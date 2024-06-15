
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

;**************************

include vtable.inc

;********  Required ProcedureTable *************

include reqproc.inc

;************** Local variables ****************

SLAVECHANNELSIZE        EQU     128
MixSpeed                =       44100

IWReinitMsg     DB      "Interwave reinitialised", 0

IWID            DB      "AMD Interwave, Revision "
RevisionLetter  DB      " ", 13
                DB      "Port ", 0FDh, "Xh, ", 0FDh, "Dk Memory", 0

IWID2           DB      "AMD Interwave, Revision "
RevisionLetter2 DB      " ", 13
                DB      "Port ", 0FDh, "Xh, IRQ ", 0FDh, "D, ", 0FDh, "Dk RAM", 0

IWFreeMsg       DB      "FreeIW  ", 0FDh, "Dk", 0

IWVolumeTable  Label   Word
        DW      00000h, 0A0C0h, 0ABE0h, 0B250h, 0B6F0h, 0BA80h, 0BD70h, 0BFE0h
	DW      0C200h, 0C3F0h, 0C5A0h, 0C720h, 0C880h, 0C9D0h, 0CB00h, 0CC10h
	DW      0CD20h, 0CE10h, 0CF00h, 0CFE0h, 0D0B0h, 0D180h, 0D230h, 0D2F0h
	DW      0D3A0h, 0D440h, 0D4E0h, 0D580h, 0D610h, 0D6A0h, 0D730h, 0D7B0h
	DW      0D830h, 0D8B0h, 0D930h, 0D9A0h, 0DA20h, 0DA90h, 0DAF0h, 0DB60h
	DW      0DBC0h, 0DC30h, 0DC90h, 0DCF0h, 0DD50h, 0DDB0h, 0DE00h, 0DE60h
	DW      0DEB0h, 0DF00h, 0DF60h, 0DFB0h, 0E000h, 0E050h, 0E090h, 0E0E0h
	DW      0E130h, 0E170h, 0E1C0h, 0E200h, 0E240h, 0E290h, 0E2D0h, 0E310h
	DW      0E350h, 0E390h, 0E3D0h, 0E410h, 0E440h, 0E480h, 0E4C0h, 0E4F0h
	DW      0E530h, 0E560h, 0E5A0h, 0E5D0h, 0E610h, 0E640h, 0E670h, 0E6B0h
	DW      0E6E0h, 0E710h, 0E740h, 0E770h, 0E7A0h, 0E7D0h, 0E800h, 0E830h
	DW      0E860h, 0E890h, 0E8C0h, 0E8F0h, 0E920h, 0E940h, 0E970h, 0E9A0h
	DW      0E9D0h, 0E9F0h, 0EA20h, 0EA40h, 0EA70h, 0EAA0h, 0EAC0h, 0EAF0h
	DW      0EB10h, 0EB40h, 0EB60h, 0EB80h, 0EBB0h, 0EBD0h, 0EBF0h, 0EC20h
	DW      0EC40h, 0EC60h, 0EC90h, 0ECB0h, 0ECD0h, 0ECF0h, 0ED10h, 0ED40h
	DW      0ED60h, 0ED80h, 0EDA0h, 0EDC0h, 0EDE0h, 0EE00h, 0EE20h, 0EE40h
        DW      0EE60h

OffsetTable             Label   Word
        DW      0FFF0h, 03000h, 02800h, 02350h, 02000h, 01D60h, 01B50h, 01980h
        DW      01800h, 016A0h, 01560h, 01450h, 01350h, 01260h, 01180h, 010B0h
        DW      01000h, 00F40h, 00EA0h, 00E00h, 00D60h, 00CD0h, 00C50h, 00BC0h
        DW      00B50h, 00AD0h, 00A60h, 009F0h, 00980h, 00920h, 008B0h, 00850h
        DW      00800h, 007A0h, 00740h, 006F0h, 006A0h, 00650h, 00600h, 005B0h
        DW      00560h, 00520h, 004D0h, 00490h, 00450h, 00410h, 003C0h, 00390h
        DW      00350h, 00310h, 002D0h, 00290h, 00260h, 00220h, 001F0h, 001B0h
        DW      00180h, 00150h, 00120h, 000F0h, 000B0h, 00080h, 00050h, 00020h
        DW      00000h


IWMemory                DW      0               ; kb of memory on IW
IWRegisterSelect        DW      0
IWVoiceSelect           DW      0
IWUpdateTimer           DW      0
IWUpdateCount           DW      0
IWMemoryFree            DD      0
IWOutputPort            DW      0
IWUpdateFlag            DB      0
IWMemorySegmented       DB      0

IWLMCFI                 DW      0
IWBankTable             DB      0, 0, 0, 0

IWBank1                 DD      0
IWBank2                 DD      0
IWBank3                 DD      0
IWBank4                 DD      0

OldIRQHandler           DD      0

Convert16To8Bit         DB      0
                        DB      0
Compress                DB      0
                        DB      0
Stereo                  DB      0

NewIWLMCFI              DW      0

IWDataTable             DD      100 Dup (0FFFFFFFFh)
Revision                DB      0

BankConfigs             Label   ; 12 configs..
;        DB      64, 64, 64, 64          ; 12
;        DB      64, 64, 0, 0            ; 11
        DB      64, 0, 0, 0             ; 10
        DB      16, 16, 16, 16          ; 9
        DB      16, 16, 0, 0            ; 8
        DB      16, 0, 0, 0             ; 7
        DB      4, 4, 16, 16            ; 6
        DB      4, 4, 16, 0             ; 5
        DB      4, 16, 16, 16           ; 4
        DB      4, 16, 0, 0             ; 3
        DB      4, 4, 4, 4              ; 2
        DB      4, 4, 0, 0             ; 1
        DB      4, 0, 0, 0              ; 0


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

IWScreenList           Label
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

                        DW      DriverText

                        DW      0

GravisHeaderLine        DW      10
                        DB      "Interwave Driver", 0

DriverText              DW      1
                        DB      38, 48
                        DB      21h
                        DB      "Interwave Driver 1.1 for Impulse Tracker", 0

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
        DW      Offset DriverSegment1
        DW      Offset DriverSegment2
        DW      Offset DriverSegment3
        DW      Offset DriverSegment4
        DW      Offset DriverSegment5
        DW      Offset DriverSegment6
        DW      Offset DriverSegment7
        DW      Offset DriverSegment8
        DW      Offset DriverSegment9
        DW      Offset DriverSegment10
        DW      0FFFFh

