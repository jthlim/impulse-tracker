;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Write module functions
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�


Proc            WriteITSampleBlock

                PushAD                  ; BX = file handle.
                Push    DS

                Mov     DS, CS:DiskDataArea

                Mov     DX, [DS:1996]
                Mov     CX, [DS:1998]
                Mov     AX, 4200h
                Int     21h

                Mov     AX, 80
                Mul     Word Ptr [DS:24h]
                Mov     CX, AX

                Mov     DX, 2000
                Call    D_SaveBlock

WriteITSampleBlock1:
                Pop     DS
                PopAD
                Ret

EndP            WriteITSampleBlock

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

NUMS3MCHANNELS    EQU     16

BitLUT          Label   Byte
                DB      1, 2, 3, 3, 4, 4, 4, 4
                DB      5, 5, 5, 5, 5, 5, 5, 5
                DB      4, 4, 4, 4, 3, 3, 2

BitLUT16        Label   Byte
                DB      1, 10 SHL 3 + 3, 11 SHL 3 + 5, 11 SHL 3 + 3
                DB      3 DUP (12 SHL 3 + 5), 12 SHL 3 + 3
                DB      7 DUP (13 SHL 3 + 5), 13 SHL 3 + 3

                DB      13 SHL 3 + 4, 7 DUP (13 SHL 3 + 5)
                DB      12 SHL 3 + 4, 3 DUP (12 SHL 3 + 5)
                DB      11 SHL 3 + 4, 11 SHL 3 + 5, 10 SHL 3 + 4, 2


Proc            D_SaveIT Far


                Call    PE_SaveCurrentPattern

                Call    D_UpdateFileName

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     NoSaveError, 0

                Mov     AH, 3Ch
                Xor     CX, CX                  ; File type is normal (archive)
                Mov     DX, Offset SaveFileName ; DS:DX points to filename
                Int     21h
                JNC     D_SaveIT3

                Call    PE_RestoreCurrentPattern
                Jmp     D_NoSaveMessage

D_SaveIT3:
                Mov     BX, AX                  ; BX = handle

                Mov     ES, DiskDataArea
                Call    Music_GetSongSegment
                Mov     DS, AX
                        Assume DS:Nothing       ; DS = MusicData

                Xor     SI, SI
                Xor     DI, DI
                Mov     CX, 192
                Rep     MovsB                   ; Get header.

                                                ; Now to figure out the
                                                ; orders.
                Mov     SI, 511
                StD
                Mov     CX, 256

D_SaveIT4:
                LodsB
                Cmp     AL, 0FFh
                LoopE   D_SaveIT4

                ClD

                Add     CX, 2
                Mov     [ES:20h], CX
                Dec     CX

                Mov     SI, 256
                Rep     MovsB                   ; Transfer orders.
                Mov     AL, 0FFh
                StosB

;                Mov     AX, 0
;                Test    Byte Ptr [DS:2Ch], 4
;                JZ      D_SaveIT6
;
                Call    Music_GetNumberOfInstruments
;
; D_SaveIT6:
                Mov     [ES:22h], AX            ; Number of instruments

                Call    Music_GetNumberOfSamples
                Mov     [ES:24h], AX            ; Number of samples

                Call    PE_GetMaxPattern
                Inc     AX
                Mov     [ES:26h], AX            ; Number of patterns.

                Xor     CX, CX                  ; CX:DX = 'long' offsets.
                Mov     DX, 0C0h
                Add     DX, [ES:20h]
                Mov     AX, [ES:22h]
                ShL     AX, 2
                Add     DX, AX
                Mov     AX, [ES:24h]
                ShL     AX, 2
                Add     DX, AX
                Mov     AX, [ES:26h]
                ShL     AX, 2
                Add     DX, AX

                Mov     DWord Ptr [ES:36h], 0
                Mov     Word Ptr [ES:2Eh], 4    ; Row hilight information

                Push    DS

                Push    Pattern
                Pop     DS
                        Assume DS:Pattern

                Mov     AX, Word Ptr [RowHilight1]

                Pop     DS
                        Assume DS:Nothing

                Mov     [ES:1Eh], AX


                Call    GetTimerCounter
                Sub     EAX, EditTimer

                Cmp     TimerData, 0
                JE      NoTimerData

                Or      Byte Ptr [ES:2Eh], 2    ; Contains timer information

                Push    ES                      ; Put time into table.
                Push    DI

                Mov     ES, TimerData
                Mov     DI, NumTimerData
                ShL     DI, 3
                Add     DI, 4
                StosD
                Add     DI, 2

                Add     DX, DI                  ; Long offset progress.
                AdC     CX, 0

                Pop     DI
                Pop     ES

NoTimerData:
; OK.. check for MIDI config save.
                Test    Byte Ptr [DS:2Ch], 128
                JZ      D_SaveITNoMIDIConfig1

                Add     DX, 4896                ; MIDI Config size
                AdC     CX, 0
                Or      Byte Ptr [ES:2Eh], 8    ; MIDI Config.

D_SaveITNOMIDIConfig1:

                Add     EAX, [ES:3Ch]
                Xor     EAX, 'JTHL'
                RoR     EAX, 4
                Neg     EAX
                RoL     EAX, 7
                Xor     EAX, 'ITRK'

                Mov     [ES:3Ch], EAX

                Call    Msg_GetMessageLength
                Cmp     AX, 1
                JE      D_SaveITMsg1

                Or      Byte Ptr [ES:2Eh], 1
                Mov     Word Ptr [ES:3Ah], 0
                Mov     [ES:38h], DX
                Mov     [ES:36h], AX
                Add     DX, AX

