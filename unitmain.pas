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
    CheckBoxSpiralVisible: TCheckBox;
    CheckBoxSquareVisible: TCheckBox;
    ColorButtonSpiral: TColorButton;
    ColorButtonSquare: TColorButton;
    ColorButtonSuport: TColorButton;
    ColorButtonGrid: TColorButton;
    ColorDialogSuport: TColorDialog;
    ComboBoxSpiralReference: TComboBox;
    Cor1: TLabel;
    Cor2: TLabel;
    Cor3: TLabel;
    FloatSpinEditWidth: TFloatSpinEdit;
    FloatSpinEditHeight: TFloatSpinEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBoxSpiralLine: TGroupBox;
    GroupBoxSquareLine: TGroupBox;
    GroupBoxSpiralQuadrant: TGroupBox;
    ImageList1: TImageList;
    Label1: TLabel;
    Label10: TLabel;
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
    SpeedButton1: TSpeedButton;
    SpeedButtonPrint: TSpeedButton;
    SpeedButtonOpen: TSpeedButton;
    SpeedButtonSave: TSpeedButton;
    SpinEditGridV: TSpinEdit;
    SpinEditGridH: TSpinEdit;
    SpinEditLineWidth: TSpinEdit;
    SpinEditGridLineWidth: TSpinEdit;
    SpinEditSquareLineWidth: TSpinEdit;
    StatusBar1: TStatusBar;
    TabSheetSpiral: TTabSheet;
    TabSheetGrid: TTabSheet;
    TabSheetSuport: TTabSheet;
    ToolBar1: TToolBar;
    procedure BitBtn100Click(Sender: TObject);
    procedure BitBtnFitClick(Sender: TObject);
    procedure BitBtnInClick(Sender: TObject);
    procedure BitBtnOutClick(Sender: TObject);
    procedure CheckBoxGridVisibleChange(Sender: TObject);
    procedure CheckBoxSpiralVisibleChange(Sender: TObject);
    procedure CheckBoxSquareVisibleChange(Sender: TObject);
    procedure ColorButtonGridColorChanged(Sender: TObject);
    procedure ColorButtonSpiralColorChanged(Sender: TObject);
    procedure ColorButtonSquareColorChanged(Sender: TObject);
    procedure ColorButtonSuportColorChanged(Sender: TObject);
    procedure ComboBoxSpiralReferenceChange(Sender: TObject);
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
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButtonExitClick(Sender: TObject);
    procedure SpeedButtonOpenClick(Sender: TObject);
    procedure SpeedButtonPrintClick(Sender: TObject);
    procedure SpeedButtonSaveClick(Sender: TObject);
    procedure SpinEditGridHChange(Sender: TObject);
    procedure SpinEditGridLineWidthChange(Sender: TObject);
    procedure SpinEditGridVChange(Sender: TObject);
    procedure SpinEditLineWidthChange(Sender: TObject);
    procedure SpinEditSpiralLineWidthChange(Sender: TObject);
    procedure SpinEditSpiralQtyChange(Sender: TObject);
    procedure SpinEditSquareLineWidthChange(Sender: TObject);
  private
    FZoom: Double;
    FRectSuport: TRect;
    FRectImage: TRect;
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
    procedure DrawSpiral(Target: TCanvas; R: TRect);
    procedure ShowZoom();
    procedure ShowFileName();
    procedure SquareArc(Target: TCanvas; Sqr: TRect; Center: Integer);
    procedure PaintBox1Refresh();

  public

  end;

  TPoint = record
    X: Integer;
    Y: Integer;
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
  ColorButtonSuport.ButtonColor := clHighlight;

  //grid
  CheckBoxGridVisible.Checked := False;
  SpinEditGridH.Value := 3;
  SpinEditGridV.Value := 3;
  SpinEditGridLineWidth.Value := 2;
  ColorButtonGrid.ButtonColor := clFuchsia;

  //spiral
  CheckBoxSpiralVisible.Checked := False;
  ColorButtonSpiral.ButtonColor := clLime;
  ComboBoxSpiralReference.ItemIndex := 0;

  //square
  CheckBoxSquareVisible.Checked := False;
  ColorButtonSquare.ButtonColor := clAqua;
  SpinEditSquareLineWidth.Value := 1;

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
  i, MLeft, MTop, MRight, MButton, PrtW, PrtH: Integer;
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

      if (FloatSpinEditWidth.Value > FloatSpinEditHeight.Value) then
          Printer.Orientation := poLandscape
      else
          Printer.Orientation := poPortrait;

      PrtW := Printer.PageWidth;
      PrtH := Printer.PageHeight;

      PrintBmp.SetSize(PrtW, PrtH);

      // Pixel format definition to prevent color problem
      PrintBmp.PixelFormat := pf24bit; // or pf32bit

      // Paint white background to avoid it black
      PrintBmp.Canvas.Brush.Color := clWhite;
      R := Rect(0, 0, PrtW, PrtH);
      PrintBmp.Canvas.FillRect(R);

      // Draw and save canvas
      DrawBackgroundImage(PrintBmp.Canvas, R);
      DrawSuport(PrintBmp.Canvas, R);
      DrawGrid(PrintBmp.Canvas, R);

      // Estica a imagem para preencher a folha
      MLeft := MMtoPx(10, Printer.XDPI); // 20mm
      MTop := MMtoPx(10, Printer.YDPI);
      MRight := MMtoPx(10, Printer.XDPI);
      MButton := MMtoPx(10, Printer.YDPI);
      R := Rect(MLeft, MTop, PrtW - MRight, PrtH - MButton);
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
      PaintBox1.Refresh;
    Except
      on E: Exception do
      begin
        FImageOriginalPath := '';
        FImageOriginal.Clear;
      end;
    end;
  end;
  PaintBox1.Refresh;
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
  ShowFileName();
  FRectImage := Rect(0, 0, DestW, DestH);
  Target.StretchDraw(FRectImage, FImageOriginal.Graphic);
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