;*********** Local functions *******************
;
; TestIW - Checks for the presence of a IW by detecting amount of memory.
; LoadIWSample - Loads a byte to IW memory, AL = value
; LoadIWSamples - Loads ECX bytes from DS:SI to IW memory
;
;***********************************************

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            DetectMemory

                Push    DS
                        Assume DS:Driver

                Push    CS
                Pop     DS

                Mov     IWMemory, 0

                Mov     DX, IWRegisterSelect
                Mov     AL, 52h
                Out     DX, AL
                Inc     DX
                In      AX, DX
                Mov     IWLMCFI, AX
                And     AX, 0FFF0h
                Or      AX, 0Ch                 ; Allow full 16MB addressing

                Mov     NewIWLMCFI, AX

                Out     DX, AX

                Mov     CX, 256
                Xor     EDI, EDI

DetectMemory1:                          ; DX = BasePort+103h
                Call    IWSetPosition

                Xor     AL, AL
                Call    LoadIWSample    ; Write a 0

                Add     EDI, 10000h
                Loop    DetectMemory1

                Mov     EBX, 3          ; 4 banks, 3, 2, 1 and 0

DetectMemory2:
                Mov     EDI, EBX
                ShL     EDI, 22         ; DI = Bank * 4MB
                Call    IWSetPosition

                Mov     AL, 0AAh
                Mov     DX, IWOutputPort
                Out     DX, AL
                Mov     AL, 055h
                Out     DX, AL
                Call    IWSetPosition

                Mov     DX, IWOutputPort

                In      AL, DX          ; Bank doesn't exist?
                Cmp     AL, 0AAh
                JNE     DetectMemory3

                In      AL, DX
                Cmp     AL, 055h
                JNE     DetectMemory3

                Mov     CX, 64          ; Max of 4MB in 1 bank...

DetectMemoryInnerLoop1:
                Inc     [IWBankTable+BX]
                Inc     IWMemory

                Add     EDI, 10000h
                Call    IWSetPosition

                Mov     DX, IWOutputPort
                In      AL, DX
                Cmp     AL, 0AAh
                JE      DetectMemory3

                Loop    DetectMemoryInnerLoop1

DetectMemory3:
                Dec     BX
                JNS     DetectMemory2

                                ; OK.. have checked each bank.. now to init.
                Mov     BL, 10
                Mov     SI, Offset BankConfigs
                Mov     EAX, DWord Ptr IWBankTable

DetectMemory4:
                Cmp     EAX, [SI]
                JE      DetectMemory5

                Add     SI, 4
                Dec     BL
                JNS     DetectMemory4

                Mov     IWMemorySegmented, 1
                Jmp     DetectMemory6

DetectMemory5:                  ; Set LMCI
                Mov     DX, IWRegisterSelect
                Mov     AL, 52h
                Out     DX, AL
                Mov     AX, IWLMCFI

                And     AX, 0FFF0h
                Or      AL, BL

                Mov     NewIWLMCFI, AX

                Inc     DX
                Out     DX, AX

DetectMemory6:
                ShL     IWMemory, 6
                JZ      DetectMemory7

                Pop     DS
                Ret

DetectMemory7:
                Pop     DS
                Pop     AX              ; Add SP, 2

                StC
                RetF

EndP            DetectMemory
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            ResetIW                        ; AX = baseport.

                Push    AX
                Push    CX
                Push    DX

                Mov     DX, AX
                Add     DX, 103h        ; DX = IGIDXR

                Comment ~

                Mov     AL, 4Ch
                Out     DX, AL
                Add     DL, 2
                Xor     AL, AL
                Out     DX, AL

                Push    DX
                Mov     DX, 300h
                Mov     CX, 20
ResetIW4:
                In      AL, DX
                Loop    ResetIW4
                Pop     DX

                Mov     AL, 1
                Out     DX, AL

                Push    DX
                Mov     DX, 300h
                Mov     CX, 20
ResetIW3:
                In      AL, DX
                Loop    ResetIW3
                Pop     DX

                Sub     DL, 2

                ~

                Mov     AL, 19h         ; Write SGMI
                Out     DX, AL

                Add     DL, 2

                Mov     AL, 1
                Out     DX, AL          ; Enhanced mode enabled.
                Sub     DL, 2

                Mov     AL, 99h         ; Read SGMI
                Out     DX, AL
                Add     DL, 2
                In      AL, DX
                Sub     DL, 2

                Cmp     AL, 1
                JNE     ResetIW1

                Mov     AL, 53h         ; LMCI
                Out     DX, AL

                Add     DL, 2
                Mov     AL, 1
                Out     DX, AL          ; Auto increment, DRAM, 8-bit, NoInvert
                Sub     DL, 2

                ClC
                Jmp     ResetIW2

ResetIW1:
                StC

ResetIW2:
                Pop     DX
                Pop     CX
                Pop     AX

                Ret

EndP            ResetIW

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            TestIW


                Call    ResetIW
                JC      TestIW3

                Push    AX

                Mov     IWMemory, 0

                Mov     DX, AX
                Add     DX, 103h                ; DX = Select Register

                Mov     CX, 256                 ; Max amount is 16MB of memory
                Xor     BX, BX                  ; BX = no of 64k chunks.

TestIW1:
                ClI

                Mov     AL, 44h                 ; IW DRAM High, 8 bit
                Out     DX, AL

                Add     DL, 2
                Mov     AX, BX                  ; BX = IW DRAM High
                Out     DX, AL
                Sub     DL, 2                   ; DX = Select Register

                Mov     AL, 43h                 ; IW DRAM Low, 16 bit
                Out     DX, AL

                Inc     DX                      ; DX = Baseport+104h
                Xor     AX, AX
                Out     DX, AX                  ; Address 0

                StI

                Add     DL, 3                   ; DX = Baseport+107h (DRAM I/O)

                Mov     AL, 55h
                Out     DX, AL                  ; Write value 55h
                Mov     AL, 0AAh
                Out     DX, AL                  ; Write value 0AAh
                Mov     AL, CL
                Out     DX, AL                  ; Write value

                Sub     DL, 3                   ; DX = Baseport+104h
                Xor     AX, AX
                Out     DX, AX                  ; Address 0

                Add     DL, 3                   ; DX = Baseport+107h
                In      AL, DX                  ; Read value..
                Cmp     AL, 55h
                JNE     TestIW2

                In      AL, DX                  ; Read value..
                Cmp     AL, 0AAh
                JNE     TestIW2

                In      AL, DX                  ; Read value..
                Cmp     AL, CL
                JNE     TestIW2

                Inc     BX
                Sub     DL, 4                   ; DX = Baseport+103h
                Loop    TestIW1

