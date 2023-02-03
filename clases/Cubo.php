<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

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
         DEF_CUBO = array (
             [5,3,2,4], [1,3,6,4], [1,5,6,2], [1,2,6,5], [1,4,6,3], [2,3,5,4] );
    //almacena la pieza que va en cada cara
    private $caras = array(6); //contendrá 6 piezas.
    
    public function __construct(){
        //inicializamos el array de $caras
        for ($n = 0; $n < 7; $n++) {
            $caras[$n]= null;
        }
    }
    
    //devuelve la Arista $nArista de la cara $nCara
    private function getArista($nCara,$nArista){
        
    }
       
    }

