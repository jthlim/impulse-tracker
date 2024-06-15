;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Music Module                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                        .386
                        .387

include switch.inc
include network.inc

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Externals                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

        Extrn   D_GotoStartingDirectory:Far
        Extrn   D_SetDriveDirectoryFar:Far
        Extrn   D_GetFileName:Far
        Extrn   D_Showtime:Far

        Extrn   E_EMSAvailable:Far
        Extrn   E_SaveEMSPageFrame:Far
        Extrn   E_RestoreEMSPageFrame:Far
        Extrn   E_UnInitEMS:Far
        Extrn   E_AllocateEMS:Far
        Extrn   E_MapEMSMemory:Far
        Extrn   E_GetEMSPageFrame:Far
        Extrn   E_ReleaseEMS:Far
        Extrn   E_AllocateBlockEMS:Far, E_ReleaseBlockEMS:Far
        Extrn   E_MapAlignedBlockEMS:Far
        Extrn   E_GetInternalEMSHandle:Far

        Extrn   I_TagInstrument:Far
        Extrn   I_TagSample:Far

        Extrn   O1_OutOfSoundCardMemoryList:Far

        Extrn   M_FunctionHandler:Far
        Extrn   M_Object1List:Far

        Extrn   Network_UpdatePatternIfIdle:Far

        Extrn   PE_GetCurrentPattern:Far
        Extrn   PE_FillHeader:Far
        Extrn   S_GetDestination:Far
        Extrn   S_UnInitScreen:Far
        Extrn   S_DirectDrawString:Far
        Extrn   S_DrawString:Far
        Extrn   S_SetDirectMode:Far
        Extrn   S_SaveScreen:Far
        Extrn   S_RestoreScreen:Far
        Extrn   S_DrawBox:Far
        Extrn   S_DrawString:Far
        Extrn   S_UpdateScreen:Far
        Extrn   S_DrawSmallBox:Far
        Extrn   F_DrawHeader:Far

        Extrn   K_GetKey:Far
        Extrn   StartClock:Far
        Extrn   SetInfoLine:Far, SetInfoLine2:Far
        Extrn   M_Object1List:Far

        Extrn   MaxRow

        Extrn   IdleUpdateInfoLine:Far
        Extrn   GlobalKeyList:Far
        Extrn   GetEnvironment:Far

        Extrn   MIDIBufferEmpty:Far, MIDISend:Far, MIDI_ClearTable:Far
        Extrn   O1_ShowTime

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Globals                                                                     ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

        Global  Music_GetDisplayVariables:Far
        Global  Music_AutoDetectSoundCard:Far

        Global  Music_Poll:Far

        Global  Music_ReinitSoundCard:Far
        Global  Music_InitMusic:Far
        Global  Music_UnInitMusic:Far
        Global  Music_GetSongSegment:Far
        Global  Music_GetInstrumentMode:Far
        Global  Music_ReleasePattern:Far
        Global  Music_GetPattern:Far
        Global  Music_GetPatternLocation:Far
        Global  Music_GetPatternLocationNoCount:Far
        Global  Music_AllocatePattern:Far
        Global  Music_AllocateSample:Far
        Global  Music_IncreaseSpeed:Far
        Global  Music_DecreaseSpeed:Far
        Global  Music_GetOutputWaveform:Far
        Global  Music_PlayPartSong:Far
        Global  Music_GetPatternLength:Far
        Global  Music_ShowAutodetectSoundcard:Far
        Global  Music_GetWaveForm:Far
        Global  Music_ToggleOrderUpdate:Far

        Global  Music_NextOrder:Far
        Global  Music_LastOrder:Far

        Global  Music_SetSoundCard:Far
        Global  Music_SetDMA:Far
        Global  Music_SetMixSpeed:Far
        Global  Music_SetIRQ:Far
        Global  Music_SetAddress:Far
        Global  Music_SetLimit:Far
        Global  Music_ReverseChannels:Far

        Global  Music_GetNumChannels:Far
        Global  Music_InitStereo:Far
        Global  Music_ReleaseSample:Far
        Global  Music_ReleaseAllSamples:Far
        Global  Music_ReleaseAllPatterns:Far
        Global  Music_ClearSampleName:Far
        Global  Music_ClearAllSampleNames:Far
        Global  Music_GetNumberOfSamples:Far
        Global  Music_GetNumberOfInstruments:Far
        Global  Music_ClearInstrument:Far
        Global  Music_ClearAllInstruments:Far
        Global  Music_GetHostChannelInformationTable:Far
        Global  Music_GetSlaveChannelInformationTable:Far
        Global  Music_SetGlobalVolume:Far

        Global  Music_InitMuteTable:Far
        Global  Music_UnmuteAll:Far

        Global  Music_GetPlayMode:Far
        Global  Music_GetPlayMode2:Far
        Global  Music_PlayPattern:Far
        Global  Music_PlaySample:Far
        Global  Music_PlayNote:Far
        Global  Music_Stop:Far
        Global  Music_PlaySong:Far
        Global  Music_ToggleChannel:Far
        Global  Music_SoloChannel:Far
        Global  Music_InitMixTable:Far
        Global  Music_GetSampleLocation:Far
        Global  Music_UpdatePatternOffset:Far
        Global  Music_AssignSampleToInstrument:Far
        Global  Music_KBPlaySong:Far
        Global  Music_IncreaseVolume:Far
        Global  Music_DecreaseVolume:Far
        Global  Music_SetSoundCardDriver:Far
        Global  Music_RegetLoopInformation:Far

        Global  Music_SoundCardLoadSample:Far
        Global  Music_SoundCardLoadAllSamples:Far
        Global  Music_GetFreeSoundCardMemory:Far
        Global  Music_GetPitchTable:Far
        Global  Music_GetMIDIDataArea:Far

        Global  Music_ToggleReverse:Far
        Global  Music_PatternStorage:Far

        Global  Music_GetDriverScreen:Far
        Global  Music_GetLastChannel:Far

        Global  SongDataArea:Word
        Global  MixDataArea:Word

        Global  Music_GetDriverVariable:Far, Music_SetDriverVariable:Far
        Public  Music_GetDelay
        Public  Music_SetNextOrder
        Public  Music_TimeSong
        Public  Music_ShowTime
        Public  Music_SaveMIDIConfig
        Public  MIDIDataArea

        Public  Music_ToggleSoloInstrument, Music_ToggleSoloSample

        Extrn   PE_GetLastInstrument:Far
        Public  CurrentPattern

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

;
; Functions for playing control
;  Music_PlaySong........ parameters, AX = order
;  Music_Stop............ parameters, None
;  Music_PlayPattern..... parameters, AX = pattern, BX = number of rows, CX = row
;  Music_ToggleChannel... parameters, AX = channel
;  Music_SoloChannel..... parameters, AX = channel
;

Segment         SongData PARA Public 'Data'
EndS

Segment                 Music DWORD Public 'Code' USE16
                        Assume CS:Music

CREATENEWLOGFILE        EQU     0
include debug.inc

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Variables                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

HOSTCHANNELSIZE         EQU     80
SLAVECHANNELSIZE        EQU     128
MAXSLAVECHANNELS        EQU     256
NONOTE                  EQU     0FDh

MIDICOMMAND_START               EQU     0
MIDICOMMAND_STOP                EQU     20h
MIDICOMMAND_TICK                EQU     40h
MIDICOMMAND_PLAYNOTE            EQU     60h
MIDICOMMAND_STOPNOTE            EQU     80h
MIDICOMMAND_CHANGEVOLUME        EQU     0A0h
MIDICOMMAND_CHANGEPAN           EQU     0C0h
MIDICOMMAND_BANKSELECT          EQU     0E0h
MIDICOMMAND_PROGRAMSELECT       EQU     100h
MIDICOMMAND_CHANGEPITCH         EQU     0FFFFh

FineSineData       Label   Byte
        DB       0,  2,  3,  5,  6,  8,  9, 11, 12, 14, 16, 17, 19, 20, 22, 23
        DB      24, 26, 27, 29, 30, 32, 33, 34, 36, 37, 38, 39, 41, 42, 43, 44
        DB      45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 56, 57, 58, 59
        DB      59, 60, 60, 61, 61, 62, 62, 62, 63, 63, 63, 64, 64, 64, 64, 64
        DB      64, 64, 64, 64, 64, 64, 63, 63, 63, 62, 62, 62, 61, 61, 60, 60
        DB      59, 59, 58, 57, 56, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46
        DB      45, 44, 43, 42, 41, 39, 38, 37, 36, 34, 33, 32, 30, 29, 27, 26
        DB      24, 23, 22, 20, 19, 17, 16, 14, 12, 11,  9,  8,  6,  5,  3,  2
        DB       0, -2, -3, -5, -6, -8, -9,-11,-12,-14,-16,-17,-19,-20,-22,-23
        DB     -24,-26,-27,-29,-30,-32,-33,-34,-36,-37,-38,-39,-41,-42,-43,-44
        DB     -45,-46,-47,-48,-49,-50,-51,-52,-53,-54,-55,-56,-56,-57,-58,-59
        DB     -59,-60,-60,-61,-61,-62,-62,-62,-63,-63,-63,-64,-64,-64,-64,-64
        DB     -64,-64,-64,-64,-64,-64,-63,-63,-63,-62,-62,-62,-61,-61,-60,-60
        DB     -59,-59,-58,-57,-56,-56,-55,-54,-53,-52,-51,-50,-49,-48,-47,-46
        DB     -45,-44,-43,-42,-41,-39,-38,-37,-36,-34,-33,-32,-30,-29,-27,-26
        DB     -24,-23,-22,-20,-19,-17,-16,-14,-12,-11, -9, -8, -6, -5, -3, -2

FineRampDownData   Label   Byte
        DB      64, 63, 63, 62, 62, 61, 61, 60, 60, 59, 59, 58, 58, 57, 57, 56
        DB      56, 55, 55, 54, 54, 53, 53, 52, 52, 51, 51, 50, 50, 49, 49, 48
        DB      48, 47, 47, 46, 46, 45, 45, 44, 44, 43, 43, 42, 42, 41, 41, 40
        DB      40, 39, 39, 38, 38, 37, 37, 36, 36, 35, 35, 34, 34, 33, 33, 32
        DB      32, 31, 31, 30, 30, 29, 29, 28, 28, 27, 27, 26, 26, 25, 25, 24
        DB      24, 23, 23, 22, 22, 21, 21, 20, 20, 19, 19, 18, 18, 17, 17, 16
        DB      16, 15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10,  9,  9,  8
        DB       8,  7,  7,  6,  6,  5,  5,  4,  4,  3,  3,  2,  2,  1,  1,  0
        DB       0, -1, -1, -2, -2, -3, -3, -4, -4, -5, -5, -6, -6, -7, -7, -8
        DB      -8, -9, -9,-10,-10,-11,-11,-12,-12,-13,-13,-14,-14,-15,-15,-16
        DB     -16,-17,-17,-18,-18,-19,-19,-20,-20,-21,-21,-22,-22,-23,-23,-24
        DB     -24,-25,-25,-26,-26,-27,-27,-28,-28,-29,-29,-30,-30,-31,-31,-32
        DB     -32,-33,-33,-34,-34,-35,-35,-36,-36,-37,-37,-38,-38,-39,-39,-40
        DB     -40,-41,-41,-42,-42,-43,-43,-44,-44,-45,-45,-46,-46,-47,-47,-48
        DB     -48,-49,-49,-50,-50,-51,-51,-52,-52,-53,-53,-54,-54,-55,-55,-56
        DB     -56,-57,-57,-58,-58,-59,-59,-60,-60,-61,-61,-62,-62,-63,-63,-64

FineSquareWave     Label   Byte
        DB      128 Dup (64), 128 Dup (0)

EmptyPattern            Label
        DW      64, 64, 0, 0
        DB      64 Dup (0)

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

                                        ; Zero globals.

LastSample      DW      0
PlayMode        DW      0               ; Playmode 0 = Freeplay
                                        ; Playmode 1 = Pattern
                                        ; Playmode 2 = Song
CurrentOrder    DW      0       ; } Must follow
CurrentPattern  DW      0       ; }
CurrentRow      DW      0       ; }
ProcessOrder    DW      0
ProcessRow      DW      0
BytesToMix      DW      0               ; = Bytes per frame
PatternOffset   DW      0
PatternSegment  DW      0
BreakRow        DW      0
RowDelay        DB      0       ; } Must join on.
RowDelayOn      DB      0       ; }
PatternArray    DB      0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ALIGN 4

PitchDepthConstant              DD      98304.0
HostChannelInformationTable     DB      64*HOSTCHANNELSIZE Dup(?)
SlaveChannelInformationTable    DB      MAXSLAVECHANNELS*SLAVECHANNELSIZE Dup(?)
MuteChannelTable                DB      64 Dup (?)
ChannelCountTable               DB      400 Dup (?)
;AllocateCount1                  DB      0
;AllocateCount2                  DB      0
;AllocateCount3                  DB      0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ALIGN 2

PatternDataSegment      DW      ?
CurrentEditPattern      DW      ?
PatternEditMaxRow       DW      ?

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

NumberOfRows            DW      64      ; Non zero globals
CurrentTick             DW      6
CurrentSpeed            DW      6
ProcessTick             DW      0
Tempo                   DB      125
GlobalVolume            DB      128
NumChannels             DW      256
SoloSample              DB      0FFh            ; * ORDER IS IMPORTANT
SoloInstrument          DB      0FFh            ; * ORDER IS IMPORTANT

AllocateNumChannels     DW      0
AllocateSlaveOffset     DW      0
LastSlaveChannel        DW      0

DecodeExpectedPattern   DW      0FFFEh
DecodeExpectedRow       DW      0FFFEh

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

CmdLineNumChannels      DW      0FFFFh

DriverRequiredVariables Label                   ; * ORDER IS IMPORTANT
BasePort                DW      0FFFFh          ; * ORDER IS IMPORTANT
IRQ                     DW      0FFFFh          ; * ORDER IS IMPORTANT
DMA                     DW      0FFFFh          ; * ORDER IS IMPORTANT
CmdLineMixSpeed         DW      0               ; * ORDER IS IMPORTANT
SongDataArea            DW      SongData        ; * ORDER IS IMPORTANT
MIDIDataArea            DW      SongData + 4076

CmdLineDMASize          DW      1024           ; default
ReverseChannels         DB      0

InstrumentHeader        Label   Byte
        DB      "IMPI"
        DB      19 Dup (0), 60, 128, 32+128, 34 Dup (0)
        DB      0, 0FFh, 0FFh, 0FFh
        DB      0, 0, 1, 0, 2, 0, 3, 0, 4, 0
        DB      5, 0, 6, 0, 7, 0, 8, 0, 9, 0
        DB      10, 0, 11, 0, 12, 0, 13, 0, 14, 0
        DB      15, 0, 16, 0, 17, 0, 18, 0, 19, 0
        DB      20, 0, 21, 0, 22, 0, 23, 0, 24, 0
        DB      25, 0, 26, 0, 27, 0, 28, 0, 29, 0
        DB      30, 0, 31, 0, 32, 0, 33, 0, 34, 0
        DB      35, 0, 36, 0, 37, 0, 38, 0, 39, 0
        DB      40, 0, 41, 0, 42, 0, 43, 0, 44, 0
        DB      45, 0, 46, 0, 47, 0, 48, 0, 49, 0
        DB      50, 0, 51, 0, 52, 0, 53, 0, 54, 0
        DB      55, 0, 56, 0, 57, 0, 58, 0, 59, 0
        DB      60, 0, 61, 0, 62, 0, 63, 0, 64, 0
        DB      65, 0, 66, 0, 67, 0, 68, 0, 69, 0
        DB      70, 0, 71, 0, 72, 0, 73, 0, 74, 0
        DB      75, 0, 76, 0, 77, 0, 78, 0, 79, 0
        DB      80, 0, 81, 0, 82, 0, 83, 0, 84, 0
        DB      85, 0, 86, 0, 87, 0, 88, 0, 89, 0
        DB      90, 0, 91, 0, 92, 0, 93, 0, 94, 0
        DB      95, 0, 96, 0, 97, 0, 98, 0, 99, 0
        DB      100, 0, 101, 0, 102, 0, 103, 0, 104, 0
        DB      105, 0, 106, 0, 107, 0, 108, 0, 109, 0
        DB      110, 0, 111, 0, 112, 0, 113, 0, 114, 0
        DB      115, 0, 116, 0, 117, 0, 118, 0, 119, 0
        DB      0, 2, 4 Dup (0), 64, 0, 0, 64, 100, 0, 70 Dup (0)
        DB      0, 2, 4 Dup (0), 0, 0, 0, 0, 100, 0, 70 Dup (0)
        DB      0, 2, 4 Dup (0), 0, 0, 0, 0, 100, 0, 70 Dup (0)
        DB      7 Dup (0)

SampleHeader            Label   Byte
        DB      "IMPS", 13 Dup (0), 64, 0, 64, 40 Dup (0)
        DW      8363
        DB      18 Dup (0)

MidiPitchSendString     DB      65h, 0, 64h, 0, 06

PatternLooping          DB      0
PatternStorage          DB      1               ; 0 = conventional only
                                                ; 1 = selective
                                                ; 2 = EMS only.

PrepareSamplesMsg       DB      "Preparing Samples", 0
ReverseMsg              DB      "Left/right outputs reversed", 0
NoSoundCardMsg          DB      "   No sound card detected", 0
MIDIConfigFileName      DB      "ITMIDI.CFG", 0

OrderUpdateEnabledMsg   DB      "Order list unlocked", 0
OrderUpdateDisabledMsg  DB      "Order list locked", 0
OrderLockFlag           DB      0

UnsoloMsg               DB      "Solo disabled", 0
SoloSampleMsg           DB      "Solo sample ", 0FDh, "D", 0
SoloInstrumentMsg       DB      "Solo instrument ", 0FDh, "D", 0

IFDEF DEBUG

LoadDriverMessage       DB      "Loading driver:", 0
UnableToReadFileMessage DB      "Unable to read file", 0
DetectingMessage        DB      "Testing driver", 0
ScreenOffset            DW      0

ENDIF

PCSpeakerDriver         DB      "ITPCSPKR.DRV", 0
SBDriver                DB      "ITSB.DRV", 0
SB2Driver               DB      "ITSB2.DRV", 0
SBProDriver             DB      "ITSBPRO.DRV", 0
SB16Driver              DB      "ITSB16.DRV", 0
AWE32Driver             DB      "ITAWE32.DRV", 0
GUSDriver               DB      "ITGUS.DRV", 0
InterwaveDriver         DB      "ITIW.DRV", 0
PASDriver               DB      "ITPAS.DRV", 0
PAS16Driver             DB      "ITPAS16.DRV", 0
WSSDriver               DB      "ITWSS.DRV", 0
ESSDriver               DB      "ITES1868.DRV", 0
MIDIDriver              DB      "ITMPU401.DRV", 0
EWSCodecDriver          DB      "ITEWSCOD.DRV", 0
VIVOCodecDriver         DB      "ITVIVO.DRV", 0
ST97PCICodecDriver      DB      "ITSTCODE.DRV", 0
WAVDriver               DB      "ITWAV.DRV", 0
MIDDriver               DB      "ITMID.DRV", 0
VSoundMMXDriver         DB      "ITVSOUND.MMX", 0
VSoundDriver            DB      "ITVSOUND.DRV", 0
DefaultDriver           DB      "ITSOUND.DRV", 0

DriverNameTable   Label
        DW      0FFFFh
        DW      Offset PAS16Driver, SB16Driver
        DW      Offset InterwaveDriver, Offset GUSDriver
        DW      Offset AWE32Driver, Offset SBProDriver
        DW      Offset SBDriver, Offset PCSpeakerDriver
        DW      Offset SB2Driver, Offset PASDriver
        DW      Offset WAVDriver, Offset WSSDriver
        DW      Offset ESSDriver, MIDIDriver
        DW      Offset EWSCodecDriver, VIVOCodecDriver
        DW      Offset ST97PCICodecDriver, Offset MIDDRIVER
        DW      Offset DefaultDriver, Offset VSoundMMXDriver
        DW      Offset VSoundDriver

DriverName              DD      0

DriverDetectionOrder    DW      19, 20, 21, 17, 16, 15, 13, 1, 10, 2, 12, 3, 4, 5, 6, 9, 7, 8, 0FFFFh
DriverSoundCard         DW      0, 8, 7, 9, 6
                        DW      2, 5, 4, 3, 10
                        DW      1, 12, 13, 15, 16
                        DW      0, 0, 0, 0, 14
                        DW      11, 18

ALIGN 4

PitchTable              Label   DWord
   DW      2048, 0,   2170, 0,   2299, 0,   2435, 0,   2580, 0,   2734, 0
   DW      2896, 0,   3069, 0,   3251, 0,   3444, 0,   3649, 0,   3866, 0

   DW      4096, 0,   4340, 0,   4598, 0,   4871, 0,   5161, 0,   5468, 0
   DW      5793, 0,   6137, 0,   6502, 0,   6889, 0,   7298, 0,   7732, 0

   DW      8192, 0,   8679, 0,   9195, 0,   9742, 0,   10321, 0,  10935, 0
   DW      11585, 0,  12274, 0,  13004, 0,  13777, 0,  14596, 0,  15464, 0

   DW      16384, 0,  17358, 0,  18390, 0,  19484, 0,  20643, 0,  21870, 0
   DW      23170, 0,  24548, 0,  26008, 0,  27554, 0,  29193, 0,  30929, 0

   DW      32768, 0,  34716, 0,  36781, 0,  38968, 0,  41285, 0,  43740, 0
   DW      46341, 0,  49097, 0,  52016, 0,  55109, 0,  58386, 0,  61858, 0

   DW      0, 1,      3897, 1,   8026, 1,   12400, 1,  17034, 1,  21944, 1
   DW      27146, 1,  32657, 1,  38496, 1,  44682, 1,  51236, 1,  58179, 1

   DW      0, 2,      7794, 2,   16051, 2,  24800, 2,  34068, 2,  43888, 2
   DW      54292, 2,  65314, 2,  11456, 3,  23828, 3,  36936, 3,  50823, 3

   DW      0, 4,      15588, 4,  32103, 4,  49600, 4,  2601, 5,   22240, 5
   DW      43048, 5,  65092, 5,  22912, 6,  47656, 6,  8336, 7,   36110, 7

   DW      0, 8,      31176, 8,  64205, 8,  33663, 9,  5201, 10,  44481, 10
   DW      20559, 11, 64648, 11, 45823, 12, 29776, 13, 16671, 14, 6684, 15

   DW      0, 16,     62352, 16, 62875, 17, 1790,  19, 10403, 20, 23425, 21
   DW      41118, 22, 63761, 23, 26111, 25, 59552, 26, 33342, 28, 13368, 30

; Pitch extention for loading some XIs

   DW      0, 32,     59167, 33, 60214, 35, 3580, 38,  20806, 40, 46850, 42
   DW      16701, 45, 61986, 47, 52221, 50, 53567, 53, 1148, 57,  26736, 60

IF USEFPUCODE

FPSave          DB      128 Dup (0)

Const_14317456  DD      14317456.0
Const1_On_768   DD      3AAAAAABh
SlideValue      DW      0
NewControlWord  DW      7Fh

ELSE

FineLinearSlideUpTable  Label
        DW      0, 1,     59, 1,    118, 1,   178, 1,   237, 1    ; 0->4
        DW      296, 1,   356, 1,   415, 1,   475, 1,   535, 1    ; 5->9
        DW      594, 1,   654, 1,   714, 1,   773, 1,   833, 1    ; 10->14
        DW      893, 1                                            ; 15

