;
; Windows Sound System Driver, with GUS PnP detection, MMX mixing.
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
MIXRESOLUTION   EQU     32      ; 32 bit mixing for
OUTPUTFILTERENABLED EQU 0

FPSave          DB      128 Dup (0)

DMASize         DW      2048

WSSMsg          DB      "GUS CS4231 Codec MMX", 13
                DB      "Port ", 0FDh, "Xh, IRQ ", 0FDh, "D, DMA ", 0FDh, "D", 0

WSSNoMemoryMsg  DB      "GUS CS4231 Codec MMX", 13
                DB      "Error: Insufficient memory", 0

ReinitMsg       DB      "GUS CS4231 Codec reinitialised", 0

DriverName      DB      "ITGUSMAX.MMX", 0

Forced          DB      0
Stereo          DB      0
MixVolume       DW      0

BytesToMix      DW      1000
WSSMixConst     DB      0

MixSegment      DW      0

MixTransferOffset       DW      0
MixTransferRemaining    DW      0

CONFIGURATIONOFFSET     EQU     $+128
CONFIGSIZE              EQU     4
MixMode                 DW      0
MixModeOffset           DW      0

IMR                     DW      0
OldWSSIRQHandler        DD      0

MixSpeedTable   DW      5513,  41h
                DW      6615,  4Fh
                DW      8000,  40h
                DW      9600,  4Eh
                DW      11025, 43h
                DW      16000, 42h
                DW      18900, 45h
                DW      22050, 47h
                DW      27429, 44h
                DW      32000, 46h
                DW      33075, 4Dh
                DW      37800, 49h
                DW      44100, 4Bh
                DW      48000, 4Ch
                DW      54860, 48h
                DW      64000, 4Ah

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
; WSS Registers
;**********************************

CODEC_INDEX_LIC         =       00
CODEC_INDEX_RIC         =       01h
CODEC_INDEX_LX1C        =       02h
CODEC_INDEX_RX1C        =       03h
CODEC_INDEX_LX2C        =       04h
CODEC_INDEX_RX2C        =       05h
CODEC_INDEX_LDC         =       06h
CODEC_INDEX_RDC         =       07h
CODEC_INDEX_CDF         =       08h
CODEC_INDEX_INTF        =       09h
CODEC_INDEX_PIN         =       0Ah
CODEC_INDEX_TEST        =       0Bh
CODEC_INDEX_MISC        =       0Ch
CODEC_INDEX_DIGMIX      =       0Dh
CODEC_INDEX_UPR_COUNT   =       0Eh
CODEC_INDEX_LWR_COUNT   =       0Fh

CODEC_MCE               =       40h

LDC_LDM                 =       80h
LDC_LDA                 =       3Fh

RDC_RDM                 =       80h
RDC_RDA                 =       3Fh

CDF_STEREO              =       10h

INTF_PEN                =       01h
INTF_CEN                =       02h
INTF_SDC                =       04h
INTF_ACAL               =       08h
INTF_PPIO               =       40h
INTF_CPIO               =       80h

PIN_IEN                 =       2

TEST_ORL                =       03h
TEST_ORR                =       0Ch
TEST_DRS                =       10h
TEST_ACI                =       20h
TEST_PUR                =       40h
TEST_COR                =       80h

;**********************************

WSS16ScreenList          Label
                        DW      12
                        DW      Near Ptr IdleFunctionList
                        DW      Near Ptr GlobalKeyLink

                        DW      Near Ptr FullScreenBox  ; 0
                        DW      Near Ptr ScreenHeader
                        DW      Near Ptr FillHeader
                        DW      Near Ptr WSSHeaderLine

                        DW      Near Ptr DriverText

                        DW      Near Ptr MixModeText
                        DW      Near Ptr MixModeButton1         ; 6
                        DW      Near Ptr MixModeButton2         ;
                        DW      Near Ptr MixModeButton3         ; 8
                        DW      Near Ptr MixModeButton4         ; 9

                        DW      Near Ptr VolumeText
                        DW      Near Ptr VolumeBox1

                        DW      Near Ptr MasterVolumeLeft       ; 12
                        DW      Near Ptr MasterVolumeRight      ; 13

                        DW      0


