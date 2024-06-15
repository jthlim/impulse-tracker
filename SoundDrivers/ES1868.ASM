;
; ESS Technology's ES1868 AudioDrive chip.
;
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

;**********************************

PNPSERIALID     EQU     0FFFFFFFFh
PNPVENDORID     EQU     68187316h

STEREOENABLED   EQU     1
DMABUFFERLENGTH EQU     8192
MIXRESOLUTION   EQU     32      ; 32 bit mixing for
MIXTABLESIZE    EQU     2*256*65

ESSMsg          DB      "ESS ES1868 AudioDrive found", 13
                DB      "Port ", 0FDh, "Xh, IRQ ", 0FDh, "D, DMA ", 0FDh, "D", 0

ESSNoMemoryMsg  DB      "ESS ES1868 AudioDrive found", 13
                DB      "Error: Insufficient memory", 0

ReinitMsg       DB      "ESS ES1868 AudioDrive reinitialised", 0

ConfigErrorMsg  DB      "Error saving configuration to ITES1868.DRV", 0
ConfigOKMsg     DB      "Configuration saved to ITES1868.DRV", 0

DriverName      DB      "ITES1868.DRV", 0

ALIGN 4
FilterValue             DD      0
FilterValue2            DD      0
ESSMixConst     DB      0, 0

DMASize         DW      2048    ; Smaller gives better MIDI timing
ConfigPort      DW      0

Forced          DB      0
Stereo          DB      0
MixVolume       DW      0

BytesToMix      DW      1000

MixSegment      DW      0
DMASegment      DW      0

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

                        DW      Near Ptr FilterText
                        DW      Near Ptr FilterButton1          ; 11
                        DW      Near Ptr FilterButton2
                        DW      Near Ptr FilterButton3

Comment ~

                        DW      Near Ptr VolumeText
                        DW      Near Ptr VolumeBox1

                        DW      Near Ptr MasterVolumeLeft       ; 16
                        DW      Near Ptr MasterVolumeRight      ; 17

~

                        DW      0

ESSHeaderLine           DW      10
                        DB      "ESS ES1868 AudioDrive Driver", 0

EmptyObject             DW      1
                        DB      0, 0
                        DB      0
                        DB      0

DriverText              DW      1
                        DB      26, 48
                        DB      21h
                        DB      "ESS ES1868 AudioDrive Driver 1.0 for Impulse Tracker", 0

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
MixSpeed        DW      44100

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
                        DB      "  16 Bit, Non-Interpolated", 0

MixModeButton2          DW      2
                        DW      6, 8, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetMixMode
DriverSegment3          DW      0
                        DW      2
                        DW      Offset SetMixMode
DriverSegment4          DW      0
                        DB      3, 19, 32, 21, 8
                        DB      0
                        DB      "  16 Bit, Interpolated", 0

MixModeButton3          DW      2
                        DW      7, 9, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetMixMode
DriverSegment5          DW      0
                        DW      4
                        DW      Offset SetMixMode
DriverSegment6          DW      0
                        DB      3, 22, 32, 24, 8
                        DB      0
                        DB      "  32 Bit, Non-Interpolated", 0

MixModeButton4          DW      2
                        DW      8, 11, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetMixMode
DriverSegment7          DW      0
                        DW      6
                        DW      Offset SetMixMode
DriverSegment8          DW      0
                        DB      3, 25, 32, 27, 8
                        DB      0
                        DB      "  32 Bit, Interpolated", 0

FilterText              DW      1
                        DB      2, 29
                        DB      20h
                        DB      "Filter mode", 0

FilterButton1           DW      2
                        DW      9, 12, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetFilter
DriverSegment9          DW      0
                        DW      0
                        DW      Offset SetFilter
DriverSegment10         DW      0
                        DB      3, 31, 29, 33, 8
                        DB      0
                        DB      "  No Filter", 0

FilterButton2           DW      2
                        DW      11, 13, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetFilter
DriverSegment11         DW      0
                        DW      1
                        DW      Offset SetFilter