TestIW2:
                Pop     AX

                And     BX, BX
                JZ      TestIW3

                ShL     BX, 6
                Mov     IWMemory, BX
                ClC
                Ret

TestIW3:
                StC
                Ret

EndP            TestIW

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            IWSetPosition           ; EDI = position

                ClI
                Mov     DX, CS:IWRegisterSelect
                Mov     AL, 44h
                Out     DX, AL

                Add     DL, 2
                SHLD    EAX, EDI, 16
;                Mov     EAX, EDI
;                ShR     EAX, 16
                Out     DX, AL
                Sub     DL, 2                   ; Select register again.

                Mov     AL, 43h                 ; Address Low, 16 bit
                Out     DX, AL
                Inc     DX                      ; DX = 3x4h

                Mov     AX, DI                  ; Memory location high
                Out     DX, AX                  ; Memory location done.

                StI
                Ret

EndP            IWSetPosition

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            LoadIWSample           ; AL = value

                Mov     DX, CS:IWOutputPort
                Out     DX, AL

                Ret

EndP            LoadIWSample

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            LoadIWSamples          ; Given DS:SI, ECX = count
                                       ; EBP = step value.

                Mov     DX, CS:IWOutputPort

LoadIWSamples2:
                Mov     AL, [SI]
                Add     SI, BP
                JC      LoadIWSamples4

LoadIWSamples3:
                Out     DX, AL

                LoopD   LoadIWSamples2
                Ret

LoadIWSamples4:
                Add     ESI, 10000h
                Int     3
                Jmp     LoadIWSamples3

EndP            LoadIWSamples

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            Load16IWSamples        ; Given DS:SI, ECX = count
                                       ; EBP = step value.

                Add     BP, BP
                Dec     BP
                Mov     BX, 1
                Xor     BP, BX
                Xor     BX, BP

                Mov     DX, CS:IWOutputPort

Load16IWSamples1:
                Xor     BX, BP
                Mov     AL, [SI]
                Add     SI, BX
                JC      Load16IWSamples4

Load16IWSamples3:
                Out     DX, AL

                Dec     ECX
                JNZ     Load16IWSamples1
                Ret

Load16IWSamples4:
                Add     ESI, 10000h
                Int     3
                Jmp     Load16IWSamples3

EndP            Load16IWSamples

;*********** Public functions ******************

; 컴 DetectCard 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Returns carry set if error, else carry clear. Has to setup internal vars
; (eg. appropriate IRQ/DMA whatever).
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            DetectIW Far

                Cmp     BasePort, 0FFFFh
                JE      DetectIW1

                Mov     AX, BasePort
                Call    TestIW
                JNC     DetectIW3

                Ret

DetectIW1:
                Mov     AX, 210h

DetectIW2:
                Call    TestIW
                JNC     DetectIW3

                Add     AL, 10h
                Cmp     AL, 60h
                JBE     DetectIW2

                StC
                Ret

DetectIW3:
                Mov     BasePort, AX
                Add     AX, 102h
                Mov     IWVoiceSelect, AX
                Inc     AX
                Mov     IWRegisterSelect, AX
                Add     AL, 4
                Mov     IWOutputPort, AX

                Call    DetectMemory

                Mov     EAX, 'Jeff'

                ClC
                Ret

EndP            DetectIW

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            IWIRQOnlyHandler

                PushAD
                Push    DS
                Push    ES

                Mov     AL, 20h

                Cmp     CS:IRQ, 8
                JB      IWIRQOnlyHandler1

                Out     0A0h, AL

IWIRQOnlyHandler1:
                Out     20h, AL

                Mov     DX, CS:BasePort
                Add     DL, 6
                In      AL, DX
                And     AL, 8
                JZ      IWIRQOnlyHandler2

                Mov     DX, CS:IWRegisterSelect
                Mov     AL, 45h
                Out     DX, AL
                Mov     AL, 0
                Add     DL, 2
                Out     DX, AL
                Mov     AL, 8
                Out     DX, AL
                Sub     DL, 2
                
                ClD

                Call    SaveEMSPageFrame
                Call    Update
                Call    SetIWRegisters
                Call    RestoreEMSPageFrame

IWIRQOnlyHandler2:
                Pop     ES
                Pop     DS
                PopAD

                IRet

EndP            IWIRQOnlyHandler

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            IWIRQHandler                   ; IRQ Handler has to
                                                ; 1) Update IW registers
                                                ; 2) Update song position
                Push    AX
                Push    DS

                Mov     AX, IWUpdateTimer
                Add     IWUpdateCount, AX
                JC      IWIRQHandler1

                Mov     AL, 20h
                Out     20h, AL
                Jmp     IWIRQHandler2

IWIRQHandler1:
                PushF
                Call    [OldIRQHandler]

IWIRQHandler2:
                Xor     IWUpdateFlag, 1
                JZ      IWIRQHandlerEnd

                PushAD
                Push    ES

                ClD

                Call    SaveEMSPageFrame
                Call    Update          ; Returns DS:SI, CX
                Call    SetIWRegisters
                Call    RestoreEMSPageFrame

                Pop     ES
                PopAD

IWIRQHandlerEnd:
                Pop     DS
                Pop     AX
                IRet

EndP            IWIRQHandler

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SetIWVolume            ; BX = new volume

                                        ; To do:
                                        ;  1) Set ramp start
                                        ;  2) Set ramp end
                                        ;  3) Set current volume
                                        ;  4) Start ramp
                                        ;  5) Save new volume.

                Push    BX
                Push    CX

                Mov     AL, 0Dh
                Out     DX, AL

                Mov     AL, 3           ; Stop Ramp!
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                Add     BX, BX
                Mov     CX, [CS:IWVolumeTable+BX] ; CX = new volume
                Mov     BX, [SI+2]
                Add     BX, BX
                Mov     BX, [CS:IWVolumeTable+BX] ; BX = old volume

                Cmp     BX, CX
                JNE     SetIWVolume2

                Mov     AL, 89h
                Out     DX, AL
                Inc     DX
                In      AX, DX
                Dec     DX

                Mov     BX, AX          ; BX = old volume

