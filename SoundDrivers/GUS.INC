
        .386P
        Jumps

Segment                 DriverHeader PARA Public 'Code' Use16
                        Assume CS:Driver, DS:Nothing

;***** Driver Header *******

include drhead.inc

EndS

Segment                 Driver PARA Public 'Code' Use16
                        Assume CS:Driver, DS:Nothing

ORG 0
StartDriver:

;**************************

include vtable.inc

;********  Required ProcedureTable *************

include reqproc.inc

;************** Local variables ****************

SLAVECHANNELSIZE        EQU     128

GUSReinitMsg    DB      "Gravis UltraSound reinitialised", 0

GUSID           DB      "Gravis UltraSound detected", 13
                DB      "Port ", 0FDh, "Xh, ", 0FDh, "Dk Memory", 0

GUSID2          DB      "Gravis UltraSound detected", 13
                DB      "Port ", 0FDh, "Xh, IRQ ", 0FDh, "D, ", 0FDh, "Dk RAM", 0

GUSFreeMsg      DB      "FreeGUS ", 0FDh, "Dk", 0

IFDEF RIC

GUSFreeMsg2     DB      "FreeGUS ", 0FDh, "Dk", 13, 13
                DB      "GUSInit ", 0FDh, "D", 0

  IFDEF RAMP
    DriverName  DB      "ITGUS.DRV", 0
  ELSE
    DriverName  DB      "ITGUS2.DRV", 0
  ENDIF

ENDIF

ULTRASndString  DB      "ULTRASND"

GUSMixTable     Label   Word

        DW      44100, 41160, 38588, 36318, 34300, 32495, 30870, 29400, 28064
        DW      26844, 25725, 24696, 23746, 22867, 22050, 21290, 20580, 19916
        DW      19294

GUSVolumeTable  Label   Word
        DW      04000h, 07FF0h, 08FF0h, 09800h, 09FF0h, 0A400h, 0A800h, 0AC00h
        DW      0AFF0h, 0B200h, 0B400h, 0B600h, 0B800h, 0BA00h, 0BC00h, 0BE00h
        DW      0BFF0h, 0C100h, 0C200h, 0C300h, 0C400h, 0C500h, 0C600h, 0C700h
        DW      0C800h, 0C900h, 0CA00h, 0CB00h, 0CC00h, 0CD00h, 0CE00h, 0CF00h

        DW      0CFF0h, 0D080h, 0D100h, 0D180h, 0D200h, 0D280h, 0D300h, 0D380h
        DW      0D400h, 0D480h, 0D500h, 0D580h, 0D600h, 0D680h, 0D700h, 0D780h
        DW      0D800h, 0D880h, 0D900h, 0D980h, 0DA00h, 0DA80h, 0DB00h, 0DB80h
        DW      0DC00h, 0DC80h, 0DD00h, 0DD80h, 0DE00h, 0DE80h, 0DF00h, 0DF80h

        DW      0DFF0h, 0E040h, 0E080h, 0E0C0h, 0E100h, 0E140h, 0E180h, 0E1C0h
        DW      0E200h, 0E240h, 0E280h, 0E2C0h, 0E300h, 0E340h, 0E380h, 0E3C0h
        DW      0E400h, 0E440h, 0E480h, 0E4C0h, 0E500h, 0E540h, 0E580h, 0E5C0h
        DW      0E600h, 0E640h, 0E680h, 0E6C0h, 0E700h, 0E740h, 0E780h, 0E7C0h

        DW      0E800h, 0E840h, 0E880h, 0E8C0h, 0E900h, 0E940h, 0E980h, 0E9C0h
        DW      0EA00h, 0EA40h, 0EA80h, 0EAC0h, 0EB00h, 0EB40h, 0EB80h, 0EBC0h
        DW      0EC00h, 0EC40h, 0EC80h, 0ECC0h, 0ED00h, 0ED40h, 0ED80h, 0EDC0h
        DW      0EE00h, 0EE40h, 0EE80h, 0EEC0h, 0EF00h, 0EF40h, 0EF80h, 0EFC0h

        DW      0EFF0h

ALIGN 4

GUSDataTable            DD      100 Dup (0FFFFFFFFh)
GUSMemory               DW      0               ; kb of memory on GUS
GUSRegisterSelect       DW      0
GUSVoiceSelect          DW      0
GUSUpdateTimer          DW      0
GUSUpdateCount          DW      0
GUSMemoryFree           DD      0
MixSpeed                DW      0
OldIRQHandler           DD      0

CONFIGURATIONOFFSET     EQU     $+128
CONFIGSIZE              EQU     8

Convert16To8Bit         DB      0
                        DB      0
Compress                DB      0
                        DB      0

IFDEF RIC
  ShowReinit              DB      0
                          DB      0
  UsedChannels            DW      ?
ENDIF

Stereo                  DB      0
GUSUpdateFlag           DB      0

MIDIIRQ                 DW      0FFFFh
MIDIBuffer              DB      256 Dup (0)
MIDIBufferHead          DB      0
MIDIBufferTail          DB      0
MIDIOldIRQHandler       DD      0

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

IMR     DW      0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

GUSScreenList           Label
                        DW      6
                        DW      Near Ptr IdleFunctionList
                        DW      Near Ptr GlobalKeyLink

                        DW      Near Ptr FullScreenBox  ; 0
                        DW      Near Ptr ScreenHeader
                        DW      Near Ptr FillHeader
                        DW      Near Ptr GravisHeaderLine

                        DW      SampleText              ; 4

                        DW      ConvertSampleText
                        DW      ConvertDisabledButton   ; 6
                        DW      ConvertEnabledButton

                        DW      SampleSizeText          ; 8
                        DW      SampleSize0Button       ; 9
                        DW      SampleSize1Button
                        DW      SampleSize2Button


IFDEF RIC
                        DW      ReinitText              ; 12
                        DW      ReinitButton0
                        DW      ReinitButton1
                        DW      ReinitButton2

ENDIF

                        DW      DriverText

                        DW      0

GravisHeaderLine        DW      10
                        DB      "Gravis UltraSound Driver", 0

