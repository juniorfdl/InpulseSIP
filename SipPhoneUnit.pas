unit SipPhoneUnit;

interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, OleCtrls, ShellAPI,
  StdCtrls, ComCtrls, jpeg, Menus, ExtCtrls, ComObj, AxCtrls, ActiveX, Generics.Collections,
    //TransferFormUnit,  JoinFormUnit, ActivationFormUnit, SendTextFormUnit,
  SIPVoipSDK_TLB, System.Json;

const
  LineCount: Integer = 6;

type
  PLineInfo = ^TLineInfo;
  TLineInfo = record
    Connections: TDictionary < integer, string > ;
    Id: Integer;
    IsCallEstablished: Boolean;
    IsCallHeld: Boolean;
    IsCallPlayStarted: Boolean;
    IsCallRecordStarted: Boolean;
    IsCalling: Boolean;
    UserInputString: string;
  end;

type
  TSipPhoneForm = class(TForm)
    AddressLbl: TLabel;
    CallPanel: TPanel;
    UsrInpurLbl: TLabel;
    DialNumberPnl: TGroupBox;
    DTFM1: TButton;
    DTFM2: TButton;
    DTFM5: TButton;
    DTFM3: TButton;
    DTFM4: TButton;
    DTFM6: TButton;
    DTFM7: TButton;
    DTFM8: TButton;
    DTFM9: TButton;
    DTFMHash: TButton;
    DTFM0: TButton;
    DTFMStar: TButton;
    SoundLevelBar: TProgressBar;
    SoundVolumeBar: TTrackBar;
    RecordLevelBar: TProgressBar;
    RecordVolumeBar: TTrackBar;
    SpeakerVolumeBox: TCheckBox;
    MicrophoneVolumeBox: TCheckBox;
    SIPSmallBanner: TImage;
    DownloadSdkLabel: TLabel;
    PlayButton: TButton;
    RecButton: TButton;
    LineButtonsGroupBox: TGroupBox;
    Line1Button: TButton;
    Line2Button: TButton;
    Line3Button: TButton;
    Line4Button: TButton;
    Line5Button: TButton;
    Line6Button: TButton;
    ConnectionsListBox: TListBox;
    StatusLogListBox: TListBox;
    MainMenu1: TMainMenu;
    SettingsMenu: TMenuItem;
    AboutMenu: TMenuItem;
    AddressComboBox: TComboBox;
    TransferButton: TButton;
    JoinButton: TButton;
    HoldButton: TButton;
    OpenDialog: TOpenDialog;
    UserInputLabel: TLabel;
    SaveDialog: TSaveDialog;
    StartCallBtn: TButton;
    Image2: TImage;
    Image3: TImage;
    buttonExpand: TButton;
    pictureReceivedVideo: TPanel;
    pictureLocalVideo: TPanel;
    SendTextButton: TButton;

    procedure FormCreate(Sender: TObject);
    procedure StartCallBtnClick(Sender: TObject);
    procedure SoundVolumeBarChange(Sender: TObject);
    procedure RecordVolumeBarChange(Sender: TObject);
    procedure RegisterBtnClick(Sender: TObject);
    procedure SpeakerVolumeBoxClick(Sender: TObject);

    procedure MicrophoneVolumeBoxClick(Sender: TObject);
    procedure Line1ButtonClick(Sender: TObject);
    procedure Line2ButtonClick(Sender: TObject);
    procedure Line3ButtonClick(Sender: TObject);
    procedure Line4ButtonClick(Sender: TObject);
    procedure Line5ButtonClick(Sender: TObject);
    procedure Line6ButtonClick(Sender: TObject);
    procedure AboutMenuClick(Sender: TObject);
    procedure SettingsMenuClick(Sender: TObject);
    procedure ActivationMenuClick(Sender: TObject);
    procedure DTFM1Click(Sender: TObject);
    procedure DTFM2Click(Sender: TObject);
    procedure DTFM3Click(Sender: TObject);
    procedure DTFM4Click(Sender: TObject);
    procedure DTFM5Click(Sender: TObject);
    procedure DTFM6Click(Sender: TObject);
    procedure DTFM7Click(Sender: TObject);
    procedure DTFM8Click(Sender: TObject);
    procedure DTFM9Click(Sender: TObject);
    procedure DTFMStarClick(Sender: TObject);
    procedure DTFM0Click(Sender: TObject);
    procedure DTFMHashClick(Sender: TObject);
    procedure PlayButtonClick(Sender: TObject);

 { event handlers }
    procedure AbtoPhone_OnInitialized(ASender: TObject; const Msg: WideString);
    procedure AbtoPhone_OnLineSwitched(Sender: TObject; LineId: Integer);
    procedure AbtoPhone_OnEstablishedCall(ASender: TObject; const Msg: WideString; LineId: Integer);
    procedure AbtoPhone_OnIncomingCall(ASender: TObject; const AddrFrom: WideString; LineId: Integer);
    procedure AbtoPhone_OnClearedCall(ASender: TObject; const Msg: WideString; Status: Integer; LineId: Integer);
    procedure AbtoPhone_OnVolumeUpdated(Sender: TObject; IsMicrophone: Integer; Level: Integer);
    procedure AbtoPhone_OnRegistered(ASender: TObject; const Msg: WideString);
    procedure AbtoPhone_OnPlayFinished(ASender: TObject; const Msg: WideString);
    procedure AbtoPhone_OnEstablishedConnection(ASender: TObject; const AddrFrom: WideString;
      const AddrTo: WideString;
      ConnId: Integer;
      LineId: Integer);
    procedure AbtoPhone_OnClearedConnection(Sender: TObject; ConnId: Integer; LineId: Integer);
    procedure AbtoPhone_OnToneReceived(ASender: TObject; Tone: Integer; ConnId: Integer;
      LineId: Integer);
    procedure AbtoPhone_OnTextMessageReceived(ASender: TObject; const address: WideString;
      const message: WideString);
    procedure AbtoPhone_OnNotify(ASender: TObject; const Msg: WideString);
    procedure AbtoPhone_OnRemoteAlerting(ASender: TObject;
      ConnId: Integer; responseCode: Integer;
      const reasonMsg: WideString);
    procedure AbtoPhone_OnHoldCall(ASender: TObject; LineId: Integer; isHeld: Integer);

    procedure AbtoPhone_OnTextMessageSentStatus(ASender: TObject; const address: WideString;
      const reason: WideString; bSuccess: Integer);
 { form event handlers }
    procedure HoldButtonClick(Sender: TObject);
    procedure RecButtonClick(Sender: TObject);
    procedure TransferButtonClick(Sender: TObject);
    procedure JoinButtonClick(Sender: TObject);
    procedure buttonExpandClick(Sender: TObject);
    procedure SendTextButtonClick(Sender: TObject);

  private
 { Private declarations }

    configFileName, CaminhoSalvar: string;
    RegistrarAttemptNumber: Integer;

    LineButtons: array[1..6] of TButton;
 (*AudioPlaybackDevices, AudioRecordDevices: TStringList;*)
    AbtoPhone: TCAbtoPhone;
    LinesTbl: TList;
    CurrentLineId: Integer;
    isAutoAnswerEnabled: Boolean;
    ffTimeStatus, ffTimeStatusAnterior: TTime;
    ffStatus: WideString;
    function getStatus: WideString;
    procedure setStatus(const Value: WideString);
    property fStatus: WideString read getStatus write setStatus;
    procedure DisplayNotifyMessage(message: string);
    procedure DisplayConnection(connId: Integer; RemoteAddress: string);
    procedure DisplayConnectionsAll(lnInfo: PLineInfo);
    procedure RemoveConnection(connId: Integer);
    procedure DecorateLineButton(button: Integer);
    function GetCurrentLine: PLineInfo;
    function GetLine(lineId: Integer): PLineInfo;
    function GetSelectedConnection(var connId: Integer): Boolean;
    procedure ChangeControlsState(lnInfo: PLineInfo);
    procedure ChangeLineCaption(lnInfo: PLineInfo);
    function GetLineButton(lineId: Integer): TButton;
    procedure StopStartPlaying(isCalledByPlayFinishedEvent: Boolean; lineId: integer);
    procedure SetupLineButton(number: Integer);

  public

    class function Ligar(pParam: WideString): WideString;
    class function Inicializar(pConf: WideString): WideString;
    class function Finalizar(pConf: WideString): WideString;
    class function Desligar(pParam: WideString): WideString;
    class function Status(pParam: WideString): WideString;
    class function Transferir(pFone:WideString): WideString;
    class function AutoFalante(pParam: WideString): WideString;
    class function MicroFone(pParam: WideString): WideString;
    class function SetCaminhoSalvar(pParam: WideString): WideString;
  end;

