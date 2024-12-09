unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  SyncObjs, System.Generics.Collections, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Timer1: TTimer;
    Label6: TLabel;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TNumberWorker = class(TThread)
  private
    FThreadID: Integer;
  protected
    procedure Execute; override;
  public
    constructor Create(ThreadID: Integer);
  end;

var
  Form1: TForm1;
  UserNameStr: string;
  GlobalCounter: Integer;
  Lock: TCriticalSection;
  ThreadList: TList<TThread>;
  QAlphabet: string;
  TerminateThreads: Boolean;
  StartTime: TDateTime;
  IsRunning: Boolean;

implementation

{$R *.dfm}

function GetCurrentUserName: string;
var
  UserName: array[0..255] of Char;
  UserNameSize: DWORD;
begin
  UserNameSize := Length(UserName);
  if GetUserName(UserName, UserNameSize) then
    Result := UserName
  else Result := '';
end;

function GetAlphabetString(Position: Integer; const Alphabet: string): string;
var
  ResultStr: string;
  Remainder: Integer;
  Base: Integer;
begin
  if Alphabet = '' then
    raise Exception.Create('The alphabet cannot be empty.');
  Base := Length(Alphabet);
  ResultStr := '';
  while Position > 0 do
  begin
    Dec(Position);
    Remainder := Position mod Base;
    ResultStr := Alphabet[Remainder + 1] + ResultStr;
    Position := Position div Base;
  end;
  Result := ResultStr;
end;

procedure StartThreads(ThreadCount: Integer);
var
  I: Integer;
begin
  for I := 1 to ThreadCount do
  begin
    ThreadList.Add(TNumberWorker.Create(I));
  end;
end;

function LogInAsUser(const UserName, Password, Domain: string): Boolean;
var
  Token: THandle;
begin
  Result := LogonUser(PChar(UserName), PChar(Domain), PChar(Password),
    LOGON32_LOGON_INTERACTIVE, LOGON32_PROVIDER_DEFAULT, Token);
  if Result then
  begin
    try
      if ImpersonateLoggedOnUser(Token) then
      begin
        Form1.Edit3.Text := UserName+':'+Password;
        Form1.Label4.Caption := Password;
        TerminateThreads := True;
        IsRunning := False;
        Form1.Timer1.Enabled := False;
      end;
    finally
      CloseHandle(Token);
    end;
  end;
end;


constructor TNumberWorker.Create(ThreadID: Integer);
begin
  inherited Create(False);
  FreeOnTerminate := False;
  FThreadID := ThreadID;
end;

procedure TNumberWorker.Execute;
var
  LocalCounter: Integer;
begin
  while not Terminated do
  begin
    if TerminateThreads then Exit;
    Lock.Acquire;
    try
      Inc(GlobalCounter);
      LocalCounter := GlobalCounter;

    finally
      Lock.Release;
    end;
    Synchronize(procedure
      begin
        if LogInAsUser(PChar(UserNameStr), GetAlphabetString(LocalCounter, QAlphabet), '.') then
        begin
          ShowMessage('Successfully authorized. UserName : ' + UserNameStr +
          ' Password : ' + GetAlphabetString(LocalCounter, QAlphabet));
        end
        else
        begin
          if TerminateThreads then Exit;
          Form1.Label4.Caption := GetAlphabetString(LocalCounter, QAlphabet);
        end;
      end);
    Sleep(100);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  StartTime := Now;
  Timer1.Enabled := True;
  IsRunning := True;
  TerminateThreads := False;
  QAlphabet := Edit1.Text;
  GlobalCounter := 1;
  Lock := TCriticalSection.Create;
  ThreadList := TList<TThread>.Create;
  try
    StartThreads(StrToInt(Edit2.Text));
  except
    on E: Exception do
      Writeln('Error starting threads: ' + E.Message);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  IsRunning := False;
  Timer1.Interval := 1000;
  Timer1.Enabled := False;
  UserNameStr := GetCurrentUserName;
  if UserNameStr = '' then
  begin
    ShowMessage('Can''t get username.');
    Application.Terminate;
  end;
  Label2.Caption := UserNameStr;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  ElapsedTime: TDateTime;
begin
  ElapsedTime := Now - StartTime;
  Label5.Caption := 'Time has passed : ' + FormatDateTime('hh:nn:ss', ElapsedTime);
end;

end.
