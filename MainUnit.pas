unit MainUnit;
// =======================================================================
// Mesoscan: Mesolens confocal LSM software                                                        e
// =======================================================================
// (c) John Dempster, University of Strathclyde 2011-12
// V1.0 1-5-12
// V1.3 19-6-12 Z stage and 3D images now supported
// V1.5 20-03-13
// V1.5 08-08-13 Scan area now correctly updated when fullfieldwidth changed
//               Fixes offsets observed in scans
//               Incorrect offset on Y axis scan fixed
// V1.5.1 15.5.14 XZ imaging mode now works
//                Voltage controlled lens positioner now supported
//                Region of interest can now be set by double-clicking and dragging
// V1.5.2 15.07.14 Laser shutter control added
// V1.5.3 19.01.15 Y scan now working correctly again (after V1.5.x)
//                 XZ imaging checked Y position now matches horizontal cursor
// V1.5.4 10.03.15 Now supports up to 4 PMT channels
//                 PMT voltage control added
// V1.5.5 10.03.15 Access violations on startup with no settings file fixed
// V1.5.6 17.03.15 Scan now only set to full field when full field with changed in setup
//                 FrameHeight now forced to be greater than 1.
//                 PMT gain menus now forced to valid settings
// V1.5.7 14.05.15 Z position is now incremented one step at end of stack
//                 rather than being returned to top of stack to allow stack to be extended
//                 Scan Full Field now correctly zooms out to full field (rather than
//                 to next wider zoom setting)
// V1.5.8 08.03.16 Beam now parked at 0,0 by last line of scan and unparked in first line
// V1.5.9 27.05.16 27.0.16 Z stage pressure switch protection implemented
// V1.6.0 26.06.16 XZ mode being fixed
// V1.6.1 27.06.16 XZ mode revised and now working
// V1.6.2 26.10.16 Frame sizes now limited to 10,10 ... 20K,20K
//                 PMT controls disabled when scanning
//                 Exit query when user stops program
// V1.6.3 13.02.17 Z steps no longer forced to be multiples of XY pixel size
// V1.6.4 10.05.17 ZPositionMin, ZPositionMax limits added
// V1.6.5 27.10.17 ZStageUnit: Stage protection interrupt now interrupts Z movement commands before move to zero.
// V1.6.6 91.11.17 ZStageUnit: OptiScan II now operated in standard (COMP 0) mode
// V1.6.7 03.11.17 RawImagesFileName folder location can now be changed by user
// V1.6.8 08.11.17 User interface revised to be more similar to MesoCam
//        26.03.18 PMT and SRS900 integrator control added
// V1.6.9 02.10.18 LaserUnit now uses LaserComThead for COM port message handling
//        03.06.19 PMTUnit and ZStageUnit now use threads for COM port message handling (not tested)
//        24.06.19 OBIS laser control working but still under test
// V2.0.0 21.10.19 Now designated as V2.0.0
//        10.12.19 PMT Gain % now incorporated into PMT/LASER control group boxes
interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ValidatedEdit, LabIOUnit, RangeEdit, math,
  ExtCtrls, ImageFile, xmldoc, xmlintf, ActiveX, Vcl.Menus, system.types, strutils, UITypes, shellapi, shlobj ;

const
    VMax = 10.0 ;
    MaxFrameWidth = 30000 ;
    MaxFrameHeight = 30000 ;
    MinFrameWidth = 10 ;
    MinFrameHeight = 10 ;
    srNoChange = 0 ;
    srScanFullField = 1 ;
    srScanROI = 2 ;

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
    MaxPMT = 3 ;

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

  TScanCycle = record
    NP : Integer ;
    NumLines : Integer ;
    NumLineRepeats : Integer ;
    StartImage : Integer ;
    EndImage : Integer ;
    StartLine : Integer ;
    EndLine : Integer ;
  end;


  TMainFrm = class(TForm)
    ImageGrp: TGroupBox;
    ZSectionPanel: TPanel;
    Timer: TTimer;
    ImageFile: TImageFile;
    SaveDialog: TSaveDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    mnExit: TMenuItem;
    mnSetup: TMenuItem;
    mnScanSettings: TMenuItem;
    Panel1: TPanel;
    scZSection: TScrollBar;
    lbZSection: TLabel;
    PMTGrp: TGroupBox;
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
    mnSaveImage: TMenuItem;
    ImagePage: TPageControl;
    TabImage0: TTabSheet;
    Image0: TImage;
    TabImage1: TTabSheet;
    TabImage2: TTabSheet;
    TabImage3: TTabSheet;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    SavetoImageJ1: TMenuItem;
    GroupBox1: TGroupBox;
    bCaptureImage: TButton;
    bStopScan: TButton;
    cbImageMode: TComboBox;
    gpPMT0: TGroupBox;
    Label15: TLabel;
    Label3: TLabel;
    ckEnablePMT0: TCheckBox;
    cbPMTGain0: TComboBox;
    cbPMTLaser0: TComboBox;
    TrackBar2: TTrackBar;
    edPMTLaserIntensity0: TValidatedEdit;
    CCDAreaGrp: TGroupBox;
    GroupBox2: TGroupBox;
    edGotoXPosition: TValidatedEdit;
    Button1: TButton;
    edGotoYPosition: TValidatedEdit;
    edGotoZPosition: TValidatedEdit;
    edXYZPosition: TEdit;
    bGoToXPosition: TButton;
    bGoToYPosition: TButton;
    edNumAverages: TValidatedEdit;
    Label4: TLabel;
    ZStackGrp: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label1: TLabel;
    edNumZSections: TValidatedEdit;
    edNumPixelsPerZStep: TValidatedEdit;
    edMicronsPerZStep: TValidatedEdit;
    LineScanGrp: TGroupBox;
    Label2: TLabel;
    edLineScanFrameHeight: TValidatedEdit;
    ZoomPanel: TPanel;
    lbZoom: TLabel;
    bZoomIn: TButton;
    bZoomOut: TButton;
    rbFullField: TRadioButton;
    rbScanROI: TRadioButton;
    rbScanRange: TRadioButton;
    bLiveSCan: TButton;
    AreaGrp: TGroupBox;
    Label25: TLabel;
    Label24: TLabel;
    edYRange: TRangeEdit;
    edXRange: TRangeEdit;
    tbPMTLaserIntensity0: TTrackBar;
    ValidatedEdit5: TValidatedEdit;
    gpPMT1: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    cbPMTLaser1: TComboBox;
    TrackBar3: TTrackBar;
    edPMTLaserIntensity1: TValidatedEdit;
    tbPMTLaserIntensity1: TTrackBar;
    ValidatedEdit3: TValidatedEdit;
    gpPMT2: TGroupBox;
    Label16: TLabel;
    Label17: TLabel;
    CheckBox2: TCheckBox;
    ComboBox3: TComboBox;
    cbPMTLaser2: TComboBox;
    TrackBar5: TTrackBar;
    edPMTLaserIntensity2: TValidatedEdit;
    tbPMTLaserIntensity2: TTrackBar;
    ValidatedEdit6: TValidatedEdit;
    gpPMT3: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    CheckBox3: TCheckBox;
    ComboBox5: TComboBox;
    cbPMTLaser3: TComboBox;
    TrackBar7: TTrackBar;
    edPMTLaserIntensity3: TValidatedEdit;
    tbPMTLaserIntensity3: TTrackBar;
    ValidatedEdit8: TValidatedEdit;
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
    procedure cbPaletteChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure mnExitClick(Sender: TObject);
    procedure edXPixelsKeyPress(Sender: TObject; var Key: Char);
    procedure edYPixelsKeyPress(Sender: TObject; var Key: Char);
    procedure mnScanSettingsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Image0MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ckLineScanClick(Sender: TObject);
    procedure bGotoZPositionClick(Sender: TObject);

    procedure Image0MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image0MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure scZSectionChange(Sender: TObject);
    procedure cbImageModeChange(Sender: TObject);
    procedure edNumPixelsPerZStepKeyPress(Sender: TObject; var Key: Char);
    procedure edMicronsPerZStepKeyPress(Sender: TObject; var Key: Char);
    procedure edGotoZPositionKeyPress(Sender: TObject; var Key: Char);
    procedure sbContrastChange(Sender: TObject);
    procedure mnSaveImageClick(Sender: TObject);
    procedure ckEnablePMT0Click(Sender: TObject);
    procedure SavetoImageJ1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure bLiveSCanClick(Sender: TObject);
    procedure bCaptureImageClick(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure edPMTLaserIntensity0KeyPress(Sender: TObject; var Key: Char);
    procedure cbPMTLaser0Change(Sender: TObject);
    procedure cbPMTGain0Change(Sender: TObject);
    procedure bGoToXPositionClick(Sender: TObject);
    procedure bGoToYPositionClick(Sender: TObject);
    procedure bZoomInClick(Sender: TObject);
    procedure bZoomOutClick(Sender: TObject);
    procedure Image0MouseLeave(Sender: TObject);
    procedure ImagePageChange(Sender: TObject);
    procedure rbFullFieldMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure rbScanROIMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure rbScanRangeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edGotoXPositionKeyPress(Sender: TObject; var Key: Char);
    procedure edGotoYPositionKeyPress(Sender: TObject; var Key: Char);
    procedure tbPMTLaserIntensity0Change(Sender: TObject);
  private
    { Private declarations }
        FormInitialized : Boolean ;
        BitMap : Array[0..MaxPMT] of TBitMap ;  // Image internal bitmaps
        Image : Array[0..MaxPMT] of TImage ;  // Image internal bitmaps
        procedure DisplayROI( BitMap : TBitmap ) ;
        procedure DisplaySquare(
                  BitMap : TBitMap ;
                  X : Integer ;
                  Y : Integer ) ;
        procedure DisplayCursorReadout(
                  Bitmap : TBitmap ) ;

        procedure DisplayCalibrationBar(
                  Bitmap : TBitmap ;
                  X : Integer ;
                  Y : Integer ) ;

        procedure FixRectangle( var Rect : TRect ) ;
        procedure SetImageSize(
                  Image : TImage ) ;
        function GetSpecialFolder(const ASpecialFolderID: Integer): string;

  public
    { Public declarations }
    DeviceNum : Integer ;
    //ADCVoltageRange : Double ;
    ADCMaxValue : Integer ;
    DACMaxValue : Integer ;
    TempBuf : PBig16bitArray ;
    DACBuf : PBig16bitArray ;
    ADCBuf : PBig16bitArray ;
    AvgBuf : PBig32bitArray ;
    ScanCycle : TScanCycle ;

//    XZLineAverage : PBig32bitArray ;

    ADCNumNewSamples : Integer ;
    ADCInput : Integer ;             // Selected analog input
    NumXPixels : Cardinal ;
    NumYPixels : Integer ;
    NumPixels : Integer ;
    NumPixelsInDACBuf : Cardinal ;
//    BufSize : Integer ;
    XCentre : Double ;
    XWidth : Double ;
    YCentre : Double ;
    YHeight : Double ;
    ScanArea : TDoubleRect ;                   // Selected scanning area (um)
    iScanZoom : Integer ;                      // Selected area in ScanArea
    PixelsToMicronsX : Double ;                // Image pixel X# to micron scaling factor
    PixelsToMicronsY : Double ;                // Image pixel Y# to micron scaling factor
    LineScanTime : Double ;                    // Time taken to scan a single line (s)
    LinesAvailableForDisplay : Integer ;       // Image lines available for display

    SelectedRect : TDoubleRect ;                     // Selected sub-area within displayed image (image pixels)
    SelectedRectBM : TRect ;                   // Selected sub-area (bitmap pixels)
    SelectedEdge : TRect ;                     // Selection rectangle edges selected
    MouseDown : Boolean ;                      // TRUE = image cursor mouse is depressed
    CursorPos : TPoint ;                       // Position of cursor within image
    TopLeftDown : TPoint ;
    MouseDownAt : TPoint ;                     // Mouse position when button depressed
    MouseUpCursor : Integer ;                  // Cursor icon when button released
    CursorReadoutText : string ;               // X,Y position of mouse cursor on display and intensity

    ZTop : Double ;
    FullFieldWidthMicrons : Double ;      // Actual width of full imaging field (um)
    InvertPMTSignal : Boolean ;           // TRUE = PMT signal inverted
    BlackLevel : Integer ;                // Black level of PMT signal
    MinCyclePeriod : Double ;             // Period of scan flyback sine waveform
    MinPixelDwellTime : Double ;          // Smallest permitted pixel dwell time
    XVoltsPerMicron : Double ;            // X galvo volts per micron displacement scall factor
    YVoltsPerMicron : Double ;            // Y galvo volts per micron displacement scall factor
    PhaseShift : Double ;                 // Phase delay between galvo command and galvo displacement (s)
    FrameWidth : Integer ;                // Width of image on display
    FrameHeight : Integer ;               // Height of image of display
    FullFieldWidth : Integer ;            // Width of full field image
    HRPixelSize : Double ;                // High res. image pixel size
    FastFrameWidth : Integer ;            // Fast imaging: frame width (pixels)
    FastFrameHeight : Integer ;           // Fast imaging: frame height (pixels)
//    FrameHeightScale : Double ;           // Fast imaging: Frame height scaling factor
    CalibrationBarSize : double ;          // Display calibration bar size (microns)
    ScanInfo : String ;

    // PMT setting
    NumPMTs : Integer ;
    PMTList : Array[0..MaxPMT] of Integer ;
    NumPMTChannels : Integer ;
    ImageNames : Array[0..MaxPMT] of string ;

    // XY galvo control
    XGalvoControl : Integer ;
    YGalvoControl : Integer ;

    NumADCChannels : Integer ;
    PixelDwellTime : Double ;

    // Z axis control
    ZSection : Integer ;                // Current Z Section being acquired
    ZStep : Double ;                  // Spacing between Z Sections (microns)
    NumZSections : Integer ;            // No. of Sections in Z stack
    NumZSectionsAvailable : Integer ;   // No. of Sections in Z stack
    NumLinesPerZStep : Integer ;      // No. lines per Z step in XZ mode
    XZLine : Integer ;                // XZ mode line counter
    ZStartingPosition : Double ;      // Z position at start of scanning
    ADCPointer : Integer ;
    EmptyFlag : Integer ;
    UpdateDisplay : Boolean ;

    DisplayMaxWidth : Integer ;
    DisplayMaxHeight : Integer ;

    XScale : Single ;
    YScale : Single ;
    XLeft : Integer ;
    YTop : Integer ;
    XDown : Integer ;
    YDown : Integer ;
    XScaleToBM : Double ;
    ROIMode : Boolean ;

    YLineSpacingMicrons : Single ;
    YStartMicrons : Single ;
    YEndMicrons : Single ;

    YScaleToBM : Double ;

    Magnification : Array[0..999] of Integer ;
    iZoom : Integer ;

        // Display look-up tables
    GreyLo : Array[0..MaxPMT] of Integer ; // Lower limit of display grey scale
    GreyHi : Array[0..MaxPMT] of Integer ; // Upper limit of display grey scale
    LUT : Array[0..MaxPMT,0..LUTSize-1] of Word ;    // Display look-up tables
    PaletteType : TPaletteType ;  // Display colour palette
    pImageBuf : Array[0..MaxPMT] of PSmallIntArray ; // Pointer to image buffers

    //PAverageBuf : PIntArray ; // Pointer to displayed image buffers
    NumAverages : Integer ;
    ClearAverage : Boolean ;

    ScanRequested : Integer ;
    ScanningInProgress : Boolean ;
    LiveImageMode : Boolean ;

    INIFileName : String ;           // Name of initialisation file
    ProgDirectory : String ;         // Path to program folder
    SaveDirectory : String ;         // Path to save folder
    SettingsDirectory : String ;     // Path to settings folder
    RawImagesFileName : String ;     // Raw image file name
    ImageJPath : String ;            // Path to Image-J program
    SaveAsMultipageTIFF : Boolean ;  // TRUE = save stacks as multi-page TIFF files
                                     // FALSE = save stacks as individual files

    UnsavedRawImage : Boolean ;    // TRUE indicates raw images file contains an unsaved hi res. image

    MemUsed : Integer ;
    procedure InitialiseImage ;
    procedure SetImagePanels ;
    procedure CreateScanWaveform(
              FastScan : Boolean            // True = fast / low resolution scan
              ) ;
    procedure StartNewScan(
              FastScan : Boolean      // TRUE = Fast scan mode
              ) ;
    procedure StartScan ;

    procedure GetImageFromPMT ;

    procedure SetDisplayIntensityRange(
          LoValue : Integer ;
          HiValue : Integer
          ) ;

    procedure UpdateLUT(
              ch : Integer ;
              GreyMax : Integer ) ;

    procedure SetPalette( BitMap : TBitMap ; PaletteType : TPaletteType ) ;

    procedure UpdateImage ;
    procedure UpdatePMTSettings ;

   procedure ReadWritePMTGroup(
             Num : Integer ;
             Group : TGroupBox ;
             RW : string ) ;

    procedure CalculateMaxContrast ;

    procedure SetScanZoomToFullField ;

    procedure SaveRawImage(
          FileName : String ;    // File to save to
          iSection : Integer     // Image Section number
          ) ;

    function SectionFileName(
         FileName : string ; // Base file name
         iChannel : Integer ;    // PMT #
         iSection : Integer  // Z section #
         ) : string ;

    procedure LoadRawImage(
          FileName : String ;    // File to save to
          iSection : Integer     // Image Section number
          ) ;

    procedure SaveImage( OpenImageJ: boolean ) ;

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
              Value : Double
              ) : Double ;
    procedure AddElementInt(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : Integer
              ) ;
    function GetElementInt(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : Integer
              ) : Integer ;
    procedure AddElementBool(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : Boolean
              ) ;
    function GetElementBool(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : Boolean
              ) : Boolean ;

    procedure AddElementText(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : String
              ) ;
    function GetElementText(
              ParentNode : IXMLNode ;
              NodeName : String ;
              Value : String
              ) : String ;

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

