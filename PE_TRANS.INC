
XMVolume        DB      0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            TranslateXMNote

                Cmp     AL, 96
                JBE     TranslateXMNote1

                Mov     AL, 0FFh-11     ; Note off

TranslateXMNote1:
                Add     AL, 11
                StosB
                Ret

EndP            TranslateXMNote

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

XMEffectG       DB      193, 193+4, 193+5, 193+6, 193+6, 193+7, 193+7, 193+8
                DB      193+8, 193+9

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            TranslateXMInstrument

                Cmp     AL, 99
                JBE     TranslateXMInstrument1

                Xor     AL, AL

                Cmp     Byte Ptr [ES:DI-1], 0FFh ; note off?
                JE      TranslateXMInstrument2
                Mov     Byte Ptr [ES:DI-1], 0FDh
                Jmp     TranslateXMInstrument2

TranslateXMInstrument1:
                Cmp     Byte Ptr [ES:DI-1], 0FFh ; note off?
                JNE     TranslateXMInstrument2

                Xor     AL, AL

TranslateXMInstrument2:
                StosB
                Ret

EndP            TranslateXMInstrument

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            TranslateXMVolume

                Push    AX

                Mov     AH, AL
                Mov     DX, AX
                Mov     AL, 0FFh
                Cmp     AH, 10h                 ; Nothing
                JB      TranslateXMVolume1

                Mov     AL, AH
                Sub     AL, 10h
                Cmp     AH, 50h                 ; Volume
                JBE     TranslateXMVolume1

                Mov     AL, 0FFh
                Cmp     AH, 60h                 ; Nothing
                JB      TranslateXMVolume1

                Mov     AL, AH
                And     AX, 0F00Fh

                Cmp     AL, 9
                JBE     TranslateXMVolume2

                Mov     AL, 9

TranslateXMVolume2:
                Cmp     AH, 70h
                JAE     TranslateXMVolume3

                Add     AL, 95                  ; Volume down
                Jmp     TranslateXMVolume1

TranslateXMVolume3:
                Cmp     AH, 80h
                JAE     TranslateXMVolume4

                Add     AL, 85                  ; volume up
                Jmp     TranslateXMVolume1

TranslateXMVolume4:
                Cmp     AH, 90h
                JAE     TranslateXMVolume5

                Add     AL, 75                  ; Fine volume down
                Jmp     TranslateXMVolume1

TranslateXMVolume5:
                Cmp     AH, 0A0h
                JAE     TranslateXMVolume6

                Add     AL, 65                  ; fine volume up
                Jmp     TranslateXMVolume1

TranslateXMVolume6:
                Cmp     AH, 0B0h
                JAE     TranslateXMVolume7

                Mov     AL, 0FFh                ; Vibrato speed
                Jmp     TranslateXMVolume1

TranslateXMVolume7:
                Cmp     AH, 0C0h
                JAE     TranslateXMVolume8

                Cmp     AL, 3
                JBE     TranslateXMVolumeH

                Dec     AX

TranslateXMVolumeH:
                Add     AL, 203                 ; Vibrato
                Jmp     TranslateXMVolume1

TranslateXMVolume8:
                Cmp     AH, 0D0h
                JAE     TranslateXMVolume9

                Mov     AL, DL
                Sub     AL, 0C0h
                Mov     AH, AL
                ShL     AL, 2
                Or      AL, AH                   ;Panning
                Add     AL, 128
                Jmp     TranslateXMVolume1

TranslateXMVolume9:
                Cmp     AH, 0F0h
                JAE     TranslateXMVolume10

                Mov     AL, 0FFh                ; Pan slide left/right
                Jmp     TranslateXMVolume1

TranslateXMVolume10:                            ; Porta
                Push    BX
                Mov     BX, AX
                And     BX, 0FFh
                Mov     AL, [CS:XMEffectG+BX]
                Pop     BX

TranslateXMVolume1:
                StosB
                Pop     AX
                Ret

EndP            TranslateXMVolume

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            TranslateXMEffect               ; Given AX = data

                Test    AX, AX
                JNZ     TranslateXMEffect1

TranslateXMEffectVol:
                Xor     AX, AX
                Cmp     CS:XMVolume, 60h
                JB      TranslateXMEffectEnd
                Mov     DH, 0FFh
                Jmp     TranslateXMEffectVolume

TranslateXMEffect1:
                Cmp     AL, 'K'-'A'+0Ah
                JNE     TranslateXMEffect24

                Mov     AL, [ES:DI-3]
                Cmp     AL, 0FDh
                JNE     TranslateXMEffectVol

                Mov     Word Ptr [ES:DI-3], 0FFh
                Jmp     TranslateXMEffectVol

TranslateXMEffect24:
                Cmp     AL, 0
                JNE     TranslateXMEffect2

                Mov     AL, 'J'-'@'
                Jmp     TranslateXMEffectEnd

TranslateXMEffect2:
                Cmp     AL, 1
                JNE     TranslateXMEffect3

                Mov     AL, 'F'-'@'
                Test    AH, AH
                JNZ     TranslateXMEffectEnd
                Cmp     CS:XMVolume, 60h
                JB      TranslateXMEffectEnd
                Mov     DH, 105
                Jmp     TranslateXMEffectVolume

TranslateXMEffect3:
                Cmp     AL, 2
                JNE     TranslateXMEffect4

                Mov     AL, 'E'-'@'
                Test    AH, AH
                JNZ     TranslateXMEffectEnd
                Cmp     CS:XMVolume, 60h
                JB      TranslateXMEffectEnd
                Mov     DH, 115
                Jmp     TranslateXMEffectVolume

