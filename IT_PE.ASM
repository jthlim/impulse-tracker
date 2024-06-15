;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ PatternEdit module                                                          ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                        Jumps
                        .386

include switch.inc

include network.inc

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Externals                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Segment         Object1 BYTE Public 'Data'
EndS

Segment         Disk BYTE Public 'Code'
EndS

Segment         Inst BYTE Public 'Code'
                Extrn   InstrumentEdit:Byte
                Extrn   NodeHeld:Byte
EndS

                Extrn   E_GetFreeEMS:Far
                Extrn   E_UnInitEMS:Far
                Extrn   E_ReleaseEMS:Far
                Extrn   E_AllocateEMS:Far
                Extrn   E_MapAvailableEMSMemory:Far
                Extrn   E_GetEMSPageFrame:Far

                Extrn   Glbl_F2:Far, Glbl_F6:Far
                Extrn   Glbl_GetHeaderMode:Far
                Extrn   Glbl_LeftBrace:Far, Glbl_RightBrace:Far
                Extrn   Glbl_LeftSquareBracket:Far, Glbl_RightSquareBracket:Far

                Extrn   I_ClearTables:Far

                Extrn   K_UnInitKeyBoard:Far
                Extrn   K_SetScrollLock:Far
                Extrn   K_IsKeyDown:Far

                Extrn   M_FunctionHandler:Far
                Extrn   M_Object1List:Far
                Extrn   M_FunctionDivider:Far

                Extrn   Music_PlayPartSong:Far
                Extrn   Music_GetSongSegment:Far
                Extrn   Music_UnInitMusic:Far
                Extrn   Music_ReleasePattern:Far
                Extrn   Music_AllocatePattern:Far
                Extrn   Music_GetPattern:Far
                Extrn   Music_GetInstrumentMode:Far
                Extrn   Music_UpdatePatternOffset:Far
                Extrn   Music_PlayNote:Far
                Extrn   Music_InitMixTable:Far
                Extrn   Music_InitMuteTable:Far
                Extrn   Music_InitStereo:Far
                Extrn   Music_ToggleChannel:Far
                Extrn   Music_SoloChannel:Far
                Extrn   Music_GetPlayMode:Far
                Extrn   Music_PlayPattern:Far
                Extrn   Music_GetLastChannel:Far
                Extrn   Music_SetNextOrder:Far
                Extrn   Music_NextOrder:Far
                Extrn   Music_LastOrder:Far
                Extrn   Music_Stop:Far

                Extrn   Music_UnmuteAll:Far

                Extrn   Music_SoundCardLoadSample:Far
                Extrn   Music_SoundCardLoadAllSamples:Far
                Extrn   Music_GetDisplayVariables:Far

                Extrn   Network_UpdatePattern:Far

                Extrn   FileName:Byte

                Extrn   O1_ConfirmNoSave:Far
                Extrn   O1_NoBlockMarkedList:Far
                Extrn   O1_SwapOutOfRangeList:Far
                Extrn   O1_OverlapBlockList:Far
                Extrn   O1_OutOfMemoryList:Far
                Extrn   O1_NoBlockDataList:Far
                Extrn   O1_GetAmpList:Far
                Extrn   O1_GetFastAmpList:Far

IF SHOWPATTERNLENGTH
                Extrn   O1_ShowPatternLengthList:Far
ENDIF

                Extrn   O1_TemplateErrorList:Far
                Extrn   O1_PatternTooLongList:Far
                Extrn   O1_SelectMultiChannel:Far
                Extrn   O1_UndoList:Far
                Extrn   O1_SetPatternLength:Far
                Extrn   O1_PatternSizeMismatchList:Far

                Extrn   S_UnInitScreen:Far
                Extrn   S_DrawBox:Far
                Extrn   S_DrawString:Far
                Extrn   S_GetDestination:Far
                Extrn   S_SaveScreen:Far
                Extrn   S_RestoreScreen:Far
                Extrn   S_SetDirectMode:Far
                Extrn   S_DrawSmallBox:Far
                Extrn   S_InvertCursor:Far

                Extrn   PatternLength

                Extrn   UpdateInfoLine:Far
                Extrn   SetInfoLine:Far
                Extrn   MouseUpdateDisable:Far
                Extrn   UpdateWAVEForm:Far

                Extrn   MIDI_AllocateChannel:Far, MIDI_FindChannel:Far
                Extrn   Music_GetDelay:Far, MIDI_GetChannel:Far

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Globals                                                                     ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                Global  PE_ClearUndoBuffer:Far

                Global  PE_ShowOrder:Far
                Global  PE_NewPattern:Far

                Global  PE_InitPatternEdit:Far
                Global  PE_UnInitPatternEdit:Far
                Global  PE_DrawOrderList:Far
                Global  PE_FillHeader:Far
                Global  PE_PreOrderList:Far
                Global  PE_PostOrderList:Far
                Global  PE_ConvAX2Num:Far
                Global  PE_GetCurrentPattern:Far
                Global  PE_GetMaxPattern:Far
                Global  PE_FillSpeedTempo:Far

                Global  PE_SetPatternModified:Far
                Global  PE_GetLastInstrument:Far
                Global  PE_DrawPatternEdit:Far
                Global  PE_PrePatternEdit:Far
                Global  PE_PostPatternEdit:Far
                Global  PE_SetCommandCursor:Far
                Global  PEFunction_IncreaseOctave:Far
                Global  PEFunction_DecreaseOctave:Far

                Global  PE_F7:Far

                Global  PE_GetPatternConfigOffset:Far

                Global  PE_SwapInstruments:Far
                Global  PE_GetMaxOrder:Far
                Global  PE_GotoPattern:Far
                Global  PECheckModified:Far

                Global  PE_TranslateXMPattern:Far
                Global  PE_TranslateS3MPattern:Far
                Global  PE_TranslateMODPattern:Far
                Global  PE_TranslateMTMPattern:Far
                Global  PE_Translate669Pattern:Far
                Global  PE_ResetOrderPattern:Far
                Global  PEFunction_OutOfMemoryMessage:Far
                Global  PE_UpdateInstruments:Far

                Global  PEFunction_DrawUndo:Far
                Global  PEFunction_PreUndo:Far
                Global  PEFunction_PostUndo:Far
                Global  PEResetModified:Far

                Global  PE_SaveCurrentPattern:Far
                Global  PE_RestoreCurrentPattern:Far
                Global  PEFunction_StoreCurrentPattern:Far

                Global  BaseOctave
                Global  SkipValue
                Global  RowHiLight1:Byte
                Global  RowHiLight2:Byte
                Global  MaxRow:Word
                Global  NumberOfRows:Word
                Global  Amplification
                Global  FastVolumeAmplification
                Global  CommandToValue:Byte
                Global  LastInstrument:Byte
                Public  MultiChannelInfo
                Public  PatternDataArea
                Public  Order, CentraliseCursor
                Public  PatternSetLength, PatternLengthStart, PatternLengthEnd
                Public  MIDI_SetInstrument, PE_TranslateMIDI
                Public  MIDIAmplification, MIDICentralNote, PE_RestoreMIDINote
                Public  PE_InsertInstrument, PE_DeleteInstrument
                Public  Flags, Modified, PatternModified

                Public  LastKeyBoard1, PatternNumber

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment                 Pattern WORD Public 'Code' USE16
                        Assume CS:Pattern, DS:Nothing

CREATENEWLOGFILE        EQU     0
include debug.inc

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Variables                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

NONOTE                  EQU     0FDh
MAXNOTE                 EQU     119

;PatternSize             DW      0
;PatternEnd              DW      0
PatternDataArea         DW      PatternData

TempVariableArea        DW      0
TempVariableArea2       DW      0
TempVariableArea3       DW      0
TempVariableArea4       DW      0
TempVariableArea5       DW      0
TempVariableArea6       DW      0

TopOrder                DW      0
Order                   DW      0
OrderCursor             DW      0
PatternNumber           DW      0
TopRow                  DW      0
Row                     DW      0
MaxRow                  DW      63
NumberOfRows            DW      64

LeftChannel             DW      0
Channel                 DW      0
MIDIChannel             DW      0
PatternCursor           DW      0
BaseOctave              DW      4
SkipValue               DW      1
MultiChannelInfo        DB      64 Dup (0)
BlockMark               DW      0  ; 0 if no block marked, 1 if block is marked
BlockLeft               DW      0
BlockTop                DW      0
BlockRight              DW      0
BlockBottom             DW      0
BlockDataArea           DW      0
BlockAnchorChannel      DW      0
BlockAnchorRow          DW      0
BlockReset              DW      0
LastKeyBoard1           DW      0, 0
LastKeyBoard2           DW      0, 0
LastKeyBoard3           DW      0, 0

EmptyRow                DB      64 Dup ( NONOTE, 0, 0FFh, 0, 0 )

KeyBoardTable           DW      12Ch, 0, 11Fh, 1, 12Dh, 2, 120h, 3, 12Eh, 4
                        DW      12Fh, 5, 122h, 6, 130h, 7, 123h, 8, 131h, 9
                        DW      124h, 10, 132h, 11, 110h, 12, 103h, 13, 111h, 14
                        DW      104h, 15, 112h, 16, 113h, 17, 106h, 18, 114h, 19
                        DW      107h, 20, 115h, 21, 108h, 22, 116h, 23, 117h, 24
                        DW      10Ah, 25, 118h, 26, 10Bh, 27, 119h, 28
                        DW      0FFFFh

MODPeriodTable          DW      1712, 1616, 1525, 1440, 1357, 1281 ; Octave 0
                        DW      1209, 1141, 1077, 1017,  961,  907
                        DW       856,  808,  762,  720,  678,  640 ; Octave 1
                        DW       604,  570,  538,  508,  480,  453
                        DW       428,  404,  381,  360,  339,  320 ; Octave 2
                        DW       302,  285,  269,  254,  240,  226
                        DW       214,  202,  190,  180,  170,  160 ; Octave 3
                        DW       151,  143,  135,  127,  120,  113
                        DW       107,  101,   95,   90,   85,   80 ; Octave 4
                        DW        75,   71,   67,   63,   60,   56
                        DW        53,   50,   47,   45,   42,   40 ; Octave 5
                        DW        37,   35,   33,   31,   30,   28

Amplification           DW      100

PlayMarkPattern         DW      0
PlayMarkRow             DW      0
PlayMarkOn              DB      0
VolumePan               DB      0

UndoBuffer              DW      20 Dup (0)      ; Word for segment, word for
                                                ; type:

UndoBufferTypes         Label   Word
        DW      Offset UndoBufferType0, Offset UndoBufferType1
        DW      Offset UndoBufferType2, Offset UndoBufferType3
        DW      Offset UndoBufferType4, Offset UndoBufferType5
        DW      Offset UndoBufferType6, Offset UndoBufferType7
        DW      Offset UndoBufferType8, Offset UndoBufferType9
        DW      Offset UndoBufferType10, Offset UndoBufferType11
        DW      Offset UndoBufferType12, Offset UndoBufferType13
        DW      Offset UndoBufferType14, Offset UndoBufferType15
        DW      Offset UndoBufferType16, Offset UndoBufferType17
        DW      Offset UndoBufferType18, Offset UndoBufferType19
        DW      Offset UndoBufferType20, Offset UndoBufferType21
        DW      Offset UndoBufferType22

UndoBufferType0         DB      "Empty", 0
UndoBufferType1         DB      "Undo revert pattern data (Alt-BkSpace)", 0
UndoBufferType2         DB      "Undo transposition up", 0FFh, 10, " (Alt-Q)", 0
UndoBufferType3         DB      "Undo transposition down", 0FFh, 8, " (Alt-A)", 0
UndoBufferType4         DB      "Undo block length double", 0FFh, 7, " (Alt-F)", 0
UndoBufferType5         DB      "Undo block length halve", 0FFh, 8, " (Alt-G)", 0
UndoBufferType6         DB      "Undo volume amplification", 0FFh, 6, " (Alt-J)", 0
UndoBufferType7         DB      "Undo volume or panning slide   (Alt-K)", 0
UndoBufferType8         DB      "Recover volumes/pannings", 0FFh, 5, " (2*Alt-K)", 0
UndoBufferType9         DB      "Replace mixed data", 0FFh, 13, " (Alt-M)", 0
UndoBufferType10        DB      "Replace overwritten data", 0FFh, 7, " (Alt-O)", 0
UndoBufferType11        DB      "Undo paste data", 0FFh, 16, " (Alt-P)", 0
UndoBufferType12        DB      "Undo set sample/instrument", 0FFh, 5, " (Alt-S)", 0
UndoBufferType13        DB      "Undo set volume/panning", 0FFh, 8, " (Alt-V)", 0
UndoBufferType14        DB      "Replace extra volumes/pannings (Alt-W)", 0
UndoBufferType15        DB      "Undo effect data slide", 0FFh, 9, " (Alt-X)", 0
UndoBufferType16        DB      "Recover effects/effect data  (2*Alt-X)", 0
UndoBufferType17        DB      "Undo swap block", 0FFh, 16, " (Alt-Y)", 0
UndoBufferType18        DB      "Undo block cut", 0FFh, 17, " (Alt-Z)", 0
UndoBufferType19        DB      "Remove inserted row(s)", 0FFh, 4, " (Alt-Insert)", 0
UndoBufferType20        DB      "Replace deleted row(s)", 0FFh, 4, " (Alt-Delete)", 0
UndoBufferType21        DB      "Redo", 0FFh, 28, " (Undo)", 0
UndoBufferType22        DB      "Pattern ", 0FDh, "D", 0

SelectUndo              DW      0
ShiftPressed            DB      0
NoteEntered             DB      0

PreviewNote             DB      0, 0, 0FFh, 0, 0

Modified                DB      0               ; } Order important
PatternModified         DB      0               ; }

MIDIPlayTrigger         DB      0               ; 0 = nothing, 1 = play
                                                ; pattern, 2 = play song.

CompleteMsg             DB      0FDh, "D% Complete", 0
Template                DB      0
TemplateMsg1            DB      "Template, Overwrite", 0
TemplateMsg2            DB      "Template, Mix - Pattern data precedence", 0
TemplateMsg3            DB      "Template, Mix - Clipboard data precedence", 0
TemplateMsg4            DB      "Template, Notes only", 0
TriggerMsg1             DB      "No MIDI Trigger", 0
TriggerMsg2             DB      "Pattern MIDI Trigger", 0
TriggerMsg3             DB      "Song MIDI Trigger", 0
NextOrderMsg            DB      "Playing order ", 0FDh, "D next", 0
CursorStepMSg           DB      "Cursor step set to ", 0FDh, "D", 0

EncodingInfo            DB      384 Dup (0)
PatternSetLength        DW      64
PatternLengthStart      DW      0
PatternLengthEnd        DW      0
TempData                DB      320 Dup (0)

PEFunctions             Label   Word
                        DB      0
                        DW      11Ch            ; Enter
                        DW      Offset PEFunction_PickUp

IF SHOWPATTERNLENGTH
                        DB      0
                        DW      111Ch            ; Right Ctrl+Enter
                        DW      Offset PE_ShowPatternLength
ENDIF

                        DB      1
                        DW      '{'
                        DW      Near Ptr PE_LeftBrace

                        DB      1
                        DW      '}'
                        DW      Near Ptr PE_RightBrace

                        DB      1
                        DW      '['
                        DW      Near Ptr PE_LeftSquareBracket

                        DB      1
                        DW      ']'
                        DW      Near Ptr PE_RightSquareBracket

                        DB      0
                        DW      1C8h
                        DW      Offset PEFunction_Up

                        DB      0
                        DW      1D0h
                        DW      Offset PEFunction_Down

                        DB      0
                        DW      1CBh
                        DW      Offset PEFunction_Left

                        DB      0
                        DW      1CDh
                        DW      Offset PEFunction_Right

                        DB      0
                        DW      1C9h
                        DW      PEFunction_PgUp

                        DB      0
                        DW      1D1h
                        DW      PEFunction_PgDn

                        DB      2
                        DW      1C7h
                        DW      Offset PEFunction_Alt_Home

                        DB      2
                        DW      1CFh
                        DW      Offset PEFunction_Alt_End

                        DB      0
                        DW      1C7h
                        DW      Offset PEFunction_Home

                        DB      0
                        DW      1CFh
                        DW      Offset PEFunction_End

                        DB      3
                        DW      1C9h
                        DW      PEFunction_Ctrl_PgUp

                        DB      3
                        DW      1D1h
                        DW      PEFunction_Ctrl_PgDn

                        DB      2               ; Alt...
                        DW      1CBh            ; Left Arrow
                        DW      Offset PEFunction_AltLeft

                        DB      2               ; Alt...
                        DW      1CDh            ; Right Arrow
                        DW      Offset PEFunction_AltRight

                        DB      3               ; Ctrl...
                        DW      1CBh            ; Left Arrow
                        DW      Offset PEFunction_ViewLeft

                        DB      3
                        DW      1CDh
                        DW      Offset PEFunction_ViewRight

                        DB      2               ; Alt...
                        DW      1C8h            ; Up Arrow
                        DW      Offset PEFunction_AltUp

                        DB      2
                        DW      1D0h
                        DW      Offset PEFunction_AltDown

                        DB      3
                        DW      1C7h
                        DW      Offset PEFunction_Ctrl_Home

                        DB      3
                        DW      1CFh
                        DW      Offset PEFunction_Ctrl_End

                        DB      4
                        DW      1C8h
                        DW      Offset PEFunction_Up

                        DB      4
                        DW      1D0h
                        DW      Offset PEFunction_Down

                        DB      4
                        DW      1CBh
                        DW      Offset PEFunction_AltLeft

                        DB      4
                        DW      1CDh
                        DW      Offset PEFunction_AltRight

                        DB      4
                        DW      1C9h
                        DW      PEFunction_ShiftPgUp

                        DB      4
                        DW      1D1h
                        DW      PEFunction_ShiftPgDn

                        DB      4
                        DW      1C7h
                        DW      Offset PEFunction_Home

                        DB      4
                        DW      1CFh
                        DW      Offset PEFunction_End

                        DB      4
                        DW      12Ah
                        DW      Offset PEFunction_Press_Shift

                        DB      4
                        DW      136h
                        DW      Offset PEFunction_Press_Shift

                        DB      0
                        DW      2Ah
                        DW      Offset PEFunction_Release_Shift

                        DB      0
                        DW      36h
                        DW      Offset PEFunction_Release_Shift

                        DB      0
                        DW      10Fh
                        DW      Offset PEFunction_Tab

                        DB      4
                        DW      10Fh
                        DW      Offset PEFunction_ShiftTab

                        DB      1
                        DW      ','
                        DW      Offset PEFunction_SetMask

                        DB      0
                        DW      1D2h
                        DW      Offset PEFunction_Insert

                        DB      0
                        DW      1D3h            ; Delete
                        DW      Offset PEFunction_Delete

                        DB      2               ; Alt...
                        DW      1D2h            ; Insert
                        DW      Offset PEFunction_RowInsert

                        DB      2               ; Alt...
                        DW      1D3h            ; Delete
                        DW      Offset PEFunction_RowDelete

                        DB      3               ; Ctrl...
                        DW      1D2h            ; Insert
                        DW      Offset PEFunction_RollDown

                        DB      3               ; Ctrl...
                        DW      1D3h            ; Delete
                        DW      Offset PEFunction_RollUp

                        DB      0
                        DW      10Eh
                        DW      Offset PEFunction_BackSpace

                        DB      3               ; Ctrl...
                        DW      10Eh            ; Backspace
                        DW      Offset PEFunction_Undo

                        DB      1
                        DW      '<'
                        DW      Offset PEFunction_DecreaseInstrument

                        DB      1
                        DW      '>'
                        DW      Offset PEFunction_IncreaseInstrument

                        DB      1
                        DW      ';'
                        DW      Offset PEFunction_DecreaseInstrument

                        DB      1
                        DW      "'"
                        DW      Offset PEFunction_IncreaseInstrument

                        DB      3               ; Ctrl
                        DW      1C8h
                        DW      Offset PEFunction_DecreaseInstrument

                        DB      3
                        DW      1D0h
                        DW      Offset PEFunction_IncreaseInstrument

                        DB      1
                        DW      3000h           ; Alt 'B'
                        DW      Offset PEFunction_MarkBeginBlock

                        DB      1
                        DW      3100h           ; Alt 'N'
                        DW      Offset PEFunction_ToggleMultiChannel

                        DB      1
                        DW      1200h           ; Alt 'E'
                        DW      Offset PEFunction_MarkEndBlock

                        DB      1
                        DW      1600h           ; Alt 'U'
                        DW      Offset PEFunction_UnMarkBlock

                        DB      1
                        DW      1700h           ; Alt 'I'
                        DW      Offset PEFunction_ToggleTemplate

                        DB      1
                        DW      ':'
                        DW      Offset PEFunction_TemplateOff

                        DB      1
                        DW      2000h           ; Alt 'D'
                        DW      Offset PEFunction_AltD

                        DB      1
                        DW      1F00h           ; Alt 'S'
                        DW      Offset PEFunction_AltS

                        DB      1
                        DW      2500h           ; Alt 'K'
                        DW      Offset PEFunction_AltK

                        DB      1
                        DW      2C00h           ; Alt 'Z'
                        DW      Offset PEFunction_WipeBlock

                        DB      1
                        DW      2600h           ; Alt 'L'
                        DW      Offset PEFunction_AltL

                        DB      1
                        DW      1800h           ; Alt 'O'
                        DW      Offset PEFunction_BlockOverwrite

                        DB      1
                        DW      1900h           ; Alt 'P'
                        DW      Offset PEFunction_BlockPaste

                        DB      1
                        DW      2E00h           ; Alt 'C'
                        DW      Offset PEFunction_BlockCopy

                        DB      1
                        DW      3h              ; Ctrl 'C'
                        DW      Offset PEFunction_ToggleCentralise

                        DB      0
                        DW      146h            ; Scroll Lock
                        DW      Offset PEFunction_ToggleTrace

                        DB      2               ; Alt Scroll Lock
                        DW      146h
                        DW      Offset MIDIInputToggle

                        DB      1
                        DW      3200h           ; Alt 'M'
                        DW      Offset PEFunction_BlockMix

                        DB      1
                        DW      1000h           ; Alt 'Q'
                        DW      Offset PEFunction_SemiUp

                        DB      1
                        DW      1E00h           ; Alt 'A'
                        DW      Offset PEFunction_SemiDown

                        DB      1
                        DW      2D00h           ; Alt 'X'
                        DW      Offset PEFunction_WipeCommands

                        DB      1
                        DW      2400h           ; Alt 'J'
                        DW      Offset PEFunction_VolumeAmp

                        DB      1               ; Ctrl...
                        DW      0Ah             ; 'J'
                        DW      Offset ToggleFastVolume

                        DB      1
                        DW      2F00h           ; Alt 'V'
                        DW      Offset PEFunction_BlockVolume

                        DB      1
                        DW      1100h           ; Alt 'W'
                        DW      Offset PEFunction_WipeExcessVolumes

                        DB      1
                        DW      1400h           ; Alt 'T'
                        DW      Offset PEFunction_ViewTrack

                        DB      1               ; Ctrl...
                        DW      14h             ; 'T'
                        DW      Offset PEFunction_ToggleTracking

                        DB      1               ; Ctrl...
                        DW      8h              ; 'H'
                        DW      Offset PEFunction_ToggleRowHilight

                        DB      1
                        DW      2300h           ; Alt 'H'
                        DW      Offset PEFunction_ToggleDivision

                        DB      1
                        DW      1300h           ; Alt 'R'
                        DW      Offset PEFunction_ClearViews

                        DB      1
                        DW      1500h           ; Alt 'Y'
                        DW      Offset PEFunction_BlockSwap

                        DB      1
                        DW      2200h           ; Alt 'G'
                        DW      Offset PEFunction_BlockHalve

                        DB      1
                        DW      2100h           ; Alt 'F'
                        DW      Offset PEFunction_BlockDouble

;                        DB      0
;                        DW      14Eh            ; Grey Plus
;                        DW      Offset PEFunction_NextPattern
;
;                        DB      0
;                        DW      14Ah            ; Grey Minus
;                        DW      Offset PEFunction_LastPattern

                        DB      4               ; Shift
                        DW      14Eh
                        DW      Offset PEFunction_Next4Patterns

                        DB      4
                        DW      14Ah
                        DW      Offset PEFunction_Last4Patterns

                        DB      3               ; Ctrl..
                        DW      14Eh            ; Grey Plus
                        DW      Offset PEFunction_NextOrderPattern

                        DB      3               ; Ctrl..
                        DW      14Ah            ; Grey Minus
                        DW      Offset PEFunction_LastOrderPattern

                        DB      1
                        DW      '+'
                        DW      Offset PEFunction_NextPattern

                        DB      1
                        DW      '-'
                        DW      Offset PEFunction_LastPattern

                        DB      3               ; Ctrl
                        DW      141h            ; F7
                        DW      Offset PEFunction_SetPlayMark

                        DB      2
                        DW      10Bh
                        DW      Offset PEFunction_Alt0

                        DB      2       ; Alt Backspace
                        DW      10Eh
                        DW      Offset PEFunction_RestoreData

                        DB      2       ; Alt..
                        DW      11Ch    ; Enter
                        DW      Offset PEFunction_StoreCurrentPattern

                        DB      0
                        DW      0B02h   ; Left-Shift, Left-Ctrl '1'
                        DW      Offset PEFunction_Ctrl_Shift1

                        DB      0
                        DW      0B03h   ; Left-Shift, Left-Ctrl '2'
                        DW      Offset PEFunction_Ctrl_Shift2

                        DB      0
                        DW      0B04h   ; Left-Shift, Left-Ctrl '3'
                        DW      Offset PEFunction_Ctrl_Shift3

                        DB      0
                        DW      0B05h   ; Left-Shift, Left-Ctrl '4'
                        DW      Offset PEFunction_Ctrl_Shift4

                        DB      3       ; Ctrl..
                        DW      10Bh    ; '0'
                        DW      Offset PEFunction_Ctrl0

                        DB      3       ; Ctrl...
                        DW      102h    ; '1'
                        DW      Offset PEFunction_Ctrl1

                        DB      3       ; Ctrl...
                        DW      103h    ; '2'
                        DW      Offset PEFunction_Ctrl2

                        DB      3       ; Ctrl...
                        DW      104h    ; '3'
                        DW      Offset PEFunction_Ctrl3

                        DB      3       ; Ctrl...
                        DW      105h    ; '4'
                        DW      Offset PEFunction_Ctrl4

                        DB      3       ; Ctrl...
                        DW      106h    ; '5'
                        DW      Offset PEFunction_Ctrl5

                        DB      1
                        DW      '\'
                        DW      Offset PEFunction_Alt_F9

                        DB      0
                        DW      135h
                        DW      Offset PEFunction_MuteNext

                        DB      1
                        DW      '?'
                        DW      Offset PEFunction_MutePrevious

                        DB      2       ; Alt
                        DW      143h    ; F9
                        DW      Offset PEFunction_Alt_F9

                        DB      1
                        DW      '|'
                        DW      Offset PEFunction_SoloGotoNext

                        DB      2       ; Alt \
                        DW      12Bh
                        DW      Offset PEFunction_UnmuteAll

                        DB      2       ; Alt
                        DW      144h    ; F10
                        DW      Offset PEFunction_Alt_F10

                        DB      3       ; Ctrl
                        DW      140h    ; F6
                        DW      Offset PE_PlayCurrentPosition

                        DB      3       ; Ctrl
                        DW      13Ch    ; F2
                        DW      Offset PE_SetPatternLength

                        DB      1       ; Ctrl 'V'
                        DW      16h
                        DW      Offset PE_ToggleDefaultVolume

                        DB      1       ; Ctrl 'Z'
                        DW      1Ah
                        DW      Offset PE_CycleMIDIPlayTrigger

                        DB      6       ; MIDI message
                        DW      8000h
                        DW      Offset PE_MIDINoteOff

                        DB      6       ; MIDI message
                        DW      9000h
                        DW      Offset PE_MIDINote

                        DB      6       ; MIDI message
                        DW      0A000h
                        DW      Offset PE_MIDIAftertouch

                        DB      0FFh

CursorPositions         DB      0, 2, 4, 5, 7, 8, 10, 11, 12
                        DB      0, 2, 3, 4, 5, 6, 7, 8, 9
                        DB      0, 2, 3, 3, 4, 4, 5, 6, 6

                        DB      20h, 2, 1, 2, 1, 2, 0, 1, 2
                        DB      10h, 1, 0, 1, 0, 1, 0, 1, 1

MaskChange              DB      0, 0, 1, 1, 2, 2, 4, 4, 4
ChannelMsg              DB      " Channel xx ", 0
ChannelMsg2             DB      "Channel xx", 0
ChannelMsg3             DB      " Chnl xx", 0
ChannelMsg4             DB      " xx", 0
ChannelMsg5             DB      "xx", 0
ChannelMsg6             DB      "Ch xx", 0
ChannelMsg7             DB      "Chnl xx", 0

NoteNames               Label   Byte
                        DB      "C-C#D-D#E-F-F#G-G#A-A#B-" ; Cmaj
StartChannelEdit        DW      5


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Don't change order of variables within here!!!!

KeySignature            DW      0
NumChannelsEdit         DW      5

RowHiLight1             DB      4
RowHiLight2             DB      16

EditMask                DB      3               ; Bit 0 = ins
                                                ; Bit 1 = vol
                                                ; Bit 2 = commands
ViewDivision            DB      1
ViewWidth               DW      0
ViewChannels            DW      100 Dup (0FFFFh)   ; Contains channel/viewmethod
ViewChannelTracking     DB      0
CommandToValue          DB      0
CentraliseCursor        DB      0E8h    ; Bit 0 = centralise cursor
                                        ; Bit 1 = hilight row
                                        ; Bit 2 = fast volume changes
                                        ; Bit 3 = Record tick base
                                        ; Bit 4 = Program base 1
                                        ; Bit 5 = Record note off
                                        ; Bit 6 = Record velocity
                                        ; Bit 7 = Record aftertouch
MIDIAmplification       DB      100
MIDICentralNote         DB      60
FastVolumeAmplification DW      67
Flags                   DB      0       ; Extra flags
                                        ; Bit 0 = display defaults.
                                        ; Bit 1 = Record note cuts.

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ViewMethodInfo          Label
                        DW      Offset ViewFull
                        DW      13              ; Width

                        DW      Offset ViewCompress
                        DW      10              ; Width

                        DW      Offset ViewAllSmall
                        DW      7

                        DW      Offset ViewNote
                        DW      3

                        DW      Offset ViewTiny
                        DW      2

EmptyData               DB      253, 0, 255, 0, 0

TempNumbers             DB      3 Dup (0)

ErrorMsg                DB      "Unable to allocate memory for pattern edit area.", 13, 10
                        DB      "Sorry, more conventional memory is required to run this program.", 13, 10, "$"

ViewChannelTrackingMsg  DB      "View-Channel cursor tracking enabled", 0
NoViewChannelTrackingMsg DB     "View-Channel cursor tracking disabled", 0
CentraliseCursorMsg     DB      "Centralise cursor enabled", 0
NoCentraliseCursorMsg   DB      "Centralise cursor disabled", 0
TraceMsg                DB      "Playback tracing enabled", 0
NoTraceMsg              DB      "Playback tracing disabled", 0
PanningControlSetMsg    DB      "Panning control set", 0
VolumeControlSetMsg     DB      "Volume control set", 0
NoRowHilightMsg         DB      "Row hilight disabled", 0
RowHilightMsg           DB      "Row hilight enabled", 0
NoFastVolumeMsg         DB      "Alt-I / Alt-J fast volume changes disabled", 0
FastVolumeMsg           DB      "Alt-I / Alt-J fast volume changes enabled", 0
FastVolumeNotEnabledMsg DB      "Alt-I / Alt-J fast volume changes not enabled", 0
DefaultVolumeOn         DB      "Default volumes enabled", 0
DefaultVolumeOff        DB      "Default volumes disabled", 0
MIDIInputDisabledMsg    DB      "MIDI Input Disabled", 0
MIDIInputEnabledMsg     DB      "MIDI Input Enabled", 0
MIDIInputEnabled        DB      1

LastNote                DB      60
LastInstrument          DB      1
LastVolume              DB      0FFh
LastCommand             DB      0
LastCommandValue        DB      0
TracePlayback           DB      0

OrderListKeys   Label

IF ORDERSORT
        DB      1
        DW      1300h   ; Alt-R
        DW      Offset PE_PostOrderListReorder
ENDIF

        DB      0
        DW      10Fh
        DW      Offset PE_PostOrderList20

        DB      1
        DW      0F00h
        DW      Offset PE_PostOrderList21

        DB      3               ; Ctrl-F7
        DW      141h
        DW      Offset PE_PostOrderListNextOrder

        DB      1               ; Spacebar
        DW      ' '
        DW      Offset PE_PostOrderListNextOrder

        DB      0
        DW      1C8h            ; Up
        DW      Offset PE_PostOrderList1

        DB      0
        DW      1D0h            ; Down
        DW      Offset PE_PostOrderList3

        DB      0
        DW      1C9h            ; PgUp
        DW      Offset PE_PostOrderList4

        DB      0
        DW      1D1h            ; PgDn
        DW      Offset PE_PostOrderList6

        DB      0
        DW      1CBh            ; Left
        DW      Offset PE_PostOrderList7

        DB      0
        DW      1CDh            ; Right
        DW      Offset PE_PostOrderList9

        DB      5
        DW      'G'
        DW      Offset PE_PostOrderList24

        DB      1
        DW      '-'
        DW      Offset PE_PostOrderList16

        DB      1
        DW      '+'
        DW      Offset PE_PostOrderList17

        DB      0
        DW      1D3h    ; Insert
        DW      Offset PE_PostOrderList18

        DB      0
        DW      1D2h    ; Delete
        DW      Offset PE_PostOrderList19

        DB      0
        DW      1CFh    ; End
        DW      PE_PostOrderListEndKey

        DB      0
        DW      1C7h
        DW      PE_PostOrderListHomeKey

        DB      5
        DW      'N'
        DW      PE_PostOrderList22

        DB      0FFh

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Functions                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Proc            PE_ConvAX2Num Far               ; ES:DI points to screen
                                                ; CH = colour
                                                ; AX = number

                Push    AX
                Push    BX
                Push    DX

                Mov     BX, 10

                And     AX, AX
                JNS     PE_ConvAX2Num1

                Mov     Byte Ptr [ES:DI], '-'
                Inc     DI
                Neg     AX
                Mov     [ES:DI], CH
                Inc     DI
                Jmp     PE_ConvAX2Num2

PE_ConvAX2Num1:
                Xor     DX, DX
                Div     BX
                Add     DL, '0'
                Mov     DH, CH
                Mov     [ES:DI+4], DX

PE_ConvAX2Num2:
                Xor     DX, DX
                Div     BX
                Add     DL, '0'
                Mov     DH, CH
                Mov     [ES:DI+2], DX

                Xor     DX, DX
                Div     BX
                Add     DL, '0'
                Mov     DH, CH
                Mov     [ES:DI], DX

                Pop     DX
                Pop     BX
                Pop     AX

                Ret

EndP            PE_ConvAX2Num

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_ConvHexAL Near

                Cmp     AL, 10
                SBB     AL, 69h
                DAS
                StosW

                Ret

