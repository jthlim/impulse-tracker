
                        ; Different mixing routines required:
                        ;  Left         } shared
                        ;  Right        }
                        ;  Central
                        ;  Surround
                        ;  Panned ; Each requires 8 bit and 16 bit
                        ; Single output - for Mono, pure left/pure right

M12Mix8Single Macro Index

M12Mix8Single&Index&:
        Mov     BL, [ES:DI]                                     ;; 2
        Add     ERROR, DELTAERROR                               ;; 1
        Mov     AX, [EBX+EBX]                                   ;; 2
        AdC     DI, DELTAOFFSET                                 ;; 1
        Sub     [SI+(Index-15)*MixResolution/4+EXTRAOFFSET], AX ;; 3

EndM

M12Mix8Central Macro   Index

M12Mix8Central&Index&:
        Mov     BL, [ES:DI]                                     ;; 2
        Add     ERROR, DELTAERROR                               ;; 1
        Mov     AX, [EBX+EBX]                                   ;; 2
        AdC     DI, DELTAOFFSET                                 ;; 1
        Sub     [SI+(Index-15)*MixResolution/4+EXTRAOFFSET], AX ;; 3
        Sub     [SI+(Index-15)*MixResolution/4+MixResolution/8+EXTRAOFFSET], AX ;; 3

EndM

M12Mix8Surround Macro   Index

M12Mix8Surround&Index&:
        Mov     BL, [ES:DI]                                     ;; 2
        Add     ERROR, DELTAERROR                               ;; 1
        Mov     AX, [EBX+EBX]                                   ;; 2
        AdC     DI, DELTAOFFSET                                 ;; 1
        Sub     [SI+(Index-15)*MixResolution/4+EXTRAOFFSET], AX ;; 3
        Add     [SI+(Index-15)*MixResolution/4+MixResolution/8+EXTRAOFFSET], AX ;; 3

EndM

                        ; Panned output
M12Mix8PannedNext Macro   Index

M12Mix8PannedVolume&Index&   EQU $+1
        Mov     BH, 12h
        Mov     BL, [ES:DI]

EndM

M12Mix8Panned Macro Index

M12Mix8Panned&Index&:
        Add     BX, BX
        Add     ERROR, DELTAERROR
        AdC     DI, DELTAOFFSET
        Mov     AX, [BX]
        Sub     [SI+(Index-15)*MixResolution/4+EXTRAOFFSET], AX

M12Mix8PannedRightVolumeOffset&Index&  EQU $+3
        Mov     AX, [BX+1200h]

        M12Mix8PannedNext       %(Index+1)

        Sub     [SI+(Index-15)*MixResolution/4+MixResolution/8+EXTRAOFFSET], AX

EndM

M12Mix16Single Macro Index

M12Mix16Single&Index&:
        Mov     BL, [ES:EDI+EDI+1]
        Add     ERROR, DELTAERROR
        Mov     AX, [EBX+EBX]
        AdC     DI, DELTAOFFSET
        Sub     [SI+(Index-15)*MixResolution/4+EXTRAOFFSET], AX

EndM

M12Mix16Central Macro Index

M12Mix16Central&Index&:
        Mov     BL, [ES:EDI+EDI+1]
        Add     ERROR, DELTAERROR
        Mov     AX, [EBX+EBX]
        AdC     DI, DELTAOFFSET
        Sub     [SI+(Index-15)*MixResolution/4+EXTRAOFFSET], AX
        Sub     [SI+(Index-15)*MixResolution/4+MixResolution/8+EXTRAOFFSET], AX

EndM

M12Mix16Surround Macro Index

M12Mix16Surround&Index&:
        Mov     BL, [ES:EDI+EDI+1]
        Add     ERROR, DELTAERROR
        Mov     AX, [EBX+EBX]
        AdC     DI, DELTAOFFSET
        Sub     [SI+(Index-15)*MixResolution/4+EXTRAOFFSET], AX
        Add     [SI+(Index-15)*MixResolution/4+MixResolution/8+EXTRAOFFSET], AX

EndM

                        ; Panned output
M12Mix16PannedNext Macro   Index

M12Mix16PannedVolume&Index&   EQU $+1
        Mov     BH, 12h
        Mov     BL, [ES:EDI+EDI+1]

EndM

M12Mix16Panned Macro Index

M12Mix16Panned&Index&:
        Add     BX, BX
        Add     ERROR, DELTAERROR
        AdC     DI, DELTAOFFSET
        Mov     AX, [BX]
        Sub     [SI+(Index-15)*MixResolution/4+EXTRAOFFSET], AX

