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
% Método para jugar: R <- Numero de bombas
jugando(Tablero, Tablero_oculto, R, N, M):-
    nl, write('Asi queda su tablero:'), nl,
    imprime_tablero(Tablero, N),
    he_ganado(Tablero, R),
    repeat,
    nl, write('Elija una posicion del tablero. Recuerde escribir un punto tras cada numero.'), nl,
    leer_columna(X, M),
    leer_fila(Y, N),
    comprueba(Tablero, Tablero_oculto, X, Y, N),
    !,
    modificar_posicion_recursiva(Tablero, Tablero_oculto, X, Y, N, M, T1),
    jugando(T1, Tablero_oculto, R, N, M).

he_ganado(T, R):-
    % N <- Numero de X en el tablero
    cuenta_X(T, N),
    N > R.
he_ganado(_, _):- !,
    write('Has ganado!'),
    halt.

cuenta_X([], 0).
cuenta_X(['X'|T], B):-
    cuenta_X(T, B1),
    succ(B1, B).
cuenta_X([_|T], B):-
    cuenta_X(T, B).

% Comprobamos si la casilla ya ha sido seleccionada o es una bomba
comprueba(Tablero, Tablero_oculto, X, Y, N):-
    Posicion is X + Y * N,
    get_posicion(Tablero, Posicion, Valor),
    get_posicion(Tablero_oculto, Posicion, Valor_oculto),
    comprueba_valor(Valor),
    comprueba_valor_oculto(Valor_oculto).

% Vemos si es un valor repetido, si lo es, hacemos backtracking
comprueba_valor('X').
comprueba_valor(_):-
    write('Valor repetido'),
    false.

% Comprobamos si es una bomba, si lo es, avisamos y termina el juego
comprueba_valor_oculto('#'):-
    write('Bomba!'), nl,
    halt.
comprueba_valor_oculto(_).

/*
    Dependiendo de si el elemento es 0 u otro, muestra recursivamente a las casillas adyacentes o no.
*/
set_cambio(Tablero, Tablero_oculto, X, Y, N, M, Indice, 0, T1):-
    set_posicion(Tablero, Indice, ' ', T0),
    modificar_posicion_recursiva(T0, Tablero_oculto, X, Y, N, M, T1).
set_cambio(Tablero, _, _, _, _, _, Indice, Elemento, T1):-
    set_posicion(Tablero, Indice, Elemento, T1).

% Mostrar las posiciones que rodean la casilla en función de su contenido en el tablero oculto
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

% Metodo auxiliar para cambiarAlrededor
modificar_posicion_recursiva(Tablero, Tablero_oculto, X, Y, N, M, T1):-
    cambiarAlrededor(Tablero, Tablero_oculto, X, Y, N, M, Tx),
    cambiarAlrededor(Tx, Tablero_oculto, X, Y + 1, N, M, Tx0),
    cambiarAlrededor(Tx0, Tablero_oculto, X + 1, Y + 1, N, M, Tx1),
    cambiarAlrededor(Tx1, Tablero_oculto, X, Y - 1, N, M, Tx2),
    cambiarAlrededor(Tx2, Tablero_oculto, X - 1, Y + 1, N, M, Tx3),
    cambiarAlrededor(Tx3, Tablero_oculto, X + 1, Y - 1, N, M, Tx4),
    cambiarAlrededor(Tx4, Tablero_oculto, X - 1, Y, N, M, Tx5),
    cambiarAlrededor(Tx5, Tablero_oculto, X + 1, Y, N, M, Tx6),
    cambiarAlrededor(Tx6, Tablero_oculto, X - 1, Y - 1, N, M, T1).
