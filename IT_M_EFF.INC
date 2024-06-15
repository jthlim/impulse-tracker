;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

SlideTable      DB      1, 4, 8, 16, 32, 64, 96, 128, 255

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Comment ~

Proc            GetC5Speed

                Push    BX
                Push    SI
                Push    BP

                Cmp     Byte Ptr [DI+0Fh], 101  ; MIDI sample
                JNE     GetC5Speed1

; OK.. we have a MIDI sample
; Check whether the midi sample points to a valid sample
; And if so, use that sample's C5 speed.
                Mov     SI, [DS:DI+3]           ; Not a note?
                And     SI, 0FFh

                Mov     BP, [DS:DI+4]
                And     EBP, 0FFh
                JZ      GetC5Speed1             ; No sample?

                Add     SI, SI
                Mov     BP, [ES:64710+EBP+EBP]

                Mov     AX, [ES:BP+SI+40h]      ; AL = note
                                                ; AH = sample.

                Test    AH, AH                  ; No sample?
                JZ      GetC5Speed1
                Mov     SI, AX
                ShR     SI, 8

                Add     SI, SI
                Mov     SI, [ES:64910+SI]       ; Sample offset
                Test    Byte Ptr [ES:SI+12h], 1
                JZ      GetC5Speed1

                Mov     BX, SI

GetC5Speed1:
                Mov     EAX, [ES:BX+3Ch]        ; EAX = C5Spd

                Pop     BP
                Pop     SI
                Pop     BX

                Ret

EndP            GetC5Speed

~

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitVolumeEffect                ; Done A, B, H

                Test    Byte Ptr [DI+2], 44h
                JNZ     InitVolumeProcess

InitVolumeEffectNoEffect:
                Ret

InitVolumeProcess:
                Mov     AL, [DI+5]
                Mov     AH, AL

                And     AL, 7Fh
                Sub     AL, 65
                JC      InitVolumeEffectNoEffect

                Test    AH, 80h
                JZ      InitVolumeEffect1

                Add     AL, 60

InitVolumeEffect1:
                Mov     DL, 10
                Xor     AH, AH
                Div     DL                      ; AL = effect number
                                                ; AH = effect parameter
                Mov     [DI+0Ah], AL            ; Store effect number

        ; Memory for effects A->D, (EFG)/H dont' share.

        ; Effects Ax and Bx (fine volume slide up and down) require immediate
        ; handling. No flags required. (effect 0 and 1)

        ; Effects Cx, Dx, Ex, Fx (volume/pitch slides) require flag to be
        ; set   (effects 2->5)

        ; Effects Gx and Hx need init (handling) code + flags.
        ; (effects 6 and 7).

                Test    AH, AH
                JZ      InitVolumeEffectNoMemory

                Cmp     AL, 4
                JB      InitNormalMemory

                Cmp     AL, 6
                JB      InitSlideMemory
                JA      InitVolumeEffectNoMemory

                MovZX   BX, AH
                Mov     DL, [SlideTable+BX-1]

                Test    Byte Ptr [ES:2Ch], 20h   ; Link command G?
                JZ      CommandGMemoryOldEffects

                Mov     [DI+1Eh], DL
                Jmp     InitVolumeEffectNoMemory

CommandGMemoryOldEffects:
                Mov     [DI+11h], DL
                Jmp     InitVolumeEffectNoMemory

InitSlideMemory:
                ShL     AH, 2
                Mov     [DI+11h], AH
                Jmp     InitVolumeEffectNoMemory

InitNormalMemory:
                Mov     [DI+0Bh], AH

InitVolumeEffectNoMemory:
                Test    Byte Ptr [DI], 4                ; Channel not on!
                JZ      InitVolumeEffect3
                Mov     SI, [DI+24h]

                Cmp     AL, 1
                JA      InitVolumeEffect2
                Mov     AL, [DI+0Bh]
                JE      InitVolumeEffectB

InitVolumeEffectA:                              ; Fine volume slide up.
                Add     AL, [SI+22h]
                Cmp     AL, 64
                JBE     InitVolumeEffectABEnd
                Mov     AL, 64
                Jmp     InitVolumeEffectABEnd

InitVolumeEffectB:                              ; Fine volume slide down
                Sub     AL, [SI+22h]
                Neg     AL
                JNS     InitVolumeEffectABEnd
                Xor     AL, AL

InitVolumeEffectABEnd:
                Jmp     CommandD2

InitVolumeEffect2:
                Or      Word Ptr [DI], 100h

                Cmp     AL, 6
                JA      InitVolumeEffectH
                JE      InitVolumeEffectG

InitVolumeEffectCDEF:
InitVolumeEffectEnd:
                Ret

InitVolumeEffect3:
                Cmp     AL, 7                   ; Vibrato?
                JNE     InitVolumeEffectCDEF

InitVolumeEffectH:
                ShL     AH, 2
                JZ      InitVolumeEffectH1

                Mov     [DI+3Ah], AH

InitVolumeEffectH1:
                Test    Byte Ptr [DI], 4
                JZ      InitVolumeEffectCDEF

                Jmp     InitVibrato

InitVolumeEffectG:
                Jmp     InitCommandG11

EndP            InitVolumeEffect

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            VolumeCommandC

                Mov     SI, [DI+24h]
                Mov     AL, [DI+0Bh]
                Add     AL, [SI+22h]
                Cmp     AL, 64
                JBE     VolumeCommandC1

                And     Word Ptr [DI], Not 100h     ; Turn off effect calling
                Mov     AL, 64

VolumeCommandC1:
                Jmp     CommandD2

EndP            VolumeCommandC

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            VolumeCommandD

                Mov     SI, [DI+24h]
                Mov     AL, [SI+22h]
                Sub     AL, [DI+0Bh]
                JNC     VolumeCommandD1

                And     Word Ptr [DI], Not 100h     ; Turn off effect calling
                Xor     AL, AL

VolumeCommandD1:
                Jmp     CommandD2

EndP            VolumeCommandD

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            VolumeCommandE          ; Pitch slide down

                Mov     BX, [DI+11h]
                And     BX, 0FFh
                ShL     BX, 2
                Jmp     CommandEChain
                Ret

EndP            VolumeCommandE

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            VolumeCommandF

                Mov     BX, [DI+11h]
                And     BX, 0FFh
                ShL     BX, 2
                Jmp     CommandFChain

EndP            VolumeCommandF

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            VolumeCommandG

                Test    Byte Ptr [DI], 16
                JZ      VolumeCommandGEnd

                Mov     BX, [DI+11h]

                Test    Byte Ptr [ES:2Ch], 20h   ; Command G linked?
                JZ      VolumeCommandGMemoryOldEffects

                Mov     BX, [DI+1Eh]

VolumeCommandGMemoryOldEffects:
                And     BX, 0FFh
                JZ      VolumeCommandGEnd

                ShL     BX, 2

                Mov     SI, [DI+24h]

                Cmp     Byte Ptr [DI+42h], 1
                JE      VolumeCommandG1
                                        ; Slide down
                Call    PitchSlideDown
                                        ; Check that frequency is above porta
                                        ;  to frequency.
                Mov     EAX, [SI+10h]
                Cmp     EAX, [DI+34h]
                JA      VolumeCommandG6

VolumeCommandG4:
                Mov     EAX, [DI+34h]
                And     Word Ptr [DI], Not (110h)    ; Turn off calling

VolumeCommandG3:
                Mov     [SI+10h], EAX

VolumeCommandG6:
                Mov     [SI+14h], EAX

VolumeCommandGEnd:
                Ret

VolumeCommandG1:                        ; Slide up!
                Call    PitchSlideUp
                                        ; Check that
                                        ;  1) Channel is on
                                        ;  2) Frequency (set) is below porta to
                                        ;       frequency
                Mov     EAX, [SI+10h]

                Test    Word Ptr [SI], 200h
                JNZ     VolumeCommandG5

                Cmp     EAX, [DI+34h]
                JB      VolumeCommandG6

VolumeCommandG5:
                And     Word Ptr [SI], Not 200h
                Or      Byte Ptr [DI], 4        ; Turn on.
                Jmp     VolumeCommandG4

EndP            VolumeCommandG

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

InitNoCommand4:
                Test    CH, 4
                JZ      InitNoCommand10 ; Taken if the channel's off.

                Mov     SI, [DI+24h]

                Cmp     AL, 0FEh
                JA      InitNoCommand5  ; Noteoff
                JNE     InitNoCommandNoteFade

                And     CH, Not 4

                Cmp     Byte Ptr [SI+36h], 100
                JE      MIDINoteCut

                Test    Byte Ptr CS:DriverFlags, 2
                JNZ     MIDINoteCut

                Mov     Word Ptr [SI], 200h
                Jmp     NoOldEffect

