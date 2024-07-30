fun climbStair(n)= if n = 1 then 1
                      else if n = 2 then 2
                      else climbStair(n-1) + climbStair(n-2);


fun modifiedDigitSum(n)= if n< 10 then n
                         else 2*modifiedDigitSum(n div 10) + n mod 10;


fun checkFinal(a,b,n) = if a>n then false
                    else if b>a then checkFinal(a+1,0,n)
                    else if (a*a + b*b = n) then true
                    else checkFinal(a,b+1,n);

fun check(a) = checkFinal(0,0,a);

fun count(a,b) = if a>b then 0 
                 else if check(a) then 1 + count(a+1,b)
                 else count(a+1,b);

fun squaredCount(n) = count(1,n);


fun c(n)=2*n*(2*n + 1)*(2*n +2);

fun series(b)= 4.0/real(c(b));

fun nilkantha(a:real,b) = if a>3.0 then 0.0
                        else if series(b) < a 
                        then series(b)
                        else series(b) - nilkantha(a,b+1);

fun nilakanthaSum(a:real)= 3.0 + nilkantha(a,1);