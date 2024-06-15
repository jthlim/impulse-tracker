
;
; MID File generator
;

REPEATSTATUSBYTE        EQU     0

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

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

include wavswitc.inc

FileHandle      DW      0

MIDOutputMsg    DB      "MIDI File Generator", 13
                DB      "Writing to disk", 0
MIDOutputError  DB      "Unable to create output file!", 0FFh, 29, " ", 0
WriteErrorMsg   DB      "Error writing to output file. Output file closed", 0FFh, 11, " ", 0
ClosedMsg       DB      "Closed output file", 0FFh, 42, " ", 0
CreateMsg       DB      "Creating file "
Filename        DB      "                                               ", 0
OUTPUT          DB      "OUTPUT"
DriverName      DB      "ITMID.DRV", 0

CONFIGURATIONOFFSET     EQU     $+128
CONFIGSIZE              EQU     80
MIDDirectory    DB      ".", 79 Dup (0)


AccumulatedTime         DD      0
AccumulatedTimeError    DD      0

FrameTime               DD      0
FrameTimeError          DD      0


MIDIHeader              DB      "MThd", 0, 0, 0, 6, 0, 0, 0, 1, 0E7h, 28h
                        DB      "MTrk"
MIDIFileSize            DD      0
                        DB      0, 0FFh, 01, 28
                        DB      "Created with Impulse Tracker"

MTrkEnd                 DB      0, 0FFh, 2Fh, 0

MIDIBuffer              DB      256 Dup (0)
MIDIBufferOffset        DW      Offset MIDIBuffer

MIDScreenList           DW      6
                        DW      IdleFunctionList
                        DW      GlobalKeyLink

                        DW      Near Ptr FullScreenBox  ; 0
                        DW      Near Ptr ScreenHeader
                        DW      Near Ptr FillHeader
                        DW      Near Ptr MIDHeader

                        DW      Near Ptr DirectoryInputText
                        DW      Near Ptr DirectoryInputBox
                        DW      Near Ptr DirectoryInput         ; 6

                        DW      0

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

MIDHeader               DW      10
                        DB      "MIDI File Export Driver", 0

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
                        DW      Offset MIDDirectory
                        DW      59
                        DD      0
                        DW      0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh

TRACEENABLED            EQU     0
CREATENEWLOGFILE        EQU     1
include debug.inc

; 컴 DetectCard 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Returns carry set if error, else carry clear. Has to setup internal vars
; (eg. appropriate IRQ/DMA whatever).
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            DetectCard Far

                Mov     EAX, 'Jeff'

                ClC
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
                Mov     SI, Offset MIDDirectory
                Call    SetDirectory

                Mov     SI, Offset MIDOutputMsg
                ClC
                Ret

EndP            InitSound

;컴 ReInitSound 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Reinitialises sound output
; Initiates sound output
;
; Parameters: AX = number of channels.
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ReInitSound Far

                Ret

EndP            ReInitSound

;컴 UnInitSound 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Stops sound output, releases any memory used by driver
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            CheckFileClosed

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     BX, FileHandle
                Test    BX, BX
                JZ      CheckFileClosedEnd

                Mov     AH, 40h
                Mov     CX, 4
                Mov     DX, Offset MTrkEnd
                Int     21h

                Mov     FileHandle, 0

                Mov     AX, 4200h       ; Move to start of file
                Xor     CX, CX
                Xor     DX, DX
                Int     21h             ; Start of file

                Mov     AX, Word Ptr [MIDIFileSize]
                Mov     DX, Word Ptr [MIDIFileSize+2]
                XChg    AL, DH
                XChg    AH, DL
                Mov     Word Ptr [MIDIFileSize], AX
                Mov     Word Ptr [MIDIFileSize+2], DX

                Mov     AH, 40h
                Mov     CX, 22+32
                Mov     DX, Offset MIDIHeader
                Int     21h

                Mov     AH, 3Eh
                Int     21h

                Mov     SI, Offset ClosedMsg
                Mov     BX, 40
                Call    SetInfoLine

CheckFileClosedEnd:
                Ret

EndP            CheckFileClosed
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            UnInitSound Far

                Call    GotoHomeDirectory

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     AX, 3D02h       ; Read write access
                Mov     DX, Offset DriverName
                Int     21h
                JC      SaveConfig2

                Mov     BX, AX

                Mov     AX, 4200h
                Xor     CX, CX
                Mov     DX, Offset CONFIGURATIONOFFSET
                Int     21h
                JC      SaveConfig1

                Mov     AH, 40h
                Mov     CX, CONFIGSIZE
                Mov     DX, Offset MIDDirectory
                Int     21h

SaveConfig1:
                Mov     AH, 3Eh
                Int     21h

