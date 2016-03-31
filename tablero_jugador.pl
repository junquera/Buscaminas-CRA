:-[metodos_auxiliares].

%Procede a crear y generar el tablero
generar_tablero_jugador(N, M, Tablero):-
    D is N * M, genera_tablero(D, Tablero).
