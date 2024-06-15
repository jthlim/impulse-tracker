

        .386P

Segment                 DriverHeader PARA Public 'Code' Use16
                        Assume CS:Driver, DS:Nothing

;***** Driver Header *******

include drhead.inc
include mmx.inc

EndS

Segment                 Driver PARA Public 'Code' Use16
                        Assume CS:Driver, DS:Nothing

ORG 0
StartDriver:

include vtable.inc

;********  Required ProcedureTable *************

include reqproc.inc

;**********************************

TRACEENABLED            =       0
CREATENEWLOGFILE        =       1

include debug.inc

STEREOENABLED           EQU     1
DMABUFFERLENGTH         EQU     4096
MIXRESOLUTION           EQU     32      ; 32 bit mixing for the SB16
OUTPUTFILTERENABLED     EQU     1
FOURIERBUFFERLENGTH     EQU     2048    ; 2048 samples

FPSave          DB      128 Dup (0)

SB16Msg         DB      "Sound Blaster 16 MMX", 13
                DB      "Port ", 0FDh, "Xh, IRQ ", 0FDh, "D, DMA ", 0FDh, "D", 0

SB16NoMemoryMsg DB      "Sound Blaster 16 MMX", 13
                DB      "Error: Insufficient memory", 0

ReinitMsg       DB      "Sound Blaster 16 reinitialised", 0

DefaultDriverName DB    "ITSB16.MMX", 0
DriverName      DD      0

DSPVersion      DW      0
DSPIRQValue     DB      0
DSPDMAValue     DB      0
Forced          DB      0
Stereo          DB      0
MixVolume       DW      0

BytesToMix      DW      1000
SBMixConst      DB      0

MixSegment      DW      0
FourierSegment  DW      0

MixTransferOffset       DW      0
MixTransferRemaining    DW      0

CONFIGURATIONOFFSET     EQU     $+128
CONFIGSIZE              EQU     20
MixMode                 DW      0
MixModeOffset           DW      0
DMASize                 DW      2048
VolumeTable             DB      6 Dup (0)
                        DB      0, 16, 96, 127
                        DB      0, 0, 0, 0

IMR             DW      0
OldIRQHandler   DD      0

MIDIPort        DW      0
MIDIBuffer      DB      256 Dup (0)
MIDIBufferHead  DB      0
MIDIBufferTail  DB      0

IRQData                 Label   Word
        DW      20h,  1111111111111110b ; IRQ 0
        DW      24h,  1111111111111101b ; IRQ 1
        DW      28h,  1111110111111011b ; IRQ 2
        DW      2Ch,  1111111111110111b ; IRQ 3
        DW      30h,  1111111111101111b ; IRQ 4
        DW      34h,  1111111111011111b ; IRQ 5
        DW      38h,  1111111110111111b ; IRQ 6
        DW      3Ch,  1111111101111111b ; IRQ 7
        DW      1C0h, 1111111011111011b ; IRQ 8
        DW      1C4h, 1111110111111011b ; IRQ 9
        DW      1C8h, 1111101111111011b ; IRQ 10
        DW      1CCh, 1111011111111011b ; IRQ 11
        DW      1D0h, 1110111111111011b ; IRQ 12
        DW      1D4h, 1101111111111011b ; IRQ 13
        DW      1D8h, 1011111111111011b ; IRQ 14
        DW      1DCh, 0111111111111011b ; IRQ 15


;**********************************

SB16ScreenList          Label
                        DW      8
                        DW      Near Ptr IdleFunctionList
                        DW      Near Ptr GlobalKeyLink

                        DW      Near Ptr FullScreenBox  ; 0
                        DW      Near Ptr ScreenHeader
                        DW      Near Ptr FillHeader
                        DW      Near Ptr SB16HeaderLine

                        DW      Near Ptr VolumeText
                        DW      Near Ptr VolumeBox1
                        DW      Near Ptr VolumeBox2

                        DW      Near Ptr DriverText

                        DW      Near Ptr MasterVolumeLeft       ; 8
                        DW      Near Ptr MasterVolumeRight      ; 9
                        DW      Near Ptr TrebleVolumeLeft       ; 10
                        DW      Near Ptr TrebleVolumeRight      ; 11
                        DW      Near Ptr BassVolumeLeft         ; 12
                        DW      Near Ptr BassVolumeRight        ; 13

                        DW      Near Ptr MixModeText
                        DW      Near Ptr MixModeButton1         ; 15
                        DW      Near Ptr MixModeButton2         ; 16
                        DW      Near Ptr MixModeButton3         ; 17
                        DW      Near Ptr MixModeButton4         ; 18

                        DW      Near Ptr FrequencyText

                        DW      Near Ptr FilterText             ; 20
                        DW      Near Ptr FilterBox1
                        DW      Near Ptr FilterBox2

                        DW      Near Ptr FilterFrequency1       ; 23
                        DW      Near Ptr FilterFrequency2
                        DW      Near Ptr FilterFrequency3
                        DW      Near Ptr FilterFrequency4

                        DW      Near Ptr FilterVolume1          ; 27
                        DW      Near Ptr FilterVolume2
                        DW      Near Ptr FilterVolume3
                        DW      Near Ptr FilterVolume4

                        DW      0