D_SaveITMsg1:
                Mov     BP, [ES:22h]            ; Number of instruments

                Mov     AX, 214h

                Cmp     CS:SaveFormat, 0
                JE      D_SaveNewFormat

                Inc     AX
                Cmp     CS:SaveFormat, 3
                JE      D_SaveNewFormat

                Mov     AX, 200h

D_SaveOldIT2_1:
                Test    BP, BP
                JNZ     D_SaveNewFormat

                Mov     AX, 100h

D_SaveNewFormat:
                Inc     BP
                Mov     Word Ptr [ES:28h], TRACKERVERSION
                Mov     [ES:2Ah], AX
                And     EBP, 0FFFFh

D_SaveIT7:
                Dec     BP
                JZ      D_SaveIT8

                Mov     SI, [DS:EBP+EBP+64710]
                Test    Byte Ptr [SI+1D4h], 80h
                JZ      D_SaveIT216

                Mov     Word Ptr [ES:2Ah], 216h

D_SaveIT216:
                Mov     AX, DX
                StosW
                Mov     AX, CX
                StosW
                Add     DX, 554
                AdC     CX, 0

                Jmp     D_SaveIT7

D_SaveIT8:
                Mov     BP, [ES:24h]            ; Number of samples
                Inc     BP
                Mov     [ES:1996], DX           ; Store sample position.
                Mov     [ES:1998], CX

D_SaveIT9:
                Dec     BP
                JZ      D_SaveIT10

                Mov     AX, DX
                StosW
                Mov     AX, CX
                StosW

                Add     DX, 80
                AdC     CX, 0

                Jmp     D_SaveIT9

D_SaveIT10:

                Xor     BP, BP

D_SaveIT11:
                Cmp     BP, [ES:26h]            ; Number of patterns
                JAE     D_SaveIT12

                Push    DS

                Mov     AX, BP
                Call    Music_GetPattern                ; DS:SI has pattern

                Mov     AX, DS
                Cmp     AX, Music
                JE      D_SaveIT1

                Mov     AX, DX
                StosW
                Mov     AX, CX
                StosW

                Add     DX, [DS:SI]
                AdC     CX, 0
                Add     DX, 8                   ; pattern header length = 8.
                AdC     CX, 0

                Jmp     D_SaveIT22

D_SaveIT1:
                Xor     EAX, EAX
                StosD

D_SaveIT22:
                Pop     DS

                Inc     BP
                Jmp     D_SaveIT11

D_SaveIT12:
                                ; CX:DX now point to first sample data.
                Push    CX
                Push    DX

                Push    DS

                Push    DI

                Push    CS
                Pop     DS
                Mov     DI, (4+17*80)*2
                Mov     SI, Offset HeaderMsg
                Mov     AH, 5
                Call    S_DrawString

                Pop     CX              ; CX = length of header.

                Push    ES
                Pop     DS

                Xor     DX, DX
                Call    D_SaveBlock             ; Header.

                Test    Byte Ptr [DS:2Eh], 2    ; Time information?
                JZ      D_SaveITTimeData

                Push    DS

                Push    CS
                Pop     DS

                Mov     CX, 2
                Mov     DX, Offset NumTimerData
                Inc     [DS:NumTimerData]
                Call    D_SaveBlock
                Mov     CX, [DS:NumTimerData]
                Dec     [DS:NumTimerData]
                ShL     CX, 3
                Mov     DS, [DS:TimerData]
                Xor     DX, DX
                Call    D_SaveBlock

                Pop     DS

D_SaveITTimeData:
                Test    Byte Ptr [DS:2Ch], 128
                JZ      D_SaveITMIDIConfig

                Push    DS

                Mov     CX, 4896
                Xor     DX, DX
                Call    Music_GetMIDIDataArea   ; Gets DS
                Call    D_SaveBlock

                Pop     DS

D_SaveITMIDIConfig:
                                                ; Message?
                Test    Byte Ptr [DS:2Eh], 1
                JZ      D_SaveITMsg2

                Mov     CX, [DS:36h]
                Push    DS
                Call    Msg_GetMessageOffset
                Call    D_SaveBlock
                Pop     DS

D_SaveITMsg2:
                Push    CS
                Pop     DS
                Mov     DI, (4+18*80)*2
                Mov     SI, Offset InstrumentHeaderMsg
                Mov     AH, 5
                Call    S_DrawString

                Pop     DS
                Cmp     Word Ptr [ES:22h], 0
                JE      D_SaveIT13

                Mov     AX, 554
                Mul     Word Ptr [ES:22h]
                Mov     DX, 512
                Mov     CX, AX

                Call    D_SaveBlock             ; Instrument headers...

D_SaveIT13:
                Push    DS

                Push    CS
                Pop     DS
                Mov     DI, (4+19*80)*2
                Mov     SI, Offset SampleHeaderMsg
                Mov     AH, 5
                Call    S_DrawString

                Pop     DS                      ; DS = song data segment
                Mov     SI, 55912               ; Start of samples in mem.
                Mov     AX, 80
                Mul     Word Ptr [ES:24h]
                Mov     DI, 2000
                Mov     CX, AX
                Rep     MovsB

                Pop     DX
                Pop     CX                      ; CX:DX = sample point.

                Mov     BP, [ES:24h]            ; Number of samples.
                Mov     SI, 2000
                Inc     BP

