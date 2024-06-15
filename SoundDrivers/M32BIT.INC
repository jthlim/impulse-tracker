
        DW      Offset UpdateNoLoop, 0, 0, 0, 0         ; Update only
        DW      Offset UpdateForwardsLoop, 0, 0, 0, 0
        DW      Offset UpdatePingPongLoop, 0, 0, 0, 0
                                                        ; Left only
        DW      Offset MixNoLoop, PreMix32Left8Bit, MFS8Bit, MBS8Bit, Mix32Single8Bit
        DW      Offset MixForwardsLoop, PreMix32Left8Bit, MFS8Bit, MBS8Bit, Mix32Single8Bit
        DW      Offset MixPingPongLoop, PreMix32Left8Bit, MFS8Bit, MBS8Bit, Mix32Single8Bit
                                                        ; Right only
        DW      Offset MixNoLoop, PreMix32Right8Bit, MFS8Bit, MBS8Bit, Mix32Single8Bit
        DW      Offset MixForwardsLoop, PreMix32Right8Bit, MFS8Bit, MBS8Bit, Mix32Single8Bit
        DW      Offset MixPingPongLoop, PreMix32Right8Bit, MFS8Bit, MBS8Bit, Mix32Single8Bit
                                                        ; Central
        DW      Offset MixNoLoop, PreMix32Central8Bit, MFS8Bit, MBS8Bit, Mix32Central8Bit
        DW      Offset MixForwardsLoop, PreMix32Central8Bit, MFS8Bit, MBS8Bit, Mix32Central8Bit
        DW      Offset MixPingPongLoop, PreMix32Central8Bit, MFS8Bit, MBS8Bit, Mix32Central8Bit
                                                        ; Stereo
        DW      Offset MixNoLoop, PreMix32Panned8Bit, MFS8Bit, MBS8Bit, Mix32Panned8Bit
        DW      Offset MixForwardsLoop, PreMix32Panned8Bit, MFS8Bit, MBS8Bit, Mix32Panned8Bit
        DW      Offset MixPingPongLoop, PreMix32Panned8Bit, MFS8Bit, MBS8Bit, Mix32Panned8Bit
                                                        ; Surround
        DW      Offset MixNoLoop, PreMix32Surround8Bit, MFS8Bit, MBS8Bit, Mix32Surround8Bit
        DW      Offset MixForwardsLoop, PreMix32Surround8Bit, MFS8Bit, MBS8Bit, Mix32Surround8Bit
        DW      Offset MixPingPongLoop, PreMix32Surround8Bit, MFS8Bit, MBS8Bit, Mix32Surround8Bit

        ; 16 bit tables
        DW      Offset UpdateNoLoop, 0, 0, 0, 0         ; Update only
        DW      Offset UpdateForwardsLoop, 0, 0, 0, 0
        DW      Offset UpdatePingPongLoop, 0, 0, 0, 0
                                                        ; Left only
        DW      Offset MixNoLoop, PreMix32Left16Bit, MFS16Bit, MBS16Bit, Mix32Single16Bit
        DW      Offset MixForwardsLoop, PreMix32Left16Bit, MFS16Bit, MBS16Bit, Mix32Single16Bit
        DW      Offset MixPingPongLoop, PreMix32Left16Bit, MFS16Bit, MBS16Bit, Mix32Single16Bit
                                                        ; Right only
        DW      Offset MixNoLoop, PreMix32Right16Bit, MFS16Bit, MBS16Bit, Mix32Single16Bit
        DW      Offset MixForwardsLoop, PreMix32Right16Bit, MFS16Bit, MBS16Bit, Mix32Single16Bit
        DW      Offset MixPingPongLoop, PreMix32Right16Bit, MFS16Bit, MBS16Bit, Mix32Single16Bit
                                                        ; Central
        DW      Offset MixNoLoop, PreMix32Central16Bit, MFS16Bit, MBS16Bit, Mix32Central16Bit
        DW      Offset MixForwardsLoop, PreMix32Central16Bit, MFS16Bit, MBS16Bit, Mix32Central16Bit
        DW      Offset MixPingPongLoop, PreMix32Central16Bit, MFS16Bit, MBS16Bit, Mix32Central16Bit
                                                        ; Stereo
        DW      Offset MixNoLoop, PreMix32Panned16Bit, MFS16Bit, MBS16Bit, Mix32Panned16Bit
        DW      Offset MixForwardsLoop, PreMix32Panned16Bit, MFS16Bit, MBS16Bit, Mix32Panned16Bit
        DW      Offset MixPingPongLoop, PreMix32Panned16Bit, MFS16Bit, MBS16Bit, Mix32Panned16Bit
                                                        ; Surround
        DW      Offset MixNoLoop, PreMix32Surround16Bit, MFS16Bit, MBS16Bit, Mix32Surround16Bit
        DW      Offset MixForwardsLoop, PreMix32Surround16Bit, MFS16Bit, MBS16Bit, Mix32Surround16Bit
        DW      Offset MixPingPongLoop, PreMix32Surround16Bit, MFS16Bit, MBS16Bit, Mix32Surround16Bit