SB16HeaderLine          DW      10
                        DB      "Sound Blaster 16 Driver", 0

DriverText              DW      1
                        DB      31, 48
                        DB      21h
                        DB      "Sound Blaster 16 Driver 1.4 for Impulse Tracker", 0

VolumeText              DW      1
                        DB      2, 13
                        DB      20h
                        DB      "Master Volume Left", 13
                        DB      "Master Volume Right", 13
                        DB      13
                        DB      13
                        DB      "Treble Left", 13
                        DB      "Treble Right", 13
                        DB      "Bass Left", 13
                        DB      "Bass Right", 13
                        DB      0

VolumeBox1              DW      0
                        DB      21, 12, 27, 15
                        DB      25

VolumeBox2              DW      0
                        DB      14, 16, 18, 21
                        DB      25

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

MasterVolumeLeft        DW      9
                        DB      22, 13
                        DW      0, 31
                        DW      9, 0
                        DW      0FFFFh, 9, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh

MasterVolumeRight       DW      9
                        DB      22, 14
                        DW      0, 31
                        DW      9, 1
                        DW      8, 10, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh

TrebleVolumeLeft        DW      9
                        DB      15, 17
                        DW      0, 15
                        DW      9, 2
                        DW      9, 11, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh

TrebleVolumeRight       DW      9
                        DB      15, 18
                        DW      0, 15
                        DW      9, 3
                        DW      10, 12, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh

BassVolumeLeft          DW      9
                        DB      15, 19
                        DW      0, 15
                        DW      9, 4
                        DW      11, 13, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh

BassVolumeRight         DW      9
                        DB      15, 20
                        DW      0, 15
                        DW      9, 5
                        DW      12, 15, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh

MixModeText             DW      1
                        DB      2, 23
                        DB      20h
                        DB      "Mixing Mode", 0

FrequencyText           DW      1
                        DB      2, 48
                        DB      20h
                        DB      "Playback Frequency: ", 0FDh, "DHz", 0
MixSpeed                DW      45454
                        DW      0

MixModeButton1          DW      2
                        DW      13, 16, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetMixMode
DriverSegment1          DW      0
                        DW      0
                        DW      Offset SetMixMode
DriverSegment2          DW      0
                        DB      3, 25, 32, 27, 8
                        DB      0
                        DB      "  MMX, Non-Interpolated", 0

MixModeButton2          DW      2
                        DW      15, 17, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetMixMode
DriverSegment3          DW      0
                        DW      1
                        DW      Offset SetMixMode
DriverSegment4          DW      0
                        DB      3, 28, 32, 30, 8
                        DB      0
                        DB      "  MMX, Interpolated", 0

MixModeButton3          DW      2
                        DW      16, 18, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetMixMode
DriverSegment5          DW      0
                        DW      2
                        DW      Offset SetMixMode
DriverSegment6          DW      0
                        DB      3, 31, 32, 33, 8
                        DB      0
                        DB      "  MMX, Volume Ramped", 0

MixModeButton4          DW      2
                        DW      17, 23, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetMixMode
DriverSegment7          DW      0
                        DW      3
                        DW      Offset SetMixMode
DriverSegment8          DW      0
                        DB      3, 34, 32, 36, 8
                        DB      0
                        DB      "  MMX, Filtered", 0

FilterText              DW      1
                        DB      2, 39
                        DB      20h
                        DB      "Output Equalizer", 13
                        DB      13
                        DB      "     Low Frequency Band", 13
                        DB      " Med Low Frequency Band", 13
                        DB      "Med High Frequency Band", 13
                        DB      "    High Frequency Band", 0

FilterBox1              DW      0
                        DB      25, 40, 47, 45
                        DB      25

FilterBox2              DW      0
                        DB      52, 40, 74, 45
                        DB      25

FilterFrequency1        DW      14
                        DB      26, 41
                        DW      0, 127
                        DW      9, 6
                        DW      18, 24, 27, 27
                        DW      0FFFFh, 0FFFFh
                        DW      20

FilterFrequency2        DW      14
                        DB      26, 42
                        DW      0, 127
                        DW      9, 7
                        DW      23, 25, 28, 28
                        DW      0FFFFh, 0FFFFh
                        DW      20

FilterFrequency3        DW      14
                        DB      26, 43
                        DW      0, 127
                        DW      9, 8
                        DW      24, 26, 29, 29
                        DW      0FFFFh, 0FFFFh
                        DW      20