EndP            PE_ConvHexAL

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_GetMaxOrder Far              ; Returns AX with max order

                Push    CX
                Push    ES
                Push    DI

                Call    Music_GetSongSegment
                Mov     ES, AX
                Mov     DI, 256
                Mov     CX, 257
                Mov     AL, 0FFh
                RepNE   ScasB
                Mov     AX, 256
                Sub     AX, CX

                And     AX, AX
                JZ      PE_GetMaxOrder1

                Dec     AX

PE_GetMaxOrder1:
                Pop     DI
                Pop     ES
                Pop     CX

                Ret

EndP            PE_GetMaxOrder

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ClearEncodingInfo       ; Encoding info
                                        ; 1.Mask, 2.Instrument, 3.Volume, 4.Cmd
                                        ; 5.CmdVal, 6.Note

                Push    CS
                Pop     ES

                Mov     DI, Offset EncodingInfo

                Mov     CX, 64

ClearEncodingInfo1:
                Mov     AX, NONOTE*100h ; Mask&Note
                StosW
                Mov     AH, 0FFh        ; Ins&Vol
                StosW
                Xor     AX, AX          ; Cmd&Value
                StosW

                Loop    ClearEncodingInfo1

                Ret

EndP            ClearEncodingInfo

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

IF ORDERSORT

Proc            PE_PostOrderListSwapPatterns    ; Given BX = pattern 1
                                                ;       DX = Pattern 2

                PushA

                Mov     AX, CS:PatternNumber

                Cmp     AX, BX
                JNE     PE_PostOrderListSwapPatterns1
                Mov     AX, DX
                Jmp     PE_PostOrderLIstSwapPatterns2

PE_PostOrderListSwapPatterns1:
                Cmp     AX, DX
                JNE     PE_PostOrderListSwapPatterns2
                Mov     AX, BX

PE_PostOrderListSwapPatterns2:
                Mov     CS:PatternNumber, AX

; Search through order list and swap BX with DX

                Mov     SI, 100h
                Mov     CX, SI

PE_PostOrderListSwapPatterns3:
                LodsB

                Cmp     AL, BL
                JNE     PE_PostOrderListSwapPatterns4

                Mov     [SI-1], DL
                Jmp     PE_PostOrderListSwapPatterns5

PE_PostOrderListSwapPatterns4:
                Cmp     AL, DL
                JNE     PE_PostOrderListSwapPatterns5

                Mov     [SI-1], BL

PE_PostOrderListSwapPatterns5:
                Loop    PE_PostOrderListSwapPatterns3

; Now swap memory references to patterns.

                LEA     BX, [EBX*4+63912]
                LEA     DI, [EDX*4+63912]

                Mov     EAX, [BX]
                XChg    EAX, [DI]
                Mov     [BX], EAX

; Finished!

                PopA
                Ret

EndP            PE_PostOrderListSwapPatterns

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_PostOrderListReorder Far

                EnsureNoNetwork

                Call    Music_Stop

                Call    Music_GetSongSegment
                Mov     DS, AX                  ; DS:100h = order list.
                                                ; DS:63912 (4) = pattern data
                Mov     SI, 100h
                Xor     DX, DX          ; DX = min pattern
                Mov     CX, SI
                Xor     BX, BX

PE_PostOrderListReorder1:
                LodsB
                Cmp     AL, 200
                JAE     PE_PostOrderListReorder2

                Cmp     AL, DL
                JB      PE_PostOrderListReorder2
                JE      PE_PostOrderListReorder3

                Mov     BL, AL
                Call    PE_PostOrderListSwapPatterns

PE_PostOrderListReorder3:
                Inc     DX

PE_PostOrderListReorder2:
                Loop    PE_PostOrderListReorder1

PE_PostOrderListReorderExit:
                Mov     AX, 1
                Ret

EndP            PE_PostOrderListReorder
                Assume DS:Nothing

ENDIF           ; ORDERSORT

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_ResetOrderPattern Far

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Xor     AX, AX
                Mov     Order, AX
                Mov     OrderCursor, AX
                Mov     Channel, AX
                Mov     PatternCursor, AX
                Mov     LastInstrument, 1
                Mov     PlayMarkOn, 0

                Mov     BX, AX

                Call    Music_GetSongSegment
                Mov     ES, AX
                MovZX   AX, Byte Ptr [ES:BX+256]

                Cmp     AX, 199
                JBE     PE_ResetOrderPattern1

                Xor     AX, AX

PE_ResetOrderPattern1:
                Mov     PatternNumber, AX
                Call    NewPattern
                Mov     Word Ptr [CS:Modified], 0

                Call    Music_InitMixTable              ; Here 'cos it's called
                                                        ; on file loading.
                Call    Music_InitMuteTable             ; ditto.
                Call    Music_InitStereo
                Call    Music_SoundCardLoadAllSamples
                Call    PE_ClearUndoBuffer

                Mov     AX, Inst
                Mov     DS, AX
                        Assume DS:Inst
                Mov     NodeHeld, 0
                Mov     InstrumentEdit, 0

                Ret

EndP            PE_ResetOrderPattern
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_GetMaxPattern Far            ; Assumes DS:SongData

                Push    CX
                Push    DS
                Push    SI
                Push    DI

                Call    Music_GetSongSegment
                Mov     DS, AX

                Mov     SI, 63912

                Xor     AX, AX
                Xor     DI, DI
                Mov     CX, 200

PE_GetMaxPattern1:
                Cmp     Word Ptr [SI], 0
                JE      PE_GetMaxPattern2

                Mov     AX, DI

PE_GetMaxPattern2:
                Inc     DI
                Add     SI, 4
                Loop    PE_GetMaxPattern1

                Pop     DI
                Pop     SI
                Pop     DS
                Pop     CX
                Ret

EndP            PE_GetMaxPattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_FillHeader Far

                Call    Music_GetSongSegment
                Mov     DS, AX
                Call    S_GetDestination
                Mov     SI, 4
                Mov     DI, (12+3*80)*2
                Mov     CX, 25
                Mov     AH, 5

PE_FillHeader1:
                LodsB
                Cmp     AL, 226
                JB      PE_FillHeader14

                Mov     AL, ' '

PE_FillHeader14:
                StosW
                Loop    PE_FillHeader1

                Push    DS

                Mov     AX, Disk
                Mov     DS, AX
                Mov     SI, Offset FileName
                Mov     DI, (12+4*80)*2
                Mov     AH, 5

PE_FillHeader11:
                LodsB
                StosW
                And     AL, AL
                JNZ     PE_FillHeader11

                Pop     DS

                Mov     CH, AH
                Mov     AX, Order
                Mov     DI, (12+5*80)*2
                Call    PE_ConvAX2Num

                Call    PE_GetMaxOrder
                Mov     DI, (16+5*80)*2
                Call    PE_ConvAX2Num

                Mov     AX, PatternNumber
                Mov     DI, (12+6*80)*2
                Call    PE_ConvAX2Num

                Call    PE_GetMaxPattern
                Mov     DI, (16+6*80)*2
                Call    PE_ConvAX2Num

                Mov     AX, Row
                Mov     DI, (12+7*80)*2
                Call    PE_ConvAX2Num

                Mov     AX, MaxRow
                Mov     DI, (16+7*80)*2
                Call    PE_ConvAX2Num

                Call    Glbl_GetHeaderMode
                                        ; AL = inst
                                        ; AH = mode.
                Mov     DI, (50+3*80)*2
                And     AL, AL
                JNZ     PE_FillHeader6

                Mov     AX, 5*256+'.'
                StosW
                StosW
                ScasW
;                Add     DI, 2
                Mov     AL, '.'
                Mov     CX, 25
                Rep     StosW
                Jmp     PE_FillHeader7

PE_FillHeader6:
                Push    AX

                Mov     DL, 10
                Xor     AH, AH
                Mov     CX, AX
                Div     DL
                Add     AX, 3030h
                Mov     DL, AH
                Mov     AH, 5
                StosW
                Mov     AL, DL
                StosW
                ScasW
;                Add     DI, 2

                Pop     AX

                Dec     CX
                And     AH, AH          ; CX = ins number
                JZ      PE_FillHeader8

                                        ; Complex instrument mode
                Mov     AX, 554
                Mul     CX
                Add     AX, 544
                Jmp     PE_FillHeader9

PE_FillHeader8:                         ; Simple instrument mode
                Mov     AX, 80
                Mul     CX
                Add     AX, 55932

PE_FillHeader9:
                Mov     SI, AX
                Mov     CX, 25
                Mov     AH, 5

PE_FillHeader10:
                LodsB
                Cmp     AL, 226
                JB      PE_FillHeader13

                Mov     AL, ' '

PE_FillHeader13:
                StosW
                Loop    PE_FillHeader10

PE_FillHeader7:
;                Mov     AL, LastVolume

                Call    PE_FillSpeedTempo

;                Cmp     AL, 0FFh
;                JNE     PE_FillHeader4
;
;                Mov     AX, 5*256+'.'
;                StosW
;                StosW
;                Jmp     PE_FillHeader5
;
;PE_FillHeader4:
;                Xor     AH, AH
;                Mov     CL, 10
;                Div     CL
;                Add     AX, 3030h
;                Mov     DL, AH
;                Mov     AH, 5
;                StosW
;                Mov     AL, DL
;                StosW

PE_FillHeader5:
                Mov     AX, BaseOctave
                Add     AL, '0'
                Mov     AH, 5
                Mov     [ES:((50+5*80)*2)], AX

;                Mov     AH, 48h
;                Mov     BX, 0FFFFh
;                Int     21h
;                Mov     AX, BX
;                Mov     CX, 2006h
;                ShR     AX, CL
;                Mov     DI, (71+6*80)*2
;                Call    PE_ConvAX2Num
;
;                Call    E_GetFreeEMS
;                Xor     DX, DX
;                Mov     BX, 1000
;                Div     BX
;
;                Add     AL, '0'
;                Mov     AH, CH
;                Mov     [ES:(70+7*80)*2], AX
;                Mov     AX, DX
;                Mov     DI, (71+7*80)*2
;                Call    PE_ConvAX2Num


;                Call    K_GetCaps
;                Mov     AH, 21h
;                And     AL, AL
;                JZ      PE_FillHeader2
;
;                Mov     AH, 23h
;
;PE_FillHeader2:
;                Mov     DI, (75+10*80)*2
;                Mov     SI, Offset CapsMsg
;                Mov     CX, 4
;
;PE_FillHeader3:
;                SegCS   LodsB
;                StosW
;                Loop    PE_FillHeader3

                Call    UpdateInfoLine

                Ret

EndP            PE_FillHeader

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_FillSpeedTempo Far

                Call    S_GetDestination

                Call    Music_GetDisplayVariables       ; AX = current speed.
                Mov     CH, 5
                Mov     DI, (50+4*80)*2
                Call    PE_ConvAX2Num

                Mov     AX, BX
                Mov     DI, (54+4*80)*2
                Call    PE_ConvAX2Num

                Ret

EndP            PE_FillSpeedTempo

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_DrawOrderList Far

                Mov     AL, 80
                Mul     Byte Ptr [SI+3]
                Add     AL, [SI+2]
                AdC     AH, 0
                Add     AX, AX
                Mov     DI, AX
                Mov     CX, [SI+4]

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     AX, TopOrder            ; Bounds checking...
                Mov     BX, Order
                Cmp     AX, BX
                JBE     PE_DrawOrderList1

                Mov     AX, BX

PE_DrawOrderList1:
                Mov     DX, AX
                Add     DX, CX
                Cmp     DX, BX
                JA      PE_DrawOrderList2

                LEA     AX, [BX+1]
                Sub     AX, CX

PE_DrawOrderList2:
                Mov     TopOrder, AX
                Mov     BX, AX

                Call    S_GetDestination
                Push    CX
                Push    DI

PE_DrawOrderList3:
                Push    CX

                Mov     CH, 20h
                Call    PE_ConvAX2Num

                Add     DI, 160
                Inc     AX

                Pop     CX
                Loop    PE_DrawOrderList3

                Pop     DI
                Pop     CX
                Add     DI, 8               ; BX = toporder, DI = order area

                Call    Music_GetSongSegment
                Mov     DS, AX
                Add     BX, 256

PE_DrawOrderList4:
                Push    CX

                Mov     CH, 2
                MovZX   AX, Byte Ptr [BX]
                Cmp     AX, 0FEh
                JB      PE_DrawOrderList5

                Mov     CL, '-'
                Cmp     AL, 0FEh
                JNE     PE_DrawOrderList7

                Mov     CL, '+'

PE_DrawOrderList7:
                Mov     AX, CX
                StosW
                StosW
                StosW
                Sub     DI, 6

                Jmp     PE_DrawOrderList6


PE_DrawOrderList5:
                Call    PE_ConvAX2Num

PE_DrawOrderList6:
                Pop     CX
                Inc     BX
                Add     DI, 160
                Loop    PE_DrawOrderList4

                Call    Music_GetPlayMode
                Cmp     AX, 2
                JNE     PE_DrawOrderList8

                Jmp     PE_ShowOrder

PE_DrawOrderList8:
                Ret

EndP            PE_DrawOrderList
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_PreOrderList Far

                Mov     AL, 80
                Mov     BX, Order
                Sub     BX, TopOrder
                Add     BL, [SI+3]
                Mul     BL
                Add     AL, [SI+2]
                AdC     AH, 0
                Add     AX, 4
                Add     AX, OrderCursor
                Add     AX, AX
                Mov     DI, AX

                Call    S_GetDestination
                Inc     DI
                Mov     Byte Ptr [ES:DI], 30h

                Ret

EndP            PE_PreOrderList

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            NetworkOrderList Near

IF NETWORKENABLED
                Call    Network_GetSendQueue
                JZ      NetworkOrderList1

                Mov     AX, NETWORK_SONGDATAOBJECT*100h ; Destination ALL
                StosW
                Mov     AX, 256
                StosW
                StosW

NetworkOrderList1:
                Call    Network_FinishedSendQueue
ENDIF
                Ret

EndP            NetworkOrderList

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_PostOrderList Far

                Push    ES
                Pop     DS
                Mov     SI, [BX]

                Push    BX

                Mov     AL, 80
                Mov     BX, Order
                Sub     BX, TopOrder
                Add     BL, [SI+3]
                Mul     BL
                Add     AL, [SI+2]
                AdC     AH, 0
                Add     AX, 4

                Pop     BX

;                Push    ES
;                Push    DI

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Push    ES
                Pop     FS

                Call    Music_GetSongSegment
                Mov     ES, AX

                Mov     SI, Offset OrderListKeys
                Call    M_FunctionDivider
                Mov     AX, Order
                JC      PE_NoKeyFound

                Jmp     [SI]

PE_NoKeyFound:
                Test    CH, Not 1
                JNZ     PE_PostOrderList10

                Cmp     DX, '0'
                JB      PE_PostOrderList10

                Cmp     DX, '9'
                JBE     PE_PostOrderList11

PE_PostOrderList10:
                Xor     AX, AX
                Ret

PE_PostOrderListNextOrder:
                Call    Music_GetPlayMode
                Cmp     AX, 2
                JNE     PE_PostOrderListNextOrderEnd

                Mov     AX, Order
                Mov     SI, Offset NextOrderMsg
                Call    SetInfoLine

                Call    Music_SetNextOrder

PE_PostOrderListNextOrderEnd:
                Mov     AX, 1
                Ret

PE_PostOrderListHomeKey:
                Mov     Order, 0
                Jmp     PE_PostOrderList2

PE_PostOrderListEndKey:
                Call    Music_GetSongSegment
                Mov     DS, AX
                Mov     SI, 100h

PE_PostOrderListEndKeyLoop:
                LodsB
                Cmp     AL, 0FFh
                JE      PE_postOrderListEndKeyLoopEnd

                Cmp     SI, 100h+255
                JBE     PE_PostOrderListEndKeyLoop

PE_PostOrderListEndKeyLoopEnd:
                Sub     SI, 101h
                Mov     CS:Order, SI

                Jmp     PE_PostOrderList2

PE_PostOrderList20:
                Push    FS
                Pop     DS
                Mov     SI, [BX]

                Mov     AX, [SI+6]
                Mov     [DI], AX
                Jmp     PE_PostOrderList2

PE_PostOrderList21:
                Push    FS
                Pop     DS
                Mov     SI, [BX]

                Mov     AX, [SI+8]
                Mov     [DI], AX
                Jmp     PE_PostOrderList2

PE_PostOrderList1:                              ; Up
                And     AX, AX
                JZ      PE_PostOrderList2

                Dec     AX
                Mov     Order, AX

PE_PostOrderList2:
                Mov     AX, 1
                Ret

PE_PostOrderList3b:
                Call    NetworkOrderList

PE_PostOrderList3:                              ; Down
                Cmp     AX, 255
                JAE     PE_PostOrderList2
                Inc     AX
                Mov     Order, AX
                Jmp     PE_PostOrderList2

PE_PostOrderList4:                              ; PgUp
                Sub     AX, 16
                JNS     PE_PostOrderList5

                Xor     AX, AX

PE_PostOrderList5:
                Mov     Order, AX
                Jmp     PE_PostOrderList2

PE_PostOrderList6:                              ; PgDn
                Add     AX, 16
                And     AH, AH
                JZ      PE_PostOrderList5

                Mov     AX, 255
                Jmp     PE_PostOrderList5

PE_PostOrderList7:                              ; Left
                Mov     AX, OrderCursor
                Dec     AX
                JNS     PE_PostOrderList8

                Mov     AX, 2

PE_PostOrderList8:
                Mov     OrderCursor, AX
                Jmp     PE_PostOrderList2

PE_PostOrderList9:                              ; Right
                Mov     AX, OrderCursor
                Inc     AX
                Cmp     AX, 2
                JBE     PE_PostOrderList8

                Xor     AX, AX
                Jmp     PE_PostOrderList8

PE_PostOrderList11:
                Mov     SI, AX
                MovZX   AX, Byte Ptr [ES:SI+256]         ; AX = pattern number
                Cmp     AL, 199
                JBE     PE_PostOrderList15

                Xor     AL, AL

PE_PostOrderList15:                     ; Number
                Mov     CL, 10
                Div     CL
                Mov     [TempNumbers+2], AH
                Xor     AH, AH
                Div     CL
                Mov     [TempNumbers+1], AH
                Xor     AH, AH
                Div     CL
                Mov     [TempNumbers], AH

                Mov     BX, OrderCursor
                Sub     DX, '0'
                Mov     TempNumbers[BX], DL

                Mov     AL, [TempNumbers]
                Mul     CL
                Add     AL, [TempNumbers+1]
                Mul     CL
                Add     AL, [TempNumbers+2]

                Cmp     AX, 199
                JBE     PE_PostOrderList12

                Mov     AX, 199

PE_PostOrderList12:
                Mov     [ES:SI+256], AL
                Call    NetworkOrderList

                Inc     BX
                Cmp     BX, 2
                JBE     PE_PostOrderList13

                Cmp     SI, 255
                JE      PE_PostOrderList2

                Xor     BX, BX
                Inc     Order

PE_PostOrderList13:
                Mov     OrderCursor, BX
                Jmp     PE_PostOrderList2


PE_PostOrderList16:                     ; '-'
                Mov     SI, AX
                Mov     Byte Ptr [ES:SI+256], 0FFh
                Mov     OrderCursor, 0

                Jmp     PE_PostOrderList3b

PE_PostOrderList17:                     ; '+'
                Mov     SI, AX
                Mov     Byte Ptr [ES:SI+256], 0FEh
                Mov     OrderCursor, 0

                Jmp     PE_PostOrderList3b

PE_PostOrderList18:                     ; Del
                Mov     SI, AX
                Add     SI, 256
                Mov     DI, SI
                Inc     SI

                Push    ES
                Pop     DS

                Mov     CX, 512
                Sub     CX, SI
                Rep     MovsB
                Mov     AL, 0FFh
                StosB

                Call    NetworkOrderList
                Jmp     PE_PostOrderList2

PE_PostOrderList19:                     ; Ins
                Mov     CX, 255
                Mov     DI, 511
                Mov     SI, DI
                Sub     CX, AX
                Dec     SI

                Push    ES
                Pop     DS

                StD
                Rep     MovsB
                ClD
                Mov     AL, 0FFh
                StosB

                Call    NetworkOrderList
                Jmp     PE_PostOrderList2

PE_PostOrderList22:
                Mov     SI, Order
                And     SI, SI
                JZ      PE_PostOrderList23

                Mov     AL, [ES:SI+255]
                Cmp     AL, 198
                JA      PE_PostOrderList23

                Inc     AX
                Mov     [ES:SI+256], AL

                Mov     AX, SI
                Jmp     PE_PostOrderList3b

PE_PostOrderList23:
                Xor     AX, AX
                Ret

PE_PostOrderList24:                             ; 'G'
                Mov     BX, AX
                MovZX   AX, Byte Ptr [ES:BX+256]
                Cmp     AL, 200
                JAE     PE_PostOrderList23

                Jmp     PE_GotoPattern2

EndP            PE_PostOrderList
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_UnInitPatternEdit Far

                Mov     AX, CS:BlockDataArea
                And     AX, AX
                JZ      PE_UnInitPatternEdit1

                Mov     ES, AX
                Mov     AH, 49h
                Int     21h

PE_UnInitPatternEdit1:
                Call    PE_ClearUndoBuffer

                Ret

EndP            PE_UnInitPatternEdit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_ClearPatternData

                Push    CX DX DS SI ES DI

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     ES, PatternDataArea
                Xor     DI, DI

                Mov     DX, 200

PE_ClearPatternData1:
                Mov     CX, 320/4
                Mov     SI, Offset EmptyRow
                Rep     MovsD

                Dec     DX
                JNZ     PE_ClearPatternData1

                Pop     DI ES SI DS DX CX
                Ret

EndP            PE_ClearPatternData
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_InitPatternEdit Far

                Trace   " - Initialising pattern data area"

                Call    PE_ClearPatternData
                Ret

EndP            PE_InitPatternEdit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

include it_pe_v.inc

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_DrawPatternEdit Far

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Cmp     TracePlayback, 0
                JE      PE_TraceOff

                Call    Music_GetPlayMode       ; AX = playmode
                                                ; BX = current row
                                                ; CX = current pattern
                                                ; DX = order.
                Cmp     AX, 1
                JB      PE_TraceOff
                JE      PE_NoTraceOrder

                Mov     Order, DX

PE_NoTraceOrder:
                Cmp     BX, Row
                JE      PE_SetMIDIChannel

                Mov     AX, Channel
                Mov     MIDIChannel, AX

                Mov     Row, BX

PE_SetMIDIChannel:
                Cmp     CX, PatternNumber
                JE      PE_TraceOff

                Push    CX                      ; Pattern number
                Push    CS
                Push    Offset PE_TraceTurnOffError

                Cmp     PatternModified, 0
                JE      PE_NoStoreRequired

                Call    PEFunction_StorePattern

PE_NoStoreRequired:
                Pop     AX
                Pop     AX
                Pop     AX

                Mov     PatternNumber, AX
                Call    NewPattern
                Jmp     PE_TraceOff

PE_TraceTurnOffError:
                Pop     AX

PE_TraceTurnOff:
                Mov     CS:TracePlayback, 0

PE_TraceOff:
                Push    CS
                Pop     DS

                Call    S_GetDestination
                Mov     AL, Template
                Cmp     AL, 1
                JB      PE_DrawPAtternEdit30

                Mov     SI, Offset TemplateMsg1
                JE      PE_DrawPatternEdit31

                Mov     SI, Offset TemplateMsg2
                Cmp     AL, 3
                JB      PE_DrawPatternEdit31

                Mov     SI, Offset TemplateMsg3
                JE      PE_DrawPatternEdit31

                Mov     SI, Offset TemplateMsg4

PE_DrawPatternEdit31:
                Mov     DI, (2+12*80)*2
                Mov     AH, 23h
                Call    S_DrawString

PE_DrawPatternEdit30:
                Test    CentraliseCursor, 1
                JZ      PE_NoCentraliseCursor

                Call    PE_CentraliseCursor

PE_NoCentraliseCursor:
                Mov     AX, MaxRow
                Cmp     AX, Row
                JAE     PE_DrawPatternEdit27

                Mov     Row, AX

PE_DrawPatternEdit27:
                Mov     BX, BlockTop
                Cmp     BX, AX
                JLE     PE_DrawPatternEdit28

                Mov     BlockTop, AX

PE_DrawPatternEdit28:
                Mov     BX, BlockBottom
                Cmp     BX, AX
                JLE     PE_DrawPatternEdit29

                Mov     BlockBottom, AX

PE_DrawPatternEdit29:
                Mov     BX, ViewWidth
                Test    BX, BX
                JZ      PE_DrawPatternEdit1

                Mov     CX, 3
                Cmp     NumChannelsEdit, 0
                JE      PE_DrawPatternEditNoEditChannels

                Xor     CX, CX

PE_DrawPatternEditNoEditChannels:
                Mov     AX, 1
                Add     AX, CX
                Push    AX
                Push    14
                Mov     AX, BX
                Add     AX, CX
                Push    AX
                Push    47
                Push    27
                Call    S_DrawBox
                Add     SP, 10

PE_DrawPatternEdit1:
                Cmp     NumChannelsEdit, 0
                JE      PE_DrawPatternEdit34

                Mov     CX, 4
                Add     CX, BX
                Push    CX
                Mov     AX, 14
                Push    AX
                Mul     NumChannelsEdit
                Add     AX, CX
                Push    AX
                Push    47
                Push    27
                Call    S_DrawBox
                Add     SP, 10

                Mov     AX, LeftChannel
                Mov     CX, Channel

                Cmp     AX, CX
                JLE     PE_DrawPatternEdit21

                Mov     AX, CX

PE_DrawPatternEdit21:
                Mov     DX, AX
                Add     DX, NumChannelsEdit
                Cmp     DX, CX
                JG      PE_DrawPatternEdit22

                Mov     AX, CX
                Sub     AX, NumChannelsEdit
                Inc     AX

PE_DrawPatternEdit22:
                Mov     LeftChannel, AX
                                                ; Channel markers.
                Mov     DX, AX                  ; DL = left channel
                Mov     AX, 5+14*80
                Add     AX, ViewWidth
                Add     AX, AX
                Mov     DI, AX
                Mov     DH, 10

                Mov     CX, NumChannelsEdit

PE_DrawPatternEdit23:
                Push    CX

                MovZX   AX, DL
                Inc     AX
                Div     DH
                Add     AX, 3030h
                Mov     SI, Offset ChannelMsg
                Mov     [SI+9], AX

                Push    DS
                Push    SI

                Call    Music_GetSongSegment
                Mov     DS, AX

                Mov     SI, DX
                And     SI, 0FFh
                Add     SI, 40h
                Mov     AH, 13h
                Test    Byte Ptr [SI], 80h
                JZ      PE_DrawPatternEdit32

                Mov     AH, 10h

PE_DrawPatternEdit32:
                Pop     SI
                Pop     DS

                Mov     CX, 12

PE_DrawPatternEdit24:
                LodsB
                StosW
                Loop    PE_DrawPatternEdit24

                Pop     CX
                Add     DI, 4
                Inc     DX
                Loop    PE_DrawPatternEdit23

PE_DrawPatternEdit34:
                Cmp     ViewChannelTracking, 0
                JE      PE_DrawPatternEditNormal

                                        ; OK.. using view windows ONLY.
                                        ; now to perform scrolling if necessary.
                Mov     SI, Offset ViewChannels
                Mov     DL, [SI]

                Cmp     DL, 0FFh
                JE      PE_DrawPatternEditNormal

                Mov     DH, DL          ; DL = min channel, DH = max channel
                Mov     CX, Channel     ; Also check

PE_DrawPatternViewChannelOnly1:
                LodsW

                Cmp     AL, CL
                JE      PE_DrawPatternEditNormalJP

                Cmp     AL, 0FFh
                JE      PE_DrawPatternViewChannelOnly2

                Cmp     AL, DL
                JB      PE_DrawPatternViewChannelOnly3

                Cmp     AL, DH
                JA      PE_DrawPatternViewChannelOnly4

                Jmp     PE_DrawPatternViewChannelOnly1

PE_DrawPatternViewChannelOnly3:
                Mov     DL, AL
                Jmp     PE_DrawPatternViewChannelOnly1

PE_DrawPatternViewChannelOnly4:
                Mov     DH, AL
                Jmp     PE_DrawPatternViewChannelOnly1

PE_DrawPatternEditNormalJP:
                Jmp     PE_DrawPatternEditNormal

PE_DrawPatternViewChannelOnly2:         ; OK.. so channel is not in list,
                                        ; DL = min channel, DH = max channel.
                Mov     CH, CL
                Sub     CH, DH          ; CH = curchannel-maxchannel

                Cmp     DH, CL
                JBE     PE_DrawPatternViewChannelOnly5

                Mov     CH, CL
                Sub     CH, DL

PE_DrawPatternViewChannelOnly5:         ; CH = modifier.

                Mov     SI, Offset ViewChannels

PE_DrawPatternViewChannelOnly6:
                LodsW
                Cmp     AL, 0FFh
                JE      PE_DrawPatternEditNormal

                Add     AL, CH
                JS      PE_DrawPatternViewChannelOnly7

                Cmp     AL, 63
                JBE     PE_DrawPatternViewChannelOnly8

                Mov     AL, 63
                Jmp     PE_DrawPatternViewChannelOnly8

PE_DrawPatternViewChannelOnly7:
                Xor     AL, AL

PE_DrawPatternViewChannelOnly8:
                Mov     [SI-2], AL
                Jmp     PE_DrawPatternViewChannelOnly6

PE_DrawPatternEditNormal:
                Mov     AX, TopRow
                Mov     CX, Row

                Cmp     AX, CX
                JLE     PE_DrawPatternEdit2

                Mov     AX, CX                  ; if row < toprow, toprow = row

PE_DrawPatternEdit2:
                LEA     DX, [EAX+32]
                Cmp     DX, CX
                JG      PE_DrawPatternEdit3

                LEA     AX, [ECX-31]

PE_DrawPatternEdit3:
                Mov     TopRow, AX

                Mov     CX, MaxRow
                Sub     CX, 31
                Cmp     AX, CX
                JBE     PE_DrawPatternEdit35

                Mov     TopRow, CX
                Mov     AX, CX

PE_DrawPatternEdit35:
                Mov     DI, (1+15*80)*2
                Cmp     NumChannelsEdit, 0
                JNE     PE_DrawPatternEditAllView

                Xor     BX, BX

PE_DrawPatternEditAllView:
                LEA     DI, [EDI+EBX*2]

                Xor     BX, BX
                Cmp     PlayMarkOn, 0
                JE      PE_DrawPlayMark

                Mov     CX, PlayMarkPattern
                Cmp     CX, PatternNumber
                JNE     PE_DrawPlayMark

                Mov     BX, 1                   ; Check to draw playmark

PE_DrawPlayMark:
                Push    DI

                Mov     DX, 32

PE_DrawPatternEdit4:
                Push    DI

                Mov     CH, 20h
                And     BX, BX
                JZ      PE_DrawPatternEditRowNumber

                Cmp     AX, PlayMarkRow
                JNE     PE_DrawPatternEditRowNumber

                Mov     CH, 0B0h

PE_DrawPatternEditRowNumber:
                Call    PE_ConvAX2Num

                Pop     DI
                Inc     AX
                Add     DI, 160

                Dec     DX
                JNZ     PE_DrawPatternEdit4

                Mov     BX, Offset NoteNames    ; CS:BX points to notenames

                Push    DS
                                        ; Viewing columns...
                Mov     SI, Offset ViewChannels
                Mov     DI, (15*80+2)*2
                Cmp     NumChannelsEdit, 0
                JNE     PE_DrawviewColumnStart

                Add     DI, 6

PE_DrawViewColumnStart:
                LodsW
                Cmp     AL, 0FFh
                JE      PE_DrawViewColumn2

PE_DrawViewColumn1:
                                        ; AL = channel, AH = view method.
                Mov     DL, AL
                MovZX   CX, AH
                LEA     BP, [ViewMethodInfo+ECX*4]

                Push    DS
                Push    SI
                Push    ES
                Push    DI
                Push    BP

                Mov     SI, 5
                Xor     AH, AH
                Push    DX
                Mul     SI
                Mov     SI, AX
                Mov     AX, 320
                Mov     CX, TopRow
                Mul     CX
                Pop     DX
                Mov     DS, PatternDataArea
                Add     SI, AX          ; DS:SI points to appropriate data.
                                        ; CS:BX points to note type.
                                        ; ES:DI points to screen area.
                                        ; DL = Channel number
                                        ; CX = Row number

                Call    [Near Ptr CS:BP]

                Pop     BP
                Pop     DI
                Pop     ES
                Pop     SI
                Pop     DS

                LodsW
                Cmp     AL, 0FFh
                JE      PE_DrawViewColumn2

                Push    AX

                Mov     CX, [CS:BP+2]
                Add     DI, CX
                Add     DI, CX

                Cmp     ViewDivision, 0
                JE      PE_DrawViewColumn4

                Mov     CX, 32
                Push    DI

                Mov     AX, 2A8h

PE_DrawViewColumn3:
                StosW
                Add     DI, 158
                Loop    PE_DrawViewColumn3

                Pop     DI
                StosW                           ; Just to do: Add DI, 2

PE_DrawViewColumn4:
                Pop     AX
                Jmp     PE_DrawViewColumn1

PE_DrawViewColumn2:
                Pop     DS
                Pop     DI
                Add     DI, 8

                Cmp     NumChannelsEdit, 0
                JE      PE_DrawPatternHilightRow

PE_DrawPatternEdit33:
                Mov     AX, 320
                Mov     BP, TopRow
                Mul     BP
                Mov     SI, AX
                Mov     AX, 5
                Mul     LeftChannel
                Add     SI, AX             ; SI contains offset to channel data
                Mov     DX, NumChannelsEdit

                Mov     CX, 32                  ; 32 rows
                Mov     DS, PatternDataArea
                        Assume DS:Nothing

PE_DrawPatternEdit5:
                Push    CX
                Push    DX
                Push    SI
                Push    DI
                Push    BP

                Mov     CX, 60Ch

                Mov     AX, BP
                Cmp     RowHiLight2, 0
                JZ      PE_DrawPatternEdit8
                Div     RowHiLight2
                And     AH, AH
                JNZ     PE_DrawPatternEdit8

                Mov     CH, 0E6h
                Jmp     PE_DrawPatternEdit6

PE_DrawPatternEdit8:
                Mov     AX, BP
                Cmp     RowHiLight1, 0
                JZ      PE_DrawPatternEdit6
                Div     RowHiLight1
                And     AH, AH
                JNZ     PE_DrawPatternEdit6

                Mov     CH, 0F6h

PE_DrawPatternEdit6:                    ; CH = colour, CL = 12 (for division)
                Push    CX
                Push    DX

                Cmp     CS:BlockMark, 0
                JE      PE_DrawPatternEdit25

                Cmp     BP, CS:BlockTop
                JB      PE_DrawPatternEdit25

                Cmp     BP, CS:BlockBottom
                JA      PE_DrawPatternEdit25

                Mov     AX, CS:LeftChannel
                Add     AX, CS:NumChannelsEdit
                Sub     AX, DX

                Cmp     AX, CS:BlockLeft
                JB      PE_DrawPatternEdit25

                Cmp     AX, CS:BlockRight
                JA      PE_DrawPatternEdit25

                Test    CH, 80h
                JZ      PE_DrawPatternEdit26

                Mov     CH, 93h
                Jmp     PE_DrawPatternHilight1

