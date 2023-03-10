UNIT U_CUBO;

INTERFACE

procedure SOL_CUBO;

IMPLEMENTATION

uses CRT, PRINTER, U_MENU, U_TIPOS, U_UTIL, U_PIEZAS, U_MOD;

const
     CTE_MENU =
    '#1SIGUIENTE MODULO #2SIGUIENTE PIEZA/POSICION INICIAL '+
    '#3GENERAR SOLUCIONES #4VER/IMPRIMIR FICHERO SOLUCIONES '+
    '#+AUMENTA RETARDO #-REDUCE RETARDO #0SALIR';
     RETARDO_MAX = 10000;
     INC_RETARDO = 500;
     DIR_FICH = 'DIR_SOL\';
type
    { tipos y definiciones para realizar el CUBO}
    T_CARA_CUBO  = record
                         PIEZA : byte;
                         POS   : byte
                   end;
    T_CUBO       = array [1..6] of T_CARA_CUBO;
    T_REG_CUBO   = record  CUBO : T_CUBO   end;
    T_FICH_CUBO  = file of T_REG_CUBO;
    {Definici?n del Cubo seg?n las caras limites a las aristas }
    const
         DEF_CUBO : array [1..6] {caras} of array [1..4] {aristas} of byte =
         ((5,3,2,4), (1,3,6,4), (1,5,6,2), (1,2,6,5), (1,4,6,3), (2,3,5,4) );
    var
       FT    : text;
       R_SOL : T_REG_CUBO;
       F_SOL : T_FICH_CUBO;
       NOM_FICH, LIN_EST : string;
       TAB_MOD : T_TAB_MODULOS;
       M : T_REG_MODULO;
       NM, PZA_IN, POS_IN : byte;
       RETARDO : integer;
       CUBO : T_CUBO;
       OP : char;
       PARAR : boolean;

procedure INI_CUBO;
 {inicializa CUBO con todas sus caras sin piezas}
   var  NC: byte;
   begin
      for NC :=1 to 6 do CUBO[NC].PIEZA :=0
   end;

procedure PIEZAS_CUBO;
 {muestra en pantalla las piezas y posiciones de las caras puestas}
   var  NC : byte;
   begin
        for NC:= 1 to 6 do
            begin
                 gotoxy(24,3+NC);clreol;
                 if CUBO[NC].PIEZA <> 0 then
                    writeln(NC:3,CUBO[NC].PIEZA:3,CUBO[NC].POS:3)
            end
   end;

procedure GEN_ARISTA_CARA_CUBO (var A: T_ARISTA; NC, NA: byte);
 {devuelve en A la arista NA de la  cara NC del cubo }
   var
      NC_LIM, NA_LIM : byte;  {N? Cara y N? Arista lim?trofe con NC, NA }
      NP, POS : byte;         {N? pza. y POS., si hay, en la cara NC_LIM}
      P_AUX   : T_PIEZA;      {Pieza AUX para girarla                   }
   begin
        NC_LIM := DEF_CUBO[NC][NA]; {N? de Cara que limita con NC, NA}
        NP := CUBO[NC_LIM].PIEZA;   {N? de Pieza en la NC_LIM}
        POS:= CUBO[NC_LIM].POS;     {POSici?n de la pieza NP}
        if NP <> 0 then             {si hab?a pieza en NC_LIM         }
           begin                    {habr? que calcular la arista que }
                NA_LIM := 1;        {limita con NC  y guardarla en A  }
                while DEF_CUBO[NC_LIM][NA_LIM] <> NC do
                      NA_LIM := NA_LIM + 1; {qu? arista de NC_LIM es}
                P_AUX := M.MODULO[NP];      {cargamos en P_AUX la pza. NP}
                PIEZA_GIRADA(P_AUX,POS);    {colocamos P_AUX en POS_AUX}
                ARISTA_ESPEJO(P_AUX[NA_LIM]);
                A := P_AUX[NA_LIM] { A ser? el espejo de la arista anterior}
           end
   end;

