concat([], L, L).
concat([X|L1], L2, [X|L3]) :-concat(L1, L2, L3).

flatten([],[]):-!.
flatten(X, [X]):-X\=[_|_].
flatten([X|L1], L):-flatten(X, LX), flatten(L1,L2), concat(LX,L2,L).


union([],L,L).
union([X|L1],L2,   L3 ):-
	member(X,L2),!,
	union(L1,L2,L3).
union([X|L1],L2,[X|L3]):-
	union(L1,L2,L3).

flattenNoRepetitions([],[]):-!.
flattenNoRepetitions(X, [X]):-X\=[_|_].
flattenNoRepetitions([X|L1], L):-
    flattenNoRepetitions(X, LX), 
    flattenNoRepetitions(L1,L2), 
    union(LX,L2,L),
    write(L),nl.