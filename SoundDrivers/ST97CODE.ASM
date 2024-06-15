;
; ST 97/42 PCI Codec
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
MIXTABLESIZE    EQU     2*256*65
DATAFLAG        EQU     200h
ACKFLAG         EQU     300h

PNPVENDORID     EQU     3746630Eh

DMASize         DW      DMABUFFERLENGTH / 2

WSSMsg          DB      "Sound Track Codec", 13
                DB      "Port ", 0FDh, "Xh, IRQ ", 0FDh, "D, DMA ", 0FDh, "D", 0

WSSNoMemoryMsg  DB      "Sound Track Codec", 13
                DB      "Error: Insufficient memory", 0

ReinitMsg       DB      "Sound Track Codec reinitialised", 0

ConfigErrorMsg  DB      "Error saving configuration to ITSTCODE.DRV", 0
ConfigOKMsg     DB      "Configuration saved to ITSTCODE.DRV", 0

DriverName      DB      "ITSTCODE.DRV", 0

Forced          DB      0
Stereo          DB      0
WSSMixConst     DB      0

ALIGN 2

MixVolume       DW      0

BytesToMix      DW      1000

MixSegment      DW      0
DMASegment      DW      0

MixTransferOffset       DW      0
MixTransferRemaining    DW      0

CONFIGURATIONOFFSET     EQU     $+128
CONFIGSIZE              EQU     37
MixMode                 DW      0
MixModeOffset           DW      0
Filter                  DW      0
VolumeTable             DB      56, 56
                        DB      60h, 60h, 0Ch             ; Low Band
                        DB      40h, 40h, 1Bh             ; Med Low Band
                        DB      40h, 40h, 72h             ; Med High Band
                        DB      60h, 60h, 40h             ; High Band
                        DB      0, 0, 0                   ; Echo
                        DB      0, 2                      ; Surround
                        DB      0, 90h, 4, 7Fh, 22h       ; Reverb
                        DB      0, 90h, 2, 40h, 9, 3, 13h ; Chorus
                        DB      0, 0            ; SRS stuff.

ALIGN 2

IMR                     DW      0
OldWSSIRQHandler        DD      0

SAM9407Reset            DW      66
                        DW      1BEh, 16Fh, 7Fh, 7Fh, ACKFLAG   ; Audio in on
                        DW      1BEh, 168h, 7Fh, 7Fh, ACKFLAG   ; Echo on
                        DW      1BEh, 16Ch, 7Fh, 7Fh, ACKFLAG   ; Reverb on
                        DW      1BEh, 16Dh, 7Fh, 7Fh, ACKFLAG   ; Chorus on
                        DW      1BEh, 16Bh, 0, 0, ACKFLAG       ; Equalizer type
                        DW      1BEh, 16Eh, 7Fh, 7Fh, ACKFLAG   ; Surround on
                        DW      1BEh, 165h, 7Fh, 7Fh            ; Post eff on Audio in
                        DW      1BEh, 166h, 7Fh, 7Fh            ; Post eff on reverb, chorus
                        DW      1BEh, 133h, 0, 0                ; 2 Speaker
                        DW      1BEh, 120h, 7Fh,  7Fh           ; Stereo input 2
                        DW      1BEh, 134h, 0FFh, 0FFh          ; Left gain
                        DW      1BEh, 135h, 0FFh, 0FFh          ; Right gain
                        DW      1BEh, 136h, 0, 0                ; Left pan
                        DW      1BEh, 137h, 7Fh, 7Fh            ; Right pan
                        DW      1BEh, 107h, 0FFh, 0FFh          ; Master volume

SAM9407EqLBL            DW      4
                        DW      1BEh, 110h, DATAFLAG, 60h
SAM9407EqLBR            DW      4
                        DW      1BEh, 114h, DATAFLAG, 60h
SAM9407EqLBF            DW      4
                        DW      1BEh, 118h, DATAFLAG, 0Ch
SAM9407EqMLBL           DW      4
                        DW      1BEh, 111h, DATAFLAG, 40h
SAM9407EqMLBR           DW      4
                        DW      1BEh, 115h, DATAFLAG, 40h
SAM9407EqMLBF           DW      4
                        DW      1BEh, 119h, DATAFLAG, 1Bh
SAM9407EqMHBL           DW      4
                        DW      1BEh, 112h, DATAFLAG, 40h
SAM9407EqMHBR           DW      4
                        DW      1BEh, 116h, DATAFLAG, 40h
SAM9407EqMHBF           DW      4
                        DW      1BEh, 11Ah, DATAFLAG, 72h
SAM9407EqHBL            DW      4
                        DW      1BEh, 113h, DATAFLAG, 60h
SAM9407EqHBR            DW      4
                        DW      1BEh, 117h, DATAFLAG, 60h
SAM9407EqHBF            DW      4
                        DW      1BEh, 11Bh, DATAFLAG, 0Ch
