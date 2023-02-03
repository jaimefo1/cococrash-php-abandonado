unit U_PIEZAS;
INTERFACE

uses U_TIPOS;

procedure PON_CURSOR (F,C: byte; NA,PA : byte);
  {pone cursor en arista NA, pos., para una pieza colocada en F,C }
procedure AVANZA (var NA,PA : byte);
  {avanza un cuadrito desde la arista NA, pos. PA}
procedure CAMBIA (var N : byte);
  {alterna el valor de N de 0 a 1 o de 1 a 0}
procedure INI_PIEZA (var P: T_PIEZA);
  {inicializa una Pieza con sus aristas a 0}
procedure PON_PIEZA (P: T_PIEZA;F,C: byte;HUECA: boolean; CAR: char);
  {pone una pieza en pantalla (F,C), hueca o no, con el caracter CAR}
procedure ARISTA_ESPEJO ( var A : T_ARISTA);
  {devuelve la imagen espejo de la arista A}
procedure INVERTIR_PIEZA ( var P: T_PIEZA);
  {invierte una pieza, de posici¢n 1 a 5}
procedure ROTAR_90 (var P: T_PIEZA);
  {devuelve la pieza P girada 90 grados en sentido de las agujas del reloj}
procedure PIEZA_GIRADA ( var P: T_PIEZA; POS : byte);
  {devuelve la pieza P girada a la posici¢n POS}
procedure ACT_ESQ_PIEZA( var P: T_PIEZA);
  {actualiza las interseciones de las aristas de una pieza}
procedure SUMA_ARISTAS (var A1 : T_ARISTA; A2:T_ARISTA);
  {en A2 devuelve la suma de las aristas A1 y A2}
Function  TEST_ARISTA (A1,A2 : T_ARISTA):boolean;
  {comprueba si dos aristas encajan}
Function  TEST_PIEZA ( PF,PC:T_PIEZA):boolean;
  {comprueba si dos piezas, PF y PC encajan}
Function  ARISTA_IGUAL (A1,A2 : T_ARISTA):boolean;
  {comprueba si dos aristas A1, A2 son iguales}
Function  PIEZA_IGUAL ( P1,P2 : T_PIEZA) : boolean;
  {comprueba si dos piezas P1, P2 son iguales}

IMPLEMENTATION
uses CRT, U_UTIL;

procedure PON_CURSOR (F,C: byte; NA,PA : byte);
   var  i : byte;
   begin
        for i := 1 to NA-1 do MUEVE (F,C,i,4);
        for i := 1 to PA-1 do MUEVE (F,C,NA,1);
        gotoxy(C,F);
   end;
procedure AVANZA (var NA,PA : byte);
   begin
        PA := PA + 1;
        if PA > 5 then  begin  NA := NA + 1; PA := 1  end;
        if NA = 5 then NA := 1
   end;
procedure CAMBIA ( var N : byte);
   begin  if N=0 then N := 1 else N:=0  end;
procedure INI_PIEZA (var P: T_PIEZA);   {inicializa a 0 las aristas}
   var  NA, PA : byte;
   begin
        for NA :=1 to 4 do
            for PA:= 1 to 5 do  P[NA][PA] := 0
   end;
function PIEZA_IGUAL ( P1,P2 : T_PIEZA) : boolean; {¨son iguales P1 y P2}
   var  NA : byte;
   begin
        PIEZA_IGUAL :=  true;
        for NA := 1 to 4 do
            if not ARISTA_IGUAL (P1[NA],P2[NA]) then PIEZA_IGUAL := false
   end;
procedure PON_ARISTA ( A: T_ARISTA; NA,F,C: byte; CAR:char);
   var  PA : byte;
   begin
        for PA := 1 to 5 do
            begin
                 gotoxy(C,F);
                 if A[PA] = 1 then write( CAR ) else write(' ') ;
                 MUEVE(F,C,NA,1)
            end
   end;
