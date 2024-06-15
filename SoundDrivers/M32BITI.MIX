
                        ; Different mixing routines required:
                        ;  Left         } shared
                        ;  Right        }
                        ;  Central
                        ;  Surround
                        ;  Panned ; Each requires 8 bit and 16 bit
                        ; Single output - for Mono, pure left/pure right

Get32Bit8Waveform Macro
        MovSX   EBX, Byte Ptr [ES:DI+1]
        MovSX   EAX, Byte Ptr [ES:DI]
        Sub     EBX, EAX
        IMul    EBX, ECX
        SAR     EBX, 8
        ShL     EAX, 8
        Add     EBX, EAX

EndM

Get32Bit16Waveform Macro
        MovSX   EBX, Word Ptr [ES:EDI+EDI+2]
        MovSX   EAX, Word Ptr [ES:EDI+EDI]
        Sub     EBX, EAX
        SAR     EBX, 1
        IMul    EBX, ECX
        SAR     EBX, 15
        Add     EBX, EAX
EndM

M32Mix8ISingle Macro Index

M32Mix8ISingle&Index&:
        Get32Bit8WaveForm

M32Mix8ISingleVolume&Index& EQU     $+3
        IMul    EAX, EBX, 8000h

        Add     ERROR, DELTAERROR                               ;; 1
        AdC     DI, DELTAOFFSET                                 ;; 1
        Sub     [SI+(Index-15)*8], EAX                          ;; 3
EndM

M32Mix8ICentral Macro   Index

M32Mix8ICentral&Index&:
        Get32Bit8WaveForm

M32Mix8ICentralVolume&Index& EQU     $+3
        IMul    EAX, EBX, 8000h

        Add     ERROR, DELTAERROR                               ;; 1
        AdC     DI, DELTAOFFSET                                 ;; 1
        Sub     [SI+(Index-15)*8], EAX                          ;; 4
        Sub     [SI+(Index-15)*8+4], EAX                        ;; 4

EndM

M32Mix8ISurround Macro   Index

M32Mix8ISurround&Index&:
        Get32Bit8WaveForm

M32Mix8ISurroundVolume&Index& EQU $+3
        IMul    EAX, EBX, 8000h

        Add     ERROR, DELTAERROR                               ;; 1
        AdC     DI, DELTAOFFSET                                 ;; 1
        Sub     [SI+(Index-15)*8], EAX                          ;; 4
        Add     [SI+(Index-15)*8+4], EAX                        ;; 4

EndM

                        ; Panned output
M32Mix8IPanned Macro Index

M32Mix8IPanned&Index&:
        Get32Bit8WaveForm

M32Mix8ILeftVolume&Index& EQU     $+3
        IMul    EAX, EBX, 8000h
M32Mix8IRightVolume&Index& EQU     $+3
        IMul    EBX, EBX, 8000h

        Sub     [SI+(Index-15)*8], EAX                          ;; 4
        Sub     [SI+(Index-15)*8+4], EBX                        ;; 4

        Add     ERROR, DELTAERROR                               ;; 1
        AdC     DI, DELTAOFFSET                                 ;; 1

EndM

M32Mix16ISingle Macro Index

M32Mix16ISingle&Index&:
        Get32Bit16WaveForm

M32Mix16ISingleVolume&Index& EQU     $+3
        IMul    EAX, EBX, 8000h

        Add     ERROR, DELTAERROR                               ;; 1
        AdC     DI, DELTAOFFSET                                 ;; 1
        Sub     [SI+(Index-15)*8], EAX                          ;; 3

EndM

M32Mix16ICentral Macro Index

M32Mix16ICentral&Index&:
        Get32Bit16WaveForm

M32Mix16ICentralVolume&Index& EQU     $+3
        IMul    EAX, EBX, 8000h

        Add     ERROR, DELTAERROR                               ;; 1
        AdC     DI, DELTAOFFSET                                 ;; 1
        Sub     [SI+(Index-15)*8], EAX                          ;; 3
        Sub     [SI+(Index-15)*8+4], EAX                        ;; 3

EndM

M32Mix16ISurround Macro Index

M32Mix16ISurround&Index&:
        Get32Bit16WaveForm

