
        DW      Offset UpdateNoLoop, 0, 0, 0, 0         ; Update only
        DW      Offset UpdateForwardsLoop, 0, 0, 0, 0
        DW      Offset UpdatePingPongLoop, 0, 0, 0, 0
                                                        ; Left only
        DW      Offset MixNoLoop, PreMix12Left8BitI, MFS8Bit, MBS8Bit, Mix12Single8BitI
        DW      Offset MixForwardsLoop, PreMix12Left8BitI, MFS8Bit, MBS8Bit, Mix12Single8BitI
        DW      Offset MixPingPongLoop, PreMix12Left8BitI, MFS8Bit, MBS8Bit, Mix12Single8BitI
                                                        ; Right only
        DW      Offset MixNoLoop, PreMix12Right8BitI, MFS8Bit, MBS8Bit, Mix12Single8BitI
        DW      Offset MixForwardsLoop, PreMix12Right8BitI, MFS8Bit, MBS8Bit, Mix12Single8BitI
        DW      Offset MixPingPongLoop, PreMix12Right8BitI, MFS8Bit, MBS8Bit, Mix12Single8BitI
                                                        ; Central
        DW      Offset MixNoLoop, PreMix12Central8BitI, MFS8Bit, MBS8Bit, Mix12Central8BitI
        DW      Offset MixForwardsLoop, PreMix12Central8BitI, MFS8Bit, MBS8Bit, Mix12Central8BitI
        DW      Offset MixPingPongLoop, PreMix12Central8BitI, MFS8Bit, MBS8Bit, Mix12Central8BitI
                                                        ; Stereo
        DW      Offset MixNoLoop, PreMix12Panned8BitI, MFS8Bit, MBS8Bit, Mix12Panned8BitI
        DW      Offset MixForwardsLoop, PreMix12Panned8BitI, MFS8Bit, MBS8Bit, Mix12Panned8BitI
        DW      Offset MixPingPongLoop, PreMix12Panned8BitI, MFS8Bit, MBS8Bit, Mix12Panned8BitI
                                                        ; Surround
        DW      Offset MixNoLoop, PreMix12Surround8BitI, MFS8Bit, MBS8Bit, Mix12Surround8BitI
        DW      Offset MixForwardsLoop, PreMix12Surround8BitI, MFS8Bit, MBS8Bit, Mix12Surround8BitI
        DW      Offset MixPingPongLoop, PreMix12Surround8BitI, MFS8Bit, MBS8Bit, Mix12Surround8BitI

        ; 16 bit tables
        DW      Offset UpdateNoLoop, 0, 0, 0, 0         ; Update only
        DW      Offset UpdateForwardsLoop, 0, 0, 0, 0
        DW      Offset UpdatePingPongLoop, 0, 0, 0, 0
                                                        ; Left only
        DW      Offset MixNoLoop, PreMix12Left16BitI, MFS16Bit, MBS16Bit, Mix12Single16BitI
        DW      Offset MixForwardsLoop, PreMix12Left16BitI, MFS16Bit, MBS16Bit, Mix12Single16BitI
        DW      Offset MixPingPongLoop, PreMix12Left16BitI, MFS16Bit, MBS16Bit, Mix12Single16BitI
                                                        ; Right only
        DW      Offset MixNoLoop, PreMix12Right16BitI, MFS16Bit, MBS16Bit, Mix12Single16BitI
        DW      Offset MixForwardsLoop, PreMix12Right16BitI, MFS16Bit, MBS16Bit, Mix12Single16BitI
        DW      Offset MixPingPongLoop, PreMix12Right16BitI, MFS16Bit, MBS16Bit, Mix12Single16BitI
                                                        ; Central
        DW      Offset MixNoLoop, PreMix12Central16BitI, MFS16Bit, MBS16Bit, Mix12Central16BitI
        DW      Offset MixForwardsLoop, PreMix12Central16BitI, MFS16Bit, MBS16Bit, Mix12Central16BitI
        DW      Offset MixPingPongLoop, PreMix12Central16BitI, MFS16Bit, MBS16Bit, Mix12Central16BitI
                                                        ; Stereo
        DW      Offset MixNoLoop, PreMix12Panned16BitI, MFS16Bit, MBS16Bit, Mix12Panned16BitI
        DW      Offset MixForwardsLoop, PreMix12Panned16BitI, MFS16Bit, MBS16Bit, Mix12Panned16BitI
        DW      Offset MixPingPongLoop, PreMix12Panned16BitI, MFS16Bit, MBS16Bit, Mix12Panned16BitI
                                                        ; Surround
        DW      Offset MixNoLoop, PreMix12Surround16BitI, MFS16Bit, MBS16Bit, Mix12Surround16BitI
        DW      Offset MixForwardsLoop, PreMix12Surround16BitI, MFS16Bit, MBS16Bit, Mix12Surround16BitI
        DW      Offset MixPingPongLoop, PreMix12Surround16BitI, MFS16Bit, MBS16Bit, Mix12Surround16BitI
