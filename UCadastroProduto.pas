unit UCadastroProduto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DB, DBCtrls, StdCtrls, Buttons, Grids, DBGrids, Mask,
  ComCtrls, UDmPrincipal, DBClient, uEnum, Math;


type
  TFrmCadastroProduto = class(TForm)
    pnlRodaPe: TPanel;
    btnNovo: TBitBtn;
    btnAlterar: TBitBtn;
    btnGravar: TBitBtn;
    btnApagar: TBitBtn;
    btnFechar: TBitBtn;
    btnNavigator: TDBNavigator;
    btnCancelar: TBitBtn;
    pnlCentro: TPanel;
    pgcPrincipal: TPageControl;
    tabListagem: TTabSheet;
    pnlListagemTopo: TPanel;
    lblIndice: TLabel;
    EdtPesquisa: TMaskEdit;
    btnPesquisa: TBitBtn;
    pnlListagemCentro: TPanel;
    DbgListagem: TDBGrid;
    tabManutencao: TTabSheet;
    Label1: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    EdtCodProduto: TDBEdit;
    DbeCodFornecedor: TDBEdit;
    DbeDescFornecedor: TDBEdit;
    RdgSituacao: TDBRadioGroup;
    DBECNPJ: TDBEdit;
    DbeDtFabricacao: TDBEdit;
    DbeDataValidade: TDBEdit;
    edtDescricao: TDBEdit;
    procedure DbgListagemKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DbgListagemTitleClick(Column: TColumn);
    procedure btnPesquisaClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
    procedure DbgListagemDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DbgListagemDblClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    SelectOriginal:String;
    function EhCNPJValido(pCNPJ : string) : Boolean;
    function TextoVazio(Texto: string): Boolean;
    function Gravar(EstadoDoCadastro:TEstadoDoCadastro):boolean; virtual;
    function ValidarRegistro: Boolean;
    procedure ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar,
      btnApagar: TBitBtn; btnNavigator: TDBNavigator;
      pgcPrincipal: TPageControl; Flag: Boolean);
    procedure ControlaIndiceTab(pgcPrincipal: TPageControl; i: Integer);
    procedure EnterComoTab(Sender: TObject; var Key: Char);
  public
    { Public declarations }
    EstadoDoCadastro:TEstadoDoCadastro;
  end;

var
  FrmCadastroProduto: TFrmCadastroProduto;

implementation

{$R *.dfm}

procedure TFrmCadastroProduto.ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar,
                          btnApagar:TBitBtn; btnNavigator:TDBNavigator;
                          pgcPrincipal:TPageControl; Flag:Boolean);
begin
  btnNovo.Enabled      :=Flag;
  btnApagar.Enabled    :=Flag;
  btnAlterar.Enabled   :=Flag;
  btnNavigator.Enabled :=Flag;
  pgcPrincipal.Pages[0].TabVisible:=Flag;
  btnCancelar.Enabled  :=not(Flag);
  btnGravar.Enabled    :=not(Flag);
end;

procedure TFrmCadastroProduto.ControlaIndiceTab(pgcPrincipal:TPageControl; i: Integer);
begin
  if (pgcPrincipal.Pages[i].TabVisible) then
    pgcPrincipal.TabIndex:=0;
  tabManutencao.Enabled := not pgcPrincipal.Pages[i].TabVisible;
end;

function TFrmCadastroProduto.Gravar(EstadoDoCadastro: TEstadoDoCadastro): boolean;
begin
  try
    with DmComercio.CdsProduto do
      if State=dsInsert then
      begin
        Post;
        ApplyUpdates(-1);
        ShowMessage('Gravado com Sucesso!');
        Refresh;
        result:= True;
      end
      else if State=dsEdit then
      begin
        Post;
        ApplyUpdates(-1);
        ShowMessage('Alterado com Sucesso!');
        result:= True;
      end
     else
     begin
       ShowMessage('Não houve modificação no registro!');
       result:= false;
    end
  except
    on E: Exception do
      begin
        result:= false;
        ShowMessage('Erro ao gravar os dados ' + #13#10 + E.message);
      end;
  end;
end;

procedure TFrmCadastroProduto.DbgListagemKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Key = 46) Then
    KEY := 0;