D_SaveIT14:
                Dec     BP
                JZ      D_SaveIT16
                Mov     AL, [ES:SI+12h]
                Mov     AH, 1

                Cmp     CS:SaveFormat, 3
                JNE     D_SaveNoDD

                Or      AH, 4

D_SaveNoDD:
                Test    AL, 1
                JZ      D_SaveIT15

                Or      AL, 8
                Cmp     CS:SaveFormat, 2
                JNE     D_SaveIT214_1

                And     AL, Not 8

D_SaveIT214_1:
                Mov     [ES:SI+48h], DX
                Mov     [ES:SI+4Ah], CX

                Test    AL, 2
                Mov     [ES:SI+12h], AL
                Mov     [ES:SI+2Eh], AH
                Mov     EAX, [ES:SI+30h]
                JZ      D_SaveIT16Bit

                Add     EAX, EAX

D_SaveIT16Bit:
                Add     DX, AX
                PushF
                ShR     EAX, 16
                PopF
                AdC     CX, AX                  ; Advance sample pointer.

D_SaveIT15:
                Add     SI, 80
                Jmp     D_SaveIT14

D_SaveIT16:
                Call    WriteITSampleBlock

                Xor     BP, BP

D_SaveIT17:
                Push    DS

                Push    CS
                Pop     DS
                Mov     DI, (4+20*80)*2
                Mov     SI, Offset PatternMsg
                Mov     AH, 5
                Push    BP
                Call    S_DrawString
                Pop     AX

                Call    Music_GetPattern
                Mov     DX, DS
                Cmp     DX, Music
                JE      D_SaveIT2

                Mov     DX, SI
                Mov     CX, [DS:SI]
                Add     CX, 8
                Call    D_SaveBlock

D_SaveIT2:
                Pop     DS
                Inc     BP
                Cmp     BP, [ES:26h]
                JB      D_SaveIT17

; Setup compression block
                Push    DS

                Push    CS
                Pop     DS
                Mov     SI, Offset BitLUT

                Mov     DI, 10240
                Mov     CX, 16/2
                Rep     MovsW

; Setup table.

                Mov     CX, 16
                Mov     AL, 6
                Rep     StosB

                Mov     CX, 28
                Inc     AX
                Rep     StosB

                Mov     CX, 64
                Inc     AX
                Rep     StosB

                Mov     CX, 8
                Inc     AX
                Rep     StosB

                Mov     CX, 64
                Dec     AX
                Rep     StosB

                Mov     CX, 29
                Dec     AX
                Rep     StosB

                Mov     CX, 16
                Dec     AX
                Rep     StosB

                Mov     CX, 15
                Sub     SI, 8
                Rep     MovsB

; 16 bit Main LUT

                Mov     SI, Offset BitLUT16
                Mov     CX, 16
                Rep     MovsB

                Mov     CX, 15
                Mov     AL, 14 SHL 3 + 5
                Rep     StosB
                Mov     AL, 14 SHL 3 + 3
                StosB

                Mov     CX, 31
                Mov     AL, 15 SHL 3 + 5
                Rep     StosB
                Mov     AL, 15 SHL 3 + 3
                StosB

                Mov     CX, 63
                Mov     AL, 16 SHL 3 + 5
                Rep     StosB
                Mov     AL, 16 SHL 3 + 3
                StosB

                Inc     AX
;                Mov     AL, 16 SHL 3 + 4
                StosB
                Mov     CX, 63
                Inc     AX
;                Mov     AL, 16 SHL 3 + 5
                Rep     StosB

                Mov     AL, 15 SHL 3 + 4
                StosB
                Mov     CX, 31
                Mov     AL, 15 SHL 3 + 5
                Rep     StosB

                Mov     AL, 14 SHL 3 + 4
                StosB
                Mov     CX, 15
                Mov     AL, 14 SHL 3 + 5
                Rep     StosB

                Mov     CX, 16
                Rep     MovsB

; 16 bit LUT 1, for 16-bit samples with high byte = 0

                Mov     SI, Offset BitLUT
                Mov     CX, 16
                Rep     MovsB

                Mov     CX, 16
                Mov     AL, 6
                Rep     StosB           ; AL = 6 from before

                Mov     CX, 24
                Inc     AX
                Rep     StosB

                Mov     CX, 64
                Inc     AX
                Rep     StosB

                Mov     CX, 128
                Inc     AX
                Rep     StosB

; 16-Bit LUT 2, for 16-bit samples with high byte = 0xFF

                Mov     CX, 16
                Inc     AX
                Rep     StosB

                Mov     CX, 128
                Dec     AX
                Rep     StosB

                Mov     CX, 64
                Dec     AX
                Rep     StosB

                Mov     CX, 25
                Dec     AX
                Rep     StosB

                Mov     CX, 16
                Dec     AX
                Rep     StosB

                Mov     CX, 15
                Sub     SI, 8
                Rep     MovsB

                Mov     CX, 256-8
                Xor     AX, AX
                Rep     StosB

                Mov     CX, 16
                Inc     AX
                Rep     StosB

                Mov     CX, 256-8+256
                Dec     AX
                Rep     StosB

                Pop     DS

                Xor     BP, BP                  ; BP = sample number.
                Mov     DI, 2000+48h

