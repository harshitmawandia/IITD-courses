max(X,Y,X):- X>Y.  % To calculate max of 2 numbers
max(X,Y,Y):- Y>X-1.
heightDiff(X,Y,Z):- X>Y , Z is (X-Y).       % To calculate |X-Y|
heightDiff(X,Y,Z):- X<Y+1 , Z is (Y-X).
sublist([],M,N,_):-M+1>N.      % to get aa sublist from Mth to Nth index of a given list
sublist(S,M,N,[_|B]):- M>0, M<N, sublist(S,M-1,N-1,B).
sublist(S,M,N,[A|B]):- 0 is M, M<N, N2 is N-1, S=[A|D], sublist(D,0,N2,B).
memberCheck([H|_], H).          % To check if H is present in a ist
memberCheck([_|T], H) :- memberCheck(T, H).
memberCheck([],_):- 0>1.

minSubtree(ibt(node(N,empty,_)),N):-integer(N).
minSubtree(ibt(node(N,L,_)),Y):- integer(N), minSubtree(ibt(L),B),  Y is B.

maxSubtree(ibt(node(N,_,empty)),N):-integer(N).
maxSubtree(ibt(node(N,_,R)),Y):- integer(N), maxSubtree(ibt(R),B),  Y is B.

ibt(empty).
ibt(node(N,L,R)):- integer(N),ibt(L),ibt(R).
size(ibt(empty),0).             % size of ibt  =  root node + size(left ibt) + size (right ibt)
size(ibt(node(N,L,R)),X):-integer(N), size(ibt(L),A), size(ibt(R),B), X is (A + B + 1).
height(ibt(empty),0).           % height of ibt  =  1 + max(height(left),height(right))
height(ibt(node(N,L,R)),X):- integer(N), height(ibt(L),A), height(ibt(R),B), max(A,B,C), X is 1 + C.
preorder(ibt(empty),[]).        % preorder = [root, _preorder(left), _preorder(right)] where _preorder is flattened list of preorder
preorder(ibt(node(N,L,R)),X):- integer(N), preorder(ibt(L),A), preorder(ibt(R),B), append(A,B,C), append([N],C,D), X = D.
inorder(ibt(empty),[]).         % inorder = [_inorder(left), root, _inorder(right)] where _inorder is flattened list of inorder
inorder(ibt(node(N,L,R)),X):- integer(N), inorder(ibt(L),A), inorder(ibt(R),B), append(A,[N],C), append(C,B,D), X = D.
postorder(ibt(empty),[]).       % postorder = [_postorder(left), _postorder(right), root] where _postorder is flattened list of postorder
postorder(ibt(node(N,L,R)),X):- integer(N), postorder(ibt(L),A), postorder(ibt(R),B), append(A,B,C), append(C,[N],D), X = D.
toString(ibt(empty),"()").      % simple concatination + recursion to find the to strig of left and right subtrees
toString(ibt(node(N,L,R)),X):- integer(N), toString(ibt(L),A), toString(ibt(R),B), atom_concat(N,", ",O), atom_concat(O,A,M), atom_concat(M, ", ", C), atom_concat(C,B,D), atom_concat("(",D,E), atom_concat(E,")",F), X = F.
isBalanced(ibt(empty)).         % if right and left subtrees are balanced and |height(L) -height(R)| < 2
isBalanced(ibt(node(N,L,R))):- integer(N),height(ibt(L),A),height(ibt(R),B), heightDiff(A,B,C), C<2, isBalanced(ibt(L)), isBalanced(ibt(R)).
isBST(ibt(empty)).              % if left subtree every element is less than root and right every element is greater than root
isBST(ibt(node(N,empty,empty))):-integer(N).
isBST(ibt(node(N,node(N1,L1,R1),empty))):- integer(N), integer(N1), N1 < N, maxSubtree(ibt(node(N1,L1,R1)),A), A<N,  isBST(ibt(node(N1,L1,R1))).
isBST(ibt(node(N,empty,node(N1,L1,R1)))):- integer(N), integer(N1), N1 > N, minSubtree(ibt(node(N1,L1,R1)),A), A>N, isBST(ibt(node(N1,L1,R1))).
isBST(ibt(node(N,node(N1,L1,R1),node(N2,L2,R2)))):-integer(N), integer(N1), integer(N2), N1 < N, N < N2, maxSubtree(ibt(node(N1,L1,R1)),A), A<N, minSubtree(ibt(node(N2,L2,R2)),B), B>N, isBST(ibt(node(N1,L1,R1))), isBST(ibt(node(N2,L2,R2))).
makeBST1([],(empty)).       % sorts the list and divides into 2 equal parts with median as the node and recurses over the two parts to form left and right subtree 
makeBST1(L,X):- sort(L,A), length(A,N), Mid1 is (N-1)//2, Mid2 is (N+1)//2, sublist(L1,0,Mid1,A), sublist(L2,Mid2, N, A), makeBST1(L1,B), makeBST1(L2,C),Mid is (N-1)//2, nth0(Mid, A, N1), X= node(N1,B,C).
makeBST(L,X):-makeBST1(L,N), X = ibt(N).
lookup(N, ibt(empty)):- integer(N),false.      % checks if root is equal to the key, else if key < root then recurses over left subree else the right subtree
lookup(X, ibt(node(N,_,_))):- integer(N), X=:=N.
lookup(X, ibt(node(N,L,_))):- X < N, lookup(X, ibt(L)).
lookup(X, ibt(node(N,_,R))):- X > N, lookup(X, ibt(R)).
insert(N,ibt(empty),X):- integer(N), X = ibt(node(N,empty,empty)).      % inserts N at left subtree if N< root else right subtree
insert(N,ibt(node(N1,L,R)),X):- integer(N), N < N1 , insert(N,ibt(L),ibt(L1)), X = ibt(node(N1,L1,R)).
insert(N,ibt(node(N1,L,R)),X):- integer(N), N > N1 , insert(N,ibt(R),ibt(R1)), X = ibt(node(N1,L,R1)).
eulerTour(ibt(empty),[]).       %creates euler tour by recusring in an anti clock wise fashion such that every element is present thrice.
eulerTour(ibt(node(N,empty,empty)),X):- integer(N), X = [N,N,N].
eulerTour(ibt(node(N,L,empty)),X):- integer(N), eulerTour(ibt(L),A), append([N],A,B), append(B,[N,N],C), X = C.
eulerTour(ibt(node(N,empty,R)),X):- integer(N), eulerTour(ibt(R),A), append([N,N],A,B), append(B,[N],C), X = C.
eulerTour(ibt(node(N,L,R)),X):- integer(N), eulerTour(ibt(L),A), eulerTour(ibt(R),B), append([N],A,C), append(C,[N],D), append(D,B,E), append(E,[N],F), X = F.
orderFromET([],A,B,C,A,B,C).     % creates pre,in and post order traversals from euler tour, first time an element is found, goes in preorder,second time goes in Inorder, and third time goes in post order
orderFromET([L|LS],A,B,C,X,Y,Z):- memberCheck(A,L), memberCheck(B,L), append(C,[L],D), orderFromET(LS,A,B,D,E,F,G), X = E, Y = F, Z = G.
orderFromET([L|LS],A,B,C,X,Y,Z):- memberCheck(A,L), append(B,[L],D), orderFromET(LS,A,D,C,E,F,G), X = E, Y = F, Z = G.
orderFromET([L|LS],A,B,C,X,Y,Z):- append(A,[L],D), orderFromET(LS,D,B,C,E,F,G), X = E, Y = F, Z = G.
preET(ibt(empty),[]).       % uses orderfromET to get the traversal
preET(ibt(node(N,L,R)),X):- eulerTour(ibt(node(N,L,R)),A), orderFromET(A,[],[],[],B,_,_), X = B.
inET(ibt(empty),[]).        % uses orderfromET to get the traversal
inET(ibt(node(N,L,R)),X):- eulerTour(ibt(node(N,L,R)),A), orderFromET(A,[],[],[],_,C,_), X = C.
postET(ibt(empty),[]).      % uses orderfromET to get the traversal
postET(ibt(node(N,L,R)),X):- eulerTour(ibt(node(N,L,R)),A), orderFromET(A,[],[],[],_,_,D), X = D.

