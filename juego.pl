:-[metodos_auxiliares].

leer_fila(Y, N):- repeat,
                write('Fila: '),
                read(Y),
                integer(Y),
                Y >= 0,
                Y < N,
                !.

leer_columna(X, M):- repeat,
                    write('Columna: '),
                    read(X),
                    integer(X),
                    X >= 0,
                    X < M,
                    !.

jugando(Tablero, Tablero_oculto, N, M):-
    nl, write('Asi queda su tablero:'), nl,
    imprime_tablero(Tablero, N),
%   imprime_tablero(Tablero_oculto, N),
    repeat,
    nl, write('Elija una posicion del tablero. Recuerde escribir un punto tras cada numero.'), nl,
    leer_columna(X, M),
    leer_fila(Y, N),
    comprueba(Tablero, Tablero_oculto, X, Y, N),
    !,
    modificar_posicion_recursiva(Tablero, Tablero_oculto, X, Y, N, M, T1),
    jugando(T1, Tablero_oculto, N, M).


comprueba(Tablero, Tablero_oculto, X, Y, N):-
    Posicion is X + Y * N,
    get_posicion(Tablero, Posicion, Valor),
    get_posicion(Tablero_oculto, Posicion, Valor_oculto),
    comprueba_valor(Valor),
    comprueba_valor_oculto(Valor_oculto).

comprueba_valor('X').
comprueba_valor(_):-
    write('Valor repetido'),
    false.

comprueba_valor_oculto('#'):-
    write('Bomba!'), nl,
    halt.
comprueba_valor_oculto(_).

set_cambio(Tablero, Tablero_oculto, X, Y, N, M, Indice, 0, T1):-
    set_posicion(Tablero, Indice, ' ', T0),
    modificar_posicion_recursiva(T0, Tablero_oculto, X, Y, N, M, T1).
set_cambio(Tablero, _, _, _, _, _, Indice, Elemento, T1):-
    set_posicion(Tablero, Indice, Elemento, T1).
cambiarAlrededor(Tablero, Tablero_oculto, X, Y, N, M, T1):-
    X >=0,
    X < N,
    Y >=0,
    Y < M,
    Indice is X + N * Y,
    Indice =< N * M,
    get_posicion(Tablero_oculto, Indice, Elemento),
    integer(Elemento),
    get_posicion(Tablero, Indice, Eaux),
    Eaux \= ' ',
    Eaux \= 0,
    set_cambio(Tablero, Tablero_oculto, X, Y, N, M, Indice, Elemento, T1).
cambiarAlrededor(T, _, _, _, _, _, T):-!.

modificar_posicion_recursiva(Tablero, Tablero_oculto, X, Y, N, M, T1):-
    cambiarAlrededor(Tablero, Tablero_oculto, X, Y, N, M, Tx),
    cambiarAlrededor(Tx, Tablero_oculto, X, Y + 1, N, M, Tx0),
    cambiarAlrededor(Tx0, Tablero_oculto, X + 1, Y + 1, N, M, Tx1),
    cambiarAlrededor(Tx1, Tablero_oculto, X, Y - 1, N, M, Tx2),
    cambiarAlrededor(Tx2, Tablero_oculto, X - 1, Y + 1, N, M, Tx3),
    cambiarAlrededor(Tx3, Tablero_oculto, X +1, Y - 1, N, M, Tx4),
    cambiarAlrededor(Tx4, Tablero_oculto, X - 1, Y, N, M, Tx5),
    cambiarAlrededor(Tx5, Tablero_oculto, X + 1, Y, N, M, Tx6),
    cambiarAlrededor(Tx6, Tablero_oculto, X - 1, Y - 1, N, M, Tx7),
    limpia_ceros(Tx7, T1).

limpia_ceros([],_).
limpia_ceros([0|T], [' '|T1]):-
    limpia_ceros(T, T1).
limpia_ceros([H|T], [H|T1]):-
    limpia_ceros(T, T1).
