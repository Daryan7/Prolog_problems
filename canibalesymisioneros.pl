% 21. (dificultad 4) Tres misioneros y tres canı́bales desean cruzar un rı́o. Solamente
% se dispone de una canoa que puede ser utilizada por 1 o 2 personas: misioneros
% o canı́bales. Si los misioneros quedan en minorı́a en cualquier orilla, los canı́bales
% se los comerán. Escribe un programa Prolog que halle la estrategia para que todos
% lleguen sanos y salvos a la otra orilla.

solucion(0,0,MO2,CO2,_,_):-nocomen(MO2,CO2).
solucion(MO1,CO1,MO2,CO2,O,L):-
    nocomen(MO1,CO1),nocomen(MO2,CO2),
    decidircanoa(MV,CV),
    mover(MV,CV,MO1,CO1,MO2,CO2,MO12,CO12,MO22,CO22,O),
    O1 is 1-O,
    L1=[MO12,CO12,MO22,CO22,O1],
    \+member(L1,L),
    solucion(MO12,CO12,MO22,CO22,O1,[L1|L]),
    write('-------------'),nl,
    write('Estado inicial'),nl,
    write(MO1),write(' '),write(CO1),write(' '),escribircanoa1(O),nl,
    write(MO2),write(' '),write(CO2),write(' '),escribircanoa2(O),nl,
    write('Mover '),write(MV), write(' misioneros y '),write(CV), write(' caníbales'),nl,
    write('Estado final'),nl,
    write(MO12),write(' '),write(CO12),write(' '),escribircanoa1(O1),nl,
    write(MO22),write(' '),write(CO22),write(' '),escribircanoa2(O1),nl,
	write('-------------'),nl.

nocomen(0,_):-!.
nocomen(M,C):-M>=C.

mover(MV,CV,
      MO1,CO1,MO2,CO2,
      MO12,CO12,MO22,CO22,0):-
    MV=<MO1,
    CV=<CO1,
    MO12 is MO1-MV,
    CO12 is CO1-CV,
    MO22 is MO2+MV,
    CO22 is CO2+CV.

mover(MV,CV,
     MO1,CO1,MO2,CO2,
     MO12,CO12,MO22,CO22,1):-
    MV=<MO2,
    CV=<CO2,
    MO12 is MO1+MV,
    CO12 is CO1+CV,
    MO22 is MO2-MV,
    CO22 is CO2-CV.

decidircanoa(MV,CV):- between(0,2,MV), between(0,2,CV), MV+CV=<2,MV+CV>0.

escribircanoa1(0):-write('<').
escribircanoa1(_).

escribircanoa2(1):-write('<').
escribircanoa2(_).