DriverSegment12         DW      0
                        DB      3, 34, 29, 36, 8
                        DB      0
                        DB      "  50% Filter", 0

FilterButton3           DW      2
                        DW      12, 0FFFFh, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetFilter
DriverSegment13         DW      0
                        DW      2
                        DW      Offset SetFilter
DriverSegment14         DW      0
                        DB      3, 37, 29, 39, 8
                        DB      0
                        DB      "  75% Filter", 0

ALIGN 4

VolumeTable             DB      2 Dup (0)
MIDIPort                DW      0

MIDIBuffer              DB      256 Dup (0)
MIDIBufferHead          DB      0
MIDIBufferTail          DB      0

; 컴 MixingRoutines 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

MixBufferPos            DW      0

include dma.inc
include mix.inc
include m12bit.mix
include m12biti.mix
include m32bit.mix
include m32biti.mix

MixFunctionTables       Label

include m12bit.inc      ; contains the tables
include m12biti.inc
include m32bit.inc
include m32biti.inc

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

RelocationTable         Label   Word
        DW      Offset DriverSegment1, Offset DriverSegment2
        DW      Offset DriverSegment3, Offset DriverSegment4
        DW      Offset DriverSegment5, Offset DriverSegment6
        DW      Offset DriverSegment7, Offset DriverSegment8
        DW      Offset DriverSegment9, Offset DriverSegment10
        DW      Offset DriverSegment11, Offset DriverSegment12
        DW      Offset DriverSegment13, Offset DriverSegment14
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

Proc            GetFilter Far

                Push    CS
                Pop     ES
                Mov     DI, Offset Filter

                Ret

EndP            GetFilter

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetFilter Far

                Mov     AX, [SI+22]
                Mov     CS:FilterValue, 0
                Mov     CS:Filter, AX
                ClI
                Jmp     SetMixModeChain

EndP            SetFilter

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetMixMode Far

                Mov     AX, [SI+22]

                ClI

                Mov     CS:MixMode, AX

                Mov     BX, 180
                Mul     BX
                Mov     CS:MixModeOffset, AX

                Mov     DS, Word Ptr [CS:RecalculateAllVolumes+2]
                Call    CS:RecalculateAllVolumes

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

PnP_SerialID            DD      0
PnP_VendorID            DD      0
PnP_ReadPort            DW      0
PnP_CSN                 DB      0
PnP_CardFound           DB      0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            PnP_Delay
                Assume DS:Driver

                Push    AX CX

                Mov     CX, 180h
PnP_Delay1:
                In      AL, 21h
                Loop    PnP_Delay1

                Pop     CX AX
                Ret

EndP            PnP_Delay

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            PnP_WriteData

                Mov     DX, 279h
                Out     DX, AL

                Mov     AL, AH
                Mov     DH, 0Ah
                Out     DX, AL
                Ret

EndP            PnP_WriteData

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            PnP_ReadData

                Mov     DX, 279h
                Out     DX, AL

                Mov     DX, PnP_ReadPort
                In      AL, DX

                Ret

EndP            PnP_ReadData

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            PnP_Isolate

                Mov     AX, 402h
                Call    Pnp_WriteData   ; Reset CSNs

PnP_IsolateNextCard:
                Mov     AX, 0003h
                Call    PnP_WriteData   ; Wake[0]

                Mov     AX, PnP_ReadPort
                ShL     AX, 6
                Xor     AL, AL
                Call    PnP_WriteData   ; Set Read Data port.

                Call    PnP_Delay
                Call    PnP_Delay
                Call    PnP_Delay
                Call    PnP_Delay

                Mov     AL, 1           ; Serial Isolation
                Mov     DX, 279h
                Out     DX, AL

                Call    PnP_Delay
                Call    PnP_Delay
                Call    PnP_Delay
                Call    PnP_Delay

                Mov     BL, 6Ah
                Mov     CX, 64
                Mov     DX, PnP_ReadPort

                ClI