FilterFrequency4        DW      14
                        DB      26, 44
                        DW      0, 127
                        DW      9, 9
                        DW      25, 0FFFFh, 30, 30
                        DW      0FFFFh, 0FFFFh
                        DW      20

FilterVolume1           DW      14
                        DB      53, 41
                        DW      0, 255
                        DW      9, 10
                        DW      18, 28, 23, 23
                        DW      0FFFFh, 0FFFFh
                        DW      20

FilterVolume2           DW      14
                        DB      53, 42
                        DW      0, 255
                        DW      9, 11
                        DW      27, 29, 24, 24
                        DW      0FFFFh, 0FFFFh
                        DW      20

FilterVolume3           DW      14
                        DB      53, 43
                        DW      0, 255
                        DW      9, 12
                        DW      28, 30, 25, 25
                        DW      0FFFFh, 0FFFFh
                        DW      20

FilterVolume4           DW      14
                        DB      53, 44
                        DW      0, 255
                        DW      9, 13
                        DW      29, 0FFFFh, 26, 26
                        DW      0FFFFh, 0FFFFh
                        DW      20


; 컴 MixingRoutines 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

include dmasirq.inc
include mix.inc

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

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

RelocationTable         Label   Word
        DW      Offset DriverSegment1, Offset DriverSegment2
        DW      Offset DriverSegment3, Offset DriverSegment4
        DW      Offset DriverSegment5, Offset DriverSegment6
        DW      Offset DriverSegment7, Offset DriverSegment8
        DW      0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SBOut           ; AL = data
                                ; DX = 2xCh

                Push    AX

SBOut1:
                In      AL, DX
                Test    AL, AL
                JS      SBOut1

                Pop     AX
                Out     DX, AL

                Ret

EndP            SBOut

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SBIn            ; DX = 2xEh, returns AL

SBIn1:
                In      AL, DX
                Test    AL, AL
                JNS     SBIn1

                Add     DL, 0Ah-0Eh     ; DX = 2xAh -> Data read port
                In      AL, DX
                Add     DL, 0Eh-0Ah

                Ret

EndP            SBIn

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

Proc            DetectUART              ; Given DX = Port

; From SB-DevKit

                ClI

                Inc     DX
                Xor     CX, CX

DetectUART1:
                In      AL, DX
                Test    AL, 40h         ; Ready for output
                LoopNZ  DetectUART1
                JNZ     DetectUARTError

                Mov     AL, 0FFh        ; Reset!
                Out     DX, AL

                Xor     CX, CX

DetectUART2:
                In      AL, DX
                Test    AL, 80h
                JNZ     DetectUART3

                Dec     DX
                In      AL, DX
                Inc     DX
                Cmp     AL, 0FEh
                JE      DetectUART4

DetectUART3:
                Loop    DetectUART2

DetectUARTError:
                StI
                StC
                Ret

DetectUART4:                    ; Now to shove it into 'intelligent' mode.
                Xor     CX, CX

DetectUART5:
                In      AL, DX
                Test    AL, 40h
                LoopNZ  DetectUART5
                JNZ     DetectUARTError

                Mov     AL, 3Fh         ; Intelligent mode!
                Out     DX, AL

DetectUART6:
                Xor     CX, CX

DetectUART7:
                In      AL, DX
                Test    AL, 80h
                JNZ     DetectUART8

                Dec     DX
                In      AL, DX
                Inc     DX
                Cmp     AL, 0FEh
                JE      DetectUART9

DetectUART8:
                Loop    DetectUART7

                Jmp     DetectUARTError

DetectUART9:
                StI
                ClC
                Ret

EndP            DetectUART

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ReinitUART

                Mov     DX, MIDIPort
                Test    DX, DX
                JZ      ReinitUART1

                Call    DetectUART

ReinitUART1:
                Ret

EndP            ReinitUART

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ResetUART

                Mov     DX, MIDIPort
                Test    DX, DX
                JZ      ResetUART1

                Inc     DX

                Mov     AL, 0FFh
                Out     DX, AL

ResetUART1:
                Ret

EndP            ResetUART

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

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SBGetRegister

                Out     DX, AL
                Inc     DX
                In      AL, DX
                Dec     DX

                Ret

EndP            SBGetRegister

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            GetSBMixConst                   ; Work out value.. and nearest
                                                ; mixspeed value.

                PushA
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     AX, CmdLineMixSpeed
                Mov     CX, MixSpeed
                Test    AX, AX
                JZ      GetSBMixConst1

                Mov     CX, 45454
                Cmp     AX, CX
                JA      GetSBMixConst1

                Mov     CX, 12000
                Cmp     AX, CX
                JB      GetSBMixConst1

                Mov     CX, AX

