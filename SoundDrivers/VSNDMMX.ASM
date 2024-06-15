;
; Impulse Tracker VSound Driver
;
;  Client for VSound.VxD to interface with Windows.
;  Output is always 16-bit stereo, 44100Hz.
;
;

STEREOENABLED           EQU     1
MIXRESOLUTION           EQU     32      ; 32 bit mixing
OUTPUTFILTERENABLED     EQU     0
TIMERCONST              EQU     11932   ; 100 times a second
DMABUFFERLENGTH         EQU     0       ; Does not have a DMA buffer in the mixsegment

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

; 컴 Variables 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

FPSave          DB      128 Dup (0)

OldTimerIRQHandler      DD      0
TimerAccumulator        DW      0

VSoundNoMemoryMsg DB    "Impulse Tracker VSound Driver", 13
                  DB    "Error: Insufficient memory", 0
VSoundDriverMsg DB      "Impulse Tracker VSound Driver", 13
                DB      "MMX Accelerated Mixing Engine", 0

NoReinitMsg     DB      "VSound driver should NOT require reinitialisation          ", 0

VSoundIDBuffer  DB      8 Dup (0)
VSoundID        DB      "ITVXDDRV"

DefaultDriverName       DB      "ITVSOUND.DRV"
DriverName              DD      0

Forced                  DB      0
Stereo                  DB      0
MixVolume               DW      0
MixSegment              DW      0

BytesToMix              DW      1000
MixTransferOffset       DW      0
MixTransferRemaining    DW      0
CONFIGURATIONOFFSET     EQU     $+128
CONFIGSIZE              EQU     4
MixMode                 DW      0
MixModeOffset           DW      0

VSoundScreenList        Label
                        DW      6
                        DW      Near Ptr IdleFunctionList
                        DW      Near Ptr GlobalKeyLink

                        DW      Near Ptr FullScreenBox  ; 0
                        DW      Near Ptr ScreenHeader
                        DW      Near Ptr FillHeader
                        DW      Near Ptr VSoundHeaderLine

                        DW      Near Ptr DriverText

                        DW      Near Ptr MixModeText
                        DW      Near Ptr MixModeButton1         ; 6
                        DW      Near Ptr MixModeButton2         ;
                        DW      Near Ptr MixModeButton3         ; 8
                        DW      Near Ptr MixModeButton4         ; 9

                        DW      Near Ptr ServerText
                        DW      Near Ptr FrequencyText

                        DW      0


VSoundHeaderLine        DW      10
                        DB      "Virtual Sound Driver (MMX)", 0

ServerText              DW      1
                        DB      2, 47
                        DB      21h
VSoundString            DB      64 Dup (0)

FrequencyText           DW      1
                        DB      2, 48
                        DB      21h
                        DB      "Playback Frequency: ", 0FDh, "DHz, Buffer Threshold: ", 0FDh, "D bytes", 0
Threshold               DW      21*1024
MixSpeed                DW      44100
                        DW      0

DriverText              DW      1
                        DB      2, 46
                        DB      21h
                        DB      "Virtual Sound Driver (MMX) 1.0 for Impulse Tracker", 0

GlobalKeyLink           DB      7
GlobalKeyLink2          DD      0

IdleFunctionList        DD      0
                        DD      0

FillHeader              DW      8
FillHeader2             DD      0

FullScreenBox           DW      0
                        DB      0, 0, 79, 49
                        DB      4

ScreenHeader            DW      8
ScreenHeader2           DD      0

MixModeText             DW      1
                        DB      2, 14
                        DB      20h
                        DB      "Mixing Mode", 0

MixModeButton1          DW      2
                        DW      0FFFFh, 7, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetMixMode
DriverSegment1          DW      0
                        DW      0
                        DW      Offset SetMixMode
DriverSegment2          DW      0
                        DB      3, 16, 32, 18, 8
                        DB      0
                        DB      "  MMX, Non-Interpolated", 0

MixModeButton2          DW      2
                        DW      6, 8, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetMixMode
DriverSegment3          DW      0
                        DW      1
                        DW      Offset SetMixMode
DriverSegment4          DW      0
                        DB      3, 19, 32, 21, 8
                        DB      0
                        DB      "  MMX, Interpolated", 0

MixModeButton3          DW      2
                        DW      7, 9, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetMixMode
DriverSegment5          DW      0
                        DW      2
                        DW      Offset SetMixMode
