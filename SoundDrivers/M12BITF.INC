
        DW      Offset UpdateNoLoop, 0, 0, 0, 0         ; Update only
        DW      Offset UpdateForwardsLoop, 0, 0, 0, 0
        DW      Offset UpdatePingPongLoop, 0, 0, 0, 0
                                                        ; Left only
        DW      Offset MixNoLoop, PreMix12Left8BitF, MFS8Bit, MBS8Bit, Mix12Single8BitF
        DW      Offset MixForwardsLoop, PreMix12Left8BitF, MFS8Bit, MBS8Bit, Mix12Single8BitF
        DW      Offset MixPingPongLoop, PreMix12Left8BitF, MFS8Bit, MBS8Bit, Mix12Single8BitF
                                                        ; Right only
        DW      Offset MixNoLoop, PreMix12Right8BitF, MFS8Bit, MBS8Bit, Mix12Single8BitF
        DW      Offset MixForwardsLoop, PreMix12Right8BitF, MFS8Bit, MBS8Bit, Mix12Single8BitF
        DW      Offset MixPingPongLoop, PreMix12Right8BitF, MFS8Bit, MBS8Bit, Mix12Single8BitF
                                                        ; Central
        DW      Offset MixNoLoop, PreMix12Central8BitF, MFS8Bit, MBS8Bit, Mix12Central8BitF
        DW      Offset MixForwardsLoop, PreMix12Central8BitF, MFS8Bit, MBS8Bit, Mix12Central8BitF
        DW      Offset MixPingPongLoop, PreMix12Central8BitF, MFS8Bit, MBS8Bit, Mix12Central8BitF
                                                        ; Stereo
        DW      Offset MixNoLoop, PreMix12Panned8BitF, MFS8Bit, MBS8Bit, Mix12Panned8BitF
        DW      Offset MixForwardsLoop, PreMix12Panned8BitF, MFS8Bit, MBS8Bit, Mix12Panned8BitF
        DW      Offset MixPingPongLoop, PreMix12Panned8BitF, MFS8Bit, MBS8Bit, Mix12Panned8BitF
                                                        ; Surround
        DW      Offset MixNoLoop, PreMix12Surround8BitF, MFS8Bit, MBS8Bit, Mix12Surround8BitF
        DW      Offset MixForwardsLoop, PreMix12Surround8BitF, MFS8Bit, MBS8Bit, Mix12Surround8BitF
        DW      Offset MixPingPongLoop, PreMix12Surround8BitF, MFS8Bit, MBS8Bit, Mix12Surround8BitF

        ; 16 bit tables
        DW      Offset UpdateNoLoop, 0, 0, 0, 0         ; Update only
        DW      Offset UpdateForwardsLoop, 0, 0, 0, 0
        DW      Offset UpdatePingPongLoop, 0, 0, 0, 0
                                                        ; Left only
        DW      Offset MixNoLoop, PreMix12Left16BitF, MFS16Bit, MBS16Bit, Mix12Single16BitF
        DW      Offset MixForwardsLoop, PreMix12Left16BitF, MFS16Bit, MBS16Bit, Mix12Single16BitF
        DW      Offset MixPingPongLoop, PreMix12Left16BitF, MFS16Bit, MBS16Bit, Mix12Single16BitF
                                                        ; Right only
        DW      Offset MixNoLoop, PreMix12Right16BitF, MFS16Bit, MBS16Bit, Mix12Single16BitF
        DW      Offset MixForwardsLoop, PreMix12Right16BitF, MFS16Bit, MBS16Bit, Mix12Single16BitF
        DW      Offset MixPingPongLoop, PreMix12Right16BitF, MFS16Bit, MBS16Bit, Mix12Single16BitF
                                                        ; Central
        DW      Offset MixNoLoop, PreMix12Central16BitF, MFS16Bit, MBS16Bit, Mix12Central16BitF
        DW      Offset MixForwardsLoop, PreMix12Central16BitF, MFS16Bit, MBS16Bit, Mix12Central16BitF
        DW      Offset MixPingPongLoop, PreMix12Central16BitF, MFS16Bit, MBS16Bit, Mix12Central16BitF
                                                        ; Stereo
        DW      Offset MixNoLoop, PreMix12Panned16BitF, MFS16Bit, MBS16Bit, Mix12Panned16BitF
        DW      Offset MixForwardsLoop, PreMix12Panned16BitF, MFS16Bit, MBS16Bit, Mix12Panned16BitF
        DW      Offset MixPingPongLoop, PreMix12Panned16BitF, MFS16Bit, MBS16Bit, Mix12Panned16BitF
                                                        ; Surround
        DW      Offset MixNoLoop, PreMix12Surround16BitF, MFS16Bit, MBS16Bit, Mix12Surround16BitF
        DW      Offset MixForwardsLoop, PreMix12Surround16BitF, MFS16Bit, MBS16Bit, Mix12Surround16BitF
        DW      Offset MixPingPongLoop, PreMix12Surround16BitF, MFS16Bit, MBS16Bit, Mix12Surround16BitF
