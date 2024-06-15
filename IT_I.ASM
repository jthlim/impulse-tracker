;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Instrument List module                                                      ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                        Jumps
                        .386

include switch.inc
include network.inc

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Externals                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Segment         Object1 BYTE Public 'Data'
                Extrn   SampleFrequency:Word
EndS

Segment         DiskData PARA Public 'Data'
EndS

Segment         Pattern BYTE Public 'Code'
                Extrn   BaseOctave:Byte
                Extrn   LastInstrument:Byte
EndS

                Extrn   F_Reset5NumInputPos:Far
                Extrn   Glbl_F4_2:Far

                Extrn   Glbl_GetCurrentMode:Far
                Extrn   S_GetDestination:Far
                Extrn   S_SaveScreen:Far
                Extrn   S_RestoreScreen:Far
                Extrn   S_DrawString:Far
                Extrn   M_FunctionDivider:Far
                Extrn   M_Object1List:Far
                Extrn   M_Object1ListDefault:Far
                Extrn   Music_GetSongSegment:Far
                Extrn   Music_ReleaseSample:Far
                Extrn   Music_ClearSampleName:Far
                Extrn   Music_PlaySample:Far
                Extrn   Music_GetInstrumentMode:Far
;                Extrn   Music_UpdateSampleLocation:Far

                Extrn   S_GetGenerationTableOffset:Far
                Extrn   S_GenerateCharacters:Far
                Extrn   S_SetDirectMode:Far
                Extrn   S_DrawBox:Far
                Extrn   S_DrawSmallBox:Far

                Extrn   O1_ConfirmDeleteSample:Far
                Extrn   O1_ConfirmConvertList:Far
                Extrn   O1_ConfirmConvert2List:Far
                Extrn   O1_ConfirmCutSample:Far
                Extrn   O1_ExchangeSampleList:Far
                Extrn   O1_ExchangeInstrumentList:Far
                Extrn   O1_SwapSampleList:Far
                Extrn   O1_SwapInstrumentList:Far
                Extrn   O1_ReplaceSampleList:Far
                Extrn   O1_ReplaceInstrumentList:Far
                Extrn   O1_ResizeSampleList:Far
                Extrn   O1_ShowSampleFrequencyList:Far
                Extrn   O1_FrequencyIndeterminedList:Far
                Extrn   O1_ConfirmDeleteInstrument:Far
                Extrn   O1_SampleAmplificationList:Far
                Extrn   O1_CopyInstrumentList:Far
                Extrn   O1_SampleCenterList:Far

                Extrn   O1_InstrumentListGeneral:Far
                Extrn   O1_InstrumentListVolume:Far
                Extrn   O1_InstrumentListPanning:Far
                Extrn   O1_InstrumentListPitch:Far
                Extrn   O1_C5FrequencyList:Far
                Extrn   O1_GetInstrumentAmpList:Far

                Extrn   PE_GetLastInstrument:Far
                Extrn   PE_SwapInstruments:Far
                Extrn   PE_UpdateInstruments:Far
                Extrn   PEFunction_OutOfMemoryMessage:Far
                Extrn   PE_TranslateMIDI:Far, PE_RestoreMIDINote:Far
                Extrn   PE_InsertInstrument:Far
                Extrn   PE_DeleteInstrument:Far

                Extrn   Music_PlayPattern:Far
                Extrn   Music_Stop:Far
                Extrn   Music_PlaySong:Far
                Extrn   Music_PlayNote:Far
                Extrn   Music_ToggleChannel:Far
                Extrn   Music_SoloChannel:Far
                Extrn   Music_GetSampleLocation:Far
                Extrn   Music_ClearInstrument:Far
                Extrn   Music_GetInstrumentMode:Far
                Extrn   Music_AllocateSample:Far
                Extrn   Music_GetSlaveChannelInformationTable:Far
                Extrn   Music_SoundCardLoadAllSamples:Far
                Extrn   Music_GetNumChannels:Far

                Extrn   Music_RegetLoopInformation:Far

                Extrn   SetInfoLine:Far

                Extrn   MouseAddEvent:Far, AddMouseQueue:Far, MouseClearEvents:Far
                Extrn   SetKeyboardLock:Far, MouseSetXY:Far
                Extrn   MouseRemoveEvents:Far, MouseGetStatus:Far
                Extrn   SetMouseCursorType:Far

                Extrn   Fourier_Transform:Far, Fourier_CreateTable:Far


;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Globals                                                                     ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                Global  I_DrawPitchPanCenter:Far
                Global  I_PrePitchPanCenter:Far
                Global  I_PostPitchPanCenter:Far

                Global  I_ClearTables:Far
                Global  I_TagInstrument:Far
                Global  I_TagSample:Far

                Global  I_DrawEnvelope:Far
                Global  I_PreEnvelope:Far
                Global  I_PostEnvelope:Far

                Global  I_ConvertSample:Far
                Global  I_DeleteSample:Far
                Global  I_CutSample:Far
                Global  I_ClearSampleName:Far
                Global  I_ExchangeSamples:Far
                Global  I_ReplaceInstrument:Far
                Global  I_ToggleSampleQuality:Far
                Global  I_CenterSample:Far

                Global  I_InstrumentListSpace:Far
                Global  I_InstrumentListNoteOff:Far
                Global  I_IncreasePlayChannel:Far
                Global  I_DecreasePlayChannel:Far
                Global  I_ToggleMultiChannel:Far

                Global  I_ScaleInstrumentVolumes:Far
                Global  I_ScaleSampleVolumes:Far
                Global  I_CopyInstrument:Far
                Global  I_DeleteInstrument:Far
                Global  I_DrawSampleList:Far
                Global  I_PreSampleList:Far
                Global  I_PostSampleList:Far
                Global  I_ShowSampleInfo:Far
                Global  I_SampleUp:Far
                Global  I_SampleDown:Far
                Global  I_CheckLoopValues:Far
                Global  I_CheckSusLoopValues:Far
                Global  I_MapEnvelope:Far
                Global  I_DrawWaveForm:Far
                Global  I_SampleButtonHandler:Far

                Global  I_DrawInstrumentWindow:Far
                Global  I_PreInstrumentWindow:Far
                Global  I_PostInstrumentWindow:Far

                Global  I_DrawNoteWindow:Far
                Global  I_PreNoteWindow:Far
                Global  I_PostNoteWindow:Far

                Global  I_AmplifySample:Far
                Global  I_ExchangeInstruments:Far
                Global  I_ReverseSample:Far
                Global  I_SwapSamples:Far
                Global  I_SwapInstruments:Far
                Global  I_ReplaceSample:Far
                Global  I_UpdateInstrument:Far
                Global  I_ResizeSample:Far
                Global  I_ResizeSampleNoInt:Far
                Global  I_InvertSample:Far

                Global  I_GetInstrumentOffset:Far
                Global  I_GetSampleOffset:Far
                Global  I_CutSampleBeforeLoop:Far

                Global  I_CalculateC5Speed:Far
                Global  I_PrintC5Frequency:Far

                Global  I_DoubleSampleSpeed:Far
                Global  I_HalveSampleSpeed:Far
                Global  I_SampleSpeedSemiUp:Far
                Global  I_SampleSpeedSemiDown:Far

                Global  I_ShowSamplePlay:Far
                Global  I_ShowInstrumentPlay:Far

                Global  I_PlaySample:Far
                Global  I_SelectScreen:Far

                Global  I_GetInstrumentScreen:Far
                Global  I_IdleUpdateEnvelope:Far

                Global  I_PlayNote:Far

                Global  SampleNumberInput:Byte
                Global  SampleNumber:Byte

                Global  MaxNode:Word
                Global  NewSampleSize:DWord
                Global  SampleAmplification:Word

                Global  InstrumentEdit:Byte
                Global  NodeHeld:Byte
                Global  InstrumentScreen:Word

                Global  I_GetPresetEnvelopeOffset:Far

                Public  UpdateWAVEForm
                Public  MIDI_PlayNote, MIDI_NoteOff, MIDI_ClearTable
                Public  MIDI_PlaySample, MIDI_FindChannel, MIDI_AllocateChannel
                Public  MIDI_GetChannel

                Global  InstrumentAmplification

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment                 Inst WORD Public 'Code' USE16
                        Assume CS:Inst, DS:Nothing

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Variables                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SLAVECHANNELSIZE        EQU     128
HOSTCHANNELSIZE         EQU     80
ENVELOPEGRANULARITY     EQU     50
MAXENVELOPETICK         EQU     9999

InstrumentAmplification DW      50
InstrumentScreen        DW      0

LastPlaySample          DB      5*12
SampleNumber            DB      1                       ; For instrument-sample
                                                        ; editing

NoteReleased            DB      1
TopInstrument           DW      1
InstrumentPos           DW      0

SamplePlayTable         DB      128 Dup (0)
InstrumentPlayTable     DB      128 Dup (0)

TopNote                 DW      0
CurrentNote             DW      0
NotePos                 DW      0                       ; 0->4

SampleNumberInput       DB      0
                        DB      3 Dup(0)

NewSampleSize           DD      0

CurrentNode             DW      0                       ; Volume envelope
MaxNode                 DW      0

AmplitudeCompensate     DB      0
                        DB      0       ; Filler
CurrentAmplitude        DW      0
CurrentTick             DW      0
LastAmplitude           DW      0
LastTick                DW      0
UpperLimit              DW      0

NodeHeld                DB      0
                        DB      0
WaveLength              DW      0
SearchDirection         DW      0
EndPoint                DW      0

InstrumentEdit          DB      0
LastKey                 DW      0

Interpolate             DB      0                       ; For resizing routines
Quality                 DB      0
MultiChannel            DB      0

PlayChannel             DW      0
SampleAmplification     DW      0               ; Percentage

MIDITable               DB      128 Dup (0)     ; Contains channel of each note

NoteData                DB      0, 0, 0FFh, 0, 0  ; For noteplay in notelist

PlayNote                DB      5*12

NotePosTable            DB      4, 6, 8, 9
SamplePos               DW      25

Resolution              DB      0
UpdateInstrumentScreen  DB      1

CompleteMsg             DB      0FDh, "D% Complete", 0
TopSample               DW      1
NoSampleMsg             DB      "No sample", 0
Quality8Msg             DB      "8 bits", 0
Quality16Msg            DB      "16 bits", 0
LengthMsg               DB      0FDh, 'L', 0

EnvelopeSetMsg          DB      "Envelope copied into slot ", 0FDh, "D", 0

EnvelopeMsg             DB      "Node ", 0FDh, "D/", 0FDh, "D", 13, 13
                        DB      "Tick ", 0FDh, "D", 13, 13
                        DB      "Value ", 0FDh, "S", 0

PlayChannelMsg          DB      "Using channel ", 0FDh, "D for playback", 0

MultiChannelEnabledMsg  DB      "Multichannel playback enabled", 0
MultiChannelDisabledMsg DB      "Multichannel playback disabled", 0

C5FrequencyText         DB      "Calculated C5Speed: ", 0FDh, "L", 0

LastWaveformValues      DW      0

EnvelopeHeaderTable     Label
        DW      Offset VolEnv, Offset VolEnvEdit
        DW      Offset PanEnv, Offset PanEnvEdit
        DW      Offset PitchEnv, Offset PitchEnvEdit

VolEnv  DB      "Volume Envelope", 0
VolEnvEdit DB   "Volume Envelope (Edit)", 0
PanEnv  DB      "Panning Envelope", 0
PanEnvEdit DB   "Panning Envelope (Edit)", 0
PitchEnv DB     "Frequency Envelope", 0
PitchEnvEdit DB "Frequency Envelope (Edit)", 0

EnvelopeOffsets Label   Word
        DW      130h, 182h, 1D4h

NoteTable               DB      "C-C#D-D#E-F-F#G-G#A-A#B-"
KeyBoardTable           DW      12Ch, 0, 11Fh, 1, 12Dh, 2, 120h, 3, 12Eh, 4
                        DW      12Fh, 5, 122h, 6, 130h, 7, 123h, 8, 131h, 9
                        DW      124h, 10, 132h, 11, 110h, 12, 103h, 13, 111h, 14
                        DW      104h, 15, 112h, 16, 113h, 17, 106h, 18, 114h, 19
                        DW      107h, 20, 115h, 21, 108h, 22, 116h, 23, 117h, 24
                        DW      10Ah, 25, 118h, 26, 10Bh, 27, 119h, 28, 0FFFFh

SampleMouseEvent        DW      5*8, 13*8, 35*8-1, 48*8-1
SampleMouseCondition    DW      102h, 28, Offset MouseSelectInst, Inst
SampleMouseOffEvent     DW      0, 0, 0, 0, 1108h, 28, MouseSelectOff, Inst
NoteMouseEvent          DW      32*8, 16*8, 42*8-1, 48*8-1
NoteMouseCondition      DW      102h, 10, Offset MouseSelectNote, Inst
NoteMouseOffEvent       DW      0, 0, 0, 0, 1108h, 10, MouseSelectNoteOff, Inst

ENVELOPELEFT    EQU     32
ENVELOPETOP     EQU     18

MouseNodeHeld   DB      0

MouseX          DW      0
MouseY          DW      0
LowerTickLimit  DW      0
UpperTickLimit  DW      0

EnvelopeEvent1  DW      ENVELOPELEFT*8, ENVELOPETOP*8
                DW      (ENVELOPELEFT+32)*8-1, (ENVELOPETOP+8)*8-1
                DW      102h, 10, Offset MouseEnvelopeEvent1, Inst
EnvelopeEvent4  DW      ENVELOPELEFT*8, ENVELOPETOP*8
                DW      (ENVELOPELEFT+32)*8-1, (ENVELOPETOP+8)*8-1
                DW      110h, 10, Offset MouseEnvelopeEvent4, Inst
EnvelopeEvent2  DW      0, 0, 0, 0, 1005h, 10, Offset MouseEnvelopeEvent2, Inst
EnvelopeEvent3  DW      0, 0, 0, 0, 1108h, 10, Offset MouseEnvelopeEvent3, Inst
                                                                    ; Release

PresetEnvelopes Label   Byte
                DB      0, 2, 0, 0, 0, 0, 32, 0, 0, 32, 100, 0, 69 Dup (0)
                DB      0, 2, 0, 0, 0, 0, 32, 0, 0, 32, 100, 0, 69 Dup (0)
                DB      0, 2, 0, 0, 0, 0, 32, 0, 0, 32, 100, 0, 69 Dup (0)
                DB      0, 2, 0, 0, 0, 0, 32, 0, 0, 32, 100, 0, 69 Dup (0)
                DB      0, 2, 0, 0, 0, 0, 32, 0, 0, 32, 100, 0, 69 Dup (0)
                DB      0, 2, 0, 0, 0, 0, 32, 0, 0, 32, 100, 0, 69 Dup (0)
                DB      0, 2, 0, 0, 0, 0, 32, 0, 0, 32, 100, 0, 69 Dup (0)
                DB      0, 2, 0, 0, 0, 0, 32, 0, 0, 32, 100, 0, 69 Dup (0)
                DB      0, 2, 0, 0, 0, 0, 32, 0, 0, 32, 100, 0, 69 Dup (0)
                DB      0, 2, 0, 0, 0, 0, 32, 0, 0, 32, 100, 0, 69 Dup (0)

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

InstrumentScreenTable   Label
        DW      Offset O1_InstrumentListGeneral
        DW      Offset O1_InstrumentListVolume
        DW      Offset O1_InstrumentListPanning
        DW      Offset O1_InstrumentListPitch

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

SampleListKeys          Label
                        DB      0               ; Mouse left button
                        DW      8010h
                        DW      Offset I_SelectInstrument

                        DB      0       ; 0 = CX, 1 = DX, 2 = Alt CX, 3 = Ctrl
                        DW      1C8h
                        DW      Offset I_SampleUp

                        DB      0
                        DW      1D0h
                        DW      Offset I_SampleDown

                        DB      0
                        DW      1C9h
                        DW      Offset I_SamplePgUp

                        DB      0
                        DW      1D1h
                        DW      Offset I_SamplePgDn

                        DB      3
                        DW      1C9h
                        DW      Offset I_SampleCtrlPgUp

                        DB      3
                        DW      1D1h
                        DW      Offset I_SampleCtrlPgDn

                        DB      2
                        DW      1D2h            ; Alt Ins
                        DW      Offset I_InsertSample

                        DB      2
                        DW      1D3h            ; Alt Del
                        DW      Offset I_RemoveSample

                        DB      0
                        DW      1CBh
                        DW      Offset I_SampleLeft

                        DB      0
                        DW      1CDh
                        DW      Offset I_SampleRight

                        DB      0
                        DW      1C7h
                        DW      Offset I_SampleHome

                        DB      0
                        DW      1CFh
                        DW      Offset I_SampleEnd

                        DB      0
                        DW      10Fh
                        DW      Offset I_SampleTab

                        DB      1               ; Alt...
                        DW      2E00h           ; 'C'
                        DW      Offset I_ClearSampleName

                        DB      0FFh

InstrumentListKeys      Label
                        DB      0               ; Mouse left button
                        DW      8010h
                        DW      Offset I_SelectInstrument2

                        DB      0       ; 0 = CX, 1 = DX, 2 = Alt CX, 3 = Ctrl
                        DW      1C8h
                        DW      Offset I_SampleUp

                        DB      0
                        DW      1D0h
                        DW      Offset I_SampleDown

                        DB      0
                        DW      1C9h
                        DW      Offset I_SamplePgUp

                        DB      0
                        DW      1D1h
                        DW      Offset I_SamplePgDn

                        DB      2
                        DW      1D2h            ; Alt Ins
                        DW      Offset I_InsertInstrument

                        DB      2
                        DW      1D3h            ; Alt Del
                        DW      Offset I_RemoveInstrument

                        DB      3
                        DW      1C9h
                        DW      Offset I_SampleCtrlPgUp

                        DB      3
                        DW      1D1h
                        DW      Offset I_SampleCtrlPgDn

                        DB      0
                        DW      1CBh
                        DW      Offset I_InstrumentLeft

                        DB      0
                        DW      1CDh
                        DW      Offset I_InstrumentRight

                        DB      0
                        DW      1C7h
                        DW      Offset I_InstrumentHome

                        DB      0
                        DW      1CFh
                        DW      Offset I_InstrumentEnd

                        DB      0
                        DW      10Fh
                        DW      Offset I_InstrumentTab

                        DB      4
                        DW      10Fh
                        DW      Offset I_InstrumentShiftTab

                        DB      1               ; Alt
                        DW      2E00h           ; 'C'
                        DW      Offset I_InstrumentNameClear

                        DB      1                ; Alt...
                        DW      1100h            ; 'W'
                        DW      Offset I_InstrumentClear

                        DB      0FFh

NoteListKeys            Label
                        DB      0
                        DW      8010h
                        DW      Offset I_SelectNoteMouse

                        DB      0       ; 0 = CX, 1 = DX, 2 = Alt CX, 3 = Ctrl
                        DW      1C8h
                        DW      Offset I_NoteUp

                        DB      0
                        DW      1D0h
                        DW      Offset I_NoteDown

                        DB      0
                        DW      1C9h
                        DW      Offset I_NotePgUp

                        DB      0
                        DW      1D1h
                        DW      Offset I_NotePgDn

                        DB      0
                        DW      1C7h
                        DW      Offset I_NoteHome

                        DB      0
                        DW      1CFh
                        DW      Offset I_NoteEnd

                        DB      0
                        DW      1CBh
                        DW      Offset I_NoteLeft

                        DB      0
                        DW      1CDh
                        DW      Offset I_NoteRight

                        DB      0
                        DW      10Fh
                        DW      Offset I_NoteTab

                        DB      4
                        DW      10Fh             ; Shift-Tab
                        DW      Offset I_NoteShiftTab

                        DB      1
                        DW      '>'
                        DW      Offset I_NoteSampleIncrease

                        DB      1
                        DW      "'"
                        DW      Offset I_NoteSampleIncrease

                        DB      1
                        DW      '<'
                        DW      Offset I_NoteSampleDecrease

                        DB      1
                        DW      ';'
                        DW      Offset I_NoteSampleDecrease

                        DB      1               ; Alt...
                        DW      1E00h            ; 'A'
                        DW      Offset I_NoteAll

                        DB      1               ; Alt...
                        DW      3100h            ; 'N'
                        DW      Offset I_NoteNext

                        DB      1               ; Alt...
                        DW      1900h            ; 'P'
                        DW      Offset I_NotePrevious

                        DB      2               ; Alt up
                        DW      1C8h
                        DW      Offset I_NoteTransposeUp

                        DB      2               ; Alt down
                        DW      1D0h
                        DW      Offset I_NoteTransposeDown

                        DB      2
                        DW      1D2h            ; Alt Ins
                        DW      Offset I_NoteInsert

                        DB      2
                        DW      1D3h            ; Alt Del
                        DW      Offset I_NoteDelete

                        DB      1
                        DW      ' '
                        DW      Offset I_NoteSpace

                        DB      0
                        DW      11Ch            ; Enter
                        DW      Offset I_NoteSamplePickup

                        DB      0FFh

VolumeEnvelopeKeys      Label
                        DB      0
                        DW      8010h
                        DW      Offset I_MouseEnvelopePress

                        DB      0
                        DW      8001h
                        DW      Offset I_MouseEnvelopeDrag

                        DB      0
                        DW      8002h
                        DW      Offset I_MouseEnvelopeReleased

                        DB      0
                        DW      8003h
                        DW      Offset I_MouseEnvelopeDelete

                        DB      0
                        DW      10Fh               ; Tab
                        DW      Offset I_NoteShiftTab

                        DB      4               ; Shifttab
                        DW      10Fh
                        DW      Offset I_NoteShiftTab

                        DB      0
                        DW      1CBh
                        DW      Offset I_VolumeEnvelopeLeft

                        DB      0
                        DW      1CDh
                        DW      Offset I_VolumeEnvelopeRight

                        DB      0               ; Enter
                        DW      11Ch
                        DW      Offset I_VolumeEnvelopeEnter

                        DB      0               ; Up arrow
                        DW      1C8h
                        DW      Offset I_VolumeEnvelopeUp

                        DB      0               ; Up arrow
                        DW      1D0h
                        DW      Offset I_VolumeEnvelopeDown

                        DB      0
                        DW      1D2h
                        DW      Offset I_VolumeEnvelopeInsert

                        DB      0
                        DW      1D3h
                        DW      Offset I_VolumeEnvelopeDelete

                        DB      0FFh

VolumeEnvelopeNodeKeys  Label
                        DB      0
                        DW      8010h
                        DW      Offset I_MouseEnvelopePress

                        DB      0
                        DW      8001h
                        DW      Offset I_MouseEnvelopeDrag

                        DB      0
                        DW      8002h
                        DW      Offset I_MouseEnvelopeReleased

                        DB      0
                        DW      8003h
                        DW      Offset I_MouseEnvelopeDelete

                        DB      0               ; Enter
                        DW      11Ch
                        DW      Offset I_VolumeEnvelopeEnter

                        DB      0
                        DW      1C8h            ; Up arrow
                        DW      Offset I_VolumeEnvelopeHeldUp

                        DB      0
                        DW      1D0h            ; Down arrow
                        DW      Offset I_VolumeEnvelopeHeldDown

                        DB      2
                        DW      1C8h
                        DW      Offset I_VolumeEnvelopeHeldPgUp

                        DB      2
                        DW      1D0h
                        DW      Offset I_VolumeEnvelopeHeldPgDn

                        DB      0
                        DW      1CBh
                        DW      Offset I_VolumeEnvelopeHeldLeft

                        DB      0
                        DW      1CDh
                        DW      Offset I_VolumeEnvelopeHeldRight

                        DB      0
                        DW      10Fh
                        DW      Offset I_VolumeEnvelopeHeldRightFast

                        DB      4
                        DW      10Fh
                        DW      Offset I_VolumeEnvelopeHeldLeftFast

                        DB      2
                        DW      1CBh
                        DW      Offset I_VolumeEnvelopeHeldLeftFast

                        DB      2
                        DW      1CDh
                        DW      Offset I_VolumeEnvelopeHeldRightFast

                        DB      0
                        DW      1C9h
                        DW      Offset I_VolumeEnvelopeHeldPgUp

                        DB      0
                        DW      1D1h
                        DW      Offset I_VolumeEnvelopeHeldPgDn

                        DB      0
                        DW      1C7h
                        DW      Offset I_VolumeEnvelopeHeldHome

                        DB      0
                        DW      1CFh
                        DW      Offset I_VolumeEnvelopeHeldEnd

                        DB      0
                        DW      1D2h
                        DW      Offset I_VolumeEnvelopeInsert

                        DB      0
                        DW      1D3h
                        DW      Offset I_VolumeEnvelopeDelete

                        DB      3
                        DW      1CBh
                        DW      Offset I_VolumeEnvelopeLeft

                        DB      3
                        DW      1CDh
                        DW      Offset I_VolumeEnvelopeRight

                        DB      0FFh

PitchPanCenterKeys      Label
                        DB      0
                        DW      10Fh               ; Tab
                        DW      Offset I_NoteShiftTab

                        DB      4               ; Shifttab
                        DW      10Fh
                        DW      Offset I_NoteShiftTab

                        DB      0
                        DW      1C8h            ; Up arrow
                        DW      Offset I_PitchPanCenterUp

                        DB      0
                        DW      1D0h            ; Down arrow
                        DW      Offset I_PitchPanCenterDown

                        DB      1
                        DW      '+'
                        DW      Offset I_PitchPanCenterSemiUp

                        DB      1
                        DW      '-'
                        DW      Offset I_PitchPanCenterSemiDown

                        DB      0
                        DW      1CBh
                        DW      Offset I_PitchPanCenterSemiDown

                        DB      0
                        DW      1CDh
                        DW      Offset I_PitchPanCenterSemiUp

                        DB      0FFh

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Functions                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_GetInstrumentScreen Far

                Push    CS
                Pop     ES
                Mov     DI, Offset InstrumentScreen

                Ret