PE_DrawPatternEdit26:
                Mov     CH, 83h
                Jmp     PE_DrawPatternHilight1

PE_DrawPatternEdit25:
                Cmp     BP, Row
                JNE     PE_DrawPatternHilight1

                Test    CentraliseCursor, 2
                JZ      PE_DrawPatternHilight1

                Mov     CH, 016h

PE_DrawPatternHilight1:
                LodsB

                Call    Draw_3Note

                Mov     AL, 20h
                StosW                           ; Note->Instrument space

                Mov     DL, 10
                LodsB

                Call    Draw_2Instrument

                Mov     AL, 20h
                StosW

                LodsB
                Cmp     AL, 0FFh
                JNE     PE_DrawPattern16

                Test    CS:Flags, 1
                JZ      PE_DrawPatternNoDefaultVolume

                Cmp     Byte Ptr [SI-3], MAXNOTE
                JA      PE_DrawPatternNoDefaultVolume
                Cmp     Byte Ptr [SI-2], 0
                JE      PE_DrawPatternNoDefaultVolume

                Sub     DI, 2
                Mov     AL, 191
                StosW

                Push    BX

                Call    Music_GetSongSegment
                Mov     FS, AX
                Mov     BL, [SI-2]      ; Sample/Instrument
                And     BX, 0FFh
                Add     BX, BX

                Test    Byte Ptr [FS:2Ch], 4    ; Sample mode?
                JZ      DefaultVolumeSample

DefaultVolumeInstrument:
                Push    DI

                Mov     BX, [FS:64710+BX]       ; Instrument pointer
                Mov     DI, [SI-3]
                And     DI, 0FFh                ; DI = Note
                Add     DI, DI
                Mov     BX, [FS:BX+DI+41h]      ; BL = sample

                Pop     DI
                And     BX, 0FFh
                Add     BX, BX
                JZ      DefaultVolumeNoSample

DefaultVolumeSample:
                Mov     BX, [FS:64910+BX]       ; Sample
                Mov     AL, [FS:BX+13h]         ; Default volume

                Pop     BX
                Mov     DL, 10
                Xor     AH, AH
                Div     DL
                Add     AX, '00'
                Mov     DH, AH
                Mov     AH, CH
                StosW
                Mov     AL, DH
                StosW
                Mov     AL, 192
                StosW
                Jmp     PE_DrawPatternEffect

DefaultVolumeNoSample:
                Pop     BX

                Mov     AH, CH
                Mov     AL, 173         ; Replace with default volume
                StosW
                StosW
                Mov     AL, 192
                StosW
                Jmp     PE_DrawPatternEffect

PE_DrawPatternNoDefaultVolume:
                Mov     AL, 173                         ; '.'
                StosW
                StosW
                Jmp     PE_DrawPattern17

PE_DrawPattern16:
                Mov     AH, AL
                And     AH, 7Fh
                Sub     AH, 65
                JC      PE_DrawPatternNoVEffect

                Test    AL, 80h
                JZ      PE_DrawPatternVEffect1

                Add     AH, 60

PE_DrawPatternVEffect1:
                Mov     AL, AH
                Xor     AH, AH
                Div     DL
                                        ; AL = effect, AH = num
                Add     AX, 'A'+'0'*256
                Mov     DH, AH
                Mov     AH, CH
                StosW
                Mov     AL, DH
                StosW

                Jmp     PE_DrawPattern17

PE_DrawPatternNoVEffect:
                Mov     CL, CH

                Test    AL, 80h
                JZ      PE_DrawPatternNoPan

                And     CL, 0F0h
                Or      CL, 2
                And     AL, 7Fh         ; Filter out panning stuff.


PE_DrawPatternNoPan:
                Xor     AH, AH
                Div     DL
                                                ; AH = units, AL = tens
                Mov     DH, AH
                Mov     AH, CL
                Add     AL, '0'
                StosW
                Mov     AL, DH
                Add     AL, '0'
                StosW

                Mov     AH, CH

PE_DrawPattern17:
                Mov     AL, 20h
                StosW

PE_DrawPatternEffect:
                LodsB
                Add     AL, 64
                Cmp     AL, 64
                JNE     PE_DrawPattern18

                Mov     AL, '.'

PE_DrawPattern18:
                StosW
                LodsB                   ; Commandvalue
                Mov     DH, AL
                ShR     AL, 4

                Call    PE_ConvHexAL

                Mov     AL, DH
                And     AL, 15
                Call    PE_ConvHexAL

                Pop     DX
                Pop     CX
                Dec     DX
                JZ      PE_DrawPatternEdit9

                And     AX, 0F000h
                Or      AX, 2A8h
                Cmp     AH, 80h
                JB      PE_DrawDiv1
                Cmp     AH, 0A0h
                JAE     PE_DrawDiv1

                Mov     AX, 2A8h

PE_DrawDiv1:
                StosW
                Jmp     PE_DrawPatternEdit6

PE_DrawPatternEdit9:
                Pop     BP
                Pop     DI
                Pop     SI
                Pop     DX
                Pop     CX
                Add     DI, 160                 ; Screen
                Add     SI, 320                 ; PatternData
                Inc     BP                      ; Row
                Loop    PE_DrawPatternEdit5

PE_DrawPatternHilightRow:
                Call    Music_GetPlayMode
                Test    AX, AX
                JZ      PE_DrawPattern40

                Cmp     CX, CS:PatternNumber
                JNE     PE_DrawPattern40

                Sub     BX, CS:TopRow
                JC      PE_DrawPattern40
                Cmp     BL, 32
                JAE     PE_DrawPattern40
                Mov     AL, 80
                Mul     BL

                Mov     DI, AX
                Add     DI, 1+15*80
                Cmp     CS:NumChannelsEdit, 0
                JE      PE_DrawPattern41

                Add     DI, CS:ViewWidth

PE_DrawPattern41:
                Add     DI, DI

                Push    ES
                Pop     DS

                Mov     CL, 3

PE_DrawPattern42:
                Inc     DI
                Mov     AL, [DI]
                And     AL, 0F0h
                Or      AL, 3
                StosB

                Dec     CL
                JNZ     PE_DrawPattern42

PE_DrawPattern40:
                Ret

EndP            PE_DrawPatternEdit
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_PrePatternEdit Far

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Cmp     NumChannelsEdit, 0
                JNE     PE_PrePatternEdit18

                Ret

PE_PrePatternEdit18:
                Call    S_GetDestination

                Mov     AX, 80
                Mov     BX, 15
                Add     BX, Row
                Sub     BX, TopRow
                Mul     BL
                Add     AX, ViewWidth
                Add     AX, 5
                Mov     BX, PatternCursor
                Add     AL, [CursorPositions+BX]
                AdC     AH, 0
                Mov     DI, AX
                Mov     AL, 14
                Mov     BX, Channel
                Sub     BX, LeftChannel
                Mul     BL
                Add     DI, AX
                Add     DI, DI
                Inc     DI
                Mov     Byte Ptr [ES:DI], 30h

                Mov     DI, 8+47*80
                Add     DI, ViewWidth
                Add     DI, DI
                Mov     SI, LeftChannel
                Mov     DX, NumChannelsEdit

PE_PrePatternEdit16:
                Cmp     [MultiChannelInfo+SI], 0        ; Put the 'M's in.
                JE      PE_PrePatternEdit17

                Mov     Byte Ptr [ES:DI], 172

PE_PrePatternEdit17:
                Inc     SI
                Add     DI, 28
                Dec     DX
                JNZ     PE_PrePatternEdit16

                Mov     DI, 5+47*80
                Add     DI, ViewWidth
                Mov     AL, 14
                Mov     BX, Channel
                Sub     BX, LeftChannel
                Mul     BL
                Add     DI, AX
                Add     DI, DI                  ; Points to bottom of channel.

                Mov     DX, 1
                Cmp     Template, 0
                JE      PE_PrePatternEditLoop
;                Test    CL, CL
;                JZ      PE_PrePatternEditLoop
                Cmp     BlockDataArea, 0
                JE      PE_PrePatternEditLoop

                Mov     FS, BlockDataArea
                Mov     AX, [FS:0]              ; Block width
                Mov     DX, NumChannelsEdit
                Add     DX, LeftChannel
                Sub     DX, Channel
                Cmp     DX, AX
                JB      PE_PrePatternEditLoop

                Mov     DX, AX

PE_PrePatternEditLoop:
                Push    DI

                Mov     AX, 23A9h
                Mov     CX, PatternCursor
                Mov     CH, EditMask

                Test    CL, CL
                JZ      PE_PrePatternEdit1

                Mov     AL, 0AAh

PE_PrePatternEdit1:
                StosW
                StosW
                StosW
;                Add     DI, 2
                ScasW

                Test    CH, 1
                JZ      PE_PrePatternEdit2

                StosW
                StosW
                Jmp     PE_PrePatternEdit3

PE_PrePatternEdit2:
                Add     DI, 4

PE_PrePatternEdit3:
;                Add     DI, 2
                ScasW

                Test    CH, 2
                JZ      PE_PrePatternEdit4

                StosW
                StosW
                Jmp     PE_PrePatternEdit5

PE_PrePatternEdit4:
                Add     DI, 4

PE_PrePatternEdit5:
;                Add     DI, 2
                ScasW

                Test    CH, 4
                JZ      PE_PrePatternEdit6

                StosW
                StosW
                StosW

PE_PrePatternEdit6:
                Pop     DI                      ; Mark in the actual channels
                Mov     AL, 0A9h
                Test    CL, CL
                JNZ     PE_PrePatternEdit7

                Mov     AL, 0ABh
                StosW
                StosW
                StosW

                Add     DI, 22
                Dec     DX
                JNZ     PE_PrePatternEditLoop

                Ret

PE_PrePatternEdit7:
                Cmp     CL, 1
                JA      PE_PrePatternEdit8

                Mov     AL, 0ABh
                Add     DI, 4
                StosW
                Ret

PE_PrePatternEdit8:
                Cmp     CL, 3
                JA      PE_PrePatternEdit10

                Test    CH, 1
                JZ      PE_PrePatternEdit9

                Mov     AL, 0ABh

PE_PrePatternEdit9:
                Add     DI, 8
                StosW
                StosW
                Ret

PE_PrePatternEdit10:
                Cmp     CL, 5
                JA      PE_PrePatternEdit12

                Test    CH, 2
                JZ      PE_PrePatternEdit11

                Mov     AL, 0ABh

PE_PrePatternEdit11:

                Add     DI, 14
                StosW
                StosW
                Ret

PE_PrePatternEdit12:
                Cmp     CL, 6
                JA      PE_PrePatternEdit14

                Test    CH, 4
                JZ      PE_PrePatternEdit13

                Mov     AL, 0ABh

PE_PrePatternEdit13:
                Add     DI, 20
                StosW
                Ret

PE_PrePatternEdit14:
                Test    CH, 4
                JZ      PE_PrePatternEdit15

                Mov     AL, 0ABh

PE_PrePatternEdit15:
                Add     DI, 22
                StosW
                StosW
                Ret

EndP            PE_PrePatternEdit
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetPatternOffset

                Assume DS:Pattern

                Push    AX
                Push    BX
                Push    DX

                Mov     AX, 64
                Mul     Row
                Add     AX, Channel
                Mov     BX, 5
                Mul     BX
                Mov     DI, AX
                Mov     ES, PatternDataArea

                Pop     DX
                Pop     BX
                Pop     AX
                Ret

EndP            GetPatternOffset
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            NetworkPatternBlock Near   ; CL = width, CH = Height, BL = Channel, BH = Row

IF NETWORKENABLED
                Call    Network_GetSendQueue
                JZ      PE_GotoNextInputNoNetwork

                Mov     AX, NETWORK_PARTIALPATTERNOBJECT*100h ; Destination ALL
                StosW
                Mov     AL, Byte Ptr PatternNumber
                StosB
                Mov     AX, BX
                StosW
                Mov     AX, CX
                StosW

PE_GotoNextInputNoNetwork:
                Call    Network_FinishedSendQueue

                Ret
ENDIF

EndP            NetworkPatternBlock

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            NetworkPartialPattern Near   ; CL = width, CH = Height

IF NETWORKENABLED
                Push    BX
                Mov     BL, Byte Ptr Channel
                Mov     BH, Byte Ptr Row
                Call    NetworkPatternBlock
                Pop     BX
ENDIF
                Ret

EndP            NetworkPartialPattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            NetworkBlock Near

IF NETWORKENABLED
                Mov     BL, Byte Ptr BlockLeft
                Mov     BH, Byte Ptr BlockTop
                Mov     CL, Byte Ptr BlockRight
                Mov     CH, Byte Ptr BlockBottom
                Sub     CX, BX
                Add     CX, 101h
                Call    NetworkPatternBlock
ENDIF
                Ret

EndP            NetworkBlock

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

PatternCursorJumpTable  DW      Offset PE_PatternCursorPos0
                        DW      Offset PE_PatternCursorPos1
                        DW      Offset PE_PatternCursorPos2
                        DW      Offset PE_PatternCursorPos3
                        DW      Offset PE_PatternCursorPos4
                        DW      Offset PE_PatternCursorPos5
                        DW      Offset PE_PatternCursorPos6
                        DW      Offset PE_PatternCursorPos7
                        DW      Offset PE_PatternCursorPos8

Proc            PE_PostPatternEdit Far

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Test    CH, 1
                JZ      PE_PostPatternEdit17

                Mov     EAX, [DWord Ptr LastKeyBoard1]
                Mov     EBX, [DWord Ptr LastKeyBoard2]

                Mov     [DWord Ptr LastKeyBoard2], EAX
                Mov     [DWord Ptr LastKeyBoard3], EBX

                Mov     [LastKeyBoard1], CX
                Mov     [LastKeyBoard1+2], DX

PE_PostPatternEdit17:
                Mov     AL, CH
                Mov     SI, Offset PEFunctions
                And     AL, 6
                Mov     ShiftPressed, AL

                Test    CH, 6
                PushF
                Call    M_FunctionDivider
                JC      PE_PostPatternEdit1

                PopF
                JNZ     PE_PostPatternEditShift

PE_PostPatternEditNotShift:
                Jmp     [SI]

PE_PostPatternEditShift:
                Cmp     Byte Ptr [SI-3], 6      ; MIDI message
                JE      PE_PostPatternEditNotshift

                Mov     AX, [SI-2]

                Cmp     AX, 10Fh   ; Shift Tab
                JE      PE_PostPatternEditNotShift

                Cmp     AX, '?'
                JE      PE_PostPatternEditNotShift

                Cmp     AX, '|'
                JE      PE_PostPatternEditNotShift

                Push    [Row]
                Push    [Channel]

                Push    CS

                Call    [SI]

                Push    CS
                Pop     DS

;                Mov     CX, BlockAnchorRow
;                Mov     DX, BlockAnchorChannel
                Pop     DX
                Pop     CX

                Cmp     CX, Row
                JNE     PE_PostPatternEditShift1

                Cmp     DX, Channel
                JE      PE_PostPatternEditShift2

PE_PostPatternEditShift1:
                Cmp     BlockReset, 0
                JE      PE_PostPatternEditShift3

                Mov     BlockReset, 0
                Mov     BlockMark, 0

PE_PostPatternEditShift3:
                                        ; Set block marks.
                Mov     AX, BlockAnchorChannel
                Mov     BX, BlockAnchorRow

                Push    CS
                Call    PEFunction_MarkBeginBlockChain
                Jmp     PEFunction_MarkEndBlock

PE_PostPatternEditShift2:
                Mov     AX, 1
                Ret

PE_PostPatternEdit1:
                PopF
                Test    CH, 60h
                JNZ     PE_PostPatternEdit6

                Call    GetPatternOffset
                Mov     BX, PatternCursor
                Add     BX, BX
                Jmp     [PatternCursorJumpTable+BX]

PE_PostPatternEdit6:
                Mov     AX, CX
                And     AX, 1FFh
                Cmp     AX, 10Ah
                JA      PE_PostPatternEdit7

                Cmp     AX, 102h
                JB      PE_PostPatternEdit7
                                        ; Alt-1 -> Alt-9
                Sub     AX, 101h
;                Dec     AL
;                Dec     AH
                Mov     SkipValue, AX

                Mov     SI, Offset CursorStepMsg
                Call    SetInfoLine

                Mov     AX, 1
                Ret

PE_PostPatternEdit7:
                Xor     AX, AX
                Ret

EndP            PE_PostPatternEdit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Ctrl_PgUp Far

                Mov     Row, 0

                Mov     AX, 1
                Ret

EndP            PEFunction_Ctrl_PgUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Ctrl_PgDn Far

                Mov     AX, MaxRow
                Mov     Row, AX

                Mov     AX, 1
                Ret

EndP            PEFunction_Ctrl_PgDn

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Up Far

                Mov     BX, SkipValue
                And     BX, BX
                JNZ     PEFunction_Up2

                Mov     BX, 1

PEFunction_Up2:
                Mov     AX, Row
                Sub     AX, BX
                JS      PEFunction_Up1

                Mov     Row, AX

PEFunction_Up1:
                Mov     AX, 1
                Ret

EndP            PEFunction_Up

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Down Far

                Push    CS
                Pop     DS

                Mov     BX, SkipValue
                And     BX, BX
                JNZ     PEFunction_Down2

                Mov     BX, 1

PEFunction_Down2:
                Mov     AX, Row
                Add     AX, BX
                Cmp     AX, MaxRow
                JA      PEFunction_Down1

                Mov     Row, AX

PEFunction_Down1:
                Mov     AX, 1
                Ret

EndP            PEFunction_Down

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Left Far

                Mov     CX, PatternCursor
                Mov     BX, Channel
                Dec     CX
                JNS     PEFunction_Left1

                Mov     CX, 8
                Dec     BX
                JS      PEFunction_Left2

                Mov     Channel, BX

                Cmp     CommandToValue, 0
                JE      PEFunction_Left1

                Call    GetPatternOffset
;                Mov     ES, PatternDataArea
;                Mov     AX, 64
;                Mul     Row
;                Add     AX, BX
;                Mov     DX, 5
;                Mul     DX
;                Mov     DI, AX
                Cmp     Word Ptr [ES:DI+3], 0
                JNE     PEFunction_Left1

                Mov     CX, 6

PEFunction_Left1:
                Mov     PatternCursor, CX

PEFunction_Left2:
                Mov     AX, 1
                Ret

EndP            PEFunction_Left

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Right Far                    ; If there is no
                                                        ; command value... skip!

                Mov     CX, PatternCursor
                Mov     BX, Channel
                Inc     CX
                Cmp     CX, 6
                JBE     PEFunction_Right1

                Cmp     CommandToValue, 0
                JE      PEFunction_Right4

                Call    GetPatternOffset
;                Mov     ES, PatternDataArea
;                Mov     AX, 64
;                Mul     Row
;                Add     AX, Channel
;                Mov     DX, 5
;                Mul     DX
;                Mov     DI, AX
                Cmp     Word Ptr [ES:DI+3], 0
                JE      PEFunction_Right3

PEFunction_Right4:
                Cmp     CX, 9
                JB      PEFunction_Right1

PEFunction_Right3:
                Xor     CX, CX
                Inc     BX
                Cmp     BX, 64
                JAE     PEFunction_Right2

PEFunction_Right1:
                Mov     PatternCursor, CX
                Mov     Channel, BX

PEFunction_Right2:
                Mov     AX, 1
                Ret

EndP            PEFunction_Right

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Press_Shift Far

                Mov     AX, Channel
                Mov     BX, Row

                Mov     BlockAnchorChannel, AX
                Mov     BlockAnchorRow, BX
                Mov     BlockReset, 1
                Mov     NoteEntered, 0

                Xor     AX, AX
                Ret

EndP            PEFunction_Press_Shift

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Release_Shift Far

                Cmp     NoteEntered, 0
                JE      PEFunction_Release_Shift1

                Mov     AX, BlockAnchorChannel
                Mov     BX, BlockAnchorRow

                Mov     Channel, AX
                Mov     Row, BX

                Call    PE_GotoNextInput

PEFunction_Release_Shift1:
                Xor     AX, AX
                Ret

EndP            PEFunction_Release_Shift

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Alt_Home Far
                Mov     BL, RowHilight1
                Jmp     PEFunction_PgUpChain

Proc            PEFunction_PgUp Far

                Mov     BL, RowHiLight2

PEFunction_PgUpChain:
                Mov     AX, Row
                Mov     CX, MaxRow
                Mov     DX, SkipValue
                And     DX, 0FFh
                JNZ     PEFunction_PgUp3

                Mov     DL, 1

PEFunction_PgUp3:
                And     BX, 0FFh

                JNZ     PEFunction_PgUp2

                Mov     BX, 16

PEFunction_PgUp2:
                Sub     CX, DX          ; Sub maxrow, skipvalue
                Cmp     CX, AX
                JAE     PEFunction_PgUp4

                Dec     AX
                Div     BL
                Mul     BL
                Jmp     PEFunction_PgUp1

PEFunction_PgUp4:
                Sub     AX, BX
                JNS     PEFunction_PgUp1

                Xor     AX, AX

PEFunction_PgUp1:
                Mov     Row, AX

                Mov     AX, 1
                Ret

EndP            PEFunction_PgUp

EndP            PEFunction_Alt_Home

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_CentraliseCursor

                Mov     AX, Row
                Sub     AX, 16
                JNC     PE_CentraliseCursor1

                Xor     AX, AX

PE_CentraliseCursor1:
                Mov     TopRow, AX
                Ret

EndP            PE_CentraliseCursor

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


Proc            PEFunction_Alt_End Far
                Mov     BL, RowHilight1
                Jmp     PEFunction_PgDnChain

Proc            PEFunction_PgDn Far

                Mov     BL, RowHiLight2

PEFunction_PgDnChain:
                Mov     AX, Row
                And     BX, 0FFh
                JNZ     PEFunction_PgDn2

                Mov     BX, 16

PEFunction_PgDn2:
                Add     AX, BX
                Cmp     AX, MaxRow
                JBE     PEFunction_PgDn1

                Mov     AX, MaxRow

PEFunction_PgDn1:
                Mov     Row, AX

                Mov     AX, 1
                Ret

EndP            PEFunction_PgDn

EndP            PEFunction_Alt_End

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_ShiftPgUp Far

                Call    PEFunction_PgUp
                Call    PE_CentraliseCursor

                Mov     AX, 1
                Ret

EndP            PEFunction_ShiftPgUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_ShiftPgDn Far

                Call    PEFunction_PgDn
                Call    PE_CentraliseCursor

                Mov     AX, 1
                Ret

EndP            PEFunction_ShiftPgDn

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Home Far

                Cmp     PatternCursor, 0
                JE      PEFunction_Home1

                Mov     PatternCursor, 0
                Jmp     PEFunction_Home3

PEFunction_Home1:
                Cmp     Channel, 0
                JE      PEFunction_Home2

                Mov     Channel, 0
                Jmp     PEFunction_Home3

PEFunction_Home2:
                Mov     Row, 0

PEFunction_Home3:
                Mov     AX, 1
                Ret

EndP            PEFunction_Home

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_End Far

                Cmp     PatternCursor, 8
                JE      PEFunction_End1

                Mov     PatternCursor, 8
                Jmp     PEFunction_End3

PEFunction_End1:
                Call    Music_GetLastChannel

                Cmp     Channel, AX
                JE      PEFunction_End2

                Mov     Channel, AX
                Jmp     PEFunction_End3

PEFunction_End2:
                Mov     AX, MaxRow
                Mov     Row, AX

PEFunction_End3:
                Mov     AX, 1
                Ret

EndP            PEFunction_End

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Tab Far

                Mov     AX, Channel
                Cmp     AX, 63
                JAE     PEFunction_Tab1

                Mov     PatternCursor, 0
                Inc     Channel

PEFunction_Tab1:
                Mov     AX, 1
                Ret

EndP            PEFunction_Tab

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_ShiftTab Far

                Cmp     PatternCursor, 0
                JNE     PEFunction_ShiftTab2

                Mov     AX, Channel
                And     AX, AX
                JZ      PEFunction_ShiftTab1

                Dec     Channel

PEFunction_ShiftTab2:
                Mov     PatternCursor, 0

PEFunction_ShiftTab1:
                Mov     AX, 1
                Ret

EndP            PEFunction_ShiftTab

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_SetMask Far

                Mov     BX, PatternCursor
                Mov     AL, [MaskChange+BX]
                Xor     EditMask, AL

                Mov     AX, 1
                Ret

EndP            PEFunction_SetMask

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_ToggleMultiChannel Far

                Mov     BX, Channel
                Xor     [MultiChannelInfo+BX], 1

                Cmp     [Word Ptr LastKeyBoard2+2], 3100h
                JNE     PEFunction_ToggleMultiChannel1

                Mov     CX, 7
                Add     CX, Channel
                Mov     DI, Offset O1_SelectMultiChannel
                Call    M_Object1List

PEFunction_ToggleMultiChannel1:
                Mov     AX, 1
                Ret

EndP            PEFunction_ToggleMultiChannel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_BackSpace Far

                Xor     CX, CX

                Mov     AX, Row
                Mov     BX, Channel
                Sub     AX, SkipValue
                JS      PEFunction_BackSpace3

                Mov     Row, AX
                Cmp     [MultiChannelInfo+BX], 0
                JE      PEFunction_BackSpace5

                Mov     DX, BX

PEFunction_BackSpace1:
                Dec     BX
                JNS     PEFunction_BackSpace4

                And     AX, AX
                JZ      PEFunction_BackSpace3

                Inc     CX

PEFunction_BackSpace4:
                And     BX, 63
                Cmp     BX, DX
                JE      PEFunction_BackSpace2

                Cmp     [MultiChannelInfo+BX], 0
                JE      PEFunction_BackSpace1

PEFunction_BackSpace2:
                Mov     Channel, BX
                Cmp     SkipValue, 0
                JNE     PEFunction_BackSpace3

                And     CX, CX
                JZ      PEFunction_BackSpace3

                And     AX, AX
                JZ      PEFunction_BackSpace3

                Dec     Row
                Jmp     PEFunction_BackSpace3

PEFunction_BackSpace5:                  ; AX = row
                Cmp     SkipValue, 0
                JNE     PEFunction_BackSpace3

                Mov     BX, Channel
                Dec     BX
                JNS     PEFunction_BackSpace6

                And     AX, AX
                JZ      PEFunction_BackSpace3
                Dec     AX

PEFunction_BackSpace6:
                And     BX, 63
                Mov     Row, AX
                Mov     Channel, BX

PEFunction_BackSpace3:
                Mov     AX, 1
                Ret

EndP            PEFunction_BackSpace

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_PickUp Far

                Cmp     Template, 4
                JE      PEFunction_PickUp2

                Mov     Template, 0             ; Turn off templates

PEFunction_PickUp2:
                Call    GetPatternOffset
                Mov     EAX, [ES:DI]

                Test    AH, AH
                JNZ     PEFunction_PickUp1

                Mov     AH, LastInstrument

PEFunction_PickUp1:
                Mov     DWord Ptr [LastNote], EAX
                Mov     AL, [ES:DI+4]
                Mov     LastCommandValue, AL

                Mov     AX, 1
                Ret

EndP            PEFunction_PickUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_PatternCursorPos1 Far

                Test    CL, CL
                JZ      PE_PatternCursorPos1_1

                Cmp     DX, '0'
                JB      PE_PatternCursorPos1_1

                Cmp     DX, '9'
                JA      PE_PatternCursorPos1_1

                Mov     AL, [ES:DI]
                Cmp     AL, 120
                JA      PE_PatternCursorPos1_2

                AAM     12              ; AH = octave, AL = note
                Mov     AH, DL
                Sub     AH, '0'
                AAD     12
                StosB

PE_PatternCursorPos1_2:
                Mov     CX, 101h
                Call    NetworkPartialPattern

                Jmp     PE_GotoNextInput

PE_PatternCursorPos1_1:
                Xor     AX, AX
                Ret

EndP            PE_PatternCursorPos1

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_PatternCursorPos0 Far

                Test    CL, CL
                JZ      PE_PatternCursorPos0_4

                Push    CX
                Mov     SI, Offset KeyBoardTable

                And     CH, Not 6               ; Remove shift mask.

PE_PatternCursorPos0_1:
                LodsW
                Cmp     AX, 0FFFFh
                JE      PE_PatternCursorPos0_3

                Cmp     AX, CX
                JNE     PE_PatternCursorPos0_2

                Pop     CX

                Mov     BX, 3Ah
                Call    K_IsKeyDown
                JNZ     PE_PatternCursorPreview

                Jmp     PE_NewNote

PE_PatternCursorPreview:
                Mov     AX, 12
                Mul     BaseOctave
                Mov     BX, AX
                LodsW
                Add     AX, BX

                Mov     SI, Offset PreviewNote

                Cmp     AX, MAXNOTE
                JA      PE_PatternCursorPos0_4

                Mov     AH, LastInstrument
                Mov     [SI], AX

                Mov     AX, CS:Channel
                Mov     DH, 32
                Call    Music_PlayNote

                Xor     AX, AX
                Ret

PE_PatternCursorPos0_2:
                LodsW                   ; Add SI, 2
                Jmp     PE_PatternCursorPos0_1

PE_PatternCursorPos0_3:
                Pop     CX

                Mov     AL, NONOTE
                Cmp     DX, '.'
                JE      WipeNote

                Inc     AX
                Cmp     DX, '1'
                JE      WipeNote
                Cmp     DX, '!'
                JE      WipeNote

                Inc     AX
                Cmp     DX, '`'
                JE      WipeNote
                Cmp     DX, '~'
                JE      WipeNote

                Cmp     DX, ' '
                JE      NoteSpace

                Cmp     DX, '4'
                JE      PEFunction_PlayCurrentNote
                Cmp     DX, '$'
                JE      PEFunction_PlayCurrentNote

                Cmp     DX, '8'
                JE      PEFunction_PlayCurrentRow

PE_PatternCursorPos0_4:
                Xor     AX, AX
                Ret

EndP            PE_PatternCursorPos0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            NoteSpace Far

                Mov     AL, LastNote
                Jmp     PE_NewNote4

EndP            NoteSpace

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            WipeNote Far

                Mov     AH, EditMask

                Mov     BP, 1
                Cmp     Template, 0
                JE      WipeNote4

                Cmp     BlockDataArea, 0
                JE      WipeNote4

                Mov     FS, BlockDataArea
                Cmp     Word Ptr [FS:2], 1
                JNE     WipeNote4

                Mov     BP, [FS:0]

WipeNote4:
                Mov     CX, BP
                Mov     CH, 1
                Call    NetworkPartialPattern

WipeNote5:
                Mov     [ES:DI], AL
                Mov     LastNote, AL
                Test    AH, 1
                JZ      WipeNote1

                Mov     Byte Ptr [ES:DI+1], 0

WipeNote1:
                Test    AH, 2
                JZ      WipeNote2

                Mov     Byte Ptr [ES:DI+2], 0FFh

WipeNote2:
                Test    AH, 4
                JZ      WipeNote3

                Mov     Word Ptr [ES:DI+3], 0

WipeNote3:
                Add     DI, 5
                Dec     BP
                JNZ     WipeNote5

IF CHORDENTRY
                Cmp     ShiftPressed, 0
                JE      PE_GotoNextInput

                Push    SkipValue
                Mov     SkipValue, 0
                Mov     NoteEntered, 1

                Call    PE_GotoNextInput
                Pop     SkipValue

                Mov     AX, 1
                Ret
ELSE
                Jmp     PE_GotoNextInput
ENDIF

EndP            WipeNote

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_GotoNextInput Far


                Mov     CX, PatternCursor
                And     CX, CX
                JZ      PE_GotoNextInput4

                Cmp     CX, 1
                JE      PE_GotoNextInput4

                Cmp     CX, 2
                JNE     PE_GotoNextInput5

PE_GotoNextInput7:
                Inc     PatternCursor
                Jmp     PE_GotoNextInput3

PE_GotoNextInput5:
                Cmp     CX, 3
                JNE     PE_GotoNextInput6

PE_GotoNextInput8:
                Dec     PatternCursor
                Jmp     PE_GotoNextInput4

PE_GotoNextInput6:
                Cmp     CX, 4
                JE      PE_GotoNextInput7

                Cmp     CX, 5
                JE      PE_GotoNextInput8

                Cmp     CX, 6
                JNE     PE_GotoNextInput9

                Cmp     CommandToValue, 0
                JZ      PE_GotoNextInput4

                Jmp     PE_GotoNextInput7

PE_GotoNextInput9:
                Cmp     CX, 7
                JE      PE_GotoNextInput7

                Cmp     CommandToValue, 0
                JE      PE_GotoNextInput8

                Sub     PatternCursor, 2

PE_GotoNextInput4:
                Mov     AX, Row
                Mov     BX, Channel
                Add     AX, SkipValue
                Cmp     AX, MaxRow
                JA      PE_GotoNextInput3

                Mov     Row, AX
                Cmp     PatternCursor, 0
                JNE     PE_GotoNextInput10

                Cmp     [MultiChannelInfo+BX], 0
                JE      PE_GotoNextInput10

                Mov     DX, BX
                Xor     CX, CX

PE_GotoNextInput1:
                Inc     BX
                Cmp     BX, 63
                JBE     PE_GotoNextInput11

                Inc     CX

PE_GotoNextInput11:
                And     BX, 63
                Cmp     DX, BX
                JE      PE_GotoNextInput2

                Cmp     [MultiChannelInfo+BX], 0
                JE      PE_GotoNextInput1

PE_GotoNextInput2:
                Mov     Channel, BX
                Cmp     SkipValue, 0
                JNE     PE_GotoNextInput3

                And     CX, CX
                JZ      PE_GotoNextInput3

                Mov     Word Ptr [Modified], 101h

                Jmp     PEFunction_Down

PE_GotoNextInput10:
                Cmp     SkipValue, 0
                JNE     PE_GotoNextInput3

                Mov     AX, Channel
                Mov     CX, Row
                Inc     AX
                Cmp     AX, 63
                JBE     PE_GotoNextInput12
                Cmp     CX, MaxRow
                JAE     PE_GotoNextInput3

                Inc     CX

PE_GotoNextInput12:
                And     AX, 63
                Mov     Row, CX
                Mov     Channel, AX

PE_GotoNextInput3:
                Mov     Word Ptr [Modified], 101h

                Mov     AX, 1
                Ret

EndP            PE_GotoNextInput

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            TemplateSetup

                Mov     AH, AL
                Push    AX

                Mov     BX, Channel
                Mov     AX, 320
                Mov     BP, MaxRow
                Inc     BP
                Mul     BP
                Mov     BP, AX                  ; BP = max offset.

                Mov     AX, 64
                Mul     Row
                Add     AX, BX
                Mov     CX, 5
                Mul     CX

                Mov     DI, AX                  ; DI = pattern offset.
                Mov     ES, PatternDataArea
                Mov     DS, BlockDataArea
                Xor     SI, SI

                LodsW
                Mov     DX, AX                          ; DX = width
                LodsW
                Mov     CX, AX                          ; CX = height

                Pop     AX                              ; AH = note.
                Sub     AH, [DS:4]

                Ret

EndP            TemplateSetup

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_TemplateOverwrite            ; AX = note

                Push    DS
                Push    ES

                Call    TemplateSetup

PE_TemplateOverWrite1:
                Push    BX
                Push    CX
                Push    DI

                Mov     CX, DX