D_SaveIT18:
                Push    DS
                Push    DI

                Xor     CX, CX
                Xor     DX, DX
                Mov     AX, 4201h
                Int     21h

                Mov     [ES:DI], AX
                Mov     [ES:DI+2], DX

                Mov     SI, BP
                Add     SI, SI
                Mov     SI, [64912+SI]          ; DS:SI points to sample head.

                Test    Byte Ptr [SI+12h], 1    ; Check if sample is present.
                JZ      D_SaveIT19
                Cmp     DWord Ptr [SI+30h], 0   ; For bodgy sample crap.
                JZ      D_SaveIT19

D_SaveIT21:
                Push    DS              ; DS:DX points to sample...
                Push    SI

                Push    CS
                Pop     DS
                Mov     DI, (4+21*80)*2
                Mov     SI, Offset SampleMsg
                Mov     AX, BP
                Inc     AX
                Push    AX
                Mov     AH, 5
                Call    S_DrawString
                Pop     AX

                Pop     SI
                Pop     DS                      ; Sample encoding to go here..
                                                ; But sample position needs to
                                                ;  be recoded then...
                Cmp     CS:SaveFormat, 2
                JNE     D_SaveSampleDataCompressedCall

                Call    D_SaveSampleData
                Jmp     D_SaveIT19

D_SaveSampleDataCompressedCall:
                Call    D_SaveSampleDataCompressed

D_SaveIT19:
                Pop     DI
                Pop     DS

                Add     DI, 80

                Inc     BP
                Cmp     BP, [ES:24h]
                JB      D_SaveIT18

                Call    WriteITSampleBlock

                Mov     AH, 3Eh                 ; Close file
                Int     21h

                Push    CS
                Pop     DS
                Mov     DI, (4+23*80)*2
                Mov     SI, Offset CompleteMsg
                Mov     AH, 5
                Call    S_DrawString

EndSaveModule:
                Mov     DX, Offset SaveFileName
                Call    D_DeleteIfError

                Call    PE_RestoreCurrentPattern

                Cmp     NoSaveError, 0
                JNE     SaveModuleError

                Call    PEResetModified

SaveModuleError:
                Mov     AX, 1
                Ret

EndP            D_SaveIT
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            D_SaveS3M Far

                Call    PE_SaveCurrentPattern
                Call    D_UpdateFileName

                Mov     BP, 60h                 ; BP = length of header.
;                Call    PE_StoreCurrentPattern

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SaveFormatError, 0

                Mov     NoSaveError, 0

                Mov     AH, 3Ch
                Xor     CX, CX                  ; File type is normal (archive)
                Mov     DX, Offset SaveFileName ; DS:DX points to filename
                Int     21h
                JNC     D_SaveS3M1

                Call    PE_RestoreCurrentPattern
                Jmp     D_NoSaveMessage

D_SaveS3M1:
                Mov     BX, AX

                Mov     ES, DiskDataArea
                Call    Music_GetSongSegment
                Mov     DS, AX
                        Assume DS:Nothing       ; DS = MusicData

                Mov     SI, 4
                Xor     DI, DI
                Mov     CX, 26/2
                Rep     MovsW
                Xor     AX, AX
                StosW
                Mov     AX, 1Ah+16*256          ; St3 module identification.
                StosW
                Xor     AX, AX
                StosW
                                                ; Now to figure out the
                                                ; orders.
                Mov     SI, 511
                StD
                Mov     CX, 256

D_SaveS3M2:
                LodsB
                Cmp     AL, 0FFh
                LoopE   D_SaveS3M2

                ClD

                Inc     CX
                Mov     AX, CX
                Inc     AX                      ; Number of orders.
                Add     BP, AX
                StosW

                Call    Music_GetNumberOfSamples
                Add     BP, AX
                Add     BP, AX
                StosW                           ; Number of samples.

                Call    PE_GetMaxPattern
                Inc     AX
                Add     BP, AX
                Add     BP, AX
                Cmp     AX, 100
                JBE     D_SaveS3M4

                Mov     AX, 100

                Push    Offset D_SaveS3M4
                Push    SI
                Push    DI
                Mov     SI, Offset TooManyPatternsMsg
                Mov     DI, (4+23*80)*2
                Jmp     D_SaveS3MFormatError

D_SaveS3M4:
                StosW           ; Number of patterns

                                ; Flags... 8 = vol0opt on.
                Mov     AX, [DS:2Ch]
                And     AX, 2
                ShL     AX, 2
                StosW           ; Flags stored.

                Mov     AX, 3000h+TRACKERVERSION
                StosW           ; Impulse Tracker

                Mov     AX, 2
                StosW           ; Standard unsigned samples.

                Mov     EAX, 'MRCS'
                StosD           ; ID done.

                Mov     AH, [DS:2Ch]
                Test    AH, 4
                JZ      D_SaveS3MNoInsError

                Push    Offset D_SaveS3MNoInsError
                Push    SI
                Push    DI
                Mov     SI, Offset ST3InstrumentErrorMsg
                Mov     DI, (4+29*80)*2
                Jmp     D_SaveS3MFormatError

D_SaveS3MNoInsError:
                Mov     AL, [DS:30h]
                ShR     AL, 1
                StosB
                Mov     AX, [DS:32h]    ; Tempo and speed
                StosW
                Mov     AL, [DS:31h]    ; Mixing volume
                Mov     AH, [DS:2Ch]    ; Grab stereo setting.
                Cmp     AL, 80h
                JB      D_SaveNoMixOverflow

                Mov     AL, 7Fh

