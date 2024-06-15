;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Functions                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                        Jumps
                        .386

include switch.inc
include network.inc

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Externals                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF MEMORYDEBUG

Segment         StartUp BYTE Public 'Code'
EndS

Segment         InfoPage BYTE Public 'Code'
EndS

Segment         Glbl BYTE Public 'Code'
EndS

Segment         Help BYTE Public 'Code'
EndS

Segment         Error BYTE Public 'Code'
EndS

Segment         EMS BYTE Public 'Code'
EndS

Segment         KeyBoard BYTE Public 'Code'
EndS

Segment         InfoLine BYTE Public 'Code'
EndS

Segment         Main BYTE Public 'Code'
EndS

ENDIF

Segment         Pattern BYTE Public 'Code'
                Extrn   PatternDataArea:Word
EndS

Segment         Inst BYTE Public 'Code'
                Extrn   MaxNode:Word
EndS

Segment         Music BYTE Public 'Code'
                Extrn   SongDataArea:Word
                Extrn   MIDIDataArea:Word
EndS

Segment         Disk BYTE Public 'Code'
                Extrn   DiskDataArea:Word
EndS

Segment         Screen BYTE Public 'Code'
EndS

Segment         Object1 BYTE Public 'Data'
EndS

;-------------------------------------------------------------------------------

                Extrn   LastInstrument:Byte

                Extrn   D_GetLoadSampleVars:Far
                Extrn   D_ClearFileName:Far
                Extrn   D_SaveSong:Far
                Extrn   D_ResetTimer:Far

                Extrn   E_UnInitEMS:Far
                Extrn   E_GetFreeEMS:Far

                Extrn   Glbl_F2_2:Far
                Extrn   Glbl_F3:Far
                Extrn   Glbl_Ctrl_F3:Far
                Extrn   Glbl_Ctrl_F4:Far
                Extrn   Glbl_F4:Far
                Extrn   Glbl_F5:Far
                Extrn   Glbl_Ctrl_F5:Far
                Extrn   Glbl_F6:Far
                Extrn   PE_F7:Far
                Extrn   Glbl_Shift_F6:Far
                Extrn   Glbl_Shift_F9:Far
                Extrn   Glbl_F9:Far
                Extrn   Glbl_F10:Far
                Extrn   Glbl_F11_2:Far
                Extrn   Glbl_F12:Far

                Extrn   Glbl_GetHeaderMode:Far

                Extrn   H_Help:Far

                Extrn   I_GetInstrumentOffset:Far
                Extrn   I_GetSampleOffset:Far

                Extrn   I_DrawWaveForm:Far
                Extrn   I_MapEnvelope:Far
                Extrn   D_DrawWaveForm:Far

                Extrn   S_InitScreen:Far
                Extrn   S_Set80x25Mode:Far
                Extrn   S_SetPalette2:Far
                Extrn   S_RedefineCharacters:Far
                Extrn   S_UnInitScreen:Far
                Extrn   S_DrawBox:Far
                Extrn   S_UpdateScreen:Far
                Extrn   S_OverrideVGADetection:Far
                Extrn   S_SetDirectMode:Far
                Extrn   S_DrawString:Far
                Extrn   S_HiLight:Far
                Extrn   S_GetDestination:Far
                Extrn   S_SaveScreen:Far
                Extrn   S_RestoreScreen:Far


                Extrn   Music_GetSongSegment:Far
                Extrn   Music_InitMixTable:Far
                Extrn   Music_InitMuteTable:Far
                Extrn   Music_ClearAllInstruments:Far
                Extrn   Music_SetGlobalVolume:Far
                Extrn   Music_InitStereo:Far
                Extrn   Music_Stop:Far

                Extrn   Music_RegetLoopInformation:Far

                Extrn   Music_ReleaseAllSamples:Far     ; For New Song Function
                Extrn   Music_ReleaseAllPatterns:Far
                Extrn   Music_ClearAllInstruments:Far
                Extrn   Music_ClearAllSampleNames:Far
                Extrn   Music_GetFreeSoundCardMemory:Far
                Extrn   Music_SoundCardLoadAllSamples:Far
                Extrn   Music_ReinitSoundCard:Far
                Extrn   Music_TimeSong:Far

                Extrn   Glbl_DriverScreen:Far
                Extrn   Music_GetDriverVariable:Far
                Extrn   Music_SetDriverVariable:Far

                Extrn   M_Object1List:Far

                Extrn   Msg_ResetMessage:Far

                Extrn   O1_EmptyList:Far
                Extrn   O1_ThumbStringList:Far
                Extrn   O1_InitialiseInstrumentList:Far
                Extrn   O1_NewSongList:Far

                Extrn   O1_MainMenu:Far
                Extrn   O1_FileMenu:Far
                Extrn   O1_PlaybackMenu:Far
                Extrn   O1_SampleMenu:Far
                Extrn   O1_InstrumentMenu:Far

                Extrn   PE_ConvAX2Num:Far
                Extrn   PE_ResetOrderPattern:Far

                Extrn   DOSShell:Far
                Extrn   Quit:Far

                Extrn   MouseAddEvent:Far, AddMouseQueue:Far, MouseClearEvents:Far
                Extrn   SetKeyboardLock:Far, NewCharacterSet:Far
                Extrn   MouseRemoveEvents:Far, MouseRestoreEvents:Far
                Extrn   MultiChannelInfo:Byte

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Globals                                                                     ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                Global  F_MainMenu:Far
                Global  F_FileMenu:Far
                Global  F_PlaybackMenu:Far
                Global  F_SampleMenu:Far
                Global  F_InstrumentMenu:Far

                Global  F_DrawHeader:Far

                Global  F_InstrumentButtonHandler:Far

                Global  F_NewSong:Far
                Global  F_DrawStringInput:Far
                Global  F_PreStringInput:Far
                Global  F_PostStringInput:Far
                Global  F_RedrawScreen:Far
                Global  F_Nothing:Far
                Global  F_DrawBoxObject:Far
                Global  F_DrawTextObject:Far
                Global  F_PostExitObject:Far
                Global  F_SetDirectMode:Far
                Global  F_CharacterDefinitions:Far
                Global  F_CallFarFunction:Far
                Global  F_CallFarPreFunction:Far
                Global  F_CallFarPostFunction:Far

                Global  F_DrawToggle:Far
                Global  F_PreToggle:Far
                Global  F_PostToggle:Far

                Global  F_Draw5Num:Far
                Global  F_Pre5Num:Far
                Global  F_Post5Num:Far

                Global  F_Draw3Num:Far
                Global  F_Pre3Num:Far
                Global  F_Post3Num:Far

                Global  F_DrawButtonObject:Far
                Global  F_PreButtonObject:Far
                Global  F_PostButtonObject:Far

                Global  F_Return0:Far
                Global  F_Return1:Far
                Global  F_Return64:Far
                Global  F_Return192:Far

                Global  F_DrawThumbBar:Far
                Global  F_DrawScalableThumbBar:Far
                Global  F_PreThumbBar:Far
                Global  F_PreScalableThumbBar:Far
                Global  F_PostThumbBar:Far
                Global  F_PostScalableThumbBar:Far

                Global  F_DrawInfoLine:Far

                Global  F_ShowChannels:Far
                Global  F_GotoEmptyList:Far
                Global  F_DrawSMCChannels:Far

                Global  F_SetControlInstrument:Far
                Global  F_SetControlSample:Far
                Global  F_ConfigButtonSetup:Far

                Global  F_SetStereo:Far
                Global  F_SetMono:Far
                Global  F_SetAmiga:Far
                Global  F_SetLinear:Far

                Global  F_Reset5NumInputPos:Far

                Global  AddressInput:Byte
                Global  ThumbStringEnter:Byte

                Global  F_MessageEditor:Far
                Global  F_Help:Far                      ; Main menu
                Global  F_ViewPattern:Far
                Global  F_ViewVariables:Far
                Global  F_ViewOrderPan:Far

                Global  F_FileLoad:Far
                Global  F_FileNew:Far
                Global  F_FileSaveCurrent:Far
                Global  F_FileSaveAs:Far
                Global  F_FileDOSShell:Far
                Global  F_FileQuit:Far

                Global  F_InfoPage:Far                  ; Playback menu
                Global  F_PlaySong:Far
                Global  F_PlayPattern:Far
                Global  F_PlayOrder:Far
                Global  F_Stop:Far
                Global  F_PlayMark:Far
                Global  F_DriverScreen:Far
                Global  F_ReinitSoundCard:Far
                Global  F_CalculateLength:Far

                Global  F_SampleList:Far
                Global  F_SampleLibrary:Far
                Global  F_ReloadGravis:Far

                Global  F_InstrumentList:Far
                Global  F_InstrumentLibrary:Far

IF MEMORYDEBUG

                Global  F_DrawDebug:Far
                Global  F_DebugUp:Far
                Global  F_DebugDown:Far
                Global  F_DebugPgUp:Far
                Global  F_DebugPgDn:Far
                Global  F_DebugStringInput:Far
                Public  F_PostDebug

ENDIF

                Public  F_ShowMIDIZxxInput
                Public  F_MIDI_Up
                Public  F_MIDI_Down
                Public  F_MIDI_PgUp, F_MIDI_PgDn

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment                 Functions BYTE Public 'Code' USE16
                        Assume CS:Functions, DS:Nothing

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Variables                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ButtonVariables         Label   Word
                        DW      220h                    ; Standard SB Configs
                        DW      7
                        DW      1
                        DW      1                       ; Clear patterns
                        DW      1                       ; Clear samples
                        DW      1                       ; Clear instruments
                        DW      1                       ; Clear order list

ButtonTypes             Label   Word
                        DW      Offset ButtonType0      ; Press/Release buttons
                        DW      Offset ButtonType1      ; Toggle Press/Release
                        DW      Offset ButtonType2      ; One of Selection

ButtonEffects           Label   Word
                        DW      Offset ButtonEffect0    ; Return value
                        DW      Offset ButtonEffect1    ; New object list
                        DW      Offset ButtonEffect2    ; Call function
                        DW      Offset ButtonEffect3    ; Set var at offset
                        DW      Offset ButtonEffect4    ; Jump to function
                        DW      Offset ButtonEffect5    ; Set var
                        DW      Offset ButtonEffect6    ; Jump to function

ButtonWidth     Label   Word
        DW      0, 0, 0, 0, 0, 0, 0, 0
        DW      7, 7, 7, 7, 7, 7, 7, 7
        DW      0, 0, 0, 0, 0, 0, 0, 0
        DW      7, 7, 7, 7, 0, 0, 0, 0

MouseEventData          DW      7 Dup (0), Functions

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

GetThumbValues          Label   Word
                        DW      Offset GetPanning
                        DW      Offset GetPEVariables
                        DW      Offset GetSampleVariables
                        DW      Offset GetMusicVariables
                        DW      Offset GetPanning               ; ChannelVol
                        DW      Offset GetLoadSampleVariables
                        DW      Offset GetInstVariables
                        DW      Offset GetScreenVariables
                        DW      Offset GetInstrumentVariables
                        DW      Offset GetDriverVariables

DrawThumbValues         Label   Word
                        DW      Offset DrawPanning
                        DW      Offset F_NothingNear
                        DW      Offset F_NothingNear
                        DW      Offset F_NothingNear
                        DW      Offset F_NothingNear
                        DW      Offset F_NothingNear
                        DW      Offset DrawMIDIChannel
                        DW      Offset F_NothingNear
                        DW      Offset F_NothingNear
                        DW      Offset F_NothingNear

PreThumbFuncs           Label   Word
                        DW      Offset HiLightPanning
                        DW      Offset GetPEVariables
                        DW      Offset GetSampleVariables
                        DW      Offset GetMusicVariables
                        DW      Offset GetPanning               ; Channelvol
                        DW      Offset GetLoadSampleVariables
                        DW      Offset GetInstVariables
                        DW      Offset GetScreenVariables
                        DW      Offset GetInstrumentVariables
                        DW      Offset GetDriverVariables

PostThumbFuncs          Label   Word
                        DW      Offset SetPanning
                        DW      Offset SetPEVariables
                        DW      Offset SetSampleVariables
                        DW      Offset SetMusicVariables
                        DW      Offset SetPanning
                        DW      Offset SetLoadSampleVariables
                        DW      Offset SetInstVariables         ; Inst
                        DW      Offset SetScreenVariables
                        DW      Offset SetInstrumentVariables   ; Inst segment
                        DW      Offset SetDriverVariables

PostThumbCheck          Label   Word
                        DW      Offset PanningKeys
                        DW      Offset F_NothingNear
                        DW      Offset F_NothingNear
                        DW      Offset F_NothingNear
                        DW      Offset F_NothingNear
                        DW      Offset F_NothingNear
                        DW      Offset FilterKeys
                        DW      Offset F_NothingNear
                        DW      Offset F_NothingNear
                        DW      Offset F_NothingNear

ThumbStringEnter        DB      0
                        DB      4 Dup (0)

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

; LastStringData          DD      0

StringInputOffset       Label   Word
                        DW      Offset GetSIODiskSegment
                        DW      Offset GetSampleString
                        DW      Offset GetSIOInstSegment
                        DW      Offset GetLoadSampleString
                        DW      Offset GetMusicSegmentString    ; Songsegment
                        DW      Offset GetPatternSegmentString
                        DW      Offset GetInstrumentString
                        DW      Offset GetMIDIString

PostStringInput         Label   Word
                        DW      Offset F_NothingNear
                        DW      Offset SetSampleString
                        DW      Offset F_NothingNear
                        DW      Offset F_NothingNear
                        DW      Offset SetMusicSegmentString    ; Songsegment
                        DW      Offset F_NothingNear
                        DW      Offset SetInstrumentString
                        DW      Offset F_NothingNear

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

GetToggleStatus         Label   Word
                        DW      Offset GetSampleToggle
                        DW      Offset GetPatternSegmentToggle
                        DW      Offset GetMusicSegmentToggle
                        DW      Offset GetLoadSampleToggle
                        DW      Offset GetInstrumentToggle

ToggleBit               Label   Word
                        DW      Offset SampleToggle
                        DW      Offset PatternSegmentToggle
                        DW      Offset MusicSegmentToggle
                        DW      Offset LoadSampleToggle
                        DW      Offset InstrumentToggle

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

TripleNumberPos         DW      0

Get3NumValues           Label   Word
                        DW      Offset GetInstrument3Num

Set3NumValues           Label   Word
                        DW      Offset SetInstrument3Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

NumberPos               DW      0

Get5NumValues           Label   Word
                        DW      Offset GetSample5Num
                        DW      Offset GetLoadSample5Num
                        Dw      Offset GetInst5Num

Set5NumValues           Label   Word
                        DW      Offset SetSample5Num
                        DW      Offset SetLoadSample5Num
                        DW      Offset SetInst5Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

HeaderMsg1              Label   Byte
IF SHOWVERSION
                        DB      0FFh, 9, ' ', "Impulse Tracker v2.14 Copyright (C) 1995-2000 Jeffrey Lim", 13
ELSE
                        DB      0FFh, 12, ' ', "Impulse Tracker Copyright (C) 1995-2000 Jeffrey Lim", 13
ENDIF
                        DB      0FFh, 9, ' ', 0FEh, 21h, 139, 0FFh, 25, 134, 138, 0FFh, 11, ' ', 139, 0FFh, 28, 134, 138, 13
                        DB      0FEh, 20h, "Song Name", 0FEh, 21h, 132, 0FEh, 5, 0FFh, 25, ' ', 0FEh, 23h, 131, 0FEh, 20h, 0

HeaderMsg2              DB      " Instrument"
                        DB      0FEh, 21h, 132, 0FEh, 7, "  :", 0FFh, 25, ' ', 0FEh, 23h, 131, 0

HeaderMsg3              DB      0FFh, 5, " Sample"
                        DB      0FEh, 21h, 132, 0FEh, 7, "  :", 0FFh, 25, ' ', 0FEh, 23h, 131, 0