EndP            I_GetInstrumentScreen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_GetInstrumentOffset Far

                Call    PE_GetLastInstrument
                Add     BX, BX
                Call    Music_GetSongSegment
                Mov     DS, AX
                Mov     BX, [DS:64712+BX]

                Ret

EndP            I_GetInstrumentOffset

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_GetSampleOffset Far

                Call    PE_GetLastInstrument
                Add     BX, BX
                Call    Music_GetSongSegment
                Mov     DS, AX
                Mov     BX, [DS:64912+BX]

                Ret

EndP            I_GetSampleOffset

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_GetEnvelopeOffset             ; Returns DS:SI

                Push    AX
                Call    I_GetInstrumentOffset   ; Returns DS:BX
                Mov     SI, CS:InstrumentScreen
                Add     SI, SI
                Mov     SI, [SI+EnvelopeOffsets-2]
                Add     SI, BX
                Pop     AX

                Ret

EndP            I_GetEnvelopeOffset

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SelectScreen Far

                Mov     BX, [SI+22]

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Mov     InstrumentScreen, BX

                Mov     AX, [ES:DI]

                Add     BX, BX
                Mov     BX, [CS:InstrumentScreenTable+BX]
                Mov     [ES:BX], AX

                Jmp     Glbl_F4_2

EndP            I_SelectScreen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseSelectOff Far

                Mov     Word Ptr [SI-16+8], 102h
                Mov     CS:SampleMouseCondition, 102h
                Mov     AX, 1

                Ret

EndP            MouseSelectOff

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseSelectNoteOff Far

                Mov     Word Ptr [SI-16+8], 102h
                Mov     CS:NoteMouseCondition, 102h
                Mov     AX, 1
                Ret

EndP            MouseSelectNoteOff

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseSelectNote Far

                Mov     CS:NoteMouseCondition, 1107h

                Push    CX
                Mov     CX, 8010h
                Call    AddMouseQueue
                Pop     CX

                Cmp     DX, 16*8
                JA      MouseSelectNote1

                Mov     DX, 16*8

MouseSelectNote1:
                Cmp     DX, 48*8-1
                JB      MouseSelectNote2

                Mov     DX, 48*8-1

MouseSelectNote2:
                Call    MouseSetXY

                Xor     AX, AX
                Ret

EndP            MouseSelectNote

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseSelectInst Far

                Mov     CS:MouseX, CX

                Mov     CS:SampleMouseCondition, 1107h

                Push    CX

                Mov     CX, 8010h
                ShR     DX, 3
                Sub     DX, 13
                Call    AddMouseQueue

                Pop     CX
                And     DX, DX
                JNS     MouseSelectInst1

                Mov     DX, 13*8
                Jmp     MouseSelectInst2

MouseSelectInst1:
                Cmp     DX, 35
                JB      MouseSelectInst3

                Mov     DX, 48*8-1

MouseSelectInst2:
                Call    MouseSetXY

MouseSelectInst3:
                Xor     AX, AX
                Ret

EndP            MouseSelectInst

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            AddSelectEvent

                Call    MouseGetStatus
                Test    AL, 6
                JNZ     AddSelectEvent1

                Mov     Word Ptr [SI+8], 102h

AddSelectEvent1:
                Call    MouseAddEvent

                Ret

EndP            AddSelectEvent

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_DrawSampleList Far

                Call    S_GetDestination

                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern

                Mov     AL, LastInstrument

                Test    AL, AL
                JNZ     I_DrawSampleList1

                Inc     AX
                Mov     LastInstrument, AL

I_DrawSampleList1:
                Push    CS
                Pop     DS
                        Assume DS:Inst

                Mov     BX, TopSample
                Cmp     BL, AL
                JBE     I_DrawSampleList2

                Mov     BL, AL

I_DrawSampleList2:                                ; BL = top, AL = current
                Mov     CL, BL
                Add     CL, 34
                Cmp     CL, AL
                JAE     I_DrawSampleList3

                Mov     BL, AL
                Sub     BL, 34

I_DrawSampleList3:
                Mov     TopSample, BX
                                                ; BX = topinstrument

                Mov     DI, (2+13*80)*2

                Mov     DX, 0A23h

I_DrawSampleList4:
                Mov     AX, BX
                Div     DH
                                                ; AH = units, AL = tens
                Add     AL, '0'
                StosB
                Mov     AL, 20h
                StosB
                XChg    AH, AL
                Add     AL, '0'
                StosW

                Inc     BX
                Add     DI, 156
                Dec     DL
                JNE     I_DrawSampleList4

                Mov     BX, TopSample

                Call    Music_GetSongSegment
                Mov     DS, AX
                        Assume DS:Nothing

                Mov     CX, 35
                Mov     DI, (5+13*80)*2
                Dec     BX
                Add     BX, BX
                Mov     SI, [BX+64912]

I_DrawSampleList5:
                Push    CX
                Push    SI
                Push    DI

                Add     SI, 14h
                Mov     CX, 25
                Mov     AH, 6

I_DrawSampleList6:
                LodsB
                Cmp     AL, 226
                JB      I_DrawSampleNoMouse

                Mov     AL, ' '

I_DrawSampleNoMouse:
                StosW
                Loop    I_DrawSampleList6

                Mov     AX, 2A8h
                StosW

                Mov     AX, 700h+'P'

                Test    Byte Ptr [SI-14h-25+12h], 1
                JZ      I_DrawSampleList8

                Mov     AH, 6

I_DrawSampleList8:
                StosW
                Mov     AL, 'l'
                StosW
                Mov     AL, 'a'
                StosW
                Mov     AL, 'y'
                StosW

                Pop     DI
                Pop     SI
                Pop     CX
                Add     SI, 80
                Add     DI, 160

                Loop    I_DrawSampleList5

                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern

                Mov     AL, LastInstrument
                Xor     AH, AH
                Sub     AX, TopSample
                Add     AX, 13
                Mov     BX, 160
                Mul     BX
                Add     AX, 10
                Mov     DI, AX

                Mov     CX, 30

I_DrawSampleList7:
                Mov     AX, [ES:DI]
                And     AH, 0Fh
                Or      AH, 0E0h
                StosW

                Loop    I_DrawSampleList7

                                ; Add on pointer...
                Push    CS
                Pop     DS
                        Assume DS:Inst

                Mov     SI, Offset SampleMouseEvent
                Mov     Word Ptr [SI+4], 35*8-1
                Mov     Word Ptr [SI+10], 28
                Call    AddSelectEvent
                Mov     SI, Offset SampleMouseOffEvent
                Mov     Word Ptr [SI+4], 35*8-1
                Call    MouseAddEvent

                Ret

EndP            I_DrawSampleList
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_PreSampleList Far

                Call    S_GetDestination
                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern

                Mov     AL, LastInstrument
                Xor     AH, AH
                Mov     SI, AX
                Sub     AX, TopSample
                Add     AX, 13
                Mov     BX, 160
                Mul     BX
                Add     AX, 10
                Mov     DI, AX

                Mov     AX, SamplePos
                Cmp     AX, 25
                JB      I_PreSampleList1

                Call    Music_GetSongSegment
                Mov     DS, AX
                        Assume DS:Nothing

                Dec     SI
                Add     SI, SI
                Mov     SI, [SI+64912]

                Mov     CX, 4
                Add     DI, 52
                Mov     AL, 30h
                Test    Byte Ptr [SI+12h], 1
                JNZ     I_PreSampleList2

                Mov     AL, 60h

I_PreSampleList2:
                Inc     DI
                StosB

                Loop    I_PreSampleList2

                Ret

I_PreSampleList1:
                Add     DI, AX
                Add     DI, AX

                Mov     AL, 30h
                Inc     DI
                StosB
                Ret

EndP            I_PreSampleList

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_PostSampleList Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Mov     SI, Offset SampleListKeys
                Call    M_FunctionDivider
                JC      I_PostSampleList7

                Jmp     [SI]

I_PostSampleList7:

                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern

                Mov     AL, LastInstrument
                Xor     AH, AH
                Mov     SI, AX
                Dec     SI

                Mov     AX, SamplePos
                Cmp     AX, 25
                JAE     I_PostSampleList2

                Mov     BX, AX                  ; BX = Pos. SI = LastInst
                Call    Music_GetSongSegment
                Mov     DS, AX
                        Assume DS:Nothing

                Add     SI, SI
                Mov     SI, [64912+SI]          ; SI = sample offset.

                Test    CL, CL
                JZ      I_PostSampleList1
                Cmp     DL, 32                  ; Space bar or less??
                JB      I_PostSampleList1

                Add     BX, 14h                 ; To sample name.
                Add     BX, SI
                Add     SI, 2Ch

I_PostSampleList3:
                Cmp     SI, BX
                JBE     I_PSL3

                Mov     AL, [SI-1]
                Mov     [SI], AL
                Dec     SI
                Jmp     I_PostSampleList3

I_PSL3:
                Mov     [SI], DL

                Inc     SamplePos

                Jmp     I_PostSampleListEnd

I_PostSampleList1:
                Cmp     CX, 10Eh
                JNE     I_PostSampleList4

                And     BX, BX
                JZ      I_PostSampleList4

                Dec     SamplePos
                Add     BX, 14h
                Add     BX, SI
                Add     SI, 2Dh

I_PostSampleList5:
                Mov     AL, [BX]
                Mov     [BX-1], AL
                Inc     BX
                Cmp     BX, SI
                JB      I_PostSampleList5

                Mov     Byte Ptr [BX-1], 0

I_PostSampleListEnd:
                NetworkSendSample

                Mov     AX, 1
                Ret

I_PostSampleList4:
                Cmp     CX, 1D3h                        ; Delete...
                JNE     I_PostSampleList6

                Add     BX, 15h
                Add     BX, SI
                Add     SI, 2Dh
                Jmp     I_PostSampleList5

I_PostSampleList6:
                Xor     AX, AX
                Ret

I_PostSampleList2:                              ; Play note....
                Push    CS
                Pop     DS

                Test    CH, Not 1
                JNZ     I_PostSampleList9

                Cmp     CX, LastKey
                JE      I_PostSampleList9

                Mov     LastKey, CX


                Mov     SI, Offset KeyBoardTable

I_PostSampleList8:
                LodsW
                Cmp     AX, 0FFFFh
                JE      I_PostSampleList9

                Mov     BX, AX
                LodsW

                Cmp     BL, CL
                JNE     I_PostSampleList8
                                                ; Note to play...
                                                ; AX = notemod.
                And     CH, CH
                JZ      I_PostSampleList10

                Mov     CX, AX

                Mov     AX, Pattern
                Mov     DS, AX
                                Assume DS:Pattern

                Mov     AL, 12
                Mul     BaseOctave
                Add     AL, CL
                Mov     AH, LastInstrument

                Push    CS
                Pop     DS
                                Assume DS:Inst

                Call    UpdateMultiChannel

                Mov     LastPlaySample, AL

                Mov     CX, PlayChannel
                Call    Music_PlaySample
                Jmp     I_PostSampleList9

I_PostSampleList10:
                Mov     SI, Offset NoteData
                Mov     Word Ptr [SI], 0FFh
                Mov     AX, PlayChannel
                Mov     DH, 32+128
                Call    Music_PlayNote  ; Note off.

I_PostSampleList9:
                Xor     AX, AX
                Ret

EndP            I_PostSampleList

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SampleLeft Far

                Mov     AX, SamplePos
                Dec     AX
                JS      I_SampleLeft1

                Mov     SamplePos, AX

I_SampleLeft1:
                Mov     AX, 1
                Ret

EndP            I_SampleLeft

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SampleRight Far

                Mov     AX, SamplePos
                Inc     AX
                Cmp     AX, 25
                JA      I_SampleRight1

                Mov     SamplePos, AX

I_SampleRight1:
                Mov     AX, 1
                Ret

EndP            I_SampleRight

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_RedrawWave

                Call    Glbl_GetCurrentMode

                Cmp     AL, 3
                JE      I_RedrawWave1
                Cmp     AL, 4
                JNE     I_RedrawWave2

                Call    I_MapEnvelope
                Ret

I_RedrawWave1:
                Call    I_DrawWaveForm

I_RedrawWave2:
                Ret

EndP            I_RedrawWave

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SelectInstrument2
                Assume DS:Inst

                                ; Set Instrument pos...
                Mov     AX, MouseX
                ShR     AX, 3
                Sub     AX, 5
                JNC     I_SelectInstrument8

                Xor     AX, AX

I_SelectInstrument8:
                Cmp     AX, 24
                JB      I_SelectInstrument7

                Mov     AX, 24

I_SelectInstrument7:
                Mov     InstrumentPos, AX

                Add     DX, TopInstrument
                Jmp     I_SelectInstrument4

Proc            I_SelectInstrument Far

                Mov     AX, MouseX
                Sub     AX, 40
                ShR     AX, 3
                Cmp     AX, 25
                JB      I_SelectInstrument6

                Mov     AX, 25

I_SelectInstrument6:
                Mov     SamplePos, AX

                Add     DX, TopSample

I_SelectInstrument4:
                Cmp     DX, 1
                JGE     I_SelectInstrument1

                Mov     DX, 1

I_SelectInstrument1:
                Cmp     DX, 99
                JL      I_SelectInstrument3

                Mov     DX, 99

I_SelectInstrument3:
                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern

                Cmp     DL, LastInstrument
                Mov     LastInstrument, DL
                JE      I_SelectInstrument5

                Call    I_RedrawWave

I_SelectInstrument5:
                Mov     AX, 1
                Ret

EndP            I_SelectInstrument

EndP            I_SelectInstrument2
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SampleDown Far

                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern

                Mov     AL, LastInstrument

                Inc     AX
                Cmp     AL, 100
                JAE     I_SampleDown1

                Mov     LastInstrument, AL
                Call    I_RedrawWave

I_SampleDown1:

                Mov     AX, 1
                Ret

EndP            I_SampleDown
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SampleUp Far

                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern

                Mov     AL, LastInstrument

                Dec     AL
                JZ      I_SampleUp1

                Mov     LastInstrument, AL
                Call    I_RedrawWave

I_SampleUp1:
                Mov     AX, 1
                Ret

EndP            I_SampleUp
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SamplePgUp Far

                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern

                Mov     AL, LastInstrument

                Cmp     AL, 1
                JE      I_SamplePgUp3

                Sub     AL, 16
                JZ      I_SamplePgUp1
                JNC     I_SamplePgUp2

I_SamplePgUp1:
                Mov     AL, 1

I_SamplePgUp2:
                Mov     LastInstrument, AL
                Call    I_RedrawWave

I_SamplePgUp3:
                Mov     AX, 1
                Ret

EndP            I_SamplePgUp
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SamplePgDn Far

                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern

                Mov     AL, LastInstrument
                Cmp     AL, 99
                JE      I_SamplePgDn2

                Add     AL, 16
                Cmp     AL, 99
                JBE     I_SamplePgDn1

                Mov     AL, 99

I_SamplePgDn1:
                Mov     LastInstrument, AL
                Call    I_RedrawWave

I_SamplePgDn2:
                Mov     AX, 1
                Ret

EndP            I_SamplePgDn
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SampleCtrlPgUp Far

                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern

                Mov     LastInstrument, 1
                Call    I_RedrawWave

                Mov     AX, 1
                Ret

EndP            I_SampleCtrlPgUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SampleCtrlPgDn Far

                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern

                Mov     LastInstrument, 99
                Call    I_RedrawWave

                Mov     AX, 1
                Ret

EndP            I_SampleCtrlPgDn

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SampleEnd Far

                Mov     SamplePos, 25

                Mov     AX, 1
                Ret

EndP            I_SampleEnd

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SampleHome Far

                Mov     SamplePos, 0

                Mov     AX, 1
                Ret

EndP            I_SampleHome

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SampleTab Far

                Mov     Word Ptr [ES:DI], 7

                Mov     AX, 1
                Ret

EndP            I_SampleTab

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_ShowSampleInfo Far

                Call    I_GetSampleOffset

                Push    DWord Ptr [BX+30h]

                Mov     AL, [BX+12h]

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Mov     SI, Offset NoSampleMsg

                Mov     AH, 2
                Test    AL, 1
                JZ      I_ShowSampleInfo1

                Mov     SI, Offset Quality8Msg
                Test    AL, 2
                JZ      I_ShowSampleInfo1

                Mov     SI, Offset Quality16Msg

I_ShowSampleInfo1:
                Mov     DI, (64+22*80)*2
                Call    S_DrawString

I_ShowSampleInfo2:
                Mov     DI, (64+23*80)*2
                Mov     SI, Offset LengthMsg
                Call    S_DrawString

                Pop     EAX

                Ret

EndP            I_ShowSampleInfo

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_VibratoButtonSelect Far

                Call    I_GetSampleOffset
                Mov     AL, [BX+04Fh]           ; AL = type.
                Xor     AH, AH

                Add     DI, 82
                Xor     CX, CX

I_VibratoButtonSelect1:
                Mov     SI, [ES:DI]

                Mov     CH, AH                  ; Assume up
                Cmp     AL, CL
                JNE     I_VibratoButtonSelect2

                Inc     CH

I_VibratoButtonSelect2:
                Mov     [ES:SI+33], CH

;                Add     DI, 2
                ScasW
                Inc     CX
                Cmp     CL, 3
                JLE     I_VibratoButtonSelect1

                Ret

EndP            I_VibratoButtonSelect

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SetVibratoWaveform Far                ; AH = waveform.

                Mov     AX, [SI+24]
                Push    AX
                Call    I_GetSampleOffset
                Pop     AX

                Mov     [BX+4Fh], AL

                Ret

EndP            I_SetVibratoWaveform

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_CheckLoopValues Far

                Call    I_GetSampleOffset

                Mov     EAX, [BX+30h]
                Sub     EAX, 1
                AdC     EAX, 0
                Cmp     EAX, [BX+34h]
                JA      I_CheckLoopValues3

                Mov     [BX+34h], EAX

I_CheckLoopValues3:
                Inc     EAX
                Cmp     EAX, [BX+38h]
                JAE     I_CheckLoopValues2

                Mov     [BX+38h], EAX

I_CheckLoopValues2:
                Mov     EAX, [BX+38h]
                Cmp     EAX, [BX+34h]
                JA      I_CheckLoopValues1

                And     Byte Ptr [BX+12h], NOT 00010000b

I_CheckLoopValues1:
                Call    Music_RegetLoopInformation
                Call    I_DrawWaveForm
                Ret

EndP            I_CheckLoopValues

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_CheckSusLoopValues Far

                Call    I_GetSampleOffset

                Mov     EAX, [BX+30h]
                Sub     EAX, 1
                AdC     EAX, 0
                Cmp     EAX, [BX+40h]
                JA      I_CheckSusLoopValues3

                Mov     [BX+40h], EAX

I_CheckSusLoopValues3:
                Inc     EAX
                Cmp     EAX, [BX+44h]
                JAE     I_CheckSusLoopValues2

                Mov     [BX+44h], EAX

I_CheckSusLoopValues2:
                Mov     EAX, [BX+44h]
                Cmp     EAX, [BX+40h]
                JA      I_CheckLoopValues1

                And     Byte Ptr [BX+12h], NOT 00100000b

I_CheckSusLoopValues1:
                Call    Music_RegetLoopInformation
                Call    I_DrawWaveForm
                Ret

EndP            I_CheckSusLoopValues

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_DrawWaveForm Far

                Mov     [CS:LastWaveformValues], 7f80h

                Call    S_GetGenerationTableOffset
                Push    DI
                Mov     CX, 176*32
                Xor     AL, AL
                Rep     StosB
                Pop     DI

                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern

                Mov     AL, LastInstrument
                And     AL, AL
                JNZ     I_DrawWaveForm1

                Mov     AL, 1

I_DrawWaveForm1:
                Mov     LastInstrument, AL
                Xor     AH, AH
                Xor     CX, CX
                Call    Music_GetSampleLocation
                        Assume DS:Nothing

                JC      I_DrawWaveFormEnd

                SetNZ   CS:Resolution
                JZ      I_DrawWaveForm8Bit

                Add     ECX, ECX
                Inc     SI

I_DrawWaveForm8Bit:
                Test    ECX, ECX
                JZ      I_DrawWaveFormEnd

                Push    AX              ; AX = instrument num
                                        ; DS:ESI = waveform, ECX = length
                                        ; ES:DI = charactergenerationtable

                Mov     EAX, ECX
                Mov     ECX, 176
                Xor     EDX, EDX
                Div     ECX              ; EAX = major shift. EDX = minor shift.

                Mov     EBX, EAX
                Xor     EAX, EAX
                Div     ECX

                Mov     EDX, EAX
                Xor     EAX, EAX

                Mov     EBP, ESI

I_DrawWaveForm6:
                Add     EAX, EDX
                AdC     EBP, EBX
                Push    EAX
                Push    EBX
                Push    ECX
                Push    EDX

                Mov     CL, [SI]
                Mov     CH, CL
                MovZX   BX, CS:Resolution
                Inc     BX

I_DrawWaveForm10:
                Cmp     ESI, EBP
                JAE     I_DrawWaveForm7

                Mov     AL, [SI]
                Add     SI, BX          ; Get max/min vals.
                JC      I_DrawWaveformNewBlock

I_DrawWaveformResume:
                Cmp     AL, CL
                JL      I_DrawWaveForm8

                Cmp     AL, CH
                JLE     I_DrawWaveForm10

                Mov     CH, AL
                Jmp     I_DrawWaveForm10

I_DrawWaveformNewBlock:
                Add     ESI, 10000h
                Int     3
                Jmp     I_DrawWaveFormResume

I_DrawWaveForm8:
                Mov     CL, AL
                Jmp     I_DrawWaveForm10

I_DrawWaveForm7:                                ; CL = min, CH = max.
                Mov     AX, CX

                XChg    CX, [CS:LastWaveformValues]

                Cmp     AL, CH
                JL      I_DrawWaveform7a

                Mov     AL, CH

I_DrawWaveform7a:
                Cmp     AH, CL
                JG      I_DrawWaveform7b

                Mov     AH, CL

I_DrawWaveform7b:
                SAR     AH, 1
                SAR     AL, 1
                Add     AX, 202h
                SAR     AH, 2
                SAR     AL, 2

                Xor     CH, CH
                Mov     CL, AH
                Sub     CL, AL                  ; CX = iterations.
                Inc     CX

                Mov     AL, 16
                Sub     AL, AH
                Cmp     AL, 32
                JNE     I_DrawWaveForm13

                Mov     AL, 31

I_DrawWaveForm13:
                Mov     AH, 176
                Mul     AH
                Mov     BX, AX

I_DrawWaveForm11:
                Mov     Byte Ptr [ES:DI+BX], 1
                Add     BX, 176
                Loop    I_DrawWaveForm11

I_DrawWaveForm12:
                Pop     EDX
                Pop     ECX
                Pop     EBX
                Pop     EAX
                Inc     DI
                Loop    I_DrawWaveForm6

                                                ; Get Sample header offset.
                Call    Music_GetSongSegment
                Mov     DS, AX
                Pop     SI
                Dec     SI
                Add     SI, SI
                Mov     SI, [64912+SI]

                Mov     EBX, [DS:SI+30h]
                Test    Byte Ptr [DS:SI+12h], 10h
                JZ      I_DrawWaveForm14

                Mov     ECX, EBX
                ShR     ECX, 1

                Mov     EAX, 175
                Mul     DWord Ptr [DS:SI+34h]
                Add     EAX, ECX
                AdC     EDX, 0
                Div     EBX

                Push    EAX              ; AX = loop start.

                Mov     EAX, 175
                Mul     DWord Ptr [DS:SI+38h]
                Add     EAX, ECX
                AdC     EDX, 0
                Div     EBX
                Mov     EDX, EAX
                Pop     EAX                     ; EDX = loop end (0-175)
                                                ; EAX = loop start (0-175)

                Call    S_GetGenerationTableOffset
                                                ; ES:DI
                Add     DI, AX
                Sub     DX, AX
                Dec     DX
                Mov     CX, 32
                Mov     AH, 1

I_DrawSampleWaveFormLoop1:
                Push    DI

;                Xor     AL, AL
;                Test    AH, 2
;                JZ      I_DrawSampleWaveFormLoop2
;
;                Inc     AL
;
;I_DrawSampleWaveFormLoop2:
                Mov     AL, AH
                ShR     AL, 1
                And     AL, 1

                StosB
                Add     DI, DX
                StosB

                Pop     DI
                Add     DI, 176
                Inc     AH
                Loop    I_DrawSampleWaveFormLoop1

I_DrawWaveForm14:
                Test    Byte Ptr [DS:SI+12h], 20h
                JZ      I_DrawWaveFormEnd

                Mov     ECX, EBX
                ShR     ECX, 1

                Mov     EAX, 175
                Mul     DWord Ptr [DS:SI+40h]
                Add     EAX, ECX
                AdC     EDX, 0
                Div     EBX

                Push    EAX              ; AX = loop start.

                Mov     EAX, 175
                Mul     DWord Ptr [DS:SI+44h]
                Add     EAX, ECX
                AdC     EDX, 0
                Div     EBX
                Mov     EDX, EAX
                Pop     EAX                      ; DX = loop end (0-175)
                                                ; AX = loop start (0-175)

                Call    S_GetGenerationTableOffset
                                                ; ES:DI
                Add     DI, AX
                Sub     DX, AX
                Dec     DX
                Mov     CX, 32
                Mov     AL, 1