DriverText              DW      1
                        DB      30, 48
                        DB      21h
                        DB      "Gravis UltraSound Driver 1.3 for Impulse Tracker", 0

SampleText              DW      1
                        DB      3, 13
                        DB      20h
                        DB      "Sample resizing options", 0

ConvertSampleText       DW      1
                        DB      5, 15
                        DB      20h
                        DB      "Reduce 16 bit samples to 8 bit", 0

ConvertDisabledButton   DW      2
                        DW      0FFFFh, 7, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetConvert
DriverSegment1          DW      0
                        DW      0
                        DW      Offset SetConvert
DriverSegment2          DW      0
                        DB      7, 17, 20, 19, 8
                        DB      0
                        DB      "  Disabled", 0

ConvertEnabledButton    DW      2
                        DW      6, 9, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetConvert
DriverSegment3          DW      0
                        DW      1
                        DW      Offset SetConvert
DriverSegment4          DW      0
                        DB      7, 20, 20, 22, 8
                        DB      0
                        DB      "  Enabled", 0

SampleSizeText          DW      1
                        DB      5, 24
                        DB      20h
                        DB      "Sample size", 0

SampleSize0Button       DW      2
                        DW      7, 10, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetCompress
DriverSegment5          DW      0
                        DW      0
                        DW      Offset SetCompress
DriverSegment6          DW      0
                        DB      7, 26, 20, 28, 8
                        DB      0
                        DB      "  Original", 0

SampleSize1Button       DW      2
                        DW      9, 11, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetCompress
DriverSegment7          DW      0
                        DW      1
                        DW      Offset SetCompress
DriverSegment8          DW      0
                        DB      7, 29, 20, 31, 8
                        DB      0
                        DB      "  Half", 0

IFDEF RIC

  SampleSize2Button       DW      2
                          DW      10, 13, 0FFFFh, 0FFFFh
                          DW      0
                          DW      0, 0
                          DW      6
                          DW      Offset GetCompress
  DriverSegment9          DW      0
                          DW      2
                          DW      Offset SetCompress
  DriverSegment10         DW      0
                          DB      7, 32, 20, 34, 8
                          DB      0
                          DB      "  Quarter", 0

  ReinitText              DW      1
                          DB      3, 36
                          DB      20h
                          DB      "Show channel reinitialisation", 0

  ReinitButton0           DW      2
                          DW      11, 14, 0FFFFh, 0FFFFh
                          DW      0
                          DW      0, 0
                          DW      6
                          DW      Offset GetReinit
  DriverSegment11         DW      0
                          DW      0
                          DW      Offset SetReinit
  DriverSegment12         DW      0
                          DB      7, 38, 21, 40, 8
                          DB      0
                          DB      "  Disabled", 0

  ReinitButton1           DW      2
                          DW      13, 15, 0FFFFh, 0FFFFh
                          DW      0
                          DW      0, 0
                          DW      6
                          DW      Offset GetReinit
  DriverSegment13         DW      0
                          DW      1
                          DW      Offset SetReinit
  DriverSegment14         DW      0
                          DB      7, 41, 21, 43, 8
                          DB      0
                          DB      "  Channels", 0

  ReinitButton2           DW      2
                          DW      14, 0FFFFh, 0FFFFh, 0FFFFh
                          DW      0
                          DW      0, 0
                          DW      6
                          DW      Offset GetReinit
  DriverSegment15         DW      0
                          DW      2
                          DW      Offset SetReinit
  DriverSegment16         DW      0
                          DB      7, 44, 21, 46, 8
                          DB      0
                          DB      "  Frequency", 0

ELSE

  SampleSize2Button       DW      2
                          DW      10, 0FFFFh, 0FFFFh, 0FFFFh
                          DW      0
                          DW      0, 0
                          DW      6
                          DW      Offset GetCompress
  DriverSegment9          DW      0
                          DW      2
                          DW      Offset SetCompress
  DriverSegment10         DW      0
                          DB      7, 32, 20, 34, 8
                          DB      0
                          DB      "  Quarter", 0


ENDIF


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

RelocationTable         Label
        DW      Offset DriverSegment1, Offset DriverSegment2
        DW      Offset DriverSegment3, Offset DriverSegment4
        DW      Offset DriverSegment5, Offset DriverSegment6
        DW      Offset DriverSegment7, Offset DriverSegment8
        DW      Offset DriverSegment9, Offset DriverSegment10

IFDEF RIC
          DW      Offset DriverSegment11, Offset DriverSegment12
          DW      Offset DriverSegment13, Offset DriverSegment14
          DW      Offset DriverSegment15, Offset DriverSegment16
ENDIF
        DW      0FFFFh

;*********** Local functions *******************
;
; GUSDelay - produces delay between GUS commands
; TestGUS - Checks for the presence of a GUS by detecting amount of memory.
; LoadGUSSample - Loads a byte to GUS, EDI = position in memory, AL = value
; LoadGUSSamples - Loads ECX bytes from DS:SI to EDI
;
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

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            TestGUS

                Push    AX

                Call    ResetGUS

                Mov     GUSMemory, 0

                Mov     DX, AX
                Add     DX, 103h                ; DX = Select Register

                Mov     CX, 4                   ; Max amount is 1MB of memory
                Xor     BL, BL                  ; Start with first 256k pool

