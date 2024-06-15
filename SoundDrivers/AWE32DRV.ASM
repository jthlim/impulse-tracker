
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

        Comment ~

Index = BasePort + 802h

      15  14  13  12  11  10   9   8   7   6   5   4   3   2   1   0
    旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴커
    � .............................. � Register  �  Channel Number   �
    읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴켸


        ~

OldIRQHandler   DD      0
AWEMemory       DD      0
AWEMemoryUsed   DD      0
AWEUpdateCount  DW      0

AWEUpdateTimer  DW      0

LoadSampleFuncF DW      0
LoadSampleFuncB DW      0

AWEDataTable    DD      5*100 Dup (0)   ; Start, Startloop, Endloop, Size
MIDIPort        DW      0
MIDIBuffer      DB      256 Dup (0)
MIDIBufferHead  DB      0
MIDIBufferTail  DB      0

DMABuffer       DW      0

SB16BasePort    DW      0
MixerPort       DW      0
Step            DW      1
AWEUpdateFlag   DB      0
Compress        DB      0
                DB      0

SBIRQMode       DB      0
BlockLength     DW      100
BlockLength2    DW      100

AWE32Msg        DB      "Sound Blaster AWE 32 detected", 13
                DB      "Address ", 0FDh, "Xh, ", 0FDh, "Dk Memory", 0

AWE32Msg2       DB      "Sound Blaster AWE 32 detected", 13
                DB      "Port ", 0FDh, "Xh, IRQ ", 0FDh, "D, DMA ", 0FDh, "D", 0

AWE32Status     DB      "FreeAWE ", 0FDh, "Dk", 0

AWE32ReinitMsg  DB      "Sound Blaster AWE 32 reinitialised", 0
Stereo          DB      0
Forced          DB      0
DriverName      DB      "ITAWE32.DRV", 0

FrequencyError  DB      "AWE Hardware frequency limit exceeded -> Note terminated", 0

IRQFlag         DB      0FFh

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

        CPF             EQU             0
        PTRX            EQU             20h
        CVCF            EQU             40h
        VTFT            EQU             60h
        PSST            EQU             0C0h
        CSL             EQU             0E0h

        CCCA            EQU             100h
        HWCF4           EQU             129h
        HWCF5           EQU             12Ah
        HWCF6           EQU             12Dh
        SMALR           EQU             134h
        SMARR           EQU             135h
        SMALW           EQU             136h
        SMARW           EQU             137h
        SMLD            EQU             43Ah
        SMRD            EQU             23Ah
        WC              EQU             23Bh
        HWCF1           EQU             43Dh
        HWCF2           EQU             43Eh
        CFG2            EQU             43Eh
        HWCF3           EQU             43Fh
        INIT1           EQU             440h
        INIT2           EQU             240h
        INIT3           EQU             460h
        INIT4           EQU             260h
        ENVVOL          EQU             480h
        DCYSUSV         EQU             4A0h
        ENVVAL          EQU             4C0h
        DCYSUS          EQU             4E0h
        SUSDCY          EQU             4E0h
        ATKHLDV         EQU             280h
        LFO1VAL         EQU             2A0h
        ATKHLD          EQU             2C0h
        HLDATK          EQU             2C0h
        LFO2VAL         EQU             2E0h
        IP              EQU             300h
        IFATN           EQU             320h
        PEFE            EQU             340h
        FMMOD           EQU             360h
        TREMFRQ         EQU             380h
        FM2FRQ2         EQU             3A0h

ALIGN 4

InitTable1      Label
        DW      003FFh, 0030h,  007FFh, 0130h, 00BFFh, 0230h,  00FFFh, 0330h
        DW      013FFh, 0430h,  017FFh, 0530h, 01BFFh, 0630h,  01FFFh, 0730h
        DW      023FFh, 0830h,  027FFh, 0930h, 02BFFh, 0A30h,  02FFFh, 0B30h
        DW      033FFh, 0C30h,  037FFh, 0D30h, 03BFFh, 0E30h,  03FFFh, 0F30h

        DW      043FFh, 0030h,  047FFh, 0130h, 04BFFh, 0230h,  04FFFh, 0330h
        DW      053FFh, 0430h,  057FFh, 0530h, 05BFFh, 0630h,  05FFFh, 0730h
        DW      063FFh, 0830h,  067FFh, 0930h, 06BFFh, 0A30h,  06FFFh, 0B30h
        DW      073FFh, 0C30h,  077FFh, 0D30h, 07BFFh, 0E30h,  07FFFh, 0F30h

        DW      083FFh, 0030h,  087FFh, 0130h, 08BFFh, 0230h,  08FFFh, 0330h
        DW      093FFh, 0430h,  097FFh, 0530h, 09BFFh, 0630h,  09FFFh, 0730h
        DW      0A3FFh, 0830h,  0A7FFh, 0930h, 0ABFFh, 0A30h,  0AFFFh, 0B30h
        DW      0B3FFh, 0C30h,  0B7FFh, 0D30h, 0BBFFh, 0E30h,  0BFFFh, 0F30h

        DW      0C3FFh, 0030h,  0C7FFh, 0130h, 0CBFFh, 0230h,  0CFFFh, 0330h
        DW      0D3FFh, 0430h,  0D7FFh, 0530h, 0DBFFh, 0630h,  0DFFFh, 0730h
        DW      0E3FFh, 0830h,  0E7FFh, 0930h, 0EBFFh, 0A30h,  0EFFFh, 0B30h
        DW      0F3FFh, 0C30h,  0F7FFh, 0D30h, 0FBFFh, 0E30h,  0FFFFh, 0F30h

InitTable2      Label
        DW      003FFh, 8030h,  007FFh, 8130h, 00BFFh, 8230h,  00FFFh, 8330h
        DW      013FFh, 8430h,  017FFh, 8530h, 01BFFh, 8630h,  01FFFh, 8730h
        DW      023FFh, 8830h,  027FFh, 8930h, 02BFFh, 8A30h,  02FFFh, 8B30h
        DW      033FFh, 8C30h,  037FFh, 8D30h, 03BFFh, 8E30h,  03FFFh, 8F30h

        DW      043FFh, 8030h,  047FFh, 8130h, 04BFFh, 8230h,  04FFFh, 8330h
        DW      053FFh, 8430h,  057FFh, 8530h, 05BFFh, 8630h,  05FFFh, 8730h
        DW      063FFh, 8830h,  067FFh, 8930h, 06BFFh, 8A30h,  06FFFh, 8B30h
        DW      073FFh, 8C30h,  077FFh, 8D30h, 07BFFh, 8E30h,  07FFFh, 8F30h

        DW      083FFh, 8030h,  087FFh, 8130h, 08BFFh, 8230h,  08FFFh, 8330h
        DW      093FFh, 8430h,  097FFh, 8530h, 09BFFh, 8630h,  09FFFh, 8730h
        DW      0A3FFh, 8830h,  0A7FFh, 8930h, 0ABFFh, 8A30h,  0AFFFh, 8B30h
        DW      0B3FFh, 8C30h,  0B7FFh, 8D30h, 0BBFFh, 8E30h,  0BFFFh, 8F30h

        DW      0C3FFh, 8030h,  0C7FFh, 8130h, 0CBFFh, 8230h,  0CFFFh, 8330h
        DW      0D3FFh, 8430h,  0D7FFh, 8530h, 0DBFFh, 8630h,  0DFFFh, 8730h
        DW      0E3FFh, 8830h,  0E7FFh, 8930h, 0EBFFh, 8A30h,  0EFFFh, 8B30h
        DW      0F3FFh, 8C30h,  0F7FFh, 8D30h, 0FBFFh, 8E30h,  0FFFFh, 8F30h

InitTable3      Label
        DW      0C10h,  8470h,  14FEh, 0B488h, 167Fh,  0A470h, 18E7h,  84B5h
        DW      1B6Eh,  842Ah,  1F1Dh, 852Ah,  0DA3h,  9F7Ch,  167Eh, 0F254h
        DW      0,      842Ah,  1,     852Ah,  18E6h,  9BAAh,  1B6Dh, 0F234h
        DW      229Fh,  8429h,  2746h, 8529h,  1F1Ch,  96E7h,  229Eh, 0F224h

        DW      0DA4h,  8429h,  2C29h, 8529h,  2745h,  97F6h,  2C28h, 0F254h
        DW      383Bh,  8428h,  320Fh, 8528h,  320Eh,  9F02h,  1341h, 0F264h
        DW      3EB6h,  8428h,  3EB9h, 8528h,  383Ah,  9FA9h,  3EB5h, 0F294h
        DW      3EB7h,  8474h,  3EBAh, 8575h,  3EB8h,  0C4C3h, 3EBBh, 0C5C3h

        DW      00000,  0A404h, 00001, 0A504h, 141Fh,  8671h,  14FDh,  8287h
        DW      3EBCh,  0E610h, 3EC8h, 8C7Bh,  31Ah,   87E6h,  3EC8h,  86F7h
        DW      3EC0h,  821Eh,  3EBEh, 0D208h, 3EBDh,  821Fh,  3ECAh,  8386h
        DW      3EC1h,  8C03h,  3EC9h, 831Eh,  3ECAh,  8C4Ch,  3EBFh,  8C55h

        DW      3EC9h,  0C208h, 3EC4h, 0BC84h, 3EC8h,  8EADh,  3EC8h,  0D308h
        DW      3EC2h,  8F7Eh,  3ECBh,  821Eh, 3ECBh,  0D208h, 3EC5h,  831Fh
        DW      3EC6h,  0C308h, 3EC3h, 0B2FFh, 3EC9h,  8265h,  3EC9h,  831Eh
        DW      1342h,  0D308h, 3EC7h, 0B3FFh, 0,      8365h,  1420h,  9570h

