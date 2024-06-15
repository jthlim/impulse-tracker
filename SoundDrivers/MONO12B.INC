
        DW      Offset UpdateNoLoop, 0, 0, 0, 0         ; Update only
        DW      Offset UpdateForwardsLoop, 0, 0, 0, 0
        DW      Offset UpdatePingPongLoop, 0, 0, 0, 0
                                                        ; Central
        DW      Offset MixNoLoop, PreMix12Central8Bit, MFS8Bit, MBS8Bit, Mix12Central8Bit
        DW      Offset MixForwardsLoop, PreMix12Central8Bit, MFS8Bit, MBS8Bit, Mix12Central8Bit
        DW      Offset MixPingPongLoop, PreMix12Central8Bit, MFS8Bit, MBS8Bit, Mix12Central8Bit

        ; 16 bit tables
        DW      Offset UpdateNoLoop, 0, 0, 0, 0         ; Update only
        DW      Offset UpdateForwardsLoop, 0, 0, 0, 0
        DW      Offset UpdatePingPongLoop, 0, 0, 0, 0
                                                        ; Central
        DW      Offset MixNoLoop, PreMix12Central16Bit, MFS16Bit, MBS16Bit, Mix12Central16Bit
        DW      Offset MixForwardsLoop, PreMix12Central16Bit, MFS16Bit, MBS16Bit, Mix12Central16Bit
        DW      Offset MixPingPongLoop, PreMix12Central16Bit, MFS16Bit, MBS16Bit, Mix12Central16Bit