end;

procedure TFrmCadastroProduto.btnFecharClick(Sender: TObject);
begin
  if (Application.MessageBox( 'Deseja Cancelar e Sair?',
                              'Atenção', MB_YESNO + MB_ICONQUESTION) = idYes) then
    Close;
end;

procedure TFrmCadastroProduto.FormCreate(Sender: TObject);
begin
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, true);
  DbgListagem.Options:=[dgTitles,
                        dgIndicator,
                        dgColumnResize,
                        dgColLines,
                        dgRowLines,
                        dgTabs,
                        dgRowSelect,
                        dgAlwaysShowSelection,
                        dgCancelOnExit];

  if DmComercio.CdsProduto.Active then
    DmComercio.CdsProduto.Close;

  DmComercio.CdsProduto.Open;
end;

procedure TFrmCadastroProduto.FormShow(Sender: TObject);
begin
  ControlaIndiceTab(pgcPrincipal, 0);

  SelectOriginal:='Select * from db_comercio.dbo.produto';
  DmComercio.CdsProduto.Close;
  DmComercio.CdsProduto.CommandText := SelectOriginal;
  DmComercio.CdsProduto.Open;
  DbgListagemTitleClick(DbgListagem.Columns[0]);
  EdtPesquisa.SetFocus;
end;

procedure TFrmCadastroProduto.DbgListagemTitleClick(Column: TColumn);
begin
  DmComercio.CdsProduto.IndexFieldNames := Column.FieldName;
  lblIndice.Caption := DmComercio.CdsProduto.FieldByName(Column.FieldName).DisplayLabel;
end;

procedure TFrmCadastroProduto.btnPesquisaClick(Sender: TObject);
var i:Integer;
    TipoCampo:TFieldType;
    NomeCampo:String;
    WhereOrAnd:String;
    CondicaoSQL:String;
begin

  if EdtPesquisa.Text='' then
  begin
    DmComercio.CdsProduto.Close;
    DmComercio.CdsProduto.CommandText:='';
    DmComercio.CdsProduto.CommandText:= SelectOriginal;
    DmComercio.CdsProduto.Open;
    Abort;
  end;

  for I := 0 to DmComercio.CdsProduto.FieldCount-1 do
  begin
    if DmComercio.CdsProduto.Fields[i].FieldName = DmComercio.CdsProduto.IndexFieldNames then
    begin
      TipoCampo := DmComercio.CdsProduto.Fields[i].DataType;
      NomeCampo := DmComercio.CdsProduto.Fields[i].FieldName;
      Break;
    end;
  end;

  if Pos('where',LowerCase(SelectOriginal)) > 1 then
    WhereOrAnd := ' and '
  else
    WhereOrAnd := ' where ';

  if (TipoCampo=ftString) or (TipoCampo=ftWideString) then
  begin
     try
       CondicaoSQL := WhereOrAnd+' '+ NomeCampo + ' LIKE '+QuotedStr(EdtPesquisa.Text+'%')
     except
        on E: Exception do
        begin
          ShowMessage('Digite um valor válido para a consulta do registro!');
          EdtPesquisa.SetFocus;
          Exit;
        end;
     end;

  end
  else if (TipoCampo = ftInteger) or (TipoCampo = ftSmallint) or (TipoCampo =ftAutoInc) then
  begin
    try
      CondicaoSQL := WhereOrAnd+' '+NomeCampo + '='+ IntToStr(StrToInt(edtPesquisa.Text))
    except
      on E: Exception do
        begin
          ShowMessage('Digite um valor inteiro para a consulta do registro!');
          EdtPesquisa.SetFocus;
          Exit;
        end;
    end;
  end
  else if (TipoCampo = ftDate) or (TipoCampo = ftDateTime) and (Length(EdtPesquisa.Text) = 10)then
  begin
    try
      CondicaoSQL := WhereOrAnd+' '+NomeCampo + ' = '+QuotedStr(FormatDateTime('dd.mm.yyyy', StrToDate(EdtPesquisa.Text)))
    except
      on E: Exception do
        begin
          ShowMessage('Digite uma data válida para a consulta do registro!');
          EdtPesquisa.SetFocus;
          Exit;
        end;
    end;
  end;

  try
    DmComercio.CdsProduto.Close;
    DmComercio.CdsProduto.CommandText:= '';
    DmComercio.CdsProduto.CommandText:=SelectOriginal;
    DmComercio.CdsProduto.CommandText:= DmComercio.CdsProduto.CommandText + ' '+CondicaoSQL;
    DmComercio.CdsProduto.Open;
  except
    on E: Exception do
       ShowMessage('Erro ao consultar registro: ' + #13#10 + E.message);
  end;
end;

procedure TFrmCadastroProduto.btnNovoClick(Sender: TObject);
begin
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, false);
  EstadoDoCadastro:=ecInserir;
  DmComercio.CdsProduto.Insert;
  RdgSituacao.ItemIndex :=0;
  edtDescricao.SetFocus;
