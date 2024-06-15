;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Read module functions
;

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

IF TUTORIAL
ELSE

Proc            D_PreLoadModule                 ; Returns ES = song segment
                                                ; BX = file handle
                                                ; DS = Diskdata area
                                                ; AX = SaveFormat

;                Call    MouseUpdateEnable

IF DEFAULTFORMAT
                Test    AL, AL
                JNZ     D_PreLoadModuleTemp

                Mov     AL, DEFAULTFORMAT

D_PreLoadModuleTemp:
ENDIF
                Mov     SaveFormat, AL

                Call    I_ClearTables
                Call    Music_ReleaseAllPatterns
                Call    Music_ReleaseAllSamples
                Call    Music_ClearAllSampleNames
                Call    Music_ClearAllInstruments
                Call    Msg_ResetMessage
                Call    ReleaseTimerData

                Mov     DS, CS:DiskDataArea

                Mov     BX, CS:CurrentFile
                Add     BX, BX
                Mov     BX, [BX]
                Add     BX, 8

                Push    CS
                Pop     ES
                Mov     DI, Offset FileName             ; OK...
                Mov     SI, BX                          ; Data area no longer
                Mov     CX, 13                          ;  reqd
                Rep     MovsB

                Mov     AX, 3D00h
                Mov     DX, BX
                Int     21h
                JC      D_LoadFileOpenErrorMsg

                Mov     BX, AX                          ; BX = file handle.

                Call    Music_GetSongSegment
                Mov     ES, AX

                Ret

EndP            D_PreLoadModule

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            D_PostLoadModule Far

                Mov     AH, 3Eh                 ; Close file.
                Int     21h

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Call    CheckTimerData
                Call    GetCurrentTime

                Mov     [TopTimerData], 0

                Call    GetTimerCounter
                Mov     [EditTimer], EAX

                Call    PE_ResetOrderPattern

;                Mov     AX, 1
                Ret

EndP            D_PostLoadModule
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            D_InsertOrder           ; DX = inserting pattern, BP = current
                                        ; ES = songdata
                PushA
                Push    DS

                Push    ES
                Pop     DS

                Mov     SI, 1FFh
                Mov     AX, BP

D_InsertOrder1:
                Cmp     AL, [SI]
                JE      D_InsertOrder2

D_InsertOrderResume:
                Dec     SI
                Cmp     SI, 100h
                JAE     D_InsertOrder1

                Pop     DS
                PopA
                Ret

D_InsertOrder2:
                Push    SI
                Mov     CX, 1FEh
                Mov     DI, 1FFh
                Sub     CX, SI
                JC      D_InsertOrder3

                Mov     SI, 1FEh

                StD
                Rep     MovsB
                ClD

                Mov     AL, DL
                StosB

D_InsertOrder3:
                Pop     SI
                Jmp     D_InsertOrderResume

EndP            D_InsertOrder

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            D_LoadXM Far

                Xor     AX, AX
                Call    D_PreLoadModule
                        Assume DS:Nothing

                Mov     AH, 3Fh
                Mov     CX, 64                  ; Header length
                Mov     DX, 64000
                Int     21h

                Mov     AH, 3Fh                 ; Read rest of header.
                Mov     CX, [DS:64000+60]
                Sub     CX, 4
                Mov     DX, 64104
                Int     21h

                Mov     DI, 4
                Mov     CX, 20
                Mov     SI, 64000+17
                Rep     MovsB
                Xor     AX, AX
                Mov     CX, 5
                Rep     StosW           ; OK name transferred.

                ; Number of Instruments
                Mov     AX, [DS:64100+12]
                StosW                   ; Insnum

                Mov     AX, 1
                StosW

                ; Number of Patterns
                Mov     AX, [DS:64100+10]
                StosW
                Mov     [ES:0C0h], AX   ; Number of patterns.

                ; CWT/V, CMWT
                Add     DI, 4

                ; Flags
                Mov     AX, [DS:64100+14]
                And     AX, 1
                ShL     AX, 3
                Or      AX, 35h    ; XM Effects, Old effects, stereo, insts
                StosW

                ; Reserved
                Xor     AX, AX
                StosW

                ; GVolume. MVolume
                Mov     AX, 128+48*256
                StosW

                ; Initial Speed, Initial Tempo
                Mov     AL, [DS:64100+16]
                Test    AL, AL
                JNZ     InitialSpeedNot0

                Mov     AL, 6

InitialSpeedNot0:
                Mov     AH, [DS:64100+18]
                StosW

                ; Separation
                Mov     AX, 128
                StosW

                ; Message length, offset, timer
                Xor     AX, AX
                Mov     CX, 5
                Rep     StosW

                ; Channel Pan

                Mov     CX, [DS:64100+8]        ; Number of channels
                Mov     AL, 32
                Rep     StosB
                Mov     AL, 128+32
                Mov     CX, 64
                Sub     CX, [DS:64100+8]
                Rep     StosB

                ; Channel Volume

                Mov     AL, 64
                Mov     CX, 64
                Rep     StosB

                ; Orders
                Add     DI, 40h
                Mov     SI, 64100+20    ; Orders
                Mov     CX, [DS:64100+4]        ; Song legnth
                JCXZ    D_LoadXMNoPatterns2

D_FindMaximumPattern:
                LodsB
                Cmp     AL, 200
                JAE     D_FindMaximumPattern3

                Cmp     AL, [ES:0C0h]
                JB      D_FindMaximumPattern2

                Inc     AX
                Mov     [ES:0C0h], AX
                Dec     AX
                Jmp     D_FindMaximumPattern2

D_FindMaximumPattern3:
                Mov     AL, 0FFh

D_FindMaximumPattern2:
                StosB
                Loop    D_FindMaximumPattern

D_LoadXMNoPatterns2:
                Mov     CX, 256
                Sub     CX, [DS:64100+4]
                Mov     AL, 0FFh
                Rep     StosB

                                        ; OK.. now to load patterns.
                Cmp     Word Ptr [DS:64100+10], 0
                JE      D_LoadXMNoPatterns

                Xor     BP, BP

D_LoadXM1:
                Push    DS SI DI

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset PatternMsg
                Mov     AH, 5
                Mov     DI, (4+16*80)*2
                Push    BP
                Call    S_DrawString
                Pop     AX

                Pop     DI SI DS
                        Assume DS:Nothing

                Mov     AH, 3Fh
                Mov     CX, 4
                Xor     DX, DX
                Int     21h                     ; Read pattern length

                Mov     AH, 3Fh
                Mov     CX, [DS:0]
                Mov     DX, 4
                Sub     CX, DX
                Int     21h                     ; Read pattern header

                Cmp     Word Ptr [DS:7], 0
                JE      D_LoadXM3

                Mov     AH, 3Fh
                Mov     CX, [DS:7]
                Mov     DX, 100h
                Mov     SI, DX
                Int     21h                     ; DS:100h contains all the
                                                ; pattern data.

                Cmp     BP, 200                 ; Too many patterns?
                JAE     D_LoadXM3

                Mov     AX, [DS:5]              ; AX = number of rows
                Mov     CX, [DS:64100+8]        ; CX = number of channels
                Mov     DX, BP

                Cmp     AX, 200
                JA      D_LoadXM2

        ; TranslateXMPattern takes:
        ;   DS:SI points to pattern data
        ;   AX = rows
        ;   CX = channels
        ;   DX = pattern number


                Call    PE_TranslateXMPattern
                Jmp     D_LoadXM3

D_LoadXM2:
                ShR     AX, 1
                Call    PE_TranslateXMPattern

                Mov     DX, [ES:0C0h]           ; DX = pattern number
                Cmp     DX, 200
                JAE     D_LoadXM3

                Inc     Word Ptr [ES:0C0h]

                Call    D_InsertOrder

                Mov     AX, [DS:5]
                Inc     AX
                ShR     AX, 1                   ; AX = number of rows.
                Call    PE_TranslateXMPattern

D_LoadXM3:
                Inc     BP
                Cmp     BP, [DS:64100+10]
                JB      D_LoadXM1

D_LoadXMNoPatterns:
                                ; Now to load instruments
                Xor     BP, BP
                Cmp     BP, [DS:64100+12]
                JE      D_LoadXMInstrumentTooMany