PnP_Isolate1:
                ShR     PnP_SerialID, 1
                RCR     PnP_VendorID, 1

                Mov     BH, BL
                ShR     BH, 1
                Xor     BH, BL
                ShR     BX, 1
                                
                In      AL, DX
                Mov     AH, AL
                Call    PnP_Delay
                In      AL, DX
                Call    PnP_Delay

                Cmp     AX, 55AAh
                JNE     PnP_Isolate2

                Xor     BL, 80h
                Or      PnP_SerialID, 80000000h

PnP_Isolate2:
                Dec     CX
                JNZ     PnP_Isolate1

                Mov     CX, 8
                Xor     BH, BH

PnP_Isolate3:
                ShR     BH, 1

                In      AL, DX
                Mov     AH, AL
                Call    PnP_Delay
                In      AL, DX
                Call    PnP_Delay
                Cmp     AX, 55AAh
                JNE     PnP_Isolate4

                Or      BH, 80h

PnP_Isolate4:
                Dec     CX
                JNZ     PnP_Isolate3

                StI

                Cmp     BL, BH                  ; Matching Checksum?
                JNE     PnP_IsolateFinished

                                ; assign CSN
                Inc     PnP_CSN

                Mov     AL, 6
                MOv     AH, PnP_CSN
                Call    PnP_WriteData

;                Cmp     PnP_VendorID, PNPVENDORID
;                JNE     PnP_IsolateNextCard
                Cmp     PnP_SerialID, PNPSERIALID
                JNE     PnP_IsolateNextCard

                Mov     AL, 3
                Call    PnP_WriteData

                Mov     AX, 07h                 ; Configuration device
                Call    PnP_WriteData

                Mov     AL, 60h
                Call    PnP_ReadData
                Mov     AH, AL
                Mov     AL, 61h
                Call    PnP_ReadData    ; AX = address.
                Mov     ConfigPort, AX

                Mov     AX, 107h                ; Audio device
                Call    PnP_WriteData

                Mov     AL, 64h
                Call    PnP_ReadData
                Mov     AH, AL
                Mov     AL, 65h
                Call    PnP_ReadData    ; AX = address.
                Mov     MIDIPort, AX

                Mov     AL, 60h
                Call    PnP_ReadData
                Mov     AH, AL
                Mov     AL, 61h
                Call    PnP_ReadData    ; AX = address.
                Cmp     BasePort, 0FFFFh
                JE      PnPBasePortOK

                Cmp     BasePort, AX
                JNE     PnP_IsolateNextCard

PnPBasePortOK:
                Mov     BasePort, AX

                Mov     AL, 70h
                Call    PnP_ReadData    ; AL[3:0] = IRQ
                And     AX, 15
                JZ      PnP_IsolateNextCard
                Mov     IRQ, AX

                Mov     AL, 74h
                Call    PnP_ReadData    ; AL[2:0] = DMA
                And     AX, 7
                Cmp     AL, 4
                JE      PnP_IsolateNextCard
                Mov     DMA, AX

                Mov     Pnp_CardFound, 1
                Jmp     PnP_IsolateNextCard

PnP_IsolateFinished:
                Mov     AL, PnP_CSN
                ShL     AL, 1
                Or      AL, PnP_CardFound

                Ret

EndP            PnP_Isolate

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            DetectCard Far          ; returns carry clear if succesful

                Push    CS
                Pop     DS

                Xor     AL, AL
                Mov     DX, 279h
                Out     DX, AL
                Out     DX, AL

                Mov     AL, 6Ah         ; Starting value
                Mov     CX, 32

PnP_InitiationKeyLoop:
                Out     DX, AL

                Mov     AH, AL
                ShR     AH, 1
                Xor     AH, AL
                ShR     AX, 1

                Dec     CX
                JNZ     PnP_InitiationKeyLoop

; Try three ports before concluding no PnP cards: 20Fh, 27Bh, 213h

PnP_DetectCardPort1:
                Mov     PnP_ReadPort, 20Fh
                Call    PnP_Isolate
                JZ      PnP_DetectCardPort2
                Test    AL, 1
                JZ      PnP_DetectCardNotFound
                Jmp     PnP_DetectCardFound