procedure GEN_CARA_CUBO ( NC:byte; var CC:T_PIEZA);
 { genera una Cara de Cubo (CC) o pieza hipot?tica en la cara NC }
   var
      NP, NA    :byte;  {N? Pza. , N? de Arista }
      P_AUX : T_PIEZA;  {Pieza AUX para girarla           }
      POS_AUX : byte;   {POS. AUX de P_AUX                }
   begin
        INI_PIEZA(CC);  {inicializa CC, puede no haber pieza ah?}
        INI_PIEZA(P_AUX); {inicializa P_AUX, que formaremo despu?s}
        NP := CUBO[NC].PIEZA; {N? de Pieza en NC, puede ser 0}
        if NP <> 0 then   {si hay pieza puesta en NC}
           begin
                P_AUX   := M.MODULO [NP];  {la cargamos en P_AUX}
                POS_AUX := CUBO[NC].POS    {tomamos su POS. en POS_AUX};
                PIEZA_GIRADA (P_AUX,POS_AUX); {giramos P_AUX a POS_AUX}
           end;
        for NA:= 1 to 4 do {vamos a generar las cuatro aristas de NC}
            begin
                 GEN_ARISTA_CARA_CUBO ( CC[NA],NC,NA);
                 SUMA_ARISTAS (CC[NA],P_AUX[NA]); {generada + P_AUX }
             end;
         ACT_ESQ_PIEZA(CC); {actualizamos las intersecciones de CC}
   end;

procedure PON_CUBO;
 {muestra en pantalla las 6 caras del CUBO, as? como las piezas colocadas}
   var
      NC: byte;    {para barrer las 6 caras del CUBO}
      CC: T_PIEZA; {en ella generaremos las caras }
      F, C : byte;  {para posicionarnos en pantalla}
   begin
        for NC := 1 to 6 do   {para cada cara}
            begin
                 F := 12; C:= (NC-1) * 6 + 2; {calculamos F, C}
                 gotoxy(C+2,F); write(NC);    {escribimos NC}
                 GEN_CARA_CUBO(NC,CC);        {generamos CC correpondiente}
                 PON_PIEZA (CC, F+1, C, CUBO[NC].PIEZA=0, CAR1);  {pone CC}
            end;
        PIEZAS_CUBO {pone la soluci?n actual}
   end;

function LIBRE (NP:byte):boolean;
  {nos devuelve verdad si la pieza NP no ha sido utilizada, est? libre}
   var
      LIBRE_AUX : boolean;
      NC : byte;
   begin
        LIBRE_AUX := true;
        for NC:= 1 to 6 do
            if CUBO[NC].PIEZA = NP then LIBRE_AUX := false;
        LIBRE := LIBRE_AUX
   end;

procedure MEN_PROCESO;  {pone las opciones de teclas y el retardo actual}
   begin
        TEXTO(23,5,' <+>/<-> RETARDO / <P> PAUSA  ');
        gotoxy(1,21);write('Retardo actual: ',RETARDO:5)
   end;

procedure PAN_SOL; {pone el texto y recuadro fijos durante el proceso}
   begin
      CLRSCR;
      TEXTO(1,2,'C.C.:');   MARCO(2,2,7);
      TEXTO(1,12,'P:  P:'); MARCO(2,12,7);
      TEXTO(1,26,'PROGRESO');
      TEXTO(3,26,'C. P. P.');
      MEN_PROCESO;
  end;

procedure SUBE_RETARDO; {aumenta RETARDO en un INC_RETARDO}
   begin
        RETARDO := RETARDO + INC_RETARDO;
        if RETARDO > RETARDO_MAX then  RETARDO := RETARDO_MAX
   end;

procedure BAJA_RETARDO; {baja RETARDO en un INC_RETARDO}
   begin
        RETARDO := RETARDO - INC_RETARDO;
        if RETARDO < 0 then RETARDO := 0
   end;

procedure PARADA; {permite detener el proceso, y aumentar o bajar retardo}
   var  A : char; {recoge la tecla que espera (KEYPRESSED es true)}
   begin
        TEXTCOLOR(7); A := READKEY;
        case A of
            '+'     : SUBE_RETARDO;
            '-'     : BAJA_RETARDO;
            'P','p' : begin
                           TEXTCOLOR(7);
                           gotoxy(1,23);clreol;
                           PARAR:= TEST_SI_NO (23,5,'PARAR PROCESO');
                           TEXTCOLOR(M.COLOR)
                       end
        end;
        MEN_PROCESO {puede haber habido cambio en RETARDO}
   end;