PE_TemplateOverWrite2:
                Cmp     BX, 64
                JAE     PE_TemplateOverWrite3

                LodsB
                Cmp     AL, MAXNOTE
                JA      PE_TemplateOverWrite6

                Add     AL, AH
                Cmp     AL, MAXNOTE
                JBE     PE_TemplateOverWrite6

                Mov     AL, NONOTE

PE_TemplateOverWrite6:
                StosB
                MovsW
                MovsW
                Jmp     PE_TemplateOverWrite4

PE_TemplateOverWrite3:
                Add     SI, 5
                Add     DI, 5

PE_TemplateOverWrite4:
                Inc     BX
                Loop    PE_TemplateOverWrite2

                Pop     DI
                Pop     CX
                Pop     BX
                Add     DI, 320
                Cmp     DI, BP
                JAE     PE_TemplateOverWrite5

                Loop    PE_TemplateOverWrite1

PE_TemplateOverWrite5:
                Pop     ES
                Pop     DS
                Ret

EndP            PE_TemplateOverWrite

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_TemplateMixPattern            ; AX = note

                Push    DS
                Push    ES

                Call    TemplateSetup

PE_TemplateMixPattern1:
                Push    BX
                Push    CX
                Push    DI

                Mov     CX, DX

PE_TemplateMixPattern2:
                Cmp     BX, 64
                JAE     PE_TemplateMixPattern3

                Mov     AL, [DS:SI]
                Cmp     AL, MAXNOTE
                JA      PE_TemplateMixPattern6

                Add     AL, AH
                Cmp     AL, MAXNOTE
                JBE     PE_TemplateMixPattern6

                Mov     AL, NONOTE

PE_TemplateMixPattern6:
                Cmp     Byte Ptr [ES:DI], NONOTE
                JNE     PE_TemplateMixPattern7

                Mov     [ES:DI], AL

PE_TemplateMixPattern7:
                Cmp     Byte Ptr [ES:DI+1], 0
                JNE     PE_TemplateMixPattern8

                Mov     AL, [DS:SI+1]
                Mov     [ES:DI+1], AL

PE_TemplateMixPattern8:
                Cmp     Byte Ptr [ES:DI+2], 0FFh
                JNE     PE_TemplateMixPattern9

                Mov     AL, [DS:SI+2]
                Mov     [ES:DI+2], AL

PE_TemplateMixPattern9:
                Cmp     Word Ptr [ES:DI+3], 0
                JNE     PE_TemplateMixPattern3

                Push    AX
                Mov     AX, [DS:SI+3]
                Mov     [ES:DI+3], AX
                Pop     AX

PE_TemplateMixPattern3:
                Add     SI, 5
                Add     DI, 5

PE_TemplateMixPattern4:
                Inc     BX
                Loop    PE_TemplateMixPattern2

                Pop     DI
                Pop     CX
                Pop     BX
                Add     DI, 320
                Cmp     DI, BP
                JAE     PE_TemplateMixPattern5

                Loop    PE_TemplateMixPattern1

PE_TemplateMixPattern5:
                Pop     ES
                Pop     DS
                Ret

EndP            PE_TemplateMixPattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_TemplateMixClipBoard            ; AX = note

                Push    DS
                Push    ES

                Call    TemplateSetup

PE_TemplateMixClipBoard1:
                Push    BX
                Push    CX
                Push    DI

                Mov     CX, DX

PE_TemplateMixClipBoard2:
                Cmp     BX, 64
                JAE     PE_TemplateMixClipBoard3

                Mov     AL, [DS:SI]
                Cmp     AL, MAXNOTE
                JA      PE_TemplateMixClipBoard6

                Add     AL, AH
                Cmp     AL, MAXNOTE
                JBE     PE_TemplateMixClipBoard6

                Mov     AL, NONOTE

PE_TemplateMixClipBoard6:
                Cmp     Byte Ptr [DS:SI], NONOTE
                JE      PE_TemplateMixClipBoard7

                Mov     [ES:DI], AL

PE_TemplateMixClipBoard7:
                Cmp     Byte Ptr [DS:SI+1], 0
                JE      PE_TemplateMixClipBoard8

                Mov     AL, [DS:SI+1]
                Mov     [ES:DI+1], AL

PE_TemplateMixClipBoard8:
                Cmp     Byte Ptr [DS:SI+2], 0FFh
                JE      PE_TemplateMixClipBoard9

                Mov     AL, [DS:SI+2]
                Mov     [ES:DI+2], AL

PE_TemplateMixClipBoard9:
                Cmp     Word Ptr [DS:SI+3], 0
                JE      PE_TemplateMixClipBoard3

                Push    AX
                Mov     AX, [DS:SI+3]
                Mov     [ES:DI+3], AX
                Pop     AX

PE_TemplateMixClipBoard3:
                Add     SI, 5
                Add     DI, 5

PE_TemplateMixClipBoard4:
                Inc     BX
                Loop    PE_TemplateMixClipBoard2

                Pop     DI
                Pop     CX
                Pop     BX
                Add     DI, 320
                Cmp     DI, BP
                JAE     PE_TemplateMixClipBoard5

                Loop    PE_TemplateMixClipBoard1

PE_TemplateMixClipBoard5:
                Pop     ES
                Pop     DS
                Ret

EndP            PE_TemplateMixClipBoard

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_TemplateNotesOnly

                Push    DS
                Push    ES

                Call    TemplateSetup

PE_TemplateNotesOnly1:
                Push    BP
                Push    BX
                Push    CX
                Push    DI

                Mov     CX, DX
                Mov     BP, Word Ptr [CS:EditMask]

PE_TemplateNotesOnly2:
                Cmp     BX, 64
                JAE     PE_TemplateNotesOnly3

                Or      BP, 8
                Mov     AL, [SI]
                Cmp     AL, MAXNOTE
                JA      PE_TemplateNotesOnly7

                Add     AL, AH
                And     BP, Not 8
                Cmp     AL, MAXNOTE
                JA      PE_TemplateNotesOnly3

PE_TemplateNotesOnly7:
                Mov     [ES:DI], AL

                Test    BP, 8
                JNZ     PE_TemplateNotesOnly3
                Test    BP, 1
                JZ      PE_TemplateNotesOnly5

                Mov     AL, CS:LastInstrument
                Mov     [ES:DI+1], AL

PE_TemplateNotesOnly5:
                Test    BP, 2
                JZ      PE_TemplateNotesOnly6

                Mov     AL, CS:LastVolume
                Mov     [ES:DI+2], AL

PE_TemplateNotesOnly6:
                Test    BP, 4
                JZ      PE_TemplateNotesOnly3

                Mov     AX, [Word Ptr CS:LastCommand]
                Mov     [ES:DI+3], AX

PE_TemplateNotesOnly3:
                Add     SI, 5
                Add     DI, 5

                Inc     BX
                Loop    PE_TemplateNotesOnly2

                Pop     DI
                Pop     CX
                Pop     BX
                Pop     BP

                Add     DI, 320
                Cmp     DI, BP
                JAE     PE_TemplateNotesOnly4

                Loop    PE_TemplateNotesOnly1

PE_TemplateNotesOnly4:
                Pop     ES
                Pop     DS

                Ret

EndP            PE_TemplateNotesOnly

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_Template Far                 ; AX = note.

                Mov     BX, BlockDataArea
                Test    BX, BX
                JZ      PEFunction_NoBlockData

                Mov     ES, BX
                Cmp     Byte Ptr [ES:4], 119
                JBE     PE_Template3

                Mov     DI, Offset O1_TemplateErrorList
                Mov     CX, 2
                Call    M_Object1List

                Mov     AX, 1
                Ret

PE_Template3:
                Mov     Word Ptr [Modified], 101h

                Mov     BL, Template
                Cmp     BL, 2
                JE      PE_Template1
                JA      PE_Template2

                Call    PE_TemplateOverWrite
                Jmp     PE_Template4

PE_Template1:
                Call    PE_TemplateMixPattern
                Jmp     PE_Template4

PE_Template2:
                Cmp     BL, 4
                JE      PE_Template6

                Call    PE_TemplateMixClipBoard
                Jmp     PE_Template4

PE_Template6:
                Call    PE_TemplateNotesOnly

PE_Template4:                           ; Play notes, if clipboard height = 1
                Mov     CL, [ES:0]
                Mov     CH, [ES:2]
                Call    NetworkPartialPattern

                Cmp     Word Ptr [ES:2], 1              ; height
                JNE     PE_TemplateNoPlay

                Mov     AX, 64
                Mul     Row
                Add     AX, Channel
                Mov     DX, 5
                Mul     DX
                Mov     SI, AX

                Mov     CX, [ES:0]              ; CX = Width
                Mov     AX, Channel
                Push    DS
                Mov     DS, PatternDataArea
                Mov     DH, 32

PE_TemplatePlay:
                Call    Music_PlayNote

                Add     SI, 5
                Inc     AX
                Dec     CX
                JNZ     PE_TemplatePlay

                Pop     DS

PE_TemplateNoPlay:
                Cmp     SkipValue, 0
                JNE     PE_GotoNextInput

                Mov     AX, Row
                Mov     BX, MaxRow
                Add     AX, [ES:2]
                Cmp     AX, BX
                JBE     PE_Template5

                Mov     AX, BX

PE_Template5:
                Mov     Row, AX

                Mov     AX, 1
                Ret

EndP            PE_Template

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_NewNote Far

                Mov     AX, 12
                Mul     BaseOctave
                Mov     BX, AX
                LodsW
                Add     AX, BX

                Cmp     AX, MAXNOTE
                JBE     PE_NewNote5

                Mov     AX, 1
                Ret

PE_NewNote5:
                Cmp     Template, 0
                JNE     PE_Template

PE_NewNote4:
                Mov     AH, EditMask

                Mov     SI, DI

                Mov     LastNote, AL
                StosB

                Test    AH, 1
                JZ      PE_NewNote1

                Mov     AL, LastInstrument
                Mov     [ES:DI], AL

PE_NewNote1:
                Test    AH, 2
                JZ      PE_NewNote2

                Mov     AL, LastVolume
                Mov     [ES:DI+1], AL

PE_NewNote2:
                Test    AH, 4
                JZ      PE_NewNote3

                Mov     AL, LastCommand
                Mov     AH, LastCommandValue
                Mov     [ES:DI+2], AX

PE_NewNote3:                                    ; Play routine reqd here...
                Push    DS

                Push    ES
                Pop     DS              ; DS = patterndatasegment

                Mov     AX, CS:Channel
                Mov     DH, 32
                Call    Music_PlayNote

                Pop     DS

                Mov     CX, 101h
                Call    NetworkPartialPattern

IF CHORDENTRY
                Cmp     ShiftPressed, 0
                JE      PE_GotoNextInput

                Push    SkipValue
                Mov     SkipValue, 0
                Mov     NoteEntered, 1

                Call    PE_GotoNextInput
                Pop     SkipValue

                Mov     AX, 1
                Ret
ELSE
                Jmp     PE_GotoNextInput
ENDIF

EndP            PE_NewNote

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Delete Far

                Mov     Word Ptr [Modified], 101h

                Mov     AX, 320
                Mul     MaxRow

                Call    GetPatternOffset

                Mov     BP, 1
                Cmp     Template, 0
                JE      PEFunction_Delete3

                Cmp     PatternCursor, 0
                JNE     PEFunction_Delete3

                Cmp     BlockDataArea, 0
                JE      PEFunction_Delete3

                Mov     FS, BlockDataArea
                Cmp     Word Ptr [FS:2], 1
                JNE     PEFunction_Delete3

                Mov     BP, [FS:0]

PEFunction_Delete3:
                Mov     CX, BP
                Mov     CH, Byte Ptr MaxRow
                Sub     CH, Byte Ptr Row
                Inc     CH
                Call    NetworkPartialPattern

                Push    AX DI

                Mov     SI, DI
                Push    ES
                Pop     DS                      ; DS:SI and ES:DI point to pat

                Add     SI, 320
                Mov     DX, 315

PEFunction_Delete1:
                Cmp     DI, AX
                JAE     PEFunction_Delete2

                Mov     CX, 5
                Rep     MovsB
                Add     SI, DX
                Add     DI, DX
                Jmp     PEFunction_Delete1

PEFunction_Delete2:
                Mov     AX, NONOTE
                StosW
                Mov     AL, 0FFh
                StosB
                Xor     AX, AX
                StosW

                Pop     DI AX
                Add     DI, 5

                Dec     BP
                JNZ     PEFunction_Delete3

                Mov     AX, 1
                Ret

EndP            PEFunction_Delete

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Insert Far

                Mov     BP, 1
                Cmp     Template, 0
                JE      PEFunction_Insert3

                Cmp     PatternCursor, 0
                JNE     PEFunction_Insert3

                Cmp     BlockDataArea, 0
                JE      PEFunction_Insert3

                Mov     FS, BlockDataArea
                Cmp     Word Ptr [FS:2], 1
                JNE     PEFunction_Insert3

                Mov     BP, [FS:0]

PEFunction_Insert3:
                Mov     Word Ptr [Modified], 101h

                Mov     CX, BP
                Mov     CH, Byte Ptr MaxRow
                Sub     CH, Byte Ptr Row
                Inc     CH
                Call    NetworkPartialPattern

                Mov     AX, 64
                Mul     MaxRow
                Add     AX, Channel
                Mov     BX, 5
                Mul     BX
                Mov     SI, AX
                Call    GetPatternOffset
                Push    ES
                Pop     DS
                Mov     BX, DI
                Mov     DX, -325

PEFunction_Insert4:
                Push    SI

                Mov     DI, SI
                Sub     SI, 320

PEFunction_Insert1:
                Cmp     DI, BX
                JBE     PEFunction_Insert2

                Mov     CX, 5
                Rep     MovsB
                Add     SI, DX
                Add     DI, DX
                Jmp     PEFunction_Insert1

PEFunction_Insert2:
                Mov     AX, NONOTE
                StosW
                Mov     AL, 0FFh
                StosB
                Xor     AX, AX
                StosW

                Pop     SI
                Add     SI, 5
                Add     BX, 5

                Dec     BP
                JNZ     PEFunction_Insert4

                Mov     AX, 1
                Ret

EndP            PEFunction_Insert

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_RowDelete Far

                Cmp     Byte Ptr LastKeyBoard2, 0D3h
                JE      PEFunction_RowDelete2

                Mov     DI, 20
                Call    PE_AddToUndoBuffer

PEFunction_RowDelete2:
                Mov     AX, 320
                Mul     Row
                Mov     DI, AX

                Mov     CX, MaxRow
                Sub     CX, Row
                Mov     AX, 320
                Mul     CX
                Mov     CX, AX

                Mov     DS, PatternDataArea
                Push    DS
                Pop     ES
                Mov     SI, DI
                Add     SI, 320
                Rep     MovsB

                Mov     DX, 64

                Push    CS
                Pop     DS

PEFunction_RowDelete1:
                Mov     CX, 5
                Mov     SI, Offset EmptyData
                Rep     MovsB

                Dec     DX
                JNZ     PEFunction_RowDelete1

                Mov     BL, 0
                Mov     BH, Byte Ptr Row
                Mov     CL, 64
                Mov     CH, Byte Ptr MaxRow
                Sub     CH, Byte Ptr Row
                Inc     CH
                Call    NetworkPatternBlock

                Mov     AX, 1
                Ret

EndP            PEFunction_RowDelete


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_RowInsert Far

                Cmp     Byte Ptr LastKeyBoard2, 0D2h
                JE      PEFunction_RowInsert2

                Mov     DI, 19
                Call    PE_AddToUndoBuffer

PEFunction_RowInsert2:
                Mov     AX, 320
                Mul     MaxRow
                Add     AX, 63*5
                Mov     DI, AX

                Mov     CX, MaxRow
                Sub     CX, Row
                Mov     AX, 320
                Mul     CX
                Mov     CX, AX

                Mov     DS, PatternDataArea
                Push    DS
                Pop     ES
                Mov     SI, DI
                Sub     SI, 320
                StD
                Rep     MovsB
                ClD

                Push    CS
                Pop     DS

                Mov     AX, 320
                Mul     Row
                Mov     DI, AX

                Mov     DX, 64


PEFunction_RowInsert1:
                Mov     CX, 5
                Mov     SI, Offset EmptyData
                Rep     MovsB

                Dec     DX
                JNZ     PEFunction_RowInsert1

                Mov     BL, 0
                Mov     BH, Byte Ptr Row
                Mov     CL, 64
                Mov     CH, Byte Ptr MaxRow
                Sub     CH, BH
                Inc     CH
                Call    NetworkPatternBlock

                Mov     AX, 1
                Ret

EndP            PEFunction_RowInsert

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_DecreaseInstrument Far

                Sub     LastInstrument, 1
                AdC     LastInstrument, 0

                Mov     AX, 1
                Ret

EndP            PEFunction_DecreaseInstrument

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_IncreaseInstrument Far

                Cmp     LastInstrument, 99
                AdC     LastInstrument, 0

                Mov     AX, 1
                Ret

EndP            PEFunction_IncreaseInstrument

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_DecreaseOctave Far

                Push    CS
                Pop     DS

                Sub     BaseOctave, 1
                AdC     BaseOctave, 0

                Mov     AX, 1
                Ret

EndP            PEFunction_DecreaseOctave

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_IncreaseOctave Far

                Push    CS
                Pop     DS

                Cmp     BaseOctave, 9
                AdC     BaseOctave, 0

                Mov     AX, 1
                Ret

EndP            PEFunction_IncreaseOctave

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_PatternCursorPos2 Far                ; Tens column of ins.

                Test    CL, CL
                JZ      PE_PatternCursorPos2_1

                Mov     BX, Offset PE_GotoNextInput4
                Mov     AL, LastInstrument
                Cmp     DX, ' '
                JE      PE_PatternCursorPos2_2

                Xor     AL, AL
                Cmp     DX, '.'
                JE      PE_PatternCursorPos2_2

                Cmp     DX, '0'
                JB      PE_PatternCursorPos2_1

                Cmp     DX, '9'
                JA      PE_PatternCursorPos2_1

                MovZX   AX, Byte Ptr [ES:DI+1]
                Mov     CL, 10
                Div     CL
                                                        ; AH = units/AL = tens
                Mov     BL, AH
                Mov     AL, DL
                Sub     AL, '0'

                Mul     CL
                Add     AL, BL

                Mov     BX, Offset PE_GotoNextInput

                Mov     LastInstrument, AL

PE_PatternCursorPos2_2:
                Mov     [ES:DI+1], AL

                Mov     CX, 101h
                Call    NetworkPartialPattern

                Jmp     BX

PE_PatternCursorPos2_1:
                Xor     AX, AX
                Ret

EndP            PE_PatternCursorPos2

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_PatternCursorPos3 Far                ; Unit column of ins.

                Test    CL, CL
                JZ      PE_PatternCursorPos3_1

                Mov     BX, Offset PE_GotoNextInput4
                Mov     AL, LastInstrument
                Cmp     DX, ' '
                JE      PE_PatternCursorPos3_2

                Xor     AL, AL
                Cmp     DX, '.'
                JE      PE_PatternCursorPos3_2

                Cmp     DX, '0'
                JB      PE_PatternCursorPos3_1

                Cmp     DX, '9'
                JA      PE_PatternCursorPos3_1

                MovZX   AX, Byte Ptr [ES:DI+1]
                Mov     CL, 10
                Div     CL
                                                        ; AH = units/AL = tens
                Mul     CL
                Sub     DL, '0'
                Add     AL, DL

                Mov     BX, Offset PE_GotoNextInput
                Mov     LastInstrument, AL

PE_PatternCursorPos3_2:
                Mov     [ES:DI+1], AL

                Mov     CX, 101h
                Call    NetworkPartialPattern

                Jmp     BX

PE_PatternCursorPos3_1:
                Xor     AX, AX
                Ret

EndP            PE_PatternCursorPos3

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_PatternCursorPos4 Far                ; Tens column of vol.

                Test    CL, CL
                JZ      PE_PatternCursorPos4_1

                Cmp     DX, '`'
                JE      PE_VolumePan

                Mov     BX, Offset PE_GotoNextInput4
                Mov     AL, LastVolume
                Cmp     DX, ' '
                JE      PE_PatternCursorPos4_9

                Mov     AL, 0FFh
                Cmp     DX, '.'
                JE      PE_PatternCursorPos4_9

                Mov     BX, Offset PE_GotoNextInput
                Mov     AL, [ES:DI+2]
                Cmp     AL, 255
                JNE     PE_PatternCursorPos4_2

                Xor     AL, AL

PE_PatternCursorPos4_2:
                And     AX, 7Fh
                Cmp     AL, 65
                JB      PE_PatternCursorPos4_4

                Sub     AL, 65

PE_PatternCursorPos4_4:
                Cmp     DX, '0'
                JB      PE_PatternCursorPos4_5

                Cmp     DX, '9'
                JA      PE_PatternCursorPos4_5

                Mov     CL, 10
                Div     CL
                                                        ; AH = units/AL = tens
                Mov     DH, AH
                Mov     AL, DL
                Sub     AL, '0'

                Mul     CL
                Add     AL, DH

                Cmp     AL, 64
                JBE     PE_PatternCursorPos4_3

                Mov     AL, 64

PE_PatternCursorPos4_3:
                Or      AL, VolumePan                   ; Panning flag.

PE_PatternCursorPos4_9:
                Mov     [ES:DI+2], AL
                Mov     LastVolume, AL

                Mov     CX, 101h
                Call    NetworkPartialPattern

                Jmp     BX

PE_PatternCursorPos4_5:
                Cmp     DX, 'A'
                JB      PE_PatternCursorPos4_6
                Cmp     DX, 'H'
                JA      PE_PatternCursorPos4_6
                Sub     DX, 'A'
                Jmp     PE_PatternCursorPos4_7

PE_PatternCursorPos4_6:
                Cmp     DX, 'a'
                JB      PE_PatternCursorPos4_1
                Cmp     DX, 'h'
                JA      PE_PatternCursorPos4_1

                Sub     DX, 'a'

PE_PatternCursorPos4_7:
                Mov     CL, 10
                Div     CL
                Mov     CH, AH
                Mov     AL, DL
                Mul     CL              ; AL = tens.

                Cmp     AL, 60
                JB      PE_PatternCursorPos4_8

                Add     AL, 128-60

PE_PatternCursorPos4_8:
                Add     AL, 65
                Add     AL, CH
                Jmp     PE_PatternCursorPos4_9

PE_PatternCursorPos4_1:
                Xor     AX, AX
                Ret

EndP            PE_PatternCursorPos4

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_VolumePan Far

                Xor     VolumePan, 80h
                Mov     SI, Offset PanningControlSetMsg

                JNZ     PE_VolumePan1

                Mov     SI, Offset VolumeControlSetMsg

PE_VolumePan1:
                Call    SetInfoLine

                Mov     AX, 1
                Ret

EndP            PE_VolumePan

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_PatternCursorPos5 Far                ; Unit column of vol.

                Test    CL, CL
                JZ      PE_PatternCursorPos5_1

                Cmp     DX, '`'
                JE      PE_VolumePan

                Mov     BX, Offset PE_GotoNextInput4
                Mov     AL, LastVolume
                Cmp     DX, ' '
                JE      PE_PatternCursorPos5_6

                Mov     AL, 0FFh
                Cmp     DX, '.'
                JE      PE_PatternCursorPos5_6

                Mov     BX, Offset PE_GotoNextInput
                Cmp     DX, '0'
                JB      PE_PatternCursorPos5_1

                Cmp     DX, '9'
                JA      PE_PatternCursorPos5_1

                Mov     AL, [ES:DI+2]
                Cmp     AL, 255
                JNE     PE_PatternCursorPos5_2

                Xor     AL, AL

PE_PatternCursorPos5_2:
                And     AX, 7Fh
                Cmp     AL, 65
                JB      PE_PatternCursorPos5_4

                Sub     AL, 65

PE_PatternCursorPos5_4:
                Mov     CL, 10
                Div     CL
                                                        ; AH = units/AL = tens
                Mul     CL
                Sub     DL, '0'
                Add     AL, DL

                Mov     AH, [ES:DI+2]
                Cmp     AH, 255
                JE      PE_PatternCursorPos5_5
                And     AH, 7Fh
                Cmp     AH, 64
                JBE     PE_PatternCursorPos5_5

                Add     AL, 65
                Test    Byte Ptr [ES:DI+2], 80h
                JZ      PE_PatternCursorPos5_6
                Add     AL, 128
                Jmp     PE_PatternCursorPos5_6

PE_PatternCursorPos5_5:
                Cmp     AL, 64
                JBE     PE_PatternCursorPos5_3

                Mov     AL, 64

PE_PatternCursorPos5_3:
                Or      AL, VolumePan

PE_PatternCursorPos5_6:
                Mov     [ES:DI+2], AL
                Mov     LastVolume, AL

                Mov     CX, 101h
                Call    NetworkPartialPattern

                Jmp     BX

PE_PatternCursorPos5_1:
                Xor     AX, AX
                Ret

EndP            PE_PatternCursorPos5

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_PatternCursorPos6 Far

                Test    CL, CL
                JZ      PE_PatternCursorPos6_2

                Mov     AL, LastCommand
                Cmp     DX, ' '
                JE      PE_PatternCursorPos6_3

                Xor     AL, AL
                Cmp     DX, '.'
                JE      PE_PatternCursorPos6_3

                Mov     AX, DX

                Cmp     AX, 'a'
                JB      PE_PatternCursorPos6_1

                Cmp     AX, 'z'
                JA      PE_PatternCursorPos6_1

                Sub     AX, 32

PE_PatternCursorPos6_1:
                Cmp     AX, 'A'
                JB      PE_PatternCursorPos6_2

                Cmp     AX, 'Z'
                JA      PE_PatternCursorPos6_2

                Sub     AL, '@'

PE_PatternCursorPos6_3:
                Mov     LastCommand, AL
                Mov     [ES:DI+3], AL

                Mov     CX, 101h
                Call    NetworkPartialPattern

                Jmp     PE_GotoNextInput

PE_PatternCursorPos6_2:
                Xor     AX, AX
                Ret

EndP            PE_PatternCursorPos6

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_PatternCursorPos7 Far

                Test    CL, CL
                JZ      PE_PatternCursorPos7_3

                Mov     BX, Offset PE_GotoNextInput4
                Xor     AL, AL
                Cmp     DX, '.'
                JE      PE_PatternCursorPos7_5

                Mov     AL, LastCommandValue
                Cmp     DX, ' '
                JE      PE_PatternCursorPos7_5

                Mov     BX, Offset PE_GotoNextInput
                Mov     AX, DX
                Cmp     AX, 'a'
                JB      PE_PatternCursorPos7_1

                Cmp     AX, 'f'
                JA      PE_PatternCursorPos7_1

                Sub     AX, 32

PE_PatternCursorPos7_1:
                Cmp     AX, 'A'
                JB      PE_PatternCursorPos7_2

                Cmp     AX, 'F'
                JA      PE_PatternCursorPos7_2

                Sub     AX, 'A'-10
                Jmp     PE_PatternCursorPos7_4

PE_PatternCursorPos7_2:
                Cmp     AX, '0'
                JB      PE_PatternCursorPos7_3

                Cmp     AX, '9'
                JA      PE_PatternCursorPos7_3

                Sub     AX, '0'

PE_PatternCursorPos7_4:
                Mov     AH, AL
                Mov     AL, [ES:DI+4]
                SHL     AH, 4
                And     AL, 0Fh
                Or      AL, AH

PE_PatternCursorPos7_5:
                Mov     [ES:DI+4], AL
                Mov     LastCommandValue, AL

                Mov     CX, 101h
                Call    NetworkPartialPattern

                Jmp     BX

PE_PatternCursorPos7_3:
                Xor     AX, AX
                Ret

EndP            PE_PatternCursorPos7

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_PatternCursorPos8 Far

                Test    CL, CL
                JZ      PE_PatternCursorPos8_3

                Mov     BX, Offset PE_GotoNextInput4
                Xor     AH, AH
                Cmp     DX, '.'
                JE      PE_PatternCursorPos8_5

                Mov     AH, LastCommandValue
                Cmp     DX, ' '
                JE      PE_PatternCursorPos8_5

                Mov     BX, Offset PE_GotoNextInput
                Mov     AX, DX
                Cmp     AX, 'a'
                JB      PE_PatternCursorPos8_1

                Cmp     AX, 'f'
                JA      PE_PatternCursorPos8_1

                Sub     AX, 32

PE_PatternCursorPos8_1:
                Cmp     AX, 'A'
                JB      PE_PatternCursorPos8_2

                Cmp     AX, 'F'
                JA      PE_PatternCursorPos8_2

                Sub     AX, 'A'-10
                Jmp     PE_PatternCursorPos8_4

PE_PatternCursorPos8_2:
                Cmp     AX, '0'
                JB      PE_PatternCursorPos7_3

                Cmp     AX, '9'
                JA      PE_PatternCursorPos7_3

                Sub     AX, '0'

PE_PatternCursorPos8_4:
                Mov     AH, [ES:DI+4]
                And     AH, 0F0h
                Or      AH, AL

PE_PatternCursorPos8_5:
                Mov     [ES:DI+4], AH
                Mov     LastCommandValue, AH

                Mov     CX, 101h
                Call    NetworkPartialPattern

                Jmp     BX

PE_PatternCursorPos8_3:
                Xor     AX, AX
                Ret

EndP            PE_PatternCursorPos8

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_SetCommandCursor Far

                Push    CS
                Pop     ES
                Mov     DI, Offset CommandToValue
;                Mov     AL, [SI+24]
;                Mov     CS:CommandToValue, AL

                Ret

EndP            PE_SetCommandCursor

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_MarkBeginBlock Far

                Mov     AX, Channel
                Mov     BX, Row

PEFunction_MarkBeginBlockChain:
                Cmp     BlockMark, 0
                JNE     PEFunction_MarkBeginBlock1

                Mov     BlockMark, 1
                Mov     BlockLeft, AX
                Mov     BlockRight, AX
                Mov     BlockTop, BX
                Mov     BlockBottom, BX
                Jmp     PEFunction_MarkBeginBlock5

PEFunction_MarkBeginBlock1:
                Cmp     AX, BlockRight
                JBE     PEFunction_MarkBeginBlock2

                Mov     CX, BlockRight
                Mov     BlockRight, AX
                Mov     BlockLeft, CX
                Jmp     PEFunction_MarkBeginBlock3

PEFunction_MarkBeginBlock2:
                Mov     BlockLeft, AX

PEFunction_MarkBeginBlock3:
                Cmp     BX, BlockBottom
                JBE     PEFunction_MarkBeginBlock4

                Mov     CX, BlockBottom
                Mov     BlockBottom, BX
                Mov     BlockTop, CX
                Jmp     PEFunction_MarkBeginBlock5

PEFunction_MarkBeginBlock4:
                Mov     BlockTop, BX

PEFunction_MarkBeginBlock5:
                Mov     AX, 1
                Ret

EndP            PEFunction_MarkBeginBlock

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_MarkEndBlock Far

                Mov     AX, Channel
                Mov     BX, Row

PEFunction_MarkEndChain:
                Cmp     BlockMark, 0
                JNE     PEFunction_MarkEndBlock1

                Mov     BlockMark, 1
                Mov     BlockLeft, AX
                Mov     BlockRight, AX
                Mov     BlockTop, BX
                Mov     BlockBottom, BX
                Jmp     PEFunction_MarkEndBlock5

PEFunction_MarkEndBlock1:
                Cmp     AX, BlockLeft
                JAE     PEFunction_MarkEndBlock2

                Mov     CX, BlockLeft
                Mov     BlockLeft, AX
                Mov     BlockRight, CX
                Jmp     PEFunction_MarkEndBlock3

PEFunction_MarkEndBlock2:
                Mov     BlockRight, AX

PEFunction_MarkEndBlock3:
                Cmp     BX, BlockTop
                JAE     PEFunction_MarkEndBlock4

                Mov     CX, BlockTop
                Mov     BlockTop, BX
                Mov     BlockBottom, CX
                Jmp     PEFunction_MarkEndBlock5

PEFunction_MarkEndBlock4:
                Mov     BlockBottom, BX

PEFunction_MarkEndBlock5:
                Mov     AX, 1
                Ret

EndP            PEFunction_MarkEndBlock

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_AltD Far

                Mov     AX, Channel
                Mov     BX, Row
                MovZX   DX, RowHiLight2

                Cmp     Word Ptr [LastKeyBoard2+2], 2000h
                JNE     PEFunction_AltD1
                                        ; OK, at least 1 Alt-D already..
                                        ; Now double length...
                Mov     DX, BlockBottom
                Sub     DX, BlockTop
                Inc     DX
                Add     DX, DX
                Add     DX, BlockTop
                Dec     DX
                Cmp     DX, MaxRow
                JBE     PEFunction_AltD3

                Mov     DX, MaxRow

PEFunction_AltD3:
                Mov     BlockBottom, DX
                Jmp     PEFunction_AltD4

PEFunction_AltD1:
                Dec     DX
                Mov     BlockTop, BX
                Mov     BlockLeft, AX
                Mov     BlockRight, AX

                Add     BX, DX
                Cmp     BX, MaxRow
                JBE     PEFunction_AltD2

                Mov     BX, MaxRow

PEFunction_AltD2:
                Mov     BlockBottom, BX
                Mov     BlockMark, 1

PEFunction_AltD4:
                Mov     AX, 1
                Ret

EndP            PEFunction_AltD

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_AltS Far

                Cmp     BlockMark, 0
                JE      PEFunction_NoBlockMarkedMessage

                Cmp     [Word Ptr LastKeyBoard2+2], 1F00h
                JE      PEFunction_AltS5
                Call    NetworkBlock

                Mov     DI, 12
                Call    PE_AddToUndoBuffer

PEFunction_AltS5:
                Mov     AX, 64
                Mul     BlockTop
                Add     AX, BlockLeft
                Mov     BX, 5
                Mul     BX

                Mov     SI, AX
                Inc     SI

                Mov     AH, LastInstrument
                Mov     DX, BlockRight
                Sub     DX, BlockLeft
                Inc     DX
                Mov     CX, BlockBottom
                Sub     CX, BlockTop
                Inc     CX

                Mov     DS, PatternDataArea

PEFunction_AltS1:
                Push    SI
                Push    CX

                Mov     CX, DX

PEFunction_AltS2:
                Cmp     Byte Ptr [SI], 0
                JE      PEFunction_AltS3

                Mov     [SI], AH

PEFunction_AltS3:
                Add     SI, 5
                Loop    PEFunction_AltS2

                Pop     CX
                Pop     SI
                Add     SI, 320
                Loop    PEFunction_AltS1

PEFunction_AltS4:
                Mov     AX, 1
                Ret

EndP            PEFunction_AltS

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEGetVolume             ; Given DL = note, DH = instrument
                                        ; Returns DL, Carry if none

                Push    AX BX DI DS

                Cmp     DL, MAXNOTE
                JA      PEGetVolumeError

                Call    Music_GetSongSegment
                Mov     DS, AX

                Mov     BL, DH
                And     BX, 0FFh
                JZ      PEGetVolumeError
                Add     BX, BX

                Test    Byte Ptr [DS:2Ch], 4
                JZ      PEGetVolumeSample

                Mov     DI, DX
                Mov     BX, [DS:64710+BX]
                And     DI, 0FFh        ; Note
                Add     DI, DI
                Mov     BX, [DS:BX+DI+41h]
                And     BX, 0FFh        ; BX = sample
                JZ      PEGetVolumeError
                Add     BX, BX