PnP_DetectCardPort2:
                Mov     PnP_ReadPort, 27Bh
                Call    PnP_Isolate
                JZ      PnP_DetectCardPort3
                Test    AL, 1
                JZ      PnP_DetectCardNotFound
                Jmp     PnP_DetectCardFound

PnP_DetectCardPort3:
                Mov     PnP_ReadPort, 213h
                Call    PnP_Isolate
                Test    AL, 1
                JNZ     PnP_DetectCardFound

PnP_DetectCardNotFound:
                StC
                Jmp     PnP_DetectEnd

PnP_DetectCardFound:
                ClC

PnP_DetectEnd:                  ;  Return PnP to wait for key state
                Mov     AX, 202h
                Call    PnP_WriteData
                Mov     EAX, 'Jeff'

                Ret

EndP            DetectCard
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            ResetDSP Far            ; AX = Port

                Push    AX
                Push    CX
                Push    DX

                Mov     DX, CS:MIDIPort
                Inc     DX
                Mov     AL, 0FFh
                Out     DX, AL

                Mov     DX, CS:BasePort
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

MixModeTable    Label   Word
        DW      Offset Mix0ModeMono, Mix0ModeStereo
        DW      Offset Mix0ModeMono, Mix0ModeStereo
        DW      Offset Mix6ModeMono, Mix6ModeStereo
        DW      Offset Mix6ModeMono, Mix6ModeStereo

Proc            MixSamples      ; Given DS:SI = info tables, CX = numchannels

                                ; 1. Clean buffer
                                ;    + update variables
                                ; 2. Update parameters
                                ; 3. Mix func
                                ; 4. Return

                Push    CX

                Mov     CX, BytesToMix
                Mov     ES, MixSegment
                Mov     DI, MIXTABLESIZE
                Xor     EAX, EAX
                Mov     DX, CX
                Add     CX, CX

                Mov     MixTransferOffset, DI           ; } Memory write

                Cmp     Stereo, 0
                JE      MixSamples1

                Mov     DX, CX

MixSamples1:
                Rep     StosD                           ; } Memory write
                Mov     MixTransferRemaining, DX        ; }

                Pop     CX

MixSamples2:
                Test    Byte Ptr [SI], 1
                JZ      MixSamplesEnd2
                Cmp     Byte Ptr [SI+36h], 100
                JE      MixSamplesEnd2

                Push    CX
                Mov     CX, [SI]

                Test    CH, 2
                JZ      MixSamples3
                And     Byte Ptr [SI], Not 1

                Jmp     MixSamplesEnd
;                Cmp     MixMode, 8              ; Is it volume ramping?
;                JB      MixSamplesEnd

MixSamples3:
                Test    CL, 20h         ; New freq?
                JZ      MixSamples5

                Mov     AX, [SI+10h]
                Mov     DX, [SI+12h]
                Mov     BX, MixSpeed
                Cmp     DX, BX
                JAE     MixSamplesHandleError

                Div     BX
                ShL     EAX, 16
                Xor     AX, AX
                Div     BX
                Mov     STEPVALUE, EAX

MixSamples4:
                Test    CH, 1
                JZ      MixSamples5

                Mov     DWord Ptr [SI+1Ch], 0           ; Current Volume = 0
                                                        ; for volume sliding.
MixSamples5:
                Test    CX, 8440h               ; New volume or panning?
                JZ      MixSamplesMix

                Xor     AX, AX
                Test    CH, 8                   ; Muted?
                JNZ     MixModeCommon

                Mov     BX, MixMode
                Add     BL, Stereo
                Add     BX, BX
                Jmp     [CS:MixModeTable+BX]

Mix0Mode:                       ;     16-bit mixing, no interpolation
Mix0ModeMono:                   ; and 16-bit mixing, interpolation
                Mov     AL, [SI+20h]
                ShR     AL, 1
                Mov     [SI+0Ch], AX
                Mov     [SI+0Eh], AX
                Mov     AX, 0
                JZ      MixModeCommon
                Mov     AL, 30          ; Use left only-mixing for mono
                Jmp     MixModeCommon

