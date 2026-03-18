unit unitabout;

{$mode ObjFPC}{$H+}

interface

uses
  Classes , SysUtils , Forms , Controls , Graphics , Dialogs , ExtCtrls ,
  StdCtrls;

type

  { TFormAbout }

  TFormAbout = class(TForm)
    ImageAbout: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Memo1: TMemo;
  private

  public

  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.lfm}

{ TFormAbout }


end.