I_DrawSampleWaveFormSusLoop1:
                Push    DI

                StosB
                Add     DI, DX
                StosB

                Pop     DI
                Add     DI, 176
                Xor     AL, 1
                Loop    I_DrawSampleWaveFormSusLoop1

I_DrawWaveFormEnd:
                Mov     AX, 1
                Mov     BX, 22
                Mov     CX, 4
                Call    S_GenerateCharacters

                Ret

EndP            I_DrawWaveForm

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_DeleteSample Far

                Mov     DI, Offset O1_ConfirmDeleteSample
                Mov     CX, 4
                Call    M_Object1List

                And     DX, DX
                JZ      I_DeleteSample1

                Call    Music_Stop

                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern

                Mov     AL, LastInstrument
                Dec     AX
                Xor     AH, AH

                Call    Music_ReleaseSample
                Call    Music_ClearSampleName

                Call    I_DrawWaveForm

I_DeleteSample1:
                Mov     AX, 1
                Ret

EndP            I_DeleteSample
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

C5Speed         DD      0

Proc            I_CalculateC5Speed Far

                Mov     AX, 1
                Ret

Comment !
                Push    DiskData
                Pop     ES
                Call    Fourier_CreateTable

                Call    PE_GetLastInstrument            ; Into BX
                Mov     AX, BX
                Inc     AX

                Xor     CX, CX
                Call    Music_GetSampleLocation         ; Returns DS:ESI, ECX
                JC      I_CalculateC5SpeedEnd

                PushF
                Mov     DX, 2048
                Mov     DI, 16384

                Cmp     CX, DX
                JB      I_CalculateC5Speed1

                Mov     CX, DX

I_CalculateC5Speed1:
                Sub     DX, CX
                PopF
                JNZ     I_CalculateC5Speed16Bit

I_CalculateC5Speed8Bit:
                LodsB
                StosW
                Loop    I_CalculateC5Speed8Bit
                Jmp     I_CalculateC5Speed2

I_CalculateC5Speed16Bit:
                Rep     MovsW

I_CalculateC5Speed2:
                Mov     CX, DX
                Xor     AX, AX
                Rep     StosW

                Push    ES
                Pop     DS
                Call    Fourier_Transform

Comment ~

                Mov     DX, 1
                JZ      I_CalculateC5BitSkip

                Inc     DX

I_CalculateC5BitSkip:
                Mov     EBP, ECX                ; EBP = number of samples

I_CalculateC5Speed1:
                Sub     EBP, 512
                JC      I_CalculateC5SpeedDisplay

                Mov     DI, 16384
                Mov     BX, 512

I_CalculateC5Loop1:
                Cmp     DX, 2
                JE      I_CalculateC5Speed16Bit

I_CalculateC5Speed8Bit:
                Mov     AL, [SI]
                Mov     AH, AL
                Jmp     I_CalculateC5SpeedTransfer

I_CalculateC5Speed16Bit:
                Mov     AX, [SI]

I_CalculateC5SpeedTransfer:
;                StosW
                Mov     CX, 4
                Rep     StosW

                Add     SI, DX
                JC      I_CalculateC5UpdateSampleLocation

I_CalculateC5Continue:
                Dec     BX
                JNZ     I_CalculateC5Loop1

; OK.. do fourier
                Push    DS
                PushAD

                Call    Fourier_Transform

; Now accumulate
                Mov     CX, 1024-64
                Mov     SI, 24576+64*4
                Mov     DI, 32768+64*4

I_CalculateC5Speed2:
                FLd     DWord Ptr [SI]
                FAdd    DWord Ptr [DI]
                FStP    DWord Ptr [DI]
                Add     SI, 4
                Add     DI, 4
                Loop    I_CalculateC5Speed2

                PopAD
                Pop     DS
                Jmp     I_CalculateC5Speed1

I_CalculateC5UpdateSampleLocation:
                Add     ESI, 10000h
                Int     3
                Jmp     I_CalculateC5Continue

I_CalculateC5SpeedDisplay:
                Push    ES
                Pop     DS
~
                Mov     SI, 24768
                Xor     CX, CX
                Xor     EAX, EAX
                Xor     EBX, EBX

I_CalculateC5Speed3:
                Cmp     EAX, [SI]
                JAE     I_CalculateC5Speed4

                Mov     BX, CX
                Mov     EAX, [SI]

I_CalculateC5Speed4:
                Add     SI, 4
                Inc     CX

                Cmp     CX, 1024
                JB      I_CalculateC5Speed3

; Have BX = wavelength.
                Mov     EAX, 17145893   ; = C5Freq * 65536
                Mul     EBX             ; EDX:EAX = frequency in 48:16 format
                ShRD    EAX, EDX, 16

                Mov     CS:C5Speed, EAX
; EAX = C5Freq
                Mov     DI, Offset O1_C5FrequencyList
                Call    M_Object1ListDefault

I_CalculateC5SpeedEnd:
                Mov     AX, 1
                Ret
!

EndP            I_CalculateC5Speed

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_PrintC5Frequency Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Push    C5Speed

                Mov     SI, Offset C5FrequencyText
                Mov     AH, 20h
                Mov     DI, (27+27*80)*2
                Call    S_DrawString

                Pop     AX      ; Clean up stack.
                Pop     BX

                Ret

EndP            I_PrintC5Frequency
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_DeleteInstrument Far

                Mov     DI, Offset O1_ConfirmDeleteInstrument
                Mov     CX, 4
                Call    M_Object1List

                And     DX, DX
                JZ      I_DeleteInstrument1

                Call    Music_Stop

                Call    I_GetInstrumentOffset   ; Gets DS:BX

                Mov     CX, 120
                Add     BX, 41h

I_DeleteInstrument2:
                Mov     AL, [BX]
                And     AX, 0FFh
                JZ      I_DeleteInstrument3

                Push    DS
                Push    BX
                Push    CX

                Dec     AX

                Call    Music_ReleaseSample
                Call    Music_ClearSampleName

                Pop     CX
                Pop     BX
                Pop     DS

I_DeleteInstrument3:
                Add     BX, 2
                Loop    I_DeleteInstrument2

                Call    I_InstrumentClear     ; This sends network data already

I_DeleteInstrument1:
                Mov     AX, 1
                Ret

EndP            I_DeleteInstrument

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_ConvertSample Far             ; Signed/Unsigned

                EnsureNoNetwork

                Call    PE_GetLastInstrument
                Mov     CX, BX
                Inc     CX
                Add     BX, BX

                Call    Music_GetSongSegment
                Mov     DS, AX
                Mov     SI, [64912+BX]
                Test    Byte Ptr [DS:SI+12h], 1
                JZ      I_ConvertSample1

                Push    CX

                Mov     DI, Offset O1_ConfirmConvertList
                Mov     CX, 3
                Call    M_Object1List

                Pop     AX              ; AX = sample number

                And     DX, DX
                JZ      I_ConvertSample1

                Call    Music_Stop

                Xor     CX, CX
                Call    Music_GetSampleLocation         ; DS:SI = location
                JC      I_ConvertSample1                ; CX = length.

                SetNZ   BL
                Xor     BH, BH
                Add     SI, BX

                Inc     BX


I_ConvertSample2:
                Xor     Byte Ptr [SI], 80h
                Add     SI, BX
                JC      I_ConvertSample3

I_ConvertSample4:
                LoopD   I_ConvertSample2

                Call    I_DrawWaveForm
                Call    Music_SoundCardLoadAllSamples

I_ConvertSample1:
                Mov     AX, 1
                Ret

I_ConvertSample3:
                Add     ESI, 10000h
                Int     3
                Jmp     I_ConvertSample4

EndP            I_ConvertSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_InvertSample Far             ; Signed/Unsigned

                EnsureNoNetwork

                Call    PE_GetLastInstrument
                Mov     CX, BX
                Inc     CX
                Add     BX, BX

                Call    Music_GetSongSegment
                Mov     DS, AX
                Mov     SI, [64912+BX]
                Test    Byte Ptr [DS:SI+12h], 1
                JZ      I_InvertSample1

                XChg    AX, CX          ; AX = sample number.

                Xor     CX, CX
                Call    Music_GetSampleLocation        ; DS:SI = location
                JC      I_InvertSample1                ; CX = length.
                JNZ     I_InvertSample_16Bit

I_InvertSample2:
                Neg     Byte Ptr [SI]
                Add     SI, 1
                JC      I_InvertSample3

I_InvertSample4:
                LoopD   I_InvertSample2

I_InvertSampleExit:
                Call    I_DrawWaveForm
                Call    Music_SoundCardLoadAllSamples

I_InvertSample1:
                Mov     AX, 1
                Ret

I_InvertSample3:
                Add     ESI, 10000h
                Int     3
                Jmp     I_InvertSample4

I_InvertSample_16Bit:
                Neg     Word Ptr [SI]
                Add     SI, 2
                JC      I_InvertSample_16Bit2

I_InvertSample_16Bit1:
                LoopD   I_InvertSample_16Bit

                Jmp     I_InvertSampleExit

I_InvertSample_16Bit2:
                Add     ESI, 10000h
                Int     3
                Jmp     I_InvertSample_16Bit1

EndP            I_InvertSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_CutSampleBeforeLoopUpdateLoop Near

                Sub     [DS:BX+DI], EDX
                JNC     I_CutSampleBeforeLoopUpdateLoop1

                Mov     DWord Ptr [DS:BX+DI], 0

I_CutSampleBeforeLoopUpdateLoop1:
                Add     DI, 4
                Ret

EndP            I_CutSampleBeforeLoopUpdateLoop

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_CutSampleBeforeLoop Far

                EnsureNoNetwork

                Call    I_GetSampleOffset

                Cmp     DWord Ptr [DS:BX+34h], 0
;                Test    Byte Ptr [DS:BX+12h], 10h
                JZ      I_CutSampleBeforeLoop1

                Push    DS
                Push    BX

                Mov     DI, Offset O1_ConfirmCutSample
                Mov     CX, 4
                Call    M_Object1List

                Pop     BX
                Pop     DS

                And     DX, DX
                JZ      I_CutSampleBeforeLoop1

                Call    Music_Stop

                Mov     EDX, [DS:BX+34h]
                Test    Byte Ptr [DS:BX+12h], 32
                JZ      I_CutSampleBeforeLoop2

                Mov     EAX, [DS:BX+40h]

                Cmp     EDX, EAX
                JB      I_CutSampleBeforeLoop2
                Mov     EDX, EAX

I_CutSampleBeforeLoop2:
                Mov     DI, 34h
                Call    I_CutSampleBeforeLoopUpdateLoop ; BX+34h - Begin
                Call    I_CutSampleBeforeLoopUpdateLoop ; BX+38h - End

                Add     DI, 4
                Call    I_CutSampleBeforeLoopUpdateLoop ; BX+40h - SusLBeg
                Call    I_CutSampleBeforeLoopUpdateLoop ; BX+44h - SusLEnd

I_CutSampleBeforeLoop4:
                Sub     [BX+30h], EDX
                Mov     ECX, [BX+30h]

                Test    Byte Ptr [BX+12h], 2
                JZ      I_CutSampleBeforeLoop6

                Add     EDX, EDX
                Add     ECX, ECX

I_CutSampleBeforeLoop6:
                Mov     ESI, EDX
                Call    I_RepositionSample

                                                ; To diskdata segment first.
                Mov     AX, DiskData
                Mov     ES, AX
                        Assume ES:Nothing

                Xor     EDI, EDI

I_CutSampleBeforeLoop7:
                Mov     AL, [SI]
                Mov     [ES:DI], AL

                Add     SI, 1
                JC      I_CutSampleBeforeLoop8

I_CutSampleBeforeLoop9:
                Add     DI, 1
                JC      I_CutSampleBeforeLoop10

I_CutSampleBeforeLoop11:
                LoopD   I_CutSampleBeforeLoop7

                Mov     ESI, EDI
                Int     3
                Mov     CX, DI

                Push    DS
                Push    ES
                Pop     DS
                Pop     ES              ; Swap DS and ES

                Xor     SI, SI
                Xor     DI, DI
                Rep     MovsB

                Call    I_DrawWaveForm
                Call    Music_SoundCardLoadAllSamples

I_CutSampleBeforeLoop1:
                Mov     AX, 1
                Ret

I_CutSampleBeforeLoop8:
                Add     ESI, 10000h
                Int     3
                Jmp     I_CutSampleBeforeLoop9

I_CutSampleBeforeLoop10:
                PushAD
                Push    DS
                Push    ES

                Mov     ESI, EDI
                Int     3

                Push    DS
                Push    ES
                Pop     DS
                Pop     ES                      ; Swap DS and ES

                Mov     CX, 16384
                Xor     SI, SI
                Xor     DI, DI
                Rep     MovsD

                Pop     ES
                Pop     DS
                PopAD

                Add     EDI, 10000h

                Int     3
                Jmp     I_CutSampleBeforeLoop11

EndP            I_CutSampleBeforeLoop

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_CutSample Far

                EnsureNoNetwork

                Call    I_GetSampleOffset

                Cmp     DWord Ptr [DS:BX+38h], 0
;                Test    Byte Ptr [DS:BX+12h], 10h       ; Loop?
                JZ      I_CutSample1

                Push    DS
                Push    BX

                Mov     DI, Offset O1_ConfirmCutSample
                Mov     CX, 4
                Call    M_Object1List

                Pop     BX
                Pop     DS

                And     DX, DX
                JZ      I_CutSample1

                Call    Music_Stop

                Mov     EAX, [DS:BX+38h]
                Mov     EDX, [DS:BX+44h]
                Cmp     EAX, EDX
                JAE     I_CutSample2
                Mov     EAX, EDX

I_CutSample2:
                Mov     [DS:BX+30h], EAX

                Call    I_DrawWaveForm
                Call    Music_SoundCardLoadAllSamples

I_CutSample1:
                Mov     AX, 1
                Ret

Proc            I_CutSampleCheckValue Near

                Cmp     DWord Ptr [DS:BX+DI], EAX
                JBE     I_CutSampleCheckValue1

                Mov     [DS:BX+DI], EAX

I_CutSampleCheckValue1:
                Ret

EndP            I_CutSampleCheckValue

EndP            I_CutSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_ClearSampleName Far
                Assume DS:Inst

                Mov     SamplePos, 0

I_ClearSampleName2:
                Call    I_GetSampleOffset

                Push    DS
                Pop     ES

                Mov     DI, BX

I_ClearSampleName3:
                Add     DI, 4

                Mov     CX, 6
                Xor     AX, AX
                Rep     StosW

                Add     DI, 4
                Mov     CX, 13
                Rep     StosW

                NetworkSendSample

                Inc     AX
                Ret

EndP            I_ClearSampleName
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_InsertSample Far

                EnsureNoNetwork

                Call    Music_GetSongSegment
                Mov     DS, AX
                Mov     SI, [DS:64912+(99-1)*2]
                Test    Byte Ptr [SI+12h], 1
                JNZ     I_InsertSampleEnd

                Call    PE_GetLastInstrument
                Cmp     BL, 98
                JE      I_InsertSampleEnd

                Call    Music_Stop

                Call    PE_GetLastInstrument
                Mov     DL, BL
                Push    BX

                Call    Music_GetSongSegment

                Mov     ES, AX
                Mov     DS, AX

                Mov     AX, 98
                Sub     AX, BX
                Mov     CX, 80
                Add     BX, BX
                Mul     CX
                Mov     SI, [DS:64912+BX]
                Add     SI, AX
                Dec     SI
                LEA     DI, [SI+80]
                Mov     CX, AX

                StD
                Rep     MovsB
                ClD

                Mov     DWord Ptr [SI+1+48h], 0
                Mov     Byte Ptr [SI+1+12h], 0

                Call    Music_SoundCardLoadAllSamples

                Pop     AX
                Push    AX
                Call    Music_ClearSampleName

                Pop     DX
                Inc     DX                      ; DL = instrument

                Call    Music_GetInstrumentMode
                JZ      I_InsertSampleSampleMode
                                                        ; Instrument mode..
                                                        ; step through inst.

                Xor     EAX, EAX

I_InsertSample4:
                Mov     SI, [DS:64712+EAX*2]
                Add     SI, 41h

                Mov     CX, 120

I_InsertSample5:
                Cmp     [SI], DL
                JB      I_InsertSample6

                Cmp     Byte Ptr [SI], 99
                JAE     I_InsertSample6

                Inc     Byte Ptr [SI]

I_InsertSample6:
                Add     SI, 2
                Loop    I_InsertSample5

                Inc     AX
                Cmp     AX, 99
                JB      I_InsertSample4

                Jmp     I_InsertSampleFinished

I_InsertSampleSampleMode:
                Call    PE_InsertInstrument

I_InsertSampleFinished:
                Call    I_DrawWaveform

I_InsertSampleEnd:
                Mov     AX, 1
                Ret

EndP            I_InsertSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_RemoveSample Far

                EnsureNoNetwork

                Call    I_GetSampleOffset
                Test    Byte Ptr [BX+12h], 1
                JNZ     I_RemoveSampleEnd

                Call    Music_Stop

                Call    PE_GetLastInstrument
                Mov     DL, BL
                Push    BX

                Call    Music_GetSongSegment

                Mov     ES, AX
                Mov     DS, AX

                Mov     AX, 98
                Sub     AX, BX
                Mov     CX, 80
                Add     BX, BX
                Mul     CX
                Mov     DI, [DS:64912+BX]
                LEA     SI, [DI+80]
                Mov     CX, AX

                Rep     MovsB

                Pop     DX
                Inc     DX                      ; DL = instrument

                Push    DS
                Push    DI

                Mov     DWord Ptr [DI+48h], 0
                Mov     Byte Ptr [DI+12h], 0

                Call    Music_SoundCardLoadAllSamples

                Call    Music_GetInstrumentMode
                JZ      I_RemoveSampleSampleMode
                                                        ; Instrument mode..
                                                        ; step through inst.

                Xor     EAX, EAX

I_RemoveSample4:
                Mov     SI, [DS:64712+EAX*2]
                Add     SI, 41h

                Mov     CX, 120

I_RemoveSample5:
                Cmp     [SI], DL
                JB      I_RemoveSample6

                Dec     Byte Ptr [SI]

I_RemoveSample6:
                Add     SI, 2
                Loop    I_RemoveSample5

                Inc     AX
                Cmp     AX, 99
                JB      I_RemoveSample4

                Jmp     I_RemoveSampleFinished

I_RemoveSampleSampleMode:
                Call    PE_DeleteInstrument

I_RemoveSampleFinished:
                Call    I_DrawWaveform

                Pop     DI
                Pop     ES
                Jmp     I_ClearSampleName3

I_RemoveSampleEnd:
                Mov     AX, 1
                Ret

EndP            I_RemoveSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_InsertInstrument Far

                EnsureNoNetwork

                Call    PE_GetLastInstrument
                Cmp     BL, 98
                JE      I_InsertInstrumentEnd

                Call    Music_Stop

                Call    PE_GetLastInstrument
                Mov     DL, BL
                Push    BX

                Call    Music_GetSongSegment

                Mov     ES, AX
                Mov     DS, AX

                Mov     AX, 98
                Sub     AX, BX
                Mov     CX, 554
                Add     BX, BX
                Mul     CX
                Mov     SI, [DS:64712+BX]
                Add     SI, AX
                Dec     SI
                LEA     DI, [SI+554]
                Mov     CX, AX

                StD
                Rep     MovsB
                ClD

                Pop     DX
                Inc     DX                      ; DL = instrument

                Call    Music_GetInstrumentMode
                JZ      I_InsertInstrumentFinished

                Call    PE_InsertInstrument

I_InsertInstrumentFinished:
                Jmp     I_InstrumentClear       ; Sends network data

I_InsertInstrumentEnd:
                Mov     AX, 1
                Ret

EndP            I_InsertInstrument

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_RemoveInstrument Far

                EnsureNoNetwork

                Call    Music_Stop

                Call    PE_GetLastInstrument
                Mov     DL, BL
                Push    BX

                Call    Music_GetSongSegment

                Mov     ES, AX
                Mov     DS, AX

                Mov     AX, 98
                Sub     AX, BX
                Mov     CX, 554
                Add     BX, BX
                Mul     CX
                MOv     DI, [DS:64712+BX]
                LEA     SI, [DI+554]
                Mov     CX, AX

                Rep     MovsB

                Pop     DX
                Inc     DX                      ; DL = instrument

                Call    Music_GetInstrumentMode
                JZ      I_RemoveInstrumentFinished

                Call    PE_DeleteInstrument

I_RemoveInstrumentFinished:
                Mov     AX, 98
                Call    Music_ClearInstrument

                Call    I_MapEnvelope

I_RemoveInstrumentEnd:
                Mov     AX, 1
                Ret

EndP            I_RemoveInstrument

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetSampleNumber                         ; Carry if not a num.
                                                        ; DX otherwise,
                Push    CS
                Pop     DS

                Mov     SI, Offset SampleNumberInput
                Xor     DX, DX

GetSampleNumber1:
                LodsB
                And     AL, AL
                JZ      GetSampleNumber2

                Cmp     AL, '0'
                JB      GetSampleNumber3
                Cmp     AL, '9'
                JA      GetSampleNumber3

                Sub     AL, '0'
                XChg    DL, AL
                Mov     AH, 10
                Mul     AH
                Add     DL, AL

                Jmp     GetSampleNumber1

GetSampleNumber3:
                StC
                Ret

GetSampleNumber2:
                Test    DX, DX
                JZ      GetSampleNumber3

;                ClC
                Ret

EndP            GetSampleNumber

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetNumberInput          ; DI = Offset of list.
                                        ; Returns DX with sample number.

                Push    DI

                Mov     DI, Offset SampleNumberInput
                Push    CS
                Pop     ES
                Xor     AL, AL
                Mov     CX, 4
                Rep     StosB

                Pop     DI

                Call    S_SaveScreen

                Mov     CX, 3
                Call    M_Object1List

                Call    S_RestoreScreen

                And     DX, DX
                JZ      GetNumberInput1

                Call    Music_Stop

                Call    GetSampleNumber
                JC      GetNumberInput1

                Ret

GetNumberInput1:
                Pop     AX              ; Add SP, 2
                Mov     AX, 1
                RetF

EndP            GetNumberInput

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_ExchangeSamples Far

                        ; Clear input...

                EnsureNoNetwork

                Mov     DI, Offset O1_ExchangeSampleList
                Call    GetNumberInput

                Mov     SI, DX
                Dec     SI
                Add     SI, SI

                Call    PE_GetLastInstrument
                Add     BX, BX

                Cmp     BX, SI
                JE      I_ExchangeSamples1

                Call    Music_GetSongSegment
                Mov     ES, AX
                Mov     DS, AX
                Mov     DI, [DS:64912+BX]
                Mov     SI, [DS:64912+SI]               ; DS:SI, ES:DI point to
                                                        ; sample headers

                Mov     CX, 80

I_ExchangeSamples2:
                Mov     AL, [ES:DI]
                MovsB
                Mov     [DS:SI-1], AL

                Loop    I_ExchangeSamples2

                Call    I_DrawWaveForm
                Call    Music_SoundCardLoadAllSamples

I_ExchangeSamples1:
                Mov     AX, 1
                Ret

EndP            I_ExchangeSamples

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SwapSamples Far

                        ; Clear input...

                EnsureNoNetwork

                Mov     DI, Offset O1_SwapSampleList
                Call    GetNumberInput

                Mov     SI, DX
                Dec     SI
                Add     SI, SI

                Call    PE_GetLastInstrument
                Mov     DH, BL
                Inc     DH                              ; DH/DL = samples to swap
                Add     BX, BX

                Cmp     DL, DH
                JE      I_SwapSamples1

                Call    Music_GetSongSegment
                Mov     ES, AX
                Mov     DS, AX
                Mov     DI, [DS:64912+BX]
                Mov     SI, [DS:64912+SI]               ; DS:SI, ES:DI point to
                                                        ; sample headers

                Mov     CX, 80

I_SwapSamples2:
                Mov     AL, [ES:DI]                     ; Swapping headers.
                MovsB
                Mov     [DS:SI-1], AL

                Loop    I_SwapSamples2

                                                        ; Now to swap pattern
                                                        ; stuff...
                Call    Music_GetInstrumentMode
                JZ      I_SwapSamples3
                                                        ; Instrument mode..
                                                        ; step through inst.
                Xor     AX, AX

I_SwapSamples4:
                Push    AX

                Mov     BX, AX
                Add     BX, BX
                Mov     SI, [DS:64712+BX]
                Add     SI, 41h

                Mov     CX, 120

I_SwapSamples5:
                Mov     AL, [SI]
                Cmp     AL, DL
                JNE     I_SwapSamples6

                Mov     [SI], DH
                Jmp     I_SwapSamples7

I_SwapSamples6:
                Cmp     AL, DH
                JNE     I_SwapSamples7

                Mov     [SI], DL

I_SwapSamples7:
                Add     SI, 2
                Loop    I_SwapSamples5

                Pop     AX

                Inc     AX
                Cmp     AX, 99
                JB      I_SwapSamples4

                Jmp     I_SwapSamples8

I_SwapSamples3:                                         ; Sample mode..
                Call    PE_SwapInstruments