GetSBMixConst1:
                Mov     AX, 1000
                Mul     AX
                Div     CX
                Mov     AH, AL
                Neg     AH
                Mov     SBMixConst, AH

                MovZX   BX, AL
                Mov     AX, 1000
                Mul     AX
                Div     BX
                Mov     MixSpeed, AX

                FNInit
                FILd    DWord Ptr [MixSpeed]
                FMul    FreqMultiplier
                FStP    FreqMultiplier

                Mov     BX, 12000
                Xor     DX, DX
                Div     BX
                Mov     FourierBufferStepOffset, AX
                Mov     FourierBufferStepFractional, DX

                Pop     DS
                PopA
                Ret

EndP            GetSBMixConst
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            ResetDSP Far            ; AX = Port

                Push    AX
                Push    CX
                Push    DX

                Mov     DX, AX
                Add     DL, 6
                Mov     AL, 1
                Out     DX, AL

                In      AL, DX
                In      AL, DX
                In      AL, DX
                In      AL, DX

                Xor     AL, AL
                Out     DX, AL

                Add     DL, 8
                Mov     CX, 200

ResetDSP1:
                In      AL, DX
                Test    AL, AL
                JS      ResetDSP2
                Loop    ResetDSP1
                Jmp     ResetDSP3

ResetDSP2:
                Sub     DL, 4
                In      AL, DX
                Cmp     AL, 0AAh
                JE      ResetDSP4
                Add     DL, 4
                Loop    ResetDSP1

ResetDSP3:
                StC

ResetDSP4:
                Pop     DX
                Pop     CX
                Pop     AX
                Ret

EndP            ResetDSP

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ResetDSPIRQ

                Mov     DX, CS:BasePort
                Add     DL, 4
                Mov     AH, CS:DSPIRQValue
                Mov     AL, 80h
                Out     DX, AX

                Ret

EndP            ResetDSPIRQ

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ResetDSPDMA

                Mov     DX, CS:BasePort
                Add     DL, 4
                Mov     AH, CS:DSPDMAValue
                Mov     AL, 81h
                Out     DX, AX

                Ret

EndP            ResetDSPDMA

; 컴 DetectCard 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Returns carry set if error, else carry clear. Has to setup internal vars
; (eg. appropriate IRQ/DMA whatever).
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            DetectCard Far

                Push    CS
                Pop     DS
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
                JC      DetectCardFailure

                Mov     AX, BasePort
                Cmp     AX, 0FFFFh
                JE      DetectCard1

                Cmp     AX, 210h
                JB      DetectCard9
                Cmp     AX, 280h
                JA      DetectCard9

                Call    ResetDSP
                JNC     DetectCard2

                Ret

DetectCard1:
                Mov     AX, 210h

DetectCard2:
                Call    ResetDSP
                JNC     DetectCard3
                Add     AL, 10h
                Cmp     AL, 80h
                JBE     DetectCard2

DetectCard9:
                StC
                Ret

DetectCard3:                            ; OK... DSP found.
                                        ; Get DSP version
                Mov     BasePort, AX

                Mov     DX, AX
                Add     DL, 0Ch         ; 2xCh -> Data ready to send...

DetectCardOuputLoop1:
                In      AL, DX
                Test    AL, AL
                JS      DetectCardOuputLoop1

                Mov     AL, 0E1h        ; Get DSP version command
                Out     DX, AL

                Add     DL, 0Eh-0Ch     ; DX = 2xEh -> Data available status

                Call    SBIn
                Mov     AH, AL          ; AH = Major version number
                Call    SBIn            ; AL = Minor version number

                Cmp     AH, 4           ; SB DSP = 4.00+
                JAE     DetectCard5

DetectCard4:
                StC
                Ret

DetectCard5:
                Mov     DSPVersion, AX

                Add     DL, 04h-0Eh     ; 2x4h = Mixer index port
                Mov     AL, 80h         ; IRQ select
                Out     DX, AL
                Inc     DL              ; 2x5h = Mixer data port

                In      AL, DX

                Dec     DL

                Mov     DSPIRQValue, AL
                                        ; OK.. now get IRQ, or set IRQ
                Mov     BX, IRQ
                Cmp     BX, 0FFFFh
                JE      DetectCardIRQ1
                Cmp     Forced, 0
                JE      DetectCardIRQ1

                Mov     AH, 11h
                Cmp     BL, 2
                JE      SetCardIRQ1
                Cmp     BL, 9
                JE      SetCardIRQ1

                Mov     AH, 12h
                Cmp     BL, 5
                JE      SetCardIRQ1

                Mov     AH, 14h
                Cmp     BL, 7
                JE      SetCardIRQ1

                Mov     AH, 18h
                Cmp     BL, 10
                JE      SetCardIRQ1

                StC
                Ret

SetCardIRQ1:
                Mov     AL, 80h
                Out     DX, AL
                Inc     DL
                Mov     AL, AH
                Out     DX, AL
                Dec     DL
                Jmp     DetectCard6

DetectCardIRQ1:
                Mov     BX, 2
                Test    AL, 1
                JNZ     DetectCardIRQ2

                Mov     BL, 5
                Test    AL, 2
                JNZ     DetectCardIRQ2

                Mov     BL, 7
                Test    AL, 4
                JNZ     DetectCardIRQ2

                Mov     BL, 10
                Test    AL, 8
                JNZ     DetectCardIRQ2

                StC
                Ret

DetectCardIRQ2:
                Cmp     IRQ, 0FFFFh
                JE      DetectCardIRQ3

                Cmp     BX, IRQ
                JE      DetectCard6

DetectCardFailure:
                StC
                Ret

DetectCardIRQ3:
                Mov     IRQ, BX

DetectCard6:                    ; Detect DMA
                Mov     AL, 81h ; DMA select
                Out     DX, AL
                Inc     DL
                In      AL, DX  ; AL = DMA
                Dec     DL

                Mov     DSPDMAValue, AL

                Mov     BX, DMA
                Cmp     BX, 0FFFFh
                JE      DetectCardDMA1
                Cmp     Forced, 0
                JE      DetectCardDMA1

                Mov     CL, 1
                Cmp     BX, 1
                JB      SetCardDMA1

                Mov     CL, 2
                JE      SetCardDMA1

                Cmp     BX, 3
                JB      DetectCard7

                Mov     CL, 8
                JE      DetectCard7

                Mov     CL, 20h
                Cmp     BX, 5
                JB      DetectCard7
                JE      SetCardDMA1

                Mov     CL, 80h
                Cmp     BX, 7
                JA      DetectCard7
                JE      SetCardDMA1

                Mov     CL, 40h

SetCardDMA1:
                And     AL, 0Bh
                Test    CL, 0Bh
                JZ      SetCardDMA4

                Xor     AL, AL

SetCardDMA4:
                Or      CL, AL

                Mov     AL, 81h
                Out     DX, AL
                Inc     DL
                Mov     AL, CL
                Out     DX, AL
                Jmp     DetectCard7

DetectCardDMA1:
                Mov     BX, 5
                Test    AL, 20h
                JNZ     DetectCardDMA2

                Inc     BL
                Test    AL, 40h
                JNZ     DetectCardDMA2

                Inc     BL
                Test    AL, 80h
                JNZ     DetectCardDMA2

                Mov     BL, 0
                Test    AL, 1
                JNZ     DetectCardDMA2

                Inc     BL
                Test    AL, 2
                JNZ     DetectCardDMA2

                Add     BL, 2
                Test    AL, 8
                JNZ     DetectCardDMA2

DetectCard8:
                Call    ResetDSPIRQ
                StC
                Ret

DetectCardDMA2:
                Cmp     DMA, 0FFFFh
                JE      DetectCardDMA3

                Cmp     BX, DMA
                JNE     DetectCard8

DetectCardDMA3:
                Mov     DMA, BX

DetectCard7:
                Mov     EAX, 'Jeff'

                ClC
                Ret

EndP            DetectCard
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

include mmxmsam.inc
include fourier.inc

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            AckIRQ
                Assume DS:Driver

                Mov     AL, 20h
                Cmp     CS:IRQ, 7
                JBE     AckIRQ1

                Out     0A0h, AL

AckIRQ1:
                Out     20h, AL
                Ret

EndP            AckIRQ
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            CheckMIDI

                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Xor     BX, BX
                Mov     DX, MIDIPort

                Mov     BL, [MIDIBufferTail]
                Test    DX, DX
                JZ      CheckMIDIEnd

                Inc     DX
                Mov     CX, 0FFFFh

CheckMIDIAgain:
                In      AL, DX

                Test    AL, 80h
                LoopNZ  CheckMIDIAgain

                Dec     DX
                In      AL, DX

                Cmp     AL, 0F0h
                JAE     CheckMIDIEnd

                Inc     BL
                Cmp     BL, MIDIBufferHead
                JE      CheckMIDIEnd

                Mov     [MIDIBuffer+BX], AL
                Mov     [MIDIBufferTail], BL
;                Jmp     CheckMIDIAgain

CheckMIDIEnd:
                Pop     DS
                Ret

EndP            CheckMIDI
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SB16IRQHandler

                PushAD
                Push    DS
                Push    ES

                CLD

SBIRQAgain:
                Mov     AX, CS
                Mov     DS, AX
                        Assume DS:Driver

                Mov     DX, BasePort
                Add     DL, 4           ; Mixer Port
                Mov     AL, 82h
                Out     DX, AL
                Inc     DL              ; DX = BasePort+5
                In      AL, DX

                Test    AL, 4
                JZ      SBMIDIInterruptEnd

                Push    AX
                Call    CheckMIDI
                Pop     AX

SBMIDIInterruptEnd:
                Test    AL, 2
                JNZ     SBDigitalInterrupt

                Call    AckIRQ
                Jmp     SBIRQEnd

