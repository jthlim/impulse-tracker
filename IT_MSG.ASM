;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Message Module                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                        .386
                        Jumps

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Externals                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                Extrn   M_FunctionDivider:Far
                Extrn   M_Object1List:Far
                Extrn   S_GetDestination:Far
                Extrn   O1_LongMessageList:Far
                Extrn   O1_ConfirmClearMessage:Far

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Globals                                                                     ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                Global  Msg_ResetMessage:Far
                Global  Msg_DrawMessage:Far
                Global  Msg_PreMessage:Far
                Global  Msg_PostMessage:Far
                Global  Msg_GetMessageLength:Far
                Global  Msg_GetMessageOffset:Far

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment                 Message BYTE Public 'Code' USE16
                        Assume CS:Message, DS:Nothing

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Variables                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MESSAGELENGTH           Equ     8000

TopLine                 DW      0
CurrentPosition         DW      0
MessageData             DB      MESSAGELENGTH Dup (0)
                        DW      0               ; Security
MessageDataTerminator   DB      0
Edit                    DB      0               ; if Edit=1, show '' for enter.
HorizontalPosition      DW      0
CurrentLine             DW      0
CharacterColour         DB      12

NoEditKeys              Label
                        DB      0
                        DW      1C8h            ; Up arrow
                        DW      Msg_ViewMsgUp

                        DB      0
                        DW      1D0h            ; Down arrow
                        DW      Msg_ViewMsgDown

                        DB      0
                        DW      1C9h
                        DW      Msg_ViewMsgPgUp

                        DB      0
                        DW      1D1h
                        DW      Msg_ViewMsgPgDn

                        DB      0
                        DW      11Ch
                        DW      Msg_ViewMsgEdit

                        DB      1
                        DW      'T'-'@' ; Ctrl 'T'
                        DW      Msg_ToggleCharacterSet

                        DB      0FFh            ; End of List

EditMsgKeys             Label
                        DB      0
                        DW      1C7h
                        DW      Msg_EditMsgHome

                        DB      0
                        DW      1CFh
                        DW      Msg_EditMsgEnd

                        DB      0
                        DW      1CBh
                        DW      Msg_EditMsgLeft

                        DB      0
                        DW      1CDh
                        DW      Msg_EditMsgRight

                        DB      0
                        DW      1C8h            ; Up arrow
                        DW      Msg_EditMsgUp

                        DB      0
                        DW      1D0h            ; Down arrow
                        DW      Msg_EditMsgDown

                        DB      0
                        DW      1C9h            ; PgUp
                        DW      Msg_EditMsgPgUp

                        DB      0
                        DW      1D1h            ; PgDn
                        DW      Msg_EditMsgPgDn

;                        DB      2
;                        DW      1C8h            ; Up arrow
;                        DW      Msg_ViewMsgUp
;
;                        DB      2
;                        DW      1D0h            ; Down arrow
;                        DW      Msg_ViewMsgDown

                        DB      0
                        DW      1D2h            ; Insert
                        DW      Msg_EditMsgInsert

                        DB      0
                        DW      10Fh
                        DW      Msg_Tab

                        DB      0
                        DW      1D3h            ; Delete
                        DW      Msg_EditMsgDelete

                        DB      0
                        DW      101h            ; Escape
                        DW      Msg_EditMsgView

                        DB      0
                        DW      10Eh            ; Backspace
                        DW      Msg_EditMsgBackSpace

                        DB      1
                        DW      19h
                        DW      Msg_EditMsgDeleteLine

                        DB      1
                        DW      2E00h            ; Alt 'C'
                        DW      Msg_ClearMessage

                        DB      1
                        DW      'T'-'@' ; Ctrl 'T'
                        DW      Msg_ToggleCharacterSet

                        DB      0FFh

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Functions                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_ResetMessage Far

                Push    CS
                Pop     ES
                Mov     DI, Offset MessageData
                Xor     AX, AX
                Mov     CX, 4000
                Rep     StosW

                Mov     CS:Edit, 0
                Mov     CS:TopLine, 0

                Ret