findMin(ibt(node(N,empty,R)),ibt(R),N):-integer(N).     % find min value in a subtree and deletes it
findMin(ibt(node(N,L,R)),X,Y):- findMin(ibt(L),ibt(A),B), X = ibt(node(N,A,R)), Y is B.

delete(N,ibt(empty),_):- integer(N), 0>1.               % deletes node directly if its a leaf, else finds the min of the right subtree and replaces the deleted node with the min
delete(N,ibt(node(N,empty,R)),X):- integer(N), X = ibt(R).
delete(N,ibt(node(N,L,empty)),X):- integer(N), X = ibt(L).
delete(N,ibt(node(N,L,R)),X):- integer(N), findMin(ibt(R),ibt(A),B), X = ibt(node(B,L,A)).
delete(N1,ibt(node(N,L,R)),X):- N1>N, delete(N1,ibt(R),ibt(A)), X = ibt(node(N,L,A)).
delete(N1,ibt(node(N,L,R)),X):- N1<N, delete(N1,ibt(L),ibt(A)), X = ibt(node(N,A,R)).

pop([X|List],X,List).       % stack operations on list
push(X,List,[X|List]).

trPre([],X,X).      % we maintain  a stack for node to process, and a processed nodes list. When the stack becomes empty, we return the processed nodes list
trPre([empty|Ls],X,Y):- trPre(Ls,X,Y).
trPre([node(N,L,R)|Ls],X,Y):- integer(N), push(R,Ls,A), push(L,A,B), append(X,[N],C), trPre(B,C,Y).
trPreorder(ibt(empty),[]).
trPreorder(ibt(node(N,L,R)),X):- integer(N), trPre([L,R],[N],Y), X=Y.