MIDINoteCut:
;                And     CH, Not 4
                Or      Word Ptr [SI], 200h

InitNoCommand10:                                ; Jump point.
                Jmp     NoOldEffect         ; InitNoCommand1

InitNoCommandNoteFade:
                Or      Byte Ptr [SI], 8        ; Note fade

                Jmp     NoOldEffect         ; InitNoCommand1

InitNoCommand5:
                Or      Byte Ptr [SI], 4        ; Note off

;                Cmp     Byte Ptr [SI+22h], 0    ; Volume = 0???
;                JE      InitNoCommand13
                Jmp     InitNoCommand11

Proc            InitNoCommand           ; DS:DI points to CIT area.

                        Assume DS:Music
                Mov     CL, [DI+2]      ; CL = mask
                Mov     CH, [DI]        ; CH = channel info.

                Test    CL, 33h
                JZ      NoOldEffect     ; InitCommand1

                                        ; Note here!
                                        ; Check for noteoff.
                Mov     AL, [DI+0Eh]
                Cmp     AL, 120
                JAE     InitNoCommand4

                Test    CH, 4
                JZ      InitNoCommand9

                Mov     SI, [DI+24h]
                Test    CL, 11h
                JNZ     InitNoCommand9

                Mov     BX, [SI+32h]
                Cmp     BX, [DI+03h]
                JE      NoOldEffect           ; InitNoCommand1

InitNoCommand9:
                Test    CL, 44h
                JZ      NoVolumePorta

                Cmp     Byte Ptr [DI+5], 193
                JB      NoVolumePorta
                Cmp     Byte Ptr [DI+5], 202
                JA      NoVolumePorta

                Test    Byte Ptr [DI], 4
                JNZ     InitVolumeEffect

NoVolumePorta:
                Call    AllocateChannel
;                JC      InitNoCommand1
                JC      NoOldEffect
                                                ; Channel allocated.
                                                ; put volume
                Mov     BX, [SI+34h]            ; Sample offset.
                Mov     AL, [DI+22h]
                Mov     AH, AL
                Mov     [SI+21h], AX            ; Volset

                Test    Byte Ptr [ES:2Ch], 4    ; Instrument mode?
                JNZ     InitNoCommandNoDefaultPan

                Mov     AL, [ES:BX+2Fh]
                Test    AL, AL
                JNS     InitNoCommandNoDefaultPan

                Mov     AH, AL
                And     AX, 7F7Fh
                Mov     [DI+2Eh], AL
                Mov     [SI+2Ah], AX

InitNoCommandNoDefaultPan:
                Mov     EAX, [ES:BX+3Ch]        ; EAX = C5Spd
;                Call    GetC5Speed

                Xor     EBX, EBX
                Mov     [SI+2Ch], EBX
                Mov     [SI+48h], BX
                Mov     [SI+4Ch], EBX
                                                ; Calculate frequency.
                Mov     BL, [DI+0Eh]            ; BL = note.

                Mul     [PitchTable+4*EBX]
                SHRD    EAX, EDX, 16
                Mov     [SI+10h], EAX
                Mov     [SI+14h], EAX

                Or      CH, 4
                And     CH, Not 16

InitNoCommand11:
                Push    CX
                Call    GetLoopInformation
                Pop     CX

InitNoCommand1:
                Test    CL, 22h+44h
                JZ      InitNoCommand3

                Mov     AH, [ES:2Ch]    ; Instrument mode and old effects?
                And     AH, 14h
                Cmp     AH, 14h
                JNE     NoOldEffect
;                Test    AH, 4
;                JZ      NoOldEffect

                Test    CL, 22h
                JZ      NoOldEffect

                MovZX   EBX, Byte Ptr [DI+4]
                Cmp     BL, 0FFh
                JE      NoOldEffect

                Mov     Word Ptr [SI+26h], 0400h
                Mov     BX, [ES:EBX*2+64710]       ; Instrument offset.

                Call    InitPlayInstrument

NoOldEffect:
                Test    CL, 44h
                JZ      InitNoCommand7

                Mov     AL, [DI+5]
                Cmp     AL, 64
                JBE     InitNoCommand8          ; Volume set...

                Mov     AH, AL
                And     AH, 7Fh
                Sub     AH, 65
                JNC     InitNoCommand7

InitNoCommandPanning:                           ; Panning set!
                Mov     [DI], CH

                Sub     AL, 128
                Call    InitCommandX2           ; Destroys (SI), AX

InitNoCommand7:
                Test    CL, 22h                 ; Instrument present? ->
                                                ;    Change volume
                JZ      InitNoCommand3

                Mov     BL, [DI+0Fh]            ; Get instrument offset.
                And     BX, 0FFh
                JZ      InitNoCommand3

                Add     BX, BX
                Mov     BX, [ES:64910+BX]

                Mov     AL, [ES:BX+13h]         ; Default volume

InitNoCommand8:
                Mov     [DI+22h], AL

                Test    CH, 4
                JZ      InitNoCommand3

                Mov     SI, [DI+24h]

                Mov     AH, AL
                Mov     [SI+21h], AX
                Or      Byte Ptr [SI], 10h              ; recalc volume

InitNoCommand3:               ; Randomise volume if required.
                Test    Byte Ptr [DI], 80h
                Mov     [DI], CH
                JZ      InitNoCommandEnd

                Push    CX
                Call    ApplyRandomValues
                Pop     CX

InitNoCommandEnd:
                Jmp     InitVolumeEffect

EndP            InitNoCommand
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandA

                        Assume DS:Music

                Mov     AL, [DS:DI+7]
                And     AX, 0FFh
                JZ      InitCommandA_1

                Mov     CX, CurrentSpeed
                Sub     CurrentTick, CX
                Sub     ProcessTick, CX
                Add     CurrentTick, AX
                Add     ProcessTick, AX
                Mov     CurrentSpeed, AX

InitCommandA_1:
                Jmp     InitNoCommand

EndP            InitCommandA
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandB
                        Assume DS:Music

                MovZX   AX, Byte Ptr [DI+7]
                Cmp     AX, CurrentOrder
                JA      InitCommandB1

                Mov     StopSong, 1

InitCommandB1:
                Dec     AX
                Mov     ProcessOrder, AX
                Mov     ProcessRow, 0FFFEh

                Jmp     InitNoCommand

EndP            InitCommandB
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandC

                        Assume DS:Music

                Cmp     PatternLooping, 0
                JNE     InitCommandC1

                MovZX   AX, Byte Ptr [DS:DI+7]
                Mov     BreakRow, AX

                Mov     ProcessRow, 0FFFEh

InitCommandC1:
                Jmp     InitNoCommand

EndP            InitCommandC
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandD
                Assume DS:Music

                Call    InitNoCommand

                Mov     AL, [DI+7]
                Test    AL, AL
                JZ      InitCommandD1

                Mov     [DI+10h], AL

InitCommandD1:
                Test    Byte Ptr [DI], 4
                JZ      InitCommandD6

                Mov     SI, [DI+24h]

InitCommandD7:                                          ; Jmp point for Lxx
                Mov     AL, [DI+10h]
                Or      Byte Ptr [SI], 16               ; Recalc vol

                Mov     AH, AL
                Test    AH, 0Fh
                JZ      InitCommandD2
                Test    AH, 0F0h
                JZ      InitCommandD3
                And     AX, 0FF0h
                Cmp     AH, 0Fh
                JE      InitCommandD5
                Cmp     AL, 0F0h
                JE      InitCommandD4

InitCommandD6:
                Ret

InitCommandD2:                  ; Slide up.
                ShR     AL, 4
                Mov     [DI+30h], AL

                Or      Byte Ptr [DI], 1
                Cmp     AL, 0Fh
                JE      InitCommandD8

                Ret

InitCommandD8:
                Jmp     CommandD

InitCommandD3:                  ; Slide down
                Neg     AL
                Mov     [DI+30h], AL

                Or      Byte Ptr [DI], 1
                Cmp     AL, -15
                JE      InitCommandD9

                Ret

InitCommandD9:
                Jmp     CommandD

InitCommandD4:                  ; Slide down (fine)
                Mov     Byte Ptr [DI+30h], 0
                Mov     AL, [SI+22h]
                Sub     AL, AH  ; Slide down
                JNS     InitCommandD4_1

                Xor     AL, AL

InitCommandD4_1:
                Mov     AH, AL
                Mov     [SI+21h], AX
                Mov     [DI+22h], AL
                Ret

InitCommandD5:                  ; Slide up (fine)
                Mov     Byte Ptr [DI+30h], 0

                ShR     AL, 4
                Mov     AH, [SI+22h]
                Add     AL, AH
                Cmp     AL, 64
                JBE     InitCommandD4_1

                Mov     AL, 64
                Jmp     InitCommandD4_1