HeaderMsg4              DB      "File Name", 0FEh, 21h, 132, 0FEh, 5, 0FFh, 18, ' ', 0FEh, 23h, 128, 0FFh, 6, 129, 136, 0FEh, 20h, "Speed/Tempo", 0FEh, 21h, 132, 0FEh, 5, "   ", 0FEh, 1, "/", 0FEh, 5, "   ", 0FEh, 23h, 128, 0FFh, 20, 129, 136, 13
                        DB      0FEh, 20h, 0FFh, 4, " Order", 0FEh, 21h, 132, 0FEh, 5, "   ", 0FEh, 1, "/", 0FEh, 5, "   ", 0FEh, 23h, 128, 0FFh, 10, 129, 136, 0FEh, 20h, 0FFh, 12, " Octave", 0FEh, 21h, 132, 0FEh, 5, " ", 0FEh, 23h, 128, 0FFh, 5, 129, 136, 13
                        DB      0FEh, 20h, "  Pattern", 0FEh, 21h, 132, 0FEh, 5, "   ", 0FEh, 1, "/", 0FEh, 5, "   ", 0FEh, 23h, 131, 0FEh, 20h,     " F1...Help       F9.....Load ", 0FEh, 23h, 137, 129, 136, 0FEh, 20h, 0FFh, 11, " FreeMem ", 0FDh, "Dk ", 13
                        DB      0FEh, 20h, 0FFh, 6, " Row", 0FEh, 21h, 132, 0FEh, 5, "   ", 0FEh, 1, "/", 0FEh, 5, "   ", 0FEh, 23h, 131, 0FEh, 20h, " ESC..Main Menu  F5/F8..Play / Stop", 0FFh, 8, " FreeEMS ", 0FDh, "Dk", 13
                        DB      0FEh, 23h, 0FFh, 9, ' ', 137, 0FFh, 7, 129, 136
                        DB      0

ChannelMsg              DB      "Channel "
ChannelNumbers          DB      "xx", 0

HexNumbers              DB      "0123456789ABCDEF"
SurroundMessage         DB      "Surround", 0
MutedMessage            DB      "  Muted", 0
ForwardMsg              DB      "Forwards", 0
PingPongMsg             DB      "Ping Pong", 0
ZxxString               DB      "Z", 0FDh, "X", 0
NumberStorage           DW      0, 0, 0, 0, 0, 0, 0, 0, 0
PitchMessage            DB      "Pitch", 0
FilterMessage           DB      "Filter", 0

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Functions                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Proc            F_Nothing Far

                Xor     AX, AX
                Ret

EndP            F_Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_InstrumentButtonHandler Far

                Test    AX, AX
                JZ      F_InstrumentButtonHandler1

                NetworkSendInstrument

F_InstrumentButtonHandler1:
                Push    DS
                Call    I_GetInstrumentOffset   ; Returns DS:BX
                Push    DS
                Pop     ES
                Mov     DI, BX
                Pop     DS

                Add     DI, [SI+24]
                Ret

EndP            F_InstrumentButtonHandler

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_NothingNear

                Xor     AX, AX
                Ret

EndP            F_NothingNear

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_CallFarPreFunction Far

                Call    DWord Ptr [SI+6]

                Ret

EndP            F_CallFarPreFunction

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_CallFarPostFunction Far

                Mov     SI, [BX]

                Call    DWord Ptr [SI+10]

                Ret

EndP            F_CallFarPostFunction

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_CallFarFunction Far

                Call DWord Ptr [SI+2]

                Ret

EndP            F_CallFarFunction

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_DrawBoxObject Far

                LodsW
                Xor     AH, AH
                LodsB
                Push    AX
                LodsB
                Push    AX
                LodsB
                Push    AX
                LodsB
                Push    AX
                LodsB
                Push    AX
                Call    S_DrawBox
                Add     SP, 10

                Ret

EndP            F_DrawBoxObject

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_DrawTextObject Far

                LodsW

                Mov     BX, 3
                Xor     CX, CX                  ; CX = string length count
                Xor     DX, DX

F_DrawTextObject1:
                Mov     AL, [SI+BX]
                Inc     BX
                Cmp     AL, 0
                JE      F_DrawTextObject2

                Cmp     AL, 0FDh
                JNE     F_DrawTextObject1
                Inc     CX
                Cmp     Byte Ptr [SI+BX], 'L'
                JNE     F_DrawTextObject1
                Inc     CX
                Jmp     F_DrawTextObject1

F_DrawTextObject2:
                JCXZ    F_DrawTextObject3
                Push    Word Ptr [SI+BX]
                Add     BX, 2
                Inc     DX
                Dec     CX
                Jmp     F_DrawTextObject2

F_DrawTextObject3:
                Mov     AL, 80
                Mul     Byte Ptr [SI+1]
                Add     AL, [SI]
                AdC     AH, 0
                Add     AX, AX
                Mov     DI, AX
                Mov     AH, [SI+2]
                Add     SI, 3
                Call    S_DrawString

                Add     DX, DX
                Add     SP, DX

                Ret

EndP            F_DrawTextObject

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_PostExitObject Far

                Xor     AX, AX
                Test    CH, 1
                JNZ     F_PostExitObject1

                Mov     SI, [BX]
                Mov     DX, [SI+2]
                Mov     AX, 4                   ; Exit from MainProc

F_PostExitObject1:
                Ret

EndP            F_PostExitObject

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_SetDirectMode Far

                LodsW
                LodsB
                Call    S_SetDirectMode

                Ret

EndP            F_SetDirectMode

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_CharacterDefinitions Far

                LodsW
                LodsW
                Mov     BX, [SI]
                Add     SI, 2
                Call    S_RedefineCharacters

                Ret

EndP            F_CharacterDefinitions

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseButtonPress Far            ; Given CX, DX = coords
                                                ; Given AX = Object number
                                                ; DS:SI points to mouse obj
                Mov     CX, 11Ch
                Xor     DX, DX
                Call    AddMouseQueue

                Mov     Word Ptr [SI+8], 1108h
                Mov     Word Ptr [SI+12], Offset MouseButtonRelease

                Mov     AL, 2
                Call    SetKeyboardLock

                Xor     AX, AX
                Ret

EndP            MouseButtonPress

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseButtonRelease Far

                Mov     CX, 01Ch
                Xor     DX, DX
                Call    AddMouseQueue

                Mov     Word Ptr [SI+8], 102h
                Mov     Word Ptr [SI+12], Offset MouseButtonPress

                Xor     AX, AX
                Call    SetKeyboardLock

                Ret

EndP            MouseButtonRelease

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_DrawButtonObject Far  ; AX = object number
                                        ; SI = object

                Mov     [CS:MouseEventData+10], AX      ; Store object number

                Cmp     Word Ptr [SI+16], 5
                JB      F_DrawButtonObject1

                Xor     AX, AX
                Call    DWord Ptr [SI+18]
                Mov     AX, [SI+22]
                ScasB
;                Cmp     [ES:DI], AL

                SetE    [SI+33]

F_DrawButtonObject1:
                Mov     BX, [SI+32]
                And     BX, 0FFh
                Add     SI, 28
                Add     BX, BX
                Mov     DX, [CS:ButtonWidth+BX]

                Xor     AH, AH
                LodsB
                LEA     CX, [EAX*8+EDX]
                Mov     [CS:MouseEventData+0], CX
                Push    AX

                LodsB
                LEA     CX, [EAX*8+EDX]
                Mov     [CS:MouseEventData+2], CX
                Push    AX

                Sub     DX, 7

                LodsB
                Mov     CX, AX
                ShL     CX, 3
                Sub     CX, DX
                Mov     [CS:MouseEventData+4], CX
                Push    AX

                LodsB
                Mov     CX, AX
                ShL     CX, 3
                Sub     CX, DX
                Mov     [CS:MouseEventData+6], CX
                Push    AX

                LodsB                                   ; Base Style
                Mov     BL, [SI]                        ; Up/Down
                And     BL, 1
                Mov     [SI], BL
                Add     AL, BL
                Push    AX
                Call    S_DrawBox
                Add     SP, 10

                Inc     SI

                Mov     AL, 80
                Mul     Byte Ptr [SI-5]
                Add     AL, [SI-6]
                AdC     AH, 0
                Add     AX, AX
                Add     AX, 162
                Mov     DI, AX
                Mov     AH, 20h

                Call    S_DrawString

                Push    CS
                Pop     DS
                Mov     SI, Offset MouseEventData
                Mov     [MouseEventData+8], 102h   ; Left mouse button pressed
                Mov     [MouseEventData+12], Offset MouseButtonPress
                Call    MouseAddEvent

                Ret

EndP            F_DrawButtonObject

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_PreButtonObject Far

                Add     SI, 28
                Xor     AH, AH
                LodsB
                Push    AX
                LodsB
                Push    AX
                LodsB
                Push    AX
                LodsB
                Push    AX
                LodsB                                   ; Base Style
                Mov     BL, [SI]                        ; Up/Down
                And     BL, 1
                Add     AL, BL
                Push    AX
                Call    S_DrawBox
                Add     SP, 10

                Inc     SI

                Mov     AL, 80
                Mul     Byte Ptr [SI-5]
                Add     AL, [SI-6]
                AdC     AH, 0
                Add     AX, AX
                Add     AX, 162
                Mov     DI, AX
                Mov     AH, 23h

                Call    S_DrawString

                Ret

EndP            F_PreButtonObject

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_PostButtonObject Far

                Mov     SI, [BX]
                Push    SI
                Push    DI
                Push    BX
                Push    CX
                Push    DX

                Add     SI, 28
                Mov     AL, 80
                Mul     Byte Ptr [SI+1]
                Add     AL, [SI]
                AdC     AH, 0
                Add     AX, AX
                Add     AX, 162
                Mov     DI, AX
                Mov     AL, 20h
                Mov     CL, [SI+2]
                Sub     CL, [SI]
                Dec     CL
                Xor     CH, CH
                Call    S_HiLight

                Pop     DX
                Pop     CX
                Pop     BX
                Pop     DI
                Pop     SI

                Test    CH, 80h
                JNZ     F_PostButtonNoMIDI

                Mov     AL, [SI+33]
                Cmp     CL, 1Ch
                JE      F_PostButtonObject6             ; Enter

                Test    AL, 2
                JNZ     F_PostButtonObject7

                Cmp     CX, 1C8h                        ; Up pressed
                JE      F_PostButtonObject1

                Cmp     CX, 1D0h
                JE      F_PostButtonObject2             ; Down

                Cmp     CX, 1CBh
                JE      F_PostButtonObject3             ; Left

                Cmp     CX, 1CDh
                JE      F_PostButtonObject4             ; Right

                Cmp     CX, 10Fh                        ; Tab
                JE      F_PostButtonObject4

;                Test    CL, CL
;                JZ      F_PostButtonNOMIDI

                Cmp     DX, 0F00h                       ; Shift tab
                JE      F_PostButtonObject3

F_PostButtonNOMIDI:
                Xor     AX, AX
                Ret

F_PostButtonObject7:
                Test    AL, 4
                JZ      F_PostButtonObject8
                Test    CH, 1
                JZ      F_PostButtonObject8

                And     AX, 1
                Xor     AL, 1
                Mov     [SI+33], AL

F_PostButtonObject8:
                Mov     AX, 2
                Ret

F_PostButtonObject4:
                LodsW

F_PostButtonObject3:
                LodsW

F_PostButtonObject2:
                LodsW

F_PostButtonObject1:
                LodsW

                LodsW
                Cmp     AX, 0FFFFh
                JNE     F_PostButtonObject5

                Xor     AX, AX
                Ret

F_PostButtonObject5:
                Mov     [DI], AX
                Mov     AX, 2
                Ret

F_PostButtonObject6:                            ; Enter pressed
                Push    BX

                Mov     BX, [SI+10]
                Add     BX, BX
                Jmp     [CS:ButtonTypes+BX]

EndP            F_PostButtonObject

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ButtonType0 Far

                Pop     BX

                Test    CH, 1
                JZ      ButtonType0_1

                Or      Byte Ptr [SI+33], 7

ButtonType0_2:
                Mov     AX, 2
                Ret

ButtonType0_1:
                Test    AL, 1
                JNZ     ButtonType0_4

                Test    AL, 2
                JZ      ButtonType0_2

ButtonType0_4:
                Mov     Byte Ptr [SI+33], 0

                Jmp     ButtonEffect

EndP            ButtonType0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ButtonType1 Far

                Pop     BX

                And     CH, CH
                JZ      ButtonType1_2

                Test    AL, 2
                JNZ     ButtonType1_1

                Xor     Byte Ptr [SI+33], 7

ButtonType1_1:
                Mov     AX, 2
                Ret

ButtonType1_2:
                And     Byte Ptr [SI+33], 1

                Jmp     ButtonEffect

EndP            ButtonType1

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ButtonEffect Far

                Mov     BX, [SI+16]
                Add     BX, BX
                Jmp     [CS:ButtonEffects+BX]

EndP            ButtonEffect

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ButtonType2 Far

                Pop     BX

                And     CH, CH
                JZ      ButtonEffect

                Test    AL, 2
                JZ      ButtonType2_1

                Mov     AX, 2
                Ret

ButtonType2_1:
                Add     SI, 12
                LodsW
                Mov     CX, AX
                LodsW
                Mov     DX, AX
                Add     DX, DX
                Add     DI, 6
                Add     DX, DI
                Add     CX, CX
                Add     DI, CX

                Xor     AX, AX

ButtonType2_2:
                Mov     SI, [DI]
                Mov     [SI+33], AL

                ScasW
;                Add     DI, 2
                Cmp     DI, DX
                JBE     ButtonType2_2

                Mov     SI, [BX]
                Mov     Byte Ptr [SI+33], 1

                Mov     AX, 1
                Ret

EndP            ButtonType2

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ButtonEffect0 Far

                Mov     DX, [SI+18]
                Mov     AX, 4
                Ret

EndP            ButtonEffect0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ButtonEffect1 Far

                Mov     CX, [SI+20]
                Mov     DX, [SI+18]
                Mov     AX, 5
                Mov     SI, 1
                Ret

EndP            ButtonEffect1

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ButtonEffect2 Far

                Push    DS
                Push    SI

                Mov     AL, [SI+33]
                Call    DWord Ptr [SI+18]

                Pop     SI
                Pop     DS

                Mov     AX, 1

                Ret

EndP            ButtonEffect2

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ButtonEffect3 Far

                Mov     BX, [SI+18]             ; Var number
                Mov     AX, [SI+20]
                Add     BX, BX
                Mov     [CS:ButtonVariables+BX], AX

                Mov     AX, 1
                Ret

EndP            ButtonEffect3

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ButtonEffect4 Far

                Jmp     DWord Ptr [SI+18]

EndP            ButtonEffect4

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ButtonEffect5 Far

                Mov     AX, 1
                Call    DWord Ptr [SI+18]
                Mov     AX, [SI+22]

                StosB
;                Mov     [ES:DI], AL

                Mov     AX, 1
                Ret

EndP            ButtonEffect5

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ButtonEffect6 Far

                Jmp    DWord Ptr [SI+24]

EndP            ButtonEffect6

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetPanning              ; DI = channel no.

                Push    DS

                Call    Music_GetSongSegment
                Mov     DS, AX

                Mov     DL, [DI+64]
                Xor     DH, DH

                Pop     DS

                Ret

EndP            GetPanning

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetPEVariables

                Push    DS

                Mov     DX, Pattern
                Mov     DS, DX
;                Call    PE_GetPatternSegment
                Mov     DL, [DI]
                Xor     DH, DH

                Pop     DS
                Ret

EndP            GetPEVariables

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetScreenVariables

                Push    DS

                Mov     DX, Screen
                Mov     DS, DX
                Mov     DL, [DI]
                Xor     DH, DH

                Pop     DS
                Ret

EndP            GetScreenVariables

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetScreenVariables

                Push    DS
                Push    AX

                Mov     AX, Screen
                Mov     DS, AX
                Pop     AX

                Mov     [DI], AL
                Call    S_SetPalette2

                Pop     DS
                Ret

EndP            SetScreenVariables

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetPanning

                Push    DS

                Push    AX
                Call    Music_GetSongSegment
                Mov     DS, AX
                Pop     AX
                Add     DI, 64

                Mov     [DI], AL

IF NETWORKENABLED
                Mov     CX, 1
                Mov     DX, DI
                Call    Network_SendSongDataInformation