SetIWVolume2:

                Push    BX                      ; Old volume on stack

                Xor     AH, AH          ; Ramp up
                Cmp     CX, BX
                JE      SetIWVolume4
                JA      SetIWVolume1

                XChg    BX, CX
                Mov     AH, 40h         ; Ramp down

SetIWVolume1:
                Mov     AL, 6           ; Ramp rate
                Out     DX, AL

                Mov     AL, 32          ; Ramp rate
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 7           ; Ramp start
                Out     DX, AL

                Mov     AL, BH
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 8           ; Ramp end
                Out     DX, AL

                Mov     AL, CH
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 9
                Out     DX, AL

                Pop     BX              ; BX = old volume
                XChg    BX, AX

                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 0Dh         ; Ramp control
                Out     DX, AL

                Mov     AL, BH
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

SetIWVolume5:
                Pop     CX
                Pop     BX

                Mov     [SI+2], BX

                Ret

SetIWVolume4:
;                Mov     AL, 0Dh         ; Volume Ramp.
;                Out     DX, AL
;
;                Mov     AL, 3
;                Add     DL, 2
;                Out     DX, AL
;                Sub     DL, 2

                Mov     AL, 9
                Out     DX, AL

                Pop     AX              ; AX = old volume

                Inc     DX
                Out     DX, AX
                Dec     DX

                Jmp     SetIWVolume5

EndP            SetIWVolume

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            IWGetAddress           ; Given EAX

                Push    CX

                Mov     CL, CS:Compress
                ShR     EAX, CL

                Pop     CX
                Add     EAX, [CS:IWDataTable+BX]
                ShL     EAX, 9
                And     EAX, 7FFFFFFFh

                Ret

EndP            IWGetAddress

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SetIWRegisters         ; Given DS:SI, CX

                Mov     ES, CS:SongDataArea

                Push    CX
                Push    SI

                Xor     AX, AX

GetOffsetLoop:
                Push    AX
                Push    CX

                Mov     DX, IWVoiceSelect
                Out     DX, AL                  ; OK.. now to play with this
                                                ; voice.
                Inc     DL                      ; DX = select rego

                Mov     BX, [SI]
                Test    BH, 2
                JZ      GetOffsetLoop2

                Mov     BX, 200h
                Mov     [SI], BX

GetOffsetLoop2:
                Test    BL, 1                   ; Channel not on!
                JZ      GetOffsetLoop1
                Test    BH, 1
                JZ      GetOffsetLoop3          ; Prev 1.

                Xor     BX, BX
                Call    SetIWVolume

                Jmp     GetOffsetLoop1

GetOffsetLoop3:
                Mov     EAX, [SI+4Ch]
                Mov     [SI+2Ch], EAX

                Mov     AL, 8Ah
                Out     DX, AL

                Inc     DX
                In      AX, DX
                Dec     DX

                And     AH, 7Fh
                ShL     EAX, 16         ; Load high part of EAX

                Mov     AL, 8Bh
                Out     DX, AL
                Inc     DX
                In      AX, DX
                        ; EAX = 000OOOOO OOOOOOOO OOOOOOOF FFFFFFFF
                        ; Need: 00000000 0000OOOO OOOOOOOO OOOOOOOO

                ShR     EAX, 9

                MovZX   EBX, Byte Ptr [SI+36h]
                Mov     EBX, [CS:IWDataTable+EBX*4]
                And     EBX, 03FFFFFh
                Sub     EAX, EBX
                Push    CX

                Mov     CL, CS:Compress
                ShL     EAX, CL

                Pop     CX
                Mov     [SI+4Ch], EAX

GetOffsetLoop1:
                Add     SI, SLAVECHANNELSIZE

                Pop     CX
                Pop     AX

                Inc     AX
                Dec     CX
                JNZ     GetOffsetLoop

                Pop     SI
                Pop     CX

                Xor     AX, AX

SetIWRegisters1:
                Push    AX
                Push    CX

                Mov     DX, IWVoiceSelect
                Out     DX, AL                  ; OK.. now to play with this
                                                ; voice.
                Mov     CX, [SI]                ; CX = flags.
                Inc     DL                      ; DX = select rego

                Test    CH, 1
                JZ      SetIWRegisters21

                Mov     AL, [SI+36]
                Cmp     AL, [SI+4]
                JE      SetIWRegisters21

                Xor     AL, AL
                Out     DX, AL

                Mov     AL, 3
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

SetIWRegisters21:
                Test    CL, 32                  ; Frequency change
                JZ      SetIWRegisters7

                Push    DX

                Mov     EAX, [SI+10h]          ; EAX = freq.

                Push    CX
                Mov     CL, CS:Compress
                ShR     EAX, CL
                Pop     CX

                Xor     EDX, EDX
                Mov     EBX, MixSpeed

                Div     EBX                    ; EAX = I portion.

                Test    EAX, Not 63
                JNZ     SetIWRegisters6

                Push    EAX

                Xor     EAX, EAX
                Div     EBX

                Pop     EBX             ; EBX:EAX = IIII FFFF etc.

                SHRD    EAX, EBX, 6

                        ; Have:      IIIIIIII IIIIIIII FFFFFFFF FFFFFFFF
                        ; Req:       IIIIIIFF FFFFFFF0

                Pop     DX
                Mov     AL, 1
                Out     DX, AL

                ShR     EAX, 16
                AdC     AX, 0
                SBB     AX, 0                   ; Just in case!

                Inc     DX
                Out     DX, AX
                Dec     DX

                Jmp     SetIWRegisters7

SetIWRegisters6:
                Mov     CH, 2                   ; Signify to turn off channel
                Pop     DX

SetIWRegisters7:
                MovZX   BX, Byte Ptr [SI+36h]   ; BX = sample number.
                Cmp     BL, 99
                JA      SetIWRegisters20

                ShL     BX, 2                   ; IWDataTable+BX = position

                Cmp     DWord Ptr [CS:IWDataTable+BX], 0FFFFFFFFh
                JNE     SetIWRegisters10

SetIWRegisters20:
                Mov     CH, 2
                Jmp     SetIWRegisters9

