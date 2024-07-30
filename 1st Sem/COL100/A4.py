def check1(q,l):     #it checks in how many ways q can be expressed as a sum of two distinct numbers in the list l
    b= 0             #count variable
    for p in range(0,len(l)):
         #p interates from 0 to len(l)-1 (for the 1st number)
        for r in range(p+1,len(l)):
             # r always remains between p+1 to len(l) - 1 (for the second number so that it is never equal to p)
            if l[p]+l[r]==q:            # checks if l[p] + l[r] = q
                b+=1                    # if true than counter increases by one
        if b>1:                         # if b>1 we dont need to check any more
            break
    return b                            # return b

def findnext(l):             # it finds the next number in the sequence we need
    a=l[-1] +1               # the next integer to the last element of the list
    while True :             # runs loop till we find the next number
        b=check1(a,l)        #checks if a can be expressed as sum of 2 elemtns of the list (if true then how many times)
        if b==1 :            # if there is only one was to write it as sum of 2 distinct elements
            return a         #if true then 'a' is the next element
        else:
            a+=1             # else checks after incrementing a by 1

def sumSequence(n):          # to find the list of sequence till n terms
    l=[1,2]                  # list upto 2 terms
    if n==1 :
        return([1])          # 1st term of the list if n=1
    elif n==2 :
        return(l)            # initial list upto 2 terms if n=2
    else :
        for i in range(3,n+1):      # find the list till n terms if n>2
            l.append(findnext(l))   # add another element to the list
        return l                    # return the list till n terms



def minLength(l,n):                 # to find the shortest sublist of l who's sum > n

    a=[]                            # initialising the sublist we check in each iteration
    lmin = len(l)+1                 
    # the variable to check the minimum length of sublist (we keep it as len(l) +1 since any sublist will be shorter than this)

    # if we are checking the sublist of l which is l[i:j] i will be the starting index and j will be the end index
    for i in range(0,len(l)):       #the leftmost index of sublist is i

        sum=0                       # initialising the sum of the sublist we are about to check
        for j in range(i,len(l)):   # rightmost index of the sublist is j (it is always >= i )
            sum+=l[j]               # it always has the sum from index i to index j of the list l
            if sum > n :            # to check if the sum from ith to jth element is > n
                a=l[i:(j+1)]        # stores the sublist in a
                if len(a)<lmin:     # if it's length is smaller than lmin then it changes lmin to lenght of a
                    lmin=len(a)     
    if (lmin)==len(l)+1 :           # if so sublist has sum > n then lmin has the initial value
        return (-1)                 # so we return -1
    else :                          # if a sublist exists satisfies the given condition
        return (lmin)               # we return its length



#	Merges	two	subarrays	of	arr[]	write	the	output	to	b[l:r]
#	First	subarray	is	arr[l:m]	#	Second	subarray	is	arr[m:r]	
def	mergeAB(arr,b,	l,	m,	r):	
			i	=	l			#	Initial	index	of	first	subarray	
			j	=	m			#	Initial	index	of	second	subarray	
			k	=	l			#	Initial	index	of	merged	subarray	
			while	i	<	m	and	j	<	r	:	
						if	arr[i][0]	<=	arr[j][0]:	# checking the first element of tuple instead of the whole object( only change to the original merge sort program)
									b[k]	=	arr[i]	
									i	+=	1
						else:	
									b[k]	=	arr[j]	
									j	+=	1
						k	+=	1
			#	Copy	the	remaining	elements	of	arr[i:m],	if	there	are	any
			while	i	<	m:	
							b[k]	=	arr[i]	
							i	+=	1
							k	+=	1
			#	Copy	the	remaining	elements	of	arr[j:r],	if	there	are	any	
			while	j	<	r:	
							b[k]	=	arr[j]	
							j	+=	1
							k	+=	1


