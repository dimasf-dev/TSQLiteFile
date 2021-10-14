unit SQLitefile;

interface

  uses
    Classes,ZConnection, ZDataset, DB, SysUtils;

type
  TSQLitefile = class(TComponent)
  private
    { Private declarations }

    vvo_conn:TZConnection;
    vvo_qry_write:TZQuery;
    vvo_qry_read:TZReadOnlyQuery;

  public
    { Public declarations }

    function ReadString(pls_secao,pls_campo,pls_padrao:string):string;
    function ReadInteger(pls_secao,pls_campo:string;pli_padrao:Integer):Integer;
    function ReadBool(pls_secao,pls_campo:string;plb_padrao:Boolean):Boolean;
    function ReadDateTime(pls_secao,pls_campo:string;pld_padrao:TDateTime):TDateTime;
    function ReadCurr(pls_secao,pls_campo:string;plc_padrao:Currency):Currency;
    function ReadFloat(pls_secao,pls_campo:string;plf_padrao:Extended):Extended;

    procedure WriteString(pls_secao,pls_campo,pls_valor:string);
    procedure WriteInteger(pls_secao,pls_campo:string;pli_valor:Integer);
    procedure WriteBool(pls_secao,pls_campo:string;plb_valor:Boolean);
    procedure WriteDateTime(pls_secao,pls_campo:string;pld_valor:TDateTime);
    procedure WriteCurr(pls_secao,pls_campo:string;plc_valor:Currency);
    procedure WriteFloat(pls_secao,pls_campo:string;plf_valor:Extended);

    constructor Create(pls_arquivo:string); overload;
    destructor Destroy; override;

  end;

implementation

{ TSQLitefile }

constructor TSQLitefile.Create(pls_arquivo: string);
begin
  inherited Create(nil);

  vvo_conn:=TZConnection.Create(Self);
  vvo_conn.Protocol:='sqlite-3';
  vvo_conn.Database:=pls_arquivo;

  vvo_qry_write:=TZQuery.Create(Self);
  vvo_qry_write.Connection:=vvo_conn;

  vvo_qry_read:=TZReadOnlyQuery.Create(Self);
  vvo_qry_read.Connection:=vvo_conn;

  if(not FileExists(pls_arquivo)) then
  begin
    vvo_conn.Connect;

    vvo_qry_read.SQL.Text:=''#13+
      'CREATE TABLE "main"."tb_ini" ('#13+
      ' "secao" CHAR(256) NOT NULL ,'#13+
      ' "campo" CHAR(256) NOT NULL ,'#13+
      ' "valor" VARCHAR(8000) ,'#13+
      ' PRIMARY KEY ("secao", "campo"))';

    vvo_qry_read.ExecSQL;

  end else
    vvo_conn.Connect;

  vvo_qry_read.SQL.Text:=''#13+
    'select'#13+
    '  secao,'#13+
    '  campo,'#13+
    '  valor'#13+
    'from'#13+
    '  tb_ini ti'#13+
    'where'#13+
    '  ti.secao = :secao and'#13+
    '  ti.campo = :campo';

  vvo_qry_write.SQL.Text:=''#13+
    'select'#13+
    '  secao,'#13+
    '  campo,'#13+
    '  valor'#13+
    'from'#13+
    '  tb_ini ti'#13+
    'where'#13+
    '  ti.secao = :secao and'#13+
    '  ti.campo = :campo';

end;

destructor TSQLitefile.Destroy;
begin
  vvo_qry_write.Close;
  vvo_qry_read.Close;
  vvo_conn.Disconnect;
  inherited;
end;

function TSQLitefile.ReadBool(pls_secao, pls_campo: string;
  plb_padrao: Boolean): Boolean;
begin
  Result:=plb_padrao;

  vvo_qry_read.ParamByName('secao').AsString:=pls_secao;
  vvo_qry_read.ParamByName('campo').AsString:=pls_campo;
  vvo_qry_read.Close;
  vvo_qry_read.Open;

  if(not vvo_qry_read.IsEmpty) then
    Result:=vvo_qry_read.FieldByName('valor').AsBoolean;
end;

function TSQLitefile.ReadCurr(pls_secao, pls_campo: string;
  plc_padrao: Currency): Currency;
begin
  Result:=plc_padrao;

  vvo_qry_read.ParamByName('secao').AsString:=pls_secao;
  vvo_qry_read.ParamByName('campo').AsString:=pls_campo;
  vvo_qry_read.Close;
  vvo_qry_read.Open;

  if(not vvo_qry_read.IsEmpty) then
    Result:=vvo_qry_read.FieldByName('valor').AsCurrency;
end;

function TSQLitefile.ReadDateTime(pls_secao, pls_campo: string;
  pld_padrao: TDateTime): TDateTime;
begin
  Result:=pld_padrao;

  vvo_qry_read.ParamByName('secao').AsString:=pls_secao;
  vvo_qry_read.ParamByName('campo').AsString:=pls_campo;
  vvo_qry_read.Close;
  vvo_qry_read.Open;

  if(not vvo_qry_read.IsEmpty) then
    Result:=vvo_qry_read.FieldByName('valor').AsDateTime;
end;

function TSQLitefile.ReadFloat(pls_secao, pls_campo: string;
  plf_padrao: Extended): Extended;