LinearSlideUpTable      Label ; Value = 2^(Val/192)
        DW      0,     1, 237,   1, 475,   1, 714,   1, 953,  1  ; 0->4
        DW      1194,  1, 1435,  1, 1677,  1, 1920,  1, 2164, 1  ; 5->9
        DW      2409,  1, 2655,  1, 2902,  1, 3149,  1, 3397, 1  ; 10->14
        DW      3647,  1, 3897,  1, 4148,  1, 4400,  1, 4653, 1  ; 15->19
        DW      4907,  1, 5157,  1, 5417,  1, 5674,  1, 5932, 1  ; 20->24
        DW      6190,  1, 6449,  1, 6710,  1, 6971,  1, 7233, 1  ; 25->29
        DW      7496,  1, 7761,  1, 8026,  1, 8292,  1, 8559, 1  ; 30->34
        DW      8027,  1, 9096,  1, 9366,  1, 9636,  1, 9908, 1  ; 35->39
        DW      10181, 1, 10455, 1, 10730, 1, 11006, 1, 11283,1  ; 40->44
        DW      11560, 1, 11839, 1, 12119, 1, 12400, 1, 12682,1  ; 45->49
        DW      12965, 1, 13249, 1, 13533, 1, 13819, 1, 14106,1  ; 50->54
        DW      14394, 1, 14684, 1, 14974, 1, 15265, 1, 15557,1  ; 55->59
        DW      15850, 1, 16145, 1, 16440, 1, 16737, 1, 17034,1  ; 60->64
        DW      17333, 1, 17633, 1, 17933, 1, 18235, 1, 18538,1  ; 65->69
        DW      18842, 1, 19147, 1, 19454, 1, 19761, 1, 20070,1  ; 70->74
        DW      20379, 1, 20690, 1, 21002, 1, 21315, 1, 21629,1  ; 75->79
        DW      21944, 1, 22260, 1, 22578, 1, 22897, 1, 23216,1  ; 80->84
        DW      23537, 1, 23860, 1, 24183, 1, 24507, 1, 24833,1  ; 85->89
        DW      25160, 1, 25488, 1, 25817, 1, 26148, 1, 26479,1  ; 90->94
        DW      26812, 1, 27146, 1, 27481, 1, 27818, 1, 28155,1  ; 95->99
        DW      28494, 1, 28834, 1, 29175, 1, 29518, 1, 29862,1  ; 100->104
        DW      30207, 1, 30553, 1, 30900, 1, 31248, 1, 31599,1  ; 105->109
        DW      31951, 1, 32303, 1, 32657, 1, 33012, 1, 33369,1  ; 110->114
        DW      33726, 1, 34085, 1, 34446, 1, 34807, 1, 35170,1  ; 115->119
        DW      35534, 1, 35900, 1, 36267, 1, 36635, 1, 37004,1  ; 120->124
        DW      37375, 1, 37747, 1, 38121, 1, 38496, 1, 38872,1  ; 125->129
        DW      39250, 1, 39629, 1, 40009, 1, 40391, 1, 40774,1  ; 130->134
        DW      41158, 1, 41544, 1, 41932, 1, 42320, 1, 42710,1  ; 135->139
        DW      43102, 1, 43495, 1, 43889, 1, 44285, 1, 44682,1  ; 140->144
        DW      45081, 1, 45481, 1, 45882, 1, 46285, 1, 46690,1  ; 145->149
        DW      47095, 1, 47503, 1, 47917, 1, 48322, 1, 48734,1  ; 150->154
        DW      49147, 1, 49562, 1, 49978, 1, 50396, 1, 50815,1  ; 155->159
        DW      51236, 1, 51658, 1, 52082, 1, 52507, 1, 52934,1  ; 160->164
        DW      53363, 1, 53793, 1, 54224, 1, 54658, 1, 55092,1  ; 165->169
        DW      55529, 1, 55966, 1, 56406, 1, 56847, 1, 57289,1  ; 170->174
        DW      57734, 1, 58179, 1, 58627, 1, 59076, 1, 59527,1  ; 175->179
        DW      59979, 1, 60433, 1, 60889, 1, 61346, 1, 61805,1  ; 180->184
        DW      62265, 1, 62727, 1, 63191, 1, 63657, 1, 64124,1  ; 185->189
        DW      64593, 1, 65064, 1, 0,     2, 474,   2, 950,  2  ; 190->194
        DW      1427,  2, 1906,  2, 2387,  2, 2870,  2, 3355, 2  ; 195->199
        DW      3841,  2, 4327,  2, 4818,  2, 5310,  2, 5803, 2  ; 200->204
        DW      6298,  2, 6795,  2, 7294,  2, 7794,  2, 8296, 2  ; 205->209
        DW      8800,  2, 9306,  2, 9814,  2, 10323, 2, 10835,2  ; 210->214
        DW      11348, 2, 11863, 2, 12380, 2, 12899, 2, 13419,2  ; 215->219
        DW      13942, 2, 14467, 2, 14993, 2, 15521, 2, 16051,2  ; 220->224
        DW      16583, 2, 17117, 2, 17653, 2, 18191, 2, 18731,2  ; 225->229
        DW      19273, 2, 19817, 2, 20362, 2, 20910, 2, 21460,2  ; 230->234
        DW      22011, 2, 22565, 2, 23121, 2, 23678, 2, 24238,2  ; 235->239
        DW      24800, 2, 25363, 2, 25929, 2, 25497, 2, 27067,2  ; 240->244
        DW      27639, 2, 28213, 2, 28789, 2, 29367, 2, 29947,2  ; 245->249
        DW      30530, 2, 31114, 2, 31701, 2, 32289, 2, 32880, 2 ; 250->254
        DW      33473, 2, 34068, 2                               ; 255->256

FineLinearSlideDownTable Label
        DW      65535, 65477, 65418, 65359, 65300, 65241, 65182, 65359 ; 0->7
        DW      65065, 65006, 64947, 64888, 64830, 64772, 64713, 64645 ; 8->15

LinearSlideDownTable    Label
        DW      65535, 65300, 65065, 64830, 64596, 64364, 64132, 63901 ; 0->7
        DW      63670, 63441, 63212, 62984, 62757, 62531, 62306, 62081 ; 8->15
        DW      61858, 61635, 61413, 61191, 60971, 60751, 60532, 60314 ; 16->23
        DW      60097, 59880, 59664, 59449, 59235, 59022, 58809, 58597 ; 24->31
        DW      58386, 58176, 57966, 57757, 57549, 57341, 57135, 56929 ; 32->39
        DW      56724, 56519, 56316, 56113, 55911, 55709, 55508, 55308 ; 40->47
        DW      55109, 54910, 54713, 54515, 54319, 54123, 53928, 53734 ; 48->55
        DW      53540, 53347, 53155, 52963, 52773, 52582, 52393, 52204 ; 56->63
        DW      52016, 51829, 51642, 51456, 51270, 51085, 50901, 50718 ; 64->71
        DW      50535, 50353, 50172, 49991, 49811, 49631, 49452, 49274 ; 72->79
        DW      49097, 48920, 48743, 48568, 48393, 48128, 48044, 47871 ; 80->87
        DW      47699, 47527, 47356, 47185, 47015, 46846, 46677, 46509 ; 88->95
        DW      46341, 46174, 46008, 45842, 45677, 45512, 45348, 45185 ; 96->103
        DW      45022, 44859, 44698, 44537, 44376, 44216, 44057, 43898 ;104->111
        DW      43740, 43582, 43425, 43269, 43113, 42958, 42803, 42649 ;112->119
        DW      42495, 42342, 42189, 42037, 41886, 41735, 41584, 41434 ;120->127
        DW      41285, 41136, 40988, 40840, 40639, 40566, 40400, 40253 ;128->135
        DW      40110, 39965, 39821, 39678, 39535, 39392, 39250, 39109 ;136->143
        DW      38968, 38828, 38688, 38548, 38409, 38271, 38133, 37996 ;144->151
        DW      37859, 37722, 37586, 37451, 37316, 37181, 37047, 36914 ;152->159
        DW      36781, 36648, 36516, 36385, 36254, 36123, 35993, 35863 ;160->167
        DW      35734, 35605, 35477, 35349, 35221, 35095, 34968, 34842 ;168->175
        DW      34716, 34591, 34467, 34343, 34219, 34095, 33973, 33850 ;176->183
        DW      33728, 33607, 33486, 33365, 33245, 33125, 33005, 32887 ;184->191
        DW      32768, 32650, 32532, 32415, 32298, 32182, 32066, 31950 ;192->199
        DW      31835, 31720, 31606, 31492, 31379, 31266, 31153, 31041 ;200->207
        DW      30929, 30817, 30706, 30596, 30485, 30376, 30226, 30157 ;208->215
        DW      30048, 29940, 29832, 29725, 29618, 29511, 29405, 29299 ;216->223
        DW      29193, 29088, 28983, 28879, 28774, 28671, 28567, 28464 ;224->231
        DW      28362, 28260, 28158, 28056, 27955, 27855, 27754, 27654 ;232->239
        DW      27554, 27455, 27356, 27258, 27159, 27062, 26964, 26867 ;240->247
        DW      26770, 26674, 26577, 26482, 26386, 26291, 26196, 26102 ;248->255
        DW      26008                                                  ; 256

ENDIF ; USEFPUCODE

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

InitCommandTable        Label   Word
        DW      Offset InitNoCommand, Offset InitCommandA
        DW      Offset InitCommandB, Offset InitCommandC
        DW      Offset InitCommandD, Offset InitCommandE
        DW      Offset InitCommandF, Offset InitCommandG
        DW      Offset InitCommandH, Offset InitCommandI
        DW      Offset InitCommandJ, Offset InitCommandK
        DW      Offset InitCommandL, Offset InitCommandM
        DW      Offset InitCommandN, Offset InitCommandO
        DW      Offset InitCommandP, Offset InitCommandQ
        DW      Offset InitCommandR, Offset InitCommandS
        DW      Offset InitCommandT, Offset InitCommandU
        DW      Offset InitCommandV, Offset InitCommandW
        DW      Offset InitCommandX, Offset InitCommandY
        DW      Offset InitCommandZ, Offset InitNoCommand
        DW      Offset InitNoCommand, Offset InitNoCommand
        DW      Offset InitNoCommand, Offset InitNoCommand

CommandTable            Label   Word
        DW      Offset NoCommand, Offset NoCommand
        DW      Offset NoCommand, Offset NoCommand
        DW      Offset CommandD, Offset CommandE
        DW      Offset CommandF, Offset CommandG
        DW      Offset CommandH, Offset CommandI
        DW      Offset CommandJ, Offset CommandK
        DW      Offset CommandL, Offset NoCommand
        DW      Offset CommandN, Offset NoCommand
        DW      Offset CommandP, Offset CommandQ
        DW      Offset CommandR, Offset CommandS
        DW      Offset CommandT, Offset CommandH
        DW      Offset NoCommand, Offset CommandW
        DW      Offset NoCommand, Offset CommandY
        DW      Offset NoCommand, Offset NoCommand
        DW      Offset NoCommand, Offset NoCommand

VolumeEffectTable       Label   Word
        DW      Offset NoCommand, Offset NoCommand      ; Last 2 of command
                                                        ; table + VolumeComA
                                                        ; and VolumeComB
        DW      Offset VolumeCommandC, Offset VolumeCommandD
        DW      Offset VolumeCommandE, Offset VolumeCommandF
        DW      Offset VolumeCommandG, Offset CommandH


RetrigOffsets           Label
        DW      CommandQ_0, CommandQ_1, CommandQ_2, CommandQ_3
        DW      CommandQ_4, CommandQ_5, CommandQ_6, CommandQ_7
        DW      CommandQ_8, CommandQ_9, CommandQ_A, CommandQ_B
        DW      CommandQ_C, CommandQ_D, CommandQ_E, CommandQ_F

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Sound Driver Data                                                           ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF OLDDRIVER
 DriverID                DB      "Impulse Tracker Sound Driver"
ELSE
 DriverID                DB      "Impulse Tracker Advanced Sound Driver"
ENDIF

ALIGN 2
SoundDriverSegment      DW      0

;*******************

DriverVariableTable     Label
DriverMaxChannels       DW      32
StopEndOfPlaySection    DW      0
DefaultChannels         DW      32
DriverFlags             DW      0       ; Bit 1 = MIDI Out supported
                                        ; Bit 2 = Hiqual
                                        ; Bit 3 = Output waveform data available

IF OLDDRIVER
                        DB      64 - ($ - DriverVariableTable) Dup (0)
ELSE
                        DB      16 - ($ - DriverVariableTable) Dup (0)
ENDIF


ALIGN 4

StartDriverFunctions    Label
DriverDetectCard        DD      0
DriverInitSound         DD      0
DriverReinitSound       DD      0
DriverUninitSound       DD      0

DriverPoll              DD      0

DriverSetTempo          DD      0
DriverSetMixVolume      DD      0
DriverSetStereo         DD      0

DriverLoadSample        DD      0
DriverReleaseSample     DD      0
DriverResetMemory       DD      0
DriverGetStatus         DD      0

DriverSoundCardScreen   DD      0
DriverGetVariable       DD      0
DriverSetVariable       DD      0

DriverMIDIOut           DD      0
DriverGetWaveform       DD      0

EndDriverFunctions      Label

IF OLDDRIVER
        DD      63-(EndDriverFunctions-StartDriverFunctions)/4 Dup (0)
ELSE
        DD      31-(EndDriverFunctions-StartDriverFunctions)/4 Dup (0)
ENDIF
        DW      0

DriverLength    DW      0

DriverRequiredFunctions Label
        DD      DWord Ptr Update
        DD      DWord Ptr Music_GetSampleHeader
        DD      DWord Ptr Music_GetSampleLocation
        DD      DWord Ptr Music_FarUpdateSampleLocation
        DD      DWord Ptr E_GetEMSPageFrame
        DD      DWord Ptr E_SaveEMSPageFrame
        DD      DWord Ptr E_RestoreEMSPageFrame
        DD      DWord Ptr Music_GetTempo
        DD      DWord Ptr M_FunctionHandler
        DD      DWord Ptr SetInfoLine2
        DD      DWord Ptr Music_SoundCardLoadAllSamples
        DD      DWord Ptr GlobalKeyList
        DD      DWord Ptr IdleUpdateInfoLine
        DD      DWord Ptr F_DrawHeader
        DD      DWord Ptr PE_FillHeader
        DD      DWord Ptr D_GotoStartingDirectory
        DD      DWord Ptr D_GetFileName
        DD      DWord Ptr D_SetDriveDirectoryFar
        DD      DWord Ptr Music_Stop
        DD      DWord Ptr GetEnvironment
        DD      DWord Ptr Music_GetSlaveChannelInformationTable
        DD      DWord Ptr RecalculateAllVolumes
        DD      DWord Ptr MIDIBufferEmpty
        DD      DWord Ptr MIDISend
        DD      DWord Ptr S_GetDestination
        DD      DWord Ptr S_DrawString

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Functions                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Command/Effect (call it what you like) information here!!                   ³
;³                                                                             ³
;³  For initialisation, DS:DI points to host channel data.                     ³
;³    Registers for use: All except DS:DI & ES (points to SongDataSegment)     ³
;³                                                                             ³
;³  For update, DS:DI points to host channel data.                             ³
;³    Registers for use: AX, BX, DX, ES, SI                                    ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Proc            RecalculateAllVolumes Far

                Mov     CX, NumChannels
                Mov     SI, Offset SlaveChannelInformationTable

RecalculateAllVolumes1:
                Or      Byte Ptr [SI], 18

                Add     SI, SLAVECHANNELSIZE
                Dec     CX
                JNZ     RecalculateAllVolumes1

                Ret

EndP            RecalculateAllVolumes

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitPlayInstrument              ; BX = instrument offset

                Push    ECX

                Mov     [SI+30h], BX            ; InsOffset

                Mov     AL, [ES:BX+11h]         ; NNA
                Mov     [SI+3Bh], AL

                Mov     AX, [ES:BX+12h]         ; DCT and DCA
                Mov     [SI+28h], AX

                Mov     AX, [DI+0Ch]            ; MCh and MPr
                Test    AL, AL
                JZ      InitPlayInstrumentNoMIDI

                Mov     [SI+3Ch], AX
                Mov     AX, [ES:BX+3Eh]         ; MidiBank
                Mov     [SI+3Eh], AX
                Mov     AL, [DI+3]
                Mov     [SI+0Bh], AL

InitPlayInstrumentNoMIDI:
                Mov     DX, [DI+2Eh]            ; ChannelVol=DH, Pan=DL

                Mov     AL, [ES:BX+19h]         ; Instrument pan
                Mov     [SI+23h], DH

                Test    AL, 80h
                JNZ     AllocatePan1

                Mov     DL, AL

AllocatePan1:
                Push    BX                      ; Check for sample pan

                Mov     BL, [DI+0Fh]
                And     BX, 0FFh
                JZ      InitPlayInstrumentNoSamplePan

                Add     BX, BX
                Mov     BX, [ES:64910+BX]       ; BX = sample offset
                Mov     AL, [ES:BX+2Fh]
                Test    AL, AL

                JNS     InitPlayInstrumentNoSamplePan

                And     AL, 7Fh
                Mov     DL, AL

InitPlayInstrumentNoSamplePan:
                Pop     BX

                Cmp     DL, 100
                JE      AllocatePanSurround

                Xor     DH, DH
                Mov     AL, [DI+3]              ; Note
                Mov     CX, [ES:BX+16h]         ; Pitch pan separation
                Sub     AL, CH
                IMul    CL

                SAR     AX, 3

                Add     AX, DX
                JS      AllocatePan2
                Cmp     AX, 64
                JBE     AllocatePan3

                Mov     AL, 64
                Jmp     AllocatePan3

AllocatePan2:
                Xor     AL, AL
                Jmp     AllocatePan3

AllocatePanSurround:
                Mov     AL, 100

AllocatePan3:
                Mov     AH, AL
                Xor     ECX, ECX                ; Envelope init
                Mov     [SI+2Ah], AX            ; Write panning

                Mov     [SI+58h], ECX
                Mov     [SI+5Ch], CX
                Mov     [SI+60h], ECX
                Mov     [SI+68h], ECX
                Mov     [SI+6Ch], CX
                Mov     [SI+70h], ECX
                Mov     [SI+78h], ECX
                Mov     [SI+7Ch], CX
                Mov     DWord Ptr [SI+50h], 400000h     ; 64*65536

                Mov     AH, [ES:BX+1D4h]
                Mov     AL, [ES:BX+182h]
                And     AX, 101h
                ShL     AH, 1
                Or      AH, AL
                Mov     AL, [ES:BX+130h]
                ShL     AH, 1
                And     AL, 1
                Or      AH, AL
                ShL     AH, 4
                Or      AX, 133h

                Mov     Word Ptr [SI], AX

                Push    DI

                Mov     DI, LastSlaveChannel
                Test    DI, DI
                JZ      InitInstrumentCarry

InitInstrumentVolumeCarry:
                Mov     AL, [ES:BX+130h]
                And     AL, 9
                Cmp     AL, 9
                JNE     InitInstrumentPanCarry

; Transfer volume data
                Mov     ECX, [DI+50h]
                Mov     EDX, [DI+54h]
                Mov     [SI+50h], ECX
                Mov     [SI+54h], EDX
                Mov     ECX, [DI+58h]
                Mov     DX, [DI+5Ch]
                Mov     [SI+58h], ECX
                Mov     [SI+5Ch], DX

InitInstrumentPanCarry:
                Mov     AL, [ES:BX+182h]
                And     AL, 9
                Cmp     AL, 9
                JNE     InitInstrumentPitchCarry
; Transfer pan data
                Mov     ECX, [DI+60h]
                Mov     EDX, [DI+64h]
                Mov     [SI+60h], ECX
                Mov     [SI+64h], EDX
                Mov     ECX, [DI+68h]
                Mov     DX, [DI+6Ch]
                Mov     [SI+68h], ECX
                Mov     [SI+6Ch], DX


InitInstrumentPitchCarry:
                Mov     AL, [ES:BX+1D4h]
                And     AL, 9
                Cmp     AL, 9
                JNE     InitInstrumentCarry
; Transfer pitch data
                Mov     ECX, [DI+70h]
                Mov     EDX, [DI+74h]
                Mov     [SI+70h], ECX
                Mov     [SI+74h], EDX
                Mov     ECX, [DI+78h]
                Mov     DX, [DI+7Ch]
                Mov     [SI+78h], ECX
                Mov     [SI+7Ch], DX

InitInstrumentCarry:
                Pop     DI

                Or      Byte Ptr [DI], 80h      ; Apply random volume/pan

                Cmp     Byte Ptr [DI+0Ch], 0
                JNE     InitPlayInstrumentNoSample

                Push    BX
                Mov     BX, [ES:BX+3Ah] ; Initial filter cutoff
; If IFC bit 7 == 1, then set filter cutoff

                Mov     Word Ptr [SI+3Eh], 0FFh

;                Test    BL, 8080h
;                JNZ     InitPlayInstrumentFilter
;
;; No filters, reset devices.
;                Mov     BL, 7Fh
;                Call    SetFilterCutoff
;                Xor     BL, BL
;                Call    SetFilterResonance
;
;                Jmp     InitPlayInstrumentFilterResonance
;
;InitPlayInstrumentFilter:
                Test    BL, BL
                JNS     InitPlayInstrumentFilterCutoff

                And     BL, 7Fh
;                Mov     [SI+3Eh], BL
                Call    SetFilterCutoff

InitPlayInstrumentFilterCutoff:
; If IFR bit 7 == 1, then set filter resonance
                Test    BX, BX
                JNS     InitPlayInstrumentFilterResonance

                Mov     BL, BH
                And     BL, 7Fh
                Mov     [SI+3Fh], BL
                Call    SetFilterResonance

InitPlayInstrumentFilterResonance:
                Pop     BX

InitPlayInstrumentNoSample:
                Pop     ECX

                Ret

EndP            InitPlayInstrument

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ApplyRandomValues

                Mov     SI, [DI+24h]
                Mov     BX, [SI+30h]

                And     Byte Ptr [DI], Not 80h

                Call    Random          ; AL = -128->+127

                Mov     AH, [ES:BX+1Ah] ; Random volume, 0->100
                Test    AH, AH
                JZ      RandomVolumeEnd

                IMul    AH              ; AX = -12800->12700
                SAR     AX, 6           ; AX = -200->+198(.4)
                Inc     AX              ; AX = -199->+199

                MovZX   DX, Byte Ptr [SI+24h] ; Sample volume set
                Mov     CX, 199
                Push    DX
                IMul    DX              ; AX = -199*128->199*128
                                        ; AX = -25472->25472

                IDiv    CX              ; AX = -128->+128
                Pop     CX
                Add     AX, CX

                Cmp     AX, 0
                JL      RandomVolume3
                Cmp     AX, 128
                JG      RandomVolume4

                Mov     [SI+24h], AL
                Jmp     RandomVolumeEnd

RandomVolume3:
                Mov     Byte Ptr [SI+24h], 0
                Jmp     RandomVolumeEnd

RandomVolume4:
                Mov     Byte Ptr [SI+24h], 128

RandomVolumeEnd:
                Call    Random          ; AL = -128->+127

                Mov     AH, [ES:BX+1Bh] ; Random pan, 0->64
                Test    AH, AH
                JZ      RandomPanEnd

                Xor     DX, DX
                IMul    AH              ; AX = -64*128->64*127, -8192->8128
                Mov     DL, [SI+2Ah]
                SAR     AX, 7
                Cmp     DL, 100
                JE      RandomPanEnd
                Add     DX, AX
                JS      RandomPan1
                Cmp     DX, 64
                JA      RandomPan2

                Mov     DH, DL
                Mov     [SI+2Ah], DX
                Ret

RandomPan2:
                Mov     Word Ptr [SI+2Ah], 4040h
                Ret

RandomPan1:
                Mov     Word Ptr [SI+2Ah], 0

RandomPanEnd:
                Ret

EndP            ApplyRandomValues

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

LastMIDIByte    DB      0FFh

Proc            MIDISendFilter

                Test    CS:DriverFlags, 1
                JZ      MIDISendFilter2

                Test    AL, AL
                JNS     MIDISendFilter1
                Cmp     AL, 0F0h
                JAE     MIDISendFilter1

                Cmp     AL, CS:LastMIDIByte
                JE      MIDISendFilter2

                Mov     CS:LastMIDIByte, AL

MIDISendFilter1:
                Call    DriverMIDIOut

MIDISendFilter2:
                Ret

EndP            MIDISendFilter
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetFilterCutoff ; Given BL = filtervalue.
                                ; Assumes that channel is non-disowned

                Push    DI

                Mov     DI, [SI+38h]

                Mov     AL, 0F0h
                Call    MIDISendFilter
                Mov     AL, 0F0h
                Call    MIDISendFilter
                Xor     AL, AL
                Call    MIDISendFilter
                Mov     AL, BL
                Call    MIDISendFilter

                Pop     DI
                Ret

EndP            SetFilterCutoff

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetFilterResonance      ; Given BL = filtervalue.
                                        ; Assumes that channel is non-disowned

                Push    DI

                Mov     DI, [SI+38h]

                Mov     AL, 0F0h
                Call    MIDISendFilter
                Mov     AL, 0F0h
                Call    MIDISendFilter
                Mov     AL, 1
                Call    MIDISendFilter
                Mov     AL, BL
                Call    MIDISendFilter

                Pop     DI
                Ret

EndP            SetFilterResonance

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

MIDIPitchDepthSent      DW      0

Proc            MIDITranslate         ; Assumes DS:SI points to slave
                                      ; And DS:DI points to host.
                                      ; BX = offset of MIDI command to interpret

                Assume DS:Music

                Test    DriverFlags, 1
                JZ      MIDITranslateEnd

                PushA

                Cmp     BX, 0F000h
                JB      MIDITranslateParameterised