ENDIF

                Pop     DS
                Ret

EndP            SetPanning

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetPEVariables

                Push    DS

                Push    AX
                Mov     AX, Pattern
                Mov     DS, AX
;                Call    PE_GetPatternSegment
                Pop     AX

                Mov     [DI], AL

                Pop     DS
                Ret

EndP            SetPEVariables

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetInstVariables

                Push    DS
                Push    AX
                Push    BX

                Call    I_GetInstrumentOffset

                Mov     DX, [BX+DI]
                Cmp     DI, 19h
                JNE     GetInstVariables1

                And     DX, 7Fh

GetInstVariables1:

; If DI = 3Ah or 3Bh, the XOR top bit.
                Cmp     DI, 3Ah
                JB      GetInstVariables4
                Cmp     DI, 3Bh
                JA      GetInstVariables4

                Xor     DL, 80h
                Jmp     GetInstVariables3

GetInstVariables4:

                Cmp     DI, 14h
                JE      GetInstVariables2
                Xor     DH, DH
                Cmp     DI, 3Dh
                JAE     GetInstVariables3
                Cmp     DI, 16h
                JNE     GetInstVariables2

GetInstVariables3:
                MovSX   DX, DL

GetInstVariables2:
                Pop     BX
                Pop     AX
                Pop     DS

                Ret

EndP            GetInstVariables
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetSampleVariables

                Push    DS
                Push    AX
                Push    BX

                Call    I_GetSampleOffset

                Mov     DL, [BX+DI]
                Xor     DH, DH
                Cmp     DI, 2Fh
                JNE     GetSampleVariables1

                And     DL, 7Fh

GetSampleVariables1:
                Pop     BX
                Pop     AX
                Pop     DS

                Ret

EndP            GetSampleVariables
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetMusicVariables

                Push    DS

                Call    Music_GetSongSegment
                Mov     DS, AX
                Xor     DX, DX
                Mov     DL, [DI]

                Pop     DS

                Ret

EndP            GetMusicVariables

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetInstrumentVariables

                Push    DS

                Mov     AX, Inst
                Mov     DS, AX
                Mov     DX, [DI]

                Pop     DS

                Ret

EndP            GetInstrumentVariables

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetDriverVariables

                Call    Music_GetDriverVariable
                Mov     DX, AX
                Ret

EndP            GetDriverVariables

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetDriverVariables

                Call    Music_SetDriverVariable
                Ret

EndP            SetDriverVariables

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetLoadSampleVariables

                Push    DS
                Push    SI
                Push    BX

                Call    D_GetLoadSampleVars
                Mov     BX, SI

                Mov     DL, [BX+DI]
                Xor     DH, DH

                Pop     BX
                Pop     SI
                Pop     DS

                Ret

EndP            GetLoadSampleVariables

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetInstVariables

                Push    DS
                Push    BX
                Push    AX

                Call    I_GetInstrumentOffset

                Pop     AX

IF FILTERENVELOPES
                Cmp     DI, 3Ah
                JB      SetInstVariables3
                Cmp     DI, 3Bh
                JA      SetInstVariables3

                Xor     AL, 80h
ELSE
                And     Word Ptr [BX+3Ah], 7F7Fh
ENDIF

SetInstVariables3:
                Mov     [BX+DI], AL
                Cmp     DI, 14h
                JNE     SetInstVariables1

SetInstVariables2:
                Mov     [BX+DI], AX

SetInstVariables1:
                NetworkSendInstrument

                Pop     BX
                Pop     DS

                Ret

EndP            SetInstVariables
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetSampleVariables

                Push    DS
                Push    BX
                Push    AX

                Call    I_GetSampleOffset

                Pop     AX
                Cmp     DI, 2Fh
                JNE     SetSampleVariables1

                Or      AL, 80h         ; Turn on.

SetSampleVariables1:
                Mov     [BX+DI], AL

                Pop     BX
                Pop     DS

                NetworkSendSample

                Ret

EndP            SetSampleVariables
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetMusicVariables

                Push    DS
                Push    AX

                Call    Music_GetSongSegment
                Mov     DS, AX

                Pop     AX
                Mov     [DI], AL

IF NETWORKENABLED
                Mov     CX, 1
                Mov     DX, DI
                Call    Network_SendSongDataInformation
ENDIF

                Cmp     DI, 31h
                JNE     SetMusicVariables1

                Call    Music_InitMixTable
                Jmp     SetMusicVariablesEnd

SetMusicVariables1:
                Cmp     DI, 30h
                JNE     SetMusicVariables3

                Call    Music_SetGlobalVolume

SetMusicVariables3:

SetMusicVariablesEnd:
                Pop     DS

                Ret

EndP            SetMusicVariables

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetInstrumentVariables

                Push    DS
                Push    AX

                Mov     AX, Inst
                Mov     DS, AX

                Pop     AX
                Mov     [DI], AX

                Pop     DS

                Ret

EndP            SetInstrumentVariables

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetLoadSampleVariables

                Push    DS
                Push    SI
                Push    BX

                Call    D_GetLoadSampleVars
                Mov     BX, SI

                Mov     [BX+DI], AL

                Pop     BX
                Pop     SI
                Pop     DS

                Ret

EndP            SetLoadSampleVariables

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MousePressThumbBar Far

                Mov     DX, CX
                Mov     CX, 8010h
                Call    AddMouseQueue

                Mov     Word Ptr [SI+8], 1109h  ; move or release
                Mov     Word Ptr [SI+12], Offset MouseHeldThumbBar

                Mov     AL, 1
                Call    SetKeyboardLock

                Xor     AX, AX

                Ret

EndP            MousePressThumbBar

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseHeldThumbBar Far

                Test    BH, 8
                JNZ     MouseHeldThumbBar2

MouseHeldThumbBar1:
                Mov     DX, CX
                Mov     CX, 8010h
                Call    AddMouseQueue
                Ret

MouseHeldThumbBar2:
                Mov     CX, 8001h               ; Redraw screen
                Call    AddMouseQueue

;                Mov     Word Ptr [SI+8], 102h
;                Mov     Word Ptr [SI+12], Offset MousePressThumbBar

                Xor     AX, AX
                Call    SetKeyboardLock

                Ret

EndP            MouseHeldThumbBar

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_DrawThumbBar Far

                Mov     [CS:MouseEventData+10], AX      ; Store object number

                Call    S_GetDestination

                Mov     BX, [SI+8]
                Mov     DI, [SI+10]
                Add     BX, BX
                Call    [CS:GetThumbValues+BX]  ; DX returns thumbbar value

                Mov     AL, 80
                Mul     Byte Ptr [SI+3]
                Add     AL, [SI+2]
                AdC     AH, 0
                Add     AX, AX
                Mov     DI, AX          ; ES:DI points to area...

                Cmp     DX, [SI+6]
                JG      F_DrawThumbBar2
                Cmp     DX, [SI+4]
                JL      F_DrawThumbBar2

                Mov     CX, [SI+6]
                Sub     CX, [SI+4]
                Add     CX, 15
                ShR     CX, 3
                Mov     BX, CX
                Mov     AX, 300h
;                Xor     AX, AX

                Push    DI
                Push    DI

                Rep     StosW

                Pop     DI
                Push    BX
                Push    DI
                Mov     BX, DX          ; DX = value to show.
                Sub     BX, [SI+4]
                Inc     BX
                Mov     AX, BX
                ShR     BX, 3
                Add     BX, BX
                Add     DI, BX
                And     AX, 7
                Add     AX, 155
                Mov     AH, 2
                StosW

                Cmp     AL, 157
                JBE     F_DrawThumbBar1
                Add     AL, 5
                StosW

F_DrawThumbBar1:
                Pop     DI
                Pop     BX
                LEA     DI, [EDI+EBX*2+2]
                Mov     CH, 21h
                Mov     AX, DX
                Call    PE_ConvAX2Num

                Pop     DI

F_DrawThumbBar2:
                Mov     BX, [SI+8]
                Add     BX, BX
                Call    [CS:DrawThumbValues+BX]  ; DX returns pan value

                Mov     CX, [SI+6]
                Sub     CX, [SI+4]
                Add     CX, 15
                ShR     CX, 3

                Xor     AH, AH
                Mov     AL, [SI+2]
                ShL     AX, 3
                Mov     [CS:MouseEventData+0], AX
                ShL     CX, 3
                Add     AX, CX
                Dec     AX
                Mov     [CS:MouseEventData+4], AX

                Xor     AH, AH
                Mov     AL, [SI+3]
                ShL     AX, 3
                Mov     [CS:MouseEventData+2], AX
                Add     AX, 7
                Mov     [CS:MouseEventData+6], AX

                Push    CS
                Pop     DS
                        Assume DS:Functions
                Mov     SI, Offset MouseEventData
                Mov     Word Ptr [SI+8], 102h
                Mov     Word Ptr [SI+12], Offset MousePressThumbBar
                Call    MouseAddEvent

                Ret

EndP            F_DrawThumbBar
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_DrawScalableThumbBar Far

                Mov     [CS:MouseEventData+10], AX      ; Store object number

                Call    S_GetDestination

                Mov     BX, [SI+8]
                Mov     DI, [SI+10]
                Add     BX, BX
                Call    [CS:GetThumbValues+BX]  ; DX returns thumbbar value

                Mov     AL, 80
                Mul     Byte Ptr [SI+3]
                Add     AL, [SI+2]
                AdC     AH, 0
                Add     AX, AX
                Mov     DI, AX          ; ES:DI points to area...

                Cmp     DX, [SI+6]
                JG      F_DrawScalableThumbBar2
                Cmp     DX, [SI+4]
                JL      F_DrawScalableThumbBar2

                Push    DI
                Push    DI

                Mov     AX, 300h
                Mov     CX, [SI+24]     ; Display length
                Inc     CX
                Rep     StosW

        ; Volume bar position = Value*Width / (MaxVal-MinVal)

                Pop     DI
                Push    DI

                Push    DX

                Mov     AX, [SI+24]
                ShL     AX, 3
                Sub     DX, [SI+4]
                Mul     DX
                Mov     CX, [SI+6]
                Sub     CX, [SI+4]
                Div     CX

                Inc     AX
                Mov     BX, AX
                ShR     BX, 3
                Add     BX, BX
                Add     DI, BX
                And     AX, 7
                Add     AX, 155
                Mov     AH, 2
                StosW

                Cmp     AL, 157
                JBE     F_DrawScalableThumbBar1
                Add     AL, 5
                StosW

F_DrawScalableThumbBar1:
                Pop     DX

                Pop     DI

                Mov     AX, [SI+24]
                LEA     DI, [EDI+EAX*2+4]
                Mov     CH, 21h
                Mov     AX, DX
                Call    PE_ConvAX2Num

                Pop     DI

F_DrawScalableThumbBar2:
                Mov     BX, [SI+8]
                Add     BX, BX
                Call    [CS:DrawThumbValues+BX]  ; DX returns pan value

                Xor     AH, AH
                Mov     AL, [SI+2]
                Mov     CX, AX
                ShL     AX, 3
                Mov     [CS:MouseEventData+0], AX
                Mov     CX, [SI+24]
                Inc     CX
                ShL     CX, 3
                Add     AX, CX
                Dec     AX
                Mov     [CS:MouseEventData+4], AX

                Xor     AH, AH
                Mov     AL, [SI+3]
                ShL     AX, 3
                Mov     [CS:MouseEventData+2], AX
                Add     AX, 7
                Mov     [CS:MouseEventData+6], AX

                Push    CS
                Pop     DS
                        Assume DS:Functions
                Mov     SI, Offset MouseEventData
                Mov     Word Ptr [SI+8], 102h
                Mov     Word Ptr [SI+12], Offset MousePressThumbBar
                Call    MouseAddEvent

                Ret

EndP            F_DrawScalableThumbBar
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            HiLightPanning

                Mov     AL, 80
                Mul     Byte Ptr [SI+3]
                Add     AL, [SI+2]
                AdC     AH, 0
                Sub     AX, 11
                Add     AX, AX
                Mov     DI, AX

                Mov     AL, 23h
                Mov     CX, 10
                Call    S_HiLight

                Ret

EndP            HiLightPanning

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_PreThumbBar Far

                Call    S_GetDestination

                Mov     BX, [SI+8]
                Mov     DI, [SI+10]
                Add     BX, BX
                Call    [CS:GetThumbValues+BX]  ; DX returns thumbbar value

                Mov     AL, 80
                Mul     Byte Ptr [SI+3]
                Add     AL, [SI+2]
                AdC     AH, 0
                Add     AX, AX
                Mov     DI, AX          ; ES:DI points to area...

                Cmp     DX, [SI+6]
                JG      F_PreThumbBar2
                Cmp     DX, [SI+4]
                JL      F_PreThumbBar2

                Mov     CX, [SI+6]
                Sub     CX, [SI+4]
                Add     CX, 15
                ShR     CX, 3
                Mov     BX, CX
                Mov     AX, 300h
;                Xor     AX, AX

                Push    DI
                Push    DI

                Rep     StosW

                Pop     DI
                Push    BX
                Push    DI
                Mov     BX, DX          ; DX = value to show.
                Sub     BX, [SI+4]
                Inc     BX
                Mov     AX, BX
                ShR     BX, 3
                Add     BX, BX
                Add     DI, BX
                And     AX, 7
                Add     AX, 155
                Mov     AH, 3
                StosW

                Cmp     AL, 157
                JBE     F_PreThumbBar1
                Add     AL, 5
                StosW

F_PreThumbBar1:
                Pop     DI
                Pop     BX
                LEA     DI, [EDI+EBX*2+2]
                Mov     CH, 21h
                Mov     AX, DX
                Call    PE_ConvAX2Num

                Pop     DI

F_PreThumbBar2:
                Mov     BX, [SI+8]
                Add     BX, BX
                Call    [CS:DrawThumbValues+BX]  ; DX returns pan value

;                Ret

                Call    S_GetDestination

                Mov     BX, [SI+8]
                Mov     DI, [SI+10]
                Add     BX, BX
                Call    [CS:PreThumbFuncs+BX]  ; DX returns pan value

                Mov     AL, 80
                Mul     Byte Ptr [SI+3]
                Add     AL, [SI+2]
                AdC     AH, 0
                Add     AX, AX
                Mov     DI, AX          ; ES:DI points to area...

F_PreThumbBar3:
                Mov     CX, [SI+6]
                Sub     CX, [SI+4]
                Add     CX, 15
                ShR     CX, 3
                Mov     AL, 3
                Call    S_HiLight
                Ret

EndP            F_PreThumbBar

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_PreScalableThumbBar Far

                Call    S_GetDestination

                Mov     BX, [SI+8]
                Mov     DI, [SI+10]
                Add     BX, BX
                Call    [CS:GetThumbValues+BX]  ; DX returns thumbbar value

                Mov     AL, 80
                Mul     Byte Ptr [SI+3]
                Add     AL, [SI+2]
                AdC     AH, 0
                Add     AX, AX
                Mov     DI, AX          ; ES:DI points to area...

                Cmp     DX, [SI+6]
                JG      F_PreScalableThumbBar2
                Cmp     DX, [SI+4]
                JL      F_PreScalableThumbBar2

                Push    DI
                Push    DI

                Mov     AX, 300h
                Mov     CX, [SI+24]     ; Display length
                Inc     CX
                Rep     StosW

        ; Volume bar position = Value*Width / (MaxVal-MinVal)

                Pop     DI
                Push    DI

                Push    DX

                Mov     AX, [SI+24]
                ShL     AX, 3
                Sub     DX, [SI+4]
                Mul     DX
                Mov     CX, [SI+6]
                Sub     CX, [SI+4]
                Div     CX

                Inc     AX
                Mov     BX, AX
                ShR     BX, 3
                Add     BX, BX
                Add     DI, BX
                And     AX, 7
                Add     AX, 155
                Mov     AH, 2
                StosW

                Cmp     AL, 157
                JBE     F_PreScalableThumbBar1
                Add     AL, 5
                StosW

F_PreScalableThumbBar1:
                Pop     DX

                Pop     DI

                Mov     AX, [SI+24]
                LEA     DI, [EDI+EAX*2+4]
                Mov     CH, 21h
                Mov     AX, DX
                Call    PE_ConvAX2Num

                Pop     DI

