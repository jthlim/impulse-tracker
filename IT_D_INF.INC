

Proc            D_GetSongNameModuleType

                LEA     DI, [SI+17]             ; ES:DI points to deposit point.
                Sub     SI, 8

                Cmp     DWord Ptr [DS:60000], 'MPMI'
                JNE     D_GetSongNameModuleType1

                Mov     DX, [DS:60000+2Ah]
                Mov     AX, 3

                Cmp     DX, TRACKERVERSION
                JA      D_GSNMTImpulse1

                Dec     AX
                Cmp     DX, 214h
                JB      D_GSNMTImpulse1

                Mov     AX, 7

D_GSNMTImpulse1:
                Mov     Word Ptr [SI+23], AX

                Mov     SI, 60004
                Mov     CX, 25
                Rep     MovsB

                Ret

D_GetSongNameModuleType1:
;                Cmp     Word Ptr [DS:60028], 101Ah
;                JNE     D_GetSongNameModuleType2

                Cmp     DWord Ptr [DS:60044], 'MRCS'
                JNE     D_GetSongNameModuleType2

                Mov     Word Ptr [SI+23], 4

                Mov     SI, 60000
                Mov     CX, 25
                Rep     MovsB

                Ret

D_GetSongNameModuleType2:
                Push    SI ES DI

                Push    CS
                Pop     ES
                Mov     SI, 60000
                Mov     DI, Offset XMIdentification
                Mov     CX, 17
                RepE    CmpsB

                Pop     DI ES SI
                JNE     D_GetSongNameModuleTypeNotXM

                Mov     Word Ptr [SI+23], 5     ; XM

                Mov     SI, 60000+17
                Mov     CX, 20
                Rep     MovsB
                Xor     AX, AX
;                Mov     CX, 5
;                Rep     StosB
                Ret

D_GetSongNameModuleTypeNotXM:
                Mov     AX, [DS:60000]
                Cmp     AX, 'fi'
                JE      D_GetSongNameModuleType669
                Cmp     AX, 'NJ'
                JNE     D_GetSongNameModuleTypeNot669

D_GetSongNameModuleType669:     ; We have a 669 module!
                Mov     Word Ptr [SI+23], 6     ; 669
                Mov     SI, 60000+2
                Mov     CX, 25
                Rep     MovsB
                Ret

D_GetSongNameModuleTypeNot669:
                Mov     EAX, [DS:61080]

                Cmp     EAX, '.K.M'
                JNE     D_GetSongNameModuleType3

                Mov     Word Ptr [SI+23], 9
                Jmp     D_GSNMTMod

D_GetSongNameModuleType3:
                Cmp     EAX, '!K!M'
                JNE     D_GetSongNameModuleType4

                Mov     Word Ptr [SI+23], 10
                Jmp     D_GSNMTMod

D_GetSongNameModuleType4:
                Cmp     EAX, 'NHC4'
                JNE     D_GetSongNameModuleType5

                Mov     Word Ptr [SI+23], 11
                Jmp     D_GSNMTMod

D_GetSongNameModuleType5:
                Cmp     EAX, 'NHC6'
                JNE     D_GetSongNameModuleType6

                Mov     Word Ptr [SI+23], 12
                Jmp     D_GSNMTMod

D_GetSongNameModuleType6:
                Cmp     EAX, 'NHC8'
                JNE     D_GetSongNameModuleType11

                Mov     Word Ptr [SI+23], 13
                Jmp     D_GSNMTMod

D_GetSongNameModuleType11:
                Cmp     Word Ptr [DS:61082], 'HC'
                JNE     D_GetSongNameModuleType7
                Cmp     AL, '0'
                JB      D_GetSongNameModuleType7
                Cmp     AL, '9'
                JA      D_GetSongNameModuleType7
                Cmp     AH, '0'
                JB      D_GetSongNameModuleType7
                Cmp     AH, '9'
                JA      D_GetSongNameModuleType7

                                                        ; Generic MOD type.
                Sub     AX, '00'
                Mov     BL, AH
                Mov     AH, 10
                Mul     AH
                Add     BL, AL
                Mov     Word Ptr [SI+23], 17
                Mov     Byte Ptr [SI+22], BL

                Jmp     D_GSNMTMod


D_GetSongNameModuleType7:
                Cmp     EAX, '4TLF'
                JNE     D_GetSongNameModuleType8

                Mov     Word Ptr [SI+23], 14
                Jmp     D_GSNMTMod