SetIWRegisters10:
                Test    CH, 5                   ; Loop changed?!??!?
                JZ      SetIWRegisters8

                Mov     AL, 3                   ; Starting location low.
                Out     DX, AL

                Mov     EAX, [SI+40h]
                Call    IWGetAddress

                                ; Reqd: .OOOOOOO OOOOOOOO OOOOOOOI III.....

                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 2                   ; Starting location high
                Out     DX, AL

                ShR     EAX, 16
                Inc     DX
                Out     DX, AX
                Dec     DX

                                                ; Ending location...
                Mov     AL, 5                   ; Ending location low
                Out     DX, AL

                Mov     EAX, [SI+44h]
                Call    IWGetAddress

                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 4                   ; Ending location high
                Out     DX, AL

                SHR     EAX, 16
                Inc     DX
                Out     DX, AX
                Dec     DX

SetIWRegisters8:
                Test    CH, 1                   ; Do Current position?
                JZ      SetIWRegisters9

                Xor     AL, AL
                Out     DX, AL

                Mov     AL, 3
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 9
                Out     DX, AL
                Xor     AX, AX
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 10h
                Out     DX, AL
                Add     DL, 2
                Mov     AL, Byte Ptr [CS:IWDataTable+BX+2]
                ShR     AL, 6
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 0Bh         ; Current location LOW
                Out     DX, AL

                Mov     EAX, [SI+4Ch]
                Mov     [SI+2Ch], EAX

                        ; EAX   = OOOOOOOO OOOOOOOO OOOOOOOO OOOOOOOO
                        ; Req:    xOOOOOOO OOOOOOOO OOOOOOOF FFFFFFFF
                Call    IWGetAddress

                Mov     DI, AX

                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 0Ah         ; Current location HIGH
                Out     DX, AL

                SHR     EAX, 16
                Inc     DX
                Out     DX, AX
                Dec     DX

                Mov     AL, 0Bh
                Out     DX, AL

                Mov     AX, DI
                Inc     DX
                Out     DX, AX
                Dec     DX

SetIWRegisters9:
                Test    CL, 64                  ; New volume??
                JZ      SetIWPan

SetIWRegisters23:
                Xor     BX, BX
                Test    CH, 8
                JNZ     SetIWRegistersMuted

                Mov     BL, Byte Ptr [SI+20h]   ; BL = volume, 0->128

SetIWRegistersMuted:
                Call    SetIWVolume

SetIWPan:
                Test    CH, 128                 ; New pan??
                JZ      SetIWRegisters5

                Xor     BH, BH

                Test    CS:Stereo, 1
                JZ      SetIWRegisters3

                Mov     BL, [SI+37h]
                Cmp     BL, 100
                JNE     SetIWRegisters4

SetIWRegisters3:
                Mov     BL, 32                  ; Surround goes to mono :(

SetIWRegisters4:
                Add     BX, BX                  ; BX = offset into IWTable

                Test    CH, 1
                JZ      IWSetPan1

                Mov     AL, 0Ch         ; Right offset
                Out     DX, AL
                Inc     DX
                Mov     AX, [CS:OffsetTable+BX]
                Out     DX, AX
                Dec     DX

                Neg     BX

                Mov     AL, 13h         ; Left offset final
                Out     DX, AL
                Inc     DX
                Mov     AX, [CS:OffsetTable+128+BX]
                Out     DX, AX
                Dec     DX

                Neg     BX

IWSetPan1:
                Mov     AL, 1Bh         ; Right offset final
                Out     DX, AL
                Inc     DX
                Mov     AX, [CS:OffsetTable+BX]
                Out     DX, AX
                Dec     DX

                Neg     BX

                Mov     AL, 1Ch         ; Left offset final
                Out     DX, AL
                Inc     DX
                Mov     AX, [CS:OffsetTable+128+BX]
                Out     DX, AX
                Dec     DX

SetIWRegisters5:
                                                ; Now for control register.
                                                ; If CH | 2, then turn rego OFF
                                                ; If CH | 5, then turn rego ON
                                                ; If CL | 1, then check channel
                Test    CH, 2
                JNZ     SetIWRegisters11

                Test    CH, 5
                JNZ     SetIWRegisters12

                Test    CL, 1
                JZ      SetIWRegisters13

                Mov     AL, 80h                 ; Read voice control
                Out     DX, AL

                Add     DL, 2
                In      AL, DX
                Sub     DL, 2

                Test    AL, 1
                JZ      SetIWRegisters13

                Xor     BX, BX
                Call    SetIWVolume

                Jmp     SetIWRegisters14

SetIWRegisters11:                               ; Turn off.
                Mov     Byte Ptr [SI+4], 0FFh

                Xor     BX, BX
                Call    SetIWVolume

                Xor     AL, AL
                Out     DX, AL
                Mov     AL, 2
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 15h
                Out     DX, AL

                Add     DL, 2           ; Synthesizer Mode select
                Mov     AL, 34          ; Offset enable, enable voice
                Out     DX, AL
                Sub     DL, 2


SetIWRegisters14:
                Test    CL, 1
                JZ      SetIWRegisters13

                Xor     CX, CX                  ; Turn off channel
                Test    Byte Ptr [SI+3Ah], 80h
                JNZ     SetIWRegisters13

                Mov     BX, [SI+38h]
                And     Byte Ptr [BX], Not 4    ; Signify channel off

                Jmp     SetIWRegisters13

SetIWRegisters12:                              ; Turn on
                Mov     AL, [SI+36]
                Mov     [SI+4], AL

                Mov     AL, 15h
                Out     DX, AL

                Add     DL, 2           ; Synthesizer Mode select
                Mov     AL, 32          ; Offset enable, enable voice
                Out     DX, AL
                Sub     DL, 2

                Xor     AL, AL
                Out     DX, AL

                Mov     AL, [SI+0Ah]

                Cmp     CS:Convert16To8Bit, 0
                JNZ     SetIWRegistersNo16Bit

                Mov     AH, [SI+18h]            ; 16 bit?
                Add     AH, AH
                Or      AL, AH

SetIWRegistersNo16Bit:
                Test    CL, 1
                JNZ     SetIWRegisters15

                Mov     AL, 2
                Xor     CX, CX

SetIWRegisters15:
                Add     DL, 2
                Out     DX, AL

SetIWRegisters13:
                And     CX, 0111100010011111b   ; Turns off:
                                                ; 1) Freq & vol recalc
                                                ; 2) New note/note stop/loop cha

                Mov     [SI], CX

                Add     SI, SLAVECHANNELSIZE

                Pop     CX
                Pop     AX

                Inc     AX
                Dec     CX
                JNZ     SetIWRegisters1

                Ret