; Internal MIDI commands.

                Test    Byte Ptr [ES:2Ch], 64   ; Do pitch wheel?
                JZ      MIDITranslateInternalEnd

; Pitch wheel
; Formula is: Depth = 16384*12 / PitchWheelDepth * log2(Freq / OldFreq)
; Do calculation, check whether pitch needs to be sent.

                Xor     EAX, EAX
                Mov     AL, [ES:35h]    ; AL = PWD

                Test    AL, AL          ; No depth!
                JZ      MIDITranslateInternalEnd

                Mov     DWord Ptr [ChannelCountTable+200], EAX ; scratch area

IFE USEFPUCODE  ; If FPU code is being used, FP registers are already saved
                FNSave  [ChannelCountTable]     ; Scratch area
                FNInit
ENDIF
                FLd     [PitchDepthConstant]
                FIDiv   DWord Ptr [ChannelCountTable+200]
                FILd    DWord Ptr [SI+10h]      ; Current pitch
                FIDiv   DWord Ptr [SI+1Ch]      ; Original pitch
                FYL2X
                FIStP   DWord Ptr [ChannelCountTable+200]
IFE USEFPUCODE
                FRstor  [ChannelCountTable]
ENDIF

; OK.. [ChannelCountTable] contains pitch depth.
; Have to check:
;  a) Within ranges?
;  b) Comparison to old pitch for this channel

                Mov     CL, [SI+3Ch]
                Mov     AX, 1
                Dec     CL
                JS      MIDITranslateInternalEnd

                Cmp     DWord Ptr [ChannelCountTable+200], 0
                JE      MIDIPitchDepthSent1

                ShL     AX, CL
                Test    MIDIPitchDepthSent, AX
                JNZ     MIDIPitchDepthSent1

                Or      MIDIPitchDepthSent, AX

; Send MIDI Pitch depth stuff

                Push    SI

                Mov     AL, 0B0h
                Or      AL, CL
                Call    MIDISendFilter

                Mov     DX, 5
                Mov     SI, Offset MIDIPitchSendString

Music_SendPitchDepth1:
                LodsB
                Call    MIDISendFilter
                Dec     DX
                JNZ     Music_SendPitchDepth1

                Pop     SI

                Mov     AL, [ES:35h]
                Call    MIDISendFilter

MIDIPitchDepthSent1:
                Mov     EAX, DWord Ptr [ChannelCountTable+200]
                Add     EAX, 2000h
                JNS     PitchRange1

                Xor     EAX, EAX

PitchRange1:
                Cmp     EAX, 4000h
                JL      PitchRange2

                Mov     AX, 3FFFh

PitchRange2:
                Mov     BL, [SI+3Ch]            ; BL = channel
                And     BX, 0FFh
                Add     BX, BX
                Cmp     [MIDIPitch+BX-2], AX
                JE      MIDITranslateInternalEnd

                Mov     [MIDIPitch+BX-2], AX

; Output pitch change

                Mov     AL, 0E0h
                Or      AL, CL

                Call    MIDISendFilter  ; Ec command

                Mov     AL, Byte Ptr [MIDIPitch+BX-2]
                And     AL, 7Fh
                Call    MIDISendFilter

                Mov     AX, [MIDIPitch+BX-2]
                ShR     AX, 7
                And     AL, 7Fh
                Call    MIDISendFilter

MIDITranslateInternalEnd:
                PopA
                Ret

; Now for user input MIDI stuff.

MIDITranslateParameterised:
                Push    FS

                Xor     AX, AX
                Xor     CX, CX
                Mov     FS, MIDIDataArea

MIDITranslate1:
                Mov     AH, [FS:BX]
                Inc     BX
                Test    AH, AH
                JZ      MIDITranslate2

                Cmp     AH, ' '                 ; Interpretation time.
                JNE     MIDITranslateNoSpace

                Test    CX, CX
                JZ      MIDITranslate1
                Jmp     MIDITranslateSend

MIDITranslateNoSpace:
                Sub     AH, '0'
                JC      MIDITranslate1
                Cmp     AH, 9
                JA      MIDITranslateValue1

                ShL     AL, 4
                Or      AL, AH
                Inc     CX
                Jmp     MIDITranslateValueEnd

MIDITranslateValue1:
                Sub     AH, 'A'-'0'
                JC      MIDITranslate1
                Cmp     AH, 'F'-'A'
                JA      MIDITranslateValue2

                ShL     AL, 4
                Add     AH, 10
                Or      AL, AH
                Inc     CX
                Jmp     MIDITranslateValueEnd

MIDITranslateValue2:
                Sub     AH, 'a'-'A'
                JC      MIDITranslate1
                Cmp     AH, 'z'-'a'
                JA      MIDITranslate1

                Cmp     AH, 'c'-'a'
                JNE     MIDITranslateValue3

                Test    SI, SI
                JZ      MIDITranslate1

;                Mov     AH, [DI+0Ch]
                Mov     AH, [SI+3Ch]
                ShL     AL, 4
                Dec     AH
                Or      AL, AH
                Inc     CX
                Jmp     MIDITranslateValueEnd

MIDITranslateValue3:
                Test    CX, CX
                JZ      MIDITranslateValue4

                Call    MIDISendFilter

                Xor     CX, CX

MIDITranslateValue4:
                Mov     AL, [DI+7]      ; Effect.
                Cmp     AH, 'z'-'a'     ; Zxx?
                JE      MIDITranslateSend

                Mov     AL, [DI+12h]
                Cmp     AH, 'o'-'a'
                JE      MIDITranslateSend

                Test    SI, SI
                JZ      MIDITranslate1

                Mov     AL, [SI+32h]    ; [DI+0Eh]
                Cmp     AH, 'n'-'a'     ; Note?
                JE      MIDITranslateSend

                Mov     AL, [SI+0Bh]
                Cmp     AH, 'm'-'a'
                JE      MIDITranslateSend

                Cmp     AH, 'v'-'a'     ; Velocity?
                JNE     MIDITranslateValue7

                Xor     AL, AL
                Test    Word Ptr [SI], 800h
                JNZ     MIDITranslateSend

                Mov     AL, [SI+22h]            ; 0->2^6
                Xor     DX, DX
                Mul     GlobalVolume            ; 0->2^13
                Mov     DL, [SI+23h]            ; Channel volume
                Mul     DX                      ; 0->2^19
                SHRD    AX, DX, 4               ; 0->2^15
                Mov     DL, [SI+24h]            ; Sample & Instrument Volume
                Mul     DX                      ; 0->2^22
                SHRD    AX, DX, 15              ; 0->2^7
                Sub     AL, 1
                AdC     AL, 1                   ; 1->2^7
                JNS     MIDITranslateSend
                Dec     AX
;                Mov     AL, 7Fh
                Jmp     MIDITranslateSend

Comment ~
                Mov     AL, [SI+22h]    ; 0->64
                Add     AL, AL          ; 0->128
                Sub     AL, 1
                AdC     AL, 1           ; 1->128
                Cmp     AL, 128
                JB      MIDITranslateSend
                Dec     AX
                Jmp     MIDITranslateSend
~

MIDITranslateValue7:
                Cmp     AH, 'u'-'a'     ; Volume?
                JNE     MIDITranslateValue8

                Xor     AL, AL
                Test    Word Ptr [SI], 800h
                JNZ     MIDITranslateSend

                Mov     AL, [SI+20h]    ; 0->128
                Sub     AL, 1
                AdC     AL, 1           ; 1->128
                Cmp     AL, 128
                JB      MIDITranslateSend
                Dec     AX
                Jmp     MIDITranslateSend

MIDITranslateValue8:
                Mov     AL, [SI+3Ah]    ; HCN
                And     AL, 7Fh
                Cmp     AH, 'h'-'a'
                JE      MIDITranslateSend

                Mov     AL, [SI+2Ah]    ; Pan set
                Cmp     AH, 'x'-'a'
                JE      MIDITranslatePanValue

                Mov     AL, [SI+25h]    ; Final pan
                Cmp     AH, 'y'-'a'
                JE      MIDITranslatePanValue

                Mov     AL, [SI+3Dh]
                Cmp     AH, 'p'-'a'     ; Program?
                JE      MIDITranslateSend

                Mov     DX, [SI+3Eh]
                Mov     AL, DL
                Add     AL, 1
                AdC     AX, 0
                Dec     AX
                Cmp     AH, 'b'-'a'
                JE      MIDITranslateSend

                Mov     AL, DH
                Add     AL, 1
                AdC     AX, 0
                Dec     AX
                Cmp     AH, 'a'-'a'
                JE      MIDITranslateSend

                Xor     AX, AX
                Jmp     MIDITranslate1

MIDITranslatePanValue:
                Add     AL, AL
                Cmp     AL, 7Fh
                JBE     MIDITranslateSend
                Dec     AX
                Cmp     AL, 7Fh
                JBE     MIDITranslateSend
                Mov     AL, 40h
                Jmp     MIDITranslateSend

MIDITranslateValueEnd:
                Cmp     CL, 2
                JB      MIDITranslate1

MIDITranslateSend:
                Call    MIDISendFilter

                Xor     AX, AX
                Xor     CX, CX
                Jmp     MIDITranslate1

MIDITranslate2:
                Test    CX, CX
                JZ      MIDITranslate3

                Call    MIDISendFilter

MIDITranslate3:
                Pop     FS
                PopA

MIDITranslateEnd:
                Ret

EndP            MIDITranslate
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            AllocateChannel         ; Returns SI. Carry set if problems
                Assume DS:Music

                Push    CX
                Mov     LastSlaveChannel, 0

                Test    Byte Ptr [ES:2Ch], 4
                JNZ     AllocateChannel1

AllocateChannel15:                      ; Sample handler
                MovZX   SI, Byte Ptr [DI+20h]
                Mov     AX, SI
                ShL     SI, 7                   ; SLAVECHANNELSIZE
                Add     SI, Offset SlaveChannelInformationTable

                Test    Byte Ptr CS:DriverFlags, 2
                JZ      AllocateChannelHiQual1
                Test    Byte Ptr [SI], 1        ; Channel on?
                JZ      AllocateChannelHiQual1

; copy out channel
                Push    CX
                Push    SI
                Push    DI
                Push    ES

                Push    DS
                Pop     ES

                Or      Word Ptr [SI], 200h
                Or      Byte Ptr [SI+3Ah], 80h

                LEA     DI, [SI+64*SLAVECHANNELSIZE]
                Mov     CX, SLAVECHANNELSIZE/4
                Rep     MovsD

                Pop     ES
                Pop     DI
                Pop     SI
                Pop     CX

AllocateChannelHiQual1:
                Mov     [DI+24h], SI
                Mov     [SI+38h], DI
                Mov     [SI+3Ah], AL
                Mov     Word Ptr [SI], 133h ; Recalc freq,vol&pan Channel on.

                Mov     AX, [DI+2Eh]        ; ChannelVol=AH, Pan=AL
                Mov     [SI+23h], AH
                Mov     AH, AL
                Mov     [SI+2Ah], AX
                                                ; Get sample offset.
AllocateChannel3:                               ; General stuff.
                Pop     CX

                Mov     Word Ptr [SI+26h], 0400h  ; FadeOut
                Mov     Word Ptr [SI+52h], 64
                Mov     Word Ptr [SI+3Eh], 0FFh  ; Filter cutoff

                Mov     AX, [DI+3]
                Mov     [SI+32h], AX            ; Nte&Ins

                Mov     BL, [DI+0Fh]
                And     BX, 0FFh
                JZ      AllocateChannel21
                Dec     BX

                Call    I_TagSample

                Mov     [SI+36h], BL

                Add     BX, BX
                Mov     BX, [ES:64912+BX]
                Mov     [SI+34h], BX            ; Sample memory offset.

                Xor     EAX, EAX
                Mov     [SI+18h], EAX           ; Reset vibrato info.
                Mov     Word Ptr [SI+62h], AX   ; No pan deviation
                Mov     Word Ptr [SI+72h], AX   ; No pitch deviation
                Mov     Byte Ptr [SI+0Bh], AL   ; Reset loop dirn

                Cmp     [ES:BX+30h], EAX        ; No sample!
                JE      AllocateChannel21

                Mov     AX, [ES:BX+11h]
                Test    AH, 1
                JZ      AllocateChannel21       ; No sample!

                And     AH, 2
                Add     AL, AL
                Mov     [SI+18h], AH
                Mov     [SI+24h], AL            ; Sample volume

                ClC
                Ret

AllocateChannel21:
                Mov     Word Ptr [SI], 200h
                And     CH, Not 4
                StC
                Ret

AllocateChannel5:
                Pop     CX
                StC
                Ret

AllocateChannel1:                               ; Instrument handler!
                Mov     DX, NumChannels

                Mov     AllocateSlaveOffset, Offset SlaveChannelInformationTable
                Mov     AllocateNumChannels, DX

                Mov     BX, MAXSLAVECHANNELS
                Cmp     Byte Ptr [DI+0Fh], 101
                JNE     AllocateChannelNoMIDI
                Cmp     DX, BX
                JE      AllocateChannelNoMIDI

                Sub     BX, DX                  ; CX = number of channels remaining
                ShL     DX, 7
                Mov     AllocateNumChannels, BX
                Add     DX, Offset SlaveChannelInformationTable
                Mov     AllocateSlaveOffset, DX

AllocateChannelNoMIDI:
                Mov     BL, [DI+4]

                Cmp     BL, 0FFh
                JE      AllocateChannel15

                And     EBX, 0FFh
                JZ      AllocateChannel5

                Call    I_TagInstrument

                Mov     BX, [ES:64710+EBX*2]    ; ES:BX points to instrument

                Test    CH, 4                   ; Test Byte Ptr [DI], 4
                JZ      AllocateChannel8
                                                ; New note action handling...
                Mov     SI, [DI+24h]

                Cmp     [SI+30h], BX
                JNE     AllocateLastChannelDifferentInstrument

                Mov     LastSlaveChannel, SI

AllocateLastChannelDifferentInstrument:
                Mov     AL, [SI+3Bh]

                Test    AL, AL
                JZ      AllocateChannel20       ; Notecut.

                Or      Byte Ptr [SI+3Ah], 80h  ; Disown channel

AllocateHandleNNA:
                Cmp     Byte Ptr [SI+22h], 0    ; Is volume set = 0?
                JE      AllocateChannel20
                Cmp     Byte Ptr [SI+23h], 0    ; Is channel volume = 0?
                JE      AllocateChannel20
                Cmp     Byte Ptr [SI+24h], 0    ; Is sample volume = 0?
                JE      AllocateChannel20

                Cmp     AL, 2
                JB      AllocateChannel8        ; Note continue
                JE      AllocateChannel14       ; Note off.

                                                ; AL = 3 -> Fade
                Or      Byte Ptr [SI], 8        ; Fade flag.
                Jmp     AllocateChannel8

AllocateChannel14:
                Or      Byte Ptr [SI], 4        ; Note off..

                Push    BX
                Call    GetLoopInformation
                Pop     BX

                Jmp     AllocateChannel8

AllocateChannel20MIDI:
                Or      Word Ptr [SI], 200h
                Or      Byte Ptr [SI+3Ah], 80h  ; Disown channel

                Cmp     Byte Ptr [DI+0Fh], 101
                JNE     AllocateChannel4        ; Sample..

AllocateChannelMIDIDC:
                Mov     SI, AllocateSlaveOffset
                Mov     CX, AllocateNumChannels

                Mov     DL, [DI+0Eh]
                Mov     DH, [DI+4]
                Mov     BP, 32h
                Mov     AH, [DI+0Ch]
                Mov     CH, [ES:BX+13h]         ; CH = DCA
                Jmp     AllocateChannel6

AllocateChannel20:
                Cmp     Byte Ptr [SI+36h], 100  ; MIDI?
                JE      AllocateChannel20MIDI

AllocateChannel20Samples:
                Test    Byte Ptr CS:DriverFlags, 2
                JNZ     AllocateChannelHiQual

                Mov     AL, [ES:BX+12h]
                Mov     Word Ptr [SI], 200h
                Test    AL, AL
                JZ      AllocateChannelInstrument
                Jmp     AllocateChannel11

AllocateChannelHiQual:
                Or      Word Ptr [SI], 200h
                Or      Byte Ptr [SI+3Ah], 80h  ; Disown channel
                Jmp     AllocateChannel4

AllocateChannel8:
                Cmp     Byte Ptr [DI+0Fh], 101
                JE      AllocateChannelMIDIDC

                Mov     AL, [ES:BX+12h]
                Test    AL, AL
                JZ      AllocateChannel4        ; Duplicate check off.

AllocateChannel11:                              ; Duplicate check...
                Mov     SI, AllocateSlaveOffset
                Mov     CX, AllocateNumChannels

                Mov     DX, [DI+3]              ; DX = note
                Mov     BP, 32h
                Cmp     AL, 1
                JE      AllocateDCT

                Mov     BP, 33h                 ; Duplicate instrument
                Mov     DL, DH
                Cmp     AL, 3
                JE      AllocateDCT

                Mov     BP, 36h                 ; Duplicate sample
                Mov     DL, [DI+0Fh]
                Dec     DL
                JS      AllocateChannel4

AllocateDCT:
                Mov     AH, [DI+20h]            ; AH = HCN
                Or      AH, 80h
                Mov     CH, [ES:BX+13h]         ; CH = DCA

AllocateChannel6:
                Test    Byte Ptr [SI], 1
                JZ      AllocateChannel7

                Cmp     Byte Ptr [DI+0Fh], 101
                JE      AllocateChannelMIDIDCT

                Mov     AL, [SI+3Ah]            ; AL = HCN of slave.
                Cmp     AH, AL
                JNE     AllocateChannel7
                                                ; OK. same channel... now..

AllocateChannelMIDIDCT:
                Cmp     DH, [SI+33h]            ; Same inst?
                JNE     AllocateChannel7

                Cmp     DL, [DS:SI+BP]          ; Same note/sample/inst?
                JNE     AllocateChannel7

                Cmp     Byte Ptr [DI+0Fh], 101  ; New note is a MIDI?
                JE      AllocateChannelMIDIHandling

                Cmp     CH, [SI+29h]
                JNE     AllocateChannel7

                Test    CH, CH                  ; Checks for hiqual
                JZ      AllocateChannel20Samples

                Mov     Word Ptr [SI+28h], 0
                Mov     AL, CH
                Inc     AX
                Jmp     AllocateHandleNNA

AllocateChannelMIDIHandling:
                Cmp     Byte Ptr [SI+36h], 100  ; Is current channel a MIDI chan
                JNE     AllocateChannel7

                Cmp     AH, [SI+3Ch]
                JNE     AllocateChannel7

                Or      Word Ptr [SI], 200h
                Test    Byte Ptr [SI+3Ah], 80h
                JNZ     AllocateChannel7

                Mov     BP, [SI+38h]
                Or      Byte Ptr [SI+3Ah], 80h
                And     Byte Ptr [DS:BP], Not 4

AllocateChannel7:
                Add     SI, SLAVECHANNELSIZE
                Dec     CL
                JNZ     AllocateChannel6

AllocateChannel4:
                Mov     CX, AllocateNumChannels
                Mov     SI, AllocateSlaveOffset

                Cmp     Byte Ptr [DI+0Fh], 101
                JNE     AllocateChannel10

; MIDI 'slave channels' have to be maintained if still referenced

                Push    DI

AllocateMIDIChannel1:
                Test    Byte Ptr [SI], 1
                JNZ     AllocateMIDIChannel2

                ; Have a channel.. check that it's host's slave isn't SI
                Mov     DI, [SI+38h]
                Test    DI, DI
                JZ      AllocateMIDIChannelFound
                Cmp     SI, [DI+24h]
                JNE     AllocateMIDIChannelFound

AllocateMIDIChannel2:
                Add     SI, SLAVECHANNELSIZE
                Dec     CX
                JNZ     AllocateMIDIChannel1

                Pop     DI

                Jmp     AllocateChannel17

AllocateChannel10:
                Test    Byte Ptr [SI], 1
                JZ      AllocateChannelInstrument

                Add     SI, SLAVECHANNELSIZE
                Dec     CX
                JNZ     AllocateChannel10

AllocateChannel17:                      ; Common sample search
                Push    BX
                Push    DI
                Push    ES

                Push    CS
                Pop     ES

                Mov     DI, Offset ChannelCountTable
                Xor     AX, AX
                Mov     CX, (100+200)/2
                Rep     StosW           ; Clear table
                Dec     AX
                Mov     CX, 100/2        ; Volumes
                Rep     StosW

                Pop     ES

                Mov     CX, AllocateNumChannels
                Xor     EBX, EBX
                Mov     DI, AllocateSlaveOffset

AllocateChannelCommonSample1:
                Mov     BL, [DI+36h]            ; BX = sample pointer into
                                                ; table.
                Cmp     BL, 99                  ; Just for safety
                JA      AllocateChannelCommonSample2

                Inc     Byte Ptr [ChannelCountTable+BX]

                Mov     AH, [ChannelCountTable+BX+300]     ; Volume

                Test    Byte Ptr [DI+3Ah], 80h  ; Disowned channel?
                JZ      AllocateChannelCommonSample2

                Cmp     AH, [DI+20h]            ; Lower Volume?
                JBE     AllocateChannelCommonSample2

                Mov     AH, [DI+20h]            ; Get volume
                Mov     Word Ptr [ChannelCountTable+EBX+EBX+100], DI ; Store location
                Mov     [ChannelCountTable+BX+300], AH      ; Store volume

AllocateChannelCommonSample2:
                Add     DI, SLAVECHANNELSIZE
                Dec     CX
                JNZ     AllocateChannelCommonSample1

                                ; OK.. now search table for maximum
                                ; occurrence of sample...

                Xor     EDI, EDI
                Xor     SI, SI
                Mov     AH, 2           ; Find maximum count, has to be
                                        ; greater than 2 channels
                Mov     CX, 100

AllocateChannelCommonSample3:
                Cmp     AH, [ChannelCountTable+DI]
                JAE     AllocateChannelCommonSample4

                Mov     AH, [ChannelCountTable+DI]
                Mov     SI, Word Ptr [ChannelCountTable+EDI+EDI+100]

AllocateChannelCommonSample4:
                Inc     DI
                Dec     CX
                JNZ     AllocateChannelCommonSample3

                Pop     DI
                Pop     BX

;                Inc     AllocateCount1

                Test    SI, SI
                JNZ     AllocateChannelInstrument

;                Dec     AllocateCount1

                                ; Find out which host channel has the most
                                ; (disowned) slave channels
                                ; Then find the softest non-single sample
                                ; in that channel.
                Push    BX

                Push    ES
                Push    DI

                Push    CS
                Pop     ES
                Mov     DI, Offset ChannelCountTable
                Xor     AX, AX
                Mov     CX, 32
                Rep     StosW

                Pop     DI
                Pop     ES

                Xor     BX, BX
                Mov     CX, AllocateNumChannels
                Mov     SI, AllocateSlaveOffset

AllocateChannelCount1:
                Mov     BL, [SI+3Ah]            ; Host channel number
                And     BL, 3Fh
                Inc     Byte Ptr [ChannelCountTable+BX]

AllocateChannelCount2:
                Add     SI, SLAVECHANNELSIZE
                Dec     CX
                JNZ     AllocateChannelCount1

AllocateChannelCountEnd:
                                                ; OK.. search through and find
                                                ; the most heavily used channel

                Mov     AX, 100h                ; AH = channel count
                Xor     BX, BX                  ; AL = channel
                Mov     CX, 64                  ; 64 = physical channels

AllocateChannelCountSearch1:
                Cmp     AH, [BX+ChannelCountTable]
                JAE     AllocateChannelCountSearch2

                Mov     AH, [BX+ChannelCountTable]
                Mov     AL, BL

AllocateChannelCountSearch2:
                Inc     BX
                Dec     CX
                JNZ     AllocateChannelCountSearch1

                Pop     BX

                                        ; AH = channel to use.
                Cmp     AH, 1
                JBE     AllocateChannelSoftestSearch

                Or      AL, 80h                 ; Search for disowned only

                Push    BX
                Push    DI

                Mov     BH, [DI+0Fh]
                Dec     BH

                Mov     CX, AllocateNumChannels
                Mov     DI, AllocateSlaveOffset
                Xor     SI, SI                  ; Offset
                Mov     AH, 0FFh

AllocateChannelNonSingle1:
                Cmp     AL, [DI+3Ah]
                JNE     AllocateChannelNonSingle3

                Cmp     AH, [DI+20h]            ; Lower Volume?
                JBE     AllocateChannelNonSingle3

                                                ; Now check if any other
                                                ; channel contains this
                                                ; sample
                Cmp     BH, [DI+36h]
                JE      AllocateChannelNonSingle6

                Push    CX
                Push    SI

                Mov     BL, [DI+36h]            ; Sample number
                Mov     Byte Ptr [DI+36h], 0FFh

                Mov     SI, AllocateSlaveOffset
                Mov     CX, AllocateNumChannels

