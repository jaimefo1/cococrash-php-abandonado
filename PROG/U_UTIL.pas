unit U_UTIL;

INTERFACE

procedure ESPERA(F,C:byte);
procedure TEXTO (F,C : byte; TEXT:string);
procedure CAJA  (F1,C1,F2,C2:byte);
procedure MARCO (F,C,L:byte);
procedure MUEVE (var F,C : byte; D,S : byte);
function  TEST_SI_NO (F,C: byte; MENS: string): boolean;
function  REPLICA (C:char; N:byte) : string;

IMPLEMENTATION

uses CRT;

const
     TAB_DIR : array [1..4] {direcciones} of
                     array [1..2] {incrementos} of shortint =
                          ((0,1), (1,0), (0,-1), (-1,0));

procedure ESPERA (F, C: byte);
   var TECLA : char ;
   begin
        TEXTO(F,C,'pulse una tecla');TECLA := READKEY;
        TEXTO(F,C,'               ');
   end;
procedure TEXTO (F,C : byte; TEXT:string);
   begin  gotoxy (C,F); write (TEXT)  end;

procedure CAJA  (F1,C1,F2,C2:byte);
   var  i:byte;
   begin
        GOTOXY(C1,F1);write('�');
        for i:=C1+1 to C2-1 do write('�');
        GOTOXY(C2,F1);write('�');
        for i:=F1+1 to F2-1 do begin GOTOXY(C2,i);write('�') end;
        GOTOXY(C1,F2);write('�');
        for i:=C1+1 to C2-1 do write('�');
        GOTOXY(C2,F2);write('�');
        for i:=F1+1 to F2-1 do begin GOTOXY(C1,i);write('�') end
   end;
procedure MARCO (F,C,L: byte );   { pone marco de puntos de L x L }
   var
      i:byte;
   begin
        TEXTO (F,C,REPLICA('�',L));
        TEXTO (F+L-1,C,REPLICA('�',L));
        for i:=1 to L-2 do
            begin
                 TEXTO (F+i,C,'�');
                 TEXTO (F+i,C+L-1,'�')
            end
    end;

procedure MUEVE (var F,C : byte; D,S : byte);
   begin
        F := F + TAB_DIR[D,1] * S;
        C := C + TAB_DIR[D,2] * S
   end;

function TEST_SI_NO (F, C: byte; MENS: string): boolean;
   var   TECLA : char;
   begin
        MENS := '�'+ MENS + ' <S>/<N>?: ';
        TEXTO (F, C, MENS);
        repeat
              TECLA := READKEY
        until TECLA in ['S','s','N','n'];
        TEST_SI_NO := TECLA in ['S','s']
    end;

function REPLICA (C: char; N: byte) : string;
   begin
        if N = 0 then
           REPLICA := ''
         else
           REPLICA := C + REPLICA (C,N-1)
   end;
end.