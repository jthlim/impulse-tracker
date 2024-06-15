;
; ESS Technology's ES1688 Audiodrive chip, MMX version.
;
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

STEREOENABLED   EQU     1
DMABUFFERLENGTH EQU     8192
OUTPUTFILTERENABLED EQU 0
MIXRESOLUTION   EQU     32      ; 32 bit mixing for
MIXTABLESIZE    EQU     2*256*65

;Debug           DW      0
;Debug2          DW      0
ESSMsg          DB      "ES1688 AudioDrive MMX", 13
                DB      "Port ", 0FDh, "Xh, IRQ ", 0FDh, "D, DMA ", 0FDh, "D", 0

ESSNoMemoryMsg  DB      "ES1688 AudioDrive MMX", 13
                DB      "Error: Insufficient memory", 0

ReinitMsg       DB      "ES1688 AudioDrive reinitialised", 0

ConfigErrorMsg  DB      "Error saving configuration to ITES1688.MMX", 0
ConfigOKMsg     DB      "Configuration saved to ITES1688.MMX", 0

DriverName      DB      "ITES1688.MMX", 0

ALIGN 4
FPSave          DB      128 Dup (0)
ESSMixConst     DB      0, 0

DMASize         DW      4096    ; Smaller gives better MIDI timing
ConfigPort      DW      0

Forced          DB      0
Stereo          DB      0
MixVolume       DW      0

BytesToMix      DW      1000

MixSegment      DW      0

MixTransferOffset       DW      0
MixTransferRemaining    DW      0

CONFIGURATIONOFFSET     EQU     $+128
CONFIGSIZE              EQU     6
MixMode                 DW      0
MixModeOffset           DW      0
Filter                  DW      0

IMR                     DW      0
OldESSIRQHandler        DD      0

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

ESSScreenList            Label
                        DW      6
                        DW      Near Ptr IdleFunctionList
                        DW      Near Ptr GlobalKeyLink

                        DW      Near Ptr FullScreenBox  ; 0
                        DW      Near Ptr ScreenHeader
                        DW      Near Ptr FillHeader
                        DW      Near Ptr ESSHeaderLine

                        DW      Near Ptr DriverText

                        DW      Near Ptr MixModeText
                        DW      Near Ptr MixModeButton1         ; 6
                        DW      Near Ptr MixModeButton2         ;
                        DW      Near Ptr MixModeButton3         ; 8
                        DW      Near Ptr MixModeButton4         ; 9

Comment ~

                        DW      Near Ptr VolumeText
                        DW      Near Ptr VolumeBox1

                        DW      Near Ptr MasterVolumeLeft       ; 16
                        DW      Near Ptr MasterVolumeRight      ; 17

~

                        DW      0

ESSHeaderLine           DW      10
                        DB      "ESS1688 AudioDrive MMX Driver", 0

EmptyObject             DW      1
                        DB      0, 0
                        DB      0
                        DB      0

DriverText              DW      1
                        DB      33, 48
                        DB      21h
                        DB      "ESS AudioDrive Driver 1.0 for Impulse Tracker", 0

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

Comment ~

VolumeText              DW      1
                        DB      2, 14
                        DB      20h
                        DB      "Master Volume Left", 13
                        DB      "Master Volume Right"
                        DB      0

VolumeBox1              DW      0
                        DB      21, 13, 31, 16
                        DB      25

MasterVolumeLeft        DW      14
                        DB      22, 14
                        DW      0, 15
                        DW      9, 0
                        DW      0FFFFh, 17, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      8

MasterVolumeRight       DW      14
                        DB      22, 15
                        DW      0, 15
                        DW      9, 1
                        DW      16, 6, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      8

~

MixModeText             DW      1
                        DB      2, 14
                        DB      20h
                        DB      "Mixing Mode, Playback Frequency: ", 0FDh, "DHz", 0
MixSpeed                DW      44100
                        DW      0

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

ALIGN 4

VolumeTable             DB      2 Dup (0)
MIDIPort                DW      0

MIDIBuffer              DB      256 Dup (0)
MIDIBufferHead          DB      0
MIDIBufferTail          DB      0

; 컴 MixingRoutines 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

MixBufferPos            DW      0

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

Proc            ESSOut          ; AL = data
                                ; DX = 2xCh

                Push    AX

ESSOut1:
                In      AL, DX
                Test    AL, AL
                JS      ESSOut1

                Pop     AX
                Out     DX, AL

                Ret

