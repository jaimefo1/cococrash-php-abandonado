<?php

/**
 * Description of Arista
 * crea un objeto para almacenar aristas
 * 
 * @author jaime
 * 
 */
class Arista {

    //array de 5 elementos que almacena una arista
    private $arista = array();

    //si no recibe el parámetro genera una arista al azar
    public function __construct($arista = "") {
        if (empty($arista)) {
            $this->rellenaAristaAzar();
        } else {
            $this->setArista(str_split($arista));
        }
    }

    public function getArista() {
        return $this->arista;
    }

    public function setArista($arista): void {
        $this->arista = $arista;
    }

    //genera una arista al azar
    public function rellenaAristaAzar() {
        for ($i = 0; $i < 5; $i++) {
            $arista[] = rand(0, 1);
        }
        $this->setArista($arista);
    }

    //devuelve la arista espejo de una arista
    public function espejar() {
        return new Arista(implode("", array_reverse($this->getArista())));
    }

}