EndP            Msg_ResetMessage

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_DrawMessage Far

                Call    S_GetDestination

                Push    CS
                Pop     DS
                        Assume DS:Message

                Cmp     Edit, 0
                JE      Msg_DrawMessage7

                Mov     SI, Offset MessageData
                Mov     CX, CurrentPosition
                Xor     DX, DX                  ; DX = line count.
                Xor     BX, BX                  ; BX = cursor position.
                JCXZ    Msg_DrawMessage4

Msg_DrawMessage1:
                LodsB
                Test    AL, AL
                JZ      Msg_DrawMessage4

                Inc     BX

                Cmp     AL, 13                  ; Enter?
                JNE     Msg_DrawMessage2

                Inc     DX                      ; Increase current line.
                Xor     BX, BX

Msg_DrawMessage2:
                Loop    Msg_DrawMessage1

Msg_DrawMessage4:
                Mov     CurrentLine, DX
                Mov     HorizontalPosition, BX

                Mov     AX, TopLine             ; Boundary checking...
                Cmp     AX, DX
                JBE     Msg_DrawMessage5

                Mov     AX, DX                  ; Need new top line.

Msg_DrawMessage5:
                LEA     CX, [EAX+34]
                Cmp     CX, DX
                JAE     Msg_DrawMessage6

                Mov     AX, DX
                Sub     AX, 34
                JNC     Msg_DrawMessage6

                Xor     AX, AX

Msg_DrawMessage6:
                Mov     TopLine, AX
                                                ; Now to get the stuff onto
                                                ; the screen...
Msg_DrawMessage7:
                Mov     CX, TopLine
                Mov     SI, Offset MessageData
                JCXZ    Msg_DrawMessage9

Msg_DrawMessage8:
                LodsB
                And     AL, AL
                JZ      Msg_DrawMessageEnd

                Cmp     AL, 13
                JNE     Msg_DrawMessage8
                Loop    Msg_DrawMessage8

Msg_DrawMessage9:
                Mov     DI, (2+13*80)*2
                Mov     BL, CharacterColour
                Mov     CX, 35
                Mov     DX, 20+100h
                Mov     AH, BL

                Push    DI

                Cmp     Edit, 1
                JE      Msg_DrawMessage10

                Mov     DX, 300h

Msg_DrawMessage10:
                LodsB
                And     AL, AL
                JZ      Msg_DrawMessage12

                Cmp     AL, 13
                JE      Msg_DrawMessage11

                Cmp     AL, ' '
                JE      Msg_DrawMessage14

                StosW
                Jmp     Msg_DrawMessage10

Msg_DrawMessage14:
                Mov     AH, 3
                StosW
                Mov     AH, BL
                Jmp     Msg_DrawMessage10

Msg_DrawMessage11:
                Mov     AX, DX
                StosW

                Mov     AH, BL

                Pop     DI
                Add     DI, 160
                Push    DI

                Loop    Msg_DrawMessage10
                Jmp     Msg_DrawMessage13

Msg_DrawMessage12:
                Mov     AX, DX
                Inc     AH
                StosW

Msg_DrawMessage13:
                Pop     DI

Msg_DrawMessageEnd:
                Ret

EndP            Msg_DrawMessage
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_PreMessage Far

                Push    CS
                Pop     DS
                        Assume DS:Message

                Cmp     Edit, 0
                JE      Msg_PreMessage1

                Call    S_GetDestination

                Mov     AX, CurrentLine
                Sub     AX, TopLine
                Mov     BX, 80
                Mul     BX
                Add     AX, HorizontalPosition
                LEA     DI, [EAX*2+(2+13*80)*2+1]

                And     Byte Ptr [ES:DI], 8
                Or      Byte Ptr [ES:DI], 30h

Msg_PreMessage1:
                Ret

EndP            Msg_PreMessage
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_PostMessage Far

                Push    CS
                Pop     DS

                Cmp     Edit, 0
                JNE     Msg_PostMessage2

                Mov     SI, Offset NoEditKeys
                Call    M_FunctionDivider
                JC      Msg_PostMessage1

                Jmp     [SI]

Msg_PostMessage1:
                Xor     AX, AX
                Ret

Msg_PostMessage2:
                Mov     SI, Offset EditMsgKeys
                Call    M_FunctionDivider
                JC      Msg_PostMessage3

                Jmp     [SI]