TranslateXMEffect4:
                Cmp     AL, 3
                JNE     TranslateXMEffect5

                Mov     AL, 'G'-'@'
                Test    AH, AH
                JNZ     TranslateXMEffectEnd
                Cmp     CS:XMVolume, 60h
                JB      TranslateXMEffectEnd
                Mov     DH, 193
                Jmp     TranslateXMEffectVolume

TranslateXMEffect5:
                Cmp     AL, 4
                JNE     TranslateXMEffect6

                Mov     AL, AH
                And     AX, 0FF0h
                Cmp     AH, 4
                JBE     TranslateXMEffectH1

                Dec     AH

TranslateXMEffectH1:
                Or      AH, AL
                Mov     AL, 'H'-'@'
                Test    AH, AH
                JNZ     TranslateXMEffectEnd
                Cmp     CS:XMVolume, 60h
                JB      TranslateXMEffectEnd
                Mov     DH, 203
                Jmp     TranslateXMEffectVolume

TranslateXMEffect6:
                Cmp     AL, 5
                JNE     TranslateXMEffect7

                Mov     AL, 'L'-'@'
                Jmp     TranslateXMEffectEnd

TranslateXMEffect7:
                Cmp     AL, 6
                JNE     TranslateXMEffect8

                Mov     AL, 'K'-'@'
                Jmp     TranslateXMEffectEnd

TranslateXMEffect8:
                Cmp     AL, 7
                JNE     TranslateXMEffect9

                Mov     AL, 'R'-'@'
                Jmp     TranslateXMEffectEnd

TranslateXMEffect9:
                Cmp     AL, 8
                JNE     TranslateXMEffect10

                Mov     AL, 'X'-'@'
                Cmp     CS:XMVolume, 60h
                JB      TranslateXMEffectEnd
                Mov     DH, AH
                ShR     DH, 2
                AdC     DH, 128
                Jmp     TranslateXMEffectVolume

TranslateXMEffect10:
                Cmp     AL, 9
                JNE     TranslateXMEffect11

                Mov     AL, 'O'-'@'
                Jmp     TranslateXMEffectEnd

TranslateXMEffect11:
                Cmp     AL, 0Ah
                JNE     TranslateXMEffect12

                Mov     AL, 'D'-'@'
                Jmp     TranslateXMEffectEnd

TranslateXMEffect12:
                Cmp     AL, 0Bh
                JNE     TranslateXMEffect13

                Mov     AL, 'B'-'@'
                Jmp     TranslateXMEffectEnd

TranslateXMEffect13:
                Cmp     AL, 0Ch
                JNE     TranslateXMEffect14

                Mov     DH, AH
                Cmp     DH, 64
                JB      TranslateXMEffectVolume

                Mov     DH, 64

TranslateXMEffectVolume:
                Mov     AL, CS:XMVolume
                Mov     AH, AL
                And     AH, 0Fh

                Cmp     AL, 60h
                JAE     TranslateXMEffectVolume1

                Xor     AX, AX
                Jmp     TranslateXMEffectVolumeEnd

TranslateXMEffectVolume1:
                Cmp     AL, 70h
                JAE     TranslateXMEffectVolume2

                Mov     AL, 'D'-'@'
                Jmp     TranslateXMEffectVolumeEnd

TranslateXMEffectVolume2:
                Cmp     AL, 80h
                JAE     TranslateXMEffectVolume3

                Mov     AL, 'D'-'@'
                ShL     AH, 4
                Jmp     TranslateXMEffectVolumeEnd

TranslateXMEffectVolume3:
                Cmp     AL, 90h
                JAE     TranslateXMEffectVolume4

                Mov     AL, 'D'-'@'
                Test    AH, AH
                JZ      TranslateXMEffect3Memory
                Or      AH, 0F0h
                Cmp     AH, 0FFh
                JNE     TranslateXMEffect3Memory

                Dec     AH

TranslateXMEffect3Memory:
                Jmp     TranslateXMEffectVolumeEnd

TranslateXMEffectVolume4:
                Cmp     AL, 0A0h
                JAE     TranslateXMEffectVolume5

                Mov     AL, 'D'-'@'
                Test    AH, AH
                JZ      TranslateXMEffect4Memory

                ShL     AH, 4
                Or      AH, 0Fh

TranslateXMEffect4Memory:
                Jmp     TranslateXMEffectVolumeEnd

TranslateXMEffectVolume5:
                Cmp     AL, 0B0h
                JAE     TranslateXMEffectVolume6

                Mov     AL, 'H'-'@'
                ShL     AH, 4
                Jmp     TranslateXMEffectVolumeEnd

TranslateXMEffectVolume6:
                Cmp     AL, 0C0h
                JAE     TranslateXMEffectVolume7

                Cmp     AH, 4
                JBE     TranslateXMEffectVolumeH6

                Dec     AH

TranslateXMEffectVolumeH6:
                Mov     AL, 'H'-'@'
                Jmp     TranslateXMEffectVolumeEnd

TranslateXMEffectVolume7:
                Cmp     AL, 0D0h
                JAE     TranslateXMEffectVolume8

                Mov     AL, 'S'-'@'
                Or      AH, 80h
                Jmp     TranslateXMEffectVolumeEnd

