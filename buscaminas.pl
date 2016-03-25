consult(generar).

leer_filas(N):- repeat,
                write('Numero de filas (entre 9 y 24): '),
                read(N),
                integer(N),
                N >= 9,
                N =< 24,
                !.

leer_columnas(M):- repeat,
                    write('Numero de columnas (entre 9 y 30): '),
                    read(M),
                    integer(M),
                    M >= 9,
                    M =< 30,
                    !.

leer_bombas(N1, R):- repeat,
                      write('Numero de bombas (entre 10 y '), write(N1), write('): '),
                      read(R),
                      integer(R),
                      R >= 10,
                      R =< N1.

jugar:- write('Elija el tamaño del tablero y el número de bombas. No se olvide de escribir cada número seguido de un punto'), nl,
        leer_filas(N), nl,
        leer_columnas(M), nl,
        N1 is (N-1)*(M-1),
        leer_bombas(N1, R), nl,
      %  generar_tablero_jugador,Inicial(N,M,Tablero_jugador),
        generar_tablero_oculto(N, M, Bombas, Tablero_oculto).