M12Mix16PannedRightVolumeOffset&Index&  EQU $+3
        Mov     AX, [BX+1200h]

        M12Mix16PannedNext       %(Index+1)

        Sub     [SI+(Index-15)*MixResolution/4+MixResolution/8+EXTRAOFFSET], AX

EndM

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Mix12Single8BitOffsetTable      Label   Word

        IndexCounter    =       15

        M12Mix8SingleOffset Macro Index
                DW      Offset M12Mix8Single&Index&
        EndM

        REPT 16
                M12Mix8SingleOffset     %IndexCounter
                IndexCounter = IndexCounter-1
        EndM

Proc            Mix12Single8Bit
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

                Push    [CS:Mix12Single8BitOffsetTable+BX]

M12Single8BitVolume     EQU     $+3
                Mov     EBX, 0          ; Set BH = volume

                RetN

                M12Mix8Single 0
                M12Mix8Single 1
                M12Mix8Single 2
                M12Mix8Single 3
                M12Mix8Single 4
                M12Mix8Single 5
                M12Mix8Single 6
                M12Mix8Single 7
                M12Mix8Single 8
                M12Mix8Single 9
                M12Mix8Single 10
                M12Mix8Single 11
                M12Mix8Single 12
                M12Mix8Single 13
                M12Mix8Single 14
                M12Mix8Single 15

                Add     SI, 16*MIXRESOLUTION/4
                Dec     LoopCounter
                JNZ     M12Mix8Single0

                Ret

EndP            Mix12Single8Bit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix12Left8Bit

                Mov     AL, [SI+0Eh]
                Mov     Byte Ptr [CS:M12Single8BitVolume], AL
                Ret

EndP            PreMix12Left8Bit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix12Right8Bit

                Add     MixBufferOffset, MixResolution/8
                Mov     AL, [SI+0Ch]
                Mov     Byte Ptr [CS:M12Single8BitVolume], AL

                Ret

EndP            PreMix12Right8Bit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Mix12Central8BitOffsetTable      Label   Word

        IndexCounter    =       15

        M12Mix8CentralOffset Macro Index
                DW      Offset M12Mix8Central&Index&
        EndM

        REPT 16
                M12Mix8CentralOffset    %IndexCounter
                IndexCounter = IndexCounter-1
        EndM

Proc            Mix12Central8Bit

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

                Push    [CS:Mix12Central8BitOffsetTable+BX]

M12Central8BitVolume EQU     $+3
                Mov     EBX, 0          ; Set BH = volume

                RetN

                M12Mix8Central 0
                M12Mix8Central 1
                M12Mix8Central 2
                M12Mix8Central 3
                M12Mix8Central 4
                M12Mix8Central 5
                M12Mix8Central 6
                M12Mix8Central 7
                M12Mix8Central 8
                M12Mix8Central 9
                M12Mix8Central 10
                M12Mix8Central 11
                M12Mix8Central 12
                M12Mix8Central 13
                M12Mix8Central 14
                M12Mix8Central 15

                Add     SI, 16*MIXRESOLUTION/4
                Dec     LoopCounter
                JNZ     M12Mix8Central0

                Ret

EndP            Mix12Central8Bit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix12Central8Bit

                Mov     AL, [SI+0Eh]
                Mov     Byte Ptr [CS:M12Central8BitVolume], AL

                Ret

EndP            PreMix12Central8Bit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Mix12Surround8BitOffsetTable      Label   Word

        IndexCounter    =       15

        M12Mix8SurroundOffset Macro Index
                DW      Offset M12Mix8Surround&Index&
        EndM

        REPT 16
                M12Mix8SurroundOffset    %IndexCounter
                IndexCounter = IndexCounter-1
        EndM

Proc            Mix12Surround8Bit

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

                Push    [CS:Mix12Surround8BitOffsetTable+BX]

M12Surround8BitVolume EQU     $+3
                Mov     EBX, 0          ; Set BH = volume


                RetN

                M12Mix8Surround 0
                M12Mix8Surround 1
                M12Mix8Surround 2
                M12Mix8Surround 3
                M12Mix8Surround 4
                M12Mix8Surround 5
                M12Mix8Surround 6
                M12Mix8Surround 7
                M12Mix8Surround 8
                M12Mix8Surround 9
                M12Mix8Surround 10
                M12Mix8Surround 11
                M12Mix8Surround 12
                M12Mix8Surround 13
                M12Mix8Surround 14
                M12Mix8Surround 15

                Add     SI, 16*MIXRESOLUTION/4
                Dec     LoopCounter
                JNZ     M12Mix8Surround0

                Ret

EndP            Mix12Surround8Bit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix12Surround8Bit

                Mov     AL, [SI+0Eh]
                Mov     Byte Ptr [CS:M12Surround8BitVolume], AL

                Ret

