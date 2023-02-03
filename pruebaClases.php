<?php

require_once './clases/Arista.php';
require_once './clases/Pieza.php';
require_once './clases/Modulo.php';
require_once './funcionesCocoCrash.php';
require_once './datosIniciales.php';

require './moduloNaranja.php';

$tabla = "<table border='1'>";
for ($p = 1; $p < 7; $p++) {
    $tabla .= "<tr><td>PIEZA Nº $p </td>";
    for ($posicion = 1; $posicion <= 8; $posicion++) {
        $tabla .= "<td>" .
                imagenPieza($moduloNaranja->getPiezas()[$p]->piezaPosicion($posicion))
                . "</td>";
    }
    $tabla.="</tr>";
}
$tabla.="</table>";
echo $tabla;

/*
for ($p = 1; $p < 9; $p++) {
    $pieza2 = $pieza->piezaPosicion($p);
    echo imagenPieza($pieza2);
    echo "<hr>";
}
 * 
 */