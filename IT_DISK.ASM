;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Disk Module                                                                 ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

include switch.inc
include network.inc

                        Jumps
                        .386

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Externals                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Segment         Object1 BYTE Public 'Data'
EndS

Segment         Pattern BYTE Public 'Code'
                Extrn   BaseOctave:Byte
                Extrn   RowHilight1:Byte
                Extrn   RowHilight2:Byte
EndS

Segment         Pattern BYTE Public 'Code'
                Extrn   PatternDataArea:Word
EndS

Segment         Music BYTE Public 'Code'
EndS

                Extrn   Display_GetDisplayWindowData:Far

                Extrn   E_UnInitEMS:Far
                Extrn   E_MapEMSMemory:Far
                Extrn   E_GetEMSPageFrame:Far

                Extrn   Glbl_F3:Far
                Extrn   Glbl_F4:Far

                Extrn   I_GetSampleOffset:Far
                Extrn   I_GetInstrumentOffset:Far
                Extrn   I_ClearTables:Far
                Extrn   I_GetPresetEnvelopeOffset:Far

                Extrn   K_UnInitKeyBoard:Far
                Extrn   K_IsAnyKeyDown:Far
                Extrn   K_ClearKeyBoardQueue:Far
                Extrn   K_GetKey:Far

                Extrn   M_FunctionDivider:Far
                Extrn   M_Object1List:Far

                Extrn   Music_PlayNote:Far
                Extrn   Music_PlaySample:Far
                Extrn   Music_ReleaseAllPatterns:Far
                Extrn   Music_ReleaseAllSamples:Far
                Extrn   Music_ReleaseSample:Far
                Extrn   Music_GetSongSegment:Far
                Extrn   Music_AllocateSample:Far
                Extrn   Music_ClearAllSampleNames:Far
                Extrn   Music_GetNumberOfSamples:Far
                Extrn   Music_GetNumberOfInstruments:Far
                Extrn   Music_GetPattern:Far
                Extrn   Music_AllocatePattern:Far
                Extrn   Music_AllocateSample:Far
                Extrn   Music_GetSampleLocation:Far
                Extrn   Music_ClearAllInstruments:Far
                Extrn   Music_GetInstrumentMode:Far
                Extrn   Music_AssignSampleToInstrument:Far
                Extrn   Music_SoundCardLoadSample:Far
                Extrn   Music_SoundCardLoadAllSamples:Far
                Extrn   Music_GetPitchTable:Far
                Extrn   Music_GetMIDIDataArea:Far

                Extrn   Music_Stop:Far
                Extrn   Msg_ResetMessage:Far
                Extrn   Msg_GetMessageOffset:Far
                Extrn   Msg_GetMessageLength:Far

IF TUTORIAL
ELSE
                Extrn   O1_LoadS3MList:Far
                Extrn   O1_LoadXMList:Far
                Extrn   O1_LoadMODList:Far
                Extrn   O1_LoadMTMList:Far
                Extrn   O1_Load669List:Far
                Extrn   O1_LoadITList:Far
ENDIF
                Extrn   O1_ConfirmOverWriteList:Far
                Extrn   O1_UnableToSaveList:Far
                Extrn   O1_SaveITList:Far
                Extrn   O1_SaveS3MList:Far
                Extrn   O1_ConfirmDelete:Far    ; Updates Song name loader.
                Extrn   O1_ConfirmDelete2:Far
                Extrn   O1_ConfirmDelete3:Far
                Extrn   O1_ConfirmSaveRenameList:Far
                Extrn   O1_ConfirmResaveList:Far
                Extrn   O1_ConfirmDiscardList:Far
                Extrn   O1_InitInstrument:Far
                Extrn   O1_EditSampleName:Far
                Extrn   O1_OutOfSamplesList:Far
                Extrn   O1_EnableInstrumentMode:Far
                Extrn   O1_StereoSampleList:Far

                Extrn   PE_TranslateXMPattern:Far
                Extrn   PE_Translate669Pattern:Far
                Extrn   PE_TranslateS3MPattern:Far
                Extrn   PE_TranslateMTMPattern:Far
                Extrn   PE_TranslateMODPattern:Far
                Extrn   PE_ResetOrderPattern:Far
                Extrn   PE_UnInitPatternEdit:Far
                Extrn   PEFunction_OutOfMemoryMessage:Far
                Extrn   PECheckModified:Far
                Extrn   PEResetModified:Far
                Extrn   PE_GetMaxPattern:Far
                Extrn   PE_ConvAX2Num:Far
                Extrn   PE_GetLastInstrument:Far
                Extrn   PE_GetPatternConfigOffset:Far
                Extrn   PE_SaveCurrentPattern:Far
                Extrn   PE_RestoreCurrentPattern:Far

                Extrn   S_UnInitScreen:Far
                Extrn   S_GetDestination:Far
                Extrn   S_DrawString:Far
                Extrn   S_SaveScreen:Far
                Extrn   S_RestoreScreen:Far
                Extrn   S_GetGenerationTableOffset:Far
                Extrn   S_GenerateCharacters:Far
                Extrn   S_RedefineCharacters:Far
                Extrn   S_GetPaletteOffset:Far
                Extrn   S_SetPalette:Far

                Extrn   SetInfoLine:Far
                Extrn   ClearInfoLine:Far

                Extrn   Glbl_SetCurrentMode:Far
                Extrn   Glbl_F10:Far

                Extrn   GetKeyboardLock:Far, GetTimerCounter:Far
                Extrn   MouseUpdateEnable:Far, MouseUpdateDisable:Far

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Globals                                                                     ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                Global  D_GetFileName:Far
                Global  D_SetDriveDirectoryFar:Far

                Global  D_RestorePreShellDirectory:Far
                Global  D_GetPreShellDirectory:Far

                Global  D_SaveInstrument:Far
                Global  D_ClearFileName:Far

                Global  D_GetFormatType:Far

                Global  D_LSCheckLoopValues:Far
                Global  D_LSCheckSusLoopValues:Far

                Global  D_SaveSong:Far

                Global  D_InitDisk:Far
                Global  D_UnInitDisk:Far
                Global  D_InitLoadModule:Far
                Global  D_InitLoadSamples:Far
                Global  D_LoadSampleNames:Far
                Global  D_NewSpecifier:Far
                Global  D_NewDirectory:Far
                Global  D_SaveIT:Far
                Global  D_DrawWaveForm:Far

                Global  D_InitLoadInstruments:Far
                Global  D_DrawLoadInstrument:Far
                Global  D_PreLoadInstrument:Far
                Global  D_PostLoadInstrument:Far
                Global  D_LoadInstrumentNames:Far
                Global  D_ViewInstrument:Far
                Global  D_SlowSampleSort:Far
                Global  D_SlowInstrumentSort:Far

                Global  D_SaveS3M:Far

                Global  D_SaveDirectoryConfiguration:Far
                Global  D_DisableFileColours:Far

                Global  D_GetLoadSampleVars:Far

                Global  D_DrawLoadSampleWindow:Far
                Global  D_PreLoadSampleWindow:Far
                Global  D_PostLoadSampleWindow:Far
                Global  D_PostViewSampleLibrary:Far

                Global  D_LSDrawDriveWindow:Far
                Global  D_LSPreDriveWindow:Far
                Global  D_LSPostDriveWindow:Far

                Global  D_LIDrawDriveWindow:Far
                Global  D_LIPreDriveWindow:Far
                Global  D_LIPostDriveWindow:Far

                Global  D_DeleteSampleFile:Far

                Global  D_PostSaveDriveWindow:Far

                Global  D_ClearFileSpecifier:Far
                Global  D_LoadSongNames:Far
                Global  D_DrawFileWindow:Far
                Global  D_DrawDirectoryWindow:Far
                Global  D_DrawDriveWindow:Far
                Global  D_PreFileWindow:Far
                Global  D_PostFileWindow:Far
                Global  D_PreDirectoryWindow:Far
                Global  D_PostDirectoryWindow:Far
                Global  D_PreDriveWindow:Far
                Global  D_PostDriveWindow:Far
                Global  D_PostFileLoadWindow:Far
                Global  D_PostFileSaveWindow:Far
                Global  D_SaveModule:Far

                Global  FileSpecifier:Byte
                Global  SongDirectory:Byte
                Global  SampleDirectory:Byte
                Global  InstrumentDirectory:Byte
                Global  FileName:Byte

                Global  D_SaveSample:Far
                Global  D_SaveRawSample:Far
                Global  D_SaveST3Sample:Far

                Global  D_GotoStartingDirectory:Far

                Global  LSWindow_Up:Far
                Global  LSWindow_Down:Far

                Global  DiskDataArea:Word
                Global  SampleName:Byte
                Global  DiskOptions:Byte

                Public  D_Resettimer
                Public  D_ShowTime

IF TIMERSCREEN
                Public  D_DrawTimer
                Public  D_PostTimerList
ENDIF

IF TUTORIAL
                Public  SamplesInModule
                Public  InSampleFileName
ELSE
                Public  D_LoadS3M
                Public  D_LoadMTM
                Public  D_LoadMOD
                Public  D_Load669
                Public  D_LoadIT
                Public  D_LoadXM
ENDIF

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment                 Disk BYTE Public 'Code' USE16
                        Assume CS:Disk, DS:Nothing

CREATENEWLOGFILE        EQU     0
include debug.inc

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Variables                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SampleInMemory          DW      0FFFFh
NoSaveError             DB      0
Specific                DB      0
DiskDataArea            DW      DiskData

OldCacheTime            DD      0

Time                    DW      0
Date                    DW      0
LoadDate                DW      0
LoadTime                DW      0
DrivesAvail             DB      27 Dup (0)
UnusedSamples           DW      0

InitialInstruments      DW      0               ;
NumInstruments          DW      0               ; Order important!
InstrumentCachefileVersion DW   TRACKERVERSION  ;

LoadInstrumentNameCount DW      0
TopInstrument           DW      0
CurrentInstrument       DW      0

LoadSongNameCount       DW      0
LoadSampleNameCount     DW      0
CurrentSample           DW      0

NumSamples              DW      0               ; Order important!
SampleCachefileVersion  DW      TRACKERVERSION  ;

TopSample               DW      0
CurrentDrive            DB      0
NumDrives               DB      0
TopDrive                DB      0
NumEntries              DW      0
NumFiles                DW      0
NumFileInfo             DW      0
NumDirectories          DW      0
TopDirectory            DW      0
CurrentDirectory        DW      0
CurrentFile             DW      0
TopFile                 DW      0
FileName                DB      0
                        DB      13 Dup (0)
SaveFileName            DB      0
                        DB      79 Dup (0)
FileSpecifier           DB      0
                        DB      64 Dup (0)
StartingDrive           DB      0
StartingDirectory       DB      70 Dup (0)

PreShellDirectory       DB      70 Dup (0)
DOSDirectory            DB      70 Dup (0)

SongDirectory           DB      0
                        DB      69 Dup (0)
SampleDirectory         DB      0
                        DB      69 Dup (0)
InstrumentDirectory     DB      0
                        DB      69 Dup (0)
CountryTableConfig      DB      0

SampleName              DB      0
                        DB      26 Dup (0)

MODNumberOfChannels     DB      0
MODNumberOfInstruments  DB      0
MODNumberOfOrders       DB      0
MODOrderOffset          DW      0
MODPatternOffset        DW      0
LastKey                 DW      0

SampleCacheFileComplete DB      0
InstrumentCacheFileComplete DB  0

Resolution              DB      0

FileTempSpecifier       DB      70 Dup (0)
CurrentSearchPos        DB      0
Search                  DB      13 Dup (0)

InstrumentTable         DB      100 Dup (0)

InstrumentLoaderTable   Label   Word
                        DW      Offset LoadITInstrument         ; 3
                        DW      Offset LoadXIInstrument         ; 4
                        DW      Offset LoadInITInstrument       ; 5
                        DW      Offset LoadInXMInstrument       ; 6
                        DW      0                               ; 7
                        DW      Offset LoadITInModuleInstrument ; 8
                        DW      Offset LoadXMInModuleInstrument ; 9

InstrumentLoader        DW      0
InSampleFileName        DB      13 Dup (0)
InSampleDateTime        DD      0
InSampleFormat          DB      0               ; Do *NOT* change order
InSampleChannels        DB      0               ; Do *NOT* change order

InInstrumentFileName    DB      13 Dup (0)
InInstrumentFormat      DB      0

ExitLibraryDirectory    Label
        DB      "IMPS.           ", 0, 0, 0, 0
        DB      8 Dup(154), "Directory", 8 Dup(154), 0, 0, 0
        DW      0, 0, 0, 0, 0, 0, 0, 0
        DW      0, 0, 0, 0, 0, 0, 0, 0
        DW      0, 0, 0, 0
        DB      1

ExitInstrumentLibraryDirectory Label
        DB      1, ".           ", 0
        DB      8 Dup(154), "Directory", 8 Dup(154), 0 ; Instrument name
        DW      0, 0            ; NoSamples, FileSize
        DD      0               ; File offset

AllFilesMask            DB      "*.*", 0
FileSpecifierDefault    DB      "*.IT, *.XM, *.S3M, *.MTM, *.669, *.MOD", 0
DriveMsg                DB      "Drive X:"
NoFilesMsg              DB      "No files.", 0
NoDirsMsg               DB      "No dirs.", 0
WAVEfmtID               DB      "WAVEfmt ", 0, 0, 1, 0
XIIdentification        DB      "Extended Instrument: "
XMIdentification        DB      "Extended Module: "
TXWAVEIdentification    DB      "LM8953", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
GUSPATIdentification    DB      "GF1PATCH110", 0, "ID#000002", 0 ; 22 bytes

OpenErrorMsg            DB      "Error opening file.", 0

HeaderMsg               DB      "File Header", 0
SampleMsg               DB      "Sample ", 0FDh, 'D', 0
SHLoadMsg               DB      "Sample Header ", 0FDh, 'D', 0
InstrumentMsg           DB      "Instrument ", 0FDh, 'D', 0
PatternMsg              DB      "Pattern ", 0FDh, 'D', 0
TrackMsg                DB      "Channel ", 0FDh, 'D ', 13
                        DB      "Track ", 0FDh, 'D    ', 0
CompleteMsg             DB      "Done", 0
InstrumentHeaderMsg     DB      "Instrument Headers", 0
SampleHeaderMsg         DB      "Sample Headers", 0
Quality8Msg             DB      "8 Bit", 0
Quality16Msg            DB      "16 Bit", 0
Quality8StereoMsg       DB      "8 Bit Stereo", 0
Quality16StereoMsg      DB      "16 Bit Stereo", 0
LengthMsg               DB      0FDh, 'L', 0
DirectoryMsg            DB      8 Dup(154), "Directory", 8 Dup(154), 0
LibraryMsg              DB      9 Dup(154), "Library", 9 Dup(154), 0
FontFileName            DB      "FONT.CFG", 0
ConfigFileName          DB      "IT.CFG", 0
ST3CacheFileName        DB      "########.ST3", 0
SampleCacheFileName     DB      "CACHE.ITS", 0
InstrumentCacheFileName DB      "CACHE.ITI", 0
SaveFormat              DB      DEFAULTFORMAT
SaveFormatError         DB      0               ; This will get erased whenever the
                                                ; saveformat changes.
SamplesInModule         DB      0
InstrumentsInModule     DB      0
FileColours             DB      1

NoteData                DB      0FFh, 0, 0FFh, 0, 0

CheckDataArea           DB      96 Dup(0)
KeyBoardTable           DW      12Ch, 0, 11Fh, 1, 12Dh, 2, 120h, 3, 12Eh, 4
                        DW      12Fh, 5, 122h, 6, 130h, 7, 123h, 8, 131h, 9
                        DW      124h, 10, 132h, 11, 110h, 12, 103h, 13, 111h, 14
                        DW      104h, 15, 112h, 16, 113h, 17, 106h, 18, 114h, 19
                        DW      107h, 20, 115h, 21, 108h, 22, 116h, 23, 117h, 24
                        DW      10Ah, 25, 118h, 26, 10Bh, 27, 119h, 28, 0FFFFh
SampleCheck             DW      0FFFFh

MonthNames              Label
                        DW      Offset Empty
                        DW      Offset January
                        DW      Offset February
                        DW      Offset March
                        DW      Offset April
                        DW      Offset May
                        DW      Offset June
                        DW      Offset July
                        DW      Offset August
                        DW      Offset September
                        DW      Offset October
                        DW      Offset November
                        DW      Offset December
                        DW      Offset Empty
                        DW      Offset Empty
                        DW      Offset Empty

January                 DB      "January", 0
February                DB      "February", 0
March                   DB      "March", 0
April                   DB      "April", 0
May                     DB      "May", 0
June                    DB      "June", 0
July                    DB      "July", 0
August                  DB      "August", 0
September               DB      "September", 0
October                 DB      "October", 0
November                DB      "November", 0
December                DB      "December"
Empty                   DB      0

TimerData               DW      0
NumTimerData            DW      0
TopTimerData            DW      0

SampleFormatNames       Label
                        DW      Offset Unchecked                ; 0
                        DW      Offset DirectoryFormat
                        DW      Offset ITSampleFormat
                        DW      Offset STSampleFormat
                        DW      Offset UnknownSampleFormat
                        DW      Offset WAV8BitFormat
                        DW      Offset XMSample
                        DW      Offset WAV16BitFormat
                        DW      Offset XMSample
                        DW      Offset PTMSample
                        DW      Offset MTMSample
                        DW      Offset C669Sample
                        DW      Offset FARSample
                        DW      Offset TXWaveSample             ; 13
                        DW      Offset MODSample
                        DW      Offset KRZSample                ; 15
                        DW      Offset PATFormat
                        DW      Offset IFFFormat                ; 17
                        DW      0, 0
                        DW      0, 0, 0, 0
                        DW      0, 0, 0, 0
                        DW      0, 0, 0, 0
                        DW      Offset ST3Module                ; 20h
                        DW      Offset ITModule
                        DW      Offset XMModule
                        DW      Offset PTMModule
                        DW      Offset MTMModule
                        DW      Offset C669Module
                        DW      Offset FARModule
                        DW      Offset MODModule1
                        DW      Offset XMModule
                        DW      Offset KRZFormat                ; 29h
                        DW      Offset PATFormat

LoadSamplesInModuleTable Label  Word
                        DW      Offset LoadS3MSamplesInModule
                        DW      Offset LoadITSamplesInModule
                        DW      Offset LoadXMSamplesInModule
                        DW      Offset LoadPTMSamplesInModule
                        DW      Offset LoadMTMSamplesInModule
                        DW      Offset Load669SamplesInModule
                        DW      Offset LoadFARSamplesInModule
                        DW      Offset LoadMODSamplesInModule
                        DW      Offset LoadMODSamplesInModule
                        DW      Offset LoadKRZSamples
                        DW      Offset LoadPATSamples
;                        DW      Offset LoadULTSamplesInModule

FormatNames             Label
                        DW      Offset Unchecked        ; 0
                        DW      Offset UnknownFormat    ; 1
                        DW      Offset ITFormat2_0      ; 2
                        DW      Offset ITFormat?        ; 3
                        DW      Offset ST3Format        ; 4
                        DW      Offset XMModule         ; 5
                        DW      Offset C669Module       ; 6
                        DW      Offset CompressedITModule ; 7
                        DW      0
                        DW      Offset MODFormat        ; 9
                        DW      Offset Protracker       ; 10
                        DW      Offset Channel4         ; 11
                        DW      Offset Channel6         ; 12
                        DW      Offset Channel8         ; 13
                        DW      Offset StarTrekker4     ; 14
                        DW      Offset StarTrekker8     ; 15
                        DW      Offset OldMod           ; 16
                        DW      Offset ChannelXX        ; 17
                        DW      Offset MultiTrackerModule ; 18

PanningPositions        DB      0, 4, 9, 13, 17, 21, 26, 30
                        DB      34, 38, 43, 47, 51, 55, 60, 64
MODChannelTable         DB      4, 4, 4, 6, 8, 4, 8, 4
FineTuneTable           DW      8363, 8413, 8463, 8529
                        DW      8581, 8651, 8723, 8757
                        DW      7895, 7941, 7985, 8046
                        DW      8107, 8169, 8232, 8280

DirectoryFormat         DB      "Directory", 0
ITSampleFormat          DB      "Impulse Tracker Sample", 0
STSampleFormat          DB      "Scream Tracker Sample", 0
UnknownSampleFormat     DB      "Unknown sample format", 0
WAV8BitFormat           DB      "8 Bit WAV Format", 0
WAV16BitFormat          DB      "16 Bit WAV Format", 0
XMSample                DB      "Fast Tracker 2 Sample", 0
PTMSample               DB      "Poly Tracker Sample", 0
MTMSample               DB      "Multi Tracker Sample", 0
C669Sample              DB      "Composer 669 Sample", 0
FARSample               DB      "Farandole Sample", 0
; ULTSample               DB      "Ultra Tracker Sample", 0
TXWaveSample            DB      "TX Wave Sample", 0
MODSample               DB      "MOD Sample", 0
KRZSample               DB      "KRZ Sample", 0

ST3Module               DB      "Scream Tracker 3 Module", 0
ITModule                DB      "Impulse Tracker Module", 0
XMModule                DB      "Fast Tracker 2 Module", 0
PTMModule               DB      "Poly Tracker Module", 0
MTMModule               DB      "Multi Tracker Module", 0
C669Module              DB      "Composer 669 Module", 0
FARModule               DB      "Farandole Module", 0
MODModule1              DB      "MOD Format", 0
; ULTModule               DB      "Ultra Tracker Module", 0
KRZFormat               DB      "Kurzweil Synth File", 0
PATFormat               DB      "Gravis UltraSound Patch", 0
IFFFormat               DB      "AIFF Sample", 0

Unchecked               DB      "Unchecked", 0
UnknownFormat           DB      "Unknown module format", 0
CompressedITModule      DB      "Compressed "
ITFormat2_0             DB      "Impulse Tracker", 0
ITFormat?               DB      "Impulse Tracker ?.??", 0
ST3Format               DB      "Scream Tracker 3", 0
MODFormat               DB      "Amiga-NewTracker", 0
ProTracker              DB      "Amiga-ProTracker", 0
StarTrekker4            DB      "4 Channel Startrekker", 0
StarTrekker8            DB      "8 Channel Startrekker", 0
Channel4                DB      "4 Channel MOD", 0
Channel6                DB      "6 Channel MOD", 0
Channel8                DB      "8 Channel MOD", 0
OldMod                  DB      "Old Amiga-MOD format ? ", 0
ChannelXX               DB      0FDh, "D Channel MOD", 0
MultiTrackerModule      DB      "MultiTracker Module", 0

ITInstrumentSavedMsg    DB      "Instrument saved (instrument ", 0FDh, "D)", 0
InstrumentErrorMsg      DB      "Error: Instrument ", 0FDh, "D NOT saved! (No Filename?)", 0
ITSampleSavedMsg        DB      "Impulse Tracker sample saved (sample ", 0FDh, "D)", 0
ST3SampleSavedMsg       DB      "Scream Tracker sample saved (sample ", 0FDh, "D)", 0
IF SAVESAMPLEWAV
RawSampleSavedMsg       DB      "WAV Sample saved (sample ", 0FDh, "D)", 0
ELSE
RawSampleSavedMsg       DB      "RAW Sample saved (sample ", 0FDh, "D)", 0
ENDIF
SampleErrorMsg          DB      "Error: Sample ", 0FDh, "D NOT saved! (No Filename?)", 0
InitInstrumentMsg       DB      "Sample assigned to Instrument ", 0FDh, "D", 0
InitInstrumentErrorMsg  DB      "Error: No available Instruments!", 0

TooManyPatternsMsg      DB      "Warning: Only 100 patterns supported in S3M format", 0
ChannelVolumeErrorMsg   DB      "Warning: Channel volumes unsupported in S3M format", 0
LinearSlideMsg          DB      "Warning: Linear slides unsupported in S3M format", 0
LoopMsg                 DB      "Warning: Sustain and Ping Pong loops unsupported in S3M format", 0
SampleVolumeMsg         DB      "Warning: Sample volumes unsupported in S3M format", 0
SampleVibratoMsg        DB      "Warning: Sample vibrato unsupported in S3M format", 0
ST3InstrumentErrorMsg   DB      "Warning: Instrument functions unsupported in S3M format", 0
PatternLengthMsg        DB      "Warning: Pattern lengths other than 64 rows unsupported in S3M format", 0
ChannelErrorMsg         DB      "Warning: Data outside 16 channels unsupported in S3M format", 0
NoteRangeMsg            DB      "Warning: Notes outside the range C-1 to B-8 are unsupported in S3M format", 0
PanningErrorMsg         DB      "Warning: Extended volume column effects are unsupported in S3M format", 0

InstrumentLibrary       DB      154, 154, "Module", 154, 154, 0
InstrumentNoSample      DB      "No Samples", 0
InstrumentSingleSample  DB      "1 Sample", 0
InstrumentSeveralSamples DB     0FDh, "D Samples", 0
InstrumentUnknownSamples DB     "???", 0
FileSizeMsg             DB      0FDh, "Dk", 0
FreeSampleMsg           DB      "Available", 13
                        DB      "Samples: ", 0FDh, 'D', 0

IF SAVESAMPLEWAV
 WAVEFileHeader  DB      "RIFF"
 WAVEFileSize    DD      0
 WAVEFileHeader2 DB      "WAVEfmt "
 WAVEFileHeaderLength DD 10h
 WAVEFileID      DW      1
 WAVEChannels    DW      1
 WAVEMixSpeed    DD      44100           ; Default to CD quality
 WAVEBytesPerSecond DD   0
 WAVEBytesPerSample DW   2
 WAVEBits        DW      16
 WAVEHeader3     DB      "data"
 WAVEDataSize    DD      0
ENDIF

DiskOptions             DB      0
EditTimer               DD      0

CDRomStartDrive         DB      0               ; The first CDRom Drive letter
CDRomEndDrive           DB      0               ; The drive AFTER the last cdrom

FileWindowKeys          Label

                        DB      0
                        DW      1C8h            ; Up arrow
                        DW      FileWindow_Up

                        DB      0
                        DW      1D0h            ; Down arrow
                        DW      FileWindow_Down

                        DB      0
                        DW      1C9h            ; PgUp
                        DW      FileWindow_PgUp

                        DB      0
                        DW      1D1h            ; PgDn
                        DW      FileWindow_PgDn

                        DB      0
                        DW      1C7h            ; Home
                        DW      FileWindow_Home

                        DB      0
                        DW      1CFh            ; End
                        DW      FileWindow_End

                        DB      4
                        DW      10Fh            ; Shift Tab
                        DW      FileWindow_ShiftTab

                        DB      0
                        DW      10Fh            ; Tab
                        DW      FileWindow_Right

                        DB      0
                        DW      1CDh            ; Right arrow
                        DW      FileWindow_Right

                        DB      0
                        DW      1CBh            ; Left arrow
                        DW      FileWindow_Left

                        DB      0
                        DW      1D3h            ; Delete
                        DW      FileWindow_DeleteFile

                        DB      0FFh

DirectoryWindowKeys     Label

                        DB      0
                        DW      1C8h
                        DW      DirectoryWindow_Up

                        DB      0
                        DW      1D0h
                        DW      DirectoryWindow_Down

                        DB      0
                        DW      1C9h            ; PgUp
                        DW      DirectoryWindow_PgUp

                        DB      0
                        DW      1D1h            ; PgDn
                        DW      DirectoryWindow_PgDn

                        DB      0
                        DW      1C7h            ; Home
                        DW      DirectoryWindow_Home

                        DB      0
                        DW      1CFh            ; End
                        DW      DirectoryWindow_End

                        DB      4
                        DW      10Fh            ; Shift Tab
                        DW      DirectoryWindow_Left

                        DB      0
                        DW      10Fh                    ; Tab
                        DW      FileWindow_Left         ; Same object num

                        DB      0
                        DW      1CDh            ; Right arrow
                        DW      FileWindow_Left

                        DB      0
                        DW      1CBh            ; Left arrow
                        DW      DirectoryWindow_Left

                        DB      0
                        DW      11Ch            ; Enter
                        DW      DirectoryWindow_Enter

                        DB      0FFh

DriveWindowKeys         Label

                        DB      0
                        DW      1C8h
                        DW      DriveWindow_Up

                        DB      0
                        DW      1D0h
                        DW      DriveWindow_Down

                        DB      4
                        DW      10Fh            ; Shift-Tab
                        DW      FileWindow_Right

                        DB      0
                        DW      10Fh            ; Tab
                        DW      DriveWindow_Tab

                        DB      0
                        DW      1CDh            ; Right arrow
                        DW      DirectoryWindow_Left

                        DB      0
                        DW      1CBh            ; Left arrow
                        DW      FileWindow_Right

                        DB      0
                        DW      11Ch            ; Enter
                        DW      DriveWindow_Enter

                        DB      0FFh

SaveDriveWindowKeys     Label

                        DB      0
                        DW      1C8h
                        DW      DriveWindow_Up

                        DB      0
                        DW      1D0h
                        DW      DriveWindow_Down

                        DB      4
                        DW      10Fh            ; Shift-Tab
                        DW      FileWindow_Right

                        DB      0
                        DW      10Fh            ; Tab
                        DW      SaveDriveWindow_Tab

                        DB      0
                        DW      1CDh            ; Right arrow
                        DW      SaveDriveWindow_Tab

                        DB      0
                        DW      1CBh            ; Left arrow
                        DW      FileWindow_Right

                        DB      0
                        DW      11Ch            ; Enter
                        DW      DriveWindow_Enter

                        DB      0FFh

LSDriveWindowKeys       Label

                        DB      0
                        DW      1C8h
                        DW      DriveWindow_Up

                        DB      0
                        DW      1D0h
                        DW      DriveWindow_Down

                        DB      4
                        DW      10Fh            ; Shift-Tab
                        DW      DriveWindow_Tab ; goto object number 15

                        DB      0
                        DW      10Fh            ; Tab
                        DW      LSDriveWindow_Right

                        DB      0
                        DW      1CDh            ; Right arrow
                        DW      LSDriveWindow_Right

                        DB      0
                        DW      1CBh            ; Left arrow
                        DW      DriveWindow_Tab

                        DB      0
                        DW      11Ch            ; Enter
                        DW      LS_DriveWindow_Enter

                        DB      0FFh

LIDriveWindowKeys       Label

                        DB      0
                        DW      1C8h
                        DW      DriveWindow_Up

                        DB      0
                        DW      1D0h
                        DW      DriveWindow_Down

                        DB      0
                        DW      1CBh            ; Left arrow
                        DW      LIDriveWindow_Tab

                        DB      0
                        DW      10Fh            ; Tab
                        DW      LIDriveWindow_Tab

                        DB      0
                        DW      11Ch            ; Enter
                        DW      LI_DriveWindow_Enter

                        DB      0FFh

LoadInstrumentKeys      Label
                        DB      0
                        DW      11Ch            ; Enter
                        DW      LIWindow_Enter

