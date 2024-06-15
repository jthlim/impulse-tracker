
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
MIXRESOLUTION   EQU     16      ; 32 bit mixing for the PAS16
MIXTABLESIZE    EQU     2*256*65
TIMERCONST      EQU     11932

Debug1          DB      0
Debug2          DW      0

PAS16Msg        DB      "Pro Audio Spectrum found", 13
                DB      "Port ", 0FDh, "Xh, IRQ ", 0FDh, "D, DMA ", 0FDh, "D", 0

PAS16NoMemoryMsg DB     "Pro Audio Spectrum found", 13
                DB      "Error: Insufficient memory", 0

ReinitMsg       DB      "Pro Audio Spectrum reinitialised", 0

ConfigErrorMsg  DB      "Error saving configuration to ITPAS.DRV", 0
ConfigOKMsg     DB      "Configuration saved to ITPAS.DRV", 0

DriverName      DB      "ITPAS.DRV", 0

Forced          DB      0
Stereo          DB      0
MixVolume       DW      0

BytesToMix      DW      1000
MixSpeed        DW      44100
PASMixConst     DW      0

MixSegment      DW      0
DMASegment      DW      0

MixTransferOffset       DW      0
MixTransferRemaining    DW      0

CONFIGURATIONOFFSET     EQU     $+128
CONFIGSIZE              EQU     6
MixMode                 DW      0
MixModeOffset           DW      0
Filter                  DW      0

IMR             DW      0
OldIRQHandler   DD      0

FilterValue     DW      0
FilterValue2    DW      0
TimerAccumulator        DW      0

DMALengthTable  Label   Byte
        DB      1, 3, 5, 7, 0C2h, 0C6h, 0CAh, 0CEh

;**********************************

PAS16ScreenList          Label
                        DW      6
                        DW      Near Ptr IdleFunctionList
                        DW      Near Ptr GlobalKeyLink

                        DW      Near Ptr FullScreenBox  ; 0
                        DW      Near Ptr ScreenHeader
                        DW      Near Ptr FillHeader
                        DW      Near Ptr PASHeaderLine

                        DW      Near Ptr DriverText

                        DW      Near Ptr MixModeText
                        DW      Near Ptr MixModeButton1         ; 6
                        DW      Near Ptr MixModeButton2         ; 7

                        DW      Near Ptr FilterText
                        DW      Near Ptr FilterButton1          ; 9
                        DW      Near Ptr FilterButton2
                        DW      Near Ptr FilterButton3

                        DW      0

PASHeaderLine           DW      10
                        DB      "Pro Audio Spectrum Driver", 0

EmptyObject             DW      1
                        DB      0, 0
                        DB      0
                        DB      0

DriverText              DW      1
                        DB      29, 48
                        DB      21h
                        DB      "Pro Audio Spectrum Driver 1.0 for Impulse Tracker", 0

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
                        DW      6, 9, 0FFFFh, 0FFFFh
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

FilterText              DW      1
                        DB      2, 22
                        DB      20h
                        DB      "Filter mode", 0

FilterButton1           DW      2
                        DW      7, 10, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetFilter
DriverSegment9          DW      0
                        DW      0
                        DW      Offset SetFilter
DriverSegment10         DW      0
                        DB      3, 24, 29, 26, 8
                        DB      0
                        DB      "  No Filter", 0

FilterButton2           DW      2
                        DW      9, 11, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetFilter
DriverSegment11         DW      0
                        DW      1
                        DW      Offset SetFilter
DriverSegment12         DW      0
                        DB      3, 27, 29, 29, 8
                        DB      0
                        DB      "  50% Filter", 0

FilterButton3           DW      2
                        DW      10, 0FFFFh, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetFilter
DriverSegment13         DW      0
                        DW      2
                        DW      Offset SetFilter
DriverSegment14         DW      0
                        DB      3, 30, 29, 32, 8
                        DB      0
                        DB      "  75% Filter", 0

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

RelocationTable         Label   Word
        DW      Offset DriverSegment1, Offset DriverSegment2
        DW      Offset DriverSegment3, Offset DriverSegment4
        DW      Offset DriverSegment9, Offset DriverSegment10
        DW      Offset DriverSegment11, Offset DriverSegment12
        DW      Offset DriverSegment13, Offset DriverSegment14
        DW      0

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

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            GetMixSpeed
                Assume DS:Driver

                Push    AX
                Push    CX
                Push    DX

                Mov     DX, 12h
                Mov     AX, 34DCh
                Mov     CX, PASMixConst
                Cmp     CS:Stereo, 0
                JE      GetMixSpeed1

                And     CX, Not 1