D_GetSongNameModuleType8:
;                 Cmp     EAX, '8TLF'
;                 JNE     D_GetSongNameModuleType9
;
;                 Mov     Word Ptr [SI+23], 15
;                 Jmp     D_GSNMTMod
;
; D_GetSongNameModuleType9:
                Cmp     Byte Ptr [DS:60000+471], 78h
                JNE     D_GetSongNameModuleType10

                Mov     Word Ptr [SI+23], 16
                Jmp     D_GSNMTMod

D_GetSongNameModuleType10:
                Cmp     Word Ptr [DS:60000], 'M'+256*'T'
                JNE     D_GetSongNameModuleType12
                Cmp     Byte Ptr [DS:60002], 'M'
                JNE     D_GetSongNameModuleType12

                Mov     Word Ptr [SI+23], 18

                Mov     SI, 60004
                Mov     CX, 20
                Rep     MovsB
                Mov     CX, 5
                Xor     AL, AL
                Rep     StosB

D_GetSongNameModuleType12:
                Mov     Word Ptr [SI+23], 1

                Ret

D_GSNMTMod:
                Mov     SI, 60000
                Mov     CX, 20
                Rep     MovsB
                Xor     AX, AX
                StosW
                StosW
                StosB

                Ret

EndP            D_GetSongNameModuleType

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_GetInstrumentInfo     ; Instrument layout
                                        ; 48 bytes per instrument.
                                        ; Offset 0 = type of file.
                                                ; 0 = Unchecked
                                                ; 1 = Directory
                                                ; 2 = Unrecognised
                                                ; 3 = ITI
                                                ; 4 = XI
                                                ; 8 = .IT
                                                ; 9 = .XM
                                        ; Offset 1 = file name
                                        ; 15->40 is the instrument name,
                                        ; 40 = No. Samples
                                        ; 42 = File size.
                                        ; 44 = file offset (DWord)

                Mov     AX, 48
                Mul     BX
                Mov     DI, AX

                Mov     DS, CS:DiskDataArea
                Mov     SI, 60000

                                                ; Check for XM
                Push    CS
                Pop     ES

;                Comment ~

                Push    DI
                Mov     DI, Offset XMIdentification
                Mov     CX, 17
                RepE    CmpSB
                Pop     DI

                Mov     AL, 9
                JE      D_InModuleInstrument    ; XM module found?

                Mov     SI, 60000

                Cmp     DWord Ptr [SI], 'MPMI'  ; Impulse Tracker module?
                JNE     D_GetInstrumentInfoNotIT
                Cmp     Word Ptr [SI+22h], 0
                JE      D_GetInstrumentInfoNotIT
                Test    Byte Ptr [SI+2Ch], 4    ; Instrument mode?
                JZ      D_GetInstrumentInfoNotIT

                Mov     AL, 8

D_InModuleInstrument:
                Push    DS
                Pop     ES

                StosB
                Add     DI, 14
                Push    CS
                Pop     DS
                Mov     SI, Offset LibraryMsg
                Mov     CX, 25
                Rep     MovsB
                Xor     AX, AX

                Ret

D_GetInstrumentInfoNotIT:
;                ~

                Cmp     DWord Ptr [SI], 'IPMI'
                JNE     D_GetInstrumentInfo1

                Push    DS
                Pop     ES
                Mov     Byte Ptr [DI], 3

                Mov     AL, [SI+1Eh]
                Xor     AH, AH

                Add     DI, 15
                Add     SI, 20h
                Mov     CX, 25
                Rep     MovsB

                StosW                   ; NOS.

                ClC
                Ret

D_GetInstrumentInfo1:                   ; Check for XI
                Push    DI

                Mov     DI, Offset XIIdentification
                Mov     CX, 21
                RepE    CmpsB

                Pop     DI
                JNE     D_GetInstrumentInfo2

D_GetInstrumentInfoXI:
                Push    DS
                Pop     ES

                Mov     Byte Ptr [DI], 4        ; XI
                Add     DI, 15
                Mov     CX, 22
                Rep     MovsB
                Xor     AX, AX
                StosW
                StosB
                Mov     AX, [DS:60000+128h]     ; AX = number of samples
                StosW                   ; NoS
                Ret