uses SettingsUnit, ZStageUnit, LaserUnit, PMTUnit ;

{$R *.dfm}

function GetSystemPaletteEntries ; external gdi32 name 'GetSystemPaletteEntries' ;


procedure TMainFrm.FormCreate(Sender: TObject);
// --------------------------------------
// Initalisations when program is created
// --------------------------------------
var
   ch : Integer ;
begin
     ADCBuf := Nil ;
     AvgBuf := Nil ;
     DACBuf := Nil ;
//     XZLineAverage := Nil ;
     for ch := 0 to High(BitMap) do BitMap[ch] := Nil ;

     // Create array of image controls
     Image0.Tag := 0 ;
     Image1.Tag := 1 ;
     Image2.Tag := 2 ;
     Image3.Tag := 3 ;

     Image[0] := Image0 ;
     Image[1] := Image1 ;
     Image[2] := Image2 ;
     Image[3] := Image3 ;

     CursorReadoutText := '' ;

     FormInitialized := False ;
     LiveImageMode := False ;

     end;


procedure TMainFrm.FormShow(Sender: TObject);
// --------------------------------------
// Initialisations when form is displayed
// --------------------------------------
var
    i,ch : Integer ;
    NumPix : Cardinal ;
begin
     Caption := 'MesoScan V2.0.0 ';
     {$IFDEF WIN32}
     Caption := Caption + '(32 bit)';
    {$ELSE}
     Caption := Caption + '(64 bit)';
    {$IFEND}
    Caption := Caption + ' 19/11/19';

     TempBuf := Nil ;
     DeviceNum := 1 ;

     LabIO.NIDAQAPI := NIDAQMX ;
     LabIO.Open ;

     meStatus.Clear ;
     for i := 1 to LabIO.NumDevices do
         meStatus.Lines.Add(LabIO.DeviceName[i] + ': ' + LabIO.DeviceBoardName[i] ) ;

     LabIO.ADCInputMode := imDifferential ;
     EmptyFlag := -32766 ;

     ADCMaxValue := LabIO.ADCMaxValue[DeviceNum] ;
     DACMaxValue := LabIO.DACMaxValue[DeviceNum] ;

     ADCPointer := 0 ;

     NumLinesPerZStep := 1 ;

     XZLine := 0 ;
//     XZAverageLine := 0 ;

     DeviceNum := 1 ;
     for ch  := 0 to High(GreyLo) do GreyLo[ch] := 0 ;
     for ch  := 0 to High(GreyLo) do GreyHi[ch] := LabIO.ADCMaxValue[DeviceNum] ;

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

//     PMTMaxVolts := 5.0 ;

     // XY galvo control
     XGalvoControl := ControlDisabled ;
     YGalvoControl := ControlDisabled ;


     edDisplayIntensityRange.LoLimit := 0 ;
     edDisplayIntensityRange.HiLimit := ADCMaxValue ;
     sbBrightness.Min := 0 ;
     sbBrightness.Max := ADCMaxValue ;
     sbContrast.Min := 0 ;
     sbContrast.Max := ADCMaxValue ;

     bFullScale.Click ;

     // Save image file dialog
     SaveDialog.InitialDir := '' ;
     SaveDialog.Title := 'Save Image ' ;
     SaveDialog.options := [ofHideReadOnly,ofPathMustExist] ;
     SaveDialog.DefaultExt := '.tif' ;
     SaveDialog.Filter := ' TIFF (*.tif)|*.tif' ;
     SaveDialog.FilterIndex := 3 ;
     SaveDirectory := '' ;

     FullFieldWidth := 500 ;
     FullFieldWidthMicrons := 2000.0 ;
     FrameWidth := FullFieldWidth ;
     FrameHeight := FullFieldWidth ;

     Magnification[0] := 1 ;
     for i := 0 to High(Magnification) do begin
         Magnification[i+1] := Magnification[i] + Max(Round(Magnification[i]*0.25),1) ;
         end ;
     iZoom := 0 ;

     for ch := 0 to High(BitMap) do begin
         if BitMap[ch] <> Nil then BitMap[ch].Free ;
         BitMap[ch] := TBitMap.Create ;
         BitMap[ch].Width := FullFieldWidth ;
         BitMap[ch].Height := FullFieldWidth ;
         end;

     LinesAvailableForDisplay := 0 ;

     // Default normal scan settings
     NumAverages := 5 ;
     MinCyclePeriod := 0.02 ;           // Flyback period 20 ms = 50 Hz
     MinPixelDwellTime := 5E-7 ;
     XVoltsPerMicron := 1E-3 ;
     YVoltsPerMicron := 1E-3 ;
     //ADCVoltageRange := 0 ;
     PhaseShift := 0 ;
     BlackLevel := 10 ;
     InvertPMTSignal := True ;

//     HRFrameWidth := 1000 ;
     HRPixelSize := 1.0 ;
     FastFrameWidth := 500 ;
     FastFrameHeight := 100 ;
//     FrameHeightScale := 1.0 ;

     edNumPixelsPerZStep.Value := 1.0 ;
     edNumZSections.Value := 10.0 ;

     // Image-J program path
     ImageJPath := 'C:\ImageJ\imagej.exe';
     SaveAsMultipageTIFF := True ;

     // Load last used settings
     ProgDirectory := ExtractFilePath(ParamStr(0)) ;

     // Create settings directory path
     SettingsDirectory := GetSpecialFolder(CSIDL_COMMON_DOCUMENTS) + '\MesoScan\';
     if not SysUtils.DirectoryExists(SettingsDirectory) then begin
        if not SysUtils.ForceDirectories(SettingsDirectory) then
           ShowMessage( 'Unable to create settings folder' + SettingsDirectory) ;
        end ;

     // Load last used settings
     INIFileName := SettingsDirectory + 'mesoscan settings2.xml' ;
     LoadSettingsFromXMLFile( INIFileName ) ;

     // Open laser control
     Laser.Open ;

     // Open PMT and integrator control
     PMT.Open ;

     // Open stage control
     ZStage.Open ;

     RawImagesFileName := SettingsDirectory + 'mesoscan.raw' ;

     // Load normal scan

     if FullFieldWidthMicrons <= 0.0 then FullFieldWidthMicrons := 1E4 ;

     // PMT controls
     ReadWritePMTGroup( 0, gpPMT0, 'W' ) ;
     ReadWritePMTGroup( 1, gpPMT1, 'W' ) ;
     ReadWritePMTGroup( 2, gpPMT2, 'W' ) ;
     ReadWritePMTGroup( 3, gpPMT3, 'W' ) ;

     UpdateDisplay := False ;
     ScanRequested := 0 ;
     ScanningInProgress := False ;

     // Initialise full field image

     iScanZoom := 0 ;
     FrameWidth := FastFrameWidth ;
     FrameHeight := FastFrameWidth ;
    // (re)allocate image buffer
    NumPix := FrameWidth*FrameHeight*NumLinesPerZStep ;
    UpdatePMTSettings ;
    for ch := 0 to High(PImageBuf) do begin
        if PImageBuf[ch] <> Nil then FreeMem(PImageBuf[ch]) ;
        PImageBuf[ch] := Nil ;
        if ch < NumPMTChannels then begin
           PImageBuf[ch] := AllocMem( Int64(NumPix)*SizeOf(SmallInt)) ;
           for i := 0 to NumPix-1 do pImageBuf[ch]^[i] := 0 ;
           end;
        end;


    SetScanZoomToFullField ;

     Timer.Enabled := True ;
     UpdateDisplay := True ;
     bStopScan.Enabled := False ;
     image0.ControlStyle := image0.ControlStyle + [csOpaque] ;
     image1.ControlStyle := image1.ControlStyle + [csOpaque] ;
     image2.ControlStyle := image2.ControlStyle + [csOpaque] ;
     image3.ControlStyle := image3.ControlStyle + [csOpaque] ;
     imagegrp.ControlStyle := imagegrp.ControlStyle + [csOpaque] ;
     ImagePage.ActivePageIndex := 0 ;

    // Initialise display
    InitialiseImage ;
    MouseUpCursor := crCross ;

     Left := 10 ;
     Top := 10 ;
     Width := Screen.Width - 10 - Left ;
     Height := Screen.Height - 50 - Top ;

     FormInitialized := True ;

     end;


procedure TMainFrm.SetScanZoomToFullField ;
// ---------------------------
// Set scan zoom to full field
// ---------------------------
begin
     iScanZoom := 0 ;
     ScanArea.Left := 0.0 ;
     ScanArea.Top := 0.0 ;
     ScanArea.Right := FullFieldWidthMicrons ;
     ScanArea.Bottom := FullFieldWidthMicrons ;
     ScanArea.Width := FullFieldWidthMicrons ;
     ScanArea.Height := FullFieldWidthMicrons ;

     SelectedRect.Left := 0 ;
     SelectedRect.Top := 0 ;
     SelectedRect.Right := FrameWidth-1 ;
     SelectedRect.Bottom := FrameHeight-1 ;

     edMicronsPerZStep.Value := edNumPixelsPerZStep.Value*HRPixelSize ;

     end ;


