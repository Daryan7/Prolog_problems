programa(P):-
    append([begin|[]],L2,P),
    append(INS,[end|[]],L2),
    instrucciones(INS),!.

instrucciones(P):- instruccion(P).
instrucciones(P):-
    append(L1,[';'|L2],P),
    instruccion(L1),
    instrucciones(L2).

instruccion(P):-
    append(L1,['='|L2],P),
    append(L3,['+'|L4],L2),
    variable(L1),
    variable(L3),
    variable(L4).
instruccion(P):-
    append([if|[]],L1,P),
    append(L2,['='|L3],L1),
    append(L4,[then|L5],L3),
    append(L6,[else|L7],L5),
    append(L8,[endif|[]],L7),
    variable(L2),
    variable(L4),
    variable(L6),
    instrucciones(L8).

variable([x]).
variable([y]).
variable([z]).