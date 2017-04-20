 programa(P):-
    append([begin],L2,P),
    append(INS,[end],L2),
    instrucciones(INS),!.

instrucciones(P):- instruccion(P).
instrucciones(P):-
    append(L1,[';'|L2],P),
    instruccion(L1),
    instrucciones(L2).

instruccion(P):-
    append(L1,[=|L2],P),
    append(L3,[+|L4],L2),
    variable(L1),
    variable(L3),
    variable(L4).
instruccion(P):-
    append([if],L1,P),
    append(L2,[=|L3],L1),
    append(L4,[then|L5],L3),
    append(L6,[else|L7],L5),
    append(L8,[endif],L7),
    variable(L2),
    variable(L4),
    instrucciones(L6),
    instrucciones(L8).

variable([x]).
variable([y]).
variable([z]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

flatten([],[]):-!.
flatten([X|L1], L):-flatten(X, LX), flatten(L1,L2), append(LX,L2,L),!.
flatten(X,[X]).

flattenNoRepetitions([],[]):-!.
flattenNoRepetitions([X|L1], L):-
    flattenNoRepetitions(X, LX), 
    flattenNoRepetitions(L1,L2), 
    union(LX,L2,L),!.
flattenNoRepetitions(X, [X]).


flattenNoRepetitionsAlt(E,L):-flatten(E,R), deleteRepetitions(R,L).

flattenNoRepetitionsAlt2([],[]):-!.
flattenNoRepetitionsAlt2([X|L1], L):-
    flattenNoRepetitionsAlt2(X, LX), 
    flattenNoRepetitionsAlt2(L1,L2), 
    insertAndReplace(LX,L2,L),!.
flattenNoRepetitionsAlt2(X, [X]).

insertAndReplace([],L,L).
insertAndReplace([X|L],R,[X|L1]):-insertAndReplace(L,R,L2), delete(L2,X,L1).

deleteRepetitions([],[]).
deleteRepetitions([X|L], [X|L1]):- deleteRepetitions(L,L2), delete(L2,X,L1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vecino(X,Y):-Y is X+1.
vecino(X,Y):-Y is X-1.

casas:-	
    Sol = [ [1,_,_,_,_,_],
            [2,_,_,_,_,_],
            [3,_,_,_,_,_],
            [4,_,_,_,_,_],
            [5,_,_,_,_,_] ],
    
    member([_,rojo,_,_,_,peru] ,Sol),
    member([_,_,_,perro,_,francia], Sol),
    member([_,_,pintor,_,_,japon], Sol),
    member([_,_,_,_,ron,china], Sol),
    member([1,_,_,_,_,hungaria], Sol),
    member([_,verde,_,_,coñac,_], Sol),
    member([X1,verde,_,_,_,_], Sol),
    Y1 is X1+1,
    member([Y1,blanco,_,_,_,_], Sol),
    member([_,_,escultor,caracol,_,_], Sol),
    member([_,amarillo,actor,_,_,_], Sol),
    member([3,_,_,_,cava,_], Sol),
    member([X2,_,actor,_,_,_], Sol),
    vecino(X2,Y2),
    member([Y2,_,_,caballo,_,_], Sol),
    member([X3,_,_,_,_,hungaria], Sol),
    vecino(X3,Y3),
    member([Y3,azul,_,_,_,_], Sol),
    member([_,_,notario,_,whisky,_], Sol),
    member([X4,_,medico,_,_,_], Sol),
    vecino(X4,Y4),
    member([Y4,_,_,ardilla,_,_], Sol),
    write(Sol), nl,!.
    