procedure TMainFrm.Image0MouseDown(Sender: TObject; Button: TMouseButton;
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

     if Image0.Cursor = crCross then screen.Cursor := crHandPoint
                                else screen.Cursor := Image0.Cursor ;

     end;


procedure TMainFrm.Image0MouseLeave(Sender: TObject);
// -------------------------
// Mouse leaves control area
// -------------------------
begin
    Screen.Cursor := crDefault ;
    end;

procedure TMainFrm.Image0MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
// ----------------------
// Mouse moved over image
// ----------------------
const
    EdgeSize = 3 ;
var
    i : Integer ;
    XRight,YBottom,XShift,YShift : Integer ;
    XImage,YImage : Integer ;
begin

     if pImageBuf[TImage(Sender).tag] = Nil then Exit ;

     XImage := Round(X/XScaleToBM) + XLeft ;
     YImage := Round(Y/YScaleToBM) + YTop ;
     i := YImage*FrameWidth + XImage ;

     PixelsToMicronsX := ScanArea.Width/FrameWidth ;
     PixelsToMicronsY := {FrameHeightScale*}PixelsToMicronsX ;

     if (i > 0) and (i < FrameWidth*FrameHeight) then begin

        CursorReadoutText := format('X=%.2f um, Y=%.2f um, I=%d',
                           [XImage*PixelsToMicronsX + ScanArea.Left,
                            YImage*PixelsToMicronsY + ScanArea.Top,
                            pImageBuf[TImage(Sender).tag][i]]) ;
         UpdateDisplay := True ;
         end ;

     if not MouseDown then
        begin
        // Indicate if cursor is over edge of zoom selection rectangle
        SelectedEdge.Left := 0 ;
        SelectedEdge.Right := 0 ;
        SelectedEdge.Top := 0 ;
        SelectedEdge.Bottom := 0 ;
        if (Abs(X - SelectedRectBM.Left) < EdgeSize) and
           (Y >= SelectedRectBM.Top) and
           (Y <= SelectedRectBM.Bottom) then SelectedEdge.Left := 1 ;
        if (Abs(X - SelectedRectBM.Right) < EdgeSize) and
           (Y >= SelectedRectBM.Top) and
           (Y <= SelectedRectBM.Bottom) then SelectedEdge.Right := 1 ;
        if (Abs(Y - SelectedRectBM.Top) < EdgeSize) and
           (X >= SelectedRectBM.Left) and
           (X <= SelectedRectBM.Right) then SelectedEdge.Top := 1 ;
        if (Abs(Y - SelectedRectBM.Bottom) < EdgeSize) and
           (X >= SelectedRectBM.Left) and
           (X <= SelectedRectBM.Right) then SelectedEdge.Bottom := 1 ;
        if (SelectedEdge.Left = 1) and (SelectedEdge.Top = 1) then Image0.Cursor := crSizeNWSE
        else if (SelectedEdge.Left = 1) and (SelectedEdge.Bottom = 1) then Image0.Cursor := crSizeNESW
        else if (SelectedEdge.Right = 1) and (SelectedEdge.Top = 1) then Image0.Cursor := crSizeNESW
        else if (SelectedEdge.Right = 1) and (SelectedEdge.Bottom = 1) then Image0.Cursor := crSizeNWSE
        else if SelectedEdge.Left = 1 then Image0.Cursor := crSizeWE
        else if SelectedEdge.Right = 1 then Image0.Cursor := crSizeWE
        else if SelectedEdge.Top = 1 then Image0.Cursor := crSizeNS
        else if SelectedEdge.Bottom = 1 then Image0.Cursor := crSizeNS
        else Image0.Cursor := crCross ;
        CursorPos.X := X ;
        CursorPos.Y := Y ;
        end
     else
        begin
        if Image0.Cursor = crCRoss then Image0.Cursor := crHandPoint ;
        XShift := X - CursorPos.X ;
        CursorPos.X := X ;
        YShift := Y - CursorPos.Y ;
        CursorPos.Y := Y ;
        if SelectedEdge.Left = 1 then
           begin
           // Move left edge
           SelectedRectBM.Left := Max(SelectedRectBM.Left + XShift,0);
           SelectedRectBM.Left := Min(SelectedRectBM.Left,Min(BitMap[0].Width-1,SelectedRectBM.Right-1)) ;
           SelectedRect.Left := Round(SelectedRectBM.Left/XScaleToBM) + XLeft ;
           end ;
        if SelectedEdge.Right = 1 then
           begin
           // Move right edge
           SelectedRectBM.Right := Max(SelectedRectBM.Right + XShift,Max(0,SelectedRectBM.Left));
           SelectedRectBM.Right := Min(SelectedRectBM.Right,BitMap[0].Width-1) ;
           SelectedRect.Right := Round(SelectedRectBM.Right/XScaleToBM) + XLeft ;
           end;
        if SelectedEdge.Top = 1 then
           begin
           // Move top edge
           SelectedRectBM.Top := Max(SelectedRectBM.Top + YShift,0);
           SelectedRectBM.Top := Min(SelectedRectBM.Top,Min(BitMap[0].Height-1,SelectedRectBM.Bottom-1)) ;
           SelectedRect.Top := Round(SelectedRectBM.Top/YScaleToBM) + YTop ;
           end;

        if SelectedEdge.Bottom = 1 then
           begin
           // Move bottom edge
           SelectedRectBM.Bottom := Max(SelectedRectBM.Bottom + YShift,SelectedRectBM.Top+1);
           SelectedRectBM.Bottom := Min(SelectedRectBM.Bottom,BitMap[0].Height-1) ;
           SelectedRect.Bottom := Round(SelectedRectBM.Bottom/YScaleToBM) + YTop ;
           end;

        if ROIMode then
           begin
           // If in ROI mode, set bottom,right edge of ROI to current cursor position
           SelectedRectBM.Right := X ;
           SelectedRectBM.Bottom := Y ;
           SelectedRect.Right := Round(SelectedRectBM.Right/XScaleToBM) + XLeft ;
           SelectedRect.Bottom := Round(SelectedRectBM.Bottom/YScaleToBM) + YTop ;
           end
        else if (SelectedEdge.Left or SelectedEdge.Right or
             SelectedEdge.Top or SelectedEdge.Bottom) = 0 then
            begin
            // Move display window
            XLeft := TopLeftDown.X - Round((X - MouseDownAt.X)/XScaleToBM) ;
            XRight := Min(XLeft + Round(BitMap[0].Width/XScaleToBM),FrameWidth) ;
            XLeft := Max( XRight - Round(BitMap[0].Width/XScaleToBM), 0 ) ;
            YTop := TopLeftDown.Y - Round((Y - MouseDownAt.Y)/YScaleToBM) ;
            YBottom := Min(YTop + Round(BitMap[0].Height/YScaleToBM),FrameHeight) ;
            YTop := Max( YBottom - Round(BitMap[0].Height/YScaleToBM),0) ;
            end;
         end ;

     Image1.Cursor := Image0.Cursor ;
     Image2.Cursor := Image0.Cursor ;
     Image3.Cursor := Image0.Cursor ;
     screen.Cursor := Image0.Cursor ;

     UpdateDisplay := True ;
     end ;


procedure TMainFrm.FixRectangle( var Rect : TRect ) ;
// -----------------------------------------------------
// Ensure top/left is above/to the right of bottom/right
// -----------------------------------------------------
var
    RTemp : TRect ;
begin

    RTemp := Rect ;
    Rect.Left := Min(RTemp.Left,RTemp.Right) ;
    Rect.Right := Max(RTemp.Left,RTemp.Right) ;
    Rect.Top := Min(RTemp.Top,RTemp.Bottom) ;
    Rect.Bottom := Max(RTemp.Top,RTemp.Bottom) ;

    end;


procedure TMainFrm.Image0MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
// -------------------
// Mouse up on image
// -------------------
begin

     MouseDown := False ;
     ROIMode := False ;                   // Turn ROI mode off
     FixRectangle(SelectedRectBM);

     screen.Cursor := Image0.Cursor ;

end;


procedure TMainFrm.ImagePageChange(Sender: TObject);
begin
    // Set intensity range and sliders
    SetDisplayIntensityRange( GreyLo[ImagePage.ActivePageIndex],
                              GreyHi[ImagePage.ActivePageIndex] ) ;

end;

procedure TMainFrm.InitialiseImage ;
// ------------------------------------------------------
// Re-initialise size of memory buffers and image bitmaps
// ------------------------------------------------------
var
    ch : Integer ;
begin

     // Set size and location of image display panels
     SetImagePanels ;

     // Indicate selected frame type selected for contrast update
     DisplayGrp.Caption := ' Contrast ' ;

     // Set intensity range and sliders
     SetDisplayIntensityRange( MainFrm.GreyLo[ImagePage.ActivePageIndex],
                               MainFrm.GreyHi[ImagePage.ActivePageIndex] ) ;

     for ch := 0 to NumPMTChannels-1 do
        begin

        // Update display look up tables
        UpdateLUT( ch, ADCMaxValue );
        end;

     end ;


procedure TMainFrm.SetImagePanels ;
// -------------------------------------------
// Set size and number of image display panels
// -------------------------------------------
const
    MarginPixels = 16 ;
var
    HeightWidthRatio : Double ;
    ch,Ybm,Xbm : Integer ;
    PScanLine : PByteArray ;    // Bitmap line buffer pointer

begin

     ImageGrp.ClientWidth :=  Max( ClientWidth - ImageGrp.Left - 5, 2) ;
     ImageGrp.ClientHeight :=  Max( ClientHeight - ImageGrp.Top - 5, 2) ;

     ZoomPanel.Top := ImageGrp.ClientHeight - ZoomPanel.Height - 1 ;
     ZoomPanel.Left := 5 ;
     lbZoom.Caption := format('Zoom (X%d)',[Magnification[iZoom]]);

     ZSectionPanel.Top := ZoomPanel.Top ;

     ImagePage.Width := ImageGrp.ClientWidth - ImagePage.Left - 5 ;
     ImagePage.Height := ZSectionPanel.Top - ImagePage.Top - 2 ;
     ZSectionPanel.Left := ImagePage.Width + ImagePage.Left - ZSectionPanel.Width ;

     DisplayMaxWidth := TabImage0.ClientWidth {- TabImage0.Left} - 1 ;
     DisplayMaxHeight := TabImage0.ClientHeight {- TabImage0.Top} - 1 ;

     for ch := 0 to NumPMTChannels-1 do
         begin
         if BitMap[ch] <> Nil then BitMap[ch].Free ;
         BitMap[ch] := TBitMap.Create ;
         SetPalette( BitMap[ch], PaletteType ) ;

         // Scale bitmap to fit into window
         BitMap[ch].Width := DisplayMaxWidth ;
         HeightWidthRatio := (FrameHeight{*FrameHeightScale})/FrameWidth ;
         BitMap[ch].Height := Round(BitMap[ch].Width*HeightWidthRatio) ;
         if BitMap[ch].Height > DisplayMaxHeight then
            begin
            BitMap[ch].Height := DisplayMaxHeight ;
            BitMap[ch].Width := Round(BitMap[ch].Height/HeightWidthRatio) ;
            BitMap[ch].Width := Min(BitMap[ch].Width,DisplayMaxWidth) ;
            LinesAvailableForDisplay := 0;//FrameHeight ;
            // Add magnification and limit BitMap to window
            BitMap[ch].Width := Min(BitMap[ch].Width*Magnification[iZoom],DisplayMaxWidth) ;
            BitMap[ch].Height := Min(BitMap[ch].Height*Magnification[iZoom],DisplayMaxHeight) ;
            end;

         XScaleToBM := (BitMap[ch].Width*Magnification[iZoom]) / FrameWidth ;
         YScaleToBM := (BitMap[ch].Width*Magnification[iZoom]{*FrameHeightScale}) / FrameWidth ;

         //Clear image to zeroes
         for Ybm := 0 to BitMap[ch].Height-1 do
             begin
             PScanLine := BitMap[ch].ScanLine[Ybm] ;
             for xBm := 0 to BitMap[ch].Width-1 do PScanLine[Xbm] := LUT[ch,0] ;
             end ;

         SetImageSize( Image[ch] ) ;

         end;

     end ;


procedure TMainFrm.SetImageSize(
          Image : TImage ) ;
// -------------------------
// Set size of image control
// -------------------------
begin

     Image.Width := BitMap[0].Width ;
     Image.Height := BitMap[0].Height ;

     Image.Canvas.Pen.Color := clWhite ;
     Image.Canvas.Brush.Style := bsClear ;
     Image.Canvas.Font.Color := clWhite ;
     Image.Canvas.TextFlags := 0 ;
     Image.Canvas.Pen.Mode := pmXOR ;
     Image.Canvas.Font.Name := 'Arial' ;
     Image.Canvas.Font.Size := 8 ;
     Image.Canvas.Font.Color := clBlue ;

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

     sbBrightness.Position := sbBrightness.Max - (LoValue + HiValue) div 2  ;
     sbContrast.Position := sbContrast.Max - (HiValue - LoValue) ;

     end ;


procedure TMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
// ------------
// Stop program
// ------------
begin

     // Close laser shutter
     Laser.Close ;

     // Close Z stage
     ZStage.Close ;

     LabIO.Close ;

     if ADCBuf <> Nil then FreeMem(ADCBuf) ;
     if AvgBuf <> Nil then FreeMem(AvgBuf) ;
     if DACBuf <> Nil then FreeMem(DACBuf) ;
//     if XZLineAverage <> Nil then FreeMem(XZLineAverage) ;

     // Close PMT and integrators
     PMT.Close ;

     SaveSettingsToXMLFile( INIFileName ) ;

     end;

procedure TMainFrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
// ----------------------------------------
// Warn user that program is about to close
// ----------------------------------------
begin
    if MessageDlg( 'Exit Program! Are you Sure? ',
       mtConfirmation,[mbYes,mbNo], 0 ) = mrYes then CanClose := True
                                                else CanClose := False ;
end;


procedure TMainFrm.CreateScanWaveform(
          FastScan : Boolean            // True = fast / low resolution scan
          ) ;
// ------------------------------
// Create X/Y galvo scan waveform
// ------------------------------
const
    SineSegment = 0 ;
    LinearSegment = 1 ;
    NumEdgeLines = 1 ;
var
    HalfPi,ScanSpeed : Double ;
    XCentre,YCentre,XAmplitude,YHeight,PCDOne : Double ;
    n,ch,iX,iY,i,j,iShift : Integer ;
    NumBytes : NativeInt ;
    NumYEdgePixels : Cardinal ;
    NumPix : Cardinal ;
    NumLinesInDACBuf : Cardinal ;
    XDAC,YDAC : SmallInt ;
    Amplitude : Double ;
    ScanSegment : Integer ;
    PhaseAngle,Amp,AmpStep,YStep : Double ;
    TwoPi : Double ;
    Rad,RadiansPerCycle,RadiansPerStep,Theta : double ;
    XScanWaveform,YScanWaveform : PBig16BitArray ;
    LinearDone : Boolean ;
    PixelSize : Double ;
begin

    meStatus.Clear ;
    meStatus.Lines[0] := 'Wait: Creating XY scan waveform' ;

    // Determine number of lines per Z step (for XZ mode)
    if cbImageMode.ItemIndex = XZMode then
       begin
       NumLinesPerZStep := Round(edNumAverages.Value) + Max(Round(ZStage.ZStepTime/LineScanTime),1);
       end
    else NumLinesPerZStep := 1 ;

    NumYEdgePixels := 1 ;
    NumYPixels := (FrameHeight + 2*NumYEdgePixels)*NumLinesPerZStep ;

    XScale := (LabIO.DACMaxValue[DeviceNum]/VMax)*XVoltsPerMicron ;
    YScale := (LabIO.DACMaxValue[DeviceNum]/VMax)*YVoltsPerMicron ;
    XWidth := ScanArea.Right - ScanArea.Left ;
    XCentre := (ScanArea.Left + ScanArea.Right - FullFieldWidthMicrons)*0.5 ;

    YHeight := ScanArea.Bottom - ScanArea.Top ;
    YCentre := (ScanArea.Top + ScanArea.Bottom - FullFieldWidthMicrons)*0.5 ;

    // No. of pixels in linear scan line
    if FastScan then
       begin
       // Fast / low resolution scan
       NumXPixels := FastFrameWidth ;
       PixelSize := XWidth / NumXPixels ;
       YLineSpacingMicrons := YHeight / FastFrameHeight ;
       ScanCycle.NumLineRepeats := Max(Round( YLineSpacingMicrons/PixelSize ),1) ;
       end
    else
       begin
       // High resolution /slow scan
       NumXPixels := Round( XWidth/HRPixelSize ) ;
       PixelSize := HRPixelSize ;
       YLineSpacingMicrons := PixelSize ;
       ScanCycle.NumLineRepeats := 1 ;
       end;

    // Calculate phase angle of sine wave which delimits end of linear scan
    Theta := arcsin(cos(2.0/Pi())) ;
    // Scale up sine wave amplitude to ensure linear section is XWidth
    XAmplitude := (0.5*XWidth) / sin(Theta) ;
    // Calculate number of radians in combined sine+ramp cycle
    RadiansPerCycle := 3.0*Pi() - 2.0*Theta ;
    RadiansPerStep := Pi() / NumXPixels ;
    ScanCycle.NP := Round(RadiansPerCycle / RadiansPerStep) ;

    // Determine line scan time
    PixelDwellTime :=  MinPixelDwellTime  ;
    PixelDwellTime :=  Max( PixelDwellTime, MinCyclePeriod / ScanCycle.NP ) ;
    LabIO.CheckSamplingInterval(DeviceNum,PixelDwellTime,1) ;

    ScanSpeed := 1.0/(ScanCycle.NP*PixelDwellTime) ;;
    ScanInfo := format('%.3g lines/s Tdwell=%.3g us LPF=%.0f kHz',[ScanSpeed,1E6*PixelDwellTime,PMT.LPFilter3dBCutOff*1E-3]);
    LineScanTime := NumXPixels*PixelDwellTime ;

    case cbImageMode.ItemIndex of
        XTMode,XZMode :
          begin
          // Line scan (XT & XZ) along X axis at YCentre position
          // No Y axis movement
          YStartMicrons := YCentre ;
          YLineSpacingMicrons := 0.0 ;
          end ;
       else
          begin
          // XY and XYZ modes
          YStartMicrons := YCentre - YHeight*0.5 ;
          YEndMicrons := YCentre + YHeight*0.5 ;
          end ;
       end;

    // Create full cycle of X scan waveform with sine edges, linear centre segment and sine flyback

    GetMem( XScanWaveform, ScanCycle.NP*SizeOf(SmallInt) ) ;
    GetMem( YScanWaveform, ScanCycle.NP*SizeOf(SmallInt) ) ;

    HalfPi := Pi()*0.5 ;
    TwoPi := Pi()*2.0 ;
    PhaseAngle := -HalfPi ;
    AmpStep := XWidth / NumXPixels ;
    ScanSegment := SineSegment ;
    Rad := -HalfPi ;
    LinearDone := False ;
    for i := 0 to ScanCycle.NP-1 do
        begin
        case ScanSegment of

             SineSegment : begin
               // Sine scan segment
               Amp := sin(Rad)*XAmplitude ;
               if (Abs(Amp) <= (0.5*XWidth)) and (not LinearDone) then
                  begin
                  // Start of linear segment
                  ScanSegment := LinearSegment ;
                  ScanCycle.StartImage := i ;
                  end;
               Rad := Rad + RadiansPerStep ;
               end;

             LinearSegment : begin
               // Linear segment
               Amp := Amp + AmpStep ;
               if Abs(Amp) >= (0.5*XWidth) then
                  begin
                  // End of linear segment
                  ScanSegment := SineSegment ;
                  Rad := Theta ;
                  ScanCycle.EndImage := i ;
                  LinearDone := True ;
                  end ;
                end;

             end;

        XScanWaveform^[i] := Round((XCentre + Amp)*XScale) ;

        end ;

    // Create full cycle of Y scan waveform with sine edges

    YStep := YScale*YLineSpacingMicrons ;
    for i := 0 to ScanCycle.NP-1 do
        begin
        if i >= ScanCycle.EndImage then
           begin
           YScanWaveform^[i] := Round(YStep*(1.0 - exp( -(i-ScanCycle.EndImage)/(ScanCycle.NP*0.2) )));
           end
        else YScanWaveform^[i] := 0 ;
        end ;

    if cbImageMode.ItemIndex = XTMode then
       begin
       ScanCycle.NumLines := Round( edLineScanFrameHeight.Value ) + 2*NumEdgeLines ;
       end
    else
       begin
       ScanCycle.NumLines := Round( YHeight/YLineSpacingMicrons ) + 2*NumEdgeLines ;
       end;
    ScanCycle.StartLine := NumEdgeLines ;
    ScanCycle.EndLine := ScanCycle.NumLines - NumEdgeLines - 1 ;

    // Create X,Y DAC voltage waveform buffer

    if DACBuf <> Nil then FreeMem( DACBuf ) ;
    NumPixelsInDACBuf := ScanCycle.NP*ScanCycle.NumLines ;
    NumLinesinDACBuf := NumPixelsInDACBuf div ScanCycle.NP ;
    NumPixelsInDACBuf := NumLinesinDACBuf*ScanCycle.NP ;
    NumBytes := Int64(NumPixelsInDACBuf)*Int64(SizeOf(SmallInt)*2) ;
    DACBuf := AllocMem( NumBytes ) ;

    PCDone := 0.0 ;
    j := 0 ;
    n := 0 ;

    for iY := 0 to ScanCycle.NumLines-1 do
        begin

        YDAC := Round(YScale*((iY)*YLineSpacingMicrons + YStartMicrons)) ;

        for iX := 0 to ScanCycle.NP-1 do
            begin
            DACBuf^[j] := XScanWaveform^[iX] ;
            DACBuf^[j+1] := YDAC + YScanWaveform^[iX] ;
            j := j + 2 ;
            end ;

        if iY mod 1000 = 0 then
           begin
           meStatus.Lines[0] := format('Wait: Creating XY scan waveform %.0f%%',[(iY*100.0)/ScanCycle.NumLines]) ;
           Application.ProcessMessages ;
           end ;

        end ;

     // Modify first line to smoothly unpark beam from centre position to top/left of imaging area
     YDAC := DACBuf^[1] ;
     XDAC := DACBuf^[0] ;
     j := 0 ;
     for iX := 0 to ScanCycle.NP-1 do
         begin
         Amplitude := 0.5*(1.0 - cos((iX*Pi)/(ScanCycle.NP-1)));
         DACBuf^[j] := Round(XDAC*Amplitude) ;
         DACBuf^[j+1] := Round(YDAC*Amplitude) ;
         j := j + 2 ;
         end ;

     // Modify last line to smoothly park beam at centre position from bottom/right of imaging area
     j := (ScanCycle.NumLines-1)*ScanCycle.NP*2 + (ScanCycle.NP-1)*2;
     YDAC := DACBuf^[j+1] ;
     XDAC := DACBuf^[j] ;
     for iX := 0 to ScanCycle.NP-1 do
         begin
         Amplitude := 0.5*(1.0 - cos((iX*Pi)/(ScanCycle.NP-1)));
         DACBuf^[j] := Round(XDAC*Amplitude) ;
         DACBuf^[j+1] := Round(YDAC*Amplitude) ;
         j := j - 2 ;
         end ;

    iShift := Round(PhaseShift/PixelDwellTime) ;

    FrameWidth := ScanCycle.EndImage - ScanCycle.StartImage + 1 ;
    FrameHeight := (ScanCycle.EndLine - ScanCycle.StartLine + 1)*ScanCycle.NumLineRepeats ;

    // Allocate image buffers
    NumPix := FrameWidth*FrameHeight*NumLinesPerZStep ;
    for ch := 0 to High(PImageBuf) do
        begin
        if PImageBuf[ch] <> Nil then FreeMem(PImageBuf[ch]) ;
        PImageBuf[ch] := Nil ;
        if ch < NumPMTChannels then
           begin
           PImageBuf[ch] := AllocMem( Int64(NumPix)*SizeOf(SmallInt)) ;
           end;
        end;

    // Allocate A/D buffer
    if ADCBuf <> Nil then FreeMem( ADCBuf ) ;
    NumBytes := Int64(ScanCycle.NP)*Int64(ScanCycle.NumLines)*Int64(NumPMTChannels)*SizeOf(SmallInt) ;
    ADCBuf := AllocMem( NumBytes ) ;

    FreeMem(XScanWaveform) ;
    FreeMem(YScanWaveform) ;

    end ;


procedure TMainFrm.rbFullFieldMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
// ------------------------
// Full field scan selected
// ------------------------
begin
    if not bLiveScan.Enabled then StartNewScan( True ) ;
end;


procedure TMainFrm.rbScanRangeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
// --------------------------------
// Scan user-entered range selected
// --------------------------------
begin
    if not bLiveScan.Enabled then StartNewScan( True ) ;
end;


procedure TMainFrm.rbScanROIMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
// ------------------------
// ROI scan selected
// ------------------------
begin
    if not bLiveScan.Enabled then StartNewScan( True ) ;
end;


procedure TMainFrm.DisplayROI(
          BitMap : TBitmap
          ) ;
// ------------------------------------------------------
// Display selected scanning region in full field of view
// ------------------------------------------------------
var
  PaletteType : TPaletteType ;
  PenColor : Integer ;
  Y : Integer ;
  s : string ;
begin

     // Set ROI colour
     PaletteType := TPaletteType(cbPalette.Items.Objects[cbPalette.ItemIndex]) ;
     case PaletteType of
          palGrey : PenColor := clRed ;
          else PenColor := clWhite ;
          end;

     Bitmap.Canvas.Pen.Color := PenColor ;
     Bitmap.Canvas.Pen.Width := 2 ;
     Bitmap.Canvas.Brush.Style := bsClear ;
     Bitmap.Canvas.Font.Color := PenColor ;

     SelectedRectBM.Left := Round((SelectedRect.Left - XLeft)*XScaletoBM) ;
     SelectedRectBM.Right := Round((SelectedRect.Right - XLeft)*XScaletoBM) ;
     SelectedRectBM.Top := Round((SelectedRect.Top - YTop)*YScaletoBM) ;
     SelectedRectBM.Bottom := Round((SelectedRect.Bottom - YTop)*YScaletoBM) ;

     // Display zomm area selection rectangle
     Bitmap.Canvas.Rectangle(SelectedRectBM);

     // Display square corner and mid-point tags
     DisplaySquare( Bitmap, SelectedRectBM.Left, SelectedRectBM.Top ) ;
     DisplaySquare( Bitmap, (SelectedRectBM.Left + SelectedRectBM.Right) div 2, SelectedRectBM.Top ) ;
     DisplaySquare( Bitmap, SelectedRectBM.Right, SelectedRectBM.Top ) ;
     DisplaySquare( Bitmap, SelectedRectBM.Left, (SelectedRectBM.Top + SelectedRectBM.Bottom) div 2) ;
     DisplaySquare( Bitmap, SelectedRectBM.Right, (SelectedRectBM.Top + SelectedRectBM.Bottom) div 2) ;
     DisplaySquare( Bitmap, SelectedRectBM.Left, SelectedRectBM.Bottom ) ;
     DisplaySquare( Bitmap, (SelectedRectBM.Left + SelectedRectBM.Right) div 2, SelectedRectBM.Bottom ) ;
     DisplaySquare( Bitmap, SelectedRectBM.Right, SelectedRectBM.Bottom ) ;

     if (cbImageMode.ItemIndex = XYMode) or (cbImageMode.ItemIndex = XYZMode) then begin
        Bitmap.Canvas.Pen.Color := clRed ;
        //Y := ((SelectedRectBM.Top + SelectedRectBM.Bottom) div 2) ;
        Y := Round(((SelectedRect.Top + SelectedRect.Bottom)*0.5 - YTop + 1)*YScaletoBM) ;
        Bitmap.Canvas.Polyline( [Point(0,Y),Point(Bitmap.Width-1,Y)]);
        Bitmap.Canvas.Pen.Color := clWhite ;
        end;

{     Bitmap.Canvas.Pen.Color := clBlack ;
     Bitmap.Canvas.Brush.Style := bsSolid ;
     Bitmap.Canvas.Brush.Color := clBlack ;
     Bitmap.Canvas.Font.Color := clRed ;}

     BitMap.Canvas.Pen.Color := clwhite ;
     BitMap.Canvas.Brush.Style := bsClear ;
     BitMap.Canvas.Pen.Width := 2 ;
     BitMap.Canvas.Font.Color := clWhite ;
     BitMap.Canvas.Font.Size := 12 ;

     s := format( '%.2f,%.2f um',
                  [(XLeft*PixelsToMicronsX) + ScanArea.Left,
                   YTop*PixelsToMicronsY + ScanArea.Top]);
     Bitmap.Canvas.TextOut( 0,0, s) ;

     s := format( '%.2f,%.2f um',
                  [(XLeft +(BitMap.Width/XScaleToBM))*PixelsToMicronsX
                   + ScanArea.Left,
                   (YTop + (BitMap.Height/YScaleToBM))*PixelsToMicronsY
                   + ScanArea.Top]);
     Bitmap.Canvas.TextOut( BitMap.Width - Bitmap.Canvas.TextWidth(s) -1,
                            BitMap.Height - Bitmap.Canvas.TextHeight(s) -1,
                            s ) ;
     end ;


procedure TMainFrm.DisplaySquare(
          Bitmap : TBitmap ;
          X : Integer ;
          Y : Integer ) ;
var
    Square : TRect ;
begin
     Square.Left := X - 4 ;
     Square.Right := X + 4 ;
     Square.Top := Y - 4 ;
     Square.Bottom := Y + 4 ;
     //Bitmap.Canvas.Pen.Color := clwhite ;
     Bitmap.Canvas.Brush.Style := bsSolid ;
     Bitmap.Canvas.Rectangle(Square);

     end ;


procedure TMainFrm.DisplayCursorReadout(
          Bitmap : TBitmap ) ;
// ----------------------------------------
// Display X,Y,intensity at cursor position
// ----------------------------------------
Const
    TickHeight = 10 ;
begin


     BitMap.Canvas.Pen.Color := clwhite ;
     BitMap.Canvas.Brush.Style := bsClear ;
     BitMap.Canvas.Pen.Width := 2 ;
     BitMap.Canvas.Font.Color := clWhite ;
     BitMap.Canvas.Font.Size := 12 ;
     if CursorReadoutText <> '' then BitMap.Canvas.TextOut( 0,
                                     BitMap.Height - BitMap.Canvas.TextHeight(CursorReadoutText),
                                     CursorReadoutText );

end ;


procedure TMainFrm.DisplayCalibrationBar(
          Bitmap : TBitmap ;
          X : Integer ;
          Y : Integer ) ;
// --------------------------------
// Display calibration bar on image
// --------------------------------
Const
    TickHeight = 10 ;
var
    PixelsToMicrons : double ;
    X1,BarWidth : Integer ;
begin

     PixelsToMicrons := HRPIxelSize ;
//     ScaleToBM := (BitMap.Width*Magnification[iZoom]) / Max(FrameWidth,1) ;
     BarWidth := Round( (CalibrationBarSize/PixelsToMicrons)*XScaleToBM ) ;

     BitMap.Canvas.Pen.Color := clwhite ;
     BitMap.Canvas.Brush.Style := bsClear ;
     BitMap.Canvas.Pen.Width := 2 ;
     BitMap.Canvas.MoveTo( X, Y - TickHeight ) ;
     BitMap.Canvas.LineTo(X, Y + TickHeight ) ;
     BitMap.Canvas.MoveTo( X, Y ) ;
     X1 := X + BarWidth ;
     BitMap.Canvas.LineTo( X1, Y  ) ;
     BitMap.Canvas.MoveTo( X1, Y - TickHeight ) ;
     BitMap.Canvas.LineTo( X1, Y + TickHeight ) ;

     BitMap.Canvas.Font.Color := clWhite ;
     BitMap.Canvas.Font.Size := 10 ;
     BitMap.Canvas.TextOut( X, Y + TickHeight + 1, format('%.3g um',[CalibrationBarSize]));

end ;



procedure TMainFrm.UpdateImage ;
// --------------
// Display image
// --------------
var
    ch,Ybm,Xbm,i,iLine : Integer ;
    PScanLine : PByteArray ;    // Bitmap line buffer pointer
    X,Y,dX,dY : Double ;
    XMap,YMap : PIntArray ;
    YBottom,XRight,MaxLine : Integer ;
begin

    //SetImagePanels ;

    for ch  := 0 to NumPMTChannels-1 do if pImageBuf[ch] <> Nil then
       begin

       Image[ch].Width := BitMap[ch].Width ;
       Image[ch].Height := BitMap[ch].Height ;

       DisplayMaxWidth := TabImage0.ClientWidth - TabImage0.Left - 1 ;
       DisplayMaxHeight := TabImage0.ClientHeight - TabImage0.Top - 1 ;

       // Adjust left,top edge of displayed region of image when bottom,right is off image
       XRight := Min(XLeft + Round(BitMap[ch].Width/XScaleToBM),FrameWidth) ;
       XLeft := Max( XRight - Round(BitMap[ch].Width/XScaleToBM), 0 ) ;
       YBottom := Min(YTop + Round(BitMap[ch].Height/YScaleToBM),FrameHeight) ;
       YTop := Max( YBottom - Round(BitMap[ch].Height/YScaleToBM),0) ;

       //  X axis pixel mapping
       X := XLeft ;
       dX := 1.0/XScaleToBM ;
       GetMem( XMap, BitMap[ch].Width*4 ) ;
       for i := 0 to BitMap[ch].Width-1 do
           begin
           XMap^[i] := Min(Max(Round(X),0),FrameWidth-1) ;
           X := X + dX ;
           end;

       // Y axis line mapping
       GetMem( YMap, BitMap[ch].Height*4 ) ;
       Y := YTop ;
       dY := 1.0/YScaleToBM ;
       for i := 0 to BitMap[ch].Height-1 do
           begin
           YMap^[i] := Min(Max(Round(Y),0),FrameHeight-1) ;
           Y := Y + dY ;
           end;

       if ScanningInProgress then MaxLine := LinesAvailableForDisplay
                             else MaxLine := FrameHeight ;

       // Copy image to BitMap
       for Ybm := 0 to BitMap[ch].Height-1 do
          begin
          // Copy line to BitMap
          if YMap^[Ybm] < MaxLine then
             begin
             PScanLine := BitMap[ch].ScanLine[Ybm] ;
             iLine := YMap^[Ybm]*FrameWidth ;
             for xBm := 0 to BitMap[ch].Width-1 do
                 begin
                 PScanLine[Xbm] := LUT[ch,pImageBuf[ch]^[XMap^[xBm]+iLine]] ;
                 end ;
             end ;
          end ;

       // Display ROI in XY and XYZ modde
       if (cbImageMode.ItemIndex <> XZMode) and
          (cbImageMode.ItemIndex <> XTMode) then DisplayROI(BitMap[ch]) ;

       // Display cursor readout text at top,left of image
       DisplayCursorReadout(BitMap[ch]) ;

       Image[ch].Picture.Assign(BitMap[ch]) ;
       Image[ch].Width := BitMap[ch].Width ;
       Image[ch].Height := BitMap[ch].Height ;

       FreeMem(XMap) ;
       FreeMem(YMap) ;

       end ;


    if (NumZSectionsAvailable > 1) and (not bStopScan.Enabled)  then
       begin
       ZSectionPanel.Visible := True ;
       lbZSection.Caption := format('Section %d/%d',[ZSection+1,NumZSectionsAvailable]) ;
       end
    else
       begin
       ZSectionPanel.Visible := False ;
       end;

    end ;


procedure TMainFrm.UpdateLUT(
          ch : integer ;
          GreyMax : Integer ) ;
// ----------------------------
// Create display look-up table
// ----------------------------
var
    y : Integer ;
    i,j : Integer ;
    GreyScale : Single ;
begin

     if GreyHi[ch] <> GreyLo[ch] then
        GreyScale := (MaxPaletteColor - MinPaletteColor)/ (GreyHi[ch] - GreyLo[ch])
     else GreyScale := 1.0 ;

     j := 0 ;
     for i := 0 to GreyMax do
         begin
         y := MinPaletteColor + Round((i-GreyLo[ch])*GreyScale) ;
         if y < MinPaletteColor then y := MinPaletteColor ;
         if y > MaxPaletteColor then y := MaxPaletteColor ;
         LUT[ch,j] := y ;
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
       PalGrey :
           Begin
           for i := MinPaletteColor to MaxPaletteColor do
               begin
               Pal^.palPalEntry[i].peRed := i ;
               Pal^.palPalEntry[i].peGreen := i ;
               Pal^.palPalEntry[i].peBlue := i ;
               end;
           end ;

       // Green scale
       PalGreen :
           Begin
           for i := MinPaletteColor to MaxPaletteColor do
               begin
               Pal^.palPalEntry[i].peRed := 0;
               Pal^.palPalEntry[i].peGreen := i;
               Pal^.palPalEntry[i].peBlue := 0 ;
               end;
           end ;

       // Red scale
       PalRed :
           Begin
           for i := MinPaletteColor to MaxPaletteColor do
               begin
               Pal^.palPalEntry[i].peRed := i;
               Pal^.palPalEntry[i].peGreen := 0;
               Pal^.palPalEntry[i].peBlue := 0 ;
               end;
           end ;

       // Blue scale
       PalBlue :
           Begin
           for i := MinPaletteColor to MaxPaletteColor do
               begin
               Pal^.palPalEntry[i].peRed := 0;
               Pal^.palPalEntry[i].peGreen := 0;
               Pal^.palPalEntry[i].peBlue := i ;
               end;
           end ;

       // False colour
       PalFalseColor :
           begin
           for i := MinPaletteColor to MaxPaletteColor do
               begin
               if i <= 63 then
                  begin
                  Pal^.palPalEntry[i].peRed := 0 ;
                  Pal^.palPalEntry[i].peGreen := 254 - 4*i ;
                  Pal^.palPalEntry[i].peBlue := 255 ;
                  end
               else if i <= 127 then
                  begin
                  Pal^.palPalEntry[i].peRed := 0 ;
                  Pal^.palPalEntry[i].peGreen := 4*i - 254 ;
                  Pal^.palPalEntry[i].peBlue := 510 - 4*i ;
                  end
               else if i <= 191 then
                  begin
                  Pal^.palPalEntry[i].peRed := 4*i - 510 ;
                  Pal^.palPalEntry[i].peGreen := 255 ;
                  Pal^.palPalEntry[i].peBlue := 0 ;
                  end
               else
                  begin
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
    if bStopScan.Enabled then bStopScan.Click ;
    StartNewScan( False ) ;
    end ;


procedure TMainFrm.StartNewScan(
              FastScan : Boolean      // TRUE = Fast scan mode
              ) ;
// ---------------
// Start new scan
// ---------------
begin

    if UnsavedRawImage then begin
       if MessageDlg( 'Current Image not saved! Do you want to overwrite image?',
           mtWarning,[mbYes,mbNo], 0 ) = mrNo then Exit ;
    end;
    UnsavedRawImage := not FastScan ;

    NumAverages := 1 ;

    ClearAverage := True ;

    //bStopScan.Enabled := True ;
    bCaptureImage.Enabled := False ;

//    PMTGrp.Enabled := False ;    // Disable changes to PMT settings


//  Select scanning region
//  ----------------------

    if rbFullField.Checked then
       begin
       // Set scanning area to full microscope field
       ScanArea.Left := 0.0 ;
       ScanArea.Right := FullFieldWidthMicrons ;
       ScanArea.Top := 0.0 ;
       ScanArea.Bottom := FullFieldWidthMicrons ;
       ScanArea.Width := ScanArea.Right - ScanArea.Left ;
       ScanArea.Height := ScanArea.Bottom - ScanArea.Top ;
       end
    else if rbScanROI.Checked then
       begin
       // Use ROI as scanning area
       if (SelectedRect.Left > 0) or (SelectedRect.Top > 0) or
          (SelectedRect.Right < (FrameWidth-1)) or
          (SelectedRect.Bottom < (FrameHeight-1)) then
          begin
          ScanArea.Left := ScanArea.Left + (SelectedRect.Left*PixelsToMicronsX) ;
          ScanArea.Width := (SelectedRect.Right - SelectedRect.Left)*PixelsToMicronsX ;
          ScanArea.Right := ScanArea.Left + ScanArea.Width ;
          ScanArea.Top := ScanArea.Top + (SelectedRect.Top*PixelsToMicronsY) ;
          ScanArea.Height := (SelectedRect.Bottom - SelectedRect.Top)*PixelsToMicronsY ;
          ScanArea.Bottom := ScanArea.Top + ScanArea.Height ;
          end;
       end
     else
       begin
       // Use user-defined area
       ScanArea.Left := edXRange.LoValue ;
       ScanArea.Right := edXRange.HiValue ;
       ScanArea.Top := edYRange.LoValue ;
       ScanArea.Bottom := edYRange.HiValue ;
       end;

    //Update area with current settings
    edXRange.LoValue := ScanArea.Left ;
    edXRange.HiValue := ScanArea.Right ;
    edYRange.LoValue := ScanArea.Top ;
    edYRange.HiValue := ScanArea.Bottom ;

    FixRectangle( SelectedRectBM ) ;

    case cbImageMode.ItemIndex of

      // XY and XYZ imaging mode
      XYMode,XYZMode :
       begin
       end ;

      // XT line scan mode
      XTMode :
        begin
        if FastScan then
           begin
           FrameWidth := FastFrameWidth ;
           end
        else
          begin
          end ;
        end ;

      // XZ image mode
      XZMode :
        begin
        if FastScan then
           begin
           FrameWidth := FastFrameWidth ;
           end
        else
           begin
           end ;
//        FrameHeightScale := 1.0 ;
        FrameHeight := Round(edNumZSections.Value) ;
        end ;

      end ;

//      Outputdebugstring(pchar(format('frameheightscale %.0f',[FrameHeightScale])));

    meStatus.Clear ;

    // Z sections
    ZSection := 0 ;
    NumZSectionsAvailable := 0 ;
    ZStep := edNumPixelsPerZStep.Value*HRPixelSize ;
    edMicronsPerZStep.Value := ZStep ;
    NumZSections := Round(edNumZSections.Value) ;

    // Save current position of Z stage
    ZStartingPosition := ZStage.ZPosition ;

    // Create scan waveform
    CreateScanWaveform(FastScan) ;

    // Image pixel to microns scaling factor
    PixelsToMicronsX := ScanArea.Width/FrameWidth ;
    PixelsToMicronsY := {FrameHeightScale*}PixelsToMicronsX ;

    SetImagePanels ;

    // Set ROI to whole image
    SelectedRect.Left := 0 ;
    SelectedRect.Right := FrameWidth-1 ;
    SelectedRect.Top := 0 ;
    SelectedRect.Bottom := FrameHeight-1 ;

    ScanRequested := 1 ;

    end ;


procedure TMainFrm.StartScan ;
// ---------------
// Scan image scan
// ---------------
var
    i,nSamples : Integer ;
    AOList : Array[0..1] of Integer ;
    NumPixels : Int64 ;
    ScanSpeed : Double ;
begin

    // Stop A/D & D/A
    MemUsed := 0 ;
    ADCPointer := 0 ;
    XZLine := 0 ;
//    XZAverageLine := 0 ;
    if LabIO.ADCActive[DeviceNum] then LabIO.StopADC(DeviceNum) ;
    if LabIO.DACActive[DeviceNum] then LabIO.StopDAC(DeviceNum) ;

    NumPixels := Int64(ScanCycle.NP)*Int64(ScanCycle.NumLines) ;

    if ClearAverage then
       begin
       // Dispose of existing display buffers and create new ones
       if AvgBuf <> Nil then FreeMem( AvgBuf ) ;
       AvgBuf := AllocMem( NumPixels*Int64(NumPMTChannels)*4 ) ;
       for i := 0 to NumPixels*NumPMTChannels-1 do AvgBuf^[i] := 0 ;
       ClearAverage := False ;
       NumAverages := 1 ;
       end ;

    ADCPointer := 0 ;

    // Set up for XZ mode image
    XZLine := 0 ;
    LinesAvailableForDisplay := 0 ;

    ADCNumNewSamples := 0 ;

    ADCPointer := 0 ;

    // Update PMT and laser settings
    UpdatePMTSettings ;

    // Set PMT integrator integration time
    PMT.SetIntegrationTime(PixelDwellTime);

    ScanSpeed := 1.0/(ScanCycle.NP*PixelDwellTime) ;
    ScanInfo := format('%.3g lines/s Tdwell=%.3g us LPF=%.0f kHz',[ScanSpeed,1E6*PixelDwellTime,PMT.LPFilter3dBCutOff*1E-3]);
    LineScanTime := NumXPixels*PixelDwellTime ;

    // Turn PMTs on
    PMT.Active := True ;

    // Setup A/D conversion of PMTs
    nSamples := Max(Round(10.0/PixelDwellTime) div ScanCycle.NP,1)*ScanCycle.NP ;
    LabIO.ADCToMemoryExtScan( DeviceNum,
                              PMT.PMTEnabled,
                              PMT.ADCGainIndex,
                              PMTList,
                              NumPMTChannels,
                              ScanCycle.NP*ScanCycle.NumLines,
                              False,
                              DeviceNum ) ;

    // Start D/A waveform output to galvos
    AOList[0] := LabIO.Resource[XGalvoControl].StartChannel ;
    AOList[1] := LabIO.Resource[YGalvoControl].StartChannel ;
    LabIO.MemoryToDAC( LabIO.Resource[XGalvoControl].Device,
                       DACBuf,
                       AOList,
                       2,
                       NumPixels,
                       NumPixelsinDACBuf,
                       PixelDwellTime,
                       False,
                       False,
                       LabIO.Resource[XGalvoControl].Device ) ;

    bStopScan.Enabled := True ;
    bCaptureImage.Enabled := False ;
    ScanningInProgress := True ;

    end;


procedure TMainFrm.tbPMTLaserIntensity0Change(Sender: TObject);
// --------------------------------
// Laser intensity trackbar changed
// --------------------------------
begin
    if not FormInitialized then Exit ;
    // Read PMT controls, updating laser intensity edit box with trackbar value
    ReadWritePMTGroup( 0, gpPMT0, 'RT' ) ;
    ReadWritePMTGroup( 1, gpPMT1, 'RT' ) ;
    ReadWritePMTGroup( 2, gpPMT2, 'RT' ) ;
    ReadWritePMTGroup( 3, gpPMT3, 'RT' ) ;
    if Laser.Active then Laser.Active := True ;
    end;


procedure TMainFrm.bCaptureImageClick(Sender: TObject);
// -------------------------------------------------------
// Capture high resolution imageof currently selected area
// -------------------------------------------------------
begin
    LiveImageMode := False ;
    StartNewScan( False ) ;
    end ;


procedure TMainFrm.bFullScaleClick(Sender: TObject);
// --------------------------------------------------------
// Set display grey scale to full intensity range of camera
// --------------------------------------------------------
begin

    edDisplayIntensityRange.LoValue := 0 ;
    GreyLo[ImagePage.ActivePageIndex] := Round(edDisplayIntensityRange.LoValue) ;
    edDisplayIntensityRange.HiValue := ADCMaxValue ;
    GreyHi[ImagePage.ActivePageIndex] := Round(edDisplayIntensityRange.HiValue) ;


    UpdateLUT( ImagePage.ActivePageIndex, ADCMaxValue ) ;

    // Set intensity range and sliders
    SetDisplayIntensityRange( GreyLo[ImagePage.ActivePageIndex],
                              GreyHi[ImagePage.ActivePageIndex] ) ;

    UpdateDisplay := True ;

    end ;


procedure TMainFrm.edDisplayIntensityRangeKeyPress(Sender: TObject;
  var Key: Char);
// ------------------------------
// Update display intensity range
// ------------------------------
begin

     if key <> #13 then Exit ;

     if edDisplayIntensityRange.LoValue = edDisplayIntensityRange.HiValue then
        begin
        edDisplayIntensityRange.LoValue := edDisplayIntensityRange.LoValue - 1.0 ;
        edDisplayIntensityRange.HiValue := edDisplayIntensityRange.HiValue + 1.0 ;
        end ;

     GreyLo[ImagePage.ActivePageIndex] := Round(edDisplayIntensityRange.LoValue) ;
     GreyHi[ImagePage.ActivePageIndex] := Round(edDisplayIntensityRange.HiValue) ;

     UpdateLUT( ImagePage.ActivePageIndex, ADCMaxValue ) ;

     // Set intensity range and sliders
     SetDisplayIntensityRange( GreyLo[ImagePage.ActivePageIndex],
                               GreyHi[ImagePage.ActivePageIndex] ) ;

     UpdateDisplay := True ;
     end;


procedure TMainFrm.edGotoXPositionKeyPress(Sender: TObject; var Key: Char);
// ---------------------------------------------------------
// Key pressed - Go to position entered by user if key is CR
// ---------------------------------------------------------
begin
    if Key = #13 then
        begin
        ZStage.MoveTo( edGoToXPosition.Value, ZStage.YPosition,ZStage.ZPosition ) ;
        end;
    end;


procedure TMainFrm.edGotoYPositionKeyPress(Sender: TObject; var Key: Char);
// ---------------------------------------------------------
// Key pressed - Go to position entered by user if key is CR
// ---------------------------------------------------------
begin
    if Key = #13 then
        begin
        ZStage.MoveTo( ZStage.XPosition, edGoToYPosition.Value, ZStage.ZPosition ) ;
        end;
    end;


procedure TMainFrm.edGotoZPositionKeyPress(Sender: TObject; var Key: Char);
// ---------------------------------------------------------
// Key pressed - Go to position entered by user if key is CR
// ---------------------------------------------------------
begin
    if Key = #13 then
        begin
        ZStage.MoveTo( ZStage.XPosition,ZStage.YPosition,edGoToZPosition.Value ) ;
        end;
    end;


procedure TMainFrm.edMicronsPerZStepKeyPress(Sender: TObject; var Key: Char);
// -------------------------
// Microns per Z step changed
// -------------------------
begin
      if Key = #13 then
         begin
         edNumPixelsPerZStep.Value := edMicronsPerZStep.Value / HRPixelSize ;
         edMicronsPerZStep.Value := edNumPixelsPerZStep.Value*HRPixelSize ;
         end;
      end;


procedure TMainFrm.edNumPixelsPerZStepKeyPress(Sender: TObject; var Key: Char);
// -------------------------
// Pixels per Z step changed
// -------------------------
begin
      if Key = #13 then
         begin
         edMicronsPerZStep.Value := edNumPixelsPerZStep.Value*HRPixelSize ;
         end;
      end;



procedure TMainFrm.bGoToXPositionClick(Sender: TObject);
// -------------------------
// Go to specified X position
// --------------------------
begin
    ZStage.MoveTo( edGoToXPosition.Value, ZStage.YPosition, ZStage.ZPosition ) ;
    end;


procedure TMainFrm.bGoToYPositionClick(Sender: TObject);
// -------------------------
// Go to specified Y position
// --------------------------
begin
    ZStage.MoveTo( ZStage.XPosition, edGoToYPosition.Value,  ZStage.ZPosition ) ;
    end;


procedure TMainFrm.bGotoZPositionClick(Sender: TObject);
// -------------------------
// Go to specified Z position
// --------------------------
begin
    ZStage.MoveTo( ZStage.XPosition, ZStage.YPosition, edGoToZPosition.Value ) ;
    end;


procedure TMainFrm.bLiveSCanClick(Sender: TObject);
// -----------------------------------------------
// Start live fast scan of currently selected area
// -----------------------------------------------
begin
    LiveImageMode := True ;
    StartNewScan( True ) ;
    bLiveScan.Enabled := False ;

    end ;


procedure TMainFrm.bMaxContrastClick(Sender: TObject);
// -------------------------------------------------------------
// Request display intensity range to be set for maximum contrast
// -------------------------------------------------------------
begin

     CalculateMaxContrast ;

     // Set intensity range and sliders
     SetDisplayIntensityRange( GreyLo[ImagePage.ActivePageIndex],
                               GreyHi[ImagePage.ActivePageIndex] ) ;

     UpdateDisplay := True ;

     end;


procedure TMainFrm.CalculateMaxContrast ;
// ---------------------------------------------------------
// Calculate and set display for maximum grey scale contrast
// ---------------------------------------------------------
const
    MaxPoints = 10000 ;
var
     ch,i,NumPixels,iStep : Integer ;
     z,zMean,zSD,zSum : Single ;
     iz,ZMin,ZMax,ZLo,ZHi,ZThreshold : Integer ;
     FrameType : Integer ;
begin

    ch := ImagePage.ActivePageIndex ;

    NumPixels := FrameWidth*FrameHeight - 4 ;
    FrameType := 0 ;
    if NumPixels < 2 then Exit ;

    iStep := Max(NumPixels div MaxPoints,1) ;

    if ckContrast6SDOnly.Checked then
       begin
       // Set contrast range to +/- 3 x standard deviation
       ZSum := 0.0 ;
       for i := 0 to NumPixels - 1 do ZSum := ZSum + pImageBuf[ch]^[i] ;
       ZMean := ZSum / NumPixels ;

       ZSum := 0.0 ;
       i := 0 ;
       repeat
         Z :=pImageBuf[ch]^[i] ;
         ZSum := ZSum + (Z - ZMean)*(Z - ZMean) ;
         i := i + iStep ;
         until i >= NumPixels ;
       ZSD := Sqrt( ZSum / (NumPixels-1) ) ;

       ZLo := Max( Round(ZMean - 3*ZSD),0) ;
       ZHi := Min( Round(ZMean + 3*ZSD), ADCMaxValue );
       end
    else
       begin
       // Set contrast range to min-max
       ZMin := ADCMaxValue ;
       ZMax := 0 ;
       i := 0 ;
       repeat
         iz := pImageBuf[ch]^[i] ;
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
       (Abs(MainFrm.GreyLo[ch]- ZLo) > 10) then MainFrm.GreyLo[ch] := ZLo ;
    if (not ckAutoOptimise.Checked) or
       (Abs(MainFrm.GreyHi[ch]- ZHi) > 10) then MainFrm.GreyHi[ch] := ZHi ;

    // Ensure a non-zero LUT range
    if MainFrm.GreyLo[ch] = MainFrm.GreyHi[ch] then
       begin
       MainFrm.GreyLo[ch] := MainFrm.GreyLo[ch] - 1 ;
       MainFrm.GreyHi[ch] := MainFrm.GreyHi[ch] + 1 ;
       end ;

    UpdateLUT(ch, ADCMaxValue ) ;

    end ;


procedure TMainFrm.TimerTimer(Sender: TObject);
// -------------------------
// Regular timed operations
// --------------------------
begin

    if UpdateDisplay then
       begin ;
       UpdateImage ;
       UpdateDisplay := False ;
       end ;

    if ScanRequested > 0 then
       begin
       Laser.Active := True ;
       ScanRequested := Max(ScanRequested - 1,0) ;
       if ScanRequested <= 0 then
          begin
          StartScan ;
          UpdateImage ;
          end ;
       end ;

    GetImageFromPMT ;

    // Acquire and display current stage position
    edXYZPosition.Text := format('X=%.2f, Y=%.2f, Z=%.2f um',
                          [ZStage.XPosition,ZStage.YPosition,ZStage.ZPosition]) ;

    if Laser.Changed then
       begin
       // PMT controls
       ReadWritePMTGroup( 0, gpPMT0, 'W' ) ;
       ReadWritePMTGroup( 1, gpPMT1, 'W' ) ;
       ReadWritePMTGroup( 2, gpPMT2, 'W' ) ;
       ReadWritePMTGroup( 3, gpPMT3, 'W' ) ;
       Laser.Changed := False ;
       end;

    end;





procedure TMainFrm.TrackBar2Change(Sender: TObject);
// --------------------------------
// Laser intensity trackbar changed
// --------------------------------
begin
    if not FormInitialized then Exit ;
    // Read PMT controls, updating laser intensity edit box with trackbar value
    ReadWritePMTGroup( 0, gpPMT0, 'RT' ) ;
    ReadWritePMTGroup( 1, gpPMT1, 'RT' ) ;
    ReadWritePMTGroup( 2, gpPMT2, 'RT' ) ;
    ReadWritePMTGroup( 3, gpPMT3, 'RT' ) ;
    end;


procedure TMainFrm.GetImageFromPMT ;
// ------------------
// Get image from PMT
// ------------------
var
    ch,iPix,iSign,iLine,nAvg,iAvg,AvgFrameStart,iY,iYStart : Integer ;
    i,ADCStart,ADCEnd : NativeInt ;
    NewZSection : Integer ;
    Sum,y : Integer ;
    j: Integer;
    iPhaseShift : Integer ;
begin

    if not LabIO.DACActive[DeviceNum] then exit ;
    if not ScanningInProgress then exit ;

    // Read new A/D converter samples
    if not LabIO.GetADCSamples( DeviceNum, ADCBuf^,ADCStart,ADCEnd ) then Exit ;

    // Copy image from circular buffer into 32 bit display buffer

    if InvertPMTSignal then iSign := -1
                       else iSign := 1 ;

    iPhaseShift := Round(Abs(PhaseShift)/PixelDwellTime)*NumPMTChannels ;
    for i := ADCStart to ADCEnd do
        begin
        ADCPointer := i ;

        // Add to average buffer
        AvgBuf^[i] := AvgBuf^[i] + ADCBuf^[i] ;

        // Determine pixel and line position
        iPix :=  ((i - iPhaseShift) div NumPMTChannels) mod ScanCycle.NP ;
        iLine := ((i - iPhaseShift) div NumPMTChannels) div ScanCycle.NP ;

        if (iPix >= ScanCycle.StartImage) and (iPix <= ScanCycle.EndImage) and
           (iLine >= ScanCycle.StartLine) and (iLine <= ScanCycle.EndLine) then
           begin
           ch := i mod NumPMTChannels ;
           // Average and add black level
           y := iSign*(AvgBuf^[i] div NumAverages) + BlackLevel ;
           // Keep within 16 bit limits
           if y  < 0 then y := 0 ;
           if y > ADCMaxValue then y := ADCmaxValue ;
           // Copy to image buffer
           iYStart := (iLine - ScanCycle.StartLine)*ScanCycle.NumLineRepeats ;
           for iY := iYStart to iYStart + ScanCycle.NumLineRepeats -1 do
               pImageBuf[ch]^[(iPix - ScanCycle.StartImage) + iY*FrameWidth] := y  ;
           end;

        end ;

    // Increment Z stage in XZ mode
    if cbImageMode.ItemIndex = XZMode then
       begin
       NewZSection := iLine div NumLinesPerZStep ;
       nAvg := Max(Round(edNumAverages.Value),1) ;
       if (NewZSection <> ZSection) and (XZLine < FrameHeight) then
          begin
          // Average lines for Z section
          AvgFrameStart := ((XZLine*NumLinesPerZStep) + NumLinesPerZStep - 1)*FrameWidth  ;
          for ch := 0 to NumPMTChannels-1 do
              begin
              for i := 0 to FrameWidth-1 do
                  begin
                  Sum := 0 ;
                  j := AvgFrameStart + i ;
                  for iAvg := 1 to nAvg do
                      begin
                      Sum := Sum + pImageBuf[ch]^[j] ;
                      j := j - FrameWidth ;
                      end;
                  pImageBuf[ch]^[(XZLine*FrameWidth)+i] := Sum div nAvg
                  end ;
              end;
          Inc(XZLine) ;
          LinesAvailableForDisplay := XZLine ;
          ZSection := NewZSection ;
          ZStage.MoveTo( ZStage.XPosition,ZStage.YPosition, ZStage.ZPosition + ZStep );
          end;
       end
    else
       begin
       LinesAvailableForDisplay := FrameHeight ;
       NewZSection := 0 ;
       end;

    meStatus.Clear ;
    case cbImageMode.ItemIndex of
       XYMode,XTMode :
         begin
         meStatus.Lines[0] := format('Line %5d/%d (%.3f MB)',
                              [iLine,ScanCycle.NumLines,ADCPointer/1048576.0]);
         meStatus.Lines.Add(format('Average %d/%d',[NumAverages,Round(edNumAverages.Value)])) ;
         end;
       XYZMode :
         begin
         meStatus.Lines[0] := format('Line %5d/%d (%.2f MB)',
                              [iLine,ScanCycle.NumLines,ADCPointer/1048576.0]);
         meStatus.Lines.Add(format('Average %d/%d',[NumAverages,Round(edNumAverages.Value)])) ;
         meStatus.Lines.Add(format('Section %d/%d',[ZSection+1,NumZSections])) ;
         end;
       XZMode :
         begin
         meStatus.Lines[0] := format('Line %5d/%d (%.2f MB)',
                              [NewZSection,NumZSections,
                               ADCPointer/(NumLinesPerZStep*1048576.0)]);
         end;
       end;

    meStatus.Lines.Add( ScanInfo ) ;
    ADCNumNewSamples := 0 ;

    NumPixels := Int64(ScanCycle.NP)*Int64(ScanCycle.NumLines) ;
    if ADCPointer >= (NumPixels*NumPMTChannels-4) then
       begin

       if cbImageMode.ItemIndex = XZMode then
          begin
          NumAverages := Round(edNumAverages.Value) + 1 ;
          SaveRawImage( RawImagesFileName, 0 ) ;
          end
       else
          begin
          Inc(NumAverages) ;
          SaveRawImage( RawImagesFileName, ZSection ) ;
          end;

       if NumAverages <= Round(edNumAverages.Value) then
          begin
          ScanRequested := 1 ;
          end
       else
          begin
          ScanningInProgress := False ;
          if LiveImageMode then
             begin
             ScanRequested := 1 ;
             NumAverages := 1 ;
             ClearAverage := True ;
             if cbImageMode.ItemIndex = XZMode then ZStage.MoveTo( ZStage.XPosition,ZStage.YPosition,ZStartingPosition );
             end
          else if cbImageMode.ItemIndex = XYZMode then
             begin
             // Increment Z position to next Section
             Inc(ZSection) ;
             ZStage.MoveTo( ZStage.XPosition,ZStage.YPosition,ZStage.ZPosition + ZStep );
             if ZSection < NumZSections then
                begin
                ScanRequested := Max(Round(ZStage.ZStepTime/(Timer.Interval*0.001)),1) ;
                NumAverages := 1 ;
                ClearAverage := True ;
                end
             else
                begin
                bStopScan.Click ;
             end ;
          end
          else
             begin
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

    // Stop A/D and D/A activity
    if LabIO.ADCActive[DeviceNum] then LabIO.StopADC(DeviceNum) ;
    if LabIO.DACActive[DeviceNum] then LabIO.StopDAC(DeviceNum) ;
    LabIO.WriteDACs( DeviceNum,[0.0,0.0],2);

    // Turn off voltage to PMTs
    PMT.Active := False ;

    // Turn off lasers
    Laser.Active := False ;

    if AvgBuf <> Nil then
      begin
      FreeMem(AvgBuf) ;
      AvgBuf := Nil ;
      end;

    if DACBuf <> Nil then
      begin
      FreeMem(DACBuf) ;
      DACBuf := Nil ;
      end;

    bStopScan.Enabled := False ;
    PMTGrp.Enabled := True ;    // Enable changes to PMT settings

    ScanRequested := 0 ;
    ScanningInProgress := False ;
    LinesAvailableForDisplay := 0 ;

    // Move Z stage back to starting position

    case cbImageMode.ItemIndex of
       XYZMode :
         begin
         //ZStage.MoveTo( ZStartingPosition );
         scZSection.Position := 0 ;
         end;
       XZMode :
         begin
         ZStage.MoveTo( ZStage.XPosition,ZStage.YPosition,ZStartingPosition );
         end;
       end;

    bLiveScan.Enabled := True ;
    bCaptureImage.Enabled := True ;

    end;



 procedure TMainFrm.bZoomInClick(Sender: TObject);
 // ---------------
 // Magnify display
 // ---------------
 var
   NewWidth,NewHeight,MagnificationOld : Integer ;
begin
     // Old magnification factor
     MagnificationOld := Magnification[iZoom] ;
     // Increase zoom index
     iZoom := Min(iZoom + 1,High(Magnification));

     // New image size (bitmap pixels)
     NewWidth := Round(BitMap[0].Width*(MagnificationOld/Magnification[iZoom])) ;
     NewHeight := Round(BitMap[0].Height*(MagnificationOld/Magnification[iZoom])) ;

     // New top,left (image pixels) centred on current image
     XLeft := XLeft + Round((BitMap[0].Width - NewWidth)/(XScaleToBM*2.0)) ;
     YTop := YTop   + Round((BitMap[0].Height - NewHeight)/(XScaleToBM*2.0)) ;

     Resize ;
     UpdateDisplay := True ;

     end;


procedure TMainFrm.bZoomOutClick(Sender: TObject);
 // ----------------
 // Zoom out display
 // ----------------
 var
   NewWidth,NewHeight,MagnificationOld : Integer ;
begin
       // Old magnification factor
       MagnificationOld := Magnification[iZoom] ;
       // Increase zoom index
       iZoom := Max(iZoom - 1,0);

       // New image size (bitmap pixels)
       NewWidth := Round(BitMap[0].Width*(MagnificationOld/Magnification[iZoom])) ;
       NewHeight := Round(BitMap[0].Height*(MagnificationOld/Magnification[iZoom])) ;

       // New top,left (image pixels) centred on current image
       XLeft := XLeft + Round((BitMap[0].Width - NewWidth)/(XScaleToBM*2.0)) ;
       YTop := YTop   + Round((BitMap[0].Height - NewHeight)/(XScaleToBM*2.0)) ;

       Resize ;
       UpdateDisplay := True ;

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


procedure TMainFrm.cbPMTLaser0Change(Sender: TObject);
// -----------------
// PMT Laser changed
// -----------------
begin
    if not FormInitialized then Exit ;
    // Read PMT controls
    ReadWritePMTGroup( 0, gpPMT0, 'R' ) ;
    ReadWritePMTGroup( 1, gpPMT1, 'R' ) ;
    ReadWritePMTGroup( 2, gpPMT2, 'R' ) ;
    ReadWritePMTGroup( 3, gpPMT3, 'R' ) ;
    if Laser.Active then Laser.Active := True ;
    end;


procedure TMainFrm.cbPaletteChange(Sender: TObject);
// ------------------------------
// Display colour palette changed
// ------------------------------
var
    ch : Integer ;
begin
     PaletteType := TPaletteType(cbPalette.Items.Objects[cbPalette.ItemIndex]) ;
     for ch  := 0 to NumPMTChannels-1 do
         if BitMap[ch] <> Nil then SetPalette( BitMap[ch], PaletteType ) ;

     UpdateDisplay := True ;
     end;


procedure TMainFrm.cbPMTGain0Change(Sender: TObject);
// -----------------
// A/D range changed
// -----------------
begin
    if not FormInitialized then Exit ;
    // Read PMT controls
    ReadWritePMTGroup( 0, gpPMT0, 'R' ) ;
    ReadWritePMTGroup( 1, gpPMT1, 'R' ) ;
    ReadWritePMTGroup( 2, gpPMT2, 'R' ) ;
    ReadWritePMTGroup( 3, gpPMT3, 'R' ) ;
    end;


procedure TMainFrm.ckEnablePMT0Click(Sender: TObject);
// --------------------
// PMT enabled/disabled
// --------------------
begin
  if not FormInitialized then Exit ;
  UpdatePMTSettings ;
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

     SettingsFrm.ShowModal ;
     edMicronsPerZStep.Value := edNumPixelsPerZStep.Value*HRPixelSize ;

     // PMT controls
     ReadWritePMTGroup( 0, gpPMT0, 'W' ) ;
     ReadWritePMTGroup( 1, gpPMT1, 'W' ) ;
     ReadWritePMTGroup( 2, gpPMT2, 'W' ) ;
     ReadWritePMTGroup( 3, gpPMT3, 'W' ) ;

     end;



procedure TMainFrm.mnSaveImageClick(Sender: TObject);
// --------------------------
// Save current image to file
// --------------------------
begin
    SaveImage(False);
end;


procedure TMainFrm.SaveImage( OpenImageJ: boolean ) ;
// -----------------------------
// Save current image(s) to file
// -----------------------------
var
    FileName,s : String ;
    iSection,nFrames : Integer ;
    iNum : Integer ;
    iPMT : Integer ;
    Exists : boolean ;
begin

     SaveDialog.InitialDir := SaveDirectory ;

     // Create an unused file name
     iNum := 1 ;
     repeat
        Exists := False ;
        FileName := SaveDialog.InitialDir + '\'
                    + FormatDateTime('yyyy-mm-dd',Now)
                    + format(' %d.tif',[iNum]) ;
        Exists := false ;
        for iPMT := 0 to NumPMTChannels-1 do
            for iSection := 0 to NumZSectionsAvailable-1 do
                begin
                s := SectionFileName(FileName,iPMT,iSection) ;
                Exists := Exists or FileExists(SectionFileName(FileName,iPMT,iSection)) ;
                end;
        Inc(iNum) ;
     until not Exists ;

     // Open save file dialog
     SaveDialog.FileName := ExtractFileName(FileName) ;
     if not SaveDialog.Execute then Exit ;

     // Ensure extension is set
     FileName := ChangeFileExt(SaveDialog.FileName, '.tif' ) ;
     Filename := ReplaceText( FileName, '.ome.tif', '.tif' ) ;
     SaveDirectory := ExtractFilePath(SaveDialog.FileName) ;

     // Check if any files exist already and allow user option to quit
     Exists := False ;
     for iPMT := 0 to NumPMTChannels-1 do
         for iSection := 0 to NumZSectionsAvailable-1 do
             begin
             Exists := Exists or FileExists(SectionFileName(FileName,iPMT,iSection)) ;
             if Exists then Break ;
             end;
     if Exists then if MessageDlg( format(
                    'File %s already exists! Do you want to overwrite it? ',[SectionFileName(FileName,iPMT,iSection)]),
                    mtWarning,[mbYes,mbNo], 0 ) = mrNo then Exit ;

     // Save image
     for iPMT := 0 to NumPMTChannels-1 do
         begin
         for iSection  := 0 to NumZSectionsAvailable-1 do
             begin

             meStatus.Lines.Clear ;
             mestatus.Lines[0] := format('Saving to file %s %d/%d',
                                  [ImageNames[iPMT],iSection+1,NumZSectionsAvailable]);

             // Load image
             LoadRawImage( RawImagesFileName, iSection ) ;

             // Create file
             if (not SaveAsMultipageTIFF) or (iSection = 0) then
                begin

                // Save individual (or first) section in stack
                if SaveAsMultipageTIFF then nFrames := NumZSectionsAvailable
                                       else nFrames := 1 ;
                if not ImageFile.CreateFile( SectionFileName(FileName,iPMT,iSection),
                                             FrameWidth,FrameHeight,
                                             2*8,1,nFrames ) then Exit ;
                ImageFile.XResolution := ScanArea.Width/FrameWidth ;
                ImageFile.YResolution := ImageFile.XResolution ;
                ImageFile.ZResolution := ZStep ;
                ImageFile.SaveFrame( 1, PImageBuf[iPMT] ) ;
                if not SaveAsMultipageTIFF then ImageFile.CloseFile ;
                end
             else
                begin
                // Save subsequent sections of stack
                ImageFile.SaveFrame( iSection+1, PImageBuf[iPMT] ) ;
                end;
             end ;

         // Close file (if a multipage TIFF)
         if SaveAsMultipageTIFF then ImageFile.CloseFile ;

         end;

     // Open in Image-J window
     if OpenImageJ and FileExists(ImageJPath) then
        begin
        if SaveAsMultipageTIFF then nFrames := 1
                               else nFrames := NumZSectionsAvailable ;
        for iPMT := 0 to NumPMTChannels-1 do
            for iSection := 0 to nFrames-1 do
                ShellExecute( Handle,
                      PChar('open'),
                      PChar('"'+ImageJPath+'"'),
                      PChar('"'+SectionFileName(FileName,iPMT,iSection)+'"'),
                      nil,
                      SW_SHOWNORMAL) ;
        end ;

     mestatus.Lines.Add('File saved') ;
     UnsavedRawImage := False ;

end;


function TMainFrm.SectionFileName(
         FileName : string ; // Base file name
         iChannel : Integer ;    // PMT #
         iSection : Integer  // Z section #
         ) : string ;
// ------------------------------------------
// Return file name to of Channel / Z section
// ------------------------------------------
begin

     if (NumZSectionsAvailable > 1) and (not SaveAsMultipageTIFF) then
        begin
        Result := ANSIReplaceText( FileName, '.tif',
                  format('.%s.%d.ome.tif',[ImageNames[iChannel],iSection+1])) ;
        end
     else
        begin
        Result := ANSIReplaceText( FileName, '.tif',
                  format('.%s.ome.tif',[ImageNames[iChannel]])) ;
        end;
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


procedure TMainFrm.sbContrastChange(Sender: TObject);
// --------------------------------------------------------
// Set display grey scale to new contrast slider setting
// --------------------------------------------------------
var
     GreyLevelMidPoint,GreyLevelRange : Integer ;
begin

     if ContrastPage.ActivePage <> SlidersTab then Exit ;

     GreyLevelMidPoint := sbBrightness.Max - sbBrightness.Position ;
     GreyLevelRange := sbContrast.Max - sbContrast.Position ;
     edDisplayIntensityRange.LoValue := Max( GreyLevelMidPoint - (GreyLevelRange div 2),0) ;
     edDisplayIntensityRange.HiValue := Min( GreyLevelMidPoint + (GreyLevelRange div 2), ADCMaxValue);

     if edDisplayIntensityRange.LoValue = edDisplayIntensityRange.HiValue then
        begin
        edDisplayIntensityRange.LoValue := edDisplayIntensityRange.LoValue - 1.0 ;
        edDisplayIntensityRange.HiValue := edDisplayIntensityRange.HiValue + 1.0 ;
        end ;

     GreyLo[ImagePage.ActivePageIndex] := Round(edDisplayIntensityRange.LoValue) ;
     GreyHi[ImagePage.ActivePageIndex] := Round(edDisplayIntensityRange.HiValue) ;

     SetDisplayIntensityRange( GreyLo[ImagePage.ActivePageIndex],
                               GreyHi[ImagePage.ActivePageIndex] ) ;
     UpdateLUT( ImagePage.ActivePageIndex, ADCMaxValue ) ;
     UpdateDisplay := True ;

     end;


procedure TMainFrm.scZSectionChange(Sender: TObject);
// ---------------
// Z Section changed
// ---------------
begin

     ZSection := scZSection.Position ;
     if not bStopScan.Enabled then
        begin
        LoadRawImage( RawImagesFileName, ZSection ) ;
        UpdateDisplay := True ;
        end;
     end;



procedure TMainFrm.SaveRawImage(
          FileName : String ;    // File to save to
          iSection : Integer     // Image Section number
          ) ;
// ----------------------
// Save raw image to file
// ----------------------
var
    FileHandle : THandle ;
    FilePointer,DataPointer,NumBytesPerImage : Int64 ;
    i,ch,NumPixels : Integer ;
    Buf16 : PBig16bitArray ;
begin

      // Copy into I/O buf
      NumPixels := FrameWidth*FrameHeight ;
      NumBytesPerImage := NumPixels*2 ;
      Buf16 := AllocMem( NumBytesPerImage ) ;


      if not FileExists(FileName) then FileHandle := FileCreate( FileName )
                                  else FileHandle := FileOpen( FileName, fmOpenWrite ) ;

      NumZSectionsAvailable := Max(NumZSectionsAvailable,iSection+1) ;
      scZSection.Max := NumZSectionsAvailable -1 ;
      scZSection.Position := iSection ;
      lbZSection.Caption := Format('Section %d/%d',[iSection+1,NumZSectionsAvailable]);

      FilePointer := FileSeek( FileHandle, 0, 0 ) ;
      FileWrite( FileHandle, NumZSectionsAvailable, Sizeof(NumZSectionsAvailable)) ;
      FileWrite( FileHandle, NumPMTChannels, SizeOf(NumPMTChannels)) ;
      FileWrite( FileHandle, FrameWidth, Sizeof(FrameWidth)) ;
      FileWrite( FileHandle, FrameHeight, Sizeof(FrameHeight)) ;
      FileWrite( FileHandle, iScanZoom, Sizeof(iScanZoom)) ;
      FileWrite( FileHandle, ScanArea, Sizeof(ScanArea)) ;
      FileWrite( FileHandle, ZStep, Sizeof(ZStep)) ;
      DataPointer := FileSeek( FileHandle, 0, 1 ) ;

      for ch := 0 to NumPMTChannels-1 do
          begin
          FilePointer := DataPointer +
                         Int64(iSection*NumPMTChannels + ch)*NumBytesPerImage ;
          FileSeek( FileHandle, FilePointer, 0 ) ;
          for i := 0 to NumPixels-1 do Buf16^[i] := Max(PImageBuf[ch]^[i],0) ;
          FileWrite( FileHandle, Buf16^, NumBytesPerImage) ;
          end;
      FileClose(FileHandle) ;
      FreeMem(Buf16) ;

      end;


procedure TMainFrm.LoadRawImage(
          FileName : String ;    // File to save to
          iSection : Integer     // Image Section number
          ) ;
// ----------------------
// Load raw image to file
// ----------------------
var
    FileHandle : THandle ;
    FilePointer,DataPointer,NumBytesPerImage : Int64 ;
    i,ch,NumPixels : Integer ;
    Buf16 : PBig16bitArray ;
begin

      FileHandle := FileOpen( FileName, fmOpenRead ) ;

      FilePointer := FileSeek( FileHandle, 0, 0 ) ;
      FileRead( FileHandle, NumZSections, Sizeof(NumZSections)) ;
      FileRead( FileHandle, NumPMTChannels, SizeOf(NumPMTChannels)) ;
      FileRead( FileHandle, FrameWidth, Sizeof(FrameWidth)) ;
      FileRead( FileHandle, FrameHeight, Sizeof(FrameHeight)) ;
      FileRead( FileHandle, iScanZoom, Sizeof(iScanZoom)) ;
      FileRead( FileHandle, ScanArea, Sizeof(ScanArea)) ;
      FileRead( FileHandle, ZStep, Sizeof(ZStep)) ;
      DataPointer := FileSeek( FileHandle, 0, 1 ) ;

      NumPixels := FrameWidth*FrameHeight ;
      NumBytesPerImage := NumPixels*2 ;
      Buf16 := AllocMem( NumBytesPerImage ) ;

      // (re)allocate full field buffer
      for ch := 0 to NumPMTChannels-1 do
          begin
          if PImageBuf[ch] <> Nil then FreeMem(PImageBuf[ch]);
          PImageBuf[ch] := AllocMem( NumPixels*SizeOf(Integer) ) ;
          end;

      for ch := 0 to NumPMTChannels-1 do
          begin
          FilePointer := DataPointer +
                         Int64(iSection*NumPMTChannels + ch)*NumBytesPerImage ;
          FileSeek( FileHandle, FilePointer, 0 ) ;
          FileRead( FileHandle, Buf16^, NumBytesPerImage) ;
          for i := 0 to NumPixels-1 do PImageBuf[ch]^[i] := Buf16^[i] ;
          end;

      FileClose(FileHandle) ;
      FreeMem(Buf16) ;

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
   i : Integer ;
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
    AddElementDouble( ProtNode, 'HRPIXELSIZE', HRPixelSize ) ;

    AddElementInt( ProtNode, 'LINESCANFRAMEHEIGHT', Round(edLineScanFrameHeight.Value) ) ;

    AddElementInt( ProtNode, 'PALETTE', cbPalette.ItemIndex ) ;

    AddElementBool( ProtNode, 'INVERTPMTSIGNAL', InvertPMTSignal ) ;

    AddElementInt( ProtNode, 'NUMAVERAGES', NumAverages ) ;
    AddElementDouble( ProtNode, 'MINCYCLEPERIOD', MinCyclePeriod ) ;
    AddElementDouble( ProtNode, 'MINPIXELDWELLTIME', MinPixelDwellTime ) ;
    AddElementInt( ProtNode, 'NUMAVERAGES', NumAverages ) ;
    AddElementInt( ProtNode, 'BLACKLEVEL', BlackLevel ) ;

    AddElementDouble( ProtNode, 'XVOLTSPERMICRON', XVoltsPerMicron ) ;
    AddElementDouble( ProtNode, 'YVOLTSPERMICRON', YVoltsPerMicron ) ;

    AddElementInt( ProtNode, 'XGALVOCONTROL', XGalvoControl ) ;
    AddElementInt( ProtNode, 'YGALVOCONTROL', YGalvoControl ) ;

    AddElementDouble( ProtNode, 'PHASESHIFT', PhaseShift ) ;
    AddElementDouble( ProtNode, 'FULLFIELDWIDTHMICRONS', FullFieldWidthMicrons ) ;

    // Z stack
    iNode := ProtNode.AddChild( 'ZSTACK' ) ;
    AddElementInt( iNode, 'NUMZSECTIONS', Round(edNUMZSections.Value) ) ;
    AddElementDouble( iNode, 'NUMPIXELSPERZSTEP', edNumPixelsPerZStep.Value ) ;

    // Laser control
    iNode := ProtNode.AddChild( 'LASER' ) ;
    AddElementInt( iNode, 'NUMLASERS', Laser.NumLasers ) ;
    AddElementInt( iNode, 'COMPORT', Laser.ControlPort ) ;
    AddElementInt( iNode, 'LASERTYPE', Laser.LaserType ) ;
//    AddElementInt( iNode, 'SHUTTERCONTROLLINE', Laser.ShutterControlLine ) ;
//    AddElementDouble( iNode, 'SHUTTERCHANGETIME', Laser.ShutterChangeTime ) ;
    for i := 1 to MaxLaser do
        begin
        AddElementText( iNode, format('NAME%d',[i]), Laser.LaserName[i] ) ;
        AddElementInt( iNode, format('ENABLEDCONTROLPORT%d',[i]), Laser.EnabledControlPort[i] ) ;
        AddElementInt( iNode, format('INTENSITYCONTROLPORT%d',[i]), Laser.IntensityControlPort[i] ) ;
        AddElementDouble( iNode, format('VMAXINTENSITY%d',[i]), Laser.VMaxIntensity[i] ) ;
        AddElementDouble( iNode, format('INTENSITY%d',[i]), Laser.Intensity[i] ) ;
        end;

    // PMT settings

    iNode := ProtNode.AddChild( 'PMT' ) ;
    AddElementInt( iNode, 'NUMPMTS', PMT.NumPMTs ) ;
    AddElementDouble( iNode, 'PMTGAINVMIN', PMT.GainVMin ) ;
    AddElementDouble( iNode, 'PMTGAINVMAX', PMT.GainVMax ) ;
    AddElementInt( iNode, 'INTEGRATORTYPE', PMT.IntegratorType ) ;
    AddElementInt( iNode, 'CONTROLPORT', PMT.ControlPort ) ;

    for i := 0 to MaxPMT do
        begin
        AddElementBool( iNode, format('ENABLED%d',[i]), PMT.PMTEnabled[i] ) ;
        AddElementDouble( iNode, format('GAIN%d',[i]), PMT.PMTGain[i] ) ;
        AddElementText( iNode, format('NAME%d',[i]), PMT.PMTName[i] ) ;
        AddElementInt( iNode, format('PORT%d',[i]), PMT.PMTPort[i] ) ;
        AddElementInt( iNode, format('ADCGAININDEX%d',[i]), PMT.ADCGainIndex[i] ) ;
        AddElementInt( iNode, format('LASERNUM%d',[i]), PMT.LaserNum[i] ) ;
        end;

    // Z stage
    iNode := ProtNode.AddChild( 'ZSTAGE' ) ;
    AddElementInt( iNode, 'STAGETYPE', ZStage.StageType ) ;
    AddElementInt( iNode, 'CONTROLPORT', ZStage.ControlPort ) ;
    AddElementDouble( iNode, 'ZSCALEFACTOR', ZStage.ZScaleFactor ) ;
    AddElementDouble( iNode, 'ZSTEPTIME', ZStage.ZStepTime ) ;
    AddElementDouble( iNode, 'ZPOSITIONMAX', ZStage.ZPositionMax ) ;
    AddElementDouble( iNode, 'ZPOSITIONMIN', ZStage.ZPositionMin ) ;

    AddElementText( ProtNode, 'SAVEDIRECTORY', SaveDirectory ) ;

    AddElementText( ProtNode, 'IMAGEJPATH', ImageJPath ) ;
    AddElementBool( ProtNode, 'SAVEASMULTIPAGETIFF', SaveAsMultipageTIFF ) ;
    AddElementText( ProtNode, 'RAWIMAGESFILENAME', RawImagesFileName ) ;

     s := TStringList.Create;
     s.Assign(xmlDoc.XML) ;
     //sl.Insert(0,'<!DOCTYPE ns:mys SYSTEM "myXML.dtd">') ;
     s.Insert(0,'<?xml version="1.0"?>') ;
     s.SaveToFile( FileName ) ;
     s.Free ;
     XMLDoc.Active := False ;
     XMLDoc := Nil ;

    end ;


procedure TMainFrm.SavetoImageJ1Click(Sender: TObject);
// ------------------------------------------------
// Save current image to file and open with Image-J
// ------------------------------------------------
begin
    SaveImage(True);
end;

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
   ch,NodeIndex : Integer ;
   XMLDoc : IXMLDocument ;
  i: Integer;
begin

    if not FileExists(FileName) then Exit ;

    XMLDoc := TXMLDocument.Create(Self) ;

    XMLDOC.Active := False ;

    XMLDOC.LoadFromFile( FileName ) ;
    XMLDoc.Active := True ;

    ProtNode := xmldoc.DocumentElement ;

    FastFrameWidth := GetElementInt( ProtNode, 'FASTFRAMEWIDTH', FastFrameWidth ) ;
    FastFrameWidth := Min(Max(FastFrameWidth,MinFrameWidth),MaxFrameWidth) ;

    FastFrameHeight := GetElementInt( ProtNode, 'FASTFRAMEHEIGHT', FastFrameHeight ) ;
    FastFrameHeight := Min(Max(FastFrameHeight,MinFrameHeight),MaxFrameHeight) ;

    HRPixelSize := GetElementDouble( ProtNode, 'HRPIXELSIZE', HRPixelSize ) ;

    edLineScanFrameHeight.Value := GetElementInt( ProtNode, 'LINESCANFRAMEHEIGHT',
                                                  Round(edLineScanFrameHeight.Value) ) ;

    cbPalette.ItemIndex := GetElementInt( ProtNode, 'PALETTE', cbPalette.ItemIndex ) ;
    PaletteType := TPaletteType(cbPalette.Items.Objects[cbPalette.ItemIndex]) ;
    for ch := 0 to NumPMTChannels-1 do
        if BitMap[ch] <> Nil then SetPalette( BitMap[ch], PaletteType ) ;

    InvertPMTSignal := GetElementBool( ProtNode, 'INVERTPMTSIGNAL', InvertPMTSignal ) ;

    NumAverages := GetElementInt( ProtNode, 'NUMAVERAGES', NumAverages ) ;
    MinCyclePeriod := GetElementDouble( ProtNode, 'MINCYCLEPERIOD', MinCyclePeriod ) ;
    MinPixelDwellTime := GetElementDouble( ProtNode, 'MINPIXELDWELLTIME', MinPixelDwellTime ) ;
    NumAverages := GetElementInt( ProtNode, 'NUMAVERAGES', NumAverages ) ;
    BlackLevel := GetElementInt( ProtNode, 'BLACKLEVEL', BlackLevel ) ;

    XVoltsPerMicron := GetElementDouble( ProtNode, 'XVOLTSPERMICRON', XVoltsPerMicron ) ;
    YVoltsPerMicron := GetElementDouble( ProtNode, 'YVOLTSPERMICRON', YVoltsPerMicron ) ;

    XGalvoControl := GetElementInt( ProtNode, 'XGALVOCONTROL', XGalvoControl ) ;
    YGalvoControl := GetElementInt( ProtNode, 'YGALVOCONTROL', YGalvoControl ) ;

    PhaseShift := GetElementDouble( ProtNode, 'PHASESHIFT', PhaseShift ) ;
    FullFieldWidthMicrons := GetElementDouble( ProtNode, 'FULLFIELDWIDTHMICRONS', FullFieldWidthMicrons ) ;

    // Z stage
    NodeIndex := 0 ;
    While FindXMLNode(ProtNode,'ZSTACK',iNode,NodeIndex) do
       begin
       edNUMZSections.Value := GetElementInt( iNode, 'NUMZSECTIONS', Round(edNUMZSections.Value) ) ;
       edNumPixelsPerZStep.Value := GetElementDouble( iNode, 'NUMPIXELSPERZSTEP', edNumPixelsPerZStep.Value ) ;
       Inc(NodeIndex) ;
       end ;

    // PMT settings

    NodeIndex := 0 ;
    While FindXMLNode(ProtNode,'PMT',iNode,NodeIndex) do
          begin
          PMT.NumPMTs := GetElementInt( iNode, 'NUMPMTS', PMT.NumPMTs ) ;
          PMT.GainVMin := GetElementDouble( iNode, 'PMTGAINVMIN', PMT.GainVMin ) ;
          PMT.GainVMax := GetElementDouble( iNode, 'PMTGAINVMAX', PMT.GainVMax ) ;
          PMT.IntegratorType := GetElementInt( iNode, 'INTEGRATORTYPE', PMT.IntegratorType ) ;
          PMT.ControlPort := GetElementInt( iNode, 'CONTROLPORT', PMT.ControlPort ) ;
          for i := 0 to MaxPMT do
              begin
              PMT.PMTEnabled[i] := GetElementBool( iNode, format('ENABLED%d',[i]), PMT.PMTEnabled[i] ) ;
              PMT.PMTGain[i] := GetElementDouble( iNode, format('GAIN%d',[i]), PMT.PMTGain[i] ) ;
              PMT.PMTName[i] := GetElementText( iNode, format('NAME%d',[i]), PMT.PMTName[i] ) ;
              PMT.PMTPort[i] := GetElementInt( iNode, format('PORT%d',[i]), PMT.PMTPort[i] ) ;
              PMT.ADCGainIndex[i] := GetElementInt( iNode, format('ADCGAININDEX%d',[i]), PMT.ADCGainIndex[i] ) ;
              PMT.LaserNum[i] := GetElementInt( iNode, format('LASERNUM%d',[i]), PMT.LaserNum[i] ) ;
              end;
          Inc(NodeIndex) ;
          end ;

    // Laser control settings

    NodeIndex := 0 ;
    While FindXMLNode(ProtNode,'LASER',iNode,NodeIndex) do
        begin
        Laser.NumLasers := GetElementInt( iNode, 'NUMLASERS', Laser.NumLasers ) ;
        Laser.LaserType := GetElementInt( iNode, 'LASERTYPE', Laser.LaserType ) ;
        Laser.ControlPort := GetElementInt( iNode, 'COMPORT', Laser.ControlPort ) ;

//    AddElementInt( iNode, 'SHUTTERCONTROLLINE', Laser.ShutterControlLine ) ;
//    AddElementDouble( iNode, 'SHUTTERCHANGETIME', Laser.ShutterChangeTime ) ;
        for i := 1 to MaxLaser do
            begin
            Laser.LaserName[i] := GetElementText( iNode, format('NAME%d',[i]), Laser.LaserName[i] ) ;
            Laser.EnabledControlPort[i]:= GetElementInt( iNode, format('ENABLEDCONTROLPORT%d',[i]), Laser.EnabledControlPort[i] ) ;
            Laser.IntensityControlPort[i]:= GetElementInt( iNode, format('INTENSITYCONTROLPORT%d',[i]), Laser.IntensityControlPort[i] ) ;
            Laser.VMaxIntensity[i]:= GetElementDouble( iNode, format('VMAXINTENSITY%d',[i]), Laser.VMaxIntensity[i] ) ;
            Laser.Intensity[i] := GetElementDouble( iNode, format('INTENSITY%d',[i]), Laser.Intensity[i] ) ;
            end;
        Inc(NodeIndex) ;
        end ;

    // Z stage
    NodeIndex := 0 ;
    While FindXMLNode(ProtNode,'ZSTAGE',iNode,NodeIndex) do
      begin
      ZStage.StageType := GetElementInt( iNode, 'STAGETYPE', ZStage.StageType ) ;
      ZStage.ControlPort := GetElementInt( iNode, 'CONTROLPORT', ZStage.ControlPort ) ;
      ZStage.ZScaleFactor := GetElementDouble( iNode, 'ZSCALEFACTOR', ZStage.ZScaleFactor ) ;
      ZStage.ZStepTime := GetElementDouble( iNode, 'ZSTEPTIME', ZStage.ZStepTime ) ;
      ZStage.ZPositionMax := GetElementDouble( iNode, 'ZPOSITIONMAX', ZStage.ZPositionMax ) ;
      ZStage.ZPositionMin := GetElementDouble( iNode, 'ZPOSITIONMIN', ZStage.ZPositionMin ) ;
      Inc(NodeIndex) ;
      end ;

    edGotoZPosition.HiLimit := ZStage.ZPositionMax ;
    edGotoZPosition.LoLimit := ZStage.ZPositionMin ;

    SaveDirectory := GetElementText( ProtNode, 'SAVEDIRECTORY', SaveDirectory ) ;
    ImageJPath := GetElementText( ProtNode, 'IMAGEJPATH', ImageJPath ) ;
    SaveAsMultipageTIFF := GetElementBool( ProtNode, 'SAVEASMULTIPAGETIFF', SaveAsMultipageTIFF ) ;
    RawImagesFileName := GetElementText( ProtNode, 'RAWIMAGESFILENAME', RawImagesFileName ) ;

    XMLDoc.Active := False ;
    XMLDoc := Nil ;

    end ;


procedure TMainFrm.UpdatePMTSettings ;
// ---------------------------
// Enable/disable PMT controls
// ---------------------------
var
  ch,NumEnabled,i : Integer ;
begin

  // Read PMT controls
  ReadWritePMTGroup( 0, gpPMT0, 'R' ) ;
  ReadWritePMTGroup( 1, gpPMT1, 'R' ) ;
  ReadWritePMTGroup( 2, gpPMT2, 'R' ) ;
  ReadWritePMTGroup( 3, gpPMT3, 'R' ) ;

  // Ensure at least one PMT is selected
  NumEnabled := 0 ;
  for i := 0 to PMT.NumPMTs-1 do if PMT.PMTEnabled[i] then Inc(NumEnabled) ;
  if NumEnabled = 0 then
     begin
     PMT.PMTEnabled[0] := True ;
     ReadWRitePMTGroup( 0, gpPMT0, 'W' ) ;
     end;

  cbPMTGain0.Enabled := ckEnablePMT0.Checked ;

  NumPMTChannels := 0 ;
  for ch := 0 to High(ImageNames) do ImageNames[ch] := '' ;
  for i := 0 to PMT.NumPMTs-1 do if PMT.PMTEnabled[i] then
      Begin
      ImageNames[NumPMTChannels] := PMT.PMTName[i] ;
      Inc(NumPMTChannels) ;
      end ;

   TabImage0.Caption := ImageNames[0] ;
   TabImage1.Caption := ImageNames[1] ;
   TabImage2.Caption := ImageNames[2] ;
   TabImage3.Caption := ImageNames[3] ;

   if TabImage0.Caption <> '' then
      begin
      TabImage0.TabVisible := True ;
      TabImage0.Visible := True ;
      TabImage0.Enabled := True ;
      end
   else
      begin
      TabImage0.TabVisible := false ;
      TabImage0.Visible := False ;
      TabImage0.Enabled := False ;
      end;

   if TabImage1.Caption <> '' then
      begin
      TabImage1.TabVisible := True ;
      TabImage1.Visible := True ;
      TabImage1.Enabled := True ;
      end
   else
      begin
      TabImage1.TabVisible := false ;
      TabImage1.Visible := False ;
      TabImage1.Enabled := False ;
      end;

   if TabImage2.Caption <> '' then
      begin
      TabImage2.TabVisible := True ;
      TabImage2.Visible := True ;
      TabImage2.Enabled := True ;
      end
   else
      begin
      TabImage2.TabVisible := false ;
      TabImage2.Visible := False ;
      TabImage2.Enabled := False ;
      end;

   if TabImage3.Caption <> '' then
      begin
      TabImage3.TabVisible := True ;
      TabImage3.Visible := True ;
      TabImage3.Enabled := True ;
      end
   else
      begin
      TabImage3.TabVisible := false ;
      TabImage3.Visible := False ;
      TabImage3.Enabled := False ;
      end;

  // If page not visible, set to first page
  if not ImagePage.ActivePage.Visible then ImagePage.ActivePage := TabImage0 ;

  end;

procedure TMainFrm.edPMTLaserIntensity0KeyPress(Sender: TObject; var Key: Char);
// --------------------------------
// Laser intensity edit box changed
// --------------------------------
begin
    if not FormInitialized then Exit ;
    if Key = #13 then
       begin
       // Read PMT controls, updating laser intensity trackbar with edit box value
       ReadWritePMTGroup( 0, gpPMT0, 'RE' ) ;
       ReadWritePMTGroup( 1, gpPMT1,'RE' ) ;
       ReadWritePMTGroup( 2, gpPMT2,'RE' ) ;
       ReadWritePMTGroup( 3, gpPMT3,'RE' ) ;
       if Laser.Active then Laser.Active := True ;
       end;

    end;


procedure TMainFrm.ReadWritePMTGroup(
          Num : Integer ;
          Group : TGroupBox ;
          RW : string ) ;
// -----------------------
// Read/write PMT controls
// -----------------------
var
    i : Integer ;
    ckEnabled : TCheckBox ;
    cbGain : TComboBox ;
    cbLaser : TComboBox ;
    tbLaserIntensity : TTrackBar ;
    edLaserIntensity : TValidatedEdit ;
    tbPMTGain : TTrackBar ;
    edPMTGain : TValidatedEdit ;
begin

      // Display Group if PMT exists
      if Num < PMT.NumPMTs then Group.Visible := True
                           else Group.Visible := False ;

      for i := 0 to Group.ControlCount-1 do
          begin
          case Group.Controls[i].Tag of
              0 : ckEnabled:= TCheckBox(Group.Controls[i]) ;
              1 : cbGain := TComboBox(Group.Controls[i]) ;
              2 : cbLaser := TComboBox(Group.Controls[i]) ;
              3 : tbPMTGain := TTrackBar(Group.Controls[i]) ;
              4 : edPMTGain := TValidatedEdit(Group.Controls[i]) ;
              5 : tbLaserIntensity := TTrackBar(Group.Controls[i]) ;
              6 : edLaserIntensity := TValidatedEdit(Group.Controls[i]) ;
              end ;
          end ;

      if ANSIContainsText( RW, 'W') then
         begin
         // Write Group
         ckEnabled.Caption := PMT.PMTName[Num] ;
         ckEnabled.Checked := PMT.PMTEnabled[Num] ;
         PMT.GetADCGainList( cbGain.Items ) ;
         cbGain.ItemIndex := PMT.ADCGainIndex[Num] ;
         Laser.GetLaserList( cbLaser.Items ) ;
         cbLaser.ItemIndex := Max(PMT.LaserNum[Num],0) ;
         tbPMTGain.Position := Round(PMT.PMTGain[Num]*tbPMTGain.Max);
         edPMTGain.Value :=  PMT.PMTGain[Num] ;
         tbLaserIntensity.Position := Round(Laser.Intensity[PMT.LaserNum[Num]]*tbLaserIntensity.Max);
         edLaserIntensity.Value :=  Laser.Intensity[PMT.LaserNum[Num]] ;
         end
      else begin
         // Read Group
         PMT.PMTEnabled[Num] := ckEnabled.Checked ;
         PMT.ADCGainIndex[Num] := cbGain.ItemIndex ;
         PMT.LaserNum[Num] := cbLaser.ItemIndex ;
         Laser.LaserEnabled[PMT.LaserNum[Num]] := PMT.PMTEnabled[Num] ;
         if ANSIContainsText( RW, 'RT') then
            begin
            // Read intensity track bars
            Laser.Intensity[PMT.LaserNum[Num]] := tbLaserIntensity.Position / tbLaserIntensity.Max ;
            edLaserIntensity.Value :=  Laser.Intensity[PMT.LaserNum[Num]] ;
            PMT.PMTGain[Num] := tbPMTGain.Position / tbPMTGain.Max ;
            edPMTGain.Value := PMT.PMTGain[Num] ;
            end
         else
            begin
            // Read intensity edit boxes
            Laser.Intensity[PMT.LaserNum[Num]] := edLaserIntensity.Value ;
            tbLaserIntensity.Position := Round(Laser.Intensity[PMT.LaserNum[Num]]*tbLaserIntensity.Max);
            PMT.PMTGain[Num] := edPMTGain.Value ;
            tbPMTGain.Position := Round(PMT.PMTGain[Num]*tbPMTGain.Max);
            end;
         end ;

      end;




procedure TMainFrm.FormDestroy(Sender: TObject);
// ------------------------------
// Tidy up when form is destroyed
// ------------------------------
var
    ch : Integer ;
begin
     for ch := 0 to High(BitMap) do If BitMap[ch] <> Nil then
         begin
         BitMap[ch].ReleasePalette ;
         BitMap[ch].Free ;
         BitMap[ch] := Nil ;
         end;
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
         Value : Double
          ) : Double ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   OldValue : Single ;
   NodeIndex : Integer ;
   s : string ;