InitTable4      Label
        DW      0C10h,  8470h,  14FEh, 0B488h, 167Fh,  0A470h, 18E7h,  84B5h
        DW      1B6Eh,  842Ah,  1F1Dh, 852Ah,  0DA3h,  0F7Ch,  167Eh,  7254h
        DW      0,      842Ah,  1,     852Ah,  18E6h,  0BAAh,  1B6Dh,  7234h
        DW      229Fh,  8429h,  2746h, 8529h,  1F1Ch,  6E7h,   229Eh,  7224h

        DW      0DA4h,  8429h,  2C29h, 8529h,  2745h,  07F6h,  2C28h,  7254h
        DW      383Bh,  8428h,  320Fh, 8528h,  320Eh,  0F02h,  1341h,  7264h
        DW      3EB6h,  8428h,  3EB9h, 8528h,  383Ah,  0FA9h,  3EB5h,  7294h
        DW      3EB7h,  8474h,  3EBAh, 8575h,  3EB8h,  44C3h,  3EBBh,  45C3h

        DW      00000,  0A404h, 00001, 0A504h, 141Fh,  0671h,  14FDh,  287h
        DW      3EBCh,  0E610h, 3EC8h, 0C7Bh,  31Ah,   7E6h,   3EC8h,  86F7h
        DW      3EC0h,  821Eh,  3EBEh, 0D208h, 3EBDh,  021Fh,  3ECAh,  386h
        DW      3EC1h,  0C03h,  3EC9h, 31Eh,   3ECAh,  8C4Ch,  3EBFh,  0C55h

        DW      3EC9h,  0C208h, 3EC4h, 0BC84h, 3EC8h,  0EADh,  3EC8h,  0D308h
        DW      3EC2h,  8F7Eh,  3ECBh, 021Eh,  3ECBh,  0D208h, 3EC5h,  31Fh
        DW      3EC6h,  0C308h, 3EC3h, 32FFh,  3EC9h,  0265h,  3EC9h,  831Eh
        DW      1342h,  0D308h, 3EC7h, 33FFh,  0,      8365h,  1420h,  9570h

AWEVolumeTable  Label   Byte    ; Value = -log(vol/256)*(20/.375)
                                ;       = -log(vol/256)*(160/3)

        DB      255, 128, 112, 103, 96, 91, 87, 83      ; 0->7
        DB      80, 78, 75, 73, 71, 69, 67, 66          ; 8->15
        DB      64, 63, 61, 60, 59, 58, 57, 56          ; 16->23
        DB      55, 54, 53, 52, 51, 50, 50, 49          ; 24->31
        DB      48, 47, 47, 46, 45, 45, 44, 44          ; 32->39
        DB      43, 42, 42, 41, 41, 40, 40, 39          ; 40->47
        DB      39, 38, 38, 37, 37, 36, 36, 36          ; 48->55
        DB      35, 35, 34, 34, 34, 33, 33, 32          ; 56->63
        DB      32, 32, 31, 31, 31, 30, 30, 30          ; 64->71
        DB      29, 29, 29, 28, 28, 28, 28, 27          ; 72->79
        DB      27, 27, 26, 26, 26, 26, 25, 25          ; 80->87
        DB      25, 25, 24, 24, 24, 23, 23, 23          ; 88->95
        DB      23, 22, 22, 22, 22, 22, 21, 21          ; 96->103
        DB      21, 21, 20, 20, 20, 20, 20, 19          ; 104->111
        DB      19, 19, 19, 19, 18, 18, 18, 18          ; 112->119
        DB      18, 17, 17, 17, 17, 17, 16, 16          ; 120->127
        DB      16                                      ; 128

        Comment ~               ; Value = -log(vol/128)*(20/.375)
                                ;       = -log(vol/128)*(160/3)
                ; This is mathematically the correct table, but it seems too
                ; loud, and it overloads on playback.

        DB      255, 112, 96, 87, 80, 75, 71, 67        ; 0->7
        DB      64, 61, 59, 57, 55, 53, 51, 50          ; 8->15
        DB      48, 47, 45, 44, 43, 42, 41, 40          ; 16->23
        DB      39, 38, 37, 36, 35, 34, 34, 33          ; 24->31
        DB      32, 31, 31, 30, 29, 29, 28, 28          ; 32->39
        DB      27, 26, 26, 25, 25, 24, 24, 23          ; 40->47
        DB      23, 22, 22, 21, 21, 20, 20, 20          ; 48->55
        DB      19, 19, 18, 18, 18, 17, 17, 16          ; 56->63
        DB      16, 16, 15, 15, 15, 14, 14, 14          ; 64->71
        DB      13, 13, 13, 13, 12, 12, 12, 11          ; 72->79
        DB      11, 11, 10, 10, 10, 9,  9,  9           ; 80->87
        DB      9,  8,  8,  8,  8,  7,  7,  7           ; 88->95
        DB      7,  6,  6,  6,  6,  5,  5,  5           ; 96->103
        DB      5,  4,  4,  4,  4,  4,  4,  3           ; 104->111
        DB      3,  3,  3,  2,  2,  2,  2,  2           ; 112->119
        DB      1,  1,  1,  1,  1,  1,  1,  1           ; 120->127
        DB      0

                ~

GUSScreenList           Label
                        DW      7
                        DW      Near Ptr IdleFunctionList
                        DW      Near Ptr GlobalKeyLink

                        DW      Near Ptr FullScreenBox  ; 0
                        DW      Near Ptr ScreenHeader
                        DW      Near Ptr FillHeader
                        DW      Near Ptr GravisHeaderLine

                        DW      Near Ptr MixerText
                        DW      Near Ptr VolumeBox1
                        DW      Near Ptr VolumeBox2

                        DW      Near Ptr MasterVolumeLeft       ; 7
                        DW      Near Ptr MasterVolumeRight
                        DW      Near Ptr TrebleVolumeLeft
                        DW      Near Ptr TrebleVolumeRight
                        DW      Near Ptr BassVolumeLeft
                        DW      Near Ptr BassVolumeRight        ; 12

                        DW      Near Ptr SampleText

                        DW      Near Ptr SampleSize0Button       ; 14
                        DW      Near Ptr SampleSize1Button
                        DW      Near Ptr SampleSize2Button
                        DW      Near Ptr SampleSize3Button      ; 17

                        DW      Near Ptr EffectText
                        DW      Near Ptr EffectBox

                        DW      Near Ptr ChorusThumbBar         ; 20
                        DW      Near Ptr ReverbThumbBar

                        DW      DriverText

                        DW      0

GravisHeaderLine        DW      10
                        DB      "Sound Blaster AWE 32 Driver", 0

DriverText              DW      1
                        DB      27, 48
                        DB      21h
                        DB      "Sound Blaster AWE 32 Driver 1.5 for Impulse Tracker", 0

MixerText               DW      1
                        DB      3, 13
                        DB      20h
                        DB      "Mixer options", 13
                        DB      13
                        DB      "  Master Volume Left", 13
                        DB      "  Master Volume Right", 13
                        DB      13
                        DB      13
                        DB      "  Treble Left", 13
                        DB      "  Treble Right", 13
                        DB      "  Bass Left", 13
                        DB      "  Bass Right", 13
                        DB      0

VolumeBox1              DW      0
                        DB      24, 14, 30, 17
                        DB      25

VolumeBox2              DW      0
                        DB      17, 18, 21, 23
                        DB      25

MasterVolumeLeft        DW      9
                        DB      25, 15
                        DW      0, 31
                        DW      9, 0
                        DW      0FFFFh, 8, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh

MasterVolumeRight       DW      9
                        DB      25, 16
                        DW      0, 31
                        DW      9, 1
                        DW      7, 9, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh

TrebleVolumeLeft        DW      9
                        DB      18, 19
                        DW      0, 15
                        DW      9, 2
                        DW      8, 10, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh

TrebleVolumeRight       DW      9
                        DB      18, 20
                        DW      0, 15
                        DW      9, 3
                        DW      9, 11, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh

BassVolumeLeft          DW      9
                        DB      18, 21
                        DW      0, 15
                        DW      9, 4
                        DW      10, 12, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh

BassVolumeRight         DW      9
                        DB      18, 22
                        DW      0, 15
                        DW      9, 5
                        DW      11, 14, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh

SampleText              DW      1
                        DB      3, 25
                        DB      20h
                        DB      "Sample resizing options", 0

SampleSize0Button       DW      2
                        DW      12, 15, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetCompress
DriverSegment1          DW      0
                        DW      0
                        DW      Offset SetCompress
DriverSegment2          DW      0
                        DB      7, 27, 20, 29, 8
                        DB      0
                        DB      "  Original", 0

SampleSize1Button       DW      2
                        DW      14, 16, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetCompress
DriverSegment3          DW      0
                        DW      1
                        DW      Offset SetCompress
DriverSegment4          DW      0
                        DB      7, 30, 20, 32, 8
                        DB      0
                        DB      "  Half", 0

SampleSize2Button       DW      2
                        DW      15, 17, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetCompress
DriverSegment5          DW      0
                        DW      2
                        DW      Offset SetCompress
DriverSegment6          DW      0
                        DB      7, 33, 20, 35, 8
                        DB      0
                        DB      "  Quarter", 0

SampleSize3Button       DW      2
                        DW      16, 20, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetCompress
DriverSegment7          DW      0
                        DW      3
                        DW      Offset SetCompress
DriverSegment8          DW      0
                        DB      7, 36, 20, 38, 8
                        DB      0
                        DB      "  Eighth", 0

EffectText              DW      1
                        DB      3, 40
                        DB      20h
                        DB      "Effect options", 13
                        DB      13
                        DB      "  Chorus", 13
                        DB      "  Reverb", 0


EffectBox               DW      0
                        DB      12, 41, 30, 44
                        DB      25

ChorusThumbBar          DW      9
                        DB      13, 42
                        DW      0, 127
                        DW      9, 6
                        DW      17, 21, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh

ReverbThumbBar          DW      9
                        DB      13, 43
                        DW      0, 127
                        DW      9, 7
                        DW      20, 0FFFFh, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh



VolumeTable             DB      6 Dup (0)
CONFIGURATIONOFFSET     EQU     $+128
CONFIGSIZE              EQU     2
Chorus                  DB      10, 64

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