EndP            SetIWRegisters

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

Relocation1:
                LodsW
                Cmp     AX, 0FFFFh
                JE      RelocationEnd

                Mov     BX, AX
                Mov     [BX], CS
                Jmp     Relocation1

RelocationEnd:                          ; OK... disable the IW Line In
                                        ; & Enable Line Out
                                ; SetupMIDI
                Mov     DX, BasePort
                Inc     DH
                Mov     AL, 0FFh
                Out     DX, AL
                Mov     AL, 0FCh
                Out     DX, AL

                                ; Setup the rest of it.
                Mov     DX, BasePort
                Mov     AL, 1
                Out     DX, AL

                Mov     DX, IWRegisterSelect
                Mov     AL, 0Eh
                Out     DX, AL          ; DX = BasePort+103h

                Add     DL, 2           ; DX = BasePort+105h
                Mov     AL, 0CDh
                Out     DX, AL          ; Full mixing rate

                Mov     CX, 32
                Sub     DL, 3

IWResetVoice1:
                Mov     AL, CL
                Dec     AL
                Out     DX, AL

                Inc     DX              ; DX = BasePort + 103h
                Xor     AL, AL          ; Voice control register, 8 bit
                Out     DX, AL

                Add     DL, 2
                Mov     AL, 3
                Out     DX, AL          ; Stop voice
                Sub     DL, 2

                Mov     AL, 0Dh         ; Volume Ramp.
                Out     DX, AL

                Mov     AL, 3
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 6           ; Ramp rate
                Out     DX, AL

                Mov     AL, 32          ; Ramp rate
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 9           ; Volume register, 16 bit
                Out     DX, AL

                Inc     DX
                Xor     AX, AX
                Out     DX, AX          ; No volume
                Dec     DX

                Mov     AL, 15h
                Out     DX, AL

                Add     DL, 2           ; Synthesizer Mode select
                Mov     AL, 32          ; Offset enable, enable voice
                Out     DX, AL

                ClI
                Sub     DL, 3           ; DX = BasePort + 102h = Voice select.

                Loop    IWResetVoice1

                Inc     DL
                Mov     AL, 5Bh
                Out     DX, AL
                Add     DL, 2
                In      AL, DX
                Sub     DL, 2
                Shr     AL, 4           ; AL = revision number

                Add     AL, 'A'
                Mov     Revision, AL
;                Cmp     AL, 'C'
;                JE      InitSound_IW2

;                Mov     OffsetTable, Offset IWOffsetTable2

InitSound_IW2:
                Cmp     CS:IRQ, 0FFFFh
                JE      InitSound_IW1

                Mov     AX, BasePort
                Call    ResetIW

                In      AL, 0A1h
                Mov     AH, AL
                In      AL, 21h
                Mov     IMR, AX

                                ; Set IRQ
                Mov     BX, IRQ
                ShL     BX, 2           ; BX points to offset in IRQData

                Xor     DI, DI
                Mov     ES, DI
                Mov     DI, [BX+IRQData]

                And     AX, [BX+IRQData+2]

                Out     21h, AL
                Mov     AL, AH
                Out     0A1h, AL

                Mov     AX, CS
                ShL     EAX, 16
                Mov     AX, Offset IWIRQOnlyHandler

                XChg    [ES:DI], EAX
                Mov     OldIRQHandler, EAX

                StI

                Mov     DX, BasePort
                Mov     AL, 9
                Out     DX, AL

                Call    GetTempo
                Call    SetTempo
                Call    ResetMemory

                Mov     AL, Revision
                Mov     RevisionLetter2, AL

                Mov     AX, BasePort
                Mov     BX, IRQ
                Mov     CX, IWMemory

                Mov     SI, Offset IWID2

                ClC
                Ret

InitSound_IW1:
                Mov     AL, 4Ch
                Out     DX, AL
                Add     DL, 2
                Mov     AL, 3
                Out     DX, AL

                Mov     AL, 34h         ; Program IRQ 0. LSB&MSB, Rate gen
                Out     43h, AL

                Call    GetTempo
                Call    SetTempo
                Call    ResetMemory

                Mov     DX, BasePort
                Mov     AL, 1
                Out     DX, AL

                Xor     AX, AX
                Mov     ES, AX          ; ES = 0

                Mov     AX, CS
                ShL     EAX, 16
                Mov     AX, Offset IWIRQHandler

                ClI

                XChg    DWord Ptr [ES:20h], EAX         ; Clock tick
                Mov     OldIRQHandler, EAX

                StI

                Mov     AL, Revision
                Mov     RevisionLetter, AL

                Mov     AX, BasePort
                Mov     BX, IWMemory
                Mov     SI, Offset IWID

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

                Push    CS
                Pop     DS
                Mov     SI, Offset IWReinitMsg
                Mov     BX, 40
                Call    SetInfoLine

                Mov     BX, CS:IRQ
                Cmp     BX, 0FFFFh
                JE      ReInitSound1

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

                Jmp     ReInitSound2

ReInitSound1:
                Mov     AL, 34h
                Out     43h, AL

                Xor     AX, AX
                Out     40h, AL
                Out     40h, AL

                Mov     ES, AX
                Mov     EAX, OldIRQHandler
                Mov     [ES:20h], EAX

ReInitSound2:
                Mov     DX, IWRegisterSelect
                Mov     AL, 52h
                Out     DX, AL
                Inc     DX
                Mov     AX, NewIWLMCFI
                Out     DX, AX

                Jmp     RelocationEnd

EndP            ReInitSound

;컴 UnInitSound 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Stops sound output, releases any memory used by driver
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            UnInitSound Far

                Mov     AX, BasePort
                Call    ResetIW

                Mov     DX, BasePort
                Inc     DH
                Mov     AL, 0FFh
                Out     DX, AL          ; Stop MIDI

                Mov     CX, 32
                Mov     DX, CS:IWVoiceSelect