DriverSegment6          DW      0
                        DB      3, 22, 32, 24, 8
                        DB      0
                        DB      "  MMX, Volume Ramped", 0

MixModeButton4          DW      2
                        DW      8, 0FFFFh, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetMixMode
DriverSegment7          DW      0
                        DW      3
                        DW      Offset SetMixMode
DriverSegment8          DW      0
                        DB      3, 25, 32, 27, 8
                        DB      0
                        DB      "  MMX, Filtered", 0


; 컴 MixingRoutines 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

MixBufferPos            DW      0

include mix.inc
include mmx.inc

include m32bitm.mix
include m32bitmi.mix
include m32bitmv.mix
include m32bitmf.mix

ALIGN 2

MixFunctionTables       Label

include m32bitm.inc
include m32bitmi.inc
include m32bitmv.inc
include m32bitmf.inc
include mnomix.inc

include nodebug.inc

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

RelocationTable         Label   Word
        DW      Offset DriverSegment1, Offset DriverSegment2
        DW      Offset DriverSegment3, Offset DriverSegment4
        DW      Offset DriverSegment5, Offset DriverSegment6
        DW      Offset DriverSegment7, Offset DriverSegment8
        DW      0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            GetMixMode Far

                Push    CS
                Pop     ES
                Mov     DI, Offset MixMode

                Ret

EndP            GetMixMode

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetMixMode Far

                Mov     AX, [SI+22]

                ClI

                Mov     CS:MixMode, AX

                Mov     BX, 60
                Mul     BX
                Mov     CS:MixModeOffset, AX

                StI

                Mov     AX, 1
                Ret

EndP            SetMixMode
                Assume DS:Nothing


; 컴 DetectCard 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Returns carry set if error, else carry clear. Has to setup internal vars
; (eg. appropriate IRQ/DMA whatever).
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            DetectMMX

                Trace   "Detecting MMX - CPUID Check"

                PushFD
                Pop     EAX
                Mov     EBX, EAX
                Xor     EAX, 00200000h
                Push    EAX
                PopFD
                PushFD
                Pop     EAX
                Cmp     EAX, EBX
                JZ      DetectMMXFail

                Trace   "CPUID - Check OK"

                Mov     EAX, 1
                DB      0Fh, 0A2h       ; CPUID
                Test    EDX, 800000h
                JZ      DetectMMXFail

                Trace   "MMX Detected"

                ClC
                Ret

DetectMMXFail:
                Trace   "MMX Not Detected"

                StC
                Ret

EndP            DetectMMX

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            DetectCard Far

                Push    CS
                Push    CS
                Pop     DS
                Pop     ES
                        Assume DS:Driver

                Mov     Forced, AL

                Cmp     BX, 217h
                JAE     DetectCardUseDriver

                Mov     CX, DS
                ShL     ECX, 16
                Mov     CX, Offset DefaultDriverName

DetectCardUseDriver:
                Mov     DriverName, ECX

                Call    DetectMMX
                JC      DetectCardError

; First need to find if VSound server is setup.
                Mov     DX, BasePort
                Cmp     DX, 0FFFFh
                JNE     PortSpecified

                Mov     DX, 400h
                Jmp     TestPort

PortSpecified:
                Cmp     AL, 1
                JNE     DetectCardError


TestPort:
                Mov     BasePort, DX

                Xor     AL, AL
                Out     DX, AL          ; Reset, get identification

                Mov     CX, 8
                Mov     DI, Offset VSoundIDBuffer
                Rep     InsB

                Mov     SI, Offset VSoundIDBuffer   ; DI now points to VSoundID
                Mov     CX, 8
                RepE    CmpsB
                JNE     DetectCardError

; We've found a VSound server. Get ServerString

                Mov     AL, 1
                Out     DX, AL
                                                ; DI now points to ServerString.
                Mov     DI, Offset VSoundString
                Mov     CX, 60
                Rep     InsB

                Mov     DI, Offset Threshold
                Mov     CX, 4
                Rep     InsB

                Xor     DWord Ptr [Threshold], 0FFFFFFFFh

                Mov     EAX, 'Jeff'
                DB      85h

DetectCardError:
                StC
                Ret

EndP            DetectCard
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

include mmxmsam.inc
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

InVSound        DB      -1

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            VSoundFillBuffer
                Assume DS:Nothing

