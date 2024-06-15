;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Display Module!!                                                            ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                        Jumps
                        .386

include switch.inc

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Externals                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Segment         Pattern WORD Public 'Code' USE16
                Extrn   Order:Word
EndS

Segment         Object1 BYTE Public 'Data' USE16
EndS

Segment         Glbl BYTE Public 'Code' USE16
                Extrn   CurrentMode:Byte
EndS

IF SPECTRUMANALYSER
                Extrn   Fourier_Start:Far
ENDIF
                Extrn   S_GetDestination:Far
                Extrn   S_DrawBox:Far
                Extrn   S_DrawString:Far
                Extrn   Music_GetOutputWaveform:Far
                Extrn   Music_GetInstrumentMode:Far
                Extrn   Music_GetSongSegment:Far
                Extrn   Music_GetSampleLocation:Far
                Extrn   Music_GetHostChannelInformationTable:Far
                Extrn   Music_GetSlaveChannelInformationTable:Far
                Extrn   Music_NextOrder:Far
                Extrn   Music_LastOrder:Far
                Extrn   Music_GetPlayMode:Far
                Extrn   Music_GetPlayMode2:Far
                Extrn   Music_GetPattern:Far
                Extrn   Music_ToggleChannel:Far
                Extrn   Music_SoloChannel:Far
                Extrn   Music_GetDisplayVariables:Far
                Extrn   Music_InitStereo:Far
;                Extrn   Music_UpdateSampleLocation:Far
                Extrn   Music_Poll:Far
                Extrn   Music_ToggleReverse:Far
                Extrn   Music_GetLastChannel:far
                Extrn   Music_GetPatternLength:Far

                Extrn   M_FunctionDivider:Far

IF NETWORKENABLED
                Extrn   Network_Poll:Far
ENDIF

                Extrn   O1_DisplayList, O1_FullDisplayList

                Extrn   PE_GetCurrentPattern:Far
                Extrn   PE_ConvAX2Num:Far

                Extrn   PE_GotoPattern:Far

                Extrn   SetInfoLine:Far

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Globals                                                                     ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                Global  DisplayPlus:Far
                Global  DisplayMinus:Far
                Global  DrawDisplayData:Far
                Global  PostDisplayData:Far
                Global  DisplayUpdateScreen:Far
                Global  Display_GetDisplayWindowData:Far
                Global  Display_SelectDisplayList:Far

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment                 InfoPage BYTE Public 'Code' USE16
                        Assume CS:InfoPage, DS:InfoPage

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Variables                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SLAVECHANNELSIZE        EQU     128
HOSTCHANNELSIZE         EQU     80

PLAYMETHODS             EQU     11
DOTSDISPLAY             EQU     9

CurrentChannel          DW      0
;CurrentSample           DW      0
;CurrentInstrument       DW      0
DisplayMode             DW      0

DrawTrackData           DW      0       ; Function to call to draw track

DataArray               DB      320 Dup (0)
DataDecode              DB      384 Dup (0)
DecodeOffset            DW      ?                       ; Offset is -1 if no pat
DecodeSegment           DW      ?

DecodePattern           DW      ?
DecodeRow               DW      ?
DecodeMaxRow            DW      ?

PatternArrayNumber      DW      ?
PatternMaxRow           DW      ?
PatternSegment          DW      ?

Channel5Msg             DB      " Channel xx ", 0
Channel8Msg             DB      "  xx  ", 0
Channel18Msg            DB      "xx", 0
NoteTable               DB      "C-C#D-D#E-F-F#G-G#A-A#B-"
Note2Table              DB      "cCdDefFgGaAb"
LeftMsg                 DB      "Left     "
RightMsg                DB      "    Right"
SurroundMsg             DB      "Surround "
NNAMsg                  DB      "Cut", 0
                        DB      "Con", 0
                        DB      "Off", 0
                        DB      "Fde", 0
VirtualMsg              DB      "NNA", 0FEh, 21h, 148, 0FEh, 12h, "Tot", 0
DetailsMsg              DB      "Frequency", 0FEh, 21h, 148, 148, 0FEh, 12h
                        DB      "Position", 0FEh, 21h, 148, 148, 0FEh, 12h
                        DB      "Smp",  0FEh, 21h, 152, 153, 0FEh, 12h
                        DB      "FVl", 0FEh, 21h, 148, 0FEh, 12h
                        DB      "Vl", 0FEh, 21h, 148, 0FEh, 12h
                        DB      "CV", 0FEh, 21h, 148, 0FEh, 12h
                        DB      "SV", 0FEh, 21h, 148, 0FEh, 12h
                        DB      "VE", 0FEh, 21h, 148, 0FEh, 12h
                        DB      "Fde", 0FEh, 21h, 148, 0FEh, 12h
                        DB      "Pn", 0FEh, 21h, 148, 0FEh, 12h
                        DB      "PE", 0


RestoreData             DB      0

DisplayWindows          Label                   ; Structure is 1 word
                        DW      0               ; 1 word, method
                        DB      0               ; 1 byte, top channel (+2)
;                        DB      1
;                        DW      31
;                        DW      160

                        DB      12              ; 1 byte, top line (+3)
                        DW      20              ; 1 word length of window (+4)
                        DW      12*80*2         ; 1 word offset to top left (+6)

                        DW      8
                        DB      0
                        DB      32
                        DW      3
                        DW      32*80*2

                        DW      5
                        DB      0
                        DB      35
                        DW      15
                        DW      35*80*2

                        DW      11 Dup (0)
                        DB      0
FullScreen              DB      0

NumWindows              DW      3               ; This cannot be moved!!!
CurrentWindow           DW      0
ProcessWindow           DW      0

PlayMode                DW      0
CurrentRow              DW      0
CurrentPattern          DW      0
CurrentOrder            DW      0

LastRow                 DW      0
LastPattern             DW      0
LastOrder               DW      0

WaveformLength          DW      0
Velocity                DB      0
Instrument              DB      0

Comment ~
Correlation             Label   Byte
                        DB      255, 254, 252, 249, 245, 240, 234, 227
                        DB      219, 210, 210, 199, 187, 174, 160, 145

                        DB      129, 112, 94, 75, 55, 34, 12, 0
                        DB      0, 0, 0, 0, 0, 0, 0, 0
~

Destination             DW      0

VariablesMsg            DB      "Active Channels: ", 0FDh, "D (", 0FDh, "D)", 13
                        DB      "  Global Volume: ", 0FDh, "D", 0

StereoEnabledMsg        DB      "Stereo Enabled", 0
StereoDisabledMsg       DB      "Stereo Disabled", 0
VelocityMsg             DB      "Using velocity bars", 0
VolumeMsg               DB      "Using volume bars", 0
InstrumentMsg           DB      "Using Instrument names", 0
SampleMsg               DB      "Using Sample names", 0

DisplayDataModes        Label
                        DW      Offset Display_HostChannel
                        DW      Offset Display_5Channel
                        DW      Offset Display_8Channel
                        DW      Offset Display_10Channel
                        DW      Offset Display_18Channel
                        DW      Offset Display_24Channel
                        DW      Offset Display_36Channel
                        DW      Offset Display_64Channel
                        DW      Offset Display_Variables
                        DW      Offset Display_NoteDots
;                        DW      Offset Display_SampleDots
                        DW      Offset Display_Details

DisplayListKeys         Label
                        DB      0               ; Up arrow
                        DW      1C8h
                        DW      Offset DisplayUp

                        DB      0
                        DW      1CBh            ; Left arrow
                        DW      Offset DisplayUp

                        DB      0
                        DW      1D0h            ; Down arrow
                        DW      Offset DisplayDown

                        DB      0
                        DW      1CDh            ; Right arrow
                        DW      Offset DisplayDown

                        DB      2
                        DW      1C8h
                        DW      Offset DisplayAltUp

                        DB      2
                        DW      1D0h
                        DW      Offset DisplayAltDown

                        DB      0
                        DW      1C7h
                        DW      Offset DisplayHome

                        DB      0
                        DW      1CFh
                        DW      Offset DisplayEnd

;                        DB      0
;                        DW      14Ah             ; Grey minus
                        DB      1
                        DW      '-'
                        DW      Offset DisplayMinus

;                        DB      0
;                        DW      14Eh             ; Grey Plus
                        DB      1
                        DW      '+'
                        DW      Offset DisplayPlus

                        DB      0
                        DW      1D2h            ; Insert
                        DW      Offset DisplayInsert

                        DB      0
                        DW      1D3h            ; Delete
                        DW      Offset DisplayDelete

                        DB      0               ; PgUp
                        DW      1C9h
                        DW      Offset DisplayPageUp

                        DB      0               ; PgDn
                        DW      1D1h
                        DW      Offset DisplayPageDown

                        DB      0               ; Tab
                        DW      10Fh
                        DW      Offset DisplayNext

                        DB      1               ; Shifttab
                        DW      0F00h
                        DW      Offset DisplayPrevious

                        DB      2               ; Alt
                        DW      143h            ; F9
                        DW      Offset DisplayToggleChannel

                        DB      5
                        DW      'Q'
                        DW      Offset DisplayToggleChannel

                        DB      2               ; Alt
                        DW      144h            ; F10
                        DW      Offset DisplaySoloChannel

                        DB      1               ; Alt 'R'
                        DW      1300h
                        DW      Offset DisplayToggleReverse

                        DB      1               ; Alt...
                        DW      1F00h           ; 'S'
                        DW      Offset DisplayToggleStereo

                        DB      5
                        DW      'S'
                        DW      Offset DisplaySoloChannel

                        DB      5
                        DW      'G'
                        DW      Offset Display_GotoPattern

                        DB      5
                        DW      'V'
                        DW      Offset DisplayToggleVelocity

                        DB      5
                        DW      'I'
                        DW      Offset DisplayToggleInstrument

                        DB      1
                        DW      ' '
                        DW      Offset Display_SpaceBar

                        DB      1
                        DW      6               ; Ctrl F
                        DW      Offset Display_FullScreen

IF SPECTRUMANALYSER
                        DB      2               ; Alt..
                        DW      158h            ; F12
                        DW      Offset Display_FourierStart
ENDIF

                        DB      0FFh            ; End of list

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Functions                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Proc            GetChannelColour                ; Gets AH

                Push    DS
                Push    BX
                Call    Music_GetSongSegment
                Mov     DS, AX
                And     BX, 0FFh
                Test    Byte Ptr [DS:BX+40h], 80h
                Pop     BX
                Pop     DS
                JNZ     GetChannelColour1

                                                ; Non-muted colours.
                Mov     AH, 13h
                Cmp     BL, DL
                JE      GetChannelColourEnd

                Mov     AH, 12h

                Mov     BH, Byte Ptr ProcessWindow
                Cmp     BH, Byte Ptr CurrentWindow
                JE      GetChannelColourEnd

                Mov     AH, 10h
                Ret

GetChannelColour1:                              ; Muted colours
                Mov     AH, 16h

                Cmp     BL, DL
                JE      GetChannelColourEnd

                Mov     AH, 11h

GetChannelColourEnd:
                Ret

EndP            GetChannelColour

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DrawChannelNumbers

                Mov     CH, 0Ah
                Mov     CL, [CS:BP+4]
                Sub     CL, 2
                Mov     DI, [CS:BP+6]
                Add     DI, (2+1*80)*2

                Call    Music_GetSongSegment
                Mov     DS, AX
                        Assume DS:Nothing

Display_HostChannel3:
                Push    CX
                Push    DI

                Mov     AX, BX
                Inc     AX
                Div     CH

                Add     AX, 3030h

                Mov     DH, AH

                Mov     AH, 23h
                Cmp     DL, BL
                JE      Display_HostChannel4

                Test    Byte Ptr [BX+40h], 80h
                JNZ     Display_HostChannel21

                Mov     AH, 21h
                Mov     CX, ProcessWindow
                Cmp     CX, CurrentWindow
                JE      Display_HostChannel4

                Mov     AH, 20h
                Jmp     Display_HostChannel32

Display_HostChannel4:
                Test    Byte Ptr [BX+40h], 80h
                JZ      Display_HostChannel32

                Mov     AH, 26h

Display_HostChannel32:
                StosW
                Mov     AL, DH
                StosW

Display_HostChannel21:
                Inc     BX

                Pop     DI
                Pop     CX
                Add     DI, 160

                Dec     CL
                JNZ     Display_HostChannel3

                Ret

EndP            DrawChannelNumbers

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DrawHexAL

                Cmp     AL, 10
                SBB     AL, 69h
                DAS

                StosW
                Ret

