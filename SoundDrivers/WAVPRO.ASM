
        .386P

Segment                 DriverHeader PARA Public 'Code' Use16
                        Assume CS:Driver, DS:Nothing

REGISTERED EQU 1

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

FileID          DW      22      ; 0 = Ozone
                                ; 1 = Andrew Seargant
                                ; 2 = David Goodale
                                ; 3 = Nebula
                                ; 4 = Christian Bode
                                ; 5 = Flatrich
                                ; 6 = MAZ
                                ; 7 = Barthelemy DEFOSSEZ
                                ; 8 = Daedalus
                                ; 9 = Joost
                                ; 10= Yannis
                                ; 11= Mike Marton
                                ; 12= HB
                                ; 13= Catspaw
                                ; 14= Airon
                                ; 15= Mike Blaine
                                ; 16= Jason Tracer
                                ; 17= Akos Matte
                                ; 18= Kristian Sergiejew
                                ; 19= Jonathan Bartlett
                                ; 20= DeltaX
                                ; 21= Zinc
                                ; 22= Draggy

FileHandle      DW      0

LowerLimit      DD      -3.2768E4
UpperLimit      DD      3.2767E4

WAVOutputMsg    DB      "Writing to disk", 13
                DB      "Output frequency ", 0FDh, "D", 0
WAVFileErrorMsg DB      "Unable to create output file!                              ", 0
WAVMemErrorMsg  DB      "Unable to allocate memory!", 0
NoReinitMsg     DB      "File output routines should NOT require reinitialisation   ", 0
WriteError      DB      "Error writing to output file. Output file closed           ", 0


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

IFDEF REGISTERED
  Stereo          DB      0
  StereoSet       DB      0
ENDIF

BytesToMix      DW      0
MixVolume       DW      0
MixSegment      DW      0
MixHandler      DW      Offset M32MixHandler
OldDirectory    DB      80 Dup (0)

CreatingMsg     DB      "Created file "
OutputFileName  DB      "                                               ", 0

ClosedFileMsg   DB      "Closed output file                                         ", 0
OUTPUT          DB      "OUTPUT"

include mix.inc
include wav.mix

; 컴 DetectCard 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Returns carry set if error, else carry clear. Has to setup internal vars
; (eg. appropriate IRQ/DMA whatever).
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            DetectCard Far

                Call    GetEMSPageFrame
                Mov     EMSPageFrame, AX

                Call    SetupRamp

                Mov     EAX, 'Jeff'
                ClC             ; Always assume true
                Ret

EndP            DetectCard

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

                FNINIT

                Mov     AH, 48h
                Mov     BX, 2643        ; (65536 / (.4*31)) * 4 * 2
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

                Push    CS
                Pop     DS
                        Assume DS:Driver

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

Proc            Poll Far

                Cmp     MixSegment, 0
                JNE     Poll2

                Ret

Poll2:
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
IFDEF REGISTERED
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

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     SI, Offset OldDirectory
                Mov     Word Ptr [SI], '.'
                Call    SetDirectory
                Call    GotoHomeDirectory

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

IFDEF REGISTERED
                Mov     CL, Stereo
                Inc     CX
                ShL     EDX, CL

ELSE
                ShL     EDX, 1

ENDIF
                Mov     WAVEBytesPerSecond, EDX

IFDEF   REGISTERED
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
                Call    Update          ; Got DS:SI, CX
                Call    M32MixHandler
                Call    RestoreEMSPageFrame

                                        ; Now reorder everything in mixbuff
                Mov     DS, CS:MixSegment
                Push    DS
                Pop     ES

                Mov     CX, CS:BytesToMix
                Mov     BX, 8

IFDEF REGISTERED
                Cmp     CS:Stereo, 0
                JE      PollNoStereo

                Add     CX, CX
                Mov     BX, 4

ENDIF

PollNoStereo:
                Push    CX

                Xor     SI, SI
                Xor     DI, DI
                Xor     DX, DX