TestGUS1:
                Mov     AL, 44h                 ; GUS DRAM High, 8 bit
                Out     DX, AL

                Add     DL, 2
                Mov     AL, BL
                Out     DX, AL

                Sub     DL, 2                   ; DX = Select Register

                Mov     AL, 43h                 ; GUS DRAM Low, 16 bit
                Out     DX, AL

                Inc     DX                      ; DX = Baseport+104h
                Xor     AX, AX
                Out     DX, AX                  ; Address 0

                Add     DL, 3                   ; DX = Baseport+107h (DRAM I/O)
                Mov     AL, 55h
                Out     DX, AL                  ; Write value 055h

                Sub     DL, 3                   ; DX = Baseport+104h
                Mov     AX, 1
                Out     DX, AX                  ; Address 1

                Add     DL, 3                   ; DX = Baseport+107h
                Mov     AL, 0AAh
                Out     DX, AL                  ; Write value 0AAh

                Sub     DL, 3                   ; DX = Baseport+104h
                Mov     AX, 2
                Out     DX, AX                  ; Address 2

                Add     DL, 3                   ; DX = Baseport+107h
                Mov     AL, 0
                Out     DX, AL                  ; Write value

                Sub     DL, 3                   ; DX = Baseport+104h
                Xor     AX, AX
                Out     DX, AX                  ; Address 0

                Add     DL, 3                   ; DX = Baseport+107h
                In      AL, DX                  ; Read value.. should be 055h
                Cmp     AL, 55h
                JNE     TestGUS2

                Sub     DL, 3                   ; DX = Baseport+104h
                Mov     AX, 1
                Out     DX, AX                  ; Address 1

                Add     DL, 3                   ; DX = Baseport+107h
                In      AL, DX                  ; Read value.. should be 0AAh
                Cmp     AL, 0AAh
                JNE     TestGUS2

                Sub     DL, 3                   ; DX = Baseport+104h
                Mov     AX, 2
                Out     DX, AX                  ; Address 2

                Add     DL, 3                   ; DX = Baseport+107h
                In      AL, DX                  ; Read value..
                Cmp     AL, 0
                JNE     TestGUS2

                Sub     DL, 4                   ; DX = Baseport+103h

                Add     GUSMemory, 256          ; Another 256k!

                Add     BL, 4                   ; Next memory chunk
                Loop    TestGUS1


TestGUS2:
                Pop     AX

                Cmp     GUSMemory, 0
                JNE     TestGUS3

                StC
                Ret

TestGUS3:
                ClC
                Ret

EndP            TestGUS

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            LoadGUSSample           ; EDI = position, AL = value

                Push    EAX

                Mov     DX, CS:GUSRegisterSelect
                Mov     AL, 44h
                Out     DX, AL

                Add     DL, 2
                Mov     EAX, EDI
                ShR     EAX, 16
                Out     DX, AL
                Sub     DL, 2                   ; Select register again.

                Mov     AL, 43h                 ; Address Low, 16 bit
                Out     DX, AL
                Inc     DX                      ; DX = 3x4h

                Mov     AX, DI                  ; Memory location high
                Out     DX, AX                  ; Memory location done.

                Add     DL, 3

                Pop     EAX

                Out     DX, AL
                Sub     DL, 3

                Inc     EDI

                Ret

EndP            LoadGUSSample

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            LoadGUSSamples          ; Given DS:SI, EDI = pos, ECX = count
                                        ; EBP = step value.

LoadGUSSamples1:
                Mov     DX, CS:GUSRegisterSelect
                Mov     AL, 44h
                Out     DX, AL

                Add     DL, 2
                Mov     EAX, EDI
                ShR     EAX, 16
                Out     DX, AL
                Sub     DL, 2                   ; Select register again.

                Mov     AL, 43h                 ; Address Low, 16 bit
                Out     DX, AL
                Inc     DX                      ; DX = 3x4h

LoadGUSSamples2:
                Mov     AX, DI                  ; Memory location high
                Out     DX, AX                  ; Memory location done.

                Add     DL, 3

                Mov     AL, [SI]
                Add     SI, BP
                JC      LoadGUSSamples4

LoadGUSSamples3:
                Out     DX, AL
                Sub     DL, 3

                Inc     DI
                JZ      LoadGUSSamples5

                Dec     ECX
                JNZ     LoadGUSSamples2
                Ret

LoadGUSSamples4:
                Add     ESI, 10000h
                Call    UpdateSampleLocation
                Jmp     LoadGUSSamples3

LoadGUSSamples5:
                Add     EDI, 10000h
                LoopD   LoadGUSSamples1
                Ret

EndP            LoadGUSSamples

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            Load16GUSSamples        ; Given DS:SI, EDI = pos, ECX = count
                                        ; EBP = step value.

                Add     BP, BP
                Dec     BP
                Mov     BX, 1
                Xor     BP, BX
                Xor     BX, BP

Load16GUSSamples1:
                Mov     DX, CS:GUSRegisterSelect
                Mov     AL, 44h
                Out     DX, AL

                Add     DL, 2
                Mov     EAX, EDI
                ShR     EAX, 16
                Out     DX, AL
                Sub     DL, 2                   ; Select register again.

                Mov     AL, 43h                 ; Address Low, 16 bit
                Out     DX, AL
                Inc     DX                      ; DX = 3x4h

Load16GUSSamples2:
                Mov     AX, DI                  ; Memory location high
                Out     DX, AX                  ; Memory location done.

                Add     DL, 3

                Xor     BX, BP
                Mov     AL, [SI]
                Add     SI, BX
                JC      Load16GUSSamples4

Load16GUSSamples3:
                Out     DX, AL
                Sub     DL, 3

                Inc     DI
                JZ      Load16GUSSamples5

                LoopD   Load16GUSSamples2
                Ret

Load16GUSSamples4:
                Add     ESI, 10000h
                Call    UpdateSampleLocation
                Jmp     Load16GUSSamples3

Load16GUSSamples5:
                Add     EDI, 10000h
                LoopD   Load16GUSSamples1
                Ret

EndP            Load16GUSSamples

;*********** Public functions ******************

; 컴 DetectCard 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Returns carry set if error, else carry clear. Has to setup internal vars
; (eg. appropriate IRQ/DMA whatever).
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            DetectGUS Far

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Cmp     BasePort, 0FFFFh
                JE      DetectGUS1

                Mov     AX, BasePort

                Cmp     AX, 210h
                JB      DetectCardError
                Cmp     AX, 280h
                JA      DetectCardError

                Call    TestGUS
                JNC     DetectGUS3
                Jmp     DetectCardError

DetectGUS1:
                Mov     AX, 210h

DetectGUS2:
                Call    TestGUS
                JNC     DetectGUS3

                Add     AL, 10h
                Cmp     AL, 60h
                JBE     DetectGUS2

DetectCardError:
                StC
                Ret

DetectGUS3:
                Mov     BasePort, AX
                Add     AX, 102h
                Mov     GUSVoiceSelect, AX
                Inc     AX
                Mov     GUSRegisterSelect, AX