ViewInstrumentKeys      Label
                        DB      0
                        DW      1C8h
                        DW      LIWindow_Up

                        DB      0
                        DW      1D0h
                        DW      LIWindow_Down

                        DB      0
                        DW      1C9h            ; PgUp
                        DW      LIWindow_PgUp

                        DB      0
                        DW      1D1h            ; PgDn
                        DW      LIWindow_PgDn

                        DB      0
                        DW      1C7h            ; Home
                        DW      LIWindow_Home

                        DB      0
                        DW      1CFh            ; End
                        DW      LIWindow_End

                        DB      0
                        DW      1D3h            ; Delete
                        DW      D_DeleteInstrumentFile

                        DB      0
                        DW      11Ch            ; Enter
                        DW      LIViewWindow_Enter

                        DB      0
                        DW      1CDh            ; Right arrow
                        DW      LIViewWindow_Tab

                        DB      0
                        DW      10Fh            ; Tab
                        DW      LIViewWindow_Tab

                        DB      0FFh

LSWindowKeys            Label
                        DB      0
                        DW      11Ch            ; Enter
                        DW      LSWindow_Enter

LSViewWindowKeys        Label
                        DB      0
                        DW      139h
                        DW      LSWindow_Space  ; Edit sample name

                        DB      0
                        DW      1C8h
                        DW      LSWindow_Up

                        DB      0
                        DW      1D0h
                        DW      LSWindow_Down

                        DB      0
                        DW      1C9h            ; PgUp
                        DW      LSWindow_PgUp

                        DB      0
                        DW      1D1h            ; PgDn
                        DW      LSWindow_PgDn

                        DB      0
                        DW      1C7h            ; Home
                        DW      LSWindow_Home

                        DB      0
                        DW      1CFh            ; End
                        DW      LSWindow_End

                        DB      0
                        DW      1CDh            ; Right arrow
                        DW      FileWindow_ShiftTab

                        DB      0
                        DW      10Fh            ; Tab
                        DW      FileWindow_ShiftTab     ; Object 16

                        DB      0
                        DW      1D3h            ; Delete
                        DW      D_DeleteSampleFile

                        DB      0
                        DW      11Ch            ; Enter
                        DW      LSViewWindow_Enter

                        DB      0FFh



;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Functions                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Proc            D_InitDisk Far

                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Disk
                                        ; Get date/time for CACHE.IT file

                Trace   " - Finding CDROM Drives"

                Mov     AX, 1500h
                Xor     BX, BX
                Int     2Fh
                Cmp     AL, 0FFh
                JNE     D_InitDiskNoCDROM
                Test    BX, BX
                JZ      D_InitDiskNoCDROM

                Add     CL, 'A'
                Mov     CDRomStartDrive, CL
                Add     CX, BX
                Mov     CDRomEndDrive, CL

D_InitDiskNoCDROM:
                Trace   " - Determining main directory"

                Mov     SI, Offset DOSDirectory
                Call    D_GetDriveDirectory

                Trace   " - Initialising cache file parameters"

                Mov     AH, 2Ah
                Int     21h             ; Get Date
                Mov     AX, CX          ; Now to get date in yyyyyyym mmmddddd
                Sub     AX, 1980
                ShL     AX, 9           ; Year
                Or      AL, DL          ; Day
                Xor     DL, DL
                ShR     DX, 3
                Or      AX, DX          ; Month
                Mov     Date, AX

                Mov     AH, 2Ch
                Int     21h             ; Get time
                Mov     AX, CX          ; Now to get time in hhhhhmmm mmmsssss
                ShL     AL, 2           ; AX = ...hhhhh mmmmmm..
                ShL     AX, 3           ; AX = hhhhhmmm mmm.....
                ShR     DH, 1           ; DH = ...sssss
                Or      AL, DH
                Mov     Time, AX

                Cmp     StartingDirectory, 0
                JNE     D_InitDisk2

                Trace   " - Determining available drives"

D_InitDisk1:
                Mov     AH, 19h
                Int     21h

                Mov     StartingDrive, AL

                Mov     CX, 26
                Xor     BX, BX
                Xor     SI, SI

D_InitDisk3:
                Mov     DL, BL
                Mov     AH, 0Eh
                Int     21h

                Mov     AH, 19h
                Int     21h
                Cmp     AL, BL
                JNE     D_InitDisk4

                Cmp     BL, StartingDrive
                JNE     D_InitDisk9

                Mov     AX, SI
                Mov     CurrentDrive, AL

D_InitDisk9:
                Test    DiskOptions, 1
                JNZ     D_InitDisk10

                Mov     AX, 440Eh               ; This code was to prevent
                                                ; A and B drives being shown
                                                ; on older DOS systems when
                                                ; only one drive was present.
                                                ; For some reason, it crashes
                                                ; one in a thousand computers.
                                                ; <shrug> hence the option /x3
                Push    BX
                Xor     BL, BL
                Int     21h

                Pop     BX
                JC      D_InitDisk10
                And     AL, AL
                JZ      D_InitDisk10
                Dec     AX
                Cmp     AL, BL
                JNE     D_InitDisk4

D_InitDisk10:
                Mov     [DrivesAvail+SI], BL
                Inc     SI

D_InitDisk4:
                Inc     BX
                Loop    D_InitDisk3

                Mov     BX, SI
                Mov     NumDrives, BL

                Mov     DL, StartingDrive
                Mov     AH, 0Eh
                Int     21h

D_GetStartingDirectory1:                        ; FS=PSP.
                Push    CS
                Pop     ES

                Mov     DI, Offset StartingDirectory

                Mov     DS, [FS:2Ch]            ; Environment thingy.
                Xor     SI, SI
                Mov     CX, 7FFFh

D_GetStartingDirectory2:
                Cmp     Word Ptr [SI], 0
                JE      D_GetStartingDirectory3

                Inc     SI
                Loop    D_GetStartingDirectory2

                Jmp     D_GetStartingDirectoryEnd

D_GetStartingDirectory3:                        ; DS:SI points to 0...
                Add     SI, 4
                Push    SI                      ; Now to work out count.

                Xor     DX, DX
                Mov     CX, 1

D_GetStartingDirectory4:
                LodsB
                And     AL, AL
                JZ      D_GetStartingDirectory5

                Inc     DX

                Cmp     AL, '\'
                JNE     D_GetStartingDirectory4

                Mov     CX, DX
                Jmp     D_GetStartingDirectory4

D_GetStartingDirectory5:
                Pop     SI

                Dec     CX
                Rep     MovsB
                Xor     AL, AL
                StosB

D_GetStartingDirectoryEnd:
                Push    CS
                Pop     DS

                Mov     SI, Offset StartingDirectory
                Call    D_SetDriveDirectory

                Mov     DI, Offset SongDirectory
                Cmp     Byte Ptr [DI], 0
                JNE     D_InitDisk11

                Push    SI

D_InitDisk5:
                LodsB
                And     AL, AL
                JZ      D_InitDisk6

                StosB
                Jmp     D_InitDisk5

D_InitDisk6:
                Cmp     Byte Ptr [ES:DI-1], '\'
                JNE     D_InitDisk15

                Dec     DI

D_InitDisk15:
                Mov     AX, '\' + 256*'S'
                StosW
                Xor     AL, AL
                StosB

                Pop     SI

D_InitDisk11:
                Mov     DI, Offset SampleDirectory
                Cmp     Byte Ptr [DI], 0
                JNE     D_InitDisk12

D_InitDisk7:
                LodsB
                And     AL, AL
                JZ      D_InitDisk8

                StosB
                Jmp     D_InitDisk7

D_InitDisk8:
                Cmp     Byte Ptr [ES:DI-1], '\'
                JNE     D_InitDisk16

                Dec     DI

D_InitDisk16:
                Mov     AX, '\' + 256*'I'
                StosW
                Xor     AL, AL
                StosB

D_InitDisk12:
                Mov     DI, Offset InstrumentDirectory
                Cmp     Byte Ptr [DI], 0
                JNE     D_InitDisk13

                Mov     SI, Offset SampleDirectory
                Mov     CX, 70
                Rep     MovsB

                Mov     SI, Offset SongDirectory
                Call    D_SetDriveDirectory
                Mov     SI, Offset SampleDirectory
                Call    D_SetDriveDirectory
                Mov     SI, Offset InstrumentDirectory
                Call    D_SetDriveDirectory

D_InitDisk13:
                Push    CS
                Pop     DS

                Mov     SI, Offset StartingDirectory
                Call    D_SetDriveDirectory

                Trace   " - Loading configuration file"

                Mov     AX, 3D00h                       ; Get config.
                Mov     DX, Offset ConfigFileName
                Int     21h
                JC      D_InitDisk2

                Mov     BX, AX                  ; BX = file handle

                Trace   " - Processing configuration file"

                Mov     AH, 3Fh
                Mov     CX, 211                 ; Load Directories+Keyboard
                Mov     DX, Offset SongDirectory
                Int     21h                     ; Read config file..

                Call    S_GetPaletteOffset      ; Read palette stuff.
                Mov     AH, 3Fh
                Mov     CX, 3*16
                Int     21h

                Call    S_SetPalette

                Call    Display_GetDisplayWindowData
                Mov     AH, 3Fh
                Mov     CX, 50
                Int     21h

                Call    PE_GetPatternConfigOffset
                Mov     AH, 3Fh
                Mov     CX, 218
                Int     21h

                Call    I_GetPresetEnvelopeOffset
                Mov     AH, 3Fh
                Mov     CX, 810
                Int     21h

                Mov     AH, 3Eh         ; Close file.
                Int     21h

D_InitDisk2:                                    ; Load font data.. and set it.
                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset StartingDirectory
                Call    D_SetDriveDirectory

                Mov     AX, 3D00h
                Mov     DX, Offset FontFileName
                Int     21h
                JC      D_NoFontFile

                Trace   " - Loading custom font file"

                Call    S_GetGenerationTableOffset
                Push    ES
                Pop     DS
                Mov     DX, DI

                Mov     BX, AX
                Mov     AH, 3Fh
                Mov     CX, 2048
                Int     21h
                JC      D_BadFontRead
                Cmp     AX, CX
                JNE     D_BadFontRead

                Trace   " - Initialising custom font file"

                Push    BX

                Mov     SI, DX
                Xor     AX, AX
                Mov     BX, 256
                Call    S_RedefineCharacters

                Pop     BX

D_BadFontRead:
                Mov     AH, 3Eh
                Int     21h

D_NoFontFile:
                Push    CS
                Pop     DS

                Call    CheckTimerData

                Pop     DS
                Ret

EndP            D_InitDisk
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_UnInitDisk Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     AX, DiskDataArea
                Test    AX, AX
                JZ      D_UnInitDisk1

                Mov     ES, AX
                Mov     AH, 49h
                Int     21h


D_UnInitDisk1:
                Call    ReleaseTimerData
                Mov     SI, Offset DOSDirectory
                Call    D_SetDriveDirectory

                Ret

EndP            D_UnInitDisk
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_GetDriveDirectory             ; DS:SI points to buffer

                Push    AX
                Push    DX
                Push    SI

                Mov     AH, 19h
                Int     21h

                Add     AL, 'A'
                Mov     [SI], AL
                Mov     Word Ptr [SI+1], ':' + 256*'\'
                Add     SI, 3
                Mov     AH, 47h
                Xor     DX, DX
                Int     21h

                Pop     SI
                Pop     DX
                Pop     AX

                Ret

EndP            D_GetDriveDirectory

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SetDriveDirectory             ; DS:SI points to dir.

                Push    AX
                Push    BX
                Push    DX

                Xor     DX, DX

                Cmp     Byte Ptr [SI+1], ':'
                JNE     D_SetDriveDirectory2

                Mov     DL, [SI]
                Cmp     DL, 'a'
                JB      D_SetDriveDirectory1
                Cmp     DL, 'z'
                JA      D_SetDriveDirectory1

                Add     DL, 'A'-'a'

D_SetDriveDirectory1:
                Sub     DL, 'A'
                Cmp     DL, 25                  ; Drive > 'Z'??
                JA      D_SetDriveDirectory4

                Mov     AX, 440Eh
                Mov     BL, DL
                Inc     BX
                Int     21h
                JC      D_SetDriveDirectory3
                And     AL, AL
                JZ      D_SetDriveDirectory3

                Mov     AX, 440Fh
                Int     21h

D_SetDriveDirectory3:
                Mov     AH, 0Eh
                Int     21h             ; This causes hanging on re-run!!!

D_SetDriveDirectory4:
                Mov     DX, 2

D_SetDriveDirectory2:
                Add     DX, SI
                Mov     AH, 3Bh
                Int     21h

                Call    D_GetDriveDirectory

                Pop     DX
                Pop     BX
                Pop     AX
                Ret

EndP            D_SetDriveDirectory

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LoadFileNames

                Mov     ES, CS:DiskDataArea
                Xor     DI, DI
                Xor     AX, AX
                Mov     CX, 32768
                Rep     StosW

                Push    CS
                Push    CS

                Pop     DS
                Pop     ES
                        Assume DS:Disk

                Mov     NumFileInfo, 0
                Mov     NumEntries, 0
                Mov     CurrentDirectory, 0

                Mov     SI, Offset FileSpecifier

D_LoadFileNames1:
                Mov     DI, Offset FileTempSpecifier

D_LoadFileNames2:
                LodsB
                And     AL, AL
                JZ      D_LoadFileNames3

                Cmp     AL, ','
                JE      D_LoadFileNames3

                Cmp     AL, ' '
                JE      D_LoadFileNames2

                StosB
                Jmp     D_LoadFileNames2

D_LoadFileNames3:
                Xor     AL, AL
                StosB                           ; ES:DI points to file name.

                Push    DS
                Push    SI
                Push    ES
                Push    DI

                Xor     BL, BL
                Mov     CX, 6                   ; Hidden/System/Normal files
                Mov     DX, Offset FileTempSpecifier
                Call    D_LoadFileNames4

                Pop     DI
                Pop     ES
                Pop     SI
                Pop     DS

                Cmp     Byte Ptr [DS:SI-1], 0
                JNE     D_LoadFileNames1

                Mov     AX, NumEntries
                Mov     NumFiles, AX
                Cmp     CurrentFile, AX
                JB      D_LoadFileNameUpdateCurrentFile

                Mov     CurrentFile, 0

D_LoadFileNameUpdateCurrentFile:
                Mov     DX, Offset AllFilesMask
                Mov     CX, 10h                 ; Directories
                Mov     BX, CX
                Call    D_LoadFileNames4

                Mov     AX, NumEntries
                Sub     AX, NumFiles
                Mov     NumDirectories, AX

                Ret

D_LoadFileNames4:
                Push    DX

                Mov     DS, DiskDataArea
                        Assume DS:Nothing

                Mov     DX, 60000
                Mov     AH, 1Ah
                Int     21h                     ; Shift DTA address..

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     AH, 4Eh
                Pop     DX
                Int     21h

D_LoadFileNames5:
                JC      D_LoadFileNames6
                                                ; A file is found....
                Cmp     NumEntries, 1000
                JAE     D_LoadFileNames6

                Mov     AX, 50
                Mul     NumEntries
                Add     AX, 2000
                Mov     DI, AX
                Mov     CX, 21

                Mov     DS, DiskDataArea
                        Assume DS:Nothing

                Mov     SI, 60000+16h

                Cmp     Word Ptr [DS:60000+1Eh], '.'
                JNE     D_LoadFileNames9

                Mov     Byte Ptr [DS:60000+1Eh], '\'

D_LoadFileNames9:
                And     BL, BL
                JZ      D_LoadFileNames7

                Test    [SI-1], BL
                JZ      D_LoadFileNames8

D_LoadFileNames7:
                Push    DS
                Pop     ES
                Rep     MovsB

                Inc     CS:NumEntries

D_LoadFileNames8:
                Push    CS
                Pop     DS
                Mov     AH, 4Fh
                Int     21h
                Jmp     D_LoadFileNames5

D_LoadFileNames6:
                RetN

EndP            D_LoadFileNames
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SortRoutine

                Mov     DS, DiskDataArea
                Push    DS
                Pop     ES

                Mov     SI, CX                          ; Start

                                                ; OK, so SI = current,
                                                ;  CX/DX = range

D_SortRoutine2:
                Cmp     SI, DX
                JAE     D_SortRoutine1

                Push    DX
                Push    SI

                Push    CX
                Push    DX

                Mov     AX, 50
                Mul     SI
                Add     AX, 2000
                Mov     SI, AX

                Mov     AX, 50
                Mul     CX
                Add     AX, 2000
                Mov     DI, AX

                Xor     BX, BX
                Pop     DX

                Cmp     Word Ptr [SI+8], '\'
                JE      D_SortRoutine4

D_SortRoutine3:
                Cmp     CX, DX
                JAE     D_SortRoutine4

                Cmp     Word Ptr [DI+8], '\'
                JE      D_SortRoutine6

                Push    CX
                Push    SI
                Push    DI

                Add     SI, 8
                Add     DI, 8
                Mov     CX, 13

                RepE    CmpsB

                Pop     DI
                Pop     SI
                Pop     CX

                JB      D_SortRoutine5
                JA      D_SortRoutine6
                Cmp     DI, SI
                JBE     D_SortRoutine5

D_SortRoutine6:
                Inc     BX

D_SortRoutine5:
                Inc     CX
                Add     DI, 50

                Jmp     D_SortRoutine3

D_SortRoutine4:
                Pop     CX
                Add     BX, CX
                Add     BX, BX
                Mov     [BX], SI

                Pop     SI
                Pop     DX
                Inc     SI
                Jmp     D_SortRoutine2

D_SortRoutine1:
                Ret

EndP            D_SortRoutine

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SortFileNames

                Xor     CX, CX
                Mov     DX, CS:NumFiles
                Call    D_SortRoutine

                Ret

EndP            D_SortFileNames

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SortDirNames

                Mov     CX, CS:NumFiles
                Mov     DX, CX
                Add     DX, CS:NumDirectories
                Call    D_SortRoutine

                Ret

EndP            D_SortDirNames

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_InitLoadModule Far

                Push    DS
                Push    ES
                Push    DI

                Push    CS
                Push    CS
                Pop     DS
                Pop     ES
                        Assume DS:Disk

                Mov     SI, Offset FileSpecifierDefault
                Mov     DI, Offset FileSpecifier
                Mov     CX, 65
                Rep     MovsB

                Pop     DI
                Pop     ES
                Pop     DS
                        Assume DS:Nothing

Proc            D_InitLoadModule2 Far

                Cmp     CS:FileSpecifier, 0
                JE      D_InitLoadModule

                Push    DS
                Push    ES
                Push    DI

                Push    CS
                Push    CS
                Pop     DS
                Pop     ES
                        Assume DS:Disk

                Mov     DI, Offset CurrentSearchPos
                Mov     CX, 14
                Xor     AL, AL
                Rep     StosB

                Mov     LoadSongNameCount, 0

                Mov     SI, Offset SongDirectory
                Call    D_SetDriveDirectory     ; DS:SI points to cur dir.

                Call    D_LoadFileNames
                Call    D_SortFileNames
                Call    D_SortDirNames

                Pop     DI
                Pop     ES
                Pop     DS
                Ret

EndP            D_InitLoadModule2

EndP            D_InitLoadModule
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_DrawFileWindow Far            ; Layout of filenames in memory
                                                ; Start at offset 2000
                                                ; Pointers to filenames at 0

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Call    S_GetDestination

                Mov     AX, TopFile
                Mov     BX, CurrentFile
                Cmp     AX, BX
                JBE     D_DrawFileWindow1

                Mov     AX, BX

D_DrawFileWindow1:
                LEA     CX, [EAX+30]
                Cmp     CX, BX
                JA      D_DrawFileWindow2

                LEA     AX, [BX-30]

D_DrawFileWindow2:
                Mov     TopFile, AX
                Mov     BX, AX          ; BX = filenum

                Mov     DS, DiskDataArea
                Assume DS:Nothing

                Mov     DI, (3+13*80)*2
                Mov     CX, 31


D_DrawFileWindow3:
                LEA     SI, [EBX+EBX]
                Mov     SI, [SI]

                Push    DI

                Cmp     BX, NumFiles
                JAE     D_DrawFileWindow4

                Push    SI
                Push    DI

                Mov     AH, 2
                Cmp     CS:FileColours, 0
                JE      D_DrawFileWindow28

                Mov     AH, 6                   ; Not checked colour
                Mov     AL, [SI+23]

                Test    AL, AL
                JE      D_DrawFileWindow28

                Mov     AH, 7                   ; Not known colour
                Cmp     AL, 1
                JE      D_DrawFileWindow28

                Mov     AH, 3                   ; Impulse Tracker colour
                Cmp     AL, 3
                JBE     D_DrawFileWindow28
                Cmp     AL, 7
                JE      D_DrawFileWindow28

                Mov     AH, 5                   ; Scream Tracker colour
                Cmp     AL, 8
                JBE     D_DrawFileWindow28

                Mov     AH, 2                   ; MOD/MTM colour

D_DrawFileWindow28:
                Push    CX

                Add     SI, 8
                Mov     CX, 12

D_DrawFileWindow6:
                LodsB
                StosW

                And     AL, AL
                LoopNZ  D_DrawFileWindow6

;                JCXZ    D_DrawFileWindow30

                Xor     AL, AL
                Rep     StosW

                Pop     CX

; D_DrawFileWindow30:
                Pop     DI
                Pop     SI

D_DrawFileWindow4:
                Add     DI, 24
                Add     SI, 25

                Mov     AX, 2A8h
                StosW

                Cmp     BX, NumFiles
                JAE     D_DrawFileWindow9

                Mov     AH, 2                           ; Song name..
                Mov     DX, 25

                Add     AH, CS:FileColours

D_DrawFileWindow5:
                LodsB
                Cmp     AL, 226
                JB      D_DrawFileCharFilter

                Mov     AL, ' '

D_DrawFileCharFilter:
                StosW

                Dec     DX
                JNZ     D_DrawFileWindow5

D_DrawFileWindow9:
                Pop     DI
                Add     DI, 160
                Inc     BX

                Loop    D_DrawFileWindow3

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Cmp     NumFiles, 0
                JE      D_DrawFileWindow7

                Jmp     D_DrawFileWindow11

D_DrawFileWindow7:
                Mov     SI, Offset NoFilesMsg
                Mov     DI, (3+13*80)*2
                Mov     AH, 7
                Mov     CX, 9

D_DrawFileWindow8:
                LodsB
                StosW

                Loop    D_DrawFileWindow8

D_DrawFileWindow11:
;                Push    CS                     ; Not necessary
;                Pop     DS

                Mov     SI, Offset Search
                Mov     DI, (51+37*80)*2
                Mov     CX, 13
                Mov     AH, 5

D_DrawFileWindow10:
                LodsB
                StosW

                Loop    D_DrawFileWindow10

                Cmp     NumFiles, 0
                JNE     D_DrawFileWindow12

                Ret

D_DrawFileWindow12:
                Mov     BX, CurrentFile
                Add     BX, BX

                Mov     DS, DiskDataArea
                        Assume DS:Nothing

                Mov     BX, [BX]
                Mov     SI, [BX+23]
                Mov     AL, [BX+22]
                Mov     DI, (51+40*80)*2

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Add     SI, SI
                Mov     SI, [FormatNames+SI]
                Cmp     SI, Offset ChannelXX
                JNE     D_DrawFileWindow29

                Xor     AH, AH
                Push    AX                      ; Number of channels for MOD

                Mov     AH, 5
                Call    S_DrawString
                Pop     AX                      ; Add    SP, 2

                Jmp     D_DrawFileWindow14

D_DrawFileWindow29:
                Mov     AH, 5

D_DrawFileWindow13:
                LodsB
                And     AL, AL
                JZ      D_DrawFileWindow14

                StosW
                Jmp     D_DrawFileWindow13

D_DrawFileWindow14:
                Mov     DS, DS:DiskDataArea
                        Assume DS:Nothing

                Mov     DX, [BX+6]
                Mov     AX, [BX+4]
                Cmp     DX, 10000

                JAE     D_DrawFileWindow15

                Mov     DI, (51+41*80)*2

                Mov     CX, 10000
                Div     CX                      ; DX = remainder. AX = main.

                Mov     BP, AX

                Mov     CX, 4
                Mov     SI, 10
                Mov     AX, DX

D_DrawFileWindow16:
                Xor     DX, DX
                Div     SI
                Add     DL, '0'
                Push    DX

                Loop    D_DrawFileWindow16

                Mov     AX, BP

                Mov     CX, 5

D_DrawFileWindow17:
                Xor     DX, DX
                Div     SI
                Add     DL, '0'
                Push    DX

                Loop    D_DrawFileWindow17

                Mov     CX, 9

D_DrawFileWindow18:
                Pop     AX
                Mov     AH, 5
                StosW
                Loop    D_DrawFileWindow18

D_DrawFileWindow15:                             ; OK, time for a date :)
                Mov     DX, [DS:BX]             ; DX = time
                Mov     BX, [DS:BX+2]           ; BX = date

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     DI, (51+42*80)*2
                Mov     AX, BX
                ShR     AX, 5
                And     AX, 0Fh
                LEA     SI, [EAX+EAX]
                Mov     SI, [MonthNames+SI]

                Mov     AH, 5

D_DrawFileWindow19:
                LodsB
                StosW
                And     AL, AL
                JNZ     D_DrawFileWindow19

                Mov     AL, BL
                And     AX, 31
                Mov     CH, 10
                Div     CH
                And     AL, AL
                JZ      D_DrawFileWindow20

                Push    AX
                Add     AL, '0'
                Mov     AH, 5
                StosW

                Pop     AX

D_DrawFileWindow20:
                Mov     AL, AH
                Add     AL, '0'
                Mov     AH, 5
                StosW

                Mov     AL, ','
                StosW

                Mov     AL, ' '
                StosW

                Push    DX
                Mov     AL, BH
                ShR     AX, 1
                And     AX, 7Fh
                Add     AX, 1980
                Mov     DX, 0FFFFh
                Push    DX

                Mov     SI, 10

D_DrawFileWindow21:
                Xor     DX, DX
                Div     SI
                Add     DL, '0'
                Push    DX

                And     AX, AX
                JNZ     D_DrawFileWindow21

D_DrawFileWindow22:
                Pop     AX
                Cmp     AX, 0FFFFh
                JE      D_DrawFileWindow23

                Mov     AH, 5
                StosW

                Jmp     D_DrawFileWindow22

D_DrawFileWindow23:
                Pop     DX
                Mov     DI, (51+43*80)*2

                Mov     AX, DX
                ShR     AX, 11

                Xor     BL, BL                  ; if BL = 0, then am, otherwise
                                                ;  pm..
                Cmp     AX, 12
                JB      D_DrawFileWindow24

                Inc     BX
                Sub     AX, 12

D_DrawFileWindow24:
                And     AX, AX
                JNZ     D_DrawFileWindow25

                Add     AX, 12

D_DrawFileWindow25:
                Mov     BH, 10
                Div     BH
                And     AL, AL
                JZ      D_DrawfileWindow26

                Push    AX
                Add     AL, '0'
                Mov     AH, 5
                StosW

                Pop     AX

D_DrawFileWindow26:
                Mov     AL, AH
                Add     AL, '0'
                Mov     AH, 5
                StosW

                Mov     AL, ':'
                StosW

                Mov     AX, DX
                ShR     AX, 5
                And     AX, 63

                Div     BH
                Mov     BH, AH

                Add     AL, '0'
                Mov     AH, 5
                StosW

                Mov     AL, BH
                Add     AL, '0'
                StosW

                Mov     AL, 'a'
                And     BL, BL
                JZ      D_DrawFileWindow27

                Mov     AL, 'p'

D_DrawFileWindow27:
                StosW
                Mov     AL, 'm'
                StosW

                Ret

EndP            D_DrawFileWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_DrawDirectoryWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Call    S_GetDestination

                Mov     AX, TopDirectory
                Mov     BX, CurrentDirectory
                Cmp     AX, BX
                JBE     D_DrawDirectoryWindow1

                Mov     AX, BX

D_DrawDirectoryWindow1:
                LEA     CX, [EAX+20]
                Cmp     CX, BX
                JA      D_DrawDirectoryWindow2

                LEA     AX, [BX-20]

D_DrawDirectoryWindow2:
                Mov     TopDirectory, AX
                Mov     BX, AX

                Mov     CX, 21
                Mov     DI, (44+13*80)*2

                Mov     DS, DiskDataArea
                        Assume DS:Nothing

D_DrawDirectoryWindow3:
                Cmp     BX, CS:NumDirectories
                JAE     D_DrawDirectoryWindow4

                Mov     SI, BX
                Add     SI, CS:NumFiles
                Add     SI, SI
                Mov     SI, [SI]

                Push    DI

                Add     SI, 8
                Mov     AH, 5

D_DrawDirectoryWindow5:
                LodsB
                And     AL, AL
                JZ      D_DrawDirectoryWindow8

                StosW
                Jmp     D_DrawDirectoryWindow5

D_DrawDirectoryWindow8:
                Pop     DI
                Add     DI, 160
                Inc     BX

                Loop    D_DrawDirectoryWindow3

D_DrawDirectoryWindow4:
                Push    CS
                Pop     DS
                        Assume DS:Disk

                Cmp     NumDirectories, 0
                JE      D_DrawDirectoryWindow6

                Ret

D_DrawDirectoryWindow6:
                Mov     SI, Offset NoDirsMsg
                Mov     DI, (44+13*80)*2
                Mov     AH, 7
                Mov     CX, 8

D_DrawDirectoryWindow7:
                LodsB
                StosW

                Loop    D_DrawDirectoryWindow7

                Ret

EndP            D_DrawDirectoryWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_DrawDriveWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Call    S_GetDestination

                Mov     AL, TopDrive
                Mov     BL, CurrentDrive
                Cmp     AL, BL
                JBE     D_DrawDriveWindow1

                Mov     AL, BL

D_DrawDriveWindow1:
                Mov     CL, AL
                Add     CL, 20
                Cmp     CL, BL
                JA      D_DrawDriveWindow2

                Mov     AL, BL
                Sub     AL, 20

D_DrawDriveWindow2:
                Mov     TopDrive, AL
                Mov     BL, AL
                Mov     CX, 21

                Mov     DI, (59+13*80)*2
                Xor     BH, BH

D_DrawDriveWindow3:
                Cmp     BL, NumDrives
                JAE     D_DrawDriveWindow5

                Push    DI

                Mov     AL, [DrivesAvail+BX]
                Add     AL, 'A'
                Mov     SI, Offset DriveMsg
                Mov     [SI+6], AL

                Mov     AH, 5
                Mov     DX, 8

D_DrawDriveWindow4:
                LodsB
                StosW

                Dec     DX
                JNZ     D_DrawDriveWindow4

                Pop     DI
                Add     DI, 160
                Inc     BX
                Loop    D_DrawDriveWindow3

D_DrawDriveWindow5:
                Ret