Mix0ModeStereo:
                Mov     AL, [SI+37h]            ; Final pan
                Cmp     AL, 100
                JE      Mix0ModeSurround

                Mul     Byte Ptr [SI+20h]       ; Final volume
                Add     AX, 64
                ShR     AX, 7
                Mov     [SI+0Ch], AX            ; Store into right volume

                Mov     AL, 64
                Sub     AL, [SI+37h]
                Mul     Byte Ptr [SI+20h]
                Add     AX, 64
                ShR     AX, 7
                Mov     [SI+0Eh], AX            ; Left volume

                Mov     CH, AL                  ; CH = left volume
                Mov     CL, [SI+0Ch]            ; CL = right volume
                Mov     AX, 0

                Test    CX, CX
                JZ      MixModeCommon

                Mov     AL, 30                  ; Left only...
                Test    CL, CL
                JZ      MixModeCommon

                Mov     AL, 60
                Test    CH, CH
                JZ      MixModeCommon

                Mov     AL, 90
                Cmp     CL, CH
                JZ      MixModeCommon

                Mov     AL, 120
                Jmp     MixModeCommon

Mix0ModeSurround:
                Mov     AL, [SI+20h]
                ShR     AL, 2
                Mov     [SI+0Ch], AX
                Mov     [SI+0Eh], AX
                Mov     AX, 0
                JZ      MixModeCommon
                Mov     AL, 150                 ; Surround
                Jmp     MixModeCommon

Mix6ModeMono:
                Mov     AX, [SI+4Ah]
                Mul     MixVolume
                ShRD    AX, DX, 8
                Mov     [SI+0Ch], AX
                Mov     [SI+0Eh], AX
                Test    AX, AX
                JZ      MixModeCommon
                Mov     AX, 30
                Jmp     MixModeCommon

Mix6ModeStereo:
                Mov     AL, [SI+37h]            ; Final pan
                Cmp     AL, 100
                JE      Mix6ModeSurround

                Mul     Byte Ptr MixVolume
                Mul     Word Ptr [SI+4Ah]
                ShRD    AX, DX, 14
                Mov     [SI+0Ch], AX            ; Store into right volume
                Mov     BX, AX
                ShL     EAX, 16

                Mov     AL, 64                  ; Do left volume
                Sub     AL, [SI+37h]            ; AL = 64-FinalPan
                Mul     Byte Ptr MixVolume
                Mul     Word Ptr [SI+4Ah]
                ShRD    AX, DX, 14
                Mov     [SI+0Eh], AX

                Mov     ECX, EAX

                                        ; BX = right volume
                                        ; CX = Left volume
                Mov     AX, 0
                Test    ECX, ECX
                JZ      MixModeCommon

                Mov     AL, 30
                Test    BX, BX
                JZ      MixModeCommon

                Mov     AL, 60
                Test    CX, CX
                JZ      MixModeCommon

                Mov     AL, 90
                Cmp     CX, BX
                JE      MixModeCommon

                Mov     AL, 120
                Jmp     MixModeCommon

Mix6ModeSurround:
                Mov     AX, [SI+4Ah]
                Mul     MixVolume
                ShRD    AX, DX, 9
                Mov     [SI+0Ch], AX
                Mov     [SI+0Eh], AX
                JZ      MixModeCommon
                Mov     AX, 150
                Jmp     MixModeCommon

MixModeCommon:                          ; Requires AX = 30/60/90 etc. depending
                                        ;               On mixing mode type.
                                        ; This will add 180 for 16-bit,
                                        ; And sort out loop types.
                Mov     BL, [SI+0Ah]
                Test    Byte Ptr [SI+18h], 2    ; 16 bit?
                JZ      MixModeCommon1

                Add     AX, 180

MixModeCommon1:
                Cmp     BL, 8
                JB      MixModeCommon3          ; No loop
                JE      MixModeCommon2          ; Forwards loop

                Add     AX, 10

MixModeCommon2:
                Add     AX, 10