trIn([],empty,X,X). % we maintain a stack for nodes to process and a current node. when the current node becomes empty, we process its parent, and then add its right node to current node
trIn(Ls,empty,X,Y):- pop(Ls,node(N,_,R),A), integer(N), append(X,[N],B), trIn(A,R,B,Y).
trIn(Ls,node(N,L,R),X,Y):- integer(N), push(node(N,L,R),Ls,A), trIn(A,L,X,Y).
trInorder(ibt(empty),[]).
trInorder(ibt(node(N,L,R)),X):- integer(N), trIn([],node(N,L,R),[],Y), X=Y.

trPost([],empty,_,X,X).     % we maintain a main stack, a right child stack and a current node
trPost([node(N,_,_)|Ls],empty,[],X,Y):- integer(N), append(X,[N],A), trPost(Ls,empty,[],A,Y).       % when current node is empty and right child stack is also empty, we pop the main stack and process the popped node
trPost([node(N,L,R)|Ls],empty,[R|Rs],X,Y):- integer(N), trPost([node(N,L,R)|Ls],R,Rs,X,Y).          % when CN is empty but right child stack is not, and the top of the RC-stack is same as right child of top of main stack,  we make the top of right child node the current node and pop the right child stack
trPost([node(N,_,_)|Ls],empty,[M|Rs],X,Y):- integer(N), append(X,[N],A), trPost(Ls,empty,[M|Rs],A,Y).   % else we just pop the main stack and process its top
trPost(Ls,node(N,L,empty),Rs,X,Y):- integer(N), trPost([node(N,L,empty)|Ls],L,Rs,X,Y).      %when CN is not empty but does not have a right child, we make the left child the CN
trPost(Ls,node(N,L,R),Rs,X,Y):- integer(N), trPost([node(N,L,R)|Ls],L,[R|Rs],X,Y).          %when it has a right child, the right child is added to the right child stack too and CN --> CN.Leftchild
trPostorder(ibt(empty),[]).
trPostorder(ibt(node(N,L,R)),X):- integer(N), trPost([],node(N,L,R),[],[],Y), X = Y.