SAM9407EchoLevel        DW      4
                        DW      1BEh, 128h, DATAFLAG, 0
SAM9407EchoTime         DW      4
                        DW      1BEh, 129h, DATAFLAG, 2Bh
SAM9407EchoFeed         DW      4
                        DW      1BEh, 12Ah, DATAFLAG, 40h
SAM9407SurroundVolume   DW      4
                        DW      1BEh, 130h, DATAFLAG, 0
SAM9407SurroundDelay    DW      4
                        DW      1BEh, 131h, DATAFLAG, 2
SAM9407ReverbSend       DW      4
                        DW      1BEh, 127h, DATAFLAG, 0
SAM9407ReverbVolume     DW      3
                        DW      1BEh, 13Ah, DATAFLAG
SAM9407ReverbType       DW      4
                        DW      1BEh, 169h, DATAFLAG, 4
SAM9407ReverbTime       DW      3
                        DW      1BEh, 178h, DATAFLAG
SAM9407ReverbFeedback   DW      3
                        DW      1BEh, 179h, DATAFLAG
SAM9407ChorusSend       DW      4
                        DW      1BEh, 124h, DATAFLAG, 0
SAM9407ChorusVolume     DW      3
                        DW      1BEh, 13Bh, DATAFLAG
SAM9407ChorusType       DW      4
                        DW      1BEh, 16Ah, DATAFLAG, 2
SAM9407ChorusDelay      DW      3
                        DW      1BEh, 174h, DATAFLAG
SAM9407ChorusFeedback   DW      3
                        DW      1BEh, 175h, DATAFLAG
SAM9407ChorusRate       DW      3
                        DW      1BEh, 176h, DATAFLAG
SAM9407ChorusDepth      DW      3
                        DW      1BEh, 177h, DATAFLAG
SAM9407Mono             DW      4
                        DW      1BEh, 132h, 7Fh, 0
SAM9407Stereo           DW      4
                        DW      1BEh, 132h, 0, 0

SAM9407Strings          DW      Offset SAM9407Reset             ;1
                        DW      Offset SAM9407EqLBL, Offset SAM9407EqLBR
                        DW      Offset SAM9407EqLBF
                        DW      Offset SAM9407EqMLBL, Offset SAM9407EqMLBR
                        DW      Offset SAM9407EqMLBF
                        DW      Offset SAM9407EqMHBL, Offset SAM9407EqMHBR
                        DW      Offset SAM9407EqMHBF
                        DW      Offset SAM9407EqHBL, Offset SAM9407EqHBR
                        DW      Offset SAM9407EqHBF
                        DW      Offset SAM9407EchoLevel         ; 14
                        DW      Offset SAM9407EchoTime
                        DW      Offset SAM9407EchoFeed
                        DW      Offset SAM9407SurroundVolume    ; 17
                        DW      Offset SAM9407SurroundDelay
                        DW      Offset SAM9407ReverbSend        ; 19
                        DW      Offset SAM9407ReverbVolume
                        DW      Offset SAM9407ReverbType
                        DW      Offset SAM9407ReverbTime
                        DW      Offset SAM9407ReverbFeedback    ; 23
                        DW      Offset SAM9407ChorusSend        ; 24
                        DW      Offset SAM9407ChorusVolume
                        DW      Offset SAM9407ChorusType
                        DW      Offset SAM9407ChorusDelay
                        DW      Offset SAM9407ChorusFeedback
                        DW      Offset SAM9407ChorusRate
                        DW      Offset SAM9407ChorusDepth       ; 30
                        DW      Offset SAM9407Mono              ; 31
                        DW      Offset SAM9407Stereo
FilterValue             DD      0
FilterValue2            DD      0

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
                        DW      16
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

                        DW      Near Ptr FilterText
                        DW      Near Ptr FilterButton1          ; 11
                        DW      Near Ptr FilterButton2
                        DW      Near Ptr FilterButton3

                        DW      Near Ptr VolumeText
                        DW      Near Ptr VolumeBox1

                        DW      Near Ptr MasterVolumeLeft       ; 16
                        DW      Near Ptr MasterVolumeRight      ; 17

                        DW      Near Ptr CS4237SRSCenter        ; 18
                        DW      Near Ptr CS4237SRSSpace         ; 19
                        DW      Near Ptr CSControlPortText