EndP            D_DrawDriveWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LoadFileHeader                ; Given DS:SI = filename

                Push    BP

                Xor     BP, BP                  ; BP = 0 (no MMTSR)

                Mov     AX, 4370h
                Int     21h                     ; MMTSR installation check.

                Cmp     EAX, 4352697Ah
                JNE     D_LoadFileHeader2

                Mov     AX, 4372h
                Int     21h                     ; Disable MMTSR

                Inc     BP

D_LoadFileHeader2:
                Mov     DX, SI
                Mov     AX, 3D00h
                Int     21h                     ; Open File
                JC      D_LoadFileHeader1

                Mov     BX, AX                  ; BX = file handle

                Push    DS
                Pop     ES
                Mov     DI, 60000
                Mov     CX, 5536
                Xor     AL, AL
                Rep     StosB                   ; Clear data area first...

                Mov     AH, 3Fh
                Mov     CX, 5536
                Mov     DX, 60000
                Int     21h
                PushF

                JC      D_LoadFileHeader5
                Test    BP, BP
                JZ      D_LoadFileHeader5

                Cmp     DWord Ptr [DS:60000], 'CRiz'
                JNE     D_LoadFileHeader5

                Cmp     DWord Ptr [DS:60004], 'aiNO'
                JNE     D_LoadFileHeader5
                                                ; OK.. have a MMCMPed file.
                Mov     AX, 4200h
                Mov     DX, [DS:60018]
                Mov     CX, [DS:60020]
                Int     21h

                Mov     AH, 3Fh
                Mov     CX, 4
                Mov     DX, 60000
                Int     21h
                Cmp     AX, CX
                JNE     D_LoadFileHeader5

                Mov     AX, 4200h
                Mov     DX, [DS:60000]
                Mov     CX, [DS:60002]
                Int     21h                     ; Seek to offset in file.

                Mov     AH, 3Fh
                Mov     CX, 28
                Mov     DX, 60000
                Int     21h
                Cmp     AX, CX
                JNE     D_LoadFileHeader5

                Mov     AX, [DS:60014]
                ShR     AX, 4
                And     AL, 7
                JNZ     D_LoadFileHeader5

                PopF
                Mov     AH, 3Fh
                Mov     CX, 5536
                Mov     DX, 60000
                Int     21h
                PushF

D_LoadFileHeader5:
                Mov     AH, 3Eh                 ; Close file
                Int     21h

D_LoadFileHeader4:
                Test    BP, BP
                JZ      D_LoadFileHeader3
                                                ; Reenable MMTSR
                Mov     AX, 4371h
                Int     21h

D_LoadFileHeader3:
                PopF

                Pop     BP
                StI                             ; For problems with MMTSR
                Ret

D_LoadFileHeader1:
                StC
                PushF
                Jmp     D_LoadFileHeader4

EndP            D_LoadFileHeader

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LoadModuleHeader

                Mov     DS, DiskDataArea
                        Assume DS:Nothing

                Add     BX, BX
                Mov     SI, [BX]
                Add     SI, 8

                Call    D_LoadFileHeader

                Ret

EndP            D_LoadModuleHeader

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LoadSongNames Far             ; Part of idle list.

                Call    K_IsAnyKeyDown
                And     AL, AL
                JNZ     D_LoadSongNames2

                Call    GetKeyboardLock
                And     AL, AL
                JNZ     D_LoadSongNames2

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     BX, LoadSongNameCount
                Cmp     BX, NumFiles
                JB      D_LoadSongNames1

D_LoadSongNames2:
                Xor     AX, AX                  ; No redraw screen.
                Ret

D_LoadSongNames1:
                Inc     LoadSongNameCount

                Call    D_LoadModuleHeader
                JC      D_LoadSongNames3

                Call    D_GetSongNameModuleType

D_LoadSongNames3:

                Mov     AX, 1                   ; Signify redraw screen
                Ret

EndP            D_LoadSongNames

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_PreFileWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     AX, CurrentFile
                Sub     AX, TopFile
                Add     AX, 13
                Mov     BX, 160
                Mul     BX

                Call    S_GetDestination

                LEA     DI, [EAX+6]
                Mov     CX, 38

D_PreFileWindow1:
                Mov     AX, [ES:DI]
                Cmp     CX, 26

;                Cmp     AL, 168
                JNE     D_PreFileWindow2

                Mov     AH, 32h
                Jmp     D_PreFileWindow3

D_PreFileWindow2:
                Mov     AH, 30h

D_PreFileWindow3:
                StosW

                Loop    D_PreFileWindow1

                Mov     DI, (51+37*80)*2
                Xor     AH, AH
                Mov     AL, CurrentSearchPos
                LEA     DI, [EDI+EAX*2+1]
                Mov     AL, 60h
                StosB

                Ret

EndP            D_PreFileWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_PreDirectoryWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     AX, CurrentDirectory
                Sub     AX, TopDirectory
                Add     AX, 13
                Mov     BX, 160
                Mul     BX

                Call    S_GetDestination

                LEA     DI, [EAX+88]

                Mov     CX, 12

D_PreDirectoryWindow1:
                Mov     AX, [ES:DI]
                Mov     AH, 30h
                StosW

                Loop    D_PreDirectoryWindow1

                Ret

EndP            D_PreDirectoryWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_PreDriveWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     AL, CurrentDrive
                Sub     AL, TopDrive
                Add     AL, 13
                Mov     AH, 160
                Mul     AH

                Call    S_GetDestination
                LEA     DI, [EAX+118]
                Mov     CX, 8

D_PreDriveWindow1:
                Mov     AX, [ES:DI]
                Mov     AH, 30h
                StosW

                Loop    D_PreDriveWindow1

                Ret

EndP            D_PreDriveWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LoadFileOpenErrorMsg Far

                Mov     DI, (4+16*80)*2
                Mov     AH, 4

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset OpenErrorMsg

                Call    S_DrawString

                Mov     AX, 1
                Ret

EndP            D_LoadFileOpenErrorMsg
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_Decompress16BitData

; Register usage:
; BX = LastValue
; CH = Bitdepth
; CL = 16-Bitdepth, 0 for Bitdepth > 16
; DL = Bitsread
; DH = scratch

                PushAD
                Mov     BP, CX
                Mov     CX, 1100h
                ShR     BP, 1
                Xor     DX, DX
                Xor     BX, BX

D_Decompress16BitData1:
                Push    CX

                Mov     EAX, [SI]
                Mov     CL, DL
                ShR     EAX, CL

                Add     DL, CH
                Mov     CX, DX
                ShR     CX, 3
                Add     SI, CX
                And     DL, 7

                Pop     CX

                Cmp     CH, 6
                JA      D_Decompress16BitA

                ShL     EAX, CL
                Cmp     AX, 8000h
                JE      D_Decompress16BitDepthChange1

D_Decompress16BitD:
                SAR     AX, CL

D_Decompress16BitC:
                Add     BX, AX
                Mov     [ES:DI], BX
                ScasW
;                Add     DI, 2

                Dec     BP
                JNZ     D_Decompress16BitData1

                PopAD
                Ret

D_Decompress16BitDepthChange1:
                ShR     EAX, 16
                And     AL, 15

                Inc     AX

; Advance bits
                Add     DL, 4

D_Decompress16BitDepthChange3:
                Cmp     AL, CH
                SBB     AL, 0FFh
                Mov     CL, 16
                Mov     CH, AL
                Sub     CL, AL
                AdC     CL, 0

                Jmp     D_Decompress16BitData1

D_Decompress16BitA:
                Cmp     CH, 16
                JA      D_Decompress16BitB

                Push    DX
                Mov     DX, 0FFFFh
                ShR     DX, CL
                And     AX, DX
                ShR     DX, 1
                Add     DX, 8
                Cmp     AX, DX
                JA      D_Decompress16BitE
                Sub     DX, 16
                Cmp     AX, DX
                JBE     D_Decompress16BitE

                Sub     AX, DX
                Pop     DX
                Jmp     D_Decompress16BitDepthChange3

D_Decompress16BitE:
                Pop     DX
                ShL     AX, CL
                Jmp     D_Decompress16BitD

D_Decompress16BitB:
                Test    EAX, 10000h
                JZ      D_Decompress16BitC

                Mov     CL, 16
                Inc     AX

                Sub     CL, AL
                Mov     CH, AL

                Jmp     D_Decompress16BitData1

EndP            D_Decompress16BitData

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_Decompress8BitData    ; DS:SI = source
                                        ; ES:DI = destination
                                        ; CX = count.

                PushA
                Mov     BP, CX          ; BP = counter;

                Mov     BX, 900h
                Xor     CX, CX
                Xor     DX, DX

; Register usage:
; BH = Bitdepth
; BL = lastvalue
; CL = 8-bitdepth, undefined for bitdepth > 8
; CH = Bitsread

; DX = scratch

D_Decompress8BitData1:
                Push    CX
                Mov     AX, [SI]
                Mov     CL, CH

; Get bits loaded into AX properly.
                ShR     AX, CL
                Pop     CX

; Advance SI as necessary.
                Add     CH, BH
                Mov     DL, CH
                And     CH, 7
                ShR     DL, 3
                Add     SI, DX

                Cmp     BH, 6
                JA      D_Decompress8BitA

                ShL     AX, CL

                Cmp     AL, 80h
                JE      D_Decompress8BitDepthChange1

D_Decompress8BitWriteData2:
                SAR     AL, CL

D_Decompress8BitWriteData:
                Add     BL, AL
                Mov     [ES:DI], BL

                Inc     DI
                Dec     BP

                JNZ     D_Decompress8BitData1
                PopA
                Ret

D_Decompress8BitDepthChange1:
                Mov     AL, AH
                Add     CH, 3

                And     AL, 7
                Mov     DL, CH

                And     CH, 7
                ShR     DL, 3

                Add     SI, DX
                Jmp     D_Decompress8BitD

D_Decompress8BitA:
                Cmp     BH, 8
                JA      D_Decompress8BitC
                JE      D_Decompress8BitB

                ShL     AL, 1
                Cmp     AL, 78h
                JB      D_Decompress8BitWriteData2
                Cmp     AL, 86h
                JA      D_Decompress8BitWriteData2

                ShR     AL, 1
                Sub     AL, 3Ch
                Jmp     D_Decompress8BitD

D_Decompress8BitB:
                Cmp     AL, 7Ch
                JB      D_Decompress8BitWriteData
                Cmp     AL, 83h
                JA      D_Decompress8BitWriteData

                Sub     AL, 7Ch

D_Decompress8BitD:
                Mov     CL, 8
                Inc     AX

                Cmp     AL, BH
                SBB     AL, 0FFh
                Mov     BH, AL
                Sub     CL, AL
                AdC     CL, 0

                Jmp     D_Decompress8BitData1

D_Decompress8BitC:                      ; 9 bit representation
                And     AX, 1FFh

                Test    AX, 100h
                JZ      D_Decompress8BitWriteData

                Jmp     D_Decompress8BitD

EndP            D_Decompress8BitData

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

TempData                DW      0
DisableStereoMenu       DB      0

Proc            D_LoadSampleData                ; DS:SI points to sample header
                                                ; AX = sample number (0 based)

                Push    DS
                Push    ES
                PushAD

                Mov     EDX, [DS:SI+30h]
                And     EDX, EDX
                JZ      D_NoLoadSample

                Mov     CL, [SI+12h]
                Mov     BP, [SI+2Eh]

                And     Byte Ptr [SI+12h], Not 0Ch
                Mov     Byte Ptr [SI+2Eh], 1
                And     BP, 0FFh

                ShL     BP, 1
                Mov     CH, CL
                And     CX, 802h
                ShL     CH, 4
                ShR     CL, 1
                Or      BP, CX                  ; BP flags:
                                                ; 1: 16 bit
                                                ; 2: Convert unsigned->signed
                                                ; 4: Swap bytes
                                                ; 8: Delta values.
                                                ; 16: Byte delta values
                                                ; 32: 12-bit sample.
                                                ; 64: Stereo prompt.
                                                ; 8000h: Compressed.

                Xor     SI, SI

                Test    BP, 1
                JZ      D_LoadSampleData5

                Add     EDX, EDX

D_LoadSampleData5:
                Test    BP, 64
                JZ      D_LoadSampleDataNotStereo

                Cmp     CS:DisableStereoMenu, 0
                JNE     D_NoStereoMenu

                PushAD
                Push    DS ES

                Mov     DI, Offset O1_StereoSampleList
                Mov     CX, 0FFFFh
                Call    M_Object1List

                Mov     CS:TempData, DX

                Pop     ES DS
                PopAD

                Or      BP, CS:TempData                 ; 64 = left
                                                        ; 64+128 = right
D_NoStereoMenu:
                Add     EDX, EDX

D_LoadSampleDataNotStereo:
                Call    Music_AllocateSample            ; AX = sample no.
                                                        ; EDX = length.
                                                        ; returns ES:DI.
                Inc     AX

                Mov     EDI, EDX

                Mov     DX, ES
                Test    DX, DX
                JZ      D_LoadSampleData1

                Push    DS

                Xor     CX, CX                          ; Start with page 0

D_LoadSampleData3:
                Push    AX                      ; AX = sample no.
                Push    CX                      ; CH = page no.
                Push    EDI                     ; EDI = bytes remaining
                                                ; SI = delta accumulator
                                                ; BX = file pointer

                Push    SI
                Call    Music_GetSampleLocation
                Mov     DX, SI
                Pop     SI

                Mov     ECX, 32768
                Cmp     EDI, ECX
                JA      D_LoadSampleData4

                Mov     CX, DI

D_LoadSampleData4:
                Test    BP, 32                  ; 12 bit format?
                JZ      NotTX12BitSampleA

                And     ECX, 0FFFFh
                LEA     ECX, [ECX*2+ECX]
                Add     ECX, 3
                ShR     ECX, 2                  ; ECX = bytes to read.

NotTX12BitSampleA:

; DS:DX point to buffer. For compressed samples, use
;       patterndata area.

                Test    BP, BP
                JNS     LoadCompressedSample1

                Push    DS
                Push    CX
                Push    DX

                Mov     DX, Pattern
                Mov     DS, DX
                        Assume DS:Pattern

                Mov     DS, Word Ptr [PatternDataArea]
                        Assume DS:Nothing

                Xor     DX, DX
                Mov     CX, 2
                Mov     AH, 3Fh
                Int     21h
                Mov     CX, [DS:0]              ; Bytes to read.
                Xor     DX, DX                  ; Compressed chunk.

LoadCompressedSample1:

                Mov     AH, 3Fh
                Int     21h

; Now to decompress samples, if required.

                Test    BP, BP
                JNS     LoadCompressedSample3

                Pop     DI
                Pop     CX
                Pop     ES
                Xor     SI, SI

                Test    BP, 1
                JNZ     LoadCompressedSample2

                Call    D_Decompress8BitData    ; 8 bit decode.
                Jmp     LoadCompressedSample4

LoadCompressedSample2:                          ; 16 bit decode
                Call    D_Decompress16BitData

LoadCompressedSample4:
                Push    ES
                Pop     DS

                Xor     SI, SI
                Jmp     SecondDelta

LoadCompressedSample3:
                Test    BP, 32                  ; 12-bit sample?
                JZ      NotTX12BitSampleB
                                                ; CX = number of bytes read.
                                                ;    = 3*2 number of sample read
                Push    SI
                Push    DX

                Add     AX, 2
                Mov     CX, 3
                Div     CX
                Mov     CX, AX
                Pop     DX

                LEA     SI, [EAX*2+EAX]         ; SI = AX * 3
                LEA     DI, [EAX*4+EDX]
                Add     SI, DX

                Test    CX, CX
                JZ      ConvertTXSample2

                Push    CX

ConvertTXSample1:
                Sub     SI, 3
                Sub     DI, 4

                Mov     AX, [SI+1]
                ShL     AL, 4
                ShL     EAX, 16
                Mov     AH, [SI]
                Mov     AL, [SI+1]
                And     AL, 0F0h
                Mov     [DI], EAX

                Loop    ConvertTXSample1

                Pop     CX
                Pop     SI
                ShL     CX, 1
                Jmp     D_LoadSampleData10

ConvertTXSample2:
                Pop     SI
                Jmp     D_LoadSampleData6

NotTX12BitSampleB:
                Mov     CX, AX                  ; CX = number of bytes read

SecondDelta:
                Test    BP, 1                   ; 16 bit?
                JZ      D_LoadSampleData10

                ShR     CX, 1

D_LoadSampleData10:
                Mov     AX, BP
                And     AX, 5                   ; 16 bit and BSwap?
                Cmp     AX, 5
                JNE     D_LoadSampleData11

                Push    CX
                Mov     DI, DX

D_LoadSampleData12:
                Mov     AX, [DI]
                XChg    AH, AL
                Mov     [DI], AX
                ScasW
;                Add     DI, 2
                Loop    D_LoadSampleData12

                Pop     CX

D_LoadSampleData11:
                Test    BP, 24                  ; Delta values?
                JZ      D_LoadSampleData8

                Push    CX
                Mov     AX, SI
                Mov     DI, DX

                Test    BP, 1                   ; 8 bit sample?
                JZ      D_LoadSampleData9

                Test    BP, 16                  ; Byte enforced?
                JZ      D_LoadSampleData7

                Add     CX, CX
                Jmp     D_LoadSampleData9

D_LoadSampleData7:                      ; 16 bit delta
                Add     AX, [DI]
                Mov     [DI], AX

;                Add     DI, 2
                ScasW
                Loop    D_LoadSampleData7

                Mov     SI, AX
                Pop     CX

                Jmp     D_LoadSampleData8

D_LoadSampleData9:                      ; 8 bit delta
                Add     AH, [DI]
                Mov     [DI], AH
                Inc     DI
                Loop    D_LoadSampleData9

                Mov     SI, AX
                Pop     CX

D_LoadSampleData8:
                Test    BP, 2                   ; unsigned->signed?
                JNZ     D_LoadSampleData6

                Push    CX
                Mov     DI, DX

                Test    BP, 1
                JNZ     D_LoadSampleData14

D_LoadSampleData13:                     ; 8 bit
                Xor     Byte Ptr [DI], 80h
                Inc     DI
                Loop    D_LoadSampleData13

                Pop     CX

                Jmp     D_LoadSampleData6

D_LoadSampleData14:                     ; 16 bit..
                Xor     Word Ptr [DI], 8000h
;                Add     DI, 2
                ScasW
                Loop    D_LoadSampleData14

                Pop     CX

D_LoadSampleData6:
                Test    BP, 64          ; Stereo?
                JZ      D_LoadSampleDataNoStereo

                Push    SI ES

                Push    DS
                Pop     ES

                Mov     SI, DX
                Mov     DI, DX

                ShR     CX, 1
                JZ      D_LoadSampleDataEndStereo

                Test    BP, 1           ; 8/16 bit?
                JNZ     D_LoadSampleDataStereo16BitStart

                Test    BP, 128
                JZ      D_LoadSampleDataStereo8Bit

                Inc     SI

D_LoadSampleDataStereo8Bit:
                MovsB
                Inc     SI
                Loop    D_LoadSampleDataStereo8Bit
                Jmp     D_LoadSampleDataEndStereo

D_LoadSampleDataStereo16BitStart:
                Test    BP, 128
                JZ      D_LoadSampledataStereo16Bit

                LodsW

D_LoadSampleDataStereo16Bit:
                MovsW
                LodsW
                Loop    D_LoadSampleDataStereo16Bit

D_LoadSampleDataEndStereo:
                Pop     ES SI

                Pop     EDI
                Pop     CX
                Pop     AX

                Inc     CH
                Jmp     D_LoadSampleDataNextChain

D_LoadSampleDataNoStereo:
                Pop     EDI
                Pop     CX
                Pop     AX

                Add     CH, 2

D_LoadSampleDataNextChain:
                Sub     EDI, 32768
                JA      D_LoadSampleData3

                Pop     DS

D_NoLoadSample:
                ClC

                PopAD
                Pop     ES
                Pop     DS
                Ret

D_LoadSampleData1:
                PopAD
                PushAD

                Mov     AX, 4201h               ; Advance file ptr.
                Mov     DX, [DS:SI+30h]
                Mov     CX, [DS:SI+32h]
                Int     21h

                Call    PEFunction_OutOfMemoryMessage

                PopAD
                Pop     ES
                Pop     DS

                StC
                Ret

EndP            D_LoadSampleData

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ConvertWriteData        ; DS:DX points to data
                                        ; BP = 1, convert, BP = 2, 16-bit
                                        ; CX = number of bytes

                PushF

                Push    AX
                Push    CX
                Push    SI

                Mov     AX, 1
                Test    BP, 2
                JZ      ConvertWriteDataLoop1

                Inc     AX
                Inc     SI
                ShR     CX, 1

ConvertWriteDataLoop1:
                JCXZ    ConvertWriteDataLoop3

ConvertWriteDataLoop2:
                Xor     Byte Ptr [SI], 80h
                Add     SI, AX
                Loop    ConvertWriteDataLoop2

ConvertWriteDataLoop3:
                Pop     SI
                Pop     CX
                Pop     AX

ConvertWriteData1:
                PopF
                Ret

EndP            ConvertWriteData

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SaveSampleDataConvert         ; AX = sample number (1 based)

                PushAD
                Push    DS
                Push    ES

                Xor     BP, BP

                Call    Music_GetSampleLocation
                Mov     EDI, ECX
                JZ      D_SaveSampleDataConvert5

                Add     EDI, EDI
                Or      BP, 2

D_SaveSampleDataConvert5:
                Xor     CX, CX                          ; Start with page 0

D_SaveSampleDataConvert3:
                Push    AX                      ; AX = sample no.
                Push    CX                      ; CX = page no.

                Call    Music_GetSampleLocation
                Mov     DX, SI

                Mov     ECX, 32768
                Cmp     EDI, ECX
                JA      D_SaveSampleDataConvert4

                Mov     CX, DI

D_SaveSampleDataConvert4:
                ClI

                Call    ConvertWriteData
                Call    D_SaveBlock
                Call    ConvertWriteData

                StI

                Pop     CX
                Pop     AX

                JC      D_SaveSampleDataConvert2

                Add     CH, 2
                Sub     EDI, 32768
                JA      D_SaveSampleDataConvert3

                DB      85h             ; ClC
D_SaveSampleDataConvert2:
                StC
                Pop     ES
                Pop     DS
                PopAD
                Ret

EndP            D_SaveSampleDataConvert

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            WriteBits               ; CH = bits to write
                                        ; CL = current bit.
                                        ; BX = data.
                                        ; ES:DI = output buffer.
                                        ; EAX = buffer
                                        ; BP = scratch

                Push    CX

                Mov     EBP, 1
                Mov     CL, CH
                ShL     EBP, CL
                Dec     EBP
                And     EBX, EBP

                Pop     CX
                ShL     EBX, CL
                Add     CL, CH
                Or      EAX, EBX

D_WriteBits1:
                Cmp     CL, 8
                JB      D_WriteBits2

                StosB
                ShR     EAX, 8
                Sub     CL, 8
                Jmp     D_WriteBits1

D_WriteBits2:
                Ret

EndP            WriteBits

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

; Data layout:
;     DiskDataArea:16384 = deltas
;     PatternDataArea:16384 = bittable
;     PatternDataArea:0 = bufferlength
;     PatternDataArea:2 = outputbuffer

Proc            D_SaveSampleDataCompressed      ; AX = sample number, 1 based.

                PushAD
                Push    DS
                Push    ES

                Xor     BP, BP

                Call    Music_GetSampleLocation
                Mov     EDI, ECX
                JZ      D_SaveSampleDataCompressed5

                Add     EDI, EDI
                Inc     BP

D_SaveSampleDataCompressed5:
                Xor     CX, CX                          ; Start with page 0

D_SaveSampleDataCompressed3:
                Push    AX                      ; AX = sample no.
                Push    CX                      ; CX = page no.
                Push    EDI

                Call    Music_GetSampleLocation

                Mov     ECX, 32768
                Cmp     EDI, ECX
                JA      D_SaveSampleDataCompressed4

                Mov     CX, DI

D_SaveSampleDataCompressed4:
                Test    BP, 1
                JZ      D_SaveSampleCompressed8BitSample

                ShR     CX, 1

D_SaveSampleCompressed8BitSample:
; DS:SI = sample location
; Calculate delats first.
                Push    BX
                Push    BP
                Push    CX

                Mov     ES, CS:DiskDataArea
                Mov     DI, 16384       ; Offset in DiskDataArea

IF DDCOMPRESS
                Mov     DX, 1

                Cmp     CS:SaveFormat, 3
                JNE     D_SaveFormatNot215

                Inc     DX

D_SaveFormatNot215:

ENDIF

D_CalculateDeltas:
                Xor     AH, AH          ; AH = lastdata.

                Test    BP, 1
                JZ      D_Calculate8BitDeltas

                Xor     BX, BX

D_Calculate16BitDeltas:
                LodsW
                Sub     AX, BX
                Mov     BX, [SI-2]
                StosW
                Loop    D_Calculate16BitDeltas

                Jmp     D_CalculateDeltaEnd

D_Calculate8BitDeltas:
                LodsB
                Sub     AL, AH
                Mov     AH, [SI-1]
                StosB
                Loop    D_Calculate8BitDeltas

D_CalculateDeltaEnd:

IF DDCOMPRESS
                Mov     DI, 16384
                Pop     CX
                Push    ES
                Mov     SI, DI
                Pop     DS
                Push    CX

                Dec     DX
                JNZ     D_CalculateDeltas

                Push    Pattern
                Pop     ES
                        Assume ES:Pattern
                Mov     ES, PatternDataArea
                        Assume ES:Nothing

ELSE

                Pop     CX

; Now to create bittable.

                Push    ES
                Pop     DS

                Push    Pattern
                Pop     ES
                        Assume ES:Pattern
                Mov     ES, PatternDataArea
                        Assume ES:Nothing

                Push    CX

                Mov     SI, 16384
                Mov     DI, SI
ENDIF

                Mov     BH, 40
                Test    BP, 1
                JZ      D_GenerateBitTable1

                Xor     AX, AX

D_Generate16BitTable1:
                Mov     BL, [SI+1]
                Mov     BH, 41
                Mov     AL, [BX]
                Mov     DL, AL
                And     DL, 7
                Mov     BL, [SI]
                Add     BH, DL
                ShR     AL, 3
                Add     SI, 2
                Add     AL, [BX]
                StosW

                Loop    D_Generate16BitTable1
                Pop     CX

; Minimise 16-bit table
                Push    ES
                Pop     DS
                Mov     Byte Ptr [DS:16382], 17 ; Starting boundary of 17.
                Mov     DL, 1   ; Scan for 1 bit first.

D_Minimise16BitTable1:
                Push    CX
                Xor     AX, AX  ; AX = consecutive values.
                Mov     SI, 16384

D_Minimise16BitTable2:
                Test    AX, AX
                JNZ     D_Minimise16BitTable3

; Not in consecutive sequence.
                Cmp     DL, [SI]
                JNE     D_Minimise16BitTableEnd
                Mov     DI, SI          ; First value

D_Minimise16BitTable4:
                Inc     AX
                Jmp     D_Minimise16BitTableEnd

D_Minimise16BitTable3:
                Cmp     DL, [SI]
                JE      D_Minimise16BitTable4

; OK.. outside of bittable
                Cmp     AX, 33
                JA      D_Minimise16BitTable5

                Mov     BL, [SI]
                Mov     BH, [DI-2]

                Cmp     BL, BH
                JBE     D_Minimise16BitTable6

                XChg    BL, BH

D_Minimise16BitTable6:
                Cmp     BL, DL
                JA      D_Minimise16BitTable7
                XChg    BL, BH

                Cmp     BL, DL
                JB      D_Minimise16BitTable5

D_Minimise16BitTable7:            ; BL = minbits.
                Push    CX
                Push    DX

                Mov     CH, BL
                Mov     DH, BL          ; DH = minbits.

                Cmp     AX, 1
                JE      D_Minimise16BitTableForce

                Cmp     BL, 5
                JA      D_Minimise16BitTable8

                Add     BL, 4

D_Minimise16BitTable8:
                Cmp     BH, 5
                JA      D_Minimise16BitTable9

                Add     BL, 4

D_Minimise16BitTable9:
                Mov     CL, CH
                And     BX, 0FFh                ; BX = bits to effect conversion

                Cmp     AX, BX
                JA      D_Minimise16BitTable13

                And     CX, 0FFh                ; CX = minbits.

                Sub     CL, DL
                Push    DX
                Mul     CX                      ; DX:AX = bits saved.
                Pop     CX
                Test    DX, DX
                JNZ     D_Minimise16BitTable13
                Cmp     AX, BX
                JA      D_Minimise16BitTable13

D_Minimise16BitTableForce:
; Have to change values from DI -> SI with minbits.
                Mov     AL, CH
                Mov     CX, SI
                Sub     CX, DI
                ShR     CX, 1
                Rep     StosW

D_Minimise16BitTable13:
                Pop     DX
                Pop     CX

D_Minimise16BitTable5:
                Xor     AX, AX

D_Minimise16BitTableEnd:
                Add     SI, 2
                Loop    D_Minimise16BitTable2

                Pop     CX

                And     DX, 0FFh
                Inc     DX
                Cmp     DX, 17
                JB      D_Minimise16BitTable1

; Now to dump bits to buffer.

                Mov     DX, CX
                Mov     DS, CS:DiskDataArea
                Xor     EAX, EAX
                Mov     DI, 2
                Mov     SI, 16384
                Mov     CX, 1100h

; Convert 16 Bit Buffer.

D_Convert16BitBuffer1:
                Cmp     CH, [ES:SI]     ; BitsToWrite = BitTable?
                JE      D_Convert16BitBufferEnd

; Need to change base
                Cmp     CH, 6
                JA      D_Convert16BitBuffer2

                Push    CX
                Mov     BX, 1
                Mov     CL, CH
                Dec     CL
                ShL     BX, CL
                Pop     CX
                Call    WriteBits

                Mov     BL, [ES:SI]
                Cmp     CH, BL
                SBB     BL, 1
                Mov     CH, 4
                Call    WriteBits
                Jmp     D_Convert16BitBufferDepthChange

D_Convert16BitBuffer2:
                Cmp     CH, 16
                JA      D_Convert16BitBuffer3

                Push    CX
                Mov     EBX, 1
                Mov     CL, CH
                Dec     CL
                ShL     EBX, CL
                Sub     BX, 9
                Add     BL, [ES:SI]
                AdC     BH, 0
                Pop     CX

                Cmp     CH, [ES:SI]
                SBB     BL, 0
                Call    WriteBits
                Jmp     D_Convert16BitBufferDepthChange

D_Convert16BitBuffer3:
                Mov     EBX, 100FFh
                Add     BL, [ES:SI]
                Call    WriteBits

D_Convert16BitBufferDepthChange:
                Mov     CH, [ES:SI]

D_Convert16BitBufferEnd:
                MovZX   EBX, Word Ptr [SI]
                Call    WriteBits

                Add     SI, 2
                Dec     DX
                JNZ     D_Convert16BitBuffer1

                Jmp     D_ConvertBitsFinished