var
  SipPhoneForm: TSipPhoneForm;

implementation

{uses AboutFormUnit, IncomingFormUnit;}

{$R *.dfm}
{$R WindowsXP.res}

/// Inicio funções external
///

class function TSipPhoneForm.SetCaminhoSalvar(pParam: WideString): WideString;
begin
  SipPhoneForm.CaminhoSalvar := pParam;
end;

class function TSipPhoneForm.AutoFalante(pParam:WideString): WideString;
var
  JSONValue: TJSONValue;
  vMudo:Boolean;
  vVolume:Integer;
begin
  result := '0';

  JSONValue := TJSONObject.ParseJSONValue(pParam);

  if JSONVAlue is TJSONObject then
  begin
    vMudo := JSONValue.GetValue<Boolean>('Mudo');
    vVolume := JSONValue.GetValue<Integer>('Volume');

    SipPhoneForm.AbtoPhone.PlaybackVolume := vVolume;

    if vMudo then
      SipPhoneForm.AbtoPhone.PlaybackMuted := 0
    else
      SipPhoneForm.AbtoPhone.PlaybackMuted := 1;
  end;

  result := '1';
end;

class function TSipPhoneForm.MicroFone(pParam:WideString): WideString;
var
  JSONValue: TJSONValue;
  vMudo:Boolean;
  vVolume:Integer;
begin
  result := '0';

  JSONValue := TJSONObject.ParseJSONValue(pParam);

  if JSONVAlue is TJSONObject then
  begin
    vMudo := JSONValue.GetValue<Boolean>('Mudo');
    vVolume := JSONValue.GetValue<Integer>('Volume');

    SipPhoneForm.AbtoPhone.RecordVolume := vVolume;

    if vMudo then
      SipPhoneForm.AbtoPhone.RecordMuted := 0
    else
      SipPhoneForm.AbtoPhone.RecordMuted := 1;
  end;

  result := '1';
end;

class function TSipPhoneForm.Transferir(pFone:WideString): WideString;
begin
  result := '0';
  SipPhoneForm.AbtoPhone.TransferCall(pFone);
  result := '1';
end;

class function TSipPhoneForm.Status(pParam: WideString): WideString;
begin
  if SipPhoneForm <> nil then
    Result := SipPhoneForm.fStatus
  else
    Result := '{"Evento": "OFFLine", "Msg":"Não Iniciado", "Time":"' + TimeToStr(Now) + '" }';
