unit unitMain;

{$mode objfpc}{$H+}

interface

uses
  Classes , SysUtils , Forms , Controls , Graphics , Dialogs , ExtCtrls ,
  StdCtrls , ComCtrls , Spin , Menus , ExtDlgs , Buttons , PrintersDlgs,
  Math, Printers, unitabout;

const
  MMperINCH = 25.4;

type

  { TFormMain }

  TFormMain = class(TForm)
    BitBtn100: TBitBtn;
    BitBtnIn: TBitBtn;
    BitBtnOut: TBitBtn;
    BitBtnFit: TBitBtn;
    CheckBoxGridVisible: TCheckBox;
    ColorButtonSuport: TColorButton;
    ColorButtonGrid: TColorButton;
    ColorDialogSuport: TColorDialog;
    Cor1: TLabel;
    FloatSpinEditWidth: TFloatSpinEdit;
    FloatSpinEditHeight: TFloatSpinEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Cor: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    LabelZoom: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItemAbout: TMenuItem;
    MenuItemPrint: TMenuItem;
    MenuItemSave: TMenuItem;
    MenuItemOpen: TMenuItem;
    MenuItemExit: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    PageControl1: TPageControl;
    PaintBox1: TPaintBox;
    PrintDialog1: TPrintDialog;
    SavePictureDialog1: TSavePictureDialog;
    ScrollBox1: TScrollBox;
    SpeedButtonPrint: TSpeedButton;
    SpeedButtonOpen: TSpeedButton;
    SpeedButtonSave: TSpeedButton;
    SpinEditGridV: TSpinEdit;
    SpinEditGridH: TSpinEdit;
    SpinEditLineWidth: TSpinEdit;
    SpinEditGridLineWidth: TSpinEdit;
    StatusBar1: TStatusBar;
    TabSheetGrid: TTabSheet;
    TabSheetSuport: TTabSheet;
    ToolBar1: TToolBar;
    procedure BitBtn100Click(Sender: TObject);
    procedure BitBtnFitClick(Sender: TObject);
    procedure BitBtnInClick(Sender: TObject);
    procedure BitBtnOutClick(Sender: TObject);
    procedure CheckBoxGridVisibleChange(Sender: TObject);
    procedure ColorButtonGridColorChanged(Sender: TObject);
    procedure FloatSpinEditHeightEditingDone(Sender: TObject);
    procedure FloatSpinEditWidthEditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuItemAboutClick(Sender: TObject);
    procedure MenuItemPrintClick(Sender: TObject);
    procedure MenuItemExitClick(Sender: TObject);
    procedure MenuItemOpenClick(Sender: TObject);
    procedure MenuItemSaveClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure SpeedButtonExitClick(Sender: TObject);
    procedure SpeedButtonOpenClick(Sender: TObject);
    procedure SpeedButtonPrintClick(Sender: TObject);
    procedure SpeedButtonSaveClick(Sender: TObject);
    procedure SpinEditGridHChange(Sender: TObject);
    procedure SpinEditGridLineWidthChange(Sender: TObject);
    procedure SpinEditGridVChange(Sender: TObject);
    procedure SpinEditLineWidthChange(Sender: TObject);
  private
    FZoom: Double;
    FRectSuport: TRect;
    FImageOriginal: TPicture;
    FImageOriginalPath: String;

    function PxtoMM(PX: Integer; DPI: Integer): Integer;
    function MMtoPx(MM: Double; DPI: Integer): Integer;
    function MMtoScreen(MM: Double): Integer;
    function PXScreenToMM(PX: Integer): Double;
    procedure UpdateRectSuport();
    procedure DrawBackgroundImage(Target: TCanvas; R: TRect);
    procedure DrawSuport(Target: TCanvas; R: TRect);
    procedure DrawGrid(Target: TCanvas; R: TRect);
    procedure ShowZoom();
    procedure ShowFileName(DestW, DestH: Integer);

  public

  end;

var
  FormMain: TFormMain;

implementation

{$R *.lfm}