D_LoadXM4:
                Push    DS SI

                Push    CS
                Pop     DS
                Mov     SI, Offset InstrumentMsg
                Mov     AX, BP
                Inc     AX
                Push    AX
                Mov     AH, 5
                Mov     DI, (4+17*80)*2
                Call    S_DrawString
                Pop     AX

                Pop     SI DS

                Mov     AH, 3Fh
                Mov     CX, 4
                Xor     DX, DX
                Int     21h

                Mov     AH, 3Fh
                Mov     CX, [DS:0]
                Mov     DX, 4
                Sub     CX, DX
                Int     21h

                                ; OK.. instrument loaded into DS:0..
                Mov     DI, BP
                Add     DI, DI
                Mov     DI, [ES:64712+DI]       ; ES:DI points to instrument
                Push    DI

                Mov     SI, 4
                Add     DI, 20h
                Mov     CX, 22
                Rep     MovsB
                Xor     AX, AX
                Mov     CX, 4
                Rep     StosW

                Pop     DI
                Cmp     Word Ptr [DS:27], 0
                JE      D_LoadXMInstrumentEnd

                Add     DI, 14h                 ; DI points to fadeout
                Mov     AX, [DS:239]
                Add     AX, 15
                ShR     AX, 5
                Cmp     AX, 256
                JBE     D_LoadXMInstrument1

                Mov     AX, 256

D_LoadXMInstrument1:
                StosW
                Add     DI, 40h-16h             ; Translation table

                Mov     CX, 12                  ; Kill first 12 entries.
                Xor     AX, AX

D_LoadXMInstrument2:                            ; First 12 entries cleared
                StosW
                Inc     AX
                Loop    D_LoadXMInstrument2

                Mov     CX, 96
                Mov     SI, 33                  ; Note translation

D_LoadXMInstrument3:
                Mov     AH, [SI]
                Add     AH, [ES:24h]
                Cmp     AH, 99
                JBE     D_LoadXMInstrument4

                Mov     AH, 99

D_LoadXMInstrument4:
                StosW
                Inc     SI
                Inc     AX
                Loop    D_LoadXMInstrument3

                Mov     CX, 12                  ; Kill first 12 entries.
                Xor     AH, AH

D_LoadXMInstrument5:                            ; First 12 entries cleared
                StosW
                Inc     AX
                Loop    D_LoadXMInstrument5

                                                ; Now for volume envelope
                Mov     AL, [DS:233]            ; Flags
                Test    AL, 1
                JNZ     D_LoadXMVolumeEnvelope

                Mov     AX, 205h
                StosW
                Xor     AX, AX
                StosW
                StosW

                Mov     AL, 64
                StosB
                Xor     AX, AX
                StosW

                StosB
                Mov     AX, 1
                StosW

                Mov     CX, 70
                Xor     AX, AX
                Rep     StosB

                Jmp     D_LoadXMInstrumentVolumeFinished

D_LoadXMVolumeEnvelope:
;                Mov     CL, AL
;                Mov     AH, AL
;                And     AX, 402h
;                ShR     AH, 1
;                ShL     AL, 1
;                Or      AL, AH
;                And     CL, 1
;                Or      AL, CL

                And     AL, 2
                ShL     AL, 1
                Or      AL, 2+1       ; Volume envelope on, Loop on (always)

                Mov     AH, [DS:225]      ; No of vol env nodes
                Cmp     AH, 12
                JB      D_NumXMVolNodes1

                Mov     AH, 12

D_NumXMVolNodes1:
                StosW
                Mov     AX, [DS:228]      ; Vol loop start+end
                Test    Byte Ptr [DS:233], 4 ; Volume loop?
                JNZ     VolumeLoopOK

                Mov     AL, [DS:225]
                Dec     AX
                Mov     AH, AL

VolumeLoopOK:
                StosW
                Mov     AL, [DS:227]      ; Vol Sustain point
                Mov     AH, AL
                StosW

                Cmp     Byte Ptr [DS:233], 7
                JNE     D_XMVolumeNoSustain

                Cmp     AL, [DS:229]        ; Compare sustain to endpoint
                JB      D_XMVolumeLoopOK

                And     Byte Ptr [ES:DI-6], Not 4
                Jmp     D_XMVolumeLoopOK

D_XMVolumeNoSustain:
                Test    Byte Ptr [DS:233], 2    ; Loop?
                JNZ     D_XMVolumeLoopOK

                Mov     AL, [DS:225]            ; Number of nodes
                Dec     AX
                Mov     AH, AL
                Mov     [ES:DI-2], AX
                Or      Byte Ptr [ES:DI-6], 4

D_XMVolumeLoopOK:
                                ; OK. now process volume env points
                Mov     CX, 12
                Mov     SI, 129

D_LoadXMInstrument6:
                Mov     AL, [SI+2]
                Cmp     AL, 64
                JB      D_LoadXMInstrument7

                Mov     AL, 64

D_LoadXMInstrument7:
                StosB
                MovsW
                LodsW
                Loop    D_LoadXMInstrument6

                Mov     CX, 13*3+1
                Xor     AX, AX
                Rep     StosB

                        ; Now for panning envelope
D_LoadXMInstrumentVolumeFinished:

                Mov     AL, [DS:234]      ; Flags
                Mov     CL, AL
                Mov     AH, AL
                And     AX, 402h
                ShR     AH, 1
                ShL     AL, 1
                Or      AL, AH
                And     CL, 1
                Or      AL, CL

                Mov     AH, [DS:226]      ; No of pan env nodes
                Cmp     AH, 12
                JB      D_NumXMPanNodes1

                Mov     AH, 12

D_NumXMPanNodes1:
                StosW
                Mov     AX, [DS:231]      ; Pan loop start+end
                StosW
                Mov     AL, [DS:230]      ; Pan Sustain point
                Mov     AH, AL
                StosW

                Test    Byte Ptr [DS:234], 2 ; Panning envelope flags
                JZ      D_XMPanningLoopOK

                Cmp     AL, [DS:232]         ; Compare sustain to endpoint
                JB      D_XMPanningLoopOK

                And     Byte Ptr [ES:DI-6], Not 4

D_XMPanningLoopOK:
                                ; OK. now process panning env points
                Mov     CX, 12
                Mov     SI, 177
                Xor     AH, AH

D_LoadXMInstrument8:
                Mov     AL, [SI+2]
                Cmp     AL, 64
                JB      D_LoadXMInstrument9

                Mov     AL, 64

D_LoadXMInstrument9:
                Sub     AL, 32
                StosB
                MovsW
                LodsW                   ; Add SI, 2
                Loop    D_LoadXMInstrument8

                Mov     AX, [DS:27]
                Mul     Word Ptr [DS:29]
                Mov     CX, AX
                Mov     AH, 3Fh
                Mov     DX, 1000h
                Mov     SI, DX
                Int     21h

                Mov     CX, [DS:27]     ; Update number of samples.
                Mov     AX, [ES:24h]
                Add     [ES:24h], CX

D_LoadXMSamples1:
                Cmp     AX, 99
                JA      D_LoadXMInstrumentTooMany
                Cmp     AX, [ES:24h]
                JAE     D_LoadXMInstrumentEnd

                Push    AX
                Push    SI

                Mov     DI, AX
                Add     DI, DI
                Mov     DI, [ES:64912+DI-2]
                Add     DI, 12h                 ; Skip filename, ID, GVL

                Mov     AH, [SI+12]     ; Default volume
                Mov     AL, 0
                Cmp     DWord Ptr [SI], 0       ; Length = 0?
                JE      D_LoadXMSamples3

                                        ; Grab the panning value

Comment ~
                Mov     AL, [SI+15]
                ShR     AL, 1
                Inc     AX
                ShR     AL, 1

                Push    DI
                Mov     DI, BP
                Add     DI, DI
                Mov     DI, [ES:64712+DI]
                Cmp     Byte Ptr [ES:DI+19h], 32+128
                JE      XMNoPan2

                Mov     AL, 32

XMNoPan2:
                Mov     [ES:DI+19h], AL

XMNoPan:
                Pop     DI
~
                                        ; Sample present flag
                Mov     AL, 1

                Mov     CL, [SI+14]
                Test    CL, 10h         ; 16 bit sample?
                JZ      D_LoadXMSamples2

                Or      AL, 2

D_LoadXMSamples2:
                And     CL, 3
                JZ      D_LoadXMSamples3 ; No loop
                                         ; CL = 1 or 2
                Cmp     DWord Ptr [SI+8], 1
                JBE     D_LoadXMSamples3

                Or      AL, 10h          ; Loop
                Dec     CX
                ShL     CL, 6
                Or      AL, CL