TranslateXMEffectVolume8:
                Cmp     AL, 0E0h
                JAE     TranslateXMEffectVolume9

                Mov     AL, 'P'-'@'
                ShL     AH, 4
                Jmp     TranslateXMEffectVolumeEnd

TranslateXMEffectVolume9:
                Cmp     AL, 0F0h
                JAE     TranslateXMEffectVolume10

                Mov     AL, 'P'-'@'
                Jmp     TranslateXMEffectVolumeEnd

TranslateXMEffectVolume10:
                Mov     AL, 'G'-'@'
                ShL     AH, 4

TranslateXMEffectVolumeEnd:
                Mov     [ES:DI-1], DH
                StosW
                Ret

TranslateXMEffect14:
                Cmp     AL, 0Dh
                JNE     TranslateXMEffect15

                Mov     AL, AH
                And     AX, 0F00Fh
                ShR     AH, 1
                Add     AL, AH
                ShR     AH, 2
                Add     AH, AL
                Mov     AL, 'C'-'@'
                Jmp     TranslateXMEffectEnd

TranslateXMEffect15:
                Cmp     AL, 0Eh
                JNE     TranslateXMEffect16

                ; 'Multiplex' effect
                Mov     AL, AH
                And     AX, 0FF0h
                Test    AL, AL
                JNZ     TranslateXMEffectE1

                Xor     AX, AX
                Jmp     TranslateXMEffectEnd

TranslateXMEffectE1:
                Cmp     AL, 10h
                JNE     TranslateXMEffectE2

                Test    AH, AH
                JZ      TranslateE1Memory
                Or      AH, 0F0h

TranslateE1Memory:
                Mov     AL, 'F'-'@'

                Jmp     TranslateXMEffectEnd

TranslateXMEffectE2:
                Cmp     AL, 20h
                JNE     TranslateXMEffectE3

                Test    AH, AH
                JZ      TranslateE2Memory
                Or      AH, 0F0h

TranslateE2Memory:
                Mov     AL, 'E'-'@'

                Jmp     TranslateXMEffectEnd

TranslateXMEffectE3:
                Cmp     AL, 30h
                JNE     TranslateXMEffectE4

                Xor     AX, AX
                Jmp     TranslateXMEffectEnd

TranslateXMEffectE4:
                Cmp     AL, 40h
                JNE     TranslateXMEffectE5

                Or      AH, 30h
                Mov     AL, 'S'-'@'

                Jmp     TranslateXMEffectEnd

TranslateXMEffectE5:
                Cmp     AL, 50h
                JNE     TranslateXMEffectE6

                Xor     AX, AX
                Jmp     TranslateXMEffectEnd

TranslateXMEffectE6:
                Cmp     AL, 60h
                JNE     TranslateXMEffectE7

                Or      AH, 0B0h
                Mov     AL, 'S'-'@'

                Jmp     TranslateXMEffectEnd

TranslateXMEffectE7:
                Cmp     AL, 70h
                JNE     TranslateXMEffectE8

                Or      AH, 040h
                Mov     AL, 'S'-'@'

                Jmp     TranslateXMEffectEnd

TranslateXMEffectE8:
                Cmp     AL, 80h
                JNE     TranslateXMEffectE9

                Or      AH, 80h
                Mov     AL, 'S'-'@'

                Jmp     TranslateXMEffectEnd

TranslateXMEffectE9:
                Cmp     AL, 90h
                JNE     TranslateXMEffectEA

                Mov     AL, 'Q'-'@'
                Test    AH, AH
                JNZ     TranslateXMEffectEnd
                Jmp     TranslateXMEffectVol

TranslateXMEffectEA:
                Cmp     AL, 0A0h
                JNE     TranslateXMEffectEB

                Test    AH, AH
                JZ      TranslateXMEAMemory

                ShL     AH, 4
                Or      AH, 0Fh

TranslateXMEAMemory:
                Mov     AL, 'D'-'@'

                Jmp     TranslateXMEffectEnd

TranslateXMEffectEB:
                Cmp     AL, 0B0h
                JNE     TranslateXMEffectEC

                Test    AH, AH
                JZ      TranslateXMEBMemory

                Or      AH, 0F0h
                Cmp     AH, 0FFh
                JNE     TranslateXMEBMemory

                Dec     AH

TranslateXMEBMemory:
                Mov     AL, 'D'-'@'

                Jmp     TranslateXMEffectEnd

TranslateXMEffectEC:
                Cmp     AL, 0C0h
                JNE     TranslateXMEffectED

                Or      AH, 0C0h
                Mov     AL, 'S'-'@'

                Jmp     TranslateXMEffectEnd

TranslateXMEffectED:
                Cmp     AL, 0D0h
                JNE     TranslateXMEffectEE

                Or      AH, 0D0h
                Mov     AL, 'S'-'@'

                Jmp     TranslateXMEffectEnd

TranslateXMEffectEE:
                Cmp     AL, 0E0h
                JNE     TranslateXMEffectEF

                Or      AH, 0E0h
                Mov     AL, 'S'-'@'
                Jmp     TranslateXMEffectEnd

TranslateXMEffectEF:
                Xor     AX, AX
                Jmp     TranslateXMEffectEnd

TranslateXMEffect16:
                Cmp     AL, 0Fh
                JNE     TranslateXMEffect18

                Mov     AL, 'T'-'@'
                Cmp     AH, 20h
                JAE     TranslateXMTempo1

                Mov     AL, 'A'-'@'

TranslateXMTempo1:
                Jmp     TranslateXMEffectEnd