M32Mix16ISurroundVolume&Index& EQU     $+3
        IMul    EAX, EBX, 8000h

        Add     ERROR, DELTAERROR                               ;; 1
        AdC     DI, DELTAOFFSET                                 ;; 1
        Sub     [SI+(Index-15)*8], EAX                          ;; 3
        Add     [SI+(Index-15)*8+4], EAX                        ;; 3

EndM

                        ; Panned output
M32Mix16IPanned Macro Index

M32Mix16IPanned&Index&:
        Get32Bit16WaveForm

M32Mix16ILeftVolume&Index& EQU     $+3
        IMul    EAX, EBX, 8000h
M32Mix16IRightVolume&Index& EQU     $+3
        IMul    EBX, EBX, 8000h

        Sub     [SI+(Index-15)*8], EAX
        Sub     [SI+(Index-15)*8+4], EBX

        Add     ERROR, DELTAERROR
        AdC     DI, DELTAOFFSET

EndM

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Mix32Single8BitIOffsetTable      Label   Word

        IndexCounter    =       15

        M32Mix8ISingleOffset Macro Index
                DW      Offset M32Mix8ISingle&Index&
        EndM

        REPT 16
                M32Mix8ISingleOffset     %IndexCounter
                IndexCounter = IndexCounter-1
        EndM

Proc            Mix32Single8BitI
                                                ; AX = count...

                ; Number of times to loop = (Count-1) / 16

                Dec     AX
                Mov     BX, AX
                And     AX, 0Fh
                ShR     BX, 4
                Add     AX, AX
                Inc     BX
                Mov     LoopCounter, BX
                Mov     BX, AX

                ShL     AX, RESOLUTIONSHIFT-1

                Add     SI, AX

                Jmp     [CS:Mix32Single8BitIOffsetTable+BX]

                M32Mix8ISingle 0
                M32Mix8ISingle 1
                M32Mix8ISingle 2
                M32Mix8ISingle 3
                M32Mix8ISingle 4
                M32Mix8ISingle 5
                M32Mix8ISingle 6
                M32Mix8ISingle 7
                M32Mix8ISingle 8
                M32Mix8ISingle 9
                M32Mix8ISingle 10
                M32Mix8ISingle 11
                M32Mix8ISingle 12
                M32Mix8ISingle 13
                M32Mix8ISingle 14
                M32Mix8ISingle 15

                Add     SI, 16*MIXRESOLUTION/4
                Dec     LoopCounter
                JNZ     M32Mix8ISingle0

                Ret

EndP            Mix32Single8BitI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix32Left8BitI

                Mov     AX, [SI+0Eh]

PreMix32Left8BitI1:
        IndexCounter    =       0

        PreMix32SingleMacro Macro Index
                Mov     Word Ptr [CS:M32Mix8ISingleVolume&Index&], AX
        EndM

        REPT 16
                PreMix32SingleMacro    %IndexCounter
                IndexCounter = IndexCounter+1
        EndM
                Ret

EndP            PreMix32Left8BitI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix32Right8BitI

                Add     MixBufferOffset, MixResolution/8
                Mov     AX, [SI+0Ch]
                Jmp     PreMix32Left8BitI1

EndP            PreMix32Right8BitI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Mix32Central8BitIOffsetTable      Label   Word

        IndexCounter    =       15

        M32Mix8ICentralOffset Macro Index
                DW      Offset M32Mix8ICentral&Index&
        EndM

        REPT 16
                M32Mix8ICentralOffset    %IndexCounter
                IndexCounter = IndexCounter-1
        EndM

Proc            Mix32Central8BitI

                Dec     AX
                Mov     BX, AX
                And     AX, 0Fh
                ShR     BX, 4
                Add     AX, AX
                Inc     BX
                Mov     LoopCounter, BX
                Mov     BX, AX

                ShL     AX, RESOLUTIONSHIFT-1

                Add     SI, AX

                Jmp     [CS:Mix32Central8BitIOffsetTable+BX]

                M32Mix8ICentral 0
                M32Mix8ICentral 1
                M32Mix8ICentral 2
                M32Mix8ICentral 3
                M32Mix8ICentral 4
                M32Mix8ICentral 5
                M32Mix8ICentral 6
                M32Mix8ICentral 7
                M32Mix8ICentral 8
                M32Mix8ICentral 9
                M32Mix8ICentral 10
                M32Mix8ICentral 11
                M32Mix8ICentral 12
                M32Mix8ICentral 13
                M32Mix8ICentral 14
                M32Mix8ICentral 15

                Add     SI, 16*MIXRESOLUTION/4
                Dec     LoopCounter
                JNZ     M32Mix8ICentral0

                Ret