SaveConfig2:
                Call    CheckFileClosed
                Ret

EndP            UnInitSound
                Assume DS:Nothing

;컴 Poll 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;
; This procedure is called as often as possible by IT.EXE
; AX = Playmode (0 for nothing in particular, 1 = pattern, 2 = song)
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            WriteMIDIBlock
                Assume DS:Driver

                Xor     ECX, ECX

                Mov     CX, MIDIBufferOffset
                Mov     DX, Offset MIDIBuffer
                Mov     AH, 40h
                Mov     BX, FileHandle
                Sub     CX, DX
                JZ      NoDataToWrite

                Add     MIDIFileSize, ECX

                Trace   "Writing MIDI block"

                Int     21h

NoDataToWrite:
                Mov     MIDIBufferOffset, Offset MIDIBuffer

                Ret

EndP            WriteMIDIBlock
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            Poll Far
                Assume DS:Nothing

                Mov     CS:Countdown, 0
                Mov     CS:MIDIBufferOffset, Offset MIDIBuffer

                Call    Update          ; Got DS:SI, CX

; Scan through channels and if any channels are samples, turn them off.

TurnOffSamples1:
                Test    Byte Ptr [SI], 1        ; Channel on?
                JZ      TurnOffSamples2

                Mov     Word Ptr [SI], 0

                Test    Byte Ptr [SI+3Ah], 80h
                JNZ     TurnOffSamples2

                Mov     BX, [SI+38h]
                And     Byte Ptr [BX], Not 4    ; Signify channel off

TurnOffSamples2:
                Add     SI, 128
                Loop    TurnOffSamples1

; OK.. check whether any MIDI data requires dumping... also whether file
; needs to be created.

                Test    AX, AX          ; Currently not playing
                JNZ     Poll1

                Call    CheckFileClosed
                Ret

Poll1:
                Push    CS
                Pop     DS
                        Assume DS:Driver

                Cmp     FileHandle, 0
                JNE     Poll2

                Trace   "New file to create"

                Mov     SI, Offset MIDDirectory
                Call    SetDirectory

                Xor     EAX, EAX
                Mov     AccumulatedTime, EAX
                Mov     AccumulatedTimeError, EAX
                Mov     AL, 4+32
                Mov     MIDIFileSize, EAX

; Have to create a file
                Call    GetFileName
                        Assume DS:Nothing       ; Returns DS:SI
                Push    CS
                Pop     ES
                Mov     DI, Offset FileName

                Push    DI

                Mov     CX, 12
                Mov     AL, ' '
                Rep     StosB

                Pop     DI

                Cmp     Byte Ptr [DS:SI], 0
                JE      PollFileNameNone
                Cmp     Byte Ptr [DS:SI], '.'
                JE      PollFileNameNone

                Mov     CX, 8
PollFileName1:
                LodsB
                Cmp     AL, 0
                JE      PollFileNameExt
                Cmp     AL, '.'
                JE      PollFileNameExt
                StosB
                Loop    PollFileName1
                Jmp     PollFileNameExt

PollFileNameNone:
                Push    CS
                Pop     DS
                Mov     SI, Offset Output
                Mov     CX, 6
                Rep     MovsB

PollFileNameExt:
                Mov     EAX, 'DIM.'
                StosD
                Xor     AL, AL
                StosB

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     SI, Offset CreateMsg
                Mov     BX, 40
                Call    SetInfoLine

                Mov     AH, 3Ch
                Xor     CX, CX
                Mov     DX, Offset Filename
                Int     21h
                JC      WriteError

                Mov     BX, AX
                Mov     FileHandle, BX
                Trace   "File opened"

; Write header once
                Mov     AH, 40h
                Mov     CX, 22+32
                Mov     DX, Offset MIDIHeader
                Int     21h
                JC      WriteError

                Trace   "Header written"

Poll2:
                Call    WriteMIDIBlock
                JC      WriteError

; Update time counters
                Mov     EAX, FrameTimeError
                Mov     EBX, FrameTime
                Add     AccumulatedTimeError, EAX
                AdC     AccumulatedTime, EBX

                Ret

WriteError:
                Call    CheckFileClosed
                Mov     SI, Offset WriteErrorMsg
                Mov     BX, 40
                Call    SetInfoLine
                Call    StopPlayback

                Ret

EndP            Poll
                Assume DS:Nothing

;컴 SetTempo 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;
; Parameters: BX = tempo
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetTempo Far    ; Frames per second = 0.4*BX
                                ; -> Milliseconds per frame = 1000/(0.4/BX)
                                ;                           = 2500/BX
                PushAD

                Mov     EAX, 2500
                And     EBX, 0FFFFh
                Xor     EDX, EDX
                Div     EBX     ; EAX = milliseconds

                Mov     CS:FrameTime, EAX
                Mov     CS:FrameTimeError, EDX


                PopAD
                Ret