end;

class function TSipPhoneForm.Finalizar(pConf: WideString): WideString;
begin
  result := '0';
  if SipPhoneForm <> nil then
  begin
    FreeAndNil(SipPhoneForm);
    SipPhoneForm := nil;
  end;
  result := '1';
end;

class function TSipPhoneForm.Desligar(pParam: WideString): WideString;
var
  lnInfo: PLineInfo;
  connId: Integer;
begin
  result := '0';
  lnInfo := SipPhoneForm.GetCurrentLine;

  if lnInfo.IsCallEstablished or lnInfo.IsCalling then
  begin
    if SipPhoneForm.GetSelectedConnection(connId) then
      SipPhoneForm.AbtoPhone.HangUp(connId)
    else
      SipPhoneForm.AbtoPhone.HangUpLastCall;
  end;

  result := '1';
end;

class function TSipPhoneForm.Ligar(pParam: WideString): WideString;
var
  lnInfo: PLineInfo;
  idx:Integer;
  JSONValue: TJSONValue;
  pFone:String;
begin
  JSONValue := TJSONObject.ParseJSONValue(pParam);
  pFone  := JSONValue.GetValue<String>('Fone');

  result := '0';
  if pFone = '' then Exit;

  lnInfo := SipPhoneForm.GetCurrentLine;

  idx := SipPhoneForm.AddressComboBox.Items.IndexOf(pFone);
  if idx = -1 then
    SipPhoneForm.AddressComboBox.Items.Add(pFone);

  lnInfo.IsCalling := true;
  SipPhoneForm.AbtoPhone.StartCall(pFone);
  result := '1';
end;

class function TSipPhoneForm.Inicializar(pConf: WideString): WideString;
begin
  result := '0';
  if SipPhoneForm = nil then
    SipPhoneForm := TSipPhoneForm.Create(nil);
  result := '1';
end;
/// Fim funções external

procedure TSipPhoneForm.FormCreate(Sender: TObject);
var
  I: integer;
  lnInfo: PLineInfo;
  phoneCfg: Variant;
begin
  Self.CurrentLineId := 1;
  Self.LinesTbl := TList.Create;
  configFileName := ExtractFilePath(Application.ExeName) + 'phoneCfg.ini';

  AbtoPhone := SIPVoipSDK_TLB.TCAbtoPhone.Create(Self);

  phoneCfg := AbtoPhone.Config;

  if phoneCfg.Load(configFileName) = 0 then
  begin
    phoneCfg.ListenPort := 5060;
    phoneCfg.Store(configFileName);
  end;

    {Note: Uncomment following lines if needed}

    //Log level
    //phoneCfg.LogLevel := LogLevelType.eLogDebug;//eLogError

    //Set AdditionalDnsServer as google dns
    //phoneCfg.AdditionalDnsServer := '8.8.8.8';

    //Specify network interface
    //phoneCfg.ActiveNetworkDevice := '';

    //Specify Licensy key
    //phoneCfg.LicenseUserId := '...';
    //phoneCfg.LicenseKey    := '...';

     //Set video windows
  phoneCfg.RemoteVideoWindow := pictureReceivedVideo.Handle;
  phoneCfg.LocalVideoWindow := pictureLocalVideo.Handle;


  AbtoPhone.ApplyConfig; //Apply modified config

  DisplayNotifyMessage('Initializing...');
  try
    AbtoPhone.Initialize; //Initialize component
  except
  end;


  Self.AbtoPhone.OnInitialized := AbtoPhone_OnInitialized;
  Self.AbtoPhone.OnLineSwiched := AbtoPhone_OnLineSwitched;
  Self.AbtoPhone.OnEstablishedCall := AbtoPhone_OnEstablishedCall;
  Self.AbtoPhone.OnIncomingCall := AbtoPhone_OnIncomingCall;
  Self.AbtoPhone.OnClearedCall := AbtoPhone_OnClearedCall;
  Self.AbtoPhone.OnVolumeUpdated := AbtoPhone_OnVolumeUpdated;
  Self.AbtoPhone.OnRegistered := AbtoPhone_OnRegistered;
  Self.AbtoPhone.OnPlayFinished := AbtoPhone_OnPlayFinished;
  Self.AbtoPhone.OnEstablishedConnection := AbtoPhone_OnEstablishedConnection;
  Self.AbtoPhone.OnClearedConnection := AbtoPhone_OnClearedConnection;
  Self.AbtoPhone.OnPhoneNotify := AbtoPhone_OnNotify;
  Self.AbtoPhone.OnToneReceived := AbtoPhone_OnToneReceived;
  Self.AbtoPhone.OnTextMessageReceived := AbtoPhone_OnTextMessageReceived;
  Self.AbtoPhone.OnRemoteAlerting := AbtoPhone_OnRemoteAlerting;
  Self.AbtoPhone.OnHoldCall := AbtoPhone_OnHoldCall;
  Self.AbtoPhone.OnTextMessageSentStatus := AbtoPhone_OnTextMessageSentStatus;

  for I := 1 to LineCount do begin
    New(lnInfo);
    with lnInfo^ do begin
      Id := i;
      Connections := TDictionary < integer, string > .Create;
      IsCallEstablished := False;
      IsCallHeld := False;
      IsCallPlayStarted := False;
      IsCallRecordStarted := False;
      IsCalling := False;
      UserInputString := '';
    end;
    Self.LinesTbl.Add(lnInfo);
  end;


  StartCallBtn.Default := True;

  LineButtons[1] := Line1Button;
  LineButtons[2] := Line2Button;
  LineButtons[3] := Line3Button;
  LineButtons[4] := Line4Button;
  LineButtons[5] := Line5Button;
  LineButtons[6] := Line6Button;
  DecorateLineButton(1);

  isAutoAnswerEnabled := phoneCfg.AutoAnswerEnabled;

  SoundVolumeBar.Position := AbtoPhone.PlaybackVolume;
  RecordVolumeBar.Position := AbtoPhone.RecordVolume;

  buttonExpandClick(Self);