ST42A                   DW      Near Ptr SAM9407PortText        ; 21
                        DW      Near Ptr SAM9407ParametersText
                        DW      Near Ptr SAM9407ParametersBox

                        DW      Near Ptr EqLBL                  ; 24
                        DW      Near Ptr EqLBR
                        DW      Near Ptr EqLBF

                        DW      Near Ptr EqMLBL
                        DW      Near Ptr EqMLBR
                        DW      Near Ptr EqMLBF

                        DW      Near Ptr EqMHBL
                        DW      Near Ptr EqMHBR
                        DW      Near Ptr EqMHBF

                        DW      Near Ptr EqHBL
                        DW      Near Ptr EqHBR
                        DW      Near Ptr EqHBF

                        DW      Near Ptr EchoLevel              ; 33
                        DW      Near Ptr EchoTime
                        DW      Near Ptr EchoFeedback

                        DW      Near Ptr SurroundVolume
                        DW      Near Ptr SurroundDelay

                        DW      Near Ptr ReverbSend             ; 38
                        DW      Near Ptr ReverbVolume
                        DW      Near Ptr ReverbType
                        DW      Near Ptr ReverbTime
                        DW      Near Ptr ReverbFeedback

                        DW      Near Ptr ChorusSend
                        DW      Near Ptr ChorusVolume
                        DW      Near Ptr ChorusType
                        DW      Near Ptr ChorusDelay
                        DW      Near Ptr ChorusFeedback
                        DW      Near Ptr ChorusRate
                        DW      Near Ptr ChorusDepth


                        DW      0

WSSHeaderLine           DW      10
                        DB      "Sound Track Codec Driver", 0

EmptyObject             DW      1
                        DB      0, 0
                        DB      0
                        DB      0

DriverText              DW      1
                        DB      28, 48
                        DB      21h
                        DB      "Sound Track Codec Driver 1.0 for Impulse Tracker", 0

CSControlPortText       DW      1
                        DB      28, 47
                        DB      21h
                        DB      "Sound Track CS4237 Control Port ", 0FDh, "Xh", 0
CS4237Port              DW      0

SAM9407PortText         DW      1
                        DB      28, 46
                        DB      21h
                        DB      "Sound Track SAM9407 Port ", 0FDh, "Xh", 0
SAM9407Port             DW      0

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
                        DB      "Master Volume Right", 13
                        DB      "CS4237 SRS Center", 13
                        DB      "CS4237 SRS Space"
                        DB      0

VolumeBox1              DW      0
                        DB      21, 13, 31, 18
                        DB      25

MasterVolumeLeft        DW      14
                        DB      22, 14
                        DW      0, 63
                        DW      9, 0
                        DW      0FFFFh, 17, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      8

MasterVolumeRight       DW      14
                        DB      22, 15
                        DW      0, 63
                        DW      9, 1
                        DW      16, 18, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      8

CS4237SRSCenter         DW      14
                        DB      22, 16
                        DW      0, 15
                        DW      9, 31
                        DW      17, 19, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      8

CS4237SRSSpace          DW      14
                        DB      22, 17
                        DW      0, 15
                        DW      9, 32
                        DW      18, 6, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      8

MixModeText             DW      1
                        DB      2, 19
                        DB      20h
                        DB      "Mixing Rate: ", 0FDh, "D, Mode:", 0
MixSpeed                DW      48000

MixModeButton1          DW      2
                        DW      19, 7, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetMixMode
DriverSegment1          DW      0
                        DW      0
                        DW      Offset SetMixMode
DriverSegment2          DW      0
                        DB      3, 21, 32, 23, 8
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
                        DB      3, 24, 32, 26, 8
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
                        DB      3, 27, 32, 29, 8
                        DB      0
                        DB      "  32 Bit, Interpolated", 0

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
                        DB      3, 30, 32, 32, 8
                        DB      0
                        DB      "  32 Bit, Ultra Quality", 0

FilterText              DW      1
                        DB      2, 34
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
                        DB      3, 36, 29, 38, 8
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
                        DB      3, 39, 29, 41, 8
                        DB      0
                        DB      "  50% Filter", 0

FilterButton3           DW      2
                        DW      12
ST42B                   DW      24, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetFilter
DriverSegment13         DW      0
                        DW      2
                        DW      Offset SetFilter
DriverSegment14         DW      0
                        DB      3, 42, 29, 44, 8
                        DB      0
                        DB      "  75% Filter", 0

SAM9407ParametersText   DW      1
                        DB      36, 14
                        DB      20h
                        DB      "Low Band Left", 13
                        DB      "Low Band Right", 13
                        DB      "Low Band Frequency", 13
                        DB      "Med Low Band Left", 13
                        DB      "Med Low Band Right", 13
                        DB      "Med Low Band Frequency", 13
                        DB      "Med High Band Left", 13
                        DB      "Med High Band Right", 13
                        DB      "Med High Band Frequency", 13
                        DB      "High Band Left", 13
                        DB      "High Band Right", 13
                        DB      "High Band Frequency", 13
                        DB      "Echo Level", 13
                        DB      "Echo Time", 13
                        DB      "Echo Feedback", 13
                        DB      "Surround Volume", 13
                        DB      "Surround Delay", 13
                        DB      "Reverb Send", 13
                        DB      "Reverb Volume", 13
                        DB      "Reverb Type", 13
                        DB      "Reverb Time", 13
                        DB      "Reverb Feedback", 13
                        DB      "Chorus Send", 13
                        DB      "Chorus Volume", 13
                        DB      "Chorus Type", 13
                        DB      "Chorus Delay", 13
                        DB      "Chorus Feedback", 13
                        DB      "Chorus Rate", 13
                        DB      "Chorus Depth", 13
                        DB      0

