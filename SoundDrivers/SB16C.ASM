
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

STEREOENABLED   EQU     1
DMABUFFERLENGTH EQU     8192
MIXRESOLUTION   EQU     16      ; 16 bit mixing for the SB16
MIXTABLESIZE    EQU     2*256*65

SB16Msg         DB      "Sound Blaster 16 detected", 13
                DB      "Port ", 0FDh, "Xh, IRQ ", 0FDh, "D, DMA ", 0FDh, "D", 0

SB16NoMemoryMsg DB      "Sound Blaster 16 detected", 13
                DB      "Error: Insufficient memory", 0

ReinitMsg       DB      "Sound Blaster 16 reinitialised", 0

DSPVersion      DW      0
DSPIRQValue     DB      0
DSPDMAValue     DB      0
Forced          DB      0
Stereo          DB      0

BytesToMix      DW      1000
SBMixConst      DB      0

MixSegment              DW      0
DMASegment              DW      0
MixSegmentLength        DW      0

MixTransferOffset       DW      0
MixTransferRemaining    DW      0

DMASize                 DW      2048

IMR             DW      0
OldIRQHandler   DD      0

FilterValue     DD      0
FilterValue2    DD      0

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

                        DW      Near Ptr MixFrequencyText

                        DW      0

SB16HeaderLine          DW      10
                        DB      "Sound Blaster 16 Lite Driver", 0

DriverText              DW      1
                        DB      31, 48
                        DB      21h
                        DB      "Sound Blaster 16 Driver 1.0 for Impulse Tracker", 0

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

MixFrequencyText        DW      1
                        DB      2, 23
                        DB      20h
                        DB      "Playback Frequency: ", 0FDh, "DHz", 0
MixSpeed                DW      45454

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
                        DW      12, 0FFFFh, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh

VolumeTable             DB      6 Dup (0)

; 컴 MixingRoutines 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

MixBufferPos            DW      0

include dma.inc
include mix.inc
include m12bit.mix

MixFunctionTables       Label

include m12bit.inc      ; contains the tables

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

                Mov     MixTransferOffset, DI           ; } Memory write

                Cmp     Stereo, 0
                JE      MixSamples1

                Add     DX, DX

MixSamples1:
                Rep     StosD                           ; } Memory write

MixSamplesCont:
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

                Cmp     Stereo, 0
                JNE     Mix0ModeStereo

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

Proc            AckIRQ
                Assume DS:Driver

                Mov     AL, 20h
                Cmp     IRQ, 7
                JBE     AckIRQ1

                Out     0A0h, AL

AckIRQ1:
                Out     20h, AL
                Ret

EndP            AckIRQ
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SB16IRQHandler

                PushAD
                Push    DS
                Push    ES

                CLD

                Mov     AX, CS
                Mov     DS, AX
                        Assume DS:Driver

                Mov     DX, BasePort
                Add     DL, 0Fh
                In      AL, DX

                Call    AckIRQ

                Mov     AX, MixBufferPos
                Mov     BX, AX
                Mul     DMASize
                Cmp     AX, DMABUFFERLENGTH
                JB      SB16IRQHandler2

                Xor     AX, AX
                Xor     BX, BX

SB16IRQHandler2:
                Inc     BX
                Mov     MixBufferPos, BX


                                        ; OK... time to get next block
                                        ;  Check whether stereo thing is on..
                                        ;
                LES     DI, [ActualDMAPtr]
                Add     DI, AX

                Mov     BX, DMASize             ; BX = bytes required
                ShR     BX, 1
                                                ; BX = samples required
                Mov     BP, 4                   ; Skip for mono
                Mov     CL, 2                   ; Shift for mono

                Cmp     Stereo, 0
                JE      SB16IRQHandlerMono

                ShR     BP, 1
                Inc     CL

SB16IRQHandlerMono:
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
                Push    DX

SB16IRQHandler6:
                MovSX   EAX, Word Ptr [SI]
                SAL     EAX, CL

                Cmp     EAX, -8000h
                JL      SB16IRQHandlerClip1
                Cmp     EAX, 7FFFh
                JG      SB16IRQHandlerClip2

SB16IRQHandler7:
                StosW                                   ; } Memory write

                Add     SI, BP
                Dec     DX
                JNZ     SB16IRQHandler6

SB16MixTransferEnd:
                Pop     DX

                Sub     MixTransferRemaining, DX        ; } Memory write
                Sub     BX, DX
                JNZ     SB16IRQHandler3

                Mov     MixTransferOffset, SI           ; } Memory write

                Call    RestoreEMSPageFrame

SBIRQEnd:
                Pop     ES
                Pop     DS
                PopAD
                IRet

SB16IRQHandlerClip1:
                Mov     AX, 8000h
                Jmp     SB16IRQHandler7

SB16IRQHandlerClip2:
                Mov     AX, 7FFFh
                Jmp     SB16IRQHandler7

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
                Push    ES

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

                ; Parags to allocate = (4/(.4*31*16))*MixSpeed + 2080
                ; = .02016129*MixSpeed = (65536*.04032258*MixSpeed) / 65536

                Mov     AX, 1322
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
                Mov     SI, Offset SB16NoMemoryMsg
                Ret

InitSound1:
                Mov     MixSegment, AX
                Add     AX, DX
                Mov     DMASegment, AX
                Sub     DX, 2080
                Mov     MixSegmentLength, DX

                Call    SetIRQ
                Call    GetTempo
                Call    SetTempo

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
                Mov     DX, AX
                Call    ResetDSP

                Call    ResetIRQ
                                        ; Delay..
                Mov     DX, BasePort
                Add     DL, 0Ch

                Mov     CX, 1000
ReInitSound1:
                In      AL, DX
                Loop    ReInitSound1

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

                Mov     DX, CS:BasePort
                Add     DL, 0Ch

                Mov     AL, 0D3h
                Call    SBOut

                Mov     AL, 0D5h
                Call    SBOut

                Mov     AL, 0D9h
                Call    SBOut

                Mov     AL, 0D5h
                Call    SBOut

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

                Dec     CX
                JNZ     SetMixVolume1

SetMixVolume2:
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

                Cmp     CS:MixSegment, 0
                JE      SetStereo1

                Mov     CS:Stereo, AL
                Mov     AX, CS:BasePort
                Call    ResetDSP

                Mov     ES, CS:MixSegment
                Mov     CX, CS:MixSegmentLength
                Mov     DI, MIXTABLESIZE
                ShL     CX, 2
                Xor     EAX, EAX
                Rep     StosD

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

Proc            SetVariable Far         ; Given AX, DI

                Push    DS
                Push    DX

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     [VolumeTable+DI], AL

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

                Pop     DX
                Pop     DS
                Ret

EndP            SetVariable
                Assume DS:Nothing

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