TranslateXMEffect18:
                Cmp     AL, 10h         ; 'G'lobal volume
                JNE     TranslateXMEffect19

                Mov     AL, 'V'-'@'
                Cmp     AH, 40h
                JB      TranslateXMEffectV

                Mov     AH, 80h
                Jmp     TranslateXMEffectEnd

TranslateXMEffectV:
                ShL     AH, 1
                Jmp     TranslateXMEffectEnd

TranslateXMEffect19:
                Cmp     AL, 11h         ; 'H'
                JNE     TranslateXMEffect20

                Mov     AL, AH
                And     AX, 0FF0h
                ShL     AH, 1
                Cmp     AH, 0Fh
                JBE     TranslateGlobalVolSlide2

                Mov     AH, 0Fh

TranslateGlobalVolSlide2:
                ShL     AL, 1
                JNC     TranslateGlobalVolSlide1

                Mov     AL, 0F0h

TranslateGlobalVolSlide1:
                Or      AH, AL
                Mov     AL, 'W'-'@'
                Jmp     TranslateXMEffectEnd

TranslateXMEffect20:
                Cmp     AL, 'R'-'A'+0Ah
                JNE     TranslateXMEffect21

                Mov     AL, 'Q'-'@'
                Jmp     TranslateXMEffectEnd

TranslateXMEffect21:
                Cmp     AL, 'T'-'A'+0Ah
                JNE     TranslateXMEffect22

                Mov     AL, AH
                And     AX, 0FF0h
                Test    AH, AH
                JNZ     Tremor1

                Inc     AH

Tremor1:
                Test    AL, AL
                JNZ     Tremor2

                Inc     AX
Tremor2:
                Or      AH, AL
                Mov     AL, 'I'-'@'
                Jmp     TranslateXMEffectEnd

TranslateXMEffect22:
                Cmp     AL, 'X'-'A'+0Ah
                JNE     TranslateXMEffect23

                Mov     AL, AH
                And     AX, 0FF0h
                Or      AH, 0E0h
                Cmp     AL, 10h
                JE      TranslateXMEffectX1
                Cmp     AL, 20h
                JE      TranslateXMEffectX2

                Xor     AX, AX
                Jmp     TranslateXMEffectEnd

TranslateXMEffectX1:
                Mov     AL, 'F'-'@'
                Jmp     TranslateXMEffectEnd

TranslateXMEffectX2:
                Mov     AL, 'E'-'@'
                Jmp     TranslateXMEffectEnd

TranslateXMEffect23:
                Cmp     AL, 'Z'-'A'+0Ah
                JNE     TranslateXMEffect25

                Mov     AL, 'Z'-'@'
                Jmp     TranslateXMEffectEnd

TranslateXMEFfect25:
                Jmp     TranslateXMEffectVol
;                Xor     AX, AX

TranslateXMEffectEnd:
                StosW
                Ret

EndP            TranslateXMEffect

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            PE_TranslateXMPattern Far               ; DS:SI points to
                                                        ; data, AX = rows
                                                        ; CX = channels
                                                        ; DX = pattern num

                                                        ; Has to return DS:SI
                PushA
                Push    DS
                Push    ES

                Dec     AX
                Mov     CS:TempVariableArea3, AX
                Cmp     AX, 31
                JAE     PE_XMLimitRows

                Mov     AX, 31

PE_XMLimitRows:
                Mov     CS:MaxRow, AX
                Mov     CS:PatternNumber, DX            ; Pattern number
                Mov     CS:TempVariableArea2, CX        ; Channels

                Call    PE_ClearPatternData

                Mov     ES, CS:PatternDataArea
                Xor     DI, DI
                Xor     AX, AX          ; AX = row number

PE_TranslateXMPattern1:
                Push    AX
                Push    DI

                Mov     CX, CS:TempVariableArea2        ; CX = channels

PE_TranslateXMPattern2:
                Push    CX

                LodsB                   ; AL = either note or compression
                                        ;      control.
                Test    AL, AL
                JS      PE_TranslateXMPatternCompressed

                Call    TranslateXMNote
                LodsB
                Call    TranslateXMInstrument
                LodsB
                Mov     CS:XMVolume, AL
                Call    TranslateXMVolume
                LodsW
                Call    TranslateXMEffect
                Jmp     PE_TranslateXMPattern3

PE_TranslateXMPatternCompressed:
                Mov     CS:XMVolume, 0
                Mov     AH, AL
                Test    AH, 1
                JZ      PE_TranslateXMPattern4

                LodsB
                Call    TranslateXMNote
                Dec     DI

PE_TranslateXMPattern4:
                Inc     DI

                Test    AH, 2
                JZ      PE_TranslateXMPattern5

                LodsB
                Call    TranslateXMInstrument
                Dec     DI

PE_TranslateXMPattern5:
                Inc     DI

                Test    AH, 4
                JZ      PE_TranslateXMPattern6

                LodsB
                Mov     CS:XMVolume, AL
                Call    TranslateXMVolume
                Dec     DI

PE_TranslateXMPattern6:
                Inc     DI

                Xor     AL, AL
                Test    AH, 8
                JZ      PE_TranslateXMPattern7

                LodsB

PE_TranslateXMPattern7:
                Test    AH, 10h
                Mov     AH, 0
                JZ      PE_TranslateXMPattern8

                Mov     AH, [SI]
                Inc     SI

PE_TranslateXMPattern8:
                Call    TranslateXMEffect