F_PreScalableThumbBar2:
                Mov     BX, [SI+8]
                Add     BX, BX
                Call    [CS:DrawThumbValues+BX]  ; DX returns pan value

;                Ret

                Call    S_GetDestination

                Mov     BX, [SI+8]
                Mov     DI, [SI+10]
                Add     BX, BX
                Call    [CS:PreThumbFuncs+BX]  ; DX returns pan value

                Mov     AL, 80
                Mul     Byte Ptr [SI+3]
                Add     AL, [SI+2]
                AdC     AH, 0
                Add     AX, AX
                Mov     DI, AX          ; ES:DI points to area...

F_PreScalableThumbBar3:
                Mov     CX, [SI+24]
                Inc     CX
                Mov     AL, 3
                Call    S_HiLight
                Ret

EndP            F_PreScalableThumbBar

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_PostScalableThumbBar Far

                Cmp     CX, 8010h
                JE      F_PostScalableThumbBarMouse1

                Jmp     F_PostThumbBar

F_PostScalableThumbBarMouse1:                   ; DX = pixel...
                Mov     SI, [BX]

                Xor     AX, AX
                Mov     AL, [SI+2]      ; Left point
                ShL     AX, 3           ; Left pixel
                Add     AX, 4

                Sub     DX, AX
                JNC     F_PostScalableThumbBarMouse2

                Xor     DX, DX

F_PostScalableThumbBarMouse2:   ; Value = (Pixel / NumPixels)*(Max-Min)+Min
                Mov     CX, [SI+24]     ; Length
                ShL     CX, 3           ; AX = MaxPixel
                Cmp     DX, CX
                JB      F_PostScalableThumbBarMouse3

                Mov     DX, CX

F_PostScalableThumbBarMouse3:
                Mov     AX, [SI+6]
                Sub     AX, [SI+4]
                Mul     DX
                Div     CX

                ShR     CX, 1
                Cmp     CX, DX
                AdC     AX, 0

                Add     AX, [SI+4]

                Mov     BX, [SI+8]
                Mov     DI, [SI+10]
                Add     BX, BX
                Call    [CS:PostThumbFuncs+BX]

                Mov     AX, 2
                Ret

EndP            F_PostScalableThumbBar

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_PostThumbBar Far

                Mov     SI, [BX]

                Push    ES
                Push    DI

                Call    S_GetDestination

                Mov     BX, [SI+8]
                Mov     DI, [SI+10]
                Add     BX, BX
                Push    BX
                Push    DX
                Call    [CS:GetThumbValues+BX]  ; AX contains value.
                Mov     AX, DX
                Pop     DX
                Pop     BX

                Pop     DI
                Pop     ES

                Push    AX
                Push    BX

                Call    [CS:PostThumbCheck+BX]
                Test    AX, AX
                JNZ     F_PostThumbBar23

                Pop     BX
                Pop     AX

                Cmp     CX, 8010h
                JE      F_PostThumbBarMouse1

                Cmp     CX, 8001h
                JE      F_PostThumbBarMouseRedrawScreen

                Cmp     CX, 1CBh
                JE      F_PostThumbBar2

                Cmp     CX, 1CDh
                JE      F_PostThumbBar4

                Cmp     CX, 1C7h
                JE      F_PostThumbBar10

                Cmp     CX, 1CFh
                JE      F_PostThumbBar11

                Cmp     CX, 1C8h
                JE      F_PostThumbBar5

                Cmp     CX, 1D0h
                JE      F_PostThumbBar6

                Cmp     CX, 10Fh
                JE      F_PostThumbBar7

                Cmp     CX, 1C9h
                JE      F_PostThumbBar21

                Cmp     CX, 1D1h
                JE      F_PostThumbBar22

                Test    CL, CL
                JZ      F_PostThumbBar20

                Cmp     DX, 0F00h
                JE      F_PostThumbBar8

                Cmp     DX, '0'
                JB      F_PostThumbBar50
                Cmp     DX, '9'
                JA      F_PostThumbBar50

                Jmp     F_PostThumbBar30

F_PostThumbBar50:
                Test    CX, 600h
                JNZ     F_PostThumbBar17

                Test    CX, 1800h
                JNZ     F_PostThumbBar16

F_PostThumbBar20:
                Xor     AX, AX
                Ret

F_PostThumbBar23:
                Pop     BX
                Pop     AX

F_PostThumbBarMouseRedrawScreen:
                Mov     AX, 1
                Ret

F_PostThumbBar16:
                Mov     DI, CX
                And     DI, 1FFh
                Cmp     DI, 1CBh
                JE      F_PostThumbBar14

                Cmp     DI, 1CDh
                JE      F_PostThumbBar12

                Jmp     F_PostThumbBar20

F_PostThumbBar17:
                Mov     DI, CX
                And     DI, 1FFh
                Cmp     DI, 1CBh
                JE      F_PostThumbBar18

                Cmp     DI, 1CDh
                JE      F_PostThumbBar19

                Jmp     F_PostThumbBar20

F_PostThumbBar2:
                Dec     AX
                Cmp     AX, [SI+6]
                JG      F_PostThumbBar9
                Cmp     Ax, [SI+4]
                JL      F_PostThumbBar9

F_PostThumbBar15:
                Cmp     AX, [SI+6]
                JG      F_PostThumbBarMin
                Cmp     AX, [SI+4]
                JGE     F_PostThumbBar3

F_PostThumbBarMin:
                Mov     AX, [SI+4]

F_PostThumbBar3:
                Mov     DI, [SI+10]
                Call    [CS:PostThumbFuncs+BX]

F_PostThumbBar9:
                Mov     AX, 1
                Ret

F_PostThumbBar10:
                Mov     AX, [SI+4]
                Jmp     F_PostThumbBar3

F_PostThumbBar11:
                Mov     AX, [SI+6]
                Jmp     F_PostThumbBar3

F_PostThumbBar4:
                Inc     AX
                Cmp     AX, [SI+4]
                JL      F_PostThumbBar9

                Cmp     AX, [SI+6]
                JG      F_PostThumbBar9

F_PostThumbBar13:
                Cmp     AX, [SI+4]
                JL      F_PostThumbBarMax
                Cmp     AX, [SI+6]
                JLE     F_PostThumbBar3

F_PostThumbBarMax:
                Mov     AX, [SI+6]
                Jmp     F_PostThumbBar3

F_PostThumbBar12:
                Add     AX, 2
                Jmp     F_PostThumbBar13

F_PostThumbBar14:
                Sub     AX, 2
                Jmp     F_PostThumbBar15

F_PostThumbBar18:
                Sub     AX, 4
                Jmp     F_PostThumbBar15

F_PostThumbBar19:
                Add     AX, 4
                Jmp     F_PostThumbBar13

F_PostThumbBar22:
                LodsW

F_PostThumbBar21:
                LodsW

F_PostThumbBar8:
                LodsW

F_PostThumbBar7:
                LodsW

F_PostThumbBar6:
                LodsW

F_PostThumbBar5:
                Add     SI, 12
                LodsW
                Cmp     AX, 0FFFFh
                JE      F_PostThumbBar20

                Mov     [DI], AX
                Jmp     F_PostThumbBar9

F_PostThumbBarMouse1:                   ; DX = pixel...
                Xor     AX, AX
                Mov     AL, [SI+2]      ; Left point
                ShL     AX, 3           ; Left pixel
                Sub     DX, AX
                Sub     DX, 4
                Mov     AX, [SI+4]
                Add     AX, DX

                Cmp     AX, [SI+4]
                JG      F_PostThumbBarMouse2

                Mov     AX, [SI+4]
                Jmp     F_PostThumbBarMouse3

F_PostThumbBarMouse2:
                Cmp     AX, [SI+6]
                JL      F_PostThumbBarMouse3

                Mov     AX, [SI+6]

F_PostThumbBarMouse3:
                Mov     BX, [SI+8]
                Mov     DI, [SI+10]
                Add     BX, BX
                Call    [CS:PostThumbFuncs+BX]

                Mov     AX, 2
                Ret

F_PostThumbBar30:
                Push    DS
                Push    SI

                Call    S_SaveScreen

                Mov     DI, Offset ThumbStringEnter
                Push    CS
                Pop     ES
                Mov     AL, DL
                StosB

                Xor     AL, AL
                Mov     CX, 4
                Rep     StosB

                Mov     DI, Offset O1_ThumbStringList
                Mov     CX, 3
                Call    M_Object1List

                Call    S_RestoreScreen

                Pop     SI
                Pop     DS

                And     DX, DX
                JZ      F_PostThumbBar31

                                        ; Now get value...
                Xor     CX, CX
                Mov     DI, Offset ThumbStringEnter

F_PostThumbBar32:
                Mov     AL, [CS:DI]
                And     AL, AL
                JZ      F_PostThumbBar33

                Inc     DI

                Push    AX
                Mov     AX, 10
                Mul     CX
                Mov     CX, AX
                Pop     AX

                Cmp     AL, '0'
                JB      F_PostThumbBar31
                Cmp     AL, '9'
                JA      F_PostThumbBar31

                Sub     AL, '0'
                Xor     AH, AH
                Add     CX, AX
                Jmp     F_PostThumbBar32

F_PostThumbBar33:                               ; now save value.
                Cmp     DI, Offset ThumbStringEnter
                JE      F_PostThumbBar31

                Mov     AX, CX

                Cmp     AX, [SI+4]
                JL      F_PostThumbBar31
                Cmp     AX, [SI+6]
                JG      F_PostThumbBar31

                Mov     BX, [SI+8]
                Mov     DI, [SI+10]
                Add     BX, BX
                Call    [CS:PostThumbFuncs+BX]

F_PostThumbBar31:
                Mov     AX, 1
                Ret

EndP            F_PostThumbBar

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_DrawInfoLine Far

                Push    ES
                LodsW
                Push    SI
                Xor     DX, DX

F_DrawInfoLine1:
                LodsB
                Inc     DX
                And     AL, AL
                JNZ     F_DrawInfoLine1

                Dec     DX
                Pop     SI                      ; DX contains length of string
                Call    S_GetDestination

                Mov     DI, (1+11*80)*2
                Mov     BX, 78
                Mov     CX, BX
                Cmp     Byte Ptr [SI], 0
                JE      F_DrawInfoLine3

                Sub     CX, DX
                ShR     CX, 1
                Sub     BX, CX
                Sub     BX, DX
                Sub     BX, 2

                Mov     AX, 219Ah
                Rep     StosW

                Mov     AX, 2020h
                StosW

F_DrawInfoLine2:
                LodsB
                StosW
                Dec     DX
                JNZ     F_DrawInfoLine2

                Mov     AX, 2020h
                StosW

                Mov     CX, BX

F_DrawInfoLine3:
                Mov     AX, 219Ah
                Rep     StosW

                Pop     ES
                Ret

EndP            F_DrawInfoLine

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_ShowChannels Far

                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Functions

                Mov     DI, (20+15*80)*2
                Mov     CX, 32
                Mov     AX, 3130h
                Mov     Word Ptr ChannelNumbers, AX
                Mov     AH, 20h
                Call    F_ShowChannel1

                Mov     DI, (54+15*80)*2
                Mov     CX, 32
                Call    F_ShowChannel1

                Pop     DS
                        Assume DS:Nothing
                Ret

EndP            F_ShowChannels

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_ShowChannel1

                        Assume DS:Functions

F_ShowChannel1_1:
                Mov     SI, Offset ChannelMsg
                Call    S_DrawString

                Inc     Byte Ptr [ChannelNumbers+1]
                Cmp     Byte Ptr [ChannelNumbers+1], '9'
                JBE     F_ShowChannel1_2

                Inc     Byte Ptr [ChannelNumbers]
                Mov     Byte Ptr [ChannelNumbers+1], '0'

F_ShowChannel1_2:
                Add     DI, 140
                Loop    F_ShowChannel1_1

                        Assume DS:Nothing

                Ret

EndP            F_ShowChannel1

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_RedrawScreen Far

                Mov     AX, 1
                Ret

EndP            F_RedrawScreen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_Return0 Far           ; ESC pressed on opening scrn

                Xor     DX, DX
                Mov     AX, 4
                Ret

EndP            F_Return0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_Return64 Far

                Mov     DX, 64
                Mov     AX, 4
                Ret

EndP            F_Return64

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_Return192 Far

                Mov     DX, 192
                Mov     AX, 4
                Ret

EndP            F_Return192

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PanningKeys

                Push    AX
                Mov     AX, DX
                Cmp     AX, 'a'
                JB      PanningKeys1

                Cmp     AX, 'z'
                JA      PanningKeys3

                Sub     AX, 32

PanningKeys1:
                Cmp     AL, 'L'
                JE      PanningKeysLeft
                Cmp     AL, 'R'
                JE      PanningKeysRight
                Cmp     AL, 'M'
                JE      PanningKeysMiddle
                Cmp     AL, 'S'
                JE      PanningKeysSurround
                Cmp     AL, ' '
                JE      PanningKeysSpace

PanningKeys3:
                Pop     AX
                Xor     AX, AX
                Ret

PanningKeysLeft:
                Xor     AX, AX
                Jmp     PanningKeys2

PanningKeysRight:
                Mov     AX, 64
                Jmp     PanningKeys2

PanningKeysMiddle:
                Mov     AX, 32
                Jmp     PanningKeys2

PanningKeysSurround:
                Mov     AX, 100

PanningKeys2:
                Mov     DI, [SI+10]
                Call    SetPanning
                Pop     AX

                Mov     AX, 1
                Ret

PanningKeysSpace:
                Pop     AX
                Xor     AL, 128
                Push    AX

                Mov     BX, [ES:DI]
                Cmp     BX, 74
                JAE     PanningKeys2

                Inc     Word Ptr [ES:DI]

                Jmp     PanningKeys2

EndP            PanningKeys

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            FilterKeys

                Push    DI
                Mov     DI, [SI+10]

                Cmp     DI, 3Ah
                JB      FilterKeys1
                Cmp     DI, 3Bh
                JA      FilterKeys1

                Cmp     DX, ' '
                JNE     FilterKeys1

                Xor     AL, 80h
                Call    SetInstVariables

                Mov     AX, 1
                Jmp     FilterKeysEnd

FilterKeys1:
                Xor     AX, AX
FilterKeysEnd:
                Pop     DI
                Ret

EndP            FilterKeys

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DrawPanning

                Push    DS
                Push    SI

                Push    CS
                Pop     DS

                Test    DL, 128
                JZ      DrawPanning2

                Mov     SI, Offset MutedMessage
                Mov     AH, 5
                Call    S_DrawString

                Jmp     DrawPanning1

DrawPanning2:
                Cmp     DX, 100
                JNE     DrawPanning1

                Mov     SI, Offset SurroundMessage
                Mov     AH, 5
                Call    S_DrawString

DrawPanning1:
                Pop     SI
                Pop     DS
                Ret

EndP            DrawPanning

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DrawMIDIChannel

                Mov     AX, [SI+0Ah]
                Cmp     AX, 3Fh
                JA      DrawMIDIChannel2
                Cmp     AX, 3Ah
                JB      DrawMIDIChannel2

                Cmp     AX, 3Ch
                JNE     DrawMIDIChannel4

DrawMIDIChannel1:
                Cmp     DL, 17
                JNE     DrawMIDIChannel5

                Add     DI, 22
                Mov     AX, 200h+'M'
                StosW
                Mov     AL, 'a'
                StosW
                Mov     AL, 'p'
                StosW
                StosW
                Mov     AL, 'e'
                StosW
                Mov     AL, 'd'
                StosW

DrawMIDIChannel5:
                Test    DL, DL
                JZ      DrawMIDIChannel3
                Jmp     DrawMIDIChannel2

DrawMIDIChannel4:
                Test    DX, DX
                JNS     DrawMIDIChannel2

DrawMIDIChannel3:
                Mov     AX, 200h+'O'
                StosW
                Mov     AL, 'f'
                StosW
                StosW
                Jmp     DrawMIDIChannel2

DrawMIDIChannel2:
                Ret

EndP            DrawMIDIChannel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_Return1 Far

                Mov     DX, 1
                Mov     AX, 4
                Ret