VSoundHandler3:

                Mov     DX, BasePort
                Mov     AL, 2
                Out     DX, AL
                In      AL, DX
                Mov     AH, AL
                In      AL, DX          ; AX = BufferSize

                Cmp     AX, Threshold
                JB      VSoundHandler4

                Ret

VSoundHandler4:
                Call    Update
                Call    MixSamples

; Convert the buffer
                Mov     DS, MixSegment
                Mov     SI, MixTransferOffset
                Mov     CX, BytesToMix  ; CX = number of 32-bit samples to mix.
                Mov     DI, SI

; Transfer the buffer
                Cmp     Stereo, 0
                JE      VSoundHandlerMono

VSoundHandlerStereo:
                Add     CX, 3
                ShR     CX, 2

VsoundHandlerStereo1:
                MovQ    MM0, [SI]       ; MM0 = s0r | s0l
                MovQ    MM1, [SI+8]     ; MM1 = s1r | s1l
                MovQ    MM2, [SI+10h]   ; MM2 = s2r | s2l
                MovQ    MM3, [SI+18h]   ; MM3 = s3r | s3l

                PSRADI  MM0, 12
                PSRADI  MM1, 12
                PSRADI  MM2, 12
                PSRADI  MM3, 12

                PackSSDW MM0, MM1
                PackSSDW MM2, MM3

                MovQM   [DI], MM0
                MovQM   [DI+8], MM2

                Add     SI, 20h
                Add     DI, 10h

                Loop    VSoundHandlerStereo1
                Jmp     VSoundHandlerSend

VSoundHandlerMono:
                Inc     CX
                ShR     CX, 1

VSoundHandlerMono1:
; want final to be s1|s1|s0|s0 (16 bits)
; Do 2 samples at a time.
                MovD    MM0, [SI]
                MovD    MM1, [SI+8]
                MovD    MM2, [SI+10h]
                MovD    MM3, [SI+18h]

                PUnpckLDQ MM0, MM0
                PUnpckLDQ MM1, MM1
                PUnpckLDQ MM2, MM2
                PUnpckLDQ MM3, MM3

                PSRADI  MM0, 13
                PSRADI  MM1, 13
                PSRADI  MM2, 13
                PSRADI  MM3, 13

                PackSSDW MM0, MM1
                PackSSDW MM2, MM3

                MovQM   [DI], MM0
                MovQM   [DI+8], MM2

                Add     SI, 20h
                Add     DI, 10h

                Loop    VSoundHandlerMono1

VSoundHandlerSend:
                Mov     CX, BytesToMix
                Mov     DX, BasePort
                ShL     CX, 2
                Add     DX, 2
                Mov     SI, MixTransferOffset
                Rep     OutsB

                Jmp     VSoundHandler3

EndP            VSoundFillBuffer

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            VSoundHandler

                PushAD
                Push    DS
                Push    ES

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Add     TimerAccumulator, TIMERCONST
                JC      VSoundHandler1

                Mov     AL, 20h
                Out     20h, AL
                Jmp     VSoundHandler2

VSoundHandler1:
                PushF
                Call    [OldTimerIRQHandler]

VSoundHandler2:
                Add     InVSound, 1
                JNC     VSoundExit

                FNSave  [FPSave]
                Call    SaveEMSPageFrame

                        Assume DS:Nothing
                Call    VSoundFillBuffer

                Call    RestoreEMSPageFrame
                FNRstor [FPSave]

VSoundExit:
                Pop     ES
                Pop     DS
                PopAD

                Sub     CS:InVSound, 1
                IRet

EndP            VSoundHandler

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetIRQ

                PushAD
                Push    ES

                Xor     AX, AX
                Mov     ES, AX

                Mov     AL, 34h         ; Program IRQ 0. LSB&MSB, Rate gen
                Out     43h, AL         ; bump the interrupt to be called
                                        ; 100 times a second.
                Mov     AX, TIMERCONST
                Out     40h, AL
                Mov     AL, AH
                Out     40h, AL

                Mov     AX, CS
                ShL     EAX, 16
                Mov     AX, Offset VSoundHandler

                ClI

                XChg    [ES:20h], EAX           ; Hook to timer interrupt
                Mov     CS:OldTimerIRQHandler, EAX

                StI

                Pop     ES
                PopAD

                Ret