PE_TranslateXMPattern3:
                Pop     CX
                Dec     CX
                JNZ     PE_TranslateXMPattern2

                Pop     DI
                Pop     AX
                Add     DI, 320                         ; Next row.
                Inc     AX
                Cmp     AX, CS:TempVariableArea3
                JBE     PE_TranslateXMPattern1

                Mov     CS:TempVariableArea, SI

                Mov     AX, CS:TempVariableArea3
                Cmp     AX, CS:MaxRow
                JE      PE_TranslateXMPatternNoBreak

                Mov     DX, 320
                Mul     DX
                Mov     DI, AX
                Add     DI, 3

PE_TranslateXMPatternBreak1:
                Cmp     Word Ptr [ES:DI], 0
                JE      PE_TranslateXMPatternBreak2

                Add     DI, 5
                Jmp     PE_TranslateXMPatternBreak1

PE_TranslateXMPatternBreak2:
                Mov     Word Ptr [ES:DI], 'C'-'@'    ; Break.

PE_TranslateXMPatternNoBreak:
                Push    CS
                Pop     DS

                Call    Far Ptr PE_TranslateS3MPointer8


                Pop     ES
                Pop     DS
                PopA

                Mov     SI, CS:TempVariableArea

                Ret

EndP            PE_TranslateXMPattern

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            TranslateMODCommand                     ; AL = command
                                                        ; AH = command value
                                                        ; ES:DI points to
                                                        ; command destination

                Test    AX, AX
                JNZ     TranslateMODCommand7

                StosW
                Ret

TranslateMODCommand7:
                Cmp     AL, 0
                JNE     TranslateMODCommand8

                Mov     AL, 'J'-'@'
                StosW
                Ret

TranslateMODCommand8:
                Cmp     AL, 1
                JNE     TranslateMODCommand9

                Mov     AL, 'F'-'@'
                Jmp     TranslateMODCommand36

TranslateMODCommand9:
                Cmp     AL, 2
                JNE     TranslateMODCommand10

                Mov     AL, 'E'-'@'
                Jmp     TranslateMODCommand36

TranslateMODCommand10:
                Cmp     AL, 3
                JNE     TranslateMODCommand11

                Mov     AL, 'G'-'@'
                StosW
                Ret

TranslateMODCommand11:
                Cmp     AL, 4
                JNE     TranslateMODCommand12

                Mov     AL, 'H'-'@'

                StosW
                Ret

TranslateMODCommand12:
                Cmp     AL, 5
                JNE     TranslateMODCommand13

                Mov     AL, 'L'-'@'
                Test    AH, AH
                JNZ     TranslateMODCommand40

                Mov     AX, 'G'-'@'

TranslateMODCommand40:
                StosW
                Ret

TranslateMODCommand13:
                Cmp     AL, 6
                JNE     TranslateMODCommand14

                Mov     AL, 'K'-'@'
                Test    AH, AH
                JNZ     TranslateMODCommand39

                Mov     AX, 'H'-'@'

TranslateMODCommand39:
                StosW
                Ret

TranslateMODCommand14:
                Cmp     AL, 7
                JNE     TranslateMODCommand15

                Mov     AL, 'R'-'@'
                StosW
                Ret

TranslateMODCommand15:
                Cmp     AL, 8
                JNE     TranslateMODCommand16

                Mov     AL, 'X'-'@'
                Cmp     AH, 0A4h
                JNE     TranslateMODNoSurround

                Mov     AX, 'S'-'@'+9100h

TranslateMODNoSurround:
                StosW
                Ret

TranslateMODCommand16:
                Cmp     AL, 9
                JNE     TranslateMODCommand17

                Mov     AL, 'O'-'@'
                StosW
                Ret

TranslateMODCommand17:
                Cmp     AL, 10
                JNE     TranslateMODCommand18

                Mov     AL, 'D'-'@'
                Test    AH, 0Fh
                JZ      TranslateMODVolumeSlide1
                Test    AH, 0F0h
                JZ      TranslateMODVolumeSlide1

                And     AH, 0F0h

TranslateMODVolumeSlide1:
                Jmp     TranslateMODCommand36

TranslateMODCommand18:
                Cmp     AL, 11
                JNE     TranslateMODCommand19

                Mov     AL, 'B'-'@'
                StosW
                Ret

TranslateMODCommand19:
                Cmp     AL, 12
                JNE     TranslateMODCommand20

                Cmp     AH, 64
                JBE     TranslateMODCommand37

                Mov     AH, 64

TranslateMODCommand37:
                Mov     [ES:DI-1], AH
                Add     DI, 2
                Ret

TranslateMODCommand20:
                Cmp     AL, 13
                JNE     TranslateMODCommand21

                Mov     AL, AH
                And     AX, 0F00Fh
                ShR     AH, 1                   ; AH = highnibble*8
                Add     AL, AH

                ShR     AH, 2                   ; AH = highnibble*2
                Add     AH, AL

                Mov     AL, 'C'-'@'
                StosW
                Ret

TranslateMODCommand21:
                Cmp     AL, 14
                JNE     TranslateMODCommand34

                Mov     AL, AH
                And     AX, 0FF0h

                Cmp     AL, 0
                JNE     TranslateMODCommand22

                Test    AH, AH
                JZ      TranslateMODCommand36

                Mov     AL, 'S'-'@'
                StosW
                Ret

