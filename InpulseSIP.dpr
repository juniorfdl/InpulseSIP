library InpulseSIP;

uses
  System.SysUtils,
  System.Classes,
  SIPVoipSDK_TLB in 'SIPVoipSDK_TLB.pas',
  SipPhoneUnit in 'SipPhoneUnit.pas' {SipPhoneForm};

{$R *.res}

function Inicializar(pParam: WideString): WideString; stdcall;
begin
  Result := '0';
  TSipPhoneForm.Inicializar(pParam);
  Result := '1';
end;

function Finalizar(pParam: WideString): WideString; stdcall;
begin
  Result := '0';
  TSipPhoneForm.Finalizar(pParam);
  Result := '1';
end;

function Ligar(pParam: WideString): WideString; stdcall;
begin
  Sleep(1000);
  Result := TSipPhoneForm.Ligar(pParam);
end;

function Desligar(pParam: WideString): WideString; stdcall;
begin
  Result := TSipPhoneForm.Desligar(pParam);
end;

function Status(pParam: WideString): WideString; stdcall;
begin
  Result := TSipPhoneForm.Status(pParam);
end;

exports
  Ligar, Inicializar, Finalizar, Desligar, Status;
begin
end.