GetMixSpeed1:
                Div     CX

GetMixSpeed2:
                Mov     MixSpeed, AX

                Pop     DX
                Pop     CX
                Pop     AX
                Ret

EndP            GetMixSpeed
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            GetPASMixConst                  ; Work out value.. and nearest
                                                ; mixspeed value.

                PushA
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     AX, CmdLineMixSpeed
                Mov     CX, MixSpeed
                Test    AX, AX
                JZ      GetPASMixConst1

                Mov     CX, 44100
                Cmp     AX, CX
                JA      GetPASMixConst1

                Mov     CX, 12000
                Cmp     AX, CX
                JB      GetPASMixConst1

                Mov     CX, AX

GetPASMixConst1:
                Mov     MixSpeed, CX

                Mov     DX, 012h
                Mov     AX, 34DCh
                Div     CX

                Mov     PASMixConst, AX
                Mov     BX, AX

                Pop     DS
                PopA
                Ret

EndP            GetPASMixConst
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            TestPAS                 ; AX = port

                Push    AX

                Mov     DX, 803h        ; Default is 0B8Bh
                Xor     DX, AX          ; DX = Interrupt Control port
                In      AL, DX

                Cmp     AL, 0FFh
                JE      TestPAS1

                Mov     AH, AL
                Xor     AL, 11100000b
                Out     DX, AL

                Jmp     $+2
                Jmp     $+2
                In      AL, DX

                Cmp     AL, AH
                XChg    AH, AL
                Out     DX, AL
                JNE     TestPAS1

                Pop     AX

                ClC
                Ret

TestPAS1:
                Pop     AX
                StC
                Ret

EndP            TestPAS

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

                Mov     AX, 0BC00h
                Mov     BX, '??'
                Xor     CX, CX
                Xor     DX, DX
                Int     2Fh

                Xor     BX, CX
                Xor     BX, DX
                Cmp     BX, 'M'*256+'V'
                JE      DetectPAS4              ; MVSound.Sys installed!

DetectPAS7:
                StC
                Ret

DetectPAS4:
                Mov     AX, BasePort
                Cmp     AX, 0FFFFh
                JE      DetectPAS1
                Cmp     AX, 388h
                JE      DetectPAS6
                Cmp     AX, 384h
                JE      DetectPAS6
                Cmp     AX, 38Ch
                JE      DetectPAS6
                Cmp     AX, 288h
                JNE     DetectPAS7

DetectPAS6:
                Call    TestPAS
                JNC     DetectPAS2

                Ret

DetectPAS1:
                Mov     AX, 388h
                Call    TestPAS
                JNC     DetectPAS2

                Mov     AX, 384h
                Call    TestPAS
                JNC     DetectPAS2

                Mov     AX, 38Ch
                Call    TestPAS
                JNC     DetectPAS2

                Mov     AX, 288h
                Call    TestPAS
                JNC     DetectPAS2

                Ret                     ; No card!

DetectPAS2:
                Push    AX

                Mov     AX, 0BC04h
                Int     2Fh

                Cmp     AX, 'M'*256+'V'
                JNE     DetectPAS3

                Pop     AX

                Mov     BasePort, AX
                Mov     DMA, BX
                Mov     IRQ, CX

                Mov     AL, [DMALengthTable+BX]
                Mov     Byte Ptr [DMAPort1], AL
                Mov     Byte Ptr [DMAPort2], AL

                Mov     AX, DMABUFFERLENGTH/2
                Cmp     BX, 4
                JB      DetectPAS5

                ShR     AX, 1

DetectPAS5:
                Mov     Word Ptr [DMABufferLength1], AX
                Mov     Word Ptr [DMABufferLength2], AX

                Mov     EAX, 'Jeff'

                ClC
                Ret

DetectPAS3:
                Pop     AX
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
                Mov     AX, 2020h
                Mov     DX, CX
                Add     CX, CX

                Mov     MixTransferOffset, DI           ; } Memory write

                Cmp     Stereo, 0
                JE      MixSamples1

                ShR     AX, 1
                Mov     DX, CX

MixSamples1:
                Rep     StosW                           ; } Memory write
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

Proc            PAS16IRQHandler

                Push    AX
                Push    BX
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Add     TimerAccumulator, TIMERCONST
                JC      PAS16IRQHandler11

                Mov     AL, 20h
                Out     20h, AL
                Jmp     PAS16IRQHandler12

