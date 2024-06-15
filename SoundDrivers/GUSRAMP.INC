
Proc            SetGUSVolume            ; BX = new volume

                                        ; To do:
                                        ;  1) Set ramp start
                                        ;  2) Set ramp end
                                        ;  3) Set current volume
                                        ;  4) Start ramp
                                        ;  5) Save new volume.

                Push    BX
                Push    CX

                Mov     AL, 0Dh
                Out     DX, AL

                Mov     AL, 3           ; Stop Ramp!
                Add     DL, 2
                Out     DX, AL
                Call    GUSDelay
                Out     DX, AL
                Sub     DL, 2

                Add     BX, BX
                Mov     CX, [CS:GUSVolumeTable+BX] ; CX = new volume
                Mov     BX, [SI+2]
                Add     BX, BX
                Mov     BX, [CS:GUSVolumeTable+BX] ; BX = old volume

                Cmp     BX, CX
                JNE     SetGUSVolume2

                Mov     AL, 89h
                Out     DX, AL
                Inc     DX
                In      AX, DX
                Dec     DX

                Mov     BX, AX          ; BX = old volume

SetGUSVolume2:

                Push    BX                      ; Old volume on stack

                Xor     AH, AH          ; Ramp up
                Cmp     CX, BX
                JAE     SetGUSVolume1

                XChg    BX, CX
                Mov     AH, 40h         ; Ramp down

SetGUSVolume1:
                Mov     AL, 6           ; Ramp rate
                Out     DX, AL

                Mov     AL, Byte Ptr CS:UsedChannels
                ShR     AL, 1
                Add     AL, 16
                Add     DL, 2
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 7           ; Ramp start
                Out     DX, AL

                Mov     AL, BH
                Add     DL, 2
                Out     DX, AL
                Call    GUSDelay
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 8           ; Ramp end
                Out     DX, AL

                Mov     AL, CH
                Add     DL, 2
                Out     DX, AL
                Call    GUSDelay
                Out     DX, AL
                Sub     DL, 2

                Mov     AL, 9
                Out     DX, AL

                Pop     BX              ; BX = old volume
                XChg    BX, AX

                Inc     DX
                Out     DX, AX
                Call    GUSDelay
                Out     DX, AX
                Dec     DX

                Mov     AL, 0Dh         ; Ramp control
                Out     DX, AL

                Mov     AL, BH
                Add     DL, 2
                Out     DX, AL
                Call    GUSDelay
                Out     DX, AL
                Sub     DL, 2

                Pop     CX
                Pop     BX

                Mov     [SI+2], BX

                Ret

EndP            SetGUSVolume