D_SaveNoMixOverflow:
                ShL     AL, 1
                ShR     AX, 1
                StosB

                Mov     AX, 252*256
                StosW
                Xor     AX, AX
                StosW

                Call    GetTimerCounter
                Sub     EAX, EditTimer
                Add     EAX, [DS:3Ch]

                Xor     EAX, 'JTHL'
                RoR     EAX, 4
                Neg     EAX
                RoL     EAX, 7
                Xor     EAX, 'ITRK'

                StosD

                Xor     AX, AX
                StosW

                Mov     SI, 256 ; Orders.
                Mov     DI, 60h
                JCXZ    D_SaveS3M3

D_SaveS3M5:
                LodsB
                Cmp     AL, 0FEh
                JAE     D_SaveS3M6
                Cmp     AL, 100
                JB      D_SaveS3M6

                Mov     AL, 0FFh  ; So that pattern numbers >= 100 aren't listed

D_SaveS3M6:
                StosB
                Loop    D_SaveS3M5

D_SaveS3M3:
                Mov     AL, 0FFh
                StosB

                                ; Do channel settings.
                Push    BX

                Mov     BX, BP

                Mov     SI, 40h
                Mov     DI, SI
                Sub     BX, DI

                Mov     CX, 32
                Xor     AH, AH

D_SaveS3M7:
                LodsB
                Test    AL, 80h
                JNZ     D_SaveS3M9

                Cmp     AL, 64
                JBE     D_SaveS3M8

                Mov     AL, 32          ; For surround.

D_SaveS3M8:
                                ; Convert 0->64 to 0->15
                Mov     DL, AL
                ShR     DL, 1
                Sub     DL, 1
                AdC     DL, 0
                ShR     DL, 1
                Or      DL, 32  ; Reqd...

                Mov     AL, AH

                And     AL, 1
                ShL     AL, 3
                Mov     DH, AH
                ShR     DH, 1
                Or      AL, DH

                Inc     AH
                Jmp     D_SaveS3M10

D_SaveS3M9:                     ; Muted/nonexistant
                Mov     AL, 0FFh
                Mov     DL, 0

D_SaveS3M10:
                Mov     [ES:BX+DI], DL
                StosB
                Loop    D_SaveS3M7

                Pop     BX

                Add     BP, 20h

                        ; Check that channel volumes are all 64...

                Mov     CX, 32
                Mov     SI, 80h

D_SaveS3M11:
                LodsB
                Cmp     AL, 64
                JNE     D_SaveS3M12
                Loop    D_SaveS3M11
                Jmp     D_SaveS3M13

D_SaveS3M12:
                Push    Offset D_SaveS3M13
                Push    SI
                Push    DI
                Mov     SI, Offset ChannelVolumeErrorMsg
                Mov     DI, (4+24*80)*2
                Jmp     D_SaveS3MFormatError

D_SaveS3M13:
                Test    Byte Ptr [DS:2Ch], 8
                JZ      D_SaveS3M15

                Push    Offset D_SaveS3M15
                Push    SI
                Push    DI
                Mov     SI, Offset LinearSlideMsg
                Mov     DI, (4+25*80)*2
                Jmp     D_SaveS3MFormatError

D_SaveS3M15:
                Push    DS

                Push    CS
                Pop     DS
                Mov     DI, (4+17*80)*2
                Mov     SI, Offset SampleHeaderMsg
                Mov     AH, 5
                Call    S_DrawString

                Pop     DS
                        Assume DS:Nothing

                Push    BP              ; BP = length of header.

                Xor     AX, AX          ; AX = sample number.
                Xor     DX, DX          ; DX:BP = file position.
                                        ; BX = file handle

;--------------------------------------

D_SaveS3M14:
                Push    AX

                Add     BP, 15          ; Align on next 16-byte boundary.
                AdC     DX, 0           ; Unnecessary.. but who cares.
                                        ; Now to store pointer.
                And     BP, Not 15

                Push    DX

                Mov     DI, AX
                Add     DI, DI

                Push    DI

                Add     DI, 60h
                Add     DI, [ES:20h]

                                        ; Move file pointer.
                Mov     AX, 4200h
                Mov     CX, DX
                Mov     DX, BP
                Int     21h

                SHRD    AX, DX, 4
                Mov     [ES:DI], AX

                                        ; Set up sample block at ES:1024.
                Pop     DI
                Push    BX

                Mov     BX, [DS:64912+DI] ; DS:BX points to sample header.

                Mov     DI, 1024
                Mov     AL, [BX+12h]
                Mov     DL, AL
                And     AL, 1

                StosB

                Mov     SI, BX
                Add     SI, 4
                Mov     CX, 12
                Rep     MovsB           ; filename

                Xor     AX, AX
                StosB
                StosW

                Mov     SI, BX
                Add     SI, 30h
                Mov     CX, 6
                Rep     MovsW   ; Length/Loopbeg/Loopend.

                Mov     AL, [DS:BX+13h]
                StosW           ; Default sample volume.

                Mov     AH, DL
                Mov     CL, DL
                ShR     AH, 4
                And     AX, 100h
                ShL     CL, 1
                And     CL, 4
                Or      AH, CL

                StosW           ; Loop, 16 Bit & no 'pack'

                MovsW
                MovsW

                Mov     CX, 6
                Xor     AX, AX
                Rep     StosW
                                ; Now for sample name.

                Mov     SI, BX
                Add     SI, 14h
                Mov     CX, 25

