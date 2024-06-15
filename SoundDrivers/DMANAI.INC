
DMAData                 Label   Byte
; Port/Mask, Port/Clear, Port/DMAMode, Address, Page, Count, Port/Mask
        DB    0Ah, 4, 0Ch, 0, 0Bh, 08h, 87h, 0, 1, 0Ah, 0
        DB    0Ah, 5, 0Ch, 0, 0Bh, 09h, 83h, 2, 3, 0Ah, 1
        DB    0Ah, 6, 0Ch, 0, 0Bh, 0Ah, 81h, 4, 5, 0Ah, 2
        DB    0Ah, 7, 0Ch, 0, 0Bh, 0Bh, 82h, 6, 7, 0Ah, 3
        DB  0D4h, 4, 0D8h, 0, 0D6h, 08h, 8Fh, 0C0h, 0C2h, 0D4h, 0
        DB  0D4h, 5, 0D8h, 0, 0D6h, 09h, 8Bh, 0C4h, 0C6h, 0D4h, 1
        DB  0D4h, 6, 0D8h, 0, 0D6h, 0Ah, 89h, 0C8h, 0CAh, 0D4h, 2
        DB  0D4h, 7, 0D8h, 0, 0D6h, 0Bh, 8Ah, 0CCh, 0CEh, 0D4h, 3

ActualDMAPtr            Label   DWord
ActualDMAOffset         DW      0
ActualDMASegment        DW      0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SetDMA                  ; BX:AX points to DMA buffer
                                        ; DL = DMA Channel
                                        ; DI = DMA Size
                PushA
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     ActualDMASegment, BX
                Mov     ActualDMAOffset, AX

                Mov     CH, BH
                ShR     CH, 4
                ShL     BX, 4
                Add     BX, AX
                AdC     CH, 0
                Mov     SI, BX          ; CH:BH:BL contains 24 bit DMA address
                Neg     SI
                Cmp     SI, DI
                JA      SetDMA1

                Add     ActualDMAOffset, SI
                Add     BX, SI
                AdC     CH, 0

SetDMA1:
                Cmp     DL, 3
                JBE     SetDMA2

                ShR     DI, 1
                Push    CX
                ShR     CH, 1
                Pop     CX
                RCR     BX, 1

SetDMA2:
                Mov     AL, 11
                Mul     DL
                Mov     SI, AX
                Add     SI, Offset DMAData

                Xor     DX, DX

                LodsB                           ; Set mask
                Mov     DL, AL
                LodsB
                Out     DX, AL

                LodsB                           ; Clear Ptrs
                Mov     DL, AL
                LodsB
                Out     DX, AL

                LodsB                           ; Set Mode
                Mov     DL, AL
                LodsB
                Out     DX, AL

                LodsB
                Mov     DL, AL                  ; DL = page port
                Mov     AL, CH
                Out     DX, AL

                LodsB
                Mov     DL, AL                  ; DL = address port
                Mov     AL, BL
                Out     DX, AL
                Mov     AL, BH
                Out     DX, AL

                LodsB
                Mov     DL, AL                  ; DL = count port
                Mov     AX, DI
                Dec     AX
                Out     DX, AL
                Mov     AL, AH
                Out     DX, AL

                LodsB                           ; Reset mask
                Mov     DL, AL
                LodsB
                Out     DX, AL

                Pop     DS
                PopA

                Ret

EndP            SetDMA
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

