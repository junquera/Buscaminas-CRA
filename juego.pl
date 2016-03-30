%Comprobar si la posici�n escogida no se encuentra repetida
comprobar_posicion(Tablero, X, Y, _):-
      Indice is X*Y,
      posicion(Tablero, Elemento, Indice),
      Elemento == 'X'.

%Comprueba si la posicion no se ha escogido todavia
comprobar_posicion(Tablero, X, Y, Tablero_oculto):-
      Indice is X*Y,
      posicion(Tablero, Elemento, Indice),
      write('Ha pinchado una posici�n ya descubierta. Vuelva a intentarlo'),nl,
      seleccionar(N, M, R, Tablero).
%Comprueba si la columna o la fila estan fuera de sus limites
leer_columna(M, X):- repeat,
                    write('Fila: '),
                    read(X),
                    integer(X),
                    X >= 9,
                    X =< M,
                    !.
leer_columna(_, _):- write('Ha pinchado una posici�n ya descubierta. Vuelva a intentarlo'),
          leer_columna(_, _).

leer_fila(N, Y):- repeat,
                write('Columna: '),
                read(Y),
                integer(Y),
                Y >= 9,
                Y =< N,
                !.
leer_fila(_, _):- write('Ha pinchado una posici�n ya descubierta. Vuelva a intentarlo'),
          leer_fila(_, _).

seleccionar(N, M, Contador, Tablero, Tablero_oculto):- write('Pinche sobre una posici�n del tablero. Recuerde escribir un punto tras cada n�mero.'), nl,
     leer_fila(N, Y), nl,
     leer_columna(M, X), nl,
     Limite is N*M,
     comprobar_posicion(Tablero, X, Y, Tablero_oculto),
     modificar_tablero(Tablero, X, Y, Tablero_oculto, Limite, Contador, ListaAux),
     continuar_partida(Tablero, X, Y, Tablero_oculto, N, M, Limite, Contador, ListaAux).

jugando(N, M, Contador, Tablero, Tablero_oculto):- seleccionar(N, M, Contador, Tablero, Tablero_oculto).
