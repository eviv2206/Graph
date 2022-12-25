unit uVisualisation;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
   Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Controls;

type
  TfrmVisual = class(TForm)
    PaintArea: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmVisual: TfrmVisual;

implementation

{$R *.dfm}

end.