MixModeCommon3:
                Add     AX, Offset MixFunctionTables
                Add     AX, MixModeOffset
                Mov     [SI+8], AX              ; Offset...

MixSamplesMix:
                Mov     BX, [SI+8]              ; BX = offset into
                Mov     EAX, [CS:BX+2]
                Mov     DWord Ptr PreMixFunction, EAX
                Mov     EAX, [CS:BX+6]
                Mov     DWord Ptr MixFunctionSeparateBackwards, EAX

                Mov     AX, BytesToMix
                Mov     MixBlockSize, AX
                Mov     MixBufferOffset, MIXTABLESIZE

                Mov     EAX, CURRENTPOSITION
                Mov     OLDPOSITION, EAX

                Call    Word Ptr [CS:BX]

                And     Word Ptr [SI], 0111100010001101b
                Jmp     MixSamplesEnd

MixSamplesHandleError:
                Mov     Word Ptr [SI], 200h

                Test    Byte Ptr [SI+3Ah], 80h
                JNZ     MixSamplesEnd

                Mov     BX, [SI+38h]
                And     Byte Ptr [BX], Not 4    ; Turn off channel

MixSamplesEnd:
                Pop     CX

MixSamplesEnd2:
                Add     SI, 128
                Dec     CX
                JNZ     MixSamples2

                Ret

EndP            MixSamples

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

                Mov     DX, [BasePort]
                Add     DL, 0Eh
                In      AL, DX

                Mov     AX, MixBufferPos
                Mov     BX, AX
                Mul     DMASize
                Cmp     AX, DMABUFFERLENGTH
                JB      ESSIRQHandler2

                Xor     AX, AX
                Xor     BX, BX

ESSIRQHandler2:
                Inc     BX
                Mov     MixBufferPos, BX

                CLD


                                        ; OK... time to get next block
                                        ;  Check whether stereo thing is on..
                                        ;
                LES     DI, [ActualDMAPtr]
                Add     DI, AX

                Mov     BX, DMASize             ; BX = bytes required
                ShR     BX, 1
                                                ; BX = samples required
                Mov     BP, 8                   ; Skip for mono
                Mov     CL, 14                  ; Shift for mono

                Cmp     Stereo, 0
                JE      ESSIRQHandlerMono

                Mov     BP, 4                   ; Stereo skip value.
                Dec     CL

ESSIRQHandlerMono:
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
                Push    DX
                Cmp     CS:Filter, 1
                JB      ESSIRQHandler6
                JE      ESSIRQHFilter

                Cmp     CS:Stereo, 0
                JE      ESSIRQ3QFilterMono

ESSIRQ3QFilterStereo:
                Push    BX

                Mov     EBX, FilterValue
                Mov     EBP, FilterValue2
                ShR     DX, 1

ESSIRQ3QFilterStereo1:
                Mov     EAX, EBX
                Mov     ECX, EBP
                Add     EAX, [SI]
                Add     ECX, [SI+4]
                SAR     EAX, 1
                SAR     ECX, 1
                Add     EBX, EAX
                Add     EBP, ECX
                SAR     EBX, 1
                SAR     EBP, 1

                Mov     EAX, EBX
                SAR     EAX, 13

                Cmp     EAX, -8000h
                JL      WSS3QFilterStereoClip1
                Cmp     EAX, 7FFFh
                JG      WSS3QFilterStereoClip2

ESSIRQ3QFilterStereo2:
                StosW

                Mov     EAX, EBP
                SAR     EAX, 13

                Cmp     EAX, -8000h
                JL      WSS3QFilterStereoClip3
                Cmp     EAX, 7FFFh
                JG      WSS3QFilterStereoClip4

ESSIRQ3QFilterStereo3:
                StosW

                Add     SI, 8
                Dec     DX
                JNZ     ESSIRQ3QFilterStereo1

                Mov     FilterValue, EBX
                Mov     FilterValue2, EBP

                Pop     BX

                Jmp     WSSMixTransferEnd

ESSIRQ3QFilterMono:
                Push    BX

                Mov     EBX, FilterValue