EndP            Mix32Central8BitI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix32Central8BitI

                Mov     AX, [SI+0Eh]

        IndexCounter    =       0

        PreMix32CentralMacro Macro Index
                Mov     Word Ptr [CS:M32Mix8ICentralVolume&Index&], AX
        EndM

        REPT 16
                PreMix32CentralMacro    %IndexCounter
                IndexCounter = IndexCounter+1
        EndM

                Ret

EndP            PreMix32Central8BitI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Mix32Surround8BitIOffsetTable      Label   Word

        IndexCounter    =       15

        M32Mix8ISurroundOffset Macro Index
                DW      Offset M32Mix8ISurround&Index&
        EndM

        REPT 16
                M32Mix8ISurroundOffset    %IndexCounter
                IndexCounter = IndexCounter-1
        EndM

Proc            Mix32Surround8BitI

                Dec     AX
                Mov     BX, AX
                And     AX, 0Fh
                ShR     BX, 4
                Add     AX, AX
                Inc     BX
                Mov     LoopCounter, BX
                Mov     BX, AX

                ShL     AX, RESOLUTIONSHIFT-1

                Add     SI, AX

                Jmp     [CS:Mix32Surround8BitIOffsetTable+BX]

                M32Mix8ISurround 0
                M32Mix8ISurround 1
                M32Mix8ISurround 2
                M32Mix8ISurround 3
                M32Mix8ISurround 4
                M32Mix8ISurround 5
                M32Mix8ISurround 6
                M32Mix8ISurround 7
                M32Mix8ISurround 8
                M32Mix8ISurround 9
                M32Mix8ISurround 10
                M32Mix8ISurround 11
                M32Mix8ISurround 12
                M32Mix8ISurround 13
                M32Mix8ISurround 14
                M32Mix8ISurround 15

                Add     SI, 16*MIXRESOLUTION/4
                Dec     LoopCounter
                JNZ     M32Mix8ISurround0

                Ret

EndP            Mix32Surround8BitI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix32Surround8BitI

                Mov     AX, [SI+0Eh]

        IndexCounter    =       0

        PreMix32SurroundMacro Macro Index
                Mov     Word Ptr [CS:M32Mix8ISurroundVolume&Index&], AX
        EndM

        REPT 16
                PreMix32SurroundMacro    %IndexCounter
                IndexCounter = IndexCounter+1
        EndM

                Ret

EndP            PreMix32Surround8BitI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Mix32Panned8BitIOffsetTable      Label   Word

        IndexCounter    =       15

        M32Mix8IPannedOffset Macro Index
                DW      Offset M32Mix8IPanned&Index&
        EndM

        REPT 16
                M32Mix8IPannedOffset    %IndexCounter
                IndexCounter = IndexCounter-1
        EndM

Proc            Mix32Panned8BitI

                Dec     AX
                Mov     BX, AX
                And     AX, 0Fh
                ShR     BX, 4
                Add     AX, AX
                Inc     BX
                Mov     LoopCounter, BX
                Mov     BX, AX

                ShL     AX, RESOLUTIONSHIFT-1

                Add     SI, AX

                Jmp     [CS:Mix32Panned8BitIOffsetTable+BX]

                M32Mix8IPanned 0
                M32Mix8IPanned 1
                M32Mix8IPanned 2
                M32Mix8IPanned 3
                M32Mix8IPanned 4
                M32Mix8IPanned 5
                M32Mix8IPanned 6
                M32Mix8IPanned 7
                M32Mix8IPanned 8
                M32Mix8IPanned 9
                M32Mix8IPanned 10
                M32Mix8IPanned 11
                M32Mix8IPanned 12
                M32Mix8IPanned 13
                M32Mix8IPanned 14
                M32Mix8IPanned 15

                Add     SI, 16*MIXRESOLUTION/4
                Dec     LoopCounter
                JNZ     M32Mix8IPanned0

                Ret