EndP            F_Return1

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetSIOInstSegment

                Mov     SI, Inst
                Mov     DS, SI
                Mov     SI, CX

                Ret

EndP            GetSIOInstSegment

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetSIODiskSegment

                Mov     SI, Disk
                Mov     DS, SI
                Mov     SI, CX

                Ret

EndP            GetSIODiskSegment

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetLoadSampleString             ; Returns DS:SI

                Call    D_GetLoadSampleVars     ; Gets SI = currentsample offset
                                                ; DS = DiskDataArea
                Add     SI, CX

                Ret

EndP            GetLoadSampleString

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetMusicSegmentString

                Call    Music_GetSongSegment
                Mov     DS, AX

                Mov     SI, CX

                Ret

EndP            GetMusicSegmentString

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetMusicSegmentString

IF NETWORKENABLED
                Mov     CX, 26
                Mov     DX, 4
                Call    Network_SendSongDataInformation
ENDIF
                Ret

EndP            SetMusicSegmentString

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetPatternSegmentString

                Push    CS
                Pop     DS

                Mov     SI, CX

                Ret

EndP            GetPatternSegmentString

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetSampleString

                Call    I_GetSampleOffset
                Mov     SI, BX
                Add     SI, CX

                Ret

EndP            GetSampleString

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetSampleString

                NetworkSendSample

                Ret

EndP            SetSampleString

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetInstrumentString

                Call    I_GetInstrumentOffset
                Mov     SI, BX
                Add     SI, CX

                Ret

EndP            GetInstrumentString

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetInstrumentString

                NetworkSendInstrument
                Ret

EndP            SetInstrumentString

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

TopMIDIMacro    DW      80h

Proc            GetMIDIString           ; CX = select2

                Push    Music
                Pop     DS
                        Assume DS:Music

                Mov     DS, MIDIDataArea
                        Assume DS:Nothing

                Mov     SI, CX
                Test    CX, CX
                JNS     GetMIDIString1

                Mov     CX, CS:TopMIDIMacro
                Sub     SI, 8000h+80h*20h
                ShL     CX, 5
                Add     SI, CX

GetMIDIString1:
                Ret

EndP            GetMIDIString

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseSelectString Far

                Mov     CX, 8010h
                Xor     DX, DX
                Call    AddMouseQueue

                Xor     AX, AX

                Ret

EndP            MouseSelectString

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

PostStringFunction      DW      0

Proc            F_GetStringInputOffset

                Mov     BX, [SI+4]
                Mov     CX, [SI+6]

                Mov     [CS:PostStringFunction], Offset F_NothingNear

                Cmp     BX, 10h
                JA      F_GetStringInputOffset1

                Add     BX, BX
                Push    AX

                Mov     AX, [CS:PostStringInput+BX]
                Mov     PostStringFunction, AX

                Pop     AX
                Call    [CS:StringInputOffset+BX]       ; DS:SI points to string
                Ret

F_GetStringInputOffset1:
                Mov     DS, BX
                Mov     SI, CX
                Ret

EndP            F_GetStringInputOffset

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_DrawStringInput Far

                Mov     [CS:MouseEventData+10], AX      ; Store object number

                Push    DS
                Push    SI

                Mov     AL, 80
                Mul     Byte Ptr [SI+3]
                Add     AL, [SI+2]
                AdC     AH, 0
                Add     AX, AX
                Mov     DI, AX
                Call    S_GetDestination

                Call    F_GetStringInputOffset

                Mov     AH, 2h

F_DrawStringInput1:
                LodsB
                Test    AL, AL
                JZ      F_DrawStringInput2
                Cmp     AL, 226
                JB      F_DrawStringInput3

                Mov     AL, ' '

F_DrawStringInput3:

                StosW
                Jmp     F_DrawStringInput1

F_DrawStringInput2:
                Pop     SI
                Pop     DS

                Xor     AH, AH
                Mov     AL, [SI+2]      ; XValue
                Mov     CX, AX
                ShL     CX, 3
                Mov     [CS:MouseEventData+0], CX

                Add     AL, [SI+8]
                Mov     CX, AX
                ShL     CX, 3
                Dec     CX
                Mov     [CS:MouseEventData+4], CX

                Mov     AL, [SI+3]
                ShL     AX, 3
                Mov     [CS:MouseEventData+2], AX
                Add     AX, 7
                Mov     [CS:MouseEventData+6], AX

                Push    CS
                Pop     DS
                        Assume DS:Functions

                Mov     SI, Offset MouseEventData
                Mov     [MouseEventData+8], 102h
                Mov     [MouseEventData+12], Offset MouseSelectString

                Call    MouseAddEvent

                Ret

EndP            F_DrawStringInput
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_PreStringInput Far

                Mov     AL, 80
                Mul     Byte Ptr [SI+3]
                Add     AL, [SI+2]
                AdC     AH, 0
                Add     AX, AX
                Mov     DI, AX
                Call    S_GetDestination

                Call    F_GetStringInputOffset

F_PreStringInput1:
                LodsB
                And     AL, AL
                JZ      F_PreStringInput2
                ScasW
;                Add     DI, 2
                Jmp     F_PreStringInput1

F_PreStringInput2:
                Inc     DI
                Mov     AL, 30h
                StosB
                Ret

EndP            F_PreStringInput

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_PostStringInput Far

                Test    CL, CL
                JZ      F_PostStringInput9

                Mov     SI, [BX]

                Cmp     CX, 8010h
                JE      F_PostStringInput5

                Cmp     CX, 1C8h
                JNE     F_PostStringInput1

                Mov     AX, [SI+14]
                Jmp     F_PostStringInput4

F_PostStringInput1:
                Cmp     CX, 1D0h
                JNE     F_PostStringInput2

                Mov     AX, [SI+16]
                Jmp     F_PostStringInput4

F_PostStringInput2:
                Cmp     CX, 10Fh        ; Tab
                JNE     F_PostStringInput3

                Mov     AX, [SI+18]
                Jmp     F_PostStringInput4

F_PostStringInput3:
                Cmp     DX, 0F00h
                JNE     F_PostStringInput6

                Mov     AX, [SI+20]

F_PostStringInput4:
                Cmp     AX, 0FFFFh
                JE      F_PostStringInput12

;                Mov     Word Ptr CS:LastStringData, 0
;                Mov     Word Ptr CS:LastStringData+2, 0

                Mov     [DI], AX

F_PostStringInput5:
                Mov     AX, 1
                Ret

F_PostStringInput6:
                Cmp     CX, 11Ch                        ; Enter
                JNE     F_PostStringInput7

                Cmp     Word Ptr [SI+10], 0
                JNE     F_PostStringInput13

                Cmp     Word Ptr [SI+12], 0
                JE      F_PostStringInput12

F_PostStringInput13:
                Jmp     DWord Ptr [SI+10]

F_PostStringInput7:
                Cmp     CX, 10Eh                ; Backspace
                JNE     F_PostStringInput8

                Call    F_GetStringInputOffset

                Cmp     Byte Ptr [DS:SI], 0
                JE      F_PostStringBackSpace2

F_PostStringBackSpace1:
                LodsB
                And     AL, AL
                JNZ     F_PostStringBackSpace1

                Mov     [SI-2], AL

F_PostStringBackSpace2:
                Jmp     F_PostStringInput11

F_PostStringInput8:
                Cmp     DX, 127                         ; Ctrl-Backspace
                JNE     F_PostStringInput12

                Mov     DX, [SI+8]
                Call    F_GetStringInputOffset

                Mov     CX, DX
                Mov     AX, DS
                Mov     ES, AX
                Mov     DI, SI
                Xor     AL, AL
                Rep     StosB

                Jmp     F_PostStringInput11

F_PostStringInput12:
                Test    CL, CL
                JZ      F_PostStringInput9
                Cmp     DL, 32
                JB      F_PostStringInput9

                Mov     DI, [SI+8]
                Call    F_GetStringInputOffset

                Xor     BX, BX

F_PostStringInput10:
                LodsB
                Inc     BX
                And     AL, AL
                JNZ     F_PostStringInput10

                Dec     SI
                Cmp     BX, DI
                JAE     F_PostStringInput11

                Mov     AL, DL
                Xor     AH, AH
                Mov     [DS:SI], AX

F_PostStringInput11:
                Call    [CS:PostStringFunction]

                Mov     AX, 1
                Ret

F_PostStringInput9:
                Xor     AX, AX
                Ret

EndP            F_PostStringInput

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_GotoEmptyList Far

                Mov     AX, 5
                Mov     SI, 1
                Mov     DI, AX
                Mov     CX, Object1
                Mov     DX, Offset O1_EmptyList

                Ret

EndP            F_GotoEmptyList

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetSampleToggle

                Push    DS

                Call    I_GetSampleOffset
                Xor     CL, CL

                Mov     DH, [BX+DI]
                Test    DH, DL
                JZ      GetSampleToggle1

                Inc     CX

                Cmp     DI, 2Fh
                JE      GetSampleToggle1

                ShL     DL, 1
                ShL     DL, 1

                Pop     DS
                Push    DS

                Mov     AL, 80
                Mul     Byte Ptr [SI+3]
                Add     AL, [SI+2]
                AdC     AH, 0
                Add     AX, AX
                LEA     DI, [EAX+6]             ; DI points to screen part.
                Push    DS
                Push    SI

                Mov     SI, Offset ForwardMsg
                Test    DH, DL
                JZ      GetSampleToggle2

                Mov     SI, Offset PingPongMsg

GetSampleToggle2:
                Push    CS
                Pop     DS
                Mov     AH, 2
                Call    S_DrawString

                Pop     SI
                Pop     DS

GetSampleToggle1:
                Pop     DS
                Ret

EndP            GetSampleToggle

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetInstrumentToggle

                Push    DS

                Call    I_GetInstrumentOffset
                Xor     CL, CL

                Mov     DH, [BX+DI]
                Test    DH, DL
                JZ      GetInstrumentToggle1

                Inc     CX

                Cmp     DI, 1D4h
                JNE     GetInstrumentToggle1
                Cmp     DL, 1
                JNE     GetInstrumentToggle1

                Push    DS
                Push    SI

                Push    CS
                Pop     DS

                Mov     DI, (28*80+57)*2
                Mov     AH, 2
                Mov     SI, Offset PitchMessage
                Test    DH, DH
                JNS     GetInstrumentToggle3

                Mov     SI, Offset FilterMessage

GetInstrumentToggle3:
                Call    S_DrawString

                Pop     SI
                Pop     DS

GetInstrumentToggle1:
                Cmp     DI, 19h
                JNE     GetInstrumentToggle2

                Xor     CL, 1

GetInstrumentToggle2:
                Pop     DS
                Ret

EndP            GetInstrumentToggle

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetLoadSampleToggle

                Push    DS
                Push    SI
                Call    D_GetLoadSampleVars     ; Gets SI = currentsample offset
                                                ; DS = DiskDataArea

                Mov     BX, SI
                Pop     SI

                Xor     CL, CL

                Mov     DH, [BX+DI]
                Test    DH, DL
                JZ      GetLoadSampleToggle1

                Inc     CX

                ShL     DL, 1
                ShL     DL, 1

                Pop     DS
                Push    DS

                Mov     AL, 80
                Mul     Byte Ptr [SI+3]
                Add     AL, [SI+2]
                AdC     AH, 0
                Add     AX, AX
                LEA     DI, [EAX+6]             ; DI points to screen part
                Push    DS
                Push    SI

                Mov     SI, Offset ForwardMsg
                Test    DH, DL
                JZ      GetLoadSampleToggle2

                Mov     SI, Offset PingPongMsg

GetLoadSampleToggle2:
                Push    CS
                Pop     DS
                Mov     AH, 2
                Call    S_DrawString

                Pop     SI
                Pop     DS

GetLoadSampleToggle1:
                Pop     DS
                Ret

EndP            GetLoadSampleToggle

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetPatternSegmentToggle

                Push    DS

                Mov     AX, Pattern
                Mov     DS, AX

                Xor     CL, CL
                Test    [DS:DI], DL
                JZ      GetPatternSegmentToggle1

                Inc     CX

GetPatternSegmentToggle1:
                Pop     DS
                Ret

EndP            GetPatternSegmentToggle

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetMusicSegmentToggle

                Push    DS

                Call    Music_GetSongSegment
                Mov     DS, AX

                Xor     CL, CL
                Test    [DS:DI], DL
                JZ      GetMusicSegmentToggle1

                Inc     CX

GetMusicSegmentToggle1:
                Pop     DS
                Ret

EndP            GetMusicSegmentToggle

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SampleToggle

                Push    DS

                Call    I_GetSampleOffset

                Cmp     DI, 2Fh
                JNE     SampleToggle6

                Xor     [BX+DI], DL

                Jmp     SampleToggleEnd

SampleToggle6:
                Mov     DH, DL
                ShL     DH, 1
                ShL     DH, 1
                Test    [BX+DI], DL
                JZ      SampleToggle3

                Test    [BX+DI], DH
                JNZ     SampleToggle3

                Xor     [BX+DI], DH

                Call    Music_RegetLoopInformation
                Jmp     SampleToggleEnd

SampleToggle3:
                Xor     [BX+DI], DL
                Test    [BX+DI], DL
                JZ      SampleToggle1
                                        ; Something was just toggled On.
                Not     DH
                And     [BX+DI], DH

                Cmp     DL, 10h
                JE      SampleToggle2
                Cmp     DL, 20h
                JNE     SampleToggle1       ; Safety Check.
                                        ; Sustain Loop.
                Mov     EAX, [BX+40h]    ; SusLBeg
                Cmp     EAX, [BX+30h]
                JB      SampleToggle4

                Xor     EAX, EAX
                Mov     [BX+40h], EAX

SampleToggle4:
                Cmp     EAX, [BX+44h]
                JB      SampleToggle1

                Mov     EAX, [BX+30h]
                Mov     [BX+44h], EAX
                Jmp     SampleToggle1

SampleToggle2:                      ; Normal Loop
                Mov     EAX, [BX+34h]
                Cmp     EAX, [BX+30h]
                JB      SampleToggle5

                Xor     EAX, EAX
                Mov     [BX+34h], EAX

SampleToggle5:
                Cmp     EAX, [BX+38h]
                JB      SampleToggle1

                Mov     EAX, [BX+30h]
                Mov     [BX+38h], EAX

SampleToggle1:
                Call    Music_RegetLoopInformation
                Call    I_DrawWaveForm

SampleToggleEnd:
                NetworkSendSample

                Pop     DS
                Ret

EndP            SampleToggle

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InstrumentToggle

                Push    DS

                Call    I_GetInstrumentOffset

IF FILTERENVELOPES
                Cmp     DI, 1D4h
                JNE     InstrumentToggle2
                Cmp     DL, 1
                JNE     InstrumentToggle2

                Xor     Byte Ptr [BX+DI], 80h
                JNS     InstrumentToggle3

                Test    [BX+DI], DL
                JZ      InstrumentToggle2

                And     Byte Ptr [BX+DI], 7Fh

InstrumentToggle2:
ELSE
                And     Byte Ptr [BX+1D4h], 7Fh
ENDIF
                Xor     [BX+DI], DL

InstrumentToggle3:
                Call    I_MapEnvelope

                NetworkSendInstrument

                Pop     DS
                Ret

EndP            InstrumentToggle

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LoadSampleToggle

                Push    DS
                Push    SI
                Call    D_GetLoadSampleVars     ; Gets SI = currentsample offset
                                                ; DS = DiskDataArea

                Mov     BX, SI
                Pop     SI

                Mov     DH, DL
                ShL     DH, 1
                ShL     DH, 1
                Test    [BX+DI], DL
                JZ      LoadSampleToggle3

                Test    [BX+DI], DH
                JNZ     LoadSampleToggle3

                Xor     [BX+DI], DH
                Pop     DS
                Ret

LoadSampleToggle3:
                Xor     [BX+DI], DL
                Test    [BX+DI], DL
                JZ      LoadSampleToggle1
                                        ; Something was just toggled On.
                Not     DH
                And     [BX+DI], DH

                Cmp     DL, 10h
                JE      LoadSampleToggle2
                Cmp     DL, 20h
                JNE     LoadSampleToggle1       ; Safety Check.
                                        ; Sustain Loop.
                Mov     EAX, [BX+40h]    ; SusLBeg
                Cmp     EAX, [BX+30h]
                JB      LoadSampleToggle4

                Xor     EAX, EAX
                Mov     [BX+40h], EAX