D_LoadXMSamples3:
                StosW

                Push    SI
                                        ; Copy sample name
                Add     SI, 18
                Mov     CX, 22/2
                Rep     MovsW
                Xor     AX, AX
                StosW
                StosW

                Pop     SI
                                        ; Conversion flags.
                Mov     AH, [SI+15]
                ShR     AH, 2
                AdC     AH, 80h
                Mov     AL, 5
                StosW

                Mov     EAX, [SI]
                Call    LoadXISample5
                Mov     EAX, [SI+4]
                Call    LoadXISample5
                Mov     EAX, [SI+4]
                Add     EAX, [SI+8]
                Call    LoadXISample5

                                        ; C5speed..
                Push    ES
                Push    DI

                Call    Music_GetPitchTable     ; Returns ES:DI
                Mov     AL, [SI+16]     ; Relative note number
                Add     AL, 60          ; AL = note multiplier
                And     AX, 0FFh
                ShL     AX, 2
                Add     DI, AX
                Mov     ECX, [ES:DI]

                Mov     AL, [SI+13]     ; Finetune, -128->+127
                SAR     AL, 4           ; Finetune = -8->+7
                And     AX, 0Fh
                Add     AX, AX
                Mov     DI, AX
                MovZX   EAX, [CS:FineTuneTable+DI]

                Pop     DI
                Pop     ES

                Push    EDX

                Mul     ECX
                ShRD    EAX, EDX, 16
                Pop     EDX
                StosD                   ; C5freq

                Xor     AX, AX
                StosW
                StosW
                StosW
                StosW

                                        ; Now for file position
                Mov     AX, 4201h
                Xor     CX, CX
                Xor     DX, DX
                Int     21h             ; Returns DX:AX

                StosW
                Mov     AX, DX
                StosW

                                        ; Vibrato information
                Mov     AX, [DS:237]
                XChg    AH, AL
                StosW

                Mov     DX, [DS:236]
                And     DX, 0FFh
                Mov     AX, 100h
                Sub     AX, DX
;                Cmp     AL, 64
;                JBE     VibratoLimit
;
;                Mov     AL, 64
;
; VibratoLimit:
                Mov     AH, [DS:235]
                StosW

                                        ; Move file pointer forwards
                Mov     AX, 4201h
                Mov     CX, [SI+2]
                Mov     DX, [SI]
                Int     21h

                Pop     SI
                Pop     AX
                Add     SI, [DS:29]     ; Next sample header
                Inc     AX
                Jmp     D_LoadXMSamples1

D_LoadXMInstrumentEnd:
                Inc     BP
                Cmp     BP, 99
                JA      D_LoadXMInstrumentTooMany
                Cmp     BP, [DS:64100+12]
                JB      D_LoadXM4

D_LoadXMInstrumentTooMany:
                Mov     CX, 1                   ; CX = sample number (base 1)
                                                ; DS = doesn't matter
                                                ; ES = songdata segment

D_LoadXMFinalSamples1:                          ; OK, now load the samples.
                Push    CX
                Push    ES

                Mov     SI, CX
                Dec     SI
                Add     SI, SI
                Mov     SI, [ES:64912+SI]
                Test    Byte Ptr [ES:SI+12h], 1
                JZ      D_LoadXMFinalSamples2

                Push    CS
                Pop     DS

                Push    SI
                Mov     SI, Offset SampleMsg
                Mov     DI, (4+18*80)*2
                Mov     AH, 5
                Push    CX
                Call    S_DrawString
                Pop     DI
                Pop     SI                      ; ES:SI points to sample header.
                                                ; DI = sample number+1
                Push    ES
                Pop     DS

                Mov     AX, 4200h
                Xor     CX, CX
                Xor     DX, DX
                XChg    CX, [DS:SI+4Ah]
                XChg    DX, [DS:SI+48h]
                Int     21h                     ; Move file pointer.

                Mov     AX, DI
                Dec     AX

                Call    D_LoadSampleData
                Jmp     D_LoadXMFinalSamplesPresent

D_LoadXMFinalSamples2:
                Mov     DWord Ptr [SI+48h], 0

D_LoadXMFinalSamplesPresent:
                Pop     ES
                Pop     CX
                Inc     CX
                Cmp     CX, 100
                JBE     D_LoadXMFinalSamples1

                Jmp     D_PostLoadModule

EndP            D_LoadXM

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            D_LoadMTM Far

                Xor     AX, AX
                Call    D_PreLoadModule

                        Assume DS:Nothing

                Mov     AH, 3Fh
                Mov     CX, 66                          ; Song header length.
                Mov     DX, 60000
                Int     21h

                Mov     DI, 4
                Mov     CX, 20
                Mov     SI, 60004
                Rep     MovsB
                Xor     AX, AX
                Mov     CX, 8
                Rep     StosB                           ; Song name.
                Mov     AL, [DS:60027]
                StosW                                   ; Order num
                Xor     AL, AL
                StosW                                   ; Inst num
                Mov     AL, [DS:60030]
                StosW                                   ; Sample number.
                Mov     AL, [DS:60026]
                StosW                                   ; Pattern number

                Add     DI, 4
;                Mov     AX, 101h                        ; Cwt/v 1.0
;                StosW
;                Mov     AX, 100h                        ; Cmwt 1.0
;                StosW

                Mov     AX, 31h                         ; Stereo. No Vol0Opt
                StosW                                   ; Use samples, old eff
                Xor     AX, AX
                StosW
                Mov     AX, 3080h                       ; GlobalVol+MixVol
                StosW
                Mov     AX, 7D06h
                StosW
                Mov     AL, 128
                StosB
                Xor     AL, AL
                Mov     CX, 11
                Rep     StosB

                Mov     CX, 32
                Mov     DX, 0
                Xor     AH, AH
                                                        ; Panning positions
D_LoadMTM1:
                Mov     SI, 60034
                Add     SI, DX
                Mov     AL, [DS:SI]
                Mov     SI, AX
                Mov     AL, [CS:PanningPositions+SI]
                StosB

                Inc     DX
                Loop    D_LoadMTM1

                Mov     CX, 32
                Mov     AL, 160
                Rep     StosB
                Mov     AL, 64
                Mov     CX, 64
                Rep     StosB

                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset SampleHeaderMsg
                Mov     AH, 5
                Mov     DI, (4+16*80)*2
                Call    S_DrawString

                Pop     DS
                        Assume DS:Nothing

                Mov     AL, 37
                Mul     Byte Ptr [ES:24h]               ; AX = length of
                                                        ; sample headers
                Mov     CX, AX                  ; length..
                Mov     AH, 3Fh                 ; read file..
                Xor     DX, DX
                Int     21h


                Mov     DH, [ES:24h]
                Mov     DI, 55912               ; Start of samples.
                Xor     SI, SI                  ; DS:SI points to MTM header.

D_LoadMTM2:
                Mov     EAX, 'SPMI'
                StosD
                Xor     AX, AX
                Mov     CX, 6
                Rep     StosW                   ; Clear file name.
                StosB
                Mov     AL, 40h
                StosB


                Mov     AL, [DS:SI+36]
                And     AL, 1
                Add     AL, AL

                Cmp     DWord Ptr [DS:SI+22], 0
                JE      D_LoadMTM3              ; Sample length = 0.

                Or      AL, 1                   ; Else there's a sample.

D_LoadMTM3:
                Mov     ECX, [SI+30]             ; Sample loop end
                Sub     ECX, [SI+26]             ; Sample loop start
                Cmp     ECX, 2
                JBE     D_LoadMTM4

                Or      AL, 16

D_LoadMTM4:
                StosB
                Mov     DL, AL
                Mov     AL, [DS:SI+35]
                StosB

                Push    SI

                Mov     CX, 22

D_LoadMTMSampleName:
                LodsB
                StosB
                And     AL, AL
                LoopNZ  D_LoadMTMSampleName
                Pop     SI

                Xor     AL, AL
                Add     CX, 5
                Rep     StosB                   ; Filler.
                Mov     AL, 32
                StosB

                Mov     EAX, [DS:SI+22]
                StosD

                Test    DL, 1
                JNZ     D_LoadMTM5

                Xor     AX, AX
                Mov     CX, 4
                Rep     StosW                   ; Clear rest of sample field.
                Mov     AX, 8363                ; (no sample)
                StosW
                Xor     AX, AX
                Mov     CX, 9
                Rep     StosW

                Jmp     D_LoadMTM8

D_LoadMTM5:
                Test    DL, 16
                JZ      D_LoadMTM6

                Mov     EAX, [DS:SI+26]
                StosD
                Mov     EAX, [DS:SI+30]
                StosD
                Jmp     D_LoadMTM7

D_LoadMTM6:
                Xor     AX, AX
                Mov     CX, 4
                Rep     StosW

D_LoadMTM7:                                     ; C5 speed here...
                Push    SI
                Mov     AL, [DS:SI+34]
                And     AX, 0Fh
                Mov     SI, AX
                Add     SI, SI
                Mov     AX, [CS:FineTuneTable+SI]
                Pop     SI
                StosW
                Xor     AX, AX
                Mov     CX, 9
                Rep     StosW

