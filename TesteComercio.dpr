program TesteComercio;

uses
  Forms,
  UDmPrincipal in 'UDmPrincipal.pas' {DmComercio: TDataModule},
  UCadastroProduto in 'UCadastroProduto.pas' {FrmCadastroProduto};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDmComercio, DmComercio);
  Application.CreateForm(TFrmCadastroProduto, FrmCadastroProduto);
  Application.Run;
end.
