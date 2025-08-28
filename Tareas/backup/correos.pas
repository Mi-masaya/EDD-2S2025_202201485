unit correos;

{$mode objfpc}{$H+}

interface

type
  PCorreo = ^TCorreo;
  TCorreo = record
    Id: Integer;
    Remitente: string;
    Estado: string;
    Programado: string;
    Asunto: string;
    Fecha: string;
    Mensaje: string;
    Prev, Next: PCorreo;
  end;

var
  HeadCorreos: PCorreo;

procedure InicializarCorreos;
procedure AgregarCorreo(Id: Integer; Remitente, Estado, Programado, Asunto, Fecha, Mensaje: string);
procedure MostrarCorreos;

implementation

procedure InicializarCorreos;
begin
  HeadCorreos := nil;
end;

procedure AgregarCorreo(Id: Integer; Remitente, Estado, Programado, Asunto, Fecha, Mensaje: string);
var
  Nuevo, Temp: PCorreo;
begin
  New(Nuevo);
  Nuevo^.Id := Id;
  Nuevo^.Remitente := Remitente;
  Nuevo^.Estado := Estado;
  Nuevo^.Programado := Programado;
  Nuevo^.Asunto := Asunto;
  Nuevo^.Fecha := Fecha;
  Nuevo^.Mensaje := Mensaje;
  Nuevo^.Next := nil;
  Nuevo^.Prev := nil;

  if HeadCorreos = nil then
    HeadCorreos := Nuevo
  else
  begin
    Temp := HeadCorreos;
    while Temp^.Next <> nil do
      Temp := Temp^.Next;
    Temp^.Next := Nuevo;
    Nuevo^.Prev := Temp;
  end;
end;

procedure MostrarCorreos;
var
  Temp: PCorreo;
begin
  Temp := HeadCorreos;
  while Temp <> nil do
  begin
    Writeln('Correo ', Temp^.Id, ': ', Temp^.Asunto, ' de ', Temp^.Remitente);
    Temp := Temp^.Next;
  end;
end;

end.