ALIGN 16
FPSave                  DB      128 Dup (0)

AWEParameters   DB      64 Dup (0FFh), 64 Dup (0)

include dma.inc

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

                Push    BX

                Mov     BL, CS:InterpretType    ; Want BX = InterpretType*64+Channel
                                                ;
                ShL     BX, 6
                Add     BL, [DI+20h]
                And     BX, 127
                Mov     [CS:AWEParameters+BX], AL

                Pop     BX

                Mov     CS:InterpretState, 0

                Test    SI, SI
                JZ      SendUARTOut4

                Or      Byte Ptr [SI], 64

SendUARTOut4:
                Ret

SendUARTOut3:
                Mov     InterpretType, AL
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

                Mov     DI, Offset AWEParameters
                Mov     CX, 32
                Or      AX, -1
                Rep     StosW
                Mov     CX, 32
                Inc     AX
                Rep     StosW

                Pop     ES
                PopA

SendUARTOutNoClear:
                Call    UARTOut
                Ret

EndP            SendUARTOut

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            DetectUART              ; Given DX = Port

;        outportb(BasePort+1, 0xFF);
;        while(InputUART() != 0xFE);
;        outportb(BasePort+1, 0x3F);
;        while(InputUART() != 0xFE);

                ClI

                Inc     DX
                Mov     AL, 0FFh        ; reset
                Out     DX, AL
                Xor     CX, CX

DetectUART1:
                In      AL, DX
                Test    AL, 80h
                LoopNZ  DetectUART1
                JNZ     DetectUARTFailed

                Dec     DX
                In      AL, DX
                Inc     DX
                Cmp     AL, 0FEh
                JNE     DetectUART1

                Xor     CX, CX

DetectUART3:
                In      AL, DX
                Test    AL, 40h
                LoopNZ  DetectUART3
                JNZ     DetectUARTFailed

                Mov     AL, 03Fh
                Out     DX, AL

                Xor     CX, CX

DetectUART2:
                In      AL, DX
                Test    AL, 80h
                LoopNZ  DetectUART2
                JNZ     DetectUARTFailed

                Dec     DX
                In      AL, DX
                Inc     DX
                Cmp     AL, 0FEh
                JNE     DetectUART2
                Dec     DX

                ClC
                StI
                Ret

DetectUARTFailed:
                StC
                StI
                Ret

Comment ~

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

~

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

Proc            SetCompress Far

                Mov     CX, [SI+22]
                Mov     CS:Compress, CL

                Mov     AX, 1
                ShL     AX, CL
                Mov     CS:Step, AX

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

Proc            Load8BitSamplesForwards ; Given DS:SI, ECX = count

                Push    BX

                Mov     BX, CS:Step
                Mov     DX, CS:BasePort
                Add     DX, 400h
                Xor     AL, AL

Load8BitSamplesForwards2:
                Mov     AH, [SI]
                Add     SI, BX
                JC      Load8BitSamplesForwards4

Load8BitSamplesForwards3:
                Out     DX, AX

                Dec     ECX
                JNZ     Load8BitSamplesForwards2

                Pop     BX
                Ret

Load8BitSamplesForwards4:
                Add     ESI, 10000h
                Int     3
                Jmp     Load8BitSamplesForwards3

EndP            Load8BitSamplesForwards

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            Load16BitSamplesForwards ; Given DS:SI, ECX = count

                Push    BX

                Mov     BX, CS:Step
                Mov     DX, CS:BasePort
                Add     DX, 400h
                Add     BX, BX

Load16BitSamplesForwards2:
                Mov     AX, [SI]
                Add     SI, BX
                JC      Load16BitSamplesForwards4

Load16BitSamplesForwards3:
                Out     DX, AX

                Dec     ECX
                JNZ     Load16BitSamplesForwards2

                Pop     BX
                Ret

Load16BitSamplesForwards4:
                Add     ESI, 10000h
                Int     3
                Jmp     Load16BitSamplesForwards3

EndP            Load16BitSamplesForwards

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            Load8BitSamplesBackwards ; Given DS:SI, ECX = count

                Push    BX

                Mov     BX, CS:Step
                Mov     DX, CS:BasePort
                Add     DX, 400h
                Xor     AL, AL

                Sub     SI, BX
                JC      Load8BitSamplesBackwards6

Load8BitSamplesBackwards2:
                Sub     SI, BX
                JC      Load8BitSamplesBackwards4

Load8BitSamplesBackwards3:
                Mov     AH, [SI]
                Out     DX, AX

                Dec     ECX
                JNZ     Load8BitSamplesBackwards2


                Pop     BX
                Ret

Load8BitSamplesBackwards4:
                Sub     ESI, 10000h
                JC      Load8BitSamplesBackwards5
                Int     3
                Jmp     Load8BitSamplesBackwards3

Load8BitSamplesBackwards5:
                Xor     ESI, ESI
                Jmp     Load8BitSamplesBackwards3

Load8BitSamplesBackwards6:
                Sub     ESI, 10000h
                Int     3
                Jmp     Load8BitSamplesBackwards2


EndP            Load8BitSamplesBackwards

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            Load16BitSamplesBackwards ; Given DS:SI, ECX = count

                Push    BX

                Mov     BX, CS:Step
                Mov     DX, CS:BasePort
                Add     DX, 400h
                Add     BX, BX

                Sub     SI, BX
                JC      Load16BitSamplesBackwards6

Load16BitSamplesBackwards2:
                Sub     SI, BX
                JC      Load16BitSamplesBackwards4

Load16BitSamplesBackwards3:
                Mov     AX, [SI]
                Out     DX, AX

                Dec     ECX
                JNZ     Load16BitSamplesBackwards2

                Pop     BX
                Ret

Load16BitSamplesBackwards4:
                Sub     ESI, 10000h
                JC      Load16BitSamplesBackwards5
                Int     3
                Jmp     Load16BitSamplesBackwards3

Load16BitSamplesBackwards5:
                Xor     ESI, ESI
                Jmp     Load16BitSamplesBackwards3

Load16BitSamplesBackwards6:
                Sub     ESI, 10000h
                Int     3
                Jmp     Load16BitSamplesBackwards2


EndP            Load16BitSamplesBackwards

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            WriteDataChannel

                Or      AX, DX

Proc            WriteData       ; Have BX/EBX = value
                                ; AX = xxyyh
                                ;      ^ ^
                                ;      | |
                                ;      | \-- value to send to pointer register
                                ;      \---- 0, 1, 2 or 3, 4
                                ;       0 = data reg 0
                                ;       1 = data reg 1, dword
                                ;       2 = data reg 2
                                ;       3 = data reg 3
                                ;       4 = data reg 4, word

                Jmp     $+2
                Jmp     $+2

                Push    DX
                Push    AX

                Mov     DX, BasePort
                Add     DX, 802h
                And     AX, 0FFh
                Out     DX, AX
                Pop     AX

                Jmp     $+2
                Jmp     $+2

                Cmp     AH, 1
                JB      WriteDataReg0
                JE      WriteDataReg1DWord
                Cmp     AH, 3
                JB      WriteDataReg2
                JE      WriteDataReg3
                Jmp     WriteDataReg1Word

WriteDataReg0:
                Sub     DX, 802h
                Mov     EAX, EBX
                Out     DX, EAX

                Pop     DX
                Ret

WriteDataReg1DWord:
                Sub     DX, 402h
                Mov     EAX, EBX
                Out     DX, EAX

                Pop     DX
                Ret

WriteDataReg1Word:
                Sub     DX, 402h
                Mov     AX, BX
                Out     DX, AX

                Pop     DX
                Ret

WriteDataReg2:
                Sub     DX, 400h
                Mov     AX, BX
                Out     DX, AX

                Pop     DX
                Ret

WriteDataReg3:
                Sub     DL, 2
                Mov     AX, BX
                Out     DX, AX

                Pop     DX
                Ret

EndP            WriteData

EndP            WriteDataChannel

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ReadDataChannel

                Or      AX, DX

Proc            ReadData       ; AX = xxyyh
                                ;      ^ ^
                                ;      | |
                                ;      | \-- value to send to pointer register
                                ;      \---- 0, 1, 2 or 3, 4
                                ;       0 = data reg 0
                                ;       1 = data reg 1, dword
                                ;       2 = data reg 2
                                ;       3 = data reg 3
                                ;       4 = data reg 4, word

                Jmp     $+2
                Jmp     $+2

                Push    DX
                Push    AX

                Mov     DX, BasePort
                Add     DX, 802h
                And     AX, 0FFh
                Out     DX, AX
                Pop     AX

                Jmp     $+2
                Jmp     $+2

                Cmp     AH, 1
                JB      ReadDataReg0
                JE      ReadDataReg1DWord
                Cmp     AH, 3
                JB      ReadDataReg2
                JE      ReadDataReg3
                Jmp     ReadDataReg1Word

ReadDataReg0:
                Sub     DX, 802h
                In      EAX, DX

                Pop     DX
                Ret

ReadDataReg1DWord:
                Sub     DX, 402h
                In      EAX, DX

                Pop     DX
                Ret

ReadDataReg1Word:
                Sub     DX, 402h
                In      AX, DX

                Pop     DX
                Ret

ReadDataReg2:
                Sub     DX, 400h
                In      AX, DX

                Pop     DX
                Ret

ReadDataReg3:
                Sub     DL, 2
                In      AX, DX

                Pop     DX
                Ret

EndP            ReadData

EndP            ReadDataChannel

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Const44100      DD      44100.0
Const1000h      DD      4096.0
ConstE000h      DD      57344.0

Proc            SetAWEFrequency

                Mov     EAX, [SI+10h]   ; Final freq

                Push    CX
                Mov     CL, Compress
                ShR     EAX, CL
                Pop     CX