LoadSampleToggle4:
                Cmp     EAX, [BX+44h]
                JB      LoadSampleToggle1

                Mov     EAX, [BX+30h]
                Mov     [BX+44h], EAX
                Jmp     LoadSampleToggle1

LoadSampleToggle2:                      ; Normal Loop
                Mov     EAX, [BX+34h]
                Cmp     EAX, [BX+30h]
                JB      LoadSampleToggle5

                Xor     EAX, EAX
                Mov     [BX+34h], EAX

LoadSampleToggle5:
                Cmp     EAX, [BX+38h]
                JB      LoadSampleToggle1

                Mov     EAX, [BX+30h]
                Mov     [BX+38h], EAX

LoadSampleToggle1:
                Call    D_DrawWaveForm

                Pop     DS
                Ret

EndP            LoadSampleToggle

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PatternSegmentToggle

                Push    DS
                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern

                Xor     [DS:DI], DL

                Cmp     DI, Offset MultiChannelInfo
                JB      PatternSegmentToggle1
                Cmp     DI, Offset MultiChannelInfo+64
                JAE     PatternSegmentToggle1

                Test    CX, 8000h
                JNZ     PatternSegmentToggle1

                Inc     Word Ptr [ES:BP]

PatternSegmentToggle1:
                Pop     DS
                Ret

EndP            PatternSegmentToggle
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MusicSegmentToggle

                Push    DS
                Call    Music_GetSongSegment
                Mov     DS, AX

                Xor     [DS:DI], DL

IF NETWORKENABLED
                Mov     CX, 1
                Mov     DX, DI
                Call    Network_SendSongDataInformation
ENDIF

                Pop     DS
                Ret

EndP            MusicSegmentToggle

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseToggle Far

                Mov     CX, 8010h
                Mov     DX, ' '
                Call    AddMouseQueue

                Xor     AX, AX

                Ret

EndP            MouseToggle

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_DrawToggle Far

                Mov     [CS:MouseEventData+10], AX      ; Store object number

                Call    S_GetDestination
                Mov     BX, [SI+4]              ; Segment no.
                Mov     DI, [SI+6]
                Mov     DL, [SI+8]
                Add     BX, BX
                Call    [CS:GetToggleStatus+BX] ; Returns CL with 0=off, 1=on

                Mov     AL, 80
                Mul     Byte Ptr [SI+3]
                Add     AL, [SI+2]
                AdC     AH, 0
                Add     AX, AX
                Mov     DI, AX                  ; DI points to screen part.

                Mov     AX, 200h+'O'
                StosW
                And     CL, CL
                JZ      F_DrawToggle1

                Mov     AL, 'n'
                StosW
                Jmp     F_DrawToggle2

F_DrawToggle1:
                Mov     AL, 'f'
                StosW
                StosW

F_DrawToggle2:
                Xor     AH, AH
                Mov     AL, [SI+2]      ; XValue
                ShL     AX, 3
                Mov     [CS:MouseEventData+0], AX
                Add     AX, 23
                Mov     [CS:MouseEventData+4], AX

                Xor     AH, AH
                Mov     AL, [SI+3]
                ShL     AX, 3
                Mov     [CS:MouseEventData+2], AX
                Add     AX, 7
                Mov     [CS:MouseEventData+6], AX

                Push    CS
                Pop     DS
                        Assume DS:Functions

                Mov     SI, Offset MouseEventData
                Mov     [MouseEventData+8], 102h
                Mov     [MouseEventData+12], Offset MouseToggle

                Call    MouseAddEvent

                Ret

EndP            F_DrawToggle

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_PreToggle Far

                Call    S_GetDestination
                Mov     BX, [SI+4]              ; Segment no.
                Mov     DI, [SI+6]
                Mov     DL, [SI+8]
                Add     BX, BX
                Call    [CS:GetToggleStatus+BX] ; Returns CL with 0=off, 1=on

                Xor     CH, CH
                Neg     CL
                Add     CL, 3                   ; CL = number to hilight

                Mov     AL, 80
                Mul     Byte Ptr [SI+3]
                Add     AL, [SI+2]
                AdC     AH, 0
                Add     AX, AX
                Mov     DI, AX

                Mov     AL, 30h
                Call    S_HiLight

                Ret

EndP            F_PreToggle

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_PostToggle Far

                Mov     SI, [BX]

                Test    CL, CL
                JZ      F_PostToggle7

                Cmp     DX, ' '
                JNE     F_PostToggle1

                Mov     BP, DI

                Mov     BX, [SI+4]              ; Segment no.
                Mov     DI, [SI+6]
                Mov     DL, [SI+8]
                Add     BX, BX
                Call    [CS:ToggleBit+BX]

                Mov     AX, 1
                Ret

F_PostToggle1:
                Cmp     CX, 1C8h
                JE      F_PostToggle5
                Cmp     CX, 1D0h
                JE      F_PostToggle4
                Cmp     CX, 10Fh        ; Tab
                JE      F_PostToggle3
                Cmp     CX, 1CDh
                JE      F_PostToggle3
                Cmp     DX, 0F00h
                JE      F_PostToggle2
                Cmp     CX, 1CBh
                JE      F_PostToggle2

F_PostToggle7:
                Xor     AX, AX
                Ret

F_PostToggle2:
                LodsW
F_PostToggle3:
                LodsW
F_PostToggle4:
                LodsW
F_PostToggle5:
                Add     SI, 9
                LodsW
                Cmp     AX, 0FFFFh
                JE      F_PostToggle7

                Mov     [DI], AX

F_PostToggle6:
                Mov     AX, 1
                Ret

EndP            F_PostToggle

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetInstrument3Num

                Push    DS

                Call    I_GetInstrumentOffset

                Mov     AL, [BX+DI]
                Xor     AH, AH

                Pop     DS
                Ret

EndP            GetInstrument3Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetInstrument3Num               ; AX = value.

                Push    DS
                Push    SI
                Push    AX

                Mov     AX, Inst
                Mov     DS, AX
                        Assume DS:Inst

                Mov     CX, MaxNode
                Dec     CL
                        Assume DS:Nothing


                Call    I_GetInstrumentOffset

                Pop     AX
                Cmp     AL, CL
                JB      SetInstrument3Num1

                Mov     AL, CL

SetInstrument3Num1:
                Mov     [BX+DI], AL

                Mov     SI, 132h
                Call    Near Ptr SetInstrument3Num2

                Mov     SI, 134h
                Call    Near Ptr SetInstrument3Num2

                Mov     SI, 184h
                Call    Near Ptr SetInstrument3Num2

                Mov     SI, 186h
                Call    Near Ptr SetInstrument3Num2

                Mov     SI, 1D6h
                Call    Near Ptr SetInstrument3Num2

                Mov     SI, 1D8h
                Call    Near Ptr SetInstrument3Num2

                Call    I_MapEnvelope

                Pop     SI
                Pop     DS

                Ret

SetInstrument3Num2:
                Mov     AL, [BX+SI]
                Cmp     AL, [BX+SI+1]
                JBE     SetInstrument3Num3

                Mov     [BX+SI+1], AL

SetInstrument3Num3:
                RetN

EndP            SetInstrument3Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetSample5Num

                Push    DS

                Call    I_GetSampleOffset

                Mov     EAX, [BX+DI]

                Pop     DS
                Ret

EndP            GetSample5Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetLoadSample5Num

                Push    DS
                Push    SI
                Call    D_GetLoadSampleVars     ; Gets SI = currentsample offset
                                                ; DS = DiskDataArea

                Mov     BX, SI
                Mov     EAX, [BX+DI]

                Pop     SI
                Pop     DS

                Ret

EndP            GetLoadSample5Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetInst5Num

                Push    DS
                Mov     AX, Inst

                Mov     DS, AX
                Mov     EAX, [DI]

                Pop     DS
                Ret

EndP            GetInst5Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetSample5Num               ; AX = value.

                Push    DS
                Push    AX

                Call    I_GetSampleOffset

                Pop     AX
                Mov     [BX+DI], EAX

                Pop     DS

                NetworkSendSample

                Ret

EndP            SetSample5Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetLoadSample5Num               ; AX = value.

                Push    DS
                Push    SI

                Call    D_GetLoadSampleVars     ; Gets SI = currentsample offset
                Mov     BX, SI

                Mov     [BX+DI], EAX

                Pop     SI
                Pop     DS
                Ret

EndP            SetLoadSample5Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetInst5Num

                Push    DS

                Mov     BX, Inst
                Mov     DS, BX
                Mov     [DI], EAX

                Pop     DS

                Ret

EndP            SetInst5Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseNumberDecrement Far

                Mov     CX, 8010h
                Mov     DX, '-'
                Call    AddMouseQueue

                Xor     AX, AX

                Ret

EndP            MouseNumberDecrement

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseNumberIncrement Far

                Mov     CX, 8010h
                Mov     DX, '+'
                Call    AddMouseQueue

                Xor     AX, AX

                Ret

EndP            MouseNumberIncrement

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_Draw3Num Far

                Mov     [CS:MouseEventData+10], AX      ; Store object number

                Mov     BX, [SI+4]
                Add     BX, BX
                Mov     DI, [SI+6]

                Call    [CS:Get3NumValues+BX]           ; AX = value.

                Push    AX

                Mov     AL, 80
                Mul     Byte Ptr [SI+3]
                Add     AL, [SI+2]
                AdC     AH, 0
                Add     AX, AX
                Mov     DI, AX
                Call    S_GetDestination

                Pop     AX
                Xor     DX, DX
                Mov     CH, 2
                Call    PE_ConvAX2Num

                Xor     AX, AX
                Mov     AL, [SI+2]              ; X value
                ShL     AX, 3
                Mov     [CS:MouseEventData+0], AX
                Add     AX, 3*8-1
                Mov     [CS:MouseEventData+4], AX
                Xor     AX, AX
                Mov     AL, [SI+3]
                ShL     AX, 3
                Mov     [CS:MouseEventData+2], AX
                Add     AX, 7
                Mov     [CS:MouseEventData+6], AX

                Push    CS
                Pop     DS

                Mov     SI, Offset MouseEventData
                Mov     Word Ptr [SI+8], 102h
                Mov     Word Ptr [SI+12], Offset MouseNumberDecrement
                Call    MouseAddEvent
                Mov     Word Ptr [SI+8], 110h
                Mov     Word Ptr [SI+12], Offset MouseNumberIncrement
                Call    MouseAddEvent

                Ret

EndP            F_Draw3Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_Pre3Num Far

                Mov     AL, 80
                Mul     Byte Ptr [SI+3]
                Add     AL, [SI+2]
                AdC     AH, 0
                Mov     DI, AX
                Add     DI, CS:TripleNumberPos
                Add     DI, DI

                Mov     CX, 1
                Mov     AL, 30h
                Call    S_HiLight

                Ret

EndP            F_Pre3Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_Post3Num Far

                Mov     SI, [BX]
                Test    CL, CL
                JZ      F_Post3Num7

                Cmp     DX, 8
                JE      F_Post3Num16
                Cmp     CX, 1CBh        ; Left
                JNE     F_Post3Num1

F_Post3Num16:
                Mov     AX, CS:TripleNumberPos
                Dec     AX
                JS      F_Post3Num2

F_Post3Num5:
                Mov     CS:TripleNumberPos, AX

F_Post3Num2:
                Mov     AX, 1
                Ret

F_Post3Num1:
                Cmp     CX, 1CDh        ; Right
                JNE     F_Post3Num3

F_Post3Num4:
                Mov     AX, CS:TripleNumberPos
                Inc     AX
                Cmp     AX, 2
                JA      F_Post3Num2
                Jmp     F_Post3Num5

F_Post3Num3:
                Cmp     CX, 1C8h        ; Up
                JE      F_Post3Num14
                Cmp     CX, 1D0h        ; Down
                JE      F_Post3Num13
                Cmp     CX, 10Fh
                JE      F_Post3Num12
                Cmp     DX, 0F00h
                JNE     F_Post3Num6

                LodsW
F_Post3Num12:
                LodsW
F_Post3Num13:
                LodsW
F_Post3Num14:
                Add     SI, 12
                LodsW
                Cmp     AX, 0FFFFh
                JE      F_Post3Num7

                Mov     [DI], AX

F_Post3Num15:
                Mov     AX, 1
                Ret

F_Post3Num18:
                Mov     BX, [SI+4]
                Add     BX, BX
                Mov     DI, [SI+6]

                Push    BX
                Call    [CS:Get3NumValues+BX]           ; AX = value.
                Pop     BX
                Add     AX, 1
                JC      F_Post3Num15
                Call    [CS:Set3NumValues+BX]           ; AX = value.
                Call    Near Ptr F_Post3Num20
                Jmp     F_Post3Num15

F_Post3Num19:
                Mov     BX, [SI+4]
                Add     BX, BX
                Mov     DI, [SI+6]

                Push    BX
                Call    [CS:Get3NumValues+BX]           ; AX = value.
                Pop     BX
                Sub     AX, 1
                JC      F_Post3Num15
                Call    [CS:Set3NumValues+BX]           ; AX = value.
                Call    Near Ptr F_Post3Num20
                Jmp     F_Post3Num15

F_Post3Num6:
                Cmp     DX, '+'
                JE      F_Post3Num18
                Cmp     DX, '-'
                JE      F_Post3Num19

                Cmp     DX, '0'
                JL      F_Post3Num7
                Cmp     DX, '9'
                JLE     F_Post3Num8

F_Post3Num7:
                Xor     AX, AX
                Ret

F_Post3Num8:                            ; OK... a number was inputted.
                Push    DX

                Mov     BX, [SI+4]
                Add     BX, BX
                Mov     DI, [SI+6]

                Call    [CS:Get3NumValues+BX]           ; AX = value.

                Mov     CX, 3
                Mov     BX, 10
                Mov     DI, Offset NumberStorage+6

F_Post3Num9:
                Xor     DX, DX
                Div     BX
                Sub     DI, 2
                Mov     [CS:DI], DX
                Loop    F_Post3Num9

                Mov     BX, CS:TripleNumberPos
                Add     BX, BX

                Pop     DX
                Sub     DX, '0'
                Mov     [CS:DI+BX], DX

                Xor     AX, AX
                Mov     BX, 10
                Mov     CX, 3
                Xor     DX, DX

F_Post3Num10:
                Mul     BX
                Add     AX, [CS:DI]
                AdC     DX, 0
                ScasW
;                Add     DI, 2
                Loop    F_Post3Num10

                And     DX, DX
                JZ      F_Post3Num11

                Mov     AX, 0FFFFh

F_Post3Num11:
                Mov     BX, [SI+4]
                Add     BX, BX
                Mov     DI, [SI+6]

                Call    [CS:Set3NumValues+BX]           ; AX = value.
                Call    Near Ptr F_Post3Num20
                Jmp     F_Post3Num4

F_Post3Num20:
                Cmp     Word Ptr [SI+8], 0
                JNZ     F_Post3Num17

                Cmp     Word Ptr [SI+10], 0
                JZ      F_Post3Num21

F_Post3Num17:
                Call    DWord Ptr [SI+8]

F_Post3Num21:
                RetN


EndP            F_Post3Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_ConvEAX2Num Far

                Push    EAX                      ; CH = colour
                Push    EBX                      ; DX:AX = number
                Push    CX
                Push    EDX

                Mov     EBX, 10
                Mov     CL, 7

F_ConvEAX2Num1:
                Xor     EDX, EDX
                Div     EBX
                Push    DX
                Dec     CL
                JNZ     F_ConvEAX2Num1

                Mov     CL, 7

F_ConvEAX2Num2:
                Pop     AX
                Add     AL, '0'
                Mov     AH, CH
                StosW

                Dec     CL
                JNZ     F_ConvEAX2Num2

                Pop     EDX
                Pop     CX
                Pop     EBX
                Pop     EAX

                Ret

