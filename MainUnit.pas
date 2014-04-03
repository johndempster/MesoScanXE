unit MainUnit;
// =======================================================================
// Mesoscan: Mesolens confocal LSM software
// =======================================================================
// (c) John Dempster, University of Strathclyde 2011-12
// V1.0 1-5-12
// V1.3 19-6-12 Z stage and 3D images now supported
// V1.5 20-03-13
// V1.5 08-08-13 Scan area now correctly updated when fullfieldwidth changed
//               Fixes offsets observed in scans
//               Incorrect offset on Y axis scan fixed

interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ValidatedEdit, LabIOUnit, RangeEdit, math,
  ExtCtrls, ImageFile, xmldoc, xmlintf, ActiveX, Vcl.Menus, system.types, strutils, UITypes ;

const
    VMax = 10.0 ;
    MaxFrameType = 2 ;
    MinPaletteColor = 11 ;
    MaxPaletteColor = 255 ;
    GreyScalePalette = 0 ;
    LUTSize = $10000 ;
    GreyLevelLimit = $FFFF ;
    FalseColourPalette = 1 ;
    MaxScanSpeed = 100. ;
    MinPixelDwellTime = 2E-6 ;
    MaxZoomFactors = 100 ;
    XYMode = 0 ;
    XYZMode = 1 ;
    XTMode = 2 ;
    XZMode = 3 ;