I_SwapSamples8:
                Call    I_DrawWaveForm
                Call    Music_SoundCardLoadAllSamples

I_SwapSamples1:
                Mov     AX, 1
                Ret

EndP            I_SwapSamples

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_ReplaceSample Far

                EnsureNoNetwork

                Mov     DI, Offset O1_ReplaceSampleList
                Call    GetNumberInput

                Call    PE_GetLastInstrument
                Mov     DH, BL
                Inc     DH                              ; DH/DL = samples to swap

                Cmp     DL, DH
                JE      I_ReplaceSample1

                Call    Music_GetSongSegment
                Mov     ES, AX
                Mov     DS, AX
                                                        ; Now to swap pattern
                                                        ; stuff...
                Call    Music_GetInstrumentMode
                JZ      I_ReplaceSample3
                                                        ; Instrument mode..
                                                        ; step through inst.
                Xor     AX, AX

I_ReplaceSample4:
                Push    AX

                Mov     BX, AX
                Add     BX, BX
                Mov     SI, [DS:64712+BX]
                Add     SI, 41h

                Mov     CX, 120

I_ReplaceSample5:
                Mov     AL, [SI]

                Cmp     AL, DH
                JNE     I_ReplaceSample7

                Mov     [SI], DL

I_ReplaceSample7:
                Add     SI, 2
                Loop    I_ReplaceSample5

                Pop     AX

                Inc     AX
                Cmp     AX, 99
                JBE     I_ReplaceSample4

                Mov     AX, 1
                Ret

I_ReplaceSample3:                                         ; Sample mode..
                XChg    DH, DL
                Or      DH, 80h
                Call    PE_SwapInstruments

I_ReplaceSample1:
                Mov     AX, 1
                Ret

EndP            I_ReplaceSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_ReMix
                Assume DS:Nothing

                EnsureNoNetwork

                Call    Music_Stop
                                                        ; OK...
                Call    I_GetSampleOffset
                Mov     EDX, CS:NewSampleSize
                Mov     AX, 99

                Test    Byte Ptr [BX+12h], 2
                JZ      I_ReMix1

                Add     EDX, EDX

I_ReMix1:
                                                ; Limit size of EDX...
                Cmp     EDX, 4177920
                JBE     I_ReMixLimitMaxSize

                Mov     EDX, 4177920
                Mov     CS:NewSampleSize, EDX

                Test    Byte Ptr [BX+12h], 2
                JZ      I_ReMixLimitMaxSize

                ShR     CS:NewSampleSize, 1

I_ReMixLimitMaxSize:
                Call    Music_AllocateSample            ; Returns ES:DI
                Mov     AX, ES
                And     AX, AX
                JNZ     I_ReMixEnoughMem

                Call    PEFunction_OutOfMemoryMessage

I_ReMixNoMix:
                Ret

I_ReMixEnoughMem:
                Mov     AX, DiskData
                Mov     ES, AX
                        Assume ES:Nothing

                Call    PE_GetLastInstrument            ; Into BX
                Mov     AX, BX
                Inc     AX

                Xor     CX, CX
                Call    Music_GetSampleLocation         ; Returns DS:ESI, ECX
                JNZ     I_ReMix16Bit

I_ReMix8Bit:
                Mov     EAX, ECX
                Xor     EDX, EDX
                Div     CS:NewSampleSize

                Mov     BP, AX
                ShR     EAX, 16
                JNZ     I_ReMixNoMix

                Xor     EAX, EAX              ; BP:AX = skip value...
                Div     CS:NewSampleSize

                ShR     EAX, 16
                Mov     BX, AX                

                                                ; BP:BX = skip value.
                Xor     ESI, ESI                ; DS:ESI = source
                Xor     EDI, EDI                ; Go from the start!
                Xor     CX, CX                  ; CX = error.
                                                ; ES:EDI = destination

I_ReMix8Bit2:
                Cmp     CS:Interpolate, 0
                JNE     I_ReMix8BitInterpolate

                Mov     AL, [SI]
                Jmp     I_ReMix8BitStore

I_ReMix8BitInterpolate:
                MovSX   AX, Byte Ptr [SI]
                Mov     DX, 100h
                Sub     DL, CH
                SbB     DH, 0
                IMul    DX                      ; AX = [SI]*(1-Remainder)*256

                Push    AX

                Add     SI, 1
                JNC     I_ReMix8BitInterpolate2

                Add     ESI, 10000h
                Int     3

I_ReMix8BitInterpolate2:
                MovSX   AX, Byte Ptr [SI]
                Mov     DL, CH
                Xor     DH, DH
                Mul     DX

                Pop     DX                      ; DX = Old AX = [SI]*(1-Remainder)*256
                Add     AX, DX
                Add     AX, 80h                 ; Rounding.
                Mov     AL, AH

                Sub     ESI, 1

I_ReMix8BitStore:
                Mov     [ES:DI], AL

                Add     CX, BX
                AdC     SI, BP
                JC      I_ReMix8Bit3

I_ReMix8Bit4:
                Add     DI, 1
                JC      I_ReMix8Bit5

I_ReMix8Bit6:
                Cmp     EDI, CS:NewSampleSize
                JB      I_ReMix8Bit2

                Jmp     I_ReMixCleanUp

I_ReMix8Bit3:
                Add     ESI, 10000h
                Int     3
                Jmp     I_Remix8Bit4

I_ReMix8Bit5:
                PushAD
                Push    DS
                Push    ES

                Mov     AX, 100
                Xor     CX, CX
                Call    Music_GetSampleLocation
                Mov     ESI, EDI
                Int     3

                Push    DS
                Push    ES
                Pop     DS
                Pop     ES

                Mov     CX, 16384
                Xor     SI, SI
                Xor     DI, DI
                Rep     MovsD

                Pop     ES
                Pop     DS
                PopAD

                Add     EDI, 10000h

                Call    I_RepositionSample
                Jmp     I_ReMix8Bit6

I_ReMix16Bit:
                Mov     EAX, ECX
                Xor     EDX, EDX
                Div     CS:NewSampleSize

                Mov     BP, AX
                Add     BP, BP
                ShR     EAX, 15
                JNZ     I_ReMixNoMix

                Xor     EAX, EAX              ; BP:AX = skip value...
                Div     CS:NewSampleSize

                ShR     EAX, 16
                Mov     BX, AX                

                                                ; BP:BX = skip value.
                Xor     ESI, ESI                ; DS:ESI = source
                Xor     EDI, EDI                ; Go from the start!
                Xor     CX, CX                  ; CX = error.
                                                ; ES:EDI = destination

I_ReMix16Bit2:
                Cmp     CS:Interpolate, 0
                JNE     I_ReMix16BitInterpolate

                Mov     AX, [SI]
                Jmp     I_ReMix16BitStore

I_ReMix16BitInterpolate:
                Mov     AX, [SI]                ; AX = [SI]*(1-Remainder)*256
                Mov     DX, 100h
                Sub     DL, CH
                SbB     DH, 0
                IMul    DX                      ; DX:AX = [SI]*(1-Remainder)*256

                Push    DX
                Push    AX

                Add     SI, 2
                JNC     I_ReMix16BitInterpolate2

                Add     ESI, 10000h
                Int     3

I_ReMix16BitInterpolate2:
                Mov     AX, [SI]

                MovZX   DX, CH
                IMul    DX                      ; DX:AX = Remainder*256
                ShL     EDX, 16
                Mov     DX, AX

                Pop     EAX

                Add     EAX, EDX
                Add     EAX, 80h                 ; Rounding.
                ShR     EAX, 8

                Sub     ESI, 2

I_ReMix16BitStore:
                Mov     [ES:DI], AX

                Xor     AX, AX
                Add     CX, BX
                SetC    AL
                Add     AX, AX
                Add     AX, BP
                Add     SI, AX
                JC      I_ReMix16Bit3

I_ReMix16Bit4:
                Add     DI, 2
                JC      I_ReMix16Bit5

I_ReMix16Bit6:
                Mov     EAX, EDI
                ShR     EAX, 1
                Cmp     EAX, CS:NewSampleSize
                JB      I_ReMix16Bit2

                Jmp     I_ReMixCleanUp

I_ReMix16Bit3:
                Add     ESI, 10000h
                Int     3
                Jmp     I_Remix16Bit4

I_ReMix16Bit5:
                PushAD
                Push    DS
                Push    ES

                Mov     AX, 100
                Xor     CX, CX
                Call    Music_GetSampleLocation
                Mov     ESI, EDI
                Int     3

                Push    DS
                Push    ES
                Pop     DS
                Pop     ES

                Mov     CX, 16384
                Xor     SI, SI
                Xor     DI, DI
                Rep     MovsD

                Pop     ES
                Pop     DS
                PopAD

                Add     EDI, 10000h

                Call    I_RepositionSample
                Jmp     I_ReMix16Bit6

I_ReMixCleanUp:
                                        ; Copy leftover stuff...
                Mov     AX, 100
                Xor     CX, CX
                Call    Music_GetSampleLocation
                Mov     ESI, EDI
                Int     3

                Push    DS
                Push    ES
                Pop     DS
                Pop     ES

                Mov     CX, DI
                Xor     SI, SI
                Xor     DI, DI
                Rep     MovsB

                Call    I_GetSampleOffset       ; Gets DS:BX
                Mov     SI, BX
                Mov     ECX, [SI+30h]
                Mov     EBX, CS:NewSampleSize
                                                ; ECX = length of old samp
                                                ; EBX = length of new samp
                Mov     [SI+30h], EBX
                Add     SI, 34h

                Call    Near Ptr I_ReMix5
                Call    Near Ptr I_ReMix5
                Call    Near Ptr I_ReMix5
                Call    Near Ptr I_ReMix5
                Call    Near Ptr I_ReMix5
                                                ; Now grab the data from Inst99
                Call    I_SwapMemoryAllocation

                Call    I_DrawWaveForm
                Call    Music_SoundCardLoadAllSamples

                Ret

I_ReMix5:
                Mov     EAX, [SI]
                Mul     EBX

                Cmp     EDX, ECX
                JAE     I_ReMix6
                
                Div     ECX
                Cmp     EAX, 9999999
                JB      I_ReMix7

I_ReMix6:
                Mov     EAX, 9999999

I_ReMix7:
                Mov     [SI], EAX
                Add     SI, 4

I_ReMixEnd:
                Ret

EndP            I_ReMix
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_ResizeSample Far

                Mov     CS:Interpolate, 1
                Jmp     I_ResizeJumpPoint

EndP            I_ResizeSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_ResizeSampleNoInt Far

                Mov     CS:Interpolate, 0

I_ResizeJumpPoint:
                EnsureNoNetwork

                Call    I_GetSampleOffset
                Mov     AL, [BX+12h]
                Test    AL, 1
                JZ      I_ResizeSampleNoInt1

                And     AL, 2
                Mov     CS:Quality, AL

                Cmp     DWord Ptr [DS:BX+30h], 0
                JE      I_ResizeSampleNoInt1

                Mov     EAX, [DS:BX+30h]         ; Old length
                Mov     CS:NewSampleSize, EAX

                Call    F_Reset5NumInputPos
                Call    S_SaveScreen

                Mov     DI, Offset O1_ResizeSampleList
                Mov     CX, 3
                Call    M_Object1List

                Call    S_RestoreScreen

                And     DX, DX
                JZ      I_ResizeSampleNoInt1

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Mov     EDX, NewSampleSize
                And     EDX, EDX
                JZ      I_ResizeSampleNoInt1

                Call    I_Remix

I_ResizeSampleNoInt1:
                Mov     AX, 1
                Ret

EndP            I_ResizeSampleNoInt
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_CenterSample Far

                EnsureNoNetwork

                Call    PE_GetLastInstrument
                Mov     AX, BX
                Inc     AX

                Xor     CX, CX
                Call    Music_GetSampleLocation ; Gets DS:SI, and ECX.
                                                ; Zero flag if 8 bit.
                JNC     I_CenterSample1

                Xor     AX, AX
                Ret

I_CenterSample1:
                Push    AX                      ; Remember sample num.
                                                ; Scan through wave first,
                                                ; and find max deviation from
                                                ; mean.
                JNZ     I_CenterSamplePre16Bit1
                Mov     BL, [SI]
                Mov     DL, [SI]

I_CenterSamplePre8Bit1:
                Mov     AL, [SI]
                Cmp     AL, BL
                JL      I_CenterSamplePre8Bit3
                Cmp     AL, DL
                JG      I_CenterSamplePre8Bit4

I_CenterSamplePre8Bit2:
                Add     SI, 1
                JC      I_CenterSamplePre8BitNextBlock

I_CenterSamplePre8Bit5:
                LoopD   I_CenterSamplePre8Bit1

                MovSX   BX, BL
                MovSX   DX, DL

                Add     BX, DX
                Neg     BX
                SAR     BX, 1

                Jmp     I_CenterSample2

I_CenterSamplePre8Bit3:
                Mov     BL, AL
                Jmp     I_CenterSamplePre8Bit2

I_CenterSamplePre8Bit4:
                Mov     DL, AL
                Jmp     I_CenterSamplePre8Bit2

I_CenterSamplePre8BitNextBlock:
                Add     ESI, 10000h
                Int     3

                Jmp     I_CenterSamplePre8Bit5

I_CenterSamplePre16Bit:
                Mov     BX, [SI]
                Mov     DX, [SI]

I_CenterSamplePre16Bit1:
                Mov     AX, [SI]
                Cmp     AX, BX
                JL      I_CenterSamplePre16Bit3
                Cmp     AX, DX
                JG      I_CenterSamplePre16Bit4

I_CenterSamplePre16Bit2:
                Add     SI, 2
                JC      I_CenterSamplePre16BitNextBlock

I_CenterSamplePre16Bit5:
                LoopD   I_CenterSamplePre16Bit1

                MovSX   EBX, BX
                MovSX   EDX, DX
                Add     EBX, EDX
                Neg     EBX
                SAR     EBX, 1

                Jmp     I_CenterSample2

I_CenterSamplePre16Bit3:
                Mov     BX, AX
                Jmp     I_CenterSamplePre16Bit2

I_CenterSamplePre16Bit4:
                Mov     DX, AX
                Jmp     I_CenterSamplePre16Bit2

I_CenterSamplePre16BitNextBlock:
                Add     ESI, 10000h
                Int     3
                Jmp     I_CenterSamplePre16Bit5

I_CenterSample2:
                Push    BX

                Mov     DI, Offset O1_SampleCenterList
                Mov     CX, 3
                Call    M_Object1List

                Pop     BX
                Pop     AX              ; AX = sample num
                Test    DL, 1
                JZ      I_CenterSampleEnd

                Call    Music_Stop

                Xor     CX, CX
                Call    Music_GetSampleLocation ; Loads DS:ESI and ECX again.
                JNZ     I_CenterSample16Bit1

I_CenterSample8Bit1:
                Add     [SI], BL
                Add     SI, 1
                JC      I_CenterSample8BitNextBlock

I_CenterSample8Bit2:
                LoopD   I_CenterSample8Bit1
                Jmp     I_CenterSample3

I_CenterSample8BitNextBlock:
                Add     ESI, 10000h
                Int     3
                Jmp     I_CenterSample8Bit2

I_CenterSample16Bit1:
                Add     [SI], BX
                Add     SI, 2
                JC      I_CenterSample16BitNextBlock

I_CenterSample16Bit2:
                LoopD   I_CenterSample16Bit1
                Jmp     I_CenterSample3

I_CenterSample16BitNextBlock:
                Add     ESI, 10000h
                Int     3
                Jmp     I_CenterSample16Bit2

I_CenterSample3:
                Call    I_DrawWaveForm
                Call    Music_SoundCardLoadAllSamples

I_CenterSampleEnd:
                Mov     AX, 1
                Ret

EndP            I_CenterSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_AmplifySample Far

                EnsureNoNetwork

                Call    PE_GetLastInstrument
                Mov     AX, BX
                Inc     AX

                Xor     CX, CX
                Call    Music_GetSampleLocation ; Gets DS:SI, and ECX.
                JNC     I_AmplifySample1

                Xor     AX, AX
                Ret

I_AmplifySample1:
                Push    AX                      ; Remember sample num.
                                                ; Scan through wave first,
                                                ; and find max deviation from
                                                ; mean.
                Mov     BX, 0                   ; BX = deviation from mean
                JNZ     I_AmplifySample11       ; 16 bit stuff.

I_AmplifySample2:
                Mov     AL, [SI]
;                Sub     AL, 80h
                CBW
                Xor     AL, AH
                Sub     AL, AH

                Cmp     AL, BH
                JB      I_AmplifySample3

                Mov     BH, AL

I_AmplifySample3:
                Add     SI, 1
                JC      I_AmplifySample8

I_AmplifySample9:
                LoopD   I_AmplifySample2
                Jmp     I_AmplifySample10

I_AmplifySample8:
                Add     ESI, 10000h
                Int     3
                Jmp     I_AmplifySample9

I_AmplifySample11:
                Mov     AX, [SI]
;                Sub     AX, 8000h
                CWD
                Xor     AX, DX
                Sub     AX, DX
                Cmp     AX, BX
                JB      I_AmplifySample12

                Mov     BX, AX

I_AmplifySample12:
                Add     SI, 2
                JC      I_AmplifySample13

I_AmplifySample14:
                LoopD   I_AmplifySample11
                Jmp     I_AmplifySample10

I_AmplifySample13:
                Add     ESI, 10000h
                Int     3
                Jmp     I_AmplifySample14


I_AmplifySample10:
                        ; OK. so BL contains max dev.
                        ; Amplificat = (8000h/MaxDev)*100
                Xor     AX, AX
                Mov     DX, 32h

                Cmp     DX, BX
                JAE     I_AmplifySample4

                Div     BX

                Cmp     AX, 400
                JB      I_AmplifySample5

I_AmplifySample4:
                Mov     AX, 400

I_AmplifySample5:
                Mov     CS:SampleAmplification, AX

                Mov     DI, Offset O1_SampleAmplificationList
                Mov     CX, 3
                Call    M_Object1List

                Pop     AX              ; AX = sample num
                And     DX, DX
                JZ      I_AmplifySampleEnd

                Call    Music_Stop

                Xor     CX, CX
                Call    Music_GetSampleLocation ; Loads DS:ESI and ECX again.

                PushF

        ; NewSample = OldSample*SampleAmplification/100, clipped.

                Mov     AX, CS:SampleAmplification
                Xor     DX, DX
                Mov     BX, 100
                Div     BX
                ShL     EAX, 16
                Div     BX
                Mov     EBX, EAX        ; EBX = multiplier, 16.16 bit.

                PopF
                JNZ     I_AmplifySample20

I_AmplifySample6:
                MovSX   EAX, Byte Ptr [SI]

                IMul    EBX

                Add     EAX, 8000h    ; Rounding factor
                ShR     EAX, 16

                Cmp     AX, 7Fh
                JGE     I_AmplifySampleClip1

                Cmp     AX, -80h
                JGE     I_AmplifySample7

                Mov     AL, 80h
                Jmp     I_AmplifySample7

I_AmplifySampleClip1:
                Mov     AL, 7Fh

I_AmplifySample7:
                Mov     [SI], AL
                Add     SI, 1
                JC      I_AmplifySample16

I_AmplifySample17:
                LoopD   I_AmplifySample6
                Jmp     I_AmplifySample15

I_AmplifySample16:
                Add     ESI, 10000h
                Int     3
                Jmp     I_AmplifySample17

I_AmplifySample20:      ; 16 bit amplification!, EBX = 16.16 bit multiplier.
                        ; Newsample = OldSample*SampleAmplification/100

                Mov     AX, [SI]
                MovSX   EAX, AX

                IMul    EBX
                Add     EAX, 8000h      ; Rounding factor
                AdC     EDX, 0           ; Rounding stuff, etc.

                ShRD    EAX, EDX, 16

                Cmp     EAX, 7FFFh
                JGE     I_AmplifySampleClip2

                Cmp     EAX, -8000h
                JGE     I_AmplifySample18

                Mov     AX, 8000h
                Jmp     I_AmplifySample18

I_AmplifySampleClip2:
                Mov     AX, 7FFFh

I_AmplifySample18:
                Mov     [SI], AX

                Add     SI, 2
                JC      I_AmplifySample21

I_AmplifySample19:
                LoopD   I_AmplifySample20
                Jmp     I_AmplifySample15

I_AmplifySample21:
                Add     ESI, 10000h
                Int     3
                Jmp     I_AmplifySample19

I_AmplifySample15:
                Call    I_DrawWaveForm
                Call    Music_SoundCardLoadAllSamples

I_AmplifySampleEnd:
                Mov     AX, 1
                Ret

EndP            I_AmplifySample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_ReverseSample Far

                EnsureNoNetwork

                Call    PE_GetLastInstrument
                Mov     AX, BX
                Inc     AX

                Xor     CX, CX
                Call    Music_GetSampleLocation ; Gets DS:SI, and CX.
                JC      I_ReverseSample1

                JNZ     I_ReverseSample10

                Call    Music_Stop

                Push    ECX

                Mov     EDX, ECX
                Mov     AX, 99
                Call    Music_AllocateSample    ; Returns ES:DI
                Mov     AX, ES
                And     AX, AX

                Pop     ECX

                JZ      I_ReverseSampleError

                Mov     ESI, ECX
                Dec     ESI
                Call    I_RepositionSample

                Mov     AX, DiskData
                Mov     ES, AX
                        Assume ES:Nothing

                Xor     EDI, EDI

I_ReverseSample2:
                Mov     AL, [SI]
                Mov     [ES:DI], AL

                Sub     SI, 1
                JC      I_ReverseSample4

I_ReverseSample5:
                Add     DI, 1
                JC      I_ReverseSample6

I_ReverseSample7:
                LoopD   I_ReverseSample2
                Jmp     I_ReverseSample3

I_ReverseSample4:
                Sub     ESI, 10000h
                JC      I_ReverseSample5
                Int     3

                Jmp     I_ReverseSample5

I_ReverseSample6:
                PushAD
                Push    DS
                Push    ES

                Mov     AX, 100
                Xor     CX, CX
                Call    Music_GetSampleLocation
                Mov     ESI, EDI
                Int     3

                Push    DS
                Push    ES

                Pop     DS
                Pop     ES

                Xor     SI, SI
                Xor     DI, DI
                Mov     CX, 16384
                Rep     MovsD

                Pop     ES
                Pop     DS
                PopAD
                Add     EDI, 10000h
                Call    I_RepositionSample
                Jmp     I_ReverseSample7

I_ReverseSample10:
                Call    Music_Stop

                Push    ECX

                Mov     EDX, ECX
                Add     EDX, EDX
                Mov     AX, 99
                Call    Music_AllocateSample    ; Returns ES:DI
                Mov     AX, ES
                And     AX, AX

                Pop     ECX

                JZ      I_ReverseSampleError

                Mov     ESI, ECX
                Dec     ESI
                Add     ESI, ESI
                Call    I_RepositionSample

                Mov     AX, DiskData
                Mov     ES, AX
                        Assume ES:Nothing

                Xor     EDI, EDI

I_ReverseSample12:
                Mov     AX, [SI]
                Mov     [ES:DI], AX

                Sub     SI, 2
                JC      I_ReverseSample14

I_ReverseSample15:
                Add     DI, 2
                JC      I_ReverseSample16

I_ReverseSample17:
                LoopD   I_ReverseSample12
                Jmp     I_ReverseSample3

I_ReverseSample14:
                Sub     ESI, 10000h
                JC      I_ReverseSample15
                Int     3

                Jmp     I_ReverseSample15

I_ReverseSample16:
                PushAD
                Push    DS
                Push    ES

                Mov     AX, 100
                Xor     CX, CX
                Call    Music_GetSampleLocation
                Mov     ESI, EDI
                Int     3

                Push    DS
                Push    ES

                Pop     DS
                Pop     ES

                Xor     SI, SI
                Xor     DI, DI
                Mov     CX, 16384
                Rep     MovsD

                Pop     ES
                Pop     DS
                PopAD
                Add     EDI, 10000h
                Call    I_RepositionSample
                Jmp     I_ReverseSample17


I_ReverseSampleError:
                Call    PEFunction_OutOfMemoryMessage

                Mov     AX, 1
                Ret

I_ReverseSample3:
                Mov     AX, 100
                Xor     CX, CX
                Call    Music_GetSampleLocation

                Mov     ESI, EDI
                Int     3

                Mov     CX, DI

                Push    DS
                Push    ES
                Pop     DS
                Pop     ES

                Xor     SI, SI
                Xor     DI, DI
                Rep     MovsB

                                        ; Now to release old memory, and swap
                                        ; in new lot...
                Call    I_SwapMemoryAllocation

                Call    I_GetSampleOffset       ; Returns DS:BX

                Mov     EDX, [BX+30h]            ; DX = length
                Mov     EAX, EDX
                Mov     ECX, EDX

                Sub     EAX, [BX+34h]
                Sub     ECX, [BX+38h]
                Mov     [BX+34h], ECX
                Mov     [BX+38h], EAX

                Mov     EAX, EDX
                Mov     ECX, EDX

                Sub     EAX, [BX+40h]
                Sub     ECX, [BX+44h]
                Mov     [BX+40h], ECX
                Mov     [BX+44h], EAX

                Call    I_DrawWaveForm
                Call    Music_SoundCardLoadAllSamples

I_ReverseSample1:
                Mov     AX, 1
                Ret

