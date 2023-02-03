<?php

/**
 * Description of Modulo
 * un array de 6 piezas
 * @author jaime
 */
class Modulo {

    private $color;
    private $piezas = array();

    public function __construct($color, $piezas = array()) {
        $this->color = $color;
        //si no nos han puesto piezas, las generamos al azar
        if (count($piezas) == 0) {
            $this->rellenaModuloAzar();
        } else {
            $this->setPiezas($piezas);
        }
    }

    public function getColor() {
        return $this->color;
    }

    public function getPiezas() {
        return $this->piezas;
    }

    public function setColor($color): void {
        $this->color = $color;
    }

    public function setPiezas($piezas): void {
        $this->piezas = $piezas;
    }

    public function rellenaModuloAzar() {
        for ($p = 1; $p < 7; $p++) {
            $piezas[$p] = new Pieza($p, $this->getColor());
        }
        $this->setPiezas($piezas);
    }
}