EndP            DrawHexAL

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Display_HostChannel
                                                ; Draw boxes first.
                                Assume DS:InfoPage

                Mov     ES, Destination

                Mov     AX, 4                   ; left
                Push    AX
                Mov     AL, [CS:BP+3]
                Push    AX
                Push    29
                Add     AX, [CS:BP+4]
                Dec     AX
                Push    AX
                Push    27
                Call    S_DrawBox

                Mov     SI, SP
                Mov     Byte Ptr [SS:SI+4], 62
                Mov     Byte Ptr [SS:SI+8], 30
                Call    S_DrawBox

                Push    DS
                Call    Music_GetSongSegment
                Mov     DS, AX
                Test    Byte Ptr [DS:2Ch], 1
                Pop     DS
                JZ      Display_HostChannel27

                Mov     Byte Ptr [SS:SI+4], 73
                Mov     Byte Ptr [SS:SI+8], 63
                Call    S_DrawBox

Display_HostChannel27:
                Add     SP, 10

                Mov     DX, CurrentChannel
                MovZX   BX, Byte Ptr [CS:BP+2]
                Cmp     DX, BX
                JAE     Display_HostChannel1

                Mov     BX, DX

Display_HostChannel1:
                LEA     CX, [EDX+3]
                Sub     CX, [CS:BP+4]
                Cmp     BX, CX
                JGE     Display_HostChannel2

                Mov     BX, CX

Display_HostChannel2:
                Mov     CX, 66
                Sub     CX, [CS:BP+4]
                Cmp     BX, CX
                JLE     Display_HostChannel22

                Mov     BX, 65
                Sub     BX, [CS:BP+4]

Display_HostChannel22:
                Mov     [CS:BP+2], BL                   ; BL = top channel

                Call    DrawChannelNumbers

                Mov     AL, 80          ; HostChannelSize
                Mul     Byte Ptr [CS:BP+2]
                Call    Music_GetHostChannelInformationTable
                        Assume DS:Nothing
                Add     SI, AX
                Mov     DI, [CS:BP+6]
                Add     DI, (31+1*80)*2
                Mov     CX, [CS:BP+4]
                Sub     CX, 2

Display_HostChannel5:                           ; Show vol and sample.
                Push    CX
                Push    DI

                Test    Byte Ptr [SI], 4
                JZ      Display_HostChannel6

                Mov     BX, [SI+24h]            ; DS:BX = slave channel

                                                ; OK get sample number
;                Mov     AL, [SI+20h]

                Push    DI

                Push    SI
                Push    DS

                Push    DI

                MovZX   AX, Byte Ptr [BX+36h]
                Inc     AX
                Mov     DH, 10
                Div     DH
                Add     AX, 3030h               ; '0'+'0'
                Cmp     AL, '9'
                JBE     SampleNumRange1

                Mov     AX, '--'

SampleNumRange1:
                Mov     DL, AH
                Mov     AH, 6
                StosW
                Mov     AL, DL
                StosW

                Call    Music_GetInstrumentMode
                JZ      Display_HostChannel23

                MovZX   AX, Byte Ptr [BX+33h]             ; Instrument number
                Cmp     AL, 0FFh
                JE      Display_HostChannel23

                Div     DH
                Add     AX, 3030h
                Mov     DX, AX

                Mov     AX, 6*256+'/'
                StosW

                Mov     AL, DL
                StosW
                Mov     AL, DH
                StosW

Display_HostChannel23:
                Mov     AX, 7*256+':'
                Test    Byte Ptr [BX], 4                ; Note off???
                JNZ     Display_HostChannel31

                Mov     AH, 6

Display_HostChannel31:
                Cmp     Byte Ptr [BX+20h], 0
                JNE     Display_HostChannel7

                Mov     AH, 4

Display_HostChannel7:
                StosW
                MovZX   AX, Byte Ptr [BX+36h]
                Add     AX, AX
                Mov     SI, AX
                Mov     DX, [BX+30h]

                Call    Music_GetSongSegment
                Mov     DS, AX

                Mov     SI, [DS:SI+64912]
                Add     SI, 14h

                Mov     AH, 6
                Mov     CX, 25

                Test    Byte Ptr [DS:2Ch], 4     ; Instrument mode?
                JZ      Display_HostChannel8
                Cmp     CS:Instrument, 0
                JE      Display_HostChannel8

                LEA     SI, [EDX+20h]

Display_HostChannel8:
                LodsB
                Cmp     AL, 226
                JB      AvoidMouse1

                Mov     AL, ' '

AvoidMouse1:
                StosW
                Loop    Display_HostChannel8

                                                ; Show string...
                                                ; Now show panning if applic
                Pop     DI

                Test    Byte Ptr [DS:2Ch], 1    ; Stereo
                JZ      Display_HostChannel24

                Pop     DS
                Pop     SI

                Push    SI
                Push    DS

                Add     DI, 33*2
                                                ; Show panning.
                MovZX   AX, Byte Ptr [BX+25h]
;                Mov     AL, [DS:SI+2Eh]
                Cmp     AL, 100
                JE      Display_HostChannel25
;                Test    AL, 80h                ; Should never occur
;                JNZ     Display_HostChannel24

                And     AL, AL
                JZ      Display_HostChannel29
                Cmp     AL, 64
                JE      Display_HostChannel30

                                                ; Show thumb bar sorta thing.
                Inc     AX
                Mov     DX, AX
                ShR     DX, 3
                Add     DX, DX
                Add     DI, DX
                And     AX, 7
                Add     AX, 155
                Mov     AH, 2
                StosW

                Cmp     AL, 157
                JBE     Display_HostChannel24
                Add     AL, 5
                StosW

                Jmp     Display_HostChannel24

Display_HostChannel29:
                Mov     SI, Offset LeftMsg
                Jmp     Display_HostChannel28

Display_HostChannel30:
                Mov     SI, Offset RightMsg
                Jmp     Display_HostChannel28

Display_HostChannel25:
                Mov     SI, Offset SurroundMsg

Display_HostChannel28:
                Push    CS
                Pop     DS
                Mov     CX, 9
                Mov     AH, 2

Display_HostChannel26:
                LodsB
                StosW
                Loop    Display_HostChannel26

Display_HostChannel24:
                Pop     DS
                Push    DS

                Mov     AL, 255
                Cmp     CS:Velocity, 0
                JNZ     Display_HostChannel10
                Cmp     Byte Ptr [BX+36h], 100
                JE      Display_HostChannel10

;                Test    Byte Ptr [BX+1], 8
;                JNZ     Display_HostChannel18   ; Don't display volume

                Mov     EDX, [BX+2Ch]            ; Initial offset.
                Mov     ECX, [BX+4Ch]            ; Final offset

                And     EDX, EDX
                JNS     Display_HostChannelPP1

                Xor     EDX, EDX

Display_HostChannelPP1:
                And     ECX, ECX
                JNS     Display_HostChannelPP2

                Xor     ECX, ECX

Display_HostChannelPP2:
                Cmp     Byte Ptr [BX+0Ah], 8
                JB      Display_HostChannel9    ; No loop

Comment ~
                Mov     AL, [BX+0Bh]
                And     AL, 7Fh
                Cmp     AL, 2
                JB      NoSampleLoop

                Mov     ECX, [BX+40h]
                Mov     EDX, [BX+44h]
                Jmp     Display_HostChannel20

NoSampleLoop:
                Cmp     Byte Ptr [BX+0Ah], 8
~
                JE      Display_HostChannel19   ; Normal loop

                                                ; Ping pong!
                Cmp     ECX, EDX
                JA      Display_HostChannel9
                XChg    ECX, EDX
                Jmp     Display_HostChannel9

Display_HostChannel19:                          ; Forwards loop!
                Cmp     ECX, EDX
                JAE     Display_HostChannel9
                Mov     ECX, [BX+44h]

Display_HostChannel9:
                Sub     ECX, EDX
                JBE     Display_HostChannel18

Display_HostChannel20:
                Test    Byte Ptr [BX+18h], 2
                PushF
                JZ      Display_HCNoDouble

                Add     ECX, ECX
                Add     EDX, EDX

Display_HCNoDouble:
                MovZX   AX, Byte Ptr [BX+36h]
                Inc     AX

                Push    ECX
                Xor     CX, CX
                Call    Music_GetSampleLocation
                Pop     ECX
                Add     ESI, EDX

                PopF
                Push    BX
                Mov     BX, 1
                JZ      Display_HostChannel8Bit

                Xor     DX, DX
                ShR     ECX, 1
                JZ      Display_HostChannelError
                Or      ESI, 1
                Inc     BX

Display_HostChannel8Bit:
                Int     3

                Mov     DL, [SI]
                Mov     DH, DL                  ; DL = min, DH = max.

Display_HostChannel11:
                Mov     AL, [SI]
                Add     SI, BX
                JC      Display_HostChannelNewSegment

Display_HostChannelResume:
                Cmp     DH, AL
                JL      Display_HostChannel12

                Cmp     DL, AL
                JG      Display_HostChannel13

Display_HostChannel14:
                Loop    Display_HostChannel11

                Pop     BX

                Mov     AL, DH
                Sub     AL, DL
                Jmp     Display_HostChannel10

Display_HostChannel13:
                Mov     DL, AL
                Jmp     Display_HostChannel14

Display_HostChannel12:
                Mov     DH, AL
                Jmp     Display_HostChannel14

Display_HostChannelNewSegment:
                Add     ESI, 10000h
                Int     3
                Jmp     Display_HostChannelResume

Display_HostChannelError:
                Pop     BX

Display_HostChannel18:                          ; AL = volume.
                Mov     AL, 0

Display_HostChannel10:                          ; AL = volume.
                Pop     DS
                Pop     SI

                Mul     Byte Ptr [BX+20h]       ; Final volume!
                ShR     AH, 1
                AdC     AH, 0                   ; AH = volume to show.

                Pop     DI
                Sub     DI, 26*2                ; ES:DI points to vol deposit
                Mov     DH, AH
                And     DH, 7
                ShR     AH, 3
                Mov     CL, AH

                Mov     AH, 5

                Test    Word Ptr [BX], 800h
                JZ      Display_HostChannelNotMuted

                Mov     AH, 1

Display_HostChannelNotMuted:
                And     CL, CL
                JZ      Display_HostChannel16

Display_HostChannel15:
                Mov     AL, 176
                StosW
                Mov     AL, 179
                StosW
                Mov     AL, 182
                StosW

                Dec     CL
                JNZ     Display_HostChannel15

Display_HostChannel16:                  ; DH contains remainder.
                And     DH, DH
                JZ      Display_HostChannel6

                Cmp     DH, 3
                JBE     Display_HostChannel17

                Mov     AL, 176
                StosW

                Cmp     DH, 5
                JBE     Display_HostChannel17

                Mov     AL, 179
                Inc     DH
                StosW

Display_HostChannel17:
                Mov     AL, 173
                Add     AL, DH
                StosW

Display_HostChannel6:
                Pop     DI
                Pop     CX
                Add     DI, 160
                Add     SI, HOSTCHANNELSIZE
                Loop    Display_HostChannel5

                Ret

EndP            Display_HostChannel
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Draw10Num

                Mov     CX, 10
                Mov     EBP, 10

Draw10Num1:
                Xor     EDX, EDX
                Div     EBP

                Add     DX, '0'+2*256
                Sub     DI, 2
                Mov     [ES:DI], DX

                And     EAX, EAX

                LoopNZ  Draw10Num1

                Add     CX, CX
                Sub     DI, CX

                Ret

EndP            Draw10Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Draw2Num

                Xor     AH, AH
                Mov     DL, 10
                Div     DL
                Add     AX, 3030h
                Mov     DL, AH
                Mov     AH, 2
                StosW
                Mov     AL, DL
                StosW

                ScasW
;                Add     DI, 2

                Ret

EndP            Draw2Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Draw3Num

                Cmp     AH, 10
                JB      Draw3Num1

                Xor     AX, AX

Draw3Num1:
                Mov     DL, 10
                Div     DL
                Mov     DH, AH
                Xor     AH, AH
                Div     DL
                Add     AX, 3030h
                Mov     DL, AH
                Mov     AH, 2
                StosW
                Mov     AL, DL
                StosW
                Mov     AL, DH
                Add     AL, 30h
                StosW

                ScasW
;                Add     DI, 2

                Ret