AllocateChannelNonSingle2:
                Cmp     BH, [SI+36h]
                JE      AllocateChannelNonSingle5

                Cmp     BL, [SI+36h]            ; A second sample?
                JE      AllocateChannelNonSingle5

AllocateChannelNonSingle4:
                Add     SI, SLAVECHANNELSIZE
                Dec     CX
                JNZ     AllocateChannelNonSingle2

                Mov     [DI+36h], BL

                Pop     SI
                Pop     CX
                Jmp     AllocateChannelNonSingle3

AllocateChannelNonSingle5:
                Mov     [DI+36h], BL

                Pop     SI
                Pop     CX

AllocateChannelNonSingle6:                      ; OK found a second sample.
                Mov     SI, DI                  ; get offset.
                Mov     AH, [DI+20h]            ; Get volume

AllocateChannelNonSingle3:
                Add     DI, SLAVECHANNELSIZE
                Dec     CX
                JNZ     AllocateChannelNonSingle1

                Pop     DI
                Pop     BX

                Test    SI, SI
                JNZ     AllocateChannelSampleSearch
;                JNZ     AllocateChannelInstrument

                Push    BX
                Mov     SI, AX
                And     SI, 03Fh
                Mov     Byte Ptr [ChannelCountTable+SI], 0
                Jmp     AllocateChannelCountEnd ; Next cycle...

AllocateChannelSampleSearch:
;                Inc     AllocateCount2

                Push    DI

                Mov     AL, [SI+36h]

                Mov     CX, AllocateNumChannels
                Mov     DI, AllocateSlaveOffset
                Mov     AH, 0FFh

AllocateChannelSampleSearch1:
                Cmp     AL, [DI+36h]            ; Same sample?
                JNE     AllocateChannelSampleSearch2

                Test    Byte Ptr [DI+3Ah], 80h  ; Disowned channel?
                JZ      AllocateChannelSampleSearch2

                Cmp     AH, [DI+20h]            ; Lower Volume?
                JBE     AllocateChannelSampleSearch2

                Mov     SI, DI                  ; get offset.
                Mov     AH, [DI+20h]            ; Get volume

AllocateChannelSampleSearch2:
                Add     DI, SLAVECHANNELSIZE
                Dec     CX
                JNZ     AllocateChannelSampleSearch1

                Pop     DI

                Jmp     AllocateChannelInstrument

AllocateChannelSoftestSearch:
                Push    DI                      ; Now search for softest
                                                ; disowned sample
                                                ; (not non-single)

                Mov     CX, AllocateNumChannels
                Mov     DI, AllocateSlaveOffset
                Xor     SI, SI                  ; Offset
                Mov     AH, 0FFh

AllocateChannel18:
                Test    Byte Ptr [DI+3Ah], 80h  ; Disowned???
                JZ      AllocateChannel19       ; No.. then look for next

                Cmp     AH, [DI+20h]            ; Volume set...
                JB      AllocateChannel19

                Mov     SI, DI                  ; get offset.
                Mov     AH, [DI+20h]            ; Get volume

AllocateChannel19:
                Add     DI, SLAVECHANNELSIZE
                Dec     CX
                JNZ     AllocateChannel18

                Pop     DI

;                Inc     AllocateCount3

                Test    SI, SI
                JNZ     AllocateChannelInstrument

                Pop     CX
                And     CH, Not 4

                StC
                Ret

AllocateMIDIChannelFound:
                Pop     DI

AllocateChannelInstrument:
                Mov     [DI+24h], SI            ; SCOffset

                Mov     AL, [DI+20h]
                Mov     [SI+3Ah], AL            ; HCN

                Mov     [SI+38h], DI            ; HCOffset

                Xor     EAX, EAX
                Mov     [SI+18h], EAX           ; Reset vibrato info.
                Mov     Byte Ptr [SI+0Bh], AL   ; Reset loop dirn

                Call    InitPlayInstrument

                Mov     AL, [ES:BX+18h]
                Mov     [SI+24h], AL

                Pop     CX

                Mov     Word Ptr [SI+26h], 0400h  ; FadeOut, VolEnv&Pos

                Mov     AX, [DI+3]
                Cmp     Byte Ptr [DI+0Fh], 101
                JNE     NoMIDINote

                Mov     AL, [DI+0Eh]

NoMIDINote:
                Mov     [SI+32h], AX            ; Nte&Ins

                Mov     BL, [DI+0Fh]
                And     BX, 0FFh
                JZ      AllocateChannel21
                Dec     BX

                Call    I_TagSample

                Mov     [SI+36h], BL

                Add     BX, BX
                Mov     BX, [ES:64912+BX]
                Mov     [SI+34h], BX            ; Sample memory offset.

                Cmp     DWord Ptr [ES:BX+30h], 0
                JE      AllocateChannelInstrument2      ; No sample!

                Mov     AX, [ES:BX+11h]
                Test    AH, 1
                JZ      AllocateChannelInstrument2 ; No sample!

                And     AH, 2
                Mov     [SI+18h], AH

                Mul     Byte Ptr [SI+24h]
                ShR     AX, 6
                Mov     [SI+24h], AL            ; SI = 0->128

                ClC
                Ret

AllocateChannelInstrument2:
                Mov     Word Ptr [SI], 200h
                And     CH, Not 4
                StC
                Ret

EndP            AllocateChannel
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Seed1           DW      1234h
Seed2           DW      5678h

Proc            Random

                Push    BX
                Push    CX
                Push    DX

                Mov     AX, Seed1
                Mov     BX, Seed2
                Mov     CX, BX
                Mov     DX, BX

                Add     AX, BX
                Rol     AX, CL
                Xor     AX, DX
                XChg    CL, CH
                Add     BX, CX
                Add     DX, BX
                Add     CX, AX
                Ror     BX, 1
                SBB     AX, DX
                Mov     Seed2, DX
                Mov     Seed1, AX

                Pop     DX
                Pop     CX
                Pop     BX

                Ret

EndP            Random

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetLoopInformation
                                ; Destroys AX, BX, CX, DX
                Mov     BX, [SI+34h]            ; ES:BX points to sample header
                Mov     AL, [ES:BX+12h]         ; AL = sample flags

                Test    AL, 30h                 ; Loop??
                JZ      GetLoopInformation4

                Mov     ECX, [ES:BX+34h]         ; CX = loopbeg
                Mov     EDX, [ES:BX+38h]         ; DX = loopend

                Mov     AH, AL

                Test    AL, 20h                 ; SusLoop?
                JZ      GetLoopInformation2

                Test    Byte Ptr [SI], 4
                JNZ     GetLoopInformation1

                Mov     ECX, [ES:BX+40h]
                Mov     EDX, [ES:BX+44h]
                ShR     AH, 1
                Jmp     GetLoopInformation2

GetLoopInformation1:
                Test    AL, 10h
                JZ      GetLoopInformation4

GetLoopInformation2:
                Test    AH, 40h
                JNZ     GetLoopInformation3

                Mov     AH, 8
                Jmp     GetLoopInformation5

GetLoopInformation3:
                Mov     AH, 24
                Jmp     GetLoopInformation5

GetLoopInformation4:
                Xor     ECX, ECX
                Mov     EDX, [ES:BX+30h]
                Mov     AH, 0

GetLoopInformation5:
                Cmp     [SI+0Ah], AH
                JNE     GetLoopInformation6
                Cmp     [SI+40h], ECX
                JNE     GetLoopInformation6
                Cmp     [SI+44h], EDX
                JNE     GetLoopInformation6

                Ret

GetLoopInformation6:
                Mov     [SI+0Ah], AH
                Mov     [SI+40h], ECX
                Mov     [SI+44h], EDX
                Or      Word Ptr [SI], 400h     ; Loop changed.

                Ret

EndP            GetLoopInformation

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

include it_m_eff.inc

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PitchSlideDown          ; Expects SI to slave
                                        ; BX = slide value
                Assume  DS:Music

IF USEFPUCODE
                Neg     BX

EndP            PitchSlideDown  ; EndP for PitchSlideDown

ELSE
                Test    Byte Ptr [ES:2Ch], 8
                JNZ     PitchSlideDownLinear
                                                ; Go on to amiga slide down.
EndP            PitchSlideDown

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PitchSlideDownAmiga

                Or      Byte Ptr [SI], 32       ; recalculate pitch!

                Mov     EAX, [SI+10h]
                MovZX   EBX, BX
                Mul     EBX             ; EDX:EAX = cmd*InitialFreq

                Xor     CX, CX          ; CX = counter.

                Add     EAX, 1712*8363
                AdC     EDX, 0
                JZ      PitchSlideDownAmiga1

PitchSlideDownAmiga2:
                ShR     EDX, 1
                RCR     EAX, 1
                Inc     CX

                Test    EDX, EDX
                JNZ     PitchSlideDownAmiga2

PitchSlideDownAmiga1:
                Mov     EBX, EAX              ; EBX = 1712*8363+Cmd*InitialFreq

                Mov     EAX, 8363*1712
                Mul     DWord Ptr [SI+10h]

                JCXZ    PitchSlideDownAmiga4

PitchSlideDownAmiga5:
                ShR     EDX, 1
                RCR     EAX, 1
                Loop    PitchSlideDownAmiga5

PitchSlideDownAmiga4:
                Cmp     EBX, EDX
                JBE     PitchSlideDownAmiga3

                Div     EBX

                Mov     [SI+10h], EAX

PitchSlideDownAmiga3:
                Ret

EndP            PitchSlideDownAmiga

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PitchSlideDownLinear
; Given BX = slide down value = 0->1024

                Or      Byte Ptr [SI], 32       ; recalculate pitch!

                Push    DI
                Mov     DI, Offset LinearSlideDownTable

                Cmp     BX, 0Fh
                JA      PitchSlideDownLinear1

                Mov     DI, Offset FineLinearSlideDownTable
                Add     BX, BX
                Jmp     PitchSlideDownLinear2

PitchSlideDownLinear1:
                ShR     BX, 1
                And     BX, Not 1

PitchSlideDownLinear2:
                MovZX   EAX, Word Ptr [DI+BX]
                Mul     DWord Ptr [SI+10h]
                SHRD    EAX, EDX, 16

                Mov     [SI+10h], EAX

                Pop     DI
                Ret

EndP            PitchSlideDownLinear

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ENDIF   ; USEFPUCODE

Proc            PitchSlideUp            ; Expects SI to slave
                                        ; BX = slide value
                Test    Byte Ptr [ES:2Ch], 8
                JZ      PitchSlideUpAmiga
                                                ; Go on to linear slide

EndP            PitchSlideUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PitchSlideUpLinear

IF USEFPUCODE
                Mov     [CS:SlideValue], BX
                FILD    Word Ptr [CS:SlideValue]
                FMul    [CS:Const1_On_768]      ; Have SlideValue/768.0
                FLd     ST
                FRndInt
                FSub    ST(1), ST
                FXCh
                F2XM1
                FLd1
                FAdd
                FScale
                FIMul   DWord Ptr [SI+10h]
                FIStP   DWord Ptr [SI+10h]
                FStP    ST

PitchSlideUpFPUFreqCheck:
                Or      Byte Ptr [SI], 32       ; recalculate pitch!
                Cmp     DWord Ptr [SI+10h], 07FFFFFFFh
                JAE     PitchSlideUpLinear1
                Ret

PitchSlideUpLinear1:                                    ; Turn off channel
                Or      Word Ptr [SI], 200h
                And     Byte Ptr [DI], Not 4
ELSE

                Or      Byte Ptr [SI], 32       ; recalculate pitch!

                Push    DI
                Cmp     BX, 0Fh
                Mov     DI, Offset LinearSlideUpTable
                JA      PitchSlideUpLinear3

                Mov     DI, Offset FineLinearSlideUpTable
                ShL     BX, 2

                Jmp     PitchSlideUpLinear2

PitchSlideUpLinear3:
                And     BX, Not 3

PitchSlideUpLinear2:
                Mov     EAX, [SI+10h]
                Mul     DWord Ptr [DI+BX]
                SHRD    EAX, EDX, 16

                Test    EDX, 0FFFF0000h
                JNZ     PitchSlideUpLinear1

                Mov     [SI+10h], EAX

                Pop     DI
                Ret

PitchSlideUpLinear1:                                    ; Turn off channel
                Pop     DI
                Or      Word Ptr [SI], 200h
                And     Byte Ptr [DI], Not 4
;                And     Byte Ptr [SI], Not 1
;                Or      Byte Ptr [SI+1], 2              ; Cut!
;                And     Byte Ptr [DI], Not 4

ENDIF

                Ret

EndP            PitchSlideUpLinear
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PitchSlideUpAmiga

IF USEFPUCODE
                Mov     [CS:SlideValue], BX
                FILD    Word Ptr [CS:SlideValue]
                FILD    DWord Ptr [SI+10h]      ; InitFreq, Cmd
                FMul    ST(1), ST               ; InitFreq, Cmd.InitFreq
                FLd     [CS:Const_14317456]     ; 1712*8363, InitFreq, Cmd.InitFreq
                FSubR   ST(2), ST               ; 1712*8363, InitFreq, 1712*8363-Cmd.InitFreq
                FMul                            ; 1712*8363*InitFreq, 1712*8363-Cmd.InitFreq
                FDivRP  ST(1), ST               ; FinalFreq
                FIStP   DWord Ptr [SI+10h]
                Jmp     PitchSlideUpFPUFreqCheck

ELSE
                Or      Byte Ptr [SI], 32       ; recalculate pitch!

                Mov     EAX, [SI+10h]
                MovZX   EBX, BX
                Mul     EBX             ; EDX:EAX = InitialFreq*Cmd

                Test    EDX, EDX
                JNZ     PitchSlideUpAmiga1

                Mov     ECX, 1712*8363
                Mov     EDX, ECX
                Sub     ECX, EAX        ; ECX = 1712*8363-Cmd*InitialFreq
                JBE     PitchSlideUpAmiga1

                Mov     EAX, [SI+10h]
                Mul     EDX
                Cmp     ECX, EDX
                JBE     PitchSlideUpAmiga1

                Div     ECX

                Mov     [SI+10h], EAX

                Ret

PitchSlideUpAmiga1:                                    ; Turn off channel
                Or      Word Ptr [SI], 200h
                And     Byte Ptr [DI], Not 4
;                And     Byte Ptr [SI], Not 1
;                Or      Byte Ptr [SI+1], 2              ; Cut!
;                And     Byte Ptr [DI], Not 4

                Ret
ENDIF

EndP            PitchSlideUpAmiga

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetWaveForm Far

                Test    Byte Ptr CS:DriverFlags, 4
                JZ      Music_GetWaveForm1

                Call    [CS:DriverGetWaveform]

                DB      85h

Music_GetWaveForm1:
                StC
                Ret

EndP            Music_GetWaveForm

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_Poll Far

                Mov     AX, CS:PlayMode
                Mov     BX, CS:CurrentPattern
                Jmp     [DriverPoll]

EndP            Music_Poll
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_InitTempo Far

                PushA
                Call    Music_GetTempo
                Call    [DriverSetTempo]
                PopA

                Ret

EndP            Music_InitTempo

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetChannels     ; Returns min of NumChannels & DriverMaxChannels
                                ; Also uses default channels if num channels
                                ; = 0ffffh
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     AX, CmdLineNumChannels
                Cmp     AX, 0FFFFh
                JNE     GetChannels2

                Mov     AX, DefaultChannels

GetChannels2:
                Cmp     AX, DriverMaxChannels
                JBE     GetChannels1

                Mov     AX, DriverMaxChannels

GetChannels1:
                Cmp     AX, MAXSLAVECHANNELS
                JB      GetChannels3            ; MC4

                Mov     AX, MAXSLAVECHANNELS

GetChannels3:                                   ; MC4
                Mov     NumChannels, AX

                Pop     DS
                Ret

EndP            GetChannels
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ReinitSoundCard Far

                Call    GetChannels
                Call    [DriverReinitSound]
                Jmp     Music_SoundCardLoadAllSamples

EndP            Music_ReinitSoundCard

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_UnInitSoundCard Far

                Jmp     [DriverUninitSound]

EndP            Music_UnInitSoundCard

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_InitMusic Far

                PushAD
                Push    DS
                Push    ES

                Xor     AX, AX
                Mov     DS, AX
                Mov     AX, CS
                ShL     EAX, 16
                Mov     AX, Offset Music_UpdateSampleLocation
IF ENABLEINT3
ELSE
                Mov     [DS:0Ch], EAX
ENDIF

                Trace   " - Initialising SoundDriver Tables"

                Call    Music_ClearDriverTables
                Call    D_GotoStartingDirectory

                Push    CS
                Pop     DS

                        Assume DS:Music

                Trace   " - Loading MIDI configuration"

                ; Open MIDI Config file.
                Mov     AX, 3D00h
                Mov     DX, Offset MIDIConfigFileName
                Int     21h
                JC      Music_InitMusic1

                Mov     BX, AX

                Mov     DS, MIDIDataArea
                Xor     DX, DX
                Mov     AH, 3Fh
                Mov     CX, (128+16+9)*32
                Int     21h

                Mov     AH, 3Eh         ; Close
                Int     21h

Music_InitMusic1:
                Trace   " - Initialising playback tables"

                Call    Music_Stop

                Pop     ES
                Pop     DS
                PopAD
                        Assume DS:Nothing

                Ret

EndP            Music_InitMusic

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ReleasePattern Far        ; AX = pattern number

                Push    AX
                Push    DS
                Push    SI
                Push    ES

                LEA     SI, [63912+EAX*4]
                Push    SI

                Mov     DS, CS:SongDataArea

                LodsW
                Cmp     AL, 1
                JB      Music_ReleasePattern1
                JA      Music_ReleasePattern2

                LodsW
                Mov     ES, AX
                Mov     AH, 49h
                Int     21h
                Jmp     Music_ReleasePattern1

Music_ReleasePattern2:
                Cmp     AL, 3
                JB      Music_ReleasePattern3
                JA      Music_ReleasePattern1

                LodsW
                Dec     AX
                Call    E_ReleaseBlockEMS

                Jmp     Music_ReleasePattern1

Music_ReleasePattern3:
                LodsW
                Call    E_ReleaseEMS

Music_ReleasePattern1:
                Pop     SI
                Mov     DWord Ptr [SI], 0

                Pop     ES
                Pop     SI
                Pop     DS
                Pop     AX

                Ret

EndP            Music_ReleasePattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetPattern Far    ; AX = pattern number
                                        ; Returns DS:SI points to pattern data.

                Push    AX

;                ShL     AX, 2
;                Mov     SI, 63912
;                Add     SI, AX
                LEA     SI, [63912+EAX*4]

                Mov     DS, CS:SongDataArea

                LodsW
                Cmp     AL, 1
                JE      Music_GetPattern1
                JA      Music_GetPattern2

                Push    CS
                Pop     DS
                Mov     SI, Offset EmptyPattern

                Pop     AX
                Ret

Music_GetPattern1:
                LodsW
                Mov     DS, AX
                Xor     SI, SI

                Pop     AX
                Ret

Music_GetPattern2:
                Cmp     AL, 3
                JB      Music_GetPattern3

                LodsW
                Call    E_MapAlignedBlockEMS

                Pop     AX
                Ret

Music_GetPattern3:
                Push    CX
                Push    DX

                MovZX   CX, AH
                Mov     DX, [SI]
                Call    E_MapEMSMemory
                Call    E_GetEMSPageFrame
                Mov     DS, AX
                Xor     SI, SI

                Pop     DX
                Pop     CX

                Pop     AX
                Ret

EndP            Music_GetPattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetPatternLocation Far    ; AX = pattern number
                                                ; Returns AX = handle
                                                ;         EBX = page/offset or
                                                ;               seg/offset
                                                ;         CX = length

                Call    Music_GetPattern        ; Returns DS:SI
                Mov     CX, [SI]
                Add     CX, 8                   ; CX = size of data including header

Proc            Music_GetPatternLocationNoCount Far

                LEA     SI, [63912+EAX*4]

                Mov     DS, CS:SongDataArea

                LodsW
                Cmp     AL, 1
                JE      Music_GetPatternLocation1
                JA      Music_GetPatternLocation2

                Mov     BX, CS
                Xor     AX, AX
                ShL     EBX, 16
                Xor     DX, DX
                Mov     BX, Offset EmptyPattern

                Ret

Music_GetPatternLocation1:
                LodsW
                Mov     BX, AX
                ShL     EBX, 16
                Xor     AX, AX
                Xor     DX, DX

                Ret

Music_GetPatternLocation2:
                Cmp     AL, 3
                JB      Music_GetPatternLocation3

                LodsW                   ; AX = "Segment" into EMS block
                                        ; Want page = (AX >> 10)
                                        ;    offset = (AX << 4) & 0xFFFF
                Mov     BX, AX
                ShL     AX, 4
                ShL     EBX, 6

                Mov     BX, AX
                And     EBX, 03F3FFFh

                Call    E_GetInternalEMSHandle
                Mov     DL, 1

                Ret

Music_GetPatternLocation3:
                LodsW
                Xor     EBX, EBX
                Mov     DL, 1

                Ret

EndP            Music_GetPatternLocationNoCount

EndP            Music_GetPatternLocation

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_AllocatePattern Far       ; DX = length.
                                                ; SI = Pattern
                                                ; ES:DI points to pattern area
                Cmp     CS:PatternStorage, 1
                JB      Music_AllocatePatternConventionalOnly
                JA      Music_AllocatePatternEMS2

Music_AllocatePatternEMS:               ; Try allocating EMS
                Xor     EAX, EAX
                Mov     AX, DX
                Call    E_AllocateBlockEMS
                JC      Music_AllocatePatternEMS2

                Mov     ES, CS:SongDataArea
                LEA     DI, [ESI*4+63914]
                Inc     AX
                StosW
                Mov     Word Ptr [ES:DI-4], 3

                Push    DS
                Push    SI

                Call    E_MapAlignedBlockEMS

                Push    DS
                Pop     ES
                Mov     DI, SI

                Pop     SI
                Pop     DS
                Ret

Music_AllocatePatternEMS2:
                MovZX   EAX, DX
                ClC
                Call    E_AllocateEMS
                Test    AX, AX
                JZ      Music_AllocatePatternConventional

                Push    CX
                Push    DX

                Mov     ES, CS:SongDataArea
                LEA     DI, [ESI*4+63914]
;                Mov     DI, SI
;                ShL     DI, 2
;                Add     DI, 63914
                StosW

                Add     DX, 16383
                RCR     DX, 1
                ShR     DX, 13
                Mov     CX, DX
                Mov     DX, AX
                Call    E_MapEMSMemory

                Mov     CH, CL
                Mov     CL, 2

                Mov     [ES:DI-4], CX
                Call    E_GetEMSPageFrame

                Mov     ES, AX
                Xor     DI, DI

                Pop     DX
                Pop     CX

                Ret

Music_AllocatePatternConventionalOnly:
                Mov     AH, 48h                 ; How much free?
                Mov     BX, 0FFFFh
                Int     21h

                Cmp     BX, -1
                JE      Music_AllocatePatternEMS

                Cmp     BX, 4096
                JAE     Music_AllocatePatternConventional

                ShL     BX, 4                   ; BX = size in bytes of
                                                ; conv remaining
                Cmp     DX, BX
                JA      Music_AllocatePatternEMS

Music_AllocatePatternConventional:
                Mov     AH, 48h
                Mov     BX, DX

                Add     BX, 15
                RCR     BX, 1
                ShR     BX, 3

                Int     21h
                JC      Music_AllocatePattern2

                Push    DS
                Mov     DS, CS:SongDataArea
                LEA     SI, [ESI*4+63912]
;                ShL     SI, 2
;                Add     SI, 63912
                Mov     Word Ptr [SI], 1
                Mov     [SI+2], AX

                Pop     DS
                Mov     ES, AX
                Xor     DI, DI

                Ret

Music_AllocatePattern2:
                Xor     AX, AX
                Mov     ES, AX

                Ret

EndP            Music_AllocatePattern

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_AllocateSample Far        ; AX = Sample number, 0 based
                                                ; EDX = length
                                                ; Returns ES:DI, ES = 0 if not.
                Push    EAX
                Push    BX
                Push    CX
                Push    EDX
                Push    DS
                Push    SI

                Mov     AH, 2
                Call    Music_ReleaseSample
                And     AX, 0FFh

                Add     EDX, 8                  ; Extra 8 bytes allocated..

                Mov     BX, AX
                Add     BX, BX
                Mov     DS, CS:SongDataArea
                Mov     SI, [64912+BX]

                Cmp     EDX, 1024
                JA      Music_AllocateSample5

                Mov     EBX, EDX
                Add     EBX, 15
                RCR     EBX, 1
                SHR     EBX, 3

                Mov     AH, 48h
                Int     21h

                JNC     Music_AllocateSample4