WSSHeaderLine           DW      10
                        DB      "GUS CS4231 Codec MMX Driver", 0

DriverText              DW      1
                        DB      28, 48
                        DB      21h
                        DB      "GUS CS4231 Codec MMX Driver 1.0 for Impulse Tracker", 0

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

VolumeText              DW      1
                        DB      2, 14
                        DB      20h
                        DB      "Master Volume Left", 13
                        DB      "Master Volume Right"
                        DB      0

VolumeBox1              DW      0
                        DB      21, 13, 31, 16
                        DB      25

MasterVolumeLeft        DW      9
                        DB      22, 14
                        DW      0, 63
                        DW      9, 0
                        DW      0FFFFh, 13, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh

MasterVolumeRight       DW      9
                        DB      22, 15
                        DW      0, 63
                        DW      9, 1
                        DW      12, 6, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh

MixModeText             DW      1
                        DB      2, 18
                        DB      20h
                        DB      "Mixing Mode, Playback Frequency: ", 0FDh, "DHz", 0
MixSpeed                DW      48000
                        DW      0

MixModeButton1          DW      2
                        DW      13, 7, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetMixMode
DriverSegment1          DW      0
                        DW      0
                        DW      Offset SetMixMode
DriverSegment2          DW      0
                        DB      3, 20, 32, 22, 8
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
                        DB      3, 23, 32, 25, 8
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
                        DB      3, 26, 32, 28, 8
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
                        DB      3, 29, 32, 31, 8
                        DB      0
                        DB      "  MMX, Filtered", 0

VolumeTable             DB      2 Dup (56)

; 컴 MixingRoutines 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

MixBufferPos            DW      0

include dma.inc
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

Proc            WaitCoDec

                Push    CX

                Mov     CX, 0F000h

WaitCoDec1:
                In      AL, DX
                Test    AL, AL
                JNS     WaitCoDec2
                Loop    WaitCoDec1

                StC

WaitCoDec2:
                Pop     CX
                Ret

EndP            WaitCoDec

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            WaitAutoCalibration

                Push    CX
                Mov     CX, 0F000h

WaitAutoCalibration1:
                Mov     AL, CODEC_INDEX_TEST
                Out     DX, AL
                Inc     DX
                In      AL, DX
                Dec     DX
                Test    AL, TEST_ACI
                JNZ     WaitAutoCalibration2
                Loop    WaitAutoCalibration1

                StC

WaitAutoCalibration2:
                Pop     CX
                Ret

EndP            WaitAutoCalibration

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetMixMode Far

                Trace   "GUSPnP MMX: SetMixMode"

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

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            GetWSSMixConst                  ; Work out value.. and nearest
                                                ; mixspeed value.

                PushA
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     AX, CmdLineMixSpeed
                Mov     CX, MixSpeed
                Test    AX, AX
                JZ      GetWSSMixConst1

                Mov     CX, 64000
                Cmp     AX, CX
                JA      GetWSSMixConst1

                Mov     CX, 8000
                Cmp     AX, CX
                JB      GetWSSMixConst1

                Mov     CX, AX

GetWSSMixConst1:                        ; CX = desired mixspeed
                Mov     SI, Offset MixSpeedTable
                Mov     DX, 16          ; 14 different available speeds

                Xor     BX, BX

GetWSSMixConst2:
                LodsW
                Cmp     AX, BX
                JB      GetWSSMixConst3
                Cmp     AX, CX
                JA      GetWSSMixConst3

                Mov     BX, AX
                Mov     DH, [SI]