Msg_PostMessage3:
                Cmp     CX, 11Ch        ; Enter
                JE      Msg_PostMessage6
                Test    CL, CL
                JZ      Msg_PostMessage1

                Cmp     DL, 32
                JB      Msg_PostMessage1
                Jmp     Msg_PostMessage4

Msg_PostMessage6:
                Mov     DL, 13

Msg_PostMessage4:
                Push    DX

                Mov     DX, 1
                Mov     SI, CurrentPosition
                Call    InsertData

                Pop     DX

                JC      Msg_PostMessage5

                Mov     [SI+MessageData], DL
                Call    CheckWordWrap
                Jmp     Msg_EditMsgRight

Msg_PostMessage5:
                Mov     AX, 1
                Ret

EndP            Msg_PostMessage
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_Tab Far

                Mov     CX, 8

Msg_Tab1:
                Push    CX
                Mov     DX, 32
                Call    Far Ptr Msg_PostMessage4
                Pop     CX
                Loop    Msg_Tab1

                Ret


EndP            Msg_Tab

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_ViewMsgUp Far
                Assume DS:Message

                Mov     AX, TopLine
                Sub     AX, 1
                AdC     AX, 0
                Mov     TopLine, AX

                Mov     AX, 1
                Ret

EndP            Msg_ViewMsgUp
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_ViewMsgDown Far
                Assume DS:Message

                Mov     AX, TopLine
                Inc     AX
                Cmp     AX, 7970
                JB      Msg_ViewMsgDown1

                Mov     AX, 7970

Msg_ViewMsgDown1:
                Mov     TopLine, AX

                Mov     AX, 1
                Ret

EndP            Msg_ViewMsgDown
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_ViewMsgPgUp Far
                Assume DS:Message

                Mov     AX, TopLine
                Sub     AX, 35
                JNC     Msg_ViewMsgPgUp1

                Xor     AX, AX

Msg_ViewMsgPgUp1:
                Mov     TopLine, AX

                Mov     AX, 1
                Ret

EndP            Msg_ViewMsgPgUp
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_ViewMsgPgDn Far
                Assume DS:Message

                Mov     AX, TopLine
                Add     AX, 35
                Cmp     AX, 7970
                JB      Msg_ViewMsgPgDn1

                Mov     AX, 7970

Msg_ViewMsgPgDn1:
                Mov     TopLine, AX

                Mov     AX, 1
                Ret

EndP            Msg_ViewMsgPgDn
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_ViewMsgEdit Far
                Assume DS:Message

                Mov     TopLine, 0
                Mov     CurrentLine, 0
                Mov     CurrentPosition, 0
                Mov     Edit, 1

                Mov     AX, 1
                Ret

EndP            Msg_ViewMsgEdit
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_EditMsgView Far
                Assume DS:Message

                Mov     Edit, 0

                Mov     AX, 1
                Ret

EndP            Msg_EditMsgView
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_EditMsgLeft Far
                Assume DS:Message

                Sub     CurrentPosition, 1
                AdC     CurrentPosition, 0

                Mov     AX, 1
                Ret

EndP            Msg_EditMsgLeft
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_EditMsgRight Far
                Assume DS:Message

                Mov     SI, CurrentPosition
                Cmp     SI, MESSAGELENGTH-2
                JAE     Msg_EditMsgRight1

                Cmp     Word Ptr [SI+MessageData], 0
                JE      Msg_EditMsgRight1

                Inc     CurrentPosition

Msg_EditMsgRight1:
                Mov     AX, 1
                Ret

EndP            Msg_EditMsgRight
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_EditMsgUp Far
                Assume DS:Message

                Mov     SI, CurrentPosition             ; Need to search back
                                                        ; twice...
                Call    FindStart
                And     SI, SI
                JZ      Msg_EditMsgUpEnd
                Dec     SI
                Call    FindStart

                Add     SI, Offset MessageData

                Mov     CX, HorizontalPosition
                JCXZ    Msg_EditMsgUp3

Msg_EditMsgUp2:
                LodsB
                Cmp     AL, 13
                LoopNE  Msg_EditMsgUp2
                JNE     Msg_EditMsgUp3

                Dec     SI

Msg_EditMsgUp3:
                Sub     SI, Offset MessageData
                Mov     CurrentPosition, SI

Msg_EditMsgUpEnd:
                Mov     AX, 1
                Ret