begin
    Result := Value ;
    OldValue := Value ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then
       begin
       { Correct for use of comma/period as decimal separator }
       s := ChildNode.Text ;
       if (FormatSettings.DECIMALSEPARATOR = '.') then s := ANSIReplaceText(s , ',',FormatSettings.DECIMALSEPARATOR);
       if (FormatSettings.DECIMALSEPARATOR = ',') then s := ANSIReplaceText( s, '.',FormatSettings.DECIMALSEPARATOR);
       try
          Result := StrToFloat(s) ;
       except
          Result := OldValue ;
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
          Value : Integer
          ) : Integer ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   NodeIndex : Integer ;
   OldValue : Integer ;
begin
    Result := Value ;
    OldValue := Value ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then
       begin
       try
          Result := StrToInt(ChildNode.Text) ;
       except
          Result := OldValue ;
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
          Value : Boolean
          ) : Boolean ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   NodeIndex : Integer ;
begin
    Result := Value ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then
       begin
       if ANSIContainsText(ChildNode.Text,'T') then Value := True
                                               else Value := False ;
       Result := Value ;
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
          Value : String
          ) : string ;
// ---------------------
// Get value of element
// ---------------------
var
   ChildNode : IXMLNode;
   NodeIndex : Integer ;
begin

    Result := Value ;
    NodeIndex := 0 ;
    if FindXMLNode(ParentNode,NodeName,ChildNode,NodeIndex) then
       begin
       Result := ChildNode.Text ;
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
    for i := NodeIndex to ParentNode.ChildNodes.Count-1 do
      begin
      if ParentNode.ChildNodes[i].NodeName = WideString(NodeName) then
         begin
         Result := True ;
         ChildNode := ParentNode.ChildNodes[i] ;
         NodeIndex := i ;
         Break ;
         end ;
      end ;
    end ;

function TMainFrm.GetSpecialFolder(const ASpecialFolderID: Integer): string;
// --------------------------
// Get Windows special folder
// --------------------------
var
  vSpecialPath : array[0..MAX_PATH] of Char;
begin

    SHGetFolderPath( 0, ASpecialFolderID, 0,0,vSpecialPath) ;
    Result := StrPas(vSpecialPath);

    end;


end.

