:-[metodos_auxiliares].
%--------------------------------------------------------------------------------------------------------------------------------
%Procede a crear y generar el tablero
generar_tablero_jugador(N, M, Tablero):-
    D is N * M, genera_tablero(D, Tablero).

%--------------------------------------------------------------------------------------------------------------------------------

%Modifica la casilla y llama a cambiar alrededor si no se ha revelado
cambiarAlrededor(Tablero, Indice, ListaAux, X, Y, Limite):-
     Indice is X*Y,
     Indice =< Limite,
     get_posicion(Tablero, Indice, Elemento),%Comprueba si es una X, si no, que pare
     Elemento == 'X',
     get_posicion(Tablero_oculto, Indice, Elemento),
     integer(Elemento),
     Elemento == 0,
     cambiar(Tablero, X, Y, ' ', ListaAux),
     modificar_posicion_recursiva(Tablero, Indice, ListaAux, X, Y, Limite).

%Modifica la casilla y para ya que no esta vacia si no se ha revelado
% TODO set_norte, sur, este, oeste...
cambiarAlrededor(Tablero, Indice, ListaAux, X, Y, Limite):-
     Indice is X*Y,
     Indice =< Limite,
     get_posicion(Tablero,Indice, Elemento),%Comprueba si es una X, si no, que pare
     Elemento == 'X',
     get_posicion(Tablero_oculto, Indice, Elemento1),
     integer(Elemento1),
     Elemento1 > 0,
     cambiar(Tablero, X, Y, Elemento, ListaAux).

%Llama a modificar alrededor para cambiar los valores alrededor si es posible
modificar_posicion_recursiva(Tablero, Indice, ListaAux7, X, Y, Limite):-
     cambiarAlrededor(Tablero, Indice, ListaAux, X, Y + 1, Limite),
     cambiarAlrededor(ListaAux, Indice, ListaAux1, X + 1, Y + 1, Limite),
     cambiarAlrededor(ListaAux1, Indice, ListaAux2, X, Y - 1, Limite),
     cambiarAlrededor(ListaAux2, Indice, ListaAux3, X - 1, Y + 1, Limite),
     cambiarAlrededor(ListaAux3, Indice, ListaAux4, X +1, Y - 1, Limite),
     cambiarAlrededor(ListaAux4, Indice, ListaAux5, X - 1, Y, Limite),
     cambiarAlrededor(ListaAux5, Indice, ListaAux6, X + 1, Y, Limite),
     cambiarAlrededor(ListaAux6, Indice, ListaAux7, X - 1, Y - 1, Limite).
%--------------------------------------------------------------------------------------------------------------------------------
%En funci�n del valor en la casila, llama a un m�todo o a otro
cambiar(Tablero, X, Y, Elemento, Limite, ListaAux1):-
      Elemento == 0,
      Indice is X*Y,
      set_posicion(' ', Tablero, Indice, ListaAux),
      modificar_posicion_recursiva(ListaAux, Indice, ListaAux1, X, Y, Limite).

cambiar(Tablero, X, Y, Elemento, Limite, ListaAux):-
      integer(Elemento),
      Elemento > 0,
      Indice is X*Y,
      modificar_posicion(Tablero, Indice, Elemento, ListaAux).
%--------------------------------------------------------------------------------------------------------------------------------
%En funci�n de la casilla, decide que realizar
modificar_tablero(Tablero, X, Y, Tablero_oculto, Limite, Contador, ListaAux):-
      Indice is X*Y,
      get_posicion(Tablero_oculto, Indice, Elemento),
      integer(Elemento),
      Elemento == 0,
      Contador is Contador -1;
      cambiar(Tablero, X, Y, ' ', Limite, ListaAux).

modificar_tablero(Tablero, X, Y, Tablero_oculto, Limite, Contador, ListaAux):-
      Indice is X*Y,
      get_posicion(Tablero_oculto, Indice, Elemento),
      integer(Elemento),
      Elemento > 0,
      Contador is Contador - 1,
      cambiar(Tablero, X, Y, Elemento, ListaAux).

modificar_tablero(Tablero, X, Y, Tablero_oculto, Limite, Contador, ListaAux):-
      Indice is X*Y,
      get_posicion(Tablero_oculto, Indice, Elemento),
      Elemento = '#',
      Contador = -1,
      write('�����BOOOOOOOOOMBAAAAAAAAA!!!!! El juego ha terminado.').
%--------------------------------------------------------------------------------------------------------------------------------
%En funci�n de la casilla, el juego decide una de las tres opciones
continuar_partida(Tablero, X, Y, Tablero_oculto, N, M, Limite, Contador, ListaAux):-
  Contador > 0,
  write('Asi queda su tablero:'), nl,
  imprime_tablero(ListaAux, N),
  seleccionar(N, M, R, ListaAux, Contador).

continuar_partida(Tablero, X, Y, Tablero_oculto, N, M, Limite, 0, ListaAux):-
  write('Has ganado').

continuar_partida(_,_,_,_,_,_).
%--------------------------------------------------------------------------------------------------------------------------------