EndP            I_ReverseSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SwapMemoryAllocation

                Call    I_GetSampleOffset       ; Gets DS:BX
                Mov     SI, [DS:64912+99*2]
                Mov     EAX, [SI+48h]
                XChg    [BX+48h], EAX
                Mov     [SI+48h], EAX

                Mov     AX, 99
                Call    Music_ReleaseSample

                Ret

EndP            I_SwapMemoryAllocation

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_RepositionSample


                Push    AX
                Push    BX
                Push    ECX
                Push    ESI

                Call    PE_GetLastInstrument
                Mov     AX, BX                  ; AX = sample no.
                Inc     AX
                Xor     CX, CX
                Call    Music_GetSampleLocation   ; Return DS:ESI, ECX

                Pop     ESI
                Int     3

                Pop     ECX
                Pop     BX
                Pop     AX
                Ret

EndP            I_RepositionSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_ToggleSampleQuality Far

                EnsureNoNetwork

                Call    I_GetSampleOffset
                Mov     AL, [BX+12h]
                Test    AL, 1
                JZ      I_ToggleSampleQuality1

                Test    AL, 2
                JZ      I_To16Bit

I_To8Bit:
                Push    DS
                Push    BX

                Mov     DI, Offset O1_ConfirmConvert2List
                Mov     CX, 3
                Call    M_Object1List

                Pop     BX
                Pop     DS

                And     DX, DX
                JZ      I_ToggleSampleQuality1

                Call    Music_Stop

                Cmp     DX, 1
                JE      I_ConvertTo8Bit

                And     Byte Ptr [BX+12h], Not 2

                ShL     DWord Ptr [BX+30h], 1
                ShL     DWord Ptr [BX+34h], 1
                ShL     DWord Ptr [BX+38h], 1
                ShL     DWord Ptr [BX+40h], 1
                ShL     DWord Ptr [BX+44h], 1

                Jmp     I_ToggleSampleQualityEnd

I_ConvertTo8Bit:
                Mov     EDX, [BX+30h]
                Mov     AX, 99                  ; Shove it into inst 99 first.
                Call    Music_AllocateSample

                Mov     AX, ES
                And     AX, AX
                JZ      I_OutOfMemory

                And     Byte Ptr [BX+12h], Not 2

                Call    PE_GetLastInstrument
                Mov     AX, BX                  ; AX = sample no.
                Inc     AX

                Xor     CX, CX
                Call    Music_GetSampleLocation   ; Return DS:ESI

                Mov     AX, DiskData
                Mov     ES, AX
                        Assume ES:Nothing

                Xor     EDI, EDI

I_ConvertTo8Bit1:
                Mov     AX, [SI]
;                Add     AX, 80h
;                SBB     AH, 0
                Mov     [ES:DI], AH

                Add     SI, 2
                JC      I_ConvertTo8Bit2

I_ConvertTo8Bit3:
                Add     DI, 1
                JC      I_ConvertTo8Bit5

I_ConvertTo8Bit4:
                LoopD   I_ConvertTo8Bit1

                Mov     AX, 100
                Xor     CX, CX
                Call    Music_GetSampleLocation

                Mov     ESI, EDI
                Int     3

                Mov     CX, DI

                Push    DS
                Push    ES
                Pop     DS
                Pop     ES

                Xor     SI, SI
                Xor     DI, DI
                Rep     MovsB

                                        ; Now to release old memory, and swap
                                        ; in new lot...
                Call    I_SwapMemoryAllocation

                Jmp     I_ToggleSampleQualityEnd

I_ConvertTo8Bit2:
                Add     ESI, 10000h
                Int     3
                Jmp     I_ConvertTo8Bit3

I_ConvertTo8Bit5:
                PushAD
                Push    DS
                Push    ES

                Mov     AX, 100
                Xor     CX, CX
                Call    Music_GetSampleLocation

                Mov     ESI, EDI
                Int     3

                Push    DS
                Push    ES

                Pop     DS
                Pop     ES

                Xor     SI, SI
                Xor     DI, DI
                Mov     CX, 16384
                Rep     MovsD

                Pop     ES
                Pop     DS
                PopAD

                Call    I_RepositionSample

                Add     EDI, 10000h
                Jmp     I_ConvertTo8Bit4

I_OutOfMemory:
                Call    PEFunction_OutOfMemoryMessage
                Jmp     I_ToggleSampleQuality1

I_To16Bit:
                Push    DS
                Push    BX

                Mov     DI, Offset O1_ConfirmConvert2List
                Mov     CX, 3
                Call    M_Object1List

                Pop     BX
                Pop     DS

                And     DX, DX
                JZ      I_ToggleSampleQuality1

                Call    Music_Stop

                Cmp     DX, 1
                JE      I_ConvertTo16Bit

                Or      Byte Ptr [BX+12h], 2

                ShR     DWord Ptr [BX+30h], 1
                ShR     DWord Ptr [BX+34h], 1
                ShR     DWord Ptr [BX+38h], 1
                ShR     DWord Ptr [BX+40h], 1
                ShR     DWord Ptr [BX+44h], 1

                Jmp     I_ToggleSampleQualityEnd

I_ConvertTo16Bit:
                Mov     EDX, [BX+30h]
                Add     EDX, EDX
                Mov     AX, 99                  ; Shove it into inst 99 first.
                Call    Music_AllocateSample

                Mov     AX, ES
                And     AX, AX
                JZ      I_OutOfMemory

                Or      Byte Ptr [BX+12h], 2

                Mov     ECX, [BX+30h]
                Xor     ESI, ESI
                Call    I_RepositionSample

                Mov     AX, DiskData
                Mov     ES, AX
                        Assume ES:Nothing

                Xor     EDI, EDI

I_ConvertTo16Bit1:
                Mov     AH, [SI]
                Xor     AL, AL
                Mov     [ES:DI], AX

                Add     SI, 1
                JC      I_ConvertTo16Bit2

I_ConvertTo16Bit3:
                Add     DI, 2
                JC      I_ConvertTo16Bit5

I_ConvertTo16Bit4:
                LoopD   I_ConvertTo16Bit1

                Mov     AX, 100
                Xor     CX, CX
                Call    Music_GetSampleLocation

                Mov     ESI, EDI
                Int     3

                Mov     CX, DI

                Push    DS
                Push    ES
                Pop     DS
                Pop     ES

                Xor     SI, SI
                Xor     DI, DI
                Rep     MovsB

                Call    I_SwapMemoryAllocation

                Jmp     I_ToggleSampleQualityEnd

I_ConvertTo16Bit2:
                Add     ESI, 10000h
                Int     3
                Jmp     I_ConvertTo16Bit3

I_ConvertTo16Bit5:
                PushAD
                Push    DS
                Push    ES

                Mov     AX, 100
                Xor     CX, CX
                Call    Music_GetSampleLocation

                Mov     ESI, EDI
                Int     3

                Push    DS
                Push    ES

                Pop     DS
                Pop     ES

                Xor     SI, SI
                Xor     DI, DI
                Mov     CX, 16384
                Rep     MovsD

                Pop     ES
                Pop     DS
                PopAD

                Call    I_RepositionSample

                Add     EDI, 10000h
                Jmp     I_ConvertTo16Bit4

I_ToggleSampleQualityEnd:
                Call    I_DrawWaveForm
                Call    Music_SoundCardLoadAllSamples

I_ToggleSampleQuality1:
                Mov     AX, 1
                Ret

EndP            I_ToggleSampleQuality

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_DrawInstrumentWindow Far

                Call    S_GetDestination

                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern

                Mov     AL, LastInstrument
                Test    AL, AL
                JNZ     I_DrawInstrumentWindow1

                Inc     AX
                Mov     LastInstrument, AL

I_DrawInstrumentWindow1:                        ; AL = last instrument
                Xor     AH, AH                  ; Now for bounds check.

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Mov     BX, TopInstrument
                Cmp     AX, BX
                JAE     I_DrawInstrumentWindow2

                Mov     BX, AX

I_DrawInstrumentWindow2:
                Mov     CX, BX
                Add     CX, 34
                Cmp     CX, AX
                JAE     I_DrawInstrumentWindow3

                Mov     BX, AX
                Sub     BX, 34

I_DrawInstrumentWindow3:
                Mov     TopInstrument, BX               ; OK.. now to draw nums
                Push    AX

                Mov     DI, (2+13*80)*2

                Mov     DX, 0A23h

I_DrawInstrumentWindow4:
                Mov     AX, BX
                Div     DH
                                                ; AH = units, AL = tens
                Add     AL, '0'
                StosB
                Mov     AL, 20h
                StosB
                XChg    AH, AL
                Add     AL, '0'
                StosW

                Inc     BX
                Add     DI, 156
                Dec     DL
                JNE     I_DrawInstrumentWindow4

                Mov     BX, TopInstrument

                Call    Music_GetSongSegment
                Mov     DS, AX
                        Assume DS:Nothing

                Mov     DX, 35
                Mov     DI, (5+13*80)*2
                Dec     BX
                Mov     SI, BX
                Add     SI, SI
                Mov     SI, [SI+64712]
                Add     SI, 20h

                Pop     CX              ; CX = last instrument
                Dec     CX

I_DrawInstrumentWindow5:
                Push    CX

                Mov     AH, 6
                Cmp     BX, CX
                JNE     I_DrawInstrumentWindow7

                Mov     AH, 0E6h

I_DrawInstrumentWindow7:
                Mov     CX, 25

I_DrawInstrumentWindow6:
                LodsB

                Cmp     AL, 226
                JB      I_DrawInstrumentNoMouse

                Mov     AL, ' '

I_DrawInstrumentNoMouse:
                StosW
                Loop    I_DrawInstrumentWindow6

                Add     DI, 160-(25*2)
                Add     SI, 554-25
                Pop     CX

                Inc     BX
                Dec     DX
                JNZ     I_DrawInstrumentWindow5

                Push    CS
                Pop     DS

                Mov     SI,Offset SampleMouseEvent
                Mov     Word Ptr [SI+4], 30*8-1
                Mov     Word Ptr [SI+10], 4
                Call    AddSelectEvent
                Mov     SI, Offset SampleMouseOffEvent
                Mov     Word Ptr [SI+4], 30*8-1
                Call    MouseAddEvent

                Ret

EndP            I_DrawInstrumentWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_PreInstrumentWindow Far

                Call    S_GetDestination
                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern

                Mov     AL, LastInstrument
                Xor     AH, AH
                Mov     SI, AX
                Sub     AX, TopInstrument
                Add     AX, 13
                Mov     BX, 160
                Mul     BX
                Add     AX, 11
                Mov     DI, AX
                Cmp     InstrumentEdit, 1
                JE      I_PreInstrumentWindow2

                Mov     CX, 25

I_PreInstrumentWindow1:
                Mov     Byte Ptr [ES:DI], 30h
;                Add     DI, 2
                ScasW

                Loop    I_PreInstrumentWindow1
                Ret

I_PreInstrumentWindow2:
                Mov     AX, CS:InstrumentPos
                Add     AX, AX
                Add     DI, AX
                Mov     Byte Ptr [ES:DI], 30h

                Ret

EndP            I_PreInstrumentWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MIDI_AllocateChannel Far   ; Given AX = Base channel, DL = note
                                           ; Finds physical channel, returns AX
                                           ; if no channel available, then
                                           ; overtakes channel at base channel
                                           ; Given DI = max channel
                Push    BX CX DX SI DS

                Push    DX

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Mov     DX, AX
                Mov     BX, AX

MIDI_AllocateChannel1:
                Inc     DX
                Cmp     DX, DI
                JA      MIDI_AllocateChannelOvertake

                Mov     SI, Offset MIDITable
                Mov     CX, 128

MIDI_AllocateChannel2:
                LodsB
                Cmp     AL, DL
                JE      MIDI_AllocateChannel1
                Loop    MIDI_AllocateChannel2

                Mov     AX, DX
                Jmp     MIDI_AllocateChannelEnd

MIDI_AllocateChannelOvertake:           ; Search for basechannel
                Mov     SI, Offset MIDITable

MIDI_AllocateChannel3:
                LodsB
                Cmp     AL, DL
                JNE     MIDI_AllocateChannel3

                                        ; Clear out last entry...
                Mov     Byte Ptr [SI-1], 0
                Mov     AX, BX
                Inc     AX

MIDI_AllocateChannelEnd:
                Pop     BX              ; BL = note
                And     BX, 07Fh
                Mov     [MIDITable+BX], AL

                Dec     AX

                Pop     DS SI DX CX BX
                Ret

EndP            MIDI_AllocateChannel


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MIDI_GetChannel Far

                Xor     AX, AX
                Mov     AL, [CS:MIDITable+BX]
                Ret

EndP            MIDI_GetChannel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MIDI_FindChannel Far    ; Given BX = Note, returns AX = channel
                                        ; number, cleans up table, AL = 0FFh =
                                        ; note not present

                Xor     AX, AX
                XChg    [CS:MIDITable+BX], AL
                Dec     AL

                Ret

EndP            MIDI_FindChannel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MIDI_ClearTable Far

                Push    AX CX ES DI

                Push    CS
                Pop     ES

                Mov     DI, Offset MIDITable
                Xor     AX, AX
                Mov     CX, 64
                Rep     StosW

                Pop     DI ES CX AX

                Ret

EndP            MIDI_ClearTable

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MIDI_NoteOff Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                        ; DL = note
MIDI_NoteOff2:
                Call    Music_GetInstrumentMode
                Mov     CX, 0FFh
                JNZ     MIDI_NoteOff3

                Dec     CX

MIDI_NoteOff3:
                MovZX   BX, DL
                Call    MIDI_FindChannel
                Cmp     AL, 0FFh
                JE      MIDI_NoteOff1

                Mov     SI, Offset NoteData
                Mov     Word Ptr [SI], CX       ; Note off/cut
                Mov     Word Ptr [SI+3], 0      ; No effect
                Mov     DH, 32
                Call    Music_PlayNote

MIDI_NoteOff1:
                Mov     AX, 1
;                Xor     AX, AX
                Ret

EndP            MIDI_NoteOff
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MIDI_PlayNote Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Call    PE_TranslateMIDI
                JC      MIDI_PlayNote1
                JZ      MIDI_NoteOff2

                Call    PE_GetLastInstrument
                Mov     AH, BL
                Inc     AH
                Mov     AL, DL  ; Note

                Mov     SI, Offset NoteData
                Mov     [SI], AX
                Mov     [SI+2], DH
                Mov     Word Ptr [SI+3], 0

                Call    Music_GetNumChannels    ; Into AX
                Mov     DI, AX
                Mov     AX, PlayChannel
                Call    PE_RestoreMIDINote
                Call    MIDI_AllocateChannel

                Mov     DH, 32
                Call    Music_PlayNote

                Mov     Byte Ptr [SI+2], 0FFh
                Mov     AX, 1
                Ret

MIDI_PlayNote1:
                Xor     AX, AX
                Ret


EndP            MIDI_PlayNote
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_PlayNote Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Test    CH, Not 1
                JNZ     I_PlayNote5

                Cmp     CX, LastKey
                JE      I_PlayNote5

                Mov     LastKey, CX

                Mov     SI, Offset KeyBoardTable

I_PlayNote1:
                LodsW
                Cmp     AX, 0FFFFh
                JE      I_PlayNote5

                Mov     BX, AX
                LodsW

                Cmp     BL, CL
                JNE     I_PlayNote1
                                                ; Note to play...
                                                ; AX = notemod.
                Mov     CL, AL

                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern

                Mov     AL, 12
                Mul     BaseOctave
                Add     AL, CL
                Cmp     AL, 119
                JBE     I_PlayNoteMax

                Mov     AL, 119

I_PlayNoteMax:
                Mov     DL, AL

                Test    CH, CH
                JZ      MIDI_NoteOff

                Call    PE_GetLastInstrument
                Mov     AH, BL
                Inc     AH

                Push    CS
                Pop     DS

                MovZX   BX, AL
                Cmp     [MIDITable+BX], 0
                JNE     I_PlayNote6

                Call    UpdateMultiChannel

                Mov     PlayNote, AL

I_PlayNote3:
                Mov     SI, Offset NoteData
                Mov     [SI], AX

                Push    DS

                Call    I_GetInstrumentOffset

                Test    Byte Ptr [BX+19h], 80h
                Mov     DH, 32
                JZ      I_PlayNote4

                Add     DH, 128

I_PlayNote4:
                Pop     DS
                Call    Music_GetNumChannels    ; Into AX
                Mov     DI, AX
                Mov     AX, PlayChannel
                Call    MIDI_AllocateChannel
                Call    Music_PlayNote

I_PlayNote6:
                Mov     AX, 1
                Ret

I_PlayNote5:
                Xor     AX, AX
                Ret

EndP            I_PlayNote
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_PostInstrumentWindow Far
                        Assume DS:Inst

                Push    CS
                Pop     DS
                Mov     SI, Offset InstrumentListKeys
                Call    M_FunctionDivider
                JC      I_PostInstrumentWindow1

                Jmp     [SI]

I_PostInstrumentWindow1:
                Cmp     InstrumentEdit, 0
                JE      I_PostInstrumentWindow7

                Cmp     CX, 101h
                JE      I_PostInstrumentWindow15
                Cmp     CX, 11Ch
                JNE     I_PostInstrumentWindow13

I_PostInstrumentWindow15:
                Mov     InstrumentEdit, 0
                Jmp     I_PostInstrumentWindow12

I_PostInstrumentWindow13:
                Call    PE_GetLastInstrument
                Mov     SI, BX
                Mov     BX, InstrumentPos
                                                ; BX = Pos, SI = LastInst
                Call    Music_GetSongSegment
                Mov     DS, AX
                        Assume DS:Nothing

                Add     SI, SI
                Mov     SI, [64712+SI]          ; SI = instrument offset.

                Test    CL, CL
                JZ      I_PostInstrumentWindow3
                Cmp     DL, 32
                JB      I_PostInstrumentWindow3

                Add     BX, 20h
                Add     BX, SI
                Add     SI, 38h

I_PostInstrumentWindow2:
                Cmp     SI, BX
                JBE     I_PIW2

                Mov     AL, [SI-1]
                Mov     [SI], AL
                Dec     SI
                Jmp     I_PostInstrumentWindow2

I_PIW2:

                Mov     [SI], DL
                NetworkSendInstrument

                Push    CS
                Pop     DS
                Jmp     I_InstrumentRight

I_PostInstrumentWindow3:
                Cmp     CX, 10Eh                        ; Backspace
                JNE     I_PostInstrumentWindow5

                And     BX, BX
                JZ      I_PostInstrumentWindow6

                Dec     InstrumentPos
                Add     BX, 20h
                Add     BX, SI
                Add     SI, 39h

I_PostInstrumentWindow4:
                Mov     AL, [BX]
                Mov     [BX-1], AL
                Inc     BX
                Cmp     BX, SI
                JB      I_PostInstrumentWindow4

                Mov     Byte Ptr [BX-1], 0
                NetworkSendInstrument

I_PostInstrumentWindow12:

                Mov     AX, 1
                Ret

I_PostInstrumentWindow5:
                        Assume DS:Inst

                Cmp     CX, 1D3h                        ; Delete...
                JNE     I_PostInstrumentWindow6

                Add     BX, 21h
                Add     BX, SI
                Add     SI, 39h
                Jmp     I_PostInstrumentWindow4

I_PostInstrumentWindow6:
                Xor     AX, AX
                Ret

I_PostInstrumentWindow7:
                        Assume DS:Inst
                Cmp     DX, ' '                         ; Spacebar
                JNE     I_PostInstrumentWindow14

                Mov     InstrumentEdit, 1
                Mov     InstrumentPos, 0

                Mov     AX, 1
                Ret

I_PostInstrumentWindow14:
                Xor     AX, AX
                Ret

EndP            I_PostInstrumentWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_InstrumentLeft Far

                Assume DS:Inst

                Cmp     InstrumentEdit, 0
                JE      I_InstrumentLeft2

                Cmp     InstrumentPos, 0
                JE      I_InstrumentLeft1

                Dec     InstrumentPos
;                Jmp     I_InstrumentLeft1

I_InstrumentLeft2:
;                Mov     Word Ptr [ES:DI], 8

I_InstrumentLeft1:
                Mov     AX, 1
                Ret

EndP            I_InstrumentLeft
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_InstrumentRight Far

                Assume DS:Inst

                Cmp     InstrumentEdit, 0
                JE      I_InstrumentRight2

                Cmp     InstrumentPos, 24
                JAE     I_InstrumentRight1

                Inc     InstrumentPos
                Jmp     I_InstrumentRight1

I_InstrumentRight2:
                Mov     Word Ptr [ES:DI], 5

I_InstrumentRight1:
                Mov     AX, 1
                Ret


EndP            I_InstrumentRight
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_InstrumentHome Far

                        Assume DS:Inst

                Mov     InstrumentPos, 0

                Mov     AX, 1
                Ret

EndP            I_InstrumentHome
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_InstrumentEnd Far

                        Assume DS:Inst

                Mov     InstrumentPos, 24

                Mov     AX, 1
                Ret

EndP            I_InstrumentEnd
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_InstrumentTab Far

                Mov     Word Ptr [ES:DI], 5

                Mov     AX, 1
                Ret

EndP            I_InstrumentTab

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_InstrumentShiftTab Far

                Mov     Word Ptr [ES:DI], 8

                Mov     AX, 1
                Ret

EndP            I_InstrumentShiftTab

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_InstrumentNameClear Far

                Call    I_GetInstrumentOffset
                Push    DS
                Pop     ES
                Mov     DI, BX

                Xor     AX, AX
                Mov     CX, 6
                Add     DI, 4
                Rep     StosW

                Add     DI, 10h
                Mov     CX, 13
                Rep     StosW

                NetworkSendInstrument

                Inc     AX
                Ret

EndP            I_InstrumentNameClear

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_InstrumentClear Far

                Call    PE_GetLastInstrument
                Mov     AX, BX
                Call    Music_ClearInstrument

                Call    I_MapEnvelope

                NetworkSendInstrument

                Mov     AX, 1
                Ret

EndP            I_InstrumentClear

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_DrawNoteWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Mov     SI, Offset NoteMouseEvent
                Call    AddSelectEvent
                Mov     SI, Offset NoteMouseOffEvent
                Call    MouseAddEvent

                Mov     AX, CurrentNote
                                                ; Now for bounds check.

                Mov     BX, TopNote
                Cmp     AX, BX
                JAE     I_DrawNoteWindow2

                Mov     BX, AX

I_DrawNoteWindow2:
                Mov     CX, BX
                Add     CX, 31
                Cmp     CX, AX
                JAE     I_DrawNoteWindow3

                Mov     BX, AX
                Sub     BX, 31

I_DrawNoteWindow3:
                Mov     TopNote, BX               ; OK.. now to draw nums
                Mov     CX, BX

                Call    S_GetDestination

                Call    I_GetInstrumentOffset
                Add     BX, 40h
                Add     BX, CX
                Add     BX, CX
                Mov     DI, (32+16*80)*2

                Mov     DX, 0C20h
                XChg    SI, BX
                                                ; DS:SI = pointer to translation
                                                ; ES:DI = screen
                                                ; CX = Current note.
I_DrawNoteWindow4:
                                                ; Draw left hand note first.
                Mov     AX, CX
                Div     DH                      ; AH = note, AL = octave.
                Push    AX

                Mov     AL, AH
                Mov     BX, AX
                And     BX, 0FFh                ; BX = note.
                Add     BX, BX                  ; BX = note*2
                Mov     AH, 2
                Mov     AL, [CS:BX+NoteTable]
                StosW
                Mov     AL, [CS:BX+NoteTable+1]
                StosW

                Pop     AX                      ; AL = octave
                Add     AL, '0'
                Mov     AH, 2
                StosW

                                                ; View division...
                Mov     AL, 0A8h
                StosW
                                                ; Note translation...

                LodsB                           ; AL = note..
                Xor     AH, AH
                Div     DH
                Push    AX

                Mov     AL, AH
                Mov     BX, AX
                And     BX, 0FFh                ; BX = note.
                Add     BX, BX                  ; BX = note*2
                Mov     AH, 2
                Mov     AL, [CS:BX+NoteTable]
                StosW
                Mov     AL, [CS:BX+NoteTable+1]
                StosW

                Pop     AX                      ; AL = octave
                Add     AL, '0'
                Mov     AH, 2
                StosW

                Mov     AL, ' '
                StosW
                                                ; Now sample number.
                LodsB                           ; AL = sample number (base 0)
;                Inc     AL                      ; Convert to base 1

                And     AL, AL
                JNZ     I_DrawNoteWindow5

                Mov     AL, 173
                StosW
                StosW
                Jmp     I_DrawNoteWindow6

I_DrawNoteWindow5:
                Xor     AH, AH
                Mov     BL, 10
                Div     BL                      ; AH = units, AL = tens.
                Add     AX, 3030h
                Mov     BL, AH
                Mov     AH, 2
                StosW
                Mov     AL, BL
                StosW

I_DrawNoteWindow6:
                Add     DI, 160-10*2

                Inc     CX
                Dec     DL
                JNZ     I_DrawNoteWindow4

                Ret

EndP            I_DrawNoteWindow

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_PreNoteWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Call    S_GetDestination
                Mov     AX, CurrentNote
                Sub     AX, TopNote
                Add     AX, 16
                Mov     BX, 160
                Mul     BX
                Add     AX, 32*2
                Mov     DI, AX                  ; First hilight the row..

                Mov     CX, 10
                Push    DI