D_LoadMTM8:
                Add     SI, 37
                Dec     DH
                JNZ     D_LoadMTM2              ; Finished with samples.

                Mov     AH, 3Fh
                Mov     CX, 128
                Xor     DX, DX
                Int     21h                     ; Order data.

                Mov     CL, [DS:60027]
                Inc     CX
                Xor     CH, CH
                Mov     DX, 256
                Sub     DX, CX
                Xor     SI, SI
                Mov     DI, 256
                Rep     MovsB
                Mov     CX, DX
                Mov     AL, 0FFh
                Rep     StosB                   ; Order list done.
                                                ; Now it's time to do the
                                                ; friggen pattern stuff.
                Mov     AL, 37
                Mul     Byte Ptr [DS:60030]
                Add     AX, 66+128
                Push    AX

                Mov     AX, 192
                Mul     Word Ptr [DS:60024]
                                                ; DX:AX = length of track data.
                Mov     BP, DX
                Mov     CX, AX
                Xor     DX, DX
                Pop     AX
                Add     CX, AX
                AdC     BP, 0
                                                ; BP:CX = offset to sequencer
D_LoadMTM9:                                     ; DX = pattern no.
                                                ; AX = offset to track data.
                Push    AX
                Push    CX
                Push    DX

                Push    AX

                Push    DS
                Push    SI
                Push    DI

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset PatternMsg
                Mov     AH, 5
                Mov     DI, (4+17*80)*2
                Push    DX
                Call    S_DrawString
                Pop     AX

                Pop     DI
                Pop     SI
                Pop     DS
                        Assume DS:Nothing


                Mov     AX, 4200h
                Mov     DX, CX
                Mov     CX, BP
                Int     21h                     ; Move to offset.

                Mov     AH, 3Fh
                Mov     CX, 64
                Xor     DX, DX
                Int     21h                     ; Read seq data.

                Pop     AX

                Mov     CX, 32
                Xor     SI, SI
                Mov     DX, AX                  ; DX = posn of track data.
                Mov     DI, 10000

D_LoadMTM10:
                Push    CX
                Push    DX

                LodsW
                And     AX, AX
                JZ      D_LoadMTM11

                Push    DS
                Push    SI
                Push    DI
                Mov     SI, 33
                Sub     SI, CX
                Push    AX
                Push    SI

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset TrackMsg
                Mov     DI, (5+18*80)*2
                Mov     AH, 5
                Call    S_DrawString

                Pop     SI
                Pop     AX
                Pop     DI
                Pop     SI
                Pop     DS
                        Assume DS:Nothing

                Push    DX

                Dec     AX
                Mov     CX, 192
                Mul     CX

                Pop     CX
                Add     AX, CX
                AdC     DX, 0
                Mov     CX, DX
                Mov     DX, AX
                Mov     AX, 4200h
                Int     21h                     ; Move ptr.

                Mov     AH, 3Fh
                Mov     CX, 192
                Mov     DX, DI
                Int     21h

                Add     DI, 192
                Jmp     D_LoadMTM12

D_LoadMTM11:
                Push    ES

                Push    DS
                Pop     ES

                Mov     CX, 192
                Xor     AL, AL
                Rep     StosB

                Pop     ES

D_LoadMTM12:
                Pop     DX
                Pop     CX
                Loop    D_LoadMTM10

                Mov     SI, 10000
                        ; DS:SI points to pattern data.

                Pop     DX
                                                ; DX = pattern number
                                                ; DS:SI = pattern data.
                Call    PE_TranslateMTMPattern

                Pop     CX
                Pop     AX
                Add     CX, 64
                AdC     BP, 0
                Inc     DX
                Cmp     DL, [DS:60026]
                JBE     D_LoadMTM9

                                                ; BP:CX points to comment

                Comment &

                Mov     AL, 37
                Mul     Byte Ptr [DS:60030]
                                                ; AX = 37*NOS
                Add     AX, 194
                Add     AX, Word Ptr [DS:60028] ; AX = 194+NOS*37+length_comment
                Mov     CX, AX
                Mov     AX, 192
                Mul     Word Ptr [DS:60024]     ; DX:AX = trcks*192
                Mov     BP, DX
                Add     CX, AX
                AdC     BP, 0                   ; BP:CX = 194+NOS*37+trcks*192+
                                                ;         length(comment)
                Mov     AL, 64
                Mov     AH, Byte Ptr [DS:60026]
                Inc     AH
                Mul     AH
                Add     CX, AX
                AdC     BP, 0                   ; BP:CX = 194+NOS*37+trcks*192+
                                                ;         64*patterns+length(comment)

                &

;                Add     CX, [DS:60028]          ; Skip past comment -> samples.
;                AdC     BP, 0
;
                Mov     AX, 4200h
                Mov     DX, CX
                Mov     CX, BP
                Int     21h                     ; File is at pointers to samps.

                Mov     CX, [DS:60028]          ; Length of message
                Call    Msg_GetMessageOffset    ; Sets up DS:DX
                Mov     AH, 3Fh
                Int     21h
                                                ; Now to 'process' the message.

                Mov     SI, DX
                Mov     CX, AX

                Xor     DX, DX                  ; DX = character count.

D_LoadMTMMessage1:
                Mov     AL, [SI]
                And     AL, AL
                JNZ     D_LoadMTMMessage2

                Mov     Byte Ptr [SI], 32       ; spacebar.

D_LoadMTMMessage2:
                Inc     DX
                Cmp     DX, 40
                JB      D_LoadMTMMessage3

                Xor     DX, DX
                Mov     Byte Ptr [SI], 13       ; Enter!

D_LoadMTMMessage3:
                Inc     SI
                Loop    D_LoadMTMMessage1

                Push    ES
                Pop     DS
                Mov     SI, 55912               ; DS:SI points to sample headers
                Xor     CX, CX

D_LoadMTM13:
                Push    CX
                Push    SI
                Test    Byte Ptr [DS:SI+12h], 1
                JZ      D_LoadMTM14
                                                ; OK.. have a sample to load.
                Push    DS
                Push    SI

                Push    CS
                Pop     DS
                Mov     SI, Offset SampleMsg
                Mov     DI, (4+20*80)*2
                Mov     AX, CX
                Inc     AX
                Push    AX
                Mov     AH, 5
                Call    S_DrawString
                Pop     AX
                Dec     AX

                Pop     SI
                Pop     DS

                Call    D_LoadSampleData

D_LoadMTM14:
                Pop     SI
                Pop     CX
                Inc     CX
                Add     SI, 80
                Cmp     CX, 100
                JB      D_LoadMTM13

                Jmp     D_PostLoadModule

EndP            D_LoadMTM
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            D_LoadS3M Far

                Mov     AL, 1
                Call    D_PreLoadModule

                Mov     AH, 3Fh
                Mov     CX, 60h
                Mov     DX, 60000
                Int     21h

                Mov     DI, 4
                Mov     CX, 25
                Mov     SI, 60000
                Rep     MovsB
                Xor     AL, AL
                StosB
                Add     DI, 14

                Mov     AX, 10h         ; Old Effects

                Test    Byte Ptr [DS:60000+33h], 80h
                JZ      D_LoadS3M1

                Inc     AX

D_LoadS3M1:
                Test    Byte Ptr [DS:60000+26h], 8
                JZ      D_LoadS3M2

                Or      AL, 2

D_LoadS3M2:
                StosW
                Xor     AX, AX
                StosW
                Mov     AL, [DS:60000+30h]
                ShL     AL, 1
                StosB
                Mov     AL, [DS:60000+33h]
                And     AL, 127
                StosB
                Mov     AX, [DS:60000+31h]
                StosW
                Mov     AL, 128
                StosB
                Add     DI, 7

                Mov     EAX, [DS:60000+38h]
                Cmp     Word Ptr [DS:60000+28h], 3208h
                JB      D_ConvertS3MTimer

                Xor     EAX, 'ITRK'
                RoR     EAX, 7
                Neg     EAX
                RoL     EAX, 4
                Xor     EAX, 'JTHL'

D_ConvertS3MTimer:
                StosD
                                        ; OK, panning now...
                Mov     SI, 60000+40h
                Mov     CX, 32

D_LoadS3M3:
                LodsB

                Mov     DL, 32+128
                Cmp     AL, 128
                JAE     D_LoadS3M4

                Mov     AH, AL

;                Test    Byte Ptr [DS:60000+33h], 128
;                JZ      D_LoadS3M5

                And     AL, 127

                Mov     DL, 0
                Cmp     AL, 7
                JBE     D_LoadS3M4

                Mov     DL, 64
                Cmp     AL, 15
                JBE     D_LoadS3M4

                Mov     DL, 32