begin
  Result:=plf_padrao;

  vvo_qry_read.ParamByName('secao').AsString:=pls_secao;
  vvo_qry_read.ParamByName('campo').AsString:=pls_campo;
  vvo_qry_read.Close;
  vvo_qry_read.Open;

  if(not vvo_qry_read.IsEmpty) then
    Result:=vvo_qry_read.FieldByName('valor').AsFloat;
end;

function TSQLitefile.ReadInteger(pls_secao, pls_campo: string;
  pli_padrao: Integer): Integer;
begin
  Result:=pli_padrao;

  vvo_qry_read.ParamByName('secao').AsString:=pls_secao;
  vvo_qry_read.ParamByName('campo').AsString:=pls_campo;
  vvo_qry_read.Close;
  vvo_qry_read.Open;

  if(not vvo_qry_read.IsEmpty) then
    Result:=vvo_qry_read.FieldByName('valor').AsInteger;
end;

function TSQLitefile.ReadString(pls_secao, pls_campo, pls_padrao:string):string;
begin
  Result:=pls_padrao;

  vvo_qry_read.ParamByName('secao').AsString:=pls_secao;
  vvo_qry_read.ParamByName('campo').AsString:=pls_campo;
  vvo_qry_read.Close;
  vvo_qry_read.Open;

  if(not vvo_qry_read.IsEmpty) then
    Result:=vvo_qry_read.FieldByName('valor').AsString;
end;

procedure TSQLitefile.WriteBool(pls_secao, pls_campo: string;
  plb_valor: Boolean);
begin
  vvo_qry_write.ParamByName('secao').AsString:=pls_secao;
  vvo_qry_write.ParamByName('campo').AsString:=pls_campo;
  vvo_qry_write.Close;
  vvo_qry_write.Open;

  vvo_qry_write.Edit;

  vvo_qry_write.FieldByName('secao').AsString:=pls_secao;
  vvo_qry_write.FieldByName('campo').AsString:=pls_campo;
  vvo_qry_write.FieldByName('valor').AsBoolean:= plb_valor;

  vvo_qry_write.Post;
end;

procedure TSQLitefile.WriteCurr(pls_secao, pls_campo: string;
  plc_valor: Currency);
begin
  vvo_qry_write.ParamByName('secao').AsString:=pls_secao;
  vvo_qry_write.ParamByName('campo').AsString:=pls_campo;
  vvo_qry_write.Close;
  vvo_qry_write.Open;

  vvo_qry_write.Edit;

  vvo_qry_write.FieldByName('secao').AsString:=pls_secao;
  vvo_qry_write.FieldByName('campo').AsString:=pls_campo;
  vvo_qry_write.FieldByName('valor').AsCurrency:= plc_valor;

  vvo_qry_write.Post;
end;

procedure TSQLitefile.WriteDateTime(pls_secao, pls_campo: string;
  pld_valor: TDateTime);
begin
  vvo_qry_write.ParamByName('secao').AsString:=pls_secao;
  vvo_qry_write.ParamByName('campo').AsString:=pls_campo;
  vvo_qry_write.Close;
  vvo_qry_write.Open;

  vvo_qry_write.Edit;

  vvo_qry_write.FieldByName('secao').AsString:=pls_secao;
  vvo_qry_write.FieldByName('campo').AsString:=pls_campo;
  vvo_qry_write.FieldByName('valor').AsDateTime:= pld_valor;

  vvo_qry_write.Post;
end;

procedure TSQLitefile.WriteFloat(pls_secao, pls_campo: string;
  plf_valor: Extended);
begin
  vvo_qry_write.ParamByName('secao').AsString:=pls_secao;
  vvo_qry_write.ParamByName('campo').AsString:=pls_campo;
  vvo_qry_write.Close;
  vvo_qry_write.Open;

  vvo_qry_write.Edit;

  vvo_qry_write.FieldByName('secao').AsString:=pls_secao;
  vvo_qry_write.FieldByName('campo').AsString:=pls_campo;
  vvo_qry_write.FieldByName('valor').AsFloat:= plf_valor;

  vvo_qry_write.Post;
end;

procedure TSQLitefile.WriteInteger(pls_secao, pls_campo: string;
  pli_valor: Integer);
begin
  vvo_qry_write.ParamByName('secao').AsString:=pls_secao;
  vvo_qry_write.ParamByName('campo').AsString:=pls_campo;
  vvo_qry_write.Close;
  vvo_qry_write.Open;

  vvo_qry_write.Edit;

  vvo_qry_write.FieldByName('secao').AsString:=pls_secao;
  vvo_qry_write.FieldByName('campo').AsString:=pls_campo;
  vvo_qry_write.FieldByName('valor').AsInteger:= pli_valor;

  vvo_qry_write.Post;
end;

procedure TSQLitefile.WriteString(pls_secao, pls_campo,
  pls_valor: string);
begin
  vvo_qry_write.ParamByName('secao').AsString:=pls_secao;
  vvo_qry_write.ParamByName('campo').AsString:=pls_campo;
  vvo_qry_write.Close;
  vvo_qry_write.Open;

  vvo_qry_write.Edit;

  vvo_qry_write.FieldByName('secao').AsString:=pls_secao;
  vvo_qry_write.FieldByName('campo').AsString:=pls_campo;
  vvo_qry_write.FieldByName('valor').AsString:= pls_valor;

  vvo_qry_write.Post;
end;

end.