;                Test    EAX, EAX
                JZ      SetAWEFrequencyError
                Cmp     EAX, 88200*2
                JAE     SetAWEFrequencyError

                Mov     DWord Ptr [SI+4], EAX

                FLd     CS:ConstE000h
                FLd     CS:Const1000h
                FILd    DWord Ptr [SI+4]
                FDiv    CS:Const44100
                FYL2X   ; ST = ln(Pitch/44100)/ln(2) * 1000h
                FAddP   ST(1)
                FIStP   DWord Ptr [SI+4]

                Mov     AX, IP
                Mov     BX, [SI+4]
                Call    WriteDataChannel

                Ret
                        Assume DS:Nothing

SetAWEFrequencyError:
                Call    StopAWENote

                Mov     Word Ptr [SI], 200h
                Test    Byte Ptr [SI+3Ah], 80h
                JNZ     SetAWEFrequencyError1

                Mov     BX, [SI+38h]
                And     Byte Ptr [BX], Not 4    ; Signify channel off

SetAWEFrequencyError1:
                Mov     AX, IP
                Xor     EBX, EBX
                Call    WriteDataChannel

                Push    DS SI

                Push    CS
                Pop     DS
                Mov     SI, Offset FrequencyError
                Mov     BX, 40
                Call    SetInfoLine

                Pop     SI DS

                Ret

EndP            SetAWEFrequency
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SetAWEPan

                Mov     AX, PSST
                Call    ReadDataChannel         ; Get starting offset

                Cmp     CS:Stereo, 0
                JE      SetPan2

                Test    CL, 128
                JNZ     SetPan2

                Mov     BL, [SI+37h]            ; Final pan
                Cmp     BL, 100                 ; Surround -> central
                JNE     SetPan1

SetPan2:
                Mov     BL, 32

SetPan1:                        ; BL = 0->64, need to extend to 0->255
                Add     BL, BL
                Add     BL, BL
                SBB     BL, 0   ; BL = 0->255
                Not     BL

                ShL     EAX, 8
                SHLD    EBX, EAX, 24
                Mov     AX, PSST
                Call    WriteDataChannel

                Ret

EndP            SetAWEPan

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SetAWEVolume

                Test    CH, 8
                JZ      SetAWEVolume1

                Test    CH, 1
                JNZ     SetAWEVolume5

                Cmp     Byte Ptr [SI+8], 0FFh
                JE      SetAWEVolume4

SetAWEVolume5:
                Mov     Byte Ptr [SI+8], 0FFh

                Mov     AX, IFATN
                Call    ReadDataChannel
                Mov     BX, AX
                Mov     AX, IFATN
                Mov     BL, 0FFh
                Call    WriteDataChannel

SetAWEVolume4:
                Ret

SetAWEVolume1:
; First check if channel has been disowned
                Xor     BX, BX
                Mov     BL, [SI+3Ah]                    ; BL = host channel

                Test    BL, BL
                JS      SetAWEVolume3

SetAWEVolume2:
                Mov     AH, [CS:AWEParameters+BX]       ; AH = filter
                Mov     AL, [CS:AWEParameters+BX+64]    ; AL = Q.

                ShR     AL, 3
                Mov     [SI+5Bh], AH

                Cmp     AL, [SI+3Fh]
                JE      SetAWEVolume3

                Mov     [SI+3Fh], AL

; Set Q
                Mov     BL, AL
                ShL     EBX, 28

                Mov     AX, CCCA
                Call    ReadDataChannel
                And     EAX, 0FFFFFFFh
                Or      EBX, EAX
                Mov     AX, CCCA
                Call    WriteDataChannel

SetAWEVolume3:
                Mov     AL, [SI+3Eh]
                Mul     Byte Ptr [SI+5Bh]
                ShL     AX, 1
                Xor     BX, BX
                Add     AH, 1
                Mov     BL, [SI+20h]                    ; Final volume
                Mov     [SI+8], BL
                Mov     BL, [CS:AWEVolumeTable+BX]
                Mov     BH, AH
                Mov     AX, IFATN
                Call    WriteDataChannel

                Ret

EndP            SetAWEVolume

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            StopAWENote

                Mov     AX, DCYSUSV
                Mov     BX, 80h
                Call    WriteDataChannel

                Mov     AX, VTFT
                Mov     EBX, 0FFFFh
                Call    WriteDataChannel

                Mov     AX, CVCF
                Call    WriteDataChannel

                Mov     BX, 80h
                Mov     AX, DCYSUSV
                Call    WriteDataChannel

                Mov     AX, VTFT
                Mov     EBX, 0FFFFh
                Call    WriteDataChannel

                Mov     AX, CVCF
                Call    WriteDataChannel

                Xor     EBX, EBX
                Mov     AX, ENVVOL
                Call    WriteDataChannel

                Mov     AX, ENVVAL
                Call    WriteDataChannel

                Mov     AX, SUSDCY
                Call    WriteDataChannel

                Mov     AX, ATKHLDV
                Call    WriteDataChannel

                Mov     AX, LFO1VAL
                Call    WriteDataChannel

                Mov     AX, HLDATK
                Call    WriteDataChannel

                Mov     AX, LFO2VAL
                Call    WriteDataChannel

                Mov     AX, IP
                Call    WriteDataChannel

                Mov     AX, IFATN
                Call    ReadDataChannel
                Mov     BH, AH
                Mov     AX, IFATN
                Call    WriteDataChannel

                Xor     EBX, EBX
                Mov     AX, PEFE
                Call    WriteDataChannel

                Mov     AX, FMMOD
                Call    WriteDataChannel

                Mov     AX, TREMFRQ
                Call    WriteDataChannel

                Mov     AX, FM2FRQ2
                Call    WriteDataChannel

                Mov     AX, PTRX
                Call    WriteDataChannel

                Mov     AX, VTFT
                Call    WriteDataChannel

;                Mov     AX, PSST
;                Call    WriteDataChannel

                Mov     BL, 8
                Mov     AX, CSL
                Call    WriteDataChannel

                Mov     AX, CCCA
                Call    ReadDataChannel
                Mov     EBX, EAX
                Mov     AX, CCCA
                And     EBX, 0F0000000h
                Call    WriteDataChannel

                Xor     EBX, EBX
                Mov     AX, CPF
                Call    WriteDataChannel

                Ret

EndP            StopAWENote

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SetAWERegisters         ; DS:SI = channel info table
                                        ; CX = number of channels...

                Push    CX
                Push    SI

                                        ; Stage 1.
                                        ;  Turn off any channel which has
                                        ;  a new note to play
                                        ;  If no new note to play and channel
                                        ;  is on, then get current position

                Xor     DX, DX          ; DX = oscillator number

GetAWERegisters1:
                Mov     BX, [SI]
                Test    BH, 2           ; Note cut command
                JZ      GetAWERegisters2

                Mov     BX, 200h
                Mov     [SI], BX

                Call    StopAWENote
                Jmp     GetAWERegisters4

GetAWERegisters2:
                Test    BL, 1           ; Channel on?
                JZ      GetAWERegisters4

                Test    BH, 1           ; New note?
                JZ      GetAWERegisters3

                                        ; Fade out volume
;                Mov     AX, DCYSUSV
;                Mov     BX, 807Fh
;                Call    WriteDataChannel

                Call    StopAWENote

                Jmp     GetAWERegisters4

GetAWERegisters3:                       ; Get offset
                Mov     AX, CCCA
                Call    ReadDataChannel

                Xor     BX, BX
                And     EAX, 00000000111111111111111111111111b
                Inc     EAX             ; Interpolator correction
                                        ; EAX = address in sound memory
                Mov     BL, [SI+36h]    ; BL = sample number
                LEA     BX, [EBX*4+EBX]
                ShL     BX, 2
                Add     BX, Offset AWEDataTable

                Cmp     Byte Ptr [SI+0Ah], 8
                JB      GetAddressNoLoop
                JE      GetAddressForwardsLoop

GetAddressPingPongLoop:
                Cmp     EAX, [CS:BX+16]
                JB      SetOldAddress

                Neg     EAX
                Add     EAX, [CS:BX+8]
                Jmp     SetOldAddress1

GetAddressNoLoop:
                Cmp     EAX, [CS:BX+4]  ; Start loop
                JB      SetOldAddress

                Call    StopAWENote

                                        ; OK.. gotta turn off channel
                Mov     Word Ptr [SI], 0
                Test    Byte Ptr [SI+3Ah], 80h
                JNZ     GetAWERegisters4

                Mov     BX, [SI+38h]
                And     Byte Ptr [BX], Not 4    ; Signify channel off

                Jmp     GetAWERegisters4

GetAddressForwardsLoop:
SetOldAddress:
                Sub     EAX, [CS:BX]    ; EAX = address in sample
                JNS     SetOldAddress1

                Xor     EAX, EAX

SetOldAddress1:
                Push    CX
                Mov     CL, Compress
                ShL     EAX, CL
                Pop     CX

                XChg    [SI+4Ch], EAX
                Mov     [SI+2Ch], EAX

GetAWERegisters4:
                Add     SI, 128

                Inc     DX
                Dec     CX
                JNZ     GetAWERegisters1

                Pop     SI
                Pop     CX

                Xor     DX, DX          ; DX = oscillator number

