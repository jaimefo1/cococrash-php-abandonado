<?php
//colores usados en el juego
const COLORES=['ROJO'=>'red', 'AZUL'=>'blue',"AMARILLO"=>'yellow',
    "MORADO"=>'violet',"VERDE"=>'green',"NARANJA"=>'orange'];
//color de no cuadro
const COLOR_NO_CUADRO = 'lightgray';//transparent;
//tamaño del cuadrado
const TAM_CUADRO=20; //pixeles
//incrementos en fila y columna para definir las 4 direcciones
//0 de izq->dcha, 1 de arriba->abajo, 2 de dcha->izq y 3 abajo->arriba
const DIRECCIONES = array([0, 1], [1, 0], [0, -1], [-1, 0]);
//las 4 esquinas de una pieza  en sentido horario
const ESQUINAS_PIEZA = array([0, 0], [0, 4], [4, 4], [4, 0]);
//indicador de posición 1, 2, 3 y 4 (las 5, 6, 7, 8 son iguales)
const INDICADOR_POSICION = array([1,2],[2,3],[3,2],[2,1],[1,2],[2,3],[3,2],[2,1]);