EndP            Draw3Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Display_Details
                                                ; Draw boxes first.
                                Assume DS:InfoPage

                Mov     ES, Destination

                Mov     AX, 4                   ; left
                Push    AX
                Mov     AL, [CS:BP+3]
                Inc     AX
                Push    AX
                Push    30
                Add     AX, [CS:BP+4]
                Sub     AX, 2
                Push    AX
                Push    27
                Call    S_DrawBox

                Mov     SI, SP
                Mov     Byte Ptr [SS:SI+4], 57
                Mov     Byte Ptr [SS:SI+8], 31
                Call    S_DrawBox

                Push    DS
                Call    Music_GetSongSegment
                Mov     DS, AX
                Test    Byte Ptr [DS:2Ch], 4
                Pop     DS
                JZ      Display_Details27

                Mov     Byte Ptr [SS:SI+4], 66
                Mov     Byte Ptr [SS:SI+8], 58
                Call    S_DrawBox

                Mov     DI, [CS:BP+6]
                Add     DI, 118+160
                Mov     SI, Offset VirtualMsg
                Mov     AH, 12h
                Call    S_DrawString

Display_Details27:
                Mov     DI, [CS:BP+6]
                Add     DI, 12+160
                Mov     SI, Offset DetailsMsg
                Mov     AH, 12h
                Call    S_DrawString

                Add     SP, 10

                Mov     DX, CurrentChannel
                MovZX   BX, Byte Ptr [CS:BP+2]
                Cmp     DX, BX
                JAE     Display_Details1

                Mov     BX, DX

Display_Details1:
                LEA     CX, [EDX+4]
                Sub     CX, [CS:BP+4]
                Cmp     BX, CX
                JGE     Display_Details2

                Mov     BX, CX

Display_Details2:
                Mov     CX, 67
                Sub     CX, [CS:BP+4]
                Cmp     BX, CX
                JL      Display_Details22

                Mov     BX, 67
                Sub     BX, [CS:BP+4]

Display_Details22:
                Mov     [CS:BP+2], BL                   ; BL = top channel

                Mov     CH, 0Ah
                Mov     CL, [CS:BP+4]
                Sub     CL, 3
                Mov     DI, [CS:BP+6]
                Add     DI, (2+2*80)*2

                Call    Music_GetSongSegment
                Mov     DS, AX
                        Assume DS:Nothing

Display_Details3:
                Push    CX
                Push    DI

                Mov     AX, BX
                Inc     AX
                Div     CH

                Add     AX, '00'

                Mov     DH, AH

                Mov     AH, 23h
                Cmp     DL, BL
                JE      Display_Details4

                Test    Byte Ptr [BX+40h], 80h
                JNZ     Display_Details21

                Mov     AH, 21h
                Mov     CX, ProcessWindow
                Cmp     CX, CurrentWindow
                JE      Display_Details4

                Mov     AH, 20h
                Jmp     Display_Details32

Display_Details4:
                Test    Byte Ptr [BX+40h], 80h
                JZ      Display_Details32

                Mov     AH, 26h

Display_Details32:
                StosW
                Mov     AL, DH
                StosW

Display_Details21:
                Inc     BX

                Pop     DI
                Pop     CX
                Add     DI, 160

                Dec     CL
                JNZ     Display_Details3

                Mov     AL, 80          ; HostChannelSize
                Mul     Byte Ptr [CS:BP+2]
                Call    Music_GetHostChannelInformationTable
                        Assume DS:Nothing
                Add     SI, AX
                Mov     DI, [CS:BP+6]
                Add     DI, (15+2*80)*2
                Mov     CX, [CS:BP+4]
                Sub     CX, 3

Display_Details5:                           ; Show vol and sample.
                Push    CX
                Push    SI
                Push    DI

                                        ; Draw in divisions.
                Mov     AX, 2A8h
                Mov     Word Ptr [ES:DI], AX
                Mov     Word Ptr [ES:DI+22], AX
                Mov     Word Ptr [ES:DI+40], AX
                Mov     Word Ptr [ES:DI+46], AX
                Mov     Word Ptr [ES:DI+52], AX
                Mov     Word Ptr [ES:DI+58], AX
                Mov     Word Ptr [ES:DI+64], AX
                Mov     Word Ptr [ES:DI+72], AX
                Mov     Word Ptr [ES:DI+78], AX

                ClI

                Test    Byte Ptr [SI], 4
                JNZ     Display_Details6

                Add     DI, 88

                Jmp     Display_Details72

Display_Details6:
                Mov     BX, [SI+24h]    ; DS:BX points to virtual channel.
                Mov     EAX, [BX+10h]
                Call    Draw10Num

                Add     DI, 42
                Mov     EAX, [BX+4Ch]
                Call    Draw10Num

                Add     DI, 22
                Xor     AH, AH
                Mov     AL, [BX+36h]
                Inc     AX                      ; Sample..
                Call    Draw3Num

;                Add     DI, 2
                ScasW
                Xor     AH, AH
                Mov     AL, [BX+20h]            ; Final vol
                Call    Draw3Num

                Mov     AL, [BX+21h]            ; Vol
                Call    Draw2Num

                Mov     AL, [BX+23h]            ; CV
                Call    Draw2Num

                Mov     AL, [BX+24h]            ; SV
                ShR     AL, 1
                Call    Draw2Num

                Mov     AL, [BX+52h]            ; VE
                Call    Draw2Num

                Mov     AX, [BX+26h]            ; Fade
                ShR     AX, 1
                Call    Draw3Num

                Mov     AL, [BX+25h]            ; Pan
                Cmp     AL, 100
                JE      Display_Details13

                Call    Draw2Num

                Jmp     Display_Details7

Display_Details13:
                Mov     AX, 'S'+2*256
                StosW
                Mov     AL, 'u'
                StosW
;                Add     DI, 2
                ScasW

Display_Details7:
                Mov     AL, [BX+62h]            ; PE
                Add     AL, 32
                Call    Draw2Num

;                Add     DI, 2
                ScasW

Display_Details72:
                Push    DS
                Call    Music_GetSongSegment
                Mov     DS, AX
                Test    Byte Ptr [DS:2Ch], 4
                Pop     DS
                JZ      Display_Details8

                Mov     Word Ptr [ES:DI+6], 2A8h

                Test    Byte Ptr [SI], 4
                JNZ     Display_Details9

                Mov     AX, '-'+2*256
                StosW
                StosW
                StosW

                Jmp     Display_Details10

Display_Details9:
                Push    SI

                Mov     SI, [BX+3Bh]            ; NNA
                And     SI, 0FFh
                ShL     SI, 2
                Mov     AH, 2
                Mov     AL, [CS:NNAMsg+SI]
                StosW
                Mov     AL, [CS:NNAMsg+SI+1]
                StosW
                Mov     AL, [CS:NNAMsg+SI+2]
                StosW

                Pop     SI

Display_Details10:                              ; Time to count channels.
                Mov     AH, [SI+20h]

;                Add     DI, 2
                ScasW
                Call    Music_GetSlaveChannelInformationTable

                Xor     AL, AL                  ; AL = count.

Display_Details11:
                Mov     DL, [SI+3Ah]
                And     DL, 7Fh
                Cmp     AH, DL
                JNE     Display_Details12

                Test    Byte Ptr [SI], 1
                JZ      Display_Details12

                Inc     AX

Display_Details12:
                Add     SI, SLAVECHANNELSIZE
                Loop    Display_Details11

                Xor     AH, AH
                Call    Draw3Num

Display_Details8:
                StI

                Pop     DI
                Pop     SI
                Pop     CX
                Add     DI, 160
                Add     SI, HOSTCHANNELSIZE
                Loop    Display_Details5

                Ret

EndP            Display_Details
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LoadNextData            ; Returns DS:SI to data. (unpacked)
                Assume DS:InfoPage

                Mov     BX, DecodePattern
                Cmp     BX, PatternArrayNumber
                JE      LoadNextData1

                Push    DI

                Push    CS
                Pop     ES
                Mov     DI, Offset DataArray
                Mov     CX, 64

LoadNextData3:
                Mov     AX, 0FDh
                StosW
                Mov     AL, 0FFh
                StosB
                Xor     AL, AL
                StosW
                Loop    LoadNextData3

                Cmp     BX, 0FFFFh
                JNE     LoadNextData2

                Pop     DI
                Mov     SI, Offset DataArray
                Ret

LoadNextData2:
                                                ; OK... time to decode.
                Mov     SI, DecodeOffset
                Mov     DS, DecodeSegment
                        Assume DS:Nothing

LoadNextData4:
                LodsB
                And     AL, AL
                JZ      LoadNextData5

                Mov     DL, AL
                And     AL, 7Fh
                Dec     AX
                Mov     DH, AL

                Mov     AH, 6
                Mul     AH
                Mov     BX, AX
                Add     BX, Offset DataDecode

                Mov     AL, 5
                Mul     DH
                Mov     DI, AX
                Add     DI, Offset DataArray

                Mov     AH, [CS:BX]
                Test    DL, 80h
                JZ      LoadNextData6

                LodsB
                Mov     AH, AL
                Mov     [CS:BX], AL

LoadNextData6:
                Test    AH, 1
                JZ      LoadNextData7

                LodsB
                Mov     [CS:BX+1], AL
                Jmp     LoadNextData8

LoadNextData7:
                Test    AH, 10h
                JZ      LoadNextData9

                Mov     AL, [CS:BX+1]

LoadNextData8:
                Mov     [CS:DI], AL             ; Note

LoadNextData9:
                Test    AH, 2
                JZ      LoadNextData10

                LodsB
                Mov     [CS:BX+2], AL
                Jmp     LoadNextData11

LoadNextData10:
                Test    AH, 20h
                JZ      LoadNextData12

                Mov     AL, [CS:BX+2]

LoadNextData11:
                Mov     [CS:DI+1], AL           ; Instrument

LoadNextData12:
                Test    AH, 4
                JZ      LoadNextData13

                LodsB
                Mov     [CS:BX+3], AL
                Jmp     LoadNextData14

LoadNextData13:
                Test    AH, 40h
                JZ      LoadNextData15

                Mov     AL, [CS:BX+3]

LoadNextData14:
                Mov     [CS:DI+2], AL           ; Volume

LoadNextData15:
                Test    AH, 8
                JZ      LoadNextData16

                LodsW
                Mov     [CS:BX+4], AX
                Mov     [CS:DI+3], AX
                Jmp     LoadNextData4

LoadNextData16:
                Test    AH, 80h
                JZ      LoadNextData4

                Mov     AX, [CS:BX+4]
                Mov     [CS:DI+3], AX
                Jmp     LoadNextData4

LoadNextData5:
                Push    CS
                Pop     DS
                        Assume DS:InfoPage

                Mov     DecodeOffset, SI

                Mov     SI, Offset DataArray

                Pop     DI
                Ret

LoadNextData1:
                Mov     SI, DecodeOffset
                Add     DecodeOffset, 320
                Mov     DS, PatternSegment
                        Assume DS:Nothing

                Ret

EndP            LoadNextData

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GotoRow                         ; DS:SI points to data.

                Push    CX


                Mov     CX, CS:DecodeRow
                Inc     CX

GotoRow1:
                Dec     CX
                JZ      GotoRow2

GotoRow3:
                LodsB
                And     AL, AL
                JZ      GotoRow1

                Mov     DL, AL
                And     AL, 7Fh
                Dec     AX
                Mov     AH, 6
                Mul     AH
                Mov     BX, AX
                Add     BX, Offset DataDecode

                Mov     DH, [CS:BX]             ; Mask.
                Test    DL, 80h
                JZ      GotoRow4

                LodsB
                Mov     DH, AL
                Mov     [CS:BX], AL             ; Mask

GotoRow4:
                Test    DH, 1
                JZ      GotoRow5

                LodsB
                Mov     [CS:BX+1], AL   ; Note

GotoRow5:
                Test    DH, 2
                JZ      GotoRow6

                LodsB
                Mov     [CS:BX+2], AL   ; Instrument

GotoRow6:
                Test    DH, 4
                JZ      GotoRow7        ; Volume

                LodsB
                Mov     [CS:BX+3], AL

GotoRow7:
                Test    DH, 8
                JZ      GotoRow3

                LodsW
                Mov     [CS:BX+4], AX
                Jmp     GotoRow3

GotoRow2:
                Mov     CS:DecodeSegment, DS
                Mov     CS:DecodeOffset, SI

                Pop     CX
                Ret

EndP            GotoRow

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetBeforeRows                   ; Returns
                                                ; CX = number of rows to show.
                                                ; the row numbers are handled.
                                                ; Initialises DataSegment,
                                                ; DataOffset and Array.
                        Assume DS:InfoPage

                Xor     CX, CX
                Mov     BX, CurrentRow
                Mov     AX, [CS:BP+4]
                Sub     AX, 4
                ShR     AX, 1
                Sub     BX, AX
                JC      GetBeforeRows2

                Ret                             ; No rows to show!