EndP            Msg_EditMsgUp
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_EditMsgPgUp Far

                Mov     CX, 35

Msg_EditMsgPgUp1:
                Push    CX
                Call    Msg_EditMsgUp
                Pop     CX
                Loop    Msg_EditMsgPgUp1

                Mov     AX, 1
                Ret

EndP            Msg_EditMsgPgUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_EditMsgDown Far
                Assume DS:Message
                                        ; Search for enter
                Mov     SI, CurrentPosition

Msg_EditMsgDown1:
                Mov     AL, [SI+MessageData]
                Inc     SI
                And     AL, AL
                JZ      Msg_EditMsgDownEnd

                Cmp     AL, 13
                JNE     Msg_EditMsgDown1

                Mov     CX, HorizontalPosition
                JCXZ    Msg_EditMsgDown3

Msg_EditMsgDown2:
                Mov     AL, [SI+MessageData]
                And     AL, AL
                JZ      Msg_EditMsgDown3

                Cmp     AL, 13
                JE      Msg_EditMsgDown3

                Inc     SI
                Loop    Msg_EditMsgDown2

Msg_EditMsgDown3:
                Cmp     SI, MESSAGELENGTH-2
                JAE     Msg_EditMsgDownEnd

                Mov     CurrentPosition, SI

Msg_EditMsgDownEnd:
                Mov     AX, 1
                Ret

EndP            Msg_EditMsgDown
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_EditMsgPgDn Far

                Mov     CX, 35

Msg_EditMsgPgDn1:
                Push    CX
                Call    Msg_EditMsgDown
                Pop     CX
                Loop    Msg_EditMsgPgDn1

                Mov     AX, 1
                Ret

EndP            Msg_EditMsgPgDn

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_EditMsgDelete Far
                Assume DS:Message

                Mov     SI, CurrentPosition
                Mov     DX, 1
                Call    DeleteData
                Call    CheckWordWrap

                Mov     AX, 1
                Ret

EndP            Msg_EditMsgDelete
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_EditMsgInsert Far

                Mov     SI, CurrentPosition
                Mov     DX, 1
                Call    InsertData
                JC      Msg_EditMsgInsert1

                Mov     Byte Ptr [SI+MessageData], 32
                Call    CheckWordWrap

Msg_EditMsgInsert1:
                Mov     AX, 1
                Ret

EndP            Msg_EditMsgInsert

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_EditMsgBackspace Far
                Assume DS:Message

                Mov     SI, CurrentPosition
                And     SI, SI
                JZ      Msg_EditMsgBackspace1

                Call    Msg_EditMsgLeft
                Call    Msg_EditMsgDelete

Msg_EditMsgBackspace1:
                Mov     AX, 1
                Ret

EndP            Msg_EditMsgBackspace
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_EditMsgDeleteLine Far
                Assume DS:Message

                Mov     SI, CurrentPosition             ; Search back for
                                                        ; start of line..
                Call    FindStart

                                                ; Find length to delete.
                Xor     BX, BX                  ; DI = length

Msg_EditMsgDeleteLine3:
                Mov     AL, [SI+BX+MessageData]
                Inc     BX

                And     AL, AL
                JZ      Msg_EditMsgDeleteLine4
                Cmp     AL, 13
                JNE     Msg_EditMsgDeleteLine3

Msg_EditMsgDeleteLine4:
                Mov     DX, BX
                Call    DeleteData

                Mov     CurrentPosition, SI

                Mov     AX, 1
                Ret

EndP            Msg_EditMsgDeleteLine
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_ClearMessage Far

                Mov     DI, Offset O1_ConfirmClearMessage
                Mov     CX, 4
                Call    M_Object1List

                And     DX, DX
                JZ      Msg_ClearMessage1

                Call    Msg_ResetMessage

Msg_ClearMessage1:
                Mov     AX, 1
                Ret

EndP            Msg_ClearMessage

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_EditMsgHome Far
                Assume DS:Message

                Mov     SI, CurrentPosition
                Call    FindStart
                Mov     CurrentPosition, SI

                Mov     AX, 1
                Ret

EndP            Msg_EditMsgHome
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_EditMsgEnd Far
                Assume DS:Message

                Mov     SI, CurrentPosition