Music_AllocateSample5:
                Mov     EAX, EDX
                StC
                Call    E_AllocateEMS
                Test    AX, AX          ; AX = handle
                JZ      Music_AllocateSample1

                Mov     Byte Ptr [DS:SI+48h], 2
                Mov     [DS:SI+4Ah], AX
                Add     EDX, 16383
                RCR     EDX, 1
                ShR     EDX, 13
                Mov     [DS:SI+49h], DL

                Xor     CH, CH
                Mov     CL, DL
                Mov     DX, AX
                Call    E_MapEMSMemory

                Call    E_GetEMSPageFrame
                Mov     ES, AX
                Xor     DI, DI
                Or      Byte Ptr [SI+12h], 1

                Jmp     Music_AllocateSample3

Music_AllocateSample1:
                Cmp     EDX, 1048576
                JAE     Music_AllocateSample2

                Mov     EBX, EDX
                Add     EBX, 15
                RCR     EBX, 1
                SHR     EBX, 3

                Mov     AH, 48h
                Int     21h

                JC      Music_AllocateSample2

Music_AllocateSample4:
                Mov     Byte Ptr [SI+48h], 1
                Mov     [SI+4Ah], AX
                Or      Byte Ptr [SI+12h], 1

                Mov     ES, AX
                Xor     DI, DI
                Jmp     Music_AllocateSample3

Music_AllocateSample2:
                And     Byte Ptr [SI+12h], 0F0h

                Xor     AX, AX
                Mov     ES, AX

Music_AllocateSample3:
                Pop     SI
                Pop     DS
                Pop     EDX
                Pop     CX
                Pop     BX
                Pop     EAX
                Ret

EndP            Music_AllocateSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ReleaseSample Far         ; AX = sample number, 0 based
                                                ; AH = 1 = called from network
                                                ;    = 2 = called from allocate

                PushAD
                Push    DS
                Push    ES

                Mov     DX, AX
                And     AX, 0FFh

                Mov     BX, AX
                Add     BX, BX
                Mov     DS, CS:SongDataArea
                Mov     BX, [BX+64912]
                                                ; DS:BX points to sample
                PushAD
                Mov     SI, BX
                Call    [DriverReleaseSample]
                PopAD

                Mov     DI, BX

                Test    Byte Ptr [BX+12h], 1
                JZ      Music_ReleaseSample1    ; Used to be ReleaseSample5.
                                                ; Changed for network code

                Mov     AL, [BX+48h]
                Cmp     AL, 1
                JB      Music_ReleaseSample5
                JE      Music_ReleaseSample2
                Cmp     AL, 2
                JA      Music_ReleaseSample1

                Mov     AX, [BX+4Ah]
                Call    E_ReleaseEMS
                Jmp     Music_ReleaseSample1

Music_ReleaseSample2:
                Mov     ES, [BX+4Ah]
                Mov     AH, 49h
                Int     21h

Music_ReleaseSample1:
                Mov     DWord Ptr [DI+30h], 0
                Mov     DWord Ptr [DI+48h], 0

                Cmp     DH, 1
                JA      Music_ReleaseSample5
                JE      Music_ReleaseSample6

IF NETWORKENABLED
                Mov     AH, DL
                Mov     AL, NETWORK_DELETESAMPLEOBJECT
                Call    Network_AddWordToQueue
ENDIF

Music_ReleaseSample6:
                Push    DS
                Pop     ES
                Xor     AX, AX
                And     Byte Ptr [DI+12h], 0FEh
                Add     DI, 14h
                Mov     CX, 3Ch/2
                Rep     StosW

Music_ReleaseSample5:
                Pop     ES
                Pop     DS
                PopAD
                Ret

EndP            Music_ReleaseSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ClearSampleName Far       ; AX = Sample number (0 based)

                Push    CX
                Push    DS
                Push    SI
                Push    ES
                Push    DI

                Push    CS
                Pop     DS
                Mov     SI, Offset SampleHeader

                Mov     ES, CS:SongDataArea
                Mov     DI, AX
                Add     DI, DI
                Mov     DI, [ES:64912+DI]

                Mov     CX, 80
                Rep     MovsB

                Pop     DI
                Pop     ES
                Pop     SI
                Pop     DS
                Pop     CX
                Ret

EndP            Music_ClearSampleName

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ClearAllSampleNames Far

                Push    AX
                Push    CX

                Mov     CX, 100

Music_ClearAllSampleNames1:
                Mov     AX, CX
                Dec     AX
                Call    Music_ClearSampleName

                Loop    Music_ClearAllSampleNames1

                Pop     CX
                Pop     AX

                Ret

EndP            Music_ClearAllSampleNames

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ReleaseAllSamples Far

                Push    AX
                Push    CX

                Mov     CX, 100

Music_ReleaseAllSamples1:
                Mov     AX, CX
                Dec     AX
                Call    Music_ReleaseSample

                Loop    Music_ReleaseAllSamples1

                Pop     CX
                Pop     AX
                Ret

EndP            Music_ReleaseAllSamples

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ReleaseAllPatterns Far

                Push    AX
                Push    CX

                Mov     CX, 200

Music_ReleaseAllPatterns1:
                Mov     AX, CX
                Dec     AX
                Call    Music_ReleasePattern
                Loop    Music_ReleaseAllPatterns1

                Pop     CX
                Pop     AX
                Ret

EndP            Music_ReleaseAllPatterns

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ClearInstrument Far               ; AX = Instrument number
                                                        ; (0 based)

                Push    CX
                Push    DS
                Push    SI
                Push    ES
                Push    DI

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     DI, AX
                Add     DI, DI
                Mov     ES, SongDataArea
                Mov     DI, [ES:DI+64712]               ; ES:DI points to inst.
                Mov     SI, Offset InstrumentHeader
                Mov     CX, 554
                Rep     MovsB

                Pop     DI
                Pop     ES
                Pop     SI
                Pop     DS
                Pop     CX
                Ret

EndP            Music_ClearInstrument
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ClearAllInstruments Far

                Mov     AX, 99

Music_ClearAllInstruments1:
                Call    Music_ClearInstrument
                Dec     AX
                JNS     Music_ClearAllInstruments1

                Ret

EndP            Music_ClearAllInstruments

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_UnInitMusic Far

                Call    Music_UnInitSoundCard
                Call    Music_UnloadDriver

                Cmp     CS:SongDataArea, 0
                JE      Music_UnInitMusic1

                Call    Music_ReleaseAllPatterns
                Call    Music_ReleaseAllSamples

Music_UnInitMusic1:
                Mov     ES, CS:SongDataArea
                Mov     AH, 49h
                Int     21h

                Ret

EndP            Music_UnInitMusic

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetSongSegment Far

                Mov     AX, CS:SongDataArea
                Ret

EndP            Music_GetSongSegment

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_UnloadDriver

                Xor     AX, AX
                XChg    AX, CS:SoundDriverSegment
                Test    AX, AX
                JZ      Music_UnloadDriver1

                Mov     ES, AX
                Mov     AH, 49h
                Int     21h

Music_UnloadDriver1:
                Ret

EndP            Music_UnloadDriver

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            NoFunction2

                Push    CS
                Pop     DS
                Mov     SI, Offset NoSoundCardMsg

Proc            NoFunction Far

                Xor     AX, AX
                StC
                Ret

EndP            NoFunction

EndP            NoFunction2

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ClearDriverTables
                                        ; Makes all of them point to
                                        ; Xor AX, AX, StC, RetF
                Mov     AX, CS
                Mov     ES, AX

                ShL     EAX, 16
                Mov     AX, Offset NoFunction2
                Mov     DI, Offset StartDriverFunctions
                StosD
                StosD

                Mov     AX, Offset NoFunction
IF OLDDRIVER
                Mov     CX, 61
ELSE
                Mov     CX, 29
ENDIF
                Rep     StosD

                Xor     EAX, EAX
                StosD

                Mov     DriverMaxChannels, 32

                Ret

EndP            Music_ClearDriverTables

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_LoadDriver        ; Given DS:DX = filename
                Assume DS:Nothing

IFDEF DEBUG

                PushA
                Push    ES
                Push    DS

                Mov     DI, 0B800h
                Mov     ES, DI

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     DI, [ScreenOffset]
                Mov     SI, Offset LoadDriverMessage
                Mov     AH, 2

LoadDriverMessage1:
                LodsB
                StosW
                Test    AL, AL
                JNZ     LoadDriverMessage1

                Pop     DS
                        Assume DS:Nothing

                Mov     SI, DX

LoadDriverMessage2:
                LodsB
                StosW
                Test    AL, AL
                JNZ     LoadDriverMessage2

                Add     [CS:ScreenOffset], 160

                Pop     ES
                PopA

ENDIF

                Mov     AX, 3D00h
                Int     21h
                ClD
                JNC     Music_LoadDriver2

IFDEF DEBUG

                PushA
                Push    DS
                Push    ES

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     DI, 0B800h
                Mov     ES, DI

                Mov     SI, Offset UnableToReadFileMessage
                Mov     DI, [ScreenOffset]
                Mov     AH, 2

UnableToReadFileLoop:
                LodsB
                StosW
                Test    AL, AL
                JNZ     UnableToReadFileLoop

                Add     [ScreenOffset], 160

                Pop     ES
                Pop     DS
                PopA
                        Assume DS:Nothing

ENDIF

                Jmp     Music_LoadDriverNoClose

Music_LoadDriverError:
                Mov     AH, 3Eh
                Int     21h

Music_LoadDriverNoClose:
                ClD

                Call    Music_ClearDriverTables

                Push    CS
                Pop     DS

                StC
                Ret

Music_LoadDriver2:
                Mov     BX, AX          ; BX = file handle
                Mov     AH, 3Fh         ; Read file

IF OLDDRIVER
                Mov     CX, 256
ELSE
                Mov     CX, 128
ENDIF

                Push    CS
                Push    CS
                Pop     DS
                Pop     ES
                        Assume DS:Music

                Mov     DX, Offset StartDriverFunctions
                Mov     SI, DX
                Int     21h
                JC      Music_LoadDriverError
                Cmp     AX, CX
                JNE     Music_LoadDriverError

IF OLDDRIVER
                Mov     CX, 28
ELSE
                Mov     CX, 37          ; Length of ID
ENDIF

                Mov     DI, Offset DriverID
                RepE    CmpsB
                JNE     Music_LoadDriverError

                                ; OK.. ID OK. Now get length, allocate memory
                                ; load driver, and fill in headers.
                Push    BX

                Mov     BX, DriverLength
                Add     BX, 15
                Mov     AH, 48h
                ShR     BX, 4
                Int     21h
                Pop     BX
                JC      Music_LoadDriverError   ; Insufficient memory

                Mov     CX, DriverLength
                Mov     SoundDriverSegment, AX
                Mov     DS, AX
                        Assume DS:Nothing

                Mov     DI, AX                  ; DI = segment of driver...

                Mov     AH, 3Fh                 ; Load driver into memory!
                Xor     DX, DX
                Int     21h

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     AH, 3Fh
                Mov     DX, Offset DriverVariableTable

IF OLDDRIVER
                Mov     CX, 64
ELSE
                Mov     CX, 16
ENDIF
                Int     21h

                Mov     AH, 3Fh

IF OLDDRIVER
                Mov     CX, 128
                Mov     DX, Offset StartDriverFunctions+128
ELSE
                Mov     CX, 64
                Mov     DX, Offset StartDriverFunctions+64
ENDIF
                Mov     SI, DX
                Int     21h
                JC      Music_LoadDriverError
                Cmp     AX, CX
                JNE     Music_LoadDriverError

                Mov     AH, 3Eh
                Int     21h

                        ; Setup reqd function table
                SHRD    EAX, EDI, 16            ; High word of EAX contains
                                                ; segment...
                Mov     DI, Offset StartDriverFunctions

IF OLDDRIVER
                Mov     CX, 64
ELSE
                Mov     CX, 32
ENDIF

DriverFunctionLoop1:
                LodsW
                StosD
                Loop    DriverFunctionLoop1

                        ; Setup variable table
                Mov     ES, SoundDriverSegment
                Xor     DI, DI

IF OLDDRIVER
                Mov     CX, 256
ELSE
                Mov     CX, 16
ENDIF
                Mov     SI, Offset DriverRequiredVariables
                Rep     MovsB

                Mov     SI, Offset DriverRequiredFunctions

IF OLDDRIVER
                Mov     CX, 128
ELSE
                Mov     CX, 32
ENDIF
                Rep     MovsD

IFDEF DEBUG

                PushA
                Push    DS
                Push    ES

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     DI, 0B800h
                Mov     ES, DI

                Mov     SI, Offset DetectingMessage
                Mov     DI, [ScreenOffset]
                Mov     AH, 2

DetectingMessageLoop:
                LodsB
                StosW
                Test    AL, AL
                JNZ     DetectingMessageLoop

                Add     [ScreenOffset], 160

                Pop     ES
                Pop     DS
                PopA
                        Assume DS:Nothing

ENDIF
                ClC

                Ret

EndP            Music_LoadDriver

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ADSCParams      DW      7 Dup (0)

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_AutoDetectSoundCard Far
                                ; Returns DS:SI = string
                                ; AX, BX, CX, DX, DI = parameters

                Call    D_GotoStartingDirectory

                Xor     SI, SI

                Mov     DX, Word Ptr [CS:DriverName]
                And     DX, DX
                JZ      Music_AutoDetectSoundCard1

                Trace   " - Loading specific soundcard driver"

                Cmp     DX, 0FFFFh
                JE      Music_AutoDetectSoundCard4

                Mov     DS, Word Ptr [CS:DriverName+2]
                Call    Music_LoadDriver
                JC      Music_AutoDetectSoundCard4

                Mov     AL, 1                   ; Forced
                Mov     BX, TRACKERVERSION
                Mov     ECX, [CS:DriverName]
                Call    [DriverDetectCard]
                JC      Music_AutodetectSoundCard5
                Cmp     EAX, 'Jeff'
                JE      Music_AutoDetectSoundCard4

Music_AutodetectSoundCard5:
                Call    Music_UnloadDriver
                Call    Music_ClearDriverTables
                Jmp     Music_AutoDetectSoundCard4

Music_AutoDetectSoundCard1:
                Trace   " - Testing soundcard driver"

                Push    SI
                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     Word Ptr [DriverName+2], DS

                Mov     BX, [SI+DriverDetectionOrder]
                Cmp     BX, 0FFFFh
                JE      Music_AutoDetectSoundCard2

                Add     BX, BX
                Mov     DX, [DriverNameTable+BX]
                Mov     Word Ptr [DriverName], DX
                Call    Music_LoadDriver
                JC      Music_AutoDetectSoundCard3

                Xor     AX, AX                  ; Not forced
                Mov     BX, TRACKERVERSION
                Mov     ECX, [CS:DriverName]
                Call    [DriverDetectCard]
                JC      Music_AutoDetectSoundCard6

                Cmp     EAX, 'Jeff'
                JE      Music_AutoDetectSoundCard2

Music_AutoDetectSoundCard6:
                Call    Music_UnloadDriver
                Call    Music_ClearDriverTables

Music_AutoDetectSoundCard3:

                Pop     SI
                Add     SI, 2
                Jmp     Music_AutoDetectSoundCard1

Music_AutoDetectSoundCard2:
                Pop     AX

Music_AutoDetectSoundCard4:
                Call    GetChannels
                Call    [CS:DriverInitSound]

                Mov     [CS:ADSCParams+2], DS

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     [ADSCParams], SI
                Mov     [ADSCParams+12], DI
                Mov     [ADSCParams+10], DX
                Mov     [ADSCParams+8], CX
                Mov     [ADSCParams+6], BX
                Mov     [ADSCParams+4], AX

                Call    Music_InitStereo

                Call    Music_InitMixTable

                Ret

EndP            Music_AutoDetectSoundCard
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ShowAutoDetectSoundCard Far

                Push    CS
                Pop     DS
                        Assume DS:Music

                Push    DWord Ptr [ADSCParams+10]
                Push    DWord Ptr [ADSCParams+6]
                Push    [ADSCParams+4]

                LDS     SI, DWord Ptr [ADSCParams]

                Mov     AH, 20h
                Mov     DI, (26+28*80)*2
                Call    S_DrawString

                Add     SP, 10
                Ret

EndP            Music_ShowAutoDetectSoundCard
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetInstrumentMode Far

                Push    DS
                Mov     DS, CS:SongDataArea
                Mov     AH, [DS:2Ch]
                And     AH, 4

                Pop     DS

                Ret

EndP            Music_GetInstrumentMode

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            UpdateGOTONote                  ; Get offset & arrayed flag.

                Push    DS
                        Assume DS:Nothing

                Call    PE_GetCurrentPattern
                        ; AX = Pattern number
                        ; BX = MaxRow
                        ; DS = PatternDataSegment
                Cmp     AX, CS:CurrentPattern
                JNE     UpdateGOTONote1

                Mov     DecodeExpectedPattern, AX
                Mov     CS:PatternSegment, DS

                Pop     DS
                        Assume DS:Music
                Mov     NumberOfRows, BX
                Mov     AX, ProcessRow
                Cmp     AX, BX
                JB      UpdateGOTONote2

                Xor     AX, AX
                Mov     ProcessRow, AX
                Mov     CurrentRow, AX

UpdateGOTONote2:
                Mov     DecodeExpectedRow, AX

                LEA     AX, [EAX*4+EAX]         ; PatternRowSize = *320
                ShL     AX, 6
;                Mov     BX, 320
;                Mul     BX
                Mov     PatternOffset, AX
                Mov     PatternArray, 1

                Ret

UpdateGOTONote1:
                Pop     DS
                        Assume DS:Music

                Mov     AX, CurrentPattern
                Mov     DecodeExpectedPattern, AX
IF NETWORKENABLED
                Call    Network_UpdatePatternIfIdle
ENDIF
                Call    Music_GetPattern
                        Assume DS:Nothing
                                                ; DS:SI points to pattern.

                LodsW
                LodsW                           ; AX = number of rows

                Mov     CX, ProcessRow
                Cmp     AX, CX
                JA      UpdateGotoNote3

                Xor     CX, CX

UpdateGOTONote3:
                Mov     CurrentRow, CX
                Mov     ProcessRow, CX
                Mov     DecodeExpectedRow, CX
                Mov     NumberOfRows, AX
                Add     SI, 4
                Inc     CX

UpdateGOTONote10:
                Dec     CX
                JZ      UpdateGOTONote5

UpdateGOTONote4:                                ; OK.. now to find the right
                                                ; offset & update tables.
                LodsB
                Test    AL, AL
                JZ      UpdateGOTONote10

                Mov     DL, AL

                And     AX, 7Fh
                Dec     AX
                LEA     BX, [EAX*4+EAX]         ; BX = AX*5
                ShL     BX, 4                   ; BX = AX*80
                LEA     DI, [HostChannelInformationTable+BX]


;                And     AL, 7Fh
;                Dec     AL
;                Mov     AH, HOSTCHANNELSIZE
;                Mul     AH
;                Mov     DI, AX
;                Add     DI, Offset HostChannelInformationTable
                                                ; CS:DI points.

                Mov     DH, [CS:DI+2]
                Test    DL, 80h
                JZ      UpdateGOTONote6

                Mov     DH, [SI]
                Inc     SI
                Mov     [CS:DI+2], DH

UpdateGOTONote6:
                Test    DH, 1
                JZ      UpdateGOTONote7

                LodsB
                Mov     [CS:DI+3], AL

UpdateGOTONote7:
                Test    DH, 2
                JZ      UpdateGOTONote8

                LodsB
                Mov     [CS:DI+4], AL

UpdateGOTONote8:
                Test    DH, 4
                JZ      UpdateGOTONote9

                LodsB
                Mov     [CS:DI+5], AL

UpdateGOTONote9:
                Test    DH, 8
                JZ      UpdateGOTONote4

                LodsW
                Mov     [CS:DI+8], AX
                Jmp     UpdateGOTONote4

UpdateGOTONote5:
                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     PatternOffset, SI
                Mov     PatternArray, 0

                Ret

EndP            UpdateGOTONote
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreInitCommand

                Push    DS
                Push    SI

                Push    CS
                Pop     DS
                        Assume DS:Music

                Test    Byte Ptr [DI+2], 33h
                JZ      PreInitCommandEnd

                Test    Byte Ptr [ES:2Ch], 4
                JNZ     PreInitCommand1

PreInitCommand2:
                Mov     AX, [DS:DI+3]
                Mov     [DS:DI+0Eh], AX                 ; Sample/note

                Jmp     PreInitCommandEnd

PreInitCommand1:                                        ; Have to xlat.
                Mov     SI, [DS:DI+3]           ; Not a note?
                And     SI, 0FFh
                Cmp     SI, 120
                JAE     PreInitCommand2

                Mov     BL, [DS:DI+4]
                And     EBX, 0FFh
                JZ      PreInitCommand2

                Add     SI, SI
                Mov     BX, [ES:64710+EBX+EBX]

                Mov     AX, [ES:BX+3Ch]
                Cmp     AL, 0
                JE      PreInitCommandNoMIDI
                Cmp     AL, 17
                JNE     PreInitCommandMIDI1

                Mov     AL, [DS:DI+20h]
                And     AL, 0Fh
                Inc     AL                      ; AL = HCN

PreInitCommandMIDI1:
                Mov     [DS:DI+0Ch], AX
                Mov     AH, 101
                Mov     AL, [ES:BX+SI+40h]
;                Mov     AL, [DS:DI+3]
                Jmp     PreInitCommandMIDIEnd

PreInitCommandNoMIDI:
                Mov     AX, [ES:BX+SI+40h]

PreInitCommandMIDIEnd:
                Mov     [DS:DI+0Eh], AX
                Test    AH, AH                  ; No sample?
                JZ      PreInitCommand4

PreInitCommandEnd:
                Mov     BL, [DS:DI+6]
                And     EBX, 31

                Call    Word Ptr [InitCommandTable+EBX+EBX] ; Init note

                Or      Byte Ptr [DI], 64

                MovZX   BX, Byte Ptr [DI+20h]           ; Check whether chn
                                                        ; is on
                Test    Byte Ptr [ES:BX+40h], 80h
                JZ      PreInitCommand4

                Test    Byte Ptr [DI], 32
                JNZ     PreInitCommand4

                Test    Byte Ptr [DI], 4
                JZ      PreInitCommand4                 ; Channel was off.

                Mov     SI, [DI+24h]
                Or      Byte Ptr [SI+1], 8

PreInitCommand4:
                Pop     SI
                Pop     DS
                Ret

EndP            PreInitCommand

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            UpdateNoteData
                        Assume DS:Music

                Mov     PatternLooping, 0

                Mov     AX, CurrentPattern
                Cmp     AX, DecodeExpectedPattern
                JNE     UpdateNoteData1

                Mov     AX, CurrentRow
                Inc     DecodeExpectedRow
                Cmp     AX, DecodeExpectedRow
                JE      UpdateNoteData2

UpdateNoteData1:
                Call    UpdateGOTONote

UpdateNoteData2:
                Mov     CX, 64                  ; 64 channels
;                Xor     AX, AX                  ; Just to get rid of "jumps"
                Mov     DI, Offset HostChannelInformationTable

                Cmp     PatternArray, 1
                JE      UpdateNoteArrayed

UpdateNoteCompressed:                   ; First clear all old command&value.
;                Mov     CX, 64                 ; Done above

UpdateNoteCompressed1:
                And     Word Ptr [DI], Not (3+32+64+256)
                Add     DI, HOSTCHANNELSIZE
                Dec     CX
                JNZ     UpdateNoteCompressed1

                Push    DS

                Mov     AX, CurrentPattern
IF NETWORKENABLED
;               Call    Network_UpdatePatternIfIdle
ENDIF
                Call    Music_GetPattern        ; Gets DS

                Mov     SI, CS:PatternOffset
;                Mov     DS, PatternSegment
                        Assume DS:Nothing

UpdateNoteCompressed2:
                LodsB
                Test    AL, AL
                JZ      UpdateNoteCompressed3   ; No more!
                                                ; else... go through decoding.
                Mov     DL, AL

                And     AX, 7Fh
                Dec     AX
                LEA     DI, [EAX*4+EAX]
                ShL     DI, 4                   ; HOSTCHANNELSIZE
                Add     DI, Offset HostChannelInformationTable

                Mov     DH, [CS:DI+2]           ; mask.
                Test    DL, 80h
                JZ      UpdateNoteCompressed4

                Mov     DH, [SI]
                Inc     SI
                Mov     [CS:DI+2], DH

UpdateNoteCompressed4:                          ; DH = mask
                Test    DH, 1
                JZ      UpdateNoteCompressed6

                LodsB
                Mov     [CS:DI+3], AL