EndP            Mix32Panned8BitI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix32Panned8BitI

                Mov     AX, [SI+0Eh]    ; Left
                Mov     BX, [SI+0Ch]    ; Right

        IndexCounter    =       0

        PreMix32PannedMacro Macro Index
                Mov     Word Ptr [CS:M32Mix8ILeftVolume&Index&], AX
                Mov     Word Ptr [CS:M32Mix8IRightVolume&Index&], BX
        EndM

        REPT 16
                PreMix32PannedMacro    %IndexCounter
                IndexCounter = IndexCounter+1
        EndM

                Ret

EndP            PreMix32Panned8BitI

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Mix32Single16BitIOffsetTable      Label   Word

        IndexCounter    =       15

        M32Mix16ISingleOffset Macro Index
                DW      Offset M32Mix16ISingle&Index&
        EndM

        REPT 16
                M32Mix16ISingleOffset     %IndexCounter
                IndexCounter = IndexCounter-1
        EndM

Proc            Mix32Single16BitI
                                                ; AX = count...

                ; Number of times to loop = (Count-1) / 16

                Dec     AX
                Mov     BX, AX
                And     AX, 0Fh
                ShR     BX, 4
                Add     AX, AX
                Inc     BX
                Mov     LoopCounter, BX
                Mov     BX, AX

                ShL     AX, RESOLUTIONSHIFT-1

                Add     SI, AX

                Jmp     [CS:Mix32Single16BitIOffsetTable+BX]

                M32Mix16ISingle 0
                M32Mix16ISingle 1
                M32Mix16ISingle 2
                M32Mix16ISingle 3
                M32Mix16ISingle 4
                M32Mix16ISingle 5
                M32Mix16ISingle 6
                M32Mix16ISingle 7
                M32Mix16ISingle 8
                M32Mix16ISingle 9
                M32Mix16ISingle 10
                M32Mix16ISingle 11
                M32Mix16ISingle 12
                M32Mix16ISingle 13
                M32Mix16ISingle 14
                M32Mix16ISingle 15

                Add     SI, 16*MIXRESOLUTION/4
                Dec     LoopCounter
                JNZ     M32Mix16ISingle0

                Ret

EndP            Mix32Single16BitI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix32Left16BitI

                Mov     AX, [SI+0Eh]    ; Left

PreMix32Left16BitI1:
        IndexCounter    =       0

        PreMix32SingleMacro Macro Index
                Mov     Word Ptr [CS:M32Mix16ISingleVolume&Index&], AX
        EndM

        REPT 16
                PreMix32SingleMacro    %IndexCounter
                IndexCounter = IndexCounter+1
        EndM

                Ret

EndP            PreMix32Left16BitI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix32Right16BitI

                Add     MixBufferOffset, MixResolution/8
                Mov     AX, [SI+0Ch]
                Jmp     PreMix32Left16BitI1

                Ret

EndP            PreMix32Right16BitI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Mix32Central16BitIOffsetTable      Label   Word

        IndexCounter    =       15

        M32Mix16ICentralOffset Macro Index
                DW      Offset M32Mix16ICentral&Index&
        EndM

        REPT 16
                M32Mix16ICentralOffset    %IndexCounter
                IndexCounter = IndexCounter-1
        EndM

Proc            Mix32Central16BitI

                Dec     AX
                Mov     BX, AX
                And     AX, 0Fh
                ShR     BX, 4
                Add     AX, AX
                Inc     BX
                Mov     LoopCounter, BX
                Mov     BX, AX

                ShL     AX, RESOLUTIONSHIFT-1

                Add     SI, AX

                Jmp     [CS:Mix32Central16BitIOffsetTable+BX]

                M32Mix16ICentral 0
                M32Mix16ICentral 1
                M32Mix16ICentral 2
                M32Mix16ICentral 3
                M32Mix16ICentral 4
                M32Mix16ICentral 5
                M32Mix16ICentral 6
                M32Mix16ICentral 7
                M32Mix16ICentral 8
                M32Mix16ICentral 9
                M32Mix16ICentral 10
                M32Mix16ICentral 11
                M32Mix16ICentral 12
                M32Mix16ICentral 13
                M32Mix16ICentral 14
                M32Mix16ICentral 15

                Add     SI, 16*MIXRESOLUTION/4
                Dec     LoopCounter
                JNZ     M32Mix16ICentral0

                Ret

EndP            Mix32Central16BitI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix32Central16BitI

                Mov     AX, [SI+0Eh]

        IndexCounter    =       0

        PreMix32CentralMacro Macro Index
                Mov     Word Ptr [CS:M32Mix16ICentralVolume&Index&], AX
        EndM

        REPT 16
                PreMix32CentralMacro    %IndexCounter
                IndexCounter = IndexCounter+1
        EndM

                Ret