D_GenerateBitTable1:
                Mov     BL, [SI]
                Inc     SI
                Mov     AL, [BX]
                StosB
                Loop    D_GenerateBitTable1

D_GenerateBitTableDone:

; OK bit table is generated.
                Pop     CX

; Have to minimise bit table (in patterndataarea)


                Push    ES
                Pop     DS
                Mov     Byte Ptr [DS:16383], 9     ; Starting boundary of 9.
                Mov     DL, 1   ; Scan for 1 bit first.

D_MinimiseBitTable1:
                Push    CX
                Xor     AX, AX  ; AX = consecutive values.
                Mov     SI, 16384

D_MinimiseBitTable2:
                Test    AX, AX
                JNZ     D_MinimiseBitTable3

; Not in consecutive sequence.
                Cmp     DL, [SI]
                JNE     D_MinimiseBitTableEnd
                Mov     DI, SI          ; First value

D_MinimiseBitTable4:
                Inc     AX
                Jmp     D_MinimiseBitTableEnd

D_MinimiseBitTable3:
                Cmp     DL, [SI]
                JE      D_MinimiseBitTable4

; OK.. outside of bittable
                Cmp     AX, 17
                JA      D_MinimiseBitTable5

                Mov     BL, [SI]
                Mov     BH, [DI-1]

                Cmp     BL, BH
                JBE     D_MinimiseBitTable6

                XChg    BL, BH

D_MinimiseBitTable6:
                Cmp     BL, DL
                JA      D_MinimiseBitTable7
                XChg    BL, BH

                Cmp     BL, DL
                JB      D_MinimiseBitTable5

D_MinimiseBitTable7:            ; BL = minbits.
                Push    CX
                Push    DX

                Mov     DH, BL          ; DH = minbits.
                Mov     CH, BL

                Cmp     AX, 1
                JE      D_MinimiseBitTableForce

                Cmp     BL, 5
                JA      D_MinimiseBitTable8

                Add     BL, 3

D_MinimiseBitTable8:
                Cmp     BH, 5
                JA      D_MinimiseBitTable9

                Add     BL, 3

D_MinimiseBitTable9:
                Mov     CL, CH                  ; CL = minbits.
                And     BX, 0FFh                ; BX = bits to effect conversion

                Cmp     AX, BX
                JA      D_MinimiseBitTable13

                And     CX, 0FFh                ; CX = minbits.

                Sub     CL, DL
                Push    DX
                Mul     CX                      ; DX:AX = bits saved.
                Pop     CX
                Test    DX, DX
                JNZ     D_MinimiseBitTable13
                Cmp     AX, BX
                JA      D_MinimiseBitTable13

; Have to change values from DI -> SI with minbits.
D_MinimiseBitTableForce:
                Mov     AL, CH
                Mov     CX, SI
                Sub     CX, DI
                Rep     StosB

D_MinimiseBitTable13:
                Pop     DX
                Pop     CX

D_MinimiseBitTable5:
                Xor     AX, AX

D_MinimiseBitTableEnd:
                Inc     SI
                Loop    D_MinimiseBitTable2

                Pop     CX

                And     DX, 0FFh
                Inc     DX
                Cmp     DX, 9
                JB      D_MinimiseBitTable1

; Now to dump bits to buffer.

                Mov     DX, CX
                Mov     DS, CS:DiskDataArea
                Xor     EAX, EAX
                Mov     DI, 2
                Mov     SI, 16384
                Mov     CX, 900h

D_ConvertBitBuffer1:                    ; CL = current bit
                                        ; CH = bitstowrite
                                        ; AX = output buffer
                                        ; DX = bytes to process
                                        ; SI = DS:source/ES:bittable
                                        ; DI = destination

                Cmp     CH, [ES:SI]     ; BitsToWrite = BitTable?
                JE      D_ConvertBitBufferEnd

; Need to change base
                Cmp     CH, 6
                JA      D_ConvertBitBuffer2

                Push    CX
                Mov     BX, 1
                Mov     CL, CH
                Dec     CL
                ShL     BX, CL
                Pop     CX
                Call    WriteBits

                Mov     BL, [ES:SI]
                Cmp     CH, BL
                SBB     BL, 1
                Mov     CH, 3
                Call    WriteBits
                Jmp     D_ConvertBitBufferDepthChange

D_ConvertBitBuffer2:
                Cmp     CH, 8
                JA      D_ConvertBitBuffer3

                Push    CX
                Mov     BX, 1
                Mov     CL, CH
                Dec     CL
                ShL     BX, CL
                Sub     BL, 5
                Add     BL, [ES:SI]
                Pop     CX

                Cmp     CH, [ES:SI]
                SBB     BL, 0
                Call    WriteBits
                Jmp     D_ConvertBitBufferDepthChange

D_ConvertBitBuffer3:
                Mov     BX, 1FFh
                Add     BL, [ES:SI]
                Call    WriteBits

D_ConvertBitBufferDepthChange:
                Mov     CH, [ES:SI]

D_ConvertBitBufferEnd:
                MovZX   BX, Byte Ptr [SI]
                Call    WriteBits

                Inc     SI
                Dec     DX
                JNZ     D_ConvertBitBuffer1

D_ConvertBitsFinished:
                Xor     CH, CH
                Add     CL, 7
                ShR     CL, 3
                Rep     StosB           ; Write 0 or 1 bytes.

; DI = end of block = size;

                Pop     BP
                Pop     BX

                Mov     CX, DI
                Sub     DI, 2

                Push    ES
                Pop     DS

                Mov     [DS:0], DI

                Xor     DX, DX
                Call    D_SaveBlock

                Pop     EDI
                Pop     CX
                Pop     AX

                JC      D_SaveSampleDataCompressed2

                Add     CH, 2
                Sub     EDI, 32768
                JA      D_SaveSampleDataCompressed3

                DB      85h
D_SaveSampleDataCompressed2:
                StC
                Pop     ES
                Pop     DS
                PopAD
                Ret

EndP            D_SaveSampleDataCompressed

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SaveSampleData                ; AX = sample number (1 based)

                PushAD
                Push    DS
                Push    ES

                Call    Music_GetSampleLocation
                Mov     EDI, ECX
                JZ      D_SaveSampleData1

                Add     EDI, EDI

D_SaveSampleData1:
                Xor     CX, CX                          ; Start with page 0

D_SaveSampleData3:
                Push    AX                      ; AX = sample no.
                Push    CX                      ; CX = page no.

                Call    Music_GetSampleLocation
                Mov     DX, SI

                Mov     ECX, 32768
                Cmp     EDI, ECX
                JA      D_SaveSampleData4

                Mov     CX, DI

D_SaveSampleData4:
                Call    D_SaveBlock
                Pop     CX
                Pop     AX
                JC      D_SaveSampleData2

                Add     CH, 2
                Sub     EDI, 32768
                JA      D_SaveSampleData3

                DB      85h
D_SaveSampleData2:
                StC
                Pop     ES
                Pop     DS
                PopAD

                Ret

EndP            D_SaveSampleData

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

include it_timer.inc
include it_d_rm.inc

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_CheckOverWrite                ; DS:DX points to filename
                                                ; Returns Carry set if not ok

                Mov     CX, 6
                Mov     AH, 4Eh
                Int     21h
                JC      D_CheckOverWrite1       ; File doesn't exist.

                                                ; File Already exists...

                Push    BX
                Push    DS
                Push    SI

                Mov     DI, Offset O1_ConfirmOverWriteList
                Mov     CX, 4
                Call    M_Object1List
                                                ; DX = 0 -> don't overwrite
                                                ; DX = 1 -> overwrite
                Pop     SI
                Pop     DS
                Pop     BX

                Test    DX, DX
                JZ      D_CheckOverWrite2

D_CheckOverWrite1:
                DB      85h

D_CheckOverWrite2:
                StC
                Ret


EndP            D_CheckOverWrite

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_PostFileSaveWindow Far

;                Cmp     DX, 13
                Cmp     CX, 11Ch
                JNE     D_PostFileWindow
                                        ; Save file routines.
                Mov     DS, CS:DiskDataArea
                Mov     SI, CurrentFile
                Add     SI, SI
                Mov     SI, [SI]
                Add     SI, 8           ; Filename
                Mov     DI, Offset SaveFileName

                Push    CS
                Pop     ES

D_PostFileSaveWindow1:
                LodsB
                StosB
                And     AL, AL
                JNZ     D_PostFileSaveWindow1

D_PostFileSaveWindow2:
                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     DX, Offset SaveFileName
                Call    D_CheckOverWrite
                JNC     D_PostFileSaveWindow3   ; OK to write!

                Mov     AX, 1
                Ret

D_PostFileSaveWindow3:
                Cmp     SaveFormat, 1
                JE      D_PostFileSaveWindow4

                Jmp     D_SaveFileITModule

D_PostFileSaveWindow4:
                Jmp     D_SaveFileS3MModule

EndP            D_PostFileSaveWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_PostFileLoadWindow Far

;                Cmp     DX, 13
                Cmp     CX, 11Ch
                JNE     D_PostFileWindow
                                        ; Load file routines.

D_PostFileLoadWindowLink:
                EnsureNoNetwork

                Call    PECheckModified

                Call    Music_Stop

                Mov     BX, CS:CurrentFile
                Call    D_LoadModuleHeader
                JC      D_PostFileLoadWindow1

                Push    DI
                Call    D_GetSongNameModuleType
                Pop     DI

IF TUTORIAL
ELSE
                Mov     BX, CS:CurrentFile
                Add     BX, BX
                Mov     BX, [BX]
                Mov     AX, [BX+23]

                Cmp     AX, 1
                JBE     D_PostFileLoadWindow1

                Cmp     AX, 3
                JB      D_LoadFileImpulseModule
                JE      D_PostFileLoadWindow1

                Cmp     AX, 5
                JB      D_LoadFileS3MModule
                JE      D_LoadFileXMModule

                Cmp     AX, 7
                JB      D_LoadFile669Module
                JE      D_LoadFileImpulseModule

                Cmp     AX, 8
                JBE     D_PostFileLoadWindow1

                Cmp     AX, 17
                JBE     D_LoadFileMODModule

                Cmp     AX, 18
                JE      D_LoadFileMTMModule
ENDIF

D_PostFileLoadWindow1:
                Mov     AX, 1
                Ret

EndP            D_PostFileLoadWindow

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_PostFileWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset FileWindowKeys
                Call    M_FunctionDivider
                JC      D_PostFileWindow1

                Jmp     [SI]

D_PostFileWindow1:
                Cmp     CX, 10Eh
                JNE     D_PostFileWindow15

D_PostFileWindowBackspace:
                Mov     BL, CurrentSearchPos
                Test    BL, BL
                JZ      D_PostFileWindow14

                Dec     BX
                Xor     BH, BH
                Mov     [Search+BX], 0
                Mov     CurrentSearchPos, BL

D_PostFileWindow14:
                Mov     AX, 1
                Ret

D_PostFileWindow15:
                Test    CL, CL
                JZ      D_PostFileWindow20
                Cmp     DL, 33
                JB      D_PostFileWindow20

                Cmp     CurrentSearchPos, 13
                JAE     D_PostFileWindow17

                Cmp     DL, 'a'
                JB      D_PostFileWindow16

                Cmp     DL, 'z'
                JA      D_PostFileWindow16

                Sub     DL, 32

D_PostFileWindow16:
                Mov     BL, CurrentSearchPos
                Xor     BH, BH
                Mov     [Search+BX], DL

                Inc     CurrentSearchPos
                                                ; Now do the search.
                Xor     DX, DX

                Mov     ES, DiskDataArea

D_PostFileWindow18:
                Cmp     DX, NumFiles
                JAE     D_PostFileWindow17

                Mov     BX, DX
                Add     BX, BX
                Mov     DI, [ES:BX]
                Add     DI, 8
                Mov     SI, Offset Search
                Mov     CX, 13

D_PostFileWindow21:
                Cmp     Byte Ptr [DS:SI], 0
                JE      D_PostFileWindow19

                CmpsB
                JE      D_PostFileWindow21

                Inc     DX
                Jmp     D_PostFileWindow18

D_PostFileWindow19:
                Mov     CurrentFile, DX

D_PostFileWindow17:
                Mov     AX, 1
                Ret

D_PostFileWindow20:
                Xor     AX, AX
                Ret

EndP            D_PostFileWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_PostDirectoryWindow Far

                Push    CS
                Pop     DS
                        Assume  DS:Disk

                Mov     SI, Offset DirectoryWindowKeys
                Call    M_FunctionDivider
                JC      D_PostDirectoryWindow1

                Jmp     [SI]

D_PostDirectoryWindow1:
                Cmp     CX, 10Eh
                JNE     D_PostDirectoryWindow15

                Jmp     D_PostFileWindowBackspace

D_PostDirectoryWindow15:
                Test    CL, CL
                JZ      D_PostDirectoryWindow20
                Cmp     DL, 33
                JB      D_PostDirectoryWindow20

                Cmp     CurrentSearchPos, 13
                JAE     D_PostDirectoryWindow17

                Cmp     DL, 'a'
                JB      D_PostDirectoryWindow16

                Cmp     DL, 'z'
                JA      D_PostDirectoryWindow16

                Sub     DL, 32

D_PostDirectoryWindow16:
                Mov     BL, CurrentSearchPos
                Xor     BH, BH
                Mov     [Search+BX], DL

                Inc     CurrentSearchPos
                                                ; Now do the search.
                Xor     DX, DX

                Mov     ES, DiskDataArea

D_PostDirectoryWindow18:
                Cmp     DX, NumDirectories
                JAE     D_PostFileWindow17

                Mov     BX, DX
                Add     BX, NumFiles
                Add     BX, BX
                Mov     DI, [ES:BX]
                Add     DI, 8
                Mov     SI, Offset Search
                Mov     CX, 13

D_PostDirectoryWindow21:
                Cmp     Byte Ptr [DS:SI], 0
                JE      D_PostDirectoryWindow19

                CmpsB
                JE      D_PostDirectoryWindow21

                Inc     DX
                Jmp     D_PostDirectoryWindow18

D_PostDirectoryWindow19:
                Mov     CurrentDirectory, DX

D_PostDirectoryWindow17:
                Mov     AX, 1
                Ret

D_PostDirectoryWindow20:
                Xor     AX, AX
                Ret

EndP            D_PostDirectoryWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_PostDriveWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset DriveWindowKeys
                Call    M_FunctionDivider
                JC      D_PostDriveWindow1

                Jmp     [SI]

D_PostDriveWindow1:
                Xor     AX, AX
                Ret

EndP            D_PostDriveWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_PostSaveDriveWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset SaveDriveWindowKeys
                Call    M_FunctionDivider
                JC      D_PostSaveDriveWindow1

                Jmp     [SI]

D_PostSaveDriveWindow1:
                Xor     AX, AX
                Ret

EndP            D_PostSaveDriveWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_NewSpecifier Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Xor     BX, BX
                Mov     SI, Offset FileSpecifier
                Mov     Specific, 1

D_NewSpecifier3:
                LodsB
                And     AL, AL
                JZ      D_NewSpecifier4

                Cmp     AL, '\'
                JE      D_NewSpecifier10
                Cmp     AL, ':'
                JE      D_NewSpecifier10

                Jmp     D_NewSpecifier3

D_NewSpecifier10:
                Mov     BX, SI
                Jmp     D_NewSpecifier3

D_NewSpecifier4:
                And     BX, BX
                JZ      D_NewSpecifier5

                Push    ES
                Push    DI

                Push    CS
                Pop     ES

                Mov     SI, Offset FileSpecifier
                Mov     DI, Offset SongDirectory

D_NewSpecifier7:
                MovsB
                Cmp     SI, BX
                JB      D_NewSpecifier7

                Xor     AL, AL
                Cmp     Byte Ptr [DI-1], '\'
                JNE     D_NewSpecifier11

                Dec     DI

D_NewSpecifier11:
                StosB

                Mov     DI, Offset FileSpecifier

D_NewSpecifier6:
                LodsB
                StosB
                And     AL, AL
                JNZ     D_NewSpecifier6

                Cmp     DI, Offset FileSpecifier+1
                JNE     D_NewSpecifier14

                Mov     Specific, 0

D_NewSpecifier14:
                Pop     DI
                Pop     ES


D_NewSpecifier5:
                Mov     CurrentFile, 0
                Call    D_InitLoadModule2

D_NewSpecifier12:
                Cmp     NumFiles, 0
                JE      D_NewSpecifier1

                Mov     Word Ptr [ES:DI], 12

D_NewSpecifier1:
                Cmp     Specific, 1
                JNE     D_NewSpecifier2

                Cmp     NumFiles, 1
                JNE     D_NewSpecifier2

                Mov     SI, Offset FileSpecifier

D_NewSpecifier8:
                LodsB
                And     AL, AL
                JZ      D_NewSpecifier9

                Cmp     AL, '*'
                JE      D_NewSpecifier2
                Cmp     AL, '?'
                JE      D_NewSpecifier2
                Jmp     D_NewSpecifier8

D_NewSpecifier9:
                Jmp     D_PostFileLoadWindowLink

D_NewSpecifier2:

                Mov     AX, 1
                Ret

EndP            D_NewSpecifier
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_NewDirectory Far

;                Mov     SI, Offset SongDirectory
;                Push    CS
;                Pop     DS
;
;                Call    S_SetDriveDirectory

                Mov     CurrentFile, 0
                Call    D_InitLoadModule

                Cmp     NumFiles, 0
                JE      D_NewDirectory1

                Mov     Word Ptr [ES:DI], 12

D_NewDirectory1:
                Mov     AX, 1
                Ret

EndP            D_NewDirectory

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_ClearFileSpecifier Far

                Push    ES
                Push    DI
                Push    AX
                Push    CX

                Push    CS
                Pop     ES
                Mov     DI, Offset FileSpecifier
                Xor     AX, AX
                Mov     CX, 65
                Rep     StosB

                Pop     CX
                Pop     AX
                Pop     DI
                Pop     ES

                Ret

EndP            D_ClearFileSpecifier

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SaveModule Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset FileSpecifier
                Cmp     Byte Ptr [SI], 0
                JNE     D_SaveModule9

                Call    D_NewSpecifier
                Call    D_ClearFileSpecifier

                Mov     AX, 1
                Ret

D_SaveModule9:
                Push    CS
                Pop     ES
                Xor     BX, BX

D_SaveModule1:
                LodsB
                And     AL, AL
                JZ      D_SaveModule3

                Cmp     AL, '?'
                JE      D_NewSpecifier
                Cmp     AL, '*'
                JE      D_NewSpecifier
                Cmp     AL, ':'
                JE      D_SaveModule2
                Cmp     AL, '\'
                JE      D_SaveModule2

                Jmp     D_SaveModule1

D_SaveModule2:
                Mov     BX, SI
                Jmp     D_SaveModule1

D_SaveModule3:
                And     BX, BX
                JZ      D_SaveModule7

                Mov     SI, Offset FileSpecifier
                Mov     DI, Offset SongDirectory

D_SaveModule4:
                MovsB
                Cmp     SI, BX
                JB      D_SaveModule4

                Xor     AL, AL
                Cmp     Byte Ptr [DI-1], '\'
                JNE     D_SaveModule5

                Dec     DI

D_SaveModule5:
                StosB

                Mov     DI, Offset FileSpecifier

D_SaveModule6:
                LodsB
                StosB
                And     AL, AL
                JNZ     D_SaveModule6

D_SaveModule7:                                  ; Time to save a module.
                Mov     DI, Offset SaveFileName
                Mov     SI, Offset FileSpecifier

D_SaveModule8:
                LodsB
                StosB
                And     AL, AL
                JNZ     D_SaveModule8

                                                ; FileName contains file to
                                                ;  save
                Mov     SI, Offset SongDirectory
                Call    D_SetDriveDirectory

                Mov     SI, Offset SaveFileName
                Xor     BX, BX

D_SaveModule10:
                LodsB
                Cmp     AL, '.'
                JNE     D_SaveModule11

                Mov     BX, SI

D_SaveModule11:
                And     AL, AL
                JNZ     D_SaveModule10

                And     BX, BX
                JNZ     D_SaveModule12

                Cmp     SaveFormat, 1
                JE      D_SaveModule13

                Mov     Word Ptr [SI-1], 'I.'
                Mov     Word Ptr [SI+1], 'T'
                Jmp     D_PostFileSaveWindow2

D_SaveModule13:
                Mov     Word Ptr [SI-1], 'S.'
                Mov     Word Ptr [SI+1], 'M3'
                Mov     Byte Ptr [SI+3], 0

D_SaveModule12:
                Jmp     D_PostFileSaveWindow2
;                Jmp     D_SaveFileITModule

EndP            D_SaveModule
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_NoSaveMessage Far

                Call    S_SaveScreen

                Mov     DI, Offset O1_UnableToSaveList
                Mov     CX, 2
                Call    M_Object1List

                Call    S_RestoreScreen

                Mov     AX, 1
                Ret

EndP            D_NoSaveMessage

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SaveBlock             ; DS:DX points to buffer
                                        ; BX = file handle
                                        ; CX = number of bytes

                JCXZ    D_SaveBlock3

                Cmp     CS:NoSaveError, 1
                JE      D_SaveBlock2

                Mov     AH, 40h
                Int     21h
                JC      D_SaveBlock1
                Cmp     CX, AX
                JNE     D_SaveBlock1

D_SaveBlock3:
                Ret

D_SaveBlock2:
                Mov     AX, CX
                StC
                Ret

D_SaveBlock1:
                PushAD
                Push    DS
                Push    ES

                Call    D_NoSaveMessage

                Pop     ES
                Pop     DS
                PopAD

                Mov     CS:NoSaveError, 1
                StC

                Ret

EndP            D_SaveBlock

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_DeleteIfError         ; DS:DX = filename

                PushF

                Cmp     CS:NoSaveError, 0
                JE      D_DeleteIfError1

                PushA

                Mov     AH, 41h
                Int     21h

                PopA

D_DeleteIfError1:
                PopF
                Ret

EndP            D_DeleteIfError

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_UpdateFileName

                Push    CS
                Push    CS
                Pop     DS
                Pop     ES

                Mov     SI, Offset SaveFileName
                Mov     DI, Offset FileName
                                                ; Scan through file name first.
                Mov     BX, SI

D_UpdateFileName1:
                LodsB
                And     AL, AL
                JZ      D_UpdateFileName2

                Cmp     AL, ':'
                JE      D_UpdateFileName3
                Cmp     AL, '\'
                JNE     D_UpdateFileName1

D_UpdateFileName3:
                Mov     BX, SI
                Jmp     D_UpdateFileName1

D_UpdateFileName2:
                Mov     SI, BX
                Add     BX, 8

D_UpdateFileName4:
                LodsB
                StosB

                Cmp     AL, '.'
                JE      D_UpdateFileName5

                And     AL, AL
                JZ      D_UpdateFileNameEnd

                Cmp     SI, BX
                JBE     D_UpdateFileName4

D_UpdateFileName5:
                Mov     BX, SI
                Add     BX, 3

D_UpdateFileName6:
                LodsB
                StosB

                And     AL, AL
                JZ      D_UpdateFileNameEnd

                Cmp     SI, BX
                JBE     D_UpdateFileName6

D_UpdateFileNameEnd:
                Ret

EndP            D_UpdateFileName

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

include it_d_wm.inc

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_InitLoadSamples Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset SampleDirectory
                Call    D_SetDriveDirectory     ; DS:SI points to cur dir.

                Cmp     SamplesInModule, 0
                JE      D_InitLoadSamples4

                Jmp     LSWindow_EnterLoadInSampleData

D_InitLoadSamples4:
                Mov     LoadSampleNameCount, 0
                Mov     NumSamples, 0
                Mov     SampleInMemory, 0FFFFh
                Mov     SampleCheck, 0FFFFh
                Mov     SampleCacheFileComplete, 0

                                                ; First attempt to delete
                                                ; ST3's cache file..
                Mov     DX, Offset ST3CacheFileName
                Mov     AH, 41h
                Int     21h

                                                ; First check for cache file.
                Mov     OldCacheTime, 0

                Mov     AX, 3D00h               ; Open file..
                Mov     DX, Offset SampleCacheFileName
                Int     21h
                JC      D_InitLoadSamples1      ; Can't open file?

                Mov     BX, AX

                Mov     AH, 3Fh
                Mov     CX, 4                   ; Integer containing number
                                                ; of sample entries...
                Mov     DS, DiskDataArea
                        Assume DS:Nothing

                Xor     DX, DX
                Int     21h
                JC      D_InitLoadSamples3
                Cmp     AX, CX
                JNE     D_InitLoadSamples3

                Mov     AL, [CS:SampleDirectory]        ; AL = drive letter
                Cmp     AL, [CS:CDRomStartDrive]
                JL      SampleVersionCheck
                Cmp     AL, [CS:CDRomEndDrive]
                JGE     SampleVersionCheck

                Cmp     Word Ptr [DS:2], 211h
                JB      D_InitLoadSamples3
                Cmp     Word Ptr [DS:2], TRACKERVERSION
                JBE     D_InitLoadSampleCacheFileOK

SampleVersionCheck:
                Cmp     Word Ptr [DS:2], TRACKERVERSION
                JNE     D_InitLoadSamples3

VersionCheckEnd:
                Mov     AX, 5700h               ; Get file date&time.
                Int     21h

                Mov     Word Ptr [OldCacheTime], CX
                Mov     Word Ptr [OldCachetime+2], DX

                Cmp     CX, Time                ; Check time and date
                JNE     D_InitLoadSamplesOldCache ;  for 'currentness'
                Cmp     DX, Date
                JNE     D_InitLoadSamplesOldCache
                                                ; OK.. let's load...

D_InitLoadSampleCacheFileOK:
                Mov     SI, [DS:0]              ; Number of samples.
                Mov     AX, 96
                Mul     SI
                Mov     CX, AX                  ; Bytes to read.

                Mov     AH, 3Fh                 ; Load again.
                Xor     DX, DX                  ; In case of internal malfunc.
                Int     21h
                JC      D_InitLoadSamples3
                Cmp     AX, CX
                JNE     D_InitLoadSamples3

                Mov     AH, 3Eh                 ; Close file.
                Int     21h

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     LoadSampleNameCount, SI
                Mov     NumSamples, SI
                Mov     SampleCacheFileComplete, 1

                Jmp     D_InitLoadSamples2

D_InitLoadSamplesOldCache:
                PushA
                Push    DS

                Call    D_GetNumFiles           ; Returns number of files
                                                ; and directories,
                                                ; carry if newer file exists.
                Pop     DS
                JC      D_InitLoadSamples5

                Cmp     AX, [DS:0]

                PopA

                JNE     D_InitLoadSamples3

                Call    Far Ptr D_InitLoadSampleCacheFileOK

                Call    D_SaveSampleCacheFile   ; Resave it with new date

                Ret

D_InitLoadSamples5:
                PopA

D_InitLoadSamples3:
                Mov     AH, 3Eh                 ; Close file.
                Int     21h

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Call    DeleteSampleCacheFile

D_InitLoadSamples1:
                Call    D_LoadSampleFiles

D_InitLoadSamples2:
                Ret

EndP            D_InitLoadSamples
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DeleteSampleCacheFile

                Push    DS

                Push    CS
                Pop     DS

                Mov     AH, 41h
                Mov     DX, Offset SampleCacheFileName
                Int     21h

                Pop     DS

                Ret

EndP            DeleteSampleCachefile

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DeleteInstrumentCacheFile

                Push    DS

                Push    CS
                Pop     DS

                Mov     AH, 41h
                Mov     DX, Offset InstrumentCacheFileName
                Int     21h

                Pop     DS

                Ret

EndP            DeleteInstrumentCachefile

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_GetNumFiles   ; DS = DiskDaraArea

                Mov     DS, CS:DiskDataArea

                Mov     DX, 64000       ; Set DTA to DS:64000
                Mov     AH, 1Ah
                Int     21h

                Push    CS
                Pop     DS

                Mov     DX, Offset AllFilesMask
                Mov     CX, 10h
                Mov     AH, 4Eh
                Int     21h

                Mov     DS, CS:DiskDataArea
                JC      D_GetNumFilesError

                Xor     AX, AX                  ; No samples/directories to
                                                ; start off with.

D_GetNumFiles1:
                Test    Byte Ptr [DS:64000+15h], 10h
                JZ      D_GetNumFiles2

                Mov     EDX, DWord Ptr [CS:OldCacheTime]
                Cmp     [DS:64000+16h], EDX     ; Newer file?
                JA      D_GetNumFilesError

                Inc     AX

D_GetNumFiles2:
                Push    AX
                Mov     AH, 4Fh
                Int     21h
                Pop     AX
                JNC     D_GetNumFiles1
                                                ; Directories done.. files now
                Push    AX

                Push    CS
                Pop     DS
                Mov     DX, Offset AllFilesMask
                Xor     CX, CX
                Mov     AH, 4Eh
                Int     21h

                Mov     DS, CS:DiskDataArea

                Pop     AX
                JC      D_GetNumFilesFinished

                Push    CS
                Pop     ES

D_GetNumFiles3:
                Mov     SI, 64000+1Eh
                Mov     DI, Offset SampleCacheFileName
                Mov     CX, 9
                RepE    CmpsB
                JE      D_GetNumFiles4

                Mov     SI, 64000+1Eh
                Mov     DI, Offset InstrumentCacheFileName
                Mov     CX, 9
                RepE    CmpsB
                JE      D_GetNumFiles4

                Mov     EDX, DWord Ptr [CS:OldCacheTime]
                Cmp     [DS:64000+16h], EDX     ; Newer file?
                JA      D_GetNumFilesError

D_GetNumFiles4:
                Inc     AX

                Push    AX
                Mov     AH, 4Fh
                Int     21h
                Pop     AX
                JNC     D_GetNumfiles3

                Dec     AX

D_GetNumFilesFinished:
                ClC
                Ret

D_GetNumFilesError:
                Xor     AX, AX
                StC
                Ret


EndP            D_GetNumFiles

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LoadSampleFiles

                Mov     DS, CS:DiskDataArea
                Push    DS
                Pop     ES

                Xor     DI, DI
                Xor     AX, AX
                Mov     CX, 32768
                Rep     StosW

                Mov     DX, 64000
                Mov     AH, 1Ah
                Int     21h                     ; Shift DTA address..
                                                ; to DiskDataArea:64000

                Xor     DI, DI

                Push    CS
                Pop     DS
                Mov     DX, Offset AllFilesMask
                Mov     CX, 10h
                Mov     AH, 4Eh
                Int     21h

                Mov     DS, CS:DiskDataArea
                Push    DS
                Pop     ES

                JC      D_LoadSampleFiles2

D_LoadSampleFiles1:                             ; A directory was found!
                Test    Byte Ptr [DS:64000+15h], 10h
                JZ      D_LoadSampleFiles5      ; Check that it IS a directory

                Cmp     Word Ptr [DS:64000+1Eh], '.'
                JNE     D_LoadSampleFilesNoRoot

                Mov     Byte Ptr [DS:64000+1Eh], '\'