I_PreNoteWindow1:
                Inc     DI
                Or      Byte Ptr [ES:DI], 0E0h
                Inc     DI
                Loop    I_PreNoteWindow1

                Pop     DI

                Mov     BX, NotePos
                Mov     BL, [NotePosTable+BX]
                Xor     BH, BH
                Add     DI, BX
                Add     DI, BX

                Inc     DI
                Mov     Byte Ptr [ES:DI], 30h

                Ret

EndP            I_PreNoteWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_PostNoteWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Mov     SI, Offset NoteListKeys
                Call    M_FunctionDivider
                JC      I_PostNoteWindow1

                Jmp     [SI]

I_PostNoteWindow1:
                Cmp     NotePos, 0
                JNE     I_PostNoteWindow5

                Mov     SI, Offset KeyBoardTable

I_PostNoteWindow2:
                LodsW
                Cmp     AX, 0FFFFh
                JE      I_PostNoteWindow3

                Mov     BX, AX
                LodsW

                Cmp     BX, CX
                JNE     I_PostNoteWindow2
                                                ; Note to play...
                                                ; AX = notemod.
                Mov     CX, AX

                Mov     AX, Pattern
                Mov     DS, AX
                                Assume DS:Pattern

                Mov     AL, 12
                Mul     BaseOctave

                Push    CS
                Pop     DS
                                Assume DS:Inst
                Mov     SI, CurrentNote
                Add     SI, SI

                Add     CX, AX
                Cmp     CX, 119
                JA      I_PostNoteWindow4 ; If note > B-9... not valid!

                Mov     CH, SampleNumber

                Call    I_GetInstrumentOffset
                Mov     [DS:BX+SI+40h], CX

                Push    CS
                Pop     DS

                Mov     SI, Offset NoteData
                Call    PE_GetLastInstrument
                Mov     AH, BL
                Inc     AH
                Mov     AL, Byte Ptr CurrentNote
                Mov     [SI], AX

                Mov     AX, PlayChannel
                Mov     DH, 32+128
                Call    Music_PlayNote

                NetworkSendInstrument
                Jmp     I_NoteDown

I_PostNoteWindow4:
                Mov     AX, 1
                Ret

I_PostNoteWindow3:
                Xor     AX, AX
                Ret

I_PostNoteWindow5:
                Cmp     DL, '0'
                JB      I_PostNoteWindow6
                Cmp     DL, '9'
                JA      I_PostNoteWindow6

                Sub     DL, '0'

                Mov     SI, CurrentNote
                Add     SI, SI

                Call    I_GetInstrumentOffset
                        Assume DS:Nothing
                                                         ; DS:BX points to inst.
                Add     BX, 40h

                Mov     AX, NotePos
                Cmp     AL, 1
                JE      I_PostNoteWindow7

                Inc     BX

                Cmp     AL, 2
                JE      I_PostNoteWindow8

                Cmp     AL, 3
                JE      I_PostNoteWindow9

I_PostNoteWindow6:
                Cmp     DX, '.'
                JNE     I_PostNoteWindow10
                Cmp     NotePos, 2
                JB      I_PostNoteWindow10

                Mov     SI, CurrentNote
                Add     SI, SI

                Call    I_GetInstrumentOffset
                        Assume DS:Nothing
                Add     BX, SI
                Add     BX, 41h
                Mov     Byte Ptr [BX], 0

                NetworkSendInstrument
                Jmp     I_NoteDown

I_PostNoteWindow10:
                Xor     AX, AX
                Ret

I_PostNoteWindow7:                              ; Octave of note.
                Mov     AL, [DS:BX+SI]          ; AL = Note
                Xor     AH, AH
                Mov     CL, 0Ch
                Div     CL                      ; AL = octave, AH = Note

                Mov     AL, DL
                Mov     CH, AH
                Mul     CL
                Add     AL, CH                  ; AL = new note

                Mov     [DS:BX+SI], AL

                NetworkSendInstrument
                Jmp     I_NoteDown

I_PostNoteWindow8:
                Mov     AL, [DS:BX+SI]          ; AL = sample.
                Xor     AH, AH
                Mov     CL, 10
                Div     CL                      ; AL = tens, AH = units

                Mov     AL, DL
                Mov     CH, AH
                Mul     CL
                Add     AL, CH

                Mov     SampleNumber, AL
                Mov     [DS:BX+SI], AL

                NetworkSendInstrument
                Jmp     I_NoteRight

I_PostNoteWindow9:
                Mov     AL, [DS:BX+SI]
                Xor     AH, AH
                Mov     CL, 10
                Div     CL

                Mov     CH, AH
                Mul     CL

                Add     AL, DL

                Mov     SampleNumber, AL
                Mov     [DS:BX+SI], AL

                Mov     NotePos, 2

I_PostNoteWindowEnd:
                NetworkSendInstrument
                Jmp     I_NoteDown

EndP            I_PostNoteWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SelectNoteMouse Far
                Assume DS:Inst

                ShR     DX, 3
                Add     DX, TopNote
                Sub     DX, 16
                JNC     I_SelectNoteMouse1

                Xor     DX, DX

I_SelectNoteMouse1:
                Cmp     DX, 119
                JB      I_SelectNoteMouse2

                Mov     DX, 119

I_SelectNoteMouse2:
                Mov     CurrentNote, DX

                Mov     AX, 1
                Ret

EndP            I_SelectNoteMouse
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NoteUp Far

                Assume DS:Inst

                Mov     AX, CurrentNote
                Dec     AX
                JS      I_NoteUp2

                Mov     CurrentNote, AX
                Jmp     I_NoteUp1

I_NoteUp2:
                Mov     Word Ptr [ES:DI], 5

I_NoteUp1:
                Mov     AX, 1
                Ret

EndP            I_NoteUp
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NoteDown Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Mov     AX, CurrentNote
                Inc     AX
                Cmp     AX, 119
                JA      I_NoteDown1

                Mov     CurrentNote, AX

I_NoteDown1:
                Mov     AX, 1
                Ret

EndP            I_NoteDown
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NotePgUp Far

                Assume DS:Inst

                Mov     AX, CurrentNote
                Sub     AX, 12
                JNS     I_NotePgUp1

                Xor     AX, AX

I_NotePgUp1:
                Mov     CurrentNote, AX

                Mov     AX, 1
                Ret

EndP            I_NotePgUp
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NotePgDn Far

                Assume DS:Inst

                Mov     AX, CurrentNote
                Add     AX, 12
                Cmp     AX, 119
                JBE     I_NotePgDn1

                Mov     AX, 119

I_NotePgDn1:
                Mov     CurrentNote, AX

                Mov     AX, 1
                Ret

EndP            I_NotePgDn
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NoteRight Far

                Push    CS
                Pop     DS
                Assume DS:Inst

                Mov     AX, NotePos
                Inc     AX
                Cmp     AX, 4
                JB      I_NoteRight1

                Mov     AX, 3

I_NoteRight1:
                Mov     NotePos, AX

                Mov     AX, 1
                Ret

EndP            I_NoteRight
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NoteLeft Far

                Assume DS:Inst
                Mov     AX, NotePos
                Dec     AX
                JS      I_NoteLeft1

                Mov     NotePos, AX

I_NoteLeft1:
                Mov     AX, 1
                Ret

EndP            I_NoteLeft
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NoteHome Far
                Assume DS:Inst

                Mov     CurrentNote, 0

                Mov     AX, 1
                Ret

EndP            I_NoteHome
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NoteEnd Far
                Assume DS:Inst

                Mov     CurrentNote, 119

                Mov     AX, 1
                Ret

EndP            I_NoteEnd
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NoteTab Far

                Mov     Word Ptr [ES:DI], 16

                Mov     AX, 1
                Ret

EndP            I_NoteTab
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NoteShiftTab Far

                Mov     Word Ptr [ES:DI], 4

                Mov     AX, 1
                Ret

EndP            I_NoteShiftTab
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NoteSampleIncrease Far

                Assume  DS:Inst

                Mov     AL, SampleNumber
                Inc     AX
                Cmp     AL, 99
                JA      I_NoteSampleIncrease1

                Mov     SampleNumber, AL

I_NoteSampleIncrease1:
                Mov     AX, 1
                Ret

EndP            I_NoteSampleIncrease
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NoteSampleDecrease Far

                Assume  DS:Inst

                Mov     AL, SampleNumber
                Dec     AL
                JS      I_NoteSampleDecrease1

                Mov     SampleNumber, AL

I_NoteSampleDecrease1:
                Mov     AX, 1
                Ret

EndP            I_NoteSampleDecrease
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NoteSamplePickUp Far

                Assume DS:Nothing

                Call    I_GetInstrumentOffset

                Mov     SI, CurrentNote
                Mov     AX, SI
                Mov     PlayNote, AL
                Add     SI, SI

                Mov     AX, [DS:BX+SI+40h]

                Mov     SampleNumber, AH

                Mov     AX, 1
                Ret

EndP            I_NoteSamplePickUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NoteNext Far
                Assume DS:Inst

                Mov     SI, CurrentNote
                Add     SI, SI
                JZ      I_NoteNext1

                Call    I_GetInstrumentOffset
                        Assume DS:Nothing

                Add     BX, SI
                Add     BX, 40h

                Mov     AX, [DS:BX-2]           ; 'Last note.'
                Cmp     AL, 119                 ; Is previous note >= B-9
                JAE     I_NoteNext1

                Inc     AX
                Mov     [DS:BX], AX

                NetworkSendInstrument
                Jmp     I_NoteDown

I_NoteNext1:
                Mov     AX, 1
                Ret

EndP            I_NoteNext
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NotePrevious Far
                Assume DS:Inst

                Mov     SI, CurrentNote
                Cmp     SI, 119
                JAE     I_NotePrevious1

                Add     SI, SI

                Call    I_GetInstrumentOffset
                        Assume DS:Nothing

                Add     BX, SI
                Add     BX, 40h

                Mov     AX, [DS:BX+2]           ; 'Last note.'
                Test    AL, AL
                JZ      I_NotePrevious1

                Dec     AX
                Mov     [DS:BX], AX

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Mov     AX, CurrentNote
                Dec     AX
                JS      I_NotePrevious1

                Mov     CurrentNote, AX
                NetworkSendInstrument

I_NotePrevious1:

                Mov     AX, 1
                Ret

EndP            I_NotePrevious
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NoteAll Far

                Assume  DS:Nothing

                Call    I_GetInstrumentOffset
                Push    DS
                Pop     ES

                LEA     DI, [BX+40h]

                Mov     CX, 120
                Mov     AH, SampleNumber
                Xor     AL, AL


I_NoteAll1:
                StosW
                Inc     AX
                Loop    I_NoteAll1

                Sub     DI, 110h

                MovZX   BX, SampleNumber
                Add     BX, BX
                JZ      I_NoteAll2

                Mov     SI, [BX+64910]
                Add     SI, 14h

                Mov     CX, 26
                Rep     MovsB

I_NoteAll2:
                NetworkSendInstrument

                Mov     AX, 1
                Ret

EndP            I_NoteAll
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NoteInsert Far

                Assume  DS:Nothing

                Call    I_GetInstrumentOffset
                Push    DS
                Pop     ES
                LEA     DI, [BX+40h+120*2-2]
                LEA     SI, [DI-2]
                Mov     CX, 119

                StD
                Rep     MovsW
                Xor     AX, AX
                StosW
                ClD

                NetworkSendInstrument
                Mov     AX, 1
                Ret

EndP            I_NoteInsert

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NoteDelete Far

                Assume  DS:Nothing

                Call    I_GetInstrumentOffset
                Push    DS
                Pop     ES
                LEA     DI, [BX+40h]
                LEA     SI, [DI+2]
                Mov     CX, 119

                Rep     MovsW
                Xor     AX, AX
                StosW

                NetworkSendInstrument

                Mov     AX, 1
                Ret

EndP            I_NoteDelete

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NoteTransposeUp Far

                Assume  DS:Nothing

                Call    I_GetInstrumentOffset
                Push    DS
                Pop     ES

                LEA     DI, [BX+40h]

                Mov     CX, 120

I_NoteTransposeUp1:
                Mov     AL, [DI]
                Inc     AX
                Cmp     AL, 119
                JBE     I_NoteTransposeUp2

                Mov     AL, 119

I_NoteTransposeUp2:
                StosB
                Inc     DI
                Loop    I_NoteTransposeUp1

                NetworkSendInstrument
                Mov     AX, 1
                Ret

EndP            I_NoteTransposeUp
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NoteTransposeDown Far

                Assume  DS:Nothing

                Call    I_GetInstrumentOffset
                Push    DS
                Pop     ES

                LEA     DI, [BX+40h]

                Mov     CX, 120

I_NoteTransposeDown1:
                Mov     AL, [DI]
                Sub     AL, 1
                AdC     AL, 0
                StosB
                Inc     DI
                Loop    I_NoteTransposeDown1

                NetworkSendInstrument

                Mov     AX, 1
                Ret

EndP            I_NoteTransposeDown
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_NoteSpace Far

                Assume DS:Inst
                Cmp     NotePos, 2
                JB      I_NoteSpace1

                Mov     SI, CurrentNote
                Add     SI, SI

                Call    I_GetInstrumentOffset
                        Assume DS:Nothing
                Mov     AL, SampleNumber
                Mov     [BX+SI+41h], AL

                Jmp     I_NoteDown

I_NoteSpace1:
                NetworkSendInstrument
                Xor     AX, AX
                Ret

EndP            I_NoteSpace
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_ExchangeInstruments Far

                EnsureNoNetwork

                Mov     DI, Offset O1_ExchangeInstrumentList
                Call    GetNumberInput

                Mov     SI, DX
                Dec     SI
                Add     SI, SI

                Call    PE_GetLastInstrument
                Add     BX, BX

                Cmp     SI, BX
                JE      I_ExchangeInstruments1

                Call    Music_GetSongSegment
                Mov     ES, AX
                Mov     DS, AX
                Mov     DI, [DS:64712+BX]
                Mov     SI, [DS:64712+SI]               ; DS:SI, ES:DI point to
                                                        ; sample headers

                Mov     CX, 554

I_ExchangeInstruments2:
                Mov     AL, [ES:DI]
                MovsB
                Mov     [DS:SI-1], AL

                Loop    I_ExchangeInstruments2

                Call    I_MapEnvelope

I_ExchangeInstruments1:
                Mov     AX, 1
                Ret

EndP            I_ExchangeInstruments

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_DoubleSampleSpeed Far

                Call    I_GetSampleOffset
                Mov     EAX, [BX+3Ch]
                ShL     EAX, 1
                Cmp     EAX, 9999999
                JA      I_DoubleSampleSpeed1

                Mov     [BX+3Ch], EAX

I_DoubleSampleSpeed1:
                NetworkSendSample

                Mov     AX, 1
                Ret

EndP            I_DoubleSampleSpeed

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_HalveSampleSpeed Far

                Call    I_GetSampleOffset
                ShR     DWord Ptr [BX+3Ch], 1

                NetworkSendSample

                Mov     AX, 1
                Ret

EndP            I_HalveSampleSpeed

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SampleSpeedSemiUp Far

                Call    I_GetSampleOffset

                Mov     EAX, 255392045
                Mul     DWord Ptr [BX+3Ch]

                Add     EDX, [BX+3Ch]
                JC      I_SampleSpeedSemiUp1

                Mov     [BX+3Ch], EDX

I_SampleSpeedSemiUp1:
                NetworkSendSample

                Mov     AX, 1
                Ret

EndP            I_SampleSpeedSemiUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SampleSpeedSemiDown Far

                Call    I_GetSampleOffset

                Mov     EAX, 4053909306
                Mul     DWord Ptr [BX+3Ch]
                Mov     [BX+3Ch], EDX

                NetworkSendSample

                Mov     AX, 1
                Ret

EndP            I_SampleSpeedSemiDown

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_ReplaceInstrument Far

                EnsureNoNetwork

                Mov     DI, Offset O1_ReplaceInstrumentList
                Call    GetNumberInput

                Call    PE_GetLastInstrument
                Mov     DH, BL
                Inc     DH                              ; DH/DL = samples to swap

                Cmp     DL, DH
                JE      I_ReplaceInstrument1

                Call    Music_GetInstrumentMode
                JZ      I_ReplaceInstrument1

                XChg    DH, DL
                Or      DH, 80h
                Call    PE_SwapInstruments

I_ReplaceInstrument1:
                Mov     AX, 1
                Ret

EndP            I_ReplaceInstrument

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_ScaleSampleVolumes Far

                EnsureNoNetwork

                Mov     DI, Offset O1_GetInstrumentAmpList
                Mov     CX, 3
                Call    M_Object1List

                Cmp     DX, 1
                JNE     I_ScaleSampleVolumesEnd

                Mov     BP, CS:InstrumentAmplification
                Mov     BX, 100

                Call    Music_GetSongSegment
                Mov     DS, AX
                Mov     SI, 64912
                Mov     CX, 99

I_ScaleSampleVolumes1:
                Xor     AX, AX
                Mov     DI, [SI]
                Mov     AL, [DI+11h]
                Mul     BP
                Div     BX
                Cmp     AX, 64
                JB      I_ScaleSampleVolumes2

                Mov     AX, 64

I_ScaleSampleVolumes2:
                Mov     [DI+11h], AL

                Add     SI, 2
                Dec     CX
                JNZ     I_ScaleSampleVolumes1

I_ScaleSampleVolumesEnd:
                Mov     AX, 1
                Ret

EndP            I_ScaleSampleVolumes

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_ScaleInstrumentVolumes Far

                EnsureNoNetwork

                Mov     DI, Offset O1_GetInstrumentAmpList
                Mov     CX, 3
                Call    M_Object1List

                Cmp     DX, 1
                JNE     I_ScaleInstrumentVolumesEnd

                Mov     BP, CS:InstrumentAmplification
                Mov     BX, 100

                Call    Music_GetSongSegment
                Mov     DS, AX
                Mov     SI, 64712
                Mov     CX, 99

I_ScaleInstrumentVolumes1:
                Xor     AX, AX
                Mov     DI, [SI]
                Mov     AL, [DI+18h]
                Mul     BP
                Div     BX
                Cmp     AX, 128
                JB      I_ScaleInstrumentVolumes2

                Mov     AX, 128

I_ScaleInstrumentVolumes2:
                Mov     [DI+18h], AL

                Add     SI, 2
                Dec     CX
                JNZ     I_ScaleInstrumentVolumes1

I_ScaleInstrumentVolumesEnd:
                Mov     AX, 1
                Ret

EndP            I_ScaleInstrumentVolumes

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_CopyInstrument Far

                Mov     DI, Offset O1_CopyInstrumentList
                Call    GetNumberInput

                Call    I_GetInstrumentOffset   ; Gets DS:BX with cur inst.

                Mov     DI, BX
                Mov     SI, DX
                Add     SI, SI
                Mov     SI, [64710+SI]

                Push    DS
                Pop     ES

                Mov     CX, 554/2
                Rep     MovsW

                Call    I_MapEnvelope

                NetworkSendInstrument

                Mov     AX, 1
                Ret

EndP            I_CopyInstrument

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SwapInstruments Far

                EnsureNoNetwork

                Mov     DI, Offset O1_SwapInstrumentList
                Call    GetNumberInput

                Mov     SI, DX
;                Dec     SI
                Add     SI, SI

                Call    PE_GetLastInstrument
                Mov     DH, BL
                Inc     DH                              ; DH/DL = samples to swap
                Add     BX, BX

                Cmp     DL, DH
                JE      I_SwapInstruments1

                Call    Music_GetSongSegment
                Mov     ES, AX
                Mov     DS, AX
                Mov     DI, [DS:64712+BX]
                Mov     SI, [DS:64710+SI]               ; DS:SI, ES:DI point to
                                                        ; sample headers

                Mov     CX, 554

I_SwapInstruments2:
                Mov     AL, [ES:DI]                     ; Swapping headers.
                MovsB
                Mov     [DS:SI-1], AL

                Loop    I_SwapInstruments2

                                                        ; Now to swap pattern
                                                        ; stuff...
                Call    Music_GetInstrumentMode
                JZ      I_SwapInstruments3

                Call    PE_SwapInstruments

I_SwapInstruments3:
                Call    I_MapEnvelope

I_SwapInstruments1:
                Mov     AX, 1
                Ret

EndP            I_SwapInstruments

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_UpdateInstrument Far

                EnsureNoNetwork

                Call    PE_GetLastInstrument
                Mov     DX, BX
                Inc     DX
                Add     BX, BX

                Call    Music_GetSongSegment
                Mov     ES, AX
                Mov     DI, [ES:64712+BX]
                Add     DI, 40h

                Call    PE_UpdateInstruments

                Mov     AX, 1
                Ret

EndP            I_UpdateInstrument

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseEnvelopeEvent1 Far

                Mov     CS:MouseX, CX
                Mov     CS:MouseY, DX

                Mov     CX, 8010h       ; Envelope mouse control request..
                Call    AddMouseQueue

                Xor     AX, AX
                Ret

EndP            MouseEnvelopeEvent1

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseEnvelopeEvent4 Far ; Delete node

                Test    BH, 6
                JNZ     MouseEnvelopeEvent4_1

                Mov     CS:MouseX, CX
                Mov     CS:MouseY, DX

                Mov     CX, 8003h       ; Envelope mouse control request..
                Call    AddMouseQueue

MouseEnvelopeEvent4_1:
                Xor     AX, AX
                Ret

EndP            MouseEnvelopeEvent4

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseEnvelopeEvent2 Far ; Envelope drag

                Mov     CS:MouseX, CX
                Mov     CS:MouseY, DX

                Mov     CX, 8001h
                Call    AddMouseQueue

                Xor     AX, AX
                Ret

EndP            MouseEnvelopeEvent2

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseEnvelopeEvent3 Far ; Release envelope

                Mov     CX, 8002h
                Call    AddMouseQueue

                Xor     AX, AX
                Ret

EndP            MouseEnvelopeEvent3

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DrawEnvelopeHeader      ; AH = colour, DS = inst
                Assume DS:Inst

                Mov     SI, InstrumentScreen    ; 1-3
                Add     SI, SI                  ; 2-6
                Add     SI, Word Ptr NodeHeld   ; 2-7
                Add     SI, SI                  ; 4-14
                Mov     SI, [EnvelopeHeaderTable+SI-4]
                Mov     DI, (33+16*80)*2

                Call    S_DrawString

                Ret

EndP            DrawEnvelopeHeader
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_DrawEnvelope Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Mov     AH, 20h
                Call    DrawEnvelopeHeader

                Call    S_GetDestination
                Mov     DI, (32+18*80)*2
                Mov     AX, 0C00h

                Mov     DX, 8

I_DrawEnvelope1:
                Mov     CX, 32

I_DrawEnvelope2:
                StosW
                Inc     AX
                Loop    I_DrawEnvelope2

                Add     DI, (80-32)*2
                Dec     DX
                JNZ     I_DrawEnvelope1

                Call    I_GetEnvelopeOffset     ; Returns DS:SI
                Mov     BX, CS:CurrentNode       ; to envelope table
                Mov     CX, BX

                Add     BX, BX
                Add     BX, CX                  ; BX = CurrentNode*3

                Mov     AL, [SI+BX+6]
                CBW                             ; Value

                Test    Byte Ptr [SI], 80h
                JZ      I_DrawEnvelope5

                Add     AX, 32

I_DrawEnvelope5:
                Push    AX
                Push    Word Ptr [SI+BX+7]      ; Tick
                Push    CS:MaxNode
                Push    CX                      ; Node

                Mov     DI, (66+19*80)*2
                Mov     AH, 2
                Push    CS
                Pop     DS
                Mov     SI, Offset EnvelopeMsg
                Call    S_DrawString

                Add     SP, 8

                Cmp     MouseNodeHeld, 0
                JZ      I_DrawEnvelope4

                Call    MouseGetStatus
                Test    AL, 6
                JNZ     I_DrawEnvelope3

                Call    I_MouseEnvelopeReleased
                Jmp     I_DrawEnvelope4

I_DrawEnvelope3:
                Mov     SI, Offset EnvelopeEvent3
                Call    MouseAddEvent
                Mov     SI, Offset EnvelopeEvent2
                Call    MouseAddEvent

                Ret

I_DrawEnvelope4:
                Mov     SI, Offset EnvelopeEvent1
                Call    MouseAddEvent
                Mov     SI, Offset EnvelopeEvent4
                Call    MouseAddEvent

                Ret

EndP            I_DrawEnvelope
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_PreEnvelope Far

                Push    CS
                Pop     DS

                Mov     AH, 23h
                Call    DrawEnvelopeHeader

                Ret

EndP            I_PreEnvelope
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_PostEnvelope Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Mov     SI, Offset VolumeEnvelopeNodeKeys

                Cmp     NodeHeld, 1
                JE      I_PostEnvelope2

                Mov     SI, Offset VolumeEnvelopeKeys

I_PostEnvelope2:
                Call    M_FunctionDivider
                JC      I_PostEnvelope1

                Jmp     [SI]

I_PostEnvelope1:
IF ENABLEPRESETENVELOPES

                Cmp     DX, '0'
                JB      I_PostEnvelopeNoPreset
                Cmp     DX, '9'
                JA      I_PostEnvelopeNoPreset

                Call    I_GetEnvelopeOffset
                Push    DS
                Pop     ES
                Mov     DI, SI          ; ES:DI set

                Push    CS
                Pop     DS
                Mov     AL, 81
                Sub     DL, '0'
                Mul     DL              ; AX = offset
                Mov     SI, AX
                Add     SI, Offset PresetEnvelopes

                Mov     CX, 6/2
                Rep     MovsW
                Mov     CX, 25

