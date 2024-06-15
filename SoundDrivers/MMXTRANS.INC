
; To be embedded within the IRQ handler.

                Push    DX

                Cmp     CS:Stereo, 0
                JNE     TransferStereoBufferMMX

TransferMonoBufferMMX:          ; DX = number of 32 bit numbers -> 16 bit.

                Push    DX
                ShR     DX, 3
                JZ      TransferMonoBufferMMX2

TransferMonoBufferMMX1:
                MovD    MM0, [SI]
                MovD    MM4, [SI+8]
                MovD    MM1, [SI+10h]
                PUnpckLDQ MM0, MM4
                MovD    MM5, [SI+18h]
                PSRADI  MM0, 13
                MovD    MM2, [SI+20h]
                PUnpckLDQ MM1, MM5
                MovD    MM6, [SI+28h]
                PSRADI  MM1, 13
                MovD    MM3, [SI+30h]
                PUnpckLDQ MM2, MM6
                MovD    MM7, [SI+38h]
                PSRADI  MM2, 13

                PUnpckLDQ MM3, MM7
                PackSSDW MM0, MM1

                PSRADI  MM3, 13

                MovQM   [DI], MM0
                PackSSDW MM2, MM3

                MovQM   [DI+8], MM2

                Add     SI, 40h
                Add     DI, 10h

                Dec     DX
                JNZ     TransferMonoBufferMMX1

TransferMonoBufferMMX2:
                Pop     CX
                Mov     DX, CX

                And     CX, 7
                JZ      TransferMonoBufferMMX4

TransferMonoBufferMMX3:
                MovD    MM0, [SI]
                PSRADI  MM0, 13
                PackSSDW MM0, MM1
                MovDR   AX, MM0
                StosW
                Add     SI, 8

                Loop    TransferMonoBufferMMX3

TransferMonoBufferMMX4:
                Jmp     MMXMixTransferEnd

TransferStereoBufferMMX:       ; DX is always an even number for stereo
                Push    DX

                ShR     DX, 3
                JZ      TransferStereoBufferMMX2

TransferStereoBufferMMX1:        ; DX = number of 32 bit numbers -> 16 bit
                MovQ     MM0, [SI]
                MovQ     MM1, [SI+10h]
                PSRADI   MM0, 12
                MovQ     MM2, [SI+8]
                PSRADI   MM1, 12
                MovQ     MM3, [SI+18h]
                PSRADI   MM2, 12
                PackSSDW MM0, MM2
                PSRADI   MM3, 12
                MovQM   [DI], MM0
                PackSSDW MM1, MM3
                MovQM   [DI+8], MM1    ; 8 values done.

                Add     SI, 20h
                Add     DI, 10h

                Dec     DX
                JNZ     TransferStereoBufferMMX1

TransferStereoBufferMMX2:
                Pop     CX
                Mov     DX, CX

                And     CX, 7
                ShR     CX, 1           ; Always an even number!
                JZ      TransferStereoBufferMMX4

TransferStereoBufferMMX3:
                MovQ     MM0, [SI]
                PSRADI   MM0, 12
                PackSSDW MM0, MM1       ; Dummy register
                MovDM    [DI], MM0
                Add     SI, 8
                Add     DI, 4

                Dec     CX
                JNZ     TransferStereoBufferMMX3

TransferStereoBufferMMX4:

MMXMixTransferEnd:
                Pop     DX

