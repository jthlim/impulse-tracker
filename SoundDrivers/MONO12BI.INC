
        DW      Offset UpdateNoLoop, 0, 0, 0, 0         ; Update only
        DW      Offset UpdateForwardsLoop, 0, 0, 0, 0
        DW      Offset UpdatePingPongLoop, 0, 0, 0, 0
                                                        ; Central
        DW      Offset MixNoLoop, PreMix12Central8BitI, MFS8Bit, MBS8Bit, Mix12Central8BitI
        DW      Offset MixForwardsLoop, PreMix12Central8BitI, MFS8Bit, MBS8Bit, Mix12Central8BitI
        DW      Offset MixPingPongLoop, PreMix12Central8BitI, MFS8Bit, MBS8Bit, Mix12Central8BitI

        ; 16 bit tables
        DW      Offset UpdateNoLoop, 0, 0, 0, 0         ; Update only
        DW      Offset UpdateForwardsLoop, 0, 0, 0, 0
        DW      Offset UpdatePingPongLoop, 0, 0, 0, 0
                                                        ; Central
        DW      Offset MixNoLoop, PreMix12Central16BitI, MFS16Bit, MBS16Bit, Mix12Central16BitI
        DW      Offset MixForwardsLoop, PreMix12Central16BitI, MFS16Bit, MBS16Bit, Mix12Central16BitI
        DW      Offset MixPingPongLoop, PreMix12Central16BitI, MFS16Bit, MBS16Bit, Mix12Central16BitI