D_GetInstrumentInfo2:
                Push    DS
                Pop     ES

                Mov     SI, DI
                Mov     CX, 48
                Mov     AX, CS:NumInstruments
                Sub     AX, BX
                Add     SI, CX
                Mul     CX
                Mov     CX, AX
                Rep     MovsB

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Dec     NumInstruments

                Mov     AX, CurrentInstrument
                Cmp     AX, NumInstruments
                JAE     D_GetInstrumentInfo3

                Cmp     AX, BX
                JBE     D_GetInstrumentInfoEnd

D_GetInstrumentInfo3:
                Sub     AX, 1
                AdC     AX, 0

D_GetInstrumentInfoEnd:
                Mov     CurrentInstrument, AX

                StC
                Ret

EndP            D_GetInstrumentInfo

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            D_GetSampleInfo                 ; BX = sample num.

                Mov     AX, 96
                Mul     BX
                Mov     DI, AX
                Mov     BX, AX
                Mov     DS, CS:DiskDataArea
                Mov     SI, 60000
                Push    DS
                Pop     ES                      ; ES:DI points to sample block
                                                ; DS:SI points to header

                Mov     Byte Ptr [BX+90], 2   ; Recognised sample default.

                Cmp     DWord Ptr [DS:60000], 'SPMI'
                JE      D_GetSampleInfo1        ; Possibly a IT sample.
                Cmp     DWord Ptr [DS:60000+4Ch], 'SRCS'
                JE      D_GetSampleInfo4
                Cmp     DWord Ptr [DS:60000], 'FFIR'
                JE      D_GetSampleInfo8        ; AIFF?
                Cmp     DWord Ptr [DS:60000], 'MROF'
                JE      D_GetSampleInfo13

                Mov     AL, 21h
                Cmp     DWord Ptr [DS:60000], 'MPMI'
                JE      D_GetSampleInfoModuleTypes1

                Mov     AL, 23h
                Cmp     DWord Ptr [DS:60000+44], 'FMTP'
                JE      D_GetSampleInfoModuleTypes1

                Inc     AX                      ; AL = 24h
                Mov     ECX, [DS:60000]
                And     ECX, 0FFFFFFh
                Cmp     ECX, 'M'*10000h+'T'*100h+'M'
                JE      D_GetSampleInfoModuleTypes1

                Inc     AX                      ; AL = 25h
                Cmp     Word Ptr [DS:60000], 'fi'
                JE      D_GetSampleInfoModuleTypes1
                Cmp     Word Ptr [DS:60000], 'NJ'
                JE      D_GetSampleInfoModuleTypes1

                Inc     AX                      ; AL = 26h
                Cmp     DWord Ptr [DS:60000], 'þRAF'
                JE      D_GetSampleInfoModuleTypes1

                Mov     ECX, [DS:60000+1080]
                Mov     AX, 427h             ; MOD Module + 4 channels
                Cmp     ECX, '.K.M'
                JE      D_GetSampleInfoModuleTypes1
                Cmp     ECX, '!K!M'
                JE      D_GetSampleInfoModuleTypes1
                Cmp     ECX, '4TLF'
                JE      D_GetSampleInfoModuleTypes1
                Cmp     ECX, 'NHC4'
                JE      D_GetSampleInfoModuleTypes1

                Mov     AH, 6           ; 6 Channel
                Cmp     ECX, 'NHC6'
                JE      D_GetSampleInfoModuleTypes1

                Mov     AH, 8
                Cmp     ECX, 'NHC8'
                JE      D_GetSampleInfoModuleTypes1
                Cmp     ECX, '8TLF'
                JE      D_GetSampleInfoModuleTypes1

                Cmp     Word Ptr [DS:61082], 'HC'
                JNE     D_GetSampleInfoS3M

                Sub     CX, '00'
                Cmp     CL, 9
                JA      D_GetSampleInfoS3M
                Cmp     CH, 9
                JA      D_GetSampleInfoS3M
                Mov     AL, 10
                Mul     CL
                Add     AL, CH
                Mov     AH, AL
                Mov     AL, 28h
                Jmp     D_GetSampleInfoModuleTypes1

D_GetSampleInfoS3M:
                Cmp     DWord Ptr [DS:60000+2Ch], 'MRCS'
                JNE     D_GetSampleInfoModuleTypes3

                Mov     AL, 20h                 ; ST3?
                Jmp     D_GetSampleInfoModuleTypes1
;                Cmp     Word Ptr [DS:60000+1Ch], 101Ah
;                JE      D_GetSampleInfoModuleTypes1
;                Jmp     D_GetSampleInfoModuleTypes3

