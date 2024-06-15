
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
DMABUFFERLENGTH EQU     4096
MIXRESOLUTION   EQU     16      ; 16 bit mixing for the SB Pro
MIXTABLESIZE    EQU     2*256*65

SBProMsg        DB      "Sound Blaster Pro detected", 13
                DB      "Port ", 0FDh, "Xh, IRQ ", 0FDh, "D, DMA ", 0FDh, "D", 0

SBProNoMemoryMsg DB     "Sound Blaster Pro detected", 13
                DB      "Error: Insufficient memory", 0

ReinitMsg       DB      "Sound Blaster Pro reinitialised", 0

ConfigErrorMsg  DB      "Error saving configuration to ITSBPRO.DRV", 0
ConfigOKMsg     DB      "Configuration saved to ITSBPRO.DRV", 0

BLASTERString   DB      "BLASTER"
DriverName      DB      "ITSBPRO.DRV", 0

BlasterEnvironment      Label   DWord
BlasterOffset   DW      0
BlasterSegment  DW      0

MixSpeed        DW      43478

DSPVersion      DW      0
Forced          DB      0
Stereo          DB      0

BytesToMix      DW      1000
SBMixConst      DB      0

MixSegment      DW      0
DMASegment      DW      0

MixTransferOffset       DW      0
MixTransferRemaining    DW      0

CONFIGURATIONOFFSET     EQU     $+128
CONFIGSIZE              EQU     6
MixMode                 DW      0
MixModeOffset           DW      0
Filter                  DW      0
DMASize                 DW      1024

MixLength               DW      0

IMR             DW      0
OldIRQHandler   DD      0

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

SBProScreenList         Label
                        DW      6
                        DW      Near Ptr IdleFunctionList
                        DW      Near Ptr GlobalKeyLink

                        DW      Near Ptr FullScreenBox  ; 0
                        DW      Near Ptr ScreenHeader
                        DW      Near Ptr FillHeader
                        DW      Near Ptr SBProHeaderLine

                        DW      Near Ptr VolumeText
                        DW      Near Ptr VolumeBox1

                        DW      Near Ptr MasterVolumeLeft       ; 6
                        DW      Near Ptr MasterVolumeRight      ; 7

                        DW      Near Ptr MixModeText
                        DW      Near Ptr MixModeButton1
                        DW      Near Ptr MixModeButton2

                        DW      0

SBProHeaderLine          DW      10
                        DB      "Sound Blaster Pro Driver", 0

DriverText              DW      1
                        DB      30, 48
                        DB      21h
                        DB      "Sound Blaster Pro Driver 1.0 for Impulse Tracker", 0

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
                        DB      21, 13, 27, 16
                        DB      25

MasterVolumeLeft        DW      9
                        DB      22, 14
                        DW      0, 31
                        DW      9, 0
                        DW      0FFFFh, 7, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh

MasterVolumeRight       DW      9
                        DB      22, 15
                        DW      0, 31
                        DW      9, 1
                        DW      6, 9, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh

MixModeText             DW      1
                        DB      2, 18
                        DB      20h
                        DB      "Mixing Mode, Playback Frequency: ", 0FDh, "DHz", 0
Frequency               DW      0

MixModeButton1          DW      2
                        DW      7, 10, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetMixMode
DriverSegment1          DW      0
                        DW      0
                        DW      Offset SetMixMode
DriverSegment2          DW      0
                        DB      5, 19, 34, 21, 8
                        DB      0
                        DB      "  16 Bit, Non-Interpolated", 0

MixModeButton2          DW      2
                        DW      9, 0FFFFh, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetMixMode
DriverSegment3          DW      0
                        DW      2
                        DW      Offset SetMixMode
DriverSegment4          DW      0
                        DB      5, 22, 34, 24, 8
                        DB      0
                        DB      "  16 Bit, Interpolated", 0

VolumeTable             DB      6 Dup (0)

; 컴 MixingRoutines 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

MixBufferPos            DW      0
include dma.inc
include mix.inc
include m12bit.mix
include m12biti.mix

MixFunctionTables       Label

include m12bit.inc      ; contains the tables
include m12biti.inc

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            RecalculateAllFrequencies

                Call    GetChannelTables

RecalculateAllFrequencies1:
                Or      Byte Ptr [SI], 32

                Add     SI, 128
                Dec     CX
                JNZ     RecalculateAllFrequencies1

                Ret

EndP            RecalculateAllFrequencies

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

                Mov     BX, 180
                Mul     BX
                Mov     CS:MixModeOffset, AX

                Mov     DS, Word Ptr [CS:RecalculateAllVolumes+2]
                Call    CS:RecalculateAllVolumes

                StI

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

                Mov     CX, 43478
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
                JNC     DetectCard3

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

                Cmp     Forced, 0
                JNE     DetectCard5
                Cmp     AH, 3           ; SB DSP = 3.00+
                JAE     DetectCard5

DetectCard4:
                StC
                Ret

DetectCard5:
                Mov     DSPVersion, AX

                                        ; Need to detect IRQ/DMA...

                Mov     SI, Offset BLASTERString
                Mov     CX, 7
                Call    GetEnvironment  ; Returns ES:DI, Carry if error
                JC      DetectCardNoEnvironment

                Mov     BlasterOffset, DI
                Mov     BlasterSegment, ES

                Cmp     IRQ, 0FFFFh
                JE      DetectCardIRQ3
                Cmp     Forced, 0
                JNE     DetectCardIRQDone
                Jmp     DetectCardError

DetectCardIRQ3:
                Push    DS
                Push    SI

                LDS     SI, BlasterEnvironment

                Xor     DX, DX                  ; DX = env..

DetectCardIRQ1:
                LodsB
                And     AL, AL
                JZ      DetectCardError
                Cmp     AL, 'i'
                JE      DetectCardIRQ2
                Cmp     AL, 'I'
                JE      DetectCardIRQ2
                Jmp     DetectCardIRQ1

DetectCardIRQ2:
                LodsB
                And     AL, AL
                JZ      DetectCardIRQEnd
                Cmp     AL, ' '
                JE      DetectCardIRQEnd
                Sub     AL, '0'
                JC      DetectCardError
                Cmp     AL, 9
                JA      DetectCardError

                IMul    DX, 10
                Add     DL, AL
                Jmp     DetectCardIRQ2

DetectCardIRQEnd:
                Pop     SI
                Pop     DS

                Mov     IRQ, DX

DetectCardIRQDone:
                Cmp     DMA, 0FFFFh
                JE      DetectCardDMA3
                Cmp     Forced, 0
                JNE     DetectCardDMADone
                Jmp     DetectCardError

DetectCardDMA3:
                Push    DS
                Push    SI

                LDS     SI, BlasterEnvironment

                Xor     DX, DX                  ; DX = env..

DetectCardDMA1:
                LodsB
                And     AL, AL
                JZ      DetectCardError
                Cmp     AL, 'd'
                JE      DetectCardDMA2
                Cmp     AL, 'D'
                JE      DetectCardDMA2
                Jmp     DetectCardDMA1

DetectCardDMA2:
                LodsB
                And     AL, AL
                JZ      DetectCardDMAEnd
                Cmp     AL, ' '
                JE      DetectCardDMAEnd
                Sub     AL, '0'
                JC      DetectCardError
                Cmp     AL, 9
                JA      DetectCardError

                IMul    DX, 10
                Add     DL, AL
                Jmp     DetectCardDMA2

DetectCardDMAEnd:
                Pop     SI
                Pop     DS

                Mov     DMA, DX

DetectCardDMADone:
                Mov     EAX, 'Jeff'

                ClC
                Ret

DetectCardNoEnvironment:
                Cmp     DMA, 0FFFFh
                JE      DetectCardError
                Cmp     IRQ, 0FFFFh
                JNE     DetectCardDMADone

DetectCardError:
                StC
                Ret

EndP            DetectCard
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

MixModeTable    Label   Word
        DW      Offset Mix0ModeMono, Mix0ModeStereo
        DW      Offset Mix0ModeMono, Mix0ModeStereo

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
                Mov     AX, 2020h

                Mov     BX, CX          ; BX = bytes to mix
                Mov     DX, CX

                Add     CX, CX

                Mov     MixTransferOffset, DI           ; } Memory write
                Cmp     CS:Stereo, 0
                JE      MixSamples1

                Mov     AX, 1010h
                And     DX, Not 1
                ShR     BX, 1
                ShR     CX, 1
                Inc     CX

MixSamples1:
                Rep     StosW                           ; } Memory write
                Mov     MixTransferRemaining, DX        ; }
                Mov     MixLength, BX

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

                Cmp     MixMode, 4              ; Is it volume ramping?
                JB      MixSamplesEnd

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
                Cmp     CS:Stereo, 0
                JE      MixSampleFreqNoStereo

                ShL     EAX, 1

MixSampleFreqNoStereo:
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

Mix0Mode:                       ; 16-bit mixing, no interpolation, no ramping
Mix0ModeMono:
                Mov     AL, [SI+20h]
                ShR     AL, 1
                Mov     [SI+0Ch], AX
                Mov     [SI+0Eh], AX
                Mov     AX, 0
                JZ      MixModeCommon
                Mov     AX, 30          ; Use left only-mixing for mono
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

                Mov     AX, 30                  ; Left only...
                Test    CL, CL
                JZ      MixModeCommon

                Mov     AX, 60
                Test    CH, CH
                JZ      MixModeCommon

                Mov     AX, 90
                Cmp     CL, CH
                JZ      MixModeCommon

                Mov     AX, 120
                Jmp     MixModeCommon

Mix0ModeSurround:
                Mov     AL, [SI+20h]
                ShR     AL, 2
                Mov     [SI+0Ch], AX
                Mov     [SI+0Eh], AX
                Mov     AX, 0
                JZ      MixModeCommon
                Mov     AX, 150                 ; Surround
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

                Mov     AX, MixLength
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

Proc            SBProIRQHandler

                PushAD
                Push    DS
                Push    ES

                CLD

                Mov     AX, CS
                Mov     DS, AX
                        Assume DS:Driver

                Mov     DX, BasePort
                Add     DL, 0Eh
                In      AL, DX          ; 8-bit IRQ ack.

                Mov     AL, 20h
                Cmp     IRQ, 7
                JBE     SBProIRQHandler1

                Out     0A0h, AL

SBProIRQHandler1:
                Out     20h, AL

                Mov     AX, MixBufferPos
                Mov     BX, AX
                Mul     DMASize
                Cmp     AX, DMABUFFERLENGTH
                JB      SBProIRQHandler2

                Xor     AX, AX
                Xor     BX, BX

SBProIRQHandler2:
                Inc     BX
                Mov     MixBufferPos, BX


                                        ; OK... time to get next block
                                        ;  Check whether stereo thing is on..
                                        ;
                LES     DI, [ActualDMAPtr]
                Add     DI, AX

                Mov     BX, DMASize             ; BX = bytes required

                                                ; BX = samples required
                Mov     BP, 4                   ; Skip for mono
                Mov     CL, 6                   ; Shift for mono

                Cmp     Stereo, 0
                JE      SBProIRQHandlerMono

                Mov     BP, 2                   ; Stereo skip value.
                Dec     CL

SBProIRQHandlerMono:
                Call    SaveEMSPageFrame

                Cmp     MixTransferRemaining, 0
                JNE     SBProIRQHandler4
                        Assume DS:Nothing

SBProIRQHandler3:
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

SBProIRQHandler4:
                Mov     DS, MixSegment
                Mov     SI, MixTransferOffset
                Mov     DX, BX          ;  DX = samples to transfer
                Cmp     DX, MixTransferRemaining
                JBE     SBProIRQHandler5

                Mov     DX, MixTransferRemaining

SBProIRQHandler5:
                Push    DX

SBProIRQHandler6:
                Mov     AX, [SI]
                SAR     AX, CL

                Test    AH, AH
                JNZ     SBProIRQHandlerClip1

SBProIRQHandler7:
                StosB                                   ; } Memory write

                Add     SI, BP
                Dec     DX
                JNZ     SBProIRQHandler6

                Pop     DX

                Sub     MixTransferRemaining, DX        ; } Memory write
                Sub     BX, DX
                JNZ     SBProIRQHandler3

                Mov     MixTransferOffset, SI           ; } Memory write

                Call    RestoreEMSPageFrame

                Pop     ES
                Pop     DS
                PopAD
                IRet

SBProIRQHandlerClip1:
                Mov     AL, 00h
                JS      SBProIRQHandler7
                Mov     AL, 0FFh
                Jmp     SBProIRQHandler7

                Comment ~

Proc            SBProIRQHandler

                PushAD
                Push    DS
                Push    ES

                CLD

                Mov     AX, CS
                Mov     DS, AX
                        Assume DS:Driver

                Mov     DX, BasePort
                Add     DL, 0Fh
                In      AL, DX          ; 16-bit IRQ ack.

                Mov     AL, 20h
                Cmp     IRQ, 7
                JBE     SBProIRQHandler1

                Out     0A0h, AL

SBProIRQHandler1:
                Out     20h, AL

                Mov     AX, MixBufferPos
                Mov     BX, AX
                Mul     DMASize
                Cmp     AX, DMABUFFERLENGTH
                JB      SBProIRQHandler2

                Xor     AX, AX
                Xor     BX, BX

SBProIRQHandler2:
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
                Mov     CL, 6                   ; Shift for mono

                Cmp     Stereo, 0
                JE      SBProIRQHandlerMono

                Mov     BP, 2                   ; Stereo skip value.
                Dec     CL

SBProIRQHandlerMono:
                Call    SaveEMSPageFrame

                Cmp     MixTransferRemaining, 0
                JNE     SBProIRQHandler4
                        Assume DS:Nothing

SBProIRQHandler3:
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

SBProIRQHandler4:
                Mov     DS, MixSegment
                Mov     SI, MixTransferOffset
                Mov     DX, BX          ;  DX = samples to transfer
                Cmp     DX, MixTransferRemaining
                JBE     SBProIRQHandler5

                Mov     DX, MixTransferRemaining

SBProIRQHandler5:
                Push    DX
                Cmp     CS:Filter, 1
                JB      SBProIRQHandler6
                JE      SBProIRQHFilter

                Cmp     CS:Stereo, 0
                JE      SBProIRQ3QFilterMono

SBProIRQ3QFilterStereo:
                Push    BX

                Mov     BX, FilterValue
                Mov     BP, FilterValue2
                ShR     DX, 1

SBProIRQ3QFilterStereo1:
                Mov     AX, BX
                Mov     CX, BP
                Add     AX, [SI]
                Add     CX, [SI+2]
                SAR     AX, 1
                SAR     CX, 1
                Add     BX, AX
                Add     BP, CX
                SAR     BX, 1
                SAR     BP, 1

                Mov     AX, BX
                SAR     AX, 5

                Test    AH, AH
                        ;......

SBProIRQ3QFilterStereo2:
                StosW

                Mov     EAX, EBP
                SAR     EAX, 13

                Cmp     EAX, -8000h
                JL      SBPro3QFilterStereoClip3
                Cmp     EAX, 7FFFh
                JG      SBPro3QFilterStereoClip4

SBProIRQ3QFilterStereo3:
                StosW

                Add     SI, 8
                Dec     DX
                JNZ     SBProIRQ3QFilterStereo1

                Mov     FilterValue, EBX
                Mov     FilterValue2, EBP

                Pop     BX

                Jmp     SBProMixTransferEnd

SBProIRQ3QFilterMono:
                Push    BX

                Mov     EBX, FilterValue

SBProIRQ3QFilterMono1:
                Mov     EAX, EBX
                Add     EAX, [SI]
                SAR     EAX, 1
                Add     EBX, EAX
                SAR     EBX, 1
                Mov     EAX, EBX
                SAR     EAX, 14

                Cmp     EAX, -8000h
                JL      SBPro3QFilterMonoClip1
                Cmp     EAX, 7FFFh
                JG      SBPro3QFilterMonoClip2

SBProIRQ3QFilterMono2:
                StosW

                Add     SI, 8
                Dec     DX
                JNZ     SBProIRQ3QFilterMono1

                Mov     FilterValue, EBX

                Pop     BX

                Jmp     SBProMixTransferEnd

SBProIRQHFilter:
                Cmp     CS:Stereo, 0
                JE      SBProIRQHFilterMono

SBProIRQHFilterStereo:
                Push    BX

                Mov     EBX, FilterValue
                Mov     EBP, FilterValue2
                ShR     DX, 1

SBProIRQHFilterStereo1:
                Add     EBX, [SI]
                Add     EBP, [SI+4]

                SAR     EBX, 1
                SAR     EBP, 1

                Mov     EAX, EBX
                SAR     EAX, 13

                Cmp     EAX, -8000h
                JL      SBProHFilterStereoClip1
                Cmp     EAX, 7FFFh
                JG      SBProHFilterStereoClip2

SBProIRQHFilterStereo2:
                StosW

                Mov     EAX, EBP
                SAR     EAX, 13

                Cmp     EAX, -8000h
                JL      SBProHFilterStereoClip3
                Cmp     EAX, 7FFFh
                JG      SBProHFilterStereoClip4

SBProIRQHFilterStereo3:
                StosW

                Add     SI, 8
                Dec     DX
                JNZ     SBProIRQHFilterStereo1

                Mov     FilterValue, EBX
                Mov     FilterValue2, EBP

                Pop     BX

                Jmp     SBProMixTransferEnd

SBProIRQHFilterMono:
                Push    BX

                Mov     EBX, FilterValue

SBProIRQHFilterMono1:
                Add     EBX, [SI]
                SAR     EBX, 1
                Mov     EAX, EBX
                SAR     EAX, 14

                Cmp     EAX, -8000h
                JL      SBProHFilterMonoClip1
                Cmp     EAX, 7FFFh
                JG      SBProHFilterMonoClip2

SBProIRQHFilterMono2:
                StosW

                Add     SI, 8
                Dec     DX
                JNZ     SBProIRQHFilterMono1

                Mov     FilterValue, EBX

                Pop     BX

                Jmp     SBProMixTransferEnd

SBProIRQHandler6:
                Mov     EAX, [SI]
                SAR     EAX, CL

                Cmp     EAX, -8000h
                JL      SBProIRQHandlerClip1
                Cmp     EAX, 7FFFh
                JG      SBProIRQHandlerClip2

SBProIRQHandler7:
                StosW                                   ; } Memory write

                Add     SI, BP
                Dec     DX
                JNZ     SBProIRQHandler6

SBProMixTransferEnd:
                Pop     DX

                Sub     MixTransferRemaining, DX        ; } Memory write
                Sub     BX, DX
                JNZ     SBProIRQHandler3

                Mov     MixTransferOffset, SI           ; } Memory write

                Call    RestoreEMSPageFrame

                Pop     ES
                Pop     DS
                PopAD
                IRet

SBProIRQHandlerClip1:
                Mov     AL, 80h
                Jmp     SBProIRQHandler7

SBProIRQHandlerClip2:
                Mov     AL, 7Fh
                Jmp     SBProIRQHandler7

SBProHFilterMonoClip1:
                Mov     AL, 80h
                Jmp     SBProIRQHFilterMono2

SBProHFilterMonoClip2:
                Mov     AL, 7Fh
                Jmp     SBProIRQHFilterMono2

SBProHFilterStereoClip1:
                Mov     AL, 80h
                Jmp     SBProIRQHFilterStereo2

SBProHFilterStereoClip2:
                Mov     AL, 7Fh
                Jmp     SBProIRQHFilterStereo2

SBProHFilterStereoClip3:
                Mov     AL, 80h
                Jmp     SBProIRQHFilterStereo3

SBProHFilterStereoClip4:
                Mov     AL, 7Fh
                Jmp     SBProIRQHFilterStereo3

SBPro3QFilterMonoClip1:
                Mov     AL, 80h
                Jmp     SBProIRQ3QFilterMono2

SBPro3QFilterMonoClip2:
                Mov     AL, 7Fh
                Jmp     SBProIRQ3QFilterMono2

SBPro3QFilterStereoClip1:
                Mov     AL, 80h
                Jmp     SBProIRQ3QFilterStereo2

SBPro3QFilterStereoClip2:
                Mov     AL, 7Fh
                Jmp     SBProIRQ3QFilterStereo2

SBPro3QFilterStereoClip3:
                Mov     AL, 80h
                Jmp     SBProIRQ3QFilterStereo3

SBPro3QFilterStereoClip4:
                Mov     AL, 7Fh
                Jmp     SBProIRQ3QFilterStereo3

EndP            SBProIRQHandler
                Assume DS:Nothing

                ~

EndP            SBProIRQHandler
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
                Mov     AX, Offset SBProIRQHandler

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

Proc            StartSBPro               ;

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

                Mov     AL, 40h         ; time constant
                Call    SBOut
                Mov     AL, SBMixConst
                Call    SBOut

                Mov     AL, 0D1h        ; turn on speaker
                Call    SBOut

                Mov     AL, 48h         ; Set DMA Size..
                Call    SBOut
                Mov     AX, DMASize
                Dec     AX
                Call    SBOut
                Mov     AL, AH
                Call    SBOut

                Mov     AL, 1Ch
                Cmp     MixSpeed, 21739
                JBE     StartSBPro1

                Mov     AL, 90h

StartSBPro1:
                Call    SBOut

                Pop     ES
                PopA

                Ret

                        Assume DS:Nothing

EndP            StartSBPro

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

                Mov     AX, DS
                Mov     DriverSegment1, AX
                Mov     DriverSegment2, AX
                Mov     DriverSegment3, AX
                Mov     DriverSegment4, AX

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
                Call    SBGetRegister
                Mov     AH, AL
                And     AX, 0FF0h
                ShR     AL, 4
                ShL     AX, 1
                Mov     Word Ptr [VolumeTable], AX

                Call    GetSBMixConst

                ; Parags to allocate = (4/(.4*31*16))*MixSpeed + 2080
                ; = 661*MixSpeed/65536

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
                Mov     SI, Offset SBProNoMemoryMsg
                Ret

InitSound1:
                Mov     MixSegment, AX
                Add     AX, DX
                Mov     DMASegment, AX

                Call    SetIRQ
                Call    GetTempo
                Call    SetTempo
                Call    StartSBPro

                Mov     SI, Offset SBProMsg

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

                Mov     AX, CS:BasePort
                Call    ResetDSP
                Call    StartSBPro

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

                Mov     AX, BasePort
                Call    ResetDSP

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

                Loop    SetMixVolume1

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

                PushA
                Mov     CX, MixSpeed

                Mov     Stereo, AL
                Mov     AH, AL

                Mov     DX, BasePort
                Add     DL, 4

                Mov     AL, 0Eh         ; Stereo register
                Out     DX, AL
                Inc     DX
                In      AL, DX

                Test    AH, AH
                JZ      SBProSetStereo1
                                        ; Turn on stereo

                ShR     CX, 1
                Or      AL, 2

                Jmp     SBProSetStereo2

SBProSetStereo1:                        ; Turn off stereo

                And     AL, NOT 2

SBProSetStereo2:
                Mov     Frequency, CX

                ClI

                Out     DX, AL
                Call    RecalculateAllFrequencies

                StI

                PopA
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
                Mov     DX, Offset SBProScreenList

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
                Mov     AX, Word Ptr [VolumeTable]

                ShL     AL, 3
                ShR     AH, 1
                And     AX, 0FF0h
                Or      AH, AL
                Or      AH, 11h
                Mov     AL, 22h
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