EndP            PreMix12Surround8Bit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Mix12Panned8BitOffsetTable      Label   Word

        IndexCounter    =       15

        M12Mix8PannedOffset Macro Index
                DW      Offset M12Mix8Panned&Index&
        EndM

        REPT 16
                M12Mix8PannedOffset    %IndexCounter
                IndexCounter = IndexCounter-1
        EndM

Proc            Mix12Panned8Bit

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

                Push    [CS:Mix12Panned8BitOffsetTable+BX]

                M12Mix8PannedNext      0

                RetN

                M12Mix8Panned 0
                M12Mix8Panned 1
                M12Mix8Panned 2
                M12Mix8Panned 3
                M12Mix8Panned 4
                M12Mix8Panned 5
                M12Mix8Panned 6
                M12Mix8Panned 7
                M12Mix8Panned 8
                M12Mix8Panned 9
                M12Mix8Panned 10
                M12Mix8Panned 11
                M12Mix8Panned 12
                M12Mix8Panned 13
                M12Mix8Panned 14
                M12Mix8Panned 15

                Add     SI, 16*MIXRESOLUTION/4
                Dec     LoopCounter
                JNZ     M12Mix8Panned0

                Ret

EndP            Mix12Panned8Bit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix12Panned8Bit

                Mov     AL, [SI+0Eh]

        IndexCounter    =       0

        PreMix12PannedMacro Macro Index
                Mov     Byte Ptr [CS:M12Mix8PannedVolume&Index&], AL
        EndM

        REPT 17
                PreMix12PannedMacro    %IndexCounter
                IndexCounter = IndexCounter+1
        EndM

                Mov     AL, [SI+0Ch]
                Sub     AL, [SI+0Eh]
                Add     AL, AL

        IndexCounter    =       0

        PreMix12PannedMacro2 Macro Index
                Mov     Byte Ptr [CS:M12Mix8PannedRightVolumeOffset&Index&], AL
        EndM

        REPT 16
                PreMix12PannedMacro2   %IndexCounter
                IndexCounter = IndexCounter+1
        EndM

                Ret

EndP            PreMix12Panned8Bit

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Mix12Single16BitOffsetTable      Label   Word

        IndexCounter    =       15

        M12Mix16SingleOffset Macro Index
                DW      Offset M12Mix16Single&Index&
        EndM

        REPT 16
                M12Mix16SingleOffset     %IndexCounter
                IndexCounter = IndexCounter-1
        EndM

Proc            Mix12Single16Bit
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

                Push    [CS:Mix12Single16BitOffsetTable+BX]

M12Single16BitVolume     EQU     $+3
                Mov     EBX, 0          ; Set BH = volume

                RetN

                M12Mix16Single 0
                M12Mix16Single 1
                M12Mix16Single 2
                M12Mix16Single 3
                M12Mix16Single 4
                M12Mix16Single 5
                M12Mix16Single 6
                M12Mix16Single 7
                M12Mix16Single 8
                M12Mix16Single 9
                M12Mix16Single 10
                M12Mix16Single 11
                M12Mix16Single 12
                M12Mix16Single 13
                M12Mix16Single 14
                M12Mix16Single 15

                Add     SI, 16*MIXRESOLUTION/4
                Dec     LoopCounter
                JNZ     M12Mix16Single0

                Ret

EndP            Mix12Single16Bit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix12Left16Bit

                Mov     AL, [SI+0Eh]
                Mov     Byte Ptr [CS:M12Single16BitVolume], AL
                Ret

EndP            PreMix12Left16Bit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix12Right16Bit

                Add     MixBufferOffset, MixResolution/8
                Mov     AL, [SI+0Ch]
                Mov     Byte Ptr [CS:M12Single16BitVolume], AL

                Ret

EndP            PreMix12Right16Bit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Mix12Central16BitOffsetTable      Label   Word

        IndexCounter    =       15

        M12Mix16CentralOffset Macro Index
                DW      Offset M12Mix16Central&Index&
        EndM

        REPT 16
                M12Mix16CentralOffset    %IndexCounter
                IndexCounter = IndexCounter-1
        EndM

Proc            Mix12Central16Bit

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

                Push    [CS:Mix12Central16BitOffsetTable+BX]