EqLBL                   DW      14
                        DB      60, 14
                        DW      0, 127
                        DW      9, 2
                        DW      13, 25, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

EqLBR                   DW      14
                        DB      60, 15
                        DW      0, 127
                        DW      9, 3
                        DW      24, 26, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

EqLBF                   DW      14
                        DB      60, 16
                        DW      0, 127
                        DW      9, 4
                        DW      25, 27, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

EqMLBL                  DW      14
                        DB      60, 17
                        DW      0, 127
                        DW      9, 5
                        DW      26, 28, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

EqMLBR                  DW      14
                        DB      60, 18
                        DW      0, 127
                        DW      9, 6
                        DW      27, 29, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

EqMLBF                  DW      14
                        DB      60, 19
                        DW      0, 127
                        DW      9, 7
                        DW      28, 30, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

EqMHBL                  DW      14
                        DB      60, 20
                        DW      0, 127
                        DW      9, 8
                        DW      29, 31, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

EqMHBR                  DW      14
                        DB      60, 21
                        DW      0, 127
                        DW      9, 9
                        DW      30, 32, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

EqMHBF                  DW      14
                        DB      60, 22
                        DW      0, 127
                        DW      9, 10
                        DW      31, 33, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

EqHBL                   DW      14
                        DB      60, 23
                        DW      0, 127
                        DW      9, 11
                        DW      32, 34, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

EqHBR                   DW      14
                        DB      60, 24
                        DW      0, 127
                        DW      9, 12
                        DW      33, 35, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

EqHBF                   DW      14
                        DB      60, 25
                        DW      0, 127
                        DW      9, 13
                        DW      34, 36, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

EchoLevel               DW      14
                        DB      60, 26
                        DW      0, 127
                        DW      9, 15
                        DW      35, 37, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

EchoTime                DW      14
                        DB      60, 27
                        DW      0, 127
                        DW      9, 14
                        DW      36, 38, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

EchoFeedback            DW      14
                        DB      60, 28
                        DW      0, 127
                        DW      9, 16
                        DW      37, 39, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

SurroundVolume          DW      14
                        DB      60, 29
                        DW      0, 255
                        DW      9, 17
                        DW      38, 40, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

SurroundDelay           DW      14
                        DB      60, 30
                        DW      0, 127
                        DW      9, 18
                        DW      39, 41, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

ReverbSend              DW      14
                        DB      60, 31
                        DW      0, 127
                        DW      9, 19
                        DW      40, 42, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

ReverbVolume            DW      14
                        DB      60, 32
                        DW      0, 255
                        DW      9, 20
                        DW      41, 43, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14


ReverbType              DW      14
                        DB      60, 33
                        DW      0, 7
                        DW      9, 21
                        DW      42, 44, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

ReverbTime              DW      14
                        DB      60, 34
                        DW      0, 127
                        DW      9, 22
                        DW      43, 45, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

ReverbFeedback          DW      14
                        DB      60, 35
                        DW      0, 127
                        DW      9, 23
                        DW      44, 46, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

ChorusSend              DW      14
                        DB      60, 36
                        DW      0, 127
                        DW      9, 24
                        DW      45, 47, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

ChorusVolume            DW      14
                        DB      60, 37
                        DW      0, 255
                        DW      9, 25
                        DW      46, 48, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

ChorusType              DW      14
                        DB      60, 38
                        DW      0, 7
                        DW      9, 26
                        DW      47, 49, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

ChorusDelay             DW      14
                        DB      60, 39
                        DW      0, 127
                        DW      9, 27
                        DW      48, 50, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

ChorusFeedback          DW      14
                        DB      60, 40
                        DW      0, 127
                        DW      9, 28
                        DW      49, 51, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

ChorusRate              DW      14
                        DB      60, 41
                        DW      0, 127
                        DW      9, 29
                        DW      50, 52, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

ChorusDepth             DW      14
                        DB      60, 42
                        DW      0, 127
                        DW      9, 30
                        DW      51, 0FFFFh, 0FFFFh, 0FFFFh
                        DW      0FFFFh, 0FFFFh
                        DW      14

SAM9407ParametersBox    DW      0
                        DB      59, 13, 75, 43
                        DB      25

; OldIRQData              DD      0
; OldIRQOffset            DD      0
; UseOldIRQ               DB      0

; 컴 MixingRoutines 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�


include dmasirq.inc
include mix.inc