D_LoadSampleFilesNoRoot:
                Mov     DL, 1
                Call    Near Ptr D_LoadSampleFiles6

                Inc     CS:NumSamples
                Inc     CS:LoadSampleNameCount

                Cmp     CS:NumSamples, 620
                JAE     D_LoadSampleFiles4

D_LoadSampleFiles5:
                Mov     AH, 4Fh
                Int     21h
                JNC     D_LoadSampleFiles1

D_LoadSampleFiles2:                             ; Directories done.. samples now
                Push    CS
                Pop     DS
                Mov     DX, Offset AllFilesMask
                Xor     CX, CX
                Mov     AH, 4Eh
                Int     21h

                Mov     DS, CS:DiskDataArea
                Push    DS
                Pop     ES

                JC      D_LoadSampleFiles4

D_LoadSampleFiles3:
                Mov     DL, 0
                Call    Near Ptr D_LoadSampleFiles6

                Inc     CS:NumSamples
                Cmp     CS:NumSamples, 620
                JAE     D_LoadSampleFiles4

D_LoadSampleFilesNext:
                Mov     AH, 4Fh
                Int     21h
                JNC     D_LoadSampleFiles3

D_LoadSampleFiles4:                             ; End!

                Ret

D_LoadSampleFiles6:                             ; Get name/size/date/time.
                Add     DI, 4
                Mov     SI, 64000+1Eh
                Mov     CX, 13
                Rep     MovsB

                Cmp     DL, 1
                JNE     D_LoadSampleFiles7

                Xor     AX, AX
                StosB
                StosW

                Push    DS
                Push    CS
                Pop     DS
                Mov     SI, Offset DirectoryMsg
                Mov     CX, 25
                Rep     MovsB

                Pop     DS

                Mov     CX, 35
                Jmp     D_LoadSampleFiles8

D_LoadSampleFiles7:
                Mov     CX, 63

D_LoadSampleFiles8:
                Xor     AL, AL
                Rep     StosB

                Mov     EAX, [DS:64000+1Ah]
                StosD
                Mov     AX, [DS:64000+18h]
                StosW
                Mov     AX, [DS:64000+16h]
                StosW
                Mov     AL, DL
                StosB
                Mov     CX, 7
                Xor     AL, AL
                Rep     StosB

                RetN

EndP            D_LoadSampleFiles

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_DrawLoadSampleWindow Far              ; Has to handle
                                                        ; 1) Sample list
                                                        ; 2) Sample info box
                                                        ; 3) WaveForm stuff


                Cmp     CS:NumSamples, 0
                JNE     D_DrawLoadSampleWindow4

                Push    CS
                Pop     DS

                Call    S_GetDestination
                Mov     DI, (6+13*80)*2                 ; (6, 13)
                Mov     SI, Offset NoFilesMsg

                Mov     AH, 5
                Call    S_DrawString

                Ret

D_DrawLoadSampleWindow4:
                Mov     BX, CS:CurrentSample
                Mov     AX, 96
                Mul     BX
                Mov     SI, AX
                Mov     ES, CS:DiskDataArea

                Cmp     Byte Ptr [ES:SI+88], 0
                JNE     D_DrawLoadSampleWindow28

                Push    SI

                Call    D_LoadSampleHeader
                Call    D_GetSampleInfo

                Pop     SI

D_DrawLoadSampleWindow28:
                Mov     BX, CS:CurrentSample
                Cmp     BX, CS:SampleCheck
                JE      D_DrawLoadSampleWindow31

                Mov     CS:SampleCheck, BX
                Push    CS
                Pop     ES
                Mov     DI, Offset CheckDataArea
                Mov     DS, CS:DiskDataArea
                Mov     CX, 96
                Rep     MovsB

D_DrawLoadSampleWindow31:
                Push    CS
                Pop     DS
                        Assume DS:Disk

                Call    S_GetDestination

                Mov     AX, TopSample
                Mov     BX, CurrentSample
                Cmp     AX, BX
                JBE     D_DrawLoadSampleWindow1

                Mov     AX, BX

D_DrawLoadSampleWindow1:
                LEA     CX, [EAX+34]
                Cmp     CX, BX
                JA      D_DrawLoadSampleWindow2

                LEA     AX, [BX-34]

D_DrawLoadSampleWindow2:
                Mov     TopSample, AX
                Mov     BX, AX

                Push    AX

                Mov     DI, (31+13*80)*2
                Mov     CX, 35
                Mov     AX, 2A8h

D_DrawLoadSampleWindow5:                                ; Divider...
                StosW
                Add     DI, 158
                Loop    D_DrawLoadSampleWindow5

                Pop     AX

                Mov     DX, NumSamples
                                                ; Put numbers of screen first.
                Mov     DI, (2+13*80)*2                 ; (2,13)
                Mov     CX, 2000h+35            ; Colour and loop count.

D_DrawLoadSampleWindow3:
                Inc     AX
                Push    DI

                Call    PE_ConvAX2Num

                Pop     DI
                Add     DI, 160
                Cmp     AX, DX          ; DX = NumSamples
                JAE     D_DrawLoadSampleWindow9

                Dec     CL
                JNZ     D_DrawLoadSampleWindow3

D_DrawLoadSampleWindow9:
                Mov     DS, DiskDataArea
                Assume DS:Nothing
                Mov     AX, 96
                Mul     BX
                Mov     SI, AX                  ; SI = offset of first sample.

                Mov     DX, 35                  ; DX = Number of rows to show.
                                                ; BX = sample num

                Mov     DI, (6+13*80)*2

D_DrawLoadSampleWindow6:
                Push    BX
                Push    DX
                Push    SI
                Push    DI
                                                ; Colour....
                Mov     AL, [DS:SI+88]          ; AL = type. 0 = not loaded.
                                                ; 1=dir
                                                ; 2=it sample
                                                ; 3=scrm sample.
                                                ; 4=unknown
                                                ; 5=8 bit mono wave
                Mov     AH, 6
                Cmp     AL, 1
                JB      D_DrawLoadSampleWindow7

                Mov     AH, 5
                JE      D_DrawLoadSampleWindow7

                Mov     AH, 3
                Cmp     AL, 4
                JNE     D_DrawLoadSampleWindow7

                Mov     AH, 2

D_DrawLoadSampleWindow7:                        ; AH = colour.
                Push    SI

                Add     SI, 14h

                Mov     CX, 25

D_DrawLoadSampleWindow50:
                LodsB

                Cmp     AL, 226
                JB      D_DrawLoadSampleCharFilter

                Mov     AL, ' '

D_DrawLoadSampleCharFilter:
                StosW
                Loop    D_DrawLoadSampleWindow50

                Xor     AL, AL
                Rep     StosW

                Pop     SI

;                Add     DI, 2
                ScasW
                Add     SI, 4

                Mov     CX, 12

D_DrawLoadSampleWindow51:
                LodsB
                StosW
                And     AL, AL
                LoopNZ  D_DrawLoadSampleWindow51

                Xor     AL, AL
                Rep     StosW

                Pop     DI
                Pop     SI
                Pop     DX
                Pop     BX

                Add     SI, 96                  ; Advance to next sample.
                Add     DI, 160                 ; Advance to next line on screen

                Inc     BX
                Cmp     BX, CS:NumSamples
                JAE     D_DrawLoadSampleWindow8

                Dec     DX
                JNZ     D_DrawLoadSampleWindow6

D_DrawLoadSampleWindow8:                        ; Length
                Mov     AX, 96
                Mul     CS:CurrentSample

                Mov     SI, AX

                Push    DS
                Push    SI

                Push    DWord Ptr [DS:SI+30h]

                Test    Byte Ptr [DS:SI+2Eh], 32        ; Stereo?
                JZ      D_DrawLoadSampleWindowNoStereo

                Test    Byte Ptr [DS:SI+12h], 2
                Mov     SI, Offset Quality8StereoMsg

                Push    CS
                Pop     DS
                JZ      D_DrawLoadSampleWindowBitMsg

                Mov     SI, Offset Quality16StereoMsg
                Jmp     D_DrawLoadSampleWindowBitMsg

D_DrawLoadSampleWindowNoStereo:
                Test    Byte Ptr [DS:SI+12h], 2
                Mov     SI, Offset Quality8Msg

                Push    CS
                Pop     DS
                JZ      D_DrawLoadSampleWindowBitMsg

                Mov     SI, Offset Quality16Msg

D_DrawLoadSampleWindowBitMsg:
                Mov     DI, (21*80+64)*2
                Mov     AH, 2
                Call    S_DrawString

                Mov     SI, Offset LengthMsg
                Mov     DI, (22*80+64)*2
                Call    S_DrawString
                Pop     EAX

                Pop     SI
                Pop     DS

D_DrawLoadSampleWindow30:
                                                ; Now for infobox.
                Mov     BL, [DS:SI+88]          ; BL = type.
                Push    DS
                Push    SI

                Push    CS
                Pop     DS
                Xor     BH, BH
                Add     BX, BX
                Mov     SI, [SampleFormatNames+BX]
                Mov     DI, (53+44*80)*2
                Mov     AH, 5
                Call    S_DrawString

                Pop     SI
                Pop     DS

                Push    SI

                Mov     DX, [DS:SI+82]
                Mov     AX, [DS:SI+80]
                Cmp     DX, 10000

                JAE     D_DrawLoadSampleWindow13

                Mov     DI, (53+45*80)*2

                Mov     CX, 10000
                Div     CX                      ; DX = remainder. AX = main.

                Mov     BP, AX

                Mov     CX, 4
                Mov     SI, 10
                Mov     AX, DX

D_DrawLoadSampleWindow10:
                Xor     DX, DX
                Div     SI
                Add     DL, '0'
                Push    DX

                Loop    D_DrawLoadSampleWindow10

                Mov     AX, BP

                Mov     CX, 5

D_DrawLoadSampleWindow11:
                Xor     DX, DX
                Div     SI
                Add     DL, '0'
                Push    DX

                Loop    D_DrawLoadSampleWindow11

                Mov     CX, 9

D_DrawLoadSampleWindow12:
                Pop     AX
                Mov     AH, 5
                StosW
                Loop    D_DrawLoadSampleWindow12

D_DrawLoadSampleWindow13:
                Pop     SI

                Mov     DX, [DS:SI+86]          ; DX = time
                Mov     BX, [DS:SI+84]          ; BX = date

                Push    CS
                Pop     DS

                Mov     DI, (53+46*80)*2
                Mov     AX, BX
                ShR     AX, 5
                And     AX, 0Fh
                Mov     SI, AX
                Add     SI, SI
                Mov     SI, [MonthNames+SI]

                Mov     AH, 5

D_DrawLoadSampleWindow19:
                LodsB
                StosW
                And     AL, AL
                JNZ     D_DrawLoadSampleWindow19

                Mov     AL, BL
                And     AX, 31
                Mov     CH, 10
                Div     CH
                And     AL, AL
                JZ      D_DrawLoadSampleWindow20

                Push    AX
                Add     AL, '0'
                Mov     AH, 5
                StosW

                Pop     AX

D_DrawLoadSampleWindow20:
                Mov     AL, AH
                Add     AL, '0'
                Mov     AH, 5
                StosW

                Mov     AL, ','
                StosW

                Mov     AL, ' '
                StosW

                Push    DX
                Mov     AL, BH
                ShR     AX, 1
                And     AX, 7Fh
                Add     AX, 1980
                Mov     DX, 0FFFFh
                Push    DX

                Mov     SI, 10

D_DrawLoadSampleWindow21:
                Xor     DX, DX
                Div     SI
                Add     DL, '0'
                Push    DX

                And     AX, AX
                JNZ     D_DrawLoadSampleWindow21

D_DrawLoadSampleWindow22:
                Pop     AX
                Cmp     AX, 0FFFFh
                JE      D_DrawLoadSampleWindow23

                Mov     AH, 5
                StosW

                Jmp     D_DrawLoadSampleWindow22

D_DrawLoadSampleWindow23:
                Pop     DX
                Mov     DI, (53+47*80)*2

                Mov     AX, DX
                ShR     AX, 11

                Xor     BL, BL                  ; if BL = 0, then am, otherwise
                                                ;  pm..
                Cmp     AX, 12
                JB      D_DrawLoadSampleWindow24

                Inc     BX
                Sub     AX, 12

D_DrawLoadSampleWindow24:
                And     AX, AX
                JNZ     D_DrawLoadSampleWindow25

                Add     AX, 12

D_DrawLoadSampleWindow25:
                Mov     BH, 10
                Div     BH
                And     AL, AL
                JZ      D_DrawLoadSampleWindow26

                Push    AX
                Add     AL, '0'
                Mov     AH, 5
                StosW

                Pop     AX

D_DrawLoadSampleWindow26:
                Mov     AL, AH
                Add     AL, '0'
                Mov     AH, 5
                StosW

                Mov     AL, ':'
                StosW

                Mov     AX, DX
                ShR     AX, 5
                And     AX, 63

                Div     BH
                Mov     BH, AH

                Add     AL, '0'
                Mov     AH, 5
                StosW

                Mov     AL, BH
                Add     AL, '0'
                StosW

                Mov     AL, 'a'
                And     BL, BL
                JZ      D_DrawLoadSampleWindow27

                Mov     AL, 'p'

D_DrawLoadSampleWindow27:
                StosW
                Mov     AL, 'm'
                StosW

                Push    CS                      ; Wave form shit..
                Pop     DS
                        Assume DS:Disk

                Mov     AX, CurrentSample
                Cmp     AX, SampleInMemory
                JNE     D_DrawLoadSampleWindow54

                Mov     DI, (46+25*80)*2
                Mov     DX, 4
                Mov     AX, 0D00h

D_DrawLoadSampleWindow55:
                Mov     CX, 31

D_DrawLoadSampleWindow56:
                StosW
                Inc     AX
                Loop    D_DrawLoadSampleWindow56

                Add     DI, 160-31*2
                Dec     DX
                JNZ     D_DrawLoadSampleWindow55

D_DrawLoadSampleWindow54:
                Ret

EndP            D_DrawLoadSampleWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_PreLoadSampleWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     AX, CurrentSample
                Sub     AX, TopSample
                Add     AX, 13
                Mov     BX, 160
                Mul     BX

                Call    S_GetDestination

                LEA     DI, [EAX+12]
                Mov     CX, 38

D_PreLoadSample1:
                Mov     AX, [ES:DI]
                Cmp     CX, 13

                JNE     D_PreLoadSample2

                Mov     AH, 32h
                Jmp     D_PreLoadSample3

D_PreLoadSample2:
                Mov     AH, 30h

D_PreLoadSample3:
                StosW

                Loop    D_PreLoadSample1

                Ret

EndP            D_PreLoadSampleWindow

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_PostLoadSampleWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset LSWindowKeys
                Call    M_FunctionDivider
                JC      D_PostLoadSampleWindow1

                Jmp     [SI]

D_PostLoadSampleWindow1:                        ; Time to check for play keys.
                Mov     SI, Offset KeyBoardTable
                Test    CH, Not 1
                JNZ     D_PostLoadSampleWindow3

                Cmp     CX, LastKey
                JE      D_PostLoadSampleWindow3

                Mov     LastKey, CX

D_PostLoadSampleWindow2:
                LodsW
                Cmp     AX, 0FFFFh
                JE      D_PostLoadSampleWindow3

                Mov     BX, AX
                LodsW

                Cmp     BL, CL
                JNE     D_PostLoadSampleWindow2
                                                ; Note to play...
                                                ; AX = notemod.
                And     CH, CH
                JZ      D_PostLoadSampleWindow5


                Mov     BX, AX

                Mov     CX, Pattern
                Mov     DS, CX
                                Assume DS:Pattern

                Mov     AL, 12
                Mul     BaseOctave

                Push    CS
                Pop     DS
                                Assume DS:Disk

                Add     AX, BX
                Cmp     AX, 119
                JA      D_PostLoadSampleWindow4 ; If note > B-9... don't play!

                Push    AX

                Mov     AX, 96
                Mul     CurrentSample
                Mov     SI, AX

                Mov     DisableStereoMenu, 1

                Mov     DS, DiskDataArea
                Mov     AX, 99
                Call    LoadSample

                Mov     CS:DisableStereoMenu, 0

                Pop     AX
                JC      D_PostLoadSampleWindow4

                                                ; AX = note. Ins = 99.
                Mov     AH, 100
                Xor     CX, CX
                Call    Music_PlaySample
                Jmp     D_PostLoadSampleWindow4

D_PostLoadSampleWindow5:
                Xor     AX, AX
                Mov     SI, Offset NoteData
                Mov     DH, 32
                Call    Music_PlayNote

D_PostLoadSampleWindow4:
                Mov     AX, 1
                Ret

D_PostLoadSampleWindow3:
                Xor     AX, AX
                Ret

EndP            D_PostLoadSampleWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_PostViewSampleLibrary Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset LSViewWindowKeys
                Call    M_FunctionDivider
                JC      D_PostLoadSampleWindow1

                Jmp     [SI]

EndP            D_PostViewSampleLibrary

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LSDrawDriveWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Call    S_GetDestination

                Mov     AL, TopDrive
                Mov     BL, CurrentDrive
                Cmp     AL, BL
                JBE     D_LSDrawDriveWindow1

                Mov     AL, BL

D_LSDrawDriveWindow1:
                Mov     CL, AL
                Add     CL, 9
                Cmp     CL, BL
                JA      D_LSDrawDriveWindow2

                Mov     AL, BL
                Sub     AL, 9

D_LSDrawDriveWindow2:
                Mov     TopDrive, AL
                Mov     BL, AL
                Mov     CX, 10

                Mov     DI, (46+13*80)*2
                Xor     BH, BH

D_LSDrawDriveWindow3:
                Cmp     BL, NumDrives
                JAE     D_LSDrawDriveWindow5

                Push    DI

                Mov     AL, [DrivesAvail+BX]
                Add     AL, 'A'
                Mov     SI, Offset DriveMsg
                Mov     [SI+6], AL

                Mov     AH, 5
                Mov     DX, 8

D_LSDrawDriveWindow4:
                LodsB
                StosW

                Dec     DX
                JNZ     D_LSDrawDriveWindow4

                Pop     DI
                Add     DI, 160
                Inc     BX
                Loop    D_LSDrawDriveWindow3

D_LSDrawDriveWindow5:
                Ret

EndP            D_LSDrawDriveWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LSPreDriveWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     AL, CurrentDrive
                Sub     AL, TopDrive
                Add     AL, 13
                Mov     AH, 160
                Mul     AH

                Call    S_GetDestination
                LEA     DI, [EAX+92]
                Mov     CX, 8

D_LSPreDriveWindow1:
                Mov     AX, [ES:DI]
                Mov     AH, 30h
                StosW

                Loop    D_LSPreDriveWindow1

                Ret

EndP            D_LSPreDriveWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LSPostDriveWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset LSDriveWindowKeys
                Call    M_FunctionDivider
                JC      D_LSPostDriveWindow1

                Jmp     [SI]

D_LSPostDriveWindow1:
                Xor     AX, AX
                Ret

EndP            D_LSPostDriveWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LIDrawDriveWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Call    S_GetDestination

                Xor     AL, AL
                Xor     BX, BX

                Mov     CX, 32

                Mov     DI, (64+16*80)*2

D_LIDrawDriveWindow3:
                Cmp     BL, NumDrives
                JAE     D_LIDrawDriveWindow5

                Push    DI

                Mov     AL, [DrivesAvail+BX]
                Add     AL, 'A'
                Mov     SI, Offset DriveMsg
                Mov     [SI+6], AL

                Mov     AH, 5
                Mov     DX, 8

D_LIDrawDriveWindow4:
                LodsB
                StosW

                Dec     DX
                JNZ     D_LIDrawDriveWindow4

                Pop     DI
                Add     DI, 160
                Inc     BX
                Loop    D_LIDrawDriveWindow3

D_LIDrawDriveWindow5:
                Ret

EndP            D_LIDrawDriveWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LIPreDriveWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     AL, CurrentDrive
                Add     AL, 16
                Mov     AH, 160
                Mul     AH
                Mov     DI, AX

                Call    S_GetDestination
                Add     DI, 64*2
                Mov     CX, 8

D_LIPreDriveWindow1:
                Mov     AX, [ES:DI]
                Mov     AH, 30h
                StosW

                Loop    D_LIPreDriveWindow1

                Ret

EndP            D_LIPreDriveWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LIPostDriveWindow Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset LIDriveWindowKeys
                Call    M_FunctionDivider
                JC      D_LIPostDriveWindow1

                Jmp     [SI]

D_LIPostDriveWindow1:
                Xor     AX, AX
                Ret

EndP            D_LIPostDriveWindow
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LoadSampleHeader              ; Given BX = sample number.

                Push    BX

                Mov     DS, DiskDataArea
                        Assume DS:Nothing

                Mov     AX, 96
                Mul     BX
                LEA     SI, [EAX+4]

                Call    D_LoadFileHeader

                Pop     BX

                Ret

EndP            D_LoadSampleHeader

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LoadInstrumentHeader          ; Given BX = instrument num

                Push    BX

                Mov     DS, DiskDataArea
                        Assume DS:Nothing

                Mov     AX, 48
                Mul     BX
                Mov     SI, AX
                Inc     SI

                Call    D_LoadFileHeader

                Pop     BX

                Ret

EndP            D_LoadInstrumentHeader

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

include it_d_inf.inc

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SaveSampleCacheFile           ; Assumes DS=Disk

                Push    CS
                Pop     DS

                Assume DS:Disk

                Test    DiskOptions, 2
                JNZ     D_SaveSampleCacheFile1

                Cmp     SamplesInModule, 0
                JNE     D_SaveSampleCacheFile1

                Mov     AH, 3Ch                 ; create file.
                Xor     CX, CX                  ; normal file
                Mov     DX, Offset SampleCacheFileName
                Int     21h
                JC      D_SaveSampleCacheFile1

                Mov     BX, AX                  ; BX = file handle

                Mov     AH, 40h                 ; Write to file
                Mov     CX, 4                   ; Word size
                Mov     DX, Offset NumSamples
                Int     21h

                Mov     AX, 96
                Mul     NumSamples
                Mov     CX, AX                  ; CX = num bytes to write.
                Mov     AH, 40h
                Xor     DX, DX
                Mov     DS, DiskDataArea
                        Assume DS:Nothing
                Int     21h                     ; Write cache file!

                                                ; Set date and time...
                Mov     AX, 5701h
                Mov     CX, CS:Time
                Mov     DX, CS:Date
                Int     21h

                Mov     AH, 3Eh                 ; Close file handle
                Int     21h

                Push    CS
                Pop     DS
                        Assume DS:Disk

D_SaveSampleCacheFile1:
                Mov     SampleCacheFileComplete, 1

                Ret

EndP            D_SaveSampleCacheFile
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SaveInstrumentCacheFile           ; Assumes DS=Disk

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Test    DiskOptions, 2
                JNZ     D_SaveInstrumentCacheFile1

                Mov     AH, 3Ch                 ; create file.
                Xor     CX, CX                  ; normal file
                Mov     DX, Offset InstrumentCacheFileName
                Int     21h
                JC      D_SaveInstrumentCacheFile1

                Mov     BX, AX                  ; BX = file handle

                Mov     AH, 40h                 ; Write to file
                Mov     CX, 6                   ; Word size
                Mov     DX, Offset InitialInstruments
                Int     21h

                Mov     AX, 48
                Mul     NumInstruments
                Mov     CX, AX                  ; CX = num bytes to write.
                Mov     AH, 40h
                Xor     DX, DX
                Mov     DS, DiskDataArea
                        Assume DS:Nothing

                Int     21h                     ; Write cache file!

                                                ; Set date and time...
                Mov     AX, 5701h
                Mov     CX, CS:Time
                Mov     DX, CS:Date
                Int     21h

                Mov     AH, 3Eh                 ; Close file handle
                Int     21h

                Push    CS
                Pop     DS
                        Assume DS:Disk

D_SaveInstrumentCacheFile1:
                Mov     InstrumentCacheFileComplete, 1

                Ret

EndP            D_SaveInstrumentCacheFile
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LoadSampleNames Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Cmp     SampleCacheFileComplete, 1
                JNE     D_LoadSampleNames2

D_LoadSampleNames6:
                Xor     AX, AX                  ; No redraw screen.
                Ret

D_LoadSampleNames2:
                Mov     BX, LoadSampleNameCount
                Cmp     BX, NumSamples
                JAE     D_LoadSampleNames5

D_LoadSampleNames1:
                Call    K_IsAnyKeyDown
                And     AL, AL
                JNZ     D_LoadSampleNames6

                Call    GetKeyboardLock
                And     AL, AL
                JNZ     D_LoadSampleNames6

                Mov     AX, 96
                Mul     BX
                Mov     SI, AX
                Mov     ES, DiskDataArea
                Cmp     Byte Ptr [ES:SI+88], 0
                JNE     D_LoadSampleNames3

                Call    D_LoadSampleHeader
                JC      D_LoadSampleNames3

                Call    D_GetSampleInfo         ; BX = sample number

D_LoadSampleNames3:
                Push    CS
                Pop     DS
                        Assume DS:Disk

                Inc     LoadSampleNameCount
                Mov     BX, LoadSampleNameCount
                Cmp     BX, NumSamples
                JNE     D_LoadSampleNames4
                                                ; Save cache file..

D_LoadSampleNames5:
                Call    D_SaveSampleCacheFile
                Cmp     CurrentSample, 0
                JNE     D_LoadSampleNames4
                Call    D_SlowSampleSort

D_LoadSampleNames4:
                Mov     AX, 1                   ; Signify redraw screen
                Ret

EndP            D_LoadSampleNames
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_GetLoadSampleVars Far         ; Returns SI with offset of

                Push    AX
                Push    DX

                Mov     AX, 96
                Mul     CS:CurrentSample
                Mov     SI, AX
                Mov     DS, CS:DiskDataArea

                Pop     DX
                Pop     AX

                Ret

EndP            D_GetLoadSampleVars

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_GotoStartingDirectory Far

                Push    DS
                Push    CS
                Pop     DS

                Mov     SI, Offset StartingDirectory
                Call    D_SetDriveDirectory
                Pop     DS

                Ret

EndP            D_GotoStartingDirectory

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SaveDirectoryConfiguration Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     NoSaveError, 0
                Mov     CountryTableConfig, 0

                Mov     SI, Offset StartingDirectory
                Call    D_SetDriveDirectory

                Mov     AH, 3Ch
                Xor     CX, CX
                Mov     DX, Offset ConfigFileName
                Int     21h
                JC      D_SaveDirectoryConfiguration1

                Mov     BX, AX

                Mov     CX, 211
                Mov     DX, Offset SongDirectory
                Call    D_SaveBlock

                Call    S_GetPaletteOffset      ; Into DS:DX
                Mov     CX, 3*16
                Call    D_SaveBlock

                Call    Display_GetDisplayWindowData
                Mov     CX, 50
                Call    D_SaveBlock

                Call    PE_GetPatternConfigOffset
                Mov     CX, 218
                Call    D_SaveBlock

                Call    I_GetPresetEnvelopeOffset
                Mov     CX, 810
                Call    D_SaveBlock

                Mov     AH, 3Eh
                Int     21h

D_SaveDirectoryConfiguration1:
                Mov     AX, 1
                Ret

EndP            D_SaveDirectoryConfiguration
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            FileWindow_Up Far

                Assume  DS:Disk

                Mov     AX, CurrentFile
                And     AX, AX
                JZ      FileWindow_Up1

                Dec     CurrentFile

FileWindow_Up1:
                Mov     AX, 1
                Ret

EndP            FileWindow_Up
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            FileWindow_Down Far

                Assume  DS:Disk

                Mov     AX, CurrentFile
                Inc     AX
                Cmp     AX, NumFiles
                JAE     FileWindow_Down1

                Inc     CurrentFile

FileWindow_Down1:
                Mov     AX, 1
                Ret

EndP            FileWindow_Down
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            FileWindow_PgUp Far

                Assume  DS:Disk

                Mov     AX, CurrentFile
                Sub     AX, 31
                JNC     FileWindow_PgUp1

                Xor     AX, AX

FileWindow_PgUp1:
                Mov     CurrentFile, AX

                Mov     AX, 1
                Ret

EndP            FileWindow_PgUp
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            FileWindow_PgDn Far

                Assume  DS:Disk

                Mov     AX, CurrentFile
                Add     AX, 31
                Cmp     AX, NumFiles
                JB      FileWindow_PgDn1

                Mov     AX, NumFiles
                And     AX, AX
                JZ      FileWindow_PgDn1

                Dec     AX

FileWindow_PgDn1:
                Mov     CurrentFile, AX

                Mov     AX, 1
                Ret

EndP            FileWindow_PgDn
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            FileWindow_Right Far

                Assume  DS:Disk

                Mov     Word Ptr [ES:DI], 13

                Mov     AX, 1
                Ret

EndP            FileWindow_Right
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            FileWindow_Left Far

                Assume  DS:Disk

                Mov     Word Ptr [ES:DI], 14

                Mov     AX, 1
                Ret

EndP            FileWindow_Left
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            FileWindow_ShiftTab Far

                Assume  DS:Disk

                Mov     Word Ptr [ES:DI], 16

                Mov     AX, 1
                Ret

EndP            FileWindow_ShiftTab
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            FileWindow_Home Far

                Assume  DS:Disk

                Mov     CurrentFile, 0

                Mov     AX, 1
                Ret

EndP            FileWindow_Home
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            FileWindow_End Far

                Assume  DS:Disk

                Mov     AX, NumFiles
                Dec     AX
                JS      FileWindow_End1

                Mov     CurrentFile, AX

FileWindow_End1:
                Mov     AX, 1
                Ret

EndP            FileWindow_End
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            FileWindow_DeleteFile Far

                Assume  DS:Disk

                Cmp     NumFiles, 0
                JE      FileWindow_DeleteFile26

                Mov     DI, Offset O1_ConfirmDelete
                Mov     CX, 4
                Call    M_Object1List
                And     DX, DX
                JNZ     FileWindow_DeleteFile24

                Mov     AX, 1
                Ret

FileWindow_DeleteFile24:                             ; Time to kill the sucker...
                Mov     DS, CS:DiskDataArea
                Mov     BX, CS:CurrentFile
                        Assume DS:Nothing

                Add     BX, BX
                Mov     DX, [BX]
                Add     DX, 8                   ; DS:BX points to thingo.
                Mov     AH, 41h
                Int     21h
                JC      FileWindow_DeleteFile26

                Push    DS
                Pop     ES

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     DI, CurrentFile
                Mov     CX, DI
                Add     DI, DI
                Mov     BX, NumFiles
                Add     BX, NumDirectories

FileWindow_DeleteFile27:
                Mov     AX, [ES:DI+2]
                StosW
                Inc     CX
                Cmp     CX, BX
                JBE     FileWindow_DeleteFile27

                Mov     AX, NumFiles
                Mov     BX, CurrentFile
                Dec     AX
                And     AX, AX
                JZ      FileWindow_DeleteFile29

                Cmp     BX, AX
                JB      FileWindow_DeleteFile28

                Mov     BX, AX
                Dec     BX
                Jmp     FileWindow_DeleteFile28