EndP            InitCommandD
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandE
                Assume DS:Music

                Call    InitNoCommand

                Mov     AL, [DI+7]
                Test    AL, AL
                JZ      InitCommandE2

                Mov     [DI+11h], AL

InitCommandE2:
                Test    Byte Ptr [DI], 4
                JZ      InitCommandE1

                Mov     SI, [DI+24h]
                Mov     AL, [DI+11h]

                Test    AL, AL
                JZ      InitCommandE1           ; still no slide??

                Mov     AH, AL
                And     AH, 0F0h
                Cmp     AH, 0E0h
                JB      InitCommandE4

                And     AL, 0Fh
                JZ      InitCommandE1

                Xor     BX, BX

                Cmp     AH, 0E0h
                JE      InitCommandE5

                ShL     AL, 2

InitCommandE5:
                Mov     BL, AL
                Call    PitchSlideDown

                Mov     EAX, [SI+10h]
                Mov     [SI+14h], EAX
                Ret

InitCommandE4:
                Xor     AH, AH
                ShL     AX, 2
                Mov     [DI+40h], AX
                Or      Byte Ptr [DI], 1        ; call update only if necess.

InitCommandE1:
                Ret

EndP            InitCommandE
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandF
                Assume DS:Music

                Call    InitNoCommand

                Mov     AL, [DI+7]
                Test    AL, AL
                JZ      InitCommandF2

                Mov     [DI+11h], AL

InitCommandF2:
                Test    Byte Ptr [DI], 4
                JZ      InitCommandF1

                Mov     SI, [DI+24h]
                                                ; OK.. now processing is dependent
                                                ; upon slide mode.

                Mov     AL, [DI+11h]
                Test    AL, AL
                JZ      InitCommandF1           ; still no slide??

                Mov     AH, AL
                And     AH, 0F0h
                Cmp     AH, 0E0h
                JB      InitCommandF4

                And     AL, 0Fh
                JZ      InitCommandF1

                Xor     BX, BX

                Cmp     AH, 0E0h
                JE      InitCommandF5

                ShL     AL, 2

InitCommandF5:
                Mov     BL, AL
                Call    PitchSlideUp

                Mov     EAX, [SI+10h]            ; Update frequency set field.
                Mov     [SI+14h], EAX
                Ret

InitCommandF4:
                Xor     AH, AH
                ShL     AX, 2
                Mov     [DI+40h], AX
                Or      Byte Ptr [DI], 1        ; call update only if necess.

InitCommandF1:
                Ret

EndP            InitCommandF
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

InitCommandG15:
                Jmp     InitNoCommand

Proc            InitCommandG
                Assume DS:Music
                                                ; Check whether channel on/owned
                Mov     AL, [DI+7]
                Test    AL, AL
                JZ      InitCommandG6

                Test    Byte Ptr [ES:2Ch], 20h   ; Compatibility Gxx?
                JZ      InitCommandGNotOldEffects1

                Mov     [DI+1Eh], AL
                Jmp     InitCommandG6

InitCommandGNotOldEffects1:
                Mov     [DI+11h], AL

InitCommandG6:
                Test    Byte Ptr [DI], 4
                JZ      InitCommandG15

InitcommandG11:                                 ; Jumped to from Lxx
                Mov     SI, [DI+24h]

                Mov     CL, [DI+2]              ; CL = mask.

                Test    CL, 22h
                JZ      InitCommandG17
                                                ; Checking for change of
                                                ; Sample or instrument.
                Mov     AL, [DI+0Fh]            ; Sample
                And     EAX, 0FFh
                JZ      InitCommandG17

                Dec     AX

                Mov     DX, [DI+3]
                Test    Byte Ptr [ES:2Ch], 20h
                JNZ     InitGXXCompat1

; Don't overwrite note if MIDI!
                Cmp     Byte Ptr [DI+0Fh], 101
                JE      InitCommandG13

                Cmp     [SI+33h], DH            ; Ins the same?
                Mov     [SI+32h], DX            ; Nte + Ins.

                JNE     InitCommandG19

                Cmp     AL, [SI+36h]
                JNE     InitCommandG16

InitCommandG17:
                Jmp     InitCommandG13

InitCommandGNoSample:
                Mov     Word Ptr [SI], 200h
                And     Byte Ptr [DI], Not 4
                Ret

InitGXXCompat1:
                Mov     AL, [SI+36h]
                Inc     AX
                Mov     [DI+0Fh], AL

                Mov     BX, [ES:EAX+EAX+64910]
                Mov     AX, [ES:BX+11h]
                Add     AL, AL
                Mov     [SI+24h], AL

                Jmp     InitCommandG18

InitCommandG19:
                Cmp     AL, [SI+36h]            ; Sample the same?
                JE      InitCommandG18

InitCommandG16:
                Mov     BX, [ES:EAX+EAX+64912]
                Mov     Byte Ptr [SI+1], 1
                                                ; Now to update sample info.
                Mov     [SI+34h], BX            ; Offset of sample
                Mov     [SI+36h], AL            ; Sample num.

                Xor     EAX, EAX

                Mov     [SI+1Ah], AX            ; Reset vibrato..
                Mov     [SI+0Bh], AL            ; Reset loop direction.
                Mov     [SI+2Ch], EAX
                Mov     [SI+48h], AX
                Mov     [SI+4Ch], EAX

                Mov     AX, [ES:BX+11h]
                Add     AL, AL
                Mov     [SI+24h], AL

                Test    AH, 1
                JZ      InitCommandGNoSample

                And     AH, 2           ; 16 bit...
                ShR     AX, 8
                Mov     [SI+18h], AX

                Call    GetLoopInformation
                Mov     CL, [DI+2]

InitCommandG18:
                Test    Byte Ptr [ES:2Ch], 4    ; Instrument/sample mode?
                JZ      InitCommandG14
                                                ; Now for instruments

                Mov     Word Ptr [SI+26h], 0400h
                MovZX   EBX, Byte Ptr [DI+4]

                Mov     BX, [ES:EBX*2+64710]       ; Instrument offset.

                Push    Word Ptr [SI]
                Call    InitPlayInstrument
                Pop     AX

                Test    AL, 1
                JZ      InitCommandGXXCompat3

                And     Word Ptr [SI], Not 100h

InitCommandGXXCompat3:

                Mov     AL, [ES:BX+18h]
                Mul     Byte Ptr [SI+24h]
                ShR     AX, 7
                Mov     [SI+24h], AL

                Jmp     InitCommandG14

InitCommandG13:
                Test    CL, 11h
                JZ      InitCommandG1

                                                ; OK. Time to calc freq.
InitCommandG14:
                Mov     AL, [DI+0Eh]
                Cmp     AL, 119
                JBE     InitCommandG5

InitCommandG12:
                Test    Byte Ptr [DI], 4
                JZ      InitCommandG1

                Cmp     AL, 0FEh
                JA      InitCommandGNoteOff
                JNE     InitCommandGNoteFade

                And     Byte Ptr [DI], Not 4    ; Note cut!
                Mov     Word Ptr [SI], 200h     ; Cut.
                Jmp     InitCommandG1

InitCommandGNoteOff:
                Or      Byte Ptr [SI], 4        ; Note off
                Push    CX
                Call    GetLoopInformation
                Pop     CX
                Jmp     InitCommandG1

InitcommandGNoteFade:
                Or      Byte Ptr [SI], 8
                Jmp     InitCommandG1

InitCommandG5:
; Don't overwrite note if MIDI!
                Cmp     Byte Ptr [DI+0Fh], 101
                JE      InitCommandGMIDI2

                Mov     [SI+32h], AL

InitCommandGMIDI2:
                Xor     EDX, EDX
                Mov     BX, [SI+34h]
                Mov     DL, AL
                Mov     EAX, [ES:BX+3Ch]         ; BP = C5Spd
;                Call    GetC5Speed

                Mul     [PitchTable+EDX*4]
                SHRD    EAX, EDX, 16

                Mov     [DI+34h], EAX
                Or      Byte Ptr [DI], 16

InitCommandG1:
                Test    CL, 44h
                JZ      InitCommandG2
;                JZ      InitCommandG3

                Mov     AL, [DI+5]

                Cmp     AL, 64
                JBE     InitCommandG4

                Mov     AH, AL
                And     AH, 7Fh
                Sub     AH, 65
                JNC     InitCommandG2

InitCommandGPanning:
                Sub     AL, 128
                Call    InitCommandX2           ; Panning set...

InitCommandG2:
                Test    CL, 22h
                JZ      InitCommandG3

                Mov     BX, [SI+34h]            ; Sample memory offset.
                Mov     AL, [ES:BX+13h]

InitCommandG4:
                Or      Byte Ptr [SI], 16       ; recalc volume.
                Mov     AH, AL
                Mov     [SI+21h], AX
                Mov     [DI+22h], AL