GetWSSMixConst3:
                LodsW                           ; Add SI, 2
                Dec     DL
                JNZ     GetWSSMixConst2

                Mov     MixSpeed, BX
                Mov     WSSMixConst, DH

                FNInit
                FILd    DWord Ptr [MixSpeed]
                FMul    FreqMultiplier
                FStP    FreqMultiplier


                Pop     DS
                PopA
                Ret

EndP            GetWSSMixConst
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            PingWSS                 ; Check BasePort, DX = BasePort
                                        ; Preserves DX, destroys AX

                Push    DX

                Inc     DX
                Inc     DX

                In      AL, DX
                Xor     AL, AL
                Out     DX, AL

                Dec     DX
                Dec     DX
                Call    WaitCodec
                JC      PingWSSFailure

                In      AL, DX
                Test    AL, AL
                JS      PingWSSFailure

                Mov     AL, CODEC_INDEX_MISC
                Out     DX, AL
                Inc     DX              ; DX = Data port
                In      AL, DX
                Mov     AH, AL          ; AH = Revision

                Xor     AL, AL          ; Write 0 revision
                Out     DX, AL
                In      AL, DX
                And     AX, 8F8Fh
                Cmp     AL, AH
                JNE     PingWSSFailure
                Dec     DX              ; DX = AD1848 baseport

                Mov     AL, CODEC_MCE or CODEC_INDEX_INTF
                Out     DX, AL
                Inc     DX
                Mov     AL, INTF_ACAL or INTF_SDC
                Out     DX, AL
                Dec     DX

                Mov     AL, CODEC_INDEX_INTF
                Out     DX, AL
                Inc     DX
                Mov     AL, INTF_ACAL or INTF_SDC
                Out     DX, AL
                Dec     DX

                Call    WaitAutoCalibration     ; Returns carry if error
                                                ; Carry clear if none.

;                JC      PingWSSFailure

                Pop     DX
                Ret

PingWSSFailure:
                Pop     DX

                StC
                Ret


EndP            PingWSS

; 컴 DetectCard 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Returns carry set if error, else carry clear. Has to setup internal vars
; (eg. appropriate IRQ/DMA whatever).
;
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

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            DetectCard Far          ; returns carry clear if succesful

                Push    CS
                Pop     DS

                Call    DetectMMX
                JC      DetectWSSFailure

                Cmp     IRQ, 0FFFFh
                JE      DetectWSSFailure
                Cmp     DMA, 0FFFFh
                JE      DetectWSSFailure

                Mov     DX, BasePort
                Cmp     DX, 0FFFFh
                JE      DetectCardFindBasePort

                Call    PingWSS
                JNC     CheckWSSOK

DetectWSSFailure:
                StC
                Ret

DetectCardFindBasePort:
                Mov     DX, 31Ch
                Call    PingWSS
                JNC     DetectWSSOK

                Mov     DX, 32Ch
                Call    PingWSS
                JNC     DetectWSSOK

                Mov     DX, 33Ch
                Call    PingWSS
                JNC     DetectWSSOK

                Mov     DX, 34Ch
                Call    PingWSS
                JNC     DetectWSSOK

                Mov     DX, 35Ch
                Call    PingWSS
                JNC     DetectWSSOK

                Mov     DX, 36Ch
                Call    PingWSS
                JNC     DetectWSSOK

                Mov     DX, 530h
                Call    PingWSS
                JNC     DetectWSSOK

                Mov     DX, 604h
                Call    PingWSS
                JNC     DetectWSSOK

                Mov     DX, 0F40h
                Call    PingWSS
                JNC     DetectWSSOK

                Mov     DX, 0E80h
                Call    PingWSS
                JC      DetectWSSFailure

DetectWSSOK:
                Mov     BasePort, DX

