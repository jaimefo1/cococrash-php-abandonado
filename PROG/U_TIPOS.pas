unit U_TIPOS;
INTERFACE

const
     CAR1 = #219; { 'Û'caracter relleno completo }
     CAR2 = #178; { '²'caracter relleno con trama }
     CAR3 = #254; { 'þ'caracter relleno central }
     FICH_MODULOS = 'MODULOS.DAT'; {nombre del fichero de datos}

type
    {tipos y definiciones para los MODULOS}
    T_ARISTA  = array [1..5] of byte;
    T_PIEZA   = array [1..4] of T_ARISTA;
    T_MODULO  = array [1..6] of T_PIEZA;
    {posiciones diferentes de una pieza}
    T_CAD_POS = string[8];
    {posiciones diferentes para todo un m¢dulo}
    T_POS_DIF = array [1..6] of T_CAD_POS;
    {registro de m¢dulos}
    T_REG_MODULO = record
                          COLOR  : byte;
                          NOMBRE : string[8];
                          MODULO : T_MODULO;
                          POS_DIF: T_POS_DIF;
                   end;
    {tabla en memoria para trabajar con los m¢dulos}
    T_TAB_MODULOS  = array [1..6] of T_REG_MODULO;
    {fichero en disco para almacenar los m¢dulos}
    T_FICH_MODULOS = file of T_REG_MODULO;

const
     {ctes. con tipo con los nombres y c¢digos de los colores}
    NOM_COL : array[1..6] of string[8] =
            ('AZUL', 'VERDE', 'AMARILLO', 'NARANJA', 'ROJO', 'MORADO');
    COD_COL : array[1..6] of byte      =
            (1,      10,       14,         12,        4,      5);

IMPLEMENTATION
begin
end.