D_LoadS3M4:
                Mov     AL, DL
                And     AH, 80h

                StosB
                Loop    D_LoadS3M3

                Mov     CX, 32
                Mov     AL, 32+128
                Rep     StosB

                Mov     CX, 64
                Mov     AL, 64
                Rep     StosB

                Mov     DI, 100h
                Mov     CX, 256
                Mov     AL, 255
                Rep     StosB

                Push    DS

                Mov     CX, [DS:60000+20h]
                Push    ES
                Pop     DS
                Mov     DX, 100h
                Mov     AH, 3Fh
                Int     21h

                Pop     DS                      ; Order list loaded.

                Mov     AH, 3Fh
                Mov     CX, [DS:60000+22h]
                Add     CX, [DS:60000+24h]
                Add     CX, CX
                Xor     DX, DX
                Int     21h

                Cmp     Byte Ptr [DS:60000+35h], 252
                JNE     D_LoadS3M15

                Mov     AH, 3Fh
                Mov     CX, 32
                Mov     DX, 1024
                Int     21h

                Mov     CX, 32
                Mov     SI, 1024
                Mov     DI, 64

D_LoadS3M14:
                LodsB
                Test    AL, 32
                JZ      D_LoadS3M16

                Mov     AH, [ES:DI]
                And     AX, 800Fh
                ShL     AL, 1
                ShL     AL, 1
                Add     AL, 2
                Or      AL, AH
                Mov     [ES:DI], AL

D_LoadS3M16:
                Inc     DI

                Loop    D_LoadS3M14

D_LoadS3M15:
                Mov     CX, 1                   ; Load instruments
                Mov     DI, 55912

D_LoadS3M7:
                Push    CX
                Push    DI

                Push    DI
                Push    DS

                Mov     SI, CX
                Dec     SI
                Add     SI, SI
                Mov     DX, [SI]

                Push    CS
                Pop     DS
                Push    CX                      ; For Drawstring.

                Mov     AX, 4200h
                Xor     CX, CX
                ShLD    CX, DX, 4
                ShL     DX, 4
                Int     21h

                Mov     SI, Offset SHLoadMsg
                Mov     DI, (4+16*80)*2
                Mov     AH, 5
                Call    S_DrawString
                Pop     AX

                Pop     DS
                Pop     DI

                Mov     DX, 1024                        ; Load inst. header.
                Mov     CX, 80
                Mov     AH, 3Fh
                Int     21h

                Mov     EAX, 'SPMI'
                StosD

                Mov     SI, 1025
                Mov     CX, 12
                Rep     MovsB
                Xor     AL, AL
                StosB
                Mov     AL, 64
                StosB

                Xor     AL, AL

                Cmp     Byte Ptr [DS:1024], 1
                JNE     D_LoadS3M8

                Mov     AL, [DS:1024+1Fh]
                ShR     AL, 1
                And     AL, 2

                Cmp     Word Ptr [DS:1024+10h], 0
                JE      D_LoadS3M8

                Inc     AX

D_LoadS3M8:
                Mov     CL, [DS:1024+1Fh]
                Mov     CH, CL                  ; CL = 1 -> loop
                And     CL, 1
                ShL     CL, 4
                Or      AL, CL                  ; Loop...

                And     CH, 4
                ShR     CH, 1
                Or      AL, CH                  ; 16 bit.

D_LoadS3M9:
                StosB
                Mov     AL, [DS:1024+1Ch]
                StosB
                Mov     SI, 1024+30h
                Mov     CX, 25
                Rep     MovsB
                Xor     AX, AX
                StosW
                Mov     AL, 32
                StosB

                Mov     EAX, [DS:1024+10h]
                StosD                   ; Length

                Mov     EAX, [DS:1024+14h]
                StosD                   ; LoopBeg

                Mov     EAX, [DS:1024+18h]
                StosD                   ; LoopEnd

                Mov     EAX, [DS:1024+20h]
                StosD                   ; C5Spd

                Xor     AX, AX
                StosW
                StosW                   ; Susloopbegin

                StosW
                StosW                   ; SusLoopEnd

                Cmp     Byte Ptr [DS:1024], 1
                JE      D_LoadS3M22

                Xor     AX, AX
                StosW
                StosW
                Jmp     D_LoadS3M23

D_LoadS3M22:
                Mov     CL, 4
                Mov     AX, [DS:1024+0Eh]
                Mov     DL, [DS:1024+0Fh]
                Mov     DH, [DS:1024+0Dh]
                ShL     AX, CL
                ShR     DX, CL
                StosW                   ; Sample pointer in file.
                Mov     AX, DX
                StosW

                Xor     AX, AX

D_LoadS3M23:
                StosW                   ; Vibrato info...
                StosW

                Pop     DI
                Pop     CX
                Add     DI, 80
                Inc     CX

                Cmp     CX, 100
                JAE     D_LoadS3M10

                Cmp     CX, [DS:60000+22h]
                JBE     D_LoadS3M7

D_LoadS3M10:
                Push    DS

                Mov     CX, 1                   ; CX = sample number (base 1)
                                                ; DS = doesn't matter
                                                ; ES = songdata segment

D_LoadS3M17:                                    ; OK, now load the samples.
                Push    CX
                Push    ES

                Mov     SI, CX
                Dec     SI
                Add     SI, SI
                Mov     SI, [ES:64912+SI]
                Test    Byte Ptr [ES:SI+12h], 1
                JZ      D_LoadS3M18

                Push    CS
                Pop     DS

                Push    SI
                Mov     SI, Offset SampleMsg
                Mov     DI, (4+17*80)*2
                Mov     AH, 5
                Push    CX
                Call    S_DrawString
                Pop     DI
                Pop     SI                      ; ES:SI points to sample header.
                                                ; DI = sample number+1
                Push    ES
                Pop     DS

                Mov     AX, 4200h
                Xor     CX, CX
                Xor     DX, DX
                XChg    CX, [DS:SI+4Ah]
                XChg    DX, [DS:SI+48h]
                Int     21h                     ; Move file pointer.

                Mov     AX, DI
                Dec     AX

                Call    D_LoadSampleData
                Jmp     D_LoadS3MSamplePresent

D_LoadS3M18:
                Mov     DWord Ptr [SI+48h], 0

D_LoadS3MSamplePresent:
                Pop     ES
                Pop     CX
                Inc     CX
                Cmp     CX, 100
                JBE     D_LoadS3M17

                Pop     DS

                Mov     CX, 0                   ; CX = pattern number
                                                ; DS = disktransfer

D_LoadS3M11:
                Push    CX                      ; Load patterns....

                Push    DS

                Push    CS
                Pop     DS

                Mov     DI, (4+18*80)*2
                Mov     SI, Offset PatternMsg
                Mov     AH, 5
                Push    CX
                Call    S_DrawString
                Pop     SI              ; SI = Pattern Number

                Pop     DS

                Add     SI, [DS:60000+22h]
                Add     SI, SI
                Mov     DX, [SI]                ; DX = offset of pattern / 16
                And     DX, DX
                JZ      D_LoadS3M13

                Push    CX

                Xor     CX, CX
                ShLD    CX, DX, 4
                ShL     DX, 4
                Mov     AX, 4200h
                Int     21h

                Mov     AH, 3Fh                 ; Load data.
                Mov     CX, 2
                Mov     DX, 1024
                Int     21h
                Mov     AH, 3Fh
                Mov     CX, [DS:1024]
                Mov     DX, 1024
                Int     21h                     ; Pattern data at DS:1024

                Pop     DX                      ; DX = Pattern number
                Mov     SI, 1024
                Call    PE_TranslateS3MPattern

D_LoadS3M13:
                Pop     CX
                Inc     CX
                Cmp     CX, 100
                JA      D_LoadS3M12

                Cmp     CX, [DS:60000+24h]
                JB      D_LoadS3M11

D_LoadS3M12:
                Jmp     D_PostLoadModule

                Ret

