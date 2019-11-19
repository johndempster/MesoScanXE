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


     ClientWidth := AreaGrp.Left + AreaGrp.Width + 5 ;
     ClientHeight := bOK.Top + bOK.Height + 5 ;

     end;

procedure TSetScanAreaFrm.bOKClick(Sender: TObject);
// -----------------
// OK button pressed
// -----------------
begin


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