D_GetSampleInfoModuleTypes3:                    ; KRZ
                Cmp     DWord Ptr [DS:60000], 'MARP'
                JNE     D_GetSampleInfoNotKRZ

                Cmp     Word Ptr [DS:60000+32], 0FFFFh
                JNE     D_GetSampleInfoNotKRZ

        ; Check filename for .KRZ

                LEA     SI, [BX+4]
                Mov     CX, 9

D_CheckKRZFileName:
                Cmp     Byte Ptr [SI], 0
                JE      D_GetSampleInfoNotKRZ

                Cmp     DWord Ptr [SI], 'ZRK.'
                JE      D_FoundKRZ

                Inc     SI
                Loop    D_CheckKRZFileName
                Jmp     D_GetSampleInfoNotKRZ

D_FoundKRZ:
                Mov     AL, 29h
                Jmp     D_GetSampleInfoModuleTypes1

D_GetSampleInfoNotKRZ:                                  ; FT2 check
                Push    SI
                Push    ES
                Push    DI

                Push    CS
                Pop     ES
                Mov     DI, Offset GUSPATIdentification
                Mov     CX, 22
                RepE    CmpsB

                Pop     DI
                Pop     ES
                Pop     SI
                JNE     D_GetSampleInfoNotPAT

                Cmp     Byte Ptr [DS:60000+198], 1
                JE      G_GetSampleInfoPAT

                Mov     AL, 2Ah
                Jmp     D_GetSampleInfoModuleTypes1

G_GetSampleInfoPAT:
                Mov     Byte Ptr [BX+88], 16

                Mov     EAX, 'SPMI'
                StosD
                Mov     SI, DI
                Add     DI, 13
                Mov     AL, 64
                StosB                           ; Global vol = 64

                Mov     AX, 4001h               ; sample present
                Mov     DL, [DS:60000+239+55]   ; modes

                Test    DL, 1                   ; 8/16 bit
                JZ      GetSampleInfoPATSamples2

                Or      AL, 2

GetSampleInfoPATSamples2:
                Test    DL, 4   ; Looping enabled?
                JZ      GetSampleInfoPATSamples3

                Or      AL, 10h

GetSampleInfoPATSamples3:
                Test    DL, 8   ; Ping pong loops?
                JZ      GetSampleInfoPATSamples4

                Or      AL, 40h

GetSampleInfoPATSamples4:
                StosW                   ; OK.. now for name.

                Mov     SI, 60000+131
                Mov     CX, 16

GetSampleInfoPATSamples5:
                LodsB
                Test    AL, AL
                JZ      GetSampleInfoPATSamples6
                StosB
                Loop    GetSampleInfoPATSamples5

                Xor     AL, AL

GetSampleInfoPATSamples6:
                Add     CX, 10
                Rep     StosB

                ; Convert, default pan

                Mov     AH, 32
                Mov     AL, [DS:60000+239+55]
                And     AL, 2
                ShR     AL, 1
                Xor     AL, 1
                StosW

                ; Length.

                Mov     DL, [DS:60000+239+55]

                Mov     EAX, [DS:60000+239+16]      ; LoopEnd -> FileSize
                Mov     [DI+20h], EAX           ; File size
                Call    StorePATLength

                Mov     EAX, [DS:60000+239+12]      ; LoopBeg
                Call    StorePATLength
                Mov     EAX, [DS:60000+239+16]      ; LoopEnd
                Call    StorePATLength

                Mov     AX, [DS:60000+239+20]
                And     EAX, 0FFFFh

Comment ~
                Push    ES DI

                Call    Music_GetPitchTable     ; Returns ES:DI
                Mov     BP, [DS:60000+239+56]
                And     BP, 0FFh
                ShL     BP, 2
                Mul     DWord Ptr [ES:DI+BP]
                SHRD    EAX, EDX, 16

                Pop     DI ES
~
                StosD                           ; C5Spd

                Xor     EAX, EAX
                StosD
                StosD

                Mov     EAX, 14Fh
                StosD

                Xor     AX, AX
                StosW
                StosW

                Ret


D_GetSampleInfoNotPAT:
                Push    SI
                Push    ES
                Push    DI

                Push    CS
                Pop     ES
                Mov     DI, Offset XMIdentification
                Mov     CX, 17
                RepE    CmpsB

                Pop     DI
                Pop     ES
                Pop     SI
                JNE     TXWaveSampleIdentification

                Mov     AL, 22h                ; FT2