include m12bit.mix
include m12biti.mix
include m32biti.mix
include m32ultra.mix

MixFunctionTables       Label

include m12bit.inc      ; contains the tables
include m12biti.inc
include m32biti.inc
include m32ultra.inc

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

                Mov     AX, 1
                Ret

EndP            SetFilter

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

; 컴 SAM9407InByte 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SAM9407InByte                   ; Returns AL

                Push    DX
                Mov     DX, CS:SAM9407Port
                Inc     DX

SAM9407InByte1:
                In      AL, DX
                Test    AL, AL
                JS      SAM9407InByte1

                Dec     DX
                In      AL, DX
                Pop     DX

                Ret

EndP            SAM9407InByte

; 컴 ST97SendByte 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SAM9407SendByte         ; DX = port, AL = data

                Push    AX
                Push    DX
                Mov     DX, CS:SAM9407Port
                Inc     DX

SAM9407SendByte1:
                In      AL, DX
                Test    AL, 40h
                JNZ     SAM9407SendByte1

                Pop     DX
                Pop     AX

                Out     DX, AL

                Ret

EndP            SAM9407SendByte

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SetSAM9407              ; DI = index. 1 = full reinit.

                PushA
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Driver

                LEA     SI, [SAM9407Strings+EDI+EDI-2]
                Mov     SI, [SI]

                LodsW
                Mov     CX, AX

SetSAM9407_1:
; AH = 0 = normal data, 1 = command, 2 = param, 3 = ack.

                Mov     DX, SAM9407Port
                Test    DX, DX
                JZ      NoSAM9407

                LodsW

                Cmp     AH, 2
                JB      SetSAM9407_3
                JA      SetSAM9407_4

                Mov     AL, [VolumeTable+DI]
                Jmp     SetSAM9407_2

SetSAM9407_4:
                Call    SAM9407InByte
                Test    AL, AL
                JNZ     SetSAM9407_4
                Jmp     SetSAM9407_5

SetSAM9407_3:
                And     AH, 1
                Add     DL, AH

SetSAM9407_2:
                Call    SAM9407SendByte

SetSAM9407_5:
                Dec     CX
                JNZ     SetSAM9407_1

NoSAM9407:
                Pop     DS
                PopA

                Ret

EndP            SetSAM9407

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

                Mov     AX, [SI+22]

                ClI

                Mov     CS:MixMode, AX

                Mov     BX, 180
                Mul     BX
                Mov     CS:MixModeOffset, AX

                Mov     DS, Word Ptr [CS:RecalculateAllVolumes+2]
                Call    CS:RecalculateAllVolumes

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
                Mov     DX, 16          ; 16 different available speeds

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

                Pop     DS
                PopA
                Ret

EndP            GetWSSMixConst
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            PingWSS                 ; Check BasePort, DX = BasePort
                                        ; Preserves DX, destroys AX

                Push    DX

                Add     DX, 6


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

                Cmp     PnP_VendorID, PNPVENDORID
                JNE     PnP_IsolateNextCard
;                Cmp     PnP_SerialID, PNPSERIALID
;                JNE     PnP_IsolateNextCard

                Mov     AL, 3
                Call    PnP_WriteData

                Mov     AX, 007h                ; Configuration device
                Call    PnP_WriteData

                Mov     AL, 60h
                Call    PnP_ReadData
                Mov     AH, AL
                Mov     AL, 61h
                Call    PnP_ReadData    ; AX = address.

                Test    AX, AX
                JZ      PnP_IsolateNextCard

                Cmp     BasePort, 0FFFFh
                JE      PnPBasePortOK

                Cmp     BasePort, AX
                JNE     PnP_IsolateNextCard

PnPBasePortOK:
                Cmp     AX, 534h
                JNE     PnPBasePortTranslate1

                Mov     AX, 530h

PnPBasePortTranslate1:
                Cmp     AX, 0F44h
                JNE     PnPBasePortTranslate2

                Mov     AX, 0F40h

PnPBasePortTranslate2:
                Cmp     AX, 608h
                JNE     PnPBasePortTranslate3

                Mov     AX, 604h

PnPBasePortTranslate3:
                Cmp     AX, 0E84h
                JNE     PnPBasePortTranslate4

                Mov     AX, 0E80h

PnPBasePortTranslate4:
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

                Mov     AX, 207h                 ; CS4237
                Call    PnP_WriteData

                Mov     AL, 60h
                Call    PnP_ReadData
                Mov     AH, AL
                Mov     AL, 61h
                Call    PnP_ReadData    ; AX = address.
                Test    AX, AX
                JZ      PnP_IsolateNextCard

                Mov     CS4237Port, AX

                Mov     AX, 407h                 ; SAM9407
                Call    PnP_WriteData

                Mov     AL, 60h
                Call    PnP_ReadData
                Mov     AH, AL
                Mov     AL, 61h
                Call    PnP_ReadData    ; AX = address.
                Test    AX, AX
                JZ      PnP_NoSAM9407

                Mov     SAM9407Port, AX

                Mov     Pnp_CardFound, 1
                Jmp     PnP_IsolateNextCard

