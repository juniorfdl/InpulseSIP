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

function Transferir(pParam: WideString): WideString; stdcall;
begin
  Result := TSipPhoneForm.Transferir(pParam);
end;

function SendTone(pParam: WideString): WideString; stdcall;
begin
  Result := TSipPhoneForm.SendTone(pParam);
end;

function Esperar(pParam: WideString): WideString; stdcall;
begin
  Result := TSipPhoneForm.Esperar(pParam);
end;

function AutoFalante(pParam: WideString): WideString; stdcall;
begin
  Result := TSipPhoneForm.AutoFalante(pParam);
end;

function MicroFone(pParam: WideString): WideString; stdcall;
begin
  Result := TSipPhoneForm.MicroFone(pParam);
end;

function SetCaminhoSalvar(pParam: WideString): WideString; stdcall;
begin
  Result := TSipPhoneForm.SetCaminhoSalvar(pParam);
end;

exports
  Ligar, Inicializar, Finalizar, Desligar, Status, Transferir, AutoFalante, MicroFone, SetCaminhoSalvar;
begin
end.