PEGetVolumeSample:
                Mov     BX, [DS:64910+BX]
                Mov     DL, [BX+13h]

                DB      85h     ;
PEGetVolumeError:               ;
                StC             ;

PEGetVolumeEnd:
                Pop     DS DI BX AX
                Ret

EndP            PEGetVolume

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_AltK Far

                Cmp     BlockMark, 0
                JE      PEFunction_NoBlockMarkedMessage

                Cmp     [Word Ptr LastKeyBoard2+2], 2500h
                JNE     PEFunction_AltK7

                Cmp     [Word Ptr LastKeyBoard3+2], 2500h
                JE      PEFunction_AltK11

                Mov     DI, 8
                Call    PE_AddToUndoBuffer
                Call    NetworkBlock

                                        ; OK.. wipe volume data...
                Mov     AX, 64
                Mul     BlockTop
                Add     AX, BlockLeft
                Mov     BX, 5
                Mul     BX
                Mov     DI, AX

                Mov     DX, BlockRight
                Sub     DX, BlockLeft
                Inc     DX

                Mov     CX, BlockBottom
                Sub     CX, BlockTop
                Inc     CX

                Mov     ES, PatternDataArea
;                Add     DI, 2
                ScasW

                Mov     AL, 0FFh

PEFunction_AltK12:
                Push    CX
                Push    DI

                Mov     CX, DX

PEFunction_AltK13:
                StosB
                Add     DI, 4
                Loop    PEFunction_AltK13

                Pop     DI
                Pop     CX
                Add     DI, 320
                Loop    PEFunction_AltK12

PEFunction_AltK11:
                Mov     AX, 1
                Ret

PEFunction_AltK7:
                Mov     DI, 7
                Call    PE_AddToUndoBuffer
                Call    NetworkBlock

                Mov     AX, 64
                Mul     BlockTop
                Add     AX, BlockLeft
                Mov     BX, 5
                Mul     BX
                Mov     SI, AX

                Mov     AX, 64
                Mul     BlockBottom
                Add     AX, BlockLeft
                Mul     BX
                Mov     DI, AX

                Mov     DX, BlockRight
                Sub     DX, BlockLeft
                Inc     DX

                Mov     CX, BlockBottom
                Sub     CX, BlockTop
                JZ      PEFunction_AltK2        ; CX contains number of rows

;                Add     SI, 2
;                Add     DI, 2
                LodsW
                ScasW
                Mov     DS, PatternDataArea

PEFunction_AltK1:
                Push    CX
                Push    DX
                Push    SI

; AltK6 = don't slide.

                MovZX   AX, Byte Ptr [DI]
                Cmp     AL, 0FFh
                JNE     PEFunction_KVolume1

                Mov     DX, [DI-2]
                Call    PEGetVolume
                JC      PEFunction_AltK6
                MovZX   AX, DL

PEFunction_KVolume1:
                MovZX   BX, Byte Ptr [SI]
                Cmp     BL, 0FFh
                JNE     PEFunction_KVolume2

                Mov     DX, [SI-2]
                Call    PEGetVolume
                JC      PEFunction_AltK6
                MovZX   BX, DL

PEFunction_KVolume2:                            ; Now BOTH AL and BL are pan
                                                ; Or BOTH AL and BL are volume
                Mov     DL, AL
                Mov     DH, BL

                And     DX, 7F7Fh
                Cmp     DL, 64
                JA      PEFunction_AltK6
                Cmp     DH, 64
                JA      PEFunction_AltK6

                Mov     DL, AL
                Mov     DH, BL

                And     DX, 8080h
                JZ      PEFunction_AltK14
                Cmp     DX, 8080h
                JNE     PEFunction_AltK6

PEFunction_AltK14:
                Mov     [DI], AL
                Mov     [SI], BL

                Sub     AX, BX                  ; AX = change.
                JS      PEFunction_AltK4

                Div     CL
                Mov     BH, AL
                Xor     AL, AL
                Div     CL
                Mov     BL, AL

                Xor     AL, AL
                Jmp     PEFunction_AltK5


PEFunction_AltK4:
                Neg     AX
                Div     CL
                Mov     BH, AL
                Xor     AL, AL
                Div     CL
                Mov     BL, AL
                Neg     BX

                Mov     AL, 0FFh

PEFunction_AltK5:
                Mov     AH, [SI]

PEFunction_AltK3:
                Mov     [SI], AH

                Add     AX, BX
                Add     SI, 320
                Loop    PEFunction_AltK3

PEFunction_AltK6:
                Pop     SI
                Pop     DX
                Pop     CX
                Add     SI, 5
                Add     DI, 5
                Dec     DX
                JNZ     PEFunction_AltK1

PEFunction_AltK2:
                Mov     AX, 1
                Ret

EndP            PEFunction_AltK

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_AltL Far

                Call    Music_GetLastChannel    ; AX = max channel.
                Mov     BX, MaxRow

                Cmp     [Word Ptr LastKeyBoard2+2], 2600h
                JNE     PEFunction_AltL1

                Xor     CX, CX
                Cmp     CX, BlockTop
                JNE     PEFunction_AltL2
                Cmp     CX, BlockLeft
                JNE     PEFunction_AltL2
                Cmp     BlockRight, AX
                JNE     PEFunction_AltL2
                Cmp     BX, BlockBottom
                JNE     PEFunction_AltL2
                Jmp     PEFunction_AltL1

PEFunction_AltL2:
                Xor     CX, CX
                Mov     BlockTop, CX
                Mov     BlockLeft, CX
                Mov     BlockRight, AX
                Mov     BlockBottom, BX
                Jmp     PEFunction_AltL3

PEFunction_AltL1:
                Mov     AX, Channel
                Mov     BlockTop, 0
                Mov     BlockLeft, AX
                Mov     BlockRight, AX
                Mov     BlockBottom, BX

PEFunction_AltL3:
                Mov     BlockMark, 1

                Mov     AX, 1
                Ret

EndP            PEFunction_AltL

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_WipeBlock Far

                Cmp     BlockMark, 0
                JE      PEFunction_NoBlockMarkedMessage

                Cmp     [Word Ptr LastKeyBoard2+2], 2C00h
                JE      PEFunction_WipeBlock1

                Mov     DI, 18
                Call    PE_AddToUndoBuffer
                Call    NetworkBlock

                Cmp     Template, 0
                JNE     PEFunction_WipeBlock4

                Push    DS
                Call    PEFunction_BlockCopy
                Pop     DS

PEFunction_WipeBlock4:

                Mov     AX, 64
                Mul     BlockTop
                Add     AX, BlockLeft
                Mov     BX, 5
                Mul     BX
                Mov     DI, AX

                Mov     CX, BlockBottom
                Sub     CX, BlockTop
                Inc     CX

                Mov     DX, BlockRight
                Sub     DX, BlockLeft
                Inc     DX

                Mov     ES, PatternDataArea

PEFunction_WipeBlock2:
                Push    DI
                Push    CX

                Mov     CX, DX

PEFunction_WipeBlock3:
                Mov     AX, NONOTE
                StosW
                Mov     AL, 0FFh
                StosB
                Xor     AX, AX
                StosW
                Loop    PEFunction_WipeBlock3

                Pop     CX
                Pop     DI
                Add     DI, 320
                Loop    PEFunction_WipeBlock2

PEFunction_WipeBlock1:
                Mov     AX, 1
                Ret

EndP            PEFunction_WipeBlock

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_RollUp Far

                Cmp     BlockMark, 0
                JE      PEFunction_NoBlockMarkedMessage

                Mov     AX, 64
                Mul     BlockTop
                Add     AX, BlockLeft
                Mov     BX, 5
                Mul     BX
                Mov     SI, AX

                Mov     BP, BlockBottom
                Sub     BP, BlockTop
                JZ      PEFunction_RollUpEnd

                Call    NetworkBlock

                Mov     DX, BlockRight
                Sub     DX, BlockLeft
                Inc     DX
                Mov     AX, 5
                Mul     DX

                Mov     CX, AX

                Push    CS
                Pop     ES
                Mov     DI, Offset TempData
                Mov     DS, PatternDataArea

                Push    SI
                Rep     MovsB
                Pop     DI

                Push    DS
                Pop     ES
                LEA     SI, [DI+320]

PEFunction_RollUp1:
                Push    SI
                Push    DI

                Mov     CX, AX
                Rep     MovsB

                Pop     DI
                Pop     SI
                Add     SI, 320
                Add     DI, 320

                Dec     BP
                JNZ     PEFunction_RollUp1

                Push    CS
                Pop     DS
                Mov     SI, Offset TempData
                Mov     CX, AX
                Rep     MovsB

PEFunction_RollUpEnd:
                Mov     AX, 1
                Ret

EndP            PEFunction_RollUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_RollDown Far

                Cmp     BlockMark, 0
                JE      PEFunction_NoBlockMarkedMessage

                Mov     AX, 64
                Mul     BlockBottom
                Add     AX, BlockLeft
                Mov     BX, 5
                Mul     BX
                Mov     SI, AX

                Mov     BP, BlockBottom
                Sub     BP, BlockTop
                JZ      PEFunction_RollDownEnd

                Call    NetworkBlock

                Mov     DX, BlockRight
                Sub     DX, BlockLeft
                Inc     DX
                Mov     AX, 5
                Mul     DX

                Mov     CX, AX

                Push    CS
                Pop     ES
                Mov     DI, Offset TempData
                Mov     DS, PatternDataArea

                Push    SI
                Rep     MovsB
                Pop     DI

                Push    DS
                Pop     ES
                LEA     SI, [DI-320]

PEFunction_RollDown1:
                Push    SI
                Push    DI

                Mov     CX, AX
                Rep     MovsB

                Pop     DI
                Pop     SI
                Sub     SI, 320
                Sub     DI, 320

                Dec     BP
                JNZ     PEFunction_RollDown1

                Push    CS
                Pop     DS
                Mov     SI, Offset TempData
                Mov     CX, AX
                Rep     MovsB

PEFunction_RollDownEnd:
                Mov     AX, 1
                Ret

EndP            PEFunction_RollDown

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_BlockHalve Far

                Cmp     BlockMark, 0
                JE      PEFunction_NoBlockMarkedMessage

                Mov     DI, 5
                Call    PE_AddToUndoBuffer

                Mov     BL, Byte Ptr BlockLeft
                Mov     BH, Byte Ptr BlockTop
                Mov     CH, Byte Ptr MaxRow
                Mov     CL, Byte Ptr BlockRight
                Sub     CX, BX
                Add     CX, 101h
                Call    NetworkPatternBlock

                Mov     AX, 320
                Mul     BlockTop
                Mov     BX, AX
                Mov     AX, 5
                Mul     BlockLeft
                Add     BX, AX
                Mov     SI, BX
                Mov     DI, BX

                Mov     DX, BlockBottom
                Sub     DX, BlockTop
                Inc     DX

                Mov     CX, BlockRight
                Sub     CX, BlockLeft
                Inc     CX

                Mov     AX, BlockTop

                Mov     DS, PatternDataArea
                Push    DS
                Pop     ES

PEFunction_BlockHalve1:
                Push    AX
                Push    CX
                Push    DX
                Push    SI
                Push    DI

                Cmp     AX, CS:MaxRow
                JBE     PEFunction_BlockHalve3

PEFunction_BlockHalve2:
                Mov     AX, NONOTE
                StosW
                Mov     AL, 0FFh
                StosB
                Xor     AX, AX
                StosW
                Loop    PEFunction_BlockHalve2

                Jmp     PEFunction_BlockHalve4

PEFunction_BlockHalve3:
                Mov     AX, 5
                Mul     CX
                Mov     CX, AX
                Rep     MovsB

PEFunction_BlockHalve4:

                Pop     DI
                Pop     SI
                Pop     DX
                Pop     CX
                Pop     AX
                Add     SI, 640
                Add     DI, 320
                Add     AX, 2
                Dec     DX
                JNZ     PEFunction_BlockHalve1

                Mov     AX, 1
                Ret

EndP            PEFunction_BlockHalve

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_BlockDouble Far

                Cmp     BlockMark, 0
                JE      PEFunction_NoBlockMarkedMessage

                Mov     DI, 4
                Call    PE_AddToUndoBuffer

                Mov     BL, Byte Ptr BlockLeft
                Mov     BH, Byte Ptr BlockTop
                Mov     CH, Byte Ptr MaxRow
                Mov     CL, Byte Ptr BlockRight
                Sub     CX, BX
                Add     CX, 101h
                Call    NetworkPatternBlock

                Mov     AX, 320
                Mov     CX, BlockBottom
                Mul     CX
                Mov     SI, AX
                Add     CX, CX                  ; CX = 2*number of rows+2*top
                Sub     CX, BlockTop            ; CX = 2*number of rows+top
                Inc     CX
                Mov     AX, 320
                Mul     CX
                Mov     DI, AX

                Push    CX                      ; CX = output row.

                Mov     CX, BlockRight
                Sub     CX, BlockLeft
                Inc     CX

                Mov     AX, 5
                Mul     BlockLeft
                Add     SI, AX
                Add     DI, AX

                Pop     DX                      ; DX = output row

                Mov     DS, PatternDataArea
                Push    DS
                Pop     ES

PEFunction_BlockDouble1:
                Push    DI

                Cmp     DX, CS:MaxRow
                JA      PEFunction_BlockDouble2
                                                ; Empty stuff now..
                Push    CX

PEFunction_BlockDouble4:
                Mov     AX, NONOTE
                StosW
                Mov     AL, 0FFh
                StosB
                Xor     AX, AX
                StosW
                Loop    PEFunction_BlockDouble4

                Pop     CX

PEFunction_BlockDouble2:
                Pop     DI
                Sub     DI, 320
                Dec     DX

                Push    SI
                Push    DI
                Cmp     DX, CS:MaxRow
                JA      PEFunction_BlockDouble3

                Push    CX
                Push    DX

                Mov     AX, 5
                Mul     CX
                Mov     CX, AX
                Rep     MovsB

                Pop     DX
                Pop     CX

PEFunction_BlockDouble3:
                Pop     DI
                Pop     SI
                Sub     SI, 320
                Sub     DI, 320

                Cmp     DX, CS:BlockTop
                JBE     PEFunction_BlockDouble5

                Dec     DX
                Jmp     PEFunction_BlockDouble1

PEFunction_BlockDouble5:
                Mov     AX, 1
                Ret

EndP            PEFunction_BlockDouble

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_BlockSwap Far                ; Alt-H... sorry.

                Cmp     BlockMark, 0
                JE      PEFunction_NoBlockMarkedMessage

                                                        ; Check that boundaries
                                                        ;  are OK..

                                        ; 1. Check that vertices of new block
                                        ;    don't lie in old block.
                                        ; 2. Check that 2nd block < channels
                                        ;    and 2nd block < maxrow.

                Mov     AX, Channel
                Mov     BX, Row
                Call    Near Ptr PEFunction_BlockSwap1
                Add     AX, BlockRight
                Sub     AX, BlockLeft
                Call    Near Ptr PEFunction_BlockSwap1
                Add     BX, BlockBottom
                Sub     BX, BlockTop
                Call    Near Ptr PEFunction_BlockSwap1
                Mov     AX, Channel
                Call    Near Ptr PEFunction_BlockSwap1
                Jmp     PEFunction_BlockSwap3

PEFunction_BlockSwap1:
                Cmp     AX, BlockLeft
                JB      PEFunction_BlockSwap2
                Cmp     AX, BlockRight
                JA      PEFunction_BlockSwap2

                Cmp     BX, BlockTop
                JB      PEFunction_BlockSwap2
                Cmp     BX, BlockBottom
                JA      PEFunction_BlockSwap2

                                        ; Uh oh... cursor is in block.

                Mov     DI, Offset O1_OverlapBlockList
                Mov     CX, 2
                Call    M_Object1List

                Pop     AX              ; Clear stack
                Mov     AX, 1
                RetF

PEFunction_BlockSwap2:
                RetN

PEFunction_BlockSwap3:
                Mov     DI, 17
                Call    PE_AddToUndoBuffer
                Call    NetworkBlock

                Mov     BL, Byte Ptr Channel
                Mov     BH, Byte Ptr Row
                Mov     CL, Byte Ptr BlockRight
                Mov     CH, Byte Ptr BlockBottom
                Sub     CL, Byte Ptr BlockLeft
                Sub     CH, Byte Ptr BlockTop
                Add     CX, 101h
                Call    NetworkPatternBlock


                Mov     AX, Channel
                Mov     BX, Row

                Mov     CX, BlockRight
                Sub     CX, BlockLeft
                Inc     CX                      ; CX = block width.
                Add     AX, CX
                Cmp     AX, 64
                JA      PEFunction_BlockSwap4

                Mov     DX, BlockBottom
                Sub     DX, BlockTop            ; DX = block height-1.
                Add     BX, DX
                Cmp     BX, MaxRow
                JBE     PEFunction_BlockSwap5

PEFunction_BlockSwap4:
                Mov     DI, Offset O1_SwapOutOfRangeList
                Mov     CX, 2
                Call    M_Object1List

                Mov     AX, 1
                Ret

PEFunction_BlockSwap5:                                  ; Do swap.
                Mov     AX, 320
                Mul     BlockTop
                Mov     BX, AX
                Mov     AX, 5
                Mul     BlockLeft
                Add     BX, AX
                Mov     SI, BX                          ; SI = "marked" block

                Call    GetPatternOffset                ; DI = implied block
;                Mov     AX, 320
;                Mul     Row
;                Mov     BX, AX
;                Mov     AX, 5
;                Mul     Channel
;                Add     BX, AX
;                Mov     SI, BX                          ; SI = implied block.

                Mov     CX, BlockRight
                Sub     CX, BlockLeft
                Inc     CX                              ; CX = width of block.
                Mov     AX, 5
                Mul     CX
                Mov     CX, AX

                Mov     DX, BlockBottom
                Sub     DX, BlockTop
                Inc     DX                              ; DX = height of block

;                Mov     ES, PatternDataArea
                Push    ES
                Pop     DS

PEFunction_BlockSwap6:
                Push    CX
                Push    DX
                Push    SI
                Push    DI

PEFunction_BlockSwap7:
                Mov     AL, [DS:DI]
                MovsB
                Mov     [DS:SI-1], AL
                Loop    PEFunction_BlockSwap7

                Pop     DI
                Pop     SI
                Pop     DX
                Pop     CX
                Add     SI, 320
                Add     DI, 320
                Dec     DX
                JNZ     PEFunction_BlockSwap6

                Mov     AX, 1
                Ret

EndP            PEFunction_BlockSwap

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_BlockCopy Far

                Cmp     BlockMark, 0
                JE      PEFunction_NoBlockMarkedMessage

                Mov     AX, BlockDataArea
                And     AX, AX
                JZ      PEFunction_BlockCopy1

                Mov     ES, AX
                Mov     AH, 49h
                Int     21h

PEFunction_BlockCopy1:
                Mov     AX, BlockBottom
                Sub     AX, BlockTop
                Inc     AX

                Mov     BX, BlockRight
                Sub     BX, BlockLeft
                Inc     BX
                Mul     BX
                Mov     BX, 5
                Mul     BX
                                                ; AX = size of block
                Mov     BX, AX
                Add     BX, 19                  ; + space for width/height
                ShR     BX, 4
                Mov     AH, 48h
                Int     21h
                JNC     PEFunction_BlockCopy2

                Jmp     PEFunction_OutOfMemoryMessage

PEFunction_BlockCopy2:
                Mov     BlockDataArea, AX
                Xor     DI, DI
                Mov     ES, AX

                Mov     AX, BlockRight
                Sub     AX, BlockLeft
                Inc     AX
                StosW
                Mov     BX, 5
                Mul     BX
                Mov     DX, AX                  ; DX = width*5

                Mov     AX, BlockBottom
                Sub     AX, BlockTop
                Inc     AX
                StosW
                Mov     CX, AX                  ; CX = height

                Push    DX

                Mov     AX, 64
                Mul     BlockTop
                Add     AX, BlockLeft
                Mul     BX
                Mov     SI, AX

                Pop     DX
                Mov     DS, PatternDataArea

PEFunction_BlockCopy3:
                Push    SI
                Push    CX

                Mov     CX, DX
                Rep     MovsB

                Pop     CX
                Pop     SI
                Add     SI, 320
                Loop    PEFunction_BlockCopy3

                Mov     AX, 1
                Ret

EndP            PEFunction_BlockCopy

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_NoBlockMarkedMessage Far

                Mov     DI, Offset O1_NoBlockMarkedList
                Mov     CX, 2
                Call    M_Object1List

                Mov     AX, 1
                Ret

EndP            PEFunction_NoBlockMarkedMessage

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_OutOfMemoryMessage Far

                Call    PE_FillHeader
                Call    S_SaveScreen

                Mov     DI, Offset O1_OutOfMemoryList
                Mov     CX, 2
                Call    M_Object1List

                Call    S_RestoreScreen

                Mov     AX, 1
                Ret

EndP            PEFunction_OutOfMemoryMessage

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_NoBlockData Far

                Mov     DI, Offset O1_NoBlockDataList
                Mov     CX, 2
                Call    M_Object1List

                Mov     AX, 1
                Ret

EndP            PEFunction_NoBlockData

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_BlockOverWrite Far

                Mov     AX, BlockDataArea
                And     AX, AX
                JZ      PEFunction_NoBlockData

                Cmp     [Word Ptr LastKeyBoard2+2], 1800h
                JE      PEFunction_BlockOverWrite5

                Mov     DI, 10
                Call    PE_AddToUndoBuffer

                Mov     ES, AX
                Mov     CL, [ES:0]
                Mov     CH, [ES:2]
                Call    NetworkPartialPattern

PEFunction_BlockOverWrite6:

                Mov     BP, MaxRow
                Mov     BX, Row
                Mov     CX, Channel

                Call    GetPatternOffset

                Mov     DS, AX

                Mov     SI, 4                   ; DS:SI points to block

                Mov     AX, CX
                Mov     DX, [DS:0]
                Mov     CX, [DS:2]              ; DX = width, CX = height

PEFunction_BlockOverWrite1:
                Push    AX
                Push    CX
                Push    DX
                Push    DI

PEFunction_BlockOverWrite2:
                Cmp     AX, 63
                JA      PEFunction_BlockOverWrite3

                Mov     CX, 5
                Rep     MovsB

                Jmp     PEFunction_BlockOverWrite4

PEFunction_BlockOverWrite3:
                Add     SI, 5

PEFunction_BlockOverWrite4:
                Inc     AX                      ; AX = channel
                Dec     DX
                JNZ     PEFunction_BlockOverWrite2

                Pop     DI
                Pop     DX
                Pop     CX
                Pop     AX
                Add     DI, 320
                Inc     BX
                Cmp     BX, BP
                JA      PEFunction_BlockOverWrite5

                Loop    PEFunction_BlockOverWrite1

PEFunction_BlockOverWrite5:
                Mov     AX, 1
                Ret

EndP            PEFunction_BlockOverWrite

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_BlockPaste Far

                Mov     AX, BlockDataArea
                And     AX, AX
                JZ      PEFunction_NoBlockData

                Cmp     [Word Ptr LastKeyBoard2+2], 1900h
                JE      PEFunction_BlockPaste6

                Mov     DI, 11
                Call    PE_AddToUndoBuffer

PEFunction_BlockPaste6:
                Push    DS
                Mov     BP, MaxRow

                Mov     ES, AX

                Mov     CH, Byte Ptr MaxRow
                Sub     CH, Byte Ptr Row
                Inc     CH
                Mov     CL, [ES:0]
                Call    NetworkPartialPattern

                Mov     BX, [ES:0]              ; width
                Mov     CX, [ES:2]              ; height

; Condition:
;  If Row == 0 && Channel == 0 && height > MaxRow && width > 1, then set maxrow = height
                Cmp     CX, BP
                JB      PEFunction_BlockPaste7

                Mov     AX, Channel
                Or      AX, Row
                JNZ     PEFunction_BlockPaste7

                Cmp     BX, 1
                JBE     PEFunction_BlockPaste7

                Mov     BP, CX
                Dec     BP
                Mov     MaxRow, BP

PEFunction_BlockPaste7:
                Mov     AX, 64
                Mul     BP
                Add     AX, Channel
                Mov     DX, 5
                Mul     DX
                Mov     SI, AX
                Mov     DI, AX

                Mov     AX, 320
                Mul     CX
                Add     DI, AX                  ; DI has destination...

                Mov     AX, Channel
                Mov     DS, PatternDataArea
                Push    DS
                Pop     ES

PEFunction_BlockPaste1:
                Push    AX
                Push    CX
                Push    SI
                Push    DI

                Mov     AX, CS:Row
                Add     AX, CX
                Mov     DX, BP
                Add     DX, CX

PEFunction_BlockPaste5:
                Cmp     DX, BP
                JA      PEFunction_BlockPaste3

                Mov     CX, 5
                Rep     MovsB
                Sub     SI, 325
                Sub     DI, 325

                Jmp     PEFunction_BlockPaste4

PEFunction_BlockPaste3:
                Sub     SI, 320
                Sub     DI, 320

PEFunction_BlockPaste4:
                Dec     DX
                Cmp     DX, AX
                JAE     PEFunction_BlockPaste5

                Pop     DI
                Pop     SI
                Pop     CX
                Pop     AX

                Add     SI, 5
                Add     DI, 5
                Inc     AX
                Cmp     AX, 63
                JA      PEFunction_BlockPaste2

                Dec     BX
                JNZ     PEFunction_BlockPaste1

PEFunction_BlockPaste2:
                Pop     DS

                Mov     AX, BlockDataArea
                Jmp     PEFunction_BlockOverWrite6

EndP            PEFunction_BlockPaste

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_SecondBlockMix Far

                Mov     BP, MaxRow
                Mov     BX, Row
                Mov     CX, Channel

                Call    GetPatternOffset

                Mov     DS, BlockDataArea

                Mov     SI, 4                   ; DS:SI points to block

                Mov     AX, CX

                Mov     CL, [DS:0]
                Mov     CH, [DS:2]
                Call    NetworkPartialPattern

                Mov     DX, [DS:0]
                Mov     CX, [DS:2]              ; DX = width, CX = height

PEFunction_SecondBlockMix1:
                Push    AX
                Push    CX
                Push    DX
                Push    DI

PEFunction_SecondBlockMix2:
                Cmp     AX, 63
                JA      PEFunction_SecondBlockMix3

                Cmp     Byte Ptr [ES:DI], NONOTE        ; Note
                JNE     PEFunction_SecondBlockMix7

                Mov     CL, [DS:SI]
                Mov     [ES:DI], CL

PEFunction_SecondBlockMix7:
                Inc     SI
                Inc     DI

                Cmp     Byte Ptr [ES:DI], 0             ; Instrument
                JNE     PEFunction_SecondBlockMix8

                Mov     CL, [DS:SI]
                Mov     [ES:DI], CL

PEFunction_SecondBlockMix8:
                Inc     SI
                Inc     DI

                Cmp     Byte Ptr [ES:DI], 0FFh          ; Volume
                JNE     PEFunction_SecondBlockMix9

                Mov     CL, [DS:SI]
                Mov     [ES:DI], CL

PEFunction_SecondBlockMix9:
                Inc     SI
                Inc     DI

                Cmp     Byte Ptr [ES:DI], 0             ; Command
                JNE     PEFunction_SecondBlockMix10

                Mov     CL, [DS:SI]
                Mov     [ES:DI], CL

PEFunction_SecondBlockMix10:
                Inc     SI
                Inc     DI

                Cmp     Byte Ptr [ES:DI], 0             ; Commandvalue
                JNE     PEFunction_SecondBlockMix11

                Mov     CL, [DS:SI]
                Mov     [ES:DI], CL

PEFunction_SecondBlockMix11:
                Inc     SI
                Inc     DI
                Jmp     PEFunction_SecondBlockMix4

PEFunction_SecondBlockMix3:
                Add     SI, 5

PEFunction_SecondBlockMix4:
                Inc     AX                      ; AX = channel
                Dec     DX
                JNZ     PEFunction_SecondBlockMix2

                Pop     DI
                Pop     DX
                Pop     CX
                Pop     AX
                Add     DI, 320
                Inc     BX
                Cmp     BX, BP
                JA      PEFunction_SecondBlockMix5

                Loop    PEFunction_SecondBlockMix1

PEFunction_SecondBlockMix5:
                Mov     AX, 1
                Ret

EndP            PEFunction_SecondBlockMix

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_BlockMix Far

                Cmp     BlockDataArea, 0
                JE      PEFunction_NoBlockData

                Cmp     [Word Ptr LastKeyBoard2+2], 3200h
                JNE     PEFunction_BlockMix1

                Cmp     [Word Ptr LastKeyboard3+2], 3200h
                JE      PEFunction_BlockMix6

                Jmp     PEFunction_SecondBlockMix

PEFunction_BlockMix1:
                Mov     DI, 9
                Call    PE_AddToUndoBuffer
                Call    NetworkBlock

                Mov     BP, MaxRow
                Mov     BX, Row
                Mov     CX, Channel

                Call    GetPatternOffset

                Mov     DS, BlockDataArea
                Mov     SI, 4                   ; DS:SI points to block

                Mov     AX, CX

                Mov     CL, [DS:0]
                Mov     CH, [DS:2]
                Call    NetworkPartialPattern

                Mov     DX, [DS:0]
                Mov     CX, [DS:2]              ; DX = width, CX = height

PEFunction_BlockMix2:
                Push    AX
                Push    CX
                Push    DX
                Push    DI

PEFunction_BlockMix3:
                Cmp     AX, 63
                JA      PEFunction_BlockMix4

                Cmp     DWord Ptr [ES:DI], NONOTE + 0FF0000h
                JNE     PEFunction_BlockMix7
                Cmp     Byte Ptr [ES:DI+4], 0
                JNE     PEFunction_BlockMix7

                Mov     CX, 5
                Rep     MovsB

                Jmp     PEFunction_BlockMix5

PEFunction_BlockMix7:
                Add     DI, 5

PEFunction_BlockMix4:
                Add     SI, 5

PEFunction_BlockMix5:
                Inc     AX                      ; AX = channel
                Dec     DX
                JNZ     PEFunction_BlockMix3

                Pop     DI
                Pop     DX
                Pop     CX
                Pop     AX
                Add     DI, 320
                Inc     BX
                Cmp     BX, BP
                JA      PEFunction_BlockMix6

                Loop    PEFunction_BlockMix2

PEFunction_BlockMix6:
                Mov     AX, 1
                Ret

EndP            PEFunction_BlockMix

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_UnMarkBlock Far

                Cmp     BlockMark, 0
                JZ      PEFunction_UnMarkBlock1

                Mov     BlockMark, 0
                Jmp     PEFunction_UnMarkBlock2

PEFunction_UnMarkBlock1:
                Mov     AX, BlockDataArea
                And     AX, AX
                JZ      PEFunction_NoBlockData

                Mov     ES, AX
                Mov     AH, 49h
                Int     21h

                Mov     BlockDataArea, 0
PEFunction_UnMarkBlock2:
                Mov     AX, 1
                Ret

EndP            PEFunction_UnMarkBlock

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_SemiUp Far

                Cmp     [Word Ptr LastKeyBoard2+2], 1000h
                JE      PEFunction_SemiUp6

                Mov     DI, 2
                Call    PE_AddToUndoBuffer

PEFunction_SemiUp6:
                Cmp     BlockMark, 0
                JNE     PEFunction_SemiUp4

                Mov     CX, 101h
                Call    NetworkPartialPattern

                Mov     AX, 64
                Mul     Row
                Add     AX, Channel
                Mov     BX, 5
                Mul     BX
                Mov     SI, AX
                Mov     CX, 1
                Mov     DX, CX
                Jmp     PEFunction_SemiUp5

PEFunction_SemiUp4:
                Call    NetworkBlock

                Mov     AX, 64
                Mul     BlockTop
                Add     AX, BlockLeft
                Mov     BX, 5
                Mul     BX                      ; AX = start offset

                Mov     SI, AX

                Mov     DX, BlockRight
                Sub     DX, BlockLeft
                Inc     DX

                Mov     CX, BlockBottom
                Sub     CX, BlockTop
                Inc     CX

PEFunction_SemiUp5:
                Mov     DS, PatternDataArea

PEFunction_SemiUp1:
                Push    DX
                Push    SI

PEFunction_SemiUp2:
                Cmp     Byte Ptr [SI], 119
                JAE     PEFunction_SemiUp3

                Inc     Byte Ptr [SI]

PEFunction_SemiUp3:
                Add     SI, 5
                Dec     DX
                JNZ     PEFunction_SemiUp2

                Pop     SI
                Pop     DX
                Add     SI, 320
                Loop    PEFunction_SemiUp1

                Mov     AX, 1
                Ret

EndP            PEFunction_SemiUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_SemiDown Far

                Cmp     [Word Ptr LastKeyBoard2+2], 1E00h
                JE      PEFunction_SemiDown6

                Mov     DI, 3
                Call    PE_AddToUndoBuffer

PEFunction_SemiDown6:
                Cmp     BlockMark, 0
                JNE     PEFunction_SemiDown4

                Mov     CX, 101h
                Call    NetworkPartialPattern

                Mov     AX, 64
                Mul     Row
                Add     AX, Channel
                Mov     BX, 5
                Mul     BX
                Mov     SI, AX
                Mov     CX, 1
                Mov     DX, CX
                Jmp     PEFunction_SemiDown5

PEFunction_SemiDown4:
                Call    NetworkBlock

                Mov     AX, 64
                Mul     BlockTop
                Add     AX, BlockLeft
                Mov     BX, 5
                Mul     BX                      ; AX = start offset

                Mov     SI, AX

                Mov     DX, BlockRight
                Sub     DX, BlockLeft
                Inc     DX

                Mov     CX, BlockBottom
                Sub     CX, BlockTop
                Inc     CX

PEFunction_SemiDown5:
                Mov     DS, PatternDataArea

PEFunction_SemiDown1:
                Push    DX
                Push    SI

PEFunction_SemiDown2:
                Cmp     Byte Ptr [SI], 0
                JLE     PEFunction_SemiDown3

                Dec     Byte Ptr [SI]

PEFunction_SemiDown3:
                Add     SI, 5
                Dec     DX
                JNZ     PEFunction_SemiDown2

                Pop     SI
                Pop     DX
                Add     SI, 320
                Loop    PEFunction_SemiDown1

                Mov     AX, 1
                Ret

EndP            PEFunction_SemiDown

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_SlideCommand Far

                Mov     DI, 15
                Call    PE_AddToUndoBuffer
                Call    NetworkBlock

                Mov     AX, 64
                Mul     BlockTop
                Add     AX, BlockLeft
                Mov     BX, 5
                Mul     BX
                Mov     SI, AX

                Mov     AX, 64
                Mul     BlockBottom
                Add     AX, BlockLeft
                Mul     BX
                Mov     DI, AX

                Mov     DX, BlockRight
                Sub     DX, BlockLeft
                Inc     DX

                Mov     CX, BlockBottom
                Sub     CX, BlockTop
                JZ      PEFunction_AltX2        ; CX contains number of rows

                Add     SI, 4
                Add     DI, 4
                Mov     DS, PatternDataArea

PEFunction_AltX1:
                Push    CX
                Push    DX
                Push    SI

                MovZX   AX, Byte Ptr [DI]
                MovZX   BX, Byte Ptr [SI]
                Sub     AX, BX                  ; AX = change.
                JS      PEFunction_AltX4

                Div     CL
                Mov     BH, AL
                Xor     AL, AL
                Div     CL
                Mov     BL, AL

                Xor     AL, AL
                Jmp     PEFunction_AltX5