EndP            D_LoadS3M
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            D_Load669 Far

                Xor     AX, AX
                Call    D_PreLoadModule

                Mov     AH, 3Fh
                Mov     CX, 1F1h
                Mov     DX, 60000
                Int     21h

                Mov     SI, 60000+2
                Mov     DI, 4
                Mov     CX, 25
                Rep     MovsB

                Xor     AX, AX
                Mov     CX, 7
                Rep     StosB
                Mov     SI, 60000+6Eh
                LodsB
                StosW
                LodsB
                StosW

                Add     DI, 4
                Mov     AX, 19h         ; Stereo control, sample controlled,
                StosW                   ; Linear, Old EFX
                Xor     AX, AX
                StosW                   ; Song message attached.

                Mov     AX, 3080h       ; GV/MV
                StosW

                Mov     AX, 78*100h+6h      ; 78 BPM, speed 6
                StosW

                Mov     AX, 64              ; Separation of 64
                StosW
                Xor     AX, AX
                Mov     CX, 5
                Rep     StosW

                Mov     AX, 4000h
                StosW
                StosW
                StosW
                StosW
                Mov     AL, 32+128
                Mov     CX, 56
                Rep     StosB           ; Channel pan
                Mov     AL, 64
                Mov     CL, AL
                Rep     StosB           ; Channel volume

                Mov     SI, 60000+71h
                Mov     DI, 100h        ; Orders
                Mov     CL, 80h
                Rep     MovsB
                Mov     CL, 80h
                Mov     AL, 0FFh
                Rep     StosB           ; Orders done.

                Xor     BP, BP          ; Sample time

                Mov     DI, 512+55400
                Mov     AL, 25
                Mul     Byte Ptr [DS:60000+6Eh]
                Mov     CX, AX          ; CX = bytes to read
                Mov     AH, 3Fh
                Xor     DX, DX
                Int     21h
                Xor     SI, SI

D_Load669_1:
                Cmp     BP, [ES:24h]
                JAE     D_Load669_2

                Mov     EAX, 'SPMI'
                StosD
                Mov     CX, 6
                Rep     MovsW
                Mov     AX, 4000h
                StosW

                ; Flag, volume
                Mov     AH, 60
                Inc     SI
                Mov     ECX, [SI]
                Test    ECX, ECX
                JZ      D_Load669_3

                Xor     EAX, EAX
                Mov     [ES:DI+22h], EAX
                Mov     [ES:DI+26h], EAX

                Mov     AX, 3C01h       ; Sample present

                Mov     ECX, [SI+8]     ; End loop

                Cmp     ECX, [SI]
                JA      D_Load669_3

                Sub     ECX, [SI+4]     ; Start loop
                JC      D_Load669_3
                Cmp     ECX, 2
                JB      D_Load669_3

                Mov     ECX, [SI+4]
                Mov     [ES:DI+22h], ECX
                Mov     ECX, [SI+8]
                Mov     [ES:DI+26h], ECX

                Mov     AX, 3C11h       ; Sample present, forwards loop

D_Load669_3:
                StosW
                Mov     CX, 13
                Sub     SI, CX
                Rep     MovsB
                Xor     AL, AL
                Mov     CX, 13
                Rep     StosB
                Mov     AH, 32
                StosW                   ; Convert, DfP
                MovsW
                MovsW
                Add     SI, 8
                Add     DI, 8

                Mov     AX, 8363
                StosW

                Xor     AX, AX
                Mov     CX, 9
                Rep     StosW

                Inc     BP
                Jmp     D_Load669_1

D_Load669_2:                            ; OK.. patterns..
                Xor     BP, BP          ; BP = pattern number

D_Load669_4:
                Cmp     BP, [ES:26h]
                JAE     D_Load669_5

                Mov     AH, 3Fh
                Mov     CX, 600h
                Xor     DX, DX
                Int     21h             ; Patterns at DS:0

                Mov     AH, [DS:60000+0F1h+BP]
                Mov     CL, [DS:60000+171h+BP]
                Call    PE_Translate669Pattern

                Inc     BP
                Jmp     D_Load669_4

D_Load669_5:                            ; Samples

                Xor     BP, BP
                Push    ES
                Pop     DS

D_Load669Samples:
                Inc     BP
                Cmp     BP, [DS:24h]
                JA      D_Load669End

                Mov     SI, BP
                Add     SI, SI
                Mov     SI, [DS:64910+SI]
                Test    Byte Ptr [DS:SI+12h], 1    ; Sample present?
                JZ      D_Load669Samples

                Push    DS
                Push    SI

                Push    CS
                Pop     DS

                Push    BP
                Mov     SI, Offset SampleMsg
                Mov     DI, (4+16*80)*2
                Mov     AH, 5
                Call    S_DrawString

                Pop     AX
                Pop     SI
                Pop     DS

                Dec     AX
                Call    D_LoadSampleData

                Jmp     D_Load669Samples

D_Load669End:
                Jmp     D_PostLoadModule

EndP            D_Load669

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            D_LoadMOD Far

                Xor     AX, AX
                Call    D_PreLoadModule

                Mov     AH, 3Fh
                Mov     CX, 2048
                Mov     DX, 60000
                Int     21h

                Mov     SI, 60000
                Mov     DI, 4
                Mov     CX, 20
                Rep     MovsB           ; Song name
                Xor     AX, AX
                Mov     CX, 8
                Rep     StosW
                Add     DI, 4
                Mov     AX, 31h         ; Old effects, stereo, sample control
                StosW
                Xor     AX, AX
                StosW
                Mov     AX, 3080h       ; GV/MV
                StosW

                Mov     AX, 07D06h      ; 125 BPM, speed 6
                StosW

                Mov     AX, 64          ; Separation of 64
                StosW

                Xor     AX, AX
                Mov     CX, 5
                Rep     StosW

                Mov     DL, CS:MODNumberOfChannels
                Mov     CX, 64
                Cmp     DL, 8
                JBE     D_LoadMOD13

                Mov     CL, DL
                Mov     AL, 32
                Rep     StosB
                Mov     CL, 64
                Sub     CL, DL
                Jmp     D_LoadMOD14

D_LoadMOD13:
                Mov     AX, 4000h               ; Panning.
                StosW
                Mov     AX, 40h
                StosW
                Sub     CX, 4

                Cmp     DL, 4
                JBE     D_LoadMOD14

                Mov     AX, 4000h
                StosW
                Sub     CX, 2
                Cmp     DL, 6
                JBE     D_LoadMOD14

                Mov     AX, 40h
                StosW
                Sub     CX, 2

D_LoadMOD14:
                Mov     AL, 32+128
                Rep     StosB                   ; Clear Panning

                Mov     AL, 64
                Mov     CX, 64
                Rep     StosB                   ; Channel Volume

                Mov     DI, 256
                Mov     CX, 256
                Mov     AL, 0FFh
                Rep     StosB                   ; Orders.

                Mov     DI, 256
                Xor     CH, CH
                Mov     CL, CS:MODNumberOfOrders
                Mov     SI, CS:MODOrderOffset
                Mov     DX, SI
                Rep     MovsB                   ; copy orders...

                                                ; Get number of patterns to load
                Xor     CX, CX
                Mov     SI, DX
                Mov     AX, 07F00h

D_LoadMOD1:
                LodsB
                Cmp     CL, AL
                JAE     D_LoadMOD2

                Mov     CL, AL

D_LoadMOD2:
                Dec     AH
                JNZ     D_LoadMOD1

                Inc     CX                      ; CX = number of patterns to
                                                ;      load
                Push    CX

                Push    BX
                                                ; setup inst. headers
                Xor     CH, CH
                Mov     CL, CS:MODNumberOfInstruments
                Mov     SI, 60000+20
                Mov     DI, 512+55400

D_LoadMOD3:
                Push    CX

                Mov     EAX, 'SPMI'
                StosD

                Mov     CX, 6
                Xor     AX, AX
                Rep     StosW
                StosB
                Mov     AL, 64
                StosB
                Xor     AL, AL
                Mov     CX, [DS:SI+28]
                XChg    CH, CL
                Cmp     CX, 1
                JBE     D_LoadMOD4

                Or      AL, 16

D_LoadMOD4:
                Mov     CX, [DS:SI+22]
                XChg    CH, CL
                Cmp     CX, 1
                JBE     D_LoadMOD5

                Or      AL, 1

D_LoadMOD5:
                StosB
                Mov     AL, [DS:SI+25]
                StosB
                Mov     CX, 22
                Rep     MovsB
                Xor     EAX, EAX
                StosD

                Mov     AX, 1+32*256            ; Convert signed->Unsigned
                StosW                           ; Default pan of 32

                LodsW
                XChg    AH, AL                  ; Sample length...
                Add     EAX, EAX
                StosD
                Mov     EDX, EAX                ; EDX = length

                MovZX   EAX, Word Ptr [DS:SI+2]         ; Loop begin
                XChg    AH, AL

                Cmp     CS:MODOrderOffset, 60472
                JE      D_LoadMOD15

                Add     EAX, EAX

D_LoadMOD15:
                Cmp     EAX, EDX
                JBE     D_LoadMODLengthCheck1

                Xor     EAX, EAX

