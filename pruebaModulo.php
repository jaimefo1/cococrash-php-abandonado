<?php
require_once './clases/Arista.php';
require_once './clases/Pieza.php';
require_once './clases/Modulo.php';
require './funcionesCocoCrash.php';
$modulo = new Modulo();
echo imagenPieza($modulo->getPiezas()[2]);