IWResetVoice2:
                Mov     AL, CL
                Dec     AL
                Out     DX, AL

                Inc     DX              ; DX = BasePort + 103h
                Xor     AL, AL          ; Voice control register, 8 bit
                Out     DX, AL

                Add     DL, 2
                Mov     AL, 3
                Out     DX, AL          ; Stop voice
                Sub     DL, 2

                Mov     AL, 0Dh         ; Volume Ramp.
                Out     DX, AL

                Mov     AL, 3
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 9           ; Volume register, 16 bit
                Out     DX, AL

                Inc     DX
                Xor     AX, AX
                Out     DX, AX          ; No volume
                Dec     DX

                Mov     AL, 15h
                Out     DX, AL

                Add     DL, 2
                Mov     AL, 2
                Out     DX, AL          ; Deactivate voice

                ClI
                Sub     DL, 3           ; DX = BasePort + 102h = Voice select.

                Loop    IWResetVoice2

;                Inc     DL
;                Mov     AL, 4Ch
;                Out     DX, AL
;                Xor     AL, AL
;                Add     DL, 2
;                Out     DX, AL

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

                Jmp     UnInitSound2

UnInitSound1:
                Mov     AL, 34h
                Out     43h, AL

                Xor     AX, AX
                Out     40h, AL
                Out     40h, AL

                Mov     ES, AX
                Mov     EAX, OldIRQHandler
                Mov     [ES:20h], EAX

UnInitSound2:
                Mov     DX, IWRegisterSelect
                Mov     AL, 52h
                Out     DX, AL
                Mov     AX, IWLMCFI
                Inc     DX
                Out     DX, AX

                Ret

EndP            UnInitSound

;컴 Poll 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;
; This procedure is called as often as possible by IT.EXE
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            Poll Far

                ClI

Poll1:
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
                Jmp     Poll1

MIDIEnd:
                StI

                Ret

EndP            Poll

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            UARTOut

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

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

InterpretState  DB      0

Proc            SendUARTOut Far ; Local interpreter activated with 0F0h 0F0h.

                Mov     AH, CS:InterpretState
                Cmp     AH, 2
                JB      SendUARTOut1

; In interpreter.
                JE      SendUARTOut3

; Have InterpretType, now get parameter, then return to normal.

                Mov     CS:InterpretState, 0

SendUARTOut4:
                Ret

SendUARTOut3:
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
                Call    UARTOut
                Ret

EndP            SendUARTOut

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

                Mov     DX, CS:IWRegisterSelect

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
                Mov     IWUpdateTimer, AX

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
                JC      Music_IWLoadSampleEnd

                Mov     BL, [FS:BP+12h]
                Test    BL, 16
                JZ      Music_IWLoadSample12

                Cmp     ECX, [FS:BP+38h]
                JBE     Music_IWLoadSample12

                Mov     ECX, [FS:BP+38h]
                Test    BL, 32
                JZ      Music_IWLoadSample12

                Cmp     ECX, [FS:BP+44h]
                JAE     Music_IWLoadSample12

                Mov     ECX, [FS:BP+44h]

Music_IWLoadSample12:
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
                Mov     DWord Ptr [CS:IWDataTable+4*EAX], 0FFFFFFFFh

                Add     ECX, 2

                Cmp     IWMemorySegmented, 0
                JNE     Music_IWLoadSegmented1

                Mov     EAX, IWMemoryFree

                Test    Byte Ptr [FS:BP+12h], 2          ; 16 bit??
                JZ      Music_IWLoadSamples13

                Cmp     CS:Convert16To8Bit, 0
                JNZ     Music_IWLoadSamples5

                Sub     EAX, 1
                JC      Music_IWLoadSampleWarning
                And     EAX, Not 1                      ; For alignment
                Add     ECX, ECX
                Jmp     Music_IWLoadSamples13

Music_IWLoadSamples5:
                Inc     ESI
                Add     EDX, EDX                        ; Step value.

Music_IWLoadSamples13:
                Cmp     ECX, EAX
                JBE     Music_IWLoadSample2

                                                ; Warning msg here.
Music_IWLoadSampleWarning:
                Pop     AX
                ClC
                Jmp     Music_IWLoadSampleEnd

Music_IWLoadSample3:
                StC

Music_IWLoadSampleEnd:
                Pop     FS
                Pop     ES
                Pop     DS
                PopAD

                Ret

Music_IWLoadSegmented1:
                Test    Byte Ptr [FS:BP+12h], 2          ; 16 bit??
                JZ      Music_IWLoadSegmented3

                Cmp     CS:Convert16To8Bit, 0
                JNZ     Music_IWLoadSegmented2

                Add     ECX, ECX

                                                ; Check each of 4 banks...
                Xor     BX, BX

Music_Load16BitSegment1:
                Mov     EAX, [IWBank1+BX]
                And     EAX, Not 1                      ; For alignment
                Cmp     ECX, EAX
                JBE     Music_LoadSegment2

Music_Load16BitSegment2:
                Add     BX, 4
                Cmp     BX, 16
                JB      Music_Load16BitSegment1
                Jmp     Music_IWLoadSampleWarning

Music_LoadSegment2:
                Sub     EAX, ECX
                Mov     [IWBank1+BX], EAX
                ShL     EBX, 20
                Add     EBX, EAX
                Jmp     LoadIWSampleChain

Music_IWLoadSegmented2:
                Inc     ESI
                Add     EDX, EDX                        ; Step value.

Music_IWLoadSegmented3:
                Xor     BX, BX

Music_Load8BitSegment1:
                Mov     EAX, [IWBank1+BX]
                Cmp     ECX, EAX
                JBE     Music_LoadSegment2

                Add     BX, 4
                Cmp     BX, 16
                JB      Music_Load8BitSegment1
                Jmp     Music_IWLoadSampleWarning

Music_IWLoadSample2:                           ; EAX = number of bytes free.
                                                ; DS:SI = sample.
                                                ; ECX = number of bytes of memory
                                                ; ES:DI = num bytes free ptr
                                                ; BP = sample number.

                                ; Location = MaxMem - DX:AX
                                ;          = -(DX:AX - IWBanks*4:0)
                MovZX   EBX, CS:IWMemory
                ShL     EBX, 10
                                                ; BX = bytes avail.
                Sub     EBX, EAX
                Sub     EAX, ECX
                Mov     IWMemoryFree, EAX

LoadIWSampleChain:
                Pop     DI                      ; DI = sample number

                ShL     DI, 2

                Cmp     CS:Convert16To8Bit, 0
                JNZ     LoadIWForced8Bit

                Test    Byte Ptr [FS:BP+12h], 2
                JNZ     Music_IWLoad16BitSample

