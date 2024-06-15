;
; Pattern edit view functions
;

;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД

Proc    Draw_3Note Near         ; Given AL = note.

        Cmp     AL, NONOTE
        JB      Draw_3Note2

        Mov     CL, AL
        Mov     AL, 173                         ; '.'
        JE      Draw_3Note1

        Mov     AL, '^'
        Cmp     CL, 0FEh
        JE      Draw_3Note1

        Mov     AL, 'Н'
        Cmp     CL, 0FFh
        JE      Draw_3Note1

        Mov     AL, '!'

Draw_3Note1:
        Mov     AH, CH
        StosW
        StosW
        StosW

        Ret

Draw_3Note2:
        Push    SI

        AAM     12                      ; AH = octave, AL = note
        Mov     CL, AH
        And     AX, 0FFh
        LEA     SI, [EBX+EAX*2]

        Mov     AH, CH
        SegCS   LodsB
        StosW
        SegCS   LodsB
        StosW
        Mov     AL, CL
        Add     AL, 30h
        StosW

        Pop     SI

        Ret

EndP    Draw_3Note

;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД

Proc    Draw_2Note Near         ; Given AL = note.

        Cmp     AL, NONOTE
        JB      Draw_2Note2

        Mov     DL, AL
        Mov     AL, 173                         ; '.'
        JE      Draw_2Note1

        Mov     AL, '^'
        Cmp     DL, 0FEh
        JE      Draw_2Note1

        Mov     AL, 'Н'
        Cmp     DL, 0FFh
        JE      Draw_2Note1

        Mov     AL, '!'

Draw_2Note1:
        Mov     AH, CH
        StosW
        StosW

        Ret

Draw_2Note2:
        Push    SI

        AAM     12                      ; AH = octave, AL = note
        Mov     CL, AH
        And     AX, 0FFh
        LEA     SI, [EBX+EAX*2]

        SegCS   LodsW
        Cmp     AH, '-'
        JNE     Draw_2Note3

        Add     AL, 'a'-'A'

Draw_2Note3:
        Mov     AH, CH
        StosW
        Mov     AL, CL
        Add     AL, 30h
        StosW

        Pop     SI

        Ret

EndP    Draw_2Note

;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД

Proc    Draw_2Instrument

        Test    AL, AL
        JNZ     Draw_2Instrument1

        Mov     AL, 173                         ; '.'
        Mov     AH, CH

        StosW
        StosW
        Ret

Draw_2Instrument1:
        AAM     10
        Add     AX, '00'

        Mov     CL, AL
        Mov     AL, AH
        Mov     AH, CH
        StosW
        Mov     AL, CL
        StosW

        Ret

EndP    Draw_2Instrument

