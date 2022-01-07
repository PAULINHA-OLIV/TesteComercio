object DmComercio: TDmComercio
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 441
  Top = 167
  Height = 336
  Width = 252
  object ADOComercio: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Persist Security Info=True;User ID=sa;Initia' +
      'l Catalog=DB_COMERCIO;Data Source=DESKTOP-E70VDM9\SQLEXPRESS'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 152
    Top = 40
  end
  object DtsProduto: TDataSource
    DataSet = CdsProduto
    Left = 152
    Top = 232
  end
  object CdsProduto: TClientDataSet
    Aggregates = <>
    CommandText = 'Select * from db_comercio.dbo.produto'
    Params = <>
    ProviderName = 'Produto'
    Left = 152
    Top = 184
    object CdsProdutoprodutoId: TAutoIncField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'produtoId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
      Required = True
    end
    object CdsProdutodescricao_produto: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'descricao_produto'
      ProviderFlags = [pfInUpdate]
      Size = 255
    end
    object CdsProdutosituacao_produto: TStringField
      DisplayLabel = 'Situa'#231#227'o'
      FieldName = 'situacao_produto'
      ProviderFlags = [pfInUpdate]
      FixedChar = True
      Size = 1
    end
    object CdsProdutodata_fabricacao: TDateTimeField
      DisplayLabel = 'Data Fabrica'#231#227'o'
      FieldName = 'data_fabricacao'
      ProviderFlags = [pfInUpdate]
      OnSetText = CdsProdutodata_fabricacaoSetText
      EditMask = '!99/99/0000;1;_'
    end
    object CdsProdutodata_validade_produto: TDateTimeField
      DisplayLabel = 'Data Validade'
      FieldName = 'data_validade_produto'
      ProviderFlags = [pfInUpdate]
      OnSetText = CdsProdutodata_validade_produtoSetText
      EditMask = '!99/99/0000;1;_'
    end
    object CdsProdutocodigo_fornecedor: TIntegerField
      DisplayLabel = 'C'#243'd. Fornecedor'
      FieldName = 'codigo_fornecedor'
      ProviderFlags = [pfInUpdate]
    end
    object CdsProdutodescricao_fornecedor: TStringField
      DisplayLabel = 'Desc. Fornecedor'
      FieldName = 'descricao_fornecedor'
      ProviderFlags = [pfInUpdate]
      Size = 100
    end
    object CdsProdutocnpj_fornecedor: TStringField
      DisplayLabel = 'CNPJ'
      FieldName = 'cnpj_fornecedor'
      ProviderFlags = [pfInUpdate]
      EditMask = '99.999.999/9999-99;0;_'
      Size = 14
    end
  end
  object Produto: TDataSetProvider
    DataSet = QryProduto
    Options = [poAllowCommandText]
    UpdateMode = upWhereKeyOnly
    Left = 152
    Top = 136
  end
  object QryProduto: TADOQuery
    Connection = ADOComercio
    CursorType = ctStatic
    Parameters = <>
    Left = 152
    Top = 88
    object QryProdutoprodutoId: TAutoIncField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'produtoId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
      Required = True
    end
    object QryProdutodescricao_produto: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'descricao_produto'
      ProviderFlags = [pfInUpdate]
      Size = 255
    end
    object QryProdutosituacao_produto: TStringField
      DisplayLabel = 'Situa'#231#227'o'
      FieldName = 'situacao_produto'
      ProviderFlags = [pfInUpdate]
      FixedChar = True
      Size = 1
    end
    object QryProdutodata_fabricacao: TDateTimeField
      DisplayLabel = 'Data Fabrica'#231#227'o'
      FieldName = 'data_fabricacao'
      ProviderFlags = [pfInUpdate]
      EditMask = '!99/99/0000;1;_'
    end
    object QryProdutodata_validade_produto: TDateTimeField
      DisplayLabel = 'Data Validade'
      FieldName = 'data_validade_produto'
      ProviderFlags = [pfInUpdate]
      EditMask = '!99/99/0000;1;_'
    end
    object QryProdutocodigo_fornecedor: TIntegerField
      DisplayLabel = 'C'#243'd. Fornecedor'
      FieldName = 'codigo_fornecedor'
      ProviderFlags = [pfInUpdate]
    end
    object QryProdutodescricao_fornecedor: TStringField
      DisplayLabel = 'Desc. Fornecedor'
      FieldName = 'descricao_fornecedor'
      ProviderFlags = [pfInUpdate]
      Size = 100
    end
    object QryProdutocnpj_fornecedor: TStringField
      DisplayLabel = 'CNPJ'
      FieldName = 'cnpj_fornecedor'
      ProviderFlags = [pfInUpdate]
      EditMask = '99.999.999/9999-99;0;_'
      Size = 14
    end
  end
end