FileWindow_DeleteFile29:
                Mov     BX, AX

FileWindow_DeleteFile28:
                Mov     NumFiles, AX
                Mov     CurrentFile, BX
                Dec     LoadSongNameCount

FileWindow_DeleteFile26:
                Mov     AX, 1
                Ret

EndP            FileWindow_DeleteFile
                Assume DS:Nothing

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Proc            DirectoryWindow_Up Far

                Assume  DS:Disk

                Mov     AX, CurrentDirectory
                And     AX, AX
                JZ      DirectoryWindow_Up1

                Dec     CurrentDirectory

DirectoryWindow_Up1:
                Mov     AX, 1
                Ret

EndP            DirectoryWindow_Up

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DirectoryWindow_Down Far

                Assume  DS:Disk

                Mov     AX, CurrentDirectory
                Inc     AX
                Cmp     AX, NumDirectories
                JAE     DirectoryWindow_Down1

                Inc     CurrentDirectory

DirectoryWindow_Down1:
                Mov     AX, 1
                Ret

EndP            DirectoryWindow_Down

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DirectoryWindow_PgUp Far

                Assume  DS:Disk

                Mov     AX, CurrentDirectory
                Sub     AX, 21
                JC      DirectoryWindow_Home

                Mov     CurrentDirectory, AX

                Mov     AX, 1
                Ret

EndP            DirectoryWindow_PgUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DirectoryWindow_PgDn Far

                Assume  DS:Disk

                Mov     AX, CurrentDirectory
                Add     AX, 21
                Cmp     AX, NumDirectories
                JAE     DirectoryWindow_End

                Mov     CurrentDirectory, AX

                Mov     AX, 1
                Ret

EndP            DirectoryWindow_PgDn

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DirectoryWindow_Home Far

                Assume  DS:Disk

                Mov     CurrentDirectory, 0

                Mov     AX, 1
                Ret

EndP            DirectoryWindow_Home

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DirectoryWindow_End Far

                Assume  DS:Disk

                Mov     AX, NumDirectories
                Dec     AX
                JS      DirectoryWindow_End1

                Mov     CurrentDirectory, AX

DirectoryWindow_End1:
                Mov     AX, 1
                Ret

EndP            DirectoryWindow_End

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DirectoryWindow_Left Far

                Assume  DS:Disk

                Mov     Word Ptr [ES:DI], 12

                Mov     AX, 1
                Ret

EndP            DirectoryWindow_Left

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DirectoryWindow_Enter Far

                Assume  DS:Disk

                Cmp     NumDirectories, 0
                JE      DirectoryWindow_Enter2

                Mov     BX, CurrentDirectory
                Add     BX, NumFiles

                Mov     DS, DiskDataArea
                        Assume DS:Nothing

                Add     BX, BX
                Mov     DX, [BX]
                Add     DX, 8
                Mov     AH, 3Bh
                Int     21h

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset SongDirectory
                Call    D_GetDriveDirectory

                Call    D_InitLoadModule

                Mov     CurrentFile, 0
                Mov     AX, 12
                Cmp     NumFiles, 0
                JNE     DirectoryWindow_Enter1

                Mov     AX, 13

DirectoryWindow_Enter1:
                StosW
;                Mov     [ES:DI], AX

                Mov     AX, 1
                Ret

DirectoryWindow_Enter2:
                Xor     AX, AX
                Ret

EndP            DirectoryWindow_Enter

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Proc            DriveWindow_Up Far

                Assume  DS:Disk

                Mov     AL, CurrentDrive
                And     AL, AL
                JZ      DriveWindow_Up1

                Dec     CurrentDrive

DriveWindow_Up1:
                Mov     AX, 1
                Ret

EndP            DriveWindow_Up
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DriveWindow_Down Far

                Assume  DS:Disk

                Mov     AL, CurrentDrive
                Inc     AX
                Cmp     AL, NumDrives
                JAE     DriveWindow_Down1

                Inc     CurrentDrive

DriveWindow_Down1:
                Mov     AX, 1
                Ret

EndP            DriveWindow_Down
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DriveWindow_Tab Far

                Assume  DS:Disk

                Mov     Word Ptr [ES:DI], 15

                Mov     AX, 1
                Ret

EndP            DriveWindow_Tab
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LIDriveWindow_Tab Far

                Assume  DS:Disk

                Mov     Word Ptr [ES:DI], 5

                Mov     AX, 1
                Ret

EndP            LIDriveWindow_Tab
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SaveDriveWindow_Tab Far

                Assume  DS:Disk

                Mov     Word Ptr [ES:DI], 18

                Mov     AX, 1
                Ret

EndP            SaveDriveWindow_Tab
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DriveWindow_Enter Far

                Assume  DS:Disk

                Mov     BL, CurrentDrive
                Xor     BH, BH
                Mov     DL, [DrivesAvail+BX]
                Mov     AH, 0Eh
                Int     21h

                Mov     SI, Offset SongDirectory
                Call    D_GetDriveDirectory

                Call    D_InitLoadModule

                Mov     CurrentFile, 0
                Mov     AX, 12
                Cmp     NumFiles, 0
                JNE     DriveWindow_Enter1

                Mov     AX, 13
                Cmp     NumDirectories, 0
                JNE     DriveWindow_Enter1

                Mov     AX, 14

DriveWindow_Enter1:
                StosW
;                Mov     [ES:DI], AX

                Mov     AX, 1
                Ret

EndP            DriveWindow_Enter
                Assume  DS:Nothing

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Proc            LS_DriveWindow_Enter Far

                Assume  DS:Disk

                Mov     BL, CurrentDrive
                Xor     BH, BH
                Mov     DL, [DrivesAvail+BX]
                Mov     AH, 0Eh
                Int     21h

                Mov     SI, Offset SampleDirectory
                Call    D_GetDriveDirectory

                Mov     CurrentSample, 0
                Push    ES
                Push    DI
                Call    D_InitLoadSamples
                Pop     DI
                Pop     ES

                Mov     Word Ptr [ES:DI], 15            ; Sample list

                Mov     AX, 1
                Ret

EndP            LS_DriveWindow_Enter

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Proc            LI_DriveWindow_Enter Far

                Assume  DS:Disk

                Mov     BL, CurrentDrive
                Xor     BH, BH
                Mov     DL, [DrivesAvail+BX]
                Mov     AH, 0Eh
                Int     21h

                Mov     SI, Offset InstrumentDirectory
                Call    D_GetDriveDirectory

                Mov     CurrentInstrument, 0
                Push    ES
                Push    DI
                Call    D_InitLoadInstruments
                Pop     DI
                Pop     ES

                Mov     Word Ptr [ES:DI], 5            ; Sample list

                Mov     AX, 1
                Ret

EndP            LI_DriveWindow_Enter

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LSDriveWindow_Right Far

                Mov     Word Ptr [ES:DI], 17

                Mov     AX, 1
                Ret

EndP            LSDriveWindow_Right

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Proc            LoadSample              ; AX = Sample number
                                        ; DS:SI points to sample header.
                Call    PE_SaveCurrentPattern

                Push    AX

                Cmp     AX, 99
                JNE     LoadSample4

                Mov     DX, CS:CurrentSample
                Cmp     DX, CS:SampleInMemory
                JE      LoadSample3

LoadSample4:
                Mov     EDX, [DS:SI+30h]
                And     EDX, EDX
                JZ      LoadSample6
                Test    Byte Ptr [DS:SI+12h], 1
                JZ      LoadSample6

                Call    Music_Stop

                Push    AX

                Mov     AX, 3D00h
                Mov     DX, SI
                Add     DX, 4
                Int     21h
                JC      LoadSample8

                Mov     BX, AX          ; BX = File Handle
                Mov     AX, 4200h
                Mov     CX, [DS:SI+4Ah]
                Mov     DX, [DS:SI+48h]
                Int     21h             ; Move File Ptr.

                Pop     AX              ; AX = sample number.

                Push    SI              ; Load sample into memory first.

                Call    D_LoadSampleData

                PushF

                Mov     AH, 3Eh
                Int     21h             ; Close file.

                PopF
                Pop     SI

                JC      LoadSample2

LoadSample3:
                Pop     BX
                Mov     DX, BX

                Add     BX, BX
                Call    Music_GetSongSegment
                Mov     ES, AX
                Mov     DI, [ES:BX+64912]       ; ES:DI points to instrument

                Mov     CX, 48h
                Rep     MovsB
                Add     SI, 4
                Add     DI, 4
                MovsW
                MovsW

                Cmp     DX, 99
                JNE     LoadSample5

                Mov     AX, [Word Ptr CS:CheckDataArea+2Eh]
                Mov     [DS:SI-50h+2Eh], AX
                Mov     AL, [CS:CheckDataArea+12h]
                Mov     [DS:SI-50h+12h], AL

                Mov     AX, CS:CurrentSample
                Cmp     AX, CS:SampleInMemory
                JE      LoadSample7

                Mov     CS:SampleInMemory, AX

                Call    D_DrawWaveForm

LoadSample5:
                Mov     AX, DX
                Inc     AX
                Call    Music_SoundCardLoadSample

LoadSample7:
                ClC
                Jmp     LoadSample1
                Ret

LoadSample2:
                Mov     CS:SampleInMemory, 0FFFFh
                Jmp     LoadSample6

LoadSample8:
                Pop     AX

LoadSample6:
                Pop     AX
                StC

LoadSample1:
                PushF
                Call    PE_RestoreCurrentPattern
                PopF
                Ret

EndP            LoadSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

include it_d_ris.inc

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LSViewWindow_Enter Far

                Assume  DS:Disk

                Cmp     NumSamples, 0
                JE      LSViewWindow_Enter1

                Mov     AX, 96
                Mul     CurrentSample
                Mov     SI, AX
                        Assume DS:Nothing

                Mov     DS, DiskDataArea
                Mov     DL, [DS:SI+88]
                Cmp     DL, 1
                JE      LSViewWindow_Enter1

                Cmp     DL, 20h
                JAE     LSViewWindow_Enter2

                Mov     AX, 1
                Ret

EndP            LSViewWindow_Enter

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LSWindow_Enter  Far

                Assume  DS:Disk

                Cmp     NumSamples, 0
                JE      LSWindow_Enter2

                Mov     AX, 96
                Mul     CurrentSample
                Mov     SI, AX
                        Assume DS:Nothing

                Mov     DS, DiskDataArea
                Mov     DX, [DS:SI+88]          ; Also get DH = InsampleChannels
                Cmp     DL, 1
                JNE     LSWindow_Enter1

LSViewWindow_Enter1:
                Push    DS
                Push    SI

                Push    CS
                Pop     DS
                Mov     SI, Offset SampleDirectory
                Call    D_SetDriveDirectory

                Pop     SI
                Pop     DS

                Add     SI, 4
                Call    D_SetDriveDirectory

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset SampleDirectory
                Call    D_GetDriveDirectory

LSWindow_EnterInModuleError:
                Mov     SamplesInModule, 0
                Call    D_InitLoadSamples
                        Assume DS:Nothing
                Mov     CS:CurrentSample, 0

                Mov     AX, 1
                Ret

LSWindow_Enter1:                                ; Load sample into sample list.
                Cmp     DL, 20h
                JB      LSWindow_EnterSample

LSViewWindow_Enter2:
                Sub     DL, 20h
                Mov     Word Ptr CS:InSampleFormat, DX
                Mov     EAX, [SI+54h]
                Mov     CS:InSampleDateTime, EAX

                Add     SI, 4
                                                ; Copy module name across
                Push    CS
                Pop     ES
                Mov     DI, Offset InSampleFileName
                Mov     CX, 13
                Rep     MovsB
                                                ; Open file
                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     CurrentSample, 0

LSWindow_EnterLoadInSampleData:
                Mov     DX, Offset InSampleFileName
                Mov     AX, 3D00h
                Int     21h
                JC      LSWindow_EnterInModuleError

                Mov     BX, AX

                Mov     SI, Word Ptr InSampleFormat
                And     SI, 0FFh
                Add     SI, SI

                Mov     NumSamples, 1

                Mov     DS, DiskDataArea
                        Assume DS:Nothing

                Push    DS
                Pop     ES

                Call    [CS:LoadSamplesInModuleTable+SI]

                        ; Close module
                Mov     AH, 3Eh
                Int     21h

                                ; Setup first 'directory'

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Xor     DI, DI
                Mov     SI, Offset ExitLibraryDirectory
                Mov     CX, 89
                Rep     MovsB

                Mov     EAX, InSampleDateTime
                Mov     [ES:DI-5], EAX
                Mov     SampleCacheFileComplete, 1
                Mov     SamplesInModule, 1
                Mov     SampleInMemory, 0FFFFh
                Mov     SampleCheck, 0FFFFh

                Mov     AX, NumSamples
                Mov     LoadSampleNameCount, AX

                Mov     AX, 1
                Ret

                Assume DS:Nothing

LSWindow_EnterSample:
                Call    Music_Stop

                Mov     AX, [Word Ptr CS:CheckDataArea+2Eh]
                Mov     [SI+2Eh], AX
                                                ; prompt whether to initialise
                                                ;  instrument
                                                ; 1) Only when no sample was
                                                ;    previously present
                                                ; 2) When instrument mode is
                                                ;    on.
                Mov     AX, 99                  ; Release sample!
                Call    Music_ReleaseSample

                Xor     DX, DX                  ; Assume don't call.

                Call    Music_GetInstrumentMode
                JZ      LSWindow_Enter4         ; Sample mode!

                                                ; Instrument mode

                                                ; Check whether previous sample
                                                ;  existed.
                Push    DS
                Push    SI

                Mov     CX, 4                   ; Assume Not OK

                Call    I_GetSampleOffset       ; DS:BX points to sample.
                Test    Byte Ptr [BX+12h], 1
                JNZ     LSWindow_Enter5

                Mov     CX, 3                   ; Assume OK.

LSWindow_Enter5:
                Mov     DI, Offset O1_InitInstrument
                Call    M_Object1List
                                                ; DX contains init flag.
                Pop     SI
                Pop     DS

LSWindow_Enter4:
                Push    DX

                Call    PE_GetLastInstrument
                Mov     AX, BX
                Push    AX
                Call    LoadSample
                Pop     CX
                Xor     DX, DX

IF NETWORKENABLED
                NetworkSendSample
                Call    Network_QueueSampleData
ENDIF

                Pop     DX

                Test    DX, DX
                JZ      LSWindow_Enter7

                Call    PE_GetLastInstrument    ; BX = sample number
                Call    Music_AssignSampleToInstrument

                Push    CS
                Pop     DS
                Mov     SI, Offset InitInstrumentErrorMsg
                JC      LSWindow_Enter6

                Mov     SI, Offset InitInstrumentMsg

LSWindow_Enter6:
                Call    SetInfoLine

LSWindow_Enter7:
                Jmp     Glbl_F3

LSWindow_Enter2:
                Mov     AX, 1
                Ret

EndP            LSWindow_Enter
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LSWindow_Space Far

                Assume  DS:Disk

                Cmp     NumSamples, 0
                JE      LSViewWindow_Enter1

                Mov     AX, 96
                Mul     CurrentSample
                LEA     SI, [EAX+14h]
                        Assume DS:Nothing

                Push    SI

                Mov     DS, DiskDataArea

                Push    CS
                Pop     ES
                Mov     DI, Offset SampleName

                Mov     CX, 26
                Mov     BX, DI

LSWindow_Space1:
                LodsB
                And     AL, AL
                JNZ     LS_WindowSpace2

                Mov     AL, ' '
                Jmp     LS_WindowSpace3

LS_WindowSpace2:
                Cmp     AL, ' '
                JE      LS_WindowSpace3

                Mov     BX, DI
                Inc     BX

LS_WindowSpace3:
                StosB
                Loop    LSWindow_Space1

                Mov     Byte Ptr [ES:BX], 0


                Mov     DI, Offset O1_EditSampleName
                Mov     CX, 3
                Call    M_Object1List

                Pop     DI                      ; DI contains offset of sample

                And     DX, DX
                JZ      LS_WindowSpace4

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset SampleName
                Mov     CX, 26
                Mov     ES, DiskDataArea
                Rep     MovsB

LS_WindowSpace4:
                Mov     AX, 1
                Ret

EndP            LSWindow_Space

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LSWindow_Up  Far

                Call    CheckSampleModified
                JC      LSWindow_Up1

                Assume  DS:Disk

                Mov     AX, CurrentSample
                And     AX, AX
                JZ      LSWindow_Up1

                Dec     CurrentSample

LSWindow_Up1:
                Mov     AX, 1
                Ret

EndP            LSWindow_Up
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LSWindow_Down  Far

                Call    CheckSampleModified
                JC      LSWindow_Down1

                Assume  DS:Disk

                Mov     AX, CurrentSample

                Inc     AX
                Cmp     AX, NumSamples
                JAE     LSWindow_Down1

                Mov     CurrentSample, AX

LSWindow_Down1:
                Mov     AX, 1
                Ret

EndP            LSWindow_Down
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LSWindow_PgUp   Far

                Call    CheckSampleModified
                JC      LSWindow_PgUp1

                Assume  DS:Disk

                Mov     AX, CurrentSample

                Sub     AX, 35
                JC      LSWindow_Home

                Mov     CurrentSample, AX

LSWindow_PgUp1:
                Mov     AX, 1
                Ret

EndP            LSWindow_PgUp
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LSWindow_PgDn   Far

                Call    CheckSampleModified
                JC      LSWindow_PgDn1

                Assume  DS:Disk

                Mov     AX, CurrentSample

                Add     AX, 35
                Cmp     AX, NumSamples
                JAE     LSWindow_End

                Mov     CurrentSample, AX

LSWindow_PgDn1:
                Mov     AX, 1
                Ret

EndP            LSWindow_PgDn
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LSWindow_Home   Far

                Call    CheckSampleModified
                JC      LSWindow_Home1

                Assume  DS:Disk

                Mov     CurrentSample, 0

LSWindow_Home1:
                Mov     AX, 1
                Ret

EndP            LSWindow_Home
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LSWindow_End    Far

                Call    CheckSampleModified
                JC      LSWindow_End1

                Assume  DS:Disk

                Mov     AX, NumSamples

                Dec     AX
                JS      LSWindow_End1

                Mov     CurrentSample, AX

LSWindow_End1:
                Mov     AX, 1
                Ret

EndP            LSWindow_End
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LSCheckLoopValues Far

                Call    D_GetLoadSampleVars             ; DS:SI points to thing

                Mov     BX, SI

                Mov     EAX, [BX+30h]
                Cmp     EAX, [BX+34h]
                JA      D_LSCheckLoopValues3

                Mov     [BX+34h], EAX

D_LSCheckLoopValues3:
                Cmp     EAX, [BX+38h]
                JAE     D_LSCheckLoopValues2

                Mov     [BX+38h], EAX

D_LSCheckLoopValues2:
                Mov     EAX, [BX+38h]
                Cmp     EAX, [BX+34h]
                JA      D_LSCheckLoopValues1

                And     Byte Ptr [BX+12h], NOT 00010000b

D_LSCheckLoopValues1:
                Call    D_DrawWaveForm

                Ret

EndP            D_LSCheckLoopValues

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LSCheckSusLoopValues Far

                Call    D_GetLoadSampleVars             ; DS:SI points to thing

                Mov     BX, SI

                Mov     EAX, [BX+30h]
                Cmp     EAX, [BX+40h]
                JA      D_LSCheckSusLoopValues3

                Mov     [BX+40h], EAX

D_LSCheckSusLoopValues3:
                Cmp     EAX, [BX+44h]
                JAE     D_LSCheckSusLoopValues2

                Mov     [BX+44h], EAX

D_LSCheckSusLoopValues2:
                Mov     EAX, [BX+44h]
                Cmp     EAX, [BX+40h]
                JA      D_LSCheckLoopValues1

                And     Byte Ptr [BX+12h], NOT 00100000b

D_LSCheckSusLoopValues1:
                Call    D_DrawWaveForm

                Ret

EndP            D_LSCheckSusLoopValues

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SaveSong Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset SongDirectory
                Call    D_SetDriveDirectory     ; DS:SI points to cur dir.

                Cmp     Byte Ptr [FileName], 0
                JNE     D_SaveSong2

                Jmp     Glbl_F10

D_SaveSong2:
;                Call    D_CheckOverWrite
;                JC      D_SaveSong1

                Push    CS
;                Push    CS
;                Pop     DS
                Pop     ES

                Mov     SI, Offset FileName
                Mov     DI, Offset SaveFileName
                Mov     CX, 14

D_SaveSong3:
                LodsB
                StosB
                Cmp     AL, '.'
                LoopNE  D_SaveSong3
                JNE     D_SaveSong4

                Cmp     SaveFormat, 1
                JE      D_SaveSong5

                Mov     AX, 'TI'
                StosW
                Xor     AX, AX
                StosB
                Jmp     D_SaveSong4

D_SaveSong5:
                Mov     AX, '3S'
                StosW
                Mov     AX, 'M'
                StosW

D_SaveSong4:
                Xor     AL, AL
                Call    Glbl_SetCurrentMode

                Cmp     SaveFormat, 1
                JE      D_SaveFileS3MModule
                Jmp     D_SaveFileITModule

EndP            D_SaveSong
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_PreSaveSample

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     NoSaveError, 0

                Mov     SI, Offset SampleDirectory
                Call    D_SetDriveDirectory

                Call    PE_GetLastInstrument
                Call    Music_GetSongSegment
                Mov     DS, AX
                        Assume DS:Nothing

                Mov     SI, BX
                Add     SI, SI
                Mov     SI, [DS:64912+SI]       ; SI points to sample.
                Inc     BX

                                                ; Check if sample exists
                Test    Byte Ptr [SI+12h], 1
                JZ      D_PreSaveSample1

                Call    DeleteSampleCacheFile

                LEA     DX, [SI+4]

                Call    D_CheckOverWrite
                Ret

D_PreSaveSample1:
                StC
                Ret

EndP            D_PreSaveSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SaveSample Far

                Call    D_PreSaveSample
                JC      D_SaveSample2

Proc            D_SaveSampleInternal Far
                                                ; OK to save. DS:SI points to
                                                ; structure, BX = sample num
                Mov     ES, CS:DiskDataArea
                Xor     DI, DI
                Mov     CX, 80
                Rep     MovsB
                Mov     Byte Ptr [ES:2Eh], 1
                Mov     DWord Ptr [ES:48h], 80

                Push    ES
                Pop     DS

                Mov     AH, 3Ch
                Xor     CX, CX
                Mov     DX, 4
                Int     21h                     ; Open file.
                JC      D_SaveSample2

                Push    BX                      ; BX = sample number
                Mov     BX, AX                  ; BX = file handle

                Mov     AH, 40h
                Mov     CX, 80
                Xor     DX, DX
                Int     21h                     ; Save header.

                Pop     AX                      ; AX = sample number
                Push    AX

                Call    D_SaveSampleData
                PushF

                Mov     AH, 3Eh
                Int     21h                     ; Close file

                PopF
                Pop     BX                      ; AX = sample number
                JC      D_SaveSample2

                Push    CS
                Pop     DS
                Mov     AX, BX
                Mov     SI, Offset ITSampleSavedMsg
                Call    SetInfoLine

                Jmp     D_SaveSampleEnd

D_SaveSample2:
                Push    CS
                Pop     DS
                Mov     AX, BX
                Mov     SI, Offset SampleErrorMsg
                Call    SetInfoLine

D_SaveSampleEnd:
                Mov     AX, 1
                Ret

EndP            D_SaveSampleInternal

EndP            D_SaveSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SaveRawSample Far
                Assume DS:Disk

                Call    D_PreSaveSample         ; DS:SI points to structure
                JC      D_SaveRawSample2
                        Assume DS:Nothing

IF SAVESAMPLEWAV
                Mov     DWord Ptr [CS:WaveBytesPerSample], 80001h
                Mov     ECX, [SI+3Ch]          ; C5Speed
                Mov     [CS:WAVEMixSpeed], ECX
                Mov     EAX, [SI+30h]          ; Length
                Test    Byte Ptr [SI+12h], 2
                JZ      D_SaveWAVHeader1

                Add     EAX, EAX
                Add     ECX, ECX
                Mov     DWord Ptr [CS:WaveBytesPerSample], 100002h

D_SaveWAVHeader1:
                Mov     [CS:WAVEDataSize], EAX
                Mov     [CS:WAVEBytesPerSecond], ECX
ENDIF
                Push    DS
                Push    SI

                Mov     AX, BX                  ; AX = sample number.
                Xor     CX, CX
                Call    Music_GetSampleLocation ; ES:DI points to sample.

                Mov     DI, SI
                Push    DS
                Pop     ES

                Pop     SI
                Pop     DS

                PushF

                Mov     AH, 3Ch
                Xor     CX, CX
                LEA     DX, [SI+4]
                Int     21h
                JC      D_SaveRawSample3

IF SAVESAMPLEWAV
                PushA
                Push    DS

                Push    CS
                Pop     DS

                Mov     BX, AX
                Mov     AH, 40h
                Mov     DX, Offset WAVEFileHeader
                Mov     CX, 2Ch
                Int     21h

                Pop     DS
                PopA
ENDIF

                PopF
                Push    BX
                XChg    AX, BX                  ; BX = file handle, AX = sample
                                                ; number
                JZ      D_SaveRawSample1        ; 8 bit, write as unsigned

                Call    D_SaveSampleData
                PushF
                Jmp     D_SaveRawSample4

D_SaveRawSample1:
                Call    D_SaveSampleDataConvert
                PushF

D_SaveRawSample4:
                Mov     AH, 3Eh
                Int     21h                     ; Close file.

                PopF
                Pop     BX                      ; BX = Sample number

                JC      D_SaveRawSample2

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     AX, BX
                Mov     SI, Offset RawSampleSavedMsg
                Call    SetInfoLine

                ClC
                Jmp     D_SaveRawSampleEnd

D_SaveRawSample3:
                PopF

D_SaveRawSample2:
                Push    CS
                Pop     DS
                Mov     AX, BX
                Mov     SI, Offset SampleErrorMsg
                Call    SetInfoLine
                StC

D_SaveRawSampleEnd:
                Mov     AX, 1
                Ret

EndP            D_SaveRawSample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SaveST3Sample Far

                Call    D_PreSaveSample
                JC      D_SaveST3Sample2

                                                ; OK to save. DS:SI points to
                                                ; structure, BX = sample num
                Mov     ES, CS:DiskDataArea
                Xor     DI, DI
                Mov     AL, 1
                StosB
                Push    SI
                Mov     CX, 13
                Add     SI, 4
                Rep     MovsB
                Pop     SI
                Mov     AX, 5
                StosW                           ; FileName

                Mov     EAX, [DS:SI+30h]         ; LoopStart
                StosD

                Mov     EAX, [DS:SI+34h]         ; LoopBeg
                StosD

                Mov     EAX, [DS:SI+38h]         ; LoopEnd
                StosD

                Xor     AX, AX
                Mov     AL, Byte Ptr [DS:SI+13h]
                StosW                           ; Volume

                Mov     AH, [DS:SI+12h]
                Mov     AL, AH
                And     AX, 1002h
                ShR     AH, 4
                ShL     AL, 1
                Or      AH, AL
                Xor     AL, AL
                StosW                           ; Flags & Pack

                Mov     EAX, [DS:SI+3Ch]
                StosD

                Mov     CX, 6
                Xor     AX, AX
                Rep     StosW

                Add     SI, 14h
                Mov     CX, 25
                Rep     MovsB
                Xor     AX, AX
                StosB
                StosW

                Mov     EAX, 'SRCS'
                StosD

                Push    ES
                Pop     DS

                Mov     AH, 3Ch
                Xor     CX, CX
                Mov     DX, 1
                Int     21h                     ; Open file.
                JC      D_SaveST3Sample2

                Push    BX                      ; BX = sample number
                Mov     BX, AX                  ; BX = file handle

                Mov     AH, 40h
                Mov     CX, 80
                Xor     DX, DX
                Int     21h                     ; Save header.

                Pop     AX                      ; AX = sample number
                Push    AX

                Call    D_SaveSampleDataConvert

                PushF

                Mov     AH, 3Eh
                Int     21h                     ; Close file

                PopF
                Pop     BX

                JC      D_SaveST3Sample2

                Push    CS
                Pop     DS
                Mov     AX, BX
                Mov     SI, Offset ST3SampleSavedMsg
                Call    SetInfoLine

                Jmp     D_SaveST3SampleEnd

D_SaveST3Sample2:
                Push    CS
                Pop     DS
                Mov     AX, BX
                Mov     SI, Offset SampleErrorMsg
                Call    SetInfoLine

D_SaveST3SampleEnd:
                Mov     AX, 1
                Ret

EndP            D_SaveST3Sample

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SaveInstrument Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     NoSaveError, 0

                Mov     SI, Offset InstrumentDirectory
                Call    D_SetDriveDirectory

                Call    PE_GetLastInstrument
                Call    Music_GetSongSegment
                Mov     DS, AX
                        Assume DS:Nothing

                Mov     SI, BX
                Add     SI, SI
                Mov     SI, [DS:64712+SI]       ; SI points to instrument

                Call    DeleteInstrumentCacheFile

;                Mov     DX, SI
;                Add     DX, 4
                LEA     DX, [SI+4]

                Call    D_CheckOverWrite
                JC      D_SaveInstrumentError

                                                ; DS:SI still points to ins.
                                                ; Clear InstrumentTable setup table.
                Push    CS
                Pop     ES
                Mov     DI, Offset InstrumentTable
                Xor     AX, AX
                Mov     CX, 50
                Rep     StosW                   ; OK.. table clear.

                                                ; Now step through instrument
                                                ; list and get sample numbers.
                Push    DS
                Push    SI

                Add     SI, 40h
                Mov     CX, 120
                Xor     BX, BX

D_SaveInstrument1:
                LodsW
                Mov     BL, AH                  ; BL = sample number.
                Mov     [CS:InstrumentTable+BX], 1
                Loop    D_SaveInstrument1

                                                ; OK. Instrument table contains
                                                ; 1s for every sample used...
                                                ; Now to re-translate it.
                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     AH, 0
                Mov     CX, 99
                Mov     SI, Offset InstrumentTable
                Mov     Byte Ptr [SI], 0

D_SaveInstrument2:
                Cmp     Byte Ptr [SI], 0
                JE      D_SaveInstrument3

                Inc     AH
                Mov     [SI], AH

D_SaveInstrument3:
                Inc     SI
                Loop    D_SaveInstrument2
                                ; AH = number of samples..
                                ; Now let's copy it to the Diskdata.

                Pop     SI
                Pop     DS
                        Assume DS:Nothing

                Mov     ES, CS:DiskDataArea
                Xor     DI, DI
                Mov     CX, 554/2

                Rep     MovsW

                Push    ES
                Pop     DS
                        Assume DS:Nothing

                Mov     [DS:1Eh], AH    ; AH = number of samples.
                Mov     Word Ptr [DS:1Ch], TRACKERVERSION

                                        ; Now to translate
                Mov     DI, 41h
