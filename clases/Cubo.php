<?php

/**
 * Description of Cubo
 *
 * @author usuario
 */
class Cubo {

    //contiene la definición del cubo, cada elemento del array indica una cara
    //según el dado típico, y contiene un array con el nº de cara con la que 
    //forma arista
    const
            DEF_CUBO = array(
        [5, 3, 2, 4], [1, 3, 6, 4], [1, 5, 6, 2], [1, 2, 6, 5], [1, 4, 6, 3], [2, 3, 5, 4]);

    //almacena las piezas que se van a utilizar para hacer el cubo
    private $piezas = array();
    //contendrá el número de la pieza que va en cada cara.
    private $caras = array(6);

    public function __construct($piezas) {
        //inicializamos el array de $caras
        $caras = array_fill(0, 6, 0);
    }

    //muestra en pantalla las piezas y posiciones de las caras puestas
    private function tablaPiezasCubo() {
        
    }

    //devuelve en $arista la arista $nArista de la  cara $nCara del cubo }
    private function getArista($nCara, $nArista) {
        $arista = new Arista();
    }

    //genera una pieza hipotética de la cara $nCara del Cubo
    private function generaCaraCubo($nCara) {
        $pieza = new Pieza(0, $this->$color);
    }

    //muestra en pantalla las 6 caras del CUBO, así como las piezas colocadas
    private function ponCubo() {
        
    }

    //nos devuelve verdad si la pieza $nPieza no ha sido utilizada
    private function libre($nPieza) {
        
    }

}
