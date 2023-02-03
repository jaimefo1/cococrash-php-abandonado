UNIT U_STAR2;

INTERFACE

uses CRT, U_TIPOS, U_UTIL, U_MODULO,PRINTER;


type
    { tipos y definiciones para realizar el CUBO}
    T_CARA_CUBO  = record
                         PIEZA : byte;
                         POS   : byte
                   end;
    T_STAR       = array [1..30] of T_CARA_CUBO;

    T_MODULO_36  = array [1..36] of T_PIEZA;
    T_POS_DIF_36 = array [1..36] of T_CAD_POS;
    T_REG_MODULO_36 = record
                          COLOR  : byte;
                          MODULO : T_MODULO_36;
                          POS_DIF: T_POS_DIF_36;
                   end;

(*    T_TC = array [0..31] {combinaciones} of
                     array [1..36] {piezas}     of
                           array [1..8] {posiciones} of
                                array [1..4] {aristas} of
                                      boolean;
     T_VAS = array[1..4] of byte;
     T_TPP = array[1..36] of array[1..8] of T_PIEZA; *)

{    T_REG_CUBO   = record
                         CUBO : T_CUBO
                   end;
    T_FICH_CUBO = file of T_REG_CUBO;}

    {Definici¢n de la ESTRELLA seg£n los aristas entre caras}
    const
         DEF_STAR : array [1..30] {caras} of array [1..4] {aristas} of byte =
 ((5 ,3 ,2 ,4 ), (1 ,3 ,6 ,4 ), (1 ,5 ,11,2 ), (1 ,2 ,16,5 ), (1 ,4 ,21,3 ),
  (2 ,8 ,7 ,9 ), (6 ,8 ,10,9 ), (6 ,14,10,7 ), (6 ,7 ,10,18), (7 ,8 ,26,9 ),
  (3 ,13,12,14), (11,13,15,14), (11,24,15,12), (11,12,15,8 ), (12,13,28,14),
  (4 ,18,17,19), (16,18,20,19), (16,9 ,20,17), (16,17,20,23), (17,18,29,19),
  (5 ,23,22,24), (21,23,25,24), (21,19,25,22), (21,22,25,13), (22,23,30,24),
  (10,28,27,29), (26,28,30,29), (26,15,30,27), (26,27,30,20), (27,28,25,29));

        ARISTA_MALA : T_ARISTA = (0,1,1,1,0);
     { Definici¢n de las esquinas 2-D }
        DEF_ESQ_2_D : array [1..4] {esquinas}
                         of array [1..2] {inicio de aristas posibles}
                               of array [1..2] {CARA,ARISTA}
                                     of byte =
     (((4,4),(1,2)),((1,4),(2,2)),((2,4),(3,2)),((3,4),(4,2)));
     { Definici¢n de las esquinas 3-D }
        DEF_ESQ_3_D : array [1..8] {esquinas}
                         of array [1..6] {inicio de aristas posibles}
                               of array [1..2] {CARA,ARISTA}
                                     of byte =
      (((2,4),(6,1),(9,1),(18,2),(16,2),(4,3)),
       ((2,3),(6,2),(8,2),(14,1),(11,1),(3,4)),
       ((5,4),(21,1),(24,1),(13,2),(11,2),(3,3)),
       ((5,3),(21,2),(23,2),(19,1),(16,1),(4,4)),
       ((26,1),(20,3),(18,3),(9,4),(10,4),(29,1)),
       ((26,2),(10,3),(8,3),(14,4),(15,4),(28,2)),
       ((30,4),(25,3),(23,3),(19,4),(20,4),(29,4)),
       ((30,3),(28,3),(15,3),(13,3),(24,4),(25,4)));

    var
       FT : text;
       STAR : T_STAR;
       M    : T_REG_MODULO_36;
       TC : T_TC;
       TPP : T_TPP;
       NC_MAX : byte;
       NIN : real;
{       sw_del : boolean;
       a: char;}

