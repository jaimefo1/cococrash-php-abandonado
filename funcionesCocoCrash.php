<?php

//genera una tabla HTML con la imagen de la pieza 
function imagenPieza($pieza) {
//generamos una tabla en memoria de 5x5 para dibjar la $pieza
//rellena de 1, osea compacta
    $piezaImagenMemoria = array_fill(0, 5, array_fill(0, 5, 1));
//interseccionamos cada aristas de la $pieza con cada $lado 0,1,2 y 3
    for ($lado = 0; $lado < 4; $lado++) {
        interseccionPiezaImagenArista($piezaImagenMemoria, $pieza->getAristas()[$lado]->getArista(), $lado);
    }
//colocamos las aristas... según su posición
    $tabla = "<div><table>";
//generamos las filas y columnas
    for ($fila = 0; $fila < 5; $fila++) {
        $tabla .= "<tr>";
        for ($columna = 0; $columna < 5; $columna++) {
            //si es 0 ponemos de fondo el COLOR_NO_CUADRO
            $tabla .= "<td style='background: " .
                    (($piezaImagenMemoria[$fila][$columna] == 0) ?
                    COLOR_NO_CUADRO : COLORES[$pieza->getColor()] ) .
                    "; color: " .
                    (($pieza->getPosicionActual() > 4) ? "grey" : "black") .
                    "; width: 20px; height: 20px; text-align: center' >";
            //si es el centro ponemos el número de pieza
            if (($fila == $columna) && ($fila == 2)) {
                $tabla .= $pieza->getNumero();
            } elseif (($fila == INDICADOR_POSICION[$pieza->getPosicionActual() - 1][0]) &&
                    ($columna == INDICADOR_POSICION[$pieza->getPosicionActual() - 1][1])) {
                $tabla .= $pieza->getPosicionActual();
            } else {
                $tabla .= "&nbsp";
            }
            $tabla .= "</td>";
        }
        $tabla .= "</tr>";
    }
    $tabla .= "</table></div>";
    return $tabla;
}

//intersecciona el $lado de la $pieza con la $arista
function interseccionPiezaImagenArista(&$piezaImagen, $arista, $lado) {
//creamos la $fila y $columna con los valores de la esquina
    $fila = ESQUINAS_PIEZA[$lado][0];
    $columna = ESQUINAS_PIEZA[$lado][1];
//hacemos la intersección (multiplicamos) en la direccion $lado
    for ($n = 0;
            $n < 5;
            $n++) {
        $piezaImagen[$fila][$columna] *= $arista[$n];
        $fila += DIRECCIONES[$lado][0];
        $columna += DIRECCIONES[$lado][1];
    }
}