procedure TFormMain.DrawSpiral(Target: TCanvas; R: TRect);
const
  GoldenNum = 1.618033;

var
  Pace, XArc: Integer;
  FRec, FSqr: TRect;
  RectRatio: Double;
  APen: TPen;
  TopDown, LeftToRight, isHorizontal: Boolean;
  ArcCenters: array of Integer;

begin
  // Draw spiral rectangles
  if CheckBoxSpiralVisible.Checked or CheckBoxSquareVisible.Checked then
  begin
    // quadrant definitions
    case ComboBoxSpiralReference.ItemIndex of
      0: begin // top-left
           TopDown := True;
           LeftToRight := False;
           ArcCenters := [0, 1, 3, 2];
         end;
      1: begin // bottom-left
           TopDown := False;
           LeftToRight := False;
           ArcCenters := [2, 3, 1, 0];
         end;
      2: begin // top-right
           TopDown := True;
           LeftToRight := True;
           ArcCenters := [1, 0, 2, 3];
         end;
      3: begin // bottom-right
           TopDown := False;
           LeftToRight := True;
           ArcCenters := [3, 2, 0, 1];
         end
    end;

    // adjust original retangle to aureal proportion
    FRec := R;
    RectRatio := FRec.Width / FRec.Height;
    isHorizontal := RectRatio >= 1.0;
    if isHorizontal then
      FRec.Width := Round(FRec.Height * GoldenNum)
    else
      FRec.Height := Round(FRec.Width / GoldenNum);

    // draw golden squares and spiral
    Pace := 0;
    XArc := 0;
    repeat
      // define square positioning
      case Pace of
      1: TopDown := not TopDown;
      2: begin
           LeftToRight := not LeftToRight;
           Pace := 0;
         end
      end;

      // define square coordinates
      FSqr := FRec;
      if isHorizontal then // horizontal
        begin
          if LeftToRight then
            begin
              FSqr.Width := FRec.Height;
              FRec.Left := FRec.Left + FRec.Height;
            end
          else
            begin
              FSqr.Left := FRec.Left + Abs(FRec.Width - FRec.Height);
              FRec.Width := FRec.Width - FRec.Height;
            end;
        end
      else // vertical
        begin
          if TopDown then
            begin
              FSqr.Height := FRec.Width;
              FRec.Top := FRec.Top + FSqr.Height;
            end
          else
            begin
              FSqr.Top := FRec.Top + Abs(FRec.Height - FRec.Width);
              FRec.Bottom := FSqr.Top;
            end;
        end;

      // show square
      if CheckBoxSquareVisible.Checked then
      begin
        APen := Target.Pen;
        with Target do
        begin
          Pen.Color := ColorButtonSquare.ButtonColor;
          Pen.Width := SpinEditSquareLineWidth.Value;
          Pen.Style := psDash;
          Rectangle(FSqr);
          Pen := APen;
        end;
      end;

      if CheckBoxSpiralVisible.Checked then
        SquareArc(Target, FSqr, ArcCenters[XArc]);

      if XArc = 3 then
        XArc := 0
      else
        XArc := XArc + 1;

      //define new rectangle horientation
      RectRatio := FRec.Width / FRec.Height;
      isHorizontal := RectRatio >= 1.0;

      Pace := Pace + 1;
    until abs(1.00 - RectRatio) <= 0.05;
  end;
end;

procedure TFormMain.SquareArc(Target: TCanvas; Sqr: TRect; Center: Integer);
var
  Pc, PI, PF, P0, P1, P2, P3: TPoint;
  R, i, X, Y, ArcLen: Integer;
  AI, AF, T, Pace: Double;