procedure RETARDAR; {para durante RETARDO o hasta que se pulse una tecla}
   var  A : char;
        N, i : integer;
   begin
        N := RETARDO;               {hay que retardar N unidades}
        repeat
              N:= N - 1;            {una unidad de RETARDO menos}
              for i:= 1 to 3000 do; {no hagas nada 3000 veces!!}
        until (N<0) or (keypressed);{no queda retardo o puls? una tecla}
        if keypressed then  PARADA; {analiza que tecla puls?}
        while keypressed do A:=READKEY {evita acumulaci?n de teclas}
   end;

procedure GEN_CUBO ( NC, NP, POS: byte);
   var
        CP : T_PIEZA; {Cara de Pieza que intenta colocar}
        CC : T_PIEZA; {Cara del Cubo donde intenta colocarla}

   procedure PONER_CP_CC; {pone en pantalla las dos piezas a probar}
      begin
           PON_PIEZA(CC,3,3,true,CAR2);
           gotoxy(7,1);write(NC);      {cara que intenta colocar}
           gotoxy(14,1);write(NP);     {N? de Pieza del m?dulo a probar}
           gotoxy(18,1);write(POS);    {Posici?n de la pieza}
           CP:=M.MODULO[NP];
           PIEZA_GIRADA(CP,POS);
           PON_PIEZA(CP,3,13,false,CAR1) {muestra la pieza a probar}
      end;
   procedure UNA_SOLUCION; {informa y guarda la soluci?n encontrada}
      begin
           TEXTO(10,6,'CUBO GENERADO');
           ESPERA(11,20);
           GOTOXY(6,10);CLREOL;
           R_SOL.CUBO := CUBO;
           write(F_SOL,R_SOL) {a?ade la soluci?n al fichero de soluciones}
      end;

   begin
      GEN_CARA_CUBO(NC,CC);
      repeat  {vamos a probar con todas las piezas que nos quedan}
        if LIBRE(NP) then  {la pieza NP no ha sido usada todav?a}
           repeat  {vamos a probar en todas las POS diferentes de NP}
             if M.POS_DIF[NP][POS] = '1' then
                begin
                     PONER_CP_CC; {muestra la Cara de la Pieza y del Cubo}
                     RETARDAR;    {produce un retardo}
                     if TEST_PIEZA (CP,CC) then   {! ENCAJA ? !}
                        begin
                             CUBO[NC].PIEZA:=NP;  {pieza NP, POS  }
                             CUBO[NC].POS  :=POS; {colocada en NC }
                             PON_CUBO; {muestra situaci?n actual}

                             if NC < 6 then {?quedan caras por poner?}
                                GEN_CUBO(NC+1,1,1)
                                {OTRA CARA!!, empezamos con NP y POS a 1}
                             else
                                UNA_SOLUCION; {hemos puesto todas}

                             CUBO[NC].PIEZA := 0; {puede haber m?s con  }
                             PON_CUBO             {otra pieza o posici?n}
                        end
                end;
                POS:=POS+1; {otra posicion para la misma pieza}
             until (POS > 8) or (NC = 1) or PARAR;
              {todas las POSiciones o estamos en la primera cara o PARAR}
             NP:=NP+1; {siguiente pieza, empezamos en posicion 1}
             POS:=1
      until (NP > 6) or (NC=1) or PARAR;
      {todas las piezas o estamos en la primera cara o PARAR}
   end;

procedure GEN_EST_FICH; {genera la LINea de ESTado y el NOMbre del fichero  }
   var  AUX : string;   {de soluciones seg?n NM, PZA_IN y POS_IN            }
   begin
        LIN_EST:= 'MODULO: ' +TAB_MOD[NM].NOMBRE;
        str(PZA_IN:1,AUX); LIN_EST := LIN_EST + ' Pza.: '+ AUX;
        NOM_FICH := TAB_MOD[NM].NOMBRE +'.'+ AUX;
        str(POS_IN:1,AUX); LIN_EST := LIN_EST + ' Pos.: '+ AUX;
        NOM_FICH := NOM_FICH + AUX;
        LIN_EST := LIN_EST + ' Fch.: ' + NOM_FICH;
        NOM_FICH := DIR_FICH + NOM_FICH;
        str (RETARDO:3,AUX);
        LIN_EST := LIN_EST + ' Ret: '+ AUX;
   end;

