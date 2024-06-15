
FourierBufferStart              DW      0

FourierBufferInputStart         DW      0
FourierBufferInputFractional    DW      0
FourierBufferStepOffset         DW      1
FourierBufferStepFractional     DW      0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc    UpdateFourierBuffer

        PushAD
        Push    DS
        Push    ES

        Push    CS
        Pop     DS
                Assume DS:Driver

        Xor     EBX, EBX
        Xor     ESI, ESI

        Mov     BX, MixTransferOffset
        Mov     DI, FourierBufferStart
        ShR     BX, 3
        Mov     CX, BytesToMix
        Mov     SI, FourierBufferInputStart
        Add     SI, BX
        Add     CX, BX

        Mov     BP, FourierBufferInputFractional
        Mov     DX, FourierBufferStepOffset
        Mov     BX, FourierBufferStepFractional

        Mov     ES, FourierSegment
        Mov     DS, MixSegment

                Assume DS:Nothing

UpdateFourierBuffer1:
        Mov     EAX, [ESI*8]
        Add     EAX, [ESI*8+4]
        SAR     EAX, 13
        Cmp     EAX, 7FFFh
        JG      UpdateFourierBuffer3
        Cmp     EAX, -8000h
        JL      UpdateFourierBuffer4

UpdateFourierBuffer2:
        StosW

        Add     BP, BX
        AdC     SI, DX
        And     DI, (FOURIERBUFFERLENGTH*2)-1

; Cmp past end of buffer?
        Cmp     SI, CX
        JB      UpdateFourierBuffer1

        Sub     SI, CX
        Mov     FourierBufferStart, DI
        Mov     FourierBufferInputFractional, BP
        Mov     FourierBufferInputStart, SI

        Pop     ES
        Pop     DS
        PopAD

        Ret

UpdateFourierBuffer3:
        Mov     AX, 7FFFh
        Jmp     UpdateFourierBuffer2

UpdateFourierBuffer4:
        Mov     AX, 8000h
        Jmp     UpdateFourierBuffer2

EndP    UpdateFourierBuffer

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