GetBeforeRows2:
                Mov     CX, BX
                Neg     CX                      ; CX = num of rows to show

                Cmp     PlayMode, 1
                JE      GetBeforeRows1
                                                ; Song..
                Mov     BX, CurrentOrder
                Test    BX, BX
                JZ      GetBeforeRows3

                Call    Music_GetSongSegment
                Mov     ES, AX
                MovZX   AX, Byte Ptr [ES:BX+100h-1]
                Cmp     AL, 199
                JBE     GetBeforeRows4

GetBeforeRows3:
                Mov     DecodePattern, 0FFFFh
                Ret

GetBeforeRows1:                                 ; Pattern...
                Mov     AX, CurrentPattern

GetBeforeRows4:
                Mov     DecodePattern, AX       ; Now find offset.
                Cmp     AX, PatternArrayNumber  ; CX = num rows to show
                JNE     GetBeforeRows5

                Mov     BX, PatternMaxRow
                Sub     BX, CX
                Mov     DecodeRow, BX
                Mov     AX, 320
                Mul     BX
                Mov     DecodeOffset, AX
                Jmp     GetBeforeRows6

GetBeforeRows5:
                Call    Music_GetPattern
                        Assume DS:Nothing
                LodsW
                LodsW
                                        ; AX = rows.
                Sub     AX, CX
                Mov     CS:DecodeRow, AX
                Add     SI, 4
                Call    GotoRow

GetBeforeRows6:                         ; Put numbers on screen.
                Push    CS
                Pop     DS

                JCXZ    GetBeforeRows9

                Push    CX
                Push    DI

GetBeforeRows7:
                Mov     AX, DecodeRow
                Mov     ES, Destination

GetBeforeRows8:
                Push    CX

                Mov     CH, 20h
                Call    PE_ConvAX2Num

                Pop     CX
                Inc     AX
                Add     DI, 160
                Loop    GetBeforeRows8

                Pop     DI
                Pop     CX

GetBeforeRows9:
                Ret

EndP            GetBeforeRows

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetAfterRows                   ; Returns
                        Assume DS:InfoPage

                Xor     CX, CX
                Mov     BX, DecodeMaxRow
                Mov     AX, [CS:BP+4]
                Sub     AX, 3
                Mov     DX, AX
                Dec     AX
                ShR     AX, 1
                Sub     DX, AX
                Add     DX, CurrentRow

                Sub     BX, DX
                JC      GetAfterRows2

                Ret                             ; No rows to show!

GetAfterRows2:
                Mov     CX, BX
                Neg     CX

                Cmp     PlayMode, 1
                JE      GetAfterRows1

                                                ; Song..
                Mov     BX, CurrentOrder
                Cmp     BX, 255
                JAE     GetAfterRows3

                Call    Music_GetSongSegment
                Mov     ES, AX
                MovZX   AX, Byte Ptr [ES:BX+101h]
                Cmp     AL, 199
                JBE     GetAfterRows4

GetAfterRows3:
                Mov     DecodePattern, 0FFFFh
                Ret

GetAfterRows1:                                 ; Pattern...
                Mov     AX, CurrentPattern

GetAfterRows4:
                Mov     DecodePattern, AX       ; Now find offset.
                Mov     DecodeRow, 0

                Cmp     AX, PatternArrayNumber  ; CX = num rows to show
                JNE     GetAfterRows5

                Mov     DecodeOffset, 0
                Jmp     GetAfterRows6

GetAfterRows5:
                Call    Music_GetPattern
                        Assume DS:Nothing
                Add     SI, 8
                Mov     CS:DecodeSegment, DS

                Push    CS
                Pop     DS
                        Assume DS:InfoPage

                Mov     DecodeOffset, SI

GetAfterRows6:                         ; Put numbers on screen.
                JCXZ    GetAfterRows9

                Push    CX
                Push    DI

GetAfterRows7:
                Mov     AX, DecodeRow
                Mov     ES, Destination

GetAfterRows8:
                Push    CX

                Mov     CH, 20h
                Call    PE_ConvAX2Num

                Pop     CX
                Inc     AX
                Add     DI, 160
                Loop    GetAfterRows8

                Pop     DI
                Pop     CX

GetAfterRows9:
                Ret

EndP            GetAfterRows

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetCurrentPatternRows           ; Returns CX = number of rows to show.
                        Assume DS:InfoPage

                Mov     BX, CurrentRow
                Mov     AX, [CS:BP+4]
                Sub     AX, 3

                Mov     CX, AX
                Dec     AX
                ShR     AX, 1
                Sub     CX, AX

                Add     CX, BX                  ; CX = final row.
                Sub     BX, AX
                JNC     GetCurrentPatternRows2

                Xor     BX, BX
                                                ; BX = starting row.

GetCurrentPatternRows2:
                Mov     AX, CurrentPattern

                Mov     DecodeRow, BX
                Mov     DecodePattern, AX       ; Now find offset.
                Cmp     AX, PatternArrayNumber  ; BX = starting row, CX = final row.
                JNE     GetCurrentPatternRows5

                Mov     AX, PatternMaxRow
                Mov     DecodeMaxRow, AX
                Cmp     CX, AX
                JBE     GetCurrentPatternRows1

                Mov     CX, AX

GetCurrentPatternRows1:
                Mov     AX, 320
                Mul     BX
                Mov     DecodeOffset, AX
                Sub     CX, BX                  ; CX = number of rows.
                Jmp     GetCurrentPatternRows6

GetCurrentPatternRows5:
                Call    Music_GetPattern
                        Assume DS:Nothing
                LodsW
                LodsW
                                        ; AX = number of rows.
                Mov     DecodeMaxRow, AX

                Cmp     CX, AX
                JBE     GetCurrentPatternRows3

                Mov     CX, AX

GetCurrentPatternRows3:
                Sub     CX, BX
                Add     SI, 4
                Call    GotoRow

GetCurrentPatternRows6:                         ; Put numbers on screen.
                Push    CS
                Pop     DS

                Push    CX
                Push    DI

GetCurrentPatternRows7:
                Mov     AX, DecodeRow
                Mov     ES, Destination

GetCurrentPatternRows8:
                Push    CX

                Mov     CH, 20h
                Call    PE_ConvAX2Num

                Pop     CX
                Inc     AX
                Add     DI, 160
                Loop    GetCurrentPatternRows8

                Pop     DI
                Pop     CX
                Ret

EndP            GetCurrentPatternRows

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DrawHilightBar

                Mov     DI, [CS:BP+6]
                Mov     AX, [CS:BP+4]
                ShR     AX, 1
                Mov     AH, 160
                Mul     AH
                Add     DI, AX
                Add     DI, 11

DrawHilightBar1:
                Or      Byte Ptr [ES:DI], 0E0h
;                Add     DI, 2
                ScasW
                Dec     CX
                JNZ     DrawHilightBar1

                Ret

EndP            DrawHilightBar

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayTrackData

                Cmp     PlayMode, 0
                JNE     DisplayTrackData1

                Pop     AX                      ; Pull off return address
                Ret

DisplayTrackData1:
                        ; Check if row is OK.

                        ; Now check for early block

                Mov     DI, [CS:BP+6]
                Add     DI, (1+2*80)*2

                Call    GetBeforeRows
                JCXZ    DisplayTrackData3

DisplayTrackData2:
                Push    CX
                Push    DI
                Push    DS

                Call    LoadNextData    ; Gets DS:SI
                Call    [CS:DrawTrackData]

                Pop     DS
                Pop     DI
                Pop     CX
                Add     DI, 160
                Dec     CX
                JNZ     DisplayTrackData2

DisplayTrackData3:
                Call    GetCurrentPatternRows

DisplayTrackData4:
                Push    CX
                Push    DI
                Push    DS

                Call    LoadNextData    ; Gets DS:SI
                Call    [CS:DrawTrackData]

                Pop     DS
                Pop     DI
                Pop     CX
                Add     DI, 160
                Dec     CX
                JNZ     DisplayTrackData4

                Call    GetAfterRows
                JCXZ    DisplayTrackData6

DisplayTrackData5:
                Push    CX
                Push    DI
                Push    DS

                Call    LoadNextData    ; Gets DS:SI
                Call    [CS:DrawTrackData]

                Pop     DS
                Pop     DI
                Pop     CX
                Add     DI, 160
                Dec     CX
                JNZ     DisplayTrackData5

DisplayTrackData6:
                Ret

EndP            DisplayTrackData

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Show5Channel

                Mov     AL, [CS:BP+2]
                Mov     AH, 5
                Mul     AH
                Add     SI, AX                  ; DS:SI points to stuff.

                Mov     CX, 0A05h
                Mov     ES, Destination
                Add     DI, 8

Show5Channel1:
                LodsB
                Cmp     AL, 119
                JBE     Show5Channel2

                Mov     AH, AL
                Mov     AL, 205

                Cmp     AH, 0FFh
                JE      Show5Channel3

                Mov     AL, '^'
                Cmp     AH, 0FEh
                JE      Show5Channel3

                Mov     AL, 173                 ; '.'

Show5Channel3:
                Mov     AH, 6
                StosW
                StosW
                StosW
                Jmp     Show5Channel4

Show5Channel2:                                  ; Show note.
                AAM     12
                                                ; AL = octave
                                                ; AH = note.
                Mov     DX, AX
                MovZX   BX, AL
                Add     BX, BX
                Mov     AH, 6
                Mov     AL, [CS:BX+NoteTable]
                StosW
                Mov     AL, [CS:BX+NoteTable+1]
                StosW
                Mov     AL, DH
                Add     AL, 30h
                StosW

Show5Channel4:                                  ; Show ins.
;                Add     DI, 2
                ScasW
                LodsB

                Test    AL, AL
                JZ      Show5Channel5

                Xor     AH, AH
                Div     CH
                Add     AX, 3030h
                Mov     DL, AH
                Mov     AH, 6
                StosW
                Mov     AL, DL
                StosW

                Jmp     Show5Channel6

Show5Channel5:
                Mov     AL, 173
                StosW
                StosW

Show5Channel6:                                  ; show vol
;                Add     DI, 2
                ScasW
                LodsB
                Cmp     AL, 0FFh
                JE      Show5Channel7

                Mov     AH, AL
                And     AH, 7Fh
                Sub     AH, 65
                JC      Show5ChannelNoVEffect

                Test    AL, 80h
                JZ      Show5ChannelVEffect

                Add     AH, 60

Show5ChannelVEffect:
                Mov     AL, AH
                Xor     AH, AH
                Div     CH
                                        ; AL = effect, AH = num
                Add     AX, 'A'+'0'*256
                Mov     DL, AH
                Mov     AH, 6
                StosW
                Mov     AL, DL
                StosW

                Jmp     Show5Channel8

Show5ChannelNoVEffect:
                Mov     DL, 6
                Test    AL, 80h
                JZ      Show5Channel10

                Mov     DL, 2
                And     AL, 7Fh

Show5Channel10:
                Xor     AH, AH
                Div     CH
                Add     AX, 3030h
                XChg    DL, AH
                StosW
                Mov     AL, DL
                StosW

                Mov     AH, 6
                Jmp     Show5Channel8

Show5Channel7:
                Mov     AL, 173
                StosW
                StosW

Show5Channel8:
;                Add     DI, 2
                ScasW
                LodsB
                And     AL, AL
                JNZ     Show5Channel9

                Mov     AL, '.'-'@'

Show5Channel9:
                Add     AL, '@'
                StosW                           ; Command

                LodsB                           ; Commandvalue.
                Mov     AH, AL
                And     AX, 0FF0h
                Mov     DL, AH
                ShR     AL, 4

                Mov     AH, 6
                Call    DrawHexAL

                Mov     AL, DL
                Call    DrawHexAL

                Dec     CL
                JZ      Show5ChannelEnd

                Mov     AX, 2A8h
                StosW

                Jmp     Show5Channel1

Show5ChannelEnd:
                Ret

EndP            Show5Channel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Display_5Channel
                        Assume DS:InfoPage

                Mov     AX, 4                   ; left
                Push    AX
                Mov     AL, [CS:BP+3]
                Inc     AX
                Push    AX
                Push    74
                Add     AX, [CS:BP+4]
                Sub     AL, 2
                Push    AX
                Push    27
                Call    S_DrawBox

                Add     SP, 10
                                                ; Fill in text.
                                                ; check boundaries.
                Mov     DX, CurrentChannel
                MovZX   BX, Byte Ptr [CS:BP+2]
                Cmp     DX, BX
                JAE     Display_5Channel2

                Mov     BX, DX