Comment ~

          ; If Windows *AND* IRQ = 0FFFFh, then grab from ULTRASND variable

                Mov     SI, Offset ULTRASNDString
                Mov     CX, 8
                Call    GetEnvironment  ; Returns ES:DI, Carry if error
                JC      DetectCardOK

                Mov     CX, 3           ; Find 3 commas first.
                                        ; Eg. skip baseport + 2 DMAs

DetectCard1:
                Mov     AL, [ES:DI]
                Inc     DI

                Cmp     AL, ','
                JNE     DetectCard1
                Loop    DetectCard1

                                ; GUS IRQ..
                Xor     DX, DX

DetectCardIRQ1_1:
                Mov     AL, [ES:DI]
                Inc     DI
                Cmp     AL, ','
                JE      DetectCardIRQ1_2

                Sub     AL, '0'
                JC      DetectCardError
                Cmp     AL, 9
                JA      DetectCardError

                IMul    DX, 10
                Add     DL, AL
                Jmp     DetectCardIRQ1_1

DetectCardIRQ1_2:                               ; DX = IRQ to use.
                Cmp     DX, 15
                JA      DetectCardError

                Mov     AX, 1600h
                Int     2Fh                     ; Windows Detect.

                Test    AL, 7Fh
                JZ      DetectCardIRQ2_1

                Mov     AX, IRQ
                Cmp     AX, -1
                JNE     DetectCardIRQ2_2
                Mov     IRQ, DX
                Mov     MIDIIRQ, DX
                Jmp     DetectCardOK

DetectCardIRQ2_2:
                Mov     DX, AX

DetectCardIRQ2_1:                   ; No Windows.
                Mov     MIDIIRQ, DX

DetectCardOK:

~

                Mov     EAX, 'Jeff'
                ClC
                Ret

EndP            DetectGUS
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            GUSIRQHandler                   ; IRQ Handler has to
                                                ; 1) Update GUS registers
                                                ; 2) Update song position
                Push    AX
                Push    DS

                Mov     AX, GUSUpdateTimer
                Add     GUSUpdateCount, AX
                JC      GUSIRQHandler1

                Mov     AL, 20h
                Out     20h, AL
                Jmp     GUSIRQHandler2

GUSIRQHandler1:
                PushF
                Call    [OldIRQHandler]

GUSIRQHandler2:
                Xor     GUSUpdateFlag, 1
                JZ      GUSIRQHandlerEnd

                PushAD
                Push    ES

                ClD

                Call    SaveEMSPageFrame
                Call    Update          ; Returns DS:SI, CX
                Call    SetGUSRegisters
                Call    RestoreEMSPageFrame

                Pop     ES
                PopAD

GUSIRQHandlerEnd:
                Pop     DS
                Pop     AX
                IRet

EndP            GUSIRQHandler

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Comment ~

Proc            CheckMIDI

                Push    AX BX DX DS

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     DX, BasePort
                Inc     DH

CheckMIDIAgain:
                In      AL, DX
                Test    AL, 1
                JZ      CheckMIDI1

                Inc     DX
                In      AL, DX
                Dec     DX

                Cmp     AL, 0F0h
;                JAE     CheckMIDIAgain
                JAE     CheckMIDI1

                Mov     BL, [MIDIBufferTail]
                Inc     BL
                Cmp     BL, [MIDIBufferHead]
                JE      CheckMIDI1
;                JE      CheckMIDIAgain

                Mov     [MIDIBuffer+BX], AL
                Mov     [MIDIBufferTail], BL
;                Jmp     CheckMIDIAgain

CheckMIDI1:
                Pop     DS DX BX AX
                Ret

EndP            CheckMIDI
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            GUSMIDIIRQHandler

                Push    AX BX DX DS

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Call    CheckMIDI

                Mov     AL, 20h

                Cmp     MIDIIRQ, 8
                JB      GUSMIDIIRQHandler1

                Out     0A0h, AL

GUSMIDIIRQHandler1:
                Out     20h, AL

                Pop     DS DX BX AX
                IRet

EndP            GUSMIDIIRQHandler
                Assume DS:Nothing

~

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            GUSIRQOnlyHandler

                PushAD
                Push    DS
                Push    ES

                Mov     AL, 20h

                Cmp     CS:IRQ, 8
                JB      GUSIRQOnlyHandler1

                Out     0A0h, AL

GUSIRQOnlyHandler1:
                Out     20h, AL

GUSIRQAgain:
                Mov     DX, CS:BasePort
                Add     DL, 6
                In      AL, DX

;                Test    AL, 2                   ; MIDI receive?
;                JZ      GUSIRQOnlyHandlerNoMIDI
;
;                Call    CheckMIDI
;
;                Jmp     GUSIRQAgain

GUSIRQOnlyHandlerNoMIDI:
                Test    AL, 8
                JZ      GUSIRQOnlyHandler3

                Mov     DX, CS:GUSRegisterSelect
                Mov     AL, 45h
                Out     DX, AL
                Mov     AL, 0
                Add     DL, 2
                Out     DX, AL
                Mov     AL, 8
                Out     DX, AL
                Sub     DL, 2
                
                CLD

                Call    SaveEMSPageFrame
                Call    Update
                Call    SetGUSRegisters
                Call    RestoreEMSPageFrame
                Jmp     GUSIRQAgain

GUSIRQOnlyHandler3:
                Test    AL, 60h
                JZ      GUSIRQOnlyHandler2

                Mov     DX, CS:GUSVoiceSelect
                In      AL, DX
                Push    AX

GUSIRQOnlyHandler4:
                Mov     DX, CS:GUSRegisterSelect
                Mov     AL, 8Fh
                Out     DX, AL
                Add     DL, 2
                In      AL, DX  ; Bit 6 = waveramp IRQ
                                ; Bit 7 = wavetable IRQ...
                                ; Bit 0-5 = voice

                Test    AL, 080h
                JZ      GUSIRQOnlyHandler5
                Test    AL, 040h
                JZ      GUSIRQOnlyHandler6

                Pop     AX
                Mov     DX, CS:GUSVoiceSelect
                Out     DX, AL

