<?php

//GENERAMOS EL JUEGO NARANJA
$aristas[0] = new Arista("01010");
$aristas[1] = new Arista("00100");
$aristas[2] = new Arista("00100");
$aristas[3] = new Arista("00010");
$piezas[1] = new Pieza(1, 'NARANJA', $aristas);

$aristas[0] = new Arista("01100");
$aristas[1] = new Arista("00101");
$aristas[2] = new Arista("11010");
$aristas[3] = new Arista("01010");
$piezas[2] = new Pieza(2, 'NARANJA', $aristas);

$aristas[0] = new Arista("10101");
$aristas[1] = new Arista("11010");
$aristas[2] = new Arista("00100");
$aristas[3] = new Arista("01011");
$piezas[3] = new Pieza(3, 'NARANJA', $aristas);

$aristas[0] = new Arista("11011");
$aristas[1] = new Arista("10010");
$aristas[2] = new Arista("01011");
$aristas[3] = new Arista("10101");
$piezas[4] = new Pieza(4, 'NARANJA', $aristas);

$aristas[0] = new Arista("00100");
$aristas[1] = new Arista("01100");
$aristas[2] = new Arista("00100");
$aristas[3] = new Arista("00110");
$piezas[5] = new Pieza(5, 'NARANJA', $aristas);

$aristas[0] = new Arista("01010");
$aristas[1] = new Arista("01011");
$aristas[2] = new Arista("10101");
$aristas[3] = new Arista("11000");
$piezas[6] = new Pieza(6, 'NARANJA', $aristas);
//var_dump($piezas);
$moduloNaranja = new Modulo("NARANJA",$piezas);