def mergeIt(A,B,n,l):
# A of size n consists of n/l sorted lists of size l each [last list may be shorter]
# merge them in pairs writing the result to B [there may be one unpaired if not even]
    if n%l == 0:
        count=n//l
    else:
        count=n//l + 1
    for i in range( count//2 ):
        left=i*l*2
        right=min(left+2*l,n)
        mergeAB(A,B,left,left+l,right)
 # Copy the last list if there is any (may happen if count is odd)
    for i in range(right,n):
        B[i]=A[i]

def mergeSort(A):           # using mergesort function given in the lectures
    n=len(A)
    l=1
    B=[("","") for x in range(n)]
    dir=0
    while l < n:
        if dir == 0:
            mergeIt(A,B,n,l)
            dir=1
        else:
            mergeIt(B,A,n,l)
            dir=0
        l*=2
 #if result is in B copy result to A
    if dir==1:
        for i in range(n):
            A[i]=B[i] 
    return(A)


def mergeContacts(A):           # to sort the list and combine common entries
    A=mergeSort(A)              # first we sort it in the order
    b=[(A[0][0],[A[0][1]])]     # list with the first element of A
    for i in range (1,len(A)):  # iterating from 1 to len(a)-1
        if A[i][0]!=A[i-1][0]:  # if the first element if the ith tuple matches with the i-1th tuple's 1st element
            b.append((A[i][0],[A[i][1]]))   # appending the 2nd element of the tuple (i.e. the list) if the first element is same
        else :
            (b[-1][1]).append(A[i][1])      # else creating a new tupple
    return(b)                   # return the final list


def findParen(s):               #to find the first parenthesis which does not contain a parenthesis inside it
    indexin=None
    indexout=None
    for i in range(len(s)):     #iterates from 0 to len(s)
        if s[i]=='(':           # checks if ith element is open parenthesis
            indexin = i         # stores its index
        elif s[i]==')':         # checks if its a closed parenthesis
            indexout = i        # stores its index
            return (indexin,indexout)       # returns the index of openening and closing of the parenthesis
    return -1                   # if no parenthesis is found returns -1

def readNumber(s,i):            #finds the real number starting from the ith position of the string
    num=0                       
    b=True                      # condition for the loop
    a=0                         # to shift to the decimal part and not iterate the main loop again
    while (b and a==0 and i<len(s)):        #to check each element and translate it to the real number
        if s[i]=='1':
            num = num*10 + 1
        elif s[i]=='2':
            num = num*10 + 2
        elif s[i]=='3':
            num = num*10 + 3
        elif s[i]=='4':
            num = num*10 + 4                # to check the part before the decimal and convert
        elif s[i]=='5':
            num = num*10 + 5
        elif s[i]=='6':
            num = num*10 + 6
        elif s[i]=='7':
            num = num*10 + 7
        elif s[i]=='8':
            num = num*10 + 8
        elif s[i]=='9':
            num = num*10 + 9
        elif s[i]=='0':
            num = num*10 + 0
        elif s[i]=='.':                     # if a decimal point is encountered, we change the format of the loop
            a=1                             # to move out of the integral part
            
            x=0.1                           # to store the power of 10 representing the next digit
            while b and i<len(s):           # runs till something other than a numerical digit is encountered or the end of string
                i+=1                        # counter
                if i==len(s):
                    break    
                if s[i]=='1':
                    num += (1*x)
                    x*=0.1
                elif s[i]=='2':
                    num += (2*x)
                    x*=0.1
                elif s[i]=='3':
                    num += (3*x)
                    x*=0.1
                elif s[i]=='4':
                    num += (4*x)                #to convert the part after decimal
                    x*=0.1
                elif s[i]=='5':
                    num += (5*x)
                    x*=0.1
                elif s[i]=='6':
                    num += (6*x)
                    x*=0.1
                elif s[i]=='7':
                    num += (7*x)
                    x*=0.1
                elif s[i]=='8':
                    num += (8*x)
                    x*=0.1
                elif s[i]=='9':
                    num += (9*x)
                    x*=0.1
                elif s[i]=='0':
                    num += (0*x)
                    x*=0.1
                else:
                    b=False
                
            break
        else :
            b= False        #if anything other than a numerical or decimal part is encountered, it ends the loop
            i-=1            # because we increment again after the else part
        i+=1
    return (num,i)          # returns the real part

def readParan(s):                   # to read and evaluate the first closed brackets without an inner bracket
    indexin,indexout = findParen(s) # to find starting and ending index
    a,i=readNumber(s,indexin+1)     # first number
    b,j=readNumber(s,i+1)           # second number
    
    if s[i]=='+':                   # choose the operator
            c=a+b
    elif s[i]=='-':
            c=a-b
    elif s[i]=='*':
            c=a*b
    elif s[i]=='/':
            c=a/b
    s=(s[0:(indexin)])+str(c)+(s[j+1:]) # adding the value back to the string for further calculation
    return(s)           #returning the evaluated expression

def evaluate(s):        #main function
    if (findParen(s)==-1):      #for calcualted of expression without brackets(last calculation)
        a,i=readNumber(s,0)     #first number
        b,j=readNumber(s,i+1)   #second number
    
        if s[i]=='+':           # choosing operator
            c=a+b
        elif s[i]=='-':
            c=a-b
        elif s[i]=='*':
            c=a*b
        elif s[i]=='/':
            c=a/b
        s=c
        return(c)               #final answer
    else:
        s=readParan(s)          #for recursion till no further brackets are left   
        return(evaluate(s))