D_SaveS3M56:
                LodsB
                And     AL, AL
                JNZ     D_SaveS3M57

                Mov     AL, 32

D_SaveS3M57:
                StosB
                Loop    D_SaveS3M56

                Xor     AX, AX
                StosB
                StosW

                Mov     EAX, 'SRCS'
                StosD           ; OK header is done...

                Test    DL, 16+32
                JZ      D_SaveS3M16             ; No loop on.

                Test    DL, 32
                JNZ     D_SaveS3M51

                Test    DL, 64
                JZ      D_SaveS3M16

D_SaveS3M51:
                Push    Offset D_SaveS3M16
                Push    SI
                Push    DI
                Mov     SI, Offset LoopMsg
                Mov     DI, (4+27*80)*2
                Jmp     D_SaveS3MFormatError

D_SaveS3M16:
                Cmp     Byte Ptr [DS:BX+11h], 64
                JE      D_SaveS3M17

                Push    Offset D_SaveS3M17
                Push    SI
                Push    DI
                Mov     SI, Offset SampleVolumeMsg
                Mov     DI, (4+26*80)*2
                Jmp     D_SaveS3MFormatError

D_SaveS3M17:
                Cmp     Byte Ptr [DS:BX+4Dh], 0
                JE      D_SaveS3M18

                Push    Offset D_SaveS3M18
                Push    SI
                Push    DI
                Mov     SI, Offset SampleVibratoMsg
                Mov     DI, (4+28*80)*2
                Jmp     D_SaveS3MFormatError

D_SaveS3M18:                            ; Write block.
                Pop     BX
                Push    DS

                Push    ES
                Pop     DS
                Mov     DX, 1024
                Mov     CX, 50h
                Call    D_SaveBlock

                Pop     DS
                Pop     DX

                Add     BP, 50h         ; Advance file pointer.
                AdC     DX, 0

                Pop     AX
                Inc     AX
                Cmp     AX, [ES:22h]
                JB      D_SaveS3M14     ; Sample headers done.

;-----------------------------------
                                        ; Pattern data.
                Xor     AX, AX          ; Start with pattern 0

D_SaveS3M19:
                Push    AX
                                        ; Shove message on screen....
                Add     BP, 15          ; Align on next 16-byte boundary.
                AdC     DX, 0           ; Unnecessary.. but who cares.
                                        ; Now to store pointer.
                And     BP, Not 15

                Push    DX

                Push    AX              ; AX for pattern msg...

                Mov     DI, AX
                Add     DI, DI

                Add     DI, 60h
                Add     DI, [ES:20h]
                Mov     CX, [ES:22h]
                Add     CX, CX
                Add     DI, CX

                                        ; Move file pointer.
                Mov     AX, 4200h
                Mov     CX, DX
                Mov     DX, BP
                Int     21h

                SHRD    AX, DX, 4       ; DX:AX = new file pointer location
                Mov     [ES:DI], AX

                Push    CS
                Pop     DS

                Mov     DI, (4+18*80)*2
                Mov     SI, Offset PatternMsg
                Mov     AH, 5
                Call    S_DrawString

                Pop     AX              ; AX = pattern.
                Call    Music_GetPattern        ; DS:SI points to pattern.

                Mov     CX, [SI+2]      ; CX = length.
                Cmp     CX, 64
                JE      D_SaveS3M20

                Push    Offset D_SaveS3M20
                Push    SI
                Push    DI
                Mov     SI, Offset PatternLengthMsg
                Mov     DI, (4+30*80)*2
                Jmp     D_SaveS3MFormatError

D_SaveS3M20:
                Push    BX

                Push    CX

                Mov     DI, 20000
                Mov     CX, 64

D_SaveS3M25:
                Mov     AX, 0FD00h      ; Mask & note.
                StosW
                Mov     AH, 0FFh        ; instrument & volume.
                StosW
                Xor     AH, AH
                StosW
                StosW
                Loop    D_SaveS3M25

                Mov     DI, 30002
                Add     SI, 8

                Pop     CX
                Push    CX

D_SaveS3M22:                            ; Pattern translation time.
                Push    CX

D_SaveS3M33:
                LodsB
                And     AL, AL
                JZ      D_SaveS3M23

                Mov     DL, AL
                And     AX, 7Fh
                Dec     AX
                Mov     CL, 3
                ShL     AX, CL
                Mov     BX, AX
                Add     BX, 20000       ; ES:BX points to old information.
                                        ; Decode row into area.

                Mov     DH, [ES:BX]

                Test    DL, 80h
                JZ      D_SaveS3M24

                LodsB                   ; Mask
                Mov     [ES:BX], AL
                Mov     DH, AL

D_SaveS3M24:
                Test    DH, 1
                JZ      D_SaveS3M26

                LodsB
                Mov     [ES:BX+1], AL

D_SaveS3M26:
                Test    DH, 2
                JZ      D_SaveS3M27

                LodsB
                Mov     [ES:BX+2], AL

D_SaveS3M27:
                Test    DH, 4
                JZ      D_SaveS3M28

                LodsB
                Cmp     AL, 64
                JA      D_SaveS3MPanError

D_SaveS3M28_2:
                Mov     [ES:BX+3], AL   ; Volume

D_SaveS3M28:
                Test    DH, 8
                JZ      D_SaveS3M29

                LodsW                   ; Effect+value.
                Mov     [ES:BX+4], AX