D_LoadMODLengthCheck1:
                StosD
                Mov     ECX, EAX

                MovZX   EAX, Word Ptr [DS:SI+4]         ; Loop end
                XChg    AH, AL

                Cmp     CS:MODOrderOffset, 60472
                JE      D_LoadMOD16

                Add     EAX, EAX

D_LoadMOD16:
                Add     EAX, ECX
                Cmp     EAX, EDX
                JBE     D_LoadMODLengthCheck2

                Mov     EAX, EDX

D_LoadMODLengthCheck2:
                StosD

                LodsB                           ; C5Speed.
                And     AX, 15
                Mov     BX, AX
                Add     BX, BX
                Mov     AX, [CS:FineTuneTable+BX]
                StosW
                Xor     AX, AX
                Mov     CX, 9
                Rep     StosW

                Add     SI, 5

                Pop     CX
                Loop    D_LoadMOD3

                Pop     BX                      ; Now to load mod patterns.

                Mov     AX, 4200h
                Xor     CX, CX
                Mov     DX, CS:MODPatternOffset
                Int     21h                     ; set offset in file...

                Pop     CX
                Xor     AX, AX                  ; Start with pattern 0

D_LoadMOD6:
                Cmp     AX, CX
                JAE     D_LoadMOD7

                Push    AX
                Push    CX

                Push    DS

                Push    CS
                Pop     DS

                Push    AX                              ; AX = pattern num.
                Mov     SI, Offset PatternMsg
                Mov     DI, (4+16*80)*2
                Mov     AH, 5
                Call    S_DrawString

                Pop     DX                              ; DX = pattern num
                Pop     DS

                Push    DX

                Mov     AH, 3Fh
                Mov     CH, CS:MODNumberOfChannels
                Xor     CL, CL
                Xor     DX, DX
                Int     21h                             ; DS:0 contains pat data

                Pop     DX
                Xor     SI, SI
                Mov     AL, CS:MODNumberOfChannels
                Xor     AH, AH

                Call    PE_TranslateMODPattern

                Pop     CX
                Pop     AX
                Inc     AX
                Jmp     D_LoadMOD6


D_LoadMOD7:                                     ; Finished loading patterns
                Mov     CX, 1                   ; Time to load samples.

D_LoadMOD8:
                Push    CX
                Push    ES

                Mov     SI, CX
                Dec     SI
                Add     SI, SI
                Mov     SI, [ES:64912+SI]

                Test    Byte Ptr [ES:SI+12h], 1
                JZ      D_LoadMOD9

                Push    SI

                Push    CS
                Pop     DS

                Push    CX
                Mov     SI, Offset SampleMsg
                Mov     DI, (4+17*80)*2
                Mov     AH, 5
                Call    S_DrawString

;                Mov     AX, 4201h
;                Xor     CX, CX
;                Mov     DX, 4
;                Int     21h                     ; Progress pointer

                Pop     AX

                Pop     SI

                Push    ES
                Pop     DS

                Dec     AX                      ; AX = sample to load.
                Call    D_LoadSampleData

D_LoadMOD9:
                Pop     ES
                Pop     CX
                Inc     CX
                Cmp     CL, CS:MODNumberOfInstruments
                JBE     D_LoadMOD8

D_LoadMOD12:
                Jmp     D_PostLoadModule

                Ret

EndP            D_LoadMOD
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

ENDIF

Proc            ConvertOldInstrument            ; DS:SI points to inst.

                PushAD
                Push    DS
                Push    ES

                Push    DS
                Pop     ES

                Mov     DI, SI

                Mov     AL, [SI+11h]            ; Old format Flg
                Mov     [SI+130h], AL

                Mov     EAX, [SI+12h]           ; VLS, VLE, SLS, SLE
                Mov     [SI+132h], EAX

                Mov     AX, [SI+18h]            ; Fadeout
                Add     AX, AX
                Mov     [SI+14h], AX

                Mov     AL, [SI+1Ah]
                Mov     [SI+11h], AL

                Xor     AX, AX
                Mov     AL, [SI+1Bh]
                Mov     [SI+12h], AX            ; DCT

                Mov     AX, 60*256              ; PPS, PPC
                Mov     [SI+16h], AX

                Mov     AX, 128+(32+128)*256          ; GbV+DfP
                Mov     [SI+18h], AX

                Xor     AX, AX
                Mov     [SI+1Ah], AX
                                                ; Now for envelope
                Push    SI
                Xor     CX, CX

                Add     SI, 1F8h
                Add     DI, 136h

D_LoadITInstrument2:
                LodsW
                Cmp     AX, 0FFFFh
                JE      D_LoadITInstrument3

                Mov     [DI], AH                ; Magintude
                Xor     AH, AH
                Mov     [DI+1], AX              ; Tick

                Add     DI, 3
                Inc     CX
                Cmp     CL, 25
                JAE     D_LoadITInstrument3

                Jmp     D_LoadITInstrument2

D_LoadITInstrument3:
                Pop     SI
                Mov     [SI+131h], CL

                Mov     CX, SI
                Add     CX, 554
                Sub     CX, DI
                Xor     AL, AL
                Rep     StosB

                Mov     Byte Ptr [SI+183h], 2 ; Num nodes for panning + pitch
                Mov     Byte Ptr [SI+1D5h], 2

                Mov     Byte Ptr [SI+18Ch], 99 ; Magn 0 at Tick 99
                Mov     Byte Ptr [SI+1DEh], 99 ; Magn 0 at Tick 99

                Pop     ES
                Pop     DS
                PopAD

                Ret

EndP            ConvertOldInstrument

IF TUTORIAL
ELSE

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            D_LoadIT Far

                Xor     AX, AX
                Call    D_PreLoadModule

                Push    DS

                Push    CS
                Pop     DS
                Mov     SI, Offset HeaderMsg
                Mov     DI, (4+16*80)*2
                Mov     AH, 5
                Call    S_DrawString

                Pop     DS

                Mov     AH, 3Fh
                Mov     CX, 2048
                Xor     DX, DX
                Int     21h

                Cmp     Word Ptr [DS:28h], 208h
                JB      D_ConvertITTimer

                Mov     EAX, [DS:3Ch]
                Xor     EAX, 'ITRK'
                RoR     EAX, 7
                Neg     EAX
                RoL     EAX, 4
                Xor     EAX, 'JTHL'
                Mov     [DS:3Ch], EAX

D_ConvertITTimer:
                Test    Byte Ptr [DS:2Eh], 2    ; Time data?
                JZ      D_LoadTimeDataNone

                                                ; Seek to 0C0+Orders+
                                                ; (ins+samp+pat)*4
                Mov     DX, [DS:22h]
                Add     DX, [DS:24h]
                Add     DX, [DS:26h]
                ShL     DX, 2
                Add     DX, [DS:20h]
                Add     DX, 0C0h
                Xor     CX, CX
                Mov     AX, 4200h
                Int     21h

                Push    DS

                Push    CS
                Pop     DS

                Mov     AH, 3Fh
                Mov     CX, 2
                Mov     DX, Offset NumTimerData
                Int     21h

                Push    BX              ; Allocate data for timedata
                Mov     BX, NumTimerData
                Cmp     BX, 0FFFFh
                JNE     D_NoTimerDataOverFlow

                Dec     BX
                Mov     NumTimerData, BX

D_NoTimerDataOverFlow:
                Mov     CX, BX
                ShR     BX, 1
                Inc     BX
                Mov     AH, 48h
                Int     21h
                Pop     BX
                JC      D_LoadTimeDataEnd

                Mov     TimerData, AX
                Mov     DS, AX
                ShL     CX, 3
                Xor     DX, DX
                Mov     AH, 3Fh
                Int     21h

D_LoadTimeDataEnd:
                Pop     DS

D_LoadTimeDataNone:
                Test    Byte Ptr [DS:2Eh], 8
                JZ      D_LoadMIDIConfigDataNone

                PushA
                Push    DS

                Call    Music_GetMIDIDataArea
                Xor     DX, DX
                Mov     CX, 4896
                Mov     AH, 3Fh
                Int     21h

                Pop     DS
                PopA

D_LoadMIDIConfigDataNone:
                Test    Byte Ptr [DS:2Eh], 1
                JZ      D_LoadITMsg1
                                                ; Load the message
                                ; Move to offset first.
                Mov     AX, 4200h
                Mov     CX, [DS:3Ah]
                Mov     DX, [DS:38h]
                Int     21h             ; Seek to position

                Push    DS

                Mov     CX, [DS:36h]
                Call    Msg_GetMessageOffset
                Mov     AH, 3Fh
                Int     21h

                Pop     DS