EndP            F_ConvEAX2Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_Draw5Num Far

                Mov     [CS:MouseEventData+10], AX

                Mov     BX, [SI+4]
                Add     BX, BX
                Mov     DI, [SI+6]

                Call    [CS:Get5NumValues+BX]           ; AX = value.

                Push    AX

                Mov     AL, 80
                Mul     Byte Ptr [SI+3]
                Add     AL, [SI+2]
                AdC     AH, 0
                Add     AX, AX
                Mov     DI, AX
                Call    S_GetDestination

                Pop     AX
                Xor     DX, DX
                Mov     CH, 2
                Call    F_ConvEAX2Num

                Xor     AX, AX
                Mov     AL, [SI+2]              ; X value
                ShL     AX, 3
                Mov     [CS:MouseEventData+0], AX
                Add     AX, 7*8-1
                Mov     [CS:MouseEventData+4], AX
                Xor     AX, AX
                Mov     AL, [SI+3]
                ShL     AX, 3
                Mov     [CS:MouseEventData+2], AX
                Add     AX, 7
                Mov     [CS:MouseEventData+6], AX

                Push    CS
                Pop     DS

                Mov     SI, Offset MouseEventData
                Mov     Word Ptr [SI+8], 102h
                Mov     Word Ptr [SI+12], Offset MouseNumberDecrement
                Call    MouseAddEvent
                Mov     Word Ptr [SI+8], 110h
                Mov     Word Ptr [SI+12], Offset MouseNumberIncrement
                Call    MouseAddEvent

                Ret

EndP            F_Draw5Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_Pre5Num Far

                Mov     AL, 80
                Mul     Byte Ptr [SI+3]
                Add     AL, [SI+2]
                AdC     AH, 0
                Mov     DI, AX
                Add     DI, CS:NumberPos
                Add     DI, DI

                Mov     CX, 1
                Mov     AL, 30h
                Call    S_HiLight

                Ret

EndP            F_Pre5Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_Post5Num Far

                Mov     SI, [BX]
                Test    CL, CL
                JZ      F_Post5Num7

                Cmp     DX, 8
                JE      F_Post5Num16
                Cmp     CX, 1CBh        ; Left
                JNE     F_Post5Num1

F_Post5Num16:
                Mov     AX, CS:NumberPos
                Dec     AX
                JS      F_Post5Num2

F_Post5Num5:
                Mov     CS:NumberPos, AX

F_Post5Num2:
                Mov     AX, 1
                Ret

F_Post5Num1:
                Cmp     CX, 1CDh        ; Right
                JNE     F_Post5Num3

F_Post5Num4:
                Mov     AX, CS:NumberPos
                Inc     AX
                Cmp     AX, 6
                JA      F_Post5Num2
                Jmp     F_Post5Num5

F_Post5Num3:
                Cmp     CX, 1C8h        ; Up
                JE      F_Post5Num14
                Cmp     CX, 1D0h        ; Down
                JE      F_Post5Num13
                Cmp     CX, 10Fh
                JE      F_Post5Num12
                Cmp     DX, 0F00h
                JNE     F_Post5Num6

                LodsW
F_Post5Num12:
                LodsW
F_Post5Num13:
                LodsW
F_Post5Num14:
                Add     SI, 12
                LodsW
                Cmp     AX, 0FFFFh
                JE      F_Post5Num7

                Mov     [DI], AX

F_Post5Num15:
                Mov     AX, 1
                Ret

F_Post5Num18:
                Mov     BX, [SI+4]
                Add     BX, BX
                Mov     DI, [SI+6]

                Push    BX
                Call    [CS:Get5NumValues+BX]           ; AX = value.
                Pop     BX
                Inc     EAX
                Call    [CS:Set5NumValues+BX]           ; AX = value.
                Call    Near Ptr F_Post5Num20
                Jmp     F_Post5Num15

F_Post5Num19:
                Mov     BX, [SI+4]
                Add     BX, BX
                Mov     DI, [SI+6]

                Push    BX
                Call    [CS:Get5NumValues+BX]           ; AX = value.
                Pop     BX
                Sub     EAX, 1
                JC      F_Post5Num15
                Call    [CS:Set5NumValues+BX]           ; AX = value.
                Call    Near Ptr F_Post5Num20
                Jmp     F_Post5Num15

F_Post5Num6:
                Cmp     DX, '+'
                JE      F_Post5Num18
                Cmp     DX, '-'
                JE      F_Post5Num19

                Cmp     DX, '0'
                JL      F_Post5Num7
                Cmp     DX, '9'
                JLE     F_Post5Num8

F_Post5Num7:
                Xor     AX, AX
                Ret

F_Post5Num8:                            ; OK... a number was inputted.
                Push    DX

                Mov     BX, [SI+4]
                Add     BX, BX
                Mov     DI, [SI+6]

                Call    [CS:Get5NumValues+BX]           ; EAX = value.

                Mov     CX, 7
                Mov     EBX, 10
                Mov     DI, Offset NumberStorage+14

F_Post5Num9:
                Xor     EDX, EDX
                Div     EBX
                Sub     DI, 2
                Mov     [CS:DI], DX
                Loop    F_Post5Num9

                Mov     BX, CS:NumberPos
                Add     BX, BX

                Pop     DX
                Sub     DX, '0'
                Mov     [CS:DI+BX], DX

                Xor     EAX, EAX
                Mov     BX, 10
                Mov     CX, 7

F_Post5Num10:
                IMul    EAX, 10
                MovZX   EBX, Word Ptr [CS:DI]
                Add     EAX, EBX

;                Add     DI, 2
                ScasW
                Loop    F_Post5Num10

F_Post5Num11:
                Mov     BX, [SI+4]
                Add     BX, BX
                Mov     DI, [SI+6]

                Call    [CS:Set5NumValues+BX]           ; AX = value.
                Call    Near Ptr F_Post5Num20
                Jmp     F_Post5Num4

F_Post5Num20:
                Cmp     Word Ptr [SI+8], 0
                JNZ     F_Post5Num17

                Cmp     Word Ptr [SI+10], 0
                JZ      F_Post5Num21

F_Post5Num17:
                Call    DWord Ptr [SI+8]

F_Post5Num21:
                RetN

EndP            F_Post5Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_DrawHeader Far

;                Call    MouseClearEvents

                Call    Music_GetSongSegment
                Mov     DS, AX
                Mov     DL, [DS:2Ch]

                Push    CS
                Pop     DS

                Call    E_GetFreeEMS
                Push    AX

                Mov     AH, 48h
                Mov     BX, 0FFFFh
                Int     21h
                ShR     BX, 6
                Push    BX

                Mov     AH, 20h
                Mov     SI, Offset HeaderMsg1
                Mov     DI, ((1*80)+2)*2
                Call    S_DrawString

                Mov     SI, Offset HeaderMsg2
                Call    Glbl_GetHeaderMode
                And     AH, AH
                JNZ     F_DrawHeader1

                Mov     SI, Offset HeaderMsg3

F_DrawHeader1:
                Mov     AH, 20h
                Call    S_DrawString

                Mov     SI, Offset HeaderMsg4
                Mov     DI, ((4*80)+2)*2
                Call    S_DrawString

                Add     SP, 4

                Call    Music_GetFreeSoundCardMemory
                 ; Returns DS:SI, Carry set if nothing to show
                JC      F_DrawHeader2          ; and AX = value to print.

                Push    BX
                Push    AX

                Mov     AH, 20h
                Mov     DI, (63+8*80)*2
                Call    S_DrawString

                Pop     AX
                Pop     BX

F_DrawHeader2:
                Ret

EndP            F_DrawHeader

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_DrawSMCChannels Far

;                Call    MouseClearEvents

                Push    CS
                Pop     DS

                Xor     CX, CX

F_DrawSMCChannels1:
                Mov     AL, CL
                Inc     AX
                Xor     AH, AH
                Mov     BH, 10
                Div     BH
                Add     AX, 3030h
                Mov     Word Ptr ChannelNumbers, AX

                Mov     BX, CX
                And     BX, 0Fh
                Mov     AX, 160                 ; Calculate DI (offset on screen)
                Mul     BX
                Mov     DI, AX
                Add     DI, (22*80+9)*2
                Mov     BX, CX
                And     BX, 00F0h
                ShL     BX, 1
                Add     DI, BX

                Mov     SI, Offset ChannelMsg
                Mov     AH, 20h
                Call    S_DrawString

                Inc     CX
                Cmp     CX, 64
                JB      F_DrawSMCChannels1

                Ret

EndP            F_DrawSMCChannels

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_ConfigButtonSetup Far

                Call    Music_GetSongSegment
                Mov     DS, AX                          ; OK... now check for
                                                        ; control mode first.
                Mov     CL, [DS:2Ch]                    ; CL = Flags.
                Add     DI, 50                          ; ES:DI points to inst button

                Mov     BX, [ES:DI]                     ; ES:BX points to inst button data
;                Add     DI, 2
                ScasW
                Xor     CH, CH
                Test    CL, 4
                JZ      F_ConfigButtonSetup1

                Inc     CH

F_ConfigButtonSetup1:
                Mov     [ES:BX+33], CH                  ; Instrument button

                Xor     CH, 1
                Mov     BX, [ES:DI]
;                Add     DI, 2
                ScasW
                Mov     [ES:BX+33], CH                  ; Sample button

                Mov     BX, [ES:DI]
;                Add     DI, 2
                ScasW
                Xor     CH, CH
                Test    CL, 1
                JZ      F_ConfigButtonSetup2

                Inc     CH

F_ConfigButtonSetup2:
                Mov     [ES:BX+33], CH                  ; Stereo button

                Xor     CH, 1
                Mov     BX, [ES:DI]
;                Add     DI, 2
                ScasW
                Mov     [ES:BX+33], CH                  ; Mono button

                Mov     BX, [ES:DI]
;                Add     DI, 2
                ScasW
                Xor     CH, CH
                Test    CL, 8                           ; Slides...
                JZ      F_ConfigButtonSetup3

                Inc     CH

F_ConfigButtonSetup3:
                Mov     [ES:BX+33], CH

                Xor     CH, 1
                Mov     BX, [ES:DI]
;                Add     DI, 2                           ; Compression reasons
                ScasW
                Mov     [ES:BX+33], CH

                Ret

EndP            F_ConfigButtonSetup

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

IF NETWORKENABLED
Proc            F_SendSongFlags

                Push    CX
                Push    DX

                Mov     CX, 1
                Mov     DX, 2Ch
                Call    Network_SendSongDataInformation

                Pop     DX
                Pop     CX

                Ret

EndP            F_SendSongFlags

SendSongFlags   EQU     Call F_SendSongFlags

ELSE

SendSongFlags   EQU     ;

ENDIF

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_SetControlSample Far

                Call    Music_GetSongSegment
                Mov     DS, AX

                And     Byte Ptr [DS:2Ch], NOT 4

                SendSongFlags

                Ret

EndP            F_SetControlSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_SetControlInstrument Far

                Call    Music_GetSongSegment
                Mov     DS, AX

                Or      Byte Ptr [DS:2Ch], 4

                Push    DS

                Mov     DI, Offset O1_InitialiseInstrumentList
                Mov     CX, 3
                Call    M_Object1List
                                                ; DX = 0 -> don't initialise
                                                ; DX = 1 -> initialise
                Pop     DS                      ; DS = SongDataSegment

                SendSongFlags

                Test    DX, DX
                JZ      F_SetControlInstrument3

                Call    Music_ClearAllInstruments

                                                ; OK.. for samples 1..99
                                                ; check if sample exists.
                                                ; if so, copy name&set all
                                                ; notes of instrument.
                Push    DS
                Pop     ES                      ; ES = SongDataSegment

                Xor     DX, DX

F_SetControlInstrument1:
                Mov     BX, DX
                Add     BX, BX
                Mov     SI, [DS:BX+64912]       ; SI points to sample
                Mov     DI, [DS:BX+64712]       ; DI points to instrument

                Test    Byte Ptr [DS:SI+12h], 1
                JZ      F_SetControlInstrument2
                                                ; No sample there!

                                                ; Copy name
                Mov     CX, 26
                Add     SI, 14h
                Add     DI, 20h
                Rep     MovsB
                Add     DI, 7

                Mov     AL, DL                  ; DL = sample number
                Inc     AX
                Mov     CX, 120

F_SetControlInstrument4:
                StosB
                Inc     DI
                Loop    F_SetControlInstrument4

F_SetControlInstrument2:
IF NETWORKENABLED
                Call    Network_GetSendQueue
                JZ      F_SetControlInstrument5

                Mov     AX, 400h
                StosW
                Mov     AX, DX
                StosB

F_SetControlInstrument5:
                Call    Network_FinishedSendQueue
ENDIF
                Inc     DX
                Cmp     DX, 99
                JBE     F_SetControlInstrument1

F_SetControlInstrument3:

                Ret

EndP            F_SetControlInstrument

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_SetStereo Far

                Call    Music_GetSongSegment
                Mov     DS, AX

                Or      Byte Ptr [DS:2Ch], 1

                Call    Music_InitStereo

                SendSongFlags

                Ret

EndP            F_SetStereo

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_SetMono Far

                Call    Music_GetSongSegment
                Mov     DS, AX

                And     Byte Ptr [DS:2Ch], NOT 1

                Call    Music_InitStereo

                SendSongFlags

                Ret

EndP            F_SetMono

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_SetLinear Far

                Call    Music_GetSongSegment
                Mov     DS, AX

                Or      Byte Ptr [DS:2Ch], 8

                SendSongFlags

                Ret

EndP            F_SetLinear

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_SetAmiga Far

                Call    Music_GetSongSegment
                Mov     DS, AX

                And     Byte Ptr [DS:2Ch], NOT 8

                SendSongFlags

                Ret

EndP            F_SetAmiga

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_Reset5NumInputPos Far

                Mov     CS:NumberPos, 0
                Ret

EndP            F_Reset5NumInputPos

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_NewSong Far

                EnsureNoNetwork

                Mov     DI, Offset O1_NewSongList
                Mov     CX, 11                  ; OK Button..
                Call    M_Object1List
                And     DX, DX
                JZ      F_NewSongEnd

                Call    Music_Stop

                Cmp     Word Ptr [CS:ButtonVariables+8], 0
                JE      F_NewSong2

                Call    Music_ReleaseAllSamples
                Call    Music_ClearAllSampleNames

F_NewSong2:
                Cmp     Word Ptr [CS:ButtonVariables+10], 0
                JE      F_NewSong3

                Call    Music_ClearAllInstruments

F_NewSong3:
                Cmp     Word Ptr [CS:ButtonVariables+12], 0
                JE      F_NewSong1

                Call    D_ClearFileName
                Call    D_ResetTimer

                Call    Music_GetSongSegment
                Mov     ES, AX

                Mov     DI, 4           ; Clear song name
                Mov     CX, 13
                Xor     AX, AX
                Rep     StosW

                Mov     DI, 3Ch         ; Clear Time
                Xor     AX, AX
                StosW
                StosW

                Mov     CX, 64
                Mov     AL, 32
                Rep     StosB

                Mov     CX, 64          ; Channel volume
                Mov     AL, 64
                Rep     StosB

                Mov     DI, 100h        ; Orders.
                Mov     AL, 0FFh
                Mov     CX, 256
                Rep     StosB

                Call    Music_InitMuteTable
                Call    Msg_ResetMessage

F_NewSong1:
                Cmp     Word Ptr [CS:ButtonVariables+6], 0
                JE      F_NewSongEnd
                                                ; Clear patterns.
                Call    D_ClearFileName
                Call    D_ResetTimer
                Call    Music_ReleaseAllPatterns
                Call    PE_ResetOrderPattern

F_NewSongEnd:
                Mov     AX, 1
                Ret

EndP            F_NewSong

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_MainMenu Far

                Call    S_SaveScreen

                Mov     CX, 0FFFFh
                Mov     DI, Offset O1_MainMenu
                Call    M_Object1List

                Call    S_RestoreScreen

                Mov     AX, 1
                Ret

EndP            F_MainMenu

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_ViewPattern Far

                Call    MouseRestoreEvents
                Add     SP, 20
                Jmp     Glbl_F2_2

EndP            F_ViewPattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_ViewVariables Far

                Call    MouseRestoreEvents
                Add     SP, 20
                Jmp     Glbl_F12

