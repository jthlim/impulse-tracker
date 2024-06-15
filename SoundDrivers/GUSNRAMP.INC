;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SetGUSVolume            ; BX = new volume

                                        ; To do:
                                        ;  1) Set ramp start
                                        ;  2) Set ramp end
                                        ;  3) Set current volume
                                        ;  4) Start ramp
                                        ;  5) Save new volume.

                Mov     AL, 9
                Out     DX, AL

                Add     BX, BX
                Mov     AX, [CS:GUSVolumeTable+BX]
                Inc     DX
                Out     DX, AX
                Call    GUSDelay
                Out     DX, AX
                Dec     DX

                Ret

EndP            SetGUSVolume