procedure PON_CENTRO (F,C : byte;CEN : string);
   begin
        gotoxy(C+1,F+1); write(CEN);
        gotoxy(C+1,F+2); write(CEN);
        gotoxy(C+1,F+3); write(CEN)
   end;

procedure PON_PIEZA (P: T_PIEZA; F,C: byte; HUECA: boolean; CAR: char);
   var  NA:byte;
   begin
       if HUECA then CAR := ' ';
       PON_CENTRO (F,C,CAR+CAR+CAR);
       for NA:= 1 to 4 do
           begin
                PON_ARISTA (P[NA],NA,F,C,CAR); MUEVE (F,C,NA,4)
           end;
   end;
procedure ARISTA_ESPEJO ( var A : T_ARISTA);
   var i : byte;
       A_AUX : T_ARISTA;
   begin
        for i:=1 to 5 do A_AUX[i] := A[6-i]; A := A_AUX
   end;
procedure INVERTIR_PIEZA ( var P: T_PIEZA);
   var  A_AUX: T_ARISTA;
   begin
        ARISTA_ESPEJO(P[1]);
        ARISTA_ESPEJO(P[3]);
        ARISTA_ESPEJO(P[4]);
        ARISTA_ESPEJO(P[2]);
        A_AUX := P[4]; P[4] := P[2]; P[2] := A_AUX
   end;
procedure ROTAR_90 (var P: T_PIEZA);
   var  A_AUX: T_ARISTA;
   begin
        A_AUX := P[4];
        P[4]  := P[3];
        P[3]  := P[2];
        P[2]  := P[1];
        P[1]  := A_AUX
   end;
procedure PIEZA_GIRADA ( var P: T_PIEZA; POS : byte);
   begin
        if POS > 4 then
           begin INVERTIR_PIEZA (P); POS := POS - 4 end;
        while POS > 1 do
              begin   ROTAR_90 (P); POS := POS - 1  end;
   end;
procedure ACT_ESQUINA ( var P: T_PIEZA; X1,Y1,X2,Y2: byte);
   var  S : byte;
   begin
        S:= P[X1][Y1] + P[X2][Y2];
        if S > 1 then S:= 1;
        P[X1][Y1] := S;
        P[X2][Y2] := S
   end;
procedure ACT_ESQ_PIEZA( var P: T_PIEZA);
   begin
      ACT_ESQUINA (P,4,5,1,1);
      ACT_ESQUINA (P,1,5,2,1);
      ACT_ESQUINA (P,2,5,3,1);
      ACT_ESQUINA (P,3,5,4,1);
  end;
procedure SUMA_ARISTAS (var A1 : T_ARISTA; A2:T_ARISTA);
   var  i : byte;
   begin
      for i:= 1 to 5 do
          begin
                A1[i] := A1[i] + A2[i];
                if A1[i]>1 then A1[i] := 1
           end;
   end;
Function ARISTA_IGUAL (A1,A2 : T_ARISTA):boolean;
    var  i : byte;
    begin
         ARISTA_IGUAL := true;
         for i:= 1 to 5 do if A1[i] <> A2[i]  then ARISTA_IGUAL := false
    end;
Function TEST_ARISTA (A1,A2 : T_ARISTA):boolean;
    var  i : byte;
    begin
         TEST_ARISTA := true;
         for i:= 1 to 5 do
             if A1[i] + A2[i] = 2 then TEST_ARISTA := false;
          if A2[2]+A2[3]+A2[4] > 0 then
             for i:= 2 to 4 do
                 if A1[i] + A2[i] = 0 then TEST_ARISTA := false;
    end;
Function TEST_PIEZA ( PF, PC:T_PIEZA):boolean;
   var   NA : byte;
         TEST_AUX : boolean;
   begin
        TEST_AUX := true; NA := 1;
        while (NA < 5) and (TEST_AUX) do
              begin
                   TEST_AUX := TEST_ARISTA(PF[NA],PC[NA]);
                   NA := NA + 1
              end;
        TEST_PIEZA := TEST_AUX
   end;
END.