;                Jmp     GUSIRQAgain
                Jmp     GUSIRQOnlyHandler2

GUSIRQOnlyHandler5:                     ; Wavetable IRQ
                Push    AX
                Mov     DX, CS:GUSVoiceSelect
                And     AL, 31
                Out     DX, AL
                Call    GUSDelay

                Inc     DX

                Xor     AL, AL
                Out     DX, AL                  ; AL = 0 (Mode control)
                Mov     AL, 2
                Add     DL, 2
                Out     DX, AL
                Call    GUSDelay
                Out     DX, AL

                Pop     AX
                Test    AL, 40h
                JNZ     GUSIRQOnlyHandler4

GUSIRQOnlyHandler6:                     ; Volume IRQ
                Mov     DX, CS:GUSVoiceSelect
                And     AL, 31
                Out     DX, AL
                Call    GUSDelay

                Inc     DX
                Mov     AL, 0Dh         ; Volume Ramp.
                Out     DX, AL

                Mov     AL, 3
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 6           ; Ramp rate
                Out     DX, AL

                Mov     AL, 63          ; Ramp rate
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                Jmp     GUSIRQOnlyHandler4


GUSIRQOnlyHandler2:
                Pop     ES
                Pop     DS
                PopAD

                IRet

EndP            GUSIRQOnlyHandler

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

IFDEF RAMP
  include gusramp.inc
ELSE
  include gusnramp.inc
ENDIF

IFDEF RIC
  include gusric.inc
ELSE
  include gusnric.inc
ENDIF

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            GUSGetAddress           ; Given EAX
                Assume DS:Nothing

                Push    CX

                Mov     CL, CS:Compress
                ShR     EAX, CL

                Pop     CX
                Add     EAX, [CS:GUSDataTable+BX]
                ShL     EAX, 9

                Ret

EndP            GUSGetAddress

;컴 InitMIDIIRQ 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Comment ~

Proc            InitMIDIIRQ

                Ret


                PushA
                Push    DS
                Push    ES

                Mov     AX, CS
                Mov     DS, AX
                ShL     EAX, 16
                Mov     ES, AX
                        Assume DS:Driver

                Mov     BX, MIDIIRQ
                Cmp     BX, 15
                JA      InitMIDIIRQ1

                ShL     BX, 2
                Mov     SI, [IRQData+BX]

                Mov     AX, Offset GUSMIDIIRQHandler
                XChg    [ES:SI], EAX

                Mov     MIDIOldIRQHandler, EAX

                In      AL, 0A1h
                Mov     AH, AL
                In      AL, 21h

                And     AX, [IRQData+BX+2]          ; Update mask

                Out     21h, AL
                Mov     AL, AH
                Out     0A1h, AL

                Mov     DX, BasePort
                Inc     DH
                Mov     AL, 0FFh
                Out     DX, AL
                Mov     AL, 0FCh
                Out     DX, AL
                Jmp     InitMIDIIRQEnd

InitMIDIIRQ1:
                Mov     DX, BasePort
                Inc     DH
                Mov     AL, 0FFh
                Out     DX, AL
                Mov     AL, 0h
                Out     DX, AL

InitMIDIIRQEnd:
                Pop     ES
                Pop     DS
                PopA

                Ret

EndP            InitMIDIIRQ
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            UnInitMIDIIRQ

                Ret

                PushA
                Push    DS
                Push    ES

                Mov     BX, MIDIIRQ
                Cmp     BX, 15
                JA      UnInitMIDIIRQ1

                ShL     BX, 2
                Mov     BX, [IRQData+BX]
                Xor     AX, AX
                Mov     ES, AX

                Mov     EAX, MIDIOldIRQHandler
                Mov     [ES:BX], EAX

UnInitMIDIIRQ1:
                Mov     DX, Baseport
                Inc     DH
                Mov     AL, 0FFh
                Out     DX, AL

                Pop     ES
                Pop     DS
                PopA

                Ret

EndP            UnInitMIDIIRQ
                Assume DS:Nothing

~

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

RelocationSetup:
                Mov     BX, [SI]
                Cmp     BX, 0FFFFh
                JE      RelocationSetupFinished

                Mov     [BX], CS

                Add     SI, 2
                Jmp     RelocationSetup

RelocationSetupFinished:
                                        ; OK... disable the GUS Line In
                                        ; & Enable Line Out
                Mov     BX, AX

                Mov     DX, BasePort
                Mov     AL, 1
                Out     DX, AL

                Call    ResetGUS

                Cmp     BL, 14
                JAE     InitSound_GUS4

                Mov     BL, 14

InitSound_GUS4:

IFDEF RIC
                  Mov     UsedChannels, BX
ENDIF

                Mov     DX, GUSRegisterSelect   ; Tell the GUS how many voices
                Mov     AL, 0Eh                 ; to use
                Out     DX, AL

                Add     DL, 2           ; DX = BasePort + 105h
                Mov     AL, BL
                Dec     AL
                Or      AL, 0C0h
                Out     DX, AL          ; Number of Voices set

                                        ; Reset each voice
                Mov     CX, 32          ; 32 voices to clear.

                Sub     BX, 14          ; Now get mixspeed
                Add     BX, BX
                Mov     AX, [GUSMixTable+BX]
                Mov     MixSpeed, AX

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

                ClI
                Sub     DL, 2           ; DX = BasePort + 102h = Voice select.

                Loop    GUSResetVoice

                In      AL, 0A1h
                Mov     AH, AL
                In      AL, 21h
                Mov     IMR, AX