I_PostEnvelopePreset1:
                LodsB
                Sub     AL, AmplitudeCompensate
                StosB
                MovsW
                Loop    I_PostEnvelopePreset1

                Call    I_MapEnvelope
                NetworkSendInstrument

                Mov     AX, 1
                Ret

I_PostEnvelopeNoPreset:
                Test    CH, 60h         ; Alt?
                JZ      I_PostEnvelopeNoSet
                Test    CH, 1           ; On keypress
                JZ      I_PostEnvelopeNoSet

                Cmp     CL, 2
                JB      I_PostEnvelopeNoSet
                Cmp     CL, 0Bh
                JA      I_PostEnvelopeNoSet
                JNE     I_PostEnvelopeSet2

                Mov     CL, 1

I_PostEnvelopeSet2:
                Mov     AX, CX
                Dec     AX
                And     AX, 0FFh
                Mov     SI, Offset EnvelopeSetMsg
                Call    SetInfoLine
                Mov     CL, 81
                Mul     CL

                Call    I_GetEnvelopeOffset     ; Gets DS:SI
                Push    CS
                Pop     ES
                Mov     DI, AX
                Add     DI, Offset PresetEnvelopes      ; ES:DI points to dest

                LodsW
                And     AL, 7Fh
                StosW

                Mov     CX, 4/2
                Rep     MovsW
                Mov     CX, 25

I_PostEnvelopeSet1:
                LodsB
                Add     AL, CS:AmplitudeCompensate
                StosB
                MovsW
                Loop    I_PostEnvelopeSet1

                Call    I_MapEnvelope

                Mov     AX, 1
                Ret

I_PostEnvelopeNoSet:
ENDIF                                           ; PRESETENVELOPES
                Xor     AX, AX
                Ret

EndP            I_PostEnvelope

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_MapEnvelope Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Cmp     InstrumentScreen, 0
                JNE     I_MapEnvelope1

                Ret

I_MapEnvelope1:
                Mov     UpdateInstrumentScreen, 0

                Push    BP

                Call    S_GetGenerationTableOffset
                Push    DI                      ; ES:DI points to table.
                Mov     CX, 32*8*8*8/4
                Xor     EAX, EAX
                Rep     StosD
                Pop     DI
                Push    DI

                Add     DI, 3
                Mov     CX, 32
                Inc     AX

I_MapEnvelopeYAxis1:
                StosB
                Add     DI, 511
                Loop    I_MapEnvelopeYAxis1

                Pop     DI
                Push    DI

                Call    I_GetEnvelopeOffset ; DS:SI points to envelope
                        Assume DS:Nothing

                Mov     AL, 32

                Add     DI, 31*256

                Test    Byte Ptr [SI], 80h
                JNZ     I_MapEnvelopeFilterCompensate
                Cmp     Byte Ptr [CS:InstrumentScreen], 1
                JNE     I_MapEnvelopeXAxis1

                Xor     AL, AL
I_MapEnvelopeFilterCompensate:
                Add     DI, 31*256

I_MapEnvelopeXAxis1:
                Mov     CS:AmplitudeCompensate, AL

                Mov     AX, 100h
                Mov     CX, 128

                Rep     StosW           ; X-axis drawn

                Pop     DI

                Xor     DH, DH
                Mov     DL, [SI+1]

                Mov     CS:MaxNode, DX
                Cmp     CS:CurrentNode, DX
                JB      I_MapEnvelope2

                Mov     AX, DX
                Sub     AX, 1
                AdC     AX, 0
                Mov     CS:CurrentNode, AX

I_MapEnvelope2:
                Test    DX, DX
                JZ      I_MapEnvelopeEnd

                Sub     DX, 1
                AdC     DX, 1

                Push    DX

                                        ; DX = last node
                                        ; DS:SI = envelope, ES:DI = table
                Mov     BX, DX          ; MaxNode
                Add     BX, BX
                Add     BX, DX          ; BX = MaxNode*3

                Mov     AX, [DS:SI+BX+6+1-3]    ; Get last nodes tick
                Xor     DX, DX
                Mov     BX, ENVELOPEGRANULARITY
                Div     BX
                Inc     AX
                Mul     BX
                Mov     CS:UpperLimit, AX

                Push    DI
                Xor     BP, BP
                Jmp     I_MapEnvelope4

I_MapEnvelope3:
                Push    CX
                Push    DI

I_MapEnvelope4:                         ; Node drawing part
                Mov     BX, BP
                Add     BX, BX
                Add     BX, BP

                Mov     AL, 64
                Sub     AL, CS:AmplitudeCompensate
                Sub     AL, [SI+BX+6]
                Mov     AH, 244         ; 244 = 61/64*256
                Mul     AH
                                        ; AX = amplitude
                Mov     CS:CurrentAmplitude, AX
                Mov     CX, AX          ; CX = amplitude

                Mov     AX, [SI+BX+7]
                Cmp     AX, CS:UpperLimit
                JAE     I_MapEnvelopeError

                Mov     DX, 250         ; 249 if UpperLimit = LastNode tick
                Mul     DX
;                Add     AX, 125
;                AdC     DX, 0
                Div     CS:UpperLimit

                Mov     CS:CurrentTick, AX

                                ; OK.. plot points
                Xor     CL, CL
                Add     DI, AX
                Add     DI, CX
                Add     DI, 256+3

                Mov     AX, 101h
                Mov     [ES:DI], AX
                Mov     [ES:DI-256], AX
                Mov     [ES:DI+256], AX
                Mov     [ES:DI-1], AL
                Mov     [ES:DI-256-1], AL
                Mov     [ES:DI+256-1], AL

                Cmp     BP, CS:CurrentNode
                JNE     I_MapEnvelope5

                Dec     AX
                Mov     [ES:DI+2], AX
                Mov     [ES:DI+256+2], AX
                Mov     [ES:DI-256+2], AX
                XChg    AH, AL
                Mov     [ES:DI-3], AX
                Mov     [ES:DI+256-3], AX
                Mov     [ES:DI-256-3], AX

I_MapEnvelope5:
                Sub     DI, CX
                Sub     DI, 256
                Mov     AX, BP
                Mov     CX, 64

                Test    Byte Ptr [SI], 2
                JZ      I_MapEnvelope6

                Mov     AH, 1

                Cmp     AL, [SI+2]
                JE      I_MapEnvelopeLoop1
                Cmp     AL, [SI+3]
                JNE     I_MapEnvelope6

I_MapEnvelopeLoop1:
                Mov     AL, AH
                ShR     AL, 1
                StosB
                Add     DI, 255
                Inc     AH
                Loop    I_MapEnvelopeLoop1

                Jmp     I_MapEnvelope7

I_MapEnvelope6:
                Test    Byte Ptr [SI], 4
                JZ      I_MapEnvelope7

                Cmp     AL, [SI+4]
                JE      I_MapEnvelopeSusLoop2
                Cmp     AL, [SI+5]
                JNE     I_MapEnvelope7

I_MapEnvelopeSusLoop2:
                Mov     AL, 1

I_MapEnvelopeSusLoop1:
                StosB
                Add     DI, 255
                Xor     AL, 1
                Loop    I_MapEnvelopeSusLoop1

I_MapEnvelope7:                         ; Now for line segment
                Test    BP, BP
                JZ      I_MapEnvelope8  ; Don't draw line for first node

                Pop     DI
                Push    DI

                Add     DI, CS:LastTick
                Add     DI, 103h

                Mov     CX, CS:CurrentTick
                Sub     CX, CS:LastTick
                JC      I_MapEnvelope8          ; Error..
                JNZ     I_MapEnvelope11

                                        ; Vertical line.
                Mov     AX, CS:LastAmplitude
                Mov     CX, CS:CurrentAmplitude
                Xor     AL, AL
                Xor     CL, CL

                Add     DI, AX          ; LastAmplitude

                Mov     DX, 256

                Sub     CX, AX
                JNS     I_MapEnvelope9

                Neg     DX
                Neg     CX

I_MapEnvelope9:
                ShR     CX, 8
                JZ      I_MapEnvelope12

I_MapEnvelope10:
                Mov     Byte Ptr [ES:DI], 1
                Add     DI, DX
                Loop    I_MapEnvelope10

I_MapEnvelope12:
                Jmp     I_MapEnvelope8

I_MapEnvelope11:                        ; Diagonal line
                Push    SI

                Xor     SI, SI
                Mov     AX, CS:CurrentAmplitude
                Sub     AX, CS:LastAmplitude
                JNS     I_MapEnvelope13

                Inc     SI              ; SI = 1 if opp direction
                Neg     AX

I_MapEnvelope13:
                Xor     DX, DX
                Div     CX
                Mov     DX, AX

                Test    SI, SI
                Mov     SI, -256
                JZ      I_MapEnvelope15

                Neg     SI
                Neg     DX

I_MapEnvelope15:
                Mov     BX, CS:LastAmplitude
                Inc     CX
                Dec     DI
                Push    DI
                Jmp     I_MapEnvelope17

I_MapEnvelope14:
                Push    DI
                Push    BX
                Xor     BL, BL
                Add     DI, BX

I_MapEnvelope16:
                Mov     Byte Ptr [ES:DI], 1
                Add     DI, SI
                Dec     AL
                JNZ     I_MapEnvelope16

                Pop     BX

I_MapEnvelope17:
                Mov     AL, BH
                Add     BX, DX
                Sub     AL, BH

                CBW                     ;
                Xor     AL, AH          ; AL = |AL|
                Sub     AL, AH          ;
                Sub     AL, 1
                AdC     AL, 1

                Pop     DI
                Inc     DI
                Loop    I_MapEnvelope14

                Pop     SI

I_MapEnvelope8:
                Mov     AX, CS:CurrentAmplitude
                Mov     BX, CS:CurrentTick
                Mov     CS:LastAmplitude, AX
                Mov     CS:LastTick, BX

I_MapEnvelopeError:
                Pop     DI
                Pop     CX
                Inc     BP
                Loop    I_MapEnvelope3

                                ; Now shove on playing points.

                Call    PE_GetLastInstrument
                Inc     BX

                Mov     CX, CS:InstrumentScreen
                Mov     BP, CX
                Mov     DL, 1
                Add     CL, 11
                ShL     BP, 4
                ShL     DX, CL
                Add     BP, 48h

                Call    Music_GetSlaveChannelInformationTable
                        ; Returns DS:SI, CX
                        Assume DS:Nothing

I_MapEnvelopePlaying1:
                Cmp     [SI+33h], BL
                JNE     I_MapEnvelopePlayingNext

                Test    Byte Ptr [SI], 1
                JZ      I_MapEnvelopePlayingNext

                Mov     AX, [DS:SI+BP]
                And     AX, AX
                JNZ     I_MapEnvelopePlaying2

                Test    [SI], DX
                JZ      I_MapEnvelopePlayingNext

I_MapEnvelopePlaying2:
                Cmp     AX, CS:UpperLimit
                JAE     I_MapEnvelopePlayingNext

                Push    CX
                Push    DX

                Call    S_GetGenerationTableOffset
                Add     DI, 3

                Mov     DX, 250
                Mul     DX
                Div     CS:UpperLimit

                Add     DI, AX
                Mov     CX, 64

I_DrawEnvelopePlaying1:
                Mov     Byte Ptr [ES:DI], 1
                Add     DI, 256
                Loop    I_DrawEnvelopePlaying1

                Mov     CS:UpdateInstrumentScreen, 1

                Pop     DX
                Pop     CX

I_MapEnvelopePlayingNext:
                Add     SI, SLAVECHANNELSIZE
                Loop    I_MapEnvelopePlaying1

I_MapEnvelopeEnd:
                Xor     AX, AX
                Mov     BX, 32
                Mov     CX, 8
                Call    S_GenerateCharacters

                Pop     BP

                Push    CS
                Pop     DS

                Ret

EndP            I_MapEnvelope
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_GetMouseNode               ; Returns DI, carry if none

                Call    I_GetEnvelopeOffset
                                        ; Returns DS:SI to envelope
                Xor     CH, CH
                Mov     CL, [SI+1]

                Add     SI, 6           ; Start of envelope.. have to find
                                        ; a point that fits MouseX, MouseY
        ; XPixel = ENVELOPELEFT*8 + 250*Tick/UpperLimit + 3
        ; YPixel = ENVELOPETOP*8 + 61*(64-AmplitudeCompensate-Amplitude)/64 + 1

                Xor     DI, DI          ; DI = node number.
                JCXZ    I_GetMouseNode3

I_GetMouseNode1:
                Mov     BX, DI
                Add     BX, BX
                Add     BX, DI

                Mov     AX, 250
                Mul     Word Ptr [SI+BX+1]
                Div     CS:UpperLimit
                Add     AX, ENVELOPELEFT*8+2

                Mov     DL, 64
                Sub     DL, CS:AmplitudeCompensate
                Sub     DL, [SI+BX]

                Mov     BX, AX                  ; BX = XPixel

                Mov     AL, 244         ; 244 = 61/64*256
                Mul     DL
                Mov     AL, AH
                Xor     AH, AH
                Add     AX, ENVELOPETOP*8       ; AX = YPixel of node...

                Cmp     MouseX, BX
                JB      I_GetMouseNode2
                Cmp     MouseY, AX
                JB      I_GetMouseNode2
                Add     AX, 2
                Add     BX, 2
                Cmp     MouseX, BX
                JA      I_GetMouseNode2
                Cmp     MouseY, AX
                JA      I_GetMouseNode2

I_GetMouseNode3:
                ClC
                Ret

I_GetMouseNode2:
                Inc     DI
                Cmp     DI, CX
                JB      I_GetMouseNode1

                StC
                Ret

EndP            I_GetMouseNode

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_MouseEnvelopeDelete Far

                Call    I_GetMouseNode
                JC      I_MouseEnvelopeDelete1
                Mov     CS:CurrentNode, DI

                Push    CS
                Pop     DS
                Jmp     I_VolumeEnvelopeDelete

I_MouseEnvelopeDelete1:
                Mov     AX, 1
                Ret

EndP            I_MouseEnvelopeDelete

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_MouseEnvelopePress Far
                Assume DS:Nothing
                                        ; If on top of node, then pick up this
                                        ; node, ;  MouseNodeHeld = 1
                                        ; If NOT near node, and nodes < 25,
                                        ;  then CREATE new node in appropriate
                                        ;  position, MouseNodeHeld = 1. If
                                        ;  no node will fit in-between, then
                                        ;  do nothing.
                                        ; Else nothing
                Call    I_GetMouseNode
                JNC     I_MouseEnvelopeNodeFound1
                Cmp     CX, 25
                JAE     I_MouseEnvelopePressError

                                        ; Figger out envelope tick position...
                Mov     AX, MouseX
                Sub     AX, ENVELOPELEFT*8+3
                JNC     I_MouseEnvelopeCreateNode4

                Xor     AX, AX

I_MouseEnvelopeCreateNode4:
                Mov     BX, 250
                Mul     CS:UpperLimit
                Add     AX, 125
                AdC     DX, 0
                Div     BX

                Mov     CX, AX          ; CX = new position....
                Cmp     AX, MAXENVELOPETICK
                JB      I_MouseEnvelopeCreateNode3

                Mov     CX, MAXENVELOPETICK

I_MouseEnvelopeCreateNode3:
                Call    I_GetEnvelopeOffset
                Mov     DL, [SI+1]
                Mov     BX, SI
                Xor     DH, DH
                Xor     DI, DI
                Add     BX, 7

I_MouseEnvelopeCreateNode1:
                Cmp     CX, [BX]
                JE      I_MouseEnvelopePressError
                JB      I_MouseEnvelopeCreateNode2

                Add     BX, 3
                Inc     DI
                Cmp     DI, DX
                JB      I_MouseEnvelopeCreateNode1

I_MouseEnvelopeCreateNode2:
                ClI

                Inc     Byte Ptr [SI+1]

                Push    BX
                Push    CX
                Push    DI

                Mov     CX, DI
                Cmp     CL, [SI+2]
                JA      I_MEPIns1

                Inc     Byte Ptr [SI+2]

I_MEPIns1:
                Cmp     CL, [SI+3]
                JA      I_MEPIns2

                Inc     Byte Ptr [SI+3]

I_MEPIns2:
                Cmp     CL, [SI+4]
                JA      I_MEPIns3

                Inc     Byte Ptr [SI+4]

I_MEPIns3:
                Cmp     CL, [SI+5]
                JA      I_MEPIns4

                Inc     Byte Ptr [SI+5]

I_MEPIns4:

                Push    DS
                Pop     ES

                StD

                Sub     DX, DI
                Mov     CX, DX
                Add     CX, CX
                Add     CX, DX          ; CX = (Last-New)*3

                LEA     DI, [BX+1]
                Add     DI, CX
                LEA     SI, [DI-3]

                Rep     MovsB

                ClD

                Pop     DI
                Pop     CX
                Pop     BX

                Mov     [BX], CX

                Mov     CX, 61
                Mov     AX, MouseY
                Sub     AX, ENVELOPETOP*8
                JNC     I_MEPChk1

                Xor     AX, AX

I_MEPChk1:
                Cmp     AX, CX
                JB      I_MepChk2

                Mov     AX, CX

I_MEPChk2:
                ShL     AX, 6
                Xor     DX, DX
                Div     CX

                Mov     DL, 64
                Sub     DL, AL
                Sub     DL, CS:AmplitudeCompensate
                Mov     [BX-1], DL

I_MouseEnvelopeNodeFound1:      ; Have to find limits...
                Mov     CurrentNode, DI
                Call    I_EnvelopeSelected

                StI

                Mov     BX, DI
                Mov     CL, BL
                Inc     CX
                Add     BX, BX
                Add     BX, DI
                                        ; AX = lower limit, DX = upper limit
                Xor     AX, AX
                Xor     DX, DX
                And     DI, DI
                JZ      I_MouseEnvelopeNodeFound3

                Mov     DX, MAXENVELOPETICK
                Mov     AX, [SI+BX+6+1-3]
                Inc     AX

I_MouseEnvelopeNodeFound2:
                Cmp     CL, [SI+1]
                JAE     I_MouseEnvelopeNodeFound3

                Mov     DX, [SI+BX+6+1+3]
                Dec     DX

I_MouseEnvelopeNodeFound3:
                Mov     LowerTickLimit, AX
                Mov     UpperTickLimit, DX

                Mov     BX, 2
                Call    SetMouseCursorType

                Mov     AX, 1
                Mov     MouseNodeHeld, AL
                Call    SetKeyboardLock
                Jmp     I_MousePressChain

I_MouseEnvelopePressError:
                Mov     AX, 1
                Ret

EndP            I_MouseEnvelopePress
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_MouseEnvelopeDrag Far
                Assume DS:Nothing
                                        ; CurrentNode update

                Call    I_GetEnvelopeOffset
                                        ; Returns DS:SI to envelope
                Mov     AX, CurrentNode
                Mov     BX, AX
                Add     BX, BX
                Add     BX, AX
                LEA     SI, [SI+BX+6]   ; DS:SI points to current node

                        ; Tick first
                Mov     AX, MouseX
                Sub     AX, ENVELOPELEFT*8+3
                JNC     I_MouseEnvelopeDrag1

                Xor     AX, AX

I_MouseEnvelopeDrag1:
                Mov     BX, 250
                Mul     CS:UpperLimit
                Add     AX, 125
                AdC     DX, 0
                Div     BX
                                        ; AX = tick.. now to check bounds..
                Cmp     AX, LowerTickLimit
                JAE     I_MouseEnvelopeDrag2

                Mov     AX, LowerTickLimit

I_MouseEnvelopeDrag2:
                Cmp     AX, UpperTickLimit
                JBE     I_MouseEnvelopeDrag3

                Mov     AX, UpperTickLimit

I_MouseEnvelopeDrag3:
                ClI

                Mov     [SI+1], AX

                Mov     AX, MouseY
                Mov     CX, 61
                Sub     AX, ENVELOPETOP*8
                JNC     I_MouseEnvelopeDrag4

                Xor     AX, AX

I_MouseEnvelopeDrag4:
                Cmp     AX, CX
                JBE     I_MouseEnvelopeDrag5

                Mov     AX, CX

I_MouseEnvelopeDrag5:
                ShL     AX, 6
                Xor     DX, DX
                Div     CX

                Mov     DL, 64
                Sub     DL, AL
                Sub     DL, CS:AmplitudeCompensate
                Mov     [SI], DL

                StI

        ; XPixel = ENVELOPELEFT*8 + 250*Tick/UpperLimit + 3
        ; YPixel = ENVELOPETOP*8 + 61*(64-AmplitudeCompensate-Amplitude)/64 + 1

I_MousePressChain:
                Push    CS:UpperLimit
                Call    I_RedrawWave
                Pop     AX
                Cmp     AX, CS:UpperLimit
                JE      I_GetMousePositionEnd

                                        ; Set position....
                Call    I_GetEnvelopeOffset
                Mov     AX, CS:CurrentNode
                Add     SI, AX
                Add     SI, AX
                Add     SI, AX
                Add     SI, 6

                Mov     AX, 250
                Mul     Word Ptr [SI+1]
                Div     CS:UpperLimit
                Add     AX, ENVELOPELEFT*8-1   ; +3
                Mov     CX, AX

                Xor     DX, DX
                Mov     AL, 64
                Sub     AL, CS:AmplitudeCompensate
                Sub     AL, [SI]
                Mov     AH, 244
                Mul     AH
                Mov     DL, AH

                Add     DX, ENVELOPETOP*8-2 ; +1
                Call    MouseSetXY

I_GetMousePositionEnd:
                NetworkSendInstrument

                Mov     AX, 1
                Ret

EndP            I_MouseEnvelopeDrag
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_MouseEnvelopeReleased Far
                Assume DS:Inst
                                        ; MouseNodeHeld = 0

                Xor     BX, BX
                Call    SetMouseCursorType

                Xor     AX, AX
                Mov     CS:MouseNodeHeld, AL
                Call    SetKeyboardLock

                NetworkSendInstrument

                Mov     AX, 1
                Ret

EndP            I_MouseEnvelopeReleased
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_VolumeEnvelopeRight Far

                        Assume  DS:Inst

                Mov     AX, CurrentNode
                Inc     AX
                Cmp     AX, MaxNode
                JAE     I_VolumeEnvelopeRight1

                Mov     CurrentNode, AX
                Call    I_MapEnvelope

I_VolumeEnvelopeRight1:
                Mov     AX, 1
                Ret

EndP            I_VolumeEnvelopeRight
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_VolumeEnvelopeLeft Far

                        Assume  DS:Inst

                Cmp     CurrentNode, 0
                JE      I_VolumeEnvelopeLeft1

                Dec     CurrentNode
                Call    I_MapEnvelope

I_VolumeEnvelopeLeft1:
                Mov     AX, 1
                Ret

EndP            I_VolumeEnvelopeLeft
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_VolumeEnvelopeUp Far

                Mov     Word Ptr [ES:DI], 5

                Mov     AX, 1
                Ret

EndP            I_VolumeEnvelopeUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_VolumeEnvelopeDown Far

                Mov     Word Ptr [ES:DI], 17

                Mov     AX, 1
                Ret

EndP            I_VolumeEnvelopeDown

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_VolumeEnvelopeHeldUp Far

                        Assume DS:Inst

                Mov     CX, CurrentNode

                Call    I_GetEnvelopeOffset
                        Assume DS:Nothing

                Add     SI, CX
                Add     SI, CX
                Add     SI, CX
                Add     SI, 6

                Mov     AL, [SI]
                Add     AL, CS:AmplitudeCompensate

                Cmp     AL, 64
                JAE     I_VolumeEnvelopeHeldUp1

                Inc     Byte Ptr [SI]

                Call    I_MapEnvelope
                NetworkSendInstrument

I_VolumeEnvelopeHeldUp1:
                Mov     AX, 1
                Ret

EndP            I_VolumeEnvelopeHeldUp
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_VolumeEnvelopeHeldDown Far

                        Assume DS:Inst

                Mov     CX, CurrentNode

                Call    I_GetEnvelopeOffset
                        Assume DS:Nothing

                Add     SI, CX
                Add     SI, CX
                Add     SI, CX
                Add     SI, 6

                Mov     AL, [SI]
                Add     AL, CS:AmplitudeCompensate

                JZ      I_VolumeEnvelopeHeldDown1

                Dec     Byte Ptr [SI]

                Call    I_MapEnvelope
                NetworkSendInstrument

I_VolumeEnvelopeHeldDown1:
                Mov     AX, 1
                Ret

EndP            I_VolumeEnvelopeHeldDown
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_VolumeEnvelopeHeldLeft Far

                        Assume DS:Inst

                Mov     CX, CurrentNode
                Mov     DX, CX
                Add     DX, DX
                JZ      I_VolumeEnvelopeHeldLeft1

                Call    I_GetEnvelopeOffset
                        Assume DS:Nothing

                Add     SI, CX
                Add     SI, DX
                Add     SI, 7           ; DS:SI points to node's posn

                Mov     AX, [SI]

                Dec     AX
                Cmp     AX, [SI-3]                      ; Last node.
                JE      I_VolumeEnvelopeHeldLeft1

                Mov     [SI], AX

                Call    I_MapEnvelope
                NetworkSendInstrument

I_VolumeEnvelopeHeldLeft1:
                Mov     AX, 1
                Ret

EndP            I_VolumeEnvelopeHeldLeft
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_VolumeEnvelopeHeldLeftFast Far

                        Assume DS:Inst

                Mov     CX, CurrentNode
                Mov     DX, CX
                Add     DX, DX
                JZ      I_VolumeEnvelopeHeldLeftFast2

                Call    I_GetEnvelopeOffset
                        Assume DS:Nothing

                Add     SI, CX
                Add     SI, DX
                Add     SI, 7

                Mov     AX, [SI]

                Sub     AX, 16
                JNC     I_VolumeEnvelopeHeldLeftFast3

                Xor     AX, AX

