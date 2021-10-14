unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  SQLitefile;

type

  { TForm1 }

  TForm1 = class(TForm)
    BntLoad: TButton;
    BntSave: TButton;
    EdtInfo: TEdit;
    procedure BntLoadClick(Sender: TObject);
    procedure BntSaveClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BntLoadClick(Sender: TObject);
var
  vloIniFile:TSQLitefile;
begin
  try
    vloIniFile:= TSQLitefile.Create('sample.ini');
    EdtInfo.Text:=vloIniFile.ReadString('mySession','myField','default_value');
    Application.MessageBox('Successfully loaded','Success');
  finally
    vloIniFile.Free;
  end;
end;

procedure TForm1.BntSaveClick(Sender: TObject);
var
  vloIniFile:TSQLitefile;
begin
  try
    vloIniFile:= TSQLitefile.Create('sample.ini');
    vloIniFile.WriteString('mySession','myField',EdtInfo.Text);
    Application.MessageBox('Saved successfully','Success');
  finally
    vloIniFile.Free;
  end;
end;

end.