D_GetSampleInfoModuleTypes1:
                Mov     Word Ptr [BX+88], AX
                Mov     Byte Ptr [BX+90], 1

                Push    DS

                Push    CS
                Pop     DS

                Mov     SI, Offset LibraryMsg
                LEA     DI, [BX+14h]
                Mov     CX, 26/2
                Rep     MovsW

                Pop     DS
                Ret

TXWaveSampleIdentification:
                Push    SI
                Push    ES
                Push    DI

                Push    CS
                Pop     ES
                Mov     DI, Offset TXWaveIdentification
                Mov     CX, 16
                RepE    CmpSB

                Pop     DI
                Pop     ES
                Pop     SI
                                                ; OK.. have a TX Wave.
                                                ; Now to transfer data.
                JNE     D_GetSampleInfo2

                Mov     AL, [DS:60000+16h]
                And     AL, 7Fh
                Cmp     AL, 49h
                JNE     D_GetSampleInfo2

                Mov     Byte Ptr [BX+88], 13

                Mov     EAX, 'SPMI'
                StosD
                Mov     SI, DI
                Add     DI, 13
                Mov     AL, 64
                StosB                           ; Global vol = 64

                Mov     AX, 64*256+1+2          ; Flag = sample + 16 bit
                                                ; Default volume = 64
                Cmp     Byte Ptr [DS:60000+16h], 049h
                JNE     D_GetTXInfo3

                Or      AL, 10h                 ; Loop forwards

D_GetTXInfo3:
                StosW

                Mov     CX, 13

D_GetTXInfo1:
                LodsB
                Test    AL, AL
                JZ      D_GetTXInfo2

                StosB
                Loop    D_GetTXInfo1

D_GetTXInfo2:
                Xor     AL, AL
                Rep     StosB

                Mov     CX, 13
                Rep     StosB
                                                ; Length...
                Mov     AX, 16+1                ; TX Wave, signed
                StosW

                Mov     EDX, [DS:60000+18h]
                Mov     ECX, [DS:60000+1Bh]
                And     EDX, 1FFFFh             ; Attack length
                And     ECX, 1FFFFh             ; Loop Length

                Mov     EAX, ECX
                Add     EAX, EDX                ; Length
                StosD
                Mov     EAX, EDX                ; LoopStart
                StosD
                Add     EAX, ECX                ; LoopEnd
                StosD

                Mov     EAX, 33000              ; Freq
                Cmp     Byte Ptr [DS:60000+17h], 2
                JB      D_GetTXInfo4

                Mov     AX, 50000
                JE      D_GetTXInfo4

                Mov     AX, 16000

D_GetTXInfo4:
                StosD                           ; Frequency
                Xor     EAX, EAX
                StosD
                StosD
                Mov     AX, 20h
                StosD
                Xor     AX, AX
                StosD

                Ret

D_GetSampleInfo2:
                Mov     DWord Ptr [BX+88], 30004h  ; Unknown Type

                Mov     EAX, 'SPMI'             
                StosD
                Mov     SI, DI
                Add     DI, 13
                Mov     AL, 64
                StosB                           ; Global vol = 64
                Mov     AL, 1
                StosB                           ; Flag = sample.
                Mov     AL, 64
                StosB                           ; Default vol = 64.

                Mov     CX, 13

D_GetSampleInfo6:
                LodsB
                Test    AL, AL
                JZ      D_GetSampleInfo7

                StosB
                Loop    D_GetSampleInfo6

D_GetSampleInfo7:
                Xor     AL, AL
                Rep     StosB

                Mov     CX, 15
                Rep     StosB
                                                ; Length...
                Mov     EAX, 4177910

                Cmp     EAX, [BX+80]
                JB      D_GetSampleInfo3

                Mov     EAX, [BX+80]

D_GetSampleInfo3:
                StosD
                Xor     AX, AX
                StosW
                StosW
                StosW
                StosW
                Mov     AX, 8363
                StosW
                Xor     AX, AX
                Mov     CX, 9
                Rep     StosW

                Ret

D_GetSampleInfo1:
                Mov     Byte Ptr [BX+88], 2

                Mov     CX, 4
                Rep     MovsB
                Add     SI, 12
                Add     DI, 12
                Mov     CX, 64
                Rep     MovsB

                Ret

