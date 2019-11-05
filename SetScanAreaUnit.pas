unit SetScanAreaUnit;
// ---------------------------------------
// Enter coordinates of CCD readout region
// ---------------------------------------
// 20.02.07 Limits of range now set correctly
// 22.05.13 Cancel now closes form rather than hides (avoiding form error)
// 16.09.15 .. JD Form position/size saved by MainFrm.SaveFormPosition() when form closed

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RangeEdit;

type
  TSetScanAreaFrm = class(TForm)
    AreaGrp: TGroupBox;
    edXRange: TRangeEdit;
    Label1: TLabel;
    Label2: TLabel;
    edYRange: TRangeEdit;
    bOK: TButton;
    bCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    RestartScan : Boolean ;
  end;

var
  SetScanAreaFrm: TSetScanAreaFrm;

implementation

{$R *.dfm}

uses MainUnit;

procedure TSetScanAreaFrm.FormShow(Sender: TObject);
// --------------------------------------
// Initialisations when form is displayed
// --------------------------------------
begin

     edXRange.LoValue := MainFrm.ScanArea.Left ;
     edXRange.HiValue := MainFrm.ScanArea.Right ;
     edYRange.LoValue := MainFrm.ScanArea.Top ;
     edYRange.HiValue := MainFrm.ScanArea.Bottom ;

     ClientWidth := AreaGrp.Left + AreaGrp.Width + 5 ;
     ClientHeight := bOK.Top + bOK.Height + 5 ;

     end;

procedure TSetScanAreaFrm.bOKClick(Sender: TObject);
// -----------------
// OK button pressed
// -----------------
begin

    MainFrm.ScanArea.Left := edXRange.LoValue ;
    MainFrm.ScanArea.Right := edXRange.HiValue ;
    MainFrm.ScanArea.Top := edYRange.LoValue ;
    MainFrm.ScanArea.Bottom := edYRange.HiValue ;

    if RestartScan then MainFrm.StartNewScan( srNoChange, true ) ;

    close ;

    end;

procedure TSetScanAreaFrm.bCancelClick(Sender: TObject);
// ---------------------
// Cancel button pressed
// ---------------------
begin
     Close ;
     end;

procedure TSetScanAreaFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
// ---------------------------
// Tidy up when form is closed
// ---------------------------
begin
//     Action := caFree ;
     end;

end.