end;

procedure TSipPhoneForm.StartCallBtnClick(Sender: TObject);
var
  lnInfo: PLineInfo;
  connId: Integer;
  address: string;
  idx: Integer;
begin
  lnInfo := Self.GetCurrentLine;

  if lnInfo.IsCallEstablished or lnInfo.IsCalling then
  begin
    if GetSelectedConnection(connId) then
      AbtoPhone.HangUp(connId)
    else
      AbtoPhone.HangUpLastCall;
  end
  else
  begin
    address := AddressComboBox.Text;
    if address = '' then Exit;

      //Append addr to combo
    idx := Self.AddressComboBox.Items.IndexOf(address);
    if idx = -1 then Self.AddressComboBox.Items.Add(address);

      //Set status
    DisplayNotifyMessage('Calling ' + address + '...');

      //Set flag
    lnInfo.IsCalling := true;
    ChangeControlsState(lnInfo);

      //Start call
    AbtoPhone.StartCall(address);
  end;
end;

procedure TSipPhoneForm.SoundVolumeBarChange(Sender: TObject);
begin
  AbtoPhone.PlaybackVolume := SoundVolumeBar.Position
end;

procedure TSipPhoneForm.RecordVolumeBarChange(Sender: TObject);
begin
  AbtoPhone.RecordVolume := RecordVolumeBar.Position;
end;

procedure TSipPhoneForm.RegisterBtnClick(Sender: TObject);
begin
  RegistrarAttemptNumber := 1;
end;

procedure TSipPhoneForm.SpeakerVolumeBoxClick(Sender: TObject);
begin
  if SpeakerVolumeBox.Checked
    then AbtoPhone.PlaybackMuted := 0
  else AbtoPhone.PlaybackMuted := 1;
end;

procedure TSipPhoneForm.MicrophoneVolumeBoxClick(Sender: TObject);
begin
  if MicrophoneVolumeBox.Checked
    then AbtoPhone.RecordMuted := 0
  else AbtoPhone.RecordMuted := 1;
end;

procedure TSipPhoneForm.DecorateLineButton(button: Integer);
var
  i: integer;
begin
  for i := 1 to 6 do begin
    LineButtons[i].Font.Style := [];
  end;
  LineButtons[button].font.style := [fsBold];
end;

procedure TSipPhoneForm.SetupLineButton(number: Integer);
begin
  DecorateLineButton(number);
  Self.CurrentLineId := number;
  AbtoPhone.SetCurrentLine(number);
end;


procedure TSipPhoneForm.Line1ButtonClick(Sender: TObject);
begin
  SetupLineButton(1);
end;

procedure TSipPhoneForm.Line2ButtonClick(Sender: TObject);
begin
  SetupLineButton(2);
end;

procedure TSipPhoneForm.Line3ButtonClick(Sender: TObject);
begin
  SetupLineButton(3);
end;

procedure TSipPhoneForm.Line4ButtonClick(Sender: TObject);
begin
  SetupLineButton(4);
end;

procedure TSipPhoneForm.Line5ButtonClick(Sender: TObject);
begin
  SetupLineButton(5);
end;

procedure TSipPhoneForm.Line6ButtonClick(Sender: TObject);
begin
  SetupLineButton(6);
end;

procedure TSipPhoneForm.AboutMenuClick(Sender: TObject);
//var
//    about : TAboutForm;
begin
//    Application.CreateForm(TAboutForm, about);
//    about.ShowModal;
//    about.Free;
end;

procedure TSipPhoneForm.SettingsMenuClick(Sender: TObject);
//var
//    settingsForm: TSettingsForm;
//    phoneCfg : Variant;
begin
    {Application.CreateForm(TSettingsForm, settingsForm);

    phoneCfg := AbtoPhone.Config;
    settingsForm.SetSettings(phoneCfg, AbtoPhone.RetrieveVersion, AbtoPhone.RetrieveExternalAddress);

    settingsForm.ShowModal;
    if settingsForm.ModalResult = mrOk then begin
        settingsForm.SetupUserInput;
        AbtoPhone.ApplyConfig;
        phoneCfg.Store(configFileName);
    end;
    isAutoAnswerEnabled := phoneCfg.AutoAnswerEnabled;

    settingsForm.Free;}
end;


procedure TSipPhoneForm.ActivationMenuClick(Sender: TObject);
//var
//    activationForm: TActivationForm;
//    phoneCfg : Variant;
begin
  {  Application.CreateForm(TActivationForm, activationForm);

    activationForm.ShowModal;
    if activationForm.ModalResult = mrOk then begin
        phoneCfg := AbtoPhone.Config;
        activationForm.GetKeys(phoneCfg);

        phoneCfg.Store(configFileName);

        Application.Messagebox('Restart application for finalize activation.', 'Activation');
    end;
    activationForm.Free;}
end;


procedure TSipPhoneForm.DTFM1Click(Sender: TObject);
begin
  AbtoPhone.SendTone('1');
