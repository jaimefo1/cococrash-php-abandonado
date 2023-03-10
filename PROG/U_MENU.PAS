unit U_MENU;

INTERFACE

procedure MENU ( CAB, LISTA : string; var OP : char; EST : string);

IMPLEMENTATION

   uses CRT, U_UTIL;

   const
        MAX_OPS = 10; CAR_SEP = '#'; MAX_TEXT = 70;
{MAXimo de OPcioneS, CARacter SEParador, MAXima longitud TEXto permitida}
   var
      TAB_OPS: array [1..MAX_OPS] of string[MAX_TEXT];
        {TABla con el texto de las OPcioneS}
      VAL_POS: string[MAX_OPS];   {cadena con VALores POSibles de teclas}
      NTO, MAX_LONG: byte;  {N? Total Opciones, MAX LONG de texto hallada}
      F1, C1, F2, C2: byte; {valores de Fila y Columna de las esquinas   }
                            {sup. izqda. (1) e inf. dcha. (2)            }

procedure CARGA_OPCIONES (LISTA: string);{carga valores de opciones en      }
   var                                   {TAB_OPS (texto) y VAL_OPS (teclas)}
      LONG_OP, P : byte;
   begin
        MAX_LONG := 0; VAL_POS  := ''; NTO := 0;
        while (LISTA <> '') and (NTO < MAX_OPS) do
              begin
                   P := POS (CAR_SEP, COPY (LISTA,2,255));
                   if P = 0 then P := 255;
                   NTO := NTO + 1;
                   VAL_POS := VAL_POS + LISTA[2];
                   TAB_OPS[NTO] := COPY (LISTA,3, P-3);
                   LONG_OP := LENGTH (TAB_OPS [NTO] );
                   if LONG_OP > MAX_LONG then MAX_LONG := LONG_OP;
                   LISTA := COPY (LISTA, P+1, 255);
            end;
   end;
procedure PON_MENU (CAB,EST: string); {coloca en pantalla el men?, con CAB,}
   var                                {EST, TAB_OPS y VAL_OPS              }
      NOP, CENTRADO : byte;           {usa F,C,B,H previamente calculados  }
   begin
        CENTRADO := (80 - length(CAB)) div 2;
        TEXTO (F1 + 2, CENTRADO, CAB);
        CAJA (F1,C1,F2,C2);
        for NOP := 1 to NTO do
            TEXTO (F1+4+(NOP-1)*2,C1+2,'('+ VAL_POS[NOP]+') '+TAB_OPS[NOP]);
        CENTRADO := (80 - length(EST)) div 2;
        TEXTO (F2+1, CENTRADO, EST)
   end;
procedure CALCULO_F1_C1_F2_C2; {calcula en funci?n de MAX_LONG y NTO   }
   var                         {tiene en cuenta las l?neas de CAB y OP }
      ANCHO, ALTO : byte;
   begin
        ALTO := (NTO + 2) * 2 + 1;   ANCHO := MAX_LONG + 8;
        F1 := (24 - ALTO ) div 2; C1 := (79 - ANCHO ) div 2;
        F2 := F1 + ALTO; C2:= C1 + ANCHO
   end;
procedure PEDIR_OP ( FP,CP: byte;var OP: char);{recoge en OP la tecla      }
   begin                                       {pulsada y valida  (VAL_OPS)}
        TEXTO (FP,CP,'OPCION:');
        repeat
              OP := READKEY
        until (POS(OP,VAL_POS) <> 0) or (OP='1')
   end;

procedure MENU ( CAB, LISTA : string; var OP : char; EST : string);
   begin
        CARGA_OPCIONES ( LISTA );
        if LENGTH (CAB) > MAX_LONG then MAX_LONG := LENGTH(CAB);
        CALCULO_F1_C1_F2_C2;
        PON_MENU (CAB, EST);
        PEDIR_OP (F2 - 1, C1 + 1, OP)
   end;
end.