UpdateNoteCompressed6:
                Test    DH, 2
                JZ      UpdateNoteCompressed8

                LodsB
                Mov     [CS:DI+4], AL

UpdateNoteCompressed8:
                Test    DH, 4
                JZ      UpdateNoteCompressed10

                LodsB
                Mov     [CS:DI+5], AL

UpdateNoteCompressed10:
                Test    DH, 8
                JZ      UpdateNoteCompressed11

                LodsW
                Mov     [CS:DI+8], AX
                Jmp     UpdateNoteCompressed13

UpdateNoteCompressed11:
                Test    DH, 80h
                JZ      UpdateNoteCompressed12

                Mov     AX, [CS:DI+8]
                Jmp     UpdateNoteCompressed13

UpdateNoteCompressed12:
                Xor     AX, AX

UpdateNoteCompressed13:
                Mov     [CS:DI+6], AX
                Call    PreInitCommand

                Jmp     UpdateNoteCompressed2

UpdateNoteCompressed3:
                Pop     DS
                        Assume DS:Music

                Mov     PatternOffset, SI

                Ret

UpdateNoteArrayed:
                        Assume DS:Music

                Push    DS

                Mov     SI, PatternOffset
                Mov     DS, PatternSegment
                        Assume DS:Nothing

;                Mov     CX, 64                  ; 64 channels
;                Mov     DI, Offset HostChannelInformationTable

UpdateNoteArrayed1:
                Xor     DL, DL                  ; DL = mask.
                And     Word Ptr [CS:DI], Not (3+32+64+256)
                                                ; Turn off all calling...

                LodsB                           ; AL = note data.
                Cmp     AL, NONOTE
                JE      UpdateNoteArrayed2

                Mov     [CS:DI+3], AL
                Or      DL, 1

UpdateNoteArrayed2:
                LodsB
                Test    AL, AL
                JZ      UpdateNoteArrayed3

                Mov     [CS:DI+4], AL
                Or      DL, 2

UpdateNoteArrayed3:
                LodsB
                Cmp     AL, 0FFh
                JE      UpdateNoteArrayed4

                Mov     [CS:DI+5], AL
                Or      DL, 4

UpdateNoteArrayed4:
                LodsW
                Mov     [CS:DI+6], AX
                Mov     [CS:DI+8], AX

                Test    AX, AX
                JZ      UpdateNoteArrayed5

                Or      DL, 8

UpdateNoteArrayed5:
                Test    DL, DL
                JZ      UpdateNoteArrayed6

                Mov     [CS:DI+2], DL
                Push    CX

                Call    PreInitCommand

                Pop     CX
                        Assume DS:Nothing


UpdateNoteArrayed6:
                Add     DI, HOSTCHANNELSIZE
                Dec     CX
                JNZ     UpdateNoteArrayed1

                Pop     DS
                        Assume DS:Music

                Mov     PatternOffset, SI

                Ret

EndP            UpdateNoteData
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            UpdateVibrato   ; DS:SI points to slavechannelstruct.

                Mov     BX, [SI+34h]    ; ES:BX points to sample
                Mov     DL, [ES:BX+4Dh] ; Vibrato depth
                Test    DL, DL
                JZ      UpdateVibrato1

                Mov     CX, [SI+1Ah]
                Add     CL, [ES:BX+4Eh] ; Vibrato rate
                AdC     CH, 0

                Cmp     CH, DL
                JBE     UpdateVibrato5

                Mov     CH, DL

UpdateVibrato5:
                Mov     [SI+1Ah], CX

                Mov     AH, [ES:BX+4Ch] ; AH = speed
                Mov     BH, [ES:BX+4Fh] ; BH = waveform
                Test    AH, AH
                JZ      UpdateVibrato1

                Cmp     BH, 3
                JE      UpdateVibrato2

                Mov     BL, [SI+19h]

                Add     BL, AH
                Mov     [SI+19h], BL    ; Update pointer.

                Mov     AL, [FineSineData+BX]
                Jmp     UpdateVibrato3

UpdateVibrato2:
                Call    Random
                And     AL, 127
                Sub     AL, 64

UpdateVibrato3:
                IMul    CH

                SAL     AX, 2
                MovSX   BX, AH

IFE USEFPUCODE
                JS      UpdateVibrato4
ENDIF
                JZ      UpdateVibrato1

                Push    DI
                Mov     DI, [SI+38h]
                Call    PitchSlideUpLinear
                Pop     DI

IFE USEFPUCODE
                Jmp     UpdateVibrato1

UpdateVibrato4:
                Neg     BX
                Call    PitchSlideDownLinear
ENDIF

UpdateVibrato1:
                Ret

EndP            UpdateVibrato

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Update Far

                Push    CS
                Pop     DS
                        Assume DS:Music

IF USEFPUCODE
                FNSave  FPSave
                FNInit
                FLdCW   [NewControlWord]
ENDIF

                Mov     CX, MAXSLAVECHANNELS
                Mov     SI, Offset SlaveChannelInformationTable
                Mov     DI, [SI+38h]

                Mov     BX, MIDICOMMAND_TICK
                Call    MIDITranslate

                Mov     ES, SongDataArea

Update2:
                Test    Byte Ptr [SI], 1
                JZ      Update3
                                                ; reset volume
                Mov     BL, [SI+22h]
                Cmp     BL, [SI+21h]
                JE      Update4

                Mov     [SI+21h], BL
                Or      Byte Ptr [SI], 10h

Update4:
                Mov     EAX, [SI+14h]           ; Freq
                Cmp     EAX, [SI+10h]
                JE      Update3

                Mov     [SI+10h], EAX
                Or      Byte Ptr [SI], 20h      ; Recalc freq.

Update3:
                Add     SI, SLAVECHANNELSIZE
                Dec     CX
                JNZ     Update2

                Call    UpdateData

                Test    Byte Ptr [ES:2Ch], 4
                JZ      Update5

                Call    UpdateInstruments
                Jmp     UpdateEnd

Update5:
                Call    UpdateSamples

UpdateEnd:
                Mov     CX, NumChannels
                Mov     SI, Offset SlaveChannelInformationTable
                Mov     AX, PlayMode

IF USEFPUCODE
                FRstor  FPSave
ENDIF
                Ret


EndP            Update

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            UpdateSamples

                        Assume DS:Music

                Mov     CX, NumChannels
                Mov     SI, Offset SlaveChannelInformationTable

UpdateSamples1:
                Test    Byte Ptr [SI], 1
                JZ      UpdateSamples2

                Mov     BX, [SI]                ; OK.. if recalc volume is on.
                                                ; then recalc volume! :)
                Push    CX

                Test    BL, 16
                JZ      UpdateSamples3

                And     BL, Not 16
                Mov     CL, SoloSample

                Or      BL, 64                  ; Recalc final vol
                Cmp     CL, 0FFh
                JE      UpdateSamples6

                Cmp     [SI+36h], CL
                JE      UpdateSamples6

                Or      BH, 8

UpdateSamples6:
                Xor     DX, DX
                Mov     AL, [SI+21h]            ; AL = vol
                Mul     Byte Ptr [SI+23h]       ; Channel volume, AX = 0->64^2
                Mov     DL, Byte Ptr [SI+24h]   ; Sample volume
                Mul     DX                      ; AX = 0->64*64*128

                SHRD    AX, DX, 4               ; AX = 0->32768

                Mov     DL, GlobalVolume
                Mul     DX                      ; AX = 0->32768*128

                SHRD    AX, DX, 7

                Mov     [SI+20h], AH            ; Final vol stored.
                Mov     [SI+4Ah], AX

UpdateSamples3:
                Test    BL, 2
                JZ      UpdateSamples4

                And     BL, Not 2
                Or      BH, 128

                Mov     AL, [SI+2Ah]
                Mov     [SI+25h], AL
                Cmp     AL, 100
                JE      UpdateSamples5

                Sub     AL, 32
                                        ; Pan = (Pan-32)* Separation/128 + 32
                Mov     AH, [ES:34h]
                ShR     AH, 1                   ; AH = 0->64 (Separation)
                IMul    AH                      ; AX = -2048->+2048
                                                ; ie. AH = -8->+8
                SAR     AX, 6                   ; AL = -32->+32

                Cmp     ReverseChannels, 0
                JE      UpdateSamplePan3

                Neg     AL

UpdateSamplePan3:
                Add     AL, 32

UpdateSamples5:
                Mov     [SI+37h], AL

UpdateSamples4:
                Mov     [SI], BX

                Call    UpdateVibrato

                Pop     CX

UpdateSamples2:
                Add     SI, SLAVECHANNELSIZE
                Dec     CX
                JNZ     UpdateSamples1

                Ret

EndP            UpdateSamples
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            UpdateEnvelope          ; Returns Carry if envelope needs
                                        ; to be turned off
                        ; Reqs ES:DI points to envelope
                        ; DS:SI points to slave channel envelope structure
                        ; Called only if envelope is ON
                        ; BP != 0 if sustain points released, 0 otherwise

                Mov     DX, [SI+8]      ; DX = current pos

                Cmp     DX, [SI+0Ch]    ; Expected end pos
                JAE     UpdateEnvelope1

                Inc     DX
                Mov     EAX, [SI+4]     ; Update value

                Mov     [SI+8], DX      ; Increase position
                Add     [SI], EAX

                ClC
                Ret

UpdateEnvelope1:                        ; Procedure:
                                        ; 1) Get current pos' value
                                        ; 2) Figure out next pos (inc/loop)
                                        ; 3) Figure out delta to next pos
                                        ; 4) Terminate if no loop (with carry)
                                        ;      or place new check in [SI+0Ch]

                Xor     BX, BX
                Mov     BL, [SI+0Ah]    ; BX = cur env node
                LEA     AX, [BX+1]
                LEA     BX, [EBX*2+EBX] ; BX = BX*3

                Xor     DH, DH
                Mov     DL, [ES:DI+BX+6]
                ShL     EDX, 16
                Mov     [SI], EDX       ; Current pos value done.

                                        ; AX = next cur env node
                Mov     DX, [ES:DI]

                Test    DL, 6           ; Any loop at all?
                JZ      UpdateEnvelope2

                Mov     BX, [ES:DI+2]   ; Normal Loop

                Test    DL, 4           ; No SusLoop?
                JZ      UpdateEnvelope3

                Test    BP, BP
                JNZ     UpdateEnvelope4

                Mov     BX, [ES:DI+4]
                Jmp     UpdateEnvelope3

UpdateEnvelope4:
                Test    DL, 2
                JZ      UpdateEnvelope2

UpdateEnvelope3:                        ; Loop
                Cmp     AL, BH
                JBE     UpdateEnvelope2

                Xor     BH, BH
                Mov     [SI+0Ah], BL    ; BL=New node
                LEA     BX, [EBX*2+EBX]

                Mov     AX, [ES:DI+BX+7]
                Mov     [SI+8], AX
                Mov     [SI+0Ch], AX

                ClC
                Ret

UpdateEnvelope2:                        ; AX = new node
                Cmp     AL, DH          ; DH = number of nodes
                JB      UpdateEnvelope7

                StC
                Ret

UpdateEnvelope7:
                Mov     [SI+0Ah], AL    ; New node
                LEA     BX, [EAX*2+EAX]

                Mov     DX, [ES:DI+BX+7]        ; New node's tick
                Mov     [SI+0Ch], DX
                Mov     AX, [ES:DI+BX+7-3]      ; Last node's tick
                Sub     DX, AX
                Inc     AX
                Mov     [SI+8], AX              ; For security.

                Mov     AL, [ES:DI+BX+6]        ; New node's amplitude
                Sub     AL, [ES:DI+BX+6-3]      ; Last node's amplitude

                Mov     BX, DX                  ; BX = delta(ticks)
                Xor     DX, DX
                CBW
                Test    AX, AX
                PushF
                JNS     UpdateEnvelope5

                Neg     AX

UpdateEnvelope5:
                Sub     BX, 1
                AdC     BX, 1                   ; Just to prevent div 0 errors

                Div     BX
                ShL     EAX, 16                 ; This clears AX also
                Div     BX
                                                ; EAX = value
                PopF
                JNS     UpdateEnvelope6

                Neg     EAX

UpdateEnvelope6:
                Mov     [SI+4], EAX             ; Delta done

                ClC
                Ret

EndP            UpdateEnvelope

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

DoMIDICycle     DB      0

MIDIPrograms    DB      16 Dup (0FFh)           ; Do NOT change order!
MIDIBanks       DW      16 Dup (0FFFFh)
MIDIPan         DB      16 Dup (0FFh)
MIDIPitch       DW      16 Dup (2000h)

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            UpdateMIDI
                Assume DS:Music

; Stop cycle

                Mov     CX, MAXSLAVECHANNELS
                Mov     SI, Offset SlaveChannelInformationTable

UpdateMIDI1:
                Test    Word Ptr [SI], 200h
                JZ      UpdateMIDI2
                Cmp     Byte Ptr [SI+36h], 100
                JNE     UpdateMIDI2
                Test    Byte Ptr [SI], 1
                JZ      UpdateMIDI2

                Mov     Word Ptr [SI], 0
                Mov     DI, [SI+38h]    ; Host channel in DI

                Mov     BX, MIDICOMMAND_STOPNOTE
                Call    MIDITranslate

                Test    Byte Ptr [SI+3Ah], 80h
                JNZ     UpdateMIDI2

                Or      Byte Ptr [SI+3Ah], 80h
                And     Byte Ptr [DI], Not 4    ; Signify channel off

UpdateMIDI2:
                Add     SI, SLAVECHANNELSIZE
                Dec     CX
                JNZ     UpdateMIDI1

; Play cycle

                Mov     CX, MAXSLAVECHANNELS
                Mov     SI, Offset SlaveChannelInformationTable

UpdateMIDI3:
                Cmp     Byte Ptr [SI+36h], 100  ; MIDI Instrument?
                JNE     UpdateMIDI4

                Mov     DX, [SI]
                Test    DL, 1
                JZ      UpdateMIDI4

                Mov     AL, [SI+4Ch]
                Mov     Byte Ptr [SI+4Ch], 1
                Mov     [SI+2Ch], AL

                Test    DX, 800h                ; Muted?
                JNZ     UpdateMIDI4

                Mov     DI, [SI+38h]    ; Host channel in DI
                And     Word Ptr [SI], 0111100010001101b

                Test    DH, 1
                JZ      UpdateMIDINoPlayNote

UpdateMIDIPlayNote:                             ; Check if there's a bank select.
                Mov     AX, [SI+3Eh]            ; MIDI Bank
                Cmp     AX, 0FFFFh
                JE      UpdatemIDIBankSelectDone

                Mov     BL, [SI+3Ch]            ; BL = channel
                And     BX, 0FFh
                Add     BX, BX
                Cmp     [MIDIBanks+BX-2], AX
                JE      UpdateMIDIBankSelectDone

                Mov     [MIDIBanks+BX-2], AX
                ShR     BX, 1
                Mov     [MIDIPrograms+BX-1], 0FFh       ; Reset program

                Mov     BX, MIDICOMMAND_BANKSELECT
                Call    MIDITranslate

UpdateMIDIBankSelectDone:               ; Check for a program specification
                Cmp     Byte Ptr [SI+3Dh], 0
                JL      UpdateMIDIProgramDone

                Mov     BL, [SI+3Ch]            ; BL = channel
                And     BX, 0FFh
                Mov     AL, [SI+3Dh]            ; MIDI program
                Cmp     [MIDIPrograms+BX-1], AL
                JE      UpdateMIDIProgramDone

                Mov     [MIDIPrograms+BX-1], AL

                Mov     BX, MIDICOMMAND_PROGRAMSELECT
                Call    MIDITranslate

UpdateMIDIProgramDone:
; Check for MIDI pitch wheel..
                Test    Byte Ptr [ES:2Ch], 64
                JZ      UpdateMIDINoPitchWheel

                Mov     BL, [SI+3Ch]            ; BL = channel
                And     BX, 0FFh
                Add     BX, BX
                Cmp     [MIDIPitch+BX-2], 2000h
                JE      UpdateMIDINoPitchWheel

                Mov     [MIDIPitch+BX-2], 2000h
                Mov     AL, [SI+3Ch]
                Dec     AL
                Or      AL, 0E0h
                Call    MIDISendFilter
                Xor     AL, AL
                Call    MIDISendFilter  ; Reset pitch wheel
                Mov     AL, 40h
                Call    MIDISendFilter

UpdateMIDINoPitchWheel:
                Mov     EAX, [SI+14h]
                Mov     BX, MIDICOMMAND_PLAYNOTE
                Mov     [SI+1Ch], EAX
                Call    MIDITranslate
                Jmp     UpdateMIDINoChangeVolume

UpdateMIDINoPlayNote:                   ; Change in volume?
                Test    DL, 64
                JZ      UpdateMIDINoChangeVolume

                Mov     BX, MIDICOMMAND_CHANGEVOLUME
                Call    MIDITranslate

UpdateMIDINoChangeVolume:
                Test    DH, 80h         ; Pan changed?
                JZ      UpdateMIDINoChangePan

                Mov     BL, [SI+3Ch]            ; BL = channel
                And     BX, 0FFh
                Mov     AL, [SI+37h]            ; FPP

                Cmp     [MIDIPan+BX-1], AL
                JE      UpdateMIDINoChangePan

                Mov     [MIDIPan+BX-1], AL

                Mov     BX, MIDICOMMAND_CHANGEPAN
                Call    MIDITranslate

UpdateMIDINoChangePan:                  ; Pitch changed?
                Test    DL, 32
                JZ      UpdateMIDINoPitchChange

                Mov     BX, MIDICOMMAND_CHANGEPITCH
                Call    MIDITranslate

UpdateMIDINoPitchChange:

UpdateMIDI4:
                Add     SI, SLAVECHANNELSIZE
                Dec     CX
                JNZ     UpdateMIDI3

                Ret

EndP            UpdateMIDI
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            UpdateInstruments
                        Assume DS:Music ; Things to update:
                                        ;  1) Volume envelope
                                        ;  2) Fadeout
                                        ;  3) FinalVolume
                                        ;  4) Vibrato.
                                        ; Turn off channel if
                                        ;  1) Volume envelope is off & VEV = 0 or
                                        ;  2) Fadeout = 0

                Mov     CX, MAXSLAVECHANNELS
                Mov     SI, Offset SlaveChannelInformationTable
                Mov     [DoMIDICycle], 0

UpdateInstruments1:
                Test    Byte Ptr [SI], 1
                JNZ     UpdateInstruments16     ; Channel on!!

UpdateInstruments2:
                Add     SI, SLAVECHANNELSIZE
                Dec     CX
                JNZ     UpdateInstruments1

                Cmp     [DoMIDICycle], 0
                JE      UpdateInstrumentNoMIDICycle

                Call    UpdateMIDI

UpdateInstrumentNoMIDICycle:
                Ret

; UpdateInstruments14:
;                 Jmp     UpdateInstruments5      ; Jump point

UpdateInstruments16:
                Push    CX

                Mov     CX, [SI]

                MovZX   EDI, Word Ptr [SI+30h]            ; ES:DI = instrument

                Cmp     Byte Ptr [SI+33h], 0FFh ; No instrument?
                JE      UpdateInstruments5      ; Prev Intruments14

                Mov     BP, CX
                And     BP, 4                   ; BP = sustain for envelope calls

UpdatePitchEnvelope:
                Test    CH, 40h
                JZ      UpdatePitchEnvelopeApply

                Push    SI
                Push    DI

                Add     SI, 70h
                Add     DI, 1D4h
                Call    UpdateEnvelope

                Pop     DI
                Pop     SI

                JNC     UpdatePitchEnvelopeApply

                And     CH, Not 40h

UpdatePitchEnvelopeApply:
                Test    Byte Ptr [ES:DI+1D4h], 80h
                JZ      UpdatePitchEnvelopePitch

                Cmp     Byte Ptr [SI+36h], 100
                JE      UpdatePanEnvelope

UpdatePitchEnvelopeFilter:
                Mov     BX, [SI+71h]
                SAR     BX, 6           ; Range -128 to +128
                Add     BX, 128         ; Range 0 -> 256
                Cmp     BH, 1
                AdC     BL, -1
                Mov     [SI+3Eh], BL

                Or      CL, 64          ; Recalculate final volume

;                Test    Byte Ptr [SI+3Ah], 80h
;                JNZ     UpdatePanEnvelope
;
;                Call    SetFilterCutoff
;
                Jmp     UpdatePanEnvelope

UpdatePitchEnvelopePitch:
                Mov     BX, [SI+71h]
                SAR     BX, 3
                JZ      UpdatePanEnvelope
IFE USEFPUCODE
                JS      UpdatePitchEnvDown
ENDIF

                Push    DI
                Mov     DI, [SI+38h]

                Call    PitchSlideUpLinear      ; req: DS:SI points to table
                                                ; DS:DI points to host channel
                                                ; BX = magnintude
                Pop     DI
IFE USEFPUCODE
                Jmp     UpdatePostPitchEnvelope

UpdatePitchEnvDown:
                Neg     BX
                Call    PitchSlideDownLinear

UpdatePostPitchEnvelope:
ENDIF
                Or      CL, 32          ; Recalculate freq

UpdatePanEnvelope:
                Test    CH, 20h
                JZ      UpdateVolumeEnvelope

                Or      CL, 2           ; Recalculate pan

                Push    SI
                Push    DI

                Add     SI, 60h
                Add     DI, 182h
                Call    UpdateEnvelope

                Pop     DI
                Pop     SI

                JNC     UpdateVolumeEnvelope

                And     CH, Not 20h

UpdateVolumeEnvelope:
                Test    CH, 10h         ; Volume envelope on?
                JZ      UpdateInstruments3

                Or      CL, 16          ; Recalculate volume

                Push    SI
                Push    DI

                Add     SI, 50h
                Add     DI, 130h
                Call    UpdateEnvelope

                Pop     DI
                Pop     SI

                JC      UpdateVolumeEnvelope1
                Test    CL, 8                   ; Note fade on?
                JNZ     UpdateInstruments13

                                                ; Now, check if loop + sustain
                                                ; off
                Test    BP, BP
                JZ      UpdateInstruments5

                Test    Byte Ptr [ES:DI+130h], 2        ; Normal vol env loop?
                JNZ     UpdateInstruments19
                Jmp     UpdateInstruments5      ; Volume calculation

UpdateVolumeEnvelope1:                          ; Envelope turned off...
                And     CH, Not 10h             ; Turn off envelope flag

                Cmp     Byte Ptr [SI+52h], 0    ; Turn off if end of loop is
                JE      UpdateInstruments17     ; reached

                Jmp     UpdateInstruments19

UpdateInstruments3:
                Test    CL, 8                   ; Note fade??
                JNZ     UpdateInstruments13

                                                ; Also apply fade if No vol env
                                                ; AND sustain off

                Test    CL, 4                   ; Note off issued?
                JZ      UpdateInstruments5

UpdateInstruments19:
                Or      CL, 8

UpdateInstruments13:
                Mov     AX, [ES:DI+14h]         ; AX = fadeout.
                Sub     [SI+26h], AX
                JG      UpdateInstruments4
                Mov     Word Ptr [SI+26h], 0

UpdateInstruments17:                            ; Turn off channel
                Test    Byte Ptr [SI+3Ah], 80h
                JNZ     UpdateInstruments18

                Or      Byte Ptr [SI+3Ah], 80h
                                                ; Host channel exists
                Mov     BX, [SI+38h]
                And     Byte Ptr [BX], Not 4

UpdateInstruments18:
;                Mov     Word Ptr [SI], 200h
;                Pop     CX
;                Jmp     UpdateInstruments2
                Or      CH, 2

UpdateInstruments4:
                Or      CL, 16                  ; Recalc volume flag.

UpdateInstruments5:
                Test    CL, 16
                JZ      UpdateInstrument10
                                                ; Calculate volume
                And     CL, Not 16
                Mov     DX, Word Ptr [SoloSample]       ; DL = sample, DH = inst

                Or      CL, 64                  ; Recalc final volume
                Mov     AL, [SI+21h]            ; Note volume..

                Mul     Byte Ptr [SI+23h]       ; Channel volume
                                                ; AX = (0->4096)
                Cmp     DL, 0FFh
                JE      UpdateInstrumentNoSampleSolo

                Cmp     [SI+36h], DL
                JNE     UpdateInstrumentSolo

UpdateInstrumentNoSampleSolo:
                Cmp     DH, 0FFh
                JE      UpdateInstrumentNoInstrumentSolo

                Cmp     [SI+33h], DH
                JE      UpdateInstrumentNoInstrumentSolo

UpdateInstrumentSolo:
                Or      CH, 8

