program PTesteComercio;

uses
  Forms,
  UPrincipal in 'UPrincipal.pas' {Form1},
  UDmPrincipal in 'UDmPrincipal.pas' {DmComercio: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDmComercio, DmComercio);
  Application.Run;
end.