SetAWERegisters1:
        ; Stage 2.
        ; If new frequency, play new frequency
        ; If new volume, play new volume
        ; If new pan, play new pan
        ; If new note, set ENVVOL, ENVVAL, SUSDCY, ATKHLDV, LFO1VAL, HLDATK
        ;                  LFO2VAL, IP, IFATN, PEFE, FMMOD, TREMFRQ, FM2FRQ2
        ;                  PSST, CSL, CCCA
        ;                  VTFT, CVCF, DCYSUSV, PTRX, CPF

                Push    CX
                Mov     CX, [SI]
                Test    CL, 1                   ; Channel on?
                JZ      SetAWERegistersEnd

                Test    CH, 1                   ; New note?
                JZ      SetAWERegisters2

                Xor     BX, BX
                Mov     BL, [SI+36h]
                LEA     DI, [EBX*4+EBX]
                ShL     DI, 2
                Add     DI, Offset AWEDataTable

                Mov     AX, DCYSUSV
                Mov     BX, 80h
                Call    WriteDataChannel

                Mov     AX, VTFT
                Xor     EBX, EBX
                Call    WriteDataChannel

                Mov     AX, CVCF
                Call    WriteDataChannel

                Cmp     DWord Ptr [CS:DI], 0FFFFFFFFh
                JE      SetAWERegistersError

                Mov     AX, PTRX
                Call    WriteDataChannel

                Mov     AX, CPF
                Call    WriteDataChannel


                Mov     AX, ENVVOL
                Mov     BX, 8000h
                Call    WriteDataChannel

                Mov     AX, ENVVAL
                Mov     BX, 8000h
                Call    WriteDataChannel

                Mov     AX, SUSDCY
                Mov     BX, 7F7Fh
                Call    WriteDataChannel

                Mov     AX, ATKHLDV
                Call    WriteDataChannel

                Mov     AX, LFO1VAL
                Mov     BX, 8000h
                Call    WriteDataChannel

                Mov     AX, HLDATK
                Mov     BX, 7F7Fh
                Call    WriteDataChannel

                Mov     AX, LFO2VAL
                Mov     BX, 8000h
                Call    WriteDataChannel

                Call    SetAWEFrequency
                Call    SetAWEVolume

                Mov     AX, PEFE
                Xor     BX, BX
                Call    WriteDataChannel

                Mov     AX, FMMOD
                Call    WriteDataChannel

                Mov     AX, TREMFRQ
                Mov     BX, 10h
                Call    WriteDataChannel

                Mov     AX, FM2FRQ2
                Call    WriteDataChannel


                Mov     EBX, [CS:DI+4]
                Dec     EBX                     ; Interpolator offset
                Mov     AX, PSST
                Call    WriteDataChannel

                Call    SetAWEPan

                Mov     AL, [CS:VolumeTable+6]  ; Chorus
                ShL     EAX, 24
                Mov     EBX, [CS:DI+8]
                Dec     EBX                     ; Interpolator offset
                Or      EBX, EAX
                Mov     AX, CSL
                Call    WriteDataChannel

                Mov     AL, [SI+3Fh]
                ShL     EAX, 28

                Push    CX
                Mov     CL, Compress
                Mov     EBX, [SI+4Ch]
                ShR     EBX, CL
                Pop     CX
                Add     EBX, [CS:DI]
                Dec     EBX                     ; Interpolator offset
                Or      EBX, EAX

                Mov     AX, CCCA                ; Current address.
                Call    WriteDataChannel


                Mov     AX, VTFT
                Mov     EBX, 0FFFFh
                Call    WriteDataChannel

                Mov     AX, CVCF
                Call    WriteDataChannel

                Mov     AX, DCYSUSV
                Mov     BX, 7F7Fh
                Call    WriteDataChannel

                Mov     AX, PTRX
                Mov     EBX, 40000000h          ; 25% reverb
                Or      BH, [CS:VolumeTable+7]
                Call    WriteDataChannel

                Mov     AX, CPF
                Call    WriteDataChannel
                Jmp     SetAWERegistersEnd

SetAWERegisters2:
                Test    CL, 32                  ; Frequency change?
                JZ      SetAWERegisters3

                Call    SetAWEFrequency

SetAWERegisters3:
                Test    CL, 64                  ; Volume change?
                JZ      SetAWERegisters4

                Call    SetAWEVolume

SetAWERegisters4:
                Test    CH, 80h                 ; New pan?
                JZ      SetAWERegistersEnd

                Call    SetAWEPan

SetAWERegistersEnd:
                Pop     CX
                And     Word Ptr [SI], 0111100010011111b

                Add     SI, 128

                Inc     DX
                Dec     CX
                JNZ     SetAWERegisters1

                Ret

SetAWERegistersError:
                Call    StopAWENote

                Mov     Word Ptr [SI], 0
                Test    Byte Ptr [SI+3Ah], 80h
                JNZ     SetAWERegistersEnd

                Mov     BX, [SI+38h]
                And     Byte Ptr [BX], Not 4    ; Signify channel off

                Jmp     SetAWERegistersEnd

EndP            SetAWERegisters

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            ACKIRQ

                Mov     AL, 20h
                Cmp     CS:IRQ, 7
                JBE     ACKIRQ1

                Out     0A0h, AL

ACKIRQ1:
                Out     20h, AL
                Ret

EndP            ACKIRQ

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

CheckMIDIAgain:
                In      AL, DX

                Test    AL, AL
                JS      CheckMIDIAgain

                Dec     DX
                In      AL, DX

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

Proc            MIDIIRQHandler

                Push    AX BX DX

                Mov     DX, CS:MixerPort
                Mov     AL, 82h
                Out     DX, AL
                Inc     DL
                In      AL, DX

                Test    AL, 4
                JZ      MIDIIRQHandlerEnd

                Call    CheckMIDI

MIDIIRQHandlerEnd:
                Call    AckIRQ

                Pop     DX BX AX
                IRet


EndP            MIDIIRQHandler

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SBIRQHandler

                PushAD
                Push    DS
                Push    ES

                StI

                Push    CS
                Pop     DS
                        Assume DS:Driver

                FNSave  [FPSave]

SBIRQHandlerAgain:
                Mov     DX, MixerPort
                Mov     AL, 82h
                Out     DX, AL
                Inc     DL
                In      AL, DX

                Test    AL, 4
                JZ      NoMIDIIRQ

                Push    AX
                Call    CheckMIDI
                Pop     AX

NoMIDIIRQ:
;                Test    AL, 2
;                JZ      No16BitIRQ
;
;                Push    AX
;                Mov     DX, MixerPort
;                Add     DL, 0Fh-4
;                In      AL, DX
;                Pop     AX
;
; No16BitIRQ:
                Test    AL, 1
                JNZ     SB8BitIRQ

SBNo8BitIRQ:
                Call    AckIRQ
                Jmp     SBEndIRQ

SB8BitIRQ:
                Mov     DX, MixerPort
                Add     DL, 0Eh-4
                In      AL, DX          ; 8-bit IRQ ack.


;                Add     DL, 0Ch-0Eh

;                Mov     AL, 80h         ; Output block of silence
;                Call    SBOut
;                Mov     AX, BlockLength2
;                Call    SBOut
;                Mov     AL, AH
;                Call    SBOut

                ClD
                Call    ACKIRQ

                Inc     IRQFlag
                JNZ     SBEndIRQ

                Call    SaveEMSPageFrame
                        Assume DS:Nothing

SB8BitIRQAgain:
                Call    Update          ; Returns DS:SI, CX

                Mov     BX, BlockLength
                Cmp     BX, BlockLength2
                JE      SBIRQHandler2
                Mov     BlockLength2, BX

                Mov     DX, SB16BasePort
                Add     DL, 0Ch

                MOv     AL, 0DAh
                Call    SBOut
                Mov     AL, 0C6h
                Call    SBOut
                Xor     AL, AL
                Call    SBOut
                Mov     AL, BL
                Call    SBOut
                Mov     AL, BH
                Call    SBOut

;                Mov     AL, 0D0h
;                Call    SBOut

;                Mov     AL, 80h         ; Output block of silence
;                Call    SBOut
;                Mov     AL, BL
;                Call    SBOut
;                Mov     AL, BH
;                Call    SBOut

SBIRQHandler2:
                Call    SetAWERegisters
                Sub     CS:IRQFlag, 1
                JNC     SB8BitIRQAgain

                Call    RestoreEMSPageFrame

SBEndIRQ:
                FRstor  [CS:FPSave]

                Pop     ES
                Pop     DS
                PopAD

                IRet

EndP            SBIRQHandler
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            AWEIRQHandler                   ; IRQ Handler has to
                                                ; 1) Update AWE registers
                                                ; 2) Update song position
                Push    AX
                Push    DS

                Mov     AX, AWEUpdateTimer
                Add     AWEUpdateCount, AX
                JC      AWEIRQHandler1

                Mov     AL, 20h
                Out     20h, AL
                Jmp     AWEIRQHandler2

AWEIRQHandler1:
                PushF
                Call    [OldIRQHandler]

AWEIRQHandler2:
                Xor     AWEUpdateFlag, 1
                JZ      AWEIRQHandlerEnd

                FNSave  [CS:FPSave]

                PushAD
                Push    ES

                ClD

                Call    SaveEMSPageFrame
                Call    Update          ; Returns DS:SI, CX
                Call    SetAWERegisters
                Call    RestoreEMSPageFrame

                Pop     ES
                PopAD

                FRstor  [CS:FPSave]

AWEIRQHandlerEnd:
                Pop     DS
                Pop     AX
                IRet

EndP            AWEIRQHandler

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            EnableRAM

                Mov     DX, BasePort
                Mov     CX, 29

EnableRAM1:
                Mov     AX, DCYSUSV
                Or      AX, CX
                Mov     BX, 80h
                Call    WriteData

                Mov     AX, VTFT
                Or      AX, CX
                Xor     EBX, EBX
                Call    WriteData

                Mov     AX, CVCF
                Or      AX, CX
                Xor     EBX, EBX
                Call    WriteData

                Mov     AX, PTRX
                Or      AX, CX
                Mov     EBX, 40000000h
                Call    WriteData

                Mov     AX, CPF
                Or      AX, CX
                Mov     EBX, 40000000h
                Call    WriteData

                Mov     AX, PSST
                Or      AX, CX
                Xor     EBX, EBX
                Call    WriteData

                Mov     AX, CSL
                Or      AX, CX
                Xor     EBX, EBX
                Call    WriteData

                Mov     AX, CCCA
                Or      AX, CX
                Mov     EBX, 6000000h   ; Left write
                Call    WriteData

                Dec     CX
                JNS     EnableRAM1

                Ret

EndP            EnableRAM

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            TestAWE                 ; Given DX = baseport.

                Push    DX

                Add     DX, 802h
                In      AL, DX
                In      AL, DX
                Not     AL
                Mov     BL, AL
                Out     DX, AL
                In      AL, DX
                Cmp     AL, BL
                JNE     TestAWE1                ; Register changed

                In      AX, DX                  ; Is upper part of pointer
                Mov     BX, AX                  ;  changing?
                Mov     CX, 128