TranslateMODCommand22:
                Cmp     AL, 10h
                JNE     TranslateMODCommand23

                Test    AH, AH
                JZ      TranslateMODCommand36

                Mov     AL, 'F'-'@'
                Or      AH, 0F0h
                StosW
                Ret

TranslateMODCommand23:
                Cmp     AL, 20h
                JNE     TranslateMODCommand24

                Test    AH, AH
                JZ      TranslateMODCommand36

                Mov     AL, 'E'-'@'
                Or      AH, 0F0h
                StosW
                Ret

TranslateMODCommand24:
                Cmp     AL, 30h
                JNE     TranslateMODCommand25

                Mov     AL, 'S'-'@'
                Or      AH, 010h
                StosW
                Ret

TranslateMODCommand25:
                Cmp     AL, 40h
                JNE     TranslateMODCommand26

                Mov     AL, 'S'-'@'
                Or      AH, 030h
                StosW
                Ret

TranslateMODCommand26:
                Cmp     AL, 50h
                JNE     TranslateMODCommand27

                Mov     AL, 'S'-'@'
                Or      AH, 020h
                StosW
                Ret

TranslateMODCommand27:
                Cmp     AL, 60h
                JNE     TranslateMODCommand28

                Mov     AL, 'S'-'@'
                Or      AH, 0B0h
                StosW
                Ret

TranslateMODCommand28:
                Cmp     AL, 70h
                JNE     TranslateMODCommand29

                Mov     AL, 'S'-'@'
                Or      AH, 40h
                StosW
                Ret

TranslateMODCommand29:
                Cmp     AL, 80h
                JNE     TranslateMODCommand30

                Or      AH, AL
                Mov     AL, 'S'-'@'
                StosW
                Ret

TranslateMODCommand30:
                Cmp     AL, 90h
                JNE     TranslateMODCommand31

                Test    AH, AH
                JZ      TranslateMODCommand36

                Mov     AL, 'Q'-'@'
                Jmp     TranslateMODCommand36

TranslateMODCommand31:
                Cmp     AL, 0A0h
                JNE     TranslateMODCommand32

                And     AH, 0Fh
                JZ      TranslateMODCommand36

                Mov     AL, 'D'-'@'
                ShL     AH, 4
                Or      AH, 0Fh
                StosW
                Ret

TranslateMODCommand32:
                Cmp     AL, 0B0h
                JNE     TranslateMODCommand33

                And     AH, 0Fh
                JZ      TranslateMODCommand36

                Mov     AL, 'D'-'@'
                Or      AH, 0F0h
                StosW
                Ret


TranslateMODCommand33:
                Or      AH, AL
                Mov     AL, 'S'-'@'
                StosW
                Ret

TranslateMODCommand34:                  ; Set speed.
                Cmp     AH, 20h
                JA      TranslateMODCommand35

                Mov     AL, 'A'-'@'
                Jmp     TranslateMODCommand36

TranslateMODCommand35:
                Mov     AL, 'T'-'@'
                StosW
                Ret

TranslateMODCommand36:
                Test    AH, AH
                JNZ     TranslateMODCommand38

                Xor     AX, AX

TranslateMODCommand38:
                StosW
                Ret

EndP            TranslateMODCommand

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            PE_TranslateMTMPattern Far              ; DS:SI points to data
                                                        ; DX = pattern no.
                PushA
                Push    DS
                Push    ES

                Mov     CS:MaxRow, 63
                Mov     CS:PatternNumber, DX

                Call    PE_ClearPatternData

                Mov     ES, CS:PatternDataArea
                Xor     DI, DI

                Mov     CX, 32

PE_TranslateMTMPattern1:
                Push    CX
                Push    DI

                Mov     CX, 64

PE_TranslateMTMPattern2:
                LodsW                           ; Layout of AX
                XChg    AH, AL
                                                ; ppppppiiiiiieeee
                                                ; p = pitch val
                                                ; i = ins
                                                ; e = effect
                Mov     DL, AL
                And     DL, 0Fh                 ; DL = effect.
                ShR     AX, 2                   ; AX = 00pppppp iiiiiixx
                ShR     AL, 2                   ; AH = pitch, AL = ins.
                XChg    AH, AL                  ; AH = ins. AL =pitch

                Test    AL, AL
                JZ      PE_TranslateMTMPattern3

                Add     AL, 36                  ; Middle octave C-5
                Jmp     PE_TranslateMTMPattern4

PE_TranslateMTMPattern3:
                Mov     AL, NONOTE

PE_TranslateMTMPattern4:
                StosB                           ; Pitch.

                Mov     AL, AH                  ; Instrument
                Mov     AH, 0FFh                ; volume
                StosW

                LodsB                           ; DL = effect, AL = effectval.
                Mov     AH, AL                  ; AH = AL = effectval. DL = eff.
                Mov     AL, DL

                Call    TranslateMODCommand

                Add     DI, 315
                Loop    PE_TranslateMTMPattern2

                Pop     DI
                Pop     CX
                Add     DI, 5
                Loop    PE_TranslateMTMPattern1

                Push    CS
                Pop     DS
                Call    Far Ptr PE_TranslateMODPattern1

                Pop     ES
                Pop     DS
                PopA

                Ret

EndP            PE_TranslateMTMPattern

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            PE_TranslateMODPattern Far              ; DS:SI points to data
                                                        ; DX = pattern no.
                                                        ; AX = number of channels
                PushA
                Push    DS
                Push    ES

                Mov     CS:MaxRow, 63
                Mov     CS:PatternNumber, DX

                Call    PE_ClearPatternData

                Mov     ES, CS:PatternDataArea
                Xor     DI, DI
                Mov     CX, 64

