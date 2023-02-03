unit U_MOD;

INTERFACE

uses U_TIPOS;

procedure CARGAR_MODULOS (NOM_FICH:string; var TAB_MOD : T_TAB_MODULOS);
  {carga en TAB_MOD el fichero de datos NOM_FICH }
procedure VOLCAR_MODULOS (NOM_FICH:string; TAB_MOD : T_TAB_MODULOS);
  {vuelca en el fichero de datos NOM_FICH, la variable TAB_MOD}

IMPLEMENTATION

uses U_PIEZAS;

procedure INI_MODULO (var M: T_MODULO);
   var  NP : byte;
   begin
      for NP := 1 to 6 do INI_PIEZA (M[NP])
   end;

procedure INI_POS_DIF (var POS_DIF: T_POS_DIF);
   var  NP : byte;
   begin
      for NP := 1 to 6 do  POS_DIF[NP] := '10000000'
   end;

procedure INI_TAB_MODULOS (var TAB_MOD : T_TAB_MODULOS);
   var  R_M : T_REG_MODULO;
        NM  : byte;
   begin
      for NM := 1 to 6 do
          begin
               INI_MODULO (R_M.MODULO);
               R_M.NOMBRE:= NOM_COL[NM];
               R_M.COLOR := COD_COL[NM];
               INI_POS_DIF (R_M.POS_DIF);
               TAB_MOD[NM] := R_M
          end
  end;

procedure CARGAR_MODULOS (NOM_FICH:string; var TAB_MOD : T_TAB_MODULOS);
   var  F_M : T_FICH_MODULOS;
        NM  : byte;
   begin
        assign (F_M, NOM_FICH);
        {$I-}  reset  (F_M); {$I+}
        if IOresult = 0 then
           begin
                 for NM:= 1 to 6 do  read (F_M, TAB_MOD[NM]);
                 close (F_M)
           end
          else
           INI_TAB_MODULOS(TAB_MOD)
   end;

procedure VOLCAR_MODULOS (NOM_FICH:string; TAB_MOD : T_TAB_MODULOS);
   var
      F_M : T_FICH_MODULOS;
      NM  : byte;
   begin
        assign (F_M, NOM_FICH);
        rewrite  (F_M);
        for NM:= 1 to 6 do write (F_M, TAB_MOD[NM]);
        close (F_M)
   end;
end.