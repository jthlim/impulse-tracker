
;зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
;Ё Variables                                                                   Ё
;юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

MIDIPort        DW      300h

;зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
;Ё Functions                                                                   Ё
;юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

Proc            Poll Far

                Mov     DX, [CS:MIDIPort]
                Test    DX, DX
                JZ      PollEnd

                Call    [CS:UARTBufferEmpty]
                JNC     PollEnd

                Inc     DX
                In      AL, DX
                Test    AL, 80h
                JNZ     PollEnd

                Dec     DX
                In      AL, DX
                Cmp     AL, 0F8h
                JAE     PollEnd

                Call    [CS:UARTSend]

PollEnd:
                Ret

EndP            Poll

;ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

Proc            MIDI_UnInit

                Ret

                Mov     DX, MIDIPort
                Test    DX, DX
                JZ      UnInitUARTEnd

                Inc     DX

                Mov     AL, 0FFh
                Out     DX, AL

UnInitUARTEnd:
                Ret

EndP            MIDI_UnInit

;ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

Proc            InitUART
                                        ; returns carry set if no UART

                Mov     BX, 32          ; Number of attempts to read correct
                                        ; value back from the UART

                Inc     DX
                Mov     AL, 0FFh
                Out     DX, AL          ; Reset UART

                Mov     AL, 03Fh
                Out     DX, AL          ; UART Mode

                Mov     CX, 0FFFFh

InitUART1:
                In      AL, DX
                Test    AL, 80h
                LoopNZ  InitUART1

InitUART2:
                StC
                JNZ     InitUART3

                Dec     DX
                In      AL, DX
                Cmp     AL, 0FEh
                JE      InitUART3

                Inc     DX
                Dec     BX
                JNZ     InitUART1

                StC

InitUART3:
                Ret

EndP            InitUART

;ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

Proc            MIDI_Init

                Mov     DX, 301h
                Mov     AL, 0FFh
                Out     DX, AL

                Mov     AL, 3Fh
                Out     DX, AL
                Ret

                Mov     DX, 330h
                Call    InitUART

                JC      MIDI_Init1

                Mov     [CS:MIDIPort], 330h
                Jmp     MIDI_InitEnd

MIDI_Init1:
                Mov     DX, 300h
                Call    InitUART
                JC      MIDI_InitEnd

                Mov     [CS:MIDIPort], 300h

MIDI_InitEnd:
                Ret

EndP            MIDI_Init
                Assume DS:Nothing

;ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд
