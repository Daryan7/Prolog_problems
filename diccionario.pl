diccionario(A,N):-nmembers(A,N,[]).

escribe([]).
escribe([X|L]):-write(X),escribe(L).
    
nmembers(_,0,L):-escribe(L), write(' '),!,fail.
nmembers(A,N,L):-
    member(X,A),
    N1 is N-1,
    append(L,[X],L1),
    nmembers(A,N1,L1).
