<?php

/**
 * Description of Pieza
 * un array de 4 aristas.
 * @author jaime
 */
class Pieza {

    private $numero = null; //número de la pieza 1..6
    private $color = null; //color de la pieza en código colores HTML
    // array de 4 aristas que definen la pieza, vista de frente la arista  1
    // es la de arriba y vamos en sentido de las agujas del reloj
    private $aristas = array(); 
    private $posicionActual; // desde 1 a 8

    public function __construct($numero, $color, $aristas = array()) {
        //si no nos pasan las aristas las generamos al azar
        if (count($aristas) == 0) {
            $this->rellenaPiezaAzar();
        } else {
            $this->setAristas($aristas);
        }
        $this->numero = $numero;
        $this->color = $color;
        $this->posicionActual = 1;
    }

    public function getPosicionActual() {
        return $this->posicionActual;
    }

    public function setPosicionActual($posicionActual): void {
        $this->posicionActual = $posicionActual;
    }

    function getNumero() {
        return $this->numero;
    }

    function getColor() {
        return $this->color;
    }

    public function getAristas() {
        return $this->aristas;
    }
    
    public function getListaAristas() {
        $resul="";
        for ($a = 0; $a < 4; $a++) {
            $resul.=$a."->".implode("", (($this->getAristas())[$a])->getArista())."<br>";
        }
        return $resul;
    }

    private function setAristas($aristas): void {
        $this->aristas = $aristas;
    }

    //rellena una pieza con las 4 aristas al azar
    public function rellenaPiezaAzar() {
        for ($a = 0; $a < 4; $a++) {
            $aristas[] = new Arista();
        }
        $this->setAristas($aristas);
    }

    //devuelve una pieza, que es una imagen de la pieza en la posición $pos
    public function piezaPosicion($pos = 1) {
        //hacemos una copia para no perder el original
        $piezaCopia = new Pieza($this->numero, $this->color, $this->getAristas());
        //ponemos la posicionActual a la que nos dicen
        $piezaCopia->posicionActual = $pos;
        //inicializamos el contador de rotaciones a 1
        $rotaciones=1;
        while ($rotaciones < $pos) {
            $piezaCopia->rotarPieza();
            $rotaciones++;
            if ($rotaciones==5){
    //            $piezaCopia->rotarPieza();
                $piezaCopia->espejar();
            }
        }
        return $piezaCopia;
    }

    //rota la pieza 90º en sentido de las agujas del reloj
    public function rotarPieza() {
        $intermediario = $this->aristas[3];
        for ($a = 2; $a >= 0; $a--) {
            $this->aristas[$a+1] = $this->aristas[$a];
        }
        $this->aristas[0] = $intermediario;
    }

    //espeja la pieza según el eje vertical
    public function espejar() {
        //arista 0 y 2(espejar)
        $this->aristas[0]= $this->aristas[0]->espejar();
        $this->aristas[2]= $this->aristas[2]->espejar();
        //arista 1 y 3 espejadas e intercambiadas
        $intercambio = $this->aristas[1]->espejar();
        $this->aristas[1]= $this->aristas[3]->espejar();
        $this->aristas[3]= $intercambio;
    }
}