Display_5Channel2:
                Mov     CX, DX
                Sub     CX, 4
                Cmp     BX, CX
                JGE     Display_5Channel3

                Mov     BX, CX

Display_5Channel3:
                Cmp     BX, 59
                JB      Display_5Channel11

                Mov     BX, 59

Display_5Channel11:
                Mov     [CS:BP+2], BL           ; top channel.
                                                ; Now do channel msgs.

                Mov     CX, 0A05h
                Mov     DI, [CS:BP+6]
                Add     DI, (5+1*80)*2
                Mov     SI, Offset Channel5Msg

Display_5Channel4:
                MovZX   AX, BL
                Inc     AX
                Div     CH
                Add     AX, 3030h
                Mov     [SI+9], AX

                Call    GetChannelColour
                Call    S_DrawString

                Add     DI, 4

                Inc     BX
                Dec     CL
                JNZ     Display_5Channel4

                Mov     [CS:DrawTrackData], Offset Show5Channel
                Call    DisplayTrackData
                Mov     CX, 69
                Call    DrawHilightBar

                Ret

EndP            Display_5Channel
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Show8Channel

                Mov     AL, [CS:BP+2]
                Mov     AH, 5
                Mul     AH
                Add     SI, AX                  ; DS:SI points to stuff.

                Mov     CX, 0A08h
                Mov     ES, Destination
                Add     DI, 8

Show8Channel1:
                LodsW
                Cmp     AL, 119
                JBE     Show8Channel2

                Mov     AH, AL
                Mov     AL, 205

                Cmp     AH, 0FFh
                JE      Show8Channel3

                Mov     AL, '^'
                Cmp     AH, 0FEh
                JE      Show8Channel3

                Mov     AL, 173                 ; '.'

Show8Channel3:
                Mov     AH, 6
                StosW
                StosW
                StosW
                Jmp     Show8Channel4

Show8Channel2:                                  ; Show note.
                AAM     12

                Mov     DX, AX
                MovZX   BX, AL
                Add     BX, BX
                Mov     AH, 6
                Mov     AL, [CS:BX+NoteTable]
                StosW
                Mov     AL, [CS:BX+NoteTable+1]
                StosW
                Mov     AL, DH
                Add     AL, 30h
                StosW

Show8Channel4:                                  ; Show vol.
                LodsB
                Cmp     AL, 0FFh
                JE      Show8Channel5

                Mov     AH, AL
                And     AH, 7Fh
                Sub     AH, 65
                JC      Show8ChannelNoVEffect

                Test    AL, 80h
                JZ      Show8ChannelVEffect

                Add     AH, 60

Show8ChannelVEffect:
                Mov     AL, AH
                Xor     AH, AH
                Div     CH
                                        ; AL = effect, AH = num
                Add     AX, 'A'+'0'*256
                Mov     DL, AH
                Mov     AH, 2
                StosW
                Mov     AL, DL
                StosW

                Jmp     Show8Channel6

Show8ChannelNoVEffect:
                Mov     DL, 2
                Test    AL, 80h
                JZ      Show8Channel10

                Dec     DL
                And     AL, 7Fh

Show8Channel10:
                Xor     AH, AH
                Div     CH
                Add     AX, 3030h
                XChg    DL, AH
                StosW
                Mov     AL, DL
                StosW

                Jmp     Show8Channel6

Show8Channel5:
                Add     DI, 4

Show8Channel6:
                LodsB
                And     AL, AL
                JNZ     Show8Channel9

                Mov     AL, '.'-'@'

Show8Channel9:
                Add     AL, '@'
                Mov     AH, 6
                StosW                           ; Command

                LodsB                           ; Commandvalue.
                Mov     AH, AL
                And     AX, 0FF0h
                Mov     DL, AH
                ShR     AL, 4

                Mov     AH, 6
                Call    DrawHexAL

                Mov     AL, DL
                Call    DrawHexAL

                Dec     CL
                JZ      Show8ChannelEnd

                Mov     AX, 2A8h
                StosW

                Jmp     Show8Channel1

Show8ChannelEnd:
                Ret

EndP            Show8Channel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Display_8Channel
                        Assume DS:InfoPage

                Mov     AX, 4                   ; left
                Push    AX
                Mov     AL, [CS:BP+3]
                Inc     AX
                Push    AX
                Push    76
                Add     AX, [CS:BP+4]
                Sub     AL, 2
                Push    AX
                Push    27
                Call    S_DrawBox

                Add     SP, 10
                                                ; Fill in text.
                                                ; check boundaries.
                Mov     DX, CurrentChannel
                MovZX   BX, Byte Ptr [CS:BP+2]
                Cmp     DX, BX
                JAE     Display_8Channel2

                Mov     BX, DX

Display_8Channel2:
                Mov     CX, DX
                Sub     CX, 7
                Cmp     BX, CX
                JGE     Display_8Channel3

                Mov     BX, CX

Display_8Channel3:
                Cmp     BX, 56
                JB      Display_8Channel11

                Mov     BX, 56

Display_8Channel11:
                Mov     [CS:BP+2], BL           ; top channel.
                                                ; Now do channel msgs.

                Mov     CX, 0A08h
                Mov     DI, [CS:BP+6]
                Add     DI, (6+1*80)*2
                Mov     SI, Offset Channel8Msg

Display_8Channel4:
                MovZX   AX, BL
                Inc     AX
                Div     CH
                Add     AX, 3030h
                Mov     [SI+2], AX

                Call    GetChannelColour
                Call    S_DrawString

                Add     DI, 6

                Inc     BX
                Dec     CL
                JNZ     Display_8Channel4

                Mov     [CS:DrawTrackData], Offset Show8Channel
                Call    DisplayTrackData
                Mov     CX, 71
                Call    DrawHilightBar

                Ret

EndP            Display_8Channel
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Show10Channel

                Mov     AL, [CS:BP+2]
                Mov     AH, 5
                Mul     AH
                Add     SI, AX                  ; DS:SI points to stuff.

                Mov     CX, 0A0Ah
                Mov     ES, Destination
                Add     DI, 8

Show10Channel1:
                LodsB
                Cmp     AL, 119
                JBE     Show10Channel2

                Mov     AH, AL
                Mov     AL, 205

                Cmp     AH, 0FFh
                JE      Show10Channel3

                Mov     AL, '^'
                Cmp     AH, 0FEh
                JE      Show10Channel3

                Mov     AL, 173                 ; '.'

Show10Channel3:
                Mov     AH, 6
                StosW
                StosW
                StosW
                Jmp     Show10Channel4

Show10Channel2:                                  ; Show note.
                AAM     12
                                                ; AL = octave
                                                ; AH = note.
                Mov     DX, AX
                MovZX   BX, AL
                Add     BX, BX
                Mov     AH, 6
                Mov     AL, [CS:BX+NoteTable]
                StosW
                Mov     AL, [CS:BX+NoteTable+1]
                StosW
                Mov     AL, DH
                Add     AL, 30h
                StosW

Show10Channel4:                                 ; Show Instrument
                LodsB                           ; AL = instrument
                And     AX, 0FFh
                JZ      Show10Channel5          ; No instrument?
                Div     CH

                                        ; AL = tens, AH = units
                ShL     AL, 4
                Or      AL, AH
                Mov     AH, 0Ah

                StosW                   ; Instrument done.
                Jmp     Show10Channel6

Show10Channel5:
                Mov     AX, 184+200h
                StosW

Show10Channel6:                                 ; Show volume
                LodsB                           ; AL = volume

                Cmp     AL, 0FFh
                JE      Show10Channel7

                Mov     AH, AL
                And     AH, 7Fh
                Sub     AH, 65
                JC      ViewAllSmallNoVEffect

                Test    AL, 80h
                JZ      ViewAllSmallVEffect1

                Mov     AL, AH
                Add     AL, 226
                Mov     AH, 6
                StosW
                Jmp     Show10Channel8

ViewAllSmallVEffect1:
                Mov     AL, AH
                AAM
                Add     AH, 0Ah
                ShL     AH, 4
                Or      AL, AH
                Mov     AH, 12
                StosW
Comment ~
                Mov     AL, AH
                Mov     AH, 0
                Div     CH
                                        ; AL = effect, AH = num
                Add     AL, 0Ah
                ShL     AL, 4
                Or      AL, AH
                Mov     AH, 12
                StosW
~
                Jmp     Show10Channel8

ViewAllSmallNoVEffect:
;                Xor     AH, AH
                Mov     DL, 12                  ; Volume
                Test    AL, AL
                JNS     Show10Channel9

                Mov     DL, 9
                And     AL, 7Fh

Show10Channel9:
;                Div     CH
                AAM

                                        ; AL = tens, AH = units
                ShL     AH, 4
                Or      AL, AH
                Mov     AH, DL

                StosW
                Jmp     Show10Channel8

Show10Channel7:                         ; No volume
                Mov     AX, 184+600h
                StosW

Show10Channel8:                                 ; Show volume
                LodsB
                Test    AL, AL
                JNZ     Show10Channel10

                Add     AL, '.'-'@'

Show10Channel10:
                Add     AL, '@'
                Mov     AH, 2
                StosW                           ; Command

                Mov     AH, 0Ah
                LodsB                           ; Commandvalue.
                StosW

                Dec     CL
                JNZ     Show10Channel1

                Ret

EndP            Show10Channel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Display_10Channel
                        Assume DS:InfoPage

                Mov     AX, 4                   ; left
                Push    AX
                Mov     AL, [CS:BP+3]
                Inc     AX
                Push    AX
                Push    75
                Add     AX, [CS:BP+4]
                Sub     AL, 2
                Push    AX
                Push    27
                Call    S_DrawBox

                Add     SP, 10
                                                ; Fill in text.
                                                ; check boundaries.
                Mov     DX, CurrentChannel
                MovZX   BX, Byte Ptr [CS:BP+2]
                Cmp     DX, BX
                JAE     Display_10Channel2

                Mov     BX, DX

Display_10Channel2:
                Mov     CX, DX
                Sub     CX, 9
                Cmp     BX, CX
                JGE     Display_10Channel3

                Mov     BX, CX

Display_10Channel3:
                Cmp     BX, 54
                JB      Display_10Channel11

                Mov     BX, 54

Display_10Channel11:
                Mov     [CS:BP+2], BL           ; top channel.
                                                ; Now do channel msgs.

                Mov     CX, 0A0Ah
                Mov     DI, [CS:BP+6]
                Add     DI, (5+1*80)*2
                Mov     SI, Offset Channel8Msg

Display_10Channel4:
                MovZX   AX, BL
                Inc     AX
                Div     CH
                Add     AX, 3030h
                Mov     [SI+2], AX

                Call    GetChannelColour
                Call    S_DrawString

;                Add     DI, 2
                ScasW

                Inc     BX
                Dec     CL
                JNZ     Display_10Channel4

                Mov     [CS:DrawTrackData], Offset Show10Channel
                Call    DisplayTrackData
                Mov     CX, 70
                Call    DrawHilightBar

                Ret

EndP            Display_10Channel
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Process3CharacterRow

                Push    SI

                LodsW
                Cmp     AX, 0FDh
                JE      Show18Channel4

                Cmp     AL, 0FDh
                JE      Show18Channel3
                JB      Show18Channel2

                Mov     AH, AL
                Mov     AL, 205

                Cmp     AH, 0FFh
                JE      Show18Channel8

                Mov     AL, '^'
                Cmp     AH, 0FEh
                JE      Show18Channel8

                Mov     AL, 173                 ; '.'

Show18Channel8:
                Mov     AH, 6
                StosW
                StosW
                StosW
                Jmp     Show18Channel7

Show18Channel2:
                AAM     12

                Mov     DX, AX
                MovZX   BX, AL
                Add     BX, BX
                Mov     AH, 6
                Mov     AL, [CS:BX+NoteTable]
                StosW
                Mov     AL, [CS:BX+NoteTable+1]
                StosW
                Mov     AL, DH
                Add     AL, 30h
                StosW

                Jmp     Show18Channel7

Show18Channel3:
                MovZX   AX, AH
                Div     CH
                Add     AX, 3030h
                Mov     DL, AH
                Mov     AH, 6
;                Add     DI, 2
                ScasW
                StosW
                Mov     AL, DL
                StosW
                Jmp     Show18Channel7

Show18Channel4:
                LodsW
                Cmp     AX, 0FFh
                JE      Show18Channel6

                Cmp     AL, 0FFh
                JE      Show18Channel5

