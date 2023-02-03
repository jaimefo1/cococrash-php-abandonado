UNIT U_GESMOD;

INTERFACE

procedure GES_MODULOS;

IMPLEMENTATION

uses CRT, U_MENU, U_TIPOS, U_UTIL, U_PIEZAS, U_MOD;
const
     CTE_MENU = '#1SIGUIENTE MODULO #2EDITAR MODULO ACTIVO '+
                '#3ROTACIONES MODULO ACTIVO #4VISUALIZAR MODULOS #0SALIR';
var
      TAB_MOD : T_TAB_MODULOS; {tabla para cargar los m¢dulos}
      NM : byte;               {variable de N§ de M¢dulo}
      LIN_EST : string;        {cadena de la LINnea de ESTado del men£}
      OP : char;               {car cter para recoger la OPci¢n del men£}

procedure ACT_POS_DIF (P: T_PIEZA; var CAD_POS: T_CAD_POS);
 {actualiza la CADena de POSiciones diferenetes para una pieza (P)}
   var
      NP1, NP2, i: byte;
      TP  :  array [1..8] of T_PIEZA;
   begin
      for i:=1 to 8 do
          begin
               TP[i] := P;
               ROTAR_90(P);
               if i = 4 then INVERTIR_PIEZA(P)
           end;
      CAD_POS := '11111111';
      for NP1 := 1 to 7 do
          if CAD_POS[NP1] = '1' then
             for NP2 := NP1 + 1 to 8 do
                 if PIEZA_IGUAL (TP[NP1],TP[NP2]) then
                    CAD_POS [NP2] := '0';
   end;

procedure PONER_PIEZAS (F, DC: byte; M: T_MODULO; CAR: char);
 {pone las piezas de un M¢dulo (M), en la fila F, separadas DC columnas }
   var
      NP, C : byte;
   begin
        for NP := 1 to 6 do
            begin
                 C := NP * 7 + DC ;
                 gotoxy(C,4);
                 PON_PIEZA (M[NP],F, C, false, CAR);
               end
         end;

procedure PEDIR_PIEZAS (var RM: T_REG_MODULO);
 {pide las piezas de un RM (Registro M¢dulo) y actualiza sus POS_DIF}
   var
      NP, NA, PA : byte;
      A      : char;
      RM_AUX  : T_REG_MODULO;
      ACT_PAN : boolean;
      P : T_PIEZA;

   procedure INICIALIZA_DATOS;
    {inicializa las variables del procedimiento ppal., pone texto teclas }
      begin
           NA := 4; PA := 5;
           P := RM_AUX.MODULO[NP];
           ACT_PAN := true;
     end;
   procedure ACTUALIZA_PANTALLA;
    {actualiza la pantalla segun informa ACT_PAN, cambio de pieza}
      begin
           TEXTCOLOR(7);
           gotoxy(5,3);
           write('MODULO :',RM.NOMBRE:8,' PIEZA: ',NP);
           TEXTCOLOR(RM.COLOR);
           PON_PIEZA (P,5,15,false,CAR3);
           ACT_PAN := false
      end;
   procedure PULSA_ENTER;
    {procesa el cambio de RELLENO (SI/NO) }
      begin
           CAMBIA (P[NA,PA]);
           if P[NA][PA] = 1 then write(CAR3) else write(' ') ;
           if PA = 5 then
              begin  AVANZA (NA,PA); CAMBIA (P[NA,PA]) end;
           AVANZA (NA,PA);
      end;
   procedure CAMBIO_DE_PIEZA;
    {guarda los cambios en P, calcula la nueva pieza (NP) y la carga en P}
      begin
           RM_AUX.MODULO[NP] := P;
           NP := ord(A) - ord('0');
           INICIALIZA_DATOS;
      end;
   procedure GRABAR_MODIFICACIONES;
    {muestra la as versiones nueva y antigua, pregunta y ejecuta guardar}
      var  NP: byte;
      begin
           TEXTMODE (co80+font8x8);
           TEXTCOLOR(RM.COLOR);
           PONER_PIEZAS (20,10,RM.MODULO, CAR2);
           PONER_PIEZAS (26,10,RM_AUX.MODULO, CAR1);
           TEXTCOLOR(7);
           if TEST_SI_NO (32,27,'GRABAR MODULO') then
              begin
                   RM := RM_AUX;
                   for NP := 1 to 6 do
                       ACT_POS_DIF(RM.MODULO[NP],RM.POS_DIF[NP])
              end;
           TEXTMODE(co80)
      end;
   {comienza el procedimiento PEDIR_PIEZAS en s¡}
   begin
        TEXTMODE(CO40);
        TEXTO (18,3,'<TAB> AVANZA / <ENTER> RELLENA SI/NO');
        TEXTO (19,3,' <1>..<6> CAMBIA PIEZA / <Esc> FIN ' );
        RM_AUX := RM;
        NP:=1;
        INICIALIZA_DATOS;
             repeat
                   if ACT_PAN then ACTUALIZA_PANTALLA;
                   PON_CURSOR(5,15,NA,PA);
                   A := READKEY; if KEYPRESSED then A := READKEY;
                   case A of
                        #13 : PULSA_ENTER;            {ENTER   }
                        #9 : begin
                                  AVANZA (NA,PA);      { TAB    }
                                  if PA=1 then AVANZA(NA,PA)
                              end;
                        '1'..'6': CAMBIO_DE_PIEZA
                   end
             until A = chr(27);                      {Esc}
        RM_AUX.MODULO[NP] := P;
        GRABAR_MODIFICACIONES
   end;