D_SaveS3M29:
                And     DL, 7Fh
                Cmp     DL, NUMS3MCHANNELS
                JA      D_SaveS3M30

                Dec     DX
                Test    DH, 33h
                JZ      D_SaveS3M31

                Or      DL, 32

D_SaveS3M31:
                Test    DH, 44h
                JZ      D_SaveS3M32

                Or      DL, 64  ; Volume

D_SaveS3M32:
                Test    DH, 88h
                JZ      D_SaveS3M34

                Or      DL, 128 ; Effect.

D_SaveS3M34:
                                        ; Check if note in range.
                Mov     AX, [ES:BX+1]
                Mov     [ES:BX+6], AX   ; BX+6=note, BX+7=ins.

                Cmp     AL, 120
                JAE     D_SaveS3M55

                Test    DH, 11h
                JZ      D_SaveS3M55
                Test    DH, 22h
                JZ      D_SaveS3M55

                Push    DS

                Call    Music_GetSongSegment
                Mov     DS, AX
                Test    Byte Ptr [DS:2Ch], 4
                JZ      D_SaveS3M54

                Push    BX
                Push    DI

                Mov     DI, BX

                Mov     BL, [ES:BX+7]
                And     BX, 0FFh        ; BX = ins.
                JZ      D_SaveS3M52

                Add     BX, BX
                Mov     BX, [BX+64712-2] ; BX points to instrument.
                Mov     AL, [ES:DI+1]
                And     AX, 0FFh
                Add     AX, AX
                Add     BX, AX
                Mov     AX, [BX+40h]

                Mov     [ES:DI+6], AX

D_SaveS3M52:
                Pop     DI
                Pop     BX

D_SaveS3M54:
                Pop     DS

D_SaveS3M55:
                Mov     AL, DL

                Test    DL, 32          ; Do note?
                JZ      D_SaveS3M35

                Mov     AH, [ES:BX+6]   ; AH = note.
                Cmp     AH, 0FDh
                JAE     D_SaveS3M35
                Cmp     AH, 12
                JB      D_SaveS3M36     ; Note out of range.
                Cmp     AH, 108
                JAE     D_SaveS3M36

D_SaveS3M35:
                StosB                   ; Store mask.
                Test    DL, 32
                JZ      D_SaveS3M39

                Mov     AL, 0FFh
                Test    DH, 11h
                JZ      D_SaveS3M37

                Cmp     AH, 0FDh
                JE      D_SaveS3M37

                Mov     AL, 0FEh
                Cmp     AH, 0FEh
                JAE     D_SaveS3M37

                Mov     AL, AH
                Xor     AH, AH
                Sub     AL, 12
                Mov     CX, 12*256+4
                Div     CH              ; AL = octave, AH = note.
                ShL     AL, CL
                Or      AL, AH

D_SaveS3M37:
                Mov     AH, 0
                Test    DH, 22h
                JZ      D_SaveS3M50

                Mov     AH, [ES:BX+7]

D_SaveS3M50:
                StosW

D_SaveS3M39:
                Test    DL, 64
                JZ      D_SaveS3M40

                Mov     AL, [ES:BX+3]
                StosB

D_SaveS3M40:
                Test    DL, 128
                JZ      D_SaveS3M41

                Mov     AX, [ES:BX+4]

;                Cmp     AL, 'H'-'@'
;                JE      D_SaveVibDepth1
;                Cmp     AL, 'U'-'@'
;                JE      D_SaveVibDepth2
;
                Cmp     AX, 'S'-'@'+9100h
                JE      D_SaveS3MSurround

                Cmp     AL, 'V'-'@'
                JE      D_SaveS3M46
                Cmp     AL, 'X'-'@'
                JE      D_SaveS3M46

                Cmp     AL, 'C'-'@'
                JNE     D_SaveS3M47

                Mov     AL, AH
                Xor     AH, AH
                Mov     CX, 10*256+4
                Div     CH
                ShL     AL, CL
                Or      AH, AL
                Mov     AL, 'C'-'@'
                Jmp     D_SaveS3M47

D_SaveS3MSurround:
                Mov     AX, 'X'-'@'+0A400h
                Jmp     D_SaveS3M47

D_SaveS3M46:
                ShR     AH, 1

D_SaveS3M47:
                StosW

D_SaveS3M41:
                Jmp     D_SaveS3M33

; D_SaveVibDepth1:                                ; Command H
;                Mov     CL, AH
;                And     AH, 0Fh
;                And     CL, 0F0h
;                Inc     AH
;                ShR     AH, 1
;                Or      AH, CL
;
;                StosW
;                Jmp     D_SaveS3M33
;
;D_SaveVibDepth2:
;                Mov     CL, AH
;                And     AH, 0Fh                 ; AH = depth
;                Inc     AH
;                ShR     AH, 1
;                And     CL, 0F0h
;                Or      AH, CL
;
;                StosW
;                Jmp     D_SaveS3M33

D_SaveS3MPanError:
                Mov     AL, 0FFh
                Mov     Byte Ptr [ES:BX+3], AL          ; Volume

                Push    Offset D_SaveS3M28_2
                Push    SI
                Push    DI
                Mov     SI, Offset PanningErrorMsg
                Mov     DI, (4+33*80)*2
                Jmp     D_SaveS3MFormatError

D_SaveS3M30:
                Push    Offset D_SaveS3M33
                Push    SI
                Push    DI
                Mov     SI, Offset ChannelErrorMsg
                Mov     DI, (4+31*80)*2
                Jmp     D_SaveS3MFormatError