InitCommandG3:
                Test    Byte Ptr [DI], 16       ; Slide on???
                JZ      InitCommandGEnd

                MovZX   AX, Byte Ptr [DI+11h]   ; Work out magnitude + dirn

                Test    Byte Ptr [ES:2Ch], 20h   ; Command G memory
                JZ      InitCommandGNotOldEffects2

                Mov     AL, [DI+1Eh]

InitCommandGNotOldEffects2:
                ShL     AX, 2
                JZ      PrepareCommandGEnd

                Mov     [DI+40h], AX

                Mov     AX, [DI+34h]
                Mov     DX, [DI+36h]            ; Port freq.

                Cmp     DX, [SI+16h]
                JA      InitCommandG8
                JB      InitCommandG9
                Cmp     AX, [SI+14h]
                JA      InitCommandG8
                JB      InitCommandG9
                                                ; equal?!?!?
                                                ; then don't update effect.
                Jmp     PrepareCommandGEnd

InitCommandG8:
                Mov     Byte Ptr [DI+42h], 1    ; slide up
                Jmp     InitCommandG10

InitCommandG9:
                Mov     Byte Ptr [DI+42h], 0    ; slide down.

InitCommandG10:
                Test    Word Ptr [DI], 100h
                JNZ     PrepareCommandGEnd

                Or      Byte Ptr [DI], 1        ; Update effect if necess.

PrepareCommandGEnd:

InitCommandGEnd:                                ; Don't call volume
                                                ; effects if it has a Gxx!
                Test    Word Ptr [DI], 100h
                JNZ     InitCommandGNoVolEffect

                Jmp     InitVolumeEffect

InitCommandGNoVolEffect:
                Ret

EndP            InitCommandG
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandH
                Assume DS:Music

                Test    Byte Ptr Byte Ptr [DI+2], 11h
                JZ      InitCommandH2
                Cmp     Byte Ptr [DI+3], 119
                JA      InitCommandH2

                Mov     Byte Ptr [DI+39h], 0
                Mov     Byte Ptr [DI+2Dh], 0

InitCommandH2:
                Mov     AL, [DI+7]
                Mov     AH, AL
                And     AX, 0FF0h                       ; AH = depth

                JZ      InitCommandH4

                ShR     AL, 2                           ; AL = speed.
                JZ      InitCommandH3


                Mov     [DI+3Bh], AL

InitCommandH3:
                ShL     AH, 2                           ; Depth * 4
                JZ      InitCommandH4

                Test    Byte Ptr [ES:2Ch], 10h
                JZ      InitCommandH5

                Add     AH, AH

InitCommandH5:
                Mov     [DI+3Ah], AH

InitCommandH4:
                Call    InitNoCommand

                Test    Byte Ptr [DI], 4
                JZ      InitCommandH1

                Or      Byte Ptr [DI], 1                ; Update mode.

                Jmp     InitVibrato

InitCommandH1:
                Ret

EndP            InitCommandH
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandI

                Call    InitNoCommand

                Mov     AL, [DI+7]
                Test    AL, AL
                JZ      InitCommandI2

                Mov     [DI+13h], AL

InitCommandI2:
                Test    Byte Ptr [DI], 4
                JZ      InitCommandI1
                                                ; OK.. now to handle tremor
                Or      Byte Ptr [DI], 1

                Mov     AL, [DI+13h]
                Mov     AH, AL
                And     AL, 0Fh
                ShR     AH, 4

                Test    Byte Ptr [ES:2Ch], 16
                JZ      InitCommandI3

                Add     AX, 101h

InitCommandI3:
                Mov     [DI+40h], AX            ; AL = Offtime, AH = ontime

                Jmp     CommandI

InitCommandI1:
                Ret

EndP            InitCommandI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandJ
                Assume DS:Music

                Call    InitNoCommand

                Mov     Word Ptr [DI+40h], 0
                Mov     AL, [DI+7]
                Test    AL, AL
                JNZ     InitCommandJ2

                Mov     AL, [DI+14h]
                Jmp     InitCommandJ3

InitCommandJ2:
                Mov     [DI+14h], AL

InitCommandJ3:
                Test    Byte Ptr [DI], 4
                JZ      InitCommandJ1

                Mov     BL, AL
                ShR     AL, 4
                And     EBX, 0Fh

                Or      Byte Ptr [DI], 1                ; Update when channel on

                LEA     DX, [EBX*4+PitchTable+240]
                Mov     BL, AL
                Mov     [DI+44h], DX
                LEA     DX, [EBX*4+PitchTable+240]
                Mov     [DI+42h], DX

InitCommandJ1:
                Ret

EndP            InitCommandJ
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandK

                Mov     AL, [DI+7]
                Test    AL, AL
                JZ      InitCommandK1

                Mov     [DI+10h], AL

InitCommandK1:
                Call    InitNoCommand

                Test    Byte Ptr [DI], 4
                JZ      InitCommandKEnd

                Call    InitVibrato
                Call    InitCommandD7
                Or      Byte Ptr [DI], 2        ; Always update.

InitCommandKEnd:
                Ret

EndP            InitCommandK

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandL

                Mov     AL, [DI+7]
                Test    AL, AL
                JZ      InitCommandL1

                Mov     [DI+10h], AL

InitCommandL1:
                Test    Byte Ptr [DI], 4
                JZ      InitCommandLEnd

                Call    InitCommandG11
                Call    InitCommandD7
                Or      Byte Ptr [DI], 2        ; Always update.

InitCommandLEnd:
                Ret

EndP            InitCommandL

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandM
                Assume DS:Music

                Call    InitNoCommand

                Mov     AL, [DI+7]              ; AL = command val.
                Cmp     AL, 40h
                JA      InitCommandM3

InitCommandM2:
                Test    Byte Ptr [DI], 4
                JZ      InitCommandM1

                Mov     SI, [DI+24h]

                Mov     [SI+23h], AL
                Or      Byte Ptr [SI], 16       ; recalc volume

InitCommandM1:
                Mov     [DI+2Fh], AL

InitCommandM3:
                Ret

EndP            InitCommandM
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandN
                Assume DS:Music

                Mov     AL, [DI+7]
                Test    AL, AL
                JZ      InitCommandN1

                Mov     [DI+16h], AL

InitCommandN1:
                Call    InitNoCommand

                Mov     AL, [DI+16h]
                Mov     AH, AL
                Test    AH, 0Fh
                JZ      InitCommandN2
                Test    AH, 0F0h
                JZ      InitCommandN3
                And     AX, 0FF0h
                Cmp     AH, 0Fh
                JE      InitCommandN4
                Cmp     AL, 0F0h
                JE      InitCommandN5
                Ret

InitCommandN2:
                ShR     AL, 4
                Mov     [DI+40h], AL
                Or      Byte Ptr [DI], 2                ; Always update effect
                Ret

InitCommandN3:
                Neg     AL
                Mov     [DI+40h], AL
                Or      Byte Ptr [DI], 2
                Ret

InitCommandN4:
                ShR     AL, 4
                Add     AL, [DI+2Fh]
                Cmp     AL, 64
                JBE     InitCommandN6
                Mov     AL, 64
                Jmp     InitCommandM2

InitCommandN5:
                Mov     AL, [DI+2Fh]
                Sub     AL, AH
                JNC     InitCommandN6
                Xor     AL, AL

InitCommandN6:
                Jmp     InitCommandM2


EndP            InitCommandN

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandO
                Assume DS:Music

                Mov     AL, [DI+7]
                Test    AL, AL
                JZ      InitCommandO2

                Mov     [DI+12h], AL

InitCommandO2:
                Call    InitNoCommand

;                Mov     AL, [DI+2]
;                Test    AL, 22h
;                JNZ     InitCommandO1

;                Test    AL, 11h
;                Test    Byte Ptr [DI+2], 11h
                Test    Byte Ptr [DI+2], 33h
                JZ      InitCommandO1

                Cmp     Byte Ptr [DI+0Eh], 120
                JAE     InitCommandO1

InitCommandO3:
                Test    Byte Ptr [DI], 4
                JZ      InitCommandO1

                Xor     EAX, EAX
                Mov     SI, [DI+24h]
                Mov     AH, [DI+1Bh]
                Mov     AL, [DI+12h]
                ShL     EAX, 8

                Cmp     EAX, [SI+44h]            ; End of sample/end of sample loop
                JB      InitCommandO4

                Test    Byte Ptr [ES:2Ch], 16
                JZ      InitCommandO1

                Mov     EAX, [SI+44h]
                Dec     EAX

InitCommandO4:
                Mov     [SI+4Ch], EAX
                Mov     [SI+2Ch], EAX

                Xor     AX, AX
                Mov     [SI+48h], AX
                Ret

InitCommandO1:
                Ret