TestAWE2:
                In      AX, DX
                Cmp     AL, BL
                JNE     TestAWE1
                Cmp     AH, BH
                JNE     TestAWE3

                Dec     CX
                JNZ     TestAWE2
                Jmp     TestAWE1

TestAWE3:
                Pop     DX

                ClC
                Ret

TestAWE1:
                Pop     DX
                StC
                Ret

EndP            TestAWE

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            InitSetAWE

                Mov     CX, 31

InitSetAWE1:
                Mov     AX, 31
                Sub     AX, CX
                Mov     BX, [SI]
                Or      AX, INIT1
                Call    WriteData

                Add     SI, 2

                Dec     CX
                JNS     InitSetAWE1

                Mov     CX, 31

InitSetAWE2:
                Mov     AX, 31
                Sub     AX, CX
                Mov     BX, [SI]
                Or      AX, INIT2
                Call    WriteData

                Add     SI, 2

                Dec     CX
                JNS     InitSetAWE2

                Mov     CX, 31

InitSetAWE3:
                Mov     AX, 31
                Sub     AX, CX
                Mov     BX, [SI]
                Or      AX, INIT3
                Call    WriteData

                Add     SI, 2

                Dec     CX
                JNS     InitSetAWE3

                Mov     CX, 31

InitSetAWE4:
                Mov     AX, 31
                Sub     AX, CX
                Mov     BX, [SI]
                Or      AX, INIT4
                Call    WriteData

                Add     SI, 2

                Dec     CX
                JNS     InitSetAWE4

                Ret

EndP            InitSetAWE

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            InitAWE

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     DX, BasePort

                Mov     AX, HWCF1
                Mov     BX, 59h
                Call    WriteData

                Mov     AX, CFG2
                Mov     BX, 20h
                Call    WriteData

                Mov     CX, 31

InitAwe1:
                Mov     BX, 80h
                Mov     AX, DCYSUSV
                Or      AX, CX
                Call    WriteData

                Xor     EBX, EBX
                Mov     AX, ENVVOL
                Or      AX, CX
                Call    WriteData

                Mov     AX, ENVVAL
                Or      AX, CX
                Call    WriteData

                Mov     AX, SUSDCY
                Or      AX, CX
                Call    WriteData

                Mov     AX, ATKHLDV
                Or      AX, CX
                Call    WriteData

                Mov     AX, LFO1VAL
                Or      AX, CX
                Call    WriteData

                Mov     AX, HLDATK
                Or      AX, CX
                Call    WriteData

                Mov     AX, LFO2VAL
                Or      AX, CX
                Call    WriteData

                Mov     AX, IP
                Or      AX, CX
                Call    WriteData

                Mov     AX, IFATN
                Or      AX, CX
                Call    WriteData

                Mov     AX, PEFE
                Or      AX, CX
                Call    WriteData

                Mov     AX, FMMOD
                Or      AX, CX
                Call    WriteData

                Mov     AX, TREMFRQ
                Or      AX, CX
                Call    WriteData

                Mov     AX, FM2FRQ2
                Or      AX, CX
                Call    WriteData

                Mov     AX, PTRX
                Or      AX, CX
                Call    WriteData

                Mov     AX, VTFT
                Or      AX, CX
                Call    WriteData

                Mov     AX, PSST
                Or      AX, CX
                Call    WriteData

                Mov     AX, CSL
                Or      AX, CX
                Call    WriteData

                Mov     AX, CCCA
                Or      AX, CX
                Call    WriteData

                Dec     CX
                JNS     InitAWE1

                Mov     CX, 31

InitAWE8:
                Mov     AX, CPF
                Or      AX, CX
                Call    WriteData

                Mov     AX, CVCF
                Or      AX, CX
                Call    WriteData

                Dec     CX
                JNS     InitAWE8
                                        ; Initialise still...
                Mov     AX, SMALR
                Call    WriteData

                Mov     AX, SMARR
                Call    WriteData

                Mov     AX, SMALW
                Call    WriteData

                Mov     AX, SMARW
                Call    WriteData

                Mov     SI, Offset InitTable1
                Call    InitSetAWE

                                        ;  Wait for 1024 sample periods
                Mov     AX, WC
                Call    ReadData

                Mov     BX, AX
                Mov     CX, AX
                Add     CX, 400h        ; 1024
                Cmp     BX, CX
                JB      InitAWE3

InitAWE4:
                Mov     AX, WC
                Call    ReadData
                Cmp     AX, CX
                JA      InitAWE4

InitAWE3:
                Mov     AX, WC
                Call    ReadData
                Cmp     AX, CX
                JB      InitAWE3

                Mov     SI, Offset InitTable2
                Call    InitSetAWE

                Mov     SI, Offset InitTable3
                Call    InitSetAWE

                Mov     AX, HWCF4
                Xor     EBX, EBX
                Call    WriteData

                Mov     AX, HWCF5
                Mov     EBX, 83h
                Call    WriteData

                Mov     AX, HWCF6
                Mov     EBX, 8000h
                Call    WriteData

                Mov     SI, Offset InitTable4
                Call    InitSetAWE

                Mov     AX, HWCF3
                Mov     BX, 4
                Call    WriteData

                Ret

EndP            InitAWE
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            InitDRAMRefresh

                Mov     AX, DCYSUSV+1Eh
                Mov     BX, 80h
                Call    WriteData

                Mov     AX, DCYSUSV+1Fh
                Call    WriteData

;

                Mov     AX, VTFT+1Eh
                Xor     EBX, EBX
                Call    WriteData

                Mov     AX, CVCF+1Eh
                Call    WriteData

                Mov     AX, VTFT+1Fh
                Call    WriteData

                Mov     AX, CVCF+1Fh
                Call    WriteData

;

                Mov     AX, PTRX+1Eh
                Call    WriteData

                Mov     AX, CPF+1Eh
                Call    WriteData

                Mov     AX, PTRX+1Fh
                Call    WriteData

                Mov     AX, CPF+1Fh
                Call    WriteData

;

                Mov     AX, PSST+1Eh
                Call    WriteData
                Mov     AX, PSST+1Fh
                Call    WriteData

                Mov     BX, 0FFFFh
                Mov     AX, CSL+1Eh
                Call    WriteData
                Mov     AX, CSL+1Fh
                Call    WriteData

                Xor     BX, BX
                Mov     AX, CCCA+1Eh
                Call    WriteData
                Mov     AX, CCCA+1Fh
                Call    WriteData

                Ret

EndP            InitDRAMRefresh
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

Proc            SBGetRegister

                Out     DX, AL
                Inc     DX
                In      AL, DX
                Dec     DX

                Ret

EndP            SBGetRegister

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SBIn            ; DX = 2xEh, returns AL

SBIn1:
                In      AL, DX

                ShR     AL, 7
                LoopZ   SBIn

;                Test    AL, AL
;                JNS     SBIn1

                Add     DL, 0Ah-0Eh     ; DX = 2xAh -> Data read port
                In      AL, DX
                Add     DL, 0Eh-0Ah

                Ret

EndP            SBIn

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

                Mov     DX, BasePort
                Cmp     DX, 0FFFFh
                JE      DetectCard1

                Cmp     DX, 620h
                JB      DetectCard3
                Cmp     DX, 680h
                JA      DetectCard3

                Call    TestAWE
                JNC     DetectCardFound
                Ret

DetectCard1:
                Mov     DX, 620h

DetectCard2:
                Call    TestAWE
                JNC     DetectCardFound

                Add     DL, 20h
                Cmp     DL, 80h
                JBE     DetectCard2

DetectCard3:
                StC
                Ret

DetectCardFound:
                Mov     BasePort, DX

                                ; Initialise AWE 32
                Call    InitAWE
                Call    InitDRAMRefresh

                                ; Detect amount of RAM.

                Mov     DX, BasePort
                Mov     CX, 29

DetectCardMemory1:
                Mov     AX, DCYSUSV
                Or      AX, CX
                Mov     BX, 80h
                Call    WriteData

                Mov     AX, VTFT
                Or      AX, CX
                Xor     EBX, EBX
                Call    WriteData

                Mov     AX, CVCF
                Or      AX, CX
                Xor     EBX, EBX
                Call    WriteData

                Mov     AX, PTRX
                Or      AX, CX
                Mov     EBX, 40000000h
                Call    WriteData

                Mov     AX, CPF
                Or      AX, CX
                Mov     EBX, 40000000h
                Call    WriteData

                Mov     AX, PSST
                Or      AX, CX
                Xor     EBX, EBX
                Call    WriteData

                Mov     AX, CSL
                Or      AX, CX
                Xor     EBX, EBX
                Call    WriteData

                Mov     AX, CCCA
                Or      AX, CX
                Mov     EBX, 4000000h   ; Left read

                Test    CL, 2
                JZ      DetectCardMemory2

                Mov     EBX, 6000000h   ; Left write

DetectCardMemory2:
                Call    WriteData

                Dec     CX
                JNS     DetectCardMemory1

                Xor     EDI, EDI                ; Amount of memory stored in
                                                ; EDI

                Mov     AX, SMALW
                Mov     EBX, 200000h
                Call    WriteData

                Mov     AX, SMLD
                Mov     BX, 0FFFFh
                Call    WriteData

                Mov     AX, SMLD
                Mov     BX, 5555h
                Call    WriteData

                Mov     AX, SMLD
                Mov     BX, 0AAAAh
                Call    WriteData

                Mov     AX, SMALR
                Mov     EBX, 200000h
                Call    WriteData

                Mov     AX, SMLD
                Call    ReadData

                Mov     AX, SMLD
                Call    ReadData
                Cmp     AX, 0FFFFh
                JNE     DetectCardMemory6

                Mov     AX, SMLD
                Call    ReadData
                Cmp     AX, 5555h
                JNE     DetectCardMemory6

                Mov     AX, SMLD
                Call    ReadData
                Cmp     AX, 0AAAAh
                JNE     DetectCardMemory6

                Mov     EDI, 20000h