LoadIWForced8Bit:
                Push    EBX
                Inc     EBX
                Mov     [CS:IWDataTable+DI], EBX       ; Store pointer

                Mov     ES, CS:SongDataArea
                Pop     EDI                     ; EDI = location in IW mem

                Sub     ECX, 2
                                                ; EDI = location in IW mem
                                                ; DS:SI = sample data
                                                ; ECX = length.
                                                ; EDX = step value.
                ClI

                Push    BP

                Mov     EBP, EDX

                Call    IWSetPosition

                Mov     AL, [DS:SI+BP]
                Call    LoadIWSample
                Call    LoadIWSamples

                Mov     BH, AL

                Pop     BP

                Mov     AL, [FS:BP+12h]
                Test    AL, 16
                JZ      Music_IWLoadSample10

                Mov     ESI, [FS:BP+34h]
                Test    AL, 64
                JZ      Music_IWLoadSample11

                Mov     ESI, [FS:BP+38h]
                Sub     ESI, 2
                AdC     ESI, 0

                Mov     EAX, Not 0
                Mov     CL, CS:Compress
                ShL     EAX, CL
                And     ESI, EAX

Music_IWLoadSample11:
                Test    Byte Ptr [FS:BP+12h], 2
                JZ      Music_IWLoadSample6

                Add     ESI, ESI
                Inc     SI

Music_IWLoadSample6:
                Int     3

                Mov     BH, [SI]

Music_IWLoadSample10:
                Mov     AL, BH
                Call    LoadIWSample

                StI
                Jmp     Music_IWLoadSample3    ; Return.. no error.

Music_IWLoad16BitSample:
                Push    EBX

                ShR     EBX, 1
                Inc     BX
                Mov     [CS:IWDataTable+DI], EBX

                Mov     ES, CS:SongDataArea
                Pop     EDI                     ; EDI = location in IW mem

                Sub     ECX, 4
                ClI

                Push    BP

                Mov     EBP, EDX

                Call    IWSetPosition

                Mov     AX, [DS:ESI+EBP*2]
                Call    LoadIWSample
                Mov     AL, AH
                Call    LoadIWSample

                Call    Load16IWSamples

                Pop     BP

                Xor     BX, BX

                Mov     AL, [FS:BP+12h]
                Test    AL, 16
                JZ      Music_IWLoad16BitSample11B

                Mov     ESI, [FS:BP+34h]

                Test    AL, 64
                JZ      Music_IWLoad16BitSample11

                Mov     ESI, [FS:BP+38h]
                Sub     ESI, 2
                JNC     Music_IWLoad16BitSample11

                Xor     ESI, ESI

Music_IWLoad16BitSample11:
                Mov     EAX, Not 0
                Mov     CL, CS:Compress
                ShL     EAX, CL
                And     ESI, EAX

                Add     ESI, ESI
                Int     3

                Mov     BX, [SI]

Music_IWLoad16BitSample11B:
                Mov     AX, BX
                Call    LoadIWSample
                Mov     AL, AH
                Call    LoadIWSample

                StI
                Jmp     Music_IWLoadSample3    ; Return.. no error.


EndP            LoadSample

;컴 ReleaseSample 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Parameters: AX = sample to release, 0 based
;             DS:SI points to sample header
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ReleaseSample Far

                LEA     DI, [EAX*4+Offset IWDataTable]
                                                ; Now to release the last
                                                ; sample from IW memory if
                                                ; able to.

                Mov     EBP, [CS:DI]            ; EBP = sample pointer.
                Cmp     EBP, 0FFFFFFFFh
                JE      ReleaseSample3

ReleaseSample4:
                MovZX   EAX, CS:IWMemory
                SHL     EAX, 10

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
                Add     EBP, EBP

ReleaseSample8Bit:
                Cmp     IWMemorySegmented, 0
                JNE     ReleaseSampleSegmented1

                Sub     EAX, EBP
                Sub     EAX, ECX

                Cmp     EAX, IWMemoryFree
                JNE     ReleaseSample3

                Add     ECX, EDI
                Add     IWMemoryFree, ECX

                Ret

ReleaseSampleSegmented1:                ; EBP = sample pointer
                                        ; if EBP-EDI = mem remaining in
                                        ; segment, then add ECX+EDI...
                Xor     AX, AX
                Sub     EBP, EDI
                Add     ECX, EDI
                Mov     EDI, EBP

                And     EBP, 3FFFFFh

                ShR     EDI, 22
                And     DI, 3
                Mov     EAX, [IWBank1+EDI*4]
                Cmp     EAX, EBP
                JNE     ReleaseSample3

                Add     [IWBank1+EDI*4], ECX

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

                MovZX   EAX, IWMemory           ; Number of kbytes
                ShL     EAX, 10                 ; Translate to bytes

                Cmp     IWMemorySegmented, 0
                JE      ResetMemory1

                Xor     AH, AH
                Mov     AL, [IWBankTable]
                ShL     EAX, 16
                Mov     IWBank1, EAX

                Xor     AH, AH
                Mov     AL, [IWBankTable+1]
                ShL     EAX, 16
                Mov     IWBank2, EAX

                Xor     AH, AH
                Mov     AL, [IWBankTable+2]
                ShL     EAX, 16
                Mov     IWBank3, EAX

                Xor     AH, AH
                Mov     AL, [IWBankTable+3]
                ShL     EAX, 16
                Mov     IWBank4, EAX

                Jmp     ResetMemory2

ResetMemory1:
                Sub     EAX, 64                 ; Safety bytes.
                Mov     IWMemoryFree, EAX

ResetMemory2:
                Push    CS
                Pop     ES
                Mov     DI, Offset IWDataTable
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

                Mov     EAX, IWMemoryFree
                Cmp     IWMemorySegmented, 0
                JE      GetStatus1

                Mov     EAX, IWBank1
                Add     EAX, IWBank2
                Add     EAX, IWBank3
                Add     EAX, IWBank4

GetStatus1:
                Mov     SI, Offset IWFreeMsg
                ShR     EAX, 10

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
                Mov     DX, Offset IWScreenList

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

EndDriver:

;********  Provided Constants Table *************

MaxNumberOfChannels     DW      32      ; Maximum number of channels the
                                        ; driver can handle.
StopAfterPlay           DW      0
DefaultChannels         DW      32

DriverFlags             DW      1       ; MIDI Out suported
                        DW      4 Dup (0)

;********  Provided Procedure Table *************

ProvidedTableStart:
        DW      Offset DetectIW

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

        DW      Offset SendUARTOut          ; MIDI output!

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