UpdateInstrumentNoInstrumentSolo:
                Mul     Word Ptr [SI+26h]       ; Fadeout Vol (0->1024)
                                                ; DX:AX = 0->4194304
                SHRD    AX, DX, 7
                                                ; AX = (0->32768)
                Mov     DL, [SI+24h]            ; Sample volume
                Mul     DX                      ; DX:AX = 0->4194304

                SHRD    AX, DX, 7               ; AX = 0->32768

                Mov     DX, Word Ptr [SI+51h]   ; VEV, 0->64*256
                Mul     DX                      ; DX:AX = 0->536870912

                SHRD    AX, DX, 14              ; AX = 0->32768

                Xor     DH, DH
                Mov     DL, GlobalVolume
                Mul     DX                      ; DX:AX = 0->4194304

                SHRD    AX, DX, 7
                Mov     [SI+20h], AH
                Mov     [SI+4Ah], AX

UpdateInstrument10:
                Test    CL, 2                   ; Change in panning?
                JZ      UpdateInstrument20

                And     CL, Not 2
                Or      CH, 128

                Mov     DL, [SI+2Ah]            ; DL = actual pan
                Mov     AL, DL
                Cmp     DL, 100
                JE      UpdateInstrumentSurroundPan

                Mov     AL, 32
                Sub     AL, DL
                CBW
                Xor     AL, AH
                Sub     AL, AH                  ; AL = |32-ActualPan|

                Neg     AL
                Add     AL, 32
                IMul    Byte Ptr [SI+62h]       ; Pan envelope..
                SAR     AX, 5
                Add     AL, DL

                Mov     [SI+25h], AL            ; Value to show..

                Sub     AL, 32
                                        ; Pan = (Pan-32)* Separation/128 + 32
                Mov     AH, [ES:34h]
                ShR     AH, 1                   ; AH = 0->64 (Separation)
                IMul    AH                      ; AX = -2048->+2048
                                                ; ie. AH = -8->+8
                SAR     AX, 6                   ; AL = -32->+32

                Cmp     ReverseChannels, 0
                JE      UpdateInstrumentPan3

                Neg     AL

UpdateInstrumentPan3:
                Add     AL, 32
                Jmp     UpdateInstrumentPan2

UpdateInstrumentSurroundPan:
                Mov     [SI+25h], AL

UpdateInstrumentPan2:
                Mov     [SI+37h], AL

UpdateInstrument20:
                Mov     [SI], CX

                Call    UpdateVibrato

                Cmp     Byte Ptr [SI+36h], 100  ; MIDI?
                JNE     UpdateInstrumentsNoMIDI

                Mov     [DoMIDICycle], 1

UpdateInstrumentsNoMIDI:
                Pop     CX

                Jmp     UpdateInstruments2

EndP            UpdateInstruments
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            UpdateData

                                Assume DS:Music

                Mov     CX, 64
                Mov     AX, PlayMode
                Cmp     AX, 1
                JE      UpdateData_PlayMode1
                JB      UpdateData_PlayMode0
                Jmp     UpdateData_PlayMode2

UpdateData_PlayMode0:                           ; Step through each channel.
                                                ; Check if on/updatemode OK
                Mov     DI, Offset HostChannelInformationTable

UpdateData1:
                Cmp     Byte Ptr [DI+21h], 0
                JE      PlayMode0UpdateVolume1

                Dec     Byte Ptr [DI+21h]               ; Handle counter
                JNZ     UpdateData4

                And     Word Ptr [DI], Not 303h         ; Turn off mode.

UpdateData4:
                Mov     AX, [DI]

                Test    AL, 4                   ; Channel on?
                JZ      UpdateData2

                Test    AH, 1
                JZ      UpdateData2             ; Don't update effect??

PlayMode0UpdateVolume2:
                Push    CX

                Mov     BX, [DI+0Ah]
                And     BX, 7
                Add     BX, BX

                Call    Word Ptr [VolumeEffectTable+BX]

                Pop     CX

                Mov     AL, [DI]

UpdateData2:
                Test    AL, 2
                JNZ     UpdateData3             ; Update effect regardless..

                Test    AL, 4                   ; Channel on?
                JZ      PlayMode0UpdateVolume1

                Test    AL, 1
                JZ      PlayMode0UpdateVolume1  ; Don't update effect??

UpdateData3:                                    ; OK. now handle counter.
                Push    CX

                Mov     BX, [DI+6]
                And     BX, 31
                Add     BX, BX

                Call    Word Ptr [CommandTable+BX]

                Pop     CX

PlayMode0UpdateVolume1:
                Add     DI, HOSTCHANNELSIZE     ; Progress to next channel
                Dec     CX
                JNZ     UpdateData1

                Ret                             ; That's all!

UpdateData_PlayMode1:
                                                ; Pattern stuff..
                Dec     ProcessTick
                Dec     CurrentTick
                JZ      UpdateData_Pattern1

UpdateData_NoNewRow:                            ; OK. call update command.
                Mov     DI, Offset HostChannelInformationTable

UpdateData_NoNewRow1:
                Mov     AX, [DI]                ; AX = host flags.

                Test    AL, 4
                JZ      UpdateData_NoNewRow5

                Test    AH, 1
                JZ      UpdateData_NoNewRow5

UpdateData_NoNewRow4:
                Push    CX

                Mov     BX, [DI+0Ah]
                And     BX, 7
                Add     BX, BX

                Call    Word Ptr [VolumeEffectTable+BX]

                Pop     CX

                Mov     AL, [DI]                ; AX = host flags.

UpdateData_NoNewRow5:
                Test    AL, 3
                JZ      UpdateData_NoNewRow2

                Test    AL, 2
                JNZ     UpdateData_NoNewRow3

                Test    AL, 4
                JZ      UpdateData_NoNewRow2

UpdateData_NoNewRow3:
                Push    CX

                Mov     BX, [DI+6]
                And     BX, 31
                Add     BX, BX

                Call    Word Ptr [CommandTable+BX]

                Pop     CX

UpdateData_NoNewRow2:
                Add     DI, HOSTCHANNELSIZE
                Dec     CX
                JNZ     UpdateData_NoNewRow1

                Ret

UpdateData_Pattern1:                            ; OK... have to update row.
                Mov     AX, CurrentSpeed
                Mov     CurrentTick, AX
                Mov     ProcessTick, AX

                Dec     RowDelay
                JNZ     UpdateEffectData

                Mov     Word Ptr RowDelay, 1

                Mov     AX, ProcessRow
                Inc     AX                      ; Progress to new row.
                Cmp     AX, NumberOfRows
                JB      UpdateData_Pattern2

                Cmp     StopEndOfPlaySection, 0
                JNE     UpdateDataStopSong
                                                ; Wrap row.
                Xor     AX, AX
                XChg    AX, BreakRow

UpdateData_Pattern2:
                Jmp     UpdateData_Song1
;                Mov     ProcessRow, AX
;                Mov     CurrentRow, AX
;
;                                                ; Gotta get note data.
;                Call    UpdateNoteData
;                Ret

UpdateEffectData:
                Mov     DI, Offset HostChannelInformationTable

UpdateEffectData1:
                Test    Byte Ptr [DI], 64
                JZ      UpdateEffectData2

                Mov     AL, [DI+2]
                Test    AL, 88h
                JZ      UpdateEffectData2

                Push    AX
                Push    CX

                And     AL, 88h
                Mov     [DI+2], AL

                Mov     BL, [DI+6]
                And     BX, 31
                Add     BX, BX

                Call    Word Ptr [InitCommandTable + BX] ; Init note

                Pop     CX
                Pop     AX

                Mov     [DI+2], AL

UpdateEffectData2:
                Add     DI, HOSTCHANNELSIZE
                Dec     CX
                JNZ     UpdateEffectData1
                Ret

UpdateData_PlayMode2:
                Dec     ProcessTick
                Dec     CurrentTick
                JNZ     UpdateData_NoNewRow
                                                ; Play song stuff...

                Mov     AX, CurrentSpeed
                Mov     CurrentTick, AX
                Mov     ProcessTick, AX

                Dec     RowDelay
                JNZ     UpdateEffectData

                Mov     Word Ptr RowDelay, 1

                Mov     AX, ProcessRow
                Inc     AX
                Cmp     AX, NumberOfRows
                JB      UpdateData_Song1

                Test    OrderLockFlag, 1
                JNZ     UpdateData_Song5
                                        
                Mov     BX, ProcessOrder        ; Get new pattern.
                Xor     DX, DX
                Inc     BX

UpdateData_Song2:
                Cmp     BX, 100h
                JGE     UpdateData_Song4

                Mov     CL, [ES:BX+100h]        ; CL = next pattern.
                Cmp     CL, 200
                JB      UpdateData_Song3

                Inc     BX
                Cmp     CL, 0FEh
                JE      UpdateData_Song2

                Mov     StopSong, 1

                Cmp     StopEndOfPlaySection, 0
                JE      UpdateData_Song4

UpdateDataStopSong:
                Call    Music_Stop      ; Optionally.. loop!
                Ret

UpdateData_Song4:
                Test    DX, DX
                JNZ     UpdateDataStopSong

                Inc     DX
                Xor     BX, BX
                Jmp     UpdateData_Song2

UpdateData_Song3:
                Mov     ProcessOrder, BX
                Mov     CurrentOrder, BX

                Mov     Byte Ptr CurrentPattern, CL

UpdateData_Song5:
                Xor     AX, AX
                XChg    AX, BreakRow

UpdateData_Song1:
                Mov     ProcessRow, AX
                Mov     CurrentRow, AX

                Call    UpdateNoteData
                Ret

EndP            UpdateData
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetNumberOfSamples Far            ; Returns AX

                Push    CX
                Push    DS
                Push    SI
                Push    ES
                Push    DI

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     ES, SongDataArea
                Mov     DI, 63912-160

                Mov     AX, 99

Music_GetNumberOfSamples1:
                Mov     CX, 80
                Mov     SI, Offset SampleHeader
                RepE    CmpsB
                JNE     Music_GetNumberOfSamples2

                Sub     DI, 160
                Dec     AX
                JNZ     Music_GetNumberOfSamples1

Music_GetNumberOfSamples2:

                Pop     DI
                Pop     ES
                Pop     SI
                Pop     DS
                Pop     CX

                Ret

EndP            Music_GetNumberOfSamples
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetNumberOfInstruments Far            ; Returns AX

                Push    CX
                Push    DS
                Push    SI
                Push    ES
                Push    DI

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     ES, SongDataArea
                Mov     DI, 55912-554*2

                Mov     AX, 99

Music_GetNumberOfInstruments1:
                Mov     CX, 554
                Mov     SI, Offset InstrumentHeader
                RepE    CmpsB
                JNE     Music_GetNumberOfInstruments2

                Sub     DI, 1108
                Dec     AX
                JNZ     Music_GetNumberOfInstruments1

Music_GetNumberOfInstruments2:

                Pop     DI
                Pop     ES
                Pop     SI
                Pop     DS
                Pop     CX

                Ret

EndP            Music_GetNumberOfInstruments
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetSampleHeader Far               ; AX = sample, 1 based

                Mov     SI, AX
                Mov     DS, CS:SongDataArea
                Add     SI, SI

                Mov     SI, [DS:64910+SI]

                Ret

EndP            Music_GetSampleHeader
                        ; Returns DS:SI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetSampleLocation Far             ; AX = sample (1based)
                                                        ; CH = page.
                                                        ; Returns DS:ESI
                                                        ;   ECX = length
                                                        ; Carry if no sample.
                                                        ; Zero set if 8 bit
                Mov     CS:LastSample, AX

                Push    AX
                Push    BX
                Push    DX

                Mov     BX, AX
                Add     BX, BX

                Mov     DS, CS:SongDataArea
                Mov     BX, [64910+BX]
                Test    Byte Ptr [BX+12h], 1
                JZ      Music_GetSampleLocationEnd

Music_GetSampleLocation3:
                Mov     AL, [BX+48h]
                Test    AL, AL
                JZ      Music_GetSampleLocationEnd

                Cmp     AL, 2
                JA      Music_GetSampleLocationEnd
                JE      Music_GetSampleLocation4

                Mov     AX, [BX+4Ah]
                Xor     CL, CL
                ShL     CX, 2
                Add     AX, CX

                Jmp     Music_GetSampleLocation2

Music_GetSampleLocation4:
                Mov     DX, [BX+4Ah]
                Mov     CL, [BX+49h]
                Call    E_MapEMSMemory
                Call    E_GetEMSPageFrame

Music_GetSampleLocation2:
                Xor     ESI, ESI
                Mov     ECX, [BX+30h]

                Test    Byte Ptr [BX+12h], 2    ; Zero flag for 8-bit.

                Mov     DS, AX

Music_GetSampleLocation5:
                ClC
                Jmp     Music_GetSampleLocationEnd2     ; Need to preserve zero flag

Music_GetSampleLocationEnd:
                StC

Music_GetSampleLocationEnd2:
                Pop     DX
                Pop     BX
                Pop     AX

                Ret

EndP            Music_GetSampleLocation

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

; Accessed via Int 3
Proc            Music_UpdateSampleLocation Far          ; Reqs ESI.

                PushAD

                Mov     AX, CS:LastSample
                Mov     ECX, ESI
                ShR     ECX, 8
                ShL     CH, 2

                Call    Music_GetSampleLocation

                PopAD
                IRet

EndP            Music_UpdateSampleLocation

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_FarUpdateSampleLocation Far

                PushF

                PushF
                ClI
                Call    Far Ptr Music_UpdateSampleLocation

                PopF

                Ret

EndP            Music_FarUpdateSampleLocation

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetPlayMode Far

                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     AX, PlayMode
                Mov     BX, CurrentRow
                Mov     CX, CurrentPattern
                Mov     DX, CurrentOrder
                Mov     SI, NumberOfRows

                Pop     DS

                Ret
                Assume DS:Nothing

EndP            Music_GetPlayMode

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetPlayMode2 Far

                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     AX, PlayMode
                Mov     EBX, DWord Ptr CurrentOrder
                Mov     CX, CurrentRow
                ShL     ECX, 16
                Mov     CX, CurrentTick

                Pop     DS
                Ret

EndP            Music_GetPlayMode2
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_PlayPattern Far   ; AX = pattern, BX = number of rows
                                        ; CX = row to start

                Push    DS

                Call    Music_Stop

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     MIDIPitchDepthSent, 0
                Mov     LastMIDIByte, 0FFh

                Mov     CurrentPattern, AX
                Mov     CurrentRow, CX
                Dec     CX
                Mov     NumberOfRows, BX
                Mov     ProcessRow, CX
                Mov     PlayMode, 1

                Pop     DS

                Ret

EndP            Music_PlayPattern
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_PlaySong Far      ; AX = Order

                PushA
                Push    DS

                Call    Music_Stop

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     MIDIPitchDepthSent, 0
                Mov     LastMIDIByte, 0FFh

                Mov     CurrentOrder, AX
                Dec     AX
                Mov     ProcessOrder, AX
                Mov     ProcessRow, 0FFFEh
                Mov     PlayMode, 2

                Call    StartClock

                Mov     BX, MIDICOMMAND_START
                Mov     SI, Offset SlaveChannelInformationTable
                Call    MIDITranslate

                Pop     DS
                PopA
                Ret

EndP            Music_PlaySong

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_PlayPartSong Far          ; AX = order, BX = row.

                Push    AX
                Push    BX
                Push    DS

                Call    Music_Stop

                Mov     CS:NumberOfRows, 200
                Mov     CS:ProcessOrder, AX
                Mov     CS:CurrentOrder, AX
                Mov     CS:CurrentRow, BX
                Dec     BX
                Mov     CS:ProcessRow, BX

                Mov     BX, AX

                Mov     DS, CS:SongDataArea
                MovZX   AX, Byte Ptr [DS:BX+100h]
                Mov     CS:CurrentPattern, AX

                Mov     CS:PlayMode, 2

                Call    StartClock

                Pop     DS
                Pop     BX
                Pop     AX
                Ret

EndP            Music_PlayPartSong

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_KBPlaySong Far

                Xor     AX, AX
                Cmp     CS:PlayMode, 2
                JNE     Music_PlaySong

                Ret

EndP            Music_KBPlaySong

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_StopChannels

                Push    CX
                Push    DS
                Push    SI
                Push    DI

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     CX, 64
                Mov     SI, Offset HostChannelInformationTable

Music_StopChannels1:
                Mov     Word Ptr [SI], 0
                Mov     Word Ptr [SI+26h], 0
                Add     SI, HOSTCHANNELSIZE
                Loop    Music_StopChannels1

                Mov     CX, MAXSLAVECHANNELS
                Mov     SI, Offset SlaveChannelInformationTable

Music_StopChannels2:
                Test    Byte Ptr [SI], 1
                JZ      Music_StopChannelsNoMIDI

                Cmp     Byte Ptr [SI+36h], 100
                JNE     Music_StopChannelsNoMIDI

                PushF
                ClI
                Mov     DI, [SI+38h]
                Mov     BX, MIDICOMMAND_STOPNOTE
                Call    MIDITranslate
                PopF

Music_StopChannelsNoMIDI:
                Mov     Word Ptr [SI], 200h
                Add     SI, SLAVECHANNELSIZE
                Loop    Music_StopChannels2

                Pop     DI
                Pop     SI
                Pop     DS
                Pop     CX

                Ret

EndP            Music_StopChannels

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_Stop Far

                PushA
                PushF
                Push    DS
                Push    ES

                CLI

                Push    CS
                Pop     DS
                        Assume DS:Music

; Turn off MIDI channels first.

                Test    OrderLockFlag, 1
                JZ      Music_StopNoOrderLocked

                Call    Music_ToggleOrderUpdate

Music_StopNoOrderLocked:
                Mov     CX, MAXSLAVECHANNELS
                Mov     SI, Offset SlaveChannelInformationTable

Music_StopMIDI1:
                Test    Byte Ptr [SI], 1
                JZ      Music_StopNoMIDI

                Cmp     Byte Ptr [SI+36h], 100
                JNE     Music_StopNoMIDI

                Mov     DI, [SI+38h]
                Mov     BX, MIDICOMMAND_STOPNOTE
                Call    MIDITranslate

Music_StopNoMIDI:
                Add     SI, SLAVECHANNELSIZE
                Loop    Music_StopMIDI1

                Mov     BX, MIDICOMMAND_STOP            ; Stop
                Mov     SI, Offset SlaveChannelInformationTable
                Call    MIDITranslate

                Mov     PlayMode, 0

                Mov     DecodeExpectedPattern, 0FFFEh
                Mov     DecodeExpectedRow, 0FFFEh
                Mov     RowDelay, 1
                Mov     CurrentRow, 0
                Mov     CurrentOrder, 0
                Mov     CurrentTick, 1
                Mov     BreakRow, 0

                Push    CX
                Push    DS
                Push    SI
                Push    DI

                Push    CS
                Pop     ES

                Mov     DI, Offset MIDIPrograms
                Mov     CX, 32
                Mov     AX, 0FFFFh
                Rep     StosW

                Mov     DI, Offset HostChannelInformationTable
                Mov     DS, SongDataArea
                        Assume DS:Nothing

                Mov     SI, 40h
                Mov     DX, 040h
                Xor     AX, AX

Music_Clear1:
                Mov     CX, 16
                Rep     StosW
                Mov     AL, DH
                StosW

                Xor     AX, AX
                Mov     CX, 6
                Rep     StosW

                Mov     AH, [SI+40h]
                LodsB
                And     AL, 7Fh
                StosW
                Xor     AX, AX
                Mov     CX, 16
                Rep     StosW

                Inc     DH
                Dec     DL
                JNZ     Music_Clear1

                                                ; Now clear SlaveChannel
                Mov     DX, MAXSLAVECHANNELS

Music_Clear2:
                Mov     AX, 200h
                StosW
                Mov     CX, SLAVECHANNELSIZE/2-1
                Xor     AX, AX
                Rep     StosW
                Dec     DX
                JNZ     Music_Clear2

                Push    DS
                Pop     ES                      ; ES = SongDataArea

                Pop     DI
                Pop     SI
                Pop     DS
                Pop     CX
                        Assume DS:Music

                Mov     AX, [ES:32h]            ; AL = speed, AH = tempo
                Mov     BX, [ES:30h]            ; BL = globalvol

                Xor     DX, DX
                Mov     DL, AL
                Mov     GlobalVolume, BL
                Mov     CurrentSpeed, DX
                Mov     ProcessTick, DX
                Mov     Tempo, AH

                Call    Music_InitTempo
                Call    MIDI_ClearTable

                Pop     ES
                Pop     DS
                PopF
                PopA

                Ret

EndP            Music_Stop
                Assume DS:Nothing, ES:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_UpdatePatternOffset Far

                Mov     CS:DecodeExpectedPattern, 0FFFEh

                Ret

EndP            Music_UpdatePatternOffset

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_PlayNote Far              ; DS:SI points to 5-note struct
                                                ; AX = channel
                                                ; DH = +32 means ignore mute
                                                ;      settings
                                                ; DH = +128 means to use central
                                                ;       pan and max volume.
                PushAD
                Push    DS
                Push    ES

                Mov     AH, HOSTCHANNELSIZE
                Mul     AH
                Mov     DI, Offset HostChannelInformationTable
                Add     DI, AX

                Mov     ES, CS:SongDataArea

                Xor     DL, DL                  ; DL = mask

                ClI

                LodsB
                Cmp     AL, NONOTE
                JE      Music_PlayNote1

                Or      DL, 1
                Mov     [CS:DI+3], AL

Music_PlayNote1:
                LodsB
                Test    AL, AL
                JZ      Music_PlayNote2

                Or      DL, 2
                Mov     [CS:DI+4], AL

Music_PlayNote2:
                LodsB
                Cmp     AL, 0FFh
                JE      Music_PlayNote3

                Or      DL, 4
                Mov     [CS:DI+5], AL

Music_PlayNote3:
                LodsW
                Test    AX, AX
                JZ      Music_PlayNote4

                Or      DL, 8

Music_PlayNote4:
                Push    CS
                Pop     DS
                        Assume DS:Music
                        
                Push    DX

                And     DH, 7Fh
                Mov     [DI+6], AX
                Mov     [DI+8], AX
                Mov     [DI+2], DL
                And     Word Ptr [DI], Not (3+32+64+256)
                Or      Byte Ptr [DI], DH    ; Now for command update count

                Mov     AX, CurrentSpeed
                Mov     [DI+21h], AL

                Call    PreInitCommand

                Pop     DX

                Test    Byte Ptr [DI], 4
                JZ      Music_PlayNote5

                Test    DH, 128
                JZ      Music_PlayNote5

                Mov     SI, [DI+24h]
                Mov     Word Ptr [SI+2Ah], 2020h; Pan and pan set.
                Mov     Byte Ptr [SI+23h], 40h  ; Full channel volume.

Music_PlayNote5:
                Mov     DecodeExpectedRow, 0FFFEh
                StI

                Pop     ES
                Pop     DS
                PopAD

                Ret

EndP            Music_PlayNote
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_PlaySample Far
                                                        ; AL = Note
                                                        ; AH = sample number
                                                        ; CX = channel.

                PushAD
                Push    DS
                Push    ES

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     ES, SongDataArea

                Push    AX

                Mov     AX, HOSTCHANNELSIZE
                Mul     CX
                Add     AX, Offset HostChannelInformationTable
                Mov     DI, AX

                Pop     AX

;                Mov     DI, Offset HostChannelInformationTable

                ClI

                Mov     Byte Ptr [DI+2], 3      ; Note & Sample
                Mov     [DI+3], AL              ; Note...
                Mov     Byte Ptr [DI+4], 0FFh
                Mov     [DI+0Eh], AX
                Or      Word Ptr [DI], 8020h

                Call    InitNoCommand

                Test    Byte Ptr [DI], 4
                JZ      Music_PlaySample1

                Mov     SI, [DI+24h]
                Mov     Word Ptr [SI+2Ah], 2020h
                Mov     Byte Ptr [SI+23h], 40h  ; Full channel volume.
                Mov     Byte Ptr [SI+3Bh], 0    ; Note cut.
                Mov     Word Ptr [SI+28h], 0

Music_PlaySample1:
                And     Word Ptr [DI], Not 8000h

                Mov     DecodeExpectedRow, 0FFFEh
                StI

                Pop     ES
                Pop     DS
                PopAD

                Ret

EndP            Music_PlaySample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetHostChannelInformationTable Far

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     SI, Offset HostChannelInformationTable

                Ret

EndP            Music_GetHostChannelInformationTable
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetSlaveChannelInformationTable Far

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     SI, Offset SlaveChannelInformationTable
                Mov     CX, MAXSLAVECHANNELS

                Ret