DetectCardMemory3:                      ; Set read/write addresses..
                Mov     AX, SMALW
                Mov     EBX, EDI
                Add     EBX, 200000h
                Call    WriteData

                Mov     AX, SMLD
                Mov     BX, 5555h
                Call    WriteData

                Mov     AX, SMLD
                Mov     BX, 0AAAAh
                Call    WriteData

                Mov     AX, SMALR
                Mov     EBX, 200000h
                Call    WriteData

                Mov     AX, SMLD
                Call    ReadData

                Mov     AX, SMLD
                Call    ReadData
                Cmp     AX, 0FFFFh
                JNE     DetectCardMemory5

                Mov     AX, SMALR
                Mov     EBX, EDI
                Add     EBX, 200000h
                Call    WriteData

                Mov     AX, SMLD
                Call    ReadData

                Mov     AX, SMLD
                Call    ReadData
                Cmp     AX, 5555h
                JNE     DetectCardMemory5

                Mov     AX, SMLD
                Call    ReadData
                Cmp     AX, 0AAAAh
                JNE     DetectCardMemory5

DetectCardMemory4:
                Add     EDI, 20000h
                Cmp     EDI, 0E00000h
                JB      DetectCardMemory3

DetectCardMemory5:
                Cmp     EDI, 0DFFFE0h
                JB      DetectCardMemory7

                Mov     EDI, 0DFFFE0h

DetectCardMemory7:
                Test    EDI, EDI
                JZ      DetectCardMemory6

                Mov     AWEMemory, EDI

                Mov     MixerPort, 210h
                Mov     AX, BasePort
                Sub     AX, 400h
                Call    ResetDSP
                JNC     DetectMixer2

DetectMixer1:
                Mov     AX, MixerPort
                Call    ResetDSP
                JNC     DetectMixer2

DetectMixer3:
                Add     MixerPort, 10h
                Cmp     MixerPort, 280h
                JBE     DetectMixer1

                Mov     DX, BasePort
                Sub     DX, 400h
                Mov     MixerPort, DX

                Jmp     DetectCard4

DetectMixer2:                            ; OK... DSP found.
                                        ; Get DSP version
                Mov     DX, AX
                Add     DL, 0Ch         ; 2xCh -> Data ready to send...

                Mov     CX, 200

DetectMixerLoop1:
                In      AL, DX
;                Test    AL, AL
;                JS      DetectMixerLoop1
                ShR     AL, 7
                LoopNZ  DetectMixerLoop1

                Mov     AL, 0E1h        ; Get DSP version command
                Out     DX, AL

                Add     DL, 0Eh-0Ch     ; DX = 2xEh -> Data available status

                Call    SBIn
                Mov     AH, AL          ; AH = Major version number
                Call    SBIn            ; AL = Minor version number

                Cmp     AX, 40Ch        ; SB DSP = 4.12+
                JB      DetectMixer3

                Sub     DL, 0Eh
                Mov     MixerPort, DX

DetectCard4:
                Mov     SB16BasePort, DX
                Add     MixerPort, 4    ; Mixerport

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

                Mov     DX, MixerPort
                Mov     AX, 0F834h
                Out     DX, AX

                Mov     AL, 35h
                Out     DX, AX

                Mov     DX, MixerPort
                Mov     AL, 80h         ; IRQ select
                Out     DX, AL
                Inc     DL              ; 2x5h = Mixer data port

                In      AL, DX

                Dec     DL

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

                Jmp     NoWindows

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

DetectCard6:
                Mov     AL, 81h
                Out     DX, AL
                Inc     DX
                In      AL, DX
                Dec     DX

                And     AL, 11
                Xor     BX, BX
                Cmp     AL, 1
                JE      DetectCardDMA

                Inc     BX
                Cmp     AL, 2
                JE      DetectCardDMA

                Inc     BX
                Inc     BX
                Cmp     AL, 8
                JNE     NoWindows

DetectCardDMA:
                Mov     DMA, BX

DetectCardWindows:
                Mov     AX, 1600h               ; Windows detection.
                Int     2Fh
                Test    AL, 7Fh
                JZ      NoWindows

                Mov     SBIRQMode, 1

NoWindows:
                Mov     EAX, 'Jeff'
                ClC
                Ret

DetectCardMemory6:
                StC
                Ret

EndP            DetectCard
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetSamplingRate
                Assume DS:Driver

                PushA
                Push    ES

                Mov     AX, SB16BasePort
                Call    ResetDSP

; Set dma
                Mov     BX, DMABuffer
                Xor     AX, AX
                Mov     DX, DMA
                Mov     DI, 512
                Call    SetDMA

                LES     DI, ActualDMAPtr
                Xor     AX, AX
                Mov     CX, 256
                Rep     StosW

                Mov     DX, SB16BasePort
                Add     DL, 0Ch

;                Mov     AL, 0D3h        ; Turn off speaker
;                Call    SBOut
                                         ; Set mixing frequency
                Mov     AL, 40h
                Call    SBOut
                Mov     AL, 0EAh
                Call    SBOut            ; 45454Hz
;                Mov     AL, 211
;                Call    SBOut           ; 22222 Hz.

                Mov     AL, 0C6h
                Call    SBOut
                Xor     AL, AL
                Call    SBOut
                Mov     AX, BlockLength
                Dec     AX
                Call    SBOut
                Mov     AL, AH
                Call    SBOut

                Pop     ES
                PopA
                Ret

EndP            SetSamplingRate
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SetMIDIIRQ

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
                Mov     AX, Offset MIDIIRQHandler

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

EndP            SetMIDIIRQ

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SetIRQ
                        Assume DS:Driver

                PushAD
                Push    ES

                Xor     AX, AX
                Mov     ES, AX

                Mov     DI, IRQ
                ShL     DI, 2
                Add     DI, Offset IRQData
                Mov     BX, [DI]

                Mov     AX, CS
                ShL     EAX, 16
                Mov     AX, Offset SBIRQHandler

                XChg    [ES:BX], EAX
                Mov     OldIRQHandler, EAX

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

                Mov     AX, IMR
                Out     21h, AL
                Mov     AL, AH
                Out     0A1h, AL

                Pop     ES
                Pop     DS
                PopAD

                Ret

EndP            ResetIRQ
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            InitMIDI
                Assume DS:Driver

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
                Ret

EndP            InitMIDI
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

FControlWord    DW      0

Proc            InitSound Far

                Push    CS
                Pop     DS
                        Assume DS:Driver

                FNInit                          ; Initialise floating point
                FNSTCW  FControlWord
                And     FControlWord, 0F0FFh
                FLDCW   FControlWord

                Mov     ECX, IdleUpdateInfoLine
                Mov     EDX, GlobalKeyList
                Mov     IdleFunctionList, ECX
                Mov     GlobalKeyLink2, EDX

                Mov     ECX, FillHeaderFunction
                Mov     EDX, DrawHeaderFunction
                Mov     FillHeader2, ECX
                Mov     ScreenHeader2, EDX

                Mov     AX, CS
                Mov     DriverSegment1, AX
                Mov     DriverSegment2, AX
                Mov     DriverSegment3, AX
                Mov     DriverSegment4, AX
                Mov     DriverSegment5, AX
                Mov     DriverSegment6, AX
                Mov     DriverSegment7, AX
                Mov     DriverSegment8, AX

                In      AL, 0A1h
                Mov     AH, AL
                In      AL, 21h
                Mov     IMR, AX

                Cmp     SBIRQMode, 0
                JE      InitSound1

                Cmp     DMABuffer, 0
                JNE     InitSound3

                Mov     AH, 48h
                Mov     BX, 1024/16
                Int     21h
                JNC     InitSound4

                Mov     SBIRQMode, 0
                Jmp     InitSound1

InitSound4:
                Mov     DMABuffer, AX

InitSound3:
                Call    SetIRQ
                Call    GetTempo
                Call    SetTempo
                Call    ResetMemory
                Call    SetSamplingRate

                Call    InitMIDI

                Mov     SI, Offset AWE32Msg2
                Mov     AX, BasePort

                Mov     BX, IRQ
                Mov     CX, DMA

                Ret

InitSound1:
                Call    SetMIDIIRQ
                Call    GetTempo
                Call    SetTempo
                Call    ResetMemory

                Xor     AX, AX
                Mov     ES, AX          ; ES = 0

                Mov     AX, CS
                ShL     EAX, 16
                Mov     AX, Offset AWEIRQHandler

                ClI

                XChg    DWord Ptr [ES:20h], EAX         ; Clock tick
                Mov     OldIRQHandler, EAX

                StI

InitSound2:
                Call    InitMIDI

                Mov     SI, Offset AWE32Msg
                Mov     AX, BasePort

                Mov     EBX, AWEMemory
                SHR     EBX, 9

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

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     SI, Offset AWE32ReinitMsg
                Mov     BX, 40
                Call    SetInfoLine

                Call    ResetUART
                Call    InitAWE
                Call    InitDRAMRefresh

                Cmp     SBIRQMode, 0
                JE      ReInitSound1

                Call    ResetIRQ
                Call    SetIRQ
                Call    SetSamplingRate
                Call    ReinitUART
                Ret

ReInitSound1:
                Xor     AX, AX
                Mov     ES, AX          ; ES = 0

                Mov     AX, CS
                ShL     EAX, 16
                Mov     AX, Offset AWEIRQHandler

                Mov     DWord Ptr [ES:20h], EAX         ; Clock tick

                Call    ResetIRQ
                Call    SetMIDIIRQ
                Call    ReinitUART

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

                                        ; Now to save config into driver file.
                Push    CS
                Pop     DS
                        Assume DS:Driver

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
                Mov     DX, Offset Chorus
                Int     21h

SaveConfig1:
                PushF
                Mov     AH, 3Eh
                Int     21h
                PopF