;                Add     DI, 2
                ScasW

                Mov     AH, AL
                And     AH, 7Fh
                Sub     AH, 65
                JC      Show18ChannelNoVEffect

                Test    AL, 80h
                JZ      Show18ChannelVEffect

                Add     AH, 60

Show18ChannelVEffect:
                Mov     AL, AH
                Xor     AH, AH
                Div     CH
                                        ; AL = effect, AH = num
                Add     AX, 'A'+'0'*256
                Mov     DL, AH
                Mov     AH, 2
                StosW
                Mov     AL, DL
                StosW

                Jmp     Show18Channel7

Show18ChannelNoVEffect:
                Mov     DL, 2
                Test    AL, 80h
                JZ      Show18Channel9

                Dec     DX
                And     AL, 7Fh

Show18Channel9:
                Xor     AH, AH                  ; Volume
                Div     CH
                Add     AX, 3030h
                XChg    DL, AH
                StosW
                Mov     AL, DL
                StosW

                Jmp     Show18Channel7

Show18Channel5:
                Mov     AL, AH
                Add     AL, '@'
                Mov     AH, 2
                StosW

                LodsB                           ; Commandvalue.
                Mov     AH, AL
                And     AX, 0FF0h
                Mov     DL, AH
                ShR     AL, 4

                Mov     AH, 2
                Call    DrawHexAL

                Mov     AL, DL
                Call    DrawHexAL
                Jmp     Show18Channel7

Show18Channel6:
                Mov     AX, 173+256*6
                StosW
                StosW
                StosW

Show18Channel7:
                Pop     SI
                Add     SI, 5

                Ret

EndP            Process3CharacterRow

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Show18Channel

                Mov     AL, [CS:BP+2]
                Mov     AH, 5
                Mul     AH
                Add     SI, AX                  ; DS:SI points to stuff.

                Mov     CX, 0A12h
                Mov     ES, Destination
                Add     DI, 8

Show18Channel1:
                Call    Process3CharacterRow
                Dec     CL
                JZ      Show18ChannelEnd

                Mov     AX, 2A8h
                StosW

                Jmp     Show18Channel1

Show18ChannelEnd:
                Ret

EndP            Show18Channel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Display_18Channel
                        Assume DS:InfoPage

                Mov     AX, 4                   ; left
                Push    AX
                Mov     AL, [CS:BP+3]
                Inc     AX
                Push    AX
                Push    76
                Add     AX, [CS:BP+4]
                Sub     AL, 2
                Push    AX
                Push    27
                Call    S_DrawBox

                Add     SP, 10
                                                ; Fill in text.
                                                ; check boundaries.
                Mov     DX, CurrentChannel
                MovZX   BX, Byte Ptr [CS:BP+2]
                Cmp     DX, BX
                JAE     Display_18Channel2

                Mov     BX, DX

Display_18Channel2:
                Mov     CX, DX
                Sub     CX, 17
                Cmp     BX, CX
                JGE     Display_18Channel3

                Mov     BX, CX

Display_18Channel3:
                Cmp     BX, 46
                JB      Display_18Channel11

                Mov     BX, 46

Display_18Channel11:
                Mov     [CS:BP+2], BL           ; top channel.
                                                ; Now do channel msgs.

                Mov     CX, 0A12h
                Mov     DI, [CS:BP+6]
                Add     DI, (6+1*80)*2
                Mov     SI, Offset Channel18Msg

Display_18Channel4:
                MovZX   AX, BL
                Inc     AX
                Div     CH
                Add     AX, 3030h
                Mov     [SI], AX

                Call    GetChannelColour
                Call    S_DrawString

                Add     DI, 4

                Inc     BX
                Dec     CL
                JNZ     Display_18Channel4

                Mov     [CS:DrawTrackData], Offset Show18Channel
                Call    DisplayTrackData
                Mov     CX, 71
                Call    DrawHilightBar

                Ret

EndP            Display_18Channel
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Show24Channel

                Mov     AL, [CS:BP+2]
                Mov     AH, 5
                Mul     AH
                Add     SI, AX                  ; DS:SI points to stuff.

                Mov     CX, 0A18h
                Mov     ES, Destination
                Add     DI, 8

Show24Channel1:
                Call    Process3CharacterRow

                Dec     CL
                JNZ     Show24Channel1

                Ret

EndP            Show24Channel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Display_24Channel
                        Assume DS:InfoPage

                Mov     AX, 4                   ; left
                Push    AX
                Mov     AL, [CS:BP+3]
                Inc     AX
                Push    AX
                Push    77
                Add     AX, [CS:BP+4]
                Sub     AL, 2
                Push    AX
                Push    27
                Call    S_DrawBox

                Add     SP, 10
                                                ; Fill in text.
                                                ; check boundaries.
                Mov     DX, CurrentChannel
                MovZX   BX, Byte Ptr [CS:BP+2]
                Cmp     DX, BX
                JAE     Display_24Channel2

                Mov     BX, DX

Display_24Channel2:
                Mov     CX, DX
                Sub     CX, 23
                Cmp     BX, CX
                JGE     Display_24Channel3

                Mov     BX, CX

Display_24Channel3:
                Cmp     BX, 40
                JB      Display_24Channel11

                Mov     BX, 40

Display_24Channel11:
                Mov     [CS:BP+2], BL           ; top channel.
                                                ; Now do channel msgs.

                Mov     CX, 0A18h
                Mov     DI, [CS:BP+6]
                Add     DI, (6+1*80)*2
                Mov     SI, Offset Channel18Msg

Display_24Channel4:
                MovZX   AX, BL
                Inc     AX
                Div     CH
                Add     AX, 3030h
                Mov     [SI], AX

                Call    GetChannelColour
                Call    S_DrawString

;                Add     DI, 2
                ScasW

                Inc     BX
                Dec     CL
                JNZ     Display_24Channel4

                Mov     [CS:DrawTrackData], Offset Show24Channel
                Call    DisplayTrackData
                Mov     CX, 72
                Call    DrawHilightBar

                Ret

EndP            Display_24Channel
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Show36Channel

                Mov     AL, [CS:BP+2]
                Mov     AH, 5
                Mul     AH
                Add     SI, AX                  ; DS:SI points to stuff.

                Mov     CX, 0A24h
                Mov     ES, Destination
                Add     DI, 8

Show36Channel1:
                LodsW

                Cmp     AX, 0FDh
                JE      Show36Channel4

                Add     SI, 3

                Cmp     AL, 0FDh
                JE      Show36Channel3
                JB      Show36Channel2

                Mov     AH, AL
                Mov     AL, 205

                Cmp     AH, 0FFh
                JE      Show36Channel8

                Mov     AL, '^'
                Cmp     AH, 0FEh
                JE      Show36Channel8

                Mov     AL, 173                 ; '.'

Show36Channel8:
                Mov     AH, 6
                StosW
                StosW
                Jmp     Show36Channel7

Show36Channel2:
                AAM     12
                Mov     BX, Offset Note2Table
                SegCS   XLatB
                Mov     DL, AH
                Mov     AH, 6
                StosW

                Mov     AL, DL
                Add     AL, 30h
                StosW

                Jmp     Show36Channel7

Show36Channel3:
                MovZX   AX, AH
                Div     CH
                Add     AX, 3030h
                Mov     DL, AH
                Mov     AH, 6
                StosW
                Mov     AL, DL
                StosW

                Jmp     Show36Channel7

Show36Channel4:
                LodsW
                Cmp     AX, 0FFh
                JE      Show36Channel6

                Cmp     AL, 0FFh
                JE      Show36Channel5

                Mov     AH, AL
                And     AH, 7Fh
                Sub     AH, 65
                JC      Show36ChannelNoVEffect

                Test    AL, 80h
                JZ      Show36ChannelVEffect

                Add     AH, 60

Show36ChannelVEffect:
                Mov     AL, AH
                Xor     AH, AH
                Div     CH
                                        ; AL = effect, AH = num
                Add     AX, 'A'+'0'*256
                Mov     DL, AH
                Mov     AH, 2
                StosW
                Mov     AL, DL
                StosW

                Jmp     Show36ChannelEndVolume

Show36ChannelNoVEffect:
                Mov     DL, 2
                Test    AL, 80h
                JZ      Show36Channel10

                And     AL, 7Fh
                Dec     DX

Show36Channel10:

                Xor     AH, AH                  ; Volume
                Div     CH
                Add     AX, 3030h
                XChg    DL, AH
                StosW
                Mov     AL, DL
                StosW

Show36ChannelEndVolume:
                Inc     SI
                Jmp     Show36Channel7

Show36Channel5:
                Mov     AL, AH
                Add     AL, '@'
                Mov     AH, 2
                StosW
                LodsB
                Mov     AH, 0Ah
                StosW

                Jmp     Show36Channel7

Show36Channel6:
                Mov     AX, 173+256*6
                StosW
                StosW
                Inc     SI

Show36Channel7:
                Dec     CL
                JNZ     Show36Channel9

                Ret

Show36Channel9:
                Jmp     Show36Channel1

EndP            Show36Channel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Display_36Channel
                        Assume DS:InfoPage

                Mov     AX, 4                   ; left
                Push    AX
                Mov     AL, [CS:BP+3]
                Inc     AX
                Push    AX
                Push    77
                Add     AX, [CS:BP+4]
                Sub     AL, 2
                Push    AX
                Push    27
                Call    S_DrawBox

                Add     SP, 10
                                                ; Fill in text.
                                                ; check boundaries.
                Mov     DX, CurrentChannel
                MovZX   BX, Byte Ptr [CS:BP+2]
                Cmp     DX, BX
                JAE     Display_36Channel2

                Mov     BX, DX

Display_36Channel2:
                Mov     CX, DX
                Sub     CX, 35
                Cmp     BX, CX
                JGE     Display_36Channel3

                Mov     BX, CX

Display_36Channel3:
                Cmp     BX, 28
                JB      Display_36Channel11

                Mov     BX, 28

Display_36Channel11:
                Mov     [CS:BP+2], BL           ; top channel.
                                                ; Now do channel msgs.

                Mov     CX, 0A24h
                Mov     DI, [CS:BP+6]
                Add     DI, (5+1*80)*2
                Mov     SI, Offset Channel18Msg

Display_36Channel4:
                MovZX   AX, BL
                Inc     AX
                Div     CH
                Add     AX, 3030h
                Mov     [SI], AX

                Call    GetChannelColour
                Call    S_DrawString

                Inc     BX
                Dec     CL
                JNZ     Display_36Channel4

                Mov     [CS:DrawTrackData], Offset Show36Channel
                Call    DisplayTrackData
                Mov     CX, 72
                Call    DrawHilightBar

                Ret

EndP            Display_36Channel
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Show64Channel
                                        ; DS:SI points to stuff.

                Mov     CX, 64
                Mov     ES, Destination
                Add     DI, 8

Show64Channel1:
                LodsW

                Cmp     AX, 0FDh
                JE      Show64Channel4

                Add     SI, 3

                Cmp     AL, 0FDh
                JE      Show64Channel3
                JB      Show64Channel2

                Mov     AH, AL
                Mov     AL, 205

                Cmp     AH, 0FFh
                JE      Show64Channel8

                Mov     AL, '^'
                Cmp     AH, 0FEh
                JE      Show64Channel8

                Mov     AL, 173                 ; '.'

Show64Channel8:
                Mov     AH, 6
                StosW
                Jmp     Show64Channel7

Show64Channel2:
                AAM     12
                Mov     BX, Offset Note2Table
                SegCS   XLatB
                Mov     AH, 6

                StosW
                Jmp     Show64Channel7

Show64Channel3:
                Mov     AL, AH
                AAM
                ShL     AH, 4
                Or      AL, AH

                Mov     AH, 10
                StosW
                Jmp     Show64Channel7

Show64Channel4:
                LodsW
                Inc     SI

                Cmp     AL, 0FFh
                JE      Show64Channel6

                Mov     DL, AL
                And     AX, 07Fh

                Cmp     AL, 64
                JA      Show64Channel6

                AAM
                ShL     AH, 4
                Or      AL, AH
                             
                Mov     AH, 12
                Test    DL, 80h
                JZ      Show64ChannelVolumePan

                Mov     AH, 9

Show64ChannelVolumePan:
                StosW

                Jmp     Show64Channel7

Show64Channel6:
                Mov     AX, 173+256*6
                StosW

Show64Channel7:
                Dec     CX
                JNZ     Show64Channel9

                Mov     CX, 9
                Mov     AX, 173+256*6
                Rep     StosW
                Ret

Show64Channel9:
                Jmp     Show64Channel1