;                Call    InitMIDIIRQ

                Cmp     IRQ, 0FFFFh
                JE      InitSound_GUS1

                Mov     AX, BasePort
                Call    ResetGUS

                                ; Set IRQ
                Mov     BX, IRQ
                ShL     BX, 2           ; BX points to offset in IRQData

                Xor     DI, DI
                Mov     ES, DI
                Mov     DI, [BX+IRQData]

                In      AL, 0A1h
                Mov     AH, AL
                In      AL, 21h

                And     AX, [BX+IRQData+2]

                Out     21h, AL
                Mov     AL, AH
                Out     0A1h, AL

                Mov     AX, CS
                ShL     EAX, 16
                Mov     AX, Offset GUSIRQOnlyHandler

                XChg    [ES:DI], EAX
                Mov     OldIRQHandler, EAX

                StI

                Mov     DX, BasePort
                Mov     AL, 9 ; + 16
                Out     DX, AL

                Mov     DX, GUSRegisterSelect
                Mov     AL, 4Ch
                Out     DX, AL
                Add     DL, 2
                Mov     AL, 7
                Out     DX, AL

                Call    GetTempo
                Call    SetTempo
                Call    ResetMemory

                Mov     AX, BasePort
                Mov     BX, IRQ
                Mov     CX, GUSMemory

                Mov     SI, Offset GUSID2

                ClC
                Ret

InitSound_GUS1:
                Inc     DL
                Mov     AL, 4Ch
                Out     DX, AL
                Add     DL, 2
                Mov     AL, 3   ; 7
                Out     DX, AL

                Mov     DX, BasePort
                Mov     AL, 9 ; + 16
                Out     DX, AL

                Mov     AL, 34h         ; Program IRQ 0. LSB&MSB, Rate gen
                Out     43h, AL

                Call    GetTempo
                Call    SetTempo
                Call    ResetMemory

                Xor     AX, AX
                Mov     ES, AX          ; ES = 0

                Mov     AX, CS
                ShL     EAX, 16
                Mov     AX, Offset GUSIRQHandler

                ClI

                XChg    DWord Ptr [ES:20h], EAX         ; Clock tick
                Mov     OldIRQHandler, EAX

                StI

                Mov     AX, BasePort
                Mov     BX, GUSMemory
                Mov     SI, Offset GUSID

                ClC
                Ret

EndP            InitSound
                Assume DS:Nothing

;컴 ReInitSound 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Stops sound output, releases any memory used by driver
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ReInitSound Far

                Push    AX

                Push    CS
                Pop     DS
                Mov     SI, Offset GUSReinitMsg
                Mov     BX, 40
                Call    SetInfoLine

                Call    UnInitSound

                Pop     AX
                Jmp     InitSound

EndP            ReInitSound

;컴 UnInitSound 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Stops sound output, releases any memory used by driver
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            UnInitSound Far

                Call    GotoHomeDirectory

                Push    CS
                Pop     DS
                        Assume DS:Driver

IFDEF RIC

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
                Mov     DX, Offset Convert16To8Bit
                Int     21h

SaveConfig1:
                Mov     AH, 3Eh
                Int     21h
SaveConfig2:

ENDIF
                Mov     AX, BasePort
                Call    ResetGUS

                ClI

                Mov     BX, CS:IRQ
                Cmp     BX, 0FFFFh
                JE      UnInitSound1

                Mov     AX, CS:IMR
                Out     21h, AL
                Mov     AL, AH
                Out     0A1h, AL

                ShL     BX, 2
                Xor     DI, DI
                Mov     ES, DI
                Mov     DI, [CS:BX+IRQData]
                Mov     EAX, CS:OldIRQHandler

                Mov     [ES:DI], EAX

;                Call    UnInitMIDIIRQ

                StI
                Ret

UnInitSound1:
                Mov     AL, 34h
                Out     43h, AL

                Xor     AX, AX
                Out     40h, AL
                Out     40h, AL

                Mov     ES, AX
                Mov     EAX, OldIRQHandler
                Mov     [ES:20h], EAX

;                Call    UnInitMIDIIRQ

                StI

                Ret

EndP            UnInitSound

;컴 Poll 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;
; This procedure is called as often as possible by IT.EXE
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

Proc            UARTOut Far

                Push    DX
                Push    AX

                Mov     DX, [CS:BasePort]
                Inc     DH

UARTOut1:
                In      AL, DX
                Test    AL, 2
                JZ      UARTOut1

                Pop     AX
                Inc     DX

                Out     DX, AL

                Pop     DX

                Ret

EndP            UARTOut

;컴 SetTempo 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;
; Parameters: BX = tempo
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetTempo Far    ; BX = tempo...

                Push    AX
                Push    BX
                Push    DX

                Cmp     CS:IRQ, 0FFFFh
                JE      SetTempo1

                ShL     BX, 8
                Mov     DX, 1Eh
                Mov     AX, 8480h
                Div     BX
                Neg     AL

                Mov     AH, AL

                Mov     DX, CS:GUSRegisterSelect

                Mov     AL, 47h
                Out     DX, AL
                Add     DL, 2
                Mov     AL, AH
                Out     DX, AL          ; Set Timer control register 2
                Sub     DL, 2

                Mov     AL, 45h
                Out     DX, AL
                Add     DL, 2
                Mov     AL, 8
                Out     DX, AL
;                Sub     DL, 2

                Mov     DX, CS:BasePort
                Add     DL, 8
                Mov     AL, 4
                Out     DX, AL

                Inc     DL
                Mov     AL, 2
                Out     DX, AL

                Jmp     SetTempo2

SetTempo1:
                                        ; Frames per second = 2 * (0.4*Tempo)
                Mov     AX, 0C214h
                Mov     DX, 16h         ; Ticks = (1193181/(2*0.4))/Tempo
                Div     BX

                                        ; AX contains counter.
                Mov     GUSUpdateTimer, AX

                Out     40h, AL         ; Timer IRQ.
                Mov     AL, AH
                Out     40h, AL

SetTempo2:
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

                Ret

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
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            LoadSample Far

                PushAD
                Push    DS
                Push    ES
                Push    FS

                Mov     FS, CS:SongDataArea
                Mov     BP, AX
                Dec     BP
                Add     BP, BP
                Mov     BP, [FS:64912+BP]

                Xor     CX, CX                  ; From the start of the sample..
                Call    GetSampleLocation       ; Returns DS:ESI, ECX = length
                JC      Music_GUSLoadSampleEnd

                Mov     BL, [FS:BP+12h]
                Test    BL, 16
                JZ      Music_GUSLoadSample12

                Cmp     ECX, [FS:BP+38h]
                JBE     Music_GUSLoadSample12

                Mov     ECX, [FS:BP+38h]
                Test    BL, 32
                JZ      Music_GUSLoadSample12

                Cmp     ECX, [FS:BP+44h]
                JAE     Music_GUSLoadSample12

                Mov     ECX, [FS:BP+44h]

