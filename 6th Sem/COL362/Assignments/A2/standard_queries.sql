--1--
-- \set K 2
-- \set X 10
-- \set taglist '(\'Frank_Sinatra\', \'William_Shakespeare\', \'Elizabeth_II\',\'Adolf_Hitler\', \'George_W._Bush\')'
-- \set commentlength 100
-- \set lastdate '\'2011-07-19\''

WITH validtags as (
    SELECT id
    FROM tag
    WHERE name in :taglist
),
validperson_hasInterest_tag As(
    Select *
    From person_hasInterest_tag pt 
    Where pt.tagid in (Select id From validtags)
),
validpersons As(
    Select DISTINCT personid as id
    From validperson_hasInterest_tag
    Group By personid
    Having Count(*) >= :K
),
validajnabi as(
    SELECT DISTINCT P1.id as person1id, P2.id as person2id
    FROM validpersons P1
        JOIN validpersons P2 ON P1.id < P2.id
        JOIN validperson_hasInterest_tag pt1 On P1.id = pt1.personid
        JOIN validperson_hasInterest_tag pt2 On P2.id = pt2.personid
    WHERE
        pt1.tagid = pt2.tagid and P2.id NOT IN (
                SELECT person2id
                FROM person_knows_person
                WHERE person1id = P1.id
            )

    Group By P1.id, P2.id
    Having Count(*) >= :K
),
totalpkps As(
    (Select person1Id, person2Id From person_knows_person)
    Union
    (SELECT person2Id As person1Id, person1Id as person2Id From person_knows_person)
),
validpkp1 As( 
    Select DISTINCT pkp.person1id As person1Id, pkp.person2id As person2Id
    From totalpkps pkp
        Join validpersons vp1 On pkp.person1id = vp1.id
),
validfriends As(
    Select DISTINCT v1.person1id as f1, v2.person1id as f2, v2.person2id As f3
    From validpkp1 v1 
        Join validpkp1 v2 On v1.person2id = v2.person2id and v1.person1id < v2.person1id
        Join validajnabi va On v1.person1id = va.person1id and v2.person1id = va.person2id
),
validcommentliking(personid ,creatorid, mid) as(
    SELECT DISTINCT pkp.personid, comment.creatorpersonid, comment.id
    FROM comment, person_likes_Comment pkp, validpersons
    Where comment.id = pkp.commentid and comment.length > :commentlength and pkp.personid = validpersons.id
),
validpostliking (personid ,creatorid, mid)As(
    SELECT DISTINCT pkp.personid, post.creatorpersonid, post.id
    FROM post  
        JOIN person_likes_post pkp on post.id = pkp.postid and post.creationdate < :lastdate
        Join validpersons On pkp.personid = validpersons.id
),
t1 As(
    Select mf.f1 As person1sid, mf.f2 As person2sid
    From validfriends mf 
    Join validpostliking vpl1 On vpl1.personid = mf.f1 and vpl1.creatorid = mf.f3
    Join validpostliking vpl2 On vpl2.personid = mf.f2 and vpl2.creatorid = mf.f3 
    where vpl1.mid = vpl2.mid
),
t2 As(
    Select mf.f1 As person1sid, mf.f2 As person2sid
    From validfriends mf
    Join validcommentliking vcl1 On vcl1.personid = mf.f1 and vcl1.creatorid = mf.f3
    Join validcommentliking vcl2 On vcl2.personid = mf.f2 and vcl2.creatorid = mf.f3
    where vcl1.mid = vcl2.mid
),
tt As(
    (SELECT * FROM t1) UNION ALL (SELECT * FROM t2)
),
ans As(
    Select person1sid, person2sid
    From tt
    Group By person1sid, person2sid
    HAVING Count(*) >= :X
)
Select mf.f1 As person1sid, mf.f2 As person2sid, Count(*) As mutualFriendCount
From validfriends mf Join ans On mf.f1 = ans.person1sid and mf.f2 = ans.person2sid
Group By mf.f1, mf.f2
Order By person1sid ASC, mutualFriendCount DESC, person2sid ASC;