begin
  // coordinates of square points
  P0.X := Sqr.Left;             P0.Y := Sqr.Top;              // left-top
  P1.X := Sqr.Left + Sqr.Width; P1.Y := Sqr.Top;              // right-top
  P2.X := Sqr.Left;             P2.Y := Sqr.Top + Sqr.Height; // left-bottom
  P3.X := Sqr.Left + Sqr.Width; P3.Y := Sqr.Top + Sqr.Height; // right-bottom

  // define center coordinate of circle
  case Center of
  0: begin // left-top
       Pc := P0; PI := P1; PF := P2
     end;
  1: begin // right-top
       Pc := P1; PI := P3; PF := P0;
     end;
  2: begin // left-bottom
       Pc := P2; PI := P0; PF := P3;
     end;
  3: begin // right-bottom
       Pc := P3; PI := P2; PF := P1;
     end;
  end;

  // ratio
  R := round(sqrt(Power(PI.X-Pc.X, 2) + Power(PI.Y-Pc.Y, 2))); // equal Srq.Widht

  // init and final angles
  AI := ArcTan2(PI.Y - Pc.Y, PI.X - Pc.X);
  AF := ArcTan2(PF.Y - Pc.Y, PF.X - Pc.X);
  if AF <= AI then
    AF := AF + 2 * 3.141516;

  ArcLen := Round(R * (AF - AI));
  Pace := (AF - AI) / ArcLen; //Screen.PixelsPerInch;

  // plot arc points
  T := AI;
  for i := 0 to (ArcLen + 1) do
  begin
    X := Round(Pc.X + R * cos(T));
    Y := Round(Pc.Y + R * sin(T));
    Target.Pixels[X, Y] := ColorButtonSpiral.ButtonColor;
    T := T + Pace;
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
  DrawSpiral(PaintBox1.Canvas, FRectImage);
end;

procedure TFormMain.SpeedButton1Click(Sender: TObject);
var
  n: double;
begin
  n := FloatSpinEditWidth.Value;
  FloatSpinEditWidth.Value := FloatSpinEditHeight.Value;
  FloatSpinEditHeight.Value := n;
  PaintBox1.Refresh;
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

procedure TFormMain.PaintBox1Refresh();
begin
  PaintBox1.Refresh;
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

procedure TFormMain.CheckBoxSpiralVisibleChange(Sender: TObject);
begin
  PaintBox1.Refresh;
end;

procedure TFormMain.CheckBoxSquareVisibleChange(Sender: TObject);
begin
  PaintBox1.Refresh;
end;

procedure TFormMain.ColorButtonGridColorChanged(Sender: TObject);
begin
  PaintBox1.Refresh;
end;

procedure TFormMain.ColorButtonSpiralColorChanged(Sender: TObject);
begin
  PaintBox1.Refresh;
end;

procedure TFormMain.ColorButtonSquareColorChanged(Sender: TObject);
begin
  PaintBox1.Refresh;
end;

procedure TFormMain.ColorButtonSuportColorChanged(Sender: TObject);
begin
  PaintBox1.Refresh;
end;

procedure TFormMain.ComboBoxSpiralReferenceChange(Sender: TObject);
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

procedure TFormMain.SpinEditSpiralLineWidthChange(Sender: TObject);
begin
  PaintBox1.Refresh;
end;

procedure TFormMain.SpinEditSpiralQtyChange(Sender: TObject);
begin
  PaintBox1.Refresh;
end;

procedure TFormMain.SpinEditSquareLineWidthChange(Sender: TObject);
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

procedure TFormMain.ShowFileName();
var
  Wmm, Hmm, ImgRatio, SupRatio: Double;
  SWpx, SHpx, DestW, DestH: Integer;
  SWmm, SHmm, SFile: String;

begin
  SFile := '';
  if FImageOriginalPath <> '' then
  begin
      if (FImageOriginal.Graphic = nil) or (FImageOriginal.Graphic.Empty) then
        Exit;

      SWpx := MMtoPX(FloatSpinEditWidth.Value , Screen.PixelsPerInch);
      SHpx := MMtoPX(FloatSpinEditHeight.Value , Screen.PixelsPerInch);

      ImgRatio := FImageOriginal.Width / FImageOriginal.Height;
      SupRatio := SWpx / SHpx;

      if ImgRatio > SupRatio then
        begin
          // Image largest than PaintBox
          DestW := SWpx;
          DestH := Round(SWpx / ImgRatio);
        end
      else
        begin
          // Image higher than PaintBox
          DestH := SHpx;
          DestW := Round(SHpx * ImgRatio);
        end;

      Wmm := PXScreenToMM(DestW);
      Hmm := PXScreenToMM(DestH);
      Str(Wmm:6:1, SWmm);
      Str(Hmm:6:1, SHmm);
      SFile := '(' + SWmm + 'mm x ' + SHmm + 'mm) ' + FImageOriginalPath;
  end;
  StatusBar1.Panels[0].Text := SFile;
end;

end.