PE_TranslateMODPattern2:
                Push    AX
                Push    CX
                Push    DI

                Mov     CX, AX

PE_TranslateMODPattern3:
                Mov     AL, [DS:SI+1]
                Mov     AH, [DS:SI]
                And     AX, 0FFFh               ; AX = period of note.
                Mov     DX, 72
                Xor     BX, BX

PE_TranslateMODPattern4:
                Cmp     AX, [CS:MODPeriodTable+BX]
                JAE     PE_TranslateMODPattern5

                Add     BX, 2
                Dec     DX
                JNZ     PE_TranslateMODPattern4

                Inc     DI
                Jmp     PE_TranslateMODPattern6

PE_TranslateMODPattern5:
                ShR     BX, 1                   ; BL = note.
                Mov     AL, BL
                Add     AL, 36                  ; For C5 as central note.
                StosB

PE_TranslateMODPattern6:
                Mov     AL, [DS:SI]
                Mov     AH, [DS:SI+2]
                ShR     AH, 4
                And     AL, 0F0h
                Or      AL, AH
                StosB                           ; Sample stored.

                Inc     DI                      ; Points to effect/commandvalue

                Mov     AH, [DS:SI+3]
                Mov     AL, [DS:SI+2]
                And     AL, 0Fh                 ; AL = effect, AH = param.

                Call    TranslateMODCommand

                Add     SI, 4
                Loop    PE_TranslateMODPattern3

                Pop     DI
                Pop     CX
                Pop     AX
                Add     DI, 320
                Loop    PE_TranslateMODPattern2

                Push    CS
                Pop     DS
                Call    Far Ptr PE_TranslateMODPattern1

                Pop     ES
                Pop     DS
                PopA

                Ret

PE_TranslateMODPattern1:
                Call    PEFunction_StorePattern

                RetF

EndP            PE_TranslateMODPattern

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            PE_Translate669Pattern Far

                PushA                                   ; DS:0 points to data
                Push    DS                              ; CL = Maxrow
                Push    ES                              ; AH = Starting tempo
                                                        ; BP = PatternNumber
                Mov     Byte Ptr [CS:MaxRow], CL
                Mov     [CS:PatternNumber], BP

                Call    PE_ClearPatternData

                Mov     ES, CS:PatternDataArea
                Cmp     CL, 31
                JAE     Pattern669Rows

                Mov     [CS:MaxRow], 31

                Mov     AL, 5
                Mul     CL
                Mov     DI, AX
                ShL     DI, 6

                Mov     Word Ptr [ES:DI+8*5+3], 'C'-'@'

Pattern669Rows:
                Xor     DI, DI

                Mov     AL, 'A'-'@'
                Mov     [ES:DI+8*5+3], AX       ; Tempo setting
                Inc     CL
                Xor     SI, SI

                Xor     EAX, EAX
                Mov     BP, Offset EncodingInfo
                Mov     [CS:BP], EAX
                Mov     [CS:BP+4], EAX
                Mov     [CS:BP+8], EAX
                Mov     [CS:BP+12], EAX

Translate669Pattern1:
                Mov     CH, 8

Translate669Pattern2:
                LodsW
                Cmp     AL, 0FEh
                JB      Translate669Pattern4
                JE      Translate669Pattern3

                Add     DI, 3
                Jmp     Translate669Pattern5

Translate669Pattern3:
                Add     DI, 2
                ShR     AX, 6
                And     AL, 3Ch
                StosB
                Jmp     Translate669Pattern5

Translate669Pattern4:
                Mov     DX, AX          ; Note

                And     AX, 0F003h
                ShL     AL, 4
                ShR     AH, 4
                Or      AH, AL
                Inc     AH
                Mov     AL, DL
                ShR     AL, 2
                Add     AL, 36
                StosW

                Mov     AL, DH          ; Volume
                ShL     AL, 2
                And     AL, 3Ch
                StosB

                Mov     Word Ptr [CS:BP], 0

Translate669Pattern5:
                LodsB

                Cmp     AL, 0FFh
                JE      Translate669NoEffect

                Mov     AH, AL
                And     AX, 00FF0h

Translate669EffectA:                    ; Portamento Up
                Cmp     AL, 0
                JNE     Translate669EffectB

                Mov     AL, 'F'-'@'
                Mov     [CS:BP], AX
                Jmp     Translate669EffectEnd

Translate669EffectB:                    ; Portamento down
                Cmp     AL, 10h
                JNE     Translate669EffectC

                Mov     AL, 'E'-'@'
                Mov     [CS:BP], AX
                Jmp     Translate669EffectEnd

Translate669EffectC:                    ; Portamento to
                Cmp     AL, 20h
                JNE     Translate669EffectD

                Mov     AL, 'G'-'@'
                Mov     [CS:BP], AX
                Jmp     Translate669EffectEnd

Translate669EffectD:                    ; Frequency Adjust
                Cmp     AL, 30h
                JNE     Translate669EffectE

                Mov     AX, ('E'-'@')+0F100h
                Mov     Word Ptr [CS:BP], 0
                Jmp     Translate669EffectEnd

Translate669EffectE:                    ; Vibrato
                Cmp     AL, 40h
                JNE     Translate669EffectF

                Mov     AL, 'H'-'@'
                Or      AH, 80h
                Mov     [CS:BP], AX
                Jmp     Translate669EffectEnd