end;

procedure TSipPhoneForm.DTFM2Click(Sender: TObject);
begin
  AbtoPhone.SendTone('2');
end;

procedure TSipPhoneForm.DTFM3Click(Sender: TObject);
begin
  AbtoPhone.SendTone('3');
end;

procedure TSipPhoneForm.DTFM4Click(Sender: TObject);
begin
  AbtoPhone.SendTone('4');
end;

procedure TSipPhoneForm.DTFM5Click(Sender: TObject);
begin
  AbtoPhone.SendTone('5');
end;

procedure TSipPhoneForm.DTFM6Click(Sender: TObject);
begin
  AbtoPhone.SendTone('6');
end;

procedure TSipPhoneForm.DTFM7Click(Sender: TObject);
begin
  AbtoPhone.SendTone('7');
end;

procedure TSipPhoneForm.DTFM8Click(Sender: TObject);
begin
  AbtoPhone.SendTone('8');
end;

procedure TSipPhoneForm.DTFM9Click(Sender: TObject);
begin
  AbtoPhone.SendTone('9');
end;

procedure TSipPhoneForm.DTFMStarClick(Sender: TObject);
begin
  AbtoPhone.SendTone('*');
end;

procedure TSipPhoneForm.DTFM0Click(Sender: TObject);
begin
  AbtoPhone.SendTone('0');
end;

procedure TSipPhoneForm.DTFMHashClick(Sender: TObject);
begin
  AbtoPhone.SendTone('#');
end;

function TSipPhoneForm.GetCurrentLine: PLineInfo;
begin
  Result := Self.LinesTbl.Items[Self.CurrentLineId - 1];
end;

function TSipPhoneForm.GetLine(lineId: Integer): PLineInfo;
begin
  Result := Self.LinesTbl.Items[lineId - 1];
end;

function TSipPhoneForm.GetSelectedConnection(var connId: Integer): Boolean;
var
  count: Integer;
  selIndex: Integer;
begin
  connId := 0;
  count := ConnectionsListBox.Count;
  if count = 0 then
    GetSelectedConnection := False
  else begin
    selIndex := ConnectionsListBox.ItemIndex;
    if selIndex = -1 then selIndex := count - 1;
    connId := Integer(ConnectionsListBox.Items.Objects[selIndex]);
    GetSelectedConnection := True;
  end;
end;


function TSipPhoneForm.getStatus: WideString;
begin
  if ffTimeStatusAnterior = ffTimeStatus then
    result := ''
  else begin
    result := ffStatus;
    ffTimeStatusAnterior := ffTimeStatus;
  end;
end;

procedure TSipPhoneForm.PlayButtonClick(Sender: TObject);
begin
  stopStartPlaying(False, Self.CurrentLineId);
end;

procedure TSipPhoneForm.StopStartPlaying(isCalledByPlayFinishedEvent: Boolean; LineId: integer);
var
  lnInfo: PLineInfo;
  succeded: Integer;
begin
  lnInfo := Self.GetLine(LineId);
  if (isCalledByPlayFinishedEvent) and (not lnInfo.IsCallPlayStarted)
    then Exit;

  if lnInfo.IsCallPlayStarted then
  begin
    AbtoPhone.StopPlayback;
    PlayButton.Caption := 'Play';
  end else
  begin
    succeded := AbtoPhone.PlayFile(CaminhoSalvar);
    if succeded = 0  then Exit;

    Self.DisplayNotifyMessage('Now playing: ' + CaminhoSalvar);
    PlayButton.Caption := 'PlayStop';
  end;
  lnInfo.IsCallPlayStarted := not lnInfo.IsCallPlayStarted;
end;

procedure TSipPhoneForm.DisplayNotifyMessage(message: string);
begin
  StatusLogListBox.AddItem(message, nil);
  StatusLogListBox.ItemIndex := StatusLogListBox.Count - 1;
  StatusLogListBox.ItemIndex := -1; // Disable selection
end;

procedure TSipPhoneForm.DisplayConnectionsAll(lnInfo: PLineInfo);
var
  k: Integer;
begin
  ConnectionsListBox.Clear;
  for k in lnInfo.Connections.Keys do begin
    Self.DisplayConnection(k, lnInfo.Connections[k]);
  end;
end;

procedure TSipPhoneForm.DisplayConnection(connId: Integer; RemoteAddress: string);
begin
  Self.ConnectionsListBox.AddItem(RemoteAddress, TObject(connId));
  Self.ConnectionsListBox.ItemIndex := Self.ConnectionsListBox.Count - 1;
end;

procedure TSipPhoneForm.RemoveConnection(connId: Integer);
var
  i, count, idx: Integer;
begin
  for i := 0 to ConnectionsListBox.Count - 1 do begin
    idx := Integer(ConnectionsListBox.Items.Objects[i]);
    if (idx <> connId) then continue;

        //ConnectionsListBox.Items.Objects[i].Free;
    ConnectionsListBox.Items.Delete(i);
    Break;
  end;

  count := Self.ConnectionsListBox.Count;
  if count >= 1 then ConnectionsListBox.ItemIndex := count - 1;
end;

