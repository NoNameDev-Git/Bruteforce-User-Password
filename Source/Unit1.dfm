object Form1: TForm1
  Left = 0
  Top = 0
  ClientHeight = 249
  ClientWidth = 199
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 15
    Top = 144
    Width = 59
    Height = 13
    Caption = 'UserName : '
  end
  object Label2: TLabel
    Left = 77
    Top = 144
    Width = 49
    Height = 13
    Caption = 'UserName'
  end
  object Label3: TLabel
    Left = 15
    Top = 163
    Width = 70
    Height = 13
    Caption = 'Enumeration : '
  end
  object Label4: TLabel
    Left = 91
    Top = 163
    Width = 17
    Height = 13
    Caption = 'abc'
  end
  object Label5: TLabel
    Left = 15
    Top = 182
    Width = 133
    Height = 13
    Caption = 'Time has passed : 00.00.00'
  end
  object Label6: TLabel
    Left = 15
    Top = 8
    Width = 43
    Height = 13
    Caption = 'Alphabet'
  end
  object Label7: TLabel
    Left = 15
    Top = 54
    Width = 43
    Height = 13
    Caption = 'Threads'
  end
  object Button1: TButton
    Left = 15
    Top = 100
    Width = 164
    Height = 33
    Caption = 'START'
    TabOrder = 0
    TabStop = False
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 15
    Top = 27
    Width = 164
    Height = 21
    TabStop = False
    Alignment = taCenter
    TabOrder = 1
    Text = '0123456789'
    TextHint = 'Alphabet'
  end
  object Edit2: TEdit
    Left = 15
    Top = 73
    Width = 164
    Height = 21
    TabStop = False
    Alignment = taCenter
    TabOrder = 2
    Text = '50'
    TextHint = 'Threads'
  end
  object Edit3: TEdit
    Left = 15
    Top = 201
    Width = 164
    Height = 21
    TabStop = False
    Alignment = taCenter
    TabOrder = 3
    TextHint = 'User:Password'
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 144
    Top = 136
  end
end