EndP            InitCommandO
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandP
                Assume DS:Music

                Mov     AL, [DI+7]
                Test    AL, AL
                JZ      InitCommandP1

                Mov     [DI+17h], AL

InitCommandP1:
                Call    InitNoCommand

                Mov     DL, [DI+2Eh]
                Test    Byte Ptr [DI], 4
                JZ      InitCommandP8

                Mov     SI, [DI+24h]
                Mov     DL, [SI+2Bh]    ; Pan set

InitCommandP8:
                Cmp     DL, 100  ; Surround??
                JE      InitCommandP7

                Mov     AL, [DI+17h]
                Mov     AH, AL
                Test    AH, 0Fh
                JZ      InitCommandP2
                Test    AH, 0F0h
                JZ      InitCommandP3
                And     AX, 0F00Fh
                Cmp     AL, 0Fh
                JE      InitCommandP4
                Cmp     AH, 0F0h
                JE      InitCommandP5

InitCommandP7:
                Ret

InitCommandP2:
                ShR     AL, 4
                Neg     AL
                Mov     [DI+40h], AL
                Or      Byte Ptr [DI], 2                ; Always update effect
                Ret

InitCommandP3:
                Mov     [DI+40h], AL
                Or      Byte Ptr [DI], 2
                Ret

InitCommandP4:
                ShR     AH, 4
                Mov     AL, DL
                Sub     AL, AH
                JNC     InitCommandP6
                Xor     AL, AL
                Jmp     InitCommandX2

InitCommandP5:
                Add     AL, DL
                Cmp     AL, 64
                JBE     InitCommandP6

                Mov     AL, 64

InitCommandP6:
                Jmp     InitCommandX2

EndP            InitCommandP
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandQ

                Call    InitNoCommand

                Mov     AL, [DI+7]
                Test    AL, AL
                JZ      InitCommandQ1

                Mov     [DI+18h], AL

InitCommandQ1:
                Test    Byte Ptr [DI], 4
                JZ      InitCommandQ2

                Or      Byte Ptr [DI], 1

                Test    Byte Ptr [DI+2], 11h
                JZ      InitCommandQ3

                Mov     AL, [DI+18h]
                And     AL, 0Fh         ; AL = retrig count
                Mov     [DI+33h], AL    ; retrig countdown

InitCommandQ2:
                Ret

InitCommandQ3:
                Jmp     CommandQ

EndP            InitCommandQ

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandR
                Assume DS:Music

                Mov     AL, [DI+7]
                Mov     AH, AL
                And     AX, 0FF0h                       ; AH = depth
                JZ      InitCommandR4

                ShR     AL, 2                           ; AL = speed.
                JZ      InitCommandR3

                Mov     [DI+3Fh], AL

InitCommandR3:
                ShL     AH, 1
                JZ      InitCommandR4

                Mov     [DI+3Eh], AH

InitCommandR4:
                Call    InitNoCommand

                Test    Byte Ptr [DI], 4
                JZ      InitCommandR1

                Or      Byte Ptr [DI], 1                ; Update mode.

                Jmp     InitTremelo

InitCommandR1:
                Ret

EndP            InitCommandR
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

CommandSTable   Label   Word
        DW      Offset InitNoCommand    ; 0
        DW      Offset InitNoCommand    ; 1
        DW      Offset InitNoCommand    ; 2
        DW      Offset InitCommandS3x   ; 3 - set vibrato waveform
        DW      Offset InitCommandS4x   ; 4 - set tremelo waveform
        DW      Offset InitCommandS5x   ; 5 - set panbrello waveform
        DW      Offset InitCommandS6x   ; 6 - extra delay of x frames
        DW      Offset InitCommandS7x   ; 7 - instrument functions
        DW      Offset InitCommandS8x   ; 8 - set pan
        DW      Offset InitCommandS9x   ; 9 - set surround
        DW      Offset InitCommandSAx   ; A - Set high order offset
        DW      Offset InitCommandSBx   ; B - loop control
        DW      Offset InitCommandSCx   ; C - note cut
        DW      Offset InitCommandSDx   ; D - note delay
        DW      Offset InitCommandSEx   ; E - pattern delay
        DW      Offset InitCommandSFx   ; F - MIDI Macro select

CommandS7Table  Label   Word
        DW      Offset InitCommandS70   ; Past note cut
        DW      Offset InitCommandS71   ; Past note off
        DW      Offset InitCommandS72   ; Past note fade
        DW      Offset InitCommandS73   ; Set NNA to cut
        DW      Offset InitCommandS73   ; Set NNA to continue
        DW      Offset InitCommandS73   ; Set NNA to off
        DW      Offset InitCommandS73   ; Set NNA to fade
        DW      Offset InitCommandS77   ; Set volume envelope on
        DW      Offset InitCommandS78   ; Set volume envelope off
        DW      Offset InitCommandS79   ; Set panning envelope on
        DW      Offset InitCommandS7A   ; Set panning envelope off
        DW      Offset InitCommandS7B   ; Set pitch envelope on
        DW      Offset InitCommandS7C   ; Set pitch envelope off
        DW      Offset InitNoCommand
        DW      Offset InitNoCommand
        DW      Offset InitNoCommand

Proc            InitCommandS
                Assume DS:Music

                Mov     AL, [DI+7]
                Test    AL, AL
                JNZ     @ICS1

                Mov     AL, [DI+1Ah]

@ICS1:
                Mov     [DI+1Ah], AL

                Mov     AH, AL
                And     AX, 0F00Fh

                Mov     [DI+40h], AX            ; Misc effects data.

                Mov     BX, AX
                ShR     BX, 11                  ; BX = (AH>>4)*2

                Jmp     [CommandSTable+BX]

InitCommandS3x:
                Cmp     AL, 3
                JA      @ICS2
                Mov     [DI+38h], AL

@ICS2:
                Jmp     InitNoCommand

InitCommandS4x:
                Cmp     AL, 3
                JA      @ICS3
                Mov     [DI+3Ch], AL

@ICS3:
                Jmp     InitNoCommand

InitCommandS5x:
                Cmp     AL, 3
                JA      @ICS4

                Mov     [DI+28h], AL
                Mov     Byte Ptr [DI+29h], 0

@ICS4:
                Jmp     InitNoCommand

InitCommandS6x:
                And     AX, 0FFh
                Add     CurrentTick, AX
                Add     ProcessTick, AX
                Jmp     InitNoCommand

InitCommandS7x:
                Mov     BL, AL
                Add     BL, BL
                Jmp     [CommandS7Table+BX]

InitCommandS70:                                 ; Past Note cut.
                Call    InitNoCommand
                Mov     SI, Offset SlaveChannelInformationTable
                Mov     CX, NumChannels
                Mov     AL, [DI+20h]
                Or      AL, 80h

InitCommandS70_1:
                Cmp     AL, [SI+3Ah]
                JNE     @ICS5

                Test    Byte Ptr CS:DriverFlags, 2
                JZ      @ICS70_2

                Or      Word Ptr [SI], 200h
                Jmp     @ICS5

@ICS70_2:
                Mov     Word Ptr [SI], 200h

@ICS5:
                Add     SI, SLAVECHANNELSIZE
                Dec     CX
                JNZ     InitCommandS70_1

                Ret

InitCommandS71:                         ; Past note off
                Call    InitNoCommand
                Mov     AH, 4
                Jmp     InitCommandS72_1

InitCommandS72:                         ; Past note fade.
                Call    InitNoCommand
                Mov     AH, 8

InitCommandS72_1:
                Mov     SI, Offset SlaveChannelInformationTable
                Mov     CX, NumChannels
                Mov     AL, [DI+20h]
                Or      AL, 80h

InitCommandS72_2:
                Cmp     AL, [SI+3Ah]
                JNE     @ICS6

                Or      [SI], AH

                Push    AX
                Push    CX
                Call    GetLoopInformation
                Pop     CX
                Pop     AX

@ICS6:
                Add     SI, SLAVECHANNELSIZE
                Dec     CX
                JNZ     InitCommandS72_2

                Ret

InitCommandS73:
                Push    AX
                Call    InitNoCommand
                Pop     AX

                Test    Byte Ptr [DI], 4
                JZ      @ICS7

                Sub     AL, 3
                Mov     SI, [DI+24h]
                Mov     [SI+3Bh], AL

@ICS7:
                Ret

InitCommandS77:
                Call    InitNoCommand
                Test    Byte Ptr [DI], 4
                JZ      @ICS9

                Mov     SI, [DI+24h]
                And     Word Ptr [SI], Not 1000h

@ICS9:
                Ret

InitCommandS78:
                Call    InitNoCommand
                Test    Byte Ptr [DI], 4
                JZ      @ICS9

                Mov     SI, [DI+24h]
                Or      Word Ptr [SI], 1000h

                Ret

