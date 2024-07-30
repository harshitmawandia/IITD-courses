#Question 1
def gridPlay(l): 
    n=len(l)                        #no. of rows
    m=len(l[0])                     #no. of columns
    S= l                            #initialising a n x m matrix to work on later
    for i in range(n):              #looping over the number of rows
        for j in range(m):          #looping over the number of columns
            if i==0 and j==0:       
                S[i][j]=l[i][j]     #at the start of the grid you have to take the initial penalty
            elif i==0:
                S[i][j]=S[i][j-1] + l[i][j]     #for the first row  you can only move from its right side to it (so the penalty of the element you reach)
            elif j==0:
                S[i][j]=S[i-1][j] + l[i][j]     #for the first column  you can only move from the above tile to it (so the penalty of the element you reach)
            else:                                                                   #for every other tile, you can reach from top from left or diagonally top left
                S[i][j]=min(S[i-1][j],S[i][j-1],S[i-1][j-1]) + l[i][j]              #so minimum of the penalty to reach these three tiles + the penalty of the tile you reach
    return S[n-1][m-1]                          #return the minimum penalty to reach the bottom right element, or the opposite corner

#Question 2
def stringProblem(a,b):             
    if a==b:
        return 0           #if a and b are same, no changes are required
    elif b=="":
        return len(a)      #if b is empty you have to delete all the elements in 'a' so it takes len(a) steps
    elif a=="":
        return len(b)      #if 'a' is empty you have to insert all the elemennts in 'b' so it takes len(b) steps
    elif a[0]==b[0]:
        return stringProblem(a[1:],b[1:])      #if the first letter of a = first letter of b, no changes is required, so recurse over the rest of both the words
    elif (a[0]== 'a' or a[0]== 'e' or a[0]== 'i' or a[0]== 'o' or a[0]== 'u') and (b[0]!= 'a' and b[0]!= 'e' and b[0]!= 'i' and b[0]!= 'o' and b[0]!= 'u'):
        return (min(1+stringProblem(a[1:],b),1+stringProblem(a,b[1:])))     #if 1st letter of a is a vowel and that of b is not, we can only delete or inert a char there, so min of those 2 opperations
    else:
        return(min(1+stringProblem(a[1:],b),1+stringProblem(a,b[1:]),1+stringProblem(a[1:],b[1:]))) # min of delete,insert or replace respectively for all other cases
    #(a[1:],b) represents deleting a char, since you delete the first element of 'a' and then check for the rest of the word with enitre of b
    #(a,b[1:]) represents inserting a character, you add a char in front but rest still have to be checked, while the fist letter of b has been accounted for, so check the rest of b
    #(a[1:],b[1:]) represents replacing a char, 1st char of a is replaced by 1st char of b, and then you check for the rest of the letters

