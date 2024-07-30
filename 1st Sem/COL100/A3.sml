fun intToLgint(n) = if n = 0 then [0] else 
  let fun g(0) =[] | g(n) = (n mod 10)::g(n div 10)
in g(n) end;
val x=intToLgint(56131);

fun LgintToInt(l) = if length(l) > 9 then 1000000000 else let fun g([x],i,a) = i +x*a | g(x::xs,i,a) =g(xs,  i+x*a,a*10)
in g(l,0,1) end;
LgintToInt(x);

fun addLgint(x,y) = let fun g(x::xs,y::ys,i) = ((x+y+i) mod 10)::g(xs,ys,(x+y+i) div 10) |
g(x::xs,[], i) = ((x+i) mod 10)::g(xs,[],(x+i)div 10) |
g([],y::ys, i) = ((y+i) mod 10)::g([],ys,(y+i)div 10) |
g([], [], i) = if i=0 then [] else i::[] in g(x,y,0) end;
addLgint(x,x);

fun multiplyLgint(x::xs,y::ys)=
let
  fun g(x::xs,y,i)=((x*y + i) mod 10)::g(xs,y,((x*y + i )div 10)) |
  g([],y,i) = if i=0 then [] else i::[] ;
in
  if ys =[] then g(x::xs,y,0) 
  else addLgint(g(x::xs,y,0), 0::multiplyLgint(x::xs,ys))
end;

fun LgLesseq(l1,l2)= if l1=l2 then true else if length(l1)< length(l2) then true 
                     else if length(l1)> length(l2) then false
                     else
  let fun reverse([x],l) = x::l|
  reverse(x::xs,l) = reverse(xs,x::l) ;
  val x = reverse(l1,[]);
  val y = reverse(l2,[]);
  fun comp(x::xs,y::ys)= if x>y then false else if y>x then true else comp(xs,ys) |
  comp([x],[y]) = if x>y then false else true; in comp(x,y) end;



fun qPerformance(l) =
  let 
  val len = length(l);
  fun q1(a,b,c,d,e) = Real.fromInt(a);
  val q1list = map q1 l;
  fun q2(a,b,c,d,e) = Real.fromInt(b);
  val q2list = map q2 l;
  fun q3(a,b,c,d,e) = Real.fromInt(c);
  val q3list = map q3 l;
  fun q4(a,b,c,d,e) = Real.fromInt(d);
  val q4list = map q4 l;
  fun sum(x:real,y:real)=x+y;
  val q1=((foldr sum 0.0 q1list))/Real.fromInt(len);
  val q2=((foldr sum 0.0 q2list))/Real.fromInt(len);
  val q3=((foldr sum 0.0 q3list))/Real.fromInt(len);
  val q4=((foldr sum 0.0 q4list))/Real.fromInt(len);
  fun profit(a)= if a>q1 then floor((a-q1)/(0.1*q1)) else 0;
  val p1= map profit q1list;
  fun profit(a)= if a>q2 then floor((a-q2)/(0.1*q2)) else 0;
  val p2= map profit q2list;
  fun profit(a)= if a>q3 then floor((a-q3)/(0.1*q3)) else 0;
  val p3= map profit q3list;
  fun profit(a)= if a>q4 then floor((a-q4)/(0.1*q4)) else 0;
  val p4= map profit q4list;
  fun final(x::xs,y::ys,z::zs,w::ws,(a,b,c,d,e)::es)=
  floor((Real.fromInt(e)*(1.0+0.01*(Real.fromInt(x+y+z+w)))))::final(xs,ys,zs,ws,es)|
  final([],[],[],[],[])= [];
in
  final(p1,p2,p3,p4,l)
end;

fun budgetRaise(l) =
let
  val l1 = qPerformance(l);
  fun sum(x,y:real)=Real.fromInt(x)+y;
  
  fun q1(a,b,c,d,e) = (e);
  val q1list = map q1 l;
  val totalbefore= foldr sum 0.0 q1list;
  
  val budget= foldr sum 0.0 l1;
in
  (budget-totalbefore)/totalbefore
end;




fun ithElement(L,i) =
let
  fun n([],j,i) =raise Empty
    | n(ls,j,i)= if j=i then hd(ls)
        else n(tl(ls),j+1,i)
in n(L,1,i)
end;

fun Append(a,n,[])=[ ]|
  Append(a,n,ls)= [[a] @ hd (ls)] @ Append(a,n,tl (ls));

fun del L ind =
let
   fun helper (x::xs) i n =
    if i = n
    then xs
    else x::(helper xs (i+1) n) |
   helper [] i n = raise Empty
in
  helper L 1 ind
end;

fun Permutations(ls)=
if null(tl(ls)) then [ls]
 else let fun g(n,i,L)= 
if i> n then [ ]
else Append(ithElement(L,i),length(L)-1,Permutations(del L i))@g(n,i+1,L)
in g(length(ls),1,ls)
end;

fun insort([]) = [] |
 insort(x::xs:char list)= 
let 
  fun insert (x,[])=[x]|
  insert (a,x::xs) = if a<x then a::x::xs else x::insert(a,xs)
in insert(x, insort(xs))
end;

fun lexicographicPerm(l) = 
let 
  val a= insort(l)
in
  Permutations(a)
end;

fun lexicographicPermDup(l)= 
let 
  val l1=lexicographicPerm(l);
  fun g(x::(y::(xs))) = if x=y then false  else g(x::xs)|g([x])=true|g([])=raise Empty;
  fun f(x::(xs))= if g(x::xs) then x::f(xs) else f(xs) |
  f(x::[]) =x::[]|f([])= []
in
  f(l1)
end;