Music_GUSLoadSample12:
                Mov     EBX, ECX
                Mov     CL, CS:Compress
                Mov     EDX, 1
                ShR     EBX, CL
                ShL     EDX, CL                 ; EDX = step value.

                Mov     ECX, EBX

                                                ; Now find location to put it in

                Dec     AX                      ; AX = sample number
                Push    AX                      ; AX = sample number (0 based)

                And     EAX, 0FFh
                Mov     DWord Ptr [CS:GUSDataTable+4*EAX], 0FFFFFFFFh

                Add     ECX, 2
                Mov     EAX, GUSMemoryFree

                Test    Byte Ptr [FS:BP+12h], 2          ; 16 bit??
                JZ      Music_GUSLoadSamples13

                Cmp     CS:Convert16To8Bit, 0
                JNZ     Music_GUSLoadSamples5

                Sub     EAX, 1
                JC      Music_GUSLoadSampleWarning
                And     EAX, Not 1                      ; For alignment
                Add     ECX, ECX

                Mov     EBX, EAX

                Sub     EBX, 1
                JC      Music_GUSLoadSampleWarning
                And     EBX, 3FFFFh  ; Get bytes remaining in 'segment'
                Inc     EBX

                Cmp     ECX, 256*1024
                JAE     Music_GUSLoadSamples13

                Cmp     ECX, EBX
                JBE     Music_GUSLoadSample2

                Sub     EAX, EBX
                Jmp     Music_GUSLoadSamples13

Music_GUSLoadSamples5:
                Inc     ESI
                Add     EDX, EDX                        ; Step value.

Music_GUSLoadSamples13:
                Cmp     ECX, EAX
                JBE     Music_GUSLoadSample2

                                                ; Warning msg here.
Music_GUSLoadSampleWarning:
                Pop     AX

Music_GUSLoadSampleEndNoError:
                ClC
                Jmp     Music_GUSLoadSampleEnd

Music_GUSLoadSample3:
                StC

Music_GUSLoadSampleEnd:
                Pop     FS
                Pop     ES
                Pop     DS
                PopAD

                Ret

Music_GUSLoadSample2:                           ; EAX = number of bytes free.
                                                ; DS:SI = sample.
                                                ; ECX = number of bytes of memory
                                                ; ES:DI = num bytes free ptr
                                                ; BP = sample number.

                                ; Location = MaxMem - DX:AX
                                ;          = -(DX:AX - GUSBanks*4:0)
                MovZX   EBX, CS:GUSMemory
                ShL     EBX, 10
                                                ; BX = bytes avail.
                Sub     EBX, EAX
                Sub     EAX, ECX
                Mov     GUSMemoryFree, EAX

                Pop     DI                      ; DI = sample number

                ShL     DI, 2

                Cmp     CS:Convert16To8Bit, 0
                JNZ     LoadGUSForced8Bit

                Test    Byte Ptr [FS:BP+12h], 2
                JNZ     Music_GUSLoad16BitSample

LoadGUSForced8Bit:
                Push    EBX
                Inc     EBX
                Mov     [CS:GUSDataTable+DI], EBX       ; Store pointer

                Mov     ES, CS:SongDataArea
                Pop     EDI                     ; EDI = location in GUS mem

                Sub     ECX, 2
                                                ; EDI = location in GUS mem
                                                ; DS:SI = sample data
                                                ; ECX = length.
                                                ; EDX = step value.
                ClI

                Push    BP

                Mov     EBP, EDX

                Mov     AL, [DS:SI+BP]
                Call    LoadGUSSample
                Call    LoadGUSSamples

                Mov     BH, AL

                Pop     BP

                Mov     AL, [FS:BP+12h]
                Test    AL, 16
                JZ      Music_GUSLoadSample10

                Mov     ESI, [FS:BP+34h]
                Test    AL, 64
                JZ      Music_GUSLoadSample11

                Mov     ESI, [FS:BP+38h]
                Sub     ESI, 2
                AdC     ESI, 0

                Mov     EAX, Not 0
                Mov     CL, CS:Compress
                ShL     EAX, CL
                And     ESI, EAX

Music_GUSLoadSample11:
                Test    Byte Ptr [FS:BP+12h], 2
                JZ      Music_GUSLoadSample6

                Add     ESI, ESI
                Inc     SI

Music_GUSLoadSample6:
                Call    UpdateSampleLocation

                Mov     BH, [SI]

Music_GUSLoadSample10:
                Mov     AL, BH
                Call    LoadGUSSample

                StI
                Jmp     Music_GUSLoadSample3    ; Return.. no error.

Music_GUSLoad16BitSample:
                Push    EBX

                Add     EBX, 2
                Mov     EAX, EBX
                And     EBX, 3FFFFh
                And     EAX, Not 3FFFFh
                ShR     EBX, 1
                Or      EAX, EBX
                Mov     [CS:GUSDataTable+DI], EAX

                Mov     ES, CS:SongDataArea
                Pop     EDI                     ; EDI = location in GUS mem

                Sub     ECX, 4
                ClI

                Push    BP

                Mov     EBP, EDX

                Mov     AX, [DS:ESI+EBP*2]
                Call    LoadGUSSample
                Mov     AL, AH
                Call    LoadGUSSample

                Call    Load16GUSSamples

                Pop     BP

                Xor     BX, BX

                Mov     AL, [FS:BP+12h]
                Test    AL, 16
                JZ      Music_GUSLoad16BitSample11B

                Mov     ESI, [FS:BP+34h]

                Test    AL, 64
                JZ      Music_GUSLoad16BitSample11

                Mov     ESI, [FS:BP+38h]
                Sub     ESI, 2
                JNC     Music_GUSLoad16BitSample11

                Xor     ESI, ESI

Music_GUSLoad16BitSample11:
                Mov     EAX, Not 0
                Mov     CL, CS:Compress
                ShL     EAX, CL
                And     ESI, EAX

                Add     ESI, ESI
                Call    UpdateSampleLocation

                Mov     BX, [SI]