SBDigitalInterrupt:
                FNSave  [FPSave]

                Mov     DX, BasePort
                Add     DL, 0Fh
                In      AL, DX          ; 16-bit IRQ ack.

                Call    AckIRQ

DMAPort1 EQU $+1
                In      AL, 1
                Mov     BL, AL
DMAPort2 EQU $+1
                In      AL, 1
                Mov     BH, AL

                Xor     AX, AX
DMA16BITADJUST EQU $
                ShL     BX, 1

                Cmp     BX, DMABUFFERLENGTH/2
                JB      SB16IRQHandler2

                Mov     AX, DMABUFFERLENGTH/2

SB16IRQHandler2:

                                        ; OK... time to get next block
                                        ;  Check whether stereo thing is on..
                                        ;
                LES     DI, [ActualDMAPtr]
                Mov     BX, DMASize             ; BX = bytes required
                Add     DI, AX
                ShR     BX, 1
                                                ; BX = samples required
                Call    SaveEMSPageFrame

                Cmp     MixTransferRemaining, 0
                JNE     SB16IRQHandler4
                        Assume DS:Nothing

SB16IRQHandler3:
                Push    BX
                Push    CX
                Push    BP
                Push    ES
                Push    DI

                Call    Update
                Call    MixSamples
                Call    UpdateFourierBuffer

                Pop     DI
                Pop     ES
                Pop     BP
                Pop     CX
                Pop     BX

SB16IRQHandler4:
                Mov     DS, MixSegment
                Mov     SI, MixTransferOffset
                Mov     DX, BX          ;  DX = samples to transfer
                Cmp     DX, MixTransferRemaining
                JBE     SB16IRQHandler5

                Mov     DX, MixTransferRemaining

SB16IRQHandler5:

include mmxtrans.inc

                Sub     MixTransferRemaining, DX        ; } Memory write
                Sub     BX, DX
                JNZ     SB16IRQHandler3

                Mov     MixTransferOffset, SI           ; } Memory write

                Call    RestoreEMSPageFrame

                FNRstor [CS:FPSave]

SBIRQEnd:
                Pop     ES
                Pop     DS
                PopAD
                IRet

EndP            SB16IRQHandler
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetIRQ

                PushAD
                Push    DS
                Push    ES

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Xor     AX, AX
                Mov     ES, AX

                Mov     DI, IRQ
                ShL     DI, 2
                Add     DI, Offset IRQData
                Mov     BX, [DI]

                Mov     AX, CS
                ShL     EAX, 16
                Mov     AX, Offset SB16IRQHandler

                XChg    [ES:BX], EAX
                Mov     OldIRQHandler, EAX

                Mov     AX, IMR
                And     AX, [DI+2]

                Out     21h, AL
                Mov     AL, AH
                Out     0A1h, AL

                Pop     ES
                Pop     DS
                PopAD

                Ret

EndP            SetIRQ
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ResetIRQ

                PushAD
                Push    DS
                Push    ES

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Xor     AX, AX
                Mov     ES, AX

                Mov     DI, IRQ
                ShL     DI, 2
                Mov     BX, [IRQData+DI]

                Mov     EAX, OldIRQHandler
                Mov     [ES:BX], EAX

                Pop     ES
                Pop     DS
                PopAD

                Ret

EndP            ResetIRQ
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            StartSB16               ;

                PushA
                Push    DS
                Push    ES

                Push    CS
                Pop     DS
                        Assume DS:Driver

                                ; Setup DMA
                Mov     BX, MixSegment
                Mov     AX, 80
                Mov     DX, DMA
                Mov     DI, DMABUFFERLENGTH
                Cmp     DX, 3
                JA      StartSB16B

                Mov     Word Ptr [DMA16BITADJUST], 9090h
StartSB16B:
                Call    SetDMA

                LES     DI, ActualDMAPtr
                Xor     AX, AX
                Mov     CX, DMABUFFERLENGTH/2
                Rep     StosW

                Mov     MixTransferRemaining, 0

                Mov     DX, BasePort
                Add     DL, 0Ch

                Mov     AL, 0D1h        ; turn on speaker
                Call    SBOut

                Mov     AL, 40h         ; time constant
                Call    SBOut
                Mov     AL, SBMixConst
                Call    SBOut

                Mov     AL, 0B6h         ; 16 bit, DAC
                Call    SBOut
                Mov     AL, Stereo
                ShL     AL, 5
                Or      AL, 10h
                Call    SBOut

                Mov     AX, DMASize
                ShR     AX, 1
                Dec     AX

                Call    SBOut           ; DMALength, Lo
                Mov     AL, AH
                Call    SBOut

                Pop     ES
                Pop     DS
                PopA

                Ret

                        Assume DS:Nothing

EndP            StartSB16

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            GetMixerRegisters

                Push    DS

                Push    CS
                Pop     DS
                        Assume   DS:Driver

                Pop     DS

                Ret