InitCommandS79:
                Call    InitNoCommand
                Test    Byte Ptr [DI], 4
                JZ      @ICS9

                Mov     SI, [DI+24h]
                And     Word Ptr [SI], Not 2000h

                Ret

InitCommandS7A:
                Call    InitNoCommand
                Test    Byte Ptr [DI], 4
                JZ      @ICS10

                Mov     SI, [DI+24h]
                Or      Word Ptr [SI], 2000h

                Ret

InitCommandS7B:
                Call    InitNoCommand
                Test    Byte Ptr [DI], 4
                JZ      @ICS10

                Mov     SI, [DI+24h]
                And     Word Ptr [SI], Not 4000h

@ICS10:
                Ret

InitCommandS7C:
                Call    InitNoCommand
                Test    Byte Ptr [DI], 4
                JZ      @ICS10

                Mov     SI, [DI+24h]
                Or      Word Ptr [SI], 4000h

                Ret

InitCommandS8x:
                Mov     AH, AL
                ShL     AH, 4
                Or      AL, AH
                And     AX, 0FFh
                Add     AX, 2
                SHR     AX, 2

InitCommandS8x_1:
                Push    AX
                Call    InitNoCommand
                Pop     AX

                Jmp     InitCommandX2

InitCommandS9x:
                Cmp     AL, 1
                Mov     AL, 100
                JE      InitCommandS8x_1
                Jmp     InitNoCommand

InitCommandSAx:
                Mov     [DI+1Bh], AL
                Jmp     InitNoCommand

InitCommandSBx:
                Push    AX
                Call    InitNoCommand
                Pop     AX

                Test    AL, AL
                JZ      InitCommandSBx_1

                Cmp     Byte Ptr [DI+27h], 0
                JNE     InitCommandSBx_2

                Mov     [DI+27h], AL

InitCommandSBx_3:
                MovZX   AX, Byte Ptr [DI+26h]

                Dec     AX
                Mov     ProcessRow, AX
                Mov     PatternLooping, 1

                Ret

InitCommandSBx_2:
                Dec     Byte Ptr [DI+27h]
                JNZ     InitCommandSBx_3
                Mov     AX, CurrentRow

                Inc     AX
                Mov     [DI+26h], AL
                Ret

InitCommandSBx_1:
                Mov     AX, CurrentRow
                Mov     [DI+26h], AL
                Ret

InitCommandSCx:
                Or      Byte Ptr [DI], 1
                Jmp     InitNoCommand

InitCommandSDx:
                Or      Byte Ptr [DI], 2
                Ret

InitCommandSEx:
                Cmp     RowDelayOn, 0
                JNE     @ICS8

                Inc     AX
                Mov     AH, 1
                Mov     [Word Ptr RowDelay], AX

@ICS8:
                Jmp     InitNoCommand

InitCommandSFx:                             ; Set MIDI Macro
                Mov     [DI+1Fh], AL
                Jmp     InitNoCommand

EndP            InitCommandS
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandT
                Assume DS:Music

                Mov     AL, [DI+7]
                Test    AL, AL
                JZ      InitCommandT2

                Mov     [DI+19h], AL

InitCommandT2:
                Mov     AL, [DI+19h]

InitCommandT3:
                Cmp     AL, 20h
                JB      InitCommandT1

                Mov     Tempo, AL
                Call    Music_InitTempo
                Jmp     InitNoCommand

InitCommandT1:
                Call    InitNoCommand
                Or      Byte Ptr [DI], 2        ; Update mode
                Ret

EndP            InitCommandT
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandU
                Assume DS:Music

                Test    Byte Ptr Byte Ptr [DI+2], 11h
                JZ      InitCommandU2

                Mov     Byte Ptr [DI+39h], 0
                Mov     Byte Ptr [DI+2Dh], 0

InitCommandU2:
                Mov     AL, [DI+7]
                Mov     AH, AL
                And     AX, 0FF0h                       ; AH = depth

                Test    AL, AL
                JZ      InitCommandU3

                ShR     AL, 2                           ; AL = speed.

                Mov     [DI+3Bh], AL

InitCommandU3:
                Test    AH, AH
                JZ      InitCommandU4

                Test    Byte Ptr [ES:2Ch], 16
                JZ      InitCommandU5

                Add     AH, AH

InitCommandU5:
                Mov     [DI+3Ah], AH

InitCommandU4:
                Call    InitNoCommand

                Test    Byte Ptr [DI], 4
                JZ      InitCommandU1

                Or      Byte Ptr [DI], 1                ; Update mode.

                Jmp     InitVibrato

InitCommandU1:
                Ret

EndP            InitCommandU
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandV
                Assume DS:Music

                Mov     AL, [DI+7]
                Cmp     AL, 80h
                JA      InitCommandV1

                Mov     GlobalVolume, AL
                Call    RecalculateAllVolumes

InitCommandV1:
                Jmp     InitNoCommand

EndP            InitCommandV
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandW                    ; Global volume slides!
                Assume DS:Music

                Call    InitNoCommand

                Mov     AL, [DI+7]
                Test    AL, AL
                JNZ     InitCommandW1

                Mov     AL, [DI+1Ch]
                Jmp     InitCommandW2

InitCommandW1:
                Mov     [DI+1Ch], AL

InitCommandW2:
                Mov     AH, AL
                And     AX, 0F00Fh
                JZ      InitCommandW3
                Test    AH, AH
                JZ      InitCommandW4
                Test    AL, AL
                JZ      InitCommandW5
                Cmp     AH, 0F0h
                JE      InitCommandW6
                Cmp     AL, 0Fh
                JE      InitCommandW8

                Ret

InitCommandW4:
                Neg     AL
                Mov     [DI+40h], AL
                Or      Byte Ptr [DI], 2
                Ret

InitCommandW5:
                ShR     AH, 4
                Mov     [DI+40h], AH
                Or      Byte Ptr [DI], 2
                Ret

InitCommandW6:
                Mov     AH, GlobalVolume
                Sub     AH, AL
                JNC     InitCommandW7

                Xor     AH, AH

InitCommandW7:
                Mov     GlobalVolume, AH

                Call    RecalculateAllVolumes
                Ret

InitCommandW8:
                ShR     AH, 4
                Mov     AL, GlobalVolume
                Add     AL, AH
                JNS     InitCommandW9

                Mov     AL, 128

InitCommandW9:
                Mov     GlobalVolume, AL

                Call    RecalculateAllVolumes
                Ret

InitCommandW3:
                Ret

EndP            InitCommandW
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandX
                Assume DS:Music

                Call    InitNoCommand

                MovZX   AX, Byte Ptr [DI+7]     ; AL = command val.
                Add     AX, 2
                SHR     AX, 2

InitCommandX2:
                Test    Byte Ptr [DI], 4
                JZ      InitCommandX1

                Mov     SI, [DI+24h]
                Mov     AH, AL
                Mov     [SI+2Ah], AX

                Or      Byte Ptr [SI], 64+2             ; Recalculate pan

InitCommandX1:
                Mov     [DI+2Eh], AL
                Ret

EndP            InitCommandX
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandY
                Assume DS:Music

                Mov     AL, [DI+7]
                Mov     AH, AL
                And     AX, 0FF0h                       ; AH = depth
                JZ      InitCommandY4

                ShR     AL, 4
                JZ      InitCommandY3

                Mov     [DI+2Bh], AL

InitCommandY3:
                ShL     AH, 1
                JZ      InitCommandY4

                Mov     [DI+2Ah], AH

InitCommandY4:
                Call    InitNoCommand

                Test    Byte Ptr [DI], 4
                JZ      InitCommandY1

                Or      Byte Ptr [DI], 1                ; Update mode.

                Jmp     CommandY

InitCommandY1:
                Ret

EndP            InitCommandY
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitCommandZ            ; Macros start at 120h, 320h

                Call    InitNoCommand

                Mov     BL, [DI+7]
                Mov     SI, [DI+24h]

                Test    BL, BL
                JS      InitCommandZ1

;                Test    SI, SI
;                JZ      InitCommandZ2

                Mov     BL, [DI+1Fh]    ; 0->7Fh
                And     BX, 0Fh         ; BX = SFx number
                ShL     BX, 5
                Add     BX, 120h
                Jmp     MIDITranslate

InitCommandZ1:                  ; Macros!
                And     BX, 7Fh
                ShL     BX, 5           ; BX = (xx-80h)*20h
                Add     BX, 320h
                Jmp     MIDITranslate

InitCommandZ2:
                Ret

EndP            InitCommandZ

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Proc            NoCommand               ; DS:DI points to CIT Area

                Ret

EndP            NoCommand

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CommandD
                Assume DS:Music

                Mov     SI, [DI+24h]
                Mov     AL, [DI+30h]
                Add     AL, [SI+22h]    ; Volset.
                JS      CommandD1

                Cmp     AL, 64
                JBE     CommandD2

                And     Byte Ptr [DI], Not 1

                Mov     AL, 64
                Jmp     CommandD2