Poll3:
                Mov     EAX, [SI]

                Test    EAX, EAX
                JS      FloatNegative

                Cmp     EAX, UpperLimit
                JL      FloatOK

                Mov     AX, 7FFFh
                Jmp     Poll4

FloatNegative:
                Cmp     EAX, LowerLimit
                JL      FloatOK

                Mov     AX, 8000h
                Jmp     Poll4

FloatOK:
                Fld     DWord Ptr [SI]
                FISt    DWord Ptr [SI]
                Mov     AX, [SI]

Poll4:
                Add     SI, BX
                StosW
                Dec     CX
                JNZ     Poll3

                Pop     CX
                Add     CX, CX

                Mov     AH, 40h                 ; Write
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

EndP            Poll

;컴 SetTempo 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;
; Parameters: AX = tempo
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetTempo Far

                Push    AX
                Push    BX
                Push    DX

                Push    BX

                Mov     AX, CS:MixSpeed
                Mov     BX, AX
                Xor     DX, DX

                ShL     AX, 1
                RCL     DX, 1           ; DX:AX = Mixspeed*2

                ShR     BX, 1           ; BX = Mixspeed/2

                Add     AX, BX
                AdC     DX, 0           ; DX:AX = Mixspeed*2.5

                Pop     BX              ; BX = tempo
                Div     BX

                Mov     CS:BytesToMix, AX

                Pop     DX
                Pop     BX
                Pop     AX

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

IFDEF REGISTERED
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
                Call    GetSampleLocation       ; Returns DS:ESI, ECX = length
                JC      LoadSampleEnd           ; Zero flag ON if 16 bit..

                Mov     AX, 0
                Mov     BL, [FS:BP+12h]
                JNZ     LoadSample1
                                                ; 8 bit

                Test    BL, 10h                 ; Loop
                JZ      LoadSample8_2

                Mov     ESI, [FS:BP+34h]
                Mov     ECX, [FS:BP+38h]

                Test    BL, 40h
                JZ      LoadSample8_1

                Mov     ESI, ECX
                Sub     ESI, 2
                JNC     LoadSample8_1

                Xor     ESI, ESI

LoadSample8_1:
                Call    UpdateSampleLocation
                Mov     AL, [SI]

LoadSample8_2:
                Mov     ESI, ECX
                Call    UpdateSampleLocation
                Mov     [SI], AL
                Jmp     LoadSampleEnd

LoadSample1:                                    ; 16 bit
                Test    BL, 10h                 ; Loop
                JZ      LoadSample16_2

                Mov     ESI, [FS:BP+34h]
                Mov     ECX, [FS:BP+38h]

                Test    BL, 40h
                JZ      LoadSample16_1

                Mov     ESI, ECX
                Sub     ESI, 2
                JNC     LoadSample16_1

                Xor     ESI, ESI

LoadSample16_1:
                Add     ESI, ESI
                Call    UpdateSampleLocation
                Mov     AX, [SI]

LoadSample16_2:
                Mov     ESI, ECX
                Add     ESI, ESI
                Call    UpdateSampleLocation
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

                StC
                Ret

EndP            GetStatus

;컴 SoundCardScreen 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
;  Function to have driver interactive part of program
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SoundCardScreen Far

                Xor     AX, AX
                StC
                Ret

EndP            SoundCardScreen

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            GetVariable Far

                Ret

EndP            GetVariable

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetVariable Far

                Ret

EndP            SetVariable

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

EndDriver:

;********  Provided Variable Table *************

MaxNumberOfChannels     DW      0FFFFh  ; Maximum number of channels the
                                        ; driver can handle.
StopPlaySection         DW      1
DefaultChannels         DW      256
                        DW      5 Dup (0)

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

ProvidedTableEnd:
        DW      32-(ProvidedTableEnd-ProvidedTableStart)/2 Dup (0)

EndS

End