CheckWSSOK:                             ; Check for IRQ
                Mov     AL, CODEC_INDEX_RDC
                Out     DX, AL
                Inc     DX
                In      AL, DX
                Mov     AH, AL
                Dec     DX

                Mov     AL, CODEC_INDEX_LDC
                Out     DX, AL
                Inc     DX
                In      AL, DX
                And     AX, 3F3Fh
                Neg     AL
                Neg     AH
                Add     AL, 3Fh
                Add     AH, 3Fh
                Mov     [Word Ptr VolumeTable], AX

                Mov     EAX, 'Jeff'
                ClC
                Ret

EndP            DetectCard
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

include mmxmsam.inc

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            WSSIRQHandler

                PushAD
                Push    DS
                Push    ES

                ClD

                Mov     AX, CS
                Mov     DS, AX
                        Assume DS:Driver

                Mov     DX, [BasePort]
                Add     DX, 2
                In      AL, DX
                Test    AL, 1
                JZ      WSSAckIRQ2

                Xor     AL, AL
                Out     DX, AL

WSSAckIRQ2:
                Mov     AL, 20h
                Cmp     IRQ, 8
                JB      WSSAckIRQ1

                Out     0A0h, AL

WSSAckIRQ1:
                Out     20h, AL

                FNSave  [FPSave]

                Mov     AX, MixBufferPos
                Mov     BX, AX
                Mul     DMASize
                Cmp     AX, DMABUFFERLENGTH
                JB      WSSIRQHandler2

                Xor     AX, AX
                Xor     BX, BX

WSSIRQHandler2:
                Inc     BX
                Mov     MixBufferPos, BX

                CLD

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
                JNE     WSSIRQHandler4
                        Assume DS:Nothing

WSSIRQHandler3:
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

WSSIRQHandler4:
                Mov     DS, MixSegment
                Mov     SI, MixTransferOffset
                Mov     DX, BX          ;  DX = samples to transfer
                Cmp     DX, MixTransferRemaining
                JBE     WSSIRQHandler5

                Mov     DX, MixTransferRemaining

WSSIRQHandler5:

include mmxtrans.inc

                Sub     MixTransferRemaining, DX        ; } Memory write
                Sub     BX, DX
                JNZ     WSSIRQHandler3

                Mov     MixTransferOffset, SI           ; } Memory write

                Call    RestoreEMSPageFrame

                FNRstor [CS:FPSave]

                Pop     ES
                Pop     DS
                PopAD
                IRet

EndP            WSSIRQHandler
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
                Mov     AX, Offset WSSIRQHandler

                XChg    [ES:BX], EAX
                Mov     OldWSSIRQHandler, EAX

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

                Mov     EAX, OldWSSIRQHandler
                Mov     [ES:BX], EAX

                Pop     ES
                PopAD

                Ret

EndP            ResetIRQ
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            StopWSS

                Trace   "GUSPnP MMX: StopSound"

                Mov     DX, BasePort

                Mov     AL, CODEC_INDEX_INTF
                Out     DX, AL
                Inc     DX
                In      AL, DX
                And     AL, Not INTF_PEN
                Out     DX, AL

                Inc     DX
                In      AL, DX
                Xor     AL, AL
                Out     DX, AL

                Dec     DX
                Dec     DX

                Mov     AL, CODEC_INDEX_PIN
                Out     DX, AL
                Inc     DX
                Xor     AL, AL
                Out     DX, AL

                Ret

EndP            StopWSS

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            StartWSS

                PushA
                Push    ES
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Trace   "GUSPnP MMX: StartSound"

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

                Mov     DX, BasePort
                Call    PingWSS

                Mov     AL, CODEC_INDEX_PIN
                Out     DX, AL
                Inc     DX
                Mov     AL, PIN_IEN
                Out     DX, AL
                Dec     DX

                Mov     AH, WSSMixConst         ; Set format/frequency
                Cmp     Stereo, 0
                JE      StartWSS1

                Or      AH, CDF_STEREO

