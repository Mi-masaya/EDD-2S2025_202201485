unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpjson, jsonparser, fgl, usuarios, correos;

function CargarUsuarios(const archivo: String): PUsuario;
procedure CargarCorreos(const archivo: String; usuarios: PUsuario);
procedure GraficarUsuarios(usuarios: PUsuario; const archivo: String);

implementation

function CargarUsuarios(const archivo: String): PUsuario;
var
  JSONData: TJSONData;
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  fs: TFileStream;
  parser: TJSONParser;
  i: Integer;
  nuevo, ultimo, inicio: PUsuario;
begin
  inicio := nil;
  ultimo := nil;

  fs := TFileStream.Create(archivo, fmOpenRead);
  try
    parser := TJSONParser.Create(fs);
    try
      JSONData := parser.Parse;
    finally
      parser.Free;
    end;
  finally
    fs.Free;
  end;

  JSONArray := TJSONObject(JSONData).Arrays['usuarios'];

  for i := 0 to JSONArray.Count - 1 do
  begin
    JSONObject := JSONArray.Objects[i];
    nuevo := CrearUsuario(
      JSONObject.Integers['id'],
      JSONObject.Strings['nombre'],
      JSONObject.Strings['usuario'],
      JSONObject.Strings['password'],
      JSONObject.Strings['email'],
      JSONObject.Strings['telefono']
    );

    if inicio = nil then
      inicio := nuevo
    else
      ultimo^.siguiente := nuevo;

    ultimo := nuevo;
  end;

  Result := inicio;
end;

procedure CargarCorreos(const archivo: String; usuarios: PUsuario);
var
  JSONData: TJSONData;
  JSONArray, bandeja: TJSONArray;
  JSONObject, correoObj: TJSONObject;
  fs: TFileStream;
  parser: TJSONParser;
  i, j, uid: Integer;
  actual: PUsuario;
  inicioCorreos: PCorreo;
begin
  fs := TFileStream.Create(archivo, fmOpenRead);
  try
    parser := TJSONParser.Create(fs);
    try
      JSONData := parser.Parse;
    finally
      parser.Free;
    end;
  finally
    fs.Free;
  end;

  JSONArray := TJSONObject(JSONData).Arrays['correos'];

  for i := 0 to JSONArray.Count - 1 do
  begin
    JSONObject := JSONArray.Objects[i];
    uid := JSONObject.Integers['usuario_id'];
    bandeja := JSONObject.Arrays['bandeja_entrada'];

    // Buscar el usuario correspondiente
    actual := usuarios;
    while (actual <> nil) and (actual^.id <> uid) do
      actual := actual^.siguiente;

    if actual <> nil then
    begin
      inicioCorreos := nil;
      for j := 0 to bandeja.Count - 1 do
      begin
        correoObj := bandeja.Objects[j];
        InsertarCorreo(
          inicioCorreos,
          correoObj.Integers['id'],
          correoObj.Strings['remitente'],
          correoObj.Strings['estado'],
          correoObj.Strings['programado'],
          correoObj.Strings['asunto'],
          correoObj.Strings['fecha'],
          correoObj.Strings['mensaje']
        );
      end;
      actual^.correos := inicioCorreos;
    end;
  end;
end;

procedure GraficarUsuarios(usuarios: PUsuario; const archivo: String);
var
  f: TextFile;
  actual: PUsuario;
begin
  AssignFile(f, archivo);
  Rewrite(f);
  Writeln(f, 'digraph G { rankdir=LR; node [shape=record];');

  actual := usuarios;
  while actual <> nil do
  begin
    Writeln(f, Format('U%d [label="Id: %d | %s"];',
      [actual^.id, actual^.id, actual^.nombre]));
    if actual^.siguiente <> nil then
      Writeln(f, Format('U%d -> U%d;', [actual^.id, actual^.siguiente^.id]));
    actual := actual^.siguiente;
  end;

  Writeln(f, '}');
  CloseFile(f);
end;

procedure GraficarCorreosUsuarios(usuarios: PUsuario; const archivo: String; numUsuarios: Integer);
var
  f: TextFile;
  actualU: PUsuario;
  actualC: PCorreo;
  count: Integer;
begin
  AssignFile(f, archivo);
  Rewrite(f);
  Writeln(f, 'digraph G { rankdir=LR; node [shape=record];');

  actualU := usuarios;
  count := 0;
  while (actualU <> nil) and (count < numUsuarios) do
  begin

    Writeln(f, Format('U%d [label="Usuario: %s\nId: %d"];',
      [actualU^.id, actualU^.nombre, actualU^.id]));


    actualC := PCorreo(actualU^.correos);
    while actualC <> nil do
    begin
      Writeln(f, Format('C%d [label="Id: %d | %s"];',
        [actualC^.id, actualC^.id, actualC^.asunto]));

      if actualC = PCorreo(actualU^.correos) then
        Writeln(f, Format('U%d -> C%d;', [actualU^.id, actualC^.id]));

      // Enlaces entre correos
      if actualC^.siguiente <> nil then
      begin
        Writeln(f, Format('C%d -> C%d;', [actualC^.id, actualC^.siguiente^.id]));
        Writeln(f, Format('C%d -> C%d [dir=back];', [actualC^.siguiente^.id, actualC^.id]));
      end;

      actualC := actualC^.siguiente;
    end;

    actualU := actualU^.siguiente;
    Inc(count);
  end;

  Writeln(f, '}');
  CloseFile(f);
end;

end.