D_SaveS3M36:
                Push    Offset D_SaveS3M33
                Push    SI
                Push    DI
                Mov     SI, Offset NoteRangeMsg
                Mov     DI, (4+32*80)*2
                Jmp     D_SaveS3MFormatError

D_SaveS3M23:
                StosB
                Pop     CX
                Loop    D_SaveS3M22

                Pop     CX
                Pop     BX
                Sub     CX, 64
                JNC     D_SaveS3M21

                Neg     CX
                Xor     AL, AL
                Rep     StosB

D_SaveS3M21:
                Mov     CX, DI
                Sub     CX, 30000
                Mov     [ES:30000], CX  ; Pattern length.

                Push    ES
                Pop     DS
                Mov     DX, 30000
                Call    D_SaveBlock

                Pop     DX

                Add     BP, CX
                AdC     DX, 0

                Pop     AX
                Inc     AX
                Cmp     AX, [ES:24h]
                JB      D_SaveS3M19

;-----------------------------------
                                        ; Now to save samples.
                Mov     DI, 10000
                Mov     CX, 200         ; ES:10000 contains sample pointers.
                Xor     AX, AX
                Rep     StosW

D_SaveS3M42:
                Inc     AX
                Push    AX

                Xor     CX, CX
                Call    Music_GetSampleLocation ; Gets DS:SI, ECX
                JC      D_SaveS3M43

                JZ      D_SaveS3M8Bit

                Add     ECX, ECX

D_SaveS3M8Bit:
                Push    DS
                Push    AX

                Push    CS
                Pop     DS
                Mov     DI, (4+19*80)*2
                Mov     SI, Offset SampleMsg
                Mov     AH, 5
                Call    S_DrawString

                Pop     AX
                Pop     DS

                                        ; Shove message on screen....
                Add     BP, 15          ; Align on next 16-byte boundary.
                AdC     DX, 0
                And     BP, Not 15

                Push    ECX
                Push    DX
                Push    AX              ; AX = sample num

                Mov     DI, AX
                Dec     DI
                Add     DI, DI
                Add     DI, DI
                Add     DI, 10000
                Mov     AX, BP
                StosW
                Mov     AX, DX
                StosW


                Mov     AX, 4200h
                Mov     CX, DX
                Mov     DX, BP
                Int     21h             ; Set file offset.

                Pop     AX

                Call    D_SaveSampleDataConvert

                Pop     DX
                Pop     ECX
                Add     BP, CX
                PushF
                ShR     ECX, 16
                PopF
                AdC     DX, CX

D_SaveS3M43:
                Pop     AX
                Cmp     AX, [ES:22h]
                JB      D_SaveS3M42

;-----------------------------------

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     DI, (4+20*80)*2
                Mov     SI, Offset HeaderMsg
                Mov     AH, 5
                Call    S_DrawString

                Mov     AX, 4200h
                Xor     CX, CX
                Xor     DX, DX
                Int     21h             ; Go back to start of file.

                Push    ES
                Pop     DS
                Xor     DX, DX
                Pop     CX              ; CX = length of header. (previously BP)
                Call    D_SaveBlock

                                        ; To do sample pointers now.
                Mov     SI, 10000
                Xor     BP, BP

D_SaveS3M44:
                Mov     DI, BP
                Add     DI, DI
                Add     DI, 60h ; Length of header
                Add     DI, [DS:20h]    ; Past Orders, DS:SI points to parasample

                Xor     CX, CX
                Mov     DX, [DI]
                SHLD    CX, DX, 4
                ShL     DX, 4

                Add     DX, 0Dh

                Mov     AX, 4200h
                Int     21h             ; file re-position.

                LodsW
                Mov     DX, AX
                LodsW                   ; AX:DX contains sample pointer.

                ShRD    DX, AX, 4
                ShR     AX, 4           ; AX:DX contains para pointer.

                Mov     [DS:0], AL
                Mov     [DS:1], DX
                Mov     CX, 3
                Xor     DX, DX
                Call    D_SaveBlock

                Inc     BP
                Cmp     BP, [DS:22h]
                JB      D_SaveS3M44

                Mov     AH, 3Eh         ; Close file.
                Int     21h

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     DI, (4+21*80)*2
                Mov     SI, Offset CompleteMsg
                Mov     AH, 5
                Call    S_DrawString

                Cmp     SaveFormatError, 0
                JE      D_SaveS3M_NoKeyWait

                Call    K_ClearKeyboardQueue

D_SaveS3MKeyWait:
                Call    K_GetKey
                Test    CH, 1
                JZ      D_SaveS3MKeyWait

D_SaveS3M_NoKeyWait:
                Jmp     EndSaveModule

D_SaveS3MFormatError:
                Push    AX
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SaveFormatError, 1
                Mov     AH, 4
                Call    S_DrawString

                Pop     DS
                Pop     AX
                Pop     DI
                Pop     SI
                RetN

EndP            D_SaveS3M
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            D_SaveFileITModule Far

                Mov     SI, 1
                Mov     CX, Object1
                Mov     DX, Offset O1_SaveITList

                Mov     AX, 5
                Ret

EndP            D_SaveFileITModule

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            D_SaveFileS3MModule Far

                Mov     SI, 1
                Mov     CX, Object1
                Mov     DX, Offset O1_SaveS3MList

                Mov     AX, 5
                Ret

EndP            D_SaveFileS3MModule


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