D_GetSampleInfo4:
                Mov     Byte Ptr [BX+88], 3             ; Scrm

                Mov     EAX, 'SPMI'
                StosD

                Add     DI, 13
                Mov     AL, 64
                StosB

                Mov     AL, 1
                Mov     CL, [DS:60000+1Fh]
                Mov     CH, CL

                And     CL, 1
                ShL     CL, 4
                Or      AL, CL                  ; Loop...

                And     CH, 4
                ShR     CH, 1
                Or      AL, CH                  ; 16 bit.

D_GetSampleInfo5:
                StosB
                Mov     AL, [DS:60000+1Ch]
                StosB
                Mov     SI, 60000+30h
                Mov     CX, 25
                Rep     MovsB
                Xor     AX, AX
                StosB
                StosW                           ; Name done... now for length

                Mov     EAX, [DS:60000+10h]
                StosD
                Mov     EAX, [DS:60000+14h]
                StosD
                Mov     EAX, [DS:60000+18h]
                StosD
                Mov     EAX, [DS:60000+20h]            ; C5Spd
                StosD
                Xor     AX, AX
                StosW
                StosW
                StosW
                StosW
                                                ; Now for sample pointer.
                Mov     CL, 4
                Mov     AX, [DS:60000+0Eh]
                Mov     DL, [DS:60000+0Fh]
                Mov     DH, [DS:60000+0Dh]
                ShL     AX, CL
                ShR     DX, CL
                StosW                   ; Sample pointer in file.
                Mov     AX, DX
                StosW

                Xor     AX, AX                  ; Vibrato info
                StosW
                StosW

                Ret

D_GetSampleInfo8:                               ; WAV Identification
                Push    SI
                Push    DI
                Push    DS

                Push    CS
                Pop     DS
                Mov     SI, Offset WAVEfmtID
                Mov     DI, 60008
                Mov     CX, 8
                RepE    CmpsB
                JNE     NotWAV

                Add     DI, 2
                Mov     CX, 4
                RepE    CmpsB

NotWAV:
                Pop     DS

                JNE     D_GetSampleInfo9

                Mov     BP, 60000+18h
                Add     BP, [DS:60000+10h]
                Mov     CX, 3           ; Only allow 3 blocks

CheckNextWAVE:
                Cmp     DWord Ptr [DS:BP-4], 'atad'
                JE      D_GetSampleWaveFound

                Mov     AX, [DS:BP]
                Add     AX, 8
                Add     BP, AX
                JC      D_GetSampleInfo9

                Loop    CheckNextWAVE
                Jmp     D_GetSampleInfo9

D_GetSampleWaveFound:
                Mov     DL, [DS:60000+22h]         ; DL = number of bits.
                Mov     DH, 1
                Cmp     DL, 8
                JE      D_GetSampleInfo9

                Mov     DH, 3
                Cmp     DL, 16

D_GetSampleInfo9:
                Pop     DI
                Pop     SI
                JNE     D_GetSampleInfo2
                                                ; We have a WAV file!
                Cmp     Word Ptr [DS:60000+16h], 2
                JNE     D_GetSampleWAVStereo

                Or      DH, 4

D_GetSampleWAVStereo:
                Mov     AL, DH
                And     AL, 3
                Add     AL, 4
                Mov     Byte Ptr [BX+88], AL    ; 5 = 8 bit, 7 = 16 bit.

                Mov     EAX, 'SPMI'
                StosD

                Mov     SI, DI
                Add     DI, 13
                Mov     AL, 64
                StosB                           ; Global vol = 64
                Mov     AL, DH
                StosB                           ; Flag = sample.
                Mov     AL, 64
                StosB                           ; Default vol = 64.

                Mov     CX, 13

D_GetSampleInfo10:
                LodsB
                And     AL, AL
                JZ      D_GetSampleInfo11

                StosB
                Loop    D_GetSampleInfo10

D_GetSampleInfo11:
                Xor     AX, AX
                Add     CX, 13
                Rep     StosB

                Mov     AL, DH
                And     AL, 4                   ; stereo?
                ShL     AL, 3

                Test    DH, 2
                JZ      D_GetSampleInfo19

                Inc     AX

D_GetSampleInfo19:
                StosW                           ; Sample format

                Mov     EAX, 4177910            ; Length

                Cmp     EAX, [DS:BP]
                JB      D_GetSampleInfo12

                Mov     EAX, [DS:BP]

