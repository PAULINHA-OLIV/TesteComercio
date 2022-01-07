unit UDmPrincipal;

interface

uses
  SysUtils, Classes, DB, ADODB, Provider, DBClient, DBXpress, SqlExpr, Dialogs,
  IniFiles, Forms, Windows;

type
  TDmComercio = class(TDataModule)
    ADOComercio: TADOConnection;
    DtsProduto: TDataSource;
    CdsProduto: TClientDataSet;
    Produto: TDataSetProvider;         
    QryProduto: TADOQuery;
    CdsProdutoprodutoId: TAutoIncField;
    CdsProdutodescricao_produto: TStringField;
    CdsProdutosituacao_produto: TStringField;
    CdsProdutodata_fabricacao: TDateTimeField;
    CdsProdutodata_validade_produto: TDateTimeField;
    CdsProdutocodigo_fornecedor: TIntegerField;
    CdsProdutodescricao_fornecedor: TStringField;
    CdsProdutocnpj_fornecedor: TStringField;
    QryProdutoprodutoId: TAutoIncField;
    QryProdutodescricao_produto: TStringField;
    QryProdutosituacao_produto: TStringField;
    QryProdutodata_fabricacao: TDateTimeField;
    QryProdutodata_validade_produto: TDateTimeField;
    QryProdutocodigo_fornecedor: TIntegerField;
    QryProdutodescricao_fornecedor: TStringField;
    QryProdutocnpj_fornecedor: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure ConfiguraBD;
    procedure CdsProdutodata_validade_produtoSetText(Sender: TField;
      const Text: String);
    procedure CdsProdutodata_fabricacaoSetText(Sender: TField;
      const Text: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmComercio: TDmComercio;

implementation


{$R *.dfm}

procedure TDmComercio.DataModuleCreate(Sender: TObject);
begin
  ConfiguraBD;
end;

procedure TDmComercio.ConfiguraBD;
var
 servidor, banco, usuario, senha, porta, driverServidor: string;
 arqIni : TiniFile;
begin
   ADOComercio.Connected := False;
  if not FileExists(ExtractFilePath(Application.ExeName)+'config.ini') then
    begin
      Application.MessageBox('O arquivo de configuração não foi localizado.','Atenção', MB_OK + MB_ICONERROR) ;
      Halt;
    end
    else
    begin
      arqIni := TIniFile.Create(ExtractFilePath(Application.ExeName)+'config.ini');
      servidor := arqIni.ReadString('configuracoes', 'servidor',    '');
      driverservidor := arqIni.ReadString('configuracoes', 'driver',      '');
      porta := arqIni.ReadString('configuracoes', 'porta',        '');
      banco := arqIni.ReadString('configuracoes', 'banco',    '');
      usuario := arqIni.ReadString('configuracoes', 'usuario',        '');
      senha := arqIni.ReadString('configuracoes', 'senha',    '');
      ADOComercio.ConnectionString := 'Provider='+DriverServidor+';'+
        'Persist Security Info=True;'+
        'User ID='+usuario+';'+
        'Password='+senha+';'+
        'Initial Catalog='+banco+';'+
        'Data Source='+servidor;
    end;

   try
     ADOComercio.Connected := true;
     CdsProduto.Open;
   except
      Application.MessageBox('Erro ao conectar no banco de dados', 'Atenção', MB_OK + MB_ICONERROR);
   end;

end;
procedure TDmComercio.CdsProdutodata_validade_produtoSetText(
  Sender: TField; const Text: String);
begin
  if (StrToDateTimeDef(Text, 0) = 0) then
  begin
    ShowMessage('Data de Validade inválida!');
    Exit;
  end;

end;

procedure TDmComercio.CdsProdutodata_fabricacaoSetText(Sender: TField;
  const Text: String);
begin
  if (StrToDateTimeDef(Text, 0) = 0) then
  begin
    ShowMessage('Data de Fabricação inválida!');
    Exit;
  end;

end;

end.