Msg_EditMsgEndLoop:
                Mov     AL, [SI+MessageData]

                Inc     SI

                And     AL, AL
                JZ      Msg_EditMsgEnd1

                Cmp     AL, 13
                JNE     Msg_EditMsgEndLoop

Msg_EditMsgEnd1:
                Dec     SI
                Mov     CurrentPosition, SI

                Mov     AX, 1
                Ret

EndP            Msg_EditMsgEnd
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            FindStart

FindStart1:
                Sub     SI, 1
                JC      FindStart2

                Cmp     Byte Ptr [SI+MessageData], 13
                JNE     FindStart1

FindStart2:
                Inc     SI
                Ret

EndP            FindStart

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InsertData                      ; SI = pos, DX = length.

                Push    CX
                Push    DX
                Push    SI

                Mov     CX, MESSAGELENGTH-1
                Sub     CX, SI
                Sub     CX, DX

                Mov     SI, Offset MessageData+MESSAGELENGTH-2
                Mov     DI, SI
                Sub     SI, DX

                Cmp     Byte Ptr [SI], 0
                JNE     InsertDataError

                Push    DS
                Pop     ES

                StD
                Rep     MovsB
                ClD

                ClC
                Jmp     InsertDataEnd

InsertDataError:
                Push    DS

                Mov     DI, Offset O1_LongMessageList
                Mov     CX, 2
                Call    M_Object1List

                Pop     DS

                StC

InsertDataEnd:
                Pop     SI
                Pop     DX
                Pop     CX
                Ret

EndP            InsertData

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DeleteData                      ; SI = pos, DX = length
                                                ; Assume DS:Message

                Push    CX
                Push    DX
                Push    SI

                Push    CS
                Pop     ES

                Mov     CX, MESSAGELENGTH
                Sub     CX, SI
                Sub     CX, DX
                JS      DeleteData1

                Add     SI, Offset MessageData
                Mov     DI, SI
                Add     SI, DX

                Rep     MovsB

                Xor     AX, AX
                Mov     CX, DX
                Rep     StosB

DeleteData1:
                Pop     SI
                Pop     DX
                Pop     CX
                Ret

EndP            DeleteData

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CheckWordWrap                   ; Check current line only.

                Mov     SI, CurrentPosition
                Call    FindStart

                                                ; OK, so SI = pos of last line.
                                                ; Now count length of new line.
                Xor     BX, BX                  ; BX = count.

CheckWordWrap3:
                Mov     AL, [SI+BX+MessageData]

                Inc     BX

                And     AL, AL
                JZ      CheckWordWrap4
                Cmp     AL, 13
                JNE     CheckWordWrap3

CheckWordWrap4:                         ; OK.. now if BX > 66...
                Cmp     BX, 75
                JA      CheckWordWrap5

                Ret

CheckWordWrap5:                         ; Search back for a space and REPLACE
                                        ; it with an enter...
                Mov     BX, 75

CheckWordWrap6:
                Dec     BX
                JZ      CheckWordWrap7

                Cmp     Byte Ptr [SI+BX+MessageData], 32
                JNE     CheckWordWrap6

                Mov     Byte Ptr [SI+BX+MessageData], 13

                Ret

CheckWordWrap7:                         ; Insert an enter
                Mov     DX, 1
                Add     SI, 75
                Call    InsertData
                Mov     Byte Ptr [SI+MessageData], 13

CheckWordWrap8:
                Ret

EndP            CheckWordWrap

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_GetMessageLength Far                ; Returns AX

                Push    DS
                Push    SI

                Push    CS
                Pop     DS

                Mov     SI, Offset MessageData

Msg_GetMessageLength1:
                LodsB
                And     AL, AL
                JNZ     Msg_GetMessageLength1

                Sub     SI, Offset MessageData
                Mov     AX, SI

                Pop     SI
                Pop     DS
                Ret

EndP            Msg_GetMessageLength

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_GetMessageOffset Far

                Push    CS
                Pop     DS

                Mov     DX, Offset MessageData
                Ret

EndP            Msg_GetMessageOffset

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Msg_ToggleCharacterSet Far
                Assume DS:Message

                Xor     CharacterColour, 6 xor 12

                Mov     AX, 1
                Ret

EndP            Msg_ToggleCharacterSet
                Assume DS:Nothing

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

EndS

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

End
