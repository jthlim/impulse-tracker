
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
                MovD    MM1, [SI+8]
                MovD    MM2, [SI+10h]
                MovD    MM3, [SI+18h]
                MovD    MM4, [SI+20h]
                MovD    MM5, [SI+28h]
                MovD    MM6, [SI+30h]
                MovD    MM7, [SI+38h]

                PUnpckLDQ MM0, MM1      ; MM0 = S2|S1
                PUnpckLDQ MM2, MM3      ; MM2 = S4|S3
                PUnpckLDQ MM4, MM5      ; MM4 = S6|S5
                PUnpckLDQ MM6, MM7      ; MM6 = S8|S7

                PF2ID   MM0, MM0
                PF2ID   MM2, MM2
                PF2ID   MM4, MM4
                PF2ID   MM6, MM6


                PackSSDW MM0, MM2
                PackSSDW MM4, MM6

                MovQ    [DI], MM0
                MovQ    [DI+8], MM4

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
                PF2ID   MM0, MM0
                MovD    EAX, MM0
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
                MovQ    MM0, [SI]
                MovQ    MM1, [SI+8]
                MovQ    MM2, [SI+10h]
                MovQ    MM3, [SI+18h]

                PF2ID   MM0, MM0
                PF2ID   MM1, MM1
                PF2ID   MM2, MM2
                PF2ID   MM3, MM3

                PackSSDW MM0, MM1
                PackSSDW MM2, MM3

                MovQ    [DI], MM0
                MovQ    [DI+8], MM2

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
                MovQ    MM0, [SI]
                PF2ID   MM0, MM0
                PackSSDW MM0, MM0
                MovD    [DI], MM0

                Add     SI, 8
                Add     DI, 4

                Loop    TransferStereoBufferMMX3

TransferStereoBufferMMX4:

MMXMixTransferEnd:
                Pop     DX