EndP            GetMixerRegisters
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

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

                Mov     ECX, IdleUpdateInfoLine
                Mov     EDX, GlobalKeyList
                Mov     IdleFunctionList, ECX
                Mov     GlobalKeyLink2, EDX

                Mov     ECX, FillHeaderFunction
                Mov     EDX, DrawHeaderFunction
                Mov     FillHeader2, ECX
                Mov     ScreenHeader2, EDX

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

                In      AL, 0A1h
                Mov     AH, AL
                In      AL, 21h
                Mov     IMR, AX

                Mov     DX, BasePort
                Add     DL, 4

                Mov     AL, 30h
                Call    SBGetRegister
                ShR     AL, 3
                Mov     VolumeTable, AL

                Mov     AL, 31h
                Call    SBGetRegister
                ShR     AL, 3
                Mov     [VolumeTable+1], AL

                Mov     AL, 44h
                Call    SBGetRegister
                ShR     AL, 4
                Mov     [VolumeTable+2], AL

                Mov     AL, 45h
                Call    SBGetRegister
                ShR     AL, 4
                Mov     [VolumeTable+3], AL

                Mov     AL, 46h
                Call    SBGetRegister
                ShR     AL, 4
                Mov     [VolumeTable+4], AL

                Mov     AL, 47h
                Call    SBGetRegister
                ShR     AL, 4
                Mov     [VolumeTable+5], AL

                Call    GetSBMixConst

                ; Parags to allocate = (8/(.4*31*16))*MixSpeed
                ; = .04032258*MixSpeed = (65536*.04032258*MixSpeed) / 65536

                Mov     AX, 2643
                Mul     MixSpeed
                Add     AX, 0FFFFh
                AdC     DX, 5+(DMABUFFERLENGTH*2)/16+(FOURIERBUFFERLENGTH*2)/16
                Mov     BX, DX

                        ; Allocate MixSegment first
                Mov     AH, 48h

                Int     21h
                JNC     InitSound1

InitSoundNoMemory:
                Mov     SI, Offset SB16NoMemoryMsg
                Ret

InitSound1:
                Mov     MixSegment, AX
                Add     AX, DX
                Sub     AX, (FOURIERBUFFERLENGTH*2)/16
                Mov     FourierSegment, AX

                Call    SetIRQ
                Call    GetTempo
                Call    SetTempo

                Mov     DX, 330h
                Call    DetectUART
                JC      DetectMIDI1

                Mov     MIDIPort, 330h
                Jmp     DetectMIDIEnd

DetectMIDI1:
                Mov     DX, 300h
                Call    DetectUART
                JC      DetectMIDIEnd

                Mov     MIDIPort, 300h

DetectMIDIEnd:
                Call    CalculateFilterCoefficients

                Mov     SI, Offset SB16Msg

                Mov     AX, BasePort
                Mov     BX, IRQ
                Mov     CX, DMA

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

                PushA
                Push    DS
                Push    ES

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     AX, BasePort
                Call    ResetDSP

                Call    ResetUART
                Call    ResetIRQ

                                        ; Delay..
                Mov     DX, BasePort
                Add     DL, 0Ch

                Mov     CX, 1000
ReInitSound1:
                In      AL, DX
                Loop    ReInitSound1

                Call    SetIRQ
                Call    ReinitUART

                Mov     SI, Offset ReInitMsg
                Mov     BX, 40
                Call    SetInfoLine

                Mov     AL, Stereo
                Call    SetStereo

                Pop     ES
                Pop     DS
                PopA

                Ret

EndP            ReInitSound
                Assume DS:Nothing

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
                Mov     DX, CS:BasePort
                Add     DL, 0Ch

                Mov     AL, 0D9h
                Call    SBOut

                Call    ResetUART

                Mov     AX, BasePort
                Call    ResetDSP

                Call    ResetDSPDMA
                Call    ResetDSPIRQ

                Mov     AX, IMR
                Out     21h, AL
                Mov     AL, AH
                Out     0A1h, AL

                Mov     AX, MixSegment
                Test    AX, AX
                JZ      UnInitSound1

                Mov     ES, AX
                Mov     AH, 49h         ; Release MixSegment
                Int     21h

                Call    ResetIRQ

UnInitSound1:
                Ret

EndP            UnInitSound

;컴 Poll 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;
; This procedure is called as often as possible by IT.EXE
; AX = Playmode (0 for nothing in particular, 1 = pattern, 2 = song)
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            Poll Far

                Push    CS
                Pop     DS
                        Assume DS:Driver

Poll1:
                Call    [UARTBufferEmpty]
                JNC     PollEnd

                Xor     BX, BX

                ClI

                Mov     BL, MIDIBufferHead
                Cmp     BL, MIDIBufferTail
                JZ      PollEnd         ; Nothing in queue

                Inc     BL
                Mov     AL, [MIDIBuffer+BX]
                Mov     MIDIBufferHead, BL

                Call    [UARTSend]
                Jmp     Poll1