#Question 3
def printCalendar(year): 
    ny=0        # for normal years
    ly=0        # for leap years
    for i in range(1753,year):      # i goes from 1753 to the year entered to count the number of leap years and normal years in between
        if i%400==0:                
            ly+=1                   # if i is a multiple of 400, its a leap year
        elif i%100==0:          
            ny+=1                   # if i is a multiple of 100 but not 400, its a normal year 
        elif i%4==0:
            ly+=1                   # if i is a multiple of 4 but not 000, its a leap year
        else:
            ny+=1                   # else its a normal year
    days = 365*ny + 366*ly          # number of days from 01/01/1753 to 01/01/*year*
    day1=days%7                     # since 01/01/1753 was a Monday, total days mod 7 will give the day of the week of 1st Jan of the year entered, 0 being monday to 6 being Sunday
    if year%400==0:
        leapyear=True
    elif year %100==0:
        leapyear=False
    elif year%4==0:                 # leap year check for the given year
        leapyear=True
    else:
        leapyear=False

    weekcount=6                        #formatting of a month can take maximum of 6 lines
    jan=[]
    c=0
    cdays=0
    for i in range (weekcount):        # i goes from 0 to 5 
        storage =""                    #for formatting of ith week of the month
        for j in range(7):             # loop iterates 7 time for days in a week
            if c<day1:                 # to skip the number of days(since 1st day may not be monday) day1 calculated above
                storage+="   "  
            elif cdays<(9):             #left alligning the single digit numbers
                storage+="  "+str(cdays+1)
                cdays+=1
            elif c<day1+31:
                storage+=" " +str(cdays+1)  #storing double digit numbers till number of days in the month
                cdays+=1
            else:
                storage+="   "          # if whole 6 weeks are not taken rest of the line is filled with spaces
            c+=1
        jan.append(storage)             # adding each week to Jan
    

    feb=[]
    c=0
    cdays=0
    day1=(day1+31)%7                    # to know the first day of feb
    if leapyear:
        febdays=29                      # if leap year then 29 days
    else:
        febdays=28                      # else 28 days
                    
    for i in range (weekcount):         
        storage =""
        for j in range(7):
            if c<day1:
                storage+="   "
            elif cdays<(9):
                storage+="  "+str(cdays+1)
                cdays+=1
            elif c<day1+febdays:                # same as Jan but only number of days changed
                storage+=" " +str(cdays+1)
                cdays+=1
            else:
                storage+="   "
            c+=1
        feb.append(storage)
    

    march=[]
    c=0
    cdays=0
    day1=(day1+febdays)%7

    for i in range (weekcount):
        storage =""
        for j in range(7):
            if c<day1:
                storage+="   "
            elif cdays<(9):
                storage+="  "+str(cdays+1)      # for march
                cdays+=1
            elif c<day1+31:
                storage+=" " +str(cdays+1)
                cdays+=1
            else:
                storage+="   "
            c+=1
        march.append(storage)
    

    april=[]
    c=0
    cdays=0
    day1=(day1+31)%7
    for i in range (weekcount):
        storage =""
        for j in range(7):
            if c<day1:
                storage+="   "
            elif cdays<(9):
                storage+="  "+str(cdays+1)
                cdays+=1
            elif c<day1+30:                         #for april
                storage+=" " +str(cdays+1)
                cdays+=1
            else:
                storage+="   "
            c+=1
        april.append(storage)
    

    may=[]
    c=0
    cdays=0
    day1=(day1+30)%7
    for i in range (weekcount):
        storage =""
        for j in range(7):
            if c<day1:
                storage+="   "
            elif cdays<(9):
                storage+="  "+str(cdays+1)          #for may
                cdays+=1
            elif c<day1+31:
                storage+=" " +str(cdays+1)
                cdays+=1
            else:
                storage+="   "
            c+=1
        may.append(storage)
    

    june=[]
    c=0
    cdays=0
    day1=(day1+31)%7
    for i in range (weekcount):
        storage =""
        for j in range(7):
            if c<day1:
                storage+="   "              #for june
            elif cdays<(9):
                storage+="  "+str(cdays+1)
                cdays+=1
            elif c<day1+30:
                storage+=" " +str(cdays+1)
                cdays+=1
            else:
                storage+="   "
            c+=1
        june.append(storage)
    

    july=[]
    c=0
    cdays=0
    day1=(day1+30)%7
    for i in range (weekcount):
        storage =""
        for j in range(7):
            if c<day1:
                storage+="   "
            elif cdays<(9):
                storage+="  "+str(cdays+1)
                cdays+=1                                  # for july
            elif c<day1+31:
                storage+=" " +str(cdays+1)
                cdays+=1
            else:
                storage+="   "
            c+=1
        july.append(storage)
    

    august=[]
    c=0
    cdays=0
    day1=(day1+31)%7
    for i in range (weekcount):
        storage =""
        for j in range(7):                  # for august
            if c<day1:
                storage+="   "
            elif cdays<(9):
                storage+="  "+str(cdays+1)
                cdays+=1
            elif c<day1+31:
                storage+=" " +str(cdays+1)
                cdays+=1
            else:
                storage+="   "
            c+=1
        august.append(storage)
    

    sep=[]
    c=0
    cdays=0
    day1=(day1+31)%7
    for i in range (weekcount):
        storage =""
        for j in range(7):
            if c<day1:                              # for september    
                storage+="   "
            elif cdays<(9):
                storage+="  "+str(cdays+1)
                cdays+=1
            elif c<day1+30:
                storage+=" " +str(cdays+1)
                cdays+=1
            else:
                storage+="   "
            c+=1
        sep.append(storage)
    
    
    oct=[]
    c=0
    cdays=0
    day1=(day1+30)%7
    for i in range (weekcount):
        storage =""
        for j in range(7):
            if c<day1:
                storage+="   "
            elif cdays<(9):
                storage+="  "+str(cdays+1)              # for october
                cdays+=1
            elif c<day1+31:
                storage+=" " +str(cdays+1)
                cdays+=1
            else:
                storage+="   "
            c+=1
        oct.append(storage)
    

    nov=[]
    c=0
    cdays=0
    day1=(day1+31)%7
    for i in range (weekcount):
        storage =""
        for j in range(7):
            if c<day1:
                storage+="   "                  # for november
            elif cdays<(9):
                storage+="  "+str(cdays+1)
                cdays+=1
            elif c<day1+30:
                storage+=" " +str(cdays+1)
                cdays+=1
            else:
                storage+="   "
            c+=1
        nov.append(storage)
    

    dec=[]
    c=0
    cdays=0
    day1=(day1+30)%7
    for i in range (weekcount):
        storage =""
        for j in range(7):
            if c<day1:
                storage+="   "                  # for december
            elif cdays<(9):
                storage+="  "+str(cdays+1)
                cdays+=1
            elif c<day1+31:
                storage+=" " +str(cdays+1)
                cdays+=1
            else:
                storage+="   "
            c+=1
        dec.append(storage)

    line1 = "                                    "+str(year)+"                                  "
    m1="      -JANUARY-                  -FEBRUARY-                  -MARCH-       "
    m2="       -APRIL-                     -MAY-                     -JUNE-         "
    m3="        -JULY-                    -AUGUST-                 -SEPTEMBER-      "               # formatting lines
    m4="      -OCTOBER-                  -NOVEMBER-                -DECEMBER-      "
    days="  M  T  W  T  F  S  S       M  T  W  T  F  S  S       M  T  W  T  F  S  S "
    f=open("calendar.txt","w+")                 #   Creates a file calendar.txt, if already exists then clear it and start as new
    f.write(line1+"\r\n")                       # writing year
    f.write(m1+"\r")                            # first set of months
    f.write(days+"\r")                          # days of week
    for i in range(6):                          # i goes from 0 to 5
        f.write(jan[i]+"     "+feb[i]+"     "+march[i]+"\r")        # to write i+1 th week of 3 months
    f.write("\r")
    f.write(m2+"\r")                        
    f.write(days+"\r")                          # REPEAT  for next 3 months
    for i in range(6):
        f.write(april[i]+"     "+may[i]+"     "+june[i]+"\r")
    f.write("\r")
    f.write(m3+"\r")
    f.write(days+"\r")
    for i in range(6):                          # repeat for next 3  months
        f.write(july[i]+"     "+august[i]+"     "+sep[i]+"\r")
    f.write("\r")
    f.write(m4+"\r")
    f.write(days+"\r")                      
    for i in range(6):                          # repeat for next 3 months
        f.write(oct[i]+"     "+nov[i]+"     "+dec[i]+"\r")
    f.close()                                   # close file