procedure VER_IMPRIMIR_SOLUCIONES; { ver/imprimir fichero de soluciones   }
   var
      NC, NS : byte; {N? de Cara y de Soluci?n}
   begin
        writeln (FT, 'SOLUCIONES MODULO ', M.NOMBRE,
                ' Pza. In.: ',PZA_IN, ' Pos. In:',POS_IN );
        write (FT,'N? ');
        NS := 0;
        for NC := 1 to 6 do  write (FT, 'Cara ',NC,' ');
        while not eof(F_SOL) do
              begin
                   writeln (FT,'');
                   NS := NS + 1;
                   write (FT,NS:2,' ');
                   read (F_SOL,R_SOL);
                   for NC := 1 to 6 do
                       write (FT, R_SOL.CUBO[NC].PIEZA:2 ,' -',
                              R_SOL.CUBO[NC].POS:2,' ')
               end;
        for NC:=1 to 3 do writeln (FT,'');
   end;

procedure SOLUCIONES; {busca y ve o imprime fichero de soluciones actual}
   begin
        clrscr;
        assign (F_SOL,NOM_FICH);
        {$I-} reset  (F_SOL) {$I+}; {directiva para detectar si existe}
        if IOresult = 0 then        {existe el fichero!!}
           begin
                if TEST_SI_NO (5,5,'IMPRIMIR') then
                   assign(FT,'lpt1')  {asigna a impresora lpt1}
                  else
                   assign(FT,'con');  {asigna a disp. con     }
                clrscr;
                {$I-} rewrite(FT) {$I+}; {intenta abrir disp.}
                if IOresult = 0 then   {disp. OK }
                   begin
                        VER_IMPRIMIR_SOLUCIONES;
                        close(FT);
                        TEXTO (23,1,'FIN VER/IMPRIMIR, ');
                   end
                 else
                   TEXTO (5,5,'EL DISPOSITIVO NO ESTA PREPARADO');
                close (F_SOL)
            end
           else
             TEXTO (5,5,'EL FICHERO NO ESTA GENERADO');
        ESPERA (23,19);
   end;

procedure SIGUIENTE_MODULO; {proc. local para cambiar m?dulo activo}
   begin
        NM := NM + 1; if NM > 6 then NM := 1;
        M := TAB_MOD[NM];
        PZA_IN := 1; POS_IN := 1
   end;

procedure CAMBIA_PIEZA_POS_INICIO; {idem. para cambiar PZA_IN y POS_IN}
   begin
        POS_IN := POS_IN + 4;
        if (POS_IN > 5) or
           (M.POS_DIF[PZA_IN][POS_IN]='0') then
           begin
                PZA_IN := PZA_IN + 1;
                if PZA_IN > 6 then PZA_IN := 1;
                POS_IN := 1
           end
   end;

procedure GENERAR_SOLUCIONES; {genera F_SOL para NM, PZA_IN, POS_IN}
   begin
        assign (F_SOL,NOM_FICH); {asigna F_SOL a NOM_FICH}
        rewrite (F_SOL);
        TEXTMODE(co40);          {pone modo 25x40 color}
        PAN_SOL;                 {PANtalla de SOLuci?n }
        TEXTCOLOR (M.COLOR);

        GEN_CUBO (1,PZA_IN,POS_IN); {proc. RECURSIVO de GENerac?on,CARA 1}

        TEXTCOLOR (7);
        TEXTO(23,1,'   FIN DEL PROCESO   ');
        ESPERA(23,22);
        TEXTMODE(co80);
        close (F_SOL)
   end;

procedure SOL_CUBO; {procedimiento PPAL. de la UNIT}
   begin
        CARGAR_MODULOS (FICH_MODULOS, TAB_MOD);
        NM:=1; PZA_IN := 1; POS_IN := 1;
        M := TAB_MOD[NM];
        RETARDO := INC_RETARDO;
        repeat
              PARAR := false;
              GEN_EST_FICH;
              CLRSCR;
              MENU ('MENU CUBO',CTE_MENU,OP,LIN_EST);
              case OP of
                   '1' : SIGUIENTE_MODULO;
                   '2' : CAMBIA_PIEZA_POS_INICIO;
                   '3' : GENERAR_SOLUCIONES;
                   '4' : SOLUCIONES;
                   '+' : SUBE_RETARDO;
                   '-' : BAJA_RETARDO;
              end
        until OP = '0'
   end;
end.