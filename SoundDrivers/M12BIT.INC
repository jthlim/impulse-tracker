
        DW      Offset UpdateNoLoop, 0, 0, 0, 0         ; Update only
        DW      Offset UpdateForwardsLoop, 0, 0, 0, 0
        DW      Offset UpdatePingPongLoop, 0, 0, 0, 0
                                                        ; Left only
        DW      Offset MixNoLoop, PreMix12Left8Bit, MFS8Bit, MBS8Bit, Mix12Single8Bit
        DW      Offset MixForwardsLoop, PreMix12Left8Bit, MFS8Bit, MBS8Bit, Mix12Single8Bit
        DW      Offset MixPingPongLoop, PreMix12Left8Bit, MFS8Bit, MBS8Bit, Mix12Single8Bit
                                                        ; Right only
        DW      Offset MixNoLoop, PreMix12Right8Bit, MFS8Bit, MBS8Bit, Mix12Single8Bit
        DW      Offset MixForwardsLoop, PreMix12Right8Bit, MFS8Bit, MBS8Bit, Mix12Single8Bit
        DW      Offset MixPingPongLoop, PreMix12Right8Bit, MFS8Bit, MBS8Bit, Mix12Single8Bit
                                                        ; Central
        DW      Offset MixNoLoop, PreMix12Central8Bit, MFS8Bit, MBS8Bit, Mix12Central8Bit
        DW      Offset MixForwardsLoop, PreMix12Central8Bit, MFS8Bit, MBS8Bit, Mix12Central8Bit
        DW      Offset MixPingPongLoop, PreMix12Central8Bit, MFS8Bit, MBS8Bit, Mix12Central8Bit
                                                        ; Stereo
        DW      Offset MixNoLoop, PreMix12Panned8Bit, MFS8Bit, MBS8Bit, Mix12Panned8Bit
        DW      Offset MixForwardsLoop, PreMix12Panned8Bit, MFS8Bit, MBS8Bit, Mix12Panned8Bit
        DW      Offset MixPingPongLoop, PreMix12Panned8Bit, MFS8Bit, MBS8Bit, Mix12Panned8Bit
                                                        ; Surround
        DW      Offset MixNoLoop, PreMix12Surround8Bit, MFS8Bit, MBS8Bit, Mix12Surround8Bit
        DW      Offset MixForwardsLoop, PreMix12Surround8Bit, MFS8Bit, MBS8Bit, Mix12Surround8Bit
        DW      Offset MixPingPongLoop, PreMix12Surround8Bit, MFS8Bit, MBS8Bit, Mix12Surround8Bit

        ; 16 bit tables
        DW      Offset UpdateNoLoop, 0, 0, 0, 0         ; Update only
        DW      Offset UpdateForwardsLoop, 0, 0, 0, 0
        DW      Offset UpdatePingPongLoop, 0, 0, 0, 0
                                                        ; Left only
        DW      Offset MixNoLoop, PreMix12Left16Bit, MFS16Bit, MBS16Bit, Mix12Single16Bit
        DW      Offset MixForwardsLoop, PreMix12Left16Bit, MFS16Bit, MBS16Bit, Mix12Single16Bit
        DW      Offset MixPingPongLoop, PreMix12Left16Bit, MFS16Bit, MBS16Bit, Mix12Single16Bit
                                                        ; Right only
        DW      Offset MixNoLoop, PreMix12Right16Bit, MFS16Bit, MBS16Bit, Mix12Single16Bit
        DW      Offset MixForwardsLoop, PreMix12Right16Bit, MFS16Bit, MBS16Bit, Mix12Single16Bit
        DW      Offset MixPingPongLoop, PreMix12Right16Bit, MFS16Bit, MBS16Bit, Mix12Single16Bit
                                                        ; Central
        DW      Offset MixNoLoop, PreMix12Central16Bit, MFS16Bit, MBS16Bit, Mix12Central16Bit
        DW      Offset MixForwardsLoop, PreMix12Central16Bit, MFS16Bit, MBS16Bit, Mix12Central16Bit
        DW      Offset MixPingPongLoop, PreMix12Central16Bit, MFS16Bit, MBS16Bit, Mix12Central16Bit
                                                        ; Stereo
        DW      Offset MixNoLoop, PreMix12Panned16Bit, MFS16Bit, MBS16Bit, Mix12Panned16Bit
        DW      Offset MixForwardsLoop, PreMix12Panned16Bit, MFS16Bit, MBS16Bit, Mix12Panned16Bit
        DW      Offset MixPingPongLoop, PreMix12Panned16Bit, MFS16Bit, MBS16Bit, Mix12Panned16Bit
                                                        ; Surround
        DW      Offset MixNoLoop, PreMix12Surround16Bit, MFS16Bit, MBS16Bit, Mix12Surround16Bit
        DW      Offset MixForwardsLoop, PreMix12Surround16Bit, MFS16Bit, MBS16Bit, Mix12Surround16Bit
        DW      Offset MixPingPongLoop, PreMix12Surround16Bit, MFS16Bit, MBS16Bit, Mix12Surround16Bit
