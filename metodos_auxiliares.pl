imprime_tablero(T,N):- imprime_tablero_aux(T, N, 0, 0).
imprime_tablero_aux([],N,_,_):- nl, imprime_barra_horiz(N), nl.
% I <- Iteración; 0 <- Es o no final de linea?
imprime_tablero_aux([H|T],N, I, 0) :-
    nl, imprime_barra_horiz(N),
    nl, write('|'), write(H), write('|'),
    succ(I, I1),
    R is I1 mod N,
    imprime_tablero_aux(T, N, I1, R).
imprime_tablero_aux([H|T],N,I,_) :-
    write(H),  write('|'),
    succ(I, I1),
    R is I1 mod N,
    imprime_tablero_aux(T, N, I1, R).

imprime_barra_horiz(N):-
    N > 0,
    N1 is 2 * N + 1,
    imprime_barra_horiz_aux(N1).
imprime_barra_horiz_aux(0).
imprime_barra_horiz_aux(N):-
    write('-'),
    N1 is N - 1,
    imprime_barra_horiz_aux(N1).

genera_tablero(D, Tablero):-
    genera_tablero_aux(D, [], Tablero).

genera_tablero_aux(0,Z,Z).
genera_tablero_aux(N, Z, Tablero):-
    N1 is N-1,
    genera_tablero_aux(N1, ['X'|Z], Tablero).

get_posicion([H|_], 0, H):-!.
get_posicion([_|T], X, V):-
    X1 is X - 1,
    get_posicion(T, X1, V).


% T <- Tablero; X <- Posicion; N <- Ancho; V <- Resultado
get_norte(T, X, N, V):-
    X1 is X - N,
    X1 > 0,
    get_posicion(T, X1, V).
get_norte(_, _, _, V):- !, V is 0.

get_noreste(T, X, N, V):-
    X0 is X - N,
    X0 > 0,
    X1 is X0 + 1,
    (X1 mod N) > (X0 mod N),
    get_posicion(T, X1, V).
get_noreste(_, _, _, V):- !, V is 0.

get_este(T, X, N, V):-
    X1 is X + 1,
    (X1 mod N) > (X mod N),
    get_posicion(T, X1, V).
get_este(_, _, _, V):- !, V is 0.

get_sur(T, X, N, D, V):-
    X1 is X + N,
    X1 < D,
    get_posicion(T, X1, V).
get_sur(_, _, _, _, V):- !, V is 0.

get_sureste(T, X, N, D, V):-
    X0 is X + N,
    X0 < D,
    X1 is X0 + 1,
    (X1 mod N) > (X0 mod N),
    get_posicion(T, X1, V).
get_sureste(_, _, _, _, V):- !, V is 0.

get_suroeste(T, X, N, D, V):-
    X0 is X + N,
    X0 < D,
    X1 is X0 - 1,
    (X1 mod N) < (X0 mod N),
    get_posicion(T, X1, V).
get_suroeste(_, _, _, _, V):- !, V is 0.

get_oeste(T, X, N, V):-
    X1 is X - 1,
    (X1 mod N) < (X mod N),
    get_posicion(T, X1, V).
get_oeste(_, _, _, V):- !, V is 0.

get_noroeste(T, X, N, V):-
    X0 is X - N,
    X0 > 0,
    X1 is X0 - 1,
    (X1 mod N) < (X0 mod N),
    get_posicion(T, X1, V).
get_noroeste(_, _, _, V):- !, V is 0.

% T <- Tablero; X <- Posicion, N <- Ancho, V <- Vecinos
get_vecinos(T, X, A, D, [N, NE, E, SE, S, SO, O, NO]):-
    get_norte(T, X, A, N),
    get_noreste(T, X, A, NE),
    get_este(T, X, A, E),
    get_sureste(T, X, A, D, SE),
    get_sur(T, X, A, D, S),
    get_suroeste(T, X, A, D, SO),
    get_oeste(T, X, A, O),
    get_noroeste(T, X, A, NO).

set_posicion([_|T], 0, E, [E|T]).
% P <- Posición
set_posicion([H|T], P, E, [H|Result1]):-
    P1 is P - 1,
    set_posicion(T, P1, E, Result1).