EndP            ESSOut

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            ESSOut2         ; AL = data
                                ; DX = 2xCh

                Push    AX

ESSOut2A:
                In      AL, DX
                Test    AL, 80h
                LoopNZ  ESSOut2A

                Pop     AX
                Out     DX, AL

                Ret

EndP            ESSOut2

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            DetectMMX

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

                Mov     EAX, 1
                DB      0Fh, 0A2h       ; CPUID
                Test    EDX, 800000h
                JZ      DetectMMXFail

                ClC
                Ret

DetectMMXFail:
                StC
                Ret

EndP            DetectMMX

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            ESSIn2

ESSInA1:
                In      AL, DX
                Test    AL, 40h
                LoopZ   ESSInA1
                JZ      ESSInA2

                Add     DL, 0Ah-0Ch     ; DX = 2xAh -> Data read port
                In      AL, DX
                Add     DL, 0Ch-0Ah

                Ret

ESSInA2:
                Mov     AL, 0FFh
                Ret

EndP            ESSIn2

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            ESSIn            ; DX = 2xCh, returns AL

ESSIn1:
                In      AL, DX
                Test    AL, 40h
                JZ      ESSIn1

                Add     DL, 0Ah-0Ch     ; DX = 2xAh -> Data read port
                In      AL, DX
                Add     DL, 0Ch-0Ah

                Ret

EndP            ESSIn

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            UARTOut                 ; AL = out

                Push    DX
                Push    AX

                Mov     DX, CS:MIDIPort
                Inc     DX

UARTOut1:
                In      AL, DX
                Test    AL, 40h
                JNZ     UARTOut1

                Pop     AX
                Dec     DX
                Out     DX, AL

                Pop     DX
                Ret

EndP            UARTOut

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            UARTIn                  ; returns AL

                Push    DX

                Mov     DX, CS:MIDIPort
                Inc     DX

UARTIn1:
                In      AL, DX
                Test    AL, 80h
                JNZ     UARTIn1

                Dec     DX
                In      AL, DX

                Pop     DX
                Ret

EndP            UARTIn

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ESSReadMixerRegister            ; AL = register to read
                                                ; DX = 2xCh

                Add     DL, 04-0Ch
                Out     DX, AL
                Inc     DX
                In      AL, DX
                Add     DL, 0Ch-05

                Ret

EndP            ESSReadMixerRegister

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ESSReadRegister                 ; AH = register to read.
                                                ; DX = 2xCh
                                                ; returns AL

                Mov     AL, 0C0h
                Call    ESSOut
                Mov     AL, AH
                Call    ESSOut
                Call    ESSIn

                Ret

EndP            ESSReadRegister

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

SetMixModeChain:
                Call    GotoHomeDirectory

                                        ; Now to save config into driver file.
                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     AX, 3D02h       ; Read write access
                Mov     DX, Offset DriverName
                Mov     SI, Offset ConfigErrorMsg
                Int     21h
                JC      SetMixMode1

                Mov     BX, AX

                Mov     AX, 4200h
                Xor     CX, CX
                Mov     DX, Offset CONFIGURATIONOFFSET
                Int     21h
                JC      SetMixMode2

                Mov     AH, 40h
                Mov     CX, CONFIGSIZE
                Mov     DX, Offset MixMode
                Int     21h

SetMixMode2:
                PushF
                Mov     AH, 3Eh
                Int     21h
                PopF

                JC      SetMixMode1

                Mov     SI, Offset ConfigOKMsg

SetMixMode1:
                Mov     BX, 40
                Call    SetInfoLine

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

Proc            DetectCard Far

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     Forced, AL

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
                Xor     CX, CX
                Add     DL, 0Ch         ; 2xCh -> Data ready to send...

                Mov     AL, 0E1h
                Call    ESSOut2

                Call    ESSIn2
                Mov     AH, AL          ; AH = Major version number
                Call    ESSIn2          ; AL = Minor version number

                Cmp     AX, 301h
                JNE     DetectCardFailure

                Mov     AL, 0E7h
                Call    ESSOut2
                Call    ESSIn2
                Mov     AH, AL
                Call    ESSIn2

                Cmp     AH, 68h
                JNE     DetectCardReset
                Cmp     AL, 88h
                JB      DetectCardReset
                Cmp     AL, 90h
                JAE     DetectCardReset
                                        ; We have an ES1688 Audiodrive chip!