Pnp_NoSAM9407:
                Xor     AX, AX
                Mov     SAM9407Port, AX
                Mov     ST42A, AX
                Dec     AX
                Mov     ST42B, AX
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
                Mov     DX, BasePort
                JNC     DetectWSSOK

DetectPCI:
;                Cmp     DMA, 0FFFFh
;                JNE     DMAOverride

                Mov     DMA, 1          ; Force DMA to 1.

DMAOverride:
                Mov     EBX, 80000000h  ; PCI output value.
                Mov     DX, 0CF8h
                Mov     CX, 32

DetectCardPCIBasePort1:
                Mov     EAX, EBX
                Out     DX, EAX
                Add     DX, 4
                In      EAX, DX
                Sub     DX, 4
                Add     EBX, 1 SHL 11

                Cmp     EAX, 8128Eh
                LoopNE  DetectCardPCIBasePort1

                JNE     DetectWSSFailure

                Add     EBX, (3Ch) - (1 SHL 11)
                Mov     EAX, EBX
                Out     DX, EAX
                Add     DX, 4
                In      EAX, DX         ; AL = IRQ
                Mov     ECX, EAX
                And     AX, 0FFh

                JZ      DetectWSSFailure
                Cmp     AL, 15
                JA      DetectWSSFailure

                Cmp     IRQ, 0FFFFh
                JNE     IRQSpecified

                Mov     IRQ, AX

;                Mov     OldIRQOffset, EBX
;                Mov     OldIRQData, ECX
;                Mov     UseOldIRQ, 1

IRQSpecified:
                Sub     DX, 4

; Get SAM9407IRQ
                Add     EBX, 1 SHL 8
                Mov     EAX, EBX
                Out     DX, EAX
                Add     DX, 4
                In      EAX, DX
                Sub     DX, 4           ; AL = IRQ.

                And     AX, 0FFh

                PushA

                JZ      NoSAM9407IRQ
                Cmp     AL, 15
                JA      NoSAM9407IRQ

                Mov     DL, AL
                ShL     DL, 4
                Mov     CL, AL
                And     DX, 80h
                Mov     CH, 1
                Or      DL, 21h
                And     CL, 7
                ShL     CH, CL
                In      AL, DX
                Or      AL, CH
                Out     DX, AL

NoSAM9407IRQ:
                PopA
                Push    AX

                Add     EBX, 10h-3Ch    ; SAM9407 port
                Mov     EAX, EBX
                Out     DX, EAX
                Add     DX, 4
                In      EAX, DX
                Sub     DX, 4
                And     AX, 0FFEh
                Mov     SAM9407Port, AX
                Pop     CX

; If SAM9407 Port not available, or IRQ = old IRQ, then set to ST42 mode.
                Test    AX, AX
                JZ      ST42Found
                Cmp     AX, 400h
                JA      ST42Found
                Cmp     CX, IRQ
                JNE     NoST42

ST42Found:
;                Mov     AX, '24'
;                Mov     Word Ptr O97A, AX
;                Mov     Word Ptr O97B, AX
;                Mov     Word Ptr O97C, AX
;                Mov     Word Ptr O97D, AX
;                Mov     Word Ptr O97E, AX
;                Mov     Word Ptr O97F, AX
                Xor     AX, AX
                Mov     SAM9407Port, AX
                Mov     ST42A, AX
                Dec     AX
                Mov     ST42B, AX

NoST42:
                Add     EBX, 3 SHL 8
                Mov     EAX, EBX
                Out     DX, EAX
                Add     DX, 4
                In      EAX, DX
                Sub     DX, 4
                And     AX, 0FFEh
                Cmp     AX, 400h
                JB      NoCS

                Xor     AX, AX

NoCS:
                Mov     CS4237Port, AX

                Sub     EBX, 4 SHL 8

;                Add     EBX, 10h - 3Ch
;                Add     EBX, (10h) - (1 SHL 11)
                Mov     EAX, EBX
                Out     DX, EAX
                Add     DX, 4
                In      EAX, DX

                And     AX, 0FFEh
                Mov     DX, AX

                Cmp     BasePort, 0FFFFh
                JE      BasePortNotSpecified

                Mov     DX, BasePort

BasePortnotSpecified:
                Call    PingWSS
                JNC     DetectWSSOK

DetectWSSFailure:
                StC
                Ret

DetectWSSOK:
                Mov     BasePort, DX