D_GetSampleInfo12:
                Test    DH, 2
                JZ      D_GetSampleInfo18

                ShR     EAX, 1

D_GetSampleInfo18:
                Test    DH, 4
                JZ      D_GetSampleWAVStereo2

                ShR     EAX, 1

D_GetSampleWAVStereo2:
                StosD

                Xor     AX, AX
                StosW
                StosW
                StosW
                StosW

                Mov     AX, [DS:60000+18h]      ; Frequency
                StosW
                Xor     AX, AX
                Mov     CX, 5
                Rep     StosW
                Mov     AX, BP
                Add     AX, 4-60000
;                Mov     AX, 2Ch
                StosW
                Xor     AX, AX
                StosW
                StosW
                StosW

                Ret

D_GetSampleInfo13:                      ; AIFF Identification
                Mov     AL, 3
                Cmp     DWord Ptr [DS:60000+8], 'VS61'
                JE      D_GetSampleInfoIFF

                Mov     AL, 1
                Cmp     DWord Ptr [DS:60000+8], 'XVS8'
                JNE     D_GetSampleInfo2

D_GetSampleInfoIFF:
                Mov     Byte Ptr [BX+88], 17    ; AIFF format.
                Mov     Byte Ptr [BX+12h], AL
                Mov     SI, 60000 + 0Ch

D_GetSampleInfoIFF1:
                Cmp     DWord Ptr [DS:SI], 'EMAN'
                JE      D_GetSampleInfoIFFName

                Cmp     DWord Ptr [DS:SI], 'RDHV'
                JE      D_GetSampleInfoIFFHeader

                Cmp     DWord Ptr [DS:SI], 'YDOB'
                JNE     D_IFFHeaderNext

                ; Body.
                Mov     DWord Ptr [DI], 'SPMI'
                Mov     Byte Ptr [DI+11h], 64   ; Global volume
                Mov     Byte Ptr [DI+13h], 64   ; Default volume
                Mov     Word Ptr [DI+2Eh], 1    ; Sign conversion

                Add     DI, 30h
                Mov     AX, [SI+06h]      ; Size
                Mov     DX, [SI+04h]
                Call    Near Ptr D_GetSampleInfoBSwap
                StosD
                Xor     EAX, EAX
                Add     DI, 0Ch
                StosD
                StosD
                StosD
                StosD

                Add     SI, 8-60000
                Mov     [BX+48h], SI

                Ret

D_GetSampleInfoIFFName:
                Push    SI
                Push    DI

                Mov     CX, [SI+6]
                XChg    CL, CH
                Cmp     CX, 25
                JBE     D_GetSampleInfoIFFName1

                Mov     CX, 25

D_GetSampleInfoIFFName1:
                Add     SI, 8
                Add     DI, 14h
                Rep     MovsB

D_IFFHeaderEnd:
                Pop     DI
                Pop     SI

D_IFFHeaderNext:
                Mov     AX, [SI+6]
                XChg    AL, AH
                Add     AX, 8
                Add     SI, AX
                JC      D_GetSampleInfo2

                Jmp     D_GetSampleInfoIFF1

D_GetSampleInfoIFFHeader:
                Push    SI
                Push    DI

                Add     DI, 34h

                Mov     AX, [SI+0Eh]      ; Loop start
                Mov     DX, [SI+0Ch]
                Call    Near Ptr D_GetSampleInfoBSwap
                StosD

                Push    EAX
                Mov     AX, [SI+12h]      ; Loop end
                Mov     DX, [SI+10h]
                Call    Near Ptr D_GetSampleInfoBSwap
                Test    EAX, EAX
                JZ      D_GetSampleInfoIFFHeader1

                Or      Byte Ptr [BX+12h], 16

D_GetSampleInfoIFFHeader1:
                Pop     EDX
                Add     EAX, EDX
                StosD

                Xor     EAX, EAX
                Mov     AX, [SI+14h]
                XChg    AL, AH
                StosD

                Jmp     D_IFFHeaderEnd

D_GetSampleInfoBSwap:
                XChg    DH, AL
                XChg    DL, AH

                ShL     EAX, 16
                Mov     AX, DX

                Test    Byte Ptr [BX+12h], 2
                JZ      D_GetSampleInfo17

                ShR     EAX, 1          ; Halve length for 16-bit samples.

D_GetSampleInfo17:
                RetN

EndP            D_GetSampleInfo