;                Xor     BX, BX
                Mov     CX, 120

D_SaveInstrument4:
                Mov     BL, [DI]
                Mov     AL, [CS:InstrumentTable+BX]
                StosB
                Inc     DI

                Loop    D_SaveInstrument4
                                        ; headerfilesize=554(instrumentheader)+
                                        ; 80*AH.
                Mov     AL, 80
                Mul     AH     
                Add     AX, 554         ; AX = header size.

                Push    AX

                Mov     DX, AX
                Xor     CX, CX          ; CX:DX = posn in file.

                Call    Music_GetSongSegment
                Mov     DS, AX
                Mov     DI, 554         ; DI = posn in header.
                Xor     BX, BX

D_SaveInstrument5:                      ; Loop to get samples into header.
                Cmp     [CS:InstrumentTable+BX], 0
                JE      D_SaveInstrument6

                Mov     SI, BX
                Add     SI, SI
                Mov     SI, [DS:64912+SI-2]     ; DS:SI points to sample.

                Push    CX                      ; Move the header...
                Mov     CX, 40
                Rep     MovsW
                Pop     CX

                Mov     [ES:DI-80+48h], DX      ; File pointer.
                Mov     [ES:DI-80+4Ah], CX

                Mov     AL, [ES:DI-80+12h]
                Test    AL, 1
                JZ      D_SaveInstrument6

                Add     DX, [ES:DI-80+30h]
                AdC     CX, [ES:DI-80+32h]

                Test    AL, 2
                JZ      D_SaveInstrument6

                Add     DX, [ES:DI-80+30h]
                AdC     CX, [ES:DI-80+32h]

D_SaveInstrument6:
                Inc     BX
                Cmp     BX, 100
                JB      D_SaveInstrument5

                Push    ES
                Pop     DS              ; Lets open the file!
                Mov     DX, 4

                Mov     AH, 3Ch         ; Open file!
                Xor     CX, CX          ; Normal attributes
                Int     21h

                Pop     CX              ; CX = header size

                JC      D_SaveInstrumentError

                Mov     BX, AX          ; BX = file handle...

                Xor     DX, DX
                Call    D_SaveBlock     ; OK.. header's written.. now save
                                        ; individual samples...
                Mov     DI, 1

D_SaveInstrument7:
                Cmp     [CS:InstrumentTable+DI], 0
                JE      D_SaveInstrument8

                Mov     AX, DI

                Call    D_SaveSampleData

D_SaveInstrument8:
                Inc     DI
                Cmp     DI, 100
                JBE     D_SaveInstrument7

                Mov     AH, 3Eh
                Int     21h
                Jmp     D_SaveInstrumentOK

D_SaveInstrumentError:
                Push    CS
                Pop     DS

                Call    PE_GetLastInstrument
                Mov     AX, BX
                Inc     AX
                Mov     SI, Offset InstrumentErrorMsg
                Call    SetInfoLine

                Jmp     D_SaveInstrumentEnd

D_SaveInstrumentOK:
                Push    CS
                Pop     DS

                Call    PE_GetLastInstrument
                Mov     AX, BX
                Inc     AX
                Mov     SI, Offset ITInstrumentSavedMsg
                Call    SetInfoLine

D_SaveInstrumentEnd:
                Mov     AX, 1
                Ret

EndP            D_SaveInstrument
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_DeleteSampleFile Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Cmp     NumSamples, 0
                JE      D_DeleteSampleFile1
                Cmp     SamplesInModule, 0
                JNE     D_DeleteSampleFile1

                Mov     AX, 96
                Mul     CurrentSample
                Mov     SI, AX
                Mov     DS, DiskDataArea
                        Assume DS:Nothing
                Cmp     Byte Ptr [DS:SI+58h], 1
                JBE     D_DeleteSampleFile1             ; Don't delete dirs!
;                Cmp     Byte Ptr [DS:SI+58h], 20h
;                JAE     D_DeleteSampleFile1

                Push    DS
                Push    SI

                Mov     DI, Offset O1_ConfirmDelete2
                Mov     CX, 4
                Call    M_Object1List

                Pop     SI
                Pop     DS

                And     DX, DX                  ; OK to delete?
                JZ      D_DeleteSampleFile1

                                                ; Delete file....
                LEA     DX, [SI+4]
                Mov     AH, 41h
                Int     21h
                JC      D_DeleteSampleFile1

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     DI, SI
                Add     SI, 96

                Mov     CX, NumSamples          ; Wipe from list..
                Mov     BX, CurrentSample
                Sub     CX, BX

                Mov     AX, 96
                Mul     CX
                Mov     CX, AX

                Push    DS

                Mov     DS, DiskDataArea
                Push    DS
                Pop     ES

                Rep     MovsB

                Pop     DS

                Mov     SampleInMemory, 0FFFFh
                Mov     SampleCheck, 0FFFFh

                Dec     NumSamples
                JZ      D_DeleteSampleFile2

                Cmp     BX, NumSamples
                JB      D_DeleteSampleFile2

                Mov     BX, NumSamples
                Dec     BX
                Mov     CurrentSample, BX

D_DeleteSampleFile2:
                Cmp     SampleCacheFileComplete, 1
                JNE     D_DeleteSampleFile1

                Call    D_SaveSampleCacheFile

D_DeleteSampleFile1:
                Mov     AX, 1
                Ret

EndP            D_DeleteSampleFile
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CheckSampleModified

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Cmp     SamplesInModule, 0
                JNE     CheckSampleModified1

                Mov     AX, 96
                Mul     CurrentSample

                Mov     ES, DiskDataArea
                Mov     DI, AX
                Mov     DL, [ES:DI+88]
                Cmp     DL, 1
                JBE     CheckSampleModified1
                Cmp     DL, 20h
                JAE     CheckSampleModified1

                Mov     SI, Offset CheckDataArea

                Mov     CX, 12h
                RepE    CmpSB
                JNE     CheckSampleModified7
                Inc     SI
                Inc     DI
                Mov     CX, 50h-12h-1
                RepE    CmpsB
                JE      CheckSampleModified1
                Mov     CX, 80
                RepE    CmpsB

                ; Check whether file name changed...
CheckSampleModified7:
                Mov     DI, AX
                Mov     SI, Offset CheckDataArea+4
                Add     DI, 4

                Mov     CX, 13
                RepE    CmpsB
                JE      CheckSampleModified3

CheckSampleModified2:                           ; Sample name different.
                Mov     DI, Offset O1_ConfirmSaveRenameList
                Mov     CX, 3
                Call    M_Object1List
                                                ; DX = 0 -> don't save
                                                ; DX = 1 -> save
                And     DX, DX
                JZ      CheckSampleModified4

                                                ; Load Sample
                Push    CS
                Pop     DS

                Mov     SI, Offset CheckDataArea
                Mov     AX, 99
                Call    LoadSample              ; Load sample into slot 100!
                JC      CheckSampleModified5
                                                ; Save sample
                Mov     AX, 96
                Mul     CS:CurrentSample
                Mov     SI, AX
                Mov     DS, CS:DiskDataArea
                Mov     BX, 100                 ; DS:SI points to block
                Push    DS
                Push    SI
                Call    D_SaveSampleInternal
                Pop     SI
                Pop     DS
                JC      CheckSampleModified6
                                                ; Delete old sample

                Push    CS
                Pop     DS
                Mov     DX, Offset CheckDataArea+4
                Mov     AH, 41h
                Int     21h                     ; Delete file

                                                ; Now update sample data...

                Call    DeleteSampleCacheFile
                Call    D_InitLoadSamples

                Jmp     CheckSampleModified1    ; Return OK!

CheckSampleModified3:                           ; Sample name the same.
                Mov     DI, Offset O1_ConfirmResaveList
                Mov     CX, 3
                Call    M_Object1List
                                                ; DX = 0 -> don't save
                                                ; DX = 1 -> save
                And     DX, DX
                JZ      CheckSampleModified4

                                                ; Load Sample
                Push    CS
                Pop     DS

                Mov     SI, Offset CheckDataArea
                Mov     AX, 99
                Call    LoadSample              ; Load sample into slot 100!
                JC      CheckSampleModified5

                                                ; Save Sample
                Mov     AX, 96
                Mul     CS:CurrentSample
                Mov     SI, AX
                Mov     DS, CS:DiskDataArea
                Mov     BX, 100                 ; DS:SI points to block
                Push    DS
                Push    SI
                Call    D_SaveSampleInternal
                Pop     SI
                Pop     DS
                JC      CheckSampleModified6
                                                ; Now update sample data...
                Call    DeleteSampleCacheFile
                Call    D_InitLoadSamples

                Jmp     CheckSampleModified1

CheckSampleModified4:                           ; Prompt to discard changes..
                Mov     DI, Offset O1_ConfirmDiscardList
                Mov     CX, 4
                Call    M_Object1List
                                                ; DX = 0 -> don't discard
                                                ; DX = 1 -> discard
                And     DX, DX
                JZ      CheckSampleModified5

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset CheckDataArea
                Mov     ES, DS:DiskDataArea
                Mov     AX, 96
                Mul     CurrentSample
                Mov     DI, AX
                Mov     CX, 80
                Rep     MovsB

                Jmp     CheckSampleModified1

CheckSampleModified6:
                Call    DeleteSampleCacheFile
                Call    D_InitLoadSamples

CheckSampleModified5:
                Push    CS
                Pop     DS

                StC
                Ret

CheckSampleModified1:
                Push    CS
                Pop     DS

                ClC
                Ret

EndP            CheckSampleModified
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_DrawWaveForm Far

                PushAD
                Push    DS
                Push    ES

                Call    S_GetGenerationTableOffset
                Push    DI
                Mov     CX, 248*32
                Xor     AL, AL
                Rep     StosB
                Pop     DI

                Mov     AX, 100
                Xor     CX, CX
                Call    Music_GetSampleLocation ; Gets DS:SI and CX
                JC      D_DrawWaveFormEnd

;                Push    AX              ; AX = instrument num
                                        ; DS:SI = waveform, CX = length
                                        ; ES:DI = charactergenerationtable

                SetNZ   CS:Resolution
                JZ      D_DrawWaveForm8Bit

                Add     ECX, ECX
                Inc     SI

D_DrawWaveForm8Bit:

                Mov     EAX, ECX
                Mov     ECX, 248
                Xor     EDX, EDX
                Div     ECX              ; AX = major shift. DX = minor shift.

                Mov     EBX, EAX
                Xor     EAX, EAX
                Div     ECX

                Mov     EDX, EAX
                Xor     EAX, EAX

                Mov     EBP, ESI

D_DrawWaveForm6:
                Add     EAX, EDX
                AdC     EBP, EBX
                Push    EAX
                Push    EBX
                Push    ECX
                Push    EDX

                Mov     CL, [SI]
                Mov     CH, CL

                Mov     BX, 1
                Add     BL, CS:Resolution

D_DrawWaveForm10:
                Cmp     ESI, EBP
                JAE     D_DrawWaveForm7

                Mov     AL, [SI]
                Add     SI, BX
                JC      D_DrawWaveFormUpdateLocation

D_DrawWaveFormResume:
                Cmp     AL, CL
                JL      D_DrawWaveForm8

                Cmp     AL, CH
                JLE     D_DrawWaveForm10

                Mov     CH, AL
                Jmp     D_DrawWaveForm10

D_DrawWaveFormUpdateLocation:
                Add     ESI, 10000h
                Int     3
                Jmp     D_DrawWaveFormResume

D_DrawWaveForm8:
                Mov     CL, AL
                Jmp     D_DrawWaveForm10

D_DrawWaveForm7:                                ; CL = min, CH = max.
                Mov     AX, CX
                SAR     AH, 1
                SAR     AL, 1
                Add     AX, 202h
                SAR     AL, 2
                SAR     AH, 2

                Xor     CH, CH
                Mov     CL, AH
                Sub     CL, AL                  ; CX = iterations.
                Inc     CX

                Mov     AL, 16
                Sub     AL, AH
                Cmp     AL, 32
                JNE     D_DrawWaveForm13

                Mov     AL, 31

D_DrawWaveForm13:
                Mov     AH, 31*8
                Mul     AH
                Mov     BX, AX

D_DrawWaveForm11:
                Mov     Byte Ptr [ES:DI+BX], 1
                Add     BX, 248
                Loop    D_DrawWaveForm11

D_DrawWaveForm12:
                Pop     EDX
                Pop     ECX
                Pop     EBX
                Pop     EAX
                Inc     DI
                Loop    D_DrawWaveForm6

                                                ; Get Sample header offset.
;                Call    Music_GetSongSegment
;                Mov     DS, AX
;                Pop     SI
;                Dec     SI
;                Add     SI, SI
;                Mov     SI, [64912+SI]
                Mov     AX, 96
                Mul     CS:CurrentSample
                Mov     DS, CS:DiskDataArea
                Mov     SI, AX


                Mov     EBX, [DS:SI+30h]
                Test    Byte Ptr [DS:SI+12h], 10h
                JZ      D_DrawWaveForm14

                Mov     ECX, EBX
                ShR     ECX, 1

                Mov     EAX, 247
                Mul     DWord Ptr [DS:SI+34h]
                Add     EAX, ECX
                AdC     EDX, 0
                Div     EBX

                Push    EAX              ; AX = loop start.

                Mov     EAX, 247
                Mul     DWord Ptr [DS:SI+38h]
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
                Mov     AH, 1

D_DrawSampleWaveFormLoop1:
                Push    DI

                Xor     AL, AL
                Test    AH, 2
                JZ      D_DrawSampleWaveFormLoop2

                Inc     AX

D_DrawSampleWaveFormLoop2:
                StosB
                Add     DI, DX
                StosB

                Pop     DI
                Add     DI, 248
                Inc     AH
                Loop    D_DrawSampleWaveFormLoop1

D_DrawWaveForm14:
                Test    Byte Ptr [DS:SI+12h], 20h
                JZ      D_DrawWaveFormEnd

                Mov     ECX, EBX
                ShR     ECX, 1

                Mov     EAX, 247
                Mul     DWord Ptr [DS:SI+40h]
                Add     EAX, ECX
                AdC     EDX, 0
                Div     EBX

                Push    EAX              ; AX = loop start.

                Mov     EAX, 247
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

D_DrawSampleWaveFormSusLoop1:
                Push    DI

                StosB
                Add     DI, DX
                StosB

                Pop     DI
                Add     DI, 248
                Xor     AL, 1
                Loop    D_DrawSampleWaveFormSusLoop1

D_DrawWaveFormEnd:
                Mov     AX, 0
                Mov     BX, 31
                Mov     CX, 4
                Call    S_GenerateCharacters

                Pop     ES
                Pop     DS
                PopAD

                Ret

EndP            D_DrawWaveForm

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_ClearFileName Far

                Push    AX
                Push    CX
                Push    ES
                Push    DI

                Mov     DI, Offset FileName
                Push    CS
                Pop     ES
                Mov     CX, 7
                Xor     AX, AX
                Rep     StosW

                Pop     DI
                Pop     ES
                Pop     CX
                Pop     AX
                Ret

EndP            D_ClearFileName

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_GetFormatType Far

                Push    CS
                Pop     ES
                Mov     DI, Offset SaveFormat

                Ret

EndP            D_GetFormatType

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_DisableFileColours Far

                Mov     CS:FileColours, 0

                Ret

EndP            D_DisableFileColours

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LoadInstrumentFiles

                Mov     DS, CS:DiskDataArea
                Push    DS
                Pop     ES

                Xor     DI, DI
                Xor     AX, AX
                Mov     CX, 32768
                Rep     StosW

                Mov     DX, 64000
                Mov     AH, 1Ah
                Int     21h                     ; Shift DTA address..
                                                ; to DiskDataArea:64000

                Xor     DI, DI

                Push    CS
                Pop     DS
                Mov     DX, Offset AllFilesMask
                Mov     CX, 10h
                Mov     AH, 4Eh
                Int     21h

                Mov     DS, CS:DiskDataArea
                Push    DS
                Pop     ES

                JC      D_LoadInstrumentFiles2

D_LoadInstrumentFiles1:                         ; A directory was found!
                Test    Byte Ptr [DS:64000+15h], 10h
                JZ      D_LoadInstrumentFiles5  ; Check that it IS a directory

                Cmp     Word Ptr [DS:64000+1Eh], '.'
                JNE     D_LoadInstrumentFilesNoRoot

                Mov     Byte Ptr [DS:64000+1Eh], '\'

D_LoadInstrumentFilesNoRoot:
                Mov     DL, 1
                Call    Near Ptr D_LoadInstrumentFiles6

                Inc     CS:NumInstruments
                Inc     CS:LoadInstrumentNameCount

                Cmp     CS:NumInstruments, 999
                JAE     D_LoadInstrumentFiles4

D_LoadInstrumentFiles5:
                Mov     AH, 4Fh
                Int     21h
                JNC     D_LoadInstrumentFiles1

D_LoadInstrumentFiles2:                 ; Directories done.. samples now
                Push    CS
                Pop     DS
                Mov     DX, Offset AllFilesMask
                Xor     CX, CX
                Mov     AH, 4Eh
                Int     21h

                Mov     DS, CS:DiskDataArea
                Push    DS
                Pop     ES

                JC      D_LoadInstrumentFiles4

D_LoadInstrumentFiles3:
;                Push    DI
;
;                Mov     SI, Offset InstrumentCacheFileName
;                Mov     DI, 64000+1Eh
;                Mov     CX, 9
;                Rep     SegCS CmpsB
;                Pop     DI
;                JE      D_LoadInstrumentFilesNext

                Mov     DL, 0
                Call    Near Ptr D_LoadInstrumentFiles6

                Inc     CS:NumInstruments
                Cmp     CS:NumInstruments, 999
                JAE     D_LoadInstrumentFiles4

D_LoadInstrumentFilesNext:
                Mov     AH, 4Fh
                Int     21h
                JNC     D_LoadInstrumentFiles3

D_LoadInstrumentFiles4:                         ; End!
                Mov     AX, CS:NumInstruments
                Mov     CS:InitialInstruments, AX

                Ret

D_LoadInstrumentFiles6:                             ; Get name/size/date/time.
                Mov     AL, DL
                StosB

                Mov     SI, 64000+1Eh
                Mov     CX, 14                  ; Name..
                Rep     MovsB

                Cmp     DL, 1
                JNE     D_LoadInstrumentFiles7

                Push    DS
                Push    CS
                Pop     DS
                Mov     SI, Offset DirectoryMsg
                Mov     CX, 25
                Rep     MovsB

                Pop     DS

                Xor     AX, AX
                Mov     CX, 4
                Rep     StosW

                RetN

D_LoadInstrumentFiles7:
                Xor     AX, AX
                Mov     CX, 27
                Rep     StosB           ; No instrumentname, NOS = 0.

                Mov     AX, [DS:64000+1Ah]      ; File Size..
                Mov     DX, [DS:64000+1Ch]

                SHRD    AX, DX, 10
                ShR     DX, 10
                JZ      D_LoadInstrumentFiles8

                Mov     AX, 0FFFFh

D_LoadInstrumentFiles8:
                StosW

                Xor     EAX, EAX        ; Offset
                StosD

                RetN

EndP            D_LoadInstrumentFiles

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_InitLoadInstruments Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset InstrumentDirectory
                Call    D_SetDriveDirectory     ; DS:SI points to cur dir.

                Call    Music_GetSongSegment
                Mov     DS, AX

                Mov     CX, 99
                Mov     BX, [DS:64912]                  ; BX = offset to first
                                                        ;      sample.

                Mov     DX, CX                          ; DX = counter.
                Add     BX, 12h

D_InitLoadInstruments4:
                Mov     AL, [BX]
                ShR     AL, 1
                SBB     DX, 0

                Add     BX, 80
                Loop    D_InitLoadInstruments4

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     UnusedSamples, DX

                Cmp     InstrumentsInModule, 0
                JE      D_InitLoadInstruments5

                Jmp     LIWindow_EnterLoadInInstrumentData

D_InitLoadInstruments5:
                Mov     LoadInstrumentNameCount, 0
                Mov     NumInstruments, 0
                Mov     InstrumentCacheFileComplete, 0

                Mov     SI, Offset InstrumentDirectory
                Call    D_SetDriveDirectory     ; DS:SI points to cur dir.

                Mov     [OldCacheTime], 0

                Mov     AX, 3D00h               ; Open file..
                Mov     DX, Offset InstrumentCacheFileName
                Int     21h
                JC      D_InitLoadInstrument1   ; Can't open file?

                Mov     BX, AX

                Mov     AH, 3Fh
                Mov     CX, 6                   ; 2 integers containing number
                                                ; of sample entries...
                                                ; 3rd word = Version check
                Mov     DS, DiskDataArea
                        Assume DS:Nothing

                Xor     DX, DX
                Int     21h
                JC      D_InitLoadInstrument3
                Cmp     AX, CX
                JNE     D_InitLoadInstrument3

                Mov     AL, [CS:InstrumentDirectory]        ; AL = drive letter
                Cmp     AL, [CS:CDRomStartDrive]
                JL      InstrumentVersionCheck
                Cmp     AL, [CS:CDRomEndDrive]
                JGE     InstrumentVersionCheck

                Cmp     Word Ptr [DS:4], 211h
                JB      D_InitLoadInstrument3
                Cmp     Word Ptr [DS:4], TRACKERVERSION
                JBE     D_InitLoadInstrumentsCacheOK

InstrumentVersionCheck:
                Cmp     Word Ptr [DS:4], TRACKERVERSION
                JNE     D_InitLoadInstrument3

InstrumentVersionCheckEnd:
                Mov     AX, 5700h               ; Get file date&time.
                Int     21h

                Mov     Word Ptr [OldCacheTime], CX
                Mov     Word Ptr [OldCacheTime+2], DX

                Cmp     CX, Time                ; Check time and date
                JNE     D_InitLoadInstrumentOldCache ;  for 'currentness'
                Cmp     DX, Date
                JNE     D_InitLoadInstrumentOldCache
                                                ; OK.. let's load...

D_InitLoadInstrumentsCacheOK:
                Mov     AX, [DS:0]
                Mov     CS:InitialInstruments, AX

                Mov     SI, [DS:2]              ; Number of samples.
                Mov     AX, 48
                Mul     SI
                Mov     CX, AX                  ; Bytes to read.

                Mov     AH, 3Fh                 ; Load again.
                Xor     DX, DX                  ; In case of internal malfunc.
                Int     21h
                JC      D_InitLoadInstrument3
                Cmp     AX, CX
                JNE     D_InitLoadInstrument3

                Mov     AH, 3Eh                 ; Close file.
                Int     21h

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     LoadInstrumentNameCount, SI
                Mov     NumInstruments, SI
                Mov     InstrumentCacheFileComplete, 1

                Jmp     D_InitLoadInstrument2

D_InitLoadInstrumentOldCache:
                PushA
                Push    DS

                Call    D_GetNumFiles

                Pop     DS
                JC      D_InitLoadInstrument5

                Cmp     AX, [DS:0]

                PopA
                JNE     D_InitLoadInstrument3

                Call    Far Ptr D_InitLoadInstrumentsCacheOK

                Call    D_SaveInstrumentCacheFile   ; Resave it with new date

                Ret

D_InitLoadInstrument5:
                PopA

D_InitLoadInstrument3:
                Mov     AH, 3Eh                 ; Close file.
                Int     21h

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Call    DeleteInstrumentCacheFile

D_InitLoadInstrument1:
                Call    D_LoadInstrumentFiles

D_InitLoadInstrument2:
                Ret

EndP            D_InitLoadInstruments

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_LoadInstrumentNames Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Cmp     InstrumentCacheFileComplete, 1
                JNE     D_LoadInstrumentNames2

D_LoadInstrumentNames6:
                Xor     AX, AX                  ; No redraw screen.
                Ret

D_LoadInstrumentNames2:
                Mov     BX, LoadInstrumentNameCount
                Cmp     BX, NumInstruments
                JAE     D_LoadInstrumentNames5

D_LoadInstrumentNames1:
                Call    K_IsAnyKeyDown
                And     AL, AL
                JNZ     D_LoadInstrumentNames6

                Call    GetKeyboardLock
                And     AL, AL
                JNZ     D_LoadInstrumentNames6

                Mov     AX, 48
                Mul     BX
                Mov     SI, AX
                Mov     ES, DiskDataArea
                Cmp     Byte Ptr [ES:SI], 0
                JNE     D_LoadInstrumentNames3

                Call    D_LoadInstrumentHeader
                JC      D_LoadInstrumentNames3

                Call    D_GetInstrumentInfo         ; BX = sample number
                Push    CS
                Pop     DS
                JC      D_LoadInstrumentNames7

D_LoadInstrumentNames3:
                Push    CS
                Pop     DS
                        Assume DS:Disk

                Inc     LoadInstrumentNameCount

D_LoadInstrumentNames7:
                Mov     BX, LoadInstrumentNameCount
                Cmp     BX, NumInstruments
                JNE     D_LoadInstrumentNames4
                                                ; Save cache file..

D_LoadInstrumentNames5:
                Call    D_SaveInstrumentCacheFile
                Cmp     CurrentInstrument, 0
                JNE     D_LoadInstrumentNames4
                Call    D_SlowInstrumentSort

D_LoadInstrumentNames4:
                Mov     AX, 1                   ; Signify redraw screen
                Ret

EndP            D_LoadInstrumentNames

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_DrawLoadInstrument Far

                Cmp     CS:NumInstruments, 0
                JNE     D_DrawLoadInstrumentPresent

                Jmp     D_DrawLoadInstrumentEnd

D_DrawLoadInstrumentPresent:
                Mov     BX, CS:CurrentInstrument
                Mov     AX, 48
                Mul     BX
                Mov     SI, AX
                Mov     ES, CS:DiskDataArea

                Cmp     Byte Ptr [ES:SI], 0
                JNE     D_DrawLoadInstrumentWindow28

                Call    D_LoadInstrumentHeader
                Call    D_GetInstrumentInfo
                JC      D_DrawLoadInstrument

D_DrawLoadInstrumentWindow28:
                Call    S_GetDestination

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     AX, TopInstrument
                Mov     BX, CurrentInstrument
                Cmp     AX, BX
                JBE     D_DrawLoadInstrument1

                Mov     AX, BX

D_DrawLoadInstrument1:
                LEa     CX, [EAX+34]
                Cmp     CX, BX
                JA      D_DrawLoadInstrument2

                LEA     AX, [BX-34]

D_DrawLoadInstrument2:
                Mov     TopInstrument, AX

                Mov     DS, DiskDataArea
                        Assume DS:Nothing

                Mov     DI, (2+13*80)*2
                Mov     CX, 35

D_DrawLoadInstrument3:
                Push    AX
                Push    CX
                Push    DI

                Cmp     AX, CS:NumInstruments
                JB      D_DrawLoadInstrument4

                Mov     AX, 2A8h
                Add     DI, 58
                StosW
                Add     DI, 24
                StosW

D_DrawLoadInstrument10:
                Add     DI, 20
                StosW

                Jmp     D_DrawLoadInstrument5

D_DrawLoadInstrument4:
                Inc     AX
                Mov     CH, 20h
                Call    PE_ConvAX2Num
                Dec     AX

                Add     DI, 8
                Mov     BX, 48
                Mul     BX
                Mov     SI, AX          ; SI = offset in diskdata..
                                        ; Name first..

                Mov     DL, [SI]
                                                ; DL = type. 0 = unchecked
                                                ;            1 = directory
                                                ;            2 = unknown
                                                ;            3 = ITI.
                Mov     AH, 6
                Cmp     DL, 1
                JB      D_DrawLoadInstrument6

                Mov     AH, 5
                JE      D_DrawLoadInstrument6

                Mov     AH, 7
                Cmp     DL, 2
                JE      D_DrawLoadInstrument6

                Mov     AH, 3

D_DrawLoadInstrument6:
                Mov     DH, AH                  ; DH = col.
                Mov     CX, 25                  ; Instrument Name
                Add     SI, 15

D_DrawLoadInstrument7:
                LodsB

                Cmp     AL, 226
                JB      D_DrawLoadInstrumentCharFilter

                Mov     AL, ' '

D_DrawLoadInstrumentCharFilter:
                StosW
                Loop    D_DrawLoadInstrument7

                Mov     AX, 2A8h
                StosW                           ; Divider 1.

                Mov     AH, DH
                                                ; File name...
                Sub     SI, 39
                Mov     CX, 12

D_DrawLoadInstrument8:
                LodsB
                StosW
                And     AL, AL
                LoopNZ  D_DrawLoadInstrument8

                Add     DI, CX
                Add     DI, CX

                Mov     AX, 2A8h
                StosW                           ; Divider 2.

                Cmp     DL, 3
                JB      D_DrawLoadInstrument10

                LEA     SI, [ESI+ECX+27]
                LodsW                           ; AX = number of samples.

                Push    DS
                Push    SI
                Push    DI
                Push    AX

                Cmp     Byte Ptr [SI-42], 8

                Push    CS
                Pop     DS

                Mov     SI, Offset InstrumentLibrary
                JAE     D_DrawLoadInstrument9

                Mov     SI, Offset InstrumentNoSample
                Cmp     AX, 1
                JB      D_DrawLoadInstrument9

                Mov     SI, Offset InstrumentSingleSample
                JE      D_DrawLoadInstrument9

                Mov     SI, Offset InstrumentSeveralSamples
                Cmp     AX, 0FFFFh
                JNE     D_DrawLoadInstrument9

                Mov     SI, Offset InstrumentUnknownSamples

D_DrawLoadInstrument9:
                Mov     AH, DH
                Call    S_DrawString

                Pop     AX
                Pop     DI
                Pop     SI
                Pop     DS

                Mov     AX, 2A8h
                Add     DI, 20
                StosW                   ; Divider.. now file size...

                LodsW                   ; AX = file size.

                Push    DS

                Push    CS
                Pop     DS
                Mov     SI, Offset FileSizeMsg

                Push    AX
                Mov     AH, DH
                Call    S_DrawString

                Pop     AX

                Pop     DS

D_DrawLoadInstrument5:
                Pop     DI
                Pop     CX
                Pop     AX

                Inc     AX

                Add     DI, 160
                Loop    D_DrawLoadInstrument3

                Push    CS
                Pop     DS
                Jmp     D_DrawLoadInstrumentEnd2

D_DrawLoadInstrumentEnd:
                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     DI, (6+13*80)*2                 ; (6, 13)
                Mov     SI, Offset NoFilesMsg

                Mov     AH, 5
                Call    S_DrawString

D_DrawLoadInstrumentEnd2:                       ; Put Unused Sample msg.
                Mov     AX, UnusedSamples
                Push    AX

                Mov     SI, Offset FreeSampleMsg
                Mov     DI, (64+13*80)*2
                Mov     AH, 20h

                Call    S_DrawString

                Pop     AX

                Ret

