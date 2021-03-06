:-include(entrada).
:-dynamic(varNumber/3).
symbolicOutput(0). % set to 1 to see symbolic output only; 0 otherwise.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% We are given a large rectangular piece of cloth from which we want
%% to cut a set of smaller rectangular pieces. The goal of this problem
%% is to decide how to cut those small pieces from the large cloth, i.e.
%% how to place them. 
%%
%% Note 1: The smaller pieces cannot be rotated.
%% 
%% Note 2: All dimensions are integer numbers and are given in
%% meters. Additionally, the larger piece of cloth is divided into
%% square cells of dimension 1m x 1m, and every small piece must
%% obtained exactly by choosing some of these cells
%% 
%% Extend this file to do this using a SAT solver, following the
%% example of sudoku.pl:
%% - implement writeClauses so that it computes the solution, and
%% - implement displaySol so that it outputs the solution in the
%%   format shown in entradapacking5.pl.

%%%%%% Some helpful definitions to make the code cleaner:
rect(B):-rect(B,_,_).
xCoord(X) :- width(W),  between(1,W,X).
yCoord(Y) :- height(H), between(1,H,Y).
width(B,W):- rect(B,W,_).
height(B,H):- rect(B,_,H).
insideTable(X,Y):- width(W), height(H), between(1,W,X), between(1,H,Y).

possiblePlacements(SX,SY,I,J):-
    height(H), width(W),
    LW is W-SX+1, LH is H-SY+1,
    between(1,LW,I), between(1,LH,J).
    
ocupa(SX,SY,X,Y,I,J):-
    LX is X+SX-1, LY is Y+SY-1,
    between(X,LX,I), between(Y,LY,J).
    
min(X,Y,X):-X < Y,!.
min(_,Y,Y).

%%%%%%  Variables: They might be useful
% starts-B-X-Y:   box B has its left-bottom cell with upper-right coordinates (X,Y)
%  fill-B-X-Y:   box B fills cell with upper-right coordinates (X,Y)

writeClauses:-
    placeAll,
    noRepetitions,
    fillAll,
    true.
    
placeAll:-
    rect(B,SX,SY),
    findall(starts-B-X-Y, possiblePlacements(SX,SY,X,Y), NoRotate),
    findall(starts-B-X-Y, possiblePlacements(SY,SX,X,Y), Rotate),  
    writeClause([\+rotate-B|Rotate]), writeClause([rotate-B|NoRotate]),
    fail.
placeAll.

noRepetitions:- xCoord(X), yCoord(Y), findall(fill-B-X-Y, rect(B), Lits), atMost(1, Lits), fail.
noRepetitions.

fillAll:-
    rect(B,SX,SY),
    possiblePlacements(SX,SY,X,Y),
    ocupa(SX,SY,X,Y,I,J),
    writeClause([rotate-B,\+starts-B-X-Y,fill-B-I-J]),fail.
fillAll:-
    rect(B,SX,SY),
    possiblePlacements(SY,SX,X,Y),
    ocupa(SY,SX,X,Y,I,J),
    writeClause([\+rotate-B,\+starts-B-X-Y,fill-B-I-J]),fail.
fillAll.

%fillAll:-
%    rect(B,SX,SY),
%    write(SX),write(' '), write(SY),nl,
%    min(SX,SY,M),
%   possiblePlacements(SX,SY,X,Y),
%   possiblePlacements(SY,SX,X,Y),
%   ocupa(M,M,X,Y,I,J),
%    writeClause([\+starts-B-X-Y,fill-B-I-J]),fail.
%fillAll:-
%    rect(B),
%    writeRest(B),fail.
%fillAll.
    
%writeRest(B):-
%    rect(B,SX,SY),
%    min(SX,SY,SX),
%    possiblePlacements(SX,SY,X,Y),
%    Y1 is Y+SX,
%    SY1 is SX-SY,
%    ocupa(SX,SY1,X,Y1,I,J),
%    writeClause([rotate-B,\+starts-B-X-Y,fill-B-I-J]),fail.
%writeRest(B):-
%    rect(B,W,H),
%    min(SY,SX,SY),
%    SX is H,
%    SY is W,
%    possiblePlacements(SX,SY,X,Y),
%    X1 is X+SY,
%    SX1 is SY-SX,
%    ocupa(SX1,SY,X1,Y,I,J),
%    writeClause([\+rotate-B,\+starts-B-X-Y,fill-B-I-J]),fail.

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% show the solution. Here M contains the literals that are true in the model:

displaySol(M):-
    yCoord(Y), xCoord(X),
    displayPartialSol(X,Y,M),
    width(X), nl, fail.
displaySol(_).

displayPartialSol(X,Y,M):-
    member(fill-B-X-Y, M),
    displayNum(B),!.
displayPartialSol(_,_,_):-write('  x').

displayNum(N):- N < 10, !, write('  '), write(N).
displayNum(N):- write(' '), write(N).

%%%%%% Alternative implementation of displaySol %%%%%%
%% Esta implementacion se asegura que cada rectangulo se dibuja una vez, aunque en la solucion del SAT solver aparezca
%% mas de una vez, incluso si hay a 1 variables de tipo fill sin que su correspondiente starts lo este

displaySolAlt(M):-
    findall(R,rect(R),RECTS),
    findall(B-X-Y, member(starts-B-X-Y,M),STARTS),
    generateResultMatrix(RECTS,STARTS,MATRIX),
    displayMatrix(MATRIX).
    
displayMatrix(MATRIX):-
    yCoord(Y), xCoord(X),
    displayPartialMatrix(X,Y,MATRIX),
    width(X),nl,fail.