{procedure GEN_STAR
 ( NC:byte; STAR:T_STAR; var M: T_REG_MODULO; NP,POS :byte);
 { procedimiento principal de  generacion del cubo }
procedure ESTRELLA;

procedure INI_STAR (var S : T_STAR);

IMPLEMENTATION

procedure INI_STAR (var S : T_STAR);
   var
      i:byte;
   begin
      for i:=1 to 30 do
          with S[i] do
            begin
               PIEZA :=0; POS :=0;
            end
   end;

procedure IMPRIMIR_STAR (var STAR: T_STAR);
   var
      NC : byte;
   begin
        gotoxy (40,3);
        for NC:= 1 to 30 do
            with STAR[NC] do
                 begin
                      gotoxy(70,3+NC);clreol;
                      if PIEZA <> 0 then
                         writeln(NC:3,PIEZA:3,POS:3)
                 end
   end;
procedure IMP_STAR (var STAR: T_STAR);
   var
      NC : byte;
   begin
        for NC:= 1 to 30 do
            with STAR[NC] do
                 begin
                      write(FT,NC:2,PIEZA:3,POS:2,' ');
                      if NC mod 10 = 0 then writeln(FT,' ');
                 end;
                 writeln(FT,' ')
   end;

function TEST_ESQ_PIEZA ( var P : T_PIEZA) : boolean;
   var
      NE,NAI : byte;
   begin
        TEST_ESQ_PIEZA := true;
        for NE := 1 to 4 do
            begin
                 if P[NE][1] = 0 then
                    begin
                         NAI:=NE - 1;
                         if NAI = 0 then NAI:=4;
                         if (P[NAI][4]=1) and (P[NE][2] = 1) then
                             TEST_ESQ_PIEZA := false
                    end
              end
   end;


function BUSCA_ESQ_3_D (NC,NA :byte) : byte;
   var
      TEST : boolean;
      NE, i   : byte;
   begin
        TEST := false;
        BUSCA_ESQ_3_D := 0;
        NE := 1;
        while (NE < 9) and not TEST do
              begin
                   for i:= 1 to 6 do
                       if (DEF_ESQ_3_D[NE][I][1]=NC) and
                          (DEF_ESQ_3_D[NE][I][2]=NA) then
                          TEST := true;
                   NE := NE + 1
              end;
         if TEST then   BUSCA_ESQ_3_D := NE-1;
   end;

function VALOR_UNA_3_D (NE : byte; var STAR: T_STAR):byte;
    var
 {      P_AUX : T_PIEZA;}
       NC, NA, V, i, NP : byte;
       POS: byte;
    begin
         V := 0;
         i := 1;
         while (i < 7) and ( V = 0) do
            begin
                 NC :=DEF_ESQ_3_D[NE][I][1];
                 NP :=STAR[NC].PIEZA;
                 if NP <> 0 then
                    begin
                         POS := STAR[NC].POS;
{                         P_AUX:= TPP[NP,POS];
                         PIEZA_GIRADA(P_AUX,POS);}
                         NA := DEF_ESQ_3_D[NE][I][2];
                         V  := TPP[NP,POS][NA][1]
                    end;
                    i := i + 1
            end;
         VALOR_UNA_3_D := V
    end;

function VALOR_ESQ_3_D (var STAR: T_STAR; NC, NA: byte):byte;
    var
       N_ESQ_3_D : byte;
    begin
         VALOR_ESQ_3_D := 0;
         N_ESQ_3_D := BUSCA_ESQ_3_D(NC,NA);
         if N_ESQ_3_D <> 0 then
            VALOR_ESQ_3_D := VALOR_UNA_3_D (N_ESQ_3_D,STAR)
    end;



procedure GEN_ARISTA_CARA_STAR
 (var A: T_ARISTA; var STAR: T_STAR; NC, NA: byte);
 {devuelve la arista de la pieza colocada en la cara lim¡trofe de la
  cara NC en su arista NA }
   var
      NC_LIM, NA_LIM : byte;
      NP, POS : byte;
      P_AUX   : T_PIEZA;
      i : byte;
   begin
        NC_LIM := DEF_STAR[NC][NA];
        NP := STAR[NC_LIM].PIEZA;
        POS:= STAR[NC_LIM].POS;
        if NP <> 0 then
           begin
                NA_LIM := 1;
                while DEF_STAR[NC_LIM][NA_LIM] <> NC do
                      NA_LIM := NA_LIM + 1;
{                P_AUX := TPP[NP,POS];
                PIEZA_GIRADA(P_AUX,POS);
                ARISTA_ESPEJO(P_AUX[NA_LIM]);}
                A := TPP[NP,POS][NA_LIM];
                ARISTA_ESPEJO (A)
           end;
           if A[1] = 0 then  A[1] := VALOR_ESQ_3_D (STAR,NC,NA);
   end;

procedure GEN_CARA_STAR
 ( NC:byte; var CC:T_PIEZA; var STAR:T_STAR);
 { genera una Cara de Cubo de la estrella o pieza hipot‚tica en la cara NC }
   var
      NP, NA    :byte;
      P_AUX : T_PIEZA;
      POS_AUX : byte;
   begin
        INI_PIEZA(CC);
        INI_PIEZA(P_AUX);
        NP := STAR[NC].PIEZA;
        if NP <> 0 then
           begin
                POS_AUX := STAR[NC].POS;
                P_AUX := TPP[NP,POS_AUX]
           end;
{        PIEZA_GIRADA (P_AUX,POS_AUX);}
        for NA:= 1 to 4 do
            begin
                 GEN_ARISTA_CARA_STAR ( CC[NA],STAR,NC,NA);
                 SUMA_ARISTAS (CC[NA],P_AUX[NA]);
             end;
         ACT_ESQ_PIEZA(CC);
   end;


PROCEDURE PON_STAR( var STAR:T_STAR);
   var
      NC: byte;
      CC: T_PIEZA;
      FIL, COL : byte;
   begin
        for NC := 1 to 30 do
            begin
                 FIL :=14+((NC-1) div 5) * 6;
                 COL := (NC mod 5);
                 if COL = 0 then COL := 5;
                 COL := (COL - 1) * 6 + 1;
                 gotoxy(COL,FIL); write(NC:3);
                 GEN_CARA_STAR(NC,CC,STAR);
                 PON_PIEZA (CC, FIL+1, COL, STAR[NC].PIEZA=0, CAR1);
            end;
   end;

function LIBRE(var NP:byte;var STAR:T_STAR):boolean;
   var
      NC : byte;
   begin
        NC := 1;
        while (STAR[NC].PIEZA <> NP)  and (NC<=30) do INC(NC);
        LIBRE := not (NC<=30)
   end;

function ESQUINAS_OK(var STAR : T_STAR; NC : byte): boolean;
   var
      TEST : boolean;
      A1,A2 : T_ARISTA;
      CC : T_PIEZA;
      NE,NA,NC_LIM : byte;

   begin
        NA := 1;
        TEST := true;
        while  (NA < 5) and (TEST) do
            begin
                 NC_LIM := DEF_STAR[NC][NA];
                 GEN_CARA_STAR(NC_LIM,CC,STAR);
                 TEST:= TEST_ESQ_PIEZA(CC);
                 NA := NA + 1
            end;
        ESQUINAS_OK := TEST;
   end;



function VAL_ARISTA (A: T_ARISTA): byte;
   begin
        VAL_ARISTA := A[1]*16+A[2]*8+A[3]*4+A[4]*2+A[5]
   end;


PROCEDURE GEN_STAR
 ( NC:byte; STAR: T_STAR; NP, POS: byte);
 { procedimiento principal de  generacion de la ESTRELLA }

   var
      CF,CC : T_PIEZA;
      NP_aux, fil : byte;
      STARAUX:T_STAR;
      SW, SW_SAL : boolean;
      VAS : T_VAS;
      i : byte;

   begin
{      NP_AUX := NP - 1;
      if NP_AUX < 1 then NP_AUX:=30;}
      NIN := NIN+1;
{      gotoxy(1,1);write(NIN);}
      STARAUX:=STAR;
      SW_SAL := false;
{     PON_STAR(STAR,M.MODULO);ESPERA;}
      GEN_CARA_STAR(NC,CC,STAR);
      for i:= 1 to 4 do
          begin
               VAS[i] := VAL_ARISTA (CC[i]);
               if VAS[i] in [14,15,30,31] then SW_SAL := true
          end;
  IF not SW_SAL then
  BEGIN {SW_SAL}
     { if NC = 30 then WRITE(30);
                    begin
                         PON_STAR(STAR,M.MODULO);
                         imprimir_star(STAR);
                         PON_PIEZA(CC,7,20,true,CAR2);
                         FIL := 7;
                         for np_aux:= 1 to 36 do
                             if LIBRE(NP_aux,STAR) then
                                begin
                                     gotoxy(60,fil-1);write(np_aux);
                                     PON_PIEZA(M.MODULO[NP_aux],fil,60,false,CAR1);
                                     fil := fil + 6
                                end
                     end;
                                 }
      repeat
         if M.POS_DIF[NP][POS] = '1' then
            if LIBRE(NP,STAR) then
            begin
                gotoxy(1,1);write( 'CARA:',NC,' PIEZA:',NP,' POSICION:',POS);
                sw :=
                    (( TC[VAS[1],NP,POS,1] and
                     TC[VAS[2],NP,POS,2]) and
                    ( TC[VAS[3],NP,POS,3] and
                     TC[VAS[4],NP,POS,4]));
                 if sw then
                    begin
                         STAR[NC].PIEZA:=NP;
                         STAR[NC].POS  :=POS;
                     end;
                 if sw then sw := ESQUINAS_OK(STAR,NC)
             end
           else
              begin
                 sw:=FALSE;
              end;

         if sw then
            begin
                { if (NC > NC_MAX)  then
                    begin
                         PON_STAR(STAR);
                         imprimir_star(STAR);
                         NC_MAX := NC
                    end;}
                 if NC<30 then
                    GEN_STAR(NC+1,STAR,36,1)
                   else
                     begin
{                          GOTOXY(60,41);writeln('ESTRELLA GENERADA');
                          ESPERA;
                          GOTOXY(60,41);CLREOL;}
                         writeln(FT,NIN:20:0);
                         imp_star(STAR)
                     end
             end
          else
             begin
                  STAR:=STARAUX;
                  POS:=POS+1;
                  if POS > 4 then
                     begin
                         NP:=NP-1;
                         POS:=1
                     end
              end;
   until (NP<1) {OR (NC=1))}   OR ( (SW_ESC) OR (NIN > 11.0E06))
   END {SW_SAL}
   end;