I_VolumeEnvelopeHeldLeftFast3:
                Cmp     AX, [SI-3]                      ; Last node.
                JA      I_VolumeEnvelopeHeldLeftFast1

                Mov     AX, [SI-3]
                Inc     AX

I_VolumeEnvelopeHeldLeftFast1:
                Mov     [SI], AX

                Call    I_MapEnvelope
                NetworkSendInstrument

I_VolumeEnvelopeHeldLeftFast2:
                Mov     AX, 1
                Ret

EndP            I_VolumeEnvelopeHeldLeftFast
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_VolumeEnvelopeHeldHome Far

                        Assume DS:Inst

                Mov     CX, CurrentNode
                Mov     DX, CX
                Add     DX, DX
                JZ      I_VolumeEnvelopeHeldHome1

                Call    I_GetEnvelopeOffset
                        Assume DS:Nothing

                Add     SI, CX
                Add     SI, DX
                Add     SI, 7

                Mov     AX, [SI-3]
                Inc     AX
                Mov     [SI], AX

                Call    I_MapEnvelope
                NetworkSendInstrument

I_VolumeEnvelopeHeldHome1:
                Mov     AX, 1
                Ret

EndP            I_VolumeEnvelopeHeldHome
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_VolumeEnvelopeHeldRight Far

                        Assume DS:Inst

                Mov     CX, CurrentNode
                Mov     DX, CX
                Add     DX, DX
                JZ      I_VolumeEnvelopeHeldRight1

                Call    I_GetEnvelopeOffset
                        Assume DS:Nothing

                Add     SI, CX
                Add     SI, DX
                Add     SI, 7

                Mov     AX, [SI]
                Cmp     AX, MAXENVELOPETICK
                JAE     I_VolumeEnvelopeHeldRight1

                Inc     AX
                Inc     CX
                Cmp     CX, CS:MaxNode
                JE      I_VolumeEnvelopeHeldRight2

                Cmp     AX, [SI+3]                      ; Last node.
                JE      I_VolumeEnvelopeHeldRight1

I_VolumeEnvelopeHeldRight2:
                Mov     [SI], AX

                Call    I_MapEnvelope
                NetworkSendInstrument

I_VolumeEnvelopeHeldRight1:
                Mov     AX, 1
                Ret

EndP            I_VolumeEnvelopeHeldRight
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_VolumeEnvelopeHeldEnd Far

                        Assume DS:Inst

                Mov     CX, CurrentNode
                Mov     DX, CX
                Add     DX, DX
                JZ      I_VolumeEnvelopeHeldEnd1

                Call    I_GetEnvelopeOffset
                        Assume DS:Nothing

                Add     SI, CX
                Add     SI, DX
                Add     SI, 7


                Mov     AX, MAXENVELOPETICK
                Inc     CX
                Cmp     CX, CS:MaxNode
                JE      I_VolumeEnvelopeHeldEnd2

                Mov     AX, [SI+3]
                Dec     AX

I_VolumeEnvelopeHeldEnd2:
                Mov     [SI], AX

                Call    I_MapEnvelope
                NetworkSendInstrument

I_VolumeEnvelopeHeldEnd1:
                Mov     AX, 1
                Ret

EndP            I_VolumeEnvelopeHeldEnd
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_VolumeEnvelopeHeldRightFast Far

                        Assume DS:Inst

                Mov     CX, CurrentNode
                Mov     DX, CX
                Add     DX, DX
                JZ      I_VolumeEnvelopeHeldRightFast1

                Call    I_GetEnvelopeOffset
                        Assume DS:Nothing

                Add     SI, CX
                Add     SI, DX
                Add     SI, 7

                Mov     AX, [SI]

                Add     AX, 16
                Inc     CX
                Cmp     CX, CS:MaxNode
                JE      I_VolumeEnvelopeHeldRightFast3

                Cmp     AX, [SI+3]
                JB      I_VolumeEnvelopeHeldRightFast2

                Mov     AX, [SI+3]
                Dec     AX

I_VolumeEnvelopeHeldRightFast3:
                Cmp     AX, MAXENVELOPETICK
                JBE     I_VolumeEnvelopeHeldRightFast2

                Mov     AX, MAXENVELOPETICK

I_VolumeEnvelopeHeldRightFast2:
                Mov     [SI], AX

                Call    I_MapEnvelope
                NetworkSendInstrument

I_VolumeEnvelopeHeldRightFast1:
                Mov     AX, 1
                Ret

EndP            I_VolumeEnvelopeHeldRightFast
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_VolumeEnvelopeHeldPgDn Far

                        Assume DS:Inst

                Mov     CX, CurrentNode
                Mov     AH, AmplitudeCompensate

                Call    I_GetEnvelopeOffset
                        Assume DS:Nothing

                Add     SI, CX
                Add     SI, CX
                Add     SI, CX
                Add     SI, 6

                Mov     AL, [SI]
                Add     AL, AH
                Sub     AL, 8
                JNS     I_VolumeEnvelopeHeldPgDn1

                Xor     AL, AL

I_VolumeEnvelopeHeldPgDn1:
                Sub     AL, AH
                Mov     [SI], AL

                Call    I_MapEnvelope
                NetworkSendInstrument

                Mov     AX, 1
                Ret

EndP            I_VolumeEnvelopeHeldPgDn
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_VolumeEnvelopeHeldPgUp Far

                        Assume DS:Inst

                Mov     CX, CurrentNode
                Mov     AH, AmplitudeCompensate

                Call    I_GetEnvelopeOffset
                        Assume DS:Nothing

                Add     SI, CX
                Add     SI, CX
                Add     SI, CX
                Add     SI, 6

                Mov     AL, [SI]
                Add     AL, AH
                Add     AL, 8
                Cmp     AL, 64
                JBE     I_VolumeEnvelopeHeldPgUp1

                Mov     AL, 64

I_VolumeEnvelopeHeldPgUp1:
                Sub     AL, AH
                Mov     [SI], AL

                Call    I_MapEnvelope
                NetworkSendInstrument

                Mov     AX, 1
                Ret

EndP            I_VolumeEnvelopeHeldPgUp
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_VolumeEnvelopeInsert Far
                        Assume DS:Inst

                Mov     DX, CurrentNode

                Inc     DX
                Mov     CX, MaxNode
                Cmp     DX, CX
                JE      I_VolumeEnvelopeInsert1

                Mov     DI, CX
                Sub     CX, DX

                Cmp     DI, 25
                JE      I_VolumeEnvelopeInsert1

                Call    I_GetEnvelopeOffset     ; DS:SI
                        Assume DS:Nothing

                LEA     BX, [SI+6]
                Add     BX, DX
                Add     BX, DX
                Add     BX, DX
                Mov     AX, [BX+1]
                Sub     AX, [BX-2]
                Cmp     AX, 2
                JB      I_VolumeEnvelopeInsert1

                ClI

                Inc     Byte Ptr [SI+1]

                Mov     BX, DI
                Add     BX, BX
                Add     BX, DI
                LEA     BX, [BX+SI+6]

I_VolumeEnvelopeInsert2:
                Mov     AX, [BX-3]
                Mov     [BX], AX
                Mov     AL, [BX-1]
                Mov     [BX+2], AL

                Sub     BX, 3
                Loop    I_VolumeEnvelopeInsert2

                Mov     AX, [BX+4]
                Add     AX, [BX-2]
                ShR     AX, 1
                Mov     [BX+1], AX

                Mov     AH, CS:AmplitudeCompensate
                Mov     AL, [BX+3]
                Add     AL, [BX-3]
                Add     AL, AH
                Add     AL, AH
                ShR     AL, 1
                Sub     AL, AH
                Mov     [BX], AL

                Mov     CL, Byte Ptr CS:CurrentNode
                Cmp     CL, [SI+2]
                JAE     I_VolumeEnvelopeInsert4

                Inc     Byte Ptr [SI+2]

I_VolumeEnvelopeInsert4:
                Cmp     CL, [SI+3]
                JAE     I_VolumeEnvelopeInsert5

                Inc     Byte Ptr [SI+3]

I_VolumeEnvelopeInsert5:
                Cmp     CL, [SI+4]
                JAE     I_VolumeEnvelopeInsert6

                Inc     Byte Ptr [SI+4]

I_VolumeEnvelopeInsert6:
                Cmp     CL, [SI+5]
                JAE     I_VolumeEnvelopeInsert7

                Inc     Byte Ptr [SI+5]

I_VolumeEnvelopeInsert7:
                StI

                Call    I_MapEnvelope
                NetworkSendInstrument

I_VolumeEnvelopeInsert1:
                Mov     AX, 1
                Ret

EndP            I_VolumeEnvelopeInsert
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_VolumeEnvelopeDelete Far

                        Assume DS:Inst

                Mov     DX, CurrentNode
                Mov     DI, DX
                Add     DI, DI
                Add     DI, DX          ; DI = CurrentNode*3
                JZ      I_VolumeEnvelopeDelete1

                Mov     CX, MaxNode
                Cmp     CX, 2
                JBE     I_VolumeEnvelopeDelete1

                Call    I_GetEnvelopeOffset     ; Returns DS:SI
                        Assume DS:Nothing

                ClI

                Dec     Byte Ptr [SI+1]

                Mov     BX, SI
                LEA     SI, [BX+DI+6]

                Sub     CX, DX
                Dec     CX
                JZ      I_VolumeEnvelopeDelete11

I_VolumeEnvelopeDelete2:
                Mov     AL, [SI+3]
                Mov     [SI], AL
                Mov     AX, [SI+4]
                Mov     [SI+1], AX

                Add     SI, 3
                Loop    I_VolumeEnvelopeDelete2

I_VolumeEnvelopeDelete11:
                Xor     AX, AX                  ; Neatness.. clear ending
                Mov     [SI], AX
                Mov     [SI+2], AL
                                                        ; Ok.. check loop stuff
                Mov     DL, [BX+1]
                Dec     DX              ; DL = number of nodes
                Mov     DH, Byte Ptr CS:CurrentNode

                Cmp     DH, [BX+2]
                JAE     I_VolumeEnvelopeDelete7

                Dec     Byte Ptr [BX+2]

I_VolumeEnvelopeDelete7:
                Cmp     DH, [BX+3]
                JAE     I_VolumeEnvelopeDelete8

                Dec     Byte Ptr [BX+3]

I_VolumeEnvelopeDelete8:
                Cmp     DH, [BX+4]
                JAE     I_VolumeEnvelopeDelete9

                Dec     Byte Ptr [BX+4]

I_VolumeEnvelopeDelete9:
                Cmp     DH, [BX+5]
                JAE     I_VolumeEnvelopeDelete10

                Dec     Byte Ptr [BX+5]

I_VolumeEnvelopeDelete10:
                Cmp     DL, [BX+2]
                JAE     I_VolumeEnvelopeDelete3

                Mov     [BX+2], DL

I_VolumeEnvelopeDelete3:
                Cmp     DL, [BX+3]
                JAE     I_VolumeEnvelopeDelete4

                Mov     [BX+3h], DL

I_VolumeEnvelopeDelete4:
                Cmp     DL, [BX+4]
                JAE     I_VolumeEnvelopeDelete5

                Mov     [BX+4], DL

I_VolumeEnvelopeDelete5:
                Cmp     DL, [BX+5]
                JAE     I_VolumeEnvelopeDelete6

                Mov     [BX+5], DL

I_VolumeEnvelopeDelete6:
                StI
                Call    I_MapEnvelope

I_VolumeEnvelopeDelete1:
                NetworkSendInstrument

                Mov     AX, 1
                Ret

EndP            I_VolumeEnvelopeDelete

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_EnvelopeSelected

                Call    I_GetEnvelopeOffset     ; Returns DS:SI

IF FILTERENVELOPES
                Cmp     CS:InstrumentScreen, 3
                JNE     I_MouseEnvelopeNoFilter

                Test    Byte Ptr [SI], 1
                JNZ     I_MouseEnvelopeNoFilter

                Or      Byte Ptr [SI], 80h

I_MouseEnvelopeNoFilter:
ELSE
                And     Byte Ptr [SI], 7Fh      ; Turn of filters.

ENDIF

                Or      Byte Ptr [SI], 1        ; Turn on envelope
                Ret

EndP            I_EnvelopeSelected

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_VolumeEnvelopeEnter Far

                        Assume  DS:Inst

                Xor     NodeHeld, 1
                JZ      I_VolumeEnvelopeEnter1

                Call    I_EnvelopeSelected

I_VolumeEnvelopeEnter1:
                Mov     AX, 1
                Ret

EndP            I_VolumeEnvelopeEnter
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_InstrumentListSpace Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Cmp     NoteReleased, 1
                JNE     I_InstrumentSpace1

                Mov     NoteReleased, 0
                Mov     SI, Offset NoteData
                Call    PE_GetLastInstrument
                Mov     AH, BL
                Inc     AH
                Mov     AL, PlayNote
                Mov     [SI], AX
                Mov     AX, PlayChannel
                Mov     DH, 32+128
                Call    Music_PlayNote

I_InstrumentSpace1:
                Mov     AX, 1
                Ret

EndP            I_InstrumentListSpace
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_InstrumentListNoteOff Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Mov     NoteReleased, 1
                Mov     SI, Offset NoteData
                Mov     Word Ptr [SI], 255
                Mov     AX, PlayChannel
                Mov     DH, 32+128
                Call    Music_PlayNote

                Mov     AX, 1
                Ret

EndP            I_InstrumentListNoteOff
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_ShowSamplePlay Far
                                        ; Clear table first.

                Push    CS
                Pop     DS
                                        ; DS = Inst
                Mov     SI, Offset SamplePlayTable
                Mov     CX, 100

I_ShowSamplePlayClearTable:
                And     Byte Ptr [SI], Not 3
                Inc     SI
                Loop    I_ShowSamplePlayClearTable

                Call    Music_GetSlaveChannelInformationTable
                                ; DS:SI points to table.
                                ; CX = numchannels.
                Xor     BH, BH

I_ShowSamplePlay1:
                Mov     AX, [SI]
                Test    AL, 1                   ; Is channel on?
                JZ      I_ShowSamplePlay2

                Test    AH, 8                   ; Is it muted?
                JNZ     I_ShowSamplePlay2

                Mov     BL, [SI+36h]
                Cmp     BL, 100
                JAE     I_ShowSamplePlay2

                Or      [CS:SamplePlayTable+BX], 1    ; Show sample is on.

                Cmp     DWord Ptr [SI+2Ch], 0
                JNE     I_ShowSamplePlay2

                Or      [CS:SamplePlayTable+BX], 2

I_ShowSamplePlay2:
                Add     SI, SLAVECHANNELSIZE
                Loop    I_ShowSamplePlay1

                                                ; OK.. now to dump the stuff
                                                ;  onscreen

                Mov     BX, TopSample
                Dec     BX
                Mov     SI, Offset SamplePlayTable

                Jmp     I_ShowInstrumentPlay5

EndP            I_ShowSamplePlay

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_ShowInstrumentPlay Far
                                        ; Clear table first.

                Call    Music_GetInstrumentMode
                JZ      I_ShowInstrumentPlayEnd

                Push    CS
                Pop     DS
                                        ; DS = Inst
                Mov     SI, Offset InstrumentPlayTable
                Mov     CX, 100

I_ShowInstrumentPlayClearTable:
                And     Byte Ptr [SI], Not 3
                Inc     SI
                Loop    I_ShowInstrumentPlayClearTable

                Call    Music_GetSlaveChannelInformationTable
                                ; DS:SI points to table.
                                ; CX = numchannels.
                Xor     BH, BH

I_ShowInstrumentPlay1:
                Mov     AX, [SI]
                Test    AL, 1                   ; Is channel on?
                JZ      I_ShowInstrumentPlay2

                Test    AH, 8                   ; Is it muted?
                JNZ     I_ShowInstrumentPlay2

                Mov     BL, [SI+33h]
                Cmp     BL, 100
                JAE     I_ShowInstrumentPlay2

                Or      [CS:InstrumentPlayTable+BX], 1    ; Show sample is on.

                Cmp     DWord Ptr [SI+2Ch], 0
                JNE     I_ShowInstrumentPlay2

                Or      [CS:InstrumentPlayTable+BX], 2

I_ShowInstrumentPlay2:
                Add     SI, SLAVECHANNELSIZE
                Loop    I_ShowInstrumentPlay1

                                                ; OK.. now to dump the stuff
                                                ;  onscreen

                Mov     BX, TopInstrument
                Mov     SI, Offset InstrumentPlayTable

I_ShowInstrumentPlay5:
                Call    S_GetDestination

                Mov     CX, 35
                Mov     DI, (1+13*80)*2

I_ShowInstrumentPlay3:
                Mov     AX, 2100h

                Mov     DL, [CS:SI+BX]

                Cmp     DL, 0                   ; No dot.
                JE      I_ShowInstrumentPlay4

                Mov     AL, 173

                Cmp     DL, 4                   ; Dark small dot
                JE      I_ShowInstrumentPlay4

                Mov     AH, 23h

                Test    DL, 2                   ; Small bright dot
                JZ      I_ShowInstrumentPlay4

                Mov     AL, 183                 ; Large bright dot.

I_ShowInstrumentPlay4:
                StosW

                Add     DI, 158
                Inc     BX
                Loop    I_ShowInstrumentPlay3

I_ShowInstrumentPlayEnd:
                Ret


EndP            I_ShowInstrumentPlay

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_ClearTables Far

                Push    CS
                Pop     ES

                Mov     DI, Offset SamplePlayTable
                Mov     CX, 128

                Xor     AX, AX
                Rep     StosW

                Ret

EndP            I_ClearTables

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_TagInstrument Far

                Mov     Byte Ptr [CS:InstrumentPlayTable+BX], 4
                Ret

EndP            I_TagInstrument

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_TagSample Far

                Mov     Byte Ptr [CS:SamplePlayTable+BX], 4
                Ret

EndP            I_TagSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MIDI_PlaySample Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Test    DH, DH
                JNZ     MIDI_PlaySample1

                Jmp     MIDI_NoteOff2

MIDI_PlaySample1:
                Call    Music_GetNumChannels    ; Into AX
                Mov     DI, AX
                Mov     AX, PlayChannel
                Call    MIDI_AllocateChannel

                Call    PE_GetLastInstrument
                Mov     CX, AX
                Mov     AL, DL
                Mov     AH, BL
                Inc     AH
                Call    Music_PlaySample

MIDI_PlaySample2:
                Mov     AX, 1
                Ret

EndP            MIDI_PlaySample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_PlaySample Far

                Mov     AX, Pattern
                Mov     DS, AX
                        Assume DS:Pattern

                Mov     AH, LastInstrument
                Mov     AL, CS:LastPlaySample

                Mov     CX, CS:PlayChannel
                Call    Music_PlaySample

                Xor     AX, AX
                Ret

EndP            I_PlaySample
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_IncreasePlayChannel Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Mov     AX, PlayChannel
                Cmp     AX, 63
                JAE     I_IncreasePlayChannel1

                Inc     AX

I_IncreasePlayChannel1:
                Mov     PlayChannel, AX

                Inc     AX
                Mov     SI, Offset PlayChannelMsg

                Call    SetInfoLine

                Mov     AX, 1
                Ret

EndP            I_IncreasePlayChannel
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_DecreasePlayChannel Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Mov     AX, PlayChannel
                And     AX, AX
                JZ      I_DecreasePlayChannel1

                Dec     AX

I_DecreasePlayChannel1:
                Mov     PlayChannel, AX

                Inc     AX
                Mov     SI, Offset PlayChannelMsg

                Call    SetInfoLine

                Mov     AX, 1
                Ret

EndP            I_DecreasePlayChannel
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            UpdateMultiChannel

                Cmp     CS:MultiChannel, 0
                JE      UpdateMultiChannel1

                Push    AX
                Push    BX
                Push    DS
                Push    SI
                        Assume DS:Inst

                Push    CS
                Pop     DS

                Call    Music_GetNumChannels    ; Into AX
                Mov     BX, PlayChannel
                Inc     BX
                Cmp     BX, AX
                JB      UpdateMultiChannel2

                Xor     BX, BX

UpdateMultiChannel2:
                Mov     PlayChannel, BX
                Mov     AX, BX
                Inc     AX

                Mov     SI, Offset PlayChannelMsg
                Call    SetInfoLine

                Pop     SI
                Pop     DS
                Pop     BX
                Pop     AX

UpdateMultiChannel1:
                Ret

EndP            UpdateMultiChannel
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_ToggleMultiChannel Far

                Push    CS
                Pop     DS
                Assume DS:Inst

                Mov     SI, Offset MultiChannelEnabledMsg
                Xor     MultiChannel, 1
                JNZ     I_ToggleMultiChannel1

                Mov     SI, Offset MultiChannelDisabledMsg

I_ToggleMultiChannel1:
                Call    SetInfoLine

                Mov     AX, 1
                Ret

EndP            I_ToggleMultiChannel
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_DrawPitchPanCenter Far

                Call    S_GetDestination
                Call    I_GetInstrumentOffset   ; Returns DS:BX
                Mov     DI, (54+45*80)*2

                Mov     AL, [BX+17h]
                Mov     CL, 12
                Xor     AH, AH
                Xor     BH, BH

                Div     CL
                                                ; AL = octave, AH = note
                Mov     BL, AH
                Mov     DL, AL
                Add     BX, BX
                Add     DL, '0'

                Mov     AH, 2
                Mov     AL, [CS:NoteTable+BX]
                StosW
                Mov     AL, [CS:NoteTable+BX+1]
                StosW
                Mov     AL, DL
                StosW

                Ret

EndP            I_DrawPitchPanCenter

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_PrePitchPanCenter Far

                Call    S_GetDestination
                Mov     AL, 3h
                Mov     DI, (54+45*80)*2+1
                StosB
                Inc     DI
                StosB
                Inc     DI
                StosB

                Ret

EndP            I_PrePitchPanCenter

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_PostPitchPanCenter Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Mov     SI, Offset PitchPanCenterKeys
                Call    M_FunctionDivider
                JC      I_PostPitchPanCenter1

                Jmp     [SI]

I_PostPitchPanCenter1:
                Xor     AX, AX
                Ret

EndP            I_PostPitchPanCenter

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_PitchPanCenterUp Far

                Mov     Word Ptr [ES:DI], 27
                Mov     AX, 1
                Ret

EndP            I_PitchPanCenterUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_PitchPanCenterDown Far

                Mov     Word Ptr [ES:DI], 29
                Mov     AX, 1
                Ret

EndP            I_PitchPanCenterDown

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_PitchPanCenterSemiUp Far

                Call    I_GetInstrumentOffset
                Mov     AL, [BX+17h]

                Cmp     AL, 119
                JAE     I_PitchPanCenterSemiUp1

                Inc     AX
                Mov     [BX+17h], AL

I_PitchPanCenterSemiUp1:
                NetworkSendInstrument

                Mov     AX, 1
                Ret

EndP            I_PitchPanCenterSemiUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_PitchPanCenterSemiDown Far

                Call    I_GetInstrumentOffset
                Mov     AL, [BX+17h]

                Dec     AL
                JS      I_PitchPanCenterSemiDown1

                Mov     [BX+17h], AL

I_PitchPanCenterSemiDown1:
                NetworkSendInstrument

                Mov     AX, 1
                Ret

EndP            I_PitchPanCenterSemiDown

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_IdleUpdateEnvelope Far

                Push    CS
                Pop     DS
                        Assume DS:Inst

                Cmp     UpdateInstrumentScreen, 0
                JNE     I_IdleUpdateEnvelope2

                Mov     CL, Byte Ptr InstrumentScreen
                Add     CL, 11
                Mov     DL, 1
                ShL     DX, CL

                Call    PE_GetLastInstrument            ; Gets BX
                Inc     BX
                Call    Music_GetSlaveChannelInformationTable
                        Assume DS:Nothing

I_IdleUpdateEnvelope1:
                Cmp     Byte Ptr [SI+33h], BL
                JNE     I_IdleUpdateEnvelope4

                Test    Byte Ptr [SI], 1
                JZ      I_IdleUpdateEnvelope4

                Test    [SI], DX
                JZ      I_IdleUpdateEnvelope4

I_IdleUpdateEnvelope2:
                Call    I_MapEnvelope
                Jmp     I_IdleUpdateEnvelope3

I_IdleUpdateEnvelope4:
                Add     SI, SLAVECHANNELSIZE
                Loop    I_IdleUpdateEnvelope1

I_IdleUpdateEnvelope3:
                Xor     AX, AX
                Ret

EndP            I_IdleUpdateEnvelope

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            UpdateWAVEForm Far

                Call    I_RedrawWave
                Ret

EndP            UpdateWAVEForm

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_SampleButtonHandler Far

                Test    AX, AX
                JZ      I_SampleButtonHandler1

                NetworkSendSample

I_SampleButtonHandler1:
                Push    DS

                Call    I_GetSampleOffset
                Push    DS
                Pop     ES
                Mov     DI, BX
                Pop     DS

                Add     DI, [SI+24]

                Ret

EndP            I_SampleButtonHandler

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            I_GetPresetEnvelopeOffset Far

                Push    CS
                Pop     DS
                Mov     DX, Offset PresetEnvelopes

                Ret

EndP            I_GetPresetEnvelopeOffset

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

EndS

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

End
