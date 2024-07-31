(* To Handle an exception and exit code *)
exception Fail; 
exception ExpectedBoolean_GotInt;
exception DivByZero;
exception OpcodeDoesNotExist;
exception IncorrectInput_NotQuadruple;

fun insert(0,i,x::l) = i::l |       (* This function inserts an element 'i' at the 'k'th position in  list*)
    insert(0,i,[]) = i::[] |
    insert(k,i,x::l) = x::insert(k-1,i,l) |
    insert(k,i,[]) = 0::insert(k-1,i,[]);

fun get(k,[]) = raise Fail |    (* to get the k'th element of a list *)
    get(0,x::l) = x |
    get(k,x::l) = get(k-1,l);

fun printList([]) = "\n" |          (* To print a list-used while debugging *)
    printList(x::xs) = Int.toString(x)^" "^printList(xs);


fun endWithError(message : string) =
    let
        val temp = print(message)
    in 
        OS.Process.exit(OS.Process.success)
    end;

fun op1(k:int,l: int list) =    (* opcode: 1; To input an element and insert it at the k'th position in the list *)
    let
        val temp = print("Enter a number:\t")
        val str = valOf (TextIO.inputLine TextIO.stdIn)
        val i : int = valOf (Int.fromString str)
        (* val temp = print(printList(l)) *)
    in
        insert(k,i,l)
    end;

fun  op2(i:int, k:int, l:int list) =    (* opcode: 2; mem[k] = mem[i] *)
    let 
        val memI = get(i,l) handle Fail => endWithError("Element Not present") 
    in 
        insert(k,memI,l)
    end;

fun op3(i:int, k:int, l:int list) =     (* opcode: 3; mem[k] := not mem[i] *)
    let 
        val memI = get(i,l) handle Fail => endWithError("Element Not present") 
    in
        if memI=0 then insert(k,1,l) else if memI=1 then insert(k,0,l) else raise ExpectedBoolean_GotInt 
    end;
 
fun op4(i:int, j:int, k:int, l:int list) =      (* opcode: 4; mem[k] := mem[i] or mem[j] *)
    let
        val memI = get(i,l) handle Fail => endWithError("Element Not present") 
        val memJ = get(j,l) handle Fail => endWithError("Element Not present") 
        val x = if memI<>1 andalso memJ<>1 andalso memI<>0 andalso memJ<>0 then raise ExpectedBoolean_GotInt
                else if memI=1 orelse memJ=1 then 1 else 0
    in 
        insert(k,x,l)
    end;

fun op5(i:int, j:int, k:int, l:int list) =  (* opcode: 5; mem[k] := mem[i] and mem[j] *)
    let
        val memI = get(i,l) handle Fail => endWithError("Element Not present") 
        val memJ = get(j,l) handle Fail => endWithError("Element Not present") 
        val x = if memI<>1 andalso memJ<>1 andalso memI<>0 andalso memJ<>0 then raise ExpectedBoolean_GotInt
                else if memI=1 andalso memJ=1 then 1 else 0
    in 
        insert(k,x,l)
    end;

fun op6(i:int, j:int, k:int, l:int list)=   (* opcode: 6; mem[k] := mem[i] + mem[j] *)
    let
        val memI = get(i,l) handle Fail => endWithError("Element Not present") 
        val memJ = get(j,l) handle Fail => endWithError("Element Not present") 
        val x = memI+memJ
    in
        insert(k,x,l)
    end;

fun op7(i:int, j:int, k:int, l:int list)=   (* opcode: 7; mem[k] := mem[i] - mem[j] *)
    let
        val memI = get(i,l) handle Fail => endWithError("Element Not present") 
        val memJ = get(j,l) handle Fail => endWithError("Element Not present") 
        val x = memI-memJ
        (* val temp = print(Int.toString(memI)^" "^Int.toString(memJ)) *)
    in
        insert(k,x,l)
    end;

fun op8(i:int, j:int, k:int, l:int list)=   (* opcode: 8; mem[k] := mem[i] * mem[j] *)
    let
        val memI = get(i,l) handle Fail => endWithError("Element Not present") 
        val memJ = get(j,l) handle Fail => endWithError("Element Not present") 
        val x = memI*memJ
    in
        insert(k,x,l)
    end;

fun op9(i:int, j:int, k:int, l:int list)=   (* opcode: 9; mem[k] := mem[i] div mem[j] *)
    let
        val memI = get(i,l) handle Fail => endWithError("Element Not present") 
        val memJ = get(j,l) handle Fail => endWithError("Element Not present") 
        val temp = if memJ = 0 then raise DivByZero else 0 handle DivByZero => endWithError("Can't divide by 0") 
        val x = memI div memJ
    in
        insert(k,x,l)
    end;

fun op10(i:int, j:int, k:int, l:int list)=  (* opcode: 10; mem[k] := mem[i] mod mem[j] *)
    let
        val memI = get(i,l) handle Fail => endWithError("Element Not present") 
        val memJ = get(j,l) handle Fail => endWithError("Element Not present") 
        val temp = if memJ = 0 then raise DivByZero else 0 handle DivByZero => endWithError("Can't divide by 0") 
        val x = memI mod memJ
    in
        insert(k,x,l)
    end;

fun op11(i:int, j:int, k:int, l:int list)=  (* opcode: 11; mem[k] :=  (mem[i] = mem[j]) *)
    let
        val memI = get(i,l) handle Fail => endWithError("Element Not present") 
        val memJ = get(j,l) handle Fail => endWithError("Element Not present") 
        val x = if memI=memJ then 1 else 0
    in
        insert(k,x,l)
    end;

fun op12(i:int, j:int, k:int, l:int list)=  (* opcode: 12; mem[k] :=  (mem[i] > mem[j]) *)
    let
        val memI = get(i,l) handle Fail => endWithError("Element Not present") 
        val memJ = get(j,l) handle Fail => endWithError("Element Not present") 
        val x = if memI>memJ then 1 else 0
    in
        insert(k,x,l)
    end;

fun op15(i:int, l: int list) = print(Int.toString(get(i,l))^"\n") handle Fail => endWithError("Element Not present") ;   (* opcode: 15; output: print mem[i] *)

fun op16(i:int, k:int, l:int list)=     (* opcode: 16; mem[k] := v *)
    insert(k,i,l);

fun isComma(c:char) =                   (* To check if a character is a comma ','*) 
    if c = #"," then true else false;

fun makeTuple(s:string) =  (* Takes input a string of format "(a,b,c,d)" and converts it into int * int * int * int tuple of format (a,b,c,d) *) 
    let
        val temp = substring(s,1,(size s) - 2 )             (* Removes the first and last paranthesis () *)
        val listOfInts = String.tokens isComma temp         (* splits the string by the ',' character and creates a list *) 
        val temp2 = if length listOfInts <> 4 then raise IncorrectInput_NotQuadruple else 0
        val x::(y::(z::(w::l))) = map (fn x => valOf(Int.fromString(x))) listOfInts       (* Creates a quad-tuple of ints *)
    in
        (x,y,z,w)
    end;

fun fileToCodeArray(infile: string) =           (* To read a file with the filename infile and returns an array of tuples (code[]) *)
  let
    val ins = TextIO.openIn infile
    val f = String.tokens Char.isSpace o TextIO.inputAll    (* Reads our input stream and converts it into list of strings  *)
    val stringList = f(ins)
    val x = map makeTuple stringList    handle IncorrectInput_NotQuadruple => endWithError("Incorrect input, Not a tuple with 4 elements")         (* Maps our string list to the mke tuple function *)
    val array = Array.fromList(x)
  in
    array
  end;

fun end1() = print("");             (* to end the code *)


fun runCode(code: (int * int * int * int) array, n: int, i: int, l: int list) =  (* Runs the entire bdim file, gets code[], n = lenggth(code[]), i = current line of code to run, l is our memory list *)
    if i<n then             
    let
        val (x,y,z,w) = Array.sub(code,i)       (* gets the values from the opcode at ith place *)
        val k = if x=14 then                    (* if opcode 14 or 13 then stores the new value of i else old value of i *)
                w-1 
            else if x=13 then
                if get(y,l)=0 orelse get(y,l)=1 then 
                    if get(y,l)=1 then 
                        w-1
                    else 
                        i
                else 
                    raise ExpectedBoolean_GotInt
            else
                i handle Fail => endWithError("Element Not present") | ExpectedBoolean_GotInt => endWithError("Expected boolean but got Int")
        (* val hehe = print(Int.toString(k)^"\n") *)
        val lref =          (* If opcode 1-12 or 16 then updates memory accordingly else if opcode is >16 or <0 the raises exception orelse no change in memory *)
        if x=1 then
            op1(w,l)
        else if x=2 then
            op2(y,w,l)
        else if x=3 then
            op3(y,w,l)
        else if x=4 then
            op4(y,z,w,l)
        else if x=5 then
            op5(y,z,w,l)
        else if x=6 then
            op6(y,z,w,l)
        else if x=7 then
            op7(y,z,w,l)
        else if x=8 then
            op8(y,z,w,l)
        else if x=9 then
            op9(y,z,w,l)
        else if x=10 then
            op10(y,z,w,l)
        else if x=11 then
            op11(y,z,w,l)
        else if x=12 then
            op12(y,z,w,l)
        else if x=16 then
            op16(y,w,l)
        else if x > 16 orelse x<0 then raise OpcodeDoesNotExist
        else l handle ExpectedBoolean_GotInt => endWithError("Expected boolean but got Int") | OpcodeDoesNotExist => endWithError("Op code does not exist")
        (* val temp = print(printList(lref)^Int.toString(x)^"\n") *)
    in  
        if i<n andalso x <> 0 andalso x<>15 then runCode(code,n,k+1,lref) else if x=15 then op15(y,l) else end1()       (* if i<n and opcode not 0 or 15 then runs the next line of code else prints the necessary value and exits the code *)
    end else end1();

fun interpret(filename: string) =       (* takes input filename and calls the functions accordingly *)
    let 
        val code = fileToCodeArray(filename)
        val n = Array.length(code)
    in
        runCode(code,n,0,[])
    end;