type

 TPaletteType = (palGrey,palGreen,palRed,palBlue,palFalseColor) ;

 TDoubleRect = record
    Left : Double ;
    Right : Double ;
    Top : Double ;
    Bottom : Double ;
    Width : Double ;
    Height : Double ;
    end ;


  TMainFrm = class(TForm)
    ControlGrp: TGroupBox;
    bScanImage: TButton;
    ImageGrp: TGroupBox;
    Image1: TImage;
    ZSectionPanel: TPanel;
    Timer: TTimer;
    bStopScan: TButton;
    ImageFile: TImageFile;
    SaveDialog: TSaveDialog;
    bSnapImage: TButton;
    ckRepeat: TCheckBox;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    mnExit: TMenuItem;
    mnSetup: TMenuItem;
    mnScanSettings: TMenuItem;
    Panel1: TPanel;
    bZoomIn: TButton;
    bZoomOut: TButton;
    lbZoom: TLabel;
    scZSection: TScrollBar;
    lbZSection: TLabel;
    lbReadout: TLabel;
    rbFastScan: TRadioButton;
    rbHRScan: TRadioButton;
    lbTopLeft: TLabel;
    lbBottomRight: TLabel;
    bScanZoomOut: TButton;
    bScanZoomIn: TButton;
    ImageSizeGrp: TGroupBox;
    Label4: TLabel;
    edNumAverages: TValidatedEdit;
    ZStackGrp: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    edNumZSections: TValidatedEdit;
    edNumPixelsPerZStep: TValidatedEdit;
    cbImageMode: TComboBox;
    Label1: TLabel;
    edMicronsPerZStep: TValidatedEdit;
    LineScanGrp: TGroupBox;
    Label2: TLabel;
    edLineScanFrameHeight: TValidatedEdit;
    ZStageGrp: TGroupBox;
    edZTop: TValidatedEdit;
    edGotoZPosition: TValidatedEdit;
    bGotoZPosition: TButton;
    GroupBox2: TGroupBox;
    Label15: TLabel;
    cbADCVoltageRange: TComboBox;
    LaserGrp: TGroupBox;
    edLaserIntensity: TValidatedEdit;
    LaserIntensityTrackBar: TTrackBar;
    rbLaserOn: TRadioButton;
    rbLaserOff: TRadioButton;
    DisplayGrp: TGroupBox;
    Splitter1: TSplitter;
    cbPalette: TComboBox;
    ContrastPage: TPageControl;
    RangeTab: TTabSheet;
    bFullScale: TButton;
    bMaxContrast: TButton;
    edDisplayIntensityRange: TRangeEdit;
    ckContrast6SDOnly: TCheckBox;
    ckAutoOptimise: TCheckBox;
    SlidersTab: TTabSheet;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    sbContrast: TScrollBar;
    sbBrightness: TScrollBar;
    StatusGrp: TGroupBox;
    meStatus: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure bScanImageClick(Sender: TObject);
    procedure bFullScaleClick(Sender: TObject);
    procedure edDisplayIntensityRangeKeyPress(Sender: TObject;
      var Key: Char);
    procedure bMaxContrastClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure bStopScanClick(Sender: TObject);
    procedure bSnapImageClick(Sender: TObject);
    procedure cbPaletteChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure mnExitClick(Sender: TObject);
    procedure edXPixelsKeyPress(Sender: TObject; var Key: Char);
    procedure edYPixelsKeyPress(Sender: TObject; var Key: Char);
    procedure mnScanSettingsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LaserIntensityTrackBarChange(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ckLineScanClick(Sender: TObject);
    procedure bGotoZPositionClick(Sender: TObject);

    procedure bZoomInClick(Sender: TObject);
    procedure bZoomOutClick(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure scZSectionChange(Sender: TObject);
    procedure rbFastScanClick(Sender: TObject);
    procedure rbHRScanClick(Sender: TObject);
    procedure bScanZoomInClick(Sender: TObject);
    procedure bScanZoomOutClick(Sender: TObject);
    procedure cbImageModeChange(Sender: TObject);
    procedure edNumPixelsPerZStepKeyPress(Sender: TObject; var Key: Char);
    procedure edMicronsPerZStepKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
        BitMap : TBitMap ;  // Image internal bitmaps
        procedure DisplayROI( BitMap : TBitmap ) ;
        procedure DisplaySquare(
                  X : Integer ;
                  Y : Integer ) ;


  public
    { Public declarations }
    DeviceNum : Integer ;
    ADCVoltageRange : Double ;
    ADCMaxValue : Integer ;
    DACMaxValue : Integer ;
    TempBuf : PBig16bitArray ;
    DACBuf : PBig16bitArray ;
    ADCBuf : PBig16bitArray ;
    AvgBuf : PBig16bitArray ;
    ADCMap : PBig32bitArray ;
    ADCNumNewSamples : Integer ;
    ADCInput : Integer ;             // Selected analog input
    NumXPixels : Cardinal ;
    NumYPixels : Integer ;
    NumPixels : Integer ;
    NumPixelsInDACBuf : Cardinal ;
    BufSize : Integer ;
    XCentre : Double ;
    XWidth : Double ;
    YCentre : Double ;
    YHeight : Double ;
    ScanArea : Array[0..99] of TDoubleRect ;   // Selected scanning areas
    iScanZoom : Integer ;                      // Selected area in ScanArea
    PixelsToMicronsX : Double ;                // Image pixel X# to micron scaling factor
    PixelsToMicronsY : Double ;                // Image pixel Y# to micron scaling factor

    SelectedRect : TRect ;                     // Selected sub-area within displayed image (image pixels)
    SelectedRectBM : TRect ;                   // Selected sub-area (bitmap pixels)
    SelectedEdge : TRect ;                     // Selection rectangle edges selected
    MouseDown : Boolean ;                      // TRUE = image cursor mouse is depressed
    CursorPos : TPoint ;                       // Position of cursor within image
    TopLeftDown : TPoint ;
    MouseDownAt : TPoint ;                     // Mouse position when button depressed
    MouseUpCursor : Integer ;                  // Cursor icon when button released

    ZTop : Double ;
    //Zoom : Double ;
    FullFieldWidthMicrons : Double ;      // Actual width of full imaging field (um)
    BidirectionalScan : Boolean ;         // TRUE = bidirectional scan enabled
    CorrectSineWaveDistortion : Boolean ; // TRUE = sine wave image distortion correction
    InvertPMTSignal : Boolean ;           // TRUE = PMT signal inverted
    BlackLevel : Integer ;                // Black level of PMT signal
    MaxScanRate : Double ;                // Highest permitted scan rate
    MinPixelDwellTime : Double ;          // Smallest permitted pixel dwell time
    XVoltsPerMicron : Double ;            // X galvo volts per micron displacement scall factor
    YVoltsPerMicron : Double ;            // Y galvo volts per micron displacement scall factor
    PhaseShift : Double ;                 // Phase delay between galvo command galvo displacement
    FrameWidth : Integer ;                // Width of image on display
    FrameHeight : Integer ;               // Height of image of display
    FullFieldWidth : Integer ;            // Width of full field image
    HRFrameWidth : Integer ;       // Width of high res. image
    HRFrameHeight : Integer ;      // Height of image of display
    FastFrameWidth : Integer ;     // Fast imaging: frame width (pixels)
    FastFrameHeight : Integer ;    // Fast imaging: frame height (pixels)
    FrameHeightScale : Double ;    // Fast imaging: Frame height scaling factor
    ScanInfo : String ;

    NumPixelsPerFrame : Integer ;
    NumADCChannels : Integer ;
    PixelDwellTime : Double ;

    // Laser control
    LaserIntensity : Double ;
    LaserControlEnabled : Boolean ;
    LaserControlComPort : Integer ;
    LaserControlComHandle : THandle ;
    LaserControlOpen : Boolean ;

    // Z axis control
    //ZControlEnabled : Boolean ;
    //ZControlComPort : Integer ;
    //ZControlComHandle : THandle ;
    //ZControlOpen : Boolean ;
    ZSection : Integer ;                // Current Z Section being acquired
    ZStep : Double ;                  // Spacing between Z Sections (microns)
    NumZSections : Integer ;            // No. of Sections in Z stack
    NumZSectionsAvailable : Integer ;            // No. of Sections in Z stack

    ADCPointer : Integer ;
    EmptyFlag : Integer ;
    UpdateDisplay : Boolean ;

    //ZoomFactors : Array[0..MaxZoomFactors-1] of Double ;

    //DisplayZoomIndex : Integer ;
    //DisplayZoom : Single ;
    DisplayMaxWidth : Integer ;
    DisplayMaxHeight : Integer ;
    NumFrameTypes : Integer ;

    XScale : Single ;
    YScale : Single ;
    XLeft : Integer ;
    YTop : Integer ;
    XDown : Integer ;
    YDown : Integer ;
    XScaleToBM : Double ;

    YLineSpacingMicrons : Single ;
    YStartMicrons : Single ;
    YScaleToBM : Double ;

    Magnification : Integer ;

    //GreyLevelMax : Integer ;

        // Display look-up tables
    GreyLo : Integer ; // Lower limit of display grey scale
    GreyHi : Integer ; // Upper limit of display grey scale
    LUT : Array[0..LUTSize-1] of Word ;    // Display look-up tables
    PaletteType : TPaletteType ;  // Display colour palette
    pImageBuf : PIntArray ; // Pointer to image buffers

    //PAverageBuf : PIntArray ; // Pointer to displayed image buffers
    NumAverages : Integer ;
    ClearAverage : Boolean ;

    SnapNum : Integer ;
    ScanRequested : Boolean ;

    INIFileName : String ;
    ProgDirectory : String ;
    SaveDirectory : String ;
    RawImagesFileName : String ;

    UnsavedRawImage : Boolean ;    // TRUE indicates raw images file contains an unsaved hi res. image

    MemUsed : Integer ;
    procedure InitialiseImage ;
    procedure SetImagePanels ;
    procedure CreateScanWaveform ;
    procedure StartNewScan( iZoom : Integer ) ;
    procedure StartScan ;
    procedure GetImageFromPMT ;

    procedure SetDisplayIntensityRange(
          LoValue : Integer ;
          HiValue : Integer
          ) ;

    procedure UpdateLUT( GreyMax : Integer ) ;

    procedure SetPalette( BitMap : TBitMap ; PaletteType : TPaletteType ) ;

    procedure UpdateImage ;
    procedure CalculateMaxContrast ;

    procedure SetScanZoomToFullField ;

procedure SaveRawImage(
          FileName : String ;    // File to save to
          iSection : Integer     // Image Section number
          ) ;

procedure LoadRawImage(
          FileName : String ;    // File to save to
          iSection : Integer     // Image Section number
          ) ;

    procedure SaveSettingsToXMLFile1(
              FileName : String
              ) ;
    procedure SaveSettingsToXMLFile(
              FileName : String
              ) ;
    procedure LoadSettingsFromXMLFile1(
              FileName : String
              ) ;
    procedure LoadSettingsFromXMLFile(
              FileName : String
              ) ;


    procedure AddElementDouble(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : Double
              ) ;
    function GetElementDouble(
              ParentNode : IXMLNode ;
              NodeName : String ;
              var Value : Double
              ) : Boolean ;
    procedure AddElementInt(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : Integer
              ) ;
    function GetElementInt(
              ParentNode : IXMLNode ;
              NodeName : String ;
              var Value : Integer
              ) : Boolean ;
    procedure AddElementBool(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : Boolean
              ) ;
    function GetElementBool(
              ParentNode : IXMLNode ;
              NodeName : String ;
              var Value : Boolean
              ) : Boolean ;

    procedure AddElementText(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : String
              ) ;
    function GetElementText(
              ParentNode : IXMLNode ;
              NodeName : String ;
              var Value : String
              ) : Boolean ;

    function FindXMLNode(
         const ParentNode : IXMLNode ;  // Node to be searched
         NodeName : String ;            // Element name to be found
         var ChildNode : IXMLNode ;     // Child Node of found element
         var NodeIndex : Integer        // ParentNode.ChildNodes Index #
                          // Starting index on entry, found index on exit
         ) : Boolean ;

  end;


// Corrected system function call template
function GetSystemPaletteEntries(
         DC : HDC ;
         StartIndex : Cardinal ;
         NumEntries : Cardinal ;
         PaletteEntries : Pointer ) : Cardinal ; stdcall ;


var
  MainFrm: TMainFrm;

implementation

//uses LogUnit;


uses SettingsUnit, ZStageUnit;

{$R *.dfm}

function GetSystemPaletteEntries ; external gdi32 name 'GetSystemPaletteEntries' ;


procedure TMainFrm.FormCreate(Sender: TObject);
// --------------------------------------
// Initalisations when program is created
// --------------------------------------
begin
     ADCBuf := Nil ;
     DACBuf := Nil ;
     BitMap := Nil ;

     end;


procedure TMainFrm.FormShow(Sender: TObject);
// --------------------------------------
// Initialisations when form is displayed
// --------------------------------------
var
    i : Integer ;
begin

     TempBuf := Nil ;
     DeviceNum := 1 ;

     LabIO.NIDAQAPI := NIDAQMX ;
     LabIO.Open ;

     meStatus.Clear ;
     meStatus.Lines.Add(LabIO.DeviceName[1] + ': ' + LabIO.DeviceBoardName[1] ) ;

     LabIO.ADCInputMode := imDifferential ;
     EmptyFlag := -32766 ;

     ADCMaxValue := LabIO.ADCMaxValue[DeviceNum] ;
     DACMaxValue := LabIO.DACMaxValue[DeviceNum] ;
     LabIO.WriteDACs( 1,[0.0,0.0],2);

     ADCPointer := 0 ;
     DeviceNum := 1 ;
     GreyLo := 0 ;
     GreyHi := LabIO.ADCMaxValue[DeviceNum] ;
     LabIO.WriteDACs( 1,[0.0,0.0],2);
     ADCVoltageRange := 10.0 ;
     SnapNum := 0 ;

     //StatusBar.SimpleText := LabIO.DeviceName[1] ;

     // Imaging mode
     cbImageMode.Clear ;
     cbImageMode.Items.Add('XY Image');
     cbImageMode.Items.Add('XYZ Image Stack');
     cbImageMode.Items.Add('XT Line Scan');
     cbImageMode.Items.Add('XZ Image');
     cbImageMode.ItemIndex := XYMode ;
     LineScanGrp.Visible := False ;
     ZStackGrp.Visible := False ;

     // Intensity display palette
     cbPalette.Clear ;
     cbPalette.Items.AddObject(' Grey scale', TObject(palGrey)) ;
     cbPalette.Items.AddObject(' False colour', TObject(palFalseColor)) ;
     cbPalette.Items.AddObject(' Red scale', TObject(palRed)) ;
     cbPalette.Items.AddObject(' Green scale', TObject(palGreen)) ;
     cbPalette.Items.AddObject(' Blue scale', TObject(palBlue)) ;
     cbPalette.ItemIndex := cbPalette.Items.IndexOfObject(TObject(MainFrm.PaletteType)) ;

     cbADCVoltageRange.clear ;
     for i := 0 to LabIO.NumADCVoltageRanges[DeviceNum]-1 do begin
         cbADCVoltageRange.items.add(
           format(' +/-%.3g V ',[LabIO.ADCVoltageRanges[1,i]] )) ;
         end ;
     //SESLabIO.ADCVoltageRangeIndex := 2 ;
     cbADCVoltageRange.ItemIndex := 0 ;
     InvertPMTSignal := True ;

     edDisplayIntensityRange.LoLimit := 0 ;
     edDisplayIntensityRange.HiLimit := ADCMaxValue ;

     bFullScale.Click ;

     // Save image file dialog
     SaveDialog.InitialDir := '' ;
     SaveDialog.Title := 'Save Image ' ;
     SaveDialog.options := [ofHideReadOnly,ofPathMustExist] ;
     SaveDialog.DefaultExt := '.tif' ;
     SaveDialog.Filter := ' TIFF (*.tif)|*.tif' ;
     SaveDialog.FilterIndex := 3 ;
     SaveDirectory := '' ;

     SnapNum := 1 ;

     FullFieldWidth := 500 ;
     FullFieldWidthMicrons := 2000.0 ;
     FrameWidth := FullFieldWidth ;
     FrameHeight := FullFieldWidth ;
     Magnification := 1;
     if BitMap <> Nil then BitMap.Free ;
     BitMap := TBitMap.Create ;
     BitMap.Width := FullFieldWidth ;
     BitMap.Height := FullFieldWidth ;

     // Default normal scan settings
     NumAverages := 5 ;
     BiDirectionalScan := True ;
     MaxScanRate := 100.0 ;
     MinPixelDwellTime := 5E-7 ;
     XVoltsPerMicron := 1E-3 ;
     YVoltsPerMicron := 1E-3 ;
     ADCVoltageRange := 0 ;
     PhaseShift := 0 ;
     CorrectSineWaveDistortion := True ;
     BlackLevel := 10 ;
     InvertPMTSignal := True ;

     HRFrameWidth := 1000 ;
     FastFrameWidth := 500 ;
     FastFrameHeight := 100 ;
     FrameHeightScale := 1.0 ;

     edNumPixelsPerZStep.Value := 1.0 ;
     edNumZSections.Value := 10.0 ;

     // Load last used settings
     ProgDirectory := ExtractFilePath(ParamStr(0)) ;
     INIFileName := ProgDirectory + 'mesoscan settings.xml' ;
     LoadSettingsFromXMLFile( INIFileName ) ;

     RawImagesFileName := ProgDirectory + 'mesoscan.raw' ;

     // Load normal scan

     if FullFieldWidthMicrons <= 0.0 then FullFieldWidthMicrons := 1E4 ;

     // Open laser control
     if LaserControlEnabled then begin
        //LaserControlOpen := OpenComPort( LaserControlCOMHandle, LaserControlCOMPort, CBR_9600 ) ;
        end
     else LaserControlOpen := False ;

     UpdateDisplay := False ;
     ScanRequested := False ;

     // Initialise full field image

     iScanZoom := 0 ;
     FrameWidth := FastFrameWidth ;
     FrameHeight := FastFrameWidth ;
    // (re)allocate image buffer
    if PImageBuf <> Nil then FreeMem(PImageBuf) ;
    PImageBuf := AllocMem( Int64(FrameWidth*FrameHeight*SizeOf(Integer)) ) ;
    for i := 0 to FrameWidth*FrameHeight-1 do pImageBuf^[i] := 0 ;
    SetImagePanels ;
    InitialiseImage ;
    MouseUpCursor := crCross ;

    SetScanZoomToFullField ;

     Timer.Enabled := True ;
     UpdateDisplay := True ;
     bStopScan.Enabled := False ;
     image1.ControlStyle := image1.ControlStyle + [csOpaque] ;
     imagegrp.ControlStyle := imagegrp.ControlStyle + [csOpaque] ;
     lbreadout.ControlStyle := lbreadout.ControlStyle + [csOpaque] ;

     Left := 10 ;
     Top := 10 ;
     Width := Screen.Width - 10 - Left ;
     Height := Screen.Height - 50 - Top ;

     end;


procedure TMainFrm.SetScanZoomToFullField ;
// ---------------------------
// Set scan zoom to full field
// ---------------------------
begin
     iScanZoom := 0 ;
     ScanArea[iScanZoom].Left := 0.0 ;
     ScanArea[iScanZoom].Top := 0.0 ;
     ScanArea[iScanZoom].Right := FullFieldWidthMicrons ;
     ScanArea[iScanZoom].Bottom := FullFieldWidthMicrons ;
     ScanArea[iScanZoom].Width := FullFieldWidthMicrons ;
     ScanArea[iScanZoom].Height := FullFieldWidthMicrons ;
     SelectedRect.Left := 0 ;
     SelectedRect.Top := 0 ;
     SelectedRect.Right := FrameWidth-1 ;
     SelectedRect.Bottom := FrameHeight-1 ;
     end ;


procedure TMainFrm.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
// -------------------
// Mouse down on image
// -------------------
begin

     // Save mouse position when button pressed
     CursorPos.X := X ;
     CursorPos.Y := Y ;

     // Set mouse down flag
     MouseDown := True ;
     XDown := X ;
     YDown := Y ;
     MouseDownAt.X := X ;
     MouseDownAt.Y := Y ;
     TopLeftDown.X := XLeft ;
     TopLeftDown.Y := YTop ;

     MouseUpCursor := Image1.Cursor ;
     if Image1.Cursor = crCross then Screen.Cursor := crHandPoint ;

     end;


procedure TMainFrm.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
// ----------------------
// Mouse moved over image
// ----------------------
var
    i : Integer ;
    XRight,YBottom,XShift,YShift : Integer ;
    XImage,YImage : Integer ;
begin

     if pImageBuf = Nil then Exit ;

     XImage := Round(X/XScaleToBM) + XLeft ;
     YImage := Round(Y/YScaleToBM) + YTop ;
     i := YImage*FrameWidth + XImage ;

     PixelsToMicronsX := ScanArea[iScanZoom].Width/FrameWidth ;
     PixelsToMicronsY := FrameHeightScale*PixelsToMicronsX ;

     if (i > 0) and (i < FrameWidth*FrameHeight) then begin
        lbReadout.Caption := format('X=%.6g um, Y=%.6g um, I=%d',
                           [XImage*PixelsToMicronsX + ScanArea[iScanZoom].Left,
                            YImage*PixelsToMicronsY + ScanArea[iScanZoom].Top,
                            pImageBuf[i]]) ;
         end ;

     if not MouseDown then begin
        // Indicate if cursor is over edge of zoom selection rectangle
        SelectedEdge.Left := 0 ;
        SelectedEdge.Right := 0 ;
        SelectedEdge.Top := 0 ;
        SelectedEdge.Bottom := 0 ;
        if (Abs(X - SelectedRectBM.Left) < 2) and
           (Y >= SelectedRectBM.Top) and
           (Y <= SelectedRectBM.Bottom) then SelectedEdge.Left := 1 ;
        if (Abs(X - SelectedRectBM.Right) < 2) and
           (Y >= SelectedRectBM.Top) and
           (Y <= SelectedRectBM.Bottom) then SelectedEdge.Right := 1 ;
        if (Abs(Y - SelectedRectBM.Top) < 2) and
           (X >= SelectedRectBM.Left) and
           (X <= SelectedRectBM.Right) then SelectedEdge.Top := 1 ;
        if (Abs(Y - SelectedRectBM.Bottom) < 2) and
           (X >= SelectedRectBM.Left) and
           (X <= SelectedRectBM.Right) then SelectedEdge.Bottom := 1 ;
        if (SelectedEdge.Left = 1) and (SelectedEdge.Top = 1) then Image1.Cursor := crSizeNWSE
        else if (SelectedEdge.Left = 1) and (SelectedEdge.Bottom = 1) then Image1.Cursor := crSizeNESW
        else if (SelectedEdge.Right = 1) and (SelectedEdge.Top = 1) then Image1.Cursor := crSizeNESW
        else if (SelectedEdge.Right = 1) and (SelectedEdge.Bottom = 1) then Image1.Cursor := crSizeNWSE
        else if SelectedEdge.Left = 1 then Image1.Cursor := crSizeWE
        else if SelectedEdge.Right = 1 then Image1.Cursor := crSizeWE
        else if SelectedEdge.Top = 1 then Image1.Cursor := crSizeNS
        else if SelectedEdge.Bottom = 1 then Image1.Cursor := crSizeNS
        else Image1.Cursor := crCross ;
        CursorPos.X := X ;
        CursorPos.Y := Y ;
        end
     else begin
        if Image1.Cursor = crCRoss then Image1.Cursor := crHandPoint ;
        XShift := X - CursorPos.X ;
        CursorPos.X := X ;
        YShift := Y - CursorPos.Y ;
        CursorPos.Y := Y ;
        if SelectedEdge.Left = 1 then begin
           // Move left edge
           SelectedRectBM.Left := Max(SelectedRectBM.Left + XShift,0);
           SelectedRectBM.Left := Min(SelectedRectBM.Left,Min(BitMap.Width-1,SelectedRectBM.Right-1)) ;
           SelectedRect.Left := Round(SelectedRectBM.Left/XScaleToBM) + XLeft ;
           end ;
        if SelectedEdge.Right = 1 then begin
           // Move right edge
           SelectedRectBM.Right := Max(SelectedRectBM.Right + XShift,Max(0,SelectedRectBM.Left));
           SelectedRectBM.Right := Min(SelectedRectBM.Right,BitMap.Width-1) ;
           SelectedRect.Right := Round(SelectedRectBM.Right/XScaleToBM) + XLeft ;
           end;
        if SelectedEdge.Top = 1 then begin
           // Move top edge
           SelectedRectBM.Top := Max(SelectedRectBM.Top + YShift,0);
           SelectedRectBM.Top := Min(SelectedRectBM.Top,Min(BitMap.Height-1,SelectedRectBM.Bottom-1)) ;
           SelectedRect.Top := Round(SelectedRectBM.Top/YScaleToBM) + YTop ;
           end;

        if SelectedEdge.Bottom = 1 then begin
           // Move bottom edge
           SelectedRectBM.Bottom := Max(SelectedRectBM.Bottom + YShift,SelectedRectBM.Top+1);
           SelectedRectBM.Bottom := Min(SelectedRectBM.Bottom,BitMap.Height-1) ;
           SelectedRect.Bottom := Round(SelectedRectBM.Bottom/YScaleToBM) + YTop ;
           end;

        if (SelectedEdge.Left or SelectedEdge.Right or
            SelectedEdge.Top or SelectedEdge.Bottom) = 0 then begin
            // Move display window
            XLeft := TopLeftDown.X - Round((X - MouseDownAt.X)/XScaleToBM) ;
            XRight := Min(XLeft + Round(Bitmap.Width/XScaleToBM),FrameWidth) ;
            XLeft := Max( XRight - Round(Bitmap.Width/XScaleToBM), 0 ) ;
            YTop := TopLeftDown.Y - Round((Y - MouseDownAt.Y)/YScaleToBM) ;
            YBottom := Min(YTop + Round(Bitmap.Height/YScaleToBM),FrameHeight) ;
            YTop := Max( YBottom - Round(Bitmap.Height/YScaleToBM),0) ;
            end;
         end ;

       UpdateDisplay := True ;
     end ;



procedure TMainFrm.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
// -------------------
// Mouse up on image
// -------------------
begin
     MouseDown := False ;
     Image1.Cursor := MouseUpCursor ;
     Screen.Cursor :=crDefault ;
     exit ;
     UpdateDisplay := True ;

end;


procedure TMainFrm.InitialiseImage ;
// ------------------------------------------------------
// Re-initialise size of memory buffers and image bitmaps
// ------------------------------------------------------
begin

    // No. of pixels per frame
    NumPixelsPerFrame := FrameWidth*FrameHeight ;

     // Create work buffer

     // Set size and location of image display panels
     SetImagePanels ;

     // Indicate selected frame type selected for contrast update
     DisplayGrp.Caption := ' Contrast ' ;

     // Set intensity range and sliders
     SetDisplayIntensityRange( MainFrm.GreyLo,MainFrm.GreyHi ) ;

     if BitMap <> Nil then SetPalette( BitMap, PaletteType ) ;

     // Update display look up tables
     UpdateLUT( ADCMaxValue );


     end ;


procedure TMainFrm.SetImagePanels ;
// -------------------------------------------
// Set size and number of image display panels
// -------------------------------------------
const
    MarginPixels = 16 ;
var
    HeightWidthRatio : Double ;
begin

     ImageGrp.ClientWidth :=  Max( ClientWidth - ImageGrp.Left - 5, 2) ;
     ImageGrp.ClientHeight :=  Max( ClientHeight - ImageGrp.Top - 5, 2) ;
     //ControlGrp.ClientHeight := ImageGrp.ClientHeight ;

     DisplayMaxWidth := ImageGrp.ClientWidth - Image1.Left - 5 ;
     DisplayMaxHeight := ImageGrp.ClientHeight
                         - Image1.Top - 5 - ZSectionPanel.Height ;

     if BitMap <> Nil then BitMap.Free ;
     BitMap := TBitMap.Create ;
     SetPalette( BitMap, PaletteType ) ;

     BitMap.Width := DisplayMaxWidth ;
     HeightWidthRatio := (FrameHeight*FrameHeightScale)/FrameWidth ;
     BitMap.Height := Round(BitMap.Width*HeightWidthRatio) ;
     if BitMap.Height > DisplayMaxHeight then begin
        BitMap.Height := DisplayMaxHeight ;
        BitMap.Width := Round(BitMap.Height/HeightWidthRatio) ;
        end;

     XScaleToBM := (BitMap.Width*Magnification) / FrameWidth ;
     YScaleToBM := (BitMap.Width*Magnification*FrameHeightScale) / FrameWidth ;

     Image1.Width := BitMap.Width ;
     Image1.Height := BitMap.Height ;
     lbBottomRight.Top := Image1.Top + Image1.Height + 2 ;
     lbBottomRight.Left := Image1.Left + Image1.Width - lbBottomRight.Width ;
     ZSectionPanel.Top := lbBottomRight.Top ;
     ZSectionPanel.Left := lbBottomRight.Left - ZSectionPanel.Width ;
     lbReadout.Top :=  lbBottomRight.Top ;

     Image1.Canvas.Pen.Color := clWhite ;
     Image1.Canvas.Brush.Style := bsClear ;
     Image1.Canvas.Font.Color := clWhite ;
     Image1.Canvas.TextFlags := 0 ;
     Image1.Canvas.Pen.Mode := pmXOR ;
     Image1.Canvas.Font.Name := 'Arial' ;
     Image1.Canvas.Font.Size := 8 ;
     Image1.Canvas.Font.Color := clBlue ;

     end ;


procedure TMainFrm.SetDisplayIntensityRange(
          LoValue : Integer ;
          HiValue : Integer
          ) ;
// --------------------------------------
// Set display contrast range and sliders
// --------------------------------------
begin

     edDisplayIntensityRange.LoValue := LoValue  ;
     edDisplayIntensityRange.HiValue := HiValue  ;
     sbBrightness.Position := (LoValue + HiValue) div 2 ;
     sbContrast.Position := HiValue - LoValue ;

     end ;


procedure TMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
// ------------
// Stop program
// ------------
begin

     LabIO.Close ;

     if ADCMap <> Nil then FreeMem(ADCMap) ;
     if ADCBuf <> Nil then FreeMem(ADCBuf) ;
     if AvgBuf <> Nil then FreeMem(AvgBuf) ;
     if DACBuf <> Nil then FreeMem(DACBuf) ;

     // Close control ports
     //if LaserControlOpen then CloseCOMPort( LaserControlCOMHandle,LaserControlOpen) ;
     //if ZControlOpen then CloseCOMPort( ZControlCOMHandle,ZControlOpen) ;

     SaveSettingsToXMLFile( INIFileName ) ;

     end;

procedure TMainFrm.CreateScanWaveform ;
// ------------------------------
// Create X/Y galvo scan waveform
// ------------------------------
var
    XPeriod,YVolts,HalfPi,ScanSpeed : Double ;
    XCentre,YCentre,XAmplitude,YHeight : Double ;
    iX,iY,i,j,k,iShift,kStart,kShift : Integer ;
    SineWaveForwardScan,SineWaveReverseScan,SineWaveCorrection : PBig16BitArray ;
    NumBytes : NativeInt ;
    NumLinesInDACBuf : Cardinal ;
begin

    meStatus.Clear ;
    meStatus.Lines[0] := 'Wait: Creating XY scan waveform' ;

    NumXPixels := FrameWidth ;
    NumYPixels := FrameHeight ;
    if not BidirectionalScan then NumYPixels := NumYPixels*2 ;

    NumPixels := NumXPixels*NumYPixels ;

    BufSize := NumXPixels*NumYPixels*4 ;

    // Allocate A/D buffer
    if ADCBuf <> Nil then FreeMem( ADCBuf ) ;
    NumBytes := Int64(NumPixels)*SizeOf(SmallInt) ;
    ADCBuf := AllocMem( NumBytes ) ;

    // Allocate D/A waveform databuffer
    if DACBuf <> Nil then FreeMem( DACBuf ) ;
    NumPixelsInDACBuf := Min(NumPixels,OutBufMaxSamples) ;
    NumLinesinDACBuf := NumPixelsInDACBuf div NumXPixels ;
    NumPixelsInDACBuf := NumLinesinDACBuf*NumXPixels ;
    NumBytes := Int64(NumPixels)*Int64(SizeOf(SmallInt)*2) ;
    DACBuf := AllocMem( NumBytes ) ;

    GetMem( SineWaveForwardScan, NumXPixels*SizeOf(SmallInt) ) ;
    GetMem( SineWaveReverseScan, NumXPixels*SizeOf(SmallInt) ) ;
    GetMem( SineWaveCorrection, NumXPixels*SizeOf(SmallInt) ) ;

    if ADCMap <> Nil then FreeMem(ADCMap) ;
    NumBytes := Int64(NumPixels)*SizeOf(Integer) ;
    ADCMap := AllocMem(NumBytes) ;

    XScale := (LabIO.DACMaxValue[DeviceNum]/VMax)*XVoltsPerMicron ;
    YScale := (LabIO.DACMaxValue[DeviceNum]/VMax)*YVoltsPerMicron ;
    XAmplitude := (ScanArea[iScanZoom].Right - ScanArea[iScanZoom].Left)*0.5 ;
    XCentre := (ScanArea[iScanZoom].Left + ScanArea[iScanZoom].Right - FullFieldWidthMicrons)*0.5 ;
    YHeight := ScanArea[iScanZoom].Bottom - ScanArea[iScanZoom].Top ;
    YCentre := (ScanArea[iScanZoom].Top + ScanArea[iScanZoom].Bottom - FullFieldWidthMicrons)*0.5 ;
    XPeriod := (pi)/NumXPixels ;

    if (cbImageMode.ItemIndex <> XTMode) then begin
       // Image modes (XY, XYZ) :
       YStartMicrons := YCentre - YHeight*0.5 ;
       YLineSpacingMicrons := YHeight/NumYPixels ;
       end
    else begin
       // Line scan (XT) along X axis at YCentre position
       YStartMicrons := YCentre ;
       YLineSpacingMicrons := 0.0 ;
    end;

    HalfPi := Pi*0.5 ;
    for iX := 0 to NumXPixels-1 do begin
        SineWaveForwardScan^[iX] := Round((XCentre + XAmplitude*sin((iX*XPeriod)-HalfPi))*XScale) ;
        SineWaveReverseScan^[iX] := Round((XCentre + XAmplitude*sin((iX*XPeriod)+HalfPi))*XScale) ;
        SineWaveCorrection^[iX] := Round( (NumXPixels*0.5) + (NumXPixels*0.5)*sin(iX*XPeriod-HalfPi) ) ;
        SineWaveCorrection^[iX] := Min(Max(SineWaveCorrection^[iX],0),NumXPixels-1);
        end ;

    // Create initial DAC buffer
    j := 0 ;
    for iY := 0 to NumLinesinDACBuf-1 do begin
        YVolts := iY*YLineSpacingMicrons + YStartMicrons ;

        if (iY mod 2) = 0 then begin
           // Forward scan
           for iX := 0 to NumXPixels-1 do begin
               DACBuf^[j] := SineWaveForwardScan^[iX] ;
               DACBuf^[j+1] := Round(YScale*YVolts) ;
               j := j + 2 ;
               end ;
           end
        else begin
           // Reverse scan
           for iX := 0 to NumXPixels-1 do begin
               DACBuf^[j] := SineWaveReverseScan^[iX] ;
               DACBuf^[j+1] := Round(YScale*YVolts) ;
               j := j + 2 ;
               end ;
            end ;
        end ;

    // Create sine wave correction mapping buffer

    k := 0 ;
    for iY := 0 to NumYPixels-1 do begin
        kStart := k ;

        if (iY mod 2) = 0 then begin
           // Forward scan
           for iX := 0 to NumXPixels-1 do begin
               ADCMap^[k] := iY*NumXPixels + iX ;
               Inc(k) ;
               end ;
           end
        else begin
           // Reverse scan
           for iX := 0 to NumXPixels-1 do begin
               ADCMap^[k] := iY*NumXPixels + NumXPixels -1 - iX ;
               Inc(k) ;
               end ;
            end ;

        if CorrectSineWaveDistortion then begin
           for iX := 0 to NumXPixels-1 do begin
               ADCMap^[kStart+iX] := SineWaveCorrection^[ADCMap^[kStart+iX]-kStart] + kStart ;
               end ;
           end ;

        if (iY mod 1000) = 0 then Application.ProcessMessages ;

        end ;

    // Discard reverse scans when in unidirectional scan mode

    if not BidirectionalScan then begin
       for iY := 0 to NumYPixels-1 do begin
           kStart := iY*NumXPixels ;
           kShift := (iY*NumXPixels) div 2 ;
           if (iY mod 2) = 0 then begin
              for iX := 0 to NumXPixels-1 do begin
                  ADCMap^[kStart+iX] := ADCMap^[kStart+iX] - kShift ;
                  end ;
              end
           else begin
              for iX := 0 to NumXPixels-1 do ADCMap^[kStart+iX] := 0 ;
              end
           end ;
       end ;

    PixelDwellTime := Max( 1.0/(MaxScanRate*NumXPixels), MinPixelDwellTime ) ;
    LabIO.CheckSamplingInterval(DeviceNum,PixelDwellTime,1) ;
    ScanSpeed := 0.5/(PixelDwellTime*NumXPixels) ;
    if BidirectionalScan then ScanSpeed := ScanSpeed*0.5 ;
    ScanInfo := format('%.3g lines/s Tdwell=%.3g us',
                              [ScanSpeed,1E6*PixelDwellTime]);

    iShift := Round(PhaseShift/PixelDwellTime) ;
    if iShift >= 0 then begin
       for i := 0 to NumPixels-1 do begin
           ADCMap^[i] := ADCMap^[Max(Min(i+iShift,NumPixels-1),0)] ;
           end ;
       end
    else begin
       for i := (NumPixels-1) downto 0 do begin
           ADCMap^[i] := ADCMap^[Max(Min(i+iShift,NumPixels-1),0)] ;
           end ;
       end ;

    for i := 0 to NumPixels-1 do ADCMap^[i] := Min(Max(ADCMap^[i],0),NumPixels-1) ;

    FreeMem( SineWaveCorrection ) ;
    FreeMem( SineWaveForwardScan ) ;
    FreeMem( SineWaveReverseScan ) ;

    end ;


procedure TMainFrm.DisplayROI(
          BitMap : TBitmap
          ) ;
// ------------------------------------------------------
// Display selected scanning region in full field of view
// ------------------------------------------------------
var
  PaletteType : TPaletteType ;
  PenColor : Integer ;
begin

     // Set ROI colour
     PaletteType := TPaletteType(cbPalette.Items.Objects[cbPalette.ItemIndex]) ;
     case PaletteType of
          palGrey : PenColor := clYellow ;
          else PenColor := clWhite ;
          end;

     Bitmap.Canvas.Pen.Color := PenColor ;
     Bitmap.Canvas.Brush.Style := bsClear ;
     Bitmap.Canvas.Font.Color := PenColor ;

     SelectedRectBM.Left := Round((SelectedRect.Left - XLeft)*XScaletoBM) ;
     SelectedRectBM.Right := Round((SelectedRect.Right - XLeft)*XScaletoBM) ;
     SelectedRectBM.Top := Round((SelectedRect.Top - YTop)*YScaletoBM) ;
     SelectedRectBM.Bottom := Round((SelectedRect.Bottom - YTop)*YScaletoBM) ;

     // Display zomm area selection rectangle
     Bitmap.Canvas.Rectangle(SelectedRectBM);

     // Display square corner and mid-point tags
     DisplaySquare( SelectedRectBM.Left, SelectedRectBM.Top ) ;
     DisplaySquare( (SelectedRectBM.Left + SelectedRectBM.Right) div 2, SelectedRectBM.Top ) ;
     DisplaySquare( SelectedRectBM.Right, SelectedRectBM.Top ) ;
     DisplaySquare( SelectedRectBM.Left, (SelectedRectBM.Top + SelectedRectBM.Bottom) div 2) ;
     DisplaySquare( SelectedRectBM.Right, (SelectedRectBM.Top + SelectedRectBM.Bottom) div 2) ;
     DisplaySquare( SelectedRectBM.Left, SelectedRectBM.Bottom ) ;
     DisplaySquare( (SelectedRectBM.Left + SelectedRectBM.Right) div 2, SelectedRectBM.Bottom ) ;
     DisplaySquare( SelectedRectBM.Right, SelectedRectBM.Bottom ) ;

     end ;


procedure TMainFrm.DisplaySquare(
          X : Integer ;
          Y : Integer ) ;
var
    Square : TRect ;
begin
     Square.Left := X - 3 ;
     Square.Right := X + 3 ;
     Square.Top := Y - 3 ;
     Square.Bottom := Y + 3 ;
     //Bitmap.Canvas.Pen.Color := clwhite ;
     Bitmap.Canvas.Brush.Style := bsSolid ;
     Bitmap.Canvas.Rectangle(Square);

     end ;


procedure TMainFrm.UpdateImage ;
// --------------
// Display image
// --------------
var
    Ybm,Xbm,i,iLine : Integer ;
    PScanLine : PByteArray ;    // Bitmap line buffer pointer
    X,Y,dX,dY : Double ;
    XMap,YMap : PIntArray ;
    YBottom,XRight : Integer ;
begin

    if pImageBuf = Nil then Exit ;

    // Copy reduced image to bitmap

    //SetImagePanels ;
     Image1.Width := BitMap.Width ;
     Image1.Height := BitMap.Height ;

     DisplayMaxWidth := ImageGrp.ClientWidth - Image1.Left - 5 ;
     DisplayMaxHeight := ImageGrp.ClientHeight
                         - Image1.Top - 5 - ZSectionPanel.Height ;

     XScaleToBM := (BitMap.Width*Magnification) / FrameWidth ;


     // Adjust left,top edge of displayed region of image when bottom,right is off image
     XRight := Min(XLeft + Round(Bitmap.Width/XScaleToBM),FrameWidth) ;
     XLeft := Max( XRight - Round(Bitmap.Width/XScaleToBM), 0 ) ;
     YBottom := Min(YTop + Round(Bitmap.Height/YScaleToBM),FrameHeight) ;
     YTop := Max( YBottom - Round(Bitmap.Height/YScaleToBM),0) ;

     //  X axis pixel mapping
     X := XLeft ;
     dX := 1.0/XScaleToBM ;
     GetMem( XMap, BitMap.Width*4 ) ;
     for i := 0 to BitMap.Width-1 do begin
         XMap^[i] := Min(Max(Round(X),0),FrameWidth-1) ;
         X := X + dX ;
         end;

     // Y axis line mapping
     YScaleToBM := (BitMap.Width*Magnification*FrameHeightScale) / FrameWidth ;
     GetMem( YMap, BitMap.Height*4 ) ;
     Y := YTop ;
     dY := 1.0/YScaleToBM ;
     for i := 0 to BitMap.Height-1 do begin
         YMap^[i] := Min(Max(Round(Y),0),FrameHeight-1) ;
         Y := Y + dY ;
         end;

    for Ybm := 0 to BitMap.Height-1 do begin
        // Copy line to bitmap
        iLine := YMap^[Ybm]*FrameWidth ;
        PScanLine := BitMap.ScanLine[Ybm] ;
        for xBm := 0 to BitMap.Width-1 do begin
            PScanLine[Xbm] := LUT[Word(pImageBuf^[XMap^[xBm]+iLine])] ;
            end ;
          end ;

     DisplayROI(BitMap) ;

     Image1.Picture.Assign(BitMap) ;
     Image1.Width := BitMap.Width ;
     Image1.Height := BitMap.Height ;

     lbZoom.Caption := format('Zoom (X%d)',[Magnification]) ;

     if (NumZSectionsAvailable > 1) and
        (not bStopScan.Enabled)  then begin
        ZSectionPanel.Visible := True ;
        lbZSection.Caption := format('Section %d/%d',[ZSection+1,NumZSectionsAvailable]) ;
     end
     else begin
        ZSectionPanel.Visible := False ;

     lbTopLeft.Caption := format('(%.6g,%.6g um)',
                          [(XLeft*PixelsToMicronsX) + ScanArea[iScanZoom].Left,
                           YTop*PixelsToMicronsY + ScanArea[iScanZoom].Top]) ;
     lbBottomRight.Caption := format('(%.6g,%.6g um)',
                              [(XLeft +(BitMap.Width/XScaleToBM))*PixelsToMicronsX
                                + ScanArea[iScanZoom].Left,
                               (YTop + (BitMap.Height/YScaleToBM))*PixelsToMicronsY
                                + ScanArea[iScanZoom].Top]) ;

     FreeMem(XMap) ;
     FreeMem(YMap) ;

     end;

    end ;


procedure TMainFrm.UpdateLUT(
          GreyMax : Integer ) ;
// ----------------------------
// Create display look-up table
// ----------------------------
var
    y : Integer ;
    i,j : Integer ;
    GreyScale : Single ;
begin

     if GreyHi <> GreyLo then
        GreyScale := (MaxPaletteColor - MinPaletteColor)/ (GreyHi - GreyLo)
     else GreyScale := 1.0 ;

     j := 0 ;
     for i := 0 to GreyMax do begin
         y := MinPaletteColor + Round((i-GreyLo)*GreyScale) ;
         if y < MinPaletteColor then y := MinPaletteColor ;
         if y > MaxPaletteColor then y := MaxPaletteColor ;
         LUT[j] := y ;
         Inc(j) ;
         end ;

     end ;


procedure TMainFrm.SetPalette(
          BitMap : TBitMap ;              // Bitmap to set (IN)
          PaletteType : TPaletteType ) ;  // Type of palette required (IN)
// ------------------------------------------------------
// Set bitmap palette to 8 bit grey or false colour scale
// ------------------------------------------------------
var
  Pal: PLogPalette;
  hpal: HPALETTE;
  i: Integer;
begin

  // Exit if bitmap does not exist
  if BitMap = Nil then Exit ;

  BitMap.PixelFormat := pf8bit ;

  pal := nil;
  GetMem(pal, sizeof(TLogPalette) + sizeof(TPaletteEntry) * 256);

  try

    // Get existing 10 system colours
    GetSystemPaletteEntries( Canvas.Handle, 0, 10, @(Pal^.palPalEntry)) ;

    // Set remaining 246 as shades of grey
    Pal^.palVersion := $300;
    Pal^.palNumEntries := 256;

    case PaletteType of

       // Grey scale
       PalGrey : Begin
           for i := MinPaletteColor to MaxPaletteColor do begin
               Pal^.palPalEntry[i].peRed := i ;
               Pal^.palPalEntry[i].peGreen := i ;
               Pal^.palPalEntry[i].peBlue := i ;
               end;
           end ;

       // Green scale
       PalGreen : Begin
           for i := MinPaletteColor to MaxPaletteColor do begin
               Pal^.palPalEntry[i].peRed := 0;
               Pal^.palPalEntry[i].peGreen := i;
               Pal^.palPalEntry[i].peBlue := 0 ;
               end;
           end ;

       // Red scale
       PalRed : Begin
           for i := MinPaletteColor to MaxPaletteColor do begin
               Pal^.palPalEntry[i].peRed := i;
               Pal^.palPalEntry[i].peGreen := 0;
               Pal^.palPalEntry[i].peBlue := 0 ;
               end;
           end ;

       // Blue scale
       PalBlue : Begin
           for i := MinPaletteColor to MaxPaletteColor do begin
               Pal^.palPalEntry[i].peRed := 0;
               Pal^.palPalEntry[i].peGreen := 0;
               Pal^.palPalEntry[i].peBlue := i ;
               end;
           end ;

       // False colour
       PalFalseColor : begin
           for i := MinPaletteColor to MaxPaletteColor do begin
               if i <= 63 then begin
                  Pal^.palPalEntry[i].peRed := 0 ;
                  Pal^.palPalEntry[i].peGreen := 254 - 4*i ;
                  Pal^.palPalEntry[i].peBlue := 255 ;
                  end
               else if i <= 127 then begin
                  Pal^.palPalEntry[i].peRed := 0 ;
                  Pal^.palPalEntry[i].peGreen := 4*i - 254 ;
                  Pal^.palPalEntry[i].peBlue := 510 - 4*i ;
                  end
               else if i <= 191 then begin
                  Pal^.palPalEntry[i].peRed := 4*i - 510 ;
                  Pal^.palPalEntry[i].peGreen := 255 ;
                  Pal^.palPalEntry[i].peBlue := 0 ;
                  end
               else begin
                  Pal^.palPalEntry[i].peRed := 255 ;
                  Pal^.palPalEntry[i].peGreen := 1022 - 4*i ;
                  Pal^.palPalEntry[i].peBlue := 0 ;
                  end ;
               end;
           // Overload colour = white
           i := MaxPaletteColor ;
           end ;
       end ;

    // Zero entry set to black for all palettes
    i := MinPaletteColor ;
    Pal^.palPalEntry[i].peRed := 0 ;
    Pal^.palPalEntry[i].peGreen := 0 ;
    Pal^.palPalEntry[i].peBlue := 0 ;

    hpal := CreatePalette(Pal^);
//    Bitmap.Palette := CreatePalette(Pal^);
    if hpal <> 0 then Bitmap.Palette := hpal ;

  finally
    FreeMem(Pal);
    end;
  end ;


procedure TMainFrm.bScanImageClick(Sender: TObject);
// ----------------------------
// Scan currently selected area
// ----------------------------
begin
    StartNewScan(0) ;
    end ;


procedure TMainFrm.bScanZoomInClick(Sender: TObject);
// -----------------------------------------------------
// Start new scan of area defined by selection rectangle
// -----------------------------------------------------
begin
    StartNewScan(1) ;
    end;

procedure TMainFrm.bScanZoomOutClick(Sender: TObject);
// --------------------------------------------------------
// Zoom out to previously selected scan area and start scan
// --------------------------------------------------------
begin
    StartNewScan(-1) ;
    end;

procedure TMainFrm.StartNewScan(
          iZoom : Integer ) ;
// ------------------------------------------------------
// Start new scan (iZoom > 0 zoom in, iZoom < 0 zoom out)
// ------------------------------------------------------
var
    i : Integer ;
begin

    if UnsavedRawImage then begin
       if MessageDlg( 'Current Image not saved! Do you want to overwrite image?',
           mtWarning,[mbYes,mbNo], 0 ) = mrNo then Exit ;
    end;

    NumAverages := 1 ;
    ScanRequested := True ;
    ClearAverage := True ;
    bStopScan.Enabled := True ;
    bScanImage.Enabled := False ;

    if cbImageMode.ItemIndex = XYZMode then ckRepeat.Checked := False  ;

    case cbImageMode.ItemIndex of

      // XY and XYZ imaging mode
      XYMode,XYZMode : begin
       if IZoom > 0 then begin
          // Zoom In - Scan area defined by selection rectangle on image
          iScanZoom := iScanZoom + 1 ;
          if (SelectedRect.Left > 0) or (SelectedRect.Top > 0) or
             (SelectedRect.Right < (FrameWidth-1)) or
             (SelectedRect.Bottom < (FrameHeight-1)) then begin
             ScanArea[iScanZoom].Left := ScanArea[iScanZoom-1].Left + (SelectedRect.Left*PixelsToMicronsX) ;
             ScanArea[iScanZoom].Right := ScanArea[iScanZoom-1].Left + (SelectedRect.Right*PixelsToMicronsX) ;
             ScanArea[iScanZoom].Top := ScanArea[iScanZoom-1].Top + (SelectedRect.Top*PixelsToMicronsY) ;
             ScanArea[iScanZoom].Bottom := ScanArea[iScanZoom-1].Top + (SelectedRect.Bottom*PixelsToMicronsY) ;
             ScanArea[iScanZoom].Width := ScanArea[iScanZoom].Right - ScanArea[iScanZoom].Left ;
             ScanArea[iScanZoom].Height := ScanArea[iScanZoom].Bottom - ScanArea[iScanZoom].Top ;
             end
          else iScanZoom := Max(iScanZoom-1,0) ;
          end
        else if iZoom < 0 then begin
          // Zoom out - change to next larger scan area
          iScanZoom := Max(iScanZoom-1,0) ;
          end;

       if rbFastScan.Checked then begin
          // Fast scan
          FrameWidth := FastFrameWidth ;
          FrameHeight := Round(FrameWidth*(ScanArea[iScanZoom].Height/ScanArea[iScanZoom].Width)) ;
          if FrameHeight > FastFrameHeight then begin
             FrameHeightScale := FrameHeight/FastFrameHeight ;
             FrameHeight := FastFrameHeight ;
             end
           else FrameHeightScale := 1.0
          end
        else begin
          // High resolution scan
          FrameWidth := HRFrameWidth ;
          FrameHeight := Round(FrameWidth*(ScanArea[iScanZoom].Height/ScanArea[iScanZoom].Width)) ;
          FrameHeightScale := 1.0 ;
          end;
       end ;

      // XT line scan mode
      XTMode : begin
        if rbFastScan.Checked then FrameWidth := FastFrameWidth
                              else  FrameWidth := HRFrameWidth ;
        FrameHeight := Round(edLineScanFrameHeight.Value) ;
        FrameHeightScale := 1.0 ;
        end ;

      // XZ image mode
      XZMode : begin
        if rbFastScan.Checked then FrameWidth := FastFrameWidth
                              else  FrameWidth := HRFrameWidth ;
        FrameHeight := Round(edNumZSections.Value) ;
        FrameHeightScale := 1.0 ;
        end ;

      end ;

    // Image pixel to microns scaling factor
    PixelsToMicronsX := ScanArea[iScanZoom].Width/FrameWidth ;
    PixelsToMicronsY := FrameHeightScale*PixelsToMicronsX ;

    meStatus.Clear ;
    //meStatus.Lines[0] := format('%d',[MemUsed]);

    // (re)allocate image buffer
    if PImageBuf <> Nil then FreeMem(PImageBuf) ;
    PImageBuf := AllocMem( Int64(FrameWidth*FrameHeight*SizeOf(Integer)) ) ;
    for i := 0 to FrameWidth*FrameHeight-1 do pImageBuf^[i] := 0 ;
    SetImagePanels ;

    SelectedRect.Left := 0 ;
    SelectedRect.Right := FrameWidth-1 ;
    SelectedRect.Top := 0 ;
    SelectedRect.Bottom := FrameHeight-1 ;

    // Z sections
    ZSection := 0 ;
    NumZSectionsAvailable := 0 ;
    ZStep := edNumPixelsPerZStep.Value*(ScanArea[iScanZoom].Width/FrameWidth) ;
    edMicronsPerZStep.Value := ZStep ;
    NumZSections := Round(edNumZSections.Value) ;

    end ;


procedure TMainFrm.StartScan ;
// ---------------
// Scan image scan
// ---------------
var
    i : Integer ;
begin

    // Stop A/D & D/A
    MemUsed := 0 ;
    ADCPointer := 0 ;
    if LabIO.ADCActive[DeviceNum] then LabIO.StopADC(DeviceNum) ;
    if LabIO.DACActive[DeviceNum] then LabIO.StopDAC(DeviceNum) ;

    // Skip

    CreateScanWaveform ;

    if ClearAverage then begin
       // Dispose of existing display buffers and create new ones
       if AvgBuf <> Nil then FreeMem( AvgBuf ) ;
       AvgBuf := AllocMem( Int64(NumPixels)*2 ) ;
       for i := 0 to NumPixels-1 do AvgBuf^[i] := 0 ;
       ClearAverage := False ;
       NumAverages := 1 ;
       end ;

    ADCPointer := 0 ;
    ADCNumNewSamples := 0 ;

    ADCPointer := 0 ;

  {  iMax := -32767 ;
    iMin := 32767 ;
    for i := 0 to NumPixels-1 do begin
      if DACBuf^[i] < iMin then iMin := DACBuf^[i] ;
      if DACBuf^[i] > iMax then iMax := DACBuf^[i] ;
    end;

    OutputDebugString(pchar(format('%d %d',[iMin,iMax]))) ;}
//    if TempBuf <> Nil  then FreeMem(TempBuf) ;
//    TempBuf := AllocMem( NumYPixels*NumXPixels*2 ) ;


    LabIO.ADCToMemoryExtScan( DeviceNum,
                              ADCBuf^,
                              ADCInput,
                              1,
                              NumXPixels*Min(NumYPixels,100),
                              LabIO.ADCVoltageRanges[DeviceNum,cbADCVoltageRange.ItemIndex],
                              True,
                              DeviceNum ) ;

    LabIO.MemoryToDAC( DeviceNum,
                       DACBuf^,
                       2,
                       NumPixels,
                       NumPixelsinDACBuf,
                       PixelDwellTime,
                       False,
                       False,
                      DeviceNum ) ;

    bStopScan.Enabled := True ;
    bScanImage.Enabled := False ;

    end;


procedure TMainFrm.bFullScaleClick(Sender: TObject);
// --------------------------------------------------------
// Set display grey scale to full intensity range of camera
// --------------------------------------------------------
var
    FT : Integer ;
begin

     FT := 0 ;
     edDisplayIntensityRange.LoValue := 0 ;
    GreyLo := Round(edDisplayIntensityRange.LoValue) ;
     edDisplayIntensityRange.HiValue := ADCMaxValue ;
     GreyHi := Round(edDisplayIntensityRange.HiValue) ;

     MainFrm.UpdateLUT( ADCMaxValue ) ;
     //DisplayImage( 1, pImageBuf, MainFrm.LUTs[FT*LUTSize],BitMap,Image1 ) ;

     // Set intensity range and sliders
     SetDisplayIntensityRange( GreyLo,
                               GreyHi ) ;

     UpdateDisplay := True ;
     end ;


procedure TMainFrm.edDisplayIntensityRangeKeyPress(Sender: TObject;
  var Key: Char);
// ------------------------------
// Update display intensity range
// ------------------------------
var
    FT : Integer ;
begin

     if key <> #13 then Exit ;

     FT := 0 ;

     if edDisplayIntensityRange.LoValue = edDisplayIntensityRange.HiValue then begin
        edDisplayIntensityRange.LoValue := edDisplayIntensityRange.LoValue - 1.0 ;
        edDisplayIntensityRange.HiValue := edDisplayIntensityRange.HiValue + 1.0 ;
        end ;

     GreyLo := Round(edDisplayIntensityRange.LoValue) ;
     GreyHi := Round(edDisplayIntensityRange.HiValue) ;

     UpdateLUT( ADCMaxValue ) ;

     // Set intensity range and sliders
     SetDisplayIntensityRange( GreyLo,
                               GreyHi ) ;
     UpdateDisplay := True ;
     end;


procedure TMainFrm.edMicronsPerZStepKeyPress(Sender: TObject; var Key: Char);
// -------------------------
// Microns per Z step changed
// -------------------------
begin
      if Key = #13 then begin
         edNumPixelsPerZStep.Value := Max(Round(edMicronsPerZStep.Value / (ScanArea[iScanZoom].Width/FrameWidth)),1) ;
         edMicronsPerZStep.Value := edNumPixelsPerZStep.Value*(ScanArea[iScanZoom].Width/FrameWidth) ;
         end;
      end;


procedure TMainFrm.edNumPixelsPerZStepKeyPress(Sender: TObject; var Key: Char);
// -------------------------
// Pixels per Z step changed
// -------------------------
begin
      if Key = #13 then begin
         edMicronsPerZStep.Value := edNumPixelsPerZStep.Value*(ScanArea[iScanZoom].Width/FrameWidth) ;
         end;
      end;


procedure TMainFrm.bGotoZPositionClick(Sender: TObject);
// -------------------------
// Go to specified Z position
// --------------------------
begin
    ZStage.MoveTo( edGoToZPosition.Value ) ;
    end;


procedure TMainFrm.bMaxContrastClick(Sender: TObject);
// -------------------------------------------------------------
// Request display intensity range to be set for maximum contrast
// -------------------------------------------------------------
begin

    CalculateMaxContrast ;

    //DisplayImage( 1, pImageBuf, MainFrm.LUTs[FT*LUTSize],BitMap,Image1 ) ;

     // Set intensity range and sliders
     SetDisplayIntensityRange( GreyLo,
                               GreyHi ) ;
     UpdateDisplay := True ;
     //OptimiseContrastNeeded := False ;

     end;


procedure TMainFrm.CalculateMaxContrast ;
// ---------------------------------------------------------
// Calculate and set display for maximum grey scale contrast
// ---------------------------------------------------------
const
    MaxPoints = 10000 ;
var
     i,NumPixels,iStep : Integer ;
     z,zMean,zSD,zSum : Single ;
     iz,ZMin,ZMax,ZLo,ZHi,ZThreshold : Integer ;
     FrameType : Integer ;
begin

    NumPixels := FrameWidth*FrameHeight - 4 ;
    FrameType := 0 ;
    if NumPixels < 2 then Exit ;

    iStep := Max(NumPixels div MaxPoints,1) ;

    if ckContrast6SDOnly.Checked then begin
       // Set contrast range to +/- 3 x standard deviation
       ZSum := 0.0 ;
       for i := 0 to NumPixels - 1 do begin
          ZSum := ZSum + pImageBuf^[i] ;
          end ;
       ZMean := ZSum / NumPixels ;

       ZSum := 0.0 ;
       i := 0 ;
       repeat
          Z :=pImageBuf^[i] ;
          ZSum := ZSum + (Z - ZMean)*(Z - ZMean) ;
          i := i + iStep ;
       until i >= NumPixels ;
       ZSD := Sqrt( ZSum / (NumPixels-1) ) ;

       ZLo := Max( Round(ZMean - 3*ZSD),0) ;
       ZHi := Min( Round(ZMean + 3*ZSD), ADCMaxValue );

       end
    else begin
       // Set contrast range to min-max
       ZMin := ADCMaxValue ;
       ZMax := 0 ;
       i := 0 ;
       repeat
          iz := pImageBuf^[i] ;
          if iz < ZMin then ZMin := iz ;
          if iz > ZMax then ZMax := iz ;
          i := i + iStep ;
       until i >= NumPixels ;
       ZLo := ZMin ;
       ZHi := ZMax ;
       end ;

    // Update contrast
    ZThreshold := Max((ADCMaxValue div 50),2) ;
    if (not ckAutoOptimise.Checked) or
       (Abs(MainFrm.GreyLo- ZLo) > 10) then MainFrm.GreyLo := ZLo ;
    if (not ckAutoOptimise.Checked) or
       (Abs(MainFrm.GreyHi- ZHi) > 10) then MainFrm.GreyHi := ZHi ;

    // Ensure a non-zero LUT range
    if MainFrm.GreyLo = MainFrm.GreyHi then begin
       MainFrm.GreyLo := MainFrm.GreyLo - 1 ;
       MainFrm.GreyHi := MainFrm.GreyHi + 1 ;
       end ;

    UpdateLUT(ADCMaxValue ) ;

    end ;


procedure TMainFrm.TimerTimer(Sender: TObject);
// -------------------------
// Regular timed operations
// --------------------------
begin
    //if pImageBuf = Nil then Exit ;

    if ScanRequested then begin
       ScanRequested := False ;
       StartScan ;
    end ;

    //LabIO.GetADCSamples(DeviceNum, ADCBuf^ );
    GetImageFromPMT ;

    if UpdateDisplay then begin ;
       UpdateImage ;
       UpdateDisplay := False ;
    end ;

    if ZStage.Enabled then begin
       ZStage.UpdateZPosition ;
       edZTop.Text := format('%.2f um',[ZStage.ZPosition]) ;
       end;

end;


procedure TMainFrm.GetImageFromPMT ;
// ------------------
// Get image from PMT
// ------------------
var
    i,iPointer,iPointerStep,iScan,iSign : Integer ;
    //pBuf : PIntArray ;
begin


    if not LabIO.DACActive[DeviceNum] then exit ;

    // Read new A/D converter samples
    LabIO.GetADCSamples( DeviceNum, ADCBuf^,ADCNumNewSamples,
                         DACBuf, YStartMicrons,YScale, YLineSpacingMicrons, NumXPixels ) ;

    // Copy image from circular buffer into 32 bit display buffer

    if InvertPMTSignal then iSign := -1
                       else iSign := 1 ;

    for i := 0 to ADCNumNewSamples-1 do begin
      //    TempBuf^[ADCPointer] := ADCBuf^[i] ;
          iPointer := ADCMap^[ADCPointer] ;
          iPointerStep := ADCMap^[ADCPointer+1] - iPointer ;
          AvgBuf^[ADCPointer] := AvgBuf^[ADCPointer] + ADCBuf^[i] ;
          pImageBuf^[iPointer] := iSign*(AvgBuf^[ADCPointer] div NumAverages) + BlackLevel ;
          if pImageBuf^[iPointer] < 0 then pImageBuf^[iPointer] := 0 ;
          if pImageBuf^[iPointer] > ADCMaxValue then pImageBuf^[iPointer] := ADCMaxValue ;
          if Abs(iPointerStep) = 2 then begin
             iPointer := iPointer + Sign(iPointerStep) ;
             pImageBuf^[iPointer] := iSign*(AvgBuf^[ADCPointer] div NumAverages) + BlackLevel ;
             if pImageBuf^[iPointer] < 0 then pImageBuf^[iPointer] := 0 ;
             if pImageBuf^[iPointer] > ADCMaxValue then pImageBuf^[iPointer] := ADCMaxValue ;
          end ;
          Inc(ADCPointer) ;
    end ;
    ADCNumNewSamples := 0 ;

    // Copy image to display bitmap
    iScan := ADCPointer div (NumXPixels) + 1 ;
    meStatus.Clear ;
    meStatus.Lines[0] := format('Line %d/%d (%.2f MB)',[iScan div 2,NumYPixels div 2,
                                                      ADCPointer/1048576.0]);
    meStatus.Lines.Add(format('Average %d/%d',[NumAverages,Round(edNumAverages.Value)])) ;
    if cbImageMode.ItemIndex = XYZMode then begin
       meStatus.Lines.Add(format('Section %d/%d',[ZSection+1,NumZSections])) ;
    end;

    meStatus.Lines.Add( ScanInfo ) ;


    if ADCPointer >= (NumPixels-4) then begin

       Inc(NumAverages) ;
       SaveRawImage( RawImagesFileName, ZSection ) ;

       if NumAverages <= Round(edNumAverages.Value) then begin
          ScanRequested := True ;
       end
       else begin
          if ckRepeat.Checked and (not bScanImage.Enabled) then begin
             ScanRequested := True ;
             NumAverages := 1 ;
             ClearAverage := True ;
             end
          else if cbImageMode.ItemIndex = XYZMode then begin
             // Increment Z position to next Section
             Inc(ZSection) ;
             if ZSection < NumZSections then begin
                ZStage.MoveTo( ZStage.ZPosition + ZStep );
                ScanRequested := True ;
                NumAverages := 1 ;
                ClearAverage := True ;
                end
             else begin
                bStopScan.Click ;
             end ;
          end
          else begin
             bStopScan.Click ;
          end;
       end ;
    end ;
    UpdateDisplay := True ;
    end ;


procedure TMainFrm.bStopScanClick(Sender: TObject);
// -------------
// Stop scanning
// -------------
//var
//    FileHandle : Integer ;
begin


//    FileHandle := FileCreate(  'ADC.DAT' ) ;
//    FileWrite( FileHandle, TempBuf^, (ADCPointer-1)*2 ) ;
//    FileCLose( FileHandle ) ;
//    FreeMem(TempBuf) ;
 //   TempBuf := Nil ;

    if LabIO.ADCActive[DeviceNum] then LabIO.StopADC(DeviceNum) ;
    if LabIO.DACActive[DeviceNum] then LabIO.StopDAC(DeviceNum) ;
    LabIO.WriteDACs( DeviceNum,[0.0,0.0],2);

    if AvgBuf <> Nil then begin
      FreeMem(AvgBuf) ;
      AvgBuf := Nil ;
    end;

    if DACBuf <> Nil then begin
      FreeMem(DACBuf) ;
      DACBuf := Nil ;
    end;

    bStopScan.Enabled := False ;
    bScanImage.Enabled := True ;
    ScanRequested := False ;

    // if Z stack image, display first section in stack
    if cbImageMode.ItemIndex = XYZMode then begin
       scZSection.Position := 0 ;
       end;

    end;


procedure TMainFrm.bZoomInClick(Sender: TObject);
// ---------------
// Magnify display
// ---------------
begin
    Inc(Magnification) ;
    Resize ;
    UpdateDisplay := True ;
    end;

procedure TMainFrm.bZoomOutClick(Sender: TObject);
// -----------------
// Demagnify display
// -----------------
begin

     Magnification := Max(Magnification-1,1) ;

     Resize ;
     UpdateDisplay := True ;
     end;


procedure TMainFrm.bSnapImageClick(Sender: TObject);
// --------------------------
// Save current image to file
// --------------------------
var
    SectionFileName,FileName : String ;
    iSection : Integer ;
    iNum : Integer ;
begin

     SaveDialog.InitialDir := SaveDirectory ;

     // Create a file name
     iNum := 0 ;
     repeat
        Inc(iNum) ;
        if NumZSectionsAvailable > 1 then begin
           FileName := SaveDialog.InitialDir + '\'
                       + FormatDateTime('yyyy-mm-dd',Now)
                       + format(' %d-1',[iNum]) ;
        end
        else begin
           FileName := SaveDialog.InitialDir
                       + FormatDateTime('yyyy-mm-dd',Now)
                       + format(' %d',[iNum]) ;
        end;
     until not FileExists(FileName + '.ome.tif' ) ;

     FileName := SaveDialog.InitialDir + '\'
                       + FormatDateTime('yyyy-mm-dd',Now)
                       + format(' %d',[iNum]) ;

     // Open save file dialog
     SaveDialog.FileName := ExtractFileName(FileName) ;

     if not SaveDialog.Execute then Exit ;

     // Ensure extension is set
     FileName := ChangeFileExt(SaveDialog.FileName, '.tif' ) ;
     Filename := ReplaceText( FileName, '.ome.tif', '.tif' ) ;
     SaveDirectory := ExtractFilePath(SaveDialog.FileName) ;


     // Save image
     for iSection  := 0 to NumZSectionsAvailable-1 do begin

        meStatus.Lines.Clear ;
        mestatus.Lines[0] := format('Saving to file %d/%d',[iSection+1,NumZSectionsAvailable]);

        if NumZSectionsAvailable > 1 then begin
           SectionFileName := ANSIReplaceText( FileName, '.tif', format('-%d.ome.tif',[iSection+1])) ;
        end
        else begin
          SectionFileName := ANSIReplaceText( FileName, '.tif', '.ome.tif') ;
        end;

        // Check if file exists already
        if FileExists( SectionFileName ) then begin
           if MessageDlg( format(
           'File %s already exists! Do you want to overwrite it? ',[SectionFileName]),
           mtWarning,[mbYes,mbNo], 0 ) = mrNo then Exit ;
        end ;

        // Load image
        LoadRawImage( RawImagesFileName, iSection ) ;

        // Create file
        if not ImageFile.CreateFile( SectionFileName,
                                     FrameWidth,
                                     FrameHeight,
                                     2*8,
                                     1,
                                     True ) then Exit ;

         ImageFile.XResolution := ScanArea[iScanZoom].Width/FrameWidth ;
         ImageFile.YResolution := ImageFile.XResolution ;
         ImageFile.ZResolution := ZStep ;
         ImageFile.SaveFrame32( 1, PImageBuf ) ;

         // Close file
         ImageFile.CloseFile ;

         UnsavedRawImage := False ;

         end;

mestatus.Lines.Add('File saved') ;

end;



procedure TMainFrm.cbImageModeChange(Sender: TObject);
// ------------------
// Image mode changed
// ------------------
begin
    ZStackGrp.Visible := False ;
    LineScanGrp.Visible := False ;
    case cbImageMode.ItemIndex of
       XYZMode,XZMode : ZStackGrp.Visible := True ;
       XTMode : LineScanGrp.Visible := True ;
       end ;

    end;

procedure TMainFrm.cbPaletteChange(Sender: TObject);
// ------------------------------
// Display colour palette changed
// ------------------------------
begin
     PaletteType := TPaletteType(cbPalette.Items.Objects[cbPalette.ItemIndex]) ;
     if BitMap <> Nil then SetPalette( BitMap, PaletteType ) ;

     UpdateDisplay := True ;
     end;


procedure TMainFrm.ckLineScanClick(Sender: TObject);
// ----------------------
// Line scan mode changed
// ----------------------
begin
    UpdateDisplay := True ;
    end;

procedure TMainFrm.mnExitClick(Sender: TObject);
// ------------
// Stop program
// ------------
begin
    Close ;
    end;

procedure TMainFrm.mnScanSettingsClick(Sender: TObject);
// --------------------------
// Show Scan Settings dialog
// --------------------------
begin

     // Close control ports
     //if  LaserControlOpen then CloseCOMPort( LaserControlCOMHandle, LaserControlOpen) ;
     //if  ZControlOpen then CloseCOMPort(  ZControlCOMHandle, ZControlOpen) ;

     SettingsFrm.ShowModal ;

     //Re-open control port (if in use)
     if LaserControlEnabled then begin
     //   LaserControlOpen := OpenComPort( LaserControlCOMHandle, LaserControlCOMPort, CBR_9600 ) ;
        end
     else LaserControlOpen := False ;

     // Z stage control
 //    if ZControlEnabled then begin
  //      ZControlOpen := OpenComPort( ZControlCOMHandle, ZControlCOMPort, CBR_9600 ) ;
  //      end
 //    else ZControlOpen := False ;

     end;



procedure TMainFrm.edXPixelsKeyPress(Sender: TObject; var Key: Char);
// --------------------------
// No. of X pixels changed
// --------------------------
begin
     if Key = #13 then UpdateDisplay := True ;
     end;

procedure TMainFrm.edYPixelsKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then UpdateDisplay := True ;
     end;



procedure TMainFrm.FormResize(Sender: TObject);
// ---------------------------------
// Resize controls when form resized
// ---------------------------------
begin

  ImageGrp.Width := Max(ClientWidth - ImageGrp.Left - 5,2) ;
  ImageGrp.Height := Max(ClientHeight - ImageGrp.Top - 5,2) ;

  DisplayMaxWidth := ImageGrp.ClientWidth - Image1.Left - 5 ;
  DisplayMaxHeight := ImageGrp.ClientHeight - Image1.Top - 5 - ZSectionPanel.Height ;

  SetImagePanels ;
  UpdateDisplay := True ;

end;


procedure TMainFrm.rbFastScanClick(Sender: TObject);
// ------------------
// Fast scan selected
// ------------------
begin
     rbHRScan.Checked := False ;
     end;

procedure TMainFrm.rbHRScanClick(Sender: TObject);
// ----------------------
// Hi res. scan selected
// ----------------------
begin
     rbFastScan.Checked := False ;
     end;



procedure TMainFrm.scZSectionChange(Sender: TObject);
// ---------------
// Z Section changed
// ---------------
begin

     ZSection := scZSection.Position ;
     LoadRawImage( RawImagesFileName, ZSection ) ;
     UpdateDisplay := True ;
     end;


procedure TMainFrm.LaserIntensityTrackBarChange(Sender: TObject);
// --------------------------------------------
// Laser intensity track bar position changed
// --------------------------------------------
begin
     edLaserIntensity.Value := LaserIntensityTrackBar.Position*0.001 ;
     LaserIntensityTrackBar.Position := Round(1000*edLaserIntensity.Value) ;
     UpdateDisplay := True ;
     end;


procedure TMainFrm.SaveRawImage(
          FileName : String ;    // File to save to
          iSection : Integer     // Image Section number
          ) ;
// ----------------------
// Save raw image to file
// ----------------------
var
    iBuf16 : PBig16BitArray ;
    FileHandle : THandle ;
    FilePointer : Int64 ;
    i,NumPixels : Integer ;
begin

      // Copy into I/O buf
      NumPixels := FrameWidth*FrameHeight ;
      iBuf16 := AllocMem( Int64(NumPixels*Sizeof(Integer))) ;
      for i := 0 to NumPixels-1 do iBuf16^[i] := PImageBuf^[i] ;

//      for i := 0 to FrameWidth*5-1 do iBuf16^[i] := iSection ;

      if not FileExists(FileName) then FileHandle := FileCreate( FileName )
                                  else FileHandle := FileOpen( FileName, fmOpenWrite ) ;

      NumZSectionsAvailable := Max(NumZSectionsAvailable,iSection+1) ;
      scZSection.Max := NumZSectionsAvailable -1 ;
      scZSection.Position := iSection ;
      lbZSection.Caption := Format('Section %d/%d',[iSection+1,NumZSectionsAvailable]);

      FileWrite( FileHandle, NumZSectionsAvailable, Sizeof(FrameWidth)) ;
      FileWrite( FileHandle, FrameWidth, Sizeof(FrameWidth)) ;
      FileWrite( FileHandle, FrameHeight, Sizeof(FrameHeight)) ;
      FileWrite( FileHandle, iScanZoom, Sizeof(iScanZoom)) ;
      FileWrite( FileHandle, ScanArea, Sizeof(ScanArea)) ;

      FileWrite( FileHandle, ZStep, Sizeof(ZStep)) ;

      FilePointer := FileSeek( FileHandle, 0, 1 ) ;
      FilePointer := FilePointer +
                     Int64(iSection)*Int64(NumPixels)*Int64(Sizeof(Integer)) ;
      FileSeek( FileHandle, FilePointer, 0 ) ;
      FileWrite( FileHandle, iBuf16^, NumPixels*Sizeof(Integer)) ;
      FileClose(FileHandle) ;
      FreeMem(iBuf16) ;

      // Set unsaved flag if image is high res.
      UnsavedRawImage := rbHRScan.Checked ;

      end;


procedure TMainFrm.LoadRawImage(
          FileName : String ;    // File to save to
          iSection : Integer     // Image Section number
          ) ;
// ----------------------
// Load raw image to file
// ----------------------
var
    iBuf16 : PBig16BitArray ;
    FileHandle : THandle ;
    FilePointer : Int64 ;
    i,NumPixels : Integer ;
begin

      FileHandle := FileOpen( FileName, fmOpenRead ) ;

      FileRead( FileHandle, NumZSections, Sizeof(FrameWidth)) ;
      FileRead( FileHandle, FrameWidth, Sizeof(FrameWidth)) ;
      FileRead( FileHandle, FrameHeight, Sizeof(FrameHeight)) ;
      FileRead( FileHandle, iScanZoom, Sizeof(iScanZoom)) ;
      FileRead( FileHandle, ScanArea, Sizeof(ScanArea)) ;
      FileRead( FileHandle, ZStep, Sizeof(ZStep)) ;
      NumPixels := FrameWidth*FrameHeight ;
      iBuf16 := AllocMem( Int64(NumPixels*Sizeof(Integer))) ;

      // (re)allocate full field buffer
      if PImageBuf = Nil then PImageBuf := AllocMem( NumPixels*SizeOf(Integer) ) ;

      FilePointer := FileSeek( FileHandle, 0, 1 ) ;
      FilePointer := FilePointer +
                     Int64(iSection)*Int64(NumPixels)*Int64(Sizeof(Integer)) ;
      FileSeek( FileHandle, FilePointer, 0 ) ;
      FileRead( FileHandle, iBuf16^, NumPixels*Sizeof(Integer)) ;

      for i := 0 to NumPixels-1 do PImageBuf^[i] := iBuf16^[i] ;

      FileClose(FileHandle) ;
      FreeMem(iBuf16) ;

      end;

procedure TMainFrm.SaveSettingsToXMLFile(
           FileName : String
           ) ;
// ------------------------------------------
// Save settings to XML file (public method)
// ------------------------------------------
begin
    CoInitialize(Nil) ;
    SaveSettingsToXMLFile1( FileName ) ;
    CoUnInitialize ;
    end ;


procedure  TMainFrm.SaveSettingsToXMLFile1(
           FileName : String
           ) ;
// ----------------------------------
// Save stimulus protocol to XML file
// ----------------------------------
var
   iNode,ProtNode : IXMLNode;
   s : TStringList ;
   XMLDoc : IXMLDocument ;
begin

    if FileName = '' then Exit ;

    XMLDoc := TXMLDocument.Create(Self);
    XMLDoc.Active := True ;

    // Clear document
    XMLDoc.ChildNodes.Clear ;

    // Add record name
    ProtNode := XMLDoc.AddChild( 'MESOSCANSETTINGS' ) ;

    AddElementInt( ProtNode, 'FASTFRAMEWIDTH', FastFrameWidth ) ;
    AddElementInt( ProtNode, 'FASTFRAMEHEIGHT', FastFrameHeight ) ;
    AddElementInt( ProtNode, 'HRFRAMEWIDTH', HRFrameWidth ) ;
    AddElementInt( ProtNode, 'LINESCANFRAMEHEIGHT', Round(edLineScanFrameHeight.Value) ) ;

    AddElementInt( ProtNode, 'PALETTE', cbPalette.ItemIndex ) ;

    AddElementBool( ProtNode, 'BIDIRECTIONALSCAN', BiDirectionalScan ) ;
    AddElementBool( ProtNode, 'CORRECTSINEWAVEDISTORTION', CorrectSineWaveDistortion ) ;
    AddElementBool( ProtNode, 'REPEATSCANS', ckRepeat.Checked ) ;
    AddElementBool( ProtNode, 'INVERTPMTSIGNAL', InvertPMTSignal ) ;

    AddElementInt( ProtNode, 'NUMAVERAGES', NumAverages ) ;
    AddElementDouble( ProtNode, 'MAXSCANRATE', MaxScanRate ) ;
    AddElementDouble( ProtNode, 'MINPIXELDWELLTIME', MinPixelDwellTime ) ;
    AddElementInt( ProtNode, 'NUMAVERAGES', NumAverages ) ;
    AddElementInt( ProtNode, 'BLACKLEVEL', BlackLevel ) ;

    AddElementDouble( ProtNode, 'XVOLTSPERMICRON', XVoltsPerMicron ) ;
    AddElementDouble( ProtNode, 'YVOLTSPERMICRON', YVoltsPerMicron ) ;
    AddElementDouble( ProtNode, 'PHASESHIFT', PhaseShift ) ;
    AddElementDouble( ProtNode, 'LASERINTENSITY', LaserIntensity ) ;
    AddElementDouble( ProtNode, 'FULLFIELDWIDTHMICRONS', FullFieldWidthMicrons ) ;
    AddElementDouble( ProtNode, 'ADCVOLTAGERANGE', ADCVoltageRange ) ;

    // Z stack
    iNode := ProtNode.AddChild( 'ZSTACK' ) ;
    AddElementInt( iNode, 'NUMZSECTIONS', Round(edNUMZSections.Value) ) ;
    AddElementInt( iNode, 'NUMPIXELSPERZSTEP', Round(edNumPixelsPerZStep.Value) ) ;

    // Laser control
    iNode := ProtNode.AddChild( 'LASER' ) ;
//    AddElementBool( iNode, 'ENABLED', ZStage.Enabled ) ;
//    AddElementInt( iNode, 'COMPORT', LaserControlComPort ) ;

    // Z stage
    iNode := ProtNode.AddChild( 'ZSTAGE' ) ;
    AddElementBool( iNode, 'ENABLED', ZStage.Enabled ) ;
    AddElementInt( iNode, 'COMPORT', ZStage.ComPort ) ;
    AddElementInt( iNode, 'BAUDRATE', ZStage.BaudRate ) ;
    AddElementDouble( iNode, 'STEPSPERMICRON', ZStage.StepsPerMicron ) ;

    AddElementText( ProtNode, 'SAVEDIRECTORY', SaveDirectory ) ;

     s := TStringList.Create;
     s.Assign(xmlDoc.XML) ;
     //sl.Insert(0,'<!DOCTYPE ns:mys SYSTEM "myXML.dtd">') ;
     s.Insert(0,'<?xml version="1.0"?>') ;
     s.SaveToFile( FileName ) ;
     s.Free ;
     XMLDoc.Active := False ;
     XMLDoc := Nil ;

    end ;


procedure TMainFrm.LoadSettingsFromXMLFile(
          FileName : String                    // XML protocol file
          ) ;
// ----------------------------------
// Load settings from XML file
// ----------------------------------
begin
    CoInitialize(Nil) ;
    LoadSettingsFromXMLFile1( FileName ) ;
    CoUnInitialize ;
    end ;


procedure TMainFrm.LoadSettingsFromXMLFile1(
          FileName : String                    // XML protocol file
          ) ;
// ----------------------------------
// Load settings from XML file
// ----------------------------------
var
   iNode,ProtNode : IXMLNode;
   iValue : Integer ;

   NodeIndex : Integer ;
   XMLDoc : IXMLDocument ;
   bValue : Boolean ;
begin

    if not FileExists(FileName) then Exit ;

    XMLDoc := TXMLDocument.Create(Self) ;

    XMLDOC.Active := False ;

    XMLDOC.LoadFromFile( FileName ) ;
    XMLDoc.Active := True ;

    ProtNode := xmldoc.DocumentElement ;

    GetElementInt( ProtNode, 'FASTFRAMEWIDTH', FastFrameWidth ) ;
    GetElementInt( ProtNode, 'FASTFRAMEHEIGHT', FastFrameHeight ) ;
    GetElementInt( ProtNode, 'HRFRAMEWIDTH', HRFrameWidth ) ;
    GetElementInt( ProtNode, 'LINESCANFRAMEHEIGHT', iValue ) ;
    edLineScanFrameHeight.Value := iValue ;

    GetElementInt( ProtNode, 'PALETTE', iValue ) ;
    cbPalette.ItemIndex := iValue ;
    PaletteType := TPaletteType(cbPalette.Items.Objects[cbPalette.ItemIndex]) ;
    if BitMap <> Nil then SetPalette( BitMap, PaletteType ) ;

    GetElementBool( ProtNode, 'BIDIRECTIONALSCAN', BiDirectionalScan ) ;
    GetElementBool( ProtNode, 'CORRECTSINEWAVEDISTORTION', CorrectSineWaveDistortion ) ;

    GetElementBool( ProtNode, 'REPEATSCANS', bValue ) ;
    ckRepeat.Checked := bValue ;
    GetElementBool( ProtNode, 'INVERTPMTSIGNAL', InvertPMTSignal ) ;

    GetElementInt( ProtNode, 'NUMAVERAGES', NumAverages ) ;
    GetElementDouble( ProtNode, 'MAXSCANRATE', MaxScanRate ) ;
    GetElementDouble( ProtNode, 'MINPIXELDWELLTIME', MinPixelDwellTime ) ;
    GetElementInt( ProtNode, 'NUMAVERAGES', NumAverages ) ;
    GetElementInt( ProtNode, 'BLACKLEVEL', BlackLevel ) ;

    GetElementDouble( ProtNode, 'XVOLTSPERMICRON', XVoltsPerMicron ) ;
    GetElementDouble( ProtNode, 'YVOLTSPERMICRON', YVoltsPerMicron ) ;
    GetElementDouble( ProtNode, 'PHASESHIFT', PhaseShift ) ;
    GetElementDouble( ProtNode, 'LASERINTENSITY', LaserIntensity ) ;
    GetElementDouble( ProtNode, 'FULLFIELDWIDTHMICRONS', FullFieldWidthMicrons ) ;
    GetElementDouble( ProtNode, 'ADCVOLTAGERANGE', ADCVoltageRange ) ;

    While FindXMLNode(ProtNode,'ZSTACK',iNode,NodeIndex) do begin
       GetElementInt( iNode, 'NUMZSECTIONS', iValue ) ;
       edNUMZSections.Value := iValue ;
       GetElementInt( iNode, 'NUMPIXELSPERZSTEP', iValue ) ;
       edNumPixelsPerZStep.Value := iValue ;
       end ;

    // Laser control
    NodeIndex := 0 ;
    While FindXMLNode(ProtNode,'LASER',iNode,NodeIndex) do begin
        //GetElementBool( iNode, 'ENABLED', bValue ) ;
        //ZStage.Enabled := bValue ;
        //GetElementInt( iNode, 'COMPORT', iValue ) ;
        //ZStage.ComPort := iValue ;
        Inc(NodeIndex) ;
        end ;

    // Z stage
    NodeIndex := 0 ;
    While FindXMLNode(ProtNode,'ZSTAGE',iNode,NodeIndex) do begin
      GetElementBool( iNode, 'ENABLED', bValue ) ;
      ZStage.Enabled := bValue ;
      GetElementInt( iNode, 'COMPORT', iValue ) ;
      ZStage.COMPort := iValue ;
      GetElementInt( iNode, 'BAUDRATE', iValue ) ;
      ZStage.BaudRate := iValue ;
      GetElementDouble( iNode, 'STEPSPERMICRON', ZStage.StepsPerMicron ) ;
      Inc(NodeIndex) ;
      end ;

    GetElementText( ProtNode, 'SAVEDIRECTORY', SaveDirectory ) ;

    XMLDoc.Active := False ;
    XMLDoc := Nil ;

    end ;


procedure TMainFrm.FormDestroy(Sender: TObject);
// ------------------------------
// Tidy up when form is destroyed
// ------------------------------
begin
     Bitmap.ReleasePalette ;
     BitMap.Free ;
     BitMap := Nil ;
     end;


procedure TMainFrm.AddElementDouble(
          ParentNode : IXMLNode ;
          NodeName : String ;
          Value : Double
          ) ;
// -------------------------------
// Add element with value to node
// -------------------------------
var
   ChildNode : IXMLNode;
begin

    ChildNode := ParentNode.AddChild( NodeName ) ;
    ChildNode.Text := format('%.10g',[Value]) ;

    end ;


function TMainFrm.GetElementDouble(
         ParentNode : IXMLNode ;
         NodeName : String ;
         var Value : Double
          ) : Boolean ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   OldValue : Single ;
   NodeIndex : Integer ;
   s : string ;
begin
    Result := False ;
    OldValue := Value ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then begin
       { Correct for use of comma/period as decimal separator }
       s := ChildNode.Text ;
       if (FormatSettings.DECIMALSEPARATOR = '.') then s := ANSIReplaceText(s , ',',FormatSettings.DECIMALSEPARATOR);
       if (FormatSettings.DECIMALSEPARATOR = ',') then s := ANSIReplaceText( s, '.',FormatSettings.DECIMALSEPARATOR);
       try

          Value := StrToFloat(s) ;
          Result := True ;
       except
          Value := OldValue ;
          Result := False ;
          end ;
       end ;

    end ;


procedure TMainFrm.AddElementInt(
          ParentNode : IXMLNode ;
          NodeName : String ;
          Value : Integer
          ) ;
// -------------------------------
// Add element with value to node
// -------------------------------
var
   ChildNode : IXMLNode;
begin

    ChildNode := ParentNode.AddChild( NodeName ) ;
    ChildNode.Text := format('%d',[Value]) ;

    end ;


function TMainFrm.GetElementInt(
          ParentNode : IXMLNode ;
          NodeName : String ;
          var Value : Integer
          ) : Boolean ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   NodeIndex : Integer ;
   OldValue : Integer ;
begin
    Result := False ;
    OldValue := Value ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then begin
       try
          Value := StrToInt(ChildNode.Text) ;
          Result := True ;
       except
          Value := OldValue ;
          Result := False ;
          end ;
       end ;
    end ;


procedure TMainFrm.AddElementBool(
          ParentNode : IXMLNode ;
          NodeName : String ;
          Value : Boolean
          ) ;
// -------------------------------
// Add element with value to node
// -------------------------------
var
   ChildNode : IXMLNode;
begin

    ChildNode := ParentNode.AddChild( NodeName ) ;
    if Value = True then ChildNode.Text := 'T'
                    else ChildNode.Text := 'F' ;

    end ;


function TMainFrm.GetElementBool(
          ParentNode : IXMLNode ;
          NodeName : String ;
          var Value : Boolean
          ) : Boolean ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   NodeIndex : Integer ;
begin
    Result := False ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then begin
       if ANSIContainsText(ChildNode.Text,'T') then Value := True
                                               else  Value := False ;
       Result := True ;
       end ;

    end ;


procedure TMainFrm.AddElementText(
          ParentNode : IXMLNode ;
          NodeName : String ;
          Value : String
          ) ;
// -------------------------------
// Add element with value to node
// -------------------------------
var
   ChildNode : IXMLNode;
begin

    ChildNode := ParentNode.AddChild( NodeName ) ;
    ChildNode.Text := Value ;

    end ;


function TMainFrm.GetElementText(
          ParentNode : IXMLNode ;
          NodeName : String ;
          var Value : String
          ) : Boolean ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   NodeIndex : Integer ;
begin

    Result := False ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then begin
       Value := ChildNode.Text ;
       Result := True ;
       end ;

    end ;


function TMainFrm.FindXMLNode(
         const ParentNode : IXMLNode ;  // Node to be searched
         NodeName : String ;            // Element name to be found
         var ChildNode : IXMLNode ;     // Child Node of found element
         var NodeIndex : Integer        // ParentNode.ChildNodes Index #
                                        // Starting index on entry, found index on exit
         ) : Boolean ;
// -------------
// Find XML node
// -------------
var
    i : Integer ;
begin

    Result := False ;
    for i := NodeIndex to ParentNode.ChildNodes.Count-1 do begin
      if ParentNode.ChildNodes[i].NodeName = WideString(NodeName) then begin
         Result := True ;
         ChildNode := ParentNode.ChildNodes[i] ;
         NodeIndex := i ;
         Break ;
         end ;
      end ;
    end ;



end.