CheckWSSOK:                             ; Check for IRQ
                Add     DX, 4

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

                Mov     DX, CS4237Port
                Test    DX, DX
                JZ      DetectNoCS4237Port

                Add     DX, 3

                Mov     AL, 3
                Out     DX, AL
                Inc     DX
                Mov     AL, 0A0h
                Out     DX, AL
                Dec     DX              ; Enable 3D stuff

                Mov     AL, 2
                Out     DX, AL
                Inc     DX
                In      AL, DX
                Out     DX, AL
                Not     AL
                Mov     AH, AL
                And     AL, 0Fh
                ShR     AH, 4

                Mov     [Word Ptr VolumeTable+31], AX

DetectNoCS4237Port:
                Mov     EAX, 'Jeff'
                ClC
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

Proc            WSSIRQHandler

                PushAD
                Push    DS
                Push    ES

                ClD

                Mov     AX, CS
                Mov     DS, AX
                        Assume DS:Driver

                Mov     DX, [BasePort]
                Add     DX, 6
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
                JE      WSSIRQHandlerMono

                Mov     BP, 4                   ; Stereo skip value.
                Dec     CL

WSSIRQHandlerMono:
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
                Push    DX
                Cmp     CS:Filter, 1
                JB      WSSIRQHandler6
                JE      WSSIRQHFilter

                Cmp     CS:Stereo, 0
                JE      WSSIRQ3QFilterMono

WSSIRQ3QFilterStereo:
                Push    BX

                Mov     EBX, FilterValue
                Mov     EBP, FilterValue2
                ShR     DX, 1

WSSIRQ3QFilterStereo1:
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

WSSIRQ3QFilterStereo2:
                StosW

                Mov     EAX, EBP
                SAR     EAX, 13

                Cmp     EAX, -8000h
                JL      WSS3QFilterStereoClip3
                Cmp     EAX, 7FFFh
                JG      WSS3QFilterStereoClip4

WSSIRQ3QFilterStereo3:
                StosW

                Add     SI, 8
                Dec     DX
                JNZ     WSSIRQ3QFilterStereo1

                Mov     FilterValue, EBX
                Mov     FilterValue2, EBP

                Pop     BX

                Jmp     WSSMixTransferEnd

WSSIRQ3QFilterMono:
                Push    BX

                Mov     EBX, FilterValue

WSSIRQ3QFilterMono1:
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

WSSIRQ3QFilterMono2:
                StosW

                Add     SI, 8
                Dec     DX
                JNZ     WSSIRQ3QFilterMono1

                Mov     FilterValue, EBX

                Pop     BX

                Jmp     WSSMixTransferEnd

WSSIRQHFilter:
                Cmp     CS:Stereo, 0
                JE      WSSIRQHFilterMono

WSSIRQHFilterStereo:
                Push    BX

                Mov     EBX, FilterValue
                Mov     EBP, FilterValue2
                ShR     DX, 1

WSSIRQHFilterStereo1:
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

WSSIRQHFilterStereo2:
                StosW

                Mov     EAX, EBP
                SAR     EAX, 13

                Cmp     EAX, -8000h
                JL      WSSHFilterStereoClip3
                Cmp     EAX, 7FFFh
                JG      WSSHFilterStereoClip4

WSSIRQHFilterStereo3:
                StosW

                Add     SI, 8
                Dec     DX
                JNZ     WSSIRQHFilterStereo1

                Mov     FilterValue, EBX
                Mov     FilterValue2, EBP

                Pop     BX

                Jmp     WSSMixTransferEnd

WSSIRQHFilterMono:
                Push    BX

                Mov     EBX, FilterValue

WSSIRQHFilterMono1:
                Add     EBX, [SI]
                SAR     EBX, 1
                Mov     EAX, EBX
                SAR     EAX, 14

                Cmp     EAX, -8000h
                JL      WSSHFilterMonoClip1
                Cmp     EAX, 7FFFh
                JG      WSSHFilterMonoClip2

WSSIRQHFilterMono2:
                StosW

                Add     SI, 8
                Dec     DX
                JNZ     WSSIRQHFilterMono1

                Mov     FilterValue, EBX

                Pop     BX

                Jmp     WSSMixTransferEnd

WSSIRQHandler6:
                Mov     EAX, [SI]
                SAR     EAX, CL

                Cmp     EAX, -8000h
                JL      WSSIRQHandlerClip1
                Cmp     EAX, 7FFFh
                JG      WSSIRQHandlerClip2

WSSIRQHandler7:
                StosW                                   ; } Memory write

                Add     SI, BP
                Dec     DX
                JNZ     WSSIRQHandler6

WSSMixTransferEnd:
                Pop     DX

                Sub     MixTransferRemaining, DX        ; } Memory write
                Sub     BX, DX
                JNZ     WSSIRQHandler3

                Mov     MixTransferOffset, SI           ; } Memory write

                Call    RestoreEMSPageFrame

                Pop     ES
                Pop     DS
                PopAD
                IRet

WSSIRQHandlerClip1:
                Mov     AX, 8000h
                Jmp     WSSIRQHandler7

WSSIRQHandlerClip2:
                Mov     AX, 7FFFh
                Jmp     WSSIRQHandler7

WSSHFilterMonoClip1:
                Mov     AX, 8000h
                Jmp     WSSIRQHFilterMono2

WSSHFilterMonoClip2:
                Mov     AX, 7FFFh
                Jmp     WSSIRQHFilterMono2

WSSHFilterStereoClip1:
                Mov     AX, 8000h
                Jmp     WSSIRQHFilterStereo2

WSSHFilterStereoClip2:
                Mov     AX, 7FFFh
                Jmp     WSSIRQHFilterStereo2

WSSHFilterStereoClip3:
                Mov     AX, 8000h
                Jmp     WSSIRQHFilterStereo3

WSSHFilterStereoClip4:
                Mov     AX, 7FFFh
                Jmp     WSSIRQHFilterStereo3

WSS3QFilterMonoClip1:
                Mov     AX, 8000h
                Jmp     WSSIRQ3QFilterMono2

WSS3QFilterMonoClip2:
                Mov     AX, 7FFFh
                Jmp     WSSIRQ3QFilterMono2

WSS3QFilterStereoClip1:
                Mov     AX, 8000h
                Jmp     WSSIRQ3QFilterStereo2

WSS3QFilterStereoClip2:
                Mov     AX, 7FFFh
                Jmp     WSSIRQ3QFilterStereo2

WSS3QFilterStereoClip3:
                Mov     AX, 8000h
                Jmp     WSSIRQ3QFilterStereo3

WSS3QFilterStereoClip4:
                Mov     AX, 7FFFh
                Jmp     WSSIRQ3QFilterStereo3

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

                Mov     DX, BasePort
                Add     DX, 4

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

                Mov     MixTransferRemaining, 0

                Mov     DX, BasePort
                Call    PingWSS

                Add     DX, 4

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
                AdC     DX, 2080

                Mov     BX, (DMABUFFERLENGTH*2)/16
                Add     BX, DX

                        ; Allocate MixSegment first
                Mov     AH, 48h

                Int     21h
                JNC     InitSound1

InitSoundNoMemory:
                Mov     SI, Offset WSSNoMemoryMsg
                Ret

InitSound1:
                Mov     MixSegment, AX
                Add     AX, DX
                Mov     DMASegment, AX

                Call    SetIRQ
                Call    GetTempo
                Call    SetTempo

                Mov     DI, 1
                Call    SetSAM9407

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
;                Cmp     UseOldIRQ, 1
;                JNE     UnInitSound2
;
;                Mov     DX, 0CF8h
;                Mov     EAX, OldIRQOffset
;                Out     DX, EAX
;                Add     DX, 4
;                Mov     EAX, OldIRQData
;                Out     DX, EAX
;
; UnInitSound2:
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
                Call    CS: RecalculateAllVolumes

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

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetStereo Far

                Mov     CS:Stereo, AL
                Cmp     CS:MixSegment, 0
                JE      SetStereo1

                Push    AX

                Call    StopWSS
                Call    StartWSS

                Call    RecalculateAllFrequencies

                Pop     DI
                And     DI, 1
                Add     DI, 31
                Call    SetSAM9407

                Mov     DI, 2
SetStereo2:
                Call    SetSAM9407
                Inc     DI
                Cmp     DI, 30
                JBE     SetStereo2

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

                PushA
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     DX, BasePort
                Add     DX, 4

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

                Mov     DX, CS4237Port
                Test    DX, DX
                JZ      UpdateSoundCardVariables1

                Add     DX, 3

                Mov     AL, 3
                Out     DX, AL
                Inc     DX
                Mov     AL, 0A0h
                Out     DX, AL
                Dec     DX

                Mov     AL, 2
                Out     DX, AL

                Mov     AX, [Word Ptr VolumeTable+31]
                ShL     AH, 4
                Inc     DX
                Or      AL, AH
                Not     AL
                Out     DX, AL

UpdateSoundCardVariables1:

                Pop     DS
                PopA

                Ret

EndP            UpdateSoundcardVariables
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetVariable Far

                Mov     [CS:VolumeTable+DI], AL
                Cmp     DI, 31
                JAE     SetVariable1
                Cmp     DI, 2
                JB      SetVariable1

                Call    SetSAM9407
                Ret

SetVariable1:
                Call    UpdateSoundcardVariables
                Ret

EndP            SetVariable

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

EndDriver:

;********  Provided Variable Table *************

MaxNumberOfChannels     DW      0FFFFh  ; Maximum number of channels the
                                        ; driver can handle.
StopAfterPlay           DW      0
DefaultChannels         DW      64
DriverFlags             DW      0
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

ProvidedTableEnd:
        DW      32-(ProvidedTableEnd-ProvidedTableStart)/2 Dup (0)

EndS

End