ESSIRQ3QFilterMono1:
                Mov     EAX, EBX
                Add     EAX, [SI]
                SAR     EAX, 1
                Add     EBX, EAX
                SAR     EBX, 1
                Mov     EAX, EBX
                SAR     EAX, 14

                Cmp     EAX, -8000h
                JL      WSS3QFilterMonoClip1
                Cmp     EAX, 7FFFh
                JG      WSS3QFilterMonoClip2

ESSIRQ3QFilterMono2:
                StosW

                Add     SI, 8
                Dec     DX
                JNZ     ESSIRQ3QFilterMono1

                Mov     FilterValue, EBX

                Pop     BX

                Jmp     WSSMixTransferEnd

ESSIRQHFilter:
                Cmp     CS:Stereo, 0
                JE      ESSIRQHFilterMono

ESSIRQHFilterStereo:
                Push    BX

                Mov     EBX, FilterValue
                Mov     EBP, FilterValue2
                ShR     DX, 1

ESSIRQHFilterStereo1:
                Add     EBX, [SI]
                Add     EBP, [SI+4]

                SAR     EBX, 1
                SAR     EBP, 1

                Mov     EAX, EBX
                SAR     EAX, 13

                Cmp     EAX, -8000h
                JL      WSSHFilterStereoClip1
                Cmp     EAX, 7FFFh
                JG      WSSHFilterStereoClip2

ESSIRQHFilterStereo2:
                StosW

                Mov     EAX, EBP
                SAR     EAX, 13

                Cmp     EAX, -8000h
                JL      WSSHFilterStereoClip3
                Cmp     EAX, 7FFFh
                JG      WSSHFilterStereoClip4

ESSIRQHFilterStereo3:
                StosW

                Add     SI, 8
                Dec     DX
                JNZ     ESSIRQHFilterStereo1

                Mov     FilterValue, EBX
                Mov     FilterValue2, EBP

                Pop     BX

                Jmp     WSSMixTransferEnd

ESSIRQHFilterMono:
                Push    BX

                Mov     EBX, FilterValue

ESSIRQHFilterMono1:
                Add     EBX, [SI]
                SAR     EBX, 1
                Mov     EAX, EBX
                SAR     EAX, 14

                Cmp     EAX, -8000h
                JL      WSSHFilterMonoClip1
                Cmp     EAX, 7FFFh
                JG      WSSHFilterMonoClip2

ESSIRQHFilterMono2:
                StosW

                Add     SI, 8
                Dec     DX
                JNZ     ESSIRQHFilterMono1

                Mov     FilterValue, EBX

                Pop     BX

                Jmp     WSSMixTransferEnd

ESSIRQHandler6:
                Mov     EAX, [SI]
                SAR     EAX, CL

                Cmp     EAX, -8000h
                JL      ESSIRQHandlerClip1
                Cmp     EAX, 7FFFh
                JG      ESSIRQHandlerClip2

ESSIRQHandler7:
                StosW                                   ; } Memory write

                Add     SI, BP
                Dec     DX
                JNZ     ESSIRQHandler6

WSSMixTransferEnd:
                Pop     DX

                Sub     MixTransferRemaining, DX        ; } Memory write
                Sub     BX, DX
                JNZ     ESSIRQHandler3

                Mov     MixTransferOffset, SI           ; } Memory write

                Call    RestoreEMSPageFrame

ESSIRQEnd:
                Mov     AL, 20h
                Cmp     IRQ, 8
                JB      WSSAckIRQ1

                Out     0A0h, AL

WSSAckIRQ1:
                Out     20h, AL

                Pop     ES
                Pop     DS
                PopAD
                IRet

ESSIRQHandlerClip1:
                Mov     AX, 8000h
                Jmp     ESSIRQHandler7

ESSIRQHandlerClip2:
                Mov     AX, 7FFFh
                Jmp     ESSIRQHandler7

WSSHFilterMonoClip1:
                Mov     AX, 8000h
                Jmp     ESSIRQHFilterMono2

