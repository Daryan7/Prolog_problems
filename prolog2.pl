card(L):-card_extended(L,R), write(R),nl.

cardinality(_,[],[],1):-!.
cardinality(X,[X|L],L2,P):-!,cardinality(X,L,L2,P1), P is P1+1.
cardinality(X,[Y|L],[Y|L2],P):-cardinality(X,L,L2,P).

card_extended([],[]).
card_extended([X|L], [[X,P]|L2]):- cardinality(X,L,L3,P), card_extended(L3,L2).