CommandD1:
                And     Byte Ptr [DI], Not 1
                Xor     AL, AL

CommandD2:
                Mov     [SI+21h], AL
                Mov     [SI+22h], AL
                Mov     [DI+22h], AL
                Or      Byte Ptr [SI], 16               ; Recalc vol
                Ret

EndP            CommandD
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CommandE
                Assume DS:Music

                Mov     BX, [DI+40h]

CommandEChain:
                Mov     SI, [DI+24h]
                Call    PitchSlideDown

                Mov     EAX, [SI+10h]
                Mov     [SI+14h], EAX

                Ret

EndP            CommandE
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CommandF
                Assume DS:Music

                Mov     BX, [DI+40h]

CommandFChain:
                Mov     SI, [DI+24h]
                Call    PitchSlideUp

                Mov     EAX, [SI+10h]
                Mov     [SI+14h], EAX

                Ret

EndP            CommandF
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CommandG

                Test    Byte Ptr [DI], 16
                JZ      CommandGEnd

                Mov     BX, [DI+40h]
                Mov     SI, [DI+24h]
                Cmp     Byte Ptr [DI+42h], 1
                JE      CommandG1
                                        ; Slide down
                Call    PitchSlideDown
                                        ; Check that frequency is above porta
                                        ;  to frequency.
                Mov     EAX, [SI+10h]
                Cmp     EAX, [DI+34h]
                JA      CommandG6

CommandG4:
                Mov     EAX, [DI+34h]
                And     Byte Ptr [DI], Not (3 Or 16)    ; Turn off calling

CommandG3:
                Mov     [SI+10h], EAX

CommandG6:
                Mov     [SI+14h], EAX

CommandGEnd:
                Ret

CommandG1:                              ; Slide up!
                Call    PitchSlideUp
                                        ; Check that
                                        ;  1) Channel is on
                                        ;  2) Frequency (set) is below porta to
                                        ;       frequency
                Mov     EAX, [SI+10h]

                Test    Word Ptr [SI], 200h
                JNZ     CommandG5

                Cmp     EAX, [DI+34h]
                JB      CommandG6

CommandG5:
;                Or      Byte Ptr [SI], 1
;                And     Byte Ptr [SI+1], Not 2
                And     Word Ptr [SI], Not 200h
                Or      Byte Ptr [DI], 4        ; Turn on.
                Jmp     CommandG4

EndP            CommandG

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

InitVibrato:
                Test    Byte Ptr [ES:2Ch], 10h
                JZ      CommandH

                Mov     SI, [DI+24h]
                Or      Byte Ptr [SI], 32       ; Freq change...
                Mov     AL, [DI+2Dh]
                Jmp     CommandH5

Proc            CommandH

                Mov     SI, [DI+24h]
                Or      Byte Ptr [SI], 32       ; Freq change...

                Mov     BL, [DI+39h]
                Add     BL, [DI+3Bh]            ; Add speed.
                Mov     [DI+39h], BL            ; Save value
                Mov     BH, [DI+38h]            ; AL = waveform

                Cmp     BH, 3
                JE      CommandH1

                Mov     AL, [FineSineData+BX]       ; AL = -64 -> 64

                Jmp     CommandH2

CommandH1:                                      ; Random.
                Call    Random
                And     AL, 127
                Sub     AL, 64

CommandH2:
                Mov     [DI+2Dh], AL            ; Save last vibrato.

CommandH5:
                IMul    Byte Ptr [DI+3Ah]
                SAL     AX, 2
                Add     AX, 80h

                Test    Byte Ptr [ES:2Ch], 16
                JZ      CommandH9

                Neg     AH

CommandH9:
                MovZX   BX, AH
                                                ; AH = EEx/FEx command value
                Test    AH, AH
                JS      CommandH4
                JNS     CommandH3
                Ret

CommandH3:
                Jmp     PitchSlideUp

CommandH4:
                Neg     BL
                Jmp     PitchSlideDown
                Ret

EndP            CommandH

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CommandI

                Mov     SI, [DI+24h]

                Or      Byte Ptr [SI], 16       ; recalc volume

                Dec     Byte Ptr [DI+31h]
                JS      CommandI2
                JZ      CommandI2

CommandI1:
                Cmp     Byte Ptr [DI+32h], 1
                JE      CommandI3

                Mov     Byte Ptr [SI+21h], 0

CommandI3:
                Ret

CommandI2:
                Xor     Byte Ptr [DI+32h], 1
                MovZX   BX, Byte Ptr [DI+32h]
                Mov     AL, [DI+40h+BX]
                Mov     [DI+31h], AL
                Jmp     CommandI1

EndP            CommandI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CommandJ
                Assume DS:Music

                Mov     SI, [DI+24h]
                Mov     BX, [DI+40h]

                Or      Byte Ptr [SI], 32

                Add     BX, 2
                Cmp     BX, 6
                JB      CommandJ1

                Mov     Word Ptr [DI+40h], 0
                Ret

CommandJ1:
                Push    DI

                Mov     [DI+40h], BX
                Mov     DI, [DI+BX+40h]         ; DI points to freq mult.

                Mov     EAX, [SI+10h]
                Mul     DWord Ptr [DI]

                Test    EDX, 0FFFF0000h
                JNZ     CommandJ2

                SHRD    EAX, EDX, 16
                Mov     [SI+10h], EAX

                Pop     DI
                Ret

CommandJ2:
                Xor     EAX, EAX
                Mov     [SI+10h], EAX

                Pop     DI
                Ret

EndP            CommandJ
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CommandK

                Call    CommandH
                Call    CommandD
                Ret

EndP            CommandK

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CommandL

                Test    Byte Ptr [DI], 16
                JZ      CommandL1

                Call    CommandG
                Or      Byte Ptr [DI], 1

CommandL1:
                Call    CommandD
                Ret

EndP            CommandL

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CommandN

                Mov     AL, [DI+2Fh]
                Add     AL, [DI+40h]
                JNS     CommandN1

                Xor     AL, AL
                Jmp     InitCommandM2

CommandN1:
                Cmp     AL, 64
                JBE     CommandN2

                Mov     AL, 64

CommandN2:
                Jmp     InitCommandM2

EndP            CommandN

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CommandP

                Mov     AL, [DI+2Eh]
                Test    Byte Ptr [DI], 4
                JZ      CommandP3

                Mov     SI, [DI+24h]
                Mov     AL, [SI+2Bh]    ; Pan set

CommandP3:
                Add     AL, [DI+40h]
                JNS     CommandP1

                Xor     AL, AL
                Jmp     InitCommandX2

CommandP1:
                Cmp     AL, 64
                JBE     CommandP2

                Mov     AL, 64

CommandP2:
                Jmp     InitCommandX2

EndP            CommandP

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CommandQ

                Dec     Byte Ptr [DI+33h]
                JS      CommandQ1
                JZ      CommandQ1

                Ret

CommandQ1:                                      ; OK... reset counter.
                Mov     BL, [DI+18h]
                Mov     BH, BL
                And     BX, 0F00Fh
                Mov     [DI+33h], BL            ; retrig count done.

                Mov     SI, [DI+24h]

                Test    Byte Ptr DriverFlags, 2 ; Hiqual?
                JZ      CommandQNoHiQual

                Push    ES
                Push    DI

                Test    Byte Ptr [ES:2Ch], 4            ; Instrument mode?

                Push    DS
                Pop     ES

                JNZ     CommandQHiqualInstruments

CommandQHiqualSamples:
                Lea     DI, [SI+64*SLAVECHANNELSIZE]

                Mov     CX, SLAVECHANNELSIZE/4
                Rep     MovsD
                Or      Byte Ptr [DI-SLAVECHANNELSIZE+1], 2h    ; Cut
                Or      Byte Ptr [DI-SLAVECHANNELSIZE+3Ah], 80h ; Disowned
                Sub     SI, SLAVECHANNELSIZE

                Pop     DI
                Jmp     CommandQHiqualEnd

CommandQHiqualInstruments:
                Mov     DI, Offset SlaveChannelInformationTable
                Mov     CX, NumChannels

CommandQFindChannel:
                Test    Byte Ptr [DI], 1
                JZ      CommandQHiqualCopy

                Add     DI, SLAVECHANNELSIZE
                Loop    CommandQFindChannel
                Pop     DI
                Jmp     CommandQHiqualEnd

CommandQHiqualCopy:
                Mov     CX, SLAVECHANNELSIZE/4
                Rep     MovsD

                Or      Byte Ptr [SI-SLAVECHANNELSIZE+1], 2h    ; Cut
                Or      Byte Ptr [SI-SLAVECHANNELSIZE+3Ah], 80h ; Disowned
                LEA     SI, [DI-SLAVECHANNELSIZE]
                Pop     DI

                Mov     [DI+24h], SI