procedure TSipPhoneForm.ChangeControlsState(lnInfo: PLineInfo);
begin
  ChangeLineCaption(lnInfo);

  if lnInfo.IsCallEstablished or lnInfo.IsCalling
    then StartCallBtn.Caption := 'Hang up'
  else StartCallBtn.Caption := 'Start call';

  Self.HoldButton.Visible := lnInfo.IsCallEstablished;
  if lnInfo.IsCallHeld
    then Self.HoldButton.Caption := 'Retrieve'
  else Self.HoldButton.Caption := 'Hold';

  Self.TransferButton.Visible := lnInfo.IsCallEstablished;
  Self.JoinButton.Visible := lnInfo.IsCallEstablished;

  Self.AddressComboBox.Enabled := not (lnInfo.IsCallEstablished or lnInfo.IsCalling);
  Self.UserInputLabel.Caption := lnInfo.UserInputString;
end;

procedure TSipPhoneForm.ChangeLineCaption(lnInfo: PLineInfo);
var
  text: string;
begin
  if lnInfo.IsCallEstablished then text := '[x]' + 'Line' + IntToStr(lnInfo.Id)
  else text := 'Line' + IntToStr(lnInfo.Id);

  Self.GetLineButton(lnInfo.Id).Caption := text;
end;

function TSipPhoneForm.GetLineButton(lineId: Integer): TButton;
begin
  case lineId of
    1: Result := Self.Line1Button;
    2: Result := Self.Line2Button;
    3: Result := Self.Line3Button;
    4: Result := Self.Line4Button;
    5: Result := Self.Line5Button;
    6: Result := Self.Line6Button;
  else
    Result := Self.Line1Button;
  end;
end;

{ event handlers }

procedure TSipPhoneForm.AbtoPhone_OnInitialized(ASender: TObject; const Msg: WideString);
begin
  fStatus := '{"Evento": "OnInitialized", "Msg":"' + Msg + '", "Time":"' + TimeToStr(Now) + '" }';
  DisplayNotifyMessage(msg);

  if ((Pos(WideString('expired'), msg) <> 0) or (Pos(WideString('Invalid'), msg) <> 0)) then
    ActivationMenuClick(self);
end;

procedure TSipPhoneForm.AbtoPhone_OnLineSwitched(Sender: TObject; LineId: Integer);
var
  lnInfo: PLineInfo;
begin
  fStatus := '{"Evento": "OnLineSwitched", "Msg":"' + IntToStr(LineId) + '" , "Time":"' + TimeToStr(Now) + '" }';
  Self.CurrentLineId := LineId;
  lnInfo := Self.GetCurrentLine;
  DisplayConnectionsAll(lnInfo);
  ChangeControlsState(lnInfo);
end;

procedure TSipPhoneForm.AbtoPhone_OnEstablishedCall(ASender: TObject; const Msg: WideString; LineId: Integer);
var
  lnInfo: PLineInfo;
begin
  fStatus := '{"Evento": "OnEstablishedCall", "Msg":"' + Msg + '", "LineId": "' + IntToStr(LineId) + '", "Time":"' + TimeToStr(Now) + '" }';

  lnInfo := Self.GetLine(LineId);
  lnInfo.UserInputString := '';
  lnInfo.IsCallEstablished := True;
  lnInfo.IsCalling := False;
  if LineId = Self.CurrentLineId then
  begin
            //Display status
    DisplayNotifyMessage(VarToStr(Msg));
            //Cange controls state
    ChangeControlsState(lnInfo);
  end
  else begin
    ChangeLineCaption(lnInfo);
  end;

  if lnInfo.IsCallEstablished then
  begin
    AbtoPhone.StartRecording(CaminhoSalvar);
    lnInfo.IsCallRecordStarted := not lnInfo.IsCallRecordStarted;
  end;
end;

procedure TSipPhoneForm.AbtoPhone_OnIncomingCall(ASender: TObject; const AddrFrom: WideString; LineId: Integer);
var
  lnInfo: PLineInfo;
//    incomingForm: TIncomingCallForm;
begin
  fStatus := '{"Evento": "OnIncomingCall", "Msg":"' + AddrFrom + '", "LineId": "' + IntToStr(LineId) + '", "Time":"' + TimeToStr(Now) + '" }';

    //Check autoanswer mode
  {  if(self.isAutoAnswerEnabled) then Exit;

    incomingForm := TIncomingCallForm.Create(Self);
    incomingForm.SetCallerLineData(VarToStr(AddrFrom), LineId);
    incomingForm.ShowModal;

    //Set cur line where incoming call found
    AbtoPhone.SetCurrentLine(lineId);

    if incomingForm.ModalResult = mrYes
        then AbtoPhone.AnswerCall
        else AbtoPhone.RejectCall;

    incomingForm.Free;}
end;

procedure TSipPhoneForm.AbtoPhone_OnClearedCall(ASender: TObject; const Msg: WideString; Status: Integer; LineId: Integer);
var
  lnInfo: PLineInfo;
  str: WideString;
begin
  fStatus := '{"Evento": "OnClearedCall", "Msg":"' + Msg
  + '", "LineId": "' + IntToStr(LineId) + '. Status: ' + IntToStr(Status) + '", "Time":"' + TimeToStr(Now) + '" }';

  lnInfo := Self.GetLine(LineId);
  lnInfo.IsCallEstablished := False;
  lnInfo.IsCalling := False;

  if lnInfo.IsCallRecordStarted then
  begin
    AbtoPhone.StopRecording;
    lnInfo.IsCallRecordStarted := not lnInfo.IsCallRecordStarted;
  end;

    //Update controls (only when it's cur line event)
  if LineId = Self.CurrentLineId then Self.ChangeControlsState(lnInfo)
  else Self.ChangeLineCaption(lnInfo);

    //Display status
  str := VarToStr(Msg) + '. Line: ' + IntToStr(lineId) + '. Status: ' + IntToStr(Status);
  DisplayNotifyMessage(str);