PollEnd:
                StI

                Ret

EndP            Poll
                Assume DS:Nothing

;컴 SetTempo 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;
; Parameters: BX = tempo
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetTempo Far

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

                Cmp     CS:MixSegment, 0
                JE      SetStereo1

                Mov     CS:Stereo, AL
                Mov     AX, CS:BasePort
                Call    ResetDSP

                Call    StartSB16

SetStereo1:
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
;  Frees all on-board memory
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
                Mov     DX, Offset SB16ScreenList

                ClC
                Ret

EndP            SoundCardScreen

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            GetVariable Far         ; Returns AX, given DI

                Xor     AH, AH
                Mov     AL, [CS:VolumeTable+DI]
                Ret

EndP            GetVariable

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

                FNInit
                FLdCW   NewControlWord

                Mov     AL, [VolumeTable+6]
                Mov     SI, Offset FilterCoefficients
                ShR     AL, 1
                Call    GetFilterFrequency

                Mov     AL, [VolumeTable+7]     ; FilterFrequency1
                Add     SI, 8
                Call    GetFilterFrequency

                Mov     AL, [VolumeTable+8]     ; FilterFrequency1
                Add     SI, 8
                Call    GetFilterFrequency

                Mov     AL, [VolumeTable+9]     ; FilterFrequency1
                Add     SI, 8
                Call    GetFilterFrequency

; Now volumes
                Mov     SI, Offset VolumeTable+10
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

Proc            SetVariable Far         ; Given AX, DI

                Push    DS
                Push    DX

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     [VolumeTable+DI], AL

                Cmp     DI, 9
                JA      SetVariable3

                Cmp     DI, 6
                JB      SetVariable1

                JE      SetVariable2

                Cmp     AL, [VolumeTable+DI-1]
                JAE     SetVariable2

                Mov     AL, [VolumeTable+DI-1]
                Mov     [VolumeTable+DI], AL

SetVariable2:
                Cmp     DI, 9
                JAE     SetVariable3

                Cmp     AL, [VolumeTable+DI+1]
                JBE     SetVariable3

                Mov     AL, [VolumeTable+DI+1]
                Mov     [VolumeTable+DI], AL

SetVariable3:
                Call    CalculateFilterCoefficients
                Jmp     SetVariableEnd

SetVariable1:
                Mov     DX, BasePort
                Add     DL, 4
                Mov     AL, 30h
                Mov     AH, [VolumeTable]
                ShL     AH, 3
                Out     DX, AX

                Mov     AL, 31h
                Mov     AH, [VolumeTable+1]
                ShL     AH, 3
                Out     DX, AX

                Mov     AL, 44h
                Mov     AH, [VolumeTable+2]
                ShL     AH, 4
                Out     DX, AX

                Mov     AL, 45h
                Mov     AH, [VolumeTable+3]
                ShL     AH, 4
                Out     DX, AX

                Mov     AL, 46h
                Mov     AH, [VolumeTable+4]
                ShL     AH, 4
                Out     DX, AX

                Mov     AL, 47h
                Mov     AH, [VolumeTable+5]
                ShL     AH, 4
                Out     DX, AX

SetVariableEnd:
                Pop     DX
                Pop     DS
                Ret

EndP            SetVariable
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            UARTOut

                Push    CX
                Push    DX
                Mov     DX, CS:MIDIPort
                Test    DX, DX
                JZ      UARTOutEnd

                Push    AX
                Xor     CX, CX
                Inc     DX

UARTOut1:
                In      AL, DX
                Test    AL, 40h
                LoopNZ  UARTOut1

                Pop     AX
                JNZ     UARTOutEnd

                Dec     DX
                Out     DX, AL

UARTOutEnd:
                Pop     DX
                Pop     CX

                Ret

EndP            UARTOut

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
                Call    UARTOut
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
                Call    UARTOut
                Ret

EndP            SendUARTOut

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            GetWaveForm Far         ; Given ES:DI = destination
                Assume DS:Nothing       ; want 2048 samples.

                PushA
                Push    DS

                Mov     DS, FourierSegment
                Mov     SI, FourierBufferStart
                Mov     CX, 2048

GetWaveForm1:
                MovsW
                And     SI, (FOURIERBUFFERLENGTH*2)-1
                Loop    GetWaveForm1

                Pop     DS
                PopA

                Ret

EndP            GetWaveForm

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

EndDriver:

;********  Provided Variable Table *************

MaxNumberOfChannels     DW      0FFFFh  ; Maximum number of channels the
                                        ; driver can handle.

StopAfterPlay           DW      0
DefaultChannels         DW      128
                        DW      7       ; MIDI, hiqual
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

        DW      Offset GetWaveform

ProvidedTableEnd:
        DW      32-(ProvidedTableEnd-ProvidedTableStart)/2 Dup (0)

EndS

End