PAS16IRQHandler11:
                PushF
                Call    [OldIRQHandler]

PAS16IRQHandler12:

DMAPort1 EQU $+1
                In      AL, 1
                Mov     AH, AL
DMAPort2 EQU $+1
                In      AL, 1
                XChg    AL, AH

                Mov     Debug2, AX

                Cmp     MixBufferPos, 0
                JE      PAS16IRQHandler13

                Xor     BX, BX
DMABufferLength1 EQU $+1
                Cmp     AX, 1234h
                JB      PAS16IRQHandler1

                Pop     DS
                Pop     BX
                Pop     AX
                IRet

PAS16IRQHandler13:
                Mov     BX, DMABUFFERLENGTH/2
DMABufferLength2 EQU $+1
                Cmp     AX, 1234h
                JAE     PAS16IRQHandler1

                Pop     DS
                Pop     BX
                Pop     AX
                IRet

PAS16IRQHandler1:
                Xor     MixBufferPos, 1

                PushAD
                Push    ES

                CLD


                                        ; OK... time to get next block
                                        ;  Check whether stereo thing is on..
                                        ;
                LES     DI, [ActualDMAPtr]
                Add     DI, BX

                Mov     BX, DMABUFFERLENGTH/2   ; BX = samples required
                Mov     BP, 4                   ; Skip for mono
                Mov     CL, 6                   ; Shift for mono

                Cmp     Stereo, 0
                JE      PAS16IRQHandlerMono

                Mov     BP, 2                   ; Stereo skip value.
                Dec     CL

PAS16IRQHandlerMono:
                Call    SaveEMSPageFrame

                Cmp     MixTransferRemaining, 0
                JNE     PAS16IRQHandler4
                        Assume DS:Nothing

PAS16IRQHandler3:
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

PAS16IRQHandler4:
                Mov     DS, MixSegment
                Mov     SI, MixTransferOffset
                Mov     DX, BX          ;  DX = samples to transfer
                Cmp     DX, MixTransferRemaining
                JBE     PAS16IRQHandler5

                Mov     DX, MixTransferRemaining

PAS16IRQHandler5:
                Push    DX
                Cmp     CS:Filter, 1
                JB      PAS16IRQHandler6
                JE      PAS16IRQHFilter

                Cmp     CS:Stereo, 0
                JE      PAS16IRQ3QFilterMono

PAS16IRQ3QFilterStereo:
                Push    BX

                Mov     BX, FilterValue
                Mov     BP, FilterValue2
                ShR     DX, 1

PAS16IRQ3QFilterStereo1:
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
                JNZ     PAS163QFilterStereoClip1

PAS16IRQ3QFilterStereo2:
                StosB

                Mov     AX, BP
                SAR     AX, 5

                Test    AH, AH
                JNZ     PAS163QFilterStereoClip3

PAS16IRQ3QFilterStereo3:
                StosB

                Add     SI, 4
                Dec     DX
                JNZ     PAS16IRQ3QFilterStereo1

                Mov     FilterValue, BX
                Mov     FilterValue2, BP

                Pop     BX

                Jmp     PAS16MixTransferEnd

PAS16IRQ3QFilterMono:
                Push    BX

                Mov     BX, FilterValue

PAS16IRQ3QFilterMono1:
                Mov     AX, BX
                Add     AX, [SI]
                SAR     AX, 1
                Add     BX, AX
                SAR     BX, 1
                Mov     AX, BX
                SAR     AX, 6

                Test    AH, AH
                JNZ     PAS163QFilterMonoClip1

PAS16IRQ3QFilterMono2:
                StosB

                Add     SI, 4
                Dec     DX
                JNZ     PAS16IRQ3QFilterMono1

                Mov     FilterValue, BX

                Pop     BX

                Jmp     PAS16MixTransferEnd

PAS16IRQHFilter:
                Cmp     CS:Stereo, 0
                JE      PAS16IRQHFilterMono

PAS16IRQHFilterStereo:
                Push    BX

                Mov     BX, FilterValue
                Mov     BP, FilterValue2
                ShR     DX, 1

PAS16IRQHFilterStereo1:
                Add     BX, [SI]
                Add     BP, [SI+2]

                SAR     BX, 1
                SAR     BP, 1

                Mov     AX, BX
                SAR     AX, 5

                Test    AH, AH
                JNZ     PAS16HFilterStereoClip1