EndP            SetTempo

;컴 SetMixVolume 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;
; Parameters: AX = MixVolume
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetMixVolume Far

                Ret

EndP            SetMixVolume

;컴 SetStereo 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Parameters: AL = Stereo on/off, 0 = off.
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetStereo Far

                Ret

EndP            SetStereo

;컴 LoadSample 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;
; Parameters: AX = sample to load (0 based)
;             DS:SI points to sample header
;             ES:0 points to first sample
;
; Returns: **Carry set if NO error**
;          **Carry clear if error**
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            LoadSample Far

                StC
                Ret

EndP            LoadSample

;컴 ReleaseSample 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Parameters: AX = sample to release (1 based)
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

                Mov     AX, 5
                Mov     SI, 1
                Mov     CX, CS
                Mov     DX, Offset MIDScreenList

                ClC
                Ret
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

StatusByte      DB      0
CountDown       DB      0

StatusByteLUT   DB      2, 2, 2, 2, 1, 1, 2
InSysex         DW      0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            BufferMIDIOutput

                PushAD
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     BX, InSysex
                Mov     SI, MIDIBufferOffset

                Test    BX, BX
                JZ      BufferMIDINoSysex

                Cmp     AL, 0F7h
                JNE     BufferMIDIOutput1

                Mov     DX, SI
                Sub     DX, BX          ; DX = count of sysex bytes
                Mov     [BX], DL
                Mov     InSysex, 0

                Jmp     BufferMIDIOutput1

BufferMIDINoSysex:
                Cmp     Countdown, 0
                JNE     BufferMIDIOutput1

                Cmp     AL, 0F0h
                JA      BufferMIDIOutput2

; Delta time required

                Xor     EDX, EDX
                Mov     EBX, AccumulatedTime
                Mov     CX, 4
                Mov     AccumulatedTime, EDX

DeltaTimeOutput1:
                ShL     EDX, 8
                Mov     DL, BL
                Or      DL, 80h
                ShR     EBX, 7
                LoopNZ  DeltaTimeOutput1
                                        ; EDX = output bytes, DL = most signif

DeltaTimeOutput2:
                Mov     [SI], DL
                Inc     SI
                ShR     EDX, 8
                JNZ     DeltaTimeOutput2

                And     Byte Ptr [SI-1], 7Fh

                Xor     BX, BX
                Xor     DL, DL
                Test    AL, AL
                JNS     BufferMIDINoStatus
                Cmp     AL, 0F0h
                JE      BufferMIDISysex

                Mov     StatusByte, AL
                Inc     DX
                Jmp     BufferMIDINoStatus

BufferMIDISysex:
                Mov     [SI], AL
                Inc     SI
                Mov     InSysex, SI
                Jmp     BufferMIDIOutput1

BufferMIDINoStatus:
                Mov     BL, StatusByte
                ShR     BX, 4
                Sub     BL, 8
                JC      BufferMIDIOutput1

                Add     DL, [StatusByteLUT+BX]
                Mov     Countdown, DL

BufferMIDIOutput1:
                Mov     [SI], AL
                Inc     SI
                Dec     Countdown

                Mov     MIDIBufferOffset, SI

                Cmp     SI, Offset MIDIBuffer+200
                JB      BufferMIDIOutput2
                Cmp     InSysex, 0
                JNE     BufferMIDIOutput2

                Call    WriteMIDIBlock

BufferMIDIOutput2:
                Pop     DS
                PopAD

                Ret

EndP            BufferMIDIOutput

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

InterpretState  DB      0
InterpretType   DB      0

Proc            SendUARTOut Far ; Local interpreter activated with 0F0h 0F0h.

                Mov     AH, CS:InterpretState
                Cmp     AH, 2
                JB      SendUARTOut1

; In interpreter.
                JE      SendUARTOut3

SendUARTOut4:
                Mov     CS:InterpretState, 0
                Ret

SendUARTOut3:
                Cmp     AL, 2
                JAE     SendUARTOut4

                Mov     CS:InterpretType, AL
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

                Push    AX
                Mov     AL, 0F0h
                Call    BufferMIDIOutput
                Pop     AX
                Mov     CS:InterpretState, 0

SendUARTOutEnd:
                Call    BufferMIDIOutput

                Ret

EndP            SendUARTOut

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

EndDriver:

;********  Provided Variable Table *************

MaxNumberOfChannels     DW      32      ; Maximum number of channels the
                                        ; driver can handle.
StopAfterPlay           DW      1
DefaultChannels         DW      32
DriverFlags             DW      1       ; Supports MIDI Out.

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
