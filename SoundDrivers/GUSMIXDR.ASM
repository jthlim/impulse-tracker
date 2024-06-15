
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

ENDLOCATIONHIGH         EQU     1Fh
ENDLOCATIONLOW          EQU     0FE00h
HALFENDLOCATIONHIGH     EQU     0Fh
HALFENDLOCATIONLOW      EQU     0FE00h

MIXRESOLUTION   EQU     32      ; 32 bit mixing for the GUS
MIXTABLESIZE    EQU     2*256*65

Voice0Position  DD      0
Voice1Position  DD      0

GUSMsg          DB      "Gravis Ultrasound detected", 13
                DB      "Port ", 0FDh, "Xh, IRQ ", 0FDh, "D, DMA ", 0FDh, "D", 0

GUSNoMemoryMsg  DB      "Gravis Ultrasound detected", 13
                DB      "Error: Insufficient memory", 0

ReinitMsg       DB      "Gravis Ultrasound reinitialised", 0

ConfigErrorMsg  DB      "Error saving configuration to ITGUSMIX.DRV", 0
ConfigOKMsg     DB      "Configuration saved to ITGUSMIX.DRV", 0

DriverName      DB      "ITGUSMIX.DRV", 0
UltrasndString  DB      "ULTRASND"

GUSMixTable     Label   Word
        DW      44100, 41160, 38588, 36318, 34300, 32495, 30870, 29400, 28064
        DW      26844, 25725, 24696, 23746, 22867, 22050, 21290, 20580, 19916
        DW      19294

DSPVersion      DW      0
DSPIRQValue     DB      0
DSPDMAValue     DB      0
Forced          DB      0
Stereo          DB      0
MixVolume       DW      0

BytesToMix      DW      1000
MixSpeed        DW      44100
GUSChannels     DB      14

MixSegment      DW      0
DMASegment      DW      0

MixTransferOffset       DW      0
MixTransferRemaining    DW      0

GUSRegisterSelect       DW      0
GUSVoiceSelect          DW      0

CONFIGURATIONOFFSET     EQU     $+128
CONFIGSIZE              EQU     8
MixMode                 DW      0
MixModeOffset           DW      0
Filter                  DW      0
DMASize                 DW      4096

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

GUSScreenList          Label
                        DW      6
                        DW      Near Ptr IdleFunctionList
                        DW      Near Ptr GlobalKeyLink

                        DW      Near Ptr FullScreenBox  ; 0
                        DW      Near Ptr ScreenHeader
                        DW      Near Ptr FillHeader
                        DW      Near Ptr GUSHeaderLine

                        DW      Near Ptr DriverText

                        DW      Near Ptr MixModeText
                        DW      Near Ptr MixModeButton1         ; 6
                        DW      Near Ptr MixModeButton2         ; 7
                        DW      Near Ptr MixModeButton3         ; 8
                        DW      Near Ptr MixModeButton4         ; 9

                        DW      Near Ptr FilterText
                        DW      Near Ptr FilterButton1          ; 11
                        DW      Near Ptr FilterButton2
                        DW      Near Ptr FilterButton3

                        DW      0

GUSHeaderLine           DW      10
                        DB      "Gravis Ultrasound Mixed Driver", 0

DriverText              DW      1
                        DB      30, 48
                        DB      21h
                        DB      "Gravis Ultrasound Driver 1.0 for Impulse Tracker", 0

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
                        DB      2, 13
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
                        DB      3, 15, 32, 17, 8
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
                        DB      3, 18, 32, 20, 8
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
                        DB      3, 21, 32, 23, 8
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
                        DB      3, 24, 32, 26, 8
                        DB      0
                        DB      "  32 Bit, Interpolated", 0

FilterText              DW      1
                        DB      2, 28
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
                        DB      3, 30, 29, 32, 8
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
                        DB      3, 33, 29, 35, 8
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
                        DB      3, 36, 29, 38, 8
                        DB      0
                        DB      "  75% Filter", 0

; 컴 MixingRoutines 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

MixBufferPos            DW      0
MixBufferDestination    DW      0

include dmanai.inc      ; Non-auto-initialise DMA
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

;***********************************************

Proc            GUSDelay

                Push    AX
                Push    DX

                Mov     DX, 300h

                In      AL, DX
                In      AL, DX
                In      AL, DX
                In      AL, DX
                In      AL, DX
                In      AL, DX
                In      AL, DX
                In      AL, DX

                Pop     DX
                Pop     AX

                Ret

EndP            GUSDelay

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            ResetGUS                        ; AX = baseport.

                Push    AX
                Push    DX

                Mov     DX, AX
                Add     DX, 103h                ; Select register

                Mov     AL, 4Ch                 ; Reset global register
                Out     DX, AL

                Add     DL, 2                   ; 8 bit data
                Xor     AL, AL
                Out     DX, AL                  ; Reset GUS!

                Call    GUSDelay
                Call    GUSDelay

                Mov     AL, 1
                Out     DX, AL

                Call    GUSDelay
                Call    GUSDelay

                Pop     DX
                Pop     AX

                Ret

EndP            ResetGUS

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

                Mov     BX, 200
                Call    SetInfoLine

                Mov     AX, 1
                Ret

EndP            SetMixMode
                Assume DS:Nothing

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

                Mov     CX, 44100
                Cmp     AX, CX
                JA      GetSBMixConst1

                Mov     CX, 12000
                Cmp     AX, CX
                JB      GetSBMixConst1

                Mov     CX, AX

GetSBMixConst1:
                                        ; OK.. find number of voices to
                                        ; achieve desired mix speed.
                Mov     SI, Offset GUSMixTable
                Mov     BL, 14
                Mov     CX, 32-14

GetSBMixConst2:
                LodsW
                Cmp     AX, CX
                JAE     GetSBMixConst3

                Inc     BL
                Loop    GetSBMixConst2

GetSBMixConst3:
                Mov     GUSChannels, BL

                Pop     DS
                PopA
                Ret

EndP            GetSBMixConst
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

                Mov     SI, Offset ULTRASNDString
                Mov     CX, 8
                Call    GetEnvironment  ; Returns ES:DI, Carry if error
                JC      DetectCardError

                Xor     DX, DX          ; Baseport first.

DetectCard1:
                Mov     AL, [ES:DI]
                Inc     DI

                Cmp     AL, ','
                JE      DetectCard2

                Sub     AL, '0'
                JC      DetectCardError
                Cmp     AL, '9'
                JA      DetectCardError

                ShL     DX, 4
                Add     DL, AL
                Jmp     DetectCard1

DetectCard2:
                Cmp     DX, 210h
                JB      DetectCardError
                Cmp     DX, 280h
                JA      DetectCardError

                Mov     BasePort, DX
                Add     DX, 102h
                Mov     GUSVoiceSelect, DX
                Inc     DL
                Mov     GUSRegisterSelect, DX

                                        ; Get DMA
                Xor     DX, DX

DetectCard3:
                Mov     AL, [ES:DI]
                Inc     DI
                Cmp     AL, ','
                JE      DetectCard4

                Sub     AL, '0'
                JC      DetectCardError
                Cmp     AL, 9
                JA      DetectCardError

                IMul    DX, 10
                Add     DL, AL
                Jmp     DetectCard3

DetectCard4:
                Cmp     DX, 7
                JA      DetectCardError

                Mov     DMA, DX

                Xor     DX, DX

DetectCard5:
                Mov     AL, [ES:DI]
                Inc     DI
                Cmp     AL, ','
                JE      DetectCard6

                Sub     AL, '0'
                JC      DetectCardError
                Cmp     AL, 9
                JA      DetectCardError

                IMul    DX, 10
                Add     DL, AL
                Jmp     DetectCard5

DetectCard6:
                Cmp     DX, 7
                JA      DetectCardError
                                ; Wasted DMA..

                                ; IRQ..

                Xor     DX, DX

DetectCard7:
                Mov     AL, [ES:DI]
                Inc     DI
                Cmp     AL, ','
                JE      DetectCard8

                Sub     AL, '0'
                JC      DetectCardError
                Cmp     AL, 9
                JA      DetectCardError

                IMul    DX, 10
                Add     DL, AL
                Jmp     DetectCard7

DetectCard8:
                Cmp     DX, 15
                JA      DetectCardError

                Mov     IRQ, DX

                Mov     EAX, 'Jeff'
                ClC
                Ret

DetectCardError:
                StC
                Ret

EndP            DetectCard
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

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

Proc            GUSIRQHandler

                PushAD
                Push    DS
                Push    ES

                CLD

                Mov     AX, CS
                Mov     DS, AX
                        Assume DS:Driver

                Mov     AL, 20h
                Cmp     IRQ, 7
                JBE     GUSIRQHandler1

                Out     0A0h, AL

GUSIRQHandler1:
                Out     20h, AL

                Mov     DX, BasePort
                Add     DL, 6
                In      AL, DX

                Test    AL, 20h
                JZ      GUSIRQHandlerEnd

                                        ; OK.. need to determine Cause type
GUSIRQAgain:
                Mov     DX, GUSRegisterSelect
                Mov     AL, 8Fh
                Out     DX, AL
                Add     DL, 2
                In      AL, DX  ; Bit 6 = waveramp IRQ

                Test    AL, 80h
                JZ      GUSLoopIRQ

                Jmp     GUSIRQHandlerEnd

GUSLoopIRQ:                             ; Need to disable looping and
                                        ; enable rollover. Set End address
                                        ; to midpoint.
                Xor     MixBufferPos, 1
                JZ      GUSRolloverIRQ

;                Mov     MixBufferDestination, DMABUFFERLENGTH/16/2
                Mov     MixBufferDestination, DMABUFFERLENGTH

                Mov     DX, GUSVoiceSelect
                Xor     AL, AL
                Out     DX, AL

                Inc     DX
                Call    GUSDelay

                Mov     AL, 4           ; End address high
                Out     DX, AL
                Mov     AX, HALFENDLOCATIONHIGH
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 5           ; End address low
                Out     DX, AL
                Mov     AX, HALFENDLOCATIONLOW
;                Cmp     CS:Stereo, 0
;                JE      HalfEndLocationMono
;
;                Mov     AX, HALFENDLOCATIONSTEREOLOW
;
; HalfEndLocationMono:
                Inc     DX
                Out     DX, AX
                Dec     DX

                Xor     AL, AL
                Out     DX, AL
                Mov     AL, 4+32        ; 16-bit data, no loop, no IRQ.
                Add     DL, 2
                Out     DX, AL
                Call    GUSDelay
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 0Dh
                Out     DX, AL
                Mov     AL, 3+4     ; Enable rollover
                Add     DL, 2
                Out     DX, AL
                Call    GUSDelay
                Out     DX, AL
                Sub     DL, 2

                Jmp     GUSIRQEnd

GUSRolloverIRQ:                         ; Need to disable rollover and
                                        ; enable looping. Set End address
                                        ; to endpoint.
                Mov     MixBufferDestination, 0

                Mov     DX, GUSVoiceSelect
                Xor     AL, AL
                Out     DX, AL

                Call    GUSDelay
                Inc     DX

                Mov     AL, 4           ; End address high
                Out     DX, AL
                Mov     AX, ENDLOCATIONHIGH
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 5           ; End location low
                Out     DX, AL
                Mov     AX, ENDLOCATIONLOW

;                Cmp     Stereo, 0
;                JE      EndLocationMono
;
;                Mov     AX, ENDLOCATIONSTEREOLOW
;
; EndLocationMono:
                Inc     DX
                Out     DX, AX
                Dec     DX

                Xor     AL, AL
                Out     DX, AL
                Mov     AL, 4+8+32      ; 16-bit data, looping + Wavetable IRQ
                Add     DL, 2
                Out     DX, AL
                Call    GUSDelay
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 0Dh
                Out     DX, AL
                Mov     AL, 3           ; Disable rollover
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

;                Jmp     GUSIRQAgain

GUSIRQEnd:
                                        ; OK... time to get next block
                                        ;  Check whether stereo thing is on..
                                        ;
                LES     DI, [ActualDMAPtr]

                Mov     BX, DMASize             ; BX = bytes required
                ShR     BX, 1
                                                ; BX = samples required
                Mov     BP, 8                   ; Skip for mono
                Mov     CL, 14                  ; Shift for mono

                Cmp     Stereo, 0
                JE      GUSIRQHandlerMono

                Mov     BP, 4                   ; Stereo skip value.
                Dec     CL

GUSIRQHandlerMono:
                Call    SaveEMSPageFrame

                Cmp     MixTransferRemaining, 0
                JNE     GUSIRQHandler4
                        Assume DS:Nothing

GUSIRQHandler3:
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

GUSIRQHandler4:
                Mov     DS, MixSegment
                Mov     SI, MixTransferOffset
                Mov     DX, BX          ;  DX = samples to transfer
                Cmp     DX, MixTransferRemaining
                JBE     GUSIRQHandler5

                Mov     DX, MixTransferRemaining

GUSIRQHandler5:
                Push    DX
                Cmp     CS:Filter, 1
                JB      GUSIRQHandler6
                JE      GUSIRQHFilter

                Cmp     CS:Stereo, 0
                JE      GUSIRQ3QFilterMono

GUSIRQ3QFilterStereo:
                Push    BX

                Mov     EBX, FilterValue
                Mov     EBP, FilterValue2
                ShR     DX, 1

GUSIRQ3QFilterStereo1:
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
                JL      GUS3QFilterStereoClip1
                Cmp     EAX, 7FFFh
                JG      GUS3QFilterStereoClip2

GUSIRQ3QFilterStereo2:
                StosW

                Mov     EAX, EBP
                SAR     EAX, 13

                Cmp     EAX, -8000h
                JL      GUS3QFilterStereoClip3
                Cmp     EAX, 7FFFh
                JG      GUS3QFilterStereoClip4

GUSIRQ3QFilterStereo3:
                StosW

                Add     SI, 8
                Dec     DX
                JNZ     GUSIRQ3QFilterStereo1

                Mov     FilterValue, EBX
                Mov     FilterValue2, EBP

                Pop     BX

                Jmp     GUSMixTransferEnd

GUSIRQ3QFilterMono:
                Push    BX

                Mov     EBX, FilterValue

GUSIRQ3QFilterMono1:
                Mov     EAX, EBX
                Add     EAX, [SI]
                SAR     EAX, 1
                Add     EBX, EAX
                SAR     EBX, 1
                Mov     EAX, EBX
                SAR     EAX, 14

                Cmp     EAX, -8000h
                JL      GUS3QFilterMonoClip1
                Cmp     EAX, 7FFFh
                JG      GUS3QFilterMonoClip2

GUSIRQ3QFilterMono2:
                StosW

                Add     SI, 8
                Dec     DX
                JNZ     GUSIRQ3QFilterMono1

                Mov     FilterValue, EBX

                Pop     BX

                Jmp     GUSMixTransferEnd

GUSIRQHFilter:
                Cmp     CS:Stereo, 0
                JE      GUSIRQHFilterMono

GUSIRQHFilterStereo:
                Push    BX

                Mov     EBX, FilterValue
                Mov     EBP, FilterValue2
                ShR     DX, 1

GUSIRQHFilterStereo1:
                Add     EBX, [SI]
                Add     EBP, [SI+4]

                SAR     EBX, 1
                SAR     EBP, 1

                Mov     EAX, EBX
                SAR     EAX, 13

                Cmp     EAX, -8000h
                JL      GUSHFilterStereoClip1
                Cmp     EAX, 7FFFh
                JG      GUSHFilterStereoClip2

GUSIRQHFilterStereo2:
                StosW

                Mov     EAX, EBP
                SAR     EAX, 13

                Cmp     EAX, -8000h
                JL      GUSHFilterStereoClip3
                Cmp     EAX, 7FFFh
                JG      GUSHFilterStereoClip4

GUSIRQHFilterStereo3:
                StosW

                Add     SI, 8
                Dec     DX
                JNZ     GUSIRQHFilterStereo1

                Mov     FilterValue, EBX
                Mov     FilterValue2, EBP

                Pop     BX

                Jmp     GUSMixTransferEnd

GUSIRQHFilterMono:
                Push    BX

                Mov     EBX, FilterValue

GUSIRQHFilterMono1:
                Add     EBX, [SI]
                SAR     EBX, 1
                Mov     EAX, EBX
                SAR     EAX, 14

                Cmp     EAX, -8000h
                JL      GUSHFilterMonoClip1
                Cmp     EAX, 7FFFh
                JG      GUSHFilterMonoClip2

GUSIRQHFilterMono2:
                StosW

                Add     SI, 8
                Dec     DX
                JNZ     GUSIRQHFilterMono1

                Mov     FilterValue, EBX

                Pop     BX

                Jmp     GUSMixTransferEnd

GUSIRQHandler6:
                Mov     EAX, [SI]
                SAR     EAX, CL

                Cmp     EAX, -8000h
                JL      GUSIRQHandlerClip1
                Cmp     EAX, 7FFFh
                JG      GUSIRQHandlerClip2

GUSIRQHandler7:
                StosW                                   ; } Memory write

                Add     SI, BP
                Dec     DX
                JNZ     GUSIRQHandler6

GUSMixTransferEnd:
                Pop     DX

                Sub     MixTransferRemaining, DX        ; } Memory write
                Sub     BX, DX
                JNZ     GUSIRQHandler3

                Mov     MixTransferOffset, SI           ; } Memory write

                                        ; DMA the data to MixBufferDestination
                Comment ~

                Mov     AX, CS
                Mov     DS, AX
                        Assume DS:Driver

                Mov     BX, DMASegment
                Xor     AX, AX
                Mov     DX, DMA
                Mov     DI, DMABUFFERLENGTH
                Call    SetDMA

                Mov     DX, GUSRegisterSelect
                Mov     AL, 42h                 ; DMA destination
                Out     DX, AL
                Mov     AX, MixBufferDestination
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 41h                 ; DMA control register
                Out     DX, AL
                Mov     AL, 1
                Cmp     DMA, 4
                JB      DMAType

                Or      AL, 4

DMAType:
                Add     DL, 2
                Out     DX, AL

                ~

;                Comment ~

                LDS     SI, [ActualDMAPtr]
                Mov     DX, GUSRegisterSelect

                Mov     AL, 44h
                Out     DX, AL          ; High address
                Xor     AL, AL
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                Mov     DI, MixBufferDestination
                Mov     CX, DMASize

                Mov     AL, 43h
                Out     DX, AL
                Inc     DX

Output1:
                Mov     AX, DI
                Out     DX, AX
                Add     DL, 3

                Mov     AL, [SI]
                Out     DX, AL

                Sub     DL, 3
                Inc     SI
                Inc     DI
                Dec     CX
                JNZ     Output1

;                ~

                Call    RestoreEMSPageFrame

GUSIRQHandlerEnd:
                Pop     ES
                Pop     DS
                PopAD
                IRet
                        Assume DS:Nothing

GUSIRQHandlerClip1:
                Mov     AX, 8000h
                Jmp     GUSIRQHandler7

GUSIRQHandlerClip2:
                Mov     AX, 7FFFh
                Jmp     GUSIRQHandler7

GUSHFilterMonoClip1:
                Mov     AX, 8000h
                Jmp     GUSIRQHFilterMono2

GUSHFilterMonoClip2:
                Mov     AX, 7FFFh
                Jmp     GUSIRQHFilterMono2

GUSHFilterStereoClip1:
                Mov     AX, 8000h
                Jmp     GUSIRQHFilterStereo2

GUSHFilterStereoClip2:
                Mov     AX, 7FFFh
                Jmp     GUSIRQHFilterStereo2

GUSHFilterStereoClip3:
                Mov     AX, 8000h
                Jmp     GUSIRQHFilterStereo3

GUSHFilterStereoClip4:
                Mov     AX, 7FFFh
                Jmp     GUSIRQHFilterStereo3

GUS3QFilterMonoClip1:
                Mov     AX, 8000h
                Jmp     GUSIRQ3QFilterMono2

GUS3QFilterMonoClip2:
                Mov     AX, 7FFFh
                Jmp     GUSIRQ3QFilterMono2

GUS3QFilterStereoClip1:
                Mov     AX, 8000h
                Jmp     GUSIRQ3QFilterStereo2

GUS3QFilterStereoClip2:
                Mov     AX, 7FFFh
                Jmp     GUSIRQ3QFilterStereo2

GUS3QFilterStereoClip3:
                Mov     AX, 8000h
                Jmp     GUSIRQ3QFilterStereo3

GUS3QFilterStereoClip4:
                Mov     AX, 7FFFh
                Jmp     GUSIRQ3QFilterStereo3

EndP            GUSIRQHandler
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
                Mov     AX, Offset GUSIRQHandler

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

Proc            StartGUS               ;

                PushA
                Push    ES

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

                Mov     DX, BasePort
                Mov     AL, 1
                Out     DX, AL

                Mov     AX, DX
                Call    ResetGUS

                Mov     DX, GUSRegisterSelect   ; Tell the GUS how many voices
                Mov     AL, 0Eh                 ; to use
                Out     DX, AL

                Add     DL, 2           ; DX = BasePort + 105h
                Mov     AL, GUSChannels
                Dec     AL
                Or      AL, 0C0h
                Out     DX, AL          ; Number of Voices set

                                        ; Reset each voice

                Mov     CX, 32          ; 32 voices to clear.

                Sub     DL, 3           ; DX = Voice select register

GUSResetVoice:
                Mov     AL, CL
                Dec     AL
                Out     DX, AL

                Inc     DX              ; DX = BasePort + 103h
                Xor     AL, AL          ; Voice control register, 8 bit
                Out     DX, AL

                Add     DL, 2
                Mov     AL, 2
                Out     DX, AL          ; Stop voice
                Call    GUSDelay
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 0Dh         ; Volume Ramp.
                Out     DX, AL

                Mov     AL, 3
                Add     DL, 2
                Out     DX, AL
                Call    GUSDelay
                Out     DX, AL
                Sub     DL, 2


                Mov     AL, 6           ; Ramp rate
                Out     DX, AL

                Mov     AL, 63          ; Ramp rate
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2


                Mov     AL, 9           ; Volume register, 16 bit
                Out     DX, AL

                Inc     DX
                Xor     AX, AX
                Out     DX, AX          ; No volume
                Call    GUSDelay
                Out     DX, AX

                Sub     DL, 2           ; DX = BasePort + 102h = Voice select.

                Loop    GUSResetVoice

                                ; OK.. now... gotta clear memory from
                                ; 0->DMABUFFERLENGTH*2

                Mov     CX, DMABUFFERLENGTH*2
                Xor     DI, DI          ; DI = destination

                ClI

                Inc     DX              ; DX = register select
                Mov     AL, 44h
                Out     DX, AL

                Xor     AL, AL
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 43h
                Out     DX, AL
                Inc     DX

ClearGUSRAM:
                Mov     AX, DI                  ; Memory location low
                Out     DX, AX                  ; Memory location done.

                Xor     AL, AL
                Add     DL, 3
                Out     DX, AL
                Sub     DL, 3

                Inc     DI
                Dec     CX
                JNZ     ClearGUSRAM

                StI
                                        ; OK.. enable interrupt
                Mov     DX, BasePort
                Mov     AL, 9
                Out     DX, AL          ; Enables DMA/IRQ

                Mov     DX, GUSRegisterSelect
                Mov     AL, 4Ch
                Out     DX, AL
                Add     DL, 2
                Mov     AL, 7
                Out     DX, AL          ; Enables IRQ

                                        ; Setup voices
                ClI
                Cmp     Stereo, 0
                JE      StartGUSMono

StartGUSStereo:                         ; Uses voices 0 and 1
                Mov     DX, GUSVoiceSelect
                Xor     AL, AL
                Out     DX, AL
                Call    GUSDelay
                Inc     DX

                Mov     AL, 1           ; Freq control
                Out     DX, AL
                Inc     DX
                Mov     AX, 0000100000000000b
                Out     DX, AX
                Dec     DX

                Mov     AL, 2           ; Starting location high
                Out     DX, AL
                Xor     AX, AX
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 3           ; Starting location low
                Out     DX, AL
                Xor     AX, AX
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 4           ; End location high
                Out     DX, AL
                Mov     AX, HALFENDLOCATIONHIGH
                Xor     AX, AX
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 5           ; End location low
                Out     DX, AL
                Mov     AX, HALFENDLOCATIONLOW
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 9           ; Current volume
                Out     DX, AL
                Mov     AX, 0EFF0h
                Inc     DX
                Out     DX, AX
                Call    GUSDelay
                Out     DX, AX
                Dec     DX

                Mov     AL, 0Ah         ; Current location high
                Out     DX, AL
                Xor     AX, AX
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 0Bh         ; Current location low
                Out     DX, AL
                Xor     AX, AX
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 0Ch         ; Pan position
                Out     DX, AL
                Mov     AL, 0           ; Full left.
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 0Dh         ; Set rollover condition
                Out     DX, AL
                Mov     AL, 4+2+1       ; Rollover
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                Mov     DX, GUSVoiceSelect
                Mov     AL, 1           ; Voice 1
                Out     DX, AL
                Call    GUSDelay
                Inc     DX

                Mov     AL, 1           ; Freq control
                Out     DX, AL
                Inc     DX
                Mov     AX, 0000100000000000b
                Out     DX, AX
                Dec     DX

                Mov     AL, 2           ; Starting location high
                Out     DX, AL
                Xor     AX, AX
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 3           ; Starting location low
                Out     DX, AL
                Mov     AX, 0000001000000000b
                Xor     AX, AX
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 4           ; End location high
                Out     DX, AL
                Mov     AX, 20h         ; ENDLOCATIONHIGH
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 5           ; End location low
                Out     DX, AL
                Mov     AX, 0           ; ENDLOCATIONLOW
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 9           ; Current volume
                Out     DX, AL
                Mov     AX, 0EFF0h
                Inc     DX
                Out     DX, AX
                Call    GUSDelay
                Out     DX, AX
                Dec     DX

                Mov     AL, 0Ah         ; Current location high
                Out     DX, AL
                Xor     AX, AX
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 0Bh         ; Current location low
                Out     DX, AL
                Mov     AX, 0000001000000000b
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 0Ch         ; Pan position
                Out     DX, AL
                Mov     AL, 0Fh         ; Full right
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2
                                        ; start voices.

                Mov     AL, 0Dh
                Out     DX, AL
                Mov     AL, 3
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                CLI

                Mov     DX, GUSVoiceSelect      ; Select voice 0
                Xor     AL, AL
                Out     DX, AL

;                Call    GUSDelay

                Inc     DX
                Out     DX, AL
                Mov     AL, 4+32        ; 16-bit data, IRQ enabled
                Add     DL, 2
                Out     DX, AL

;                Call    GUSDelay
;                Out     DX, AL

                Sub     DL, 3

                Mov     AL, 1           ; Select voice 1
                Out     DX, AL

;                Call    GUSDelay

                Inc     DX
                Xor     AL, AL
                Out     DX, AL
                Mov     AL, 4+8         ; 16-bit, Loop
                Add     DL, 2
                Out     DX, AL

;                Call    GUSDelay
;                Out     DX, AL

                Jmp     StartGUSEnd

StartGUSMono:                           ; Uses voice 0
                Mov     DX, GUSVoiceSelect
                Xor     AL, AL
                Out     DX, AL
                Call    GUSDelay
                Inc     DX

                Mov     AL, 1           ; Freq control
                Out     DX, AL
                Inc     DX
                Mov     AX, 0000010000000000b
                Out     DX, AX
                Dec     DX

                Mov     AL, 2           ; Starting location high
                Out     DX, AL
                Xor     AX, AX
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 3           ; Starting location low
                Out     DX, AL
                Xor     AX, AX
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 4           ; End location high
                Out     DX, AL
                Mov     AX, HALFENDLOCATIONHIGH
                Xor     AX, AX
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 5           ; End location low
                Out     DX, AL
                Mov     AX, HALFENDLOCATIONLOW
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 9           ; Current volume
                Out     DX, AL
                Mov     AX, 0EFF0h
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 0Ah         ; Current location high
                Out     DX, AL
                Xor     AX, AX
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 0Bh         ; Current location low
                Out     DX, AL
                Xor     AX, AX
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 0Ch         ; Pan position
                Out     DX, AL
                Mov     AL, 8           ; Central.
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 0Dh         ; Set rollover condition
                Out     DX, AL
                Mov     AL, 4+2+1       ; Rollover
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                Xor     AL, AL
                Out     DX, AL
                Mov     AL, 4+32        ; 16-bit data, IRQ enabled
                Add     DL, 2
                Out     DX, AL
                Call    GUSDelay
                Out     DX, AL

StartGUSEnd:
                StI

                Pop     ES
                PopA

                Ret


EndP            StartGUS
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
                Mov     AX, BasePort
                Call    ResetGUS

                                ; SetupMIDI
                Mov     DX, BasePort
                Inc     DH
                Mov     AL, 0FFh
                Out     DX, AL
                Mov     AL, 0FCh
                Out     DX, AL

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

                        ; Allocate MixSegment first
                Mov     AH, 48h
                Mov     BX, 3859+(DMABUFFERLENGTH*2)/16
                                ; 3859 = (256*2*65+8*44100/(.4*31))/16
                Int     21h
                JNC     InitSound1

InitSoundNoMemory:
                Mov     SI, Offset GUSNoMemoryMsg
                Ret

InitSound1:
                Mov     MixSegment, AX
                Add     AX, 3859
                Mov     DMASegment, AX

                Call    SetIRQ
                Call    GetSBMixConst
                Call    GetTempo
                Call    SetTempo

                Mov     SI, Offset GUSMsg

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
                Mov     BX, 200
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

                Mov     AX, BasePort
                Call    ResetGUS

                Mov     DX, BasePort
                Inc     DH
                Mov     AL, 0FFh
                Out     DX, AL          ; Stop MIDI

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

                Mov     DX, CS:GUSVoiceSelect
                Xor     AL, AL
                Out     DX, AL
                Inc     DX
                Mov     AL, 8Ah
                Out     DX, AL
                Inc     DX
                In      AX, DX
                ShL     EAX, 16
                Dec     DX
                Mov     AL, 8Bh
                OUt     DX, AL
                Inc     DX
                In      AX, DX
                ShR     EAX, 9
                Mov     CS:Voice0Position, EAX

                Mov     DX, CS:GUSVoiceSelect
                Mov     AL, 1
                Out     DX, AL
                Inc     DX
                Mov     AL, 8Ah
                Out     DX, AL
                Inc     DX
                In      AX, DX
                ShL     EAX, 16
                Dec     DX
                Mov     AL, 8Bh
                OUt     DX, AL
                Inc     DX
                In      AX, DX
                ShR     EAX, 9
                Mov     CS:Voice1Position, EAX

                Call    [CS:UARTBufferEmpty]
                JNC     MIDIEnd

                Mov     DX, [CS:BasePort]
                Inc     DH
                In      AL, DX
                Test    AL, 1
                JZ      MIDIEnd

                Inc     DX
                In      AL, DX
                Cmp     AL, 0F0h
                JAE     MIDIEnd

                Call    [CS:UARTSend]

MIDIEnd:

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
                Call    StartGUS

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
                Mov     DX, Offset GUSScreenList

                ClC
                Ret

EndP            SoundCardScreen

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            GetVariable Far         ; Returns AX, given DI

                Ret

EndP            GetVariable

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetVariable Far         ; Given AX, DI

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
