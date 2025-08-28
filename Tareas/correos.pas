unit correos;

{$mode objfpc}{$H+}

interface

type
  PCorreo = ^TCorreo;
  TCorreo = record
    id: Integer;
    remitente: String;
    estado: String;
    programado: String;
    asunto: String;
    fecha: String;
    mensaje: String;
    anterior: PCorreo;
    siguiente: PCorreo;
  end;

procedure InsertarCorreo(var inicio: PCorreo; id: Integer; remitente, estado, programado, asunto, fecha, mensaje: String);

implementation

procedure InsertarCorreo(var inicio: PCorreo; id: Integer; remitente, estado, programado, asunto, fecha, mensaje: String);
var
  nuevo, temp: PCorreo;
begin
  New(nuevo);
  nuevo^.id := id;
  nuevo^.remitente := remitente;
  nuevo^.estado := estado;
  nuevo^.programado := programado;
  nuevo^.asunto := asunto;
  nuevo^.fecha := fecha;
  nuevo^.mensaje := mensaje;
  nuevo^.anterior := nil;
  nuevo^.siguiente := nil;

  if inicio = nil then
    inicio := nuevo
  else
  begin
    temp := inicio;
    while temp^.siguiente <> nil do
      temp := temp^.siguiente;
    temp^.siguiente := nuevo;
    nuevo^.anterior := temp;
  end;
end;

end.