end;

procedure TFrmCadastroProduto.btnAlterarClick(Sender: TObject);
begin
 if not DmComercio.CdsProduto.IsEmpty then
 begin
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, False);
  ControlaIndiceTab(pgcPrincipal, 0);
  EstadoDoCadastro:=ecAlterar;
  edtDescricao.SetFocus;
 end
 else
   ShowMessage('Não existe registro selecionado a ser alterado!');
end;

procedure TFrmCadastroProduto.btnCancelarClick(Sender: TObject);
begin
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, true);
  ControlaIndiceTab(pgcPrincipal, 0);
  EstadoDoCadastro:=ecNenhum;
  DmComercio.CdsProduto.Cancel;
end;

procedure TFrmCadastroProduto.btnGravarClick(Sender: TObject);
begin
  if (ValidarRegistro) then
    try
      if Gravar(EstadoDoCadastro) then
      begin
        ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, true);
        ControlaIndiceTab(pgcPrincipal, 0);
        EstadoDoCadastro:=ecNenhum;
        if EstadoDoCadastro = ecInserir then
          edtDescricao.SetFocus;
      end;
    except
      on E: Exception do
        ShowMessage('Erro ao Gravar: ' + #13#10 + E.message);
  end;
end;

procedure TFrmCadastroProduto.btnApagarClick(Sender: TObject);
begin
  try
    if not DmComercio.CdsProduto.IsEmpty then
    begin
      try
        if (Application.MessageBox( 'Confirma atualizar a situação do produto?',
                                    'Atenção', MB_YESNO + MB_ICONWARNING) = idYes) then

        begin
          DmComercio.CdsProduto.Edit;
          DmComercio.CdsProdutosituacao_produto.AsString :='I';
          DmComercio.CdsProduto.Post;
          DmComercio.CdsProduto.ApplyUpdates(-1);
          DmComercio.CdsProduto.Refresh;
          ShowMessage('Registro excluído com sucesso!');
        end
        else
          DmComercio.CdsProduto.Cancel;
      except
        on E: Exception do
           ShowMessage('Erro ao excluir: ' + #13#10 + E.message);
      end;
    end
    else
      ShowMessage('Não existe registro selecionado a ser excluído!');
  finally
    EstadoDoCadastro:=ecNenhum;
  end;
end;

function TFrmCadastroProduto.ValidarRegistro: Boolean;
begin
  Result := False;

  if (TextoVazio(edtDescricao.Text)) then
  begin
    ShowMessage('Descrição do produdo inváiida!');
    edtDescricao.SetFocus;
    Exit;
  end;

  if (StrToDateTimeDef(DbeDtFabricacao.Text, 0) = 0) then
  begin
    ShowMessage('Data de Fabricação inválida!');
    DbeDtFabricacao.SetFocus;
    Exit;
  end;

  if (StrToDateTimeDef(DbeDataValidade.Text, 0) = 0) then
  begin
    ShowMessage('Data de Validade inválida!');
    DbeDataValidade.SetFocus;
    Exit;
  end;

  if (StrToDate(DbeDtFabricacao.Text) >= NOW) then
  begin
    ShowMessage ('A data de fabricação não pode ser maior que a data atual!');
    DbeDtFabricacao.SetFocus;
    Exit;
  end;

  if (StrToDate(DbeDtFabricacao.Text) >= StrToDate(DbeDataValidade.Text)) then
  begin
    ShowMessage ('A data de fabricação não pode ser maior ou igual a data de validade!');
    DbeDtFabricacao.SetFocus;
    Exit;
  end;

  if not (TextoVazio(DBECNPJ.Text)) then
    if not EhCNPJValido(DBECNPJ.Text) then
    begin
      ShowMessage('O CNPJ não é válido.');
      DBECNPJ.SetFocus;
      Exit;
    end;

  Result := True;
end;

function TFrmCadastroProduto.TextoVazio(Texto: string): Boolean;
begin
  Texto := Trim(Texto);
  Result := (Texto = '');
end;

procedure TFrmCadastroProduto.DbgListagemDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if not DbgListagem.DataSource.DataSet.Active  then
   exit;

  if not odd(DbgListagem.DataSource.DataSet.RecNo) then
    if not (gdSelected in State) then
    begin
      DbgListagem.Canvas.Brush.Color := $00FFEFDF;
      DbgListagem.Canvas.FillRect(Rect);
      DbgListagem.DefaultDrawDataCell(Rect,Column.Field,State);
    end;
end;

procedure TFrmCadastroProduto.DbgListagemDblClick(Sender: TObject);
begin
  btnAlterarClick(btnAlterar);
end;

procedure TFrmCadastroProduto.EnterComoTab(Sender: TObject; var Key: Char);
begin
  if Key = '''' then
    Key := '´';
  if Key = #13 then
    SelectNext(TWinControl(Sender), True, True);
end;

procedure TFrmCadastroProduto.FormKeyPress(Sender: TObject; var Key: Char);
begin
  EnterComoTab(Sender, Key);
end;

function TFrmCadastroProduto.EhCNPJValido(pCNPJ : string) : Boolean;
var
  v: array[1..2] of Word;
  cnpj: array[1..14] of Byte;
  I: Byte;
begin
  Result := False;

  if Length(pCNPJ) <> 14 then
  begin
    Exit;
  end;

  if pCNPJ = StringOfChar('0', 14) then
    Exit;
 
  if pCNPJ = StringOfChar('1', 14) then
    Exit;
 
  if pCNPJ = StringOfChar('2', 14) then
    Exit;
 
  if pCNPJ = StringOfChar('3', 14) then
    Exit;
 
  if pCNPJ = StringOfChar('4', 14) then
    Exit;
 
  if pCNPJ = StringOfChar('5', 14) then
    Exit;
 
  if pCNPJ = StringOfChar('6', 14) then
    Exit;
 
  if pCNPJ = StringOfChar('7', 14) then
    Exit;
 
  if pCNPJ = StringOfChar('8', 14) then
    Exit;
 
  if pCNPJ = StringOfChar('9', 14) then
    Exit;
 
  try
    for I := 1 to 14 do
      cnpj[i] := StrToInt(pCNPJ[i]);

    v[1] := 5*cnpj[1] + 4*cnpj[2]  + 3*cnpj[3]  + 2*cnpj[4];
    v[1] := v[1] + 9*cnpj[5] + 8*cnpj[6]  + 7*cnpj[7]  + 6*cnpj[8];
    v[1] := v[1] + 5*cnpj[9] + 4*cnpj[10] + 3*cnpj[11] + 2*cnpj[12];
    v[1] := 11 - v[1] mod 11;
    v[1] := IfThen(v[1] >= 10, 0, v[1]);

    v[2] := 6*cnpj[1] + 5*cnpj[2]  + 4*cnpj[3]  + 3*cnpj[4];
    v[2] := v[2] + 2*cnpj[5] + 9*cnpj[6]  + 8*cnpj[7]  + 7*cnpj[8];
    v[2] := v[2] + 6*cnpj[9] + 5*cnpj[10] + 4*cnpj[11] + 3*cnpj[12];
    v[2] := v[2] + 2*v[1];
    v[2] := 11 - v[2] mod 11;
    v[2] := IfThen(v[2] >= 10, 0, v[2]);

    Result := ((v[1] = cnpj[13]) and (v[2] = cnpj[14]));
  except on E: Exception do
    Result := False;
  end;
end;

end.