CommandQHiqualEnd:
                Pop     ES

CommandQNoHiQual:
                Xor     EAX, EAX
                Mov     [SI+2Ch], EAX
                Mov     [SI+48h], AX
                Mov     [SI+4Ch], EAX

                Or      Word Ptr [SI], 540h

                Mov     AL, [SI+22h]
                ShR     BX, 11

                Jmp     [RetrigOffsets+BX]

CommandQ_0:
                Ret

CommandQ_1:
                Dec     AL
                Jmp     CommandQCheckLow

CommandQ_2:
                Sub     AL, 2
                Jmp     CommandQCheckLow

CommandQ_3:
                Sub     AL, 4
                Jmp     CommandQCheckLow

CommandQ_4:
                Sub     AL, 8
                Jmp     CommandQCheckLow

CommandQ_5:
                Sub     AL, 16
                Jmp     CommandQCheckLow

CommandQ_6:
                ShL     AL, 1
                Mov     BL, 3
                Div     BL
                Jmp     CommandQEnd

CommandQ_7:
                ShR     AL, 1
                Jmp     CommandQEnd

CommandQ_8:
                Ret

CommandQ_9:
                Inc     AX
                Jmp     CommandQCheckHigh

CommandQ_A:
                Add     AL, 2
                Jmp     CommandQCheckHigh

CommandQ_B:
                Add     AL, 4
                Jmp     CommandQCheckHigh

CommandQ_C:
                Add     AL, 8
                Jmp     CommandQCheckHigh

CommandQ_D:
                Add     AL, 16
                Jmp     CommandQCheckHigh

CommandQ_E:
                Mov     AH, AL
                Add     AL, AL
                Add     AL, AH
                ShR     AL, 1
                Jmp     CommandQCheckHigh

CommandQ_F:
                ShL     AL, 1
                Jmp     CommandQCheckHigh


CommandQCheckLow:
                JNS     CommandQEnd
                Xor     AL, AL
                Jmp     CommandQEnd

CommandQCheckHigh:
                Cmp     AL, 64
                JBE     CommandQEnd
                Mov     AL, 64

CommandQEnd:
                Mov     [SI+21h], AL
                Mov     [SI+22h], AL
                Mov     [DI+22h], AL
                Or      Byte Ptr [SI], 16       ; recalc volume flag

                Cmp     Byte Ptr [DI+0Fh], 101  ; MIDI sample
                JNE     CommandQNoMidi

                Mov     BX, MIDICOMMAND_STOPNOTE
                Call    MIDITranslate

CommandQNoMidi:
                Ret

EndP            CommandQ

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

InitTremelo:
                Test    Byte Ptr [ES:2Ch], 10h
                JZ      CommandR

                Mov     SI, [DI+24h]
                Or      Byte Ptr [SI], 64       ; Volume change...
                Mov     AL, [DI+23h]
                Jmp     CommandR2

Proc            CommandR

                Mov     SI, [DI+24h]
                Or      Byte Ptr [SI], 16       ; Volume change

                Mov     BL, [DI+3Dh]
                Add     BL, [DI+3Fh]            ; Add speed.
                Mov     [DI+3Dh], BL            ; Save value
                Mov     BH, [DI+3Ch]            ; AL = waveform

                Cmp     BH, 3
                JE      CommandR1

                Mov     AL, [FineSineData+BX]       ; AL = -64 -> 64

                Jmp     CommandR5

CommandR1:                                      ; Random.
                Call    Random
                And     AL, 127
                Sub     AL, 64

CommandR5:
                Mov     [DI+23h], AL            ; Save last tremelo

CommandR2:
                IMul    Byte Ptr [DI+3Eh]
                SAL     AX, 2
                Add     AX, 80h
                MovZX   BX, AH
                                                ; AH = volume change
                Mov     AL, [SI+21h]            ; AL = vol.
                Add     AL, AH
                JNS     CommandR3

                Xor     AL, AL

CommandR3:
                Cmp     AL, 64
                JBE     CommandR4

                Mov     AL, 64

CommandR4:
                Mov     [SI+21h], AL
                Ret

EndP            CommandR

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CommandS                        ; Have to handle SDx, SCx
                Assume  DS:Music

                Mov     AX, [DI+40h]            ; AH = command, AL = value.
                Cmp     AH, 0D0h
                JE      CommandS1

                Cmp     AH, 0C0h
                JE      CommandS3

CommandS4:
                Ret

CommandS3:
                Test    Byte Ptr [DI], 4
                JZ      CommandS4

                Dec     Byte Ptr [DI+40h]
                JZ      CommandS5
                JS      CommandS5

                Ret

CommandS5:
                Mov     SI, [DI+24h]                    ; Note cut.

                Mov     AL, [DI]

                And     AL, Not 4
                Mov     [DI], AL

                Cmp     Byte Ptr [SI+36h], 100
                JE      CommandS7

                Test    Byte Ptr CS:DriverFlags, 2
                JNZ     CommandS7

                Mov     Word Ptr [SI], 200h
                Ret

CommandS7:
                Or      Word Ptr [SI], 200h
                Ret

CommandS1:
                Dec     Byte Ptr [DI+40h]
                JS      CommandS2
                JZ      CommandS2

                Ret

CommandS2:
                And     Byte Ptr [DI], Not 3
                Call    InitNoCommand

                Or      Byte Ptr [DI], 64

                MovZX   BX, Byte Ptr [DI+20h]           ; Check whether chn
                                                        ; is on
                Test    Byte Ptr [ES:BX+40h], 80h
                JZ      CommandS6

                Test    Byte Ptr [DI], 32
                JNZ     CommandS6

                Test    Byte Ptr [DI], 4
                JZ      CommandS6                       ; Channel was off.

                Mov     SI, [DI+24h]
                Or      Byte Ptr [SI+1], 8

CommandS6:
                Ret

EndP            CommandS
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CommandT
                Assume DS:Music

                Mov     AL, [DI+19h]
                Mov     BL, Tempo
                Xor     AH, AH
                Xor     BH, BH

                Test    AL, 0F0h
                JZ      CommandT1
                                        ; Slide up
                Add     BX, AX
                Sub     BX, 10h
                Cmp     BX, 0FFh
                JBE     CommandT2
                Mov     BL, 0FFh
                Jmp     CommandT2

CommandT1:                              ; Slide down
                Sub     BX, AX
                Cmp     BX, 20h
                JGE     CommandT2

                Mov     BL, 20h

CommandT2:
                Mov     Tempo, BL
                PushA
                Call    [DriverSetTempo]
                PopA
                Ret

EndP            CommandT
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CommandW                        ; Global volume slide!
                Assume DS:Music

                Xor     BH, BH
                MovSX   AX, Byte Ptr [DI+40h]
                Mov     BL, GlobalVolume

                Add     AX, BX

                JNS     CommandW1

                Xor     AL, AL

CommandW1:
                Cmp     AL, 128
                JBE     CommandW2

                Mov     AL, 128

CommandW2:
                Mov     GlobalVolume, AL

                Call    RecalculateAllVolumes
                Ret

EndP            CommandW
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CommandY

                Test    Byte Ptr [DI], 4
                JZ      CommandY5

                Mov     SI, [DI+24h]

                Mov     BH, [DI+28h]            ; AL = waveform
                Cmp     BH, 3
                JAE     CommandY1

                Mov     BL, [DI+29h]            ; Pos
                Add     BL, [DI+2Bh]            ; Add speed.
                Mov     [DI+29h], BL            ; Save value

                Mov     AL, [FineSineData+BX]       ; AL = -64 -> 64

                Jmp     CommandY2

CommandY1:                                      ; Random panning make
                                                ; speed the delay time.
                Dec     Byte Ptr [DI+29h]
                JZ      CommandY6
                JS      CommandY6

                Mov     AL, [DI+2Ch]
                Jmp     CommandY2

CommandY6:
                Mov     BL, [DI+2Bh]
                Mov     [DI+29h], BL            ; reset countdown.

                Call    Random
                And     AL, 127
                Sub     AL, 64

                Mov     [DI+2Ch], AL

CommandY2:
                IMul    Byte Ptr [DI+2Ah]
                SAL     AX, 2
                Add     AX, 80h
                MovZX   BX, AH
                                                ; AH = panning change
                Mov     AL, [SI+2Bh]            ; AL = panning
                Cmp     AL, 100                 ; Surround?
                JE      CommandY5

                Add     AL, AH
                JNS     CommandY3

                Xor     AL, AL

CommandY3:
                Cmp     AL, 64
                JBE     CommandY4

                Mov     AL, 64

CommandY4:
                Or      Byte Ptr [SI], 2        ; Panning change
                Mov     [SI+2Ah], AL

CommandY5:
                Ret

EndP            CommandY


