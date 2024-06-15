
        DW      Offset UpdateNoLoop, 0, 0, 0, 0         ; Update only
        DW      Offset UpdateForwardsLoop, 0, 0, 0, 0
        DW      Offset UpdatePingPongLoop, 0, 0, 0, 0
                                                        ; Left only
        DW      Offset MixNoLoop, PreMix32Left8BitI, MFS8Bit, MBS8Bit, Mix32Single8BitI
        DW      Offset MixForwardsLoop, PreMix32Left8BitI, MFS8Bit, MBS8Bit, Mix32Single8BitI
        DW      Offset MixPingPongLoop, PreMix32Left8BitI, MFS8Bit, MBS8Bit, Mix32Single8BitI
                                                        ; Right only
        DW      Offset MixNoLoop, PreMix32Right8BitI, MFS8Bit, MBS8Bit, Mix32Single8BitI
        DW      Offset MixForwardsLoop, PreMix32Right8BitI, MFS8Bit, MBS8Bit, Mix32Single8BitI
        DW      Offset MixPingPongLoop, PreMix32Right8BitI, MFS8Bit, MBS8Bit, Mix32Single8BitI
                                                        ; Central
        DW      Offset MixNoLoop, PreMix32Central8BitI, MFS8Bit, MBS8Bit, Mix32Central8BitI
        DW      Offset MixForwardsLoop, PreMix32Central8BitI, MFS8Bit, MBS8Bit, Mix32Central8BitI
        DW      Offset MixPingPongLoop, PreMix32Central8BitI, MFS8Bit, MBS8Bit, Mix32Central8BitI
                                                        ; Stereo
        DW      Offset MixNoLoop, PreMix32Panned8BitI, MFS8Bit, MBS8Bit, Mix32Panned8BitI
        DW      Offset MixForwardsLoop, PreMix32Panned8BitI, MFS8Bit, MBS8Bit, Mix32Panned8BitI
        DW      Offset MixPingPongLoop, PreMix32Panned8BitI, MFS8Bit, MBS8Bit, Mix32Panned8BitI
                                                        ; Surround
        DW      Offset MixNoLoop, PreMix32Surround8BitI, MFS8Bit, MBS8Bit, Mix32Surround8BitI
        DW      Offset MixForwardsLoop, PreMix32Surround8BitI, MFS8Bit, MBS8Bit, Mix32Surround8BitI
        DW      Offset MixPingPongLoop, PreMix32Surround8BitI, MFS8Bit, MBS8Bit, Mix32Surround8BitI

        ; 16 bit tables
        DW      Offset UpdateNoLoop, 0, 0, 0, 0         ; Update only
        DW      Offset UpdateForwardsLoop, 0, 0, 0, 0
        DW      Offset UpdatePingPongLoop, 0, 0, 0, 0
                                                        ; Left only
        DW      Offset MixNoLoop, PreMix32Left16BitI, MFS16Bit, MBS16Bit, Mix32Single16BitI
        DW      Offset MixForwardsLoop, PreMix32Left16BitI, MFS16Bit, MBS16Bit, Mix32Single16BitI
        DW      Offset MixPingPongLoop, PreMix32Left16BitI, MFS16Bit, MBS16Bit, Mix32Single16BitI
                                                        ; Right only
        DW      Offset MixNoLoop, PreMix32Right16BitI, MFS16Bit, MBS16Bit, Mix32Single16BitI
        DW      Offset MixForwardsLoop, PreMix32Right16BitI, MFS16Bit, MBS16Bit, Mix32Single16BitI
        DW      Offset MixPingPongLoop, PreMix32Right16BitI, MFS16Bit, MBS16Bit, Mix32Single16BitI
                                                        ; Central
        DW      Offset MixNoLoop, PreMix32Central16BitI, MFS16Bit, MBS16Bit, Mix32Central16BitI
        DW      Offset MixForwardsLoop, PreMix32Central16BitI, MFS16Bit, MBS16Bit, Mix32Central16BitI
        DW      Offset MixPingPongLoop, PreMix32Central16BitI, MFS16Bit, MBS16Bit, Mix32Central16BitI
                                                        ; Stereo
        DW      Offset MixNoLoop, PreMix32Panned16BitI, MFS16Bit, MBS16Bit, Mix32Panned16BitI
        DW      Offset MixForwardsLoop, PreMix32Panned16BitI, MFS16Bit, MBS16Bit, Mix32Panned16BitI
        DW      Offset MixPingPongLoop, PreMix32Panned16BitI, MFS16Bit, MBS16Bit, Mix32Panned16BitI
                                                        ; Surround
        DW      Offset MixNoLoop, PreMix32Surround16BitI, MFS16Bit, MBS16Bit, Mix32Surround16BitI
        DW      Offset MixForwardsLoop, PreMix32Surround16BitI, MFS16Bit, MBS16Bit, Mix32Surround16BitI
        DW      Offset MixPingPongLoop, PreMix32Surround16BitI, MFS16Bit, MBS16Bit, Mix32Surround16BitI