displayMatrix(_).

displayPartialMatrix(X,Y,MATRIX):-
    nth1(Y,MATRIX,ROW),
    nth1(X,ROW,ELEM),
    integer(ELEM),
    displayNum(ELEM),!.
displayPartialMatrix(_,_,_):-write('  x').

fillRectInMatrix([],_).
fillRectInMatrix([R-X-Y|L],MATRIX):-
    nth1(Y,MATRIX,ROW),
    nth1(X,ROW,R),
    fillRectInMatrix(L,MATRIX).
    
generateResultMatrix([],_,_).
generateResultMatrix([R|L],M,MATRIX):-
    member(R-X-Y, M),
    findall(R-I-J,ocupa(R,X,Y,I,J), COORDS),
    fillRectInMatrix(COORDS,MATRIX),
    generateResultMatrix(L,M,MATRIX).

%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Express that Var is equivalent to the disjunction of Lits:
expressOr( Var, Lits ):- member(Lit,Lits), negate(Lit,NLit), writeClause([ NLit, Var ]), fail.
expressOr( Var, Lits ):- negate(Var,NVar), writeClause([ NVar | Lits ]),!.


%%%%%% Cardinality constraints on arbitrary sets of literals Lits:

exactly(K,Lits):- atLeast(K,Lits), atMost(K,Lits),!.

atMost(K,Lits):-   % l1+...+ln <= k:  in all subsets of size k+1, at least one is false:
	negateAll(Lits,NLits),
	K1 is K+1,    subsetOfSize(K1,NLits,Clause), writeClause(Clause),fail.
atMost(_,_).

atLeast(K,Lits):-  % l1+...+ln >= k: in all subsets of size n-k+1, at least one is true:
	length(Lits,N),
	K1 is N-K+1,  subsetOfSize(K1, Lits,Clause), writeClause(Clause),fail.
atLeast(_,_).

negateAll( [], [] ).
negateAll( [Lit|Lits], [NLit|NLits] ):- negate(Lit,NLit), negateAll( Lits, NLits ),!.

negate(\+Lit,  Lit):-!.
negate(  Lit,\+Lit):-!.

subsetOfSize(0,_,[]):-!.
subsetOfSize(N,[X|L],[X|S]):- N1 is N-1, length(L,Leng), Leng>=N1, subsetOfSize(N1,L,S).
subsetOfSize(N,[_|L],   S ):-            length(L,Leng), Leng>=N,  subsetOfSize( N,L,S).


%%%%%% main:

main:-  symbolicOutput(1), !, writeClauses, halt.   % print the clauses in symbolic form and halt
main:-  initClauseGeneration,
tell(clauses), writeClauses, told,          % generate the (numeric) SAT clauses and call the solver
tell(header),  writeHeader,  told,
numVars(N), numClauses(C),
write('Generated '), write(C), write(' clauses over '), write(N), write(' variables. '),nl,
shell('cat header clauses > infile.cnf',_),
write('Calling solver....'), nl,
shell('picosat -v -o model infile.cnf', Result),  % if sat: Result=10; if unsat: Result=20.
	treatResult(Result),!.

treatResult(20):- write('Unsatisfiable'), nl, halt.
treatResult(10):- write('Solution found: '), nl, see(model), symbolicModel(M), seen, displaySol(M), nl,nl,halt.

initClauseGeneration:-  %initialize all info about variables and clauses:
	retractall(numClauses(   _)),
	retractall(numVars(      _)),
	retractall(varNumber(_,_,_)),
	assert(numClauses( 0 )),
	assert(numVars(    0 )),     !.

writeClause([]):- symbolicOutput(1),!, nl.
writeClause([]):- countClause, write(0), nl.
writeClause([Lit|C]):- w(Lit), writeClause(C),!.
w( Lit ):- symbolicOutput(1), write(Lit), write(' '),!.
w(\+Var):- var2num(Var,N), write(-), write(N), write(' '),!.
w(  Var):- var2num(Var,N),           write(N), write(' '),!.


% given the symbolic variable V, find its variable number N in the SAT solver:
var2num(V,N):- hash_term(V,Key), existsOrCreate(V,Key,N),!.
existsOrCreate(V,Key,N):- varNumber(Key,V,N),!.                            % V already existed with num N
existsOrCreate(V,Key,N):- newVarNumber(N), assert(varNumber(Key,V,N)), !.  % otherwise, introduce new N for V

writeHeader:- numVars(N),numClauses(C), write('p cnf '),write(N), write(' '),write(C),nl.

countClause:-     retract( numClauses(N0) ), N is N0+1, assert( numClauses(N) ),!.
newVarNumber(N):- retract( numVars(   N0) ), N is N0+1, assert(    numVars(N) ),!.

% Getting the symbolic model M from the output file:
symbolicModel(M):- get_code(Char), readWord(Char,W), symbolicModel(M1), addIfPositiveInt(W,M1,M),!.
symbolicModel([]).
addIfPositiveInt(W,L,[Var|L]):- W = [C|_], between(48,57,C), number_codes(N,W), N>0, varNumber(_,Var,N),!.
addIfPositiveInt(_,L,L).
readWord( 99,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!. % skip line starting w/ c
readWord(115,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!. % skip line starting w/ s
readWord(-1,_):-!, fail. %end of file
readWord(C,[]):- member(C,[10,32]), !. % newline or white space marks end of word
readWord(Char,[Char|W]):- get_code(Char1), readWord(Char1,W), !.
%========================================================================================
