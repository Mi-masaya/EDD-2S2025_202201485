unit usuarios;

{$mode objfpc}{$H+}

interface

type
  PUsuario = ^TUsuario;
  TUsuario = record
    id: Integer;
    nombre: String;
    usuario: String;
    password: String;
    email: String;
    telefono: String;
    siguiente: PUsuario;
    correos: Pointer; // Apunta a lista doble de correos
  end;

function CrearUsuario(id: Integer; nombre, usuario, password, email, telefono: String): PUsuario;

implementation

function CrearUsuario(id: Integer; nombre, usuario, password, email, telefono: String): PUsuario;
var
  nuevo: PUsuario;
begin
  New(nuevo);
  nuevo^.id := id;
  nuevo^.nombre := nombre;
  nuevo^.usuario := usuario;
  nuevo^.password := password;
  nuevo^.email := email;
  nuevo^.telefono := telefono;
  nuevo^.siguiente := nil;
  nuevo^.correos := nil;
  Result := nuevo;
end;

end.