StartWSS1:
                Mov     AL, CODEC_MCE or CODEC_INDEX_CDF
                Out     DX, AL
                Inc     DX
                Mov     AL, AH
                Out     DX, AL
                Dec     DX

                Call    WaitCodec

                Mov     AL, CODEC_INDEX_CDF
                Out     DX, AL
                Inc     DX
                Mov     AL, AH
                Out     DX, AL
                Dec     DX

                Call    WaitAutoCalibration

                                                ; Start playback
                Mov     AL, CODEC_INDEX_LWR_COUNT
                Out     DX, AL
                Inc     DX

                Mov     AX, DMASize
                ShR     AX, 1

                Cmp     Stereo, 0
                JE      StartWSS2

                ShR     AX, 1

StartWSS2:
                Dec     AX
                Out     DX, AL
                Dec     DX

                Mov     AL, CODEC_INDEX_UPR_COUNT
                Out     DX, AL
                Inc     DX
                Mov     AL, AH
                Out     DX, AL
                Dec     DX

                Mov     AL, CODEC_INDEX_INTF
                Out     DX, AL
                Inc     DX
                In      AL, DX
                Or      AL, INTF_PEN
                Out     DX, AL
                Dec     DX

                Mov     AL, CODEC_INDEX_LDC
                Out     DX, AL
                Inc     DX
                In      AL, DX
                And     AL, Not LDC_LDM
                Out     DX, AL
                Dec     DX

                Mov     AL, CODEC_INDEX_RDC
                Out     DX, AL
                Inc     DX
                In      AL, DX
                And     AL, Not RDC_RDM
                Out     DX, AL
                Dec     DX

                Pop     DS
                Pop     ES
                PopA

                Ret

EndP            StartWSS
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

                Trace   "GUSPnP MMX: InitSound"

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

                Call    GetWSSMixConst

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
                Mov     SI, Offset WSSNoMemoryMsg
                Ret

InitSound1:
                Mov     MixSegment, AX

                Call    SetIRQ
                Call    GetTempo
                Call    SetTempo

                Call    UpdateSoundcardVariables

                Mov     SI, Offset WSSMsg

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

                Call    StopWSS
                Call    ResetIRQ

UnInitSound1:
                Call    GotoHomeDirectory

                                        ; Now to save config into driver file.
                Mov     AX, 3D02h       ; Read write access
                Mov     DX, Offset DriverName
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
                Mov     AH, 3Eh
                Int     21h

SetMixMode1:
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

                Ret

EndP            Poll

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

Proc            RecalculateAllFrequencies

                Call    GetChannelTables

RecalculateAllFrequencies1:
                Or      Byte Ptr [SI], 32

                Add     SI, 128
                Dec     CX
                JNZ     RecalculateAllFrequencies1

                Ret

EndP            RecalculateAllFrequencies

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetStereo Far

                Trace   "GUSPnP MMX: SetStereoCall"

                Mov     CS:Stereo, AL
                Cmp     CS:MixSegment, 0
                JE      SetStereo1

                Call    StopWSS
                Call    StartWSS

                Call    RecalculateAllFrequencies

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
                Mov     DX, Offset WSS16ScreenList

                Trace   "GUSPnP MMX: Driver Screen"

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

Proc            UpdateSoundcardVariables

                Push    AX DX

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     DX, BasePort

                Mov     AL, CODEC_INDEX_LDC
                Out     DX, AL
                Inc     DX
                Mov     AX, 3F3Fh
                Sub     AX, [Word Ptr VolumeTable]
                Out     DX, AL
                Dec     DX

                Mov     AL, CODEC_INDEX_RDC
                Out     DX, AL
                Inc     DX
                Mov     AL, AH
                Out     DX, AL
                Dec     DX

                Pop     DX AX
                Ret

EndP            UpdatesoundcardVariables
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetVariable Far

                Push    DS
                Push    DX

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     [VolumeTable+DI], AL
                Call    UpdateSoundcardVariables

                Pop     DX
                Pop     DS
                Ret

EndP            SetVariable
                Assume DS:Nothing

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