PAS16IRQHFilterStereo2:
                StosB

                Mov     AX, BP
                SAR     AX, 5

                Test    AH, AH
                JNZ     PAS16HFilterStereoClip3

PAS16IRQHFilterStereo3:
                StosB

                Add     SI, 4
                Dec     DX
                JNZ     PAS16IRQHFilterStereo1

                Mov     FilterValue, BX
                Mov     FilterValue2, BP

                Pop     BX

                Jmp     PAS16MixTransferEnd

PAS16IRQHFilterMono:
                Push    BX

                Mov     BX, FilterValue

PAS16IRQHFilterMono1:
                Add     BX, [SI]
                SAR     BX, 1
                Mov     AX, BX
                SAR     AX, 6

                Test    AH, AH
                JNZ     PAS16HFilterMonoClip1

PAS16IRQHFilterMono2:
                StosB

                Add     SI, 4
                Dec     DX
                JNZ     PAS16IRQHFilterMono1

                Mov     FilterValue, BX

                Pop     BX

                Jmp     PAS16MixTransferEnd

PAS16IRQHandler6:
                Mov     AX, [SI]
                SAR     AX, CL

                Test    AH, AH
                JNZ     PAS16IRQHandlerClip1

PAS16IRQHandler7:
                StosB                                   ; } Memory write

                Add     SI, BP
                Dec     DX
                JNZ     PAS16IRQHandler6

PAS16MixTransferEnd:
                Pop     DX

                Sub     MixTransferRemaining, DX        ; } Memory write
                Sub     BX, DX
                JNZ     PAS16IRQHandler3

                Mov     MixTransferOffset, SI           ; } Memory write

                Call    RestoreEMSPageFrame

                Pop     ES
                PopAD
                Pop     DS
                Pop     BX
                Pop     AX
                IRet

PAS16IRQHandlerClip1:
                Mov     AL, 0FFh
                JNS     PAS16IRQHandler7
                Mov     AL, 0
                Jmp     PAS16IRQHandler7

PAS16HFilterMonoClip1:
                Mov     AL, 0FFh
                JNS     PAS16IRQHFilterMono2
                Mov     AL, 0
                Jmp     PAS16IRQHFilterMono2

PAS16HFilterStereoClip1:
                Mov     AL, 0FFh
                JNS     PAS16IRQHFilterStereo2
                Mov     AL, 0
                Jmp     PAS16IRQHFilterStereo2

PAS16HFilterStereoClip3:
                Mov     AL, 0FFh
                JNS     PAS16IRQHFilterStereo3
                Mov     AL, 0
                Jmp     PAS16IRQHFilterStereo3

PAS163QFilterMonoClip1:
                Mov     AL, 0FFh
                JNS     PAS16IRQ3QFilterMono2
                Mov     AL, 0
                Jmp     PAS16IRQ3QFilterMono2

PAS163QFilterStereoClip1:
                Mov     AL, 0FFh
                JNS     PAS16IRQ3QFilterStereo2
                Mov     AL, 0
                Jmp     PAS16IRQ3QFilterStereo2

PAS163QFilterStereoClip3:
                Mov     AL, 0FFh
                JNS     PAS16IRQ3QFilterStereo3
                Mov     AL, 0
                Jmp     PAS16IRQ3QFilterStereo3

EndP            PAS16IRQHandler
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetIRQ

                Push    EAX
                Push    ES

                Xor     AX, AX
                Mov     ES, AX

                Mov     AL, 34h         ; Program IRQ 0. LSB&MSB, Rate gen
                Out     43h, AL

                                        ; bump the interrupt to be called
                                        ; 100 times a second.
                Mov     AX, TIMERCONST
                Out     40h, AL
                Mov     AL, AH
                Out     40h, AL

                Mov     AX, CS
                ShL     EAX, 16
                Mov     AX, Offset PAS16IRQHandler

                ClI

                XChg    [ES:20h], EAX           ; Hook to timer interrupt
                Mov     CS:OldIRQHandler, EAX

                StI

                Pop     ES
                Pop     EAX

                Ret

EndP            SetIRQ
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ResetIRQ

                Push    EAX
                Push    ES

                Xor     AX, AX
                Mov     ES, AX

                Mov     AL, 34h         ; Program IRQ 0. LSB&MSB, Rate gen
                Out     43h, AL

                Xor     AL, AL
                Out     40h, AL         ; Interrupt called at normal 18.2 times
                Out     40h, AL

                Mov     EAX, CS:OldIRQHandler
                Mov     [ES:20h], EAX

                Pop     ES
                Pop     EAX

                Ret