--2--
-- \set startdate '\'2010-06-01\''
-- \set enddate '\'2012-07-01\''
-- \set country_name '\'China\''

with s As(
    Select s1.id As cityid
    From Place s1 Join Place s2 On s1.partofplaceid = s2.id
    Where s1.type = 'City' and s2.type = 'Country' and s2.name = :country_name
),
t As(
    Select person.id as id, pu.universityid as universityid, person.birthday as birthday
    From person
        Join s On person.locationcityid = s.cityid
        Join person_studyAt_university pu On pu.personid = person.id
    Where person.creationdate < :enddate and person.creationdate > :startdate
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
-- \set begindate '\'2010-02-03\''
-- \set middate '\'2010-12-03\''
-- \set enddate '\'2011-05-03\''

With t1 As(
    Select tagid, COUNT(*) as num
    From (Select * From comment_hastag_tag UNION ALL (Select * From post_hastag_tag)) As p
    Where creationdate >= :begindate and creationdate <= :middate
    Group By tagid
),
t2 As(
    Select tagid, COUNT(*) as num
    From (Select * From comment_hastag_tag UNION ALL (Select * From post_hastag_tag)) As p
    Where creationdate <= :enddate and creationdate >= :middate
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
-- \set X 4
WITH t1(PostId) as (
    SELECT P.id
    FROM Post P JOIN Comment C ON P.id = C.ParentPostId
    GROUP BY P.id
    HAVING COUNT(C.id) >= :X
),
t2(CommentId) as (
    SELECT C1.id
    FROM Comment C1 JOIN Comment C2 ON C1.id = C2.ParentCommentId
    GROUP BY C1.id
    HAVING COUNT(C2.id) >= :X
),
t3(tagId) as (
    SELECT P.TagId
    FROM Post_hasTag_Tag P JOIN t1 ON P.PostId = t1.PostId
    UNION ALL
    SELECT C.TagId
    FROM Comment_hasTag_Tag C JOIN t2 ON C.CommentId = t2.CommentId
),
t4(tagid, count) As(
    SELECT T.TagId, COUNT(*) as count
    FROM t3 T
    GROUP BY T.TagId
)
SELECT T.name as tagname, t4.count as count
FROM Tag T JOIN t4 ON T.id = t4.tagId
ORDER BY t4.count DESC, T.name ASC
LIMIT 10;

--5--
-- \set country_name '\'India\''
-- \set tagclass '\'TennisPlayer\''

WITH RECURSIVE TagClasses(id) as (
    SELECT id
    FROM TagClass
    WHERE name = :tagclass
    UNION ALL
    SELECT T.id
    FROM TagClass T 
    JOIN TagClasses ON T.SubclassOfTagClassId = TagClasses.id
),
TagIds(id) as (
    SELECT T.id
    FROM Tag T
    JOIN TagClasses ON T.TypeTagClassId = TagClasses.id
),
CountryId(CountryId) as ( --
    SELECT DISTINCT id
    FROM Place
    WHERE name = :country_name and place.type = 'Country'
),
CityIds(id) as (
    SELECT id
    FROM Place Join CountryId On CountryId.CountryId = Place.PartOfPlaceId
),
personIds(id) as (
    SELECT person.id
    FROM person Join CityIds On CityIds.id = person.LocationCityId
),
t3(forumId, title, tagID, tagCount) as(
    SELECT Forum.id, Forum.title, pt.tagid, Count(*)
    FROM Forum Join personIds On personIds.id = ModeratorpersonId
    JOIN Post P ON Forum.id = P.ContainerForumId
    Join Post_hasTag_Tag pt On pt.postid = P.id
    GROUP BY Forum.id, Forum.title, pt.TagId
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
    t7 JOIN Tag T ON t7.tagID = T.id
ORDER BY
    t7.tagCount DESC, t7.forumId ASC, t7.title ASC, T.name ASC;