procedure ROTACIONES_UNA_PIEZA (P: T_PIEZA; F: byte; POS_DIF : T_CAD_POS);
   var
      POS: byte;
      PIEZA_AUX : T_PIEZA;
      CAR_RELL  : char;
   begin
        for POS := 1 to 8 do
            begin
                 PIEZA_AUX := P;
                 PIEZA_GIRADA (PIEZA_AUX, POS);
                 if POS_DIF[POS] = '1' then
                    CAR_RELL := CAR1
                   else
                    CAR_RELL := CAR2;
                 PON_PIEZA (PIEZA_AUX, F, POS*7, false, CAR_RELL)
               end;
   end;

procedure ROTACIONES( RM : T_REG_MODULO);
 { permite ver las rotaciones posibles del m¢dulo o juego de piezas }
   var
      NP, POS : byte;
      PIEZA_AUX : T_PIEZA;
   begin
     TEXTMODE(co80+font8x8);
     gotoxy(1,0); write('ROTACIONES DEL MODULO :',RM.NOMBRE);
     for POS :=1 to 8 do
         begin  gotoxy(POS*7,4); write('POS ',POS) end;
     for NP :=1 to 6 do
         begin
              gotoxy(1,NP*6+2); write('P ',NP);
              TEXTCOLOR(RM.COLOR);
              ROTACIONES_UNA_PIEZA(RM.MODULO[NP], NP*6, RM.POS_DIF[NP]);
              TEXTCOLOR(7)
         end;
         ESPERA(49,60); TEXTMODE(co80);
     end;

procedure VER_UN_MODULO (NM, F: byte);
 { permite ver el m¢dulo NM en fila F, a partir de la columna 10 }
   begin
        TEXTCOLOR(7);
        gotoxy(1,F+2); write(NM,' ', TAB_MOD[NM].NOMBRE);
        TEXTCOLOR(TAB_MOD[NM].COLOR);
        PONER_PIEZAS (F,10,TAB_MOD[NM].MODULO, CAR1)
   end;

procedure VER_MODULOS;
 { permite ver las piezas de una tabla completa de m¢dulos }
   var NM : byte;
   begin
        TEXTMODE(co80+font8x8);
        CLRSCR;
        for NM:=1 to 6 do VER_UN_MODULO (NM, NM*6);
        TEXTCOLOR(7);
        ESPERA(49,60);
        TEXTMODE(co80);
   end;

procedure GES_MODULOS;
   begin
        CARGAR_MODULOS (FICH_MODULOS, TAB_MOD);
        NM:=1;
        repeat
              str (NM:1,LIN_EST);
              LIN_EST:= 'MODULO ACTIVO: '+TAB_MOD[NM].NOMBRE+' ('+LIN_EST+')';
              CLRSCR;
              MENU ('MENU MODULOS', CTE_MENU, OP, LIN_EST);
              case OP of
                   '1' : begin
                              NM := NM + 1;
                              if NM > 6 then NM := 1
                         end;
                   '2' : PEDIR_PIEZAS (TAB_MOD[NM]);
                   '3' : ROTACIONES (TAB_MOD[NM]);
                   '4' : VER_MODULOS
           end
     until OP = '0'
   end;
end.