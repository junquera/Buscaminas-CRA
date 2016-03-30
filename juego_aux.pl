:-[metodos_auxiliares].
%Comprobar si la posici�n escogida no se encuentra repetida
comprobar_posicion(Tablero, X, Y, N, _):-
      Indice is X + N *Y,
      get_posicion(Tablero, Indice, 'X').

%Comprueba si la posicion no se ha escogido todavia
comprobar_posicion(Tablero, X, Y, N, Tablero_oculto):-
      !,
      Indice is X + N*Y,
      get_posicion(Tablero, Indice, Elemento),
      write('Ha pinchado una posici�n ya descubierta. Vuelva a intentarlo'),nl,
      seleccionar(N, M, R, Tablero, Tablero_oculto).

%Comprueba si la columna o la fila estan fuera de sus limites
leer_columna(M, X):- repeat,
                    write('Columna: '),
                    read(X),
                    integer(X),
                    X >= 0,
                    X =< M,
                    !.
leer_columna(_, _):- write('Ha pinchado una posici�n ya descubierta. Vuelva a intentarlo'),
          leer_columna(_, _).

leer_fila(N, Y):- repeat,
                write('Fila: '),
                read(Y),
                integer(Y),
                Y >= 0,
                Y =< N,
                !.
leer_fila(_, _):- write('Ha pinchado una posici�n ya descubierta. Vuelva a intentarlo'),
          leer_fila(_, _).

seleccionar(N, M, Contador, Tablero, Tablero_oculto):- write('Pinche sobre una posici�n del tablero. Recuerde escribir un punto tras cada n�mero.'), nl,
     leer_fila(N, Y), nl,
     leer_columna(M, X), nl,
     Limite is N*M,
     %trace,
     comprobar_posicion(Tablero, X, Y, N, Tablero_oculto),
     modificar_tablero(Tablero, X, Y, N, Tablero_oculto, Limite, Contador, ListaAux),
     continuar_partida(ListaAux, X, Y, Tablero_oculto, N, M, Limite, Contador - 1).

jugando(N, M, Contador, Tablero, Tablero_oculto):- seleccionar(N, M, Contador, Tablero, Tablero_oculto).

%En funci�n de la casilla, decide que realizar
modificar_tablero(Tablero, X, Y, N, Tablero_oculto, Limite, Contador, ListaAux):-
      Indice is X+ Y * N,
      get_posicion(Tablero_oculto, Indice, Elemento),
      integer(Elemento),
      Elemento == 0,
      cambiar(Tablero, X, Y, N, ' ', Limite, ListaAux).

modificar_tablero(Tablero, X, Y, N, Tablero_oculto, Limite, Contador, ListaAux):-
      !,
      Indice is X+ Y * N,
      get_posicion(Tablero_oculto, Indice, Elemento),
      integer(Elemento),
      Elemento > 0,
      cambiar(Tablero, X, Y, N, Elemento, Limite, ListaAux).

modificar_tablero(Tablero, X, Y, N, Tablero_oculto, Limite, Contador, ListaAux):-
      !,
      Indice is X+ Y * N,
      get_posicion(Tablero_oculto, Indice, Elemento),
      Elemento == '#',
      write('�����BOOOOOOOOOMBAAAAAAAAA!!!!! El juego ha terminado.').
      %En funci�n de la casilla, el juego decide una de las tres opciones

continuar_partida(Tablero, X, Y, Tablero_oculto, N, M, Limite, Contador):-
    Contador > 0,
    write('Asi queda su tablero:'), nl,
    imprime_tablero(Tablero, N),
    seleccionar(N, M, Contador, Tablero, Tablero_oculto).

continuar_partida(Tablero, X, Y, Tablero_oculto, N, M, Limite, 0):-
    write('Has ganado').

%Modifica la casilla y llama a cambiar alrededor si no se ha revelado
cambiarAlrededor(Tablero, Indice, ListaAux, X, Y, N, Limite):-
     Indice is X + N *Y,
     Indice =< Limite,
     get_posicion(Tablero, Indice, Elemento),%Comprueba si es una X, si no, que pare
     Elemento == 'X',
     get_posicion(Tablero_oculto, Indice, Elemento1),
     integer(Elemento1),
     cambiar(Tablero, X, Y, N, ' ', Limite, ListaAux),
     Elemento1 == 0,
     modificar_posicion_recursiva(Tablero, Indice, ListaAux, X, Y).
 cambiarAlrededor(T, _, T, _, _, _, _):- !.

/*
%Modifica la casilla y para ya que no esta vacia si no se ha revelado
% IDEA set_norte, sur, este, oeste...
cambiarAlrededor(Tablero, Indice, ListaAux, X, Y, Limite):-
    !,
     Indice is X*Y,
     Indice =< Limite,
     get_posicion(Tablero,Indice, Elemento),%Comprueba si es una X, si no, que pare
     Elemento == 'X',
     get_posicion(Tablero_oculto, Indice, Elemento1),
     integer(Elemento1),
     Elemento1 > 0,
     cambiar(Tablero, X, Y, Elemento1, ListaAux).*/


%Llama a modificar alrededor para cambiar los valores alrededor si es posible
modificar_posicion_recursiva(Tablero, Indice, ListaAux7, X, Y, N):-
    Limite is N * M,
     cambiarAlrededor(Tablero, Indice, ListaAux, X, Y + 1, N, Limite),
     cambiarAlrededor(ListaAux, Indice, ListaAux1, X + 1, Y + 1, N, Limite),
     cambiarAlrededor(ListaAux1, Indice, ListaAux2, X, Y - 1, N, Limite),
     cambiarAlrededor(ListaAux2, Indice, ListaAux3, X - 1, Y + 1, N, Limite),
     cambiarAlrededor(ListaAux3, Indice, ListaAux4, X +1, Y - 1, N, Limite),
     cambiarAlrededor(ListaAux4, Indice, ListaAux5, X - 1, Y, N, Limite),
     cambiarAlrededor(ListaAux5, Indice, ListaAux6, X + 1, Y, N, Limite),
     cambiarAlrededor(ListaAux6, Indice, ListaAux7, X - 1, Y - 1, N, Limite).
%--------------------------------------------------------------------------------------------------------------------------------
%En funci�n del valor en la casila, llama a un m�todo o a otro
cambiar(Tablero, X, Y, N, Elemento, Limite, ListaAux1):-
      set_posicion(Tablero, Indice, Elemento, ListaAux),
      modificar_posicion_recursiva(ListaAux, Indice, ListaAux1, X, Y, N, Limite).