D_LoadITMsg1:
                        ; Actually, load row hilights first...
                Test    Byte Ptr [DS:2Eh], 4
                JZ      D_LoadITNoHilight

                Mov     AX, [DS:1Eh]
                Push    DS

                Push    Pattern
                Pop     DS
                        Assume DS:Pattern
                Mov     Word Ptr [RowHilight1], AX

                Pop     DS
                        Assume DS:Nothing

D_LoadITNoHilight:
                Xor     SI, SI
                Xor     DI, DI
                Mov     CX, 192
                Rep     MovsB                           ; Header

                Mov     DI, 256
                Mov     CX, [DS:20h]

                Mov     DX, DI
                Dec     CX
                Sub     DX, CX
                Rep     MovsB                           ; Orders
                Mov     AL, 0FFh
                Mov     CX, DX
                Rep     StosB

                Inc     SI                              ; SI points to first
                                                        ; pointer

                Xor     BP, BP                          ; Instrument time.

D_LoadIT1:
                Cmp     BP, [DS:22h]
                JAE     D_LoadIT2

                Push    DS
                Push    SI

                Push    CS
                Pop     DS
                Mov     SI, Offset InstrumentMsg
                Mov     AX, BP
                Inc     AX
                Push    AX
                Mov     AH, 5
                Mov     DI, (4+17*80)*2
                Call    S_DrawString
                Pop     AX

                Pop     SI
                Pop     DS
                                                ; Move to offset..
                LodsW
                Mov     DX, AX
                LodsW
                Mov     CX, AX
                Mov     AX, 4200h
                Int     21h

                Mov     DI, [DS:2Ah]            ; Format version

                Push    DS
                Push    SI

                Push    ES
                Pop     DS
                Mov     SI, BP
                Add     SI, SI
                Mov     DX, [DS:64712+SI]
                Mov     CX, 554
                Mov     AH, 3Fh
                Int     21h

                Cmp     DI, 200h
                JAE     D_LoadITInstrument1

                Mov     SI, DX
                Call    ConvertOldInstrument

D_LoadITInstrument1:
                Pop     SI
                Pop     DS
                Inc     BP
                Jmp     D_LoadIT1

D_LoadIT2:
                Xor     BP, BP                          ; Sample header time.

D_LoadIT3:
                Cmp     BP, [DS:24h]
                JAE     D_LoadIT4

                Push    DS
                Push    SI

                Push    CS
                Pop     DS
                Mov     SI, Offset SHLoadMsg
                Mov     AX, BP
                Inc     AX
                Push    AX
                Mov     AH, 5
                Mov     DI, (4+18*80)*2
                Call    S_DrawString
                Pop     AX

                Pop     SI
                Pop     DS
                                                ; Move to offset..
                LodsW
                Mov     DX, AX
                LodsW
                Mov     CX, AX
                Mov     AX, 4200h
                Int     21h

                Push    DS
                Push    SI

                Push    ES
                Pop     DS

                Mov     SI, BP
                Add     SI, SI
                Mov     DX, [DS:64912+SI]
                Mov     CX, 80
                Mov     AH, 3Fh
                Int     21h

                Pop     SI
                Pop     DS
                Inc     BP
                Jmp     D_LoadIT3

D_LoadIT4:
                Xor     BP, BP

                Push    DS
                Push    SI


                Push    ES
                Pop     DS                      ; DS now points to song data.

D_LoadIT7:
                Mov     SI, BP
                Add     SI, SI
                Mov     SI, [64912+SI]

                Test    Byte Ptr [DS:SI+12h], 1
                JZ      D_LoadIT8

                Push    DS
                Push    SI

                Push    CS
                Pop     DS
                Mov     SI, Offset SampleMsg
                Mov     AX, BP
                Inc     AX
                Push    AX
                Mov     AH, 5
                Mov     DI, (4+19*80)*2
                Call    S_DrawString
                Pop     AX

                Pop     SI
                Pop     DS

                Mov     AX, 4200h
                Xor     CX, CX
                Xor     DX, DX
                XChg    DX, [DS:SI+48h]
                XChg    CX, [DS:SI+4Ah]
                Int     21h                     ; Move file pointer.

                Mov     AX, BP
                Call    D_LoadSampleData
                Jmp     D_LoadITSamplePresent

D_LoadIT8:
                Mov     DWord Ptr [SI+48h], 0

D_LoadITSamplePresent:
                Inc     BP
                Cmp     BP, 99
                JB      D_LoadIT7

                Pop     SI
                Pop     DS

                Xor     BP, BP

D_LoadIT5:
                Cmp     BP, [DS:26h]            ; Pattern time.
                JAE     D_LoadIT6

                Push    ES

                Push    DS
                Push    SI

                Push    CS
                Pop     DS
                Mov     SI, Offset PatternMsg
                Push    BP
                Mov     AH, 5
                Mov     DI, (4+20*80)*2
                Call    S_DrawString
                Pop     AX

                Pop     SI
                Pop     DS
                                                ; Move to offset..
                LodsW
                Mov     DX, AX
                LodsW
                Mov     CX, AX
                And     DX, DX
                JNZ     D_LoadIT12
                And     CX, CX
                JZ      D_LoadIT13

D_LoadIT12:
                Mov     AX, 4200h
                Int     21h

                Push    DS
                Push    SI

                Mov     AH, 3Fh
                Mov     DX, 60000
                Mov     CX, 8
                Int     21h                     ; DS:DX = pattern header.

                Mov     DX, [DS:60000]          ; DX = length
                Push    DX
                Add     DX, 8
                Mov     SI, BP

                Push    BX
                Call    Music_AllocatePattern
                                                ; ES:DI = location.
                Pop     BX

                Mov     AX, ES
                And     AX, AX
                JZ      D_LoadIT10

                Mov     SI, 60000
                Mov     CX, 8
                Rep     MovsB

                Push    ES
                Pop     DS
                Mov     DX, DI
                Mov     AH, 3Fh
                Pop     CX                      ; CX = length.
                Int     21h

                Jmp     D_LoadIT11

D_LoadIT10:
                Pop     CX
                Push    BX


                Call    PEFunction_OutOfMemoryMessage

                Pop     BX

D_LoadIT11:
                Pop     SI
                Pop     DS

D_LoadIT13:
                Pop     ES

                Inc     BP
                Jmp     D_LoadIT5

D_LoadIT6:
                Jmp     D_PostLoadModule

                Ret

EndP            D_LoadIT

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            D_LoadFileImpulseModule Far

                Mov     SI, 1
                Mov     CX, Object1
                Mov     DX, Offset O1_LoadITList

                Mov     AX, 5
                Ret

EndP            D_LoadFileImpulseModule

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            D_LoadFileS3MModule Far

                Mov     SI, 1
                Mov     CX, Object1
                Mov     DX, Offset O1_LoadS3MList

                Mov     AX, 5
                Ret

EndP            D_LoadFileS3MModule

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            D_LoadFile669Module Far

                Mov     SI, 1
                Mov     CX, Object1
                Mov     DX, Offset O1_Load669List

                Mov     AX, 5
                Ret

EndP            D_LoadFile669Module

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            D_LoadFileXMModule Far

                Mov     SI, 1
                Mov     CX, Object1
                Mov     DX, Offset O1_LoadXMList

                Mov     AX, 5
                Ret

EndP            D_LoadFileXMModule

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            D_LoadFileMTMModule Far

                Mov     SI, 1
                Mov     CX, Object1
                Mov     DX, Offset O1_LoadMTMList

                Mov     AX, 5
                Ret

EndP            D_LoadFileMTMModule

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            D_LoadFileMODModule Far

                Mov     AL, 31
                Mov     CL, [DS:60000+950]
                Mov     DX, 60952
                Mov     SI, 1084

                Cmp     Word Ptr [BX+23], 16
                JNE     D_LoadFileMODModule1

                Mov     AL, 15
                Mov     CL, [DS:60000+470]
                Mov     DX, 60472
                Mov     SI, 600

D_LoadFileMODModule1:
                Mov     CS:MODNumberOfInstruments, AL
                Mov     CS:MODNumberOfOrders, CL
                Mov     CS:MODOrderOffset, DX
                Mov     CS:MODPatternOffset, SI

                Mov     SI, [BX+23]
                Cmp     SI, 17
                JNE     D_LoadFileMODModule2

                Mov     AL, [BX+22]
                Jmp     D_LoadFileMODModule3

D_LoadFileMODModule2:
                Sub     SI, 9
                Mov     AL, [CS:MODChannelTable+SI]

D_LoadFileMODModule3:
                Mov     CS:MODNumberOfChannels, AL

                Mov     SI, 1
                Mov     CX, Object1
                Mov     DX, Offset O1_LoadMODList

                Mov     AX, 5
                Ret

EndP            D_LoadFileMODModule

ENDIF

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