{ TFormMain }

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FImageOriginalPath := '';
  FImageOriginal := TPicture.Create;

  FZoom := 1.0; // 100%

  PageControl1.ActivePage := TabSheetSuport;

  //suport
  SpinEditLineWidth.Value := 3;
  FloatSpinEditHeight.Value := 210;
  FloatSpinEditWidth.Value := 297;
  ColorButtonSuport.ButtonColor := clRed;

  //grid
  CheckBoxGridVisible.Checked := True;
  SpinEditGridH.Value := 3;
  SpinEditGridV.Value := 3;
  SpinEditGridLineWidth.Value := 2;
  ColorButtonGrid.ButtonColor := clGreen;

  UpdateRectSuport;
  ShowZoom;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FImageOriginal.Free;
end;

procedure TFormMain.MenuItemAboutClick(Sender: TObject);
begin
  FormAbout.ShowModal;
end;

procedure TFormMain.MenuItemPrintClick(Sender: TObject);
var
  PrintBmp: TBitmap;
  i, MLeft, MTop, MRight, MButton: Integer;
  PaperName: String;
  R: TRect;
begin
  PrintBmp := TBitmap.Create;
  if PrintDialog1.Execute then // Usuário escolhe a impressora "Print to PDF"
  begin
    Printer.BeginDoc;
    try
      for i := 0 to Printer.PaperSize.SupportedPapers.Count - 1 do
      begin
        PaperName := Printer.PaperSize.SupportedPapers[i];

        if Pos('A4', UpperCase(PaperName)) > 0 then
        begin
          Printer.PaperSize.PaperName := PaperName;
        end;
      end;

      Printer.Orientation := poLandscape;

      PrintBmp.SetSize(Printer.PageWidth, Printer.PageHeight);

      // Pixel format definition to prevent color problem
      PrintBmp.PixelFormat := pf24bit; // or pf32bit

      // Paint white background to avoid it black
      PrintBmp.Canvas.Brush.Color := clWhite;
      R := Rect(0, 0, Printer.PageWidth, Printer.PageHeight);
      PrintBmp.Canvas.FillRect(R);

      // Draw and save canvas
      DrawBackgroundImage(PrintBmp.Canvas, R);
      DrawSuport(PrintBmp.Canvas, R);
      DrawGrid(PrintBmp.Canvas, R);

      //DrawCanvas(PrintBmp.Canvas, Rect(0, 0, PrintBmp.Width, PrintBmp.Height));

      // Estica a imagem para preencher a folha
      MLeft := MMtoPx(10, Printer.XDPI); // 20mm
      MTop := MMtoPx(10, Printer.YDPI);
      MRight := MMtoPx(10, Printer.XDPI);
      MButton := MMtoPx(10, Printer.YDPI);
      R := Rect(MLeft, MTop, Printer.PageWidth - MRight, Printer.PageHeight - MButton);
      //Rect(0, 0, Printer.PageWidth, Printer.PageHeight);
      Printer.Canvas.StretchDraw(R, PrintBmp);
    finally
      Printer.EndDoc;
    end;
  end;

end;