EndP            Music_GetSlaveChannelInformationTable
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_NextOrder Far

                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Music

                Cmp     PlayMode, 2
                JNE     Music_NextOrder1

                Mov     PlayMode, 0
                Call    Music_StopChannels
                Mov     ProcessRow, 0FFFEh
                Mov     CurrentTick, 1
                Mov     RowDelay, 1
                Mov     PlayMode, 2

Music_NextOrder1:
                Pop     DS
                Ret

EndP            Music_NextOrder
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_LastOrder Far

                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Music

                Cmp     PlayMode, 2
                JNE     Music_NextOrder1

                Mov     AX, ProcessOrder
                Cmp     AX, 0
                JLE     Music_LastOrder1

                ClI

                Mov     PlayMode, 0
                Call    Music_StopChannels
                Sub     AX, 2
                Mov     ProcessOrder, AX
                Mov     ProcessRow, 0FFFEh
                Mov     CurrentTick, 1
                Mov     RowDelay, 1
                Mov     PlayMode, 2

                StI

Music_LastOrder1:
                Pop     DS
                Ret

EndP            Music_LastOrder
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_SetGlobalVolume Far

                Push    CX
                Push    DS
                Push    SI

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     GlobalVolume, AL
                Call    RecalculateAllVolumes

                Pop     SI
                Pop     DS
                Pop     CX
                Ret

EndP            Music_SetGlobalVolume
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_MuteChannel Far           ; AX = channel number

                Push    AX
                Push    CX
                Push    DS
                Push    SI
                Push    DI

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     CX, NumChannels
                Mov     SI, Offset SlaveChannelInformationTable

Music_MuteChannel1:
                Test    Byte Ptr [SI], 1
                JZ      Music_MuteChannel2

                Mov     AH, [SI+3Ah]
                And     AH, 07Fh
                Cmp     AH, AL
                JNE     Music_MuteChannel2

                Or      Word Ptr [SI], 840h

Music_MuteChannel2:
                Add     SI, SLAVECHANNELSIZE
                Loop    Music_MuteChannel1

                Pop     DI
                Pop     SI
                Pop     DS
                Pop     CX
                Pop     AX
                Ret

EndP            Music_MuteChannel
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_UnmuteChannel Far           ; AX = channel number

                Push    AX
                Push    CX
                Push    DS
                Push    SI
                Push    DI

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     CX, NumChannels
                Mov     Word Ptr [SoloSample], 0FFFFh
                Mov     SI, Offset SlaveChannelInformationTable

Music_UnmuteChannel1:
                Test    Byte Ptr [SI], 1
                JZ      Music_UnmuteChannel2

                Mov     AH, [SI+3Ah]
                And     AH, 07Fh
                Cmp     AH, AL
                JNE     Music_UnmuteChannel2

Comment ~
Music_UnmuteChannel3:
                Test    DL, DL
                JS      Music_UnmuteChannel5

                Cmp     [SI+36h], DL
                JE      Music_UnmuteChannel2

Music_UnmuteChannel4:
                Test    DH, DH
                JS      Music_UnmuteChannel5

                Cmp     [SI+33h], DH
                JE      Music_UnmuteChannel2

Music_UnmuteChannel5:
~
                And     Byte Ptr [SI+1], Not 8
                Or      Byte Ptr [SI], 64

Music_UnmuteChannel2:
                Add     SI, SLAVECHANNELSIZE
                Loop    Music_UnmuteChannel1

                Pop     DI
                Pop     SI
                Pop     DS
                Pop     CX
                Pop     AX
                Ret

EndP            Music_UnmuteChannel
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ToggleChannel Far         ; AX = channel number.

                Push    BX
                Push    DS

                Mov     BX, AX
                Mov     DS, CS:SongDataArea

                Test    Byte Ptr [BX+40h], 80h
                JZ      Music_ToggleChannel1

                And     Byte Ptr [BX+40h], 7Fh
                Call    Music_UnmuteChannel

                Mov     [CS:MuteChannelTable+BX], 0

                Pop     DS
                Pop     BX
                Ret

Music_ToggleChannel1:                   ; Mute channel
                Xor     [CS:MuteChannelTable+BX], 1
                Or      Byte Ptr [BX+40h], 80h
                Call    Music_MuteChannel

                Pop     DS
                Pop     BX
                Ret

EndP            Music_ToggleChannel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_UnmuteAll Far

                Push    BX
                Push    CX
                Push    DX
                Push    DS
                Push    SI

                Jmp     Music_SoloChannel3


Proc            Music_SoloChannel Far           ; AX = channel

                Push    BX
                Push    CX
                Push    DX
                Push    DS
                Push    SI
                                                ; Check & count whether any playing.

                Mov     BX, AX

                Mov     DS, CS:SongDataArea
                Mov     SI, 40h
                Mov     CX, SI
                Mov     DX, CX

Music_SoloChannel1:
                LodsB
                ShL     AL, 1
                SbB     DX, 0

                Loop    Music_SoloChannel1
                                                ; DX = num playing.
                Cmp     DX, 1
                JNE     Music_SoloChannel6

Music_SoloChannel2:                             ; check whether it's the current
                Test    Byte Ptr [BX+40h], 80h
                JZ      Music_SoloChannel3

Music_SoloChannel6:
                Mov     CX, 64                  ; 64 channel to step through
                                                ; turn 'em all off.
Music_SoloChannel7:
                Mov     SI, CX
                Dec     SI
                Cmp     SI, BX
                JE      Music_SoloChannel9

                Test    Byte Ptr [SI+40h], 80h
                JNZ     Music_SoloChannel8

Music_SoloChannel10:
                Mov     AX, SI
                Call    Music_ToggleChannel

Music_SoloChannel8:
                Loop    Music_SoloChannel7
                Jmp     Music_SoloChannel11

Music_SoloChannel9:
                Test    Byte Ptr [SI+40h], 80h
                JZ      Music_SoloChannel8
                Jmp     Music_SoloChannel10

Music_SoloChannel3:                             ; solo pressed on already soloed
                                                ; channel -> turn everything on.
                Mov     CX, 64

Music_SoloChannel4:
                Mov     BX, CX
                Dec     BX
                Cmp     [CS:MuteChannelTable+BX], 1
                JNE     Music_SoloChannel5

                Mov     AX, BX
                Call    Music_ToggleChannel

Music_SoloChannel5:
                Loop    Music_SoloChannel4

Music_SoloChannel11:
                Pop     SI
                Pop     DS
                Pop     DX
                Pop     CX
                Pop     BX

                Ret

EndP            Music_SoloChannel
EndP            Music_UnmuteAll

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_InitMuteTable Far

                Push    AX
                Push    CX
                Push    ES
                Push    DI

                Mov     DI, Offset MuteChannelTable
                Mov     CX, 32
                Push    CS
                Pop     ES

                Xor     AX, AX
                Rep     StosW

                Mov     DWord Ptr [CS:SoloSample], 0FFFFh

                Pop     DI
                Pop     ES
                Pop     CX
                Pop     AX

                Ret

EndP            Music_InitMuteTable

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_InitStereo Far

                Push    DS

                Mov     DS, CS:SongDataArea
                Mov     AL, [DS:2Ch]
                And     AL, 1

                Call    [DriverSetStereo]

                Push    CS
                Pop     DS
                Call    RecalculateAllVolumes

                Pop     DS
                Ret

EndP            Music_InitStereo

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_IncreaseSpeed Far ; Returns AX = speed

                Mov     AX, CS:CurrentSpeed
                Cmp     AX, 1
                JE      Music_IncreaseSpeed1

                Dec     AX
                Mov     CS:CurrentSpeed, AX
                Push    DS

                Mov     DS, SongDataArea
                Mov     [DS:32h], AL

                Pop     DS

Music_IncreaseSpeed1:
                Ret

EndP            Music_IncreaseSpeed

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_DecreaseSpeed Far

                Mov     AX, CS:CurrentSpeed
                Cmp     AX, 0FFh
                JAE     Music_DecreaseSpeed1

                Inc     AX
                Mov     CS:CurrentSpeed, AX
                Push    DS

                Mov     DS, SongDataArea
                Mov     [DS:32h], AL

                Pop     DS


Music_DecreaseSpeed1:
                Ret

EndP            Music_DecreaseSpeed

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_SetSoundCard Far          ; AL contains sound card num

                Xor     AH, AH

                Push    EBX

                Mov     BX, CS
                ShL     EBX, 16

                Mov     BX, AX
                Add     BX, BX
                Mov     BX, [CS:DriverSoundCard+BX]
                Add     BX, BX
                Mov     BX, [CS:DriverNameTable+BX]
                Mov     [CS:DriverName], EBX

                Pop     EBX

                Ret

EndP            Music_SetSoundCard

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_SetSoundCardDriver Far

                Mov     Word Ptr [CS:DriverName], SI
                Mov     Word Ptr [CS:DriverName+2], DS

                Ret

EndP            Music_SetSoundCardDriver

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_SetDMA Far

                Xor     AH, AH
                Mov     DMA, AX

                Ret

EndP            Music_SetDMA

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_SetMixSpeed Far
                Assume DS:Nothing

                Mov     CmdLineMixSpeed, CX

                Ret

EndP            Music_SetMixSpeed

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_SetIRQ Far
                Assume DS:Nothing

                Mov     IRQ, CX

                Ret

EndP            Music_SetIRQ

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_SetAddress Far

                Mov     BasePort, DX

                Ret

EndP            Music_SetAddress

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetDisplayVariables Far

                Mov     AX, CS:CurrentSpeed
                MovZX   BX, CS:Tempo
                MovZX   CX, CS:GlobalVolume

                Ret

EndP            Music_GetDisplayVariables

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_AssignSampleToInstrument Far           ; BX = sample num
                                                             ; returns AX

                Push    CX DX DS SI ES DI

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     ES, SongDataArea

; Check for sample-number's instrument first.
                Mov     AX, 554
                Mul     BX
                Mov     DI, AX
                Add     DI, 512

                LEA     AX, [BX+1]
                Mov     SI, Offset InstrumentHeader
                Mov     CX, 554

                RepE    CmpsB
                JE      Music_AssignSampleToInstrument4

; Search
                Mov     CX, 99
                Mov     DI, 512         ; Points to first inst.
                Mov     AX, 1

Music_AssignSampleToInstrument1:
                Push    CX

                Mov     SI, Offset InstrumentHeader
                Mov     CX, 554

                RepE    CmpsB
                JE      Music_AssignSampleToInstrument2

                Add     DI, CX
                Pop     CX
                Inc     AX
                Loop    Music_AssignSampleToInstrument1

                StC

Music_AssignSampleToInstrumentEnd:
                Pop     DI ES SI DS DX CX
                Ret

Music_AssignSampleToInstrument2:
                Pop     CX              ; Clear the stack

Music_AssignSampleToInstrument4:
IF NETWORKENABLED
                Call    Network_GetSendQueue
                JZ      Music_AssignSampleNetwork

                Mov     SI, AX
                Mov     AX, 400h
                StosW
                Mov     AX, SI
                Dec     AX
                StosB

Music_AssignSampleNetwork:
                Call    Network_FinishedSendQueue
ENDIF

                Push    ES
                Pop     DS

                Sub     DI, 554-20h     ; Points to name
                Mov     SI, BX
                Mov     SI, [64912+SI+BX]
                Add     SI, 14h

                Mov     CX, 26
                Rep     MovsB

                Add     DI, 7

                                        ; Now to fill in table.
                Mov     CX, 120
                Inc     BX

Music_AssignSampleToInstrument3:
                Mov     [DI], BL
;                Add     DI, 2
                ScasW
                Loop    Music_AssignSampleToInstrument3

                ClC
                Jmp     Music_AssignSampleToInstrumentEnd

EndP            Music_AssignSampleToInstrument
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_SetLimit Far

                Mov     CS:CmdLineNumChannels, CX
                Ret

EndP            Music_SetLimit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ReverseChannels Far

                Mov     CS:ReverseChannels, 1
                Ret

EndP            Music_ReverseChannels

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_IncreaseVolume Far

                Push    CX
                Push    DS
                Push    SI

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     AL, GlobalVolume
                And     AX, 0FFh
                Cmp     AX, 128
                JAE     Music_IncreaseVolume1

                Inc     AX
                Mov     GlobalVolume, AL
                Call    RecalculateAllVolumes

Music_IncreaseVolume1:
                Pop     SI
                Pop     DS
                Pop     CX

                Ret

EndP            Music_IncreaseVolume
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_DecreaseVolume Far

                Push    CX
                Push    DS
                Push    SI

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     AL, GlobalVolume
                And     AX, 0FFh
                JZ      Music_DecreaseVolume1

                Dec     AX
                Mov     GlobalVolume, AL
                Call    RecalculateAllVolumes

Music_DecreaseVolume1:
                Pop     SI
                Pop     DS
                Pop     CX

                Ret

EndP            Music_DecreaseVolume
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_RegetLoopInformation Far

                Push    AX
                Push    BX
                Push    CX
                Push    DX

                Push    DS
                Push    SI
                Push    ES

                Push    CS
                Pop     DS                      ; DS setup
                        Assume DS:Music

                Mov     ES, SongDataArea

                Mov     CX, NumChannels
                Mov     SI, Offset SlaveChannelInformationTable

Music_RegetLoopInformation1:
                Test    Byte Ptr [SI], 1
                JZ      Music_RegetLoopInformation2

                Push    CX
                ClI

                Call    GetLoopInformation

                Or      Byte Ptr [SI], 40h

                StI
                Pop     CX

Music_RegetLoopInformation2:
                Add     SI, SLAVECHANNELSIZE
                Loop    Music_RegetLoopInformation1



                Pop     ES
                Pop     SI
                Pop     DS

                Pop     DX
                Pop     CX
                Pop     BX
                Pop     AX

                Ret

EndP            Music_RegetLoopInformation
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ResetSoundCardMemory Far

                Jmp     [DriverResetMemory]

EndP            ResetSoundCardMemory

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_SoundCardLoadSample Far           ; AX = sample number
                                                        ; (1 based)
                                                        ; Carry set if insuf mem
                PushA
                Call    [DriverLoadSample]
                PushF

                JC      Music_SoundCardLoadSample1

                Mov     CX, 2
                Mov     DI, Offset O1_OutOfSoundCardMemoryList
                Call    M_Object1List

Music_SoundCardLoadSample1:
                PopF
                PopA
                Ret

EndP            Music_SoundCardLoadSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_SoundCardLoadAllSamples Far

                PushAD
                Push    DS

                Call    Music_Stop
                Call    S_SaveScreen

                Push    30
                Push    28
                Push    50
                Push    30
                Push    3
                Call    S_DrawBox
                Add     SP, 10

                Push    CS
                Pop     DS

                Mov     DI, (32+29*80)*2
                Mov     SI, Offset PrepareSamplesMsg
                Mov     AH, 20h
                Call    S_DrawString

                Call    S_UpdateScreen

                Call    ResetSoundCardMemory

                Mov     AX, 1

Music_SoundCardLoadAllSamples1:
                Call    Music_SoundCardLoadSample
                JNC     Music_SoundCardLoadAllSamples2

                Inc     AX
                Cmp     AX, 100
                JBE     Music_SoundCardLoadAllSamples1

Music_SoundCardLoadAllSamples3:
                Call    S_RestoreScreen

Music_SoundCardLoadAllSamples2:
                Pop     DS
                PopAD

                Mov     AX, 1
                Ret

EndP            Music_SoundCardLoadAllSamples
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetFreeSoundCardMemory Far

                Call    [DriverGetStatus]
                Ret

EndP            Music_GetFreeSoundCardMemory

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetNumChannels Far

                Mov     AX, CS:NumChannels

                Ret

EndP            Music_GetNumChannels

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetPitchTable Far ; Returns ES:DI to pitch table

                Push    CS
                Pop     ES
                Mov     DI, Offset PitchTable

                Ret

EndP            Music_GetPitchTable

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ToggleReverse Far

                Push    CS
                Pop     DS
                        Assume DS:Music

                Xor     ReverseChannels, 1
                Call    ReCalculateAllVolumes
                Mov     SI, Offset ReverseMsg
                Call    SetInfoLine

                Ret

EndP            Music_ToggleReverse
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_PatternStorage Far

                Mov     CS:PatternStorage, AL
                Ret

EndP            Music_PatternStorage

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_InitMixTable Far

                Push    AX
                Push    DS

                Xor     AX, AX
                Mov     DS, CS:SongDataArea
                Mov     AL, Byte Ptr [DS:31h]           ; AL = 0->128

                Call    [DriverSetMixVolume]

                Pop     DS
                Pop     AX
                Ret

EndP            Music_InitMixTable

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetTempo Far

                Xor     BH, BH
                Mov     BL, CS:Tempo

                Ret

EndP            Music_GetTempo

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetLastChannel Far        ; Returns AX

                Push    DS

                Mov     DS, CS:SongDataArea
                Xor     SI, SI
                Mov     CX, 64
                Xor     AX, AX
                Xor     DX, DX

Music_GetLastChannel1:
                Mov     BL, [SI+40h]
                ShR     BL, 7
                Xor     BL, [CS:MuteChannelTable+SI]
                JNZ     Music_GetLastChannel2

                Mov     AX, DX

Music_GetLastChannel2:
                Inc     DX
                Inc     SI
                Loop    Music_GetLastChannel1

                Pop     DS
                Ret

EndP            Music_GetLastChannel

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetDriverScreen Far

                Jmp     [DriverSoundCardScreen]

EndP            Music_GetDriverScreen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetDriverVariable Far

                Jmp     [DriverGetVariable]

EndP            Music_GetDriverVariable

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_SetDriverVariable Far

                Jmp     [DriverSetVariable]

EndP            Music_SetDriverVariable

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_SetNextOrder Far

                Dec     AX
                Mov     CS:ProcessOrder, AX

                Ret

EndP            Music_SetNextOrder

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetDelay Far

                ClI

                Xor     DX, DX
                Mov     CX, CS:PlayMode
                Test    CX, CX
                JZ      Music_GetDelay2

                Mov     DX, CS:CurrentSpeed
                Cmp     AX, CS:CurrentRow
                JNE     Music_GetDelay3

                Sub     DX, CS:ProcessTick
                JZ      Music_GetDelay2

                Cmp     DX, 0Fh
                JAE     Music_GetDelay4
                Jmp     Music_GetDelay1

Music_GetDelay3:
                Dec     DX
                Cmp     DX, 0Fh
                JBE     Music_GetDelay1

Music_GetDelay4:
                Mov     DX, 0Fh

Music_GetDelay1:
                ShL     DX, 8
                Or      DX, 'S'-'@'+0D000h

Music_GetDelay2:
                StI
                Ret

EndP            Music_GetDelay

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

StopSong        DB      0
TimerCounter    DD      0
TotalTimer      DD      0
TotalTimerHigh  DD      0
PleaseWaitMsg   DB      "Please Wait...", 0

Proc            InternalTimer Far

                PushAD

                Mov     EAX, 0C214h
                Mov     DX, 16h         ; Ticks = (1193181/(2*0.4))/Tempo
                Div     BX
                Add     EAX, EAX
                Mov     CS:TimerCounter, EAX

                PopAD
                Ret

EndP            InternalTimer

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_TimeSong Far              ; Time song!

                Push    CS
                Pop     DS
                        Assume DS:Music

                Call    S_SaveScreen

                Mov     AL, 1
                Call    S_SetDirectMode
                Call    S_DrawSmallBox

                Mov     SI, Offset PleaseWaitMsg
                Mov     AH, 20h
                Mov     DI, (33+26*80)*2
                Call    S_DrawString

                Call    Music_Stop

                Mov     CX, 0FFFFh

Music_TimeSong1:
                In      AL, 21h                 ; Delay mechanism
                In      AL, 0A1h                 ; Delay mechanism
                Loop    Music_TimeSong1

                Mov     StopSong, 0
                Mov     TotalTimer, 0
                Mov     TotalTimerHigh, 0

                ClI
                In      AL, 0A1h
                Mov     AH, AL
                In      AL, 21h
                Push    AX

                Mov     AL, 0FFh
                Out     0A1h, AL
                Out     21h, AL

                Push    DWord Ptr [DriverSetTempo]

                Mov     AX, CS
                ShL     EAX, 16
                Mov     AX, Offset InternalTimer
                Mov     [DriverSetTempo], EAX

                Push    Word Ptr [NumChannels]

                Mov     ES, SongDataArea

                Push    Word Ptr [ES:2Ch]
                And     Byte Ptr [ES:2Ch], Not 4

                Xor     AX, AX
                Call    Music_PlaySong

Music_TimeSong3:
                        Assume DS:Nothing
                Call    Update

                Cmp     CS:StopSong, 0
                JNE     Music_TimeSong4

                Mov     EAX, CS:TimerCounter
                Add     CS:TotalTimer, EAX
                AdC     CS:TotalTimerHigh, 0
                Jmp     Music_TimeSong3

Music_TimeSong4:
                Call    Music_Stop

                Mov     ES, CS:SongDataArea

                Pop     Word Ptr [ES:2Ch]
                Pop     Word Ptr [CS:NumChannels]
                Pop     DWord Ptr [CS:DriverSetTempo]

                Pop     AX
                Out     21h, AL
                Mov     AL, AH
                Out     0A1h, AL

                StI

                Mov     AL, 0
                Call    S_SetDirectMode

                Call    S_RestoreScreen

                Mov     CX, 0FFFFh
                Mov     DI, Offset O1_ShowTime
                Call    M_Object1List

                Mov     AX, 1
                Ret

EndP            Music_TimeSong

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ShowTime Far

                Call    S_GetDestination

                Mov     EDX, CS:TotalTimerHigh
                Mov     EAX, CS:TotalTimer

                SHRD    EAX, EDX, 16

                Mov     DI, (43+27*80)*2
                Call    D_ShowTime

                Ret

EndP            Music_ShowTime

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetPatternLength Far

                Mov     AX, CS:NumberOfRows
                Ret

EndP            Music_GetPatternLength

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_SaveMIDIConfig Far

                Call    D_GotoStartingDirectory

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     AH, 3Ch
                Xor     CX, CX
                Mov     DX, Offset MIDIConfigFileName
                Int     21h
                JC      Music_SaveMIDIConfig1

                Mov     BX, AX

                Mov     AH, 40h
                Mov     DS, CS:MIDIDataArea
                Xor     DX, DX
                Mov     CX, (128+16+9)*32
                Int     21h

                Mov     AH, 3Eh
                Int     21h

Music_SaveMIDIConfig1:
                Xor     AX, AX
                Ret

EndP            Music_SaveMIDIConfig
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_GetMIDIDataArea Far

                Mov     DS, CS:MIDIDataArea
                Ret

EndP            Music_GetMIDIDataArea

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ToggleOrderUpdate Far

                Push    CS
                Pop     DS
                        Assume DS:Music

                Mov     SI, Offset OrderUpdateEnabledMsg
                Xor     OrderLockFlag, 1
                JZ      Music_ToggleOrderUpdate1

                Mov     SI, Offset OrderUpdateDisabledMsg

Music_ToggleOrderUpdate1:
                Call    SetInfoLine

                Ret

EndP            Music_ToggleOrderUpdate
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ToggleSoloInstrument Far

                Mov     SI, Offset SoloInstrumentMsg
                Mov     DI, Offset SoloInstrument
                Mov     BP, 1
                Jmp     Music_ToggleSolo

EndP            Music_ToggleSoloInstrument

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ToggleSoloSample Far

                Mov     SI, Offset SoloSampleMsg
                Mov     DI, Offset SoloSample
                Xor     BP, BP

EndP            Music_ToggleSoloSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Music_ToggleSolo Far

                Push    CS
                Pop     DS
                        Assume DS:Music

                Call    PE_GetLastInstrument            ; Returns BX

                Mov     AX, BX
                Add     BX, BP

                Cmp     [DI], BL
                Mov     Word Ptr [SoloSample], 0FFFFh
                JE      Music_ToggleSolo1

                Inc     AX
                Mov     Byte Ptr [DI], BL

                Jmp     Music_ToggleSolo2

Music_ToggleSolo1:
                Mov     SI, Offset UnsoloMsg

Music_ToggleSolo2:
                Call    SetInfoLine

                Mov     CX, NumChannels
                Mov     SI, Offset SlaveChannelInformationTable
                Xor     BX, BX

                Mov     ES, SongDataArea

Music_ToggleSolo3:
                Or      Byte Ptr [SI], 18
                Mov     BL, [SI+3Ah]            ; BX = channel

                Test    Byte Ptr [ES:BX+40h], 80h
                JNZ     Music_ToggleSolo4

                And     Word Ptr [SI], Not 800h

Music_ToggleSolo4:
                Add     SI, SLAVECHANNELSIZE
                Dec     CX
                JNZ     Music_ToggleSolo3

                Call    RecalculateAllVolumes

                Mov     AX, 1
                Ret

EndP            Music_ToggleSolo
                Assume DS:Nothing


;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

EndS

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

End
