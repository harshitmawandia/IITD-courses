--1--
with validtags as (
    select id
    from tag
    where name in ('Frank_Sinatra', 'William_Shakespeare', 'Elizabeth_II', 'Adolf_Hitler', 'George_W._Bush')
),
validperson_hasinterest_tag As(
    select *
    from person_hasinterest_tag pt 
    where pt.tagid in (select id from validtags)
),
validpersons As(
    select distinct personid as id
    from validperson_hasinterest_tag
    group by personid
    having count(*) >= 2
),
validajnabi as(
    select distinct P1.id as person1id, P2.id as person2id
    from validpersons P1
        join validpersons P2 ON P1.id < P2.id
        join validperson_hasinterest_tag pt1 On P1.id = pt1.personid
        join validperson_hasinterest_tag pt2 On P2.id = pt2.personid
    where
        pt1.tagid = pt2.tagid and P2.id not in (
                select person2id
                from person_knows_person
                where person1id = P1.id
            )

    group by P1.id, P2.id
    having count(*) >= 2
),
totalpkps As(
    (select person1id, person2id from person_knows_person)
    Union
    (select person2id As person1id, person1id as person2id from person_knows_person)
),
validpkp1 As( 
    select distinct pkp.person1id As person1id, pkp.person2id As person2id
    from totalpkps pkp
        join validpersons vp1 On pkp.person1id = vp1.id
),
validfriends As(
    select distinct v1.person1id as f1, v2.person1id as f2, v2.person2id As f3
    from validpkp1 v1 
        join validpkp1 v2 On v1.person2id = v2.person2id and v1.person1id < v2.person1id
        join validajnabi va On v1.person1id = va.person1id and v2.person1id = va.person2id
),
validcommentliking(personid ,creatorid, mid) as(
    select distinct pkp.personid, comment.creatorpersonid, comment.id
    from comment, person_likes_comment pkp, validpersons  
    where comment.id = pkp.commentid and pkp.personid = validpersons.id and comment.length > 100
    and comment.length :varies 
),
validpostliking (personid ,creatorid, mid)As(
    select distinct pkp.personid, post.creatorpersonid, post.id
    from post, person_likes_post pkp, validpersons
	Where post.id = pkp.postid and pkp.personid = validpersons.id and post.creationdate < '2011-07-19'
    and post.creationdate :varies
),
t1 As(
    select mf.f1 As person1sid, mf.f2 As person2sid
    from validfriends mf 
    join validpostliking vpl1 On vpl1.personid = mf.f1 and vpl1.creatorid = mf.f3
    join validpostliking vpl2 On vpl2.personid = mf.f2 and vpl2.creatorid = mf.f3 
    where vpl1.mid = vpl2.mid
),
t2 As(
    select mf.f1 As person1sid, mf.f2 As person2sid
    from validfriends mf
    join validcommentliking vcl1 On vcl1.personid = mf.f1 and vcl1.creatorid = mf.f3
    join validcommentliking vcl2 On vcl2.personid = mf.f2 and vcl2.creatorid = mf.f3
    where vcl1.mid = vcl2.mid
),
tt As(
    (select * from t1) UNION ALL (select * from t2)
),
ans As(
    select person1sid, person2sid
    from tt
    group by person1sid, person2sid
    having count(*) >= 10
)
select mf.f1 As person1sid, mf.f2 As person2sid, count(*) As mutualFriendCount
from validfriends mf join ans On mf.f1 = ans.person1sid and mf.f2 = ans.person2sid
group by mf.f1, mf.f2
order by person1sid asc, mutualFriendCount desc, person2sid asc;

--2--
with s As(
    Select s1.id As cityid
    From place s1 Join place s2 On s1.partofplaceid = s2.id
    Where s1.type = 'City' and s2.type = 'Country' and s2.name = 'China'
),
t As(
    Select person.id as id, pu.universityid as universityid, person.birthday as birthday
    From person, s, person_studyat_university pu
    Where person.creationdate < '2012-07-01'
        and person.creationdate > '2010-06-01' 
        and person.locationcityid = s.cityid
        and pu.personid = person.id
        and person.creationdate :varies
        and pu.creationdate :varies
),
r As(
    Select DISTINCT pp.person1id as id1, pp.person2id as id2
    From person_knows_person pp
        Join t t1 On t1.id = pp.person1id 
        Join t t2 On t2.id = pp.person2id and t1.universityid = t2.universityid and EXTRACT(MONTH FROM t1.birthday) = EXTRACT(MONTH FROM t2.birthday)
    where t1.universityid is not null
)
Select COUNT(DISTINCT(r1.id1, r2.id1, r2.id2)) as count
From r r1
    Join r r2 On r1.id2 = r2.id1 
    Join r r3 On r3.id1 = r1.id1 and r3.id2 = r2.id2;