Music_GUSLoad16BitSample11B:
                Mov     AX, BX
                Call    LoadGUSSample
                Mov     AL, AH
                Call    LoadGUSSample

                StI
                Jmp     Music_GUSLoadSample3    ; Return.. no error.


EndP            LoadSample

;컴 ReleaseSample 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Parameters: AX = sample to release, 0 based
;             DS:SI points to sample header
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ReleaseSample Far

                LEA     DI, [EAX*4+Offset GUSDataTable]
                                                ; Now to release the last
                                                ; sample from GUS memory if
                                                ; able to.

                Cmp     DWord Ptr [CS:DI], 0FFFFFFFFh
                JE      ReleaseSample3

ReleaseSample4:
                MovZX   EAX, CS:GUSMemory
                SHL     EAX, 10

                Mov     EBP, [CS:DI]            ; EBP = sample pointer.

 ; If (MaxMem-(sample location in bank + sample length + 2)) = memory remaining,
 ; then release memory.

                Mov     ECX, [SI+30h]
                Mov     DL, [SI+12h]
                Test    DL, 16
                JZ      ReleaseSample7

                Cmp     ECX, [SI+38h]
                JBE     ReleaseSample7

                Mov     ECX, [SI+38h]

                Test    DL, 32
                JZ      ReleaseSample7

                Cmp     ECX, [SI+44h]
                JAE     ReleaseSample7

                Mov     ECX, [SI+44h]

ReleaseSample7:
                Push    EBX
                Mov     EBX, ECX
                Mov     CL, CS:Compress
                ShR     EBX, CL
                Mov     ECX, EBX
                Pop     EBX

                Inc     ECX
                Mov     EDI, 1

                Test    DL, 2
                JZ      ReleaseSample8Bit

                Cmp     CS:Convert16To8Bit, 0
                JNZ     ReleaseSample8Bit

                Add     ECX, ECX
                Inc     DI

                                                ; EBP = pointer for 16 bit
                                                ; need to convert back:
                Mov     EDX, EBP
                Add     EBP, EBP
                And     EBP, 3FFFFh
                And     EDX, Not 3FFFFh
                Or      EBP, EDX

ReleaseSample8Bit:
                Sub     EAX, EBP
                Sub     EAX, ECX

                Cmp     EAX, GUSMemoryFree
                JNE     ReleaseSample3

                Add     ECX, EDI
                Add     GUSMemoryFree, ECX

ReleaseSample3:
                Ret

EndP            ReleaseSample

;컴 ResetMemory 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
;  Frees all on-board memory
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ResetMemory Far

                Push    EAX
                Push    CX
                Push    ES
                Push    DI

                MovZX   EAX, GUSMemory          ; Number of kbytes
                ShL     EAX, 10                 ; Translate to bytes

                Sub     EAX, 64                 ; Safety bytes.
                Mov     GUSMemoryFree, EAX

                Push    CS
                Pop     ES
                Mov     DI, Offset GUSDataTable
                Mov     CX, 200
                Mov     AX, 0FFFFh
                Rep     StosW

                Pop     DI
                Pop     ES
                Pop     CX
                Pop     EAX

                Ret

EndP            ResetMemory

;컴 GetStatus 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
;  Returns text to show on status line, AX = display parameter
;  Carry set if not to show anything.
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            GetStatus Far

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     EAX, GUSMemoryFree
                Mov     SI, Offset GUSFreeMsg
                ShR     EAX, 10

IFDEF RIC
                  Cmp     ShowReinit, 0
                  JE      NoShowInit

                  Mov     SI, Offset GUSFreeMsg2
                  Mov     BX, UsedChannels
                  Cmp     ShowReinit, 1
                  JE      NoShowInit

                  Add     BX, BX
                  Mov     BX, [GUSMixTable+BX-28]

  NoShowInit:

ENDIF
                ClC

                Ret

EndP            GetStatus
                Assume DS:Nothing

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

Proc            SetVariable Far

                Ret

EndP            SetVariable

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            GetVariable Far

                Ret

EndP            GetVariable

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetConvert Far

                Mov     AX, [SI+22]
                Mov     CS:Convert16To8Bit, AL
                Call    Music_LoadAllSamples

                Mov     AX, 1
                Ret

EndP            SetConvert

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            GetConvert Far

                Push    CS
                Pop     ES
                Mov     DI, Offset Convert16To8Bit
                Ret

EndP            GetConvert

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetCompress Far

                Mov     AX, [SI+22]
                Mov     CS:Compress, AL
                Call    Music_LoadAllSamples

                Mov     AX, 1
                Ret

EndP            SetCompress

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            GetCompress Far

                Push    CS
                Pop     ES
                Mov     DI, Offset Compress

                Ret

EndP            GetCompress

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFDEF RIC

Proc            SetReinit Far

                Mov     AX, [SI+22]
                Mov     CS:ShowReinit, AL

                Mov     AX, 1
                Ret

EndP            SetReinit

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            GetReinit Far

                Push    CS
                Pop     ES
                Mov     DI, Offset ShowReinit

                Ret

EndP            GetReinit

ENDIF

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

EndDriver:

;********  Provided Constants Table *************

MaxNumberOfChannels     DW      32      ; Maximum number of channels the
                                        ; driver can handle.
StopAfterPlay           DW      0
DefaultChannels         DW      32
DriverFlags             DW      1       ; Driver supports MIDI Out
                        DW      4 Dup (0)

;********  Provided Procedure Table *************

ProvidedTableStart:
        DW      Offset DetectGUS

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

        DW      Offset UARTOut

ProvidedTableEnd:
        DW      32-(ProvidedTableEnd-ProvidedTableStart)/2 Dup (0)

EndS

End

               *********************** Notes *******************

                        UltraSound Output Structure

       0   1   2   3   4   5   6   7   8   9
     旼컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴쩡컴컴컴�
0000:�(Flags)쿗astVol                        �
     쳐컴쩡컴탠컴쩡컴탠컴쩡컴쩡컴쩡컴탠컴쩡컴�


