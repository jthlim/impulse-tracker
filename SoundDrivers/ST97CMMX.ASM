;
; ST 97/42 PCI Codec, using MMX.
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

STEREOENABLED           EQU     1
DMABUFFERLENGTH         EQU     8192
MIXRESOLUTION           EQU     32      ; 32 bit mixing
OUTPUTFILTERENABLED     EQU     0
DATAFLAG                EQU     200h
ACKFLAG                 EQU     300h
FOURIERBUFFERLENGTH     EQU     2048    ; 2048 samples

PNPVENDORID     EQU     3746630Eh

FPSave          DB      128 Dup (0)

DMASize         DW      DMABUFFERLENGTH / 2

WSSMsg          DB      "Sound Track Codec MMX", 13
                DB      "Port ", 0FDh, "Xh, IRQ ", 0FDh, "D, DMA ", 0FDh, "D", 0

WSSNoMemoryMsg  DB      "Sound Track Codec MMX", 13
                DB      "Error: Insufficient memory", 0

ReinitMsg       DB      "Sound Track Codec reinitialised", 0

DriverName      DB      "ITSTCODE.MMX", 0

Forced          DB      0
Stereo          DB      0
WSSMixConst     DB      0

ALIGN 2

MixVolume       DW      0

BytesToMix      DW      1000

MixSegment      DW      0
FourierSegment  DW      0

; Arrangement of data:
; First 64 bytes = MMX temporary area
; Next 2*DMABUFFERLENGTH = DMA area
; After that is mixing buffer.

MixTransferOffset       DW      0
MixTransferRemaining    DW      0

CONFIGURATIONOFFSET     EQU     $+128
CONFIGSIZE              EQU     35
MixMode                 DW      0
MixModeOffset           DW      0
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
                        DW      Near Ptr MixModeButton3         ;
                        DW      Near Ptr MixModeButton4         ;

                        DW      Near Ptr EmptyObject
                        DW      Near Ptr EmptyObject
                        DW      Near Ptr EmptyObject
                        DW      Near Ptr EmptyObject

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
                        DB      "Mixing Rate: ", 0FDh, "D", 0
MixSpeed                DW      48000
                        DW      0

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
                        DB      "  MMX, Non-interpolated", 0

MixModeButton2          DW      2
                        DW      6
                        DW      8, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetMixMode
DriverSegment3          DW      0
                        DW      1
                        DW      Offset SetMixMode
DriverSegment4          DW      0
                        DB      3, 24, 32, 26, 8
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
                        DB      3, 27, 32, 29, 8
                        DB      0
                        DB      "  MMX, Volume Ramp", 0

MixModeButton4          DW      2
                        DW      8
ST42B                   DW      24, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      6
                        DW      Offset GetMixMode
DriverSegment7          DW      0
                        DW      3
                        DW      Offset SetMixMode
DriverSegment8          DW      0
                        DB      3, 30, 32, 32, 8
                        DB      0
                        DB      "  MMX, Filtered", 0

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
                        DW      9, 25, 0FFFFh, 0FFFFh
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

; 컴 MixingRoutines 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�


include dmasirq.inc
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

                FNInit
                FILd    DWord Ptr [MixSpeed]
                FMul    FreqMultiplier
                FStP    FreqMultiplier

                Mov     AX, BX
                Mov     BX, 12000
                Xor     DX, DX
                Div     BX
                Mov     FourierBufferStepOffset, AX
                Mov     FourierBufferStepFractional, DX

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

                DB      85h

PingWSSFailure:
                StC
                Pop     DX

                Ret


EndP            PingWSS

include nodebug.inc

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

                Trace   "MMX Detected"

                DB      85h

DetectMMXFail:
                StC
                Ret

EndP            DetectMMX

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

                Call    DetectMMX
                JC      DetectWSSFailure

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
                JNC     BasePortNotSpecified
;                JNC     DetectWSSOK

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

                Sub     DX, 4
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

include mmxmsam.inc
include fourier.inc

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            WSSIRQHandler

                PushAD
                Push    DS
                Push    ES

                ClD

                Mov     AX, CS
                Mov     DS, AX
                        Assume DS:Driver

                FNSave  [FPSave]

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
                Call    UpdateFourierBuffer

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
                Mov     BX, MixSegment
                Mov     AX, 80
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
                AdC     DX, 5 + (DMABUFFERLENGTH*2)/16 + FOURIERBUFFERLENGTH/8
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
                Add     AX, DX
                Sub     AX, FOURIERBUFFERLENGTH/8
                Mov     FourierSegment, AX

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

                Call    ResetUART
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

                Call    ResetUART
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

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            SetStereo Far

                Mov     CS:Stereo, AL
                Cmp     CS:MixSegment, 0
                JE      SetStereo1

                Push    AX

                Call    ResetUART
                Call    StopWSS
                Call    StartWSS

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
                Call    InitUART
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

Proc            ResetUART

                Mov     DX, CS:SAM9407Port
                Test    DX, DX
                JZ      ResetUART1

                Inc     DX

                Mov     AL, 0FFh
                Out     DX, AL

ResetUART1:
                Ret

EndP            ResetUART

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            InitUART

                ClI

                Mov     DX, CS:SAM9407Port
                Inc     DX
                Mov     AL, 0FFh        ; reset
                Out     DX, AL

                Xor     CX, CX

DetectUARTPause:
                In      AL, 21h
                In      AL, 0A1h
                Loop    DetectUARTPause

                Mov     AL, 0FFh
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

                Mov     AL, 0FFh
                Out     DX, AL

                DB      85h
DetectUARTFailed:
                StC
                StI
                Ret

EndP            InitUART

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            UARTOut

                Push    CX
                Push    DX
                Mov     DX, CS:SAM9407Port

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
                Call    UARTOut
                Ret

EndP            SendUARTOut

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Proc            GetWaveForm Far         ; Given ES:DI = destination
                Assume DS:Nothing       ; want 2048 samples.

                PushA
                Push    DS

                Mov     DS, FourierSegment
                Mov     SI, FourierBufferStart
                Mov     CX, 2048

GetWaveForm1:
                MovsW
                And     SI, (FOURIERBUFFERLENGTH*2)-1
                Dec     CX
                JNZ     GetWaveForm1

                Pop     DS
                PopA

                Ret

EndP            GetWaveForm

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

EndDriver:

;********  Provided Variable Table *************

MaxNumberOfChannels     DW      0FFFFh  ; Maximum number of channels the
                                        ; driver can handle.

StopAfterPlay           DW      0
DefaultChannels         DW      128
DriverFlags             DW      7
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
        DW      Offset GetWaveForm

ProvidedTableEnd:
        DW      32-(ProvidedTableEnd-ProvidedTableStart)/2 Dup (0)

EndS

End
