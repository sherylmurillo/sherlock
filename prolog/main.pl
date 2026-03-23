:- dynamic estudiante/3.

archivo('universidadd.txt').

% GUARDAR EN ARCHIVO
guardar :-
    archivo(Archivo),
    open(Archivo, write, Stream),
    forall(estudiante(ID,E,S),
        ( write(Stream, estudiante(ID,E,S)),
          write(Stream, '.'),
          nl(Stream)
        )
    ),
    close(Stream).
% CARGAR DESDE ARCHIVO
cargar :-
    archivo(Archivo),
    exists_file(Archivo),
    open(Archivo, read, Stream),
    repeat,
    read(Stream, Term),
    ( Term == end_of_file ->
        close(Stream), !
    ;
        assertz(Term),
        fail
    ).

% CHECK IN
check_in :-
    write('ID: '), read(ID),
    write('Entrada: '), read(E),
    assertz(estudiante(ID,E,none)),
    guardar,
    write('Registrado'), nl.

% MOSTRAR
mostrar :-
    estudiante(ID,E,S),
    write(ID), write(' '), write(E), write(' '), write(S), nl,
    fail.
mostrar.

% BUSCAR
buscar :-
    write('ID: '), read(ID),
    ( estudiante(ID,E,none) ->
        write('Encontrado: '), write(ID), write(' '), write(E), nl
    ;
        write('No encontrado'), nl
    ).

% CHECK OUT
check_out :-
    write('ID: '), read(ID),
    write('Salida: '), read(S),
    retract(estudiante(ID,E,none)),
    assertz(estudiante(ID,E,S)),
    guardar,
    write('Salida registrada'), nl.

% TIEMPO
tiempo :-
    estudiante(ID,E,S),
    S \= none,
    T is S - E,
    write(ID), write(' Tiempo: '), write(T), nl,
    fail.
tiempo.

% MENÚ
menu :-
    cargar,
    repeat,
    write('1. Check In'), nl,
    write('2. Mostrar'), nl,
    write('3. Buscar'), nl,
    write('4. Check Out'), nl,
    write('5. Tiempo'), nl,
    write('6. Salir'), nl,
    read(O),
    ejecutar(O),
    O = 6.

ejecutar(1) :- check_in.
ejecutar(2) :- mostrar.
ejecutar(3) :- buscar.
ejecutar(4) :- check_out.
ejecutar(5) :- tiempo.
ejecutar(6) :- write('Adios'), nl.
ejecutar(_) :- write('Error'), nl.