end;

procedure TSipPhoneForm.AbtoPhone_OnToneReceived(ASender: TObject; Tone: Integer; connId: Integer;
  LineId: Integer);
var
  lnInfo: PLineInfo;
begin
  fStatus := '{"Evento": "OnToneReceived", "Msg":"' + IntToStr(Tone) + '", "Time":"' + TimeToStr(Now) + '" }';

  lnInfo := Self.GetLine(LineId);
  lnInfo.UserInputString := lnInfo.UserInputString + Chr(Tone);

  if LineId = Self.CurrentLineId then
  begin
    Self.UserInputLabel.Caption := lnInfo.UserInputString;
  end;

end;

procedure TSipPhoneForm.AbtoPhone_OnVolumeUpdated(Sender: TObject; IsMicrophone: Integer; Level: Integer);
begin
  if IsMicrophone = 0 then SoundLevelBar.Position := Level
  else RecordLevelBar.Position := Level;
end;

procedure TSipPhoneForm.AbtoPhone_OnRegistered(ASender: TObject; const Msg: WideString);
begin
  fStatus := '{"Evento": "OnRegistered", "Msg":"' + Msg + '", "Time":"' + TimeToStr(Now) + '" }';
  Self.DisplayNotifyMessage(Msg);
end;


procedure TSipPhoneForm.AbtoPhone_OnPlayFinished(ASender: TObject; const Msg: WideString);
const
  playFinishedStr: string = 'Play Finished on Line: ';
var
  lineId: integer;
  strMsg: string;
begin
  fStatus := '{"Evento": "OnPlayFinished", "Msg":"' + Msg + '", "Time":"' + TimeToStr(Now) + '" }';
  strMsg := Msg;

  if (Pos(playFinishedStr, strMsg) = 0) then
  begin
    lineId := StrToInt(Copy(strMsg, Length(playFinishedStr), Length(strMsg) - Length(playFinishedStr)));
    StopStartPlaying(true, lineId);
  end;

  Self.DisplayNotifyMessage(Msg);
end;

procedure TSipPhoneForm.AbtoPhone_OnEstablishedConnection(ASender: TObject; const AddrFrom: WideString;
  const AddrTo: WideString;
  connId: Integer;
  LineId: Integer);
var
  lnInfo: PLineInfo;
  addr: WideString;
begin
  lnInfo := Self.GetLine(LineId);

  if (lnInfo.IsCalling = True) then
    addr := AddrTo
  else
    addr := AddrFrom;

  lnInfo.Connections.Add(connId, addr);

  if LineId = Self.CurrentLineId then
    Self.DisplayConnection(connId, addr);

  fStatus := '{"Evento": "OnEstablishedConnection", "Msg":"' + addr + '", "Time":"' + TimeToStr(Now) + '" }';
end;

procedure TSipPhoneForm.AbtoPhone_OnClearedConnection(Sender: TObject; connId: Integer; LineId: Integer);
var
  lnInfo: PLineInfo;
begin
  fStatus := '{"Evento": "OnClearedConnection", "Msg":"' + IntToStr(LineId) + '", "Time":"' + TimeToStr(Now) + '" }';
  lnInfo := Self.GetLine(LineId);
  lnInfo.Connections.Remove(connId);

  if lineId = Self.CurrentLineId then
    RemoveConnection(connId);
end;

procedure TSipPhoneForm.AbtoPhone_OnTextMessageReceived(ASender: TObject; const address: WideString;
  const message: WideString);
begin
  fStatus := '{"Evento": "OnTextMessageReceived", "Msg":"' + '"' + message + '" received from: ' + address + '", "Time":"' + TimeToStr(Now) + '" }';
  Self.DisplayNotifyMessage('"' + message + '" received from: ' + address);
end;


procedure TSipPhoneForm.AbtoPhone_OnTextMessageSentStatus(ASender: TObject; const address: WideString;
  const reason: WideString; bSuccess: Integer);
begin
  if (bSuccess <> 0) then
  begin
    Self.DisplayNotifyMessage('Message sent succesfully. to: ' + address);
    fStatus := '{"Evento": "OnTextMessageSentStatus", "Msg":"' + address + '", "Time":"' + TimeToStr(Now) + '" }';
  end
  else begin
    Self.DisplayNotifyMessage('Message sent failure. to: ' + address + '. Reason: ' + reason);
    fStatus := '{"Evento": "OnTextMessageSentStatus", "Msg":"' + address + '. Reason: ' + reason + '", "Time":"' + TimeToStr(Now) + '" }';
  end;
end;

procedure TSipPhoneForm.AbtoPhone_OnNotify(ASender: TObject; const Msg: WideString);
begin
  Self.DisplayNotifyMessage(Msg);
  fStatus := '{"Evento": "OnNotify", "Msg":"' + Msg + '", "Time":"' + TimeToStr(Now) + '" }';
end;

procedure TSipPhoneForm.AbtoPhone_OnRemoteAlerting(ASender: TObject;
  connId: Integer; responseCode: Integer;
  const reasonMsg: WideString);
begin
  Self.DisplayNotifyMessage('Remote alerting: ' + IntToStr(responseCode) + ' ' + reasonMsg);
  fStatus := '{"Evento": "OnRemoteAlerting", "Msg":"' + IntToStr(responseCode) + ' - ' + reasonMsg + '", "Time":"' + TimeToStr(Now) + '" }';
end;