M12Central16BitVolume     EQU     $+3
                Mov     EBX, 0          ; Set BH = volume


                RetN

                M12Mix16Central 0
                M12Mix16Central 1
                M12Mix16Central 2
                M12Mix16Central 3
                M12Mix16Central 4
                M12Mix16Central 5
                M12Mix16Central 6
                M12Mix16Central 7
                M12Mix16Central 8
                M12Mix16Central 9
                M12Mix16Central 10
                M12Mix16Central 11
                M12Mix16Central 12
                M12Mix16Central 13
                M12Mix16Central 14
                M12Mix16Central 15

                Add     SI, 16*MIXRESOLUTION/4
                Dec     LoopCounter
                JNZ     M12Mix16Central0

                Ret

EndP            Mix12Central16Bit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix12Central16Bit

                Mov     AL, [SI+0Eh]
                Mov     Byte Ptr [CS:M12Central16BitVolume], AL

                Ret

EndP            PreMix12Central16Bit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Mix12Surround16BitOffsetTable      Label   Word

        IndexCounter    =       15

        M12Mix16SurroundOffset Macro Index
                DW      Offset M12Mix16Surround&Index&
        EndM

        REPT 16
                M12Mix16SurroundOffset    %IndexCounter
                IndexCounter = IndexCounter-1
        EndM

Proc            Mix12Surround16Bit

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

                Push    [CS:Mix12Surround16BitOffsetTable+BX]

M12Surround16BitVolume     EQU     $+3
                Mov     EBX, 0          ; Set BH = volume


                RetN

                M12Mix16Surround 0
                M12Mix16Surround 1
                M12Mix16Surround 2
                M12Mix16Surround 3
                M12Mix16Surround 4
                M12Mix16Surround 5
                M12Mix16Surround 6
                M12Mix16Surround 7
                M12Mix16Surround 8
                M12Mix16Surround 9
                M12Mix16Surround 10
                M12Mix16Surround 11
                M12Mix16Surround 12
                M12Mix16Surround 13
                M12Mix16Surround 14
                M12Mix16Surround 15

                Add     SI, 16*MIXRESOLUTION/4
                Dec     LoopCounter
                JNZ     M12Mix16Surround0

                Ret

EndP            Mix12Surround16Bit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix12Surround16Bit

                Mov     AL, [SI+0Eh]
                Mov     Byte Ptr [CS:M12Surround16BitVolume], AL

                Ret

EndP            PreMix12Surround16Bit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Mix12Panned16BitOffsetTable      Label   Word

        IndexCounter    =       15

        M12Mix16PannedOffset Macro Index
                DW      Offset M12Mix16Panned&Index&
        EndM

        REPT 16
                M12Mix16PannedOffset    %IndexCounter
                IndexCounter = IndexCounter-1
        EndM

Proc            Mix12Panned16Bit

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

                Push    [CS:Mix12Panned16BitOffsetTable+BX]

                M12Mix16PannedNext      0

                RetN

Pan12Bit16Loop:
                M12Mix16PannedNext       16

                M12Mix16Panned 0
                M12Mix16Panned 1
                M12Mix16Panned 2
                M12Mix16Panned 3
                M12Mix16Panned 4
                M12Mix16Panned 5
                M12Mix16Panned 6
                M12Mix16Panned 7
                M12Mix16Panned 8
                M12Mix16Panned 9
                M12Mix16Panned 10
                M12Mix16Panned 11
                M12Mix16Panned 12
                M12Mix16Panned 13
                M12Mix16Panned 14

        M12Mix16Panned15:
                Add     BX, BX
                Add     ERROR, DELTAERROR
                AdC     DI, DELTAOFFSET
                Mov     AX, [BX]
                Sub     [SI+EXTRAOFFSET], AX
        M12Mix16PannedRightVolumeOffset15  EQU $+3
                Mov     AX, [BX+1200h]
                Sub     [SI+MixResolution/8+EXTRAOFFSET], AX


                Add     SI, 16*MIXRESOLUTION/4
                Dec     LoopCounter
                JNZ     Pan12Bit16Loop

                Ret

EndP            Mix12Panned16Bit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PreMix12Panned16Bit

                Mov     AL, [SI+0Eh]

        IndexCounter    =       0

        PreMix12PannedMacro Macro Index
                Mov     Byte Ptr [CS:M12Mix16PannedVolume&Index&], AL
        EndM

        REPT 17
                PreMix12PannedMacro    %IndexCounter
                IndexCounter = IndexCounter+1
        EndM

                Mov     AL, [SI+0Ch]
                Sub     AL, [SI+0Eh]
                Add     AL, AL

        IndexCounter    =       0

        PreMix12PannedMacro2 Macro Index
                Mov     Byte Ptr [CS:M12Mix16PannedRightVolumeOffset&Index&], AL
        EndM

        REPT 16
                PreMix12PannedMacro2   %IndexCounter
                IndexCounter = IndexCounter+1
        EndM

                Ret

EndP            PreMix12Panned16Bit


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