--3--
With tt(creationdate, tagid) As(
    Select creationdate, tagid From comment_hastag_tag cht
    where cht.creationdate :varies
    UNION ALL 
    Select creationdate, tagid From post_hastag_tag pht
    where pht.creationdate :varies
),
t1(tagid, num) As(
    Select tagid, COUNT(*)
    From tt
    Where creationdate >= '2010-02-03' and creationdate <= '2010-12-03' 
    Group By tagid
),
t2(tagid, num)As(
    Select tagid, COUNT(*)
    From tt
    Where creationdate <= '2011-05-03' and creationdate >= '2010-12-03' 
    Group By tagid
),
w AS(
    Select tag.typetagclassid as classid, COUNT(*) as count
    From t1 
        Join t2 On t1.tagid = t2.tagid and t1.num >= 5*t2.num
        Join tag On tag.id = t1.tagid
    Group By tag.typetagclassid
)
Select tagclass.name as tagclassname, count
From w Join tagclass On w.classid = tagclass.id
Order By count DESC, tagclassname ASC;

--4--
WITH t1(postid) as (
    SELECT p.id
    FROM post p JOIN comment c ON p.id = c.parentpostid
    Where p.creationdate :varies
    GROUP BY p.id
    HAVING COUNT(c.id) >= 4
),
t2(commentid) as (
    SELECT c1.id
    FROM comment c1 JOIN comment c2 ON c1.id = c2.parentcommentid
    where c1.length :varies
    GROUP BY c1.id
    HAVING COUNT(c2.id) >= 4
),
t3(tagid) as (
    SELECT p.tagid
    FROM post_hastag_tag p JOIN t1 ON p.postid = t1.postid
    UNION ALL
    SELECT c.tagid
    FROM comment_hastag_tag c JOIN t2 ON c.commentid = t2.commentid
),
t4(tagid, count) As(
    SELECT t.tagid, COUNT(*) as count
    FROM t3 t
    GROUP BY t.tagid
)
SELECT t.name as tagname, t4.count as count
FROM tag t JOIN t4 ON t.id = t4.tagid
ORDER BY t4.count DESC, t.name ASC
LIMIT 10;

--5--
\set country_name '\'India\''
\set tagclass '\'TennisPlayer\''

WITH RECURSIVE tagclasses(id) as (
    SELECT id
    FROM tagclass
    WHERE name = 'TennisPlayer'
    UNION ALL
    SELECT T.id
    FROM tagclass T 
    JOIN tagclasses ON T.subclassoftagclassid = tagclasses.id
),
tagids(id) as (
    SELECT T.id
    FROM tag T
    JOIN tagclasses ON T.typetagclassid = tagclasses.id
),
countryid(countryid) as ( --
    SELECT DISTINCT id
    FROM place
    WHERE name = 'India' and place.type = 'Country'
),
Cityids(id) as (
    SELECT id
    FROM place Join countryid On countryid.countryid = place.partofplaceid
),
t3(forumId, title, tagid, tagCount) as(
    SELECT forum.id, forum.title, pt.tagid, Count(*)
    FROM forum, person, post p, post_hastag_tag pt, cityids
    Where person.id = ModeratorpersonId
    and cityids.id = person.locationcityid
    and forum.id = p.ContainerforumId
    and pt.postid = p.id
    and forum.creationdate :varies and person.creationdate :varies
    GROUP BY forum.id, forum.title, pt.tagId
),
t6(forumId) as(
    SELECT DISTINCT forumId 
    FROM t3 Join tagids On tagids.id = t3.tagid
),
t4(forumId, title, tagCount) as(
    SELECT t3.forumId,t3.title,MAX(t3.tagCount) 
    FROM t3 
    GROUP BY forumId, title
),
t5(forumId, title, tagID, tagCount) as(
    Select t3.forumid, t3.title, t3.tagid, t3.tagCount
    From t3 Join t4 On t3.forumid = t4.forumid and t3.title = t4.title and t3.tagCount = t4.tagcount
),
t7 as(
    SELECT * From t5 WHERE t5.forumId in (SELECT * FROM t6)
)
SELECT
    t7.forumId as forumid, t7.title as forumtitle, T.name as mostpopulartagname, t7.tagCount as count
FROM
    t7 JOIN tag T ON t7.tagID = T.id
ORDER BY
    t7.tagCount DESC, t7.forumId ASC, t7.title ASC, T.name ASC;




