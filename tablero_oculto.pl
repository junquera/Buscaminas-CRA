:-[metodos_auxiliares].
/* N <- Ancho; M <- Alto; B <- Bombas */
generar_tablero_oculto(N, M, B, Tablero_oculto):-
    D is N * M, genera_tablero(D, Tablero),
    set_bombs(Tablero, D, B, Tablero_bombas),
    set_bomb_advert(Tablero_bombas, N, D, Tablero_oculto).

/*
    Pone los numeros que avisan de una bomba cercana sumando
    el numero de bombas vecinas con el metodo get_vecinos
*/
set_bomb_advert(T, N, D, T1):-
    set_bomb_advert_aux(T, T, 0, N, D, T1).
set_bomb_advert_aux([],_,_,_,_,[]).
set_bomb_advert_aux(['#'|T], TO, X, N, D, ['#'|T1]):-
    set_bomb_advert_aux(T, TO, X + 1, N, D, T1).
set_bomb_advert_aux([_|T], TO, X, N, D, [V|T1]):-
    vecinos_bomba(TO, X, N, D, V),
    set_bomb_advert_aux(T, TO, X + 1, N, D, T1).
vecinos_bomba(T, X, N, D, V):-
    get_vecinos(T, X, N, D, R),
    cuenta_bombas(R, V).

/*
    Coloca las bombas de forma aleatoria.
    Si hay menos bombas de las que se indica, el metodo se
    repite recursivamente. Asi, podemos verificar que no se pone
    una bomba encima de otra.
*/
set_bombs(T, D, B, TB):-
    set_bombs_aux(T, D, B, 0, TB).
set_bombs_aux(T, _, B, B, T).
set_bombs_aux(T, D, B, _, TB):-
    random(0, D, X),
    set_bomb(T, X, T1),
    cuenta_bombas(T1, B1),
    set_bombs_aux(T1, D, B, B1, TB).

cuenta_bombas([], 0).
cuenta_bombas(['#'|T], B):-
    cuenta_bombas(T, B1),
    succ(B1, B).
cuenta_bombas([_|T], B):-
    cuenta_bombas(T, B).

set_bomb(T, P, T1):- set_posicion(T, P, '#', T1).
