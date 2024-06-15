
        DW      Offset UpdateNoLoop, 0, 0, 0, 0         ; Update only
        DW      Offset UpdateForwardsLoop, 0, 0, 0, 0
        DW      Offset UpdatePingPongLoop, 0, 0, 0, 0
                                                        ; Left only
        DW      Offset MixNoLoop, PreMixUltraLeft8BitI, MFS8Bit, MBS8Bit, MixUltraSingle8BitI
        DW      Offset MixForwardsLoop, PreMixUltraLeft8BitI, MFS8Bit, MBS8Bit, MixUltraSingle8BitI
        DW      Offset MixPingPongLoop, PreMixUltraLeft8BitI, MFS8Bit, MBS8Bit, MixUltraSingle8BitI
                                                        ; Right only
        DW      Offset MixNoLoop, PreMixUltraRight8BitI, MFS8Bit, MBS8Bit, MixUltraSingle8BitI
        DW      Offset MixForwardsLoop, PreMixUltraRight8BitI, MFS8Bit, MBS8Bit, MixUltraSingle8BitI
        DW      Offset MixPingPongLoop, PreMixUltraRight8BitI, MFS8Bit, MBS8Bit, MixUltraSingle8BitI
                                                        ; Central
        DW      Offset MixNoLoop, PreMixUltraCentral8BitI, MFS8Bit, MBS8Bit, MixUltraCentral8BitI
        DW      Offset MixForwardsLoop, PreMixUltraCentral8BitI, MFS8Bit, MBS8Bit, MixUltraCentral8BitI
        DW      Offset MixPingPongLoop, PreMixUltraCentral8BitI, MFS8Bit, MBS8Bit, MixUltraCentral8BitI
                                                        ; Stereo
        DW      Offset MixNoLoop, PreMixUltraPanned8BitI, MFS8Bit, MBS8Bit, MixUltraPanned8BitI
        DW      Offset MixForwardsLoop, PreMixUltraPanned8BitI, MFS8Bit, MBS8Bit, MixUltraPanned8BitI
        DW      Offset MixPingPongLoop, PreMixUltraPanned8BitI, MFS8Bit, MBS8Bit, MixUltraPanned8BitI
                                                        ; Surround
        DW      Offset MixNoLoop, PreMixUltraSurround8BitI, MFS8Bit, MBS8Bit, MixUltraSurround8BitI
        DW      Offset MixForwardsLoop, PreMixUltraSurround8BitI, MFS8Bit, MBS8Bit, MixUltraSurround8BitI
        DW      Offset MixPingPongLoop, PreMixUltraSurround8BitI, MFS8Bit, MBS8Bit, MixUltraSurround8BitI

        ; 16 bit tables
        DW      Offset UpdateNoLoop, 0, 0, 0, 0         ; Update only
        DW      Offset UpdateForwardsLoop, 0, 0, 0, 0
        DW      Offset UpdatePingPongLoop, 0, 0, 0, 0
                                                        ; Left only
        DW      Offset MixNoLoop, PreMixUltraLeft16BitI, MFS16Bit, MBS16Bit, MixUltraSingle16BitI
        DW      Offset MixForwardsLoop, PreMixUltraLeft16BitI, MFS16Bit, MBS16Bit, MixUltraSingle16BitI
        DW      Offset MixPingPongLoop, PreMixUltraLeft16BitI, MFS16Bit, MBS16Bit, MixUltraSingle16BitI
                                                        ; Right only
        DW      Offset MixNoLoop, PreMixUltraRight16BitI, MFS16Bit, MBS16Bit, MixUltraSingle16BitI
        DW      Offset MixForwardsLoop, PreMixUltraRight16BitI, MFS16Bit, MBS16Bit, MixUltraSingle16BitI
        DW      Offset MixPingPongLoop, PreMixUltraRight16BitI, MFS16Bit, MBS16Bit, MixUltraSingle16BitI
                                                        ; Central
        DW      Offset MixNoLoop, PreMixUltraCentral16BitI, MFS16Bit, MBS16Bit, MixUltraCentral16BitI
        DW      Offset MixForwardsLoop, PreMixUltraCentral16BitI, MFS16Bit, MBS16Bit, MixUltraCentral16BitI
        DW      Offset MixPingPongLoop, PreMixUltraCentral16BitI, MFS16Bit, MBS16Bit, MixUltraCentral16BitI
                                                        ; Stereo
        DW      Offset MixNoLoop, PreMixUltraPanned16BitI, MFS16Bit, MBS16Bit, MixUltraPanned16BitI
        DW      Offset MixForwardsLoop, PreMixUltraPanned16BitI, MFS16Bit, MBS16Bit, MixUltraPanned16BitI
        DW      Offset MixPingPongLoop, PreMixUltraPanned16BitI, MFS16Bit, MBS16Bit, MixUltraPanned16BitI
                                                        ; Surround
        DW      Offset MixNoLoop, PreMixUltraSurround16BitI, MFS16Bit, MBS16Bit, MixUltraSurround16BitI
        DW      Offset MixForwardsLoop, PreMixUltraSurround16BitI, MFS16Bit, MBS16Bit, MixUltraSurround16BitI
        DW      Offset MixPingPongLoop, PreMixUltraSurround16BitI, MFS16Bit, MBS16Bit, MixUltraSurround16BitI