Comment ~
                Mov     AL, 40h
                Call    ESSReadMixerRegister
                ShL     AL, 1
                And     AX, 30h
                Add     AX, 300h
                Mov     MIDIPort, AX
~

                Mov     AH, 0B1h        ; IRQ determination
                Call    ESSReadRegister

                Mov     BX, 9
                And     AL, 0Ch
                JZ      DetectCardIRQ

                Mov     BX, 5
                Cmp     AL, 4
                JE      DetectCardIRQ

                Mov     BX, 7
                Cmp     AL, 8
                JE      DetectCardIRQ

                Mov     BX, 10
                Cmp     AL, 0Ch
                JNE     DetectCardFailure


DetectCardIRQ:
                Mov     IRQ, BX

                Mov     AH, 0B2h
                Call    ESSReadRegister

                Xor     BX, BX
                And     AL, 0Ch
                JZ      DetectCardFailure

                Cmp     AL, 4
                JE      DetectCardDMA

                Inc     BX
                Cmp     AL, 8
                JE      DetectCardDMA

                Add     BL, 2

DetectCardDMA:
                Mov     DMA, BX

                Mov     EAX, 'Jeff'
                ClC
                Ret

DetectCardReset:
                Sub     DL, 0Ch
                Mov     AX, DX
                Call    ResetDSP

DetectCardFailure:
                StC
                Ret


EndP            DetectCard
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            ResetDSP Far            ; AX = Port

                Push    AX
                Push    CX
                Push    DX

                Mov     DX, AX
                Add     DL, 6
                Mov     AL, 3
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

include mmxmsam.inc

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            CheckMIDI

                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Xor     BX, BX
                Call    UARTIn
                Mov     BL, [MIDIBufferTail]

                Cmp     AL, 0F0h
                JAE     CheckMIDIEnd

                Inc     BL
                Cmp     BL, MIDIBufferHead
                JE      CheckMIDIEnd

                Mov     [MIDIBuffer+BX], AL
                Mov     [MIDIBufferTail], BL

CheckMIDIEnd:
                Pop     DS
                Ret

EndP            CheckMIDI
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            ESSIRQHandler

                PushAD
                Push    DS
                Push    ES

                ClD

                Mov     AX, CS
                Mov     DS, AX
                        Assume DS:Driver

;                Inc     Debug

Comment ~
                Mov     DX, [ConfigPort]
                Add     DL, 6
                In      AL, DX
                Test    AL, 8
                JZ      ESSNoMIDI

                Push    AX
                Call    CheckMIDI
                Pop     AX

ESSNoMIDI:
                Test    AL, 1
                JZ      ESSIRQEnd
~
                Mov     DX, [BasePort]  ; ESSAck
                Add     DL, 0Eh         ; ESSAck
                In      AL, DX          ; ESSAck

                Mov     AL, 20h         ; IRQAck
                Cmp     IRQ, 8          ; IRQAck
                JB      WSSAckIRQ1      ; IRQAck
                                        ; IRQAck
                Out     0A0h, AL        ; IRQAck
                                        ; IRQAck
WSSAckIRQ1:                             ; IRQAck
                Out     20h, AL         ; IRQAck

DMAPort1 EQU $+1
                In      AL, 1
                Mov     BL, AL
DMAPort2 EQU $+1
                In      AL, 1
                Mov     BH, AL

                Xor     AX, AX

                Cmp     BX, DMABUFFERLENGTH/2
                JB      WSSIRQHandler1

                Mov     AX, DMABUFFERLENGTH/2

WSSIRQHandler1:
                FNSave  [FPSave]

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
                JNE     ESSIRQHandler4
                        Assume DS:Nothing

ESSIRQHandler3:
                Push    BX
                Push    CX
                Push    BP
                Push    ES
                Push    DI

                Call    Update
                Call    MixSamples

                Pop     DI
                Pop     ES
                Pop     BP
                Pop     CX
                Pop     BX

ESSIRQHandler4:
                Mov     DS, MixSegment
                Mov     SI, MixTransferOffset
                Mov     DX, BX          ;  DX = samples to transfer
                Cmp     DX, MixTransferRemaining
                JBE     ESSIRQHandler5

                Mov     DX, MixTransferRemaining

ESSIRQHandler5:

include mmxtrans.inc

                Sub     MixTransferRemaining, DX        ; } Memory write
                Sub     BX, DX
                JNZ     ESSIRQHandler3

                Mov     MixTransferOffset, SI           ; } Memory write

                Call    RestoreEMSPageFrame

                FNRstor [CS:FPSave]

ESSIRQEnd:
                Pop     ES
                Pop     DS
                PopAD
                IRet

EndP            ESSIRQHandler
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetIRQ

                PushAD
                Push    ES

                Xor     AX, AX
                Mov     ES, AX

                Mov     DI, IRQ
                ShL     DI, 2
                Add     DI, Offset IRQData
                Mov     BX, [CS:DI]

                Mov     AX, CS
                ShL     EAX, 16
                Mov     AX, Offset ESSIRQHandler

                XChg    [ES:BX], EAX
                Mov     OldESSIRQHandler, EAX

                Mov     AX, IMR
                And     AX, [DI+2]

                Out     21h, AL
                Mov     AL, AH
                Out     0A1h, AL

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

                Mov     DI, IRQ
                ShL     DI, 2
                Mov     BX, [IRQData+DI]

                Mov     EAX, OldESSIRQHandler
                Mov     [ES:BX], EAX

                Pop     ES
                PopAD

                Ret

EndP            ResetIRQ
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            GetESSMixConst

                PushA
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     AX, CmdLineMixSpeed
                Mov     CX, MixSpeed
                Test    AX, AX
                JZ      GetESSMixConst1

                Mov     CX, 22050
                Cmp     AX, CX
                JB      GetESSMixConst1

                Mov     CX, 56821
                Cmp     AX, CX
                JA      GetESSMixConst1

                Mov     CX, AX

GetESSMixConst1:                        ; CX = mixspeed.
                Mov     DX, 0Ch
                Mov     AX, 236Ch       ; DX:AX = 795.5kHz
                Div     CX

                Mov     BX, AX
                Neg     AL
                Mov     ESSMixConst, AL

                Mov     DX, 0Ch
                Mov     AX, 236Ch
                Div     BX
                Mov     MixSpeed, AX

                FNInit
                FILd    DWord Ptr [MixSpeed]
                FMul    FreqMultiplier
                FStP    FreqMultiplier

                Pop     DS
                PopA
                Ret

EndP            GetESSMixConst

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            StartESS

                PushA
                Push    ES
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Driver

                                ; Setup DMA
                Mov     BX, MixSegment
                Mov     AX, 80
                Mov     DX, DMA
                Mov     DI, DMABUFFERLENGTH
                Call    SetDMA

                LES     DI, ActualDMAPtr
                Xor     AX, AX
                Mov     CX, DMABUFFERLENGTH/2
                Rep     StosW

                Mov     MixBufferPos, 0
                Mov     MixTransferRemaining, 0

                Mov     AX, BasePort
                Call    ResetDSP
                Mov     DX, AX
                Add     DL, 0Ch

; Extended Functions

                Mov     AL, 0C6h
                Call    ESSOut

; Autoinit DMA

                Mov     AL, 0B8h
                Call    ESSOut
                Mov     AL, 4
                Call    ESSOut

; Stereo/Mono select

                Mov     AH, 0A8h
                Call    ESSReadRegister
                Mov     AH, AL
                Mov     AL, 0A8h
                Call    ESSOut
                Mov     AL, AH
                And     AL, Not 3
                Or      AL, 2
                Cmp     Stereo, 0
                JE      StartESS1

                Xor     AL, 3

StartESS1:
                Call    ESSOut

; DMA mode

                Mov     AL, 0B9h
                Call    ESSOut
                Mov     AL, 2
                Call    ESSOut

; Mixspeed

                Mov     AL, 0A1h
                Call    ESSOut
                Mov     AL, ESSMixConst
                Call    ESSOut

; Filter clock divider
                Mov     AL, 0A2h
                Call    ESSOut

                Mov     AL, 0FEh
                Call    ESSOut

; DMA counter
                Mov     CX, DMASize
                Neg     CX

                Mov     AL, 0A4h
                Call    ESSOut
                Mov     AL, CL
                Call    ESSOut
                Mov     AL, 0A5h
                Call    ESSOut
                Mov     AL, CH
                Call    ESSOut

; Initialise DAC
                Mov     AL, 0B6h
                Call    ESSOut
                Mov     AL, 0
                Call    ESSOut