PEFunction_AltX4:
                Neg     AX
                Div     CL
                Mov     BH, AL
                Xor     AL, AL
                Div     CL
                Mov     BL, aL
                Neg     BX

                Mov     AL, 0FFh

PEFunction_AltX5:
                Mov     AH, [SI]

PEFunction_AltX3:
                Mov     [SI], AH

                Add     AX, BX
                Add     SI, 320
                Loop    PEFunction_AltX3

                Pop     SI
                Pop     DX
                Pop     CX
                Add     SI, 5
                Add     DI, 5
                Dec     DX
                JNZ     PEFunction_AltX1

PEFunction_AltX2:
                Mov     AX, 1
                Ret

EndP            PEFunction_SlideCommand

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_WipeCommands Far

                Cmp     BlockMark, 0
                JE      PEFunction_NoBlockMarkedMessage

                Cmp     [Word Ptr LastKeyBoard2+2], 2D00h
                JE      PEFunction_WipeCommands4

                Jmp     PEFunction_SlideCommand

PEFunction_WipeCommands4:
                Cmp     [Word Ptr LastKeyBoard3+2], 2D00h
                JE      PEFunction_WipeCommands6

                Mov     DI, 16
                Call    PE_AddToUndoBuffer
                Call    NetworkBlock

PEFunction_WipeCommands6:
                Mov     AX, 64
                Mul     BlockTop
                Add     AX, BlockLeft
                Mov     BX, 5
                Mul     BX
                Mov     DI, AX

                Mov     DX, BlockRight
                Sub     DX, BlockLeft
                Inc     DX

                Mov     CX, BlockBottom
                Sub     CX, BlockTop
                Inc     CX

                Mov     ES, PatternDataArea
                Add     DI, 3

                Xor     AX, AX

PEFunction_WipeCommands2:
                Push    CX
                Push    DI

                Mov     CX, DX

PEFunction_WipeCommands3:
                StosW
                Add     DI, 3
                Loop    PEFunction_WipeCommands3

                Pop     DI
                Pop     CX
                Add     DI, 320
                Loop    PEFunction_WipeCommands2

PEFunction_WipeCommands1:
                Mov     AX, 1
                Ret

EndP            PEFunction_WipeCommands

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_VolumeAmp Far

                Cmp     BlockMark, 0
                JE      PEFunction_NoBlockMarkedMessage

                Test    CentraliseCursor, 4
                JZ      PENoFast1

                Mov     AX, FastVolumeAmplification
                Mov     Amplification, AX
                Jmp     PEFastVolumeAmp

PENoFast1:
                Cmp     Amplification, 200
                JBE     PENoFast2

                Mov     Amplification, 200

PENoFast2:
                Push    DS

                Mov     DI, Offset O1_GetAmpList
                Mov     CX, 3
                Call    M_Object1List

                Pop     DS

                Cmp     DX, 1
                JNE     PEFunction_VolumeAmp1

PEFastVolumeAmp:
                Mov     DI, 6
                Call    PE_AddToUndoBuffer
                Call    NetworkBlock

                Mov     AX, 64
                Mul     BlockTop
                Add     AX, BlockLeft
                Mov     BX, 5
                Mul     BX
                Mov     SI, AX

                Mov     CX, BlockBottom
                Sub     CX, BlockTop
                Inc     CX

                Mov     DX, BlockRight
                Sub     DX, BlockLeft
                Inc     DX

                Mov     BP, Amplification
                Mov     BX, 100
;                Mov     BH, 100                 ; For division

                Mov     DS, PatternDataArea
                Add     SI, 2

                Call    Music_GetSongSegment
                Mov     ES, AX

PEFunction_VolumeAmp2:
                Push    CX
                Push    DX
                Push    SI

                Mov     CX, DX

PEFunction_VolumeAmp3:
                Mov     AL, [SI]
                Cmp     AL, 0FFh
                JNE     PEFunction_VolumeAmp6

                Mov     DI, [SI-1]
                And     DI, 0FFh
                JZ      PEFunction_VolumeAmp4
                                                ; OK.. find whether inst/sample
                                                ; then get default vol.
                Call    Music_GetInstrumentMode
                JZ      PEFunction_VolumeAmp7

                Add     DI, DI
                Mov     DI, [ES:64712+DI-2]
                Mov     AL, [SI-2]
                And     AX, 0FFh
                JZ      PEFunction_VolumeAmp4
                Add     AX, AX
                Add     DI, AX
                Mov     DI, [ES:DI+41h]
                And     DI, 0FFh
                JZ      PEFunction_VolumeAmp4

PEFunction_VolumeAmp7:
                Dec     DI
                Add     DI, DI
                Mov     DI, [ES:64912+DI]
                Mov     AL, [ES:DI+13h]

PEFunction_VolumeAmp6:
                Cmp     AL, 64
                JA      PEFunction_VolumeAmp4

                Xor     AH, AH
                Push    DX

                Mul     BP
                Div     BX

                Pop     DX

                Cmp     AX, 64
                JBE     PEFunction_VolumeAmp5

                Mov     AL, 64

PEFunction_VolumeAmp5:
                Mov     [SI], AL

PEFunction_VolumeAmp4:
                Add     SI, 5
                Loop    PEFunction_VolumeAmp3

                Pop     SI
                Pop     DX
                Pop     CX
                Add     SI, 320
                Loop    PEFunction_VolumeAmp2

PEFunction_VolumeAmp1:
                Mov     AX, 1
                Ret

EndP            PEFunction_VolumeAmp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetPatternLength

                Push    AX
                Push    BX
                Push    CX
                Push    DS
                Push    SI
                Push    ES
                Push    DI

                Call    ClearEncodingInfo
                                                ; OK, masks are reset.

                Mov     CX, CS:MaxRow
                Inc     CX
                Mov     DX, CX                  ; DX = count of bytes.
                                                ; End of row bytes added.

                Mov     DS, CS:PatternDataArea
                Xor     SI, SI                  ; SI = pattern area.

                Mov     DI, Offset EncodingInfo ; ES:DI points to encoding info

GetPatternLength1:
                Push    CX
                Push    DI

                Mov     CX, 64

GetPatternLength2:
                Cmp     Word Ptr [SI], NONOTE
                JNE     GetPatternLength4
                Cmp     Byte Ptr [SI+2], 0FFh
                JNE     GetPatternLength4
                Cmp     Word Ptr [SI+3], 0
                JE      GetPatternLength3

GetPatternLength4:
                Inc     DX                      ; 1 byte for channel
                                                ;   indication
                JZ      GetPatternLength13
                                                ; AH will be mask
                MovZX   AX, Byte Ptr [SI]       ; Note
                Cmp     AL, NONOTE
                JE      GetPatternLength5
                Cmp     AL, [ES:DI+1]           ; 5 is note.
                JE      GetPatternLength12

                Mov     [ES:DI+1], AL
                Inc     DX
                JZ      GetPatternLength13
                Or      AH, 1
                Jmp     GetPatternLength5

GetPatternLength12:
                Or      AH, 16

GetPatternLength5:
                Mov     AL, [SI+1]              ; Instrument
                And     AL, AL
                JZ      GetPatternLength7

                Cmp     AL, [ES:DI+2]
                JE      GetPatternLength6

                Mov     [ES:DI+2], AL
                Inc     DX
                JZ      GetPatternLength13
                Or      AH, 2
                Jmp     GetPatternLength7

GetPatternLength6:
                Or      AH, 32

GetPatternLength7:
                Mov     AL, [SI+2]              ; Volume
                Cmp     AL, 0FFh
                JE      GetPatternLength8

                Cmp     AL, [ES:DI+3]
                JE      GetPatternLength9

                Mov     [ES:DI+3], AL
                Inc     DX
                JZ      GetPatternLength13
                Or      AH, 4
                Jmp     GetPatternLength8

GetPatternLength9:
                Or      AH, 64

GetPatternLength8:
                Mov     BX, [SI+3]
                And     BX, BX
                JZ      GetPatternLength11
                Cmp     BX, [ES:DI+4]
                JE      GetPatternLength10

                Mov     [ES:DI+4], BX

                Inc     DX
                JZ      GetPatternLength13
                Inc     DX
                JZ      GetPatternLength13
                Or      AH, 8

                Jmp     GetPatternLength11

GetPatternLength10:
                Or      AH, 128

GetPatternLength11:
                Cmp     AH, [ES:DI]
                JE      GetPatternLength3

                Inc     DX
                JZ      GetPatternLength13
                Mov     [ES:DI], AH

GetPatternLength3:

                Add     SI, 5
                Add     DI, 6
                Loop    GetPatternLength2

                Pop     DI
                Pop     CX
                Loop    GetPatternLength1

                Pop     DI
                Pop     ES
                Pop     SI
                Pop     DS
                Pop     CX
                Pop     BX
                Pop     AX

                Ret

GetPatternLength13:
                Mov     DI, Offset O1_PatternTooLongList
                Mov     CX, 2
                Call    M_Object1List

                Add     SP, 22          ; yes!
                Mov     AX, 1
                RetF

EndP            GetPatternLength

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

IF SHOWPATTERNLENGTH

Proc            PE_ShowPatternLength Far

                Push    AX                      ; Just for stack length..
                Call    GetPatternLength
                Pop     AX

                Mov     AX, Object1
                Push    AX
                Mov     DS, AX
                Mov     AX, Offset O1_ShowPatternLengthList
                Push    AX
                Mov     SI, Offset PatternLength
                Mov     [SI], DX
                Call    M_FunctionHandler

                Mov     AX, 1
                Ret

EndP            PE_ShowPatternLength

ENDIF

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

DecodePatternBytes      DW      0
DecodePatternOffset     DW      0

Proc            DecodePattern           ; DS:SI points to pattern info to decode

                PushA
                Push    DS
                Push    ES

;                Call    ClearEncodingInfo      ; Should be unnecess.


                Push    CS
                Pop     ES
                Mov     BX, Offset EncodingInfo

                LodsW                   ; AX = number of bytes
                Mov     CS:DecodePatternBytes, AX
                LodsW                   ; AX = maxrow
                Mov     CX, AX
                Dec     AX
                Mov     CS:MaxRow, AX
                LodsW
                LodsW

                Mov     CS:DecodePatternOffset, SI

                Call    PE_ClearPatternData

                Mov     ES, CS:PatternDataArea
                Xor     DI, DI

DecodePattern1:
                Push    CX

DecodePattern5:
                LodsB                           ; AL = channel byte.
                Test    AL, AL
                JZ      DecodePattern2

                Push    BX
                Push    DI

                Mov     CX, AX
                Dec     CX
                And     CX, 63

        ; DI = DI + Channel*5
        ; BX = EncodingInfo + Channel*6

                LEA     BX, [ECX*4+ECX]
                LEA     DI, [DI+BX]
                LEA     BX, [EBX+ECX+EncodingInfo]

                Test    AL, 128
                JZ      DecodePattern3

                Mov     DL, [SI]
                Inc     SI

                Mov     [CS:BX], DL
                Jmp     DecodePattern4

DecodePattern3:
                Mov     DL, [CS:BX]             ; DL = mask

DecodePattern4:
                Test    DL, 1
                JZ      DecodePattern13

                LodsB

                Mov     [ES:DI], AL
                Mov     [CS:BX+1], AL
                Jmp     DecodePattern6

DecodePattern13:
                Test    DL, 16
                JZ      DecodePattern6

                Mov     AL, [CS:BX+1]
                Mov     [ES:DI], AL

DecodePattern6:
                Test    DL, 2
                JZ      DecodePattern7

                LodsB

                Mov     [ES:DI+1], AL
                Mov     [CS:BX+2], AL
                Jmp     DecodePattern8

DecodePattern7:
                Test    DL, 32
                JZ      DecodePattern8

                Mov     AL, [CS:BX+2]
                Mov     [ES:DI+1], AL

DecodePattern8:
                Test    DL, 4
                JZ      DecodePattern9

                LodsB

                Mov     [ES:DI+2], AL
                Mov     [CS:BX+3], AL
                Jmp     DecodePattern10

DecodePattern9:
                Test    DL, 64
                JZ      DecodePattern10

                Mov     AL, [CS:BX+3]
                Mov     [ES:DI+2], AL

DecodePattern10:
                Test    DL, 8
                JZ      DecodePattern11

                LodsW

                Mov     [ES:DI+3], AX
                Mov     [CS:BX+4], AX
                Jmp     DecodePattern12

DecodePattern11:
                Test    DL, 128
                JZ      DecodePattern12

                Mov     AX, [CS:BX+4]
                Mov     [ES:DI+3], AX

DecodePattern12:
                Pop     DI
                Pop     BX
                Jmp     DecodePattern5

DecodePattern2:
                Pop     CX
                Add     DI, 320
                Loop    DecodePattern1

                Sub     SI, CS:DecodePatternOffset
                Cmp     SI, CS:DecodePatternBytes
                JE      DecodePatternEnd

                Mov     CX, 0FFFFh
                Mov     DI, Offset O1_PatternSizeMismatchList
                Call    M_Object1List

DecodePatternEnd:
                Pop     ES
                Pop     DS
                PopA

                Call    Music_UpdatePatternOffset

                Ret

EndP            DecodePattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            EncodePattern           ; ES:DI points to area to deposit data
                                        ; DX = length of data

                Push    AX
                Push    BX
                Push    CX
                Push    DX
                Push    DS
                Push    SI

                Push    ES
                Push    DI

                Call    ClearEncodingInfo

                Pop     DI
                Pop     ES

                Mov     BX, Offset EncodingInfo

                Mov     AX, DX
                StosW

                Mov     CX, CS:MaxRow
                Inc     CX

                Mov     AX, CX
                StosW

                Xor     AX, AX
                StosW
                StosW                           ; This is the header.

                Xor     SI, SI
                Mov     DS, CS:PatternDataArea

EncodePattern1:
                Push    BX
                Push    CX

                Xor     DX, DX                  ; DL = channelnumber
                                                ; DH is used as mask val.
                Mov     CX, 64

EncodePattern2:
                Cmp     Word Ptr [SI], NONOTE
                JNE     EncodePattern3
                Cmp     Byte Ptr [SI+2], 0FFh
                JNE     EncodePattern8
                Cmp     Word Ptr [SI+3], 0
                JE      EncodePattern4
                Jmp     EncodePattern10

EncodePattern3:
                Mov     AL, [SI]
                Cmp     AL, NONOTE
                JE      EncodePattern5
                Cmp     AL, [CS:BX+1]   ; 1=note
                JE      EncodePattern6

                Mov     [CS:BX+1], AL
                Or      DH, 1
                Jmp     EncodePattern5

EncodePattern6:
                Or      DH, 16

EncodePattern5:
                Mov     AL, [SI+1]
                And     AL, AL
                JZ      EncodePattern8
                Cmp     AL, [CS:BX+2]   ; 2=ins
                JE      EncodePattern7

                Mov     [CS:BX+2], AL
                Or      DH, 2
                Jmp     EncodePattern8

EncodePattern7:
                Or      DH, 32

EncodePattern8:
                Mov     AL, [SI+2]
                Cmp     AL, 0FFh
                JE      EncodePattern10
                Cmp     AL, [CS:BX+3]   ; 3=vol
                JE      EncodePattern9

                Mov     [CS:BX+3], AL
                Or      DH, 4
                Jmp     EncodePattern10

EncodePattern9:
                Or      DH, 64

EncodePattern10:
                Mov     AX, [SI+3]
                Test    AX, AX
                JZ      EncodePattern12
                Cmp     AX, [CS:BX+4]   ; 4=effect
                JE      EncodePattern11

                Mov     [CS:BX+4], AX
                Or      DH, 8
                Jmp     EncodePattern12

EncodePattern11:
                Or      DH, 128

EncodePattern12:
                Mov     AL, DL
                Inc     AX

                Cmp     [CS:BX], DH     ; 0 = mask
                JE      EncodePattern13

                Mov     [CS:BX], DH
                Or      AL, 128                 ; read another mask...
                StosB
                Mov     AL, DH
                StosB
                Jmp     EncodePattern14

EncodePattern13:
                StosB

EncodePattern14:
                Test    DH, 1
                JZ      EncodePattern15

                Mov     AL, [SI]
                StosB

EncodePattern15:
                Test    DH, 2
                JZ      EncodePattern16

                Mov     AL, [SI+1]
                StosB

EncodePattern16:
                Test    DH, 4
                JZ      EncodePattern17

                Mov     AL, [SI+2]
                StosB

EncodePattern17:
                Test    DH, 8
                JZ      EncodePattern18

                Mov     AX, [SI+3]
                StosW

EncodePattern18:
                Xor     DH, DH

EncodePattern4:
                Add     SI, 5
                Add     BX, 6
                Inc     DX
                Loop    EncodePattern2

                Pop     CX
                Pop     BX
                Xor     AL, AL
                StosB
                Loop    EncodePattern1

                Pop     SI
                Pop     DS
                Pop     DX
                Pop     CX
                Pop     BX
                Pop     AX
                Ret

EndP            EncodePattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_StorePattern

IF NETWORKENABLED
                Cmp     PatternModified, 0
                JE      PEFunction_StorePattern5

                Mov     AX, PatternNumber
                ShL     AX, 8
                Add     AX, NETWORK_ENTIREPATTERNOBJECT
                Call    Network_AddWordToQueue

PEFunction_StorePattern5:
ENDIF

                Mov     AX, PatternNumber
                Mov     SI, AX
                Call    Music_ReleasePattern

                Call    GetPatternLength
                Cmp     DX, 64
                JNE     PEFunction_StorePattern1
                Cmp     CS:MaxRow, 63
                JE      PEFunction_StorePattern2

PEFunction_StorePattern1:
                Add     DX, 8
                JC      PEFunction_StorePattern4

                ClI

                Call    Music_AllocatePattern
                Mov     AX, ES
                And     AX, AX
                JZ      PEFunction_StorePattern3
                Sub     DX, 8
                Call    EncodePattern

                StI

PEFunction_StorePattern2:
                Ret

PEFunction_StorePattern3:
                StI

                Add     SP, 2
                Jmp     PEFunction_OutOfMemoryMessage

PEFunction_StorePattern4:
                Mov     DI, Offset O1_PatternTooLongList
                Mov     CX, 2
                Call    M_Object1List

                Pop     AX
                Mov     AX, 1
                RetF

EndP            PEFunction_StorePattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_StoreCurrentPattern Far

                Push    CS
                Pop     DS
                Call    PEFunction_StorePattern

                Mov     AX, 1
                Ret

EndP            PEFunction_StoreCurrentPattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            NewPattern                      ; Reqs. AX = pattern

IF NETWORKENABLED
                Call    Network_UpdatePattern
ENDIF
                Call    Music_GetPattern
                Call    DecodePattern

                Mov     CS:PatternModified, 0
                Mov     AH, CS:Byte Ptr PatternNumber
                Mov     AL, 22
                Mov     DI, AX
;                Mov     DI, 22
                Call    PE_AddToUndoBuffer

                Ret

EndP            NewPattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_GotoPattern Far                      ; AX = pattern.

                Push    CS
                Pop     DS

                Mov     Row, BX
                Mov     Channel, CX

PE_GotoPattern2:
                Cmp     PatternModified, 0
                JE      PE_GotoPattern1

                Mov     TempVariableArea, AX
                Call    PEFunction_StorePattern
                Mov     AX, TempVariableArea

PE_GotoPattern1:
                Mov     PatternNumber, AX
                Call    NewPattern

                Jmp     Glbl_F2

EndP            PE_GotoPattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

include pe_trans.inc

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_NextPattern Far

                Cmp     TracePlayback, 0
                JE      PEFunction_NextPatternNoTrace

                Call    Music_GetPlayMode
                Cmp     AX, 1
                JE      PEFunction_NextPattern1
                JB      PEFunction_NextPatternNoTrace

                Call    Music_NextOrder
                Jmp     PEFunction_NextPattern1

PEFunction_NextPatternNoTrace:
                Cmp     PatternNumber, 199
                JAE     PEFunction_NextPattern1

                Cmp     PatternModified, 0
                JE      PEFunction_NextPattern2

                Call    PEFunction_StorePattern

PEFunction_NextPattern2:
                Inc     PatternNumber
                Mov     AX, PatternNumber

                Call    NewPattern

PEFunction_NextPattern1:
                Mov     AX, 1
                Ret

EndP            PEFunction_NextPattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_LastPattern Far

                Cmp     TracePlayback, 0
                JE      PEFunction_LastPatternNoTrace

                Call    Music_GetPlayMode
                Cmp     AX, 1
                JE      PEFunction_LastPattern1
                JB      PEFunction_LastPatternNoTrace

                Call    Music_LastOrder
                Jmp     PEFunction_LastPattern1

PEFunction_LastPatternNoTrace:
                Cmp     PatternNumber, 0
                JE      PEFunction_LastPattern1

                Cmp     PatternModified, 0
                JE      PEFunction_LastPattern2

                Call    PEFunction_StorePattern

PEFunction_LastPattern2:
                Dec     PatternNumber
                Mov     AX, PatternNumber

                Call    NewPattern

PEFunction_LastPattern1:
                Mov     AX, 1
                Ret

EndP            PEFunction_LastPattern
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Next4Patterns Far

                Cmp     PatternModified, 0
                JE      PEFunction_Next4Patterns2

                Call    PEFunction_StorePattern

PEFunction_Next4Patterns2:
                Mov     AX, PatternNumber
                Add     AX, 4
                Cmp     AX, 199
                JBE     PEFunction_Next4Patterns1

                Mov     AX, 199

PEFunction_Next4Patterns1:
                Mov     PatternNumber, AX

                Call    NewPattern

                Mov     AX, 1
                Ret

EndP            PEFunction_Next4Patterns

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Last4Patterns Far

                Cmp     PatternModified, 0
                JE      PEFunction_Last4Patterns2

                Call    PEFunction_StorePattern

PEFunction_Last4Patterns2:
                Mov     AX, PatternNumber
                Sub     AX, 4
                JNS     PEFunction_Last4Patterns1

                Xor     AX, AX

PEFunction_Last4Patterns1:
                Mov     PatternNumber, AX

                Call    NewPattern

                Mov     AX, 1
                Ret

EndP            PEFunction_Last4Patterns

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_LastOrderPattern Far

                Cmp     PatternModified, 0
                JE      PEFunction_LastOrderPattern3

                Call    PEFunction_StorePattern

PEFunction_LastOrderPattern3:
                Call    Music_GetSongSegment
                Mov     ES, AX

                Mov     BX, Order
                And     BX, BX
                JZ      PEFunction_LastOrderPattern2

                Cmp     Byte Ptr [ES:BX+0FFh], 200
                JAE     PEFunction_LastOrderPattern2

                Dec     BX
                Mov     Order, BX

PEFunction_LastOrderPattern2:
                MovZX   AX, Byte Ptr [ES:BX+0100h]
                Cmp     AL, 200
                JAE     PEFunction_LastOrderPattern1

                Mov     PatternNumber, AX

                Call    NewPattern

PEFunction_LastOrderPattern1:
                Mov     AX, 1
                Ret

EndP            PEFunction_LastOrderPattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_NextOrderPattern Far

                Cmp     PatternModified, 0
                JE      PEFunction_NextOrderPattern3

                Call    PEFunction_StorePattern

PEFunction_NextOrderPattern3:
                Mov     BX, Order

                Cmp     BX, 0FFh
                JAE     PEFunction_NextOrderPattern1

                Call    Music_GetSongSegment
                Mov     ES, AX
                Cmp     Byte Ptr [ES:BX+101h], 200
                JAE     PEFunction_NextOrderPattern2

                Inc     BX
                Mov     Order, BX

PEFunction_NextOrderPattern2:
                MovZX   AX, Byte Ptr [ES:BX+100h]
                Cmp     AL, 200
                JAE     PEFunction_NextOrderPattern1

                Mov     PatternNumber, AX

                Call    NewPattern

PEFunction_NextOrderPattern1:
                Mov     AX, 1
                Ret

EndP            PEFunction_NextOrderPattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Alt0 Far

                Xor     AX, AX
                Mov     SkipValue, AX
                Mov     SI, Offset CursorStepMsg
                Call    SetInfoLine

                Inc     AX

                Ret

EndP            PEFunction_Alt0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_BlockVolume Far

                Cmp     BlockMark, 0
                JE      PEFunction_NoBlockMarkedMessage

                Cmp     [Word Ptr LastKeyBoard2], 2F00h
                JE      PEFunction_BlockVolume3

                Mov     DI, 13
                Call    PE_AddToUndoBuffer
                Call    NetworkBlock

PEFunction_BlockVolume3:
                Mov     AX, 64
                Mul     BlockTop
                Add     AX, BlockLeft
                Mov     BX, 5
                Mul     BX

                Mov     SI, AX
                Mov     CX, BlockBottom
                Sub     CX, BlockTop
                Inc     CX

                Mov     DX, BlockRight
                Sub     DX, BlockLeft
                Inc     DX

                Mov     AL, LastVolume

                Mov     DS, PatternDataArea
                Add     SI, 2

PEFunction_BlockVolume1:
                Push    CX
                Push    SI

                Mov     CX, DX

PEFunction_BlockVolume2:
                Mov     [SI], AL

                Add     SI, 5
                Loop    PEFunction_BlockVolume2

                Pop     SI
                Pop     CX
                Add     SI, 320
                Loop    PEFunction_BlockVolume1

                Mov     AX, 1
                Ret

EndP            PEFunction_BlockVolume

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_WipeExcessVolumes Far

                Cmp     BlockMark, 0
                JE      PEFunction_NoBlockMarkedMessage

                Cmp     [Word Ptr LastKeyBoard2+2], 1100h
                JE      PEFunction_WipeExcessVolumesEnd

                Mov     DI, 14
                Call    PE_AddToUndoBuffer
                Call    NetworkBlock

                Mov     AX, 64
                Mul     BlockTop
                Add     AX, BlockLeft
                Mov     BX, 5
                Mul     BX
                Mov     SI, AX

                Mov     CX, BlockBottom
                Sub     CX, BlockTop
                Inc     CX

                Mov     DX, BlockRight
                Sub     DX, BlockLeft
                Inc     DX

                Mov     DS, PatternDataArea
                Mov     AL, 0FFh

PEFunction_WipeExcessVolumes1:
                Push    CX
                Push    SI

                Mov     CX, DX

PEFunction_WipeExcessVolumes2:
                Cmp     Byte Ptr [SI+1], 0
                JNE     PEFunction_WipeExcessVolumes3

                Cmp     Byte Ptr [SI], NONOTE
                JAE     PEFunction_WipeExcessVolumes4

PEFunction_WipeExcessVolumes3:
                Add     SI, 5
                Loop    PEFunction_WipeExcessVolumes2

                Pop     SI
                Pop     CX
                Add     SI, 320
                Loop    PEFunction_WipeExcessVolumes1

PEFunction_WipeExcessVolumesEnd:
                Mov     AX, 1
                Ret

PEFunction_WipeExcessVolumes4:
                Mov     [SI+2], AL
                Jmp     PEFunction_WipeExcessVolumes3

EndP            PEFunction_WipeExcessVolumes

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_PlayCurrentNote Far

                Mov     AX, 64
                Mul     Row
                Add     AX, Channel
                Mov     BX, 5
                Mul     BX
                Mov     SI, AX
                Mov     AX, Channel
                Mov     DS, PatternDataArea
                Mov     DH, 32
                Call    Music_PlayNote

IF CHORDENTRY
                Push    CS
                Pop     DS

                Cmp     ShiftPressed, 0
                JE      PE_GotoNextInput

                Push    SkipValue
                Mov     SkipValue, 0
                Mov     NoteEntered, 1

                Call    PE_GotoNextInput
                Pop     SkipValue

                Mov     AX, 1
                Ret
ELSE
                Jmp     PEFunction_Down
ENDIF

EndP            PEFunction_PlayCurrentNote

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_PlayCurrentRow Far

                Mov     CX, 64
                Mov     DS, PatternDataArea

                Mov     AX, 320
                Mul     CS:Row
                Mov     SI, AX
                Xor     AX, AX

PEFunction_PlayCurrentRow1:
;                Push    CX

;                Dec     CX
;                Mov     AX, 64
;                Mul     CS:Row
;                Add     AX, CX
;                Mov     BX, 5
;                Mul     BX
;                Mov     SI, AX
;                Mov     AX, CX
                Xor     DH, DH
                Call    Music_PlayNote

;                Pop     CX
                Inc     AX
                Add     SI, 5
                Loop    PEFunction_PlayCurrentRow1

                Jmp     PEFunction_Down

EndP            PEFunction_PlayCurrentRow

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_RestoreData Far

;                Mov     PatternModified, 0

                Cmp     Byte Ptr LastKeyBoard2, 0Eh
                JE      PEFunction_RestoreData1

                Mov     DI, 1
                Call    PE_AddToUndoBuffer

PEFunction_RestoreData1:
                Mov     AX, PatternNumber

                Call    Music_GetPattern
                Call    DecodePattern

                Xor     BX, BX
                Mov     CL, 64
                Mov     CH, Byte Ptr [CS:MaxRow]
                Inc     CH
                Call    NetworkPatternBlock

                Mov     AX, 1
                Ret

                Ret

EndP            PEFunction_RestoreData

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_ToggleDefaultVolume Far

                Xor     Flags, 1
                Mov     SI, Offset DefaultVolumeOn
                Test    Flags, 1
                JNZ     PEFunction_ToggleDefaultVolume1

                Mov     SI, Offset DefaultVolumeOff

PEFunction_ToggleDefaultVolume1:
                Call    SetInfoLine

                Mov     AX, 1
                Ret

EndP            PE_ToggleDefaultVolume

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_ToggleTemplate Far

                Test    CentraliseCursor, 4
                JZ      ToggleTemplate2

                Cmp     BlockMark, 0
                JE      PEFunction_NoBlockMarkedMessage

                        ; Amplification = 1/(FastVolumeAmplification/100)
                        ;               = 10050/FastvolumeAmplification
                Mov     AX, 10050
                Xor     DX, DX
                Div     FastVolumeAmplification
                Mov     Amplification, AX
                Jmp     PEFastVolumeAmp

ToggleTemplate2:
                Mov     AL, Template
                Inc     AX
                Cmp     AL, 4
                JBE     PEFunction_ToggleTemplate1

Proc            PEFunction_TemplateOff Far

                Xor     AL, AL

PEFunction_ToggleTemplate1:
                Mov     Template, AL

                Mov     AX, 1
                Ret

EndP            PEFunction_TemplateOff

EndP            PEFunction_ToggleTemplate

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_GetCurrentPattern Far

                Mov     AX, CS:PatternNumber
                Mov     BX, CS:MaxRow
                Inc     BX
                Mov     DS, CS:PatternDataArea

                Ret

EndP            PE_GetCurrentPattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_CheckWidth

                Xor     DX, DX                          ; Time to work out width
                Xor     CX, CX                          ; Count of channels.
                Mov     SI, Offset ViewChannels

PE_CheckWidth1:
                LodsW
                Cmp     AL, 0FFh
                JE      PE_CheckWidth2

                MovZX   BX, AH
                ShL     BX, 2
                Add     DX, [ViewMethodInfo+BX+2]
                Inc     CX
                Jmp     PE_CheckWidth1

PE_CheckWidth2:
                And     CX, CX
                JZ      PE_CheckWidth3

                Add     DX, 2

                Cmp     ViewDivision, 0
                JE      PE_CheckWidth3

                Dec     CX
                Add     DX, CX

PE_CheckWidth3:
                Cmp     DX, 76                  ; Too big to fit screen?
                JAE     PE_CheckWidth5

                Mov     ViewWidth, DX
                Xor     AX, AX
                Cmp     DX, 74
                JAE     PE_CheckWidth4

                Mov     AX, 74
                Sub     AX, DX
                Mov     BL, 14
                Div     BL
                Xor     AH, AH

PE_CheckWidth4:
                Mov     NumChannelsEdit, AX

                DB      85h     ;
PE_CheckWidth5:                 ;
                StC             ;
                Ret

EndP            PE_CheckWidth

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_ViewTrack Far

                Mov     DX, Channel
                Mov     SI, Offset ViewChannels

PEFunction_ViewTrack2:
                LodsW
                Cmp     AL, 0FFh                        ; No more in list??
                JE      PEFunction_ViewTrack1

                Cmp     AL, DL
                JNE     PEFunction_ViewTrack2

PEFunction_ViewTrack1:
                Sub     SI, 2

                Mov     CX, AX                          ; Store old value.
                Mov     AL, DL
                Inc     AH
                Cmp     AH, 4                           ; Number of view methods
                JBE     PEFunction_ViewTrack3

                LodsW

PEFunction_ViewTrack8:
                LodsW
                Mov     [SI-4], AX
                Cmp     AX, 0FFFFh
                JNE     PEFunction_ViewTrack8

                Jmp     PEFunction_ViewTrack9

PEFunction_ViewTrack3:
                Mov     [SI], AX                        ; Update...

PEFunction_ViewTrack9:
                Push    CX
                Push    SI

                Call    PE_CheckWidth
                JC      PEFunction_ViewTrack7

                Add     SP, 4
                Mov     AX, 1
                Ret

PEFunction_ViewTrack7:
                Pop     SI
                Pop     CX
                Mov     AX, [SI]
                Inc     AH
                Cmp     AH, 4                   ; Number of view methods
                JE      PEFunction_ViewTrack10

                Mov     [SI], AX

                Jmp     PEFunction_ViewTrack9

PEFunction_ViewTrack10:
                Mov     [SI], CX

                Mov     AX, 1
                Ret

EndP            PEFunction_ViewTrack

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_ClearViews Far

                Push    CS
                Pop     ES
                Mov     DI, Offset ViewChannels
                Mov     CX, 100
                Mov     AX, 0FFFFh
                Rep     StosW

                Mov     ViewWidth, 0
                Mov     AX, StartChannelEdit
                Mov     NumChannelsEdit, AX
                Mov     ViewChannelTracking, 0

                Mov     AX, 1
                Ret

EndP            PEFunction_ClearViews

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_SelectColour Near

                MovZX   AX, CL                  ; AL = row number

                Mov     CH, 0E6h
                Cmp     CS:RowHilight2, 0
                JE      PE_SelectColour4
                Div     CS:RowHilight2
                And     AH, AH
                JZ      PE_SelectColour1

PE_SelectColour4:
                MovZX   AX, CL
                Mov     CH, 0F6h
                Cmp     CS:RowHilight1, 0
                JE      PE_SelectColour5
                Div     CS:RowHiLight1
                And     AH, AH
                JZ      PE_SelectColour1

PE_SelectColour5:
                Mov     CH, 6

PE_SelectColour1:                       ; Check for block, CL = rownum, BP = ch
                MovZX   AX, CL          ; AX = row number
                Cmp     CS:BlockMark, 0
                JE      PE_SelectColour3
                Cmp     BP, CS:BlockLeft
                JB      PE_SelectColour3
                Cmp     BP, CS:BlockRight
                JA      PE_SelectColour3
                Cmp     AX, CS:BlockTop
                JB      PE_SelectColour3
                Cmp     AX, CS:BlockBottom
                JA      PE_SelectColour3

                Test    CH, 80h
                JZ      PE_SelectColour2

                Mov     CH, 96h
                Ret