EndP            D_DrawLoadInstrument
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_PreLoadInstrument Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     AX, CurrentInstrument
                Sub     AX, TopInstrument
                Add     AX, 13
                Mov     BX, 160
                Mul     BX

                Call    S_GetDestination

                LEA     DI, [EAX+12]
                Mov     CX, 56

D_PreLoadInstrument1:
                Mov     AX, [ES:DI]

                Mov     AH, 32h

                Cmp     AL, 0A8h
                JE      D_PreLoadInstrument3

D_PreLoadInstrument2:
                Mov     AH, 30h

D_PreLoadInstrument3:
                StosW

                Loop    D_PreLoadInstrument1

                Ret

                Ret

EndP            D_PreLoadInstrument

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_PostLoadInstrument Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset LoadInstrumentKeys
                Call    M_FunctionDivider
                JC      D_PostLoadInstrument1

                Jmp     [SI]

D_PostLoadInstrument1:
                Xor     AX, AX
                Ret

EndP            D_PostLoadInstrument

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_ViewInstrument Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset ViewInstrumentKeys
                Call    M_FunctionDivider
                JC      D_ViewInstrument1

                Jmp     [SI]

D_ViewInstrument1:
                Xor     AX, AX
                Ret

EndP            D_ViewInstrument

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LIWindow_Up  Far

                Assume  DS:Disk

                Mov     AX, CurrentInstrument
                And     AX, AX
                JZ      LIWindow_Up1

                Dec     CurrentInstrument

LIWindow_Up1:
                Mov     AX, 1
                Ret

EndP            LIWindow_Up
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LIWindow_Down  Far

                Assume  DS:Disk

                Mov     AX, CurrentInstrument

                Inc     AX
                Cmp     AX, NumInstruments
                JAE     LIWindow_Down1

                Mov     CurrentInstrument, AX

LIWindow_Down1:
                Mov     AX, 1
                Ret

EndP            LIWindow_Down
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LIWindow_PgUp   Far

                Assume  DS:Disk

                Mov     AX, CurrentInstrument

                Sub     AX, 35
                JC      LIWindow_Home

                Mov     CurrentInstrument, AX

LIWindow_PgUp1:
                Mov     AX, 1
                Ret

EndP            LIWindow_PgUp
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LIWindow_PgDn   Far

                Assume  DS:Disk

                Mov     AX, CurrentInstrument

                Add     AX, 35
                Cmp     AX, NumInstruments
                JAE     LIWindow_End

                Mov     CurrentInstrument, AX

LIWindow_PgDn1:
                Mov     AX, 1
                Ret

EndP            LIWindow_PgDn
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LIWindow_Home   Far

                Assume  DS:Disk
                Mov     CurrentInstrument, 0

                Mov     AX, 1
                Ret

EndP            LIWindow_Home
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LIWindow_End    Far

                Assume  DS:Disk

                Mov     AX, NumInstruments

                Dec     AX
                JS      LIWindow_End1

                Mov     CurrentInstrument, AX

LIWindow_End1:
                Mov     AX, 1
                Ret

EndP            LIWindow_End
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LIViewWindow_Tab Far

                Mov     Word Ptr [ES:DI], 7

                Mov     AX, 1
                Ret

EndP            LIViewWindow_Tab

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

include it_d_ri.inc

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LIViewWindow_Enter  Far

                Assume  DS:Disk

                Cmp     NumInstruments, 0
                JE      LIViewWindow_Enter2

                Mov     AX, 48
                Mul     CurrentInstrument
                Mov     SI, AX
                        Assume DS:Nothing

                Mov     DS, DiskDataArea
                Mov     DL, [DS:SI]
                Cmp     DL, 1
                JE      LIViewWindow_Enter1
                Cmp     DL, 8
                JAE     LIWindow_InInstrument1

LIViewWindow_Enter2:
                Mov     AX, 1
                Ret

EndP            LIViewWindow_Enter
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LIWindow_Enter  Far

                Assume  DS:Disk

                Cmp     NumInstruments, 0
                JE      LIWindow_Enter4

                Mov     AX, 48
                Mul     CurrentInstrument
                Mov     SI, AX
                        Assume DS:Nothing

                Mov     DS, DiskDataArea
                Mov     DL, [DS:SI]
                Cmp     DL, 1
                JNE     LIWindow_Enter1

LIViewWindow_Enter1:
                Push    DS
                Push    SI

                Push    CS
                Pop     DS
                Mov     SI, Offset InstrumentDirectory
                Call    D_SetDriveDirectory

                Pop     SI
                Pop     DS

                Inc     SI
                Call    D_SetDriveDirectory

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset InstrumentDirectory
                Call    D_GetDriveDirectory

LIWindow_EnterInModuleError:
                Mov     InstrumentsInModule, 0
                Call    D_InitLoadInstruments
                        Assume DS:Nothing

                Mov     CS:CurrentInstrument, 0

LIWindow_Enter4:
                Mov     AX, 1
                Ret

LIWindow_Enter1:                                ; Load sample into sample list.
                Cmp     DL, 8
                JAE     LIWindow_InInstrument1
                Cmp     DL, 3
                JAE     LIWindow_Enter2

                Xor     AX, AX
                Ret

LIWindow_InInstrument1:
                Mov     CS:InInstrumentFormat, DL

                Inc     SI
                                                ; Copy module name across
                Push    CS
                Pop     ES
                Mov     DI, Offset InInstrumentFileName
                Mov     CX, 13
                Rep     MovsB
                                                ; Open file
                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     CurrentInstrument, 0

LIWindow_EnterLoadInInstrumentData:
                Mov     DX, Offset InInstrumentFileName
                Mov     AX, 3D00h
                Int     21h
                JC      LIWindow_EnterInModuleError

                Mov     BX, AX

                Mov     SI, Word Ptr InInstrumentFormat
                And     SI, 0FFh
                Add     SI, SI

                Mov     NumInstruments, 1

                Mov     DS, DiskDataArea
                        Assume DS:Nothing

                Push    DS
                Pop     ES

                Call    [CS:InstrumentLoaderTable+SI-6]

                        ; Close module
                Mov     AH, 3Eh
                Int     21h

                                ; Setup first 'directory'

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Xor     DI, DI
                Mov     SI, Offset ExitInstrumentLibraryDirectory
                Mov     CX, 48
                Rep     MovsB

                Mov     InstrumentCacheFileComplete, 1
                Mov     InstrumentsInModule, 1

                Mov     AX, NumInstruments
                Mov     LoadInstrumentNameCount, AX

                Mov     AX, 1
                Ret
                        Assume DS:Nothing

LIWindow_Enter2:
                Mov     EAX, [SI+44]
                Mov     CS:LoadInstrumentOffset, EAX
                Mov     AX, [SI+40]
                Mov     CS:NumInstrumentSamples, AX

                And     DX, 0FFh
                Sub     DX, 3
                Add     DX, DX
                Mov     BX, DX
                Mov     AX, [CS:InstrumentLoaderTable+BX]
                Mov     [CS:InstrumentLoader], AX

                Mov     AX, [SI+40]
                Cmp     AX, UnusedSamples
                JBE     LIWindow_Enter5

                Mov     CX, 0FFFFh
                Mov     DI, Offset O1_OutOfSamplesList
                Call    M_Object1List
                Jmp     LIWindow_Enter4

LIWindow_Enter5:                        ; OK.. enough 'sample space'..
                Call    Music_Stop

                                        ; Clean out all old samples...
                                        ; 1. Clean out table
                                        ; 2. Set all samples used in inst to 1
                                        ; 3. Step through all insts and set
                                        ;    samples to 0
                                        ; 4. Delete all samples with 1.
                Push    CS      ; Step 1.
                Pop     ES
                Mov     DI, Offset InstrumentTable
                Mov     CX, 50
                Xor     AX, AX
                Rep     StosW   ; Step 1. Done.

                Push    DS
                Push    SI

                Call    Music_GetSongSegment
                Mov     DS, AX
                        Assume DS:Nothing


                Call    PE_GetLastInstrument
                Mov     DX, BX                  ; DX = instrument, 0 based
                Add     BX, BX
                Mov     SI, [DS:64712+BX]
                Add     SI, 40h
                Mov     CX, 120

ClearSamples1:
                LodsW                           ; AH = sample. AL = note
                Mov     BL, AH
                Mov     [CS:InstrumentTable+BX], 1
                Loop    Clearsamples1

                Xor     BX, BX

ClearSamples2:
                Cmp     BX, DX
                JE      ClearSamples3

                Mov     SI, BX
                Add     SI, SI
                Mov     SI, [DS:64712+SI]
                Add     SI, 41h
                Mov     CX, 120

ClearSamples4:
                LodsW
                And     AX, 0FFh
                Mov     DI, AX
                Mov     [CS:InstrumentTable+DI], 0
                Loop    ClearSamples4

ClearSamples3:
                Inc     BX
                Cmp     BL, 99
                JB      ClearSamples2

                Xor     DI, DI

ClearSamples5:
                Cmp     [CS:InstrumentTable+DI+1], 0
                JE      ClearSamples6

                Mov     AX, DI
                Call    Music_ReleaseSample

ClearSamples6:
                Inc     DI
                Cmp     DI, 99
                JB      ClearSamples5

                Pop     DX
                Pop     DS
                                        ; Process.
                                        ; 1. Reset instrument-sample table.
                                        ; 2. Read all sample headers into mem.
                                        ; 3. Load each sample/sample header.
                                        ; 4. Store instrument header.

                Push    CS      ; Step 1.
                Pop     ES
                Mov     DI, Offset InstrumentTable
                Mov     CX, 50
                Xor     AX, AX
                Rep     StosW   ; Step 1. Done.

                                        ; OK. to do step 2.
                                        ; a) Open file.
                                        ; b) if error.. skip!
                                        ; c) Load file.

                Inc     DX
                Mov     AX, 3D00h       ; Open file..
;                Mov     DX, SI
;                Inc     DX              ; DS:DX points to file name
                Int     21h

                JNC     LIWindow_Enter6

                Mov     AX, 1
                Ret

LIWindow_Enter6:
                Mov     BX, AX          ; BX = file handle.

                                        ; Load instrument data into DS:64000
                                        ; Step 3. Go through each sample.
                Call    [CS:InstrumentLoader]

                Call    Music_GetSongSegment
                Mov     ES, AX

                Mov     CL, [DS:64000+1Eh]
                And     CX, 0FFh
                JZ      LIWindow_Enter10

                Push    CX

                Mov     DI, [ES:64912]
                Add     DI, 12h-80
                Xor     SI, SI
                Xor     AX, AX

LIWindow_Enter8:                        ; Figure out instrument translation
                                        ; table first.
                Inc     AX
                Add     DI, 80
                Test    Byte Ptr [ES:DI], 1     ; Sample present?
                JNZ     LIWindow_Enter8

                Inc     SI
                Mov     [CS:InstrumentTable+SI], AL

                Loop    LIWindow_Enter8

                Pop     CX

                Xor     SI, SI          ; SI = pointer to first sample.
                Mov     DI, 1           ; DI = untranslated sample number.

LIWindow_Enter9:
                Push    CX              ; Have to load EACH sample...
                Push    DS
                Push    SI
                Push    ES
                Push    DI

                Mov     DL, [CS:InstrumentTable+DI]
                Xor     DH, DH          ; DX = translated sample number.
                Dec     DX

                Mov     DI, DX
                Add     DI, DI          ; DI = 2*samplenumber
                Mov     DI, [ES:64912+DI]     ; ES:DI points to sample in mem.

                Mov     CX, 48h/2
                Rep     MovsW
                Xor     AX, AX
                StosW                   ; Sample pointer data.
                StosW
                Add     SI, 4
                MovsW
                MovsW                   ; OK.. sample header transferred..
                                        ; Need to load sample data??
                Mov     Word Ptr [ES:DI-80+2Eh], 1

IF NETWORKENABLED
                Mov     AL, NETWORK_SAMPLEHEADEROBJECT
                Mov     AH, DL
                Call    Network_AddWordToQueue
ENDIF
                Test    Byte Ptr [SI-80+12h], 1
                JZ      LIWindow_Enter11        ; No!

                Push    DX
                Push    DX

                Mov     AX, 4200h
                Mov     CX, [SI-80+4Ah]
                Mov     DX, [SI-80+48h]
                Int     21h                     ; Move pointer...

                Pop     AX
                Sub     SI, 80
                Call    PE_SaveCurrentPattern
                Call    D_LoadSampleData
                Call    PE_RestoreCurrentPattern

                Pop     CX

IF NETWORKENABLED
                Xor     DX, DX
                Call    Network_QueueSampleData
;                Mov     AL, NETWORK_SAMPLEHEADEROBJECT
;                Mov     AH, DL
;                Call    Network_AddWordToQueue
ENDIF


                Jmp     LIWindow_Enter11

LIWindow_Enter12:
                Call    PEFunction_OutOfMemoryMessage

LIWindow_Enter11:
                Pop     DI
                Pop     ES
                Pop     SI
                Pop     DS
                Pop     CX

                Inc     DI
                Add     SI, 80

                Loop    LIWindow_Enter9

LIWindow_Enter10:                       ; Now to copy instrument...
                Mov     AH, 3Eh
                Int     21h             ; Close file first.

                Call    I_GetInstrumentOffset
                                        ; DS:BX points to instrument
                                        ; DS:64000 points to loaded instrument
                                        ; so copy everything, but update the
                                        ; sample numbers..
                Mov     DI, BX
                Push    DS
                Pop     ES

                Mov     DS, CS:DiskDataArea


                Mov     SI, 64000
                Mov     CX, 40h/2
                Rep     MovsW

                Mov     CX, 120
                Xor     BX, BX

LIWindow_Enter7:
                MovsB                   ; Note transferred.
                LodsB
                Mov     BL, AL
                Mov     AL, [CS:InstrumentTable+BX]
                StosB
                Loop    LIWindow_Enter7

                Mov     CX, 250/2
                Rep     MovsW

                Call    Music_SoundCardLoadAllSamples

                Call    Music_GetInstrumentMode
                JNZ     LIWindow_Enter13

                Mov     CX, 3
                Mov     DI, Offset O1_EnableInstrumentMode
                Call    M_Object1List
                Test    DX, DX

                JZ      LIWindow_Enter13

                Call    Music_GetSongSegment
                Mov     DS, AX
                Or      Byte Ptr [DS:2Ch], 4

IF NETWORKENABLED
                Mov     CX, 1
                Mov     DX, 2Ch
                Call    Network_SendSongDataInformation
ENDIF

LIWindow_Enter13:
                NetworkSendInstrument
                Jmp     Glbl_F4

EndP            LIWindow_Enter
                Assume  DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_DeleteInstrumentFile Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Cmp     NumInstruments, 0
                JE      D_DeleteInstrumentFile1
                Cmp     InstrumentsInModule, 0
                JNE     D_DeleteInstrumentFile1

                Mov     AX, 48
                Mul     CurrentInstrument
                Mov     SI, AX
                Mov     DS, DiskDataArea
                        Assume DS:Nothing
                Cmp     Byte Ptr [DS:SI], 1
                JBE     D_DeleteInstrumentFile1         ; Don't delete dirs!
                Cmp     Byte Ptr [DS:SI], 8
                JAE     D_DeleteInstrumentFile1

                Push    DS
                Push    SI

                Mov     DI, Offset O1_ConfirmDelete3
                Mov     CX, 4
                Call    M_Object1List

                Pop     SI
                Pop     DS

                And     DX, DX                  ; OK to delete?
                JZ      D_DeleteInstrumentFile1

                                                ; Delete file....
                Mov     DX, SI
                Inc     DX
                Mov     AH, 41h
                Int     21h
                JC      D_DeleteInstrumentFile1

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     DI, SI
                Add     SI, 48

                Mov     CX, NumInstruments
                Mov     BX, CurrentInstrument
                Sub     CX, BX

                Mov     AX, 48
                Mul     CX
                Mov     CX, AX

                Push    DS

                Mov     DS, DiskDataArea
                Push    DS
                Pop     ES

                Rep     MovsB

                Pop     DS

                Dec     NumInstruments
                JZ      D_DeleteInstrumentFile2

                Cmp     BX, NumInstruments
                JB      D_DeleteInstrumentFile2

                Mov     BX, NumInstruments
                Dec     BX
                Mov     CurrentInstrument, BX
                Dec     LoadInstrumentNameCount

D_DeleteInstrumentFile2:
                Cmp     InstrumentCacheFileComplete, 1
                JNE     D_DeleteInstrumentFile1

                Call    D_SaveInstrumentCacheFile

D_DeleteInstrumentFile1:
                Mov     AX, 1
                Ret

EndP            D_DeleteInstrumentFile
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_GetPreShellDirectory Far

                Push    CS
                Pop     DS
                Mov     SI, Offset PreShellDirectory

                Call    D_GetDriveDirectory

                Mov     SI, Offset DOSDirectory
                Call    D_SetDriveDirectory


                Ret

EndP            D_GetPreShellDirectory

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_RestorePreShellDirectory Far

                Push    CS
                Pop     DS
                Mov     SI, Offset PreShellDirectory

                Call    D_SetDriveDirectory

                Ret

EndP            D_RestorePreShellDirectory

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SetDriveDirectoryFar Far

                Call    D_SetDriveDirectory
                Ret

EndP            D_SetDriveDirectoryFar

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_GetFileName Far

                Push    CS
                Pop     DS
                Mov     SI, Offset FileName

                Ret

EndP            D_GetFileName

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_ResetTimer Far

                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Call    GetTimerCounter
                Mov     [EditTimer], EAX
                Call    ReleaseTimerData

                Call    CheckTimerData

                Pop     DS
                Ret

EndP            D_ResetTimer
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Hours                   DB      "0000:"
Minutes                 DB      "00:"
Seconds                 DB      "00", 0

RemainingDateMsg        DB      " ", 0FDh, "D, ", 0FDh, "D", 0

Time2Msg                DB      0FDh, "D:00", 0
TotalTime               DD      0

Proc            D_ShowTime Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     EDX, 3600
                Mul     EDX
                ShRD    EAX, EDX, 16
                ShR     EDX, 16
                JNZ     D_ShowTimeEnd
                                        ; EAX = number of seconds
                Mov     EBX, 60
                Div     EBX             ; EAX = minutes, EDX = seconds

                Push    EDX
                Xor     EDX, EDX
                Div     EBX             ; EAX = hours, EDX = minutes

                Pop     ECX
                Push    AX              ; Hours on stack, CX = seconds, DX = min
                Mov     BL, 10

                Mov     AX, DX
                Div     BL
                Add     AX, 3030h
                Mov     [Word Ptr Minutes], AX

                Mov     AX, CX
                Div     BL
                Add     AX, 3030h
                Mov     [Word Ptr Seconds], AX

                Pop     AX              ; AX = hours.
                Cmp     AH, BL
                JAE     D_ShowTimeEnd

                Div     BL
                Add     AH, '0'
                Mov     [Byte Ptr Hours+3], AH
                Xor     AH, AH

                Div     BL
                Add     AH, '0'
                Mov     [Byte Ptr Hours+2], AH
                Xor     AH, AH

                Div     BL
                Add     AH, '0'
                Mov     [Byte Ptr Hours+1], AH
                Xor     AH, AH

                Div     BL
                Add     AH, '0'
                Mov     [Byte Ptr Hours+0], AH
                Xor     AH, AH

                Xor     BX, BX
                Mov     SI, Offset Hours

D_ShowTime1:
                Cmp     Byte Ptr [SI+BX], '0'
                JNE     D_ShowTime2
                Mov     Byte Ptr [SI+BX], ' '
                Inc     BX
                Cmp     BX, 3
                JB      D_ShowTime1

D_ShowTime2:
                Mov     AH, 20h
                Call    S_DrawString

D_ShowTimeEnd:
                Ret

EndP            D_ShowTime
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

IF TIMERSCREEN

TimerListKeys           Label

                        DB      0
                        DW      1C8h            ; Up arrow
                        DW      D_TimerListUp

                        DB      0
                        DW      1D0h            ; Down arrow
                        DW      D_TimerListDown

                        DB      0
                        DW      1C9h            ; PgUp
                        DW      D_TimerListPgUp

                        DB      0
                        DW      1D1h            ; PgDn
                        DW      D_TimerListPgDn

                        DB      0
                        DW      0D29h           ; Left Ctrl, Right Shift + '`'
                        DW      D_ReleaseTimer

                        DB      0
                        DW      4529h
                        DW      D_ToggleShowTimes

                        DB      0FFh

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_PostTimerList Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset TimerListKeys
                Call    M_FunctionDivider
                JC      D_PostTimerList1

                Jmp     [SI]

D_PostTimerList1:
                Xor     AX, AX

                Ret

EndP            D_PostTimerList

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_TimerListUp Far
                Assume DS:Disk

                Sub     TopTimerData, 1
                AdC     TopTimerData, 0

                Mov     AX, 1
                Ret

EndP            D_TimerListUp
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_TimerListDown Far
                Assume DS:Disk

                Mov     AX, TopTimerData
                Cmp     AX, NumTimerData
                JAE     D_TimerListDown1

                Inc     AX
                Mov     TopTimerData, AX

D_TimerListDown1:
                Mov     AX, 1
                Ret

EndP            D_TimerListDown
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_TimerListPgUp Far
                Assume DS:Disk

                Sub     TopTimerData, 28
                JNC     D_TimerListPgUp1

                Mov     TopTimerData, 0

D_TimerListPgUp1:
                Mov     AX, 1
                Ret

EndP            D_TimerListPgUp
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_TimerListPgDn Far
                Assume DS:Disk

                Mov     AX, TopTimerData
                Add     AX, 28
                Cmp     AX, NumTimerData
                JB      D_TimerListPgDn1

                Mov     AX, NumTimerData
                Sub     AX, 1
                AdC     AX, 0

D_TimerListPgDn1:
                Mov     TopTimerData, AX

                Mov     AX, 1
                Ret

EndP            D_TimerListPgDn
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ShowTimes       DB      0

Proc            D_DrawTimer Far

                Call    Music_GetSongSegment
                Mov     ES, AX

                Mov     EAX, [ES:3Ch]
                Mov     DI, (18+13*80)*2
                Call    D_ShowTime

                Call    GetTimerCounter
                Sub     EAX, [CS:EditTimer]
                Mov     DI, (18+14*80)*2
                Push    EAX
                Call    D_ShowTime

                Pop     EAX
                Mov     DI, (18+16*80)*2
                Add     EAX, [ES:3Ch]
                Call    D_ShowTime

                Test    ShowTimes, 1
                JZ      D_DrawTimerEnd

                Assume DS:Disk

                Mov     CX, 28
                Mov     SI, TopTimerData
                Mov     AX, TimerData
                Test    AX, AX
                JZ      D_DrawTimerEnd
                Mov     ES, AX
                Mov     AX, SI
                ShL     SI, 3
                Mov     DI, (4+20*80)*2

                Mov     BX, 4
                Mov     TotalTime, 0

D_DrawTimer2:
                Cmp     BX, SI
                JA      D_DrawTimer1

                Mov     EDX, [ES:BX]
                Add     TotalTime, EDX
                Add     BX, 8
                Jmp     D_DrawTimer2

D_DrawTimer1:
                Cmp     AX, NumTimerData
                JAE     D_DrawTimerEnd
                PushA
                                        ; Data formats:      yyyyyyym mmmddddd
                                        ;                    hhhhhmmm mmmsssss
                SegES   LodsD

                Push    SI
                Push    DI
                                        ; AX = yyyyyyym mmmddddd
                Mov     BX, AX
                ShR     AX, 9
                Add     AX, 1980
                Push    AX              ; Year
                Mov     AX, BX
                And     AX, 1Fh
                Push    AX

                ShR     BX, 5
                And     BX, 0Fh
                Add     BX, BX

                Mov     SI, [MonthNames+BX]
                Mov     AH, 20h
                Call    S_DrawString

                Mov     SI, Offset RemainingDateMsg
                Call    S_DrawString

                Pop     AX              ; Clean up stack
                Pop     AX

                Pop     DI
                Add     DI, 50
                Push    DI

                                        ; time
                ShR     EAX, 21         ; AX =  hhh hhmmmmmm
                Mov     BX, AX
                ShR     BX, 6
                Push    BX
                Mov     BL, 10
                And     AX, 3Fh
                Div     BL
                Add     AX, '00'
                Mov     Word Ptr [Time2Msg+3], AX       ; Minutes done.

                Mov     SI, Offset Time2Msg
                Mov     AH, 20h
                Call    S_DrawString
                Pop     AX

                Pop     DI
                Pop     SI

                Add     DI, 30
                SegES   LodSD
                Add     TotalTime, EAX
                Call    D_ShowTime

                Add     DI, 20

                Mov     EAX, TotalTime
                Call    D_ShowTime

                PopA
                Add     SI, 8
                Add     DI, 160
                Inc     AX
                Loop    D_DrawTimer1

D_DrawTimerEnd:
                Xor     AX, AX
                Ret

EndP            D_DrawTimer

ENDIF

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_ReleaseTimer Far

                Call    ReleaseTimerData
                Inc     AX
                Ret

EndP            D_ReleaseTimer

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

IF TIMERSCREEN

Proc            D_ToggleShowTimes Far
                Assume DS:Disk

                Xor     ShowTimes, 1

                Mov     AX, 1
                Ret

EndP            D_ToggleShowTimes
                Assume DS:Nothing

ENDIF

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SlowSampleSort Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

IF SORTENABLED
                Cmp     SamplesInModule, 1
                JE      D_SlowSampleSortExit
                Cmp     SampleCacheFileComplete, 1
                JNE     D_SlowSampleSortExit
                Mov     CX, NumSamples

                Mov     SampleInMemory, 0FFFFh
                Mov     SampleCheck, 0FFFFh

                Mov     ES, DiskDataArea
                Push    ES
                Pop     DS
                        Assume DS:Nothing

                Xor     SI, SI

                Cmp     Word Ptr [SI+4], '\'
                JNE     SlowSampleSortNoSort1

                Add     SI, 60h
                Dec     CX

SlowSampleSortNoSort1:
                Cmp     Word Ptr [SI+4], '..'
                JNE     SlowSampleSortNoSort2

                Add     SI, 60h
                Dec     CX

SlowSampleSortNoSort2:
                Cmp     CX, 0
                JLE     D_SlowSampleSortExit

SlowSampleSortLoop1:
                Push    CX
                Push    SI

                Mov     AL, [SI+5Ah]
                Mov     DX, SI          ; DX = destination of SI
                Mov     DI, SI
                Mov     BX, CX

SlowSampleSortLoop2:

; SI = current lowest.

; Sort priority: 0 = directory
;                1 = library
;                2 = recognised
;                3 = unknown

                Cmp     AL, [DI+5Ah]
                JB      D_CompareSamples2
                JA      D_CompareSamples1

                Push    SI
                Push    DI

                Mov     CX, 13
                Add     SI, 4
                Add     DI, 4
                RepE    CmpSB
                Pop     DI
                Pop     SI

                JBE     D_CompareSamples2

D_CompareSamples1:
                Mov     AL, [DI+5Ah]
                Mov     SI, DI

D_CompareSamples2:
                Add     DI, 60h

                Dec     BX
                JNZ     SlowSampleSortLoop2

                Cmp     SI, DX
                JE      D_CompareSamplesNoSwap


                Push    DI
                Mov     CX, 24
                Rep     MovsD

                LEA     DI, [SI-60h]
                Mov     SI, DX
                Mov     CX, 24
                Rep     MovsD

                Pop     SI
                Mov     DI, DX
                Mov     CX, 24
                Rep     MovsD

D_CompareSamplesNoSwap:
                Pop     SI
                Pop     CX

                Add     SI, 60h

                Dec     CX
                JNZ     SlowSampleSortLoop1

                Call    D_SaveSampleCacheFile   ; Resave it with new date

D_SlowSampleSortExit:

ENDIF

                Mov     AX, 1
                Ret

EndP            D_SlowSampleSort

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_SlowInstrumentSort Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

IF SORTENABLED
                Cmp     InstrumentsInModule, 1
                JE      D_SlowInstrumentSortExit
                Cmp     InstrumentCacheFileComplete, 1
                JNE     D_SlowInstrumentSortExit
                Mov     CX, NumInstruments

                Mov     ES, DiskDataArea
                Push    ES
                Pop     DS
                        Assume DS:Nothing

                Xor     SI, SI

                Cmp     Word Ptr [SI+1], '\'
                JNE     SlowInstrumentSortNoSort1

                Add     SI, 30h
                Dec     CX

SlowInstrumentSortNoSort1:
                Cmp     Word Ptr [SI+1], '..'
                JNE     SlowInstrumentSortNoSort2

                Add     SI, 30h
                Dec     CX

SlowInstrumentSortNoSort2:
                Cmp     CX, 0
                JLE     D_SlowInstrumentSortExit

SlowInstrumentSortLoop1:
                Push    CX
                Push    SI

                Mov     AL, [SI]
                Mov     DX, SI          ; DX = destination of SI
                Mov     DI, SI
                Mov     BX, CX

SlowInstrumentSortLoop2:
                Mov     AH, [DI]

; SI = current lowest.

                Cmp     AL, 1
                JNE     SlowInstrumentSort3
                Cmp     AH, 1
                JE      SlowInstrumentFilename
                Jmp     D_CompareInstruments2

SlowInstrumentsort3:
                Cmp     AH, 1
                JE      D_CompareInstruments1

                Test    AL, 8
                JZ      SlowInstrumentSort4
                Test    AH, 8
                JNZ     SlowInstrumentFileName
                Jmp     D_CompareInstruments2

SlowInstrumentsort4:
                Test    AH, 8
                JNZ     D_CompareInstruments1

SlowInstrumentFilename:
                Push    SI
                Push    DI

                Mov     CX, 13
                Inc     SI
                Inc     DI
                RepE    CmpSB
                Pop     DI
                Pop     SI

                JBE     D_CompareInstruments2

D_CompareInstruments1:
                Mov     AL, AH
                Mov     SI, DI

D_CompareInstruments2:
                Add     DI, 30h

                Dec     BX
                JNZ     SlowInstrumentSortLoop2

                Cmp     SI, DX
                JE      D_CompareInstrumentsNoSwap

                Push    DI
                Mov     CX, 12
                Rep     MovsD

                LEA     DI, [SI-30h]
                Mov     SI, DX
                Mov     CX, 12
                Rep     MovsD

                Pop     SI
                Mov     DI, DX
                Mov     CX, 12
                Rep     MovsD

D_CompareInstrumentsNoSwap:
                Pop     SI
                Pop     CX

                Add     SI, 30h

                Dec     CX
                JNZ     SlowInstrumentSortLoop1

                Call    D_SaveInstrumentCacheFile   ; Resave it with new date

D_SlowInstrumentSortExit:

ENDIF

                Mov     AX, 1
                Ret

EndP            D_SlowInstrumentSort

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment         DiskData PARA Public 'Data'
        DB      65536 Dup (0)
EndS

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

EndS

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

End
