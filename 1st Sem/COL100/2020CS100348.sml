fun inttoString(n)= if n=1 then"1" else if n= 2 then "2" else if n=3 then "3" else if n=4 then "4" else if n=5 then "5" else if n=6 then "6" else if n=7 then "7" else if n=9 then "9" else "0"

fun toString(n)=if n=0 then "0" else let fun f(n,a:string)= if n=0 then a else f(n div 10, inttoString(n mod 10)^a) in f(n,"") end;

fun convertUnitsIter(n,factor,name)= let fun f(n,i,os:string) = if n=0 then os else f(n div factor(i), i+1, toString(n mod factor(i))^name(i)^os) in f(n,0,"") end;

fun convertUnitsRec(n,factor,name)= let fun f(n,i) = if n=0 then "" else f(n div factor(i), i+1)^toString(n mod factor(i))^name(i) in f(n,0) end;



fun maximumValue(n,v,w,W)= let fun f(i,n,weight,W,value)= if i<=n then
                                                if (weight + w(i)) <= W then
                                                    let val y= f(i+1,n,weight+w(i),W,value + v(i)); val x= f(i+1,n,weight,W,value); in if y>x then y else x end
                                                else  f(i+1,n,weight,W,value)
                                             else value
in f(1,n,0,W,0) end;



fun g(n,a)= if n=0 then a else g(n div 4, a*4);

fun f(n,i,q,p) = if p=1 then if (2*i +1)*(2*i + 1)<=n then 2*i + 1 else 2*i
                 else f(n,if (2*i +1)*(2*i + 1)<=q then 2*i +1 else 2*i, n div(p div 4), p div 4);

fun intSqrt(n)= f(n,0,n div g(n div 4,1),g(n div 4,1));



fun isPrime(a,b,c)= if a=2 then true else if a mod b=0 orelse a<=1 then false else if b>c then true else isPrime(a,b+1,c);

fun g(n,a)= if n=0 then a else g(n div 4, a*4);

fun f(n,i,q,p) = if p=1 then if (2*i +1)*(2*i + 1)<=n then 2*i + 1 else 2*i
                 else f(n,if (2*i +1)*(2*i + 1)<=q then 2*i +1 else 2*i, n div(p div 4), p div 4);

fun intSqrt(n)= f(n,0,n div g(n div 4,1),g(n div 4,1));

fun f(a,n,l)=if a>n then l else if isPrime(a,2,intSqrt(a)) then f(a+1,n,a::l) else f(a+1,n,l);

fun helper(n,[],q,l) =(0,0,0) | 
helper(n,x::p, [],l) = helper(n,p,l,l) |
helper(n,x::p,y::q,l)= if (n-x-y) <0 then helper(n,x::p,q,l) else if  isPrime(n-x-y,2, intSqrt(n-x-y)) then (x,y,(n-x-y))  else helper(n,x::p,q,l);

fun  findPrimes(n)= let val l=f(2,n,[])
  in helper(n,l,l,l) end;