PE_SelectColour2:
                Mov     CH, 86h
                Ret

PE_SelectColour3:
                Cmp     AX, CS:Row
                JNE     PE_SelectColour6

                Test    CS:CentraliseCursor, 2
                JZ      PE_SelectColour6

                Mov     CH, 16h

PE_SelectColour6:
                Ret

EndP            PE_SelectColour

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_HilightCursor Near

                Mov     AX, [ES:DI]
                And     AH, 8
                Or      AH, 30h
                StosW

                Ret

EndP            PE_HilightCursor

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_HilightView Near

                Mov     AX, 1
                Cmp     CS:Template, 0
                JE      PE_HilightView1

                Cmp     CS:ShiftPressed, 0
                JNE     PE_HilightView1

                Cmp     CS:PatternCursor, 0
                JNE     PE_HilightView1

                Cmp     CS:BlockDataArea, 0
                JE      PE_HilightView1

                Mov     FS, CS:BlockDataArea
                Mov     AX, [FS:0]

PE_HilightView1:
                Mov     CX, CS:Channel
                Cmp     DX, CX
                JB      PE_HilightViewEnd
                Add     CX, AX
                Cmp     DX, CX
                JAE     PE_HilightViewEnd

                Sub     DI, (32*160)
                Mov     AL, 160
                Mov     CX, CS:Row
                Sub     CX, CS:TopRow
                Mul     CL
                Add     DI, AX
                Add     BP, CS:PatternCursor

                Mov     CL, Byte Ptr [CS:BP]
                Mov     AX, CX
                And     AX, 0Fh

                Add     AX, AX
                Add     DI, AX

                Mov     DX, [ES:DI]
                Test    DH, 8
                JNZ     PE_HilightView4
                Cmp     DL, 184
                JE      PE_HilightView4
                Cmp     DL, 226
                JB      PE_HilightView2
                Cmp     DL, 246
                JAE     PE_HilightView2

PE_HilightView4:
                Mov     AH, 0Fh         ; mask value
                Cmp     CL, Byte Ptr [CS:BP+1]
                JE      PE_HilightView3

                Mov     AH, 0F0h

PE_HilightView3:
                Call    S_InvertCursor

                Mov     AX, 246+3000h
                StosW

PE_HilightViewEnd:
                Ret

PE_HilightView2:
                Mov     AX, [ES:DI]
                Mov     AH, 30h
                StosW

                Sub     CL, 10h
                JNC     PE_HilightView2

                Ret

EndP            PE_HilightView

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_GetChannelColour             ; Puts colour in AH
                                                ; Param: BP = channel

                Push    DS

                Call    Music_GetSongSegment
                Mov     DS, AX

                Mov     AH, 13h
                Test    Byte Ptr [DS:BP+40h], 80h
                JZ      PE_GetChannelColour1

                Mov     AH, 10h

PE_GetChannelColour1:
                Pop     DS

                Ret

EndP            PE_GetChannelColour

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ViewCommon

                Push    DS
                Push    ES
                Push    DI

                Mov     BP, DX
                And     BP, 0FFh

                Push    CS
                Pop     DS
                MovZX   AX, DL
                Inc     AX
                Mov     DX, 0A0Ch
                Div     DH
;                Mov     DL, 10
;                Div     DL

                Add     AX, 3030h
                Mov     [SI+BX], AX
                Sub     DI, 160
                Call    PE_GetChannelColour
                Call    S_DrawString

                Pop     DI
                Pop     ES
                Pop     DS

;                Mov     DX, 0A0Ch               ; DH = 10, DL = 12 (for div.)

                Mov     CH, 32

                Ret

EndP            ViewCommon

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


Proc            ViewFull                        ; DS:SI = pattern data
                                                ; ES:DI = screen pointer
                                                ; CS:BX = note data
                                                ; CX = row number
                                                ; DL = channel number.

                Push    SI
                Push    BX

                Mov     SI, Offset ChannelMsg
                Mov     BX, 9
                Call    ViewCommon

                Pop     BX
                Pop     SI

ViewFull1:
                Push    CX
                Push    DX
                Push    DI

                Call    PE_SelectColour

                LodsB
                Call    Draw_3Note
                Mov     AL, 20h
                StosW

                LodsB                           ; Instrument
                Call    Draw_2Instrument
                Mov     AL, 20h
                StosW

                LodsB                           ; Volume
                Cmp     AL, 0FFh
                JNE     ViewFull8

                Mov     AL, 173
                StosW
                StosW

                Jmp     ViewFull9

ViewFull8:
                Mov     AH, AL
                And     AH, 7Fh
                Sub     AH, 65
                JC      ViewFullNoVEffect

                Test    AL, 80h
                JZ      ViewFullVEffect1

                Add     AH, 60

ViewFullVEffect1:
                Mov     AL, AH
                Xor     AH, AH
                Div     DH
                                        ; AL = effect, AH = num
                Add     AX, 'A'+'0'*256
                Mov     CL, AH
                Mov     AH, CH
                StosW
                Mov     AL, CL
                StosW

                Jmp     ViewFull9

ViewFullNoVEffect:
                Mov     DL, CH

                Test    AL, 80h
                JZ      ViewFull12

                And     DL, 0F0h
                Or      DL, 2
                And     AL, 7Fh         ; Filter out panning stuff.

ViewFull12:
                Xor     AH, AH
                Div     DH
                Add     AX, 3030h
                Mov     CL, AH
                Mov     AH, DL
                StosW
                Mov     AL, CL
                StosW

                Mov     AH, CH

ViewFull9:
                Mov     AL, 20h
                StosW

                LodsB                           ; Command
                And     AL, AL
                JNZ     ViewFull10

                Mov     AL, '.'
                StosW
                Jmp     ViewFull11

ViewFull10:
                Add     AL, '@'
                StosW

ViewFull11:
                LodsB                           ; Command value

                AAM     16                      ; AH = High nibble, AL = low nibble
                Mov     CL, AL
                Mov     AL, AH
                Mov     AH, CH
                Call    PE_ConvHexAL

                Mov     AL, CL
                Call    PE_ConvHexAL

                Add     SI, 315
                Pop     DI
                Add     DI, 160
                Pop     DX
                Pop     CX
                Inc     CX
                Dec     CH
                JNZ     ViewFull1

                Mov     DX, BP
                Mov     BP, Offset CursorPositions
                Jmp     PE_HilightView

EndP            ViewFull

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ViewCompress                        ; DS:SI = pattern data
                                                ; ES:DI = screen pointer
                                                ; CS:BX = note data
                                                ; CX = row number
                                                ; DL = channel number.

                Push    SI
                Push    BX

                Mov     SI, Offset ChannelMsg2
                Mov     BX, 8
                Call    ViewCommon

                Pop     BX
                Pop     SI

ViewCompress1:
                Push    CX
                Push    DX
                Push    DI

                Call    PE_SelectColour

                LodsB

                Call    Draw_3Note

                LodsB                           ; Instrument
                Sub     CH, 4
                Call    Draw_2Instrument
                Add     CH, 4

                LodsB                           ; Volume
                Mov     AH, CH

                Cmp     AL, 0FFh
                JNE     ViewCompress8

                Mov     AL, 173
                StosW
                StosW

                Jmp     ViewCompress9

ViewCompress8:
                Mov     AH, AL
                And     AH, 7Fh
                Sub     AH, 65
                JC      ViewCompressNoVEffect

                Test    AL, 80h
                JZ      ViewCompressVEffect1

                Add     AH, 60

ViewCompressVEffect1:
                Mov     AL, AH
                Xor     AH, AH
                Div     DH
                                        ; AL = effect, AH = num
                Add     AX, 'A'+'0'*256
                Mov     CL, AH
                Mov     AH, CH
                StosW
                Mov     AL, CL
                StosW

                Jmp     ViewCompress9

ViewCompressNoVEffect:
                Mov     DL, CH

                Test    AL, 80h
                JZ      ViewCompress12

                And     DL, 0F0h
                Or      DL, 2
                And     AL, 7Fh         ; Filter out panning stuff.

ViewCompress12:
                Xor     AH, AH
                Div     DH
                Add     AX, 3030h
                Mov     CL, AH
                Mov     AH, DL
                StosW
                Mov     AL, CL
                StosW
                Mov     AH, CH

ViewCompress9:
                LodsB                           ; Command
                Sub     AH, 4
                And     AL, AL
                JNZ     ViewCompress10

                Mov     AL, '.'
                StosW
                Jmp     ViewCompress11

ViewCompress10:
                Add     AL, '@'
                StosW

ViewCompress11:
                LodsB                           ; Command value
                AAM     16                      ; AH = High nibble, AL = low nibble
                Mov     CL, AL
                Mov     AL, AH
                Mov     AH, CH
                Sub     AH, 4
                Call    PE_ConvHexAL

                Mov     AL, CL
                Call    PE_ConvHexAL

                Add     SI, 315
                Pop     DI
                Add     DI, 160
                Pop     DX
                Pop     CX
                Inc     CX
                Dec     CH
                JNZ     ViewCompress1

                Mov     DX, BP
                Mov     BP, Offset CursorPositions+9
                Jmp     PE_HilightView

EndP            ViewCompress

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ViewAllSmall                    ; DS:SI = pattern data
                                                ; ES:DI = screen pointer
                                                ; CS:BX = note data
                                                ; CX = row number
                                                ; DL = channel number.

                Push    SI
                Push    BX

                Mov     SI, Offset ChannelMsg7
                Mov     BX, 5
                Call    ViewCommon

                Pop     BX
                Pop     SI

ViewAllSmall1:
                Push    CX
                Push    DI

                Call    PE_SelectColour

                LodsB
                Call    Draw_3Note

                LodsB                           ; Instrument
                And     AL, AL
                JNZ     ViewAllSmall6

                Mov     AL, 184
                Sub     AH, 4
                StosW
                Jmp     ViewAllSmall7

ViewAllSmall6:
                Xor     AH, AH
                Div     DH
                ShL     AL, 4
                Or      AL, AH
                Mov     AH, CH
                Add     AH, 4
                StosW

ViewAllSmall7:
                LodsB                           ; Volume
                Cmp     AL, 0FFh
                JNE     ViewAllSmall8

                Mov     AL, 184
                Mov     AH, CH
                StosW

                Jmp     ViewAllSmall9

ViewAllSmall8:
                Mov     CL, CH
                Add     CL, 6

                Mov     AH, AL
                And     AH, 7Fh
                Sub     AH, 65
                JC      ViewAllSmallNoVEffect

                Test    AL, 80h
                JZ      ViewAllSmallVEffect1

                Mov     AL, AH
                Add     AL, 226
                Mov     AH, CH
                StosW
                Jmp     ViewAllSmall9

ViewAllSmallVEffect1:
                Mov     AL, AH
                Mov     AH, 0
                Div     DH
                                        ; AL = effect, AH = num
                Add     AL, 0Ah
                ShL     AL, 4
                Or      AL, AH
                Mov     AH, CL
                StosW

                Jmp     ViewAllSmall9

ViewAllSmallNoVEffect:
                Test    AL, 80h
                JZ      ViewAllSmall12

                Sub     CL, 2
                And     AL, 7Fh         ; Filter out panning stuff.

ViewAllSmall12:
                Xor     AH, AH
                Div     DH
                ShL     AL, 4
                Or      AL, AH
                Mov     AH, CL
                StosW

ViewAllSmall9:
                LodsB                           ; Command
                Mov     AH, CH
                Sub     AH, 4

                And     AL, AL
                JNZ     ViewAllSmall10

                Mov     AL, '.'
                StosW
                Jmp     ViewAllSmall11

ViewAllSmall10:
                Add     AL, '@'
                StosW

ViewAllSmall11:
                LodsB                           ; Command value
                Add     AH, 8
                StosW

                Add     SI, 315
                Pop     DI
                Add     DI, 160
                Pop     CX
                Inc     CX
                Dec     CH
                JNZ     ViewAllSmall1

                Mov     DX, BP
                Mov     BP, Offset CursorPositions+18
                Jmp     PE_HilightView

EndP            ViewAllSmall

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ViewNote                        ; DS:SI = pattern data
                                                ; ES:DI = screen pointer
                                                ; CS:BX = note data
                                                ; CX = row number
                                                ; DL = channel number.

                Push    SI
                Push    BX

                Mov     SI, Offset ChannelMsg4
                Mov     BX, 1
                Call    ViewCommon

                Pop     BX
                Pop     SI

ViewNote1:
                Push    CX
                Push    SI
                Push    DI

                Call    PE_SelectColour

                LodsB
                Cmp     AL, NONOTE
                JE      ViewNote4

                Call    Draw_3Note
                Jmp     ViewNoteEnd

ViewNote4:
                LodsB

                Test    AL, AL
                JZ      ViewNote5

                Push    AX

                Mov     AH, CH
                Mov     AL, 20h
                StosW

                Pop     AX

                Call    Draw_2Instrument
                Jmp     ViewNoteEnd

ViewNote5:                                      ; Volume
                LodsB
                Cmp     AL, 0FFh
                JE      ViewNote6

                Push    AX
                Mov     AH, CH
                Sub     AH, 4
                Mov     AL, 20h
                StosW
                Pop     AX

                Mov     AH, AL
                And     AH, 7Fh
                Sub     AH, 65
                JC      ViewNoteNoVEffect

                Test    AL, 80h
                JZ      ViewNoteVEffect1

                Add     AH, 60

ViewNoteVEffect1:
                Mov     AL, AH
                Xor     AH, AH
                Div     DH
                                        ; AL = effect, AH = num
                Add     AX, 'A'+'0'*256
                Mov     CL, AH
                Mov     AH, CH
                StosW
                Mov     AL, CL
                StosW

                Jmp     ViewNoteEnd

ViewNoteNoVEffect:
                Mov     CL, CH
                Sub     CL, 4

                Test    AL, 80h
                JZ      ViewNote25

                Dec     CX
                And     AL, 7Fh

ViewNote25:
                Xor     AH, AH
                Div     DH
                Add     AX, 3030h
                XChg    CL, AH
                StosW
                Mov     AL, CL
                StosW

                Jmp     ViewNoteEnd

ViewNote6:
                LodsW
                And     AX, AX
                JZ      ViewNote11

                Mov     CL, AH
                And     AL, AL
                JZ      ViewNote7

                Add     AL, '@'
                Jmp     ViewNote8

ViewNote7:
                Mov     AL, '.'

ViewNote8:
                Mov     AH, CH
                Sub     AH, 4
                StosW

                Mov     AL, CL
                AAM     16                      ; AH = High nibble, AL = low nibble
                Mov     CL, AL
                Mov     AL, AH
                Mov     AH, CH
                Sub     AH, 4
                Call    PE_ConvHexAL

                Mov     AL, CL
                Call    PE_ConvHexAL

                Jmp     ViewNoteEnd

ViewNote11:                             ; Nothing to show except dots...
                Mov     AH, CH
                Mov     AL, 173
                StosW
                StosW
                StosW

ViewNoteEnd:

                Pop     DI
                Add     DI, 160
                Pop     SI
                Add     SI, 320
                Pop     CX
                Inc     CX
                Dec     CH
                JNZ     ViewNote1

                Cmp     BP, CS:Channel
                JE      ViewNote12

                Mov     DX, BP
                Mov     BP, Offset CursorPositions+27
                Jmp     PE_HilightView

                Ret

ViewNote12:
                Push    DI

                Sub     SI, (320*32)
                Sub     DI, (32*160)
                Mov     AL, 160
                Mov     DX, CS:Row
                Sub     DX, CS:TopRow

                Mul     DL
                Add     DI, AX
                Add     AX, AX
                Add     SI, AX

                Mov     CX, CS:Row
                Call    PE_SelectColour         ; CH = colour.

                Mov     DX, CS:PatternCursor

ViewNote13:
                LodsB
                Cmp     DL, 1
                JA      ViewNote16

                Cmp     AL, NONOTE
                JNE     ViewNote15

                Mov     AH, CH
                Mov     AL, 173
                StosW
                StosW
                StosW

ViewNote15:
                Jmp     ViewNoteEndHilight

ViewNote16:
                LodsB
                Cmp     DL, 3
                JA      ViewNote19

                Mov     DH, AL

                Mov     AH, CH
                Mov     AL, 20h
                StosW
                And     DH, DH
                JZ      ViewNote17

                MovZX   AX, DH
                Mov     DH, 10
                Div     DH

                Add     AX, 3030h
                Mov     DH, AH
                Mov     AH, CH
                StosW
                Mov     AL, DH
                StosW
                Jmp     ViewNoteEndHilight

ViewNote17:
                Mov     AL, 173
                StosW
                StosW
                Jmp     ViewNoteEndHilight

ViewNote19:
                LodsB
                Cmp     DL, 5
                JA      ViewNote22

                Mov     DH, AL

                Mov     AH, CH
                Sub     AH, 4
                Mov     AL, 20h
                StosW

                Cmp     DH, 0FFh
                JE      ViewNote20

                Mov     AH, DH
                And     AH, 7Fh
                Sub     AH, 65
                JC      ViewNoteNoVEffect2

                Test    DH, 80h
                JZ      ViewNoteVEffect2

                Add     AH, 60

ViewNoteVEffect2:
                Mov     AL, AH
                Xor     AH, AH
                Mov     DH, 10
                Div     DH
                                        ; AL = effect, AH = num
                Add     AX, 'A'+'0'*256
                Mov     CL, AH
                Mov     AH, CH
                StosW
                Mov     AL, CL
                StosW

                Jmp     ViewNoteEndHilight

ViewNoteNoVEffect2:
                Sub     CH, 4

                Test    DH, 80h
                JZ      ViewNote26

                Dec     CH
                And     DH, 7Fh

ViewNote26:
                MovZX   AX, DH
                Mov     DH, 10
                Div     DH

                Add     AX, 3030h
                XChg    CH, AH
                StosW
                Mov     AL, CH
                StosW
                Jmp     ViewNoteEndHilight

ViewNote20:
                Mov     AL, 173
                StosW
                StosW
                Jmp     ViewNoteEndHilight

ViewNote22:
                LodsB
                Mov     AH, CH
                Sub     AH, 4
                And     AL, AL
                JNZ     ViewNote23

                Mov     AL, '.'
                Jmp     ViewNote24

ViewNote23:
                Add     AL, '@'

ViewNote24:
                Mov     AH, CH
                Sub     AH, 4
                StosW

                LodsB
                AAM     16                      ; AH = High nibble, AL = low nibble
                Mov     CL, AL
                Mov     AL, AH
                Mov     AH, CH
                Sub     AH, 4
                Call    PE_ConvHexAL

                Mov     AL, CL
                Call    PE_ConvHexAL

ViewNoteEndHilight:
                Pop     DI

                Mov     DX, BP
                Mov     BP, Offset CursorPositions+27
                Jmp     PE_HilightView


EndP            ViewNote

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ViewTiny                        ; DS:SI = pattern data
                                                ; ES:DI = screen pointer
                                                ; CS:BX = note data
                                                ; CX = row number
                                                ; DL = channel number.

                Push    SI
                Push    BX

                Mov     SI, Offset ChannelMsg5
                Mov     BX, 0
                Call    ViewCommon

                Pop     BX
                Pop     SI

ViewTiny1:
                Push    CX
                Push    SI
                Push    DI

                Call    PE_SelectColour

                LodsB
                Cmp     AL, NONOTE
                JE      ViewTiny4

                Call    Draw_2Note
                Jmp     ViewTinyEnd

ViewTiny4:
                LodsB
                Test    AL, AL
                JZ      ViewTiny5

                Call    Draw_2Instrument
                Jmp     ViewTinyEnd

ViewTiny5:                                      ; Volume
                LodsB
                Cmp     AL, 0FFh
                JE      ViewTiny6

                Mov     AH, AL
                And     AH, 7Fh
                Sub     AH, 65
                JC      ViewTinyNoVEffect

                Test    AL, 80h
                JZ      ViewTinyVEffect1

                Add     AH, 60

ViewTinyVEffect1:
                Mov     AL, AH
                Xor     AH, AH
                Div     DH
                                        ; AL = effect, AH = num
                Add     AX, 'A'+'0'*256
                Mov     CL, AH
                Mov     AH, CH
                StosW
                Mov     AL, CL
                StosW

                Jmp     ViewTinyEnd

ViewtinyNoVEffect:
                Mov     CL, CH
                Sub     CL, 4

                Test    AL, 80h
                JZ      ViewTiny27

                Dec     CX
                And     AL, 7Fh

ViewTiny27:
                Xor     AH, AH
                Div     DH
                Add     AX, 3030h
                XChg    AH, CL
                StosW
                Mov     AL, CL
                StosW

                Jmp     ViewTinyEnd

ViewTiny6:
                LodsW
                And     AX, AX
                JZ      ViewTiny11

                Mov     CL, AH
                And     AL, AL
                JZ      ViewTiny7

                Add     AL, '@'
                Jmp     ViewTiny8

ViewTiny7:
                Mov     AL, '.'

ViewTiny8:
                Mov     AH, CH
                Sub     AH, 4
                StosW
                Add     AH, 8
                Mov     AL, CL
                StosW

                Jmp     ViewTinyEnd

ViewTiny11:                             ; Nothing to show except dots...
                Mov     AH, CH
                Mov     AL, 173
                StosW
                StosW

ViewTinyEnd:

                Pop     DI
                Pop     SI
                Pop     CX

                Add     DI, 160
                Inc     CX
                Add     SI, 320

                Dec     CH
                JNZ     ViewTiny1

                Cmp     BP, CS:Channel
                JE      ViewTiny14

                Mov     DX, BP
                Mov     BP, Offset CursorPositions+36
                Jmp     PE_HilightView

ViewTiny14:
                Push    DI

                Sub     SI, (32*320)
                Sub     DI, (32*160)
                Mov     AL, 160
                Mov     CX, CS:Row
                Sub     CX, CS:TopRow
                Mul     CL
                Add     DI, AX
                Add     AX, AX
                Add     SI, AX

                Mov     CX, CS:Row
                Call    PE_SelectColour         ; CH = colour.

                Mov     DX, CS:PatternCursor
                LodsB
                Cmp     DL, 1
                JA      ViewTiny17

                Cmp     AL, NONOTE
                JE      ViewTinyDots

                Jmp     ViewTinyEndHilight

ViewTiny17:
                LodsB                           ; Instrument
                Cmp     DL, 3
                JA      ViewTiny20

                And     AL, AL
                JZ      ViewTinyDots

                Mov     DH, 10
                Xor     AH, AH
                Div     DH
                Add     AX, 3030h
                Mov     DH, AH
                Mov     AH, CH
                StosW
                Mov     AL, DH
                StosW
                Jmp     ViewTinyEndHilight

ViewTiny20:
                LodsB                           ; Volume
                Cmp     DL, 5
                JA      ViewTiny23

                Cmp     AL, 0FFh
                JE      ViewTiny21

                Mov     AH, AL
                And     AH, 7Fh
                Sub     AH, 65
                JC      ViewTinyNoVEffect2

                Test    AL, 80h
                JZ      ViewTinyVEffect2

                Add     AH, 60

ViewTinyVEffect2:
                Mov     AL, AH
                Xor     AH, AH
                Mov     DH, 10
                Div     DH
                                        ; AL = effect, AH = num
                Add     AX, 'A'+'0'*256
                Mov     CL, AH
                Mov     AH, CH
                StosW
                Mov     AL, CL
                StosW

                Jmp     ViewTinyEndHilight

ViewTinyNoVEffect2:
                Sub     CH, 4
                Test    AL, 80h
                JZ      ViewTiny28

                Dec     CH
                And     AL, 7Fh

ViewTiny28:
                Mov     DH, 10
                Xor     AH, AH
                Div     DH
                Add     AX, 3030h
                XChg    CH, AH
                StosW
                Mov     AL, CH
                StosW
                Jmp     ViewTinyEndHilight

ViewTiny21:
                Sub     CH, 4

ViewTinyDots:
                Mov     AH, CH
                Mov     AL, 173
                StosW
                StosW
                Jmp     ViewTinyEndHilight

ViewTiny23:
                LodsB                           ; CommandValue.
                And     AL, AL
                JNZ     ViewTiny24

                Mov     AL, '.'
                Jmp     ViewTiny25

ViewTiny24:
                Add     AL, '@'

ViewTiny25:
                Mov     AH, CH
                Sub     AH, 4
                StosW

                Add     AH, 8
                LodsB
                StosW

ViewTinyEndHilight:
                Pop     DI

                Mov     DX, BP
                Mov     BP, Offset CursorPositions+36
                Jmp     PE_HilightView

EndP            ViewTiny

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_ToggleDivision Far

                Xor     ViewDivision, 1

                Call    PE_CheckWidth
                JC      PEFunction_ToggleDivision1

                Mov     AX, 1
                Ret

PEFunction_ToggleDivision1:
                Xor     ViewDivision, 1

                Mov     AX, 1
                Ret

EndP            PEFunction_ToggleDivision

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Ctrl0 Far

                Mov     AX, 0
                Jmp     PE_FastView

EndP            PEFunction_Ctrl0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Ctrl1 Far

                Mov     AX, 1
                Jmp     PE_FastView

EndP            PEFunction_Ctrl1

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Ctrl2 Far

                Mov     AX, 2
                Jmp     PE_FastView

EndP            PEFunction_Ctrl2

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Ctrl3 Far

                Mov     AX, 3
                Jmp     PE_FastView

EndP            PEFunction_Ctrl3

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Ctrl4 Far

                Mov     AX, 4
                Jmp     PE_FastView

EndP            PEFunction_Ctrl4

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Ctrl5 Far

                Mov     AX, 5
                Jmp     PE_FastView

EndP            PEFunction_Ctrl5

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_QuickViewSetup Far           ; CX = num with div
                                                        ; BX = num without div
                                                        ; AH = type.
                Cmp     ViewDivision, 0
                JNE     PEFunction_QuickViewSetup1

                Mov     CX, BX
                Mov     BX, 100
                Sub     BX, CX

PEFunction_QuickViewSetup1:
                Push    CS
                Pop     ES
                Mov     DI, Offset ViewChannels

PEFunction_QuickViewSetup3:
                StosW

                Inc     AL
                Loop    PEFunction_QuickViewSetup3

                Mov     CX, BX
                Mov     AX, 0FFFFh
                Rep     StosW

                Call    PE_CheckWidth

                Cmp     ViewChannelTracking, 0
                JNE     PEFunction_QuickViewSetup2

                Call    PEFunction_ToggleTracking

PEFunction_QuickViewSetup2:

                Mov     AX, 1
                Ret

EndP            PEFunction_QuickViewSetup

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Ctrl_Shift1 Far

                Mov     AX, 100h
                Mov     BX, 7
                Mov     CX, 6
                Jmp     PEFunction_QuickViewSetup

EndP            PEFunction_Ctrl_Shift1

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Ctrl_Shift2 Far

                Mov     AX, 200h
                Mov     BX, 10
                Mov     CX, 9
                Jmp     PEFunction_QuickViewSetup

EndP            PEFunction_Ctrl_Shift2

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Ctrl_Shift3 Far

                Mov     AX, 300h
                Mov     BX, 24
                Mov     CX, 18
                Jmp     PEFunction_QuickViewSetup

EndP            PEFunction_Ctrl_Shift3

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Ctrl_Shift4 Far

                Mov     AX, 400h
                Mov     BX, 36
                Mov     CX, 24
                Jmp     PEFunction_QuickViewSetup

EndP            PEFunction_Ctrl_Shift4

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_FastView Far

                Dec     AX              ; AL = viewmethod
                Mov     CL, AL
                Mov     BX, Channel
                Mov     SI, Offset ViewChannels

                Cmp     CL, 0FFh
                JE      PE_FastView4

PE_FastView1:
                LodsW
                Cmp     AL, 0FFh
                JE      PE_FastView2

                Cmp     AL, BL
                JE      PE_FastView2
                Jmp     PE_FastView1

PE_FastView2:
                Sub     SI, 2
                Push    AX
                Push    SI

                Mov     AL, BL
                Mov     AH, CL
                Mov     [SI], AX

                Call    PE_CheckWidth
                JC      PE_FastView3

                Add     SP, 4
                Mov     AX, 1
                Ret

PE_FastView3:
                Pop     SI
                Pop     AX
                Mov     [SI], AX

                Mov     AX, 1
                Ret

PE_FastView4:
                LodsW
                Cmp     AL, 0FFh
                JE      PE_FastView6

                Cmp     AL, BL
                JNE     PE_FastView4

PE_FastView5:
                LodsW
                Mov     [SI-4], AX
                Cmp     AX, 0FFFFh
                JNE     PE_FastView5

                Call    PE_CheckWidth

PE_FastView6:
                Mov     AX, 1
                Ret

EndP            PE_FastView

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_ViewLeft Far
                                                ; First find current channel.
                Mov     DX, Channel
                Mov     SI, Offset ViewChannels

PEFunction_ViewLeft1:
                LodsW
                Cmp     AL, 0FFh
                JE      PEFunction_ViewLeft2

                Cmp     AL, DL
                JNE     PEFunction_ViewLeft1

                Cmp     SI, Offset ViewChannels+2
                JE      PEFunction_ViewLeft2

                Mov     DL, [SI-4]
                Mov     Channel, DX

PEFunction_ViewLeft2:                           ; Else decrease channel
                Mov     AX, 1
                Ret

EndP            PEFunction_ViewLeft

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_ViewRight Far

                Mov     DX, Channel
                Mov     SI, Offset ViewChannels

PEFunction_ViewRight1:
                LodsW
                Cmp     AL, 0FFh
                JE      PEFunction_ViewRight2

                Cmp     AL, DL
                JNE     PEFunction_ViewRight1

                LodsW
                Cmp     AL, 0FFh
                JE      PEFunction_ViewRight2

                Xor     AH, AH
                Mov     Channel, AX

PEFunction_ViewRight2:
                Mov     AX, 1
                Ret

EndP            PEFunction_ViewRight

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_AltRight Far

                Mov     AX, Channel
                Inc     AX
                Cmp     AX, 64
                JAE     PEFunction_AltRight1

                Mov     Channel, AX

PEFunction_AltRight1:
                Mov     AX, 1
                Ret

EndP            PEFunction_AltRight

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_AltLeft Far

                Mov     AX, Channel
                And     AX, AX
                JZ      PEFunction_AltLeft1

                Dec     AX
                Mov     Channel, AX

PEFunction_AltLeft1:
                Mov     AX, 1
                Ret

EndP            PEFunction_AltLeft

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Ctrl_Home Far

                Mov     AX, Row
                Sub     AL, 1
                AdC     AL, 0
                Mov     Row, AX

                Mov     AX, 1
                Ret

EndP            PEFunction_Ctrl_Home

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Ctrl_End Far

                Mov     AX, Row
                Cmp     AX, MaxRow
                AdC     AX, 0
                Mov     Row, AX

                Mov     AX, 1
                Ret

EndP            PEFunction_Ctrl_End

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_AltUp Far

                Mov     AX, TopRow
                Mov     BX, Row
                Test    AX, AX
                JZ      PEFunction_AltUp1

                Dec     AX
                Mov     TopRow, AX
                Sub     BX, AX
                Cmp     BX, 32
                JB      PEFunction_AltUp1

                Dec     Row

PEFunction_AltUp1:
                Mov     AX, 1
                Ret

EndP            PEFunction_AltUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_AltDown Far

                Mov     AX, TopRow
                Mov     BX, MaxRow

                Inc     AX
                Sub     BX, AX
                Cmp     BX, 31
                JB      PEFunction_AltDown1

                Mov     TopRow, AX
                Cmp     AX, Row
                JBE     PEFunction_AltDown1

                Mov     Row, AX

PEFunction_AltDown1:
                Mov     AX, 1
                Ret

EndP            PEFunction_AltDown

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_GetLastInstrument Far

                MovZX   BX, [CS:LastInstrument]
                Dec     BX
                Ret

EndP            PE_GetLastInstrument

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_SwapInstruments Far                   ; DH/DL = instruments
                                                         ; to swap.
                Call    Music_GetSongSegment
                Mov     DS, AX
                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     TempVariableArea2, DX
                Mov     AX, PatternNumber
                Mov     TempVariableArea, AX
                Call    PEFunction_StorePattern

                Call    PE_GetMaxPattern
                Inc     AX
                Mov     TempVariableArea4, AX           ; 1=OldPattern
                                                        ; 2=Instrument swap
                                                        ; 3=Current pattern
                                                        ; 4=Max pattern

                                                        ; OK...
                Mov     AL, 1
                Call    S_SetDirectMode

                                                        ; Draw Box first...
                Call    S_DrawSmallBox

                Mov     TempVariableArea3, 0
                        Assume DS:Nothing

PE_SwapInstruments1:                            ; Draw % Complete on screen first
                Mov     AX, 100
                Mul     TempVariableArea3
                Div     TempVariableArea4       ; AX = percentage

                Push    AX

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     SI, Offset CompleteMsg
                Mov     DI, (34+26*80)*2
                Mov     AH, 20h
                Call    S_DrawString
                Add     SP, 2                   ; OK message is on screen.


                Mov     AX, TempVariableArea3
                Mov     PatternNumber, AX
                        Assume DS:Nothing

                Call    Music_GetPattern
                Call    DecodePattern           ; Next pattern should be in mem

                Mov     AX, MaxRow
                Inc     AX
                Mov     CX, 64
                Mul     CX
                                                ; AX = number of "blocks"
                Mov     CX, AX
                Mov     DX, TempVariableArea2

                Mov     DS, PatternDataArea
                Mov     SI, 1

PE_SwapInstruments3:
                Mov     AL, [SI]
                Cmp     AL, DL
                JNE     PE_SwapInstruments4

                Mov     AL, DH
                And     AL, 7Fh
                Mov     [SI], AL
                Jmp     PE_SwapInstruments5

PE_SwapInstruments4:
                Test    DH, 80h
                JNZ     PE_SwapInstruments5

                Cmp     AL, DH
                JNE     PE_SwapInstruments5

                Mov     [SI], DL

PE_SwapInstruments5:
                Add     SI, 5
                Loop    PE_SwapInstruments3

                Push    CS
                Pop     DS

                Mov     AX, TempVariableArea3
                Call    PEFunction_StorePattern
                                                ; OK.. onto next pattern

                Mov     AX, TempVariableArea3
                Inc     AX
                Cmp     AX, TempVariableArea4
                JAE     PE_SwapInstruments2

                Mov     TempVariableArea3, AX
                Jmp     PE_SwapInstruments1

PE_SwapInstruments2:
                Mov     AL, 0
                Call    S_SetDirectMode

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     AX, TempVariableArea
                Mov     PatternNumber, AX
                Call    Music_GetPattern
                Call    DecodePattern

                Ret

EndP            PE_SwapInstruments
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_InsertInstrument Far                  ; DL = instrument

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     TempVariableArea2, DX
                Mov     AX, PatternNumber
                Mov     TempVariableArea, AX
                Call    PEFunction_StorePattern

                Call    PE_GetMaxPattern
                Inc     AX
                Mov     TempVariableArea4, AX           ; 1=OldPattern
                                                        ; 2=Instrument swap
                                                        ; 3=Current pattern
                                                        ; 4=Max pattern

                                                        ; OK...
                Mov     AL, 1
                Call    S_SetDirectMode

                                                        ; Draw Box first...
                Call    S_DrawSmallBox

                Mov     TempVariableArea3, 0
                        Assume DS:Nothing