procedure TSipPhoneForm.AbtoPhone_OnHoldCall(ASender: TObject; LineId: Integer; isHeld: Integer);
begin
  if (isHeld <> 0) then
  begin
    Self.DisplayNotifyMessage('OnCallHold. Line: ' + IntToStr(LineId) + ' Held');
    fStatus := '{"Evento": "OnHoldCall", "Msg":"' + IntToStr(LineId) + ' - Held ' + '", "Time":"' + TimeToStr(Now) + '" }';
  end
  else begin
    Self.DisplayNotifyMessage('OnCallHold. Line: ' + IntToStr(LineId) + ' Retrived');
    fStatus := '{"Evento": "OnHoldCall", "Msg":"' + IntToStr(LineId) + ' - Retrived ' + '", "Time":"' + TimeToStr(Now) + '" }';
  end;
end;


procedure TSipPhoneForm.HoldButtonClick(Sender: TObject);
var
  lnInfo: PLineInfo;
begin
  lnInfo := Self.GetCurrentLine;
  Self.AbtoPhone.HoldRetrieveCurrentCall;
  if lnInfo.IsCallHeld
    then Self.HoldButton.Caption := 'Hold'
  else Self.HoldButton.Caption := 'Retrieve';
  lnInfo.IsCallHeld := not lnInfo.IsCallHeld;
end;



procedure TSipPhoneForm.RecButtonClick(Sender: TObject);
var
  lnInfo: PLineInfo;
begin
  lnInfo := Self.GetCurrentLine;
  if lnInfo.IsCallRecordStarted
    then begin
    Self.AbtoPhone.StopRecording();
    Self.RecButton.Caption := 'Rec';
    Self.DisplayNotifyMessage('Recording stopped'); end
  else begin
    Self.SaveDialog.Filter := 'Sound Files (*.wav)|*.wav';
    Self.SaveDialog.Options := Self.SaveDialog.Options + [ofOverwritePrompt];
    if not Self.SaveDialog.Execute
      then Exit;
    Self.AbtoPhone.StartRecording(Self.SaveDialog.FileName);
    Self.RecButton.Caption := 'RecStop';
    Self.DisplayNotifyMessage('Now recording to ' + Self.SaveDialog.FileName);
  end;
  lnInfo.IsCallRecordStarted := not lnInfo.IsCallRecordStarted;
end;

procedure TSipPhoneForm.TransferButtonClick(Sender: TObject);
//var
//    form: TTransferForm;
begin
 {   form := TTransferForm.Create(Self);
    form.ShowModal;
    if form.ModalResult = mrOK then begin
        Self.AbtoPhone.TransferCall(form.TransferToEdit.Text);
    end;
    form.Free;}
end;

procedure TSipPhoneForm.JoinButtonClick(Sender: TObject);
{var
    form: TJoinForm;
    selLineInfo, curLineInfo: PLineInfo;
    k: Integer;
 }
begin
  {form := TJoinForm.Create(Self);
 form.SetCurrentLineId(Self.CurrentLineId);
 form.ShowModal;
 if (form.ModalResult <> mrOK) or (form.GetSelectedLineId = Self.CurrentLineId) then begin
  form.Free;
  Exit;
 end;

 ShowMessage(IntToStr(form.GetSelectedLineId));
 selLineInfo := Self.GetLine(form.GetSelectedLineId + 1);
 curLineInfo := Self.GetCurrentLine;
 if not selLineInfo.IsCallEstablished then begin
  form.Free;
  Exit;
 end;


   for k in selLineInfo.Connections.Keys do begin
        curLineInfo.Connections.Add(k, selLineInfo.Connections[k])
   end;

 selLineInfo.Connections.Clear;
 DisplayConnectionsAll(curLineInfo);
 AbtoPhone.JoinToCurrentCall(form.GetSelectedLineId);
 form.Free;}
end;

procedure TSipPhoneForm.buttonExpandClick(Sender: TObject);
var
  deltaWidth: Integer;
begin
  deltaWidth := CallPanel.Left;
  if Self.Width > CallPanel.Width + 2 * deltaWidth then
  begin
      //Straiten
    Self.Width := CallPanel.Width + 2 * deltaWidth;
    buttonExpand.Caption := '>>';
  end else
  begin
      //Expand
    Self.Width := pictureReceivedVideo.Width + pictureReceivedVideo.Left + deltaWidth;
    buttonExpand.Caption := '<<';
  end;

  buttonExpand.Left := Self.Width - deltaWidth - buttonExpand.Width;
  DownloadSdkLabel.Width := buttonExpand.Left - deltaWidth;
end;

procedure TSipPhoneForm.SendTextButtonClick(Sender: TObject);
{var
    sendTextForm: TSendTextForm;
    sendAsUnicode : integer;}
begin
    {Application.CreateForm(TSendTextForm, sendTextForm);

    sendTextForm.AddrEdit.Text := self.AddressComboBox.Text;
    sendTextForm.ShowModal;

    if (sendTextForm.ModalResult = mrOk) and
       (sendTextForm.AddrEdit.Text <> '') and
       (sendTextForm.MessageEdit.Text <> '')  then
    begin
        if(sendTextForm.UnicodeCheckBox.Checked=true) then sendAsUnicode := 1 else sendAsUnicode := 0;

        self.AbtoPhone.SendTextMessage(sendTextForm.AddrEdit.Text,
                                      sendTextForm.MessageEdit.Text,
                                      sendAsUnicode);

    end;
    sendTextForm.Free;}
end;

procedure TSipPhoneForm.setStatus(const Value: WideString);
begin
  ffTimeStatus := Now;
  ffStatus := Value;
end;

end.