EndP            F_ViewVariables

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_ViewOrderPan Far

                Call    MouseRestoreEvents
                Add     SP, 20
                Jmp     Glbl_F11_2

EndP            F_ViewOrderPan

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_MessageEditor Far

                Call    MouseRestoreEvents
                Add     SP, 20
                Jmp     Glbl_Shift_F9

EndP            F_MessageEditor

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_Help Far

                Call    S_RestoreScreen
                Call    MouseRestoreEvents
                Add     SP, 20
                Jmp     H_Help

EndP            F_Help

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_PlaybackMenu Far

                Mov     CX, 0FFFFh
                Mov     DI, Offset O1_PlaybackMenu
                Call    M_Object1List

                Call    S_RestoreScreen
                Mov     AX, 1
                Ret

EndP            F_PlaybackMenu

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_InfoPage Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents

                Add     SP, 48
                Jmp     Glbl_F5

EndP            F_InfoPage

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_PlaySong Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Add     SP, 48
                Jmp     Glbl_Ctrl_F5

EndP            F_PlaySong

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_PlayPattern Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Add     SP, 48
                Jmp     Glbl_F6

EndP            F_PlayPattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_PlayOrder Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Add     SP, 48
                Jmp     Glbl_Shift_F6

EndP            F_PlayOrder

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_PlayMark Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Add     SP, 48
                Jmp     PE_F7

EndP            F_PlayMark

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_Stop Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Add     SP, 48
                Jmp     Music_Stop

EndP            F_Stop

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_ReinitSoundCard Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Add     SP, 48
                Jmp     Music_ReinitSoundCard

EndP            F_ReinitSoundCard

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_CalculateLength Far

                Call    S_RestoreScreen
                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Add     SP, 48
                Jmp     Music_TimeSong

EndP            F_CalculateLEngth

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_DriverScreen Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Add     SP, 48
                Jmp     Glbl_DriverScreen

EndP            F_DriverScreen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_SampleMenu Far

                Mov     CX, 0FFFFh
                Mov     DI, Offset O1_SampleMenu
                Call    M_Object1List

                Call    S_RestoreScreen
                Mov     AX, 1
                Ret

EndP            F_SampleMenu

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_InstrumentMenu Far

                Mov     CX, 0FFFFh
                Mov     DI, Offset O1_InstrumentMenu
                Call    M_Object1List

                Call    S_RestoreScreen
                Mov     AX, 1
                Ret

EndP            F_InstrumentMenu

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_SampleList Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Add     SP, 48
                Jmp     Glbl_F3

EndP            F_SampleList

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_InstrumentList Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Add     SP, 48
                Jmp     Glbl_F4

EndP            F_InstrumentList

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_InstrumentLibrary Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Add     SP, 48
                Jmp     Glbl_Ctrl_F4

EndP            F_InstrumentLibrary

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_ReloadGravis Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Add     SP, 48
                Jmp     Music_SoundCardLoadAllSamples

EndP            F_ReloadGravis

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_SampleLibrary Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Add     SP, 48
                Jmp     Glbl_Ctrl_F3

EndP            F_SampleLibrary

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_FileMenu Far

                Mov     CX, 0FFFFh
                Mov     DI, Offset O1_FileMenu
                Call    M_Object1List

                Call    S_RestoreScreen
                Mov     AX, 1
                Ret

EndP            F_FileMenu

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_FileLoad Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Add     SP, 48
                Jmp     Glbl_F9

EndP            F_FileLoad


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_FileNew Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Call    S_RestoreScreen
                Add     SP, 48
                Jmp     F_NewSong

EndP            F_FileNew

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_FileSaveCurrent Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Call    S_RestoreScreen
                Add     SP, 48
                Jmp     D_SaveSong

EndP            F_FileSaveCurrent

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_FileSaveAs Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Add     SP, 48
                Jmp     Glbl_F10

EndP            F_FileSaveAs

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_FileDOSShell Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Call    S_RestoreScreen
                Add     SP, 48
                Jmp     DOSShell

EndP            F_FileDOSShell

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_FileQuit Far

                Call    MouseRestoreEvents
                Call    MouseRestoreEvents
                Call    S_RestoreScreen
                Add     SP, 48
                Jmp     Quit

EndP            F_FileQuit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

IF MEMORYDEBUG

DebugOffset             DW      0
DebugSegment            DW      0

AddressInput            DB      0
                        DB      19 Dup (0)
SegmentMsg              DB      "Segment: ", 0FDh, 'Xh', 0

DebugSegmentNames       DB      10, "STARTUP", 0
                        DW      Startup

                        DB      11, "KEYBOARD", 0
                        DW      Keyboard

                        DB      10, "PATTERN", 0
                        DW      Pattern

                        DB      7, "DISK", 0
                        DW      Disk

                        DB      6, "EMS", 0
                        DW      EMS

                        DB      8, "ERROR", 0
                        DW      Error

                        DB      7, "INST", 0
                        DW      Inst

                        DB      12, "FUNCTIONS", 0
                        DW      Functions

                        DB      9, "GLOBAL", 0
                        DW      Glbl

                        DB      7, "HELP", 0
                        DW      Help

                        DB      11, "INFOLINE", 0
                        DW      InfoLine

                        DB      7, "MAIN", 0
                        DW      Main

                        DB      8, "MUSIC", 0
                        DW      Music

                        DB      9, "SCREEN", 0
                        DW      Screen

                        DB      10, "OBJECT1", 0
                        DW      Object1

                        DB      11, "INFOPAGE", 0
                        DW      InfoPage

                        DB      11, "SONGDATA", 0
DebugSongDataSegment    DW      0

                        DB      11, "DISKDATA", 0
DebugDiskDataSegment    DW      0

                        DB      14, "PATTERNDATA", 0
DebugPatternDataSegment DW      0

                        DB      0FFh            ; End of list.

DebugMsg                DB      "CX: ", 0FDh, "X, DX: ", 0FDh, "X        ", 0
DebugCX                 DW      0
DebugDX                 DW      0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_DrawDebug Far

                Push    CS
                Pop     DS
                        Assume DS:Functions

                Call    S_GetDestination
                Mov     SI, Offset SegmentMsg
                Mov     DI, (4+13*80)*2

                Push    DebugSegment
;                Mov     AX, DebugSegment
;                Push    AX
                Mov     AH, 21h
                Call    S_DrawString            ; OK segment done
                Pop     AX                      ; Clear stack.

                                        ; Put offsets on screen.
                                        ; Work out digits.
                Mov     CX, 1E04h
                Mov     DI, (3+15*80)*2
                Mov     DX, DebugOffset
                Xor     BH, BH
                Mov     AH, 2

F_DrawDebug1:
                Push    DI

                Mov     BL, DH
                ShR     BL, CL
                Mov     AL, [HexNumbers+BX]             ; Blah.. how inefficient
                StosW
                Mov     BL, DH
                And     BL, 0Fh
                Mov     AL, [HexNumbers+BX]
                StosW
                Mov     BL, DL
                ShR     BL, CL
                Mov     AL, [HexNumbers+BX]
                StosW
                Mov     BL, DL
                And     BL, 0Fh
                Mov     AL, [HexNumbers+BX]
                StosW                           ; Offset is on screen.

                Mov     AL, ':'
                StosW

                Pop     DI
                Add     DI, 160
                Add     DX, 16
                Dec     CH
                JNZ     F_DrawDebug1

                                                ; Now to shove debug stuff.
                Mov     SI, DebugOffset
                Mov     DS, DebugSegment
                        Assume DS:Nothing
                Mov     DI, (10+15*80)*2

                Mov     DX, 30

F_DrawDebug2:
                Push    DI
                Push    SI

                Mov     CX, 1004h

F_DrawDebug3:
                Cmp     CH, 8
                JNE     F_DrawDebug4

                Mov     AL, '-'
                StosW
                Xor     AL, AL
                StosW

F_DrawDebug4:
                LodsB                           ; Number.
                Mov     BL, AL
                ShR     BL, CL
                Mov     BL, [CS:HexNumbers+BX]
                XChg    AL, BL
                And     BL, 0Fh
                StosW
                Mov     AL, [CS:HexNumbers+BX]
                StosW

                Xor     AL, AL
                StosW

                Dec     CH                      ; Hex number loop
                JNZ     F_DrawDebug3

                StosW

                Pop     SI
                Mov     CX, 16

F_DrawDebug5:
                LodsB
                StosW
                Loop    F_DrawDebug5

                Pop     DI
                Add     DI, 160                 ; Next line.

                Dec     DX                      ; line loop.
                JNZ     F_DrawDebug2

                Push    CS
                Pop     DS

                Push    DebugDX
                Push    DebugCX

                Mov     SI, Offset DebugMsg
                Mov     AH, 20h
                Mov     DI, (40+47*80)*2
                Call    S_DrawString
                Pop     AX
                Pop     AX

                Mov     AX, 1
                Ret

EndP            F_DrawDebug
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_PostDebug Far

                Mov     CS:DebugCX, CX
                Mov     CS:DebugDX, DX

                Xor     AX, AX
                Ret

EndP            F_PostDebug

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_DebugUp Far

                Sub     CS:DebugOffset, 16

                Mov     AX, 1
                Ret

EndP            F_DebugUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_DebugDown Far

                Add     CS:DebugOffset, 16

                Mov     AX, 1
                Ret

EndP            F_DebugDown

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_DebugPgUp Far

                Sub     CS:DebugOffset, 16*30

                Mov     AX, 1
                Ret

EndP            F_DebugPgUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_DebugPgDn Far

                Add     CS:DebugOffset, 16*30

                Mov     AX, 1
                Ret

EndP            F_DebugPgDn

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_DebugStringInput Far

                Mov     AX, Disk
                Mov     DS, AX
                        Assume DS:Disk
                Mov     DX, DiskDataArea

                Xor     BP, BP                  ; BP = ':' count.

                Mov     AX, Music
                Mov     DS, AX
                        Assume DS:Music
                Mov     BX, SongDataArea

                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern
                Mov     SI, PatternDataArea

                Push    CS
                Push    CS
                Pop     DS
                Pop     ES
                        Assume DS:Functions ; ES = functions also.

                Mov     DebugSongDataSegment, BX
                Mov     DebugDiskDataSegment, DX
                Mov     DebugPatternDataSegment, SI

                Mov     SI, Offset DebugSegmentNames
                Xor     BX, BX

F_DebugStringInput1:
                Mov     DI, Offset AddressInput
                LodsB
                Cmp     AL, 0FFh
                JE      F_DebugStringInput2

                Mov     BL, AL
                Push    SI
                                        ; OK.. compare in here..
F_DebugStringInput4:
                LodsB
                Mov     AH, [DI]

                And     AL, AL
                JZ      F_DebugStringInput3

                And     AH, AH
                JZ      F_DebugStringInput6

                Cmp     AH, 'a'
                JB      F_DebugStringInput6
                Cmp     AH, 'z'
                JA      F_DebugStringInput6

                Add     AH, 'A'-'a'

F_DebugStringInput6:
                Inc     DI
                Cmp     AH, AL
                JE      F_DebugStringInput4


F_DebugStringInput5:
                Pop     SI
                Add     SI, BX
                Jmp     F_DebugStringInput1


F_DebugStringInput3:
                And     AH, AH
                JNZ     F_DebugStringInput6

                LodsW
                Pop     SI
                Mov     DebugSegment, AX
                Mov     DebugOffset, 0

                Mov     AX, 1
                Ret

F_DebugStringInput2:                            ; We have a hex address(?)
                Mov     SI, Offset AddressInput
                Cmp     Byte Ptr [SI], 0
                JE      F_DebugStringInput15

F_DebugStringInput7:
                LodsB
                And     AL, AL
                JZ      F_DebugStringInput10

                Cmp     AL, '0'
                JB      F_DebugStringInput8
                Cmp     AL, '9'
                JBE     F_DebugStringInput7

F_DebugStringInput8:
                Cmp     AL, 'A'
                JB      F_DebugStringInput9
                Cmp     AL, 'F'
                JBE     F_DebugStringInput7


F_DebugStringInput9:
                Cmp     AL, 'a'
                JB      F_DebugStringInput16
                Cmp     AL, 'f'
                JBE     F_DebugStringInput7

F_DebugStringInput16:
                Cmp     AL, ':'
                JE      F_DebugStringInput7

F_DebugStringInput15:
                Xor     AX, AX
                Ret

F_DebugStringInput10:                           ; Hex address
                Mov     BX, DebugSegment
                Mov     CL, 4
                Xor     DX, DX                  ; BX:DX contains address

                Xor     AX, AX
                Mov     SI, Offset AddressInput

F_DebugStringInput11:
                LodsB
                And     AL, AL
                JZ      F_DebugStringInput12

                Cmp     AL, ':'
                JE      F_DebugStringInput13

                Sub     AL, '0'
                Cmp     AL, 9
                JBE     F_DebugStringInput14

                Sub     AL, '@'-'9'
                Cmp     AL, 15
                JBE     F_DebugStringInput14

                Sub     AL, 32

F_DebugStringInput14:
                ShL     DX, CL
                Add     DX, AX

                Jmp     F_DebugStringInput11

F_DebugStringInput13:
                Inc     BP
                Cmp     BP, 2
                JAE     F_DebugStringInput17

                Mov     BX, DX
                Xor     DX, DX
                Jmp     F_DebugStringInput11

F_DebugStringInput17:
                Mov     DebugSegment, BX
                Mov     DebugOffset, DX
                Xor     DX, DX
                Jmp     F_DebugStringInput11

F_DebugStringInput12:
                Cmp     BP, 2
                JB      F_DebugStringInput18

                LDS     SI, DWord Ptr [DebugOffset]
                Mov     [SI], DL
                Jmp     F_DebugStringInput19

F_DebugStringInput18:
                Mov     DebugSegment, BX
                Mov     DebugOffset, DX

F_DebugStringInput19:
                Mov     AX, 1
                Ret

EndP            F_DebugStringInput

ENDIF

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_ShowMIDIZxxInput Far

                Push    CS
                Pop     DS
                        Assume DS:Functions

                Mov     SI, Offset ZxxString
                Mov     AX, TopMIDIMacro
                Add     AX, 6
                Mov     CX, 7

F_ShowMIDIZxxInput1:
                Push    AX
                Dec     AX
                Loop    F_ShowMIDIZxxInput1

                Mov     CX, 7
                Mov     DI, (13+42*80)*2

F_ShowMIDIZxxInput2:
                Mov     AH, 20h
                Call    S_DrawString
                Pop     AX
                Add     DI, (80-3)*2
                Loop    F_ShowMIDIZxxInput2

                Ret

EndP            F_ShowMIDIZxxInput
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_MIDI_Up Far

                Cmp     CS:TopMIDIMacro, 80h
                JBE     F_MIDI_Up1

                Dec     CS:TOPMIDIMacro
                Jmp     F_MIDI_Up2

F_MIDI_Up1:
                Mov     Word Ptr [ES:DI], 33

F_MIDI_Up2:
                Mov     AX, 1
                Ret

EndP            F_MIDI_Up

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_MIDI_Down Far

                Cmp     CS:TopMIDIMacro, 0F9h
                JAE     F_MIDI_Down1

                Inc     CS:TOPMIDIMacro

F_MIDI_Down1:
                Mov     AX, 1
                Ret

EndP            F_MIDI_Down

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_MIDI_PgUp Far

                Cmp     Word Ptr [ES:DI], 33
                JBE     F_MIDI_PgUp1

                Sub     Byte Ptr [CS:TopMIDIMacro], 7
                JS      F_MIDI_PgUp1

                Mov     Byte Ptr [CS:TopMIDIMacro], 80h

F_MIDI_PgUp1:
                Mov     AX, 1
                Ret

EndP            F_MIDI_PgUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_MIDI_PgDn Far

                Cmp     Word Ptr [ES:DI], 33
                JBE     F_MIDI_PgDn1

                Add     [CS:TopMIDIMacro], 7
                Cmp     [CS:TopMIDIMacro], 0F9h
                JB      F_MIDI_PgDn1

                Mov     [CS:TopMIDIMacro], 0F9h

F_MIDI_PgDn1:
                Mov     AX, 1
                Ret

EndP            F_MIDI_PgDn

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

EndS

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

End