procedure TFormMain.MenuItemExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFormMain.MenuItemOpenClick(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  begin
    try
      FImageOriginalPath := OpenPictureDialog1.FileName;
      FImageOriginal.LoadFromFile(FImageOriginalPath);
    Except
      on E: Exception do
      begin
        FImageOriginalPath := '';
        FImageOriginal.Clear;
      end;
    end;
  end;
  StatusBar1.Panels[0].Text := FImageOriginalPath;
end;

procedure TFormMain.MenuItemSaveClick(Sender: TObject);
var
  FinalBmp: TBitmap;
  R: TRect;

begin
  if SavePictureDialog1.Execute then
  begin
    FinalBmp := TBitmap.Create;
    try
      FinalBmp.SetSize(FRectSuport.Width, FRectSuport.Height);

      // Pixel format definition to prevent color problem
      FinalBmp.PixelFormat := pf24bit; // or pf32bit

      // Paint white background to avoid it black
      FinalBmp.Canvas.Brush.Color := clWhite;
      R := Rect(0, 0, FinalBmp.Width, FinalBmp.Height);
      FinalBmp.Canvas.FillRect(R);

      // Draw and save canvas
      DrawBackgroundImage(FinalBmp.Canvas, R);
      DrawSuport(FinalBmp.Canvas, R);
      DrawGrid(FinalBmp.Canvas, R);
      FinalBmp.SaveToFile(SavePictureDialog1.FileName);
      ShowMessage('Imagem salva com sucesso!');
    finally
      FinalBmp.Free;
    end;
  end;

end;

procedure TFormMain.UpdateRectSuport();
var
  LeftLin, LeftCol, RightLin, RigthCol: Integer;
begin
  LeftLin := 0; //Top
  LeftCol := 0; //Left
  RightLin := MMtoScreen(FloatSpinEditHeight.Value); // Height
  RigthCol := MMtoScreen(FloatSpinEditWidth.Value);  // Width

  FRectSuport := Rect(LeftCol, LeftLin, RigthCol, RightLin);
end;

procedure TFormMain.DrawSuport(Target: TCanvas; R: TRect);
begin
  with Target do
  begin
    Pen.Color := ColorButtonSuport.ButtonColor;
    Pen.Width := SpinEditLineWidth.Value;
    Brush.Style := bsClear;
    Rectangle(R);
  end;
end;

procedure TFormMain.DrawBackgroundImage(Target: TCanvas; R: TRect);
var
  DestW, DestH: Integer;
  ImgRatio, SupRatio: Double;
  FRectTarget: TRect;

begin
  if (FImageOriginal.Graphic = nil) or (FImageOriginal.Graphic.Empty) then
    Exit;

  ImgRatio := FImageOriginal.Width / FImageOriginal.Height;
  SupRatio := R.Width / R.Height;

  if ImgRatio > SupRatio then
    begin
      // Image largest than PaintBox
      DestW := R.Width;
      DestH := Round(R.Width / ImgRatio);
    end
  else
    begin
      // Image higher than PaintBox
      DestH := R.Height;
      DestW := Round(R.Height * ImgRatio);
    end;
  ShowFileName(DestW, DestH);
  FRectTarget := Rect(0, 0, DestW, DestH);
  Target.StretchDraw(FRectTarget, FImageOriginal.Graphic);
end;

procedure TFormMain.DrawGrid(Target: TCanvas; R: TRect);
var
  DestW, DestH, DestY, DestX, X: Integer;

begin
  if CheckBoxGridVisible.Checked then
  begin
    with Target do
    begin
      Pen.Color := ColorButtonGrid.ButtonColor;
      Pen.Width := SpinEditGridLineWidth.Value;
    end;

    DestH := R.Height;
    DestW := R.Width;

    // Draw horizontal grid
    if SpinEditGridH.Value > 0 then
    begin
      DestY := (DestH div SpinEditGridH.Value);
      for X := 1 to (SpinEditGridH.Value - 1) do
      begin
        Target.MoveTo(0, DestY*X);
        Target.LineTo(DestW-1, DestY*X);
      end;
    end;

    // Draw vertical grid
    if SpinEditGridV.Value > 0 then
    begin
      DestX := (DestW div SpinEditGridV.Value);
      for X := 1 to (SpinEditGridV.Value - 1) do
      begin
        Target.MoveTo(DestX*X, 0);
        Target.LineTo(DestX*X, DestH-1);
      end;
    end;
  end;

end;

procedure TFormMain.PaintBox1Paint(Sender: TObject);
begin
  UpdateRectSuport;
  // position and resize PaintBox1 area
  PaintBox1.Left := 0;
  PaintBox1.Top := 0;
  PaintBox1.Width := abs(FRectSuport.Width - FRectSuport.Left);
  PaintBox1.Height := abs(FRectSuport.Height - FRectSuport.Top);

  DrawBackgroundImage(PaintBox1.Canvas, FRectSuport);
  DrawSuport(PaintBox1.Canvas, FRectSuport);
  DrawGrid(PaintBox1.Canvas, FRectSuport);
end;

procedure TFormMain.SpeedButtonOpenClick(Sender: TObject);
begin
  MenuItemOpen.Click;
end;

procedure TFormMain.SpeedButtonSaveClick(Sender: TObject);
begin
  MenuItemSave.Click;
end;

procedure TFormMain.SpeedButtonPrintClick(Sender: TObject);
begin
  MenuItemPrint.Click;
end;

procedure TFormMain.SpeedButtonExitClick(Sender: TObject);
begin
  MenuItemExit.Click;
end;

procedure TFormMain.SpinEditGridHChange(Sender: TObject);
begin
  PaintBox1.Refresh;
end;

procedure TFormMain.SpinEditGridLineWidthChange(Sender: TObject);
begin
  PaintBox1.Refresh;
end;

procedure TFormMain.SpinEditGridVChange(Sender: TObject);
begin
  PaintBox1.Refresh;
end;

procedure TFormMain.BitBtnInClick(Sender: TObject);
begin
  if FZoom > 0.2 then
      FZoom := FZoom - 0.1;
  ShowZoom;
  PaintBox1.Refresh;
end;

procedure TFormMain.BitBtnOutClick(Sender: TObject);
begin
  FZoom := FZoom + 0.1;
  ShowZoom;
  PaintBox1.Refresh;
end;

procedure TFormMain.CheckBoxGridVisibleChange(Sender: TObject);
begin
  PaintBox1.Refresh;
end;

procedure TFormMain.ColorButtonGridColorChanged(Sender: TObject);
begin
  PaintBox1.Refresh;
end;

procedure TFormMain.BitBtnFitClick(Sender: TObject);
var
  RatioW, RatioH: Double;
begin
  RatioW := ScrollBox1.ClientWidth / FRectSuport.Width;
  RatioH := ScrollBox1.ClientHeight / FRectSuport.Height;
  FZoom := Min(RatioW, RatioH);
  ShowZoom;
  PaintBox1.Refresh;
end;

procedure TFormMain.BitBtn100Click(Sender: TObject);
begin
  FZoom := 1.0;
  ShowZoom;
  PaintBox1.Refresh;
end;

procedure TFormMain.SpinEditLineWidthChange(Sender: TObject);
begin
  PaintBox1.Refresh;
end;

procedure TFormMain.FloatSpinEditHeightEditingDone(Sender: TObject);
begin
  PaintBox1.Refresh;
end;

procedure TFormMain.FloatSpinEditWidthEditingDone(Sender: TObject);
begin
  PaintBox1.Refresh;
end;

procedure TFormMain.ShowZoom();
var
  StrZoom: String;

begin
  Str(FZoom*100:5:1, StrZoom);
  LabelZoom.Caption := StrZoom + ' %';
end;

//TODO: Repair
function TFormMain.PXtoMM(PX: Integer; DPI: Integer): Integer;
begin
  Result := Round(PX / DPI * MMperINCH);
end;

function TFormMain.MMtoPX(MM: Double; DPI: Integer): Integer;
begin
  Result := Round(MM * DPI / MMperINCH);
end;

function TFormMain.MMtoScreen(MM: Double): Integer;
begin
  Result := Round(MMToPx(MM, Screen.PixelsPerInch) * FZoom);
end;

function TFormMain.PXScreenToMM(PX: Integer): Double;
begin
  Result := PXtoMM(PX, Screen.PixelsPerInch);
end;

procedure TFormMain.ShowFileName(DestW, DestH: Integer);
var
  Wmm, Hmm: Double;
  SWmm, SHmm, SFile: String;

begin
  SFile := '';
  if FImageOriginalPath <> '' then
  begin
      Wmm := PXScreenToMM(DestW);
      Hmm := PXScreenToMM(DestH);
      Str(Wmm:6:1, SWmm);
      Str(Hmm:6:1, SHmm);
      SFile := '(' + SWmm + 'mm x ' + SHmm + 'mm) ' + FImageOriginalPath;
  end;
  StatusBar1.Panels[0].Text := SFile;
end;

end.