; Configure DACs

                Mov     AL, 0B7h
                Call    ESSOut
                Mov     AL, 71h
                Call    ESSOut

                Mov     AL, 0B7h
                Call    ESSOut

                Mov     AL, 0BCh
                Cmp     Stereo, 0
                JNE     StartESS2

                Mov     AL, 0F4h

StartESS2:
                Call    ESSOut

; IRQ configuration
                Mov     AH, 0B1h
                Call    ESSReadRegister
                Mov     AH, AL
                Mov     AL, 0B1h
                Call    ESSOut
                Mov     AL, AH
                And     AL, 0Fh
                Or      AL, 50h
                Call    ESSOut

; DMA configuration
                Mov     AH, 0B2h
                Call    ESSReadRegister
                Mov     AH, AL
                Mov     AL, 0B2h
                Call    ESSOut
                Mov     AL, AH
                And     AL, 0Fh
                Or      AL, 50h
                Call    ESSOut

; Enable voice
                Mov     AL, 0D1h
                Call    ESSOut

; Start transfer
                Mov     AH, 0B8h
                Call    ESSReadRegister
                Mov     AH, AL
                Mov     AL, 0B8h
                Call    ESSOut
                Mov     AL, AH
                Or      AL, 1
                Call    ESSOut

Comment ~

; Init UART
                Mov     DX, MIDIPort
                Inc     DX
                Mov     AL, 3Fh         ; Intelligent mode.
                Out     DX, AL

; Enable MIDI IRQ
                Mov     DX, BasePort
                Add     DL, 4
                Mov     AX, 4064h
                Out     DX, AX

~

                Pop     DS
                Pop     ES
                PopA

                Ret

EndP            StartESS
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

                Mov     ECX, IdleUpdateInfoLine
                Mov     EDX, GlobalKeyList
                Mov     IdleFunctionList, ECX
                Mov     GlobalKeyLink2, EDX

                Mov     ECX, FillHeaderFunction
                Mov     EDX, DrawHeaderFunction
                Mov     FillHeader2, ECX
                Mov     ScreenHeader2, EDX

                Mov     DX, BasePort
                Add     DL, 4
                Mov     AL, 22h
                Out     DX, AL
                Inc     DX
                In      AL, DX
                Mov     AH, AL
                And     AX, 0FF0h
                ShR     AH, 1
                ShR     AL, 5
                Mov     Word Ptr [VolumeTable], AX

                Call    GetESSMixConst

                Mov     AX, 2643
                Mul     MixSpeed
                Add     AX, 0FFFFh
                AdC     DX, (DMABUFFERLENGTH*2)/16 + 5
                Mov     BX, DX

                        ; Allocate MixSegment first
                Mov     AH, 48h

                Int     21h
                JNC     InitSound1

InitSoundNoMemory:
                Mov     SI, Offset ESSNoMemoryMsg
                Ret

InitSound1:
                Mov     MixSegment, AX

                Call    SetIRQ
                Call    GetTempo
                Call    SetTempo

                Mov     SI, Offset ESSMsg

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

                Call    ResetIRQ
                Call    SetIRQ

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

                Push    CS
                Pop     DS
                        Assume DS:Driver

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

                Mov     AX, BasePort
                Call    ResetDSP
                Call    ResetIRQ

UnInitSound1:
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

                Push    CS
                Pop     DS
                        Assume DS:Driver
;
;DMAPort1 EQU $+1
;                In      AL, 1
;                Mov     BL, AL
;DMAPort2 EQU $+1
;                In      AL, 1
;                Mov     BH, AL
;
;                Mov     Debug2, BX

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

                Mov     CS:Stereo, AL
                Cmp     CS:MixSegment, 0
                JE      SetStereo1

                Mov     AX, BasePort
                Call    ResetDSP
                Call    StartESS

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
                Mov     DX, Offset ESSScreenList

                ClC
                Ret

EndP            SoundCardScreen

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            GetVariable Far

                Xor     AH, AH
                Mov     AL, [CS:VolumeTable+DI]
                Ret

EndP            GetVariable

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetVariable Far

                Push    DS
                Push    DX

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     [VolumeTable+DI], AL

                Mov     DX, BasePort
                Add     DL, 4
                Mov     AL, 22h
                Out     DX, AL
                Mov     AH, [VolumeTable]
                ShL     AH, 4
                Or      AH, [VolumeTable+1]
                ShL     AH, 1
                Out     DX, AX

                Pop     DX
                Pop     DS
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

StopAfterPlay           DW      0
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