EndP            SetIRQ
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ResetIRQ

                PushAD
                Push    ES

                Xor     AX, AX
                Mov     ES, AX

                Mov     AL, 34h         ; Program IRQ 0. LSB&MSB, Rate gen
                Out     43h, AL

                Xor     AL, AL
                Out     40h, AL         ; Interrupt called at normal 18.2 times
                Out     40h, AL

                Mov     EAX, CS:OldTimerIRQHandler
                Mov     [ES:20h], EAX

                Pop     ES
                PopAD

                Ret

EndP            ResetIRQ
                Assume DS:Nothing


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

                FNInit
                FILd    DWord Ptr [MixSpeed]
                FMul    FreqMultiplier
                FStP    FreqMultiplier

                Mov     SI, Offset RelocationTable

RelocationFix:
                LodsW
                Test    AX, AX
                JZ      RelocationEnd
                Mov     BX, AX
                Mov     [BX], DS
                Jmp     RelocationFix


RelocationEnd:
                Call    GetEMSPageFrame
                Mov     EMSPageFrame, AX

                Mov     ECX, IdleUpdateInfoLine
                Mov     EDX, GlobalKeyList
                Mov     IdleFunctionList, ECX
                Mov     GlobalKeyLink2, EDX

                Mov     ECX, FillHeaderFunction
                Mov     EDX, DrawHeaderFunction
                Mov     FillHeader2, ECX
                Mov     ScreenHeader2, EDX

                ; Parags to allocate = (8/(.4*31*16))*MixSpeed
                ; = .04032258*MixSpeed = (65536*.04032258*MixSpeed) / 65536

                Mov     AX, 2643
                Mul     MixSpeed
                Add     AX, 0FFFFh
                AdC     DX, 5
                Mov     BX, DX
                Mov     AH, 48h
                Int     21h

                Mov     SI, Offset VSoundNoMemoryMsg
                JNC     InitSound1

                Pop     ES
                Ret

InitSound1:
                Mov     MixSegment, AX

                Call    SetIRQ
                Call    GetTempo
                Call    SetTempo

                Mov     SI, Offset VSoundDriverMsg
                Mov     AX, BasePort

                ClC
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
                Mov     DX, Offset MixMode
                Int     21h

SaveConfig1:
                Mov     AH, 3Eh
                Int     21h

SaveConfig2:
                Mov     AX, MixSegment
                Test    AX, AX
                JZ      UnInitSound1

                Mov     ES, AX
                Mov     AH, 49h         ; Release MixSegment
                Int     21h

                Call    ResetIRQ

UnInitSound1:
                Mov     DX, BasePort
                Mov     AL, 3
                Out     DX, AL

                Ret

EndP            UnInitSound
                Assume DS:Nothing

;컴 Poll 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;
; This procedure is called as often as possible by IT.EXE
; AX = Playmode (0 for nothing in particular, 1 = pattern, 2 = song)
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            Poll Far

                ClI
                Add     CS:InVSound, 1
                JNC     Poll1

                Call    VSoundFillBuffer

Poll1:
                Sub     CS:InVSound, 1
                StI

                Ret

EndP            Poll

;컴 SetTempo 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;
; Parameters: BX = tempo
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetTempo Far
                Assume DS:Nothing

                Push    AX
                Push    BX
                Push    DX

                Push    BX

                Mov     AX, MixSpeed
                Mov     BX, AX
                Xor     DX, DX

                ShL     AX, 1
                RCL     DX, 1           ; DX:AX = Mixspeed*2

                ShR     BX, 1           ; BX = Mixspeed/2

                Add     AX, BX
                AdC     DX, 0           ; DX:AX = Mixspeed*2.5

                Pop     BX              ; BX = tempo
                Div     BX

                Mov     BytesToMix, AX

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
                Mov     DS, Word Ptr [CS:RecalculateAllVolumes+2]
                Jmp     CS:RecalculateAllVolumes

EndP            SetMixVolume

;컴 SetStereo 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Parameters: AL = Stereo on/off, 0 = off.
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetStereo Far

                Mov     CS:Stereo, AL
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

include loadsam.inc

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

                Mov     AX, 5
                Mov     SI, 1
                Mov     CX, CS
                Mov     DX, Offset VSoundScreenList

                ClC

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
;                Call    UARTOut
                Pop     AX
                Mov     CS:InterpretState, 0

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
;                Call    UARTOut
                Ret

EndP            SendUARTOut

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

EndDriver:

;********  Provided Variable Table *************

MaxNumberOfChannels     DW      0FFFFh  ; Maximum number of channels the
                                        ; driver can handle.
                        DW      0
DefaultChannels         DW      128
                        DW      3
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