procedure CARGAR_MODULOS_36 (NOM_FICH:string; var M : T_REG_MODULO_36);
   var
      F_M : T_FICH_MODULOS;
      R_M : T_REG_MODULO;
      NP_36, NM, NP : byte;
   begin
        assign (F_M, NOM_FICH);
        reset  (F_M);
        NP_36 := 1;
        for NM:= 1 to 6 do
            begin
                 read (F_M, R_M);
                 for NP := 1 to 6 do
                     begin
                          M.MODULO [NP_36] := R_M.MODULO[NP];
                          M.POS_DIF[NP_36] := R_M.POS_DIF[NP];
                          NP_36 := NP_36 + 1
                     end
            end;
        close (F_M)
   end;
procedure VALOR_ARISTA (V:byte;var A:T_ARISTA);
   var
      IA : byte;
   begin
        write(V:3,' -> ');
        for IA := 5 downto 1 do
            begin
                 A[IA] := V mod 2;
                 V := V div 2
            end;
        for IA:=1 TO 5 DO
                 write(A[IA]);
  end;


procedure GEN_TC (var TC :T_TC; M:T_MODULO_36);
   var
      NC,NP,POS,NA : byte;
      A : T_ARISTA;
      P_AUX : T_PIEZA;
      SW : BOOLEAN;
   begin
      for NC := 0 to 31 do
          begin
               VALOR_ARISTA(NC,A);
               sw := false;
               for NP := 1 to 36 do
                   begin
                   for POS := 1 to 8 do
                       begin
                            P_AUX := TPP[NP,POS];
{                            PIEZA_GIRADA (P_AUX,POS);}
                            for NA := 1 to 4 do
                                begin
                                     TC[NC,NP,POS,NA] :=
                                     TEST_ARISTA (P_AUX[NA],A);
                                     if TC[NC,NP,POS,NA] then sw:=true
                                end;
                        end;
                   end;
             if not sw then WRITELN(NC) ELSE WRITELN
          end;
   end;
procedure GEN_TPP (var TPP : T_TPP; M:T_MODULO_36);
   var
      NP,POS : byte;
      P_AUX  : T_PIEZA;
   begin
       for NP := 1 to 36 do
           for POS := 1 to 8 do
               begin
                    P_AUX := M[NP];
                    PIEZA_GIRADA (P_AUX,POS);
                    TPP[NP][POS] :=P_AUX
                end;
   end;

procedure ESTRELLA;
   var
      nc   : BYTE;
   begin
        CARGAR_MODULOS_36('MODULOS.DAT',M);
        GEN_TPP(TPP,M.MODULO);
        GEN_TC(TC,M.MODULO);
        INI_STAR(STAR);
        clrscr;
    ASSIGN(FT,'SOLUCION.DAT');
    REWRITE(FT);
    GEN_STAR(1,STAR,32,1);
    CLOSE (FT)
   end;
begin
    nc_max := 0;
    NIN := 0;
{    sw_del := true;
    ASSIGN(FT,'SOLUCION.DAT');
    REWRITE(FT);}
end.