EndP            ResetIRQ
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            StopPAS16

                Mov     DX, BasePort
                Xor     AL, AL
                Xor     DX, 0B89h xor 388h      ; Interrupt Status register
                Out     DX, AL

                Mov     DX, BasePort            ; Audio filter control
                Mov     AL, 1
                Xor     DX, 0B8Ah xor 388h      ; Disable buffer counter
                Out     DX, AL                  ; and PAS 16 output

                Mov     DX, BasePort
                Mov     AL, 19h                 ; Mono, L2L, R2R
                Xor     DX, 0F8Ah xor 388h      ; Cross channel register
                Out     DX, AL

                Ret

EndP            StopPAS16

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            StartPAS16               ;

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

                Mov     DX, BasePort
                Xor     AL, AL
                Xor     DX, 0B89h xor 388h      ; Interrupt Status register
                Out     DX, AL

                Mov     DX, BasePort            ; Audio filter control
                Mov     AL, 1
                Xor     DX, 0B8Ah xor 388h      ; Disable buffer counter
                Out     DX, AL                  ; and PAS 16 output

                Mov     DX, BasePort
                Mov     AL, 19h
                Xor     DX, 0F8Ah xor 388h      ; Cross channel register
                Out     DX, AL

                Mov     DX, BasePort
                Xor     DX, 138Bh xor 388h      ; Timer control,
                Mov     AL, 00110110b           ; 36h - set frequency
                Out     DX, AL

                Mov     DX, BasePort
                Xor     DX, 1388h xor 388h
                Mov     AX, PASMixConst
                Cmp     Stereo, 0
                JE      StartPAS16_2

                ShR     AX, 1

StartPAS16_2:
                Out     DX, AL
                Mov     AL, AH
                Out     DX, AL

                Call    GetMixSpeed
                Call    GetTempo
                Call    SetTempo

                Mov     DX, BasePort
                Xor     DX, 138Bh xor 388h      ; Timer control
                Mov     AL, 01110100b           ; 74h - set buffer count
                Out     DX, AL

                Mov     DX, BasePort    ; Sample count
                Mov     AX, DMABUFFERLENGTH
                Xor     DX, 1389h xor 388h

                Cmp     DMA, 4
                JB      StartPAS16_1

                ShR     AX, 1

StartPAS16_1:
                Out     DX, AL
                Mov     AL, AH
                Out     DX, AL

                Mov     AL, Stereo
                Xor     AL, 1                   ; 0 if stereo, 1 if mono.
                ShL     AL, 5
                Mov     DX, BasePort
                Or      AL, 099h                ; Enable DRQ, DAC output
                Xor     DX, 0F8Ah xor 388h
                Out     DX, AL
                Jmp     $+2
                Jmp     $+2
                Or      AL, 40h                 ; Enable PCM
                Out     DX, AL

                Mov     DX, BasePort
                Xor     DX, 0B8Bh xor 388h
                In      AL, DX
                Or      AL, 8               ; Enable sample buffer intr
                Out     DX, AL

                Mov     DX, BasePort
                Mov     AL, 0E1h        ; disable mute, enable sample rate
                                        ; timer and sample buffer counter.
                Xor     DX, 0B8Ah xor 388h
                Out     DX, AL

                Pop     DS
                Pop     ES
                PopA

                Ret

                        Assume DS:Nothing

EndP            StartPAS16

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

                Call    GetPASMixConst
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
                Mov     SI, Offset PAS16NoMemoryMsg
                Ret

InitSound1:
                Mov     MixSegment, AX
                Add     AX, DX
                Mov     DMASegment, AX

                Call    SetIRQ
                Call    GetTempo
                Call    SetTempo

                Mov     SI, Offset PAS16Msg

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

                Call    StopPAS16
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

;                In      AL, 1
;                Mov     AH, AL
;                In      AL, 1
;                Mov     CS:Debug2, AX

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

Proc            RecalculateAllFrequencies

                Call    GetChannelTables

RecalculateAllFrequencies1:
                Or      Byte Ptr [SI], 32

                Add     SI, 128
                Dec     CX
                JNZ     RecalculateAllFrequencies1

                Ret

EndP            RecalculateAllFrequencies


Proc            SetStereo Far

                Mov     CS:Stereo, AL
                Cmp     CS:MixSegment, 0
                JE      SetStereo1

                Call    StopPAS16
                Call    StartPAS16

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
                Mov     DX, Offset PAS16ScreenList

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

                Comment ~

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

                ~

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