WSSHFilterMonoClip2:
                Mov     AX, 7FFFh
                Jmp     ESSIRQHFilterMono2

WSSHFilterStereoClip1:
                Mov     AX, 8000h
                Jmp     ESSIRQHFilterStereo2

WSSHFilterStereoClip2:
                Mov     AX, 7FFFh
                Jmp     ESSIRQHFilterStereo2

WSSHFilterStereoClip3:
                Mov     AX, 8000h
                Jmp     ESSIRQHFilterStereo3

WSSHFilterStereoClip4:
                Mov     AX, 7FFFh
                Jmp     ESSIRQHFilterStereo3

WSS3QFilterMonoClip1:
                Mov     AX, 8000h
                Jmp     ESSIRQ3QFilterMono2

WSS3QFilterMonoClip2:
                Mov     AX, 7FFFh
                Jmp     ESSIRQ3QFilterMono2

WSS3QFilterStereoClip1:
                Mov     AX, 8000h
                Jmp     ESSIRQ3QFilterStereo2

WSS3QFilterStereoClip2:
                Mov     AX, 7FFFh
                Jmp     ESSIRQ3QFilterStereo2

WSS3QFilterStereoClip3:
                Mov     AX, 8000h
                Jmp     ESSIRQ3QFilterStereo3

WSS3QFilterStereoClip4:
                Mov     AX, 7FFFh
                Jmp     ESSIRQ3QFilterStereo3

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
                Mov     BX, DMASegment
                Xor     AX, AX
                Mov     DX, DMA
                Mov     DI, DMABUFFERLENGTH
                Call    SetDMA

                LES     DI, ActualDMAPtr
                Xor     AX, AX
                Mov     CX, DMABUFFERLENGTH/2
                Rep     StosW

                Mov     MixBufferPos, 0
                Mov     MixTransferRemaining, 0

                Call    ResetDSP
                Mov     DX, BasePort
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
                Mov     AL, 0B1h
                Call    ESSOut
                Mov     AL, 50h
                Call    ESSOut

; DMA configuration
                Mov     AL, 0B2h
                Call    ESSOut
                Mov     AL, 50h
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
                AdC     DX, 2080

                Mov     BX, (DMABUFFERLENGTH*2)/16
                Add     BX, DX

                        ; Allocate MixSegment first
                Mov     AH, 48h

                Int     21h
                JNC     InitSound1

InitSoundNoMemory:
                Mov     SI, Offset ESSNoMemoryMsg
                Ret

InitSound1:
                Mov     MixSegment, AX
                Add     AX, DX
                Mov     DMASegment, AX

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

                PushA
                Push    DS

                Mov     BX, AX                  ; BX = MixVolume
                Mov     CS:MixVolume, BX

                Mov     AX, CS:MixSegment
                Test    AX, AX
                JZ      SetMixVolume2

                Mov     DS, AX

                Mov     CX, MIXTABLESIZE/2
                Mov     SI, MIXTABLESIZE-2; Starting point - working backwards

SetMixVolume1:
                Mov     AX, CX

                Dec     AX      ; AH = volume, AL = wave value.
                Xor     DX, DX
                XChg    AH, DL  ; DL = Volume, AX = wave value
                CBW

                IMul    DX      ; DX:AX = Volume * Wave Value
                                ; Ranges -8192->8128

                IMul    BX      ; DX:AX = Volume * Wave Value * Mixing Volume
                                ; Ranges -1048576->1040384

                Add     AX, 64
                AdC     DX, 0

                ShRD    AX, DX, 7
                Mov     [SI], AX
                Sub     SI, 2

                Loop    SetMixVolume1

SetMixVolume2:
                Mov     DS, Word Ptr [CS:RecalculateAllVolumes+2]
                Call    CS:RecalculateAllVolumes

                Pop     DS
                PopA

                Ret

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

EndDriver:

;********  Provided Variable Table *************

MaxNumberOfChannels     DW      0FFFFh  ; Maximum number of channels the
                                        ; driver can handle.

StopAfterPlay           DW      0
DefaultChannels         DW      64
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
