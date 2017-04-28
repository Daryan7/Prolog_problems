domino([],[]):-!.
domino(L,R):-member(D,L), delete(L,D,L1),domino(L1,R1),placeDomino(D,R1,R).

placeDomino([X,Y],[],[[X,Y]]).
placeDomino([X,Y],[],[[Y,X]]).

placeDomino([X,Y],[[Y,Z]|L],[[X,Y],[Y,Z]|L]).
placeDomino([Y,X],[[Y,Z]|L],[[X,Y],[Y,Z]|L]).