Translate669EffectF:
                Cmp     AL, 50h
                JNE     Translate669NoEffect

                Mov     AL, 'A'-'@'
                Mov     Word Ptr [CS:BP], 0
                Jmp     Translate669EffectEnd

Translate669NoEffect:
                Mov     AX, [CS:BP]

Translate669EffectEnd:
                StosW

                Add     BP, 2

                Dec     CH
                JNZ     Translate669Pattern2

                Add     DI, 320-8*5
                Mov     BP, Offset EncodingInfo

                Dec     CL
                JNZ     Translate669Pattern1

                Push    CS
                Pop     DS

                Call    Far Ptr PE_TranslateS3MPointer8

                Pop     ES
                Pop     DS
                PopA

                Ret

EndP            PE_Translate669Pattern

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            PE_TranslateS3MPattern Far              ; DS:SI points to data.
                                                        ; DX = pattern no.
                PushA
                Push    DS
                Push    ES

                Mov     CS:MaxRow, 63
                Mov     CS:PatternNumber, DX

                Call    PE_ClearPatternData

                Mov     ES, CS:PatternDataArea
                Xor     DI, DI
                Mov     CX, 64

PE_TranslateS3MPattern1:
                Push    DI

PE_TranslateS3MPattern2:
                LodsB
                Test    AL, AL
                JNZ     PE_TranslateS3MPattern3

                Pop     DI
                Add     DI, 320

                Loop    PE_TranslateS3MPattern1

                Push    CS
                Pop     DS

                Call    Far Ptr PE_TranslateS3MPointer8

                Pop     ES
                Pop     DS
                PopA

                Ret

PE_TranslateS3MPointer8:
                Call    PEFunction_StorePattern

                RetF

PE_TranslateS3MPattern3:
                Push    DI
                Mov     BH, AL
                And     AL, 31
                Mov     AH, 5
                Mul     AH                      ; DI+AX = offset.
                Add     DI, AX
                Test    BH, 32
                JZ      PE_TranslateS3MPattern6

                LodsB
;                Cmp     AL, 0FFH
;                JE      PE_TranslateS3MPattern5
                Cmp     AL, 0FEh
                JE      PE_TranslateS3MPattern4
                Cmp     AL, 07Fh
                JA      PE_TranslateS3MPattern5

                Mov     BL, AL
                And     BL, 0Fh
                ShR     AL, 4
                Mov     AH, 12
                Mul     AH
                Add     AL, BL
                Add     AL, 12                  ; C5 is now central octave
                Mov     [ES:DI], AL             ; Note
                Jmp     PE_TranslateS3MPattern5

PE_TranslateS3MPattern4:
                Mov     Byte Ptr [ES:DI], 0FEh

PE_TranslateS3MPattern5:
                LodsB                           ; Instrument
                Cmp     AL, 99
                JBE     PE_TranslateS3MPattern13

                Xor     AL, AL

PE_TranslateS3MPattern13:
                Mov     [ES:DI+1], AL

PE_TranslateS3MPattern6:
                Test    BH, 64
                JZ      PE_TranslateS3MPattern7

                LodsB                           ; Volume
                Cmp     AL, 64
                JBE     PE_TranslateS3MPattern12
                Cmp     AL, 0FFh
                JE      PE_TranslateS3MPattern12

                Mov     AL, 64

PE_TranslateS3MPattern12:
                Mov     [ES:DI+2], AL

PE_TranslateS3MPattern7:
                Test    BH, 128
                JZ      PE_TranslateS3MPattern8

                LodsW
                Cmp     AL, 'C'-'@'
                JNE     PE_TranslateS3MPattern9

                Mov     AL, AH
                And     AX, 0F00Fh
                ShR     AH, 1
                Add     AL, AH
                ShR     AH, 2
                Add     AH, AL
                Mov     AL, 'C'-'@'
                Jmp     PE_TranslateS3MPattern10

PE_TranslateS3MPattern9:
                Cmp     AL, 'V'-'@'
                JNE     PE_TranslateS3MPattern11

                Jmp     PE_TranslateS3MPattern14

PE_TranslateS3MPattern11:
                Cmp     AL, 'X'-'@'
                JNE     PE_TranslateS3MPattern15

                Cmp     AH, 0A4h
                JNE     PE_TranslateS3MPattern14

                Mov     AX, 'S'-'@'+9100h
                Jmp     PE_TranslateS3MPattern10

PE_TranslateS3MPattern14:
                ShL     AH, 1
                JNC     PE_TranslateS3MPattern10

                Mov     AH, 0FFh
                Jmp     PE_TranslateS3MPattern10

PE_TranslateS3MPattern15:
                Cmp     AL, 'D'-'@'
                JNE     PE_TranslateS3MPattern10
                Test    AL, 0Fh
                JZ      PE_TranslateS3MPattern10
                Test    AL, 0F0h
                JZ      PE_TranslateS3MPattern10

                Mov     BL, AH
                Mov     BH, AH
                And     BX, 0FF0h
                Cmp     BH, 0Fh
                JE      PE_TranslateS3MPattern10
                Cmp     BL, 0F0h
                JE      PE_TranslateS3MPattern10

                And     AH, 0Fh

PE_TranslateS3MPattern10:
                Mov     [ES:DI+3], AX

PE_TranslateS3MPattern8:
                Pop     DI

                Jmp     PE_TranslateS3MPattern2

EndP            PE_TranslateS3MPattern