SaveConfig2:
                Call    ResetIRQ

                Cmp     SBIRQMode, 0
                JE      UnInitSound1

                Mov     DX, SB16BasePort
                Add     DL, 0Ch

                Call    ResetUART

                Mov     AX, SB16BasePort
                Call    ResetDSP

                Call    InitAWE

                Push    ES
                Mov     AH, 49h
                Mov     ES, DMABuffer
                Int     21h
                Pop     ES

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

                Mov     AX, SB16BasePort
                Call    ResetDSP
                Call    ResetUART
                Call    InitAWE
                Call    ResetIRQ
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

                Cmp     CS:SBIRQMode, 0
                JE      SetTempo1
                                        ; BlockLength = 55555/BPM
                                        ; BlockLength = 45454*5/2
                                        ;             = 113635
                Mov     AX, 48099
                Mov     DX, 1

                Div     BX
                Dec     AX
                Dec     AX
                Mov     CS:BlockLength, AX

;                Mov     DX, SB16BasePort
;                Add     DL, 0Ch

                Jmp     SetTempo2

SetTempo1:
                                        ; Frames per second = 2 * (0.4*Tempo)
                Mov     AX, 0C214h
                Mov     DX, 16h         ; Ticks = (1193181/(2*0.4))/Tempo
                Div     BX

                                        ; AX contains counter.
                Mov     CS:AWEUpdateTimer, AX

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
; Returns: **Carry set if NO error**
;          **Carry clear if error**
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            LoadSample Far
                                        ; if no sample, then do nothing
                                        ; MemoryUsed = length of sample
                                        ; if sustain loop, then use sustain
                                        ;  loop information
                                        ; if no sustain loop, then use loop
                                        ;  information
                                        ; if no loop or sustain loop,
                                        ;  memoryused += 16; (16 zero samples
                                        ;                     at the end)
                                        ;
                PushAD
                Push    DS
                Push    ES
                Push    FS

                Push    AX

                ClI

                Call    EnableRAM       ; Enable access to DRAM.

                                        ; Set destination address
                Mov     AX, SMALW
                Mov     EBX, CS:AWEMemoryUsed
                Add     EBX, 200000h
                Call    WriteData

                Mov     DX, CS:BasePort
                Add     DX, 802h        ; Index
                Mov     AX, 32+26
                Out     DX, AX

                Pop     AX

                Mov     FS, CS:SongDataArea
                LEA     DI, [EAX*4+EAX]
                ShL     DI, 2
                Add     DI, Offset AWEDataTable-20

                Mov     ECX, -1

                Mov     DWord Ptr [CS:DI], ECX    ; Start
                Mov     DWord Ptr [CS:DI+4], ECX  ; Loop start
                Mov     DWord Ptr [CS:DI+8], ECX  ; Loop end
                Mov     DWord Ptr [CS:DI+12], ECX ; Size occupied
                Mov     DWord Ptr [CS:DI+16], ECX ; Size occupied

                Mov     BP, AX
                Add     BP, BP
                Mov     BP, [FS:64910+BP]

                Xor     CX, CX                  ; From the start of the sample..
                Call    GetSampleLocation       ; Returns DS:ESI, ECX = length
                JC      LoadSampleNoError

                JZ      LoadSample1

                        ; 16 bit

                Mov     CS:LoadSampleFuncF, Offset Load16BitSamplesForwards
                Mov     CS:LoadSampleFuncB, Offset Load16BitSamplesBackwards

                Jmp     LoadSample2

LoadSample1:            ; 8 bit
                Mov     CS:LoadSampleFuncF, Offset Load8BitSamplesForwards
                Mov     CS:LoadSampleFuncB, Offset Load8BitSamplesBackwards

LoadSample2:
                Mov     AL, [FS:BP+12h]
                Test    AL, 30h                 ; Loop or sustain loop?
                JZ      LoadSampleNoLoop

                Mov     EBX, [FS:BP+34h]        ; Loop begin
                Mov     EDX, [FS:BP+38h]        ; Loop end
                Test    AL, 20h                 ; Sustain loop?
                JZ      LoadSample3

                ShR     AL, 1
                Mov     EBX, [FS:BP+40h]
                Mov     EDX, [FS:BP+44h]
                Jmp     LoadSample3

LoadSampleError:
                ClC
                Jmp     LoadSampleEnd

LoadSampleNoError:
                StC

LoadSampleEnd:
                StI
                Pop     FS
                Pop     ES
                Pop     DS
                PopAD

                Ret

LoadSampleNoLoop:                       ; ECX contains length of sample
                Mov     EAX, ECX
                Mov     EDX, AWEMemoryUsed
                Mov     EBX, AWEMemory
                Sub     EBX, EDX                ; EBX = AWEMemory remaining

                Mov     CL, Compress
                ShR     EAX, CL                 ; Compress sample
                Add     EAX, 16                 ; zeroes at end of sample

                Cmp     EAX, EBX
                JA      LoadSampleError

                Mov     ECX, EAX
                Add     AWEMemoryUsed, EAX      ; Record memory as used
                Mov     [CS:DI+12], EAX

                Add     EDX, 200000h

                Sub     ECX, 16                 ; Number of samples to transfer
                Mov     [CS:DI], EDX
                Add     EDX, ECX
                Mov     [CS:DI+4], EDX             ; Loop start
                Add     EDX, 14
                Mov     [CS:DI+8], EDX             ; Loop end

                                        ; Now to transfer samples to AWE32
                Call    [CS:LoadSampleFuncF]
                                        ; Now to shove a whole lot of zeroes
                Xor     AX, AX
                Mov     CX, 16

LoadSampleNoLoop2:
                Out     DX, AX
                Loop    LoadsampleNoLoop2

                Jmp     LoadSampleNoError

LoadSample3:                            ; OK... EBX = loop start
                                        ;       EDX = loop end
                                        ;        AL&40h = ping pong
                Test    AL, 40h
                JNZ     LoadSamplePingPong

                Mov     CL, Compress

                Push    EBX

                ShR     EDX, CL
                ShR     EBX, CL
                Mov     EAX, EDX
                Add     EAX, 2          ; For loop fixing

                Mov     ECX, AWEMemory
                Sub     ECX, AWEMemoryUsed      ; ECX = AWEMemoryRemaining

                Cmp     EAX, ECX
                Pop     ECX
                JA      LoadSampleError         ; Sufficient memory?
                Push    ECX

                Mov     ECX, EAX
                Mov     EAX, AWEMemoryUsed
                Add     AWEMemoryUsed, ECX
                Mov     [CS:DI+12], ECX

                Sub     ECX, 2

                Add     EAX, 200000h
                Mov     [CS:DI], EAX

                Add     EDX, EAX
                Add     EAX, EBX

                Mov     [CS:DI+4], EAX
                Mov     [CS:DI+8], EDX

                Call    [CS:LoadSampleFuncF]
                                                ; Now to fix loop.. 1 extra
                                                ; sample.

                Pop     ESI                     ; Loop start
                Test    Byte Ptr [FS:BP+12h], 2
                JZ      LoadSampleForwards1

                Add     ESI, ESI

LoadSampleForwards1:
                Int     3

                Mov     ECX, 2
                Call    [CS:LoadSampleFuncF]

                Jmp     LoadSampleNoError

LoadSamplePingPong:
                Mov     CL, Compress
                ShR     EDX, CL
                ShR     EBX, CL

                Mov     EAX, EDX
                Add     EAX, EDX
                Sub     EAX, EBX
                Inc     EAX

                Mov     ECX, AWEMemory
                Sub     ECX, AWEMemoryUsed

                Cmp     EAX, ECX
                JA      LoadSampleError

                Mov     [CS:DI+12], EAX
                Mov     ECX, AWEMemoryUsed
                Add     AWEMemoryUsed, EAX

                Add     ECX, 200000h
                Add     EAX, ECX
                Dec     EAX

                Mov     [CS:DI], ECX
                Add     ECX, EBX
                Mov     [CS:DI+4], ECX
                Mov     [CS:DI+8], EAX

                Mov     EAX, [CS:DI]
                Add     EAX, EDX
                Mov     [CS:DI+16], EAX

                Mov     ECX, EDX
                Sub     EDX, EBX
                Push    EDX

                Call    [CS:LoadSampleFuncF]

                Pop     ECX
                Inc     ECX

                Call    [CS:LoadSampleFuncB]

                Jmp     LoadSampleNoError

EndP            LoadSample

;컴 ReleaseSample 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Parameters: AX = sample to release
;             DS:SI points to sample header
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ReleaseSample Far

                PushAD

                LEA     DI, [EAX*4+EAX]         ; DI = AX * 5
                ShL     DI, 2
                Add     DI, Offset AWEDataTable

                Mov     EBX, [CS:DI+12]
                Mov     EAX, CS:AWEMemoryUsed
                Sub     EAX, EBX
                Add     EAX, 200000h
                Cmp     EAX, [CS:DI]
                JNE     ReleaseSample1

                Sub     AWEMemoryUsed, EBX
ReleaseSample1:
                Mov     EAX, -1
                Mov     [CS:DI], EAX
                Mov     [CS:DI+4], EAX
                Mov     [CS:DI+8], EAX
                Mov     [CS:DI+12], EAX

                PopAD
                Ret

EndP            ReleaseSample

;컴 ResetMemory 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
;  Frees all on-board memory
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            ResetMemory Far

                Push    CS
                Pop     ES

                Xor     EAX, EAX
                Mov     CS:AWEMemoryUsed, EAX

                Mov     DI, Offset AWEDataTable
                Mov     CX, 1000
                Mov     AX, 0FFFFh
                Rep     StosW

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

                Mov     SI, Offset AWE32Status

                Mov     EAX, AWEMemory
                Sub     EAX, AWEMemoryUsed
                SHR     EAX, 9

                ClC
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

                Mov     DX, MixerPort
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

MaxNumberOfChannels     DW      30      ; Maximum number of channels the
                                        ; driver can handle.
StopAfterPlay           DW      0
DefaultChannels         DW      30
DriverFlags             DW      1       ; MIDI Out supported

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

        DW      Offset SendUARTOut      ; For MIDI Out

ProvidedTableEnd:
        DW      32-(ProvidedTableEnd-ProvidedTableStart)/2 Dup (0)

EndS

End
