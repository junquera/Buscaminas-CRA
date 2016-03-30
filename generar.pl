% Ver si esto nos puede servir: http://blog.ivank.net/prolog-matrices.html
    /* N <- Ancho; M <- Alto; B <- Bombas */
genera_tablero_oculto(N, M, B, Tablero_oculto):-
    D is N * M, genera_tablero(D, Tablero),
    set_bombs(Tablero, D, B, Tablero_bombas),
    set_bomb_advert(Tablero_bombas, N, D, Tablero_oculto).

set_bomb_advert(T, N, D, T1):-
    set_bomb_advert_aux(T, T, 0, N, D, T1).
set_bomb_advert_aux([],_,_,_,_,[]).
set_bomb_advert_aux(['#'|T], TO, X, N, D, ['#'|T1]):-
    set_bomb_advert_aux(T, TO, X + 1, N, D, T1).
set_bomb_advert_aux([H|T], TO, X, N, D, [V|T1]):-
    vecinos_bomba(TO, X, N, D, V),
    set_bomb_advert_aux(T, TO, X + 1, N, D, T1).
vecinos_bomba(T, X, N, D, V):-
    get_vecinos(T, X, N, D, R),
    cuenta_bombas(R, V).

imprime_tablero(T,N):- imprime_tablero_aux(T, N, 0, 0).
imprime_tablero_aux([],N,_,_):- nl, imprime_barra_horiz(N).
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

quita_cabeza([_|Z], Z).

genera_tablero(D, Tablero):-
    genera_tablero_aux(D, [], Tablero).

genera_tablero_aux(0,Z,Z).
genera_tablero_aux(N, Z, Tablero):-
    N1 is N-1,
    genera_tablero_aux(N1, [0 | Z], Tablero).

set_bombs(T, D, B, TB):-
    set_bombs_aux(T, D, B, 0, TB).
set_bombs_aux(T, _, B, B, T).
set_bombs_aux(T, D, B, B0, TB):-
    random(0, D, X),
    set_bomb(T, X, T1),
    cuenta_bombas(T1, B1),
    set_bombs_aux(T1, D, B, B1, TB).

cuenta_bombas([], 0).
cuenta_bombas([0|T], B):-
    cuenta_bombas(T, B).
cuenta_bombas(['#'|T], B):-
    cuenta_bombas(T, B1),
    succ(B1, B).

set_bomb(T, P, T1):- set_posicion(T, P, '#', T1).
set_posicion([_|T], 0, E, [E|T]).
% P <- Posición
set_posicion([H|T], P, E, [H|Result1]):-
    P1 is P - 1,
    set_posicion(T, P1, E, Result1).

get_posicion([H|T], 0, H).
get_posicion([_|T], X, V):-
    X1 is X - 1,
    get_posicion(T, X1, V).

% T <- Tablero; X <- Posicion; N <- Ancho; V <- Resultado
get_norte(T, X, N, V):-
    X1 is X - N,
    X1 > 0,
    get_posicion(T, X1, V).
get_norte(T, X, N, V):- !, V is 0.

get_noreste(T, X, N, V):-
    X0 is X - N,
    X0 > 0,
    X1 is X0 + 1,
    (X1 mod N) > (X0 mod N),
    get_posicion(T, X1, V).
get_noreste(T, X, N, V):- !, V is 0.

get_este(T, X, N, V):-
    X1 is X + 1,
    (X1 mod N) > (X mod N),
    get_posicion(T, X1, V).
get_este(T, X, N, V):- !, V is 0.

get_sur(T, X, N, D, V):-
    X1 is X + N,
    X1 < D,
    get_posicion(T, X1, V).
get_sur(T, X, N, D, V):- !, V is 0.

get_sureste(T, X, N, D, V):-
    X0 is X + N,
    X0 < D,
    X1 is X0 + 1,
    (X1 mod N) > (X0 mod N),
    get_posicion(T, X1, V).
get_sureste(T, X, N, D, V):- !, V is 0.

get_suroeste(T, X, N, D, V):-
    X0 is X + N,
    X0 < D,
    X1 is X0 - 1,
    (X1 mod N) < (X0 mod N),
    get_posicion(T, X1, V).
get_suroeste(T, X, N, D, V):- !, V is 0.

get_oeste(T, X, N, V):-
    X1 is X - 1,
    (X1 mod N) < (X mod N),
    get_posicion(T, X1, V).
get_oeste(T, X, N, V):- !, V is 0.

get_noroeste(T, X, N, V):-
    X0 is X - N,
    X0 > 0,
    X1 is X0 - 1,
    (X1 mod N) < (X0 mod N),
    get_posicion(T, X1, V).
get_noroeste(T, X, N, V):- !, V is 0.

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
