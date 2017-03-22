% 21. (dificultad 4) Tres misioneros y tres canı́bales desean cruzar un rı́o. Solamente
% se dispone de una canoa que puede ser utilizada por 1 o 2 personas: misioneros
% o canı́bales. Si los misioneros quedan en minorı́a en cualquier orilla, los canı́bales
% se los comerán. Escribe un programa Prolog que halle la estrategia para que todos
% lleguen sanos y salvos a la otra orilla.

solucion(0,0,MO2,CO2):-nocomen(MO2,CO2).
solucion(MO1,CO1,MO2,CO2):-
    nocomen(MO1,CO1),nocomen(MO2,CO2),
    viajar(MV,CV),
    MV=<MO1,
    CV=<CO1,
    MO12 is MO1-MV,
    CO12 is CO1-CV,
    MO22 is MO2+MV,
    CO22 is CO2+CV,
    solucion(MO12,CO12,MO22,CO22),
    write('Mover '),write(MV),
    write(' misioneros y '),write(CV),
    write(' caníbales. Quedan en ambas costas: '),nl,
    write(MO12),write(' '),write(CO12),write(' '),nl,
    write(MO22),write(' '),write(CO22),write(' '),nl.

viajar(MV,CV):- between(1,2,MV), CV is 0.
viajar(MV,CV):- between(1,2,CV), MV is 0.

nocomen(0,_):-!.
nocomen(M,C):-M>=C.