EndP            Show64Channel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Display_64Channel
                        Assume DS:InfoPage

                Mov     AX, 4                   ; left
                Push    AX
                Mov     AL, [CS:BP+3]
                Inc     AX
                Push    AX
                Push    78
                Add     AX, [CS:BP+4]
                Sub     AL, 2
                Push    AX
                Push    27
                Call    S_DrawBox

                Add     SP, 10
                                                ; Now do channel msgs.

                Mov     CX, 0A40h
                Mov     DI, [CS:BP+6]
                Add     DI, (5+1*80)*2
                Mov     SI, Offset Channel18Msg
                Xor     BX, BX
                Mov     DL, Byte Ptr CurrentChannel

Display_64Channel4:
                MovZX   AX, BL
                Inc     AX
                Div     CH

                ShL     AL, 4
                Or      AL, AH
                Mov     DH, AL
                Call    GetChannelColour
                Or      AH, 8
                Mov     AL, DH
                StosW

                Inc     BX
                Dec     CL
                JNZ     Display_64Channel4

                Mov     AX, 1000h
                Mov     CX, 9
                Rep     StosW

                Mov     Byte Ptr [CS:BP+2], 0

                Mov     [CS:DrawTrackData], Offset Show64Channel
                Call    DisplayTrackData
                Mov     CX, 73
                Call    DrawHilightBar

                Ret

EndP            Display_64Channel
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Display_Variables

                Mov     DI, [CS:BP+6]
                Add     DI, (2+1*80)*2

                Call    Music_GetSlaveChannelInformationTable
                                                        ; DS:SI points to tables
                                                        ; CX = numchannels.
                Xor     DX, DX                          ; DX = counter of
                                                        ;      currently act.
                                                        ;      channels.
                Xor     BX, BX


Display_Variables1:
                Cmp     Word Ptr [SI+38h], 0
                JE      Display_Variables2

                Inc     BX

Display_Variables2:
                Mov     AX, [SI]
;                Test    AH, 8
;                JNZ     Display_Variables4

                And     AX, 1
                Add     DX, AX

Display_Variables4:
                Add     SI, SLAVECHANNELSIZE
                Loop    Display_Variables1

                Push    BX
                Call    Music_GetDisplayVariables       ; AX = Current Speed
                                                        ; BX = current tempo
                                                        ; CX = global volume
                                                        ; DX = active channels
                Pop     BX
                Push    CX
                Push    BX
                Push    DX

                Push    CS
                Pop     DS

                Mov     AH, 20h
                Mov     AL, Byte Ptr CurrentWindow
                Cmp     AL, Byte Ptr ProcessWindow
                JNE     Display_Variables3

                Mov     AH, 23h

Display_Variables3:
                Mov     SI, Offset VariablesMsg
                Call    S_DrawString

                Add     SP, 6

                Ret

EndP            Display_Variables

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Display_NoteDots                        ; Draw boxes first.
                                Assume DS:InfoPage

                Mov     ES, Destination

                Mov     AX, 4                   ; left
                Push    AX
                Mov     AL, [CS:BP+3]
                Push    AX
                Push    78
                Add     AX, [CS:BP+4]
                Dec     AX
                Push    AX
                Push    27
                Call    S_DrawBox
                Add     SP, 10

                Mov     DX, CurrentChannel
                MovZX   BX, Byte Ptr [CS:BP+2]
                Cmp     DX, BX
                JAE     Display_Dots1

                Mov     BX, DX

Display_Dots1:
                LEA     CX, [EDX+3]
                Sub     CX, [CS:BP+4]
                Cmp     BX, CX
                JGE     Display_Dots2

                Mov     BX, CX

Display_Dots2:
                Mov     CX, 66
                Sub     CX, [CS:BP+4]
                Cmp     BX, CX
                JLE     Display_Dots3

                Mov     BX, 65
                Sub     BX, [CS:BP+4]

Display_Dots3:
                Mov     [CS:BP+2], BL                   ; BL = top channel

                Call    DrawChannelNumbers

                Mov     DX, [CS:BP+4]
                Sub     DX, 2
                Mov     BL, [CS:BP+2]                   ; BL = channel
                Mov     DI, [CS:BP+6]
                Add     DI, (5+1*80)*2

Display_Dots4:
                Push    DI

                Push    CS
                Pop     ES
                Mov     DI, Offset DataArray
                Mov     AX, 600h + 193
                Mov     CX, 73
                Rep     StosW                   ; DataArray cleared.

                                        ; OK.. loop to find channel usage.
                Call    Music_GetSlaveChannelInformationTable
                                        ; Return DS:SI, CX
Display_Dots5:
;                Cmp     Word Ptr [SI+38h], 0
;                JE      Display_Dots8

                Test    Byte Ptr [SI], 1
                JZ      Display_Dots6

                Mov     AL, [SI+3Ah]
                And     AX, 7Fh
                Cmp     AL, BL
                JNE     Display_Dots6   ; Nope.. not the same channel

                Mov     AL, [SI+32h]
                Sub     AL, 30
                JC      Display_Dots6
                Cmp     AL, 73
                JAE     Display_Dots6

                LEA     DI, [DataArray+EAX+EAX]
                Mov     AL, [SI+20h]
                Mov     AH, [SI+36h]
                Cmp     AH, 100
                JNE     Display_DotsNOMIDI

                Mov     AH, [SI+33h]

Display_DotsNoMIDI:
                And     AH, 3
                Add     AL, 7
                ShR     AL, 4
                AdC     AX, 200h+193
                Test    Word Ptr [SI], 800h
                JZ      Display_Dots7

                Mov     AH, 1 ; 6

Display_Dots7:
                Test    Byte Ptr [SI+3Ah], 80h
                JZ      Display_Dots9

                Cmp     Byte Ptr [CS:DI], AL
                JA      Display_Dots6
Display_Dots9:

                Mov     [CS:DI], AX

Display_Dots6:
                Add     SI, SLAVECHANNELSIZE

                Dec     CX
                JNZ     Display_Dots5

Display_Dots8:
; Dump to screen buffer.

                Pop     DI

                Push    CS
                Pop     DS
                Mov     SI, Offset DataArray
                Mov     ES, Destination

                Mov     CX, 73
                Rep     MovsW

                Add     DI, 160-146

                Inc     BL
                Dec     DX
                JNZ     Display_Dots4

                Ret

EndP            Display_NoteDots

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Comment ~

Proc            Display_SampleDots          ; Draw boxes first.
                                Assume DS:InfoPage

                Mov     ES, Destination

                Mov     AX, 4                   ; left
                Push    AX
                Mov     AL, [CS:BP+3]
                Push    AX
                Push    78
                Add     AX, [CS:BP+4]
                Dec     AX
                Push    AX
                Push    27
                Call    S_DrawBox
                Add     SP, 10

                Mov     DX, CurrentSample
                MovZX   BX, Byte Ptr [CS:BP+2]
                Cmp     DX, BX
                JAE     Display_SampleDots1

                Mov     BX, DX

Display_SampleDots1:
                LEA     CX, [EDX+3]
                Sub     CX, [CS:BP+4]
                Cmp     BX, CX
                JGE     Display_SampleDots2

                Mov     BX, CX

Display_SampleDots2:
                Mov     CX, 66
                Sub     CX, [CS:BP+4]
                Cmp     BX, CX
                JLE     Display_SampleDots3

                Mov     BX, 65
                Sub     BX, [CS:BP+4]

Display_SampleDots3:
                Mov     [CS:BP+2], BL                   ; BL = top channel

                Mov     CL, [CS:BP+4]
                Mov     CH, 0Ah
                Sub     CL, 2
                Mov     DI, [CS:BP+6]
                Add     DI, (2+1*80)*2

Display_SampleDotsNumbers1:             ; BX = top number, CL = count
                Inc     BX
                Mov     AX, BX
                Div     CH
                Add     AX, 3030h
                Mov     DH, AH
                Mov     AH, 21h
                StosW
                Mov     AL, DH
                StosW
                Add     DI, 160-4
                Dec     CL
                JNZ     Display_SampleDotsNumbers1

                Mov     DX, [CS:BP+4]
                Sub     DX, 2
                Mov     BL, [CS:BP+2]                   ; BL = sample
                Mov     DI, [CS:BP+6]
                Add     DI, (5+1*80)*2

Display_SampleDots4:
                Push    DI

                Push    CS
                Pop     ES
                Mov     DI, Offset DataArray
                Mov     AX, 600h + 193
                Mov     CX, 73
                Rep     StosW                   ; DataArray cleared.

                                        ; OK.. loop to find channel usage.
                Call    Music_GetSlaveChannelInformationTable
                                        ; Return DS:SI, CX
Display_SampleDots5:
                Test    Byte Ptr [SI], 1
                JZ      Display_SampleDots6

                Mov     AL, [SI+36h]
                Cmp     AL, BL
                JNE     Display_SampleDots6   ; Nope.. not the same channel

                MovZX   AX, Byte Ptr [SI+32h]
                Sub     AL, 30
                JC      Display_SampleDots6
                Cmp     AL, 73
                JAE     Display_SampleDots6

                LEA     DI, [DataArray+EAX+EAX]
                Mov     AL, [SI+20h]    ; Volume
                Mov     AH, [SI+33h]    ; Instrument

                And     AH, 3
                Add     AL, 7
                ShR     AL, 4
                AdC     AX, 200h+193
                Test    Word Ptr [SI], 800h
                JZ      Display_SampleDots7

                Mov     AH, 1 ; 6       ; Muted

Display_SampleDots7:
                Cmp     Byte Ptr [CS:DI], AL
                JA      Display_SampleDots6

Display_SampleDots9:
                Mov     [CS:DI], AX

Display_SampleDots6:
                Add     SI, SLAVECHANNELSIZE

                Dec     CX
                JNZ     Display_SampleDots5

Display_SampleDots8:
; Dump to screen buffer.

                Pop     DI

                Push    CS
                Pop     DS
                Mov     SI, Offset DataArray
                Mov     ES, Destination

                Mov     CX, 73
                Rep     MovsW

                Add     DI, 160-146

                Inc     BL
                Dec     DX
                JNZ     Display_SampleDots4


                Ret

EndP            Display_SampleDots

~

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DrawDisplayData Far

                Call    PE_GetCurrentPattern
                Mov     CS:PatternSegment, DS

                Push    CS
                Pop     DS
                        Assume DS:InfoPage

                Call    S_GetDestination
                Mov     Destination, ES

                Mov     PatternArrayNumber, AX
                Mov     PatternMaxRow, BX

                Call    Music_GetPlayMode
                Mov     PlayMode, AX
                Mov     CurrentRow, BX
                Mov     CurrentPattern, CX
                Mov     CurrentOrder, DX

                Xor     BP, BP

                Cmp     CX, PatternArrayNumber
                JNE     DrawDisplayData1

                Call    Music_GetPatternLength
                Mov     PatternMaxRow, AX

DrawDisplayData1:
                Push    CS
                Pop     DS
                        Assume DS:InfoPage

                Push    BP

                Mov     ProcessWindow, BP

                ShL     BP, 3
                Add     BP, Offset DisplayWindows
                Mov     SI, [CS:BP]

                Xor     AL, AL

                Cmp     FullScreen, 0
                JNE     DisplayDataFull

                Cmp     BP, Offset DisplayWindows
                JE      DisplayData2

DisplayDataFull:
                Test    SI, SI
                JZ      DisplayData2
                Cmp     SI, DOTSDISPLAY
                JE      DisplayData2

                Inc     AX

                Dec     Byte Ptr [CS:BP+3]         ; Starting row
                Inc     Word Ptr [CS:BP+4]         ; Length of window
                Sub     Word Ptr [CS:BP+6], 160    ; Offset

DisplayData2:
                Mov     [RestoreData], AL

                Add     SI, SI
                Call    [DisplayDataModes+SI]

                Push    CS
                Pop     DS

                Cmp     [RestoreData], 0
                JE      DisplayData3

                Pop     BX
                Push    BX

                ShL     BX, 3
                Add     BX, Offset DisplayWindows

                Inc     Byte Ptr [BX+3]
                Dec     Word Ptr [BX+4]
                Add     Word Ptr [BX+6], 160

DisplayData3:
                Pop     BP
                Inc     BP
                Cmp     BP, NumWindows
                JB      DrawDisplayData1

                Mov     AX, 1
                Ret

EndP            DrawDisplayData
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PostDisplayData Far

                Push    CS
                Pop     DS
                        Assume DS:InfoPage

                Mov     SI, Offset DisplayListKeys
                Call    M_FunctionDivider
                JC      PostDisplayData1

                Jmp     [SI]

PostDisplayData1:
                Xor     AX, AX
                Ret

EndP            PostDisplayData

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayUp Far
                        Assume DS:InfoPage

                Mov     AX, 1

                Sub     CurrentChannel, AX
                AdC     CurrentChannel, 0

                Ret

EndP            DisplayUp
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayDown Far
                        Assume DS:InfoPage

                Mov     AX, CurrentChannel
                Inc     AX
                Cmp     AX, 64
                JAE     DisplayDown1

                Mov     CurrentChannel, AX

DisplayDown1:
                Mov     AX, 1
                Ret

EndP            DisplayDown
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayPlus Far

                Call    Music_NextOrder

                Mov     AX, 1
                Ret

EndP            DisplayPlus

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayMinus Far

                Call    Music_LastOrder

                Mov     AX, 1
                Ret

EndP            DisplayMinus

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayInsert Far
                Assume DS:InfoPage

                Cmp     NumWindows, 5
                JAE     DisplayInsert1

                Push    DS
                Pop     ES

                Mov     AX, 8
                Mul     Byte Ptr CurrentWindow          ; AX = offset
                Mov     SI, Offset DisplayWindows
                Add     SI, AX

                Cmp     Word Ptr [SI+4], 6              ; Length of window
                JBE     DisplayInsert1

                Push    SI

                Mov     AX, 8
                Mul     Byte Ptr NumWindows
                Mov     SI, Offset DisplayWindows
                Add     SI, AX
                Mov     DI, SI
                Sub     SI, 8

                Mov     DX, NumWindows
                Sub     DX, CurrentWindow

DisplayInsert2:
                Mov     CX, 4
                Rep     MovsW

                Sub     SI, 16
                Sub     DI, 16
                Dec     DX
                JNZ     DisplayInsert2

                Pop     SI                              ; SI points to cur win
                                                        ; now to resize..
                Mov     AX, [SI+4]                      ; AX = length of win
                ShR     AX, 1
                AdC     AX, 0

                Mov     [SI+4], AX                      ; halve length.
                Sub     [SI+8+4], AX                    ; second one also
                Add     AL, [SI+3]                      ; Add top line
                Mov     [SI+8+3], AL
                Mov     AH, 160
                Mul     AH
                Mov     [SI+8+6], AX

                Inc     NumWindows

DisplayInsert1:
                Mov     AX, 1
                Ret

EndP            DisplayInsert
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayDelete Far
                Assume DS:InfoPage

                Cmp     NumWindows, 1
                JBE     DisplayDelete1

                Mov     AX, 8
                Mul     Byte Ptr CurrentWindow          ; AX = offset
                Mov     SI, Offset DisplayWindows
                Add     SI, AX
                Mov     DI, SI

                Mov     BX, [SI+4]                      ; Length of deleted win
                Push    SI

                Add     SI, 8

                Push    DS
                Pop     ES

                Mov     DX, NumWindows
                Sub     DX, CurrentWindow

DisplayDelete2:
                Mov     CX, 4
                Rep     MovsW

                Dec     DX
                JNZ     DisplayDelete2

                Pop     SI
                                                        ; Now to recombine.

                Dec     NumWindows

                Mov     AX, CurrentWindow
                Cmp     AX, NumWindows
                JB      DisplayDelete3

                Dec     CurrentWindow                   ; Combine with earlier.
                Add     [SI-8+4], BX
                Jmp     DisplayDelete1

DisplayDelete3:                                         ; Combine with next
                Add     [SI+4], BX
                Mov     AL, [SI+3]
                Sub     AL, BL
                Mov     [SI+3], AL
                Mov     AH, 160
                Mul     AH
                Mov     [SI+6], AX

DisplayDelete1:
                Mov     AX, 1
                Ret

EndP            DisplayDelete
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayNext Far
                        Assume DS:InfoPage

                Mov     AX, CurrentWindow
                Inc     AX
                Cmp     AX, NumWindows
                JB      DisplayNext1

                Xor     AX, AX

DisplayNext1:
                Mov     CurrentWindow, AX

                Mov     AX, 1
                Ret

EndP            DisplayNext
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayPrevious Far

                Mov     AX, CurrentWindow
                And     AX, AX
                JZ      DisplayPrevious1

                Dec     AX
                Mov     CurrentWindow, AX

DisplayPrevious1:
                Mov     AX, 1
                Ret

EndP            DisplayPrevious

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayAltUp Far
                        Assume DS:InfoPage

                Mov     BX, 3

                Mov     AX, CurrentWindow
                Sub     AX, 1
                AdC     BX, 0
                Add     AX, 2

                Cmp     AX, NumWindows
                JAE     DisplayAltUp1

                Mov     AH, 8
                Mul     AH
                Mov     SI, Offset DisplayWindows
                Add     SI, AX

                Cmp     Word Ptr [SI-8+4], BX
                JBE     DisplayAltUp1

                Inc     Word Ptr [SI+4]
                Dec     Word Ptr [SI-8+4]
                Dec     Byte Ptr [SI+3]
                Sub     Word Ptr [SI+6], 160

DisplayAltUp1:
                Mov     AX, 1
                Ret

EndP            DisplayAltUp
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayAltDown Far
                        Assume DS:InfoPage

                Mov     AX, CurrentWindow
                Inc     AX
                Cmp     AX, NumWindows
                JAE     DisplayAltDown1

                Mov     AH, 8
                Mul     AH
                Mov     SI, Offset DisplayWindows
                Add     SI, AX

                Cmp     Word Ptr [SI+4], 3
                JBE     DisplayAltDown1

                Inc     Word Ptr [SI-8+4]
                Dec     Word Ptr [SI+4]
                Inc     Byte Ptr [SI+3]
                Add     Word Ptr [SI+6], 160

DisplayAltDown1:
                Mov     AX, 1
                Ret

EndP            DisplayAltDown
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayPageUp Far
                        Assume DS:InfoPage

                Mov     AX, CurrentWindow
                Mov     AH, 8
                Mul     AH
                Mov     SI, Offset DisplayWindows
                Add     SI, AX

                Mov     AX, [SI]
                And     AX, AX
                JNZ     DisplayPageUp1

                Mov     AX, PLAYMETHODS

DisplayPageUp1:
                Dec     AX
                Mov     [SI], AX

                Mov     AX, 1
                Ret

EndP            DisplayPageUp
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayPageDown Far
                        Assume DS:InfoPage

                Mov     AX, CurrentWindow
                Mov     AH, 8
                Mul     AH
                Mov     SI, Offset DisplayWindows
                Add     SI, AX

                Mov     AX, [SI]
                Inc     AX
                Cmp     AX, PLAYMETHODS
                JB      DisplayPageDown1

                Xor     AX, AX

DisplayPageDown1:
                Mov     [SI], AX

                Mov     AX, 1
                Ret

EndP            DisplayPageDown
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayHome Far
                Assume DS:InfoPage

                Mov     CurrentChannel, 0

                Mov     AX, 1
                Ret

EndP            DisplayHome
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayEnd Far
                Assume DS:InfoPage

                Call    Music_GetLastChannel
                Mov     CurrentChannel, AX

                Mov     AX, 1
                Ret

EndP            DisplayEnd
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayToggleChannel Far

                Mov     AX, CurrentChannel
                Call    Music_ToggleChannel

                Mov     AX, 1
                Ret

EndP            DisplayToggleChannel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplaySoloChannel Far

                Mov     AX, CurrentChannel
                Call    Music_SoloChannel

                Mov     AX, 1
                Ret

EndP            DisplaySoloChannel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

OldEBX          DD      0
OldECX          DD      0

Proc            DisplayUpdateScreen Far

IF NETWORKENABLED
                Call    Network_Poll

                Test    AX, AX
                JNZ     DisplayUpdateScreen1
ENDIF

                Call    Music_Poll
                Call    Music_GetPlayMode2

                Test    AX, AX
                JZ      DisplayUpdateScreen3    ; Play mode 0 - update screen

                Cmp     CS:OldEBX, EBX
                JNE     DisplayUpdateScreen2

                Cmp     CS:OldECX, ECX
                JNE     DisplayUpdateScreen2

                Xor     AX, AX
                Ret

DisplayUpdateScreen3:
                Mov     EBX, -1
                Mov     ECX, EBX

DisplayUpdateScreen2:
                Mov     CS:OldEBX, EBX
                Mov     CS:OldECX, ECX

DisplayUpdateScreen1:
                Mov     AX, 1
                Ret

EndP            DisplayUpdateScreen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayToggleStereo Far
                Assume DS:InfoPage

                Call    Music_GetSongSegment
                Mov     ES, AX

                Mov     AL, [ES:2Ch]
                Xor     AL, 1
                Mov     [ES:2Ch], AL

                Mov     SI, Offset StereoEnabledMsg
                Test    AL, 1
                JNZ     DisplayToggleStereo1

                Mov     SI, Offset StereoDisabledMsg

DisplayToggleStereo1:
                Call    SetInfoLine
                Call    Music_InitStereo

                Mov     AX, 1
                Ret

EndP            DisplayToggleStereo
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Display_GetDisplayWindowData Far

                Push    CS
                Pop     DS
                        Assume DS:InfoPage

                Mov     DX, Offset DisplayWindows

                Ret

EndP            DIsplay_GetDisplayWindowData

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Display_GotoPattern Far

                Call    Music_GetPlayMode
                Cmp     AX, 1
                JB      Display_GotoPattern1
                JE      Display_GotoPattern2

                Push    Pattern
                Pop     DS
                        Assume DS:Pattern

                Mov     Order, DX

Display_GotoPattern2:
                Mov     AX, CX
                        ; BX = current row
                Mov     CX, CS:CurrentChannel

                Jmp     PE_GotoPattern

Display_GotoPattern1:
                Xor     AX, AX
                Ret

EndP            Display_GotoPattern
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Display_SpaceBar Far
                Assume DS:InfoPage

                Call    DisplayToggleChannel
                Jmp     DisplayDown

EndP            Display_SpaceBar

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayToggleVelocity Far

                Mov     SI, Offset VolumeMsg
                Xor     Byte Ptr Velocity, 1
                JZ      DisplayToggleVelocity1

                Mov     SI, Offset VelocityMsg

DisplayToggleVelocity1:
                Call    SetInfoLine

                Mov     AX, 1
                Ret

EndP            DisplayToggleVelocity

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayToggleInstrument Far

                Mov     SI, Offset SampleMsg
                Xor     Byte Ptr Instrument, 1
                JZ      DisplayToggleInstrument1

                Mov     SI, Offset InstrumentMsg

DisplayToggleInstrument1:
                Call    SetInfoLine

                Mov     AX, 1
                Ret

EndP            DisplayToggleInstrument

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DisplayToggleReverse Far

                Call    Music_ToggleReverse

                Mov     AX, 1
                Ret

EndP            DisplayToggleReverse

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Display_SelectDisplayList Far

                Cmp     CS:FullScreen, 1
                JZ      Display_FullScreen3
                Jmp     Display_FullScreen4

EndP            Display_SelectDisplayList

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Display_FullScreen Far

                Cmp     NumWindows, 1
                JE      Display_FullScreen1

                Mov     AX, 1
                Ret

Display_FullScreen1:
                Push    Glbl
                Pop     ES
                        Assume ES:Glbl
                Mov     ES:CurrentMode, 5
                        Assume ES:Nothing

                Xor     FullScreen, 1

                JZ      Display_FullScreen2

                Mov     Byte Ptr [DisplayWindows+3], 1
                Mov     DWord Ptr [DisplayWindows+4], 160*10000h+49

Display_FullScreen3:
                Push    Glbl
                Pop     ES
                        Assume ES:Glbl
                Mov     ES:CurrentMode, 200
                        Assume ES:Nothing

                Mov     AX, 5
                Mov     SI, 1
                Mov     CX, Object1

                Mov     DX, Offset O1_FullDisplayList
                Ret

Display_FullScreen2:
                Mov     Byte Ptr [DisplayWindows+3], 12
                Mov     DWord Ptr [DisplayWindows+4], 12*80*2*65536+38

Display_FullScreen4:
                Push    Glbl
                Pop     ES
                        Assume ES:Glbl
                Mov     ES:CurrentMode, 5
                        Assume ES:Nothing

                Mov     AX, 5
                Mov     SI, 1
                Mov     CX, Object1

                Mov     DX, Offset O1_DisplayList
                Ret

EndP            Display_FullScreen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

IF SPECTRUMANALYSER

Proc            Display_FourierStart Far

                Jmp     Fourier_Start

EndP            Display_FourierStart

ENDIF

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

EndS

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

End