PE_InsertInstrument1:                   ; Draw % Complete on screen first
                Mov     AX, 100
                Mul     TempVariableArea3
                Div     TempVariableArea4       ; AX = percentage

                Push    AX

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     SI, Offset CompleteMsg
                Mov     DI, (34+26*80)*2
                Mov     AH, 20h
                Call    S_DrawString
                Add     SP, 2                   ; OK message is on screen.


                Mov     AX, TempVariableArea3
                Mov     PatternNumber, AX
                        Assume DS:Nothing

                Call    Music_GetPattern
                Call    DecodePattern           ; Next pattern should be in mem

                Mov     AX, MaxRow
                Inc     AX
                Mov     CX, 64
                Mul     CX
                                                ; AX = number of "blocks"
                Mov     CX, AX
                Mov     DX, TempVariableArea2

                Mov     DS, PatternDataArea
                Mov     SI, 1

PE_InsertInstrument3:
                Cmp     [SI], DL
                JB      PE_InsertInstrument4

                Cmp     Byte Ptr [SI], 99
                JAE     PE_InsertInstrument4

                Inc     Byte Ptr [SI]

PE_InsertInstrument4:
                Add     SI, 5
                Loop    PE_InsertInstrument3

                Push    CS
                Pop     DS

                Mov     AX, TempVariableArea3
                Call    PEFunction_StorePattern
                                                ; OK.. onto next pattern

                Mov     AX, TempVariableArea3
                Inc     AX
                Cmp     AX, TempVariableArea4
                JAE     PE_InsertInstrument2

                Mov     TempVariableArea3, AX
                Jmp     PE_InsertInstrument1

PE_InsertInstrument2:
                Mov     AL, 0
                Call    S_SetDirectMode

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     AX, TempVariableArea
                Mov     PatternNumber, AX
                Call    Music_GetPattern
                Call    DecodePattern

                Ret

EndP            PE_InsertInstrument
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_DeleteInstrument Far                  ; DL = instrument

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     TempVariableArea2, DX
                Mov     AX, PatternNumber
                Mov     TempVariableArea, AX
                Call    PEFunction_StorePattern

                Call    PE_GetMaxPattern
                Inc     AX
                Mov     TempVariableArea4, AX           ; 1=OldPattern
                                                        ; 2=Instrument swap
                                                        ; 3=Current pattern
                                                        ; 4=Max pattern

                                                        ; OK...
                Mov     AL, 1
                Call    S_SetDirectMode

                                                        ; Draw Box first...
                Call    S_DrawSmallBox

                Mov     TempVariableArea3, 0
                        Assume DS:Nothing

PE_DeleteInstrument1:                   ; Draw % Complete on screen first
                Mov     AX, 100
                Mul     TempVariableArea3
                Div     TempVariableArea4       ; AX = percentage

                Push    AX

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     SI, Offset CompleteMsg
                Mov     DI, (34+26*80)*2
                Mov     AH, 20h
                Call    S_DrawString
                Add     SP, 2                   ; OK message is on screen.


                Mov     AX, TempVariableArea3
                Mov     PatternNumber, AX
                        Assume DS:Nothing

                Call    Music_GetPattern
                Call    DecodePattern           ; Next pattern should be in mem

                Mov     AX, MaxRow
                Inc     AX
                Mov     CX, 64
                Mul     CX
                                                ; AX = number of "blocks"
                Mov     CX, AX
                Mov     DX, TempVariableArea2

                Mov     DS, PatternDataArea
                Mov     SI, 1

PE_DeleteInstrument3:
                Cmp     [SI], DL
                JB      PE_DeleteInstrument4

                Dec     Byte Ptr [SI]

PE_DeleteInstrument4:
                Add     SI, 5
                Loop    PE_DeleteInstrument3

                Push    CS
                Pop     DS

                Mov     AX, TempVariableArea3
                Call    PEFunction_StorePattern
                                                ; OK.. onto next pattern

                Mov     AX, TempVariableArea3
                Inc     AX
                Cmp     AX, TempVariableArea4
                JAE     PE_DeleteInstrument2

                Mov     TempVariableArea3, AX
                Jmp     PE_DeleteInstrument1

PE_DeleteInstrument2:
                Mov     AL, 0
                Call    S_SetDirectMode

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     AX, TempVariableArea
                Mov     PatternNumber, AX
                Call    Music_GetPattern
                Call    DecodePattern

                Ret

EndP            PE_DeleteInstrument
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_UpdateInstruments Far                 ; ES:DI = instrument table
                                                         ; DL = instrument number
                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     Byte Ptr TempVariableArea2, DL
                Mov     AX, PatternNumber
                Mov     TempVariableArea, AX
                Mov     TempVariableArea5, ES
                Mov     TempVariableArea6, DI
                Call    PEFunction_StorePattern

                Call    PE_GetMaxPattern
                Inc     AX
                Mov     TempVariableArea4, AX           ; 1=OldPattern
                                                        ; 2=Instrument
                                                        ; 3=Current pattern
                                                        ; 4=Max pattern
                                                        ; 5=ES
                                                        ; 6=DI

                Mov     AL, 1
                Call    S_SetDirectMode

                                                        ; Draw Box first...
                Call    S_DrawSmallBox

                Mov     TempVariableArea3, 0
                        Assume DS:Nothing

PE_UpdateInstruments1:                            ; Draw % Complete on screen first
                Mov     AX, 100
                Mul     TempVariableArea3
                Div     TempVariableArea4       ; AX = percentage

                Push    AX

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     SI, Offset CompleteMsg
                Mov     DI, (34+26*80)*2
                Mov     AH, 20h
                Call    S_DrawString
                Pop     AX                      ; Remove AX from stack

                Mov     AX, TempVariableArea3
                Mov     PatternNumber, AX
                        Assume DS:Nothing

                Call    Music_GetPattern
                Call    DecodePattern           ; Next pattern should be in mem

                Mov     AX, MaxRow
                Inc     AX
                Mov     CX, 64
                Mul     CX
                                                ; AX = number of "blocks"
                Mov     CX, AX
                Mov     BL, CS:Byte Ptr TempVariableArea2
                Mov     ES, CS:TempVariableArea5

                Mov     DS, PatternDataArea
                Xor     SI, SI

PE_UpdateInstruments3:
                LodsW
                Cmp     AL, NONOTE
                JAE     PE_UpdateInstrument4

                And     AH, AH                  ; AH = instrument
                JZ      PE_UpdateInstrument4

                Xor     DX, DX
                Mov     DI, CS:TempVariableArea6

PE_UpdateInstrument5:
                Cmp     AX, [ES:DI]
                JE      PE_UpdateInstrument7

;                Add     DI, 2
                ScasW
                Inc     DX                      ; Not it...
                Cmp     DX, 120
                JB      PE_UpdateInstrument5

                Jmp     PE_UpdateInstrument4

PE_UpdateInstrument7:
                Mov     DH, BL
                Mov     [DS:SI-2], DX


PE_UpdateInstrument4:
                Add     SI, 3
                Loop    PE_UpdateInstruments3

                Push    CS
                Pop     DS

                Mov     AX, TempVariableArea3
                Call    PEFunction_StorePattern
                                                ; OK.. onto next pattern

                Mov     AX, TempVariableArea3
                Inc     AX
                Cmp     AX, TempVariableArea4
                JAE     PE_UpdateInstruments2

                Mov     TempVariableArea3, AX
                Jmp     PE_UpdateInstruments1

PE_UpdateInstruments2:
                Mov     AL, 0
                Call    S_SetDirectMode

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     AX, TempVariableArea
                Mov     PatternNumber, AX
                Call    Music_GetPattern
                Call    DecodePattern

                Ret

EndP            PE_UpdateInstruments
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Alt_F9 Far
                Assume DS:Pattern

                Mov     AX, Channel
                Call    Music_ToggleChannel

                Mov     AX, 1
                Ret

EndP            PEFunction_Alt_F9
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_MuteNext Far
                Assume DS:Pattern

                Call    PEFunction_Alt_F9
                Jmp     PEFunction_Tab

EndP            PEFunction_MuteNext

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_MutePrevious Far
                Assume DS:Pattern

                Sub     Channel, 1
                AdC     Channel, 0
                Jmp     PEFunction_Alt_F9

EndP            PEFunction_MutePrevious

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Alt_F10 Far
                Assume DS:Pattern

                Mov     AX, Channel
                Call    Music_SoloChannel

                Mov     AX, 1
                Ret

EndP            PEFunction_Alt_F10
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_SoloGotoNext Far

                Call    PEFunction_Alt_F10
                Jmp     PEFunction_Tab

EndP            PEFunction_SoloGotoNext

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_UnmuteAll Far

                Call    Music_UnmuteAll

                Mov     AX, 1
                Ret

EndP            PEFunction_UnmuteAll

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_ShowOrder Far                        ; DX = order.

                Call    S_GetDestination
                Mov     CX, 32

                Mov     DI, (2+15*80)*2+1
                Mov     BX, TopOrder

PE_ShowOrder1:
                Mov     AL, 23h
                Cmp     BX, DX
                JE      PE_ShowOrder2

                Mov     AL, 20h

PE_ShowOrder2:
                StosB
                Inc     DI
                StosB
                Inc     DI
                StosB

                Add     DI, 155
                Inc     BX
                Loop    PE_ShowOrder1

                Ret

EndP            PE_ShowOrder

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_PlayCurrentPosition Far
                Assume DS:Pattern

                Call    I_ClearTables

                Mov     AX, PatternNumber
                Mov     BX, MaxRow
                Inc     BX
                Mov     CX, Row

                Call    Music_PlayPattern

                Mov     AX, 1
                Ret

EndP            PE_PlayCurrentPosition
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_SetPlayMark Far
                Assume DS:Pattern

                Cmp     PlayMarkOn, 1     ; If on..
                JNE     PEFunction_SetPlayMarkNew

                Mov     AX, PatternNumber
                Cmp     AX, PlayMarkPattern
                JNE     PEFunction_SetPlayMarkNew

                Mov     AX, Row
                Cmp     AX, PlayMarkRow
                JNe     PEFunction_SetPlayMarkNew

                Mov     PlayMarkOn, 0
                Jmp     PEFunction_SetPlayMarkEnd

PEFunction_SetPlayMarkNew:
                Mov     PlayMarkOn, 1
                Mov     AX, PatternNumber
                Mov     PlayMarkPattern, AX
                Mov     AX, Row
                Mov     PlayMarkRow, AX

PEFunction_SetPlayMarkEnd:
                Mov     AX, 1
                Ret

EndP            PEFunction_SetPlayMark
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_F7 Far                       ; If no mark is set, use
                                                ; current pattern & row
                Call    I_ClearTables

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     CX, PatternNumber
                Mov     BX, Row

                Cmp     PlayMarkOn, 1
                JNE     PE_F7_1

                Mov     CX, PlayMarkPattern
                Mov     BX, PlayMarkRow

PE_F7_1:
                Mov     SI, Order

                Call    Music_GetSongSegment
                Mov     ES, AX

                Cmp     CL, [ES:SI+100h]
                JNE     PE_F7_3

                Mov     AX, SI
                Jmp     PE_F7_4

PE_F7_3:
                Mov     AL, CL                  ; AL = pattern.
                Mov     DI, 100h
                Mov     CX, 256

                RepNE   ScasB
                JNE     PE_F7_2

                Mov     AX, DI
                Sub     AX, 101h                ; AX = order.

PE_F7_4:
                Call    Music_PlayPartSong

                Mov     AX, 1
                Ret

PE_F7_2:
                Mov     CX, BX

                Mov     AX, PatternNumber
                Mov     BX, MaxRow
                Inc     BX
                Call    Music_PlayPattern

                Mov     AX, 1
                Ret

EndP            PE_F7

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_ToggleTracking Far
                Assume DS:Pattern

                Mov     SI, Offset NoViewChannelTrackingMsg
                Xor     ViewChannelTracking, 1
                JZ      PEFunction_ToggleTracking1

                Mov     SI, Offset ViewChannelTrackingMsg

PEFunction_ToggleTracking1:
                Call    SetInfoLine

                Mov     AX, 1
                Ret

EndP            PEFunction_ToggleTracking
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_ToggleRowHilight Far
                Assume DS:Pattern

                Mov     SI, Offset NoRowHilightMsg
                Xor     CentraliseCursor, 2
                Test    CentraliseCursor, 2
                JZ      PEFunction_ToggleRowHilight1

                Mov     SI, Offset RowHilightMsg

PEFunction_ToggleRowHilight1:
                Call    SetInfoLine

                Mov     AX, 1
                Ret

EndP            PEFunction_ToggleRowHilight
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_ToggleCentralise Far
                Assume DS:Pattern

                Mov     SI, Offset NoCentraliseCursorMsg
                Xor     CentraliseCursor, 1
                Test    CentraliseCursor, 1
                JZ      PEFunction_ToggleCentralise1

                Mov     SI, Offset CentraliseCursorMsg

PEFunction_ToggleCentralise1:
                Call    SetInfoLine

                Mov     AX, 1
                Ret

EndP            PEFunction_ToggleCentralise
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_ToggleTrace Far
                Assume DS:Pattern

                Mov     SI, Offset NoTraceMsg
                Xor     TracePlayback, 1
                JZ      PEFunction_ToggleTrace1

                Mov     SI, Offset TraceMsg

PEFunction_ToggleTrace1:
                Call    SetInfoLine

                Mov     AL, TracePlayback
                Call    K_SetScrollLock

                Mov     AX, 1
                Ret

EndP            PEFunction_ToggleTrace
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_GetPatternConfigOffset Far

                Push    CS
                Pop     DS

                Mov     DX, Offset KeySignature

                Ret

EndP            PE_GetPatternConfigOffset

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ReleaseUndoMemory

                Test    AX, AX
                JZ      ReleaseUndoMemoryEnd

                Push    AX
                And     AH, 0F0h
                Cmp     AH, 0A0h
                Pop     AX
                JE      ReleaseUndoMemoryEMS

ReleaseUndoMemoryConventional:
                Push    ES

                Mov     ES, AX
                Mov     AH, 49h
                Int     21h

                Pop     ES
                Ret

ReleaseUndoMemoryEMS:
                And     AX, 0FFFh
                Call    E_ReleaseEMS

ReleaseUndoMemoryEnd:
                Ret

EndP            ReleaseUndoMemory

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_AddToUndoBuffer Far          ; 1) Release oldest data.
                                                ; 2) Shift all stuff down.
                                                ; 3) Store newest data.

                                                ; Parameter: DI = buffer TYPE.

                PushA
                Push    DS
                Push    ES

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     AX, DI
                Cmp     AL, 22
                JE      PE_NotModified

                Mov     Word Ptr [Modified], 101h

PE_NotModified:
        ; Error maintenance... sorta
                Push    CS
                Push    Offset PE_AddToUndoBufferEnd
                Push    AX                      ; Just for stack alignment

                Call    GetPatternLength        ; Get's pattern length in DX

                Add     SP, 6
        ; For GetPatternLength's error stuff..

                Add     DX, 8
                JNC     PE_AddToUndoBuffer3

                Mov     DI, Offset O1_PatternTooLongList
                Mov     CX, 2
                Call    M_Object1List
                Jmp     PE_AddToUndoBufferEnd

PE_AddToUndoBuffer3:
;               ClC             ; Carry already not set to get here - for
                                ; Non essential EMS allocation
                MovZX   EAX, DX
                Call    E_AllocateEMS
                Test    AX, AX
                JZ      PE_AddToUndoBuffer1     ; No EMS allocated?

                Call    E_MapAvailableEMSMemory

                Or      AH, 0A0h                ; EMS tag
                Push    AX
                Call    E_GetEMSPageFrame
                Push    AX
                Jmp     PE_AddToUndoBuffer4

PE_AddToUndoBuffer1:
                Mov     BX, DX          ; BX = length of pattern.
                Add     BX, 15
                RCR     BX, 1
                ShR     BX, 3

                Mov     AH, 48h
                Int     21h
                JC      PE_AddToUndoBufferEnd

                Push    AX              ; Handle
                Push    AX              ; Memory region

PE_AddToUndoBuffer4:
                Mov     SI, Offset UndoBuffer+36
                Mov     AX, [SI]
                Call    ReleaseUndoMemory

                Mov     CX, 9

PE_AddToUndoBuffer2:
                Mov     EAX, [SI-4]
                Mov     [SI], EAX

                Sub     SI, 4
                Loop    PE_AddToUndoBuffer2

                Pop     ES
                Pop     AX

                Mov     [SI], AX
                Mov     [SI+2], DI

                Sub     DX, 8
                Xor     DI, DI          ; ES:DI points to data, DX = length

                Call    EncodePattern

PE_AddToUndoBufferEnd:
                Pop     ES
                Pop     DS
                PopA

                Ret

EndP            PE_AddToUndoBuffer
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_ClearUndoBuffer Far

                Push    EAX
                Push    CX
                Push    DS
                Push    SI

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     CX, 10
                Mov     SI, Offset UndoBuffer

PE_ClearUndoBuffer1:
                Mov     AX, [SI]
                Call    ReleaseUndoMemory

                Xor     EAX, EAX
                Mov     [SI], EAX

                Add     SI, 4

                Loop    PE_ClearUndoBuffer1

                Pop     SI
                Pop     DS
                Pop     CX
                Pop     EAX

                Ret

EndP            PE_ClearUndoBuffer
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_Undo Far

                Mov     SelectUndo, 0

                Mov     DI, Offset O1_UndoList
                Mov     CX, 3
                Call    M_Object1List

                Mov     AX, 1
                Ret

EndP            PEFunction_Undo

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_DrawUndo Far

                        Assume DS:Pattern
                Push    CS
                Pop     DS

                Call    S_GetDestination
                Mov     CX, 10
                Mov     DI, (21+24*80)*2
                Mov     BX, Offset UndoBuffer+2

PEFunction_DrawUndo1:
                Push    DI

                Mov     SI, [BX]
                Mov     AX, SI
                And     SI, 0FFh
                Add     SI, SI

                MovZX   AX, AH

                Push    AX
                Mov     SI, [UndoBufferTypes+SI]
                Mov     AH, 2
                Call    S_DrawString
                Pop     AX

                Add     BX, 4
                Pop     DI
                Add     DI, 160
                Loop    PEFunction_DrawUndo1

                Ret

EndP            PEFunction_DrawUndo
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_PreUndo Far

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Call    S_GetDestination
                Mov     AX, 160
                Mul     SelectUndo
                Add     AX, (20+24*80)*2+1
                Mov     DI, AX

                Mov     CX, 40
                Mov     AL, 30h

PEFunction_PreUndo1:
                StosB
                Inc     DI
                Loop    PEFunction_PreUndo1

                Ret

EndP            PEFunction_PreUndo
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEFunction_PostUndo Far

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     BX, SelectUndo

                Cmp     CX, 1C8h
                JE      PEFunction_PostUndoUp

                Cmp     CX, 1D0h
                JE      PEFunction_PostUndoDown

                Cmp     CX, 11Ch        ; Enter
                JE      PEFunction_PostUndoEnter

                Xor     AX, AX
                Ret

PEFunction_PostUndoUp:
                Sub     BL, 1
                AdC     BL, 0
                Jmp     PEFunction_PostUndoShift

PEFunction_PostUndoDown:
                Cmp     BX, 8
                JA      PEFunction_PostUndoShift

                Inc     BX

PEFunction_PostUndoShift:
                Mov     SelectUndo, BX

                Mov     AX, 1
                Ret

PEFunction_PostUndoEnter:
                ShL     BX, 2
                Add     BX, Offset UndoBuffer

                Mov     CX, [BX+2]
                JCXZ    PEFunction_PostUndoEnd

                Push    Word Ptr [BX]

                Mov     DI, 21
                Call    PE_AddToUndoBuffer

                Pop     AX
                Mov     CH, AH
                And     CH, 0F0h
                Cmp     CH, 0A0h
                JNE     PEFunction_PostUndoEnterEnd

PEFunction_PostUndoEMS:
                And     AX, 0FFFh
                Call    E_MapAvailableEMSMemory
                Call    E_GetEMSPageFrame

PEFunction_PostUndoEnterEnd:
                Mov     DS, AX
                        Assume DS:Nothing
                Xor     SI, SI
                Call    DecodePattern

                Xor     BX, BX
                Mov     CL, 64
                Mov     CH, Byte Ptr [CS:MaxRow]
                Inc     CH
                Call    NetworkPatternBlock

PEFunction_PostUndoEnd:
                Mov     AX, 4
                Ret

EndP            PEFunction_PostUndo

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ToggleFastVolume Far
                Assume DS:Pattern

                Mov     SI, Offset NoFastVolumeMsg
                Xor     CentraliseCursor, 4
                Test    CentraliseCursor, 4
                JZ      ToggleFastVolume3

                Push    DS

                Mov     DI, Offset O1_GetFastAmpList
                Mov     CX, 3
                Call    M_Object1List

                Pop     DS

                Cmp     DX, 1
                JNE     ToggleFastVolume2

                Mov     SI, Offset FastVolumeMsg
                Jmp     ToggleFastVolume3

ToggleFastVolume2:
                And     CentraliseCursor, Not 4
                Mov     SI, Offset FastVolumeNotEnabledMsg

ToggleFastVolume3:
                Call    SetInfoLine

                Mov     AX, 1
                Ret

EndP            ToggleFastVolume
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PECheckModified Far

                Cmp     CS:Modified, 0
                JE      PECheckModified1

                Mov     CX, 4
                Mov     DI, Offset O1_ConfirmNoSave
                Call    M_Object1List

                And     DX, DX
                JNZ     PECheckModified1

                Add     SP, 4

                Mov     AX, 1

PECheckModified1:
                Ret

EndP            PECheckModified

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PEResetModified Far

                Mov     CS:Modified, 0

                Ret

EndP            PEResetModified

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_SetPatternLength Far
                Assume DS:Pattern

;                Mov     AX, MaxRow
;                Inc     AX
;                Mov     PatternSetLength, AX
                Mov     AX, PatternNumber
                Mov     PatternLengthStart, AX
                Mov     PatternLengthEnd, AX

                Assume DS:Nothing

                Mov     CX, 4
                Mov     DI, Offset O1_SetPatternLength
                Call    M_Object1List

                Test    DX, DX
                JZ      PE_SetPatternLength2

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Call    PEFunction_StorePattern

                Mov     AX, PatternNumber
                Mov     TempVariableArea, AX

                Mov     AX, PatternLengthStart
                Mov     TempVariableArea2, AX

PE_SetPatternLength3:
                Mov     AX, TempVariableArea2
                Cmp     AX, PatternLengthEnd
                JA      PE_SetPatternLength4

                Mov     PatternNumber, AX
                        Assume DS:Nothing

                Call    Music_GetPattern
                Call    DecodePattern           ; Next pattern should be in mem

                Push    CS
                Pop     DS
                        Assume DS:Pattern

                Mov     AX, PatternSetLength
                Mov     PatternModified, 1
                Dec     AX
                Mov     MaxRow, AX
                Call    PEFunction_StorePattern

                Inc     TempVariableArea2
                Jmp     PE_SetPatternLength3

PE_SetPatternLength4:                   ; Cleanup
                Mov     AX, TempVariableArea
                Mov     PatternNumber, AX
                Call    Music_GetPattern
                Call    DecodePattern

PE_SetPatternLength2:
                Mov     AX, 1
                Ret

EndP            PE_SetPatternLength
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_LeftBrace Far

                Jmp     Glbl_LeftBrace

EndP            PE_LeftBrace

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_RightBrace Far

                Jmp     Glbl_RightBrace

EndP            PE_RightBrace

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_LeftSquareBracket Far

                Jmp     Glbl_LeftSquareBracket

EndP            PE_LeftSquareBracket

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_RightSquareBracket Far

                Jmp     Glbl_RightSquareBracket

EndP            PE_RightSquareBracket

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MIDI_SetInstrument Far

                Test    Byte Ptr CS:CentraliseCursor, 16
                JZ      MIDI_SetInstrument2

                Inc     DX

MIDI_SetInstrument2:
                Cmp     DX, 99
                JA      MIDI_SetInstrument1

                Mov     CS:LastInstrument, DL

                Test    DL, DL
                JZ      MIDI_SetInstrument1

                Call    UpdateWAVEForm

MIDI_SetInstrument1:
                Mov     AX, 1
                Ret

EndP            MIDI_SetInstrument

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_MIDIAfterTouch Far
                Assume DS:Pattern

                Cmp     MIDIInputEnabled, 0
                JNE     PE_MIDIAfterTouch2

                Xor     AX, AX
                Ret

PE_MIDIAfterTouch2:
                Test    CentraliseCursor, 128

                MovZX   BX, DL
                Call    MIDI_GetChannel
                                ; Returns AX
                Sub     AL, 1
                JC      PE_MIDIAfterTouch1
;                Cmp     AL, 0FFh
;                JE      PE_MIDIAfterTouch1

                Call    PE_TranslateMIDI
                ;       DL = note, DH = volume

                Mov     AH, 5
                Mul     AL
                Mov     SI, AX
                Mov     BL, DH
                Mov     AX, 320
                Mul     Row
                Mov     Word Ptr [Modified], 101h
                Add     SI, AX
                Mov     DS, PatternDataArea
                        Assume DS:Nothing
                Cmp     SI, 64000
                JAE     PE_MIDIAfterTouch1

                Mov     [SI+2], BL

PE_MIDIAfterTouch1:
                Mov     AX, 1
                Ret

EndP            PE_MIDIAfterTouch
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_MIDINoteOff Far
                        Assume DS:Pattern

                Cmp     MIDIInputEnabled, 0
                JNE     PE_MIDINoteOff1

                Xor     AX, AX
                Ret

PE_MIDINoteOff1:
                MovSX   BX, DL
                Call    MIDI_FindChannel        ; Returns AX
                Cmp     AL, 0FFh
                JE      PE_MIDINoteOff2

                Test    CentraliseCursor, 32
                JZ      PE_MIDINoteOff2         ; Dont' record note-offs

                Cmp     TracePlayback, 0
                JE      PE_MIDINoteOff2

                Push    AX
                Mov     AX, Row
                Call    Music_GetDelay          ; DX = delay value
                                                ; CX = playmode
                Pop     AX

                Test    CX, CX
                JZ      PE_MIDINoteOff2

                Push    DX
                Push    AX

                Mov     AH, 5
                Mul     AH
                Mov     SI, AX
                Mov     AX, 320
                Mul     Row
                Add     SI, AX
                Cmp     SI, 64000
                JAE     PE_MIDINoteOff3

                Mov     DS, PatternDataArea
                        Assume DS:Nothing

                Cmp     Word Ptr [SI], NONOTE
                JE      PE_MIDINoteOff4
                                                ; check next spot.
                Mov     AX, Row
                Cmp     AX, MaxRow
                JAE     PE_MIDINoteOff3         ; Already at end of pattern

                Add     SI, 320                 ; Try very next spot.
                Cmp     SI, 64000
                JAE     PE_MIDINoteOff3

                Xor     DX, DX                  ; Tick 0
                Cmp     Word Ptr [SI], NONOTE
                JNE     PE_MIDINoteOff3

PE_MIDINoteOff4:
                Mov     BX, 0FFh

                Mov     [SI+2], BX
                Mov     [SI+4], BH
                Test    [CS:Flags], 2
                JZ      PE_MIDINoteOffCut

                Dec     BX

PE_MIDINoteOffCut:
                Mov     [SI], BX

                Mov     Word Ptr [CS:Modified], 101h

                Pop     AX
                Mov     DL, 32
                Call    Music_PlayNote
                Pop     DX

                Test    CS:CentraliseCursor, 8
                JZ      PE_MIDINoteOff2

                Mov     [SI+3], DX

PE_MIDINoteOff2:
                Mov     AX, 1
                Ret

PE_MIDINoteOff3:
                Pop     AX
                Pop     AX
                Mov     AX, 1
                Ret

EndP            PE_MIDINoteOff
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_MIDINote Far
                        Assume DS:Pattern

                Cmp     MIDIInputEnabled, 0
                JNE     PE_MIDINote6

                Xor     AX, AX
                Ret

PE_MIDINote6:
                Push    DX
                Call    Music_GetLastChannel
                Mov     DI, AX
                Pop     DX

                Call    PE_TranslateMIDI
                JC      PE_MIDINote1            ; Note out of range?
                JZ      PE_MIDINoteOff1         ; Note off?

                Mov     BL, DH
                Test    CentraliseCursor, 64
                JNZ     PE_MIDINote3

                Mov     BL, LastVolume
                Test    EditMask, 2
                JNZ     PE_MIDINote3

                Mov     BL, 0FFh

PE_MIDINote3:
                                ; If TracePlayback = 1 *AND* Playmode > 1, then
                                ; Basechannel = MIDIChannel, else
                                ; Basechannel = Channel
                Push    DX

                Mov     AX, Row
                Call    Music_GetDelay          ; CX = playmode
                                                ; DX = delay value
                PushA

                Cmp     MIDIPlayTrigger, 1
                JB      PE_MIDINoteTriggerEnd
                JA      MIDIPlayTriggerSong

MIDIPlayTriggerPattern:
                Mov     Row, 0

                Call    Glbl_F6
                Jmp     PE_MIDINoteTriggerCleanup

MIDIPlayTriggerSong:

                Call    PE_F7

PE_MIDINoteTriggerCleanup:
                Push    CS
                Pop     DS

                Mov     AX, Channel
                Mov     MIDIChannel, AX

                Mov     TracePlayback, 1
                Mov     MIDIPlayTrigger, 0

PE_MIDINoteTriggerEnd:
                PopA

                Mov     AX, Channel
                Test    CX, CX
                JZ      PE_MIDINote2

                Cmp     TracePlayback, 0
                JE      PE_MIDINote2

                Mov     AX, MIDIChannel

PE_MIDINote2:
                Pop     CX                      ; CX = note/volume
                Xor     CH, CH
                Test    EditMask, 1
                JZ      PE_MIDINote4

                Mov     CH, LastInstrument

PE_MIDINote4:

                XChg    CX, DX
                        ; CX = delay
                        ; DX = note/ins

                Push    DX
                Call    PE_RestoreMIDINote
                Call    MIDI_AllocateChannel    ; Returns AX = channel to use
                Pop     DX

                XChg    CX, DX

                Push    DX
                Push    AX

                Inc     AX
                Cmp     AX, 63
                JA      PE_MIDINote5

                Mov     MIDIChannel, AX
PE_MIDINote5:
                Dec     AX

                Mov     AH, 5
                Mul     AH
                Mov     SI, AX
                Mov     AX, 320
                Mul     Row
                Add     SI, AX

                Pop     AX
                Cmp     SI, 64000
                JAE     PE_MIDINote1

                Mov     DS, PatternDataArea
                        Assume DS:Nothing

                Mov     [SI], CX
                Mov     [SI+2], BL
                Mov     Word Ptr [SI+3], 0

                Mov     DH, 32
                Call    Music_PlayNote
                Pop     DX

                Mov     Word Ptr [CS:Modified], 101h

                Test    CS:CentraliseCursor, 8
                JZ      PE_MIDINote1

                Mov     [SI+3], DX

PE_MIDINote1:
                Mov     AX, 1
                Ret

EndP            PE_MIDINote
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_TranslateMIDI Far
                                        ; Given DL = 0->127, return DL = 0->127
                                        ; Given DH = 0->127, return DH=0->64

                                        ; Apply note swing. Return carry
                                        ; if note out of range.

                                        ; Apply volume swing. Return zero
                                        ; flag set if note off.
                Push    AX

                Test    DH, DH
                JZ      PE_TranslateMIDIVolumeEnd

                MovSX   BX, DL
                MovSX   AX, CS:MIDICentralNote
                Add     AX, BX
                Sub     AX, 60
                JS      PE_TranslateMIDIError1

PE_TranslateMIDIPitch1:
                Cmp     AX, 119
                JBE     PE_TranslateMIDIPitch2

PE_TranslateMIDIError1:
                StC
                Pop     AX
                Ret

PE_TranslateMIDIPitch2:
                Mov     DL, AL
                                        ; OK.. pitch done.
                Mov     AL, DH
                Mul     CS:MIDIAmplification
                                        ; AX = (Volume*VolumeAmp)
                                        ;    = 0->127*200
                                        ;    = 0->25400
                                        ; Req AX = 0->128
                                        ; ie. Div AX 198.4
                                        ; or Mul AX, 331
                                        ; >> 16

                Mov     BL, DL          ; Note
                Mov     DX, 331
                Mul     DX
                Mov     DH, DL
                Mov     DL, BL
                Cmp     DH, 64
                JB      PS_TranslateMIDIVolume1

                Mov     DH, 64

PS_TranslateMIDIVolume1:
                Test    DL, DL          ; Clear zero flag + carry.

PE_TranslateMIDIVolumeEnd:
                Pop     AX
                Ret

EndP            PE_TranslateMIDI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_RestoreMIDINote Far

                Add     DL, 60
                Sub     DL, CS:MIDICentralNote

                Ret

EndP            PE_RestoreMIDINote

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_CycleMIDIPlayTrigger Far
                Assume DS:Pattern

                Mov     AL, MIDIPlayTrigger
                Inc     AX
                Cmp     AL, 2
                JBE     PE_CycleMIDIPlayTrigger1

                Xor     AL, AL
                Mov     SI, Offset TriggerMsg1
                Jmp     PE_CycleMIDIPlayTriggerEnd

PE_CycleMIDIPlayTrigger1:
                Mov     SI, Offset TriggerMsg2
                Cmp     AL, 1
                JE      PE_CycleMIDIPlayTriggerEnd

                Mov     SI, Offset TriggerMsg3

PE_CycleMIDIPlayTriggerEnd:
                Mov     MIDIPlayTrigger, AL

                Call    SetInfoLine

                Mov     AX, 1
                Ret

EndP            PE_CycleMIDIPlayTrigger
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MIDIInputToggle Far                     ; Ctrl-Scroll Lock
                Assume DS:Pattern

                Mov     SI, Offset MIDIInputEnabledMsg
                Xor     MIDIInputEnabled, 1
                JNZ     MIDIInputToggle1
                Mov     SI, Offset MIDIInputDisabledMsg

MIDIInputToggle1:
                Call    SetInfoLine

                Mov     AX, 1
                Ret

EndP            MIDIInputToggle
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_SetPatternModified Far

                Mov     Word Ptr [CS:Modified], 101h
                Ret

EndP            PE_SetPatternModified

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_SaveCurrentPattern Far

                PushAD
                Push    DS
                Push    ES

                Call    PEFunction_StoreCurrentPattern

                Mov     AX, 0FFFFh
                XChg    AX, CS:PatternNumber
                Mov     Word Ptr CS:TempNumbers, AX

                Call    Music_UpdatePatternOffset

                Pop     ES
                Pop     DS
                PopAD
                Ret

EndP            PE_SaveCurrentPattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_RestoreCurrentPattern Far

                PushAD
                Push    DS
                Push    ES
                Mov     AX, Word Ptr CS:TempNumbers
                Mov     CS:PatternNumber, AX
                Call    Music_GetPattern
                Call    DecodePattern
                Pop     ES
                Pop     DS
                PopAD
                Ret

EndP            PE_RestoreCurrentPattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PE_NewPattern Far

                Mov     AX, CS:PatternNumber
                Call    Music_GetPattern
                Call    DecodePattern

                Mov     CS:PatternModified, 0
                Ret

EndP            PE_NewPattern

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

EndS

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment                 PatternData PARA Public 'Data'
                        DB      64000 Dup (?)
EndS


;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

End