EndP            PreMix32Central16BitI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Mix32Surround16BitIOffsetTable      Label   Word

        IndexCounter    =       15

        M32Mix16ISurroundOffset Macro Index
                DW      Offset M32Mix16ISurround&Index&
        EndM

        REPT 16
                M32Mix16ISurroundOffset    %IndexCounter
                IndexCounter = IndexCounter-1
        EndM

Proc            Mix32Surround16BitI

                Dec     AX
                Mov     BX, AX
                And     AX, 0Fh
                ShR     BX, 4
                Add     AX, AX
                Inc     BX
                Mov     LoopCounter, BX
                Mov     BX, AX

                ShL     AX, RESOLUTIONSHIFT-1

                Add     SI, AX

                Jmp     [CS:Mix32Surround16BitIOffsetTable+BX]

                M32Mix16ISurround 0
                M32Mix16ISurround 1
                M32Mix16ISurround 2
                M32Mix16ISurround 3
                M32Mix16ISurround 4
                M32Mix16ISurround 5
                M32Mix16ISurround 6
                M32Mix16ISurround 7
                M32Mix16ISurround 8
                M32Mix16ISurround 9
                M32Mix16ISurround 10
                M32Mix16ISurround 11
                M32Mix16ISurround 12
                M32Mix16ISurround 13
                M32Mix16ISurround 14
                M32Mix16ISurround 15

                Add     SI, 16*MIXRESOLUTION/4
                Dec     LoopCounter
                JNZ     M32Mix16ISurround0

                Ret

EndP            Mix32Surround16BitI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix32Surround16BitI

                Mov     AX, [SI+0Eh]

        IndexCounter    =       0

        PreMix32SurroundMacro Macro Index
                Mov     Word Ptr [CS:M32Mix16ISurroundVolume&Index&], AX
        EndM

        REPT 16
                PreMix32SurroundMacro    %IndexCounter
                IndexCounter = IndexCounter+1
        EndM

                Ret

EndP            PreMix32Surround16BitI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Mix32Panned16BitIOffsetTable      Label   Word

        IndexCounter    =       15

        M32Mix16IPannedOffset Macro Index
                DW      Offset M32Mix16IPanned&Index&
        EndM

        REPT 16
                M32Mix16IPannedOffset    %IndexCounter
                IndexCounter = IndexCounter-1
        EndM

Proc            Mix32Panned16BitI

                Dec     AX
                Mov     BX, AX
                And     AX, 0Fh
                ShR     BX, 4
                Add     AX, AX
                Inc     BX
                Mov     LoopCounter, BX
                Mov     BX, AX

                ShL     AX, RESOLUTIONSHIFT-1

                Add     SI, AX

                Jmp     [CS:Mix32Panned16BitIOffsetTable+BX]

Pan32Bit16ILoop:
                M32Mix16IPanned 0
                M32Mix16IPanned 1
                M32Mix16IPanned 2
                M32Mix16IPanned 3
                M32Mix16IPanned 4
                M32Mix16IPanned 5
                M32Mix16IPanned 6
                M32Mix16IPanned 7
                M32Mix16IPanned 8
                M32Mix16IPanned 9
                M32Mix16IPanned 10
                M32Mix16IPanned 11
                M32Mix16IPanned 12
                M32Mix16IPanned 13
                M32Mix16IPanned 14
                M32Mix16IPanned 15


                Add     SI, 16*MIXRESOLUTION/4
                Dec     LoopCounter
                JNZ     Pan32Bit16ILoop

                Ret

EndP            Mix32Panned16BitI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix32Panned16BitI

                Mov     AX, [SI+0Eh]            ; Left
                Mov     BX, [SI+0Ch]            ; Right

        IndexCounter    =       0

        PreMix32PannedMacro Macro Index
                Mov     Word Ptr [CS:M32Mix16ILeftVolume&Index&], AX
                Mov     Word Ptr [CS:M32Mix16IRightVolume&Index&], BX
        EndM

        REPT 16
                PreMix32PannedMacro    %IndexCounter
                IndexCounter = IndexCounter+1
        EndM

                Ret

EndP            PreMix32Panned16BitI


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

