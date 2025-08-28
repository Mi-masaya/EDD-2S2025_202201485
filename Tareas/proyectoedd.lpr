program proyectoedd;

{$mode objfpc}{$H+}

uses
  SysUtils, usuarios, correos, main;

var
  listaUsuarios: PUsuario;
begin

  // Cargar usuarios y correos
  listaUsuarios := CargarUsuarios('usuarios.json');
  CargarCorreos('correos.json', listaUsuarios);

  // Graficar usuarios
  GraficarUsuarios(listaUsuarios, 'usuarios.dot');
  Writeln('Se generó usuarios.dot');

  // Graficar 2 usuarios
  GraficarCorreosUsuarios(listaUsuarios, 'correos.dot', 2);
  Writeln('Se generó correos.dot');

  Writeln('Usa Graphviz para convertir .dot a .png');
end.
