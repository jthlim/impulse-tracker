;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Mouse Module                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                        Jumps
                        .386P

; MouseRecord Structure...
;  Area         DW      Left, Top, Right, Bottom
;  Condition    DB      ?
;  Flags        DB      ?
;  ObjectNumber DW      ?
;  Function     DD      DWord FunctionPtr
;
; Condition bits
;  Bit 0: Mouse moved
;  Bit 1: Left button pressed
;  Bit 2: Left button held
;  Bit 3: Left button released
;  Bit 4: Right button pressed
;  Bit 5: Right button held
;  Bit 6: Right button released
;
; Flags
;  Bit 0-1: Condition test
;            0 = equal
;            1 = result when ANDed
;            2, 3 = reserved
;  Bit 2: NOT of condition test
;  Bit 3: Off - Cursor within area
;         On  - Cursor outside area
;  Bit 4: Always call, ignore area

include switch.inc

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Externals                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

        Extrn   S_SetSequencer:Far, S_ResetSequencer:Far
        Extrn   S_SetDirectMode:Far
        Extrn   S_GetDestination:Far

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Globals                                                                     ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

        Global  InitMouse:Far, UnInitMouse:Far
        Global  MouseCharacterGenerationOffset:Word
        Global  RestoreMouse:Far, DrawMouse:Far
        Global  MouseSecondSetEnable:Far, MouseSecondSetDisable:Far
        Global  RestoreMouseGraphics:Far, MouseToggle:Far
        Global  MouseInput:Far, AddMouseQueue:Far
        Global  SetKeyboardLock:Far, GetKeyboardLock:Far
        Global  MouseSaveEvents:Far, MouseRestoreEvents:Far
        Global  MouseAddEvent:Far, MouseClearEvents:Far
        Global  MouseRemoveEvents:Far, MouseSetXY:Far
        Global  MouseGetStatus:Far, NewCharacterSet:Far
        Global  MouseUpdateEnable:Far, MouseUpdateDisable:Far
        Global  SetMouseCursorType:Far, CmdLineDisableMouse:Far
        Global  ForceMouseRestore:Far

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment                 Mouse PARA Public 'Code' USE16
                        Assume CS:Mouse, DS:Nothing

CREATENEWLOGFILE        EQU     0
include debug.inc

                ; Assumes 80x50 display (512 characters, 8x8 pixels per char.)

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Variables                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

STARTINGCHARACTER       EQU     247     ; Use last 9 characters
QUEUEELEMENTSIZE        EQU     8
MAXXPIXEL               EQU     639
MAXYPIXEL               EQU     399

MouseCharacterGenerationOffset  DW      512*32
MouseAvailable          DB      0
MouseDisplay            DB      1
MouseEnabled            DB      1

MouseCursorType         DW      0

MouseCursorOffset       DW      0
MouseCursorWidth        DB      0
MouseCursorHeight       DB      0

NewMouseX               DW      40*8
NewMouseY               DW      30*8
MouseX                  DW      40*8
MouseY                  DW      30*8
MouseXHotSpot           DW      0
MouseYHotSpot           DW      0

OldCharacterData        DW      9 Dup (0)
Label   EndOldCharacterData
CharacterTypes          DW      247, 248, 249, 250, 251, 252, 253, 254, 255

OldBitmapData           DB      9*8 Dup (0)
NewBitmapData           DB      24*4 Dup (0)

OverWriteSecondSet      DB      1
RestoreGraphicsRequired DB      0
LockKeyBoard            DB      0
UpdateScreen            DB      0

MouseCursorHotSpot      Label
        DB      0, 0
        DB      4, 3
;        DB      8, 16

MouseCursorTypes        Label
        DW      Offset MouseCursorArrow
        DW      Offset MouseCursorCrossHairs
;        DW      Offset MouseCursorDownArrow

Label           MouseCursorArrow
        DW      0011111111111111b,      0000000000000000b
        DW      0001111111111111b,      0100000000000000b
        DW      0000111111111111b,      0110000000000000b
        DW      0000011111111111b,      0111000000000000b
        DW      0000001111111111b,      0111100000000000b
        DW      0000000111111111b,      0111110000000000b
        DW      0000000011111111b,      0111111000000000b
        DW      0000000001111111b,      0111111100000000b
        DW      0000000000111111b,      0111111110000000b
        DW      0000000001111111b,      0111111100000000b
        DW      0000000111111111b,      0111110000000000b
        DW      0000000011111111b,      0100011000000000b
        DW      1011000011111111b,      0000011000000000b
        DW      1111100001111111b,      0000001100000000b
        DW      1111100001111111b,      0000001100000000b
        DW      1111110011111111b,      0000000000000000b

Label           MouseCursorCrossHairs
        DW      1111111111111111b,      0000000000000000b
        DW      1111011111111111b,      0000000000000000b
        DW      1100000111111111b,      0000100000000000b
        DW      1000000011111111b,      0011111000000000b
        DW      1100000111111111b,      0000100000000000b
        DW      1111011111111111b,      0000000000000000b
        DW      1111111111111111b,      0000000000000000b
        DW      1111111111111111b,      0000000000000000b
        DW      1111111111111111b,      0000000000000000b
        DW      1111111111111111b,      0000000000000000b
        DW      1111111111111111b,      0000000000000000b
        DW      1111111111111111b,      0000000000000000b
        DW      1111111111111111b,      0000000000000000b
        DW      1111111111111111b,      0000000000000000b
        DW      1111111111111111b,      0000000000000000b
        DW      1111111111111111b,      0000000000000000b

        Comment ~

Label           MouseCursorDownArrow
        DW      1111111111111111b,      0000000000000000b
        DW      1111000000001111b,      0000000000000000b
        DW      1111000000001111b,      0000011111100000b
        DW      1111000000001111b,      0000011111100000b
        DW      1111000000001111b,      0000011111100000b
        DW      1111000000001111b,      0000011111100000b
        DW      1111000000001111b,      0000011111100000b
        DW      0000000000000000b,      0000011111100000b
        DW      0000000000000000b,      0111111111111110b
        DW      1000000000000001b,      0011111111111100b
        DW      1100000000000011b,      0001111111111000b
        DW      1110000000000111b,      0000111111110000b
        DW      1111000000001111b,      0000011111100000b
        DW      1111100000011111b,      0000001111000000b
        DW      1111110000111111b,      0000000110000000b
        DW      1111111001111111b,      0000000000000000b

                ~

MouseEvents             DB      100 * 16 Dup (0)
MouseEventStack         DW      8 Dup (0)
MouseEventStackPointer  DW      0
MouseEventStart         DW      Offset MouseEvents
MouseEventEnd           DW      Offset MouseEvents

MouseStatus             DB      0       ; Same as conditions...

MouseQueue              DW      128 Dup (0)
MouseQueueStart         DB      0
MouseQueueEnd           DB      0

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Functions                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            RestoreMouse Far

                Push    CS
                Pop     DS
                        Assume DS:Mouse

                Cmp     MouseDisplay, 0
                JE      RestoreMouse1

                Call    RemoveMouseCursor

RestoreMouse1:
                Ret

EndP            RestoreMouse
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            RemoveMouseCursor               ; Given ES=cursor to remove

                        Assume DS:Mouse
                Mov     BX, Offset OldCharacterData
                Mov     DI, MouseCursorOffset


                Mov     DX, Word Ptr MouseCursorWidth
                Test    DH, DH
                JZ      RemoveMouseCursor3
                Test    DL, DL
                JZ      RemoveMouseCursor3

                Mov     CL, STARTINGCHARACTER

RemoveMouseCursor1:
                Push    CX
                Push    BX
                Push    DI
                Mov     DL, MouseCursorWidth

RemoveMouseCursor2:
                Mov     AX, [BX]
                Test    AH, 8
                JNZ     RemoveMouseCursor4

                Cmp     [ES:DI], CL
                JNE     RemoveMouseCursor8
                Mov     [ES:DI], AX
                Jmp     RemoveMouseCursor8

RemoveMouseCursor4:
                Or      RestoreGraphicsRequired, 1

RemoveMouseCursor8:
;                Add     DI, 2
                ScasW
                Add     BX, 2
                Inc     CX
                Dec     DL
                JNZ     RemoveMouseCursor2

                Pop     DI
                Pop     BX
                Pop     CX

                Add     CL, 3
                Add     BX, 6
                Add     DI, 160

                Dec     DH
                JNZ     RemoveMouseCursor1

RemoveMouseCursor3:
                Ret

EndP            RemoveMouseCursor
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            RestoreMouseGraphics Far

                Push    CS
                Pop     DS
                        Assume DS:Mouse

                Mov     AL, RestoreGraphicsRequired
                Cmp     MouseDisplay, 0
                JE      RestoreMouseGraphics4
                Cmp     OverWriteSecondSet, 1
                JE      RestoreMouseGraphics4
                Test    AL, 10
                JNZ     RestoreMouseGraphics4
                Test    AL, 4
                JZ      RestoreMouseGraphics4

                Or      RestoreGraphicsRequired, 8
                Test    AL, 1
                JZ      RestoreMouseGraphics4

                Call    S_SetSequencer

                Mov     AX, 0A000h
                Mov     ES, AX

                Xor     BX, BX
                Mov     DH, MouseCursorHeight
                Test    DH, DH
                JZ      RestoreMouseGraphics4

RestoreMouseGraphics1:
                Push    BX
                Mov     DL, MouseCursorWidth

RestoreMouseGraphics2:
                Mov     AX, [OldCharacterData+BX]
                Test    AH, 8
                JZ      RestoreMouseGraphics3

                        ; AL = character in extended set.
                And     AX, 0FFh
                Mov     DI, AX
                Mov     SI, BX
                ShL     DI, 5
                ShL     SI, 2   ; DS:SI points to OldBitMap table
                Add     SI, Offset OldBitMapData
                Add     DI, MouseCharacterGenerationOffset
                                ; ES:DI points to output table

                Mov     CX, 8
                Rep     MovsB

RestoreMouseGraphics3:
                Add     BX, 2
                Dec     DL
                JNZ     RestoreMouseGraphics2

                Pop     BX
                Add     BX, 6

                Dec     DH
                JNZ     RestoreMouseGraphics1

                Call    S_ResetSequencer

RestoreMouseGraphics4:
                Ret

EndP            RestoreMouseGraphics
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SaveMouseCursor
                Assume DS:Mouse

                Push    CS              ; ***
                Pop     DS              ; ***

                PushF
                ClI
                Mov     SI, NewMouseX
                Mov     AX, NewMouseY
                PopF

                Mov     MouseX, SI
                Mov     MouseY, AX


;                Mov     AX, MouseY
                ShR     AX, 3

                Mov     DX, 50
                Sub     DX, AX          ; CX = height

                Cmp     DX, 3
                JB      SaveMouseCursor1

                Mov     DL, 3

SaveMouseCursor1:
                Mov     MouseCursorHeight, DL

                Mov     BL, 160
                Mul     BL
;                Mov     SI, MouseX
                ShR     SI, 3

                Mov     CX, 80
                Sub     CX, SI
                Cmp     CX, 3
                JB      SaveMouseCursor2

                Mov     CL, 3

SaveMouseCursor2:
                Add     SI, SI
                Mov     MouseCursorWidth, CL

                Add     SI, AX
                Mov     MouseCursorOffset, SI
                Mov     DI, Offset OldCharacterData
                Xor     EAX, EAX

                Mov     DWord Ptr [DI], EAX             ; Clear buffer first.
                Mov     DWord Ptr [DI+4], EAX
                Mov     DWord Ptr [DI+8], EAX
                Mov     DWord Ptr [DI+12], EAX
                Mov     Word Ptr [DI+16], AX

SaveMouseCursor3:
                Push    DI
                Push    SI
                Push    CX

SaveMouseCursor4:
                Mov     AX, [ES:SI]
                Mov     [DI], AX

                Add     SI, 2
;                Add     DI, 2
                ScasW
                Dec     CX
                JNZ     SaveMouseCursor4

                Pop     CX
                Pop     SI
                Pop     DI
                Add     SI, 160
                Add     DI, 6

                Dec     DX
                JNZ     SaveMouseCursor3

                                ; Now get bitmap data...

                Call    S_SetSequencer

                Push    ES

                Mov     AX, 0A000h
                Mov     ES, AX

                Mov     BX, Offset OldCharacterData
                Mov     DI, Offset OldBitmapData

SaveMouseCursor5:
                Mov     AX, [BX]
                Mov     SI, AX
                And     SI, 0FFh
                ShL     SI, 5
                Test    AH, 8
                JZ      SaveMouseCursor6

                Mov     AL, RestoreGraphicsRequired
                Test    AL, 1
                JZ      SaveMouseCursor8
                Test    AL, 10
                JZ      SaveMouseCursor7        ; JNZ 8
;                Test    AL, 4
;                JZ      SaveMouseCursor7

SaveMouseCursor8:
                Add     SI, MouseCharacterGenerationOffset

SaveMouseCursor6:
                Mov     EAX, [ES:SI]
                Mov     [DI], EAX
                Mov     EAX, [ES:SI+4]
                Mov     [DI+4], EAX

SaveMouseCursor7:
                Add     DI, 8
                Add     BX, 2
                Cmp     BX, Offset EndOldCharacterData
                JB      SaveMouseCursor5

                Pop     ES

                Test    RestoreGraphicsRequired, 10
                JZ      SaveMouseCursor9

                And     RestoreGraphicsRequired, Not 14

SaveMouseCursor9:
                Ret

EndP            SaveMouseCursor
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GenerateMouseCursor
                Assume DS:Mouse

;                Push    CS              ; ***
;                Pop     DS              ; ***

                                ; Has to work out new table and write chars
                Mov     SI, Offset OldBitMapData
                Mov     DI, Offset NewBitMapData
                Mov     DX, 3

GenerateMouseCursor1:
                Mov     CX, 8

GenerateMouseCursor2:
;                Mov     Byte Ptr [DI], 0
                Mov     AL, [SI+16]
                Mov     [DI+1], AL
                Mov     AL, [SI+8]
                Mov     [DI+2], AL
                Mov     AL, [SI]
                Mov     [DI+3], AL

                Inc     SI
                Add     DI, 4
                Loop    GenerateMouseCursor2

                Add     SI, 16

                Dec     DX
                JNZ     GenerateMouseCursor1

                Mov     BX, MouseX
                And     BX, 7           ; CX = MouseX % 8
                Mov     CX, 8
                Sub     CX, BX
                Mov     EDX, 0FF000000h
                ShL     EDX, CL         ; EDX = 0FF000000h << (8 - shift);
                Mov     CX, BX

                Mov     SI, MouseCursorType
;                Add     SI, SI
                Mov     SI, [MouseCursorTypes+SI]
                                        ; DS:SI points to masks.
                Mov     DI, MouseY
                And     DI, 7
                ShL     DI, 2
                Add     DI, Offset NewBitMapData

                Mov     BX, 16          ; Cursor height = 16

GenerateMouseCharacter3:
                Mov     AX, [SI]
                ShL     EAX, 16
                Mov     AX, 0FFFFh
                RCR     EAX, CL
                Or      EAX, EDX
                And     [DI], EAX

                Mov     AX, [SI+2]
                ShL     EAX, 16
                ShR     EAX, CL
                Or      [DI], EAX

                Add     SI, 4
                Add     DI, 4
                Dec     BX
                JNZ     GenerateMouseCharacter3

                        ; Lets write the characters!

                Push    ES
                Mov     AX, 0A000h
                Mov     ES, AX

                Mov     BX, Offset OldCharacterData
                Mov     SI, Offset NewBitmapData+3

                Mov     DL, 3

GenerateMouseCharacter7:
                Mov     DH, 3

GenerateMouseCharacter4:
                Mov     AX, [BX]
                                        ; Get DI = char to write to...
                Test    AH, 8
                JZ      GenerateMouseCharacter5

                Cmp     OverWriteSecondSet, 0
                JNE     GenerateMouseCharacter6

                And     AX, 0FFh
                ShL     AX, 5
                Add     AX, MouseCharacterGenerationOffset
                Mov     DI, AX
                Jmp     GenerateMouseCharacter9

GenerateMouseCharacter5:
                Mov     AX, [BX+18]
                ShL     AX, 5
                Mov     DI, AX

GenerateMouseCharacter9:
                        ; ES:DI points to character map memory

                Mov     CX, 8
                Push    SI

GenerateMouseCharacter8:
                MovsB
                Add     SI, 3

;                Mov     AL, [SI]
;                StosB
                Loop    GenerateMouseCharacter8

                Pop     SI

GenerateMouseCharacter6:
                Dec     SI
;                Inc     SI

                Add     BX, 2
                Dec     DH
                JNZ     GenerateMouseCharacter4

                Add     SI, 35
;                Add     SI, 32-3

                Dec     DL
                JNZ     GenerateMouseCharacter7

                Cmp     BX, Offset EndOldCharacterData
                JB      GenerateMouseCharacter4


                Pop     ES

                Ret

EndP            GenerateMouseCursor
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            PlotMouseCursor
                Assume DS:Mouse

                Push    CS              ; ***
                Pop     DS              ; ***

                Mov     DH, MouseCursorHeight
                And     DH, DH
                JZ      PlotMouseCursor4

                Mov     AL, STARTINGCHARACTER
                Mov     BX, MouseCursorOffset

PlotMouseCursor1:
                Push    AX
                Push    BX

                Mov     DL, MouseCursorWidth

PlotMouseCursor2:
                Test    Word Ptr [ES:BX], 800h
                JNZ     PlotMouseCursor3

                Mov     [ES:BX], AL

PlotMouseCursor3:
                Inc     AX
                Add     BX, 2
                Dec     DL
                JNZ     PlotMouseCursor2

                Pop     BX
                Pop     AX
                Add     BX, 160
                Add     AX, 3

                Dec     DH
                JNZ     PlotMouseCursor1

PlotMouseCursor4:
                Ret

EndP            PlotMouseCursor
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DrawMouseCursor         ; Given ES to write to.

                Call    SaveMouseCursor
                Call    GenerateMouseCursor

                Call    S_ResetSequencer

                                ; Write block...
                Call    PlotMouseCursor

                Ret

EndP            DrawMouseCursor

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DrawMouse Far

                Push    CS
                Pop     DS
                        Assume DS:Mouse

                Cmp     MouseDisplay, 0
                JE      DrawMouse1

                Call    DrawMouseCursor

DrawMouse1:
                Ret

EndP            DrawMouse
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseInterruptHandler Far

                PushF

                ClI
                CLD

                PushAD
                Push    DS
                Push    ES

                Push    CS
                Pop     DS
                        Assume DS:Mouse

                Mov     NewMouseX, CX
                Mov     NewMouseY, DX

                Xor     BH, BH                  ; BH = new status.
                Mov     BL, MouseStatus

                Test    AL, 1           ; Mouse moved
                JZ      MIH1

                Or      BH, 1
                Or      RestoreGraphicsRequired, 4

MIH1:
                Test    AL, 2           ; Left pressed
                JZ      MIH2

                Or      BH, 2
                Jmp     MIH4

MIH2:
                Test    AL, 4
                JZ      MIH3

                Or      BH, 8
                Jmp     MIH4

MIH3:
                Test    BL, 6           ; If last status had press or
                JZ      MIH4            ; held...

                Or      BH, 4           ; Set held

MIH4:
                Test    AL, 8           ; Left pressed
                JZ      MIH5

                Or      BH, 10h
                Jmp     MIH7

MIH5:
                Test    AL, 10h
                JZ      MIH6

                Or      BH, 40h
                Jmp     MIH7

MIH6:
                Test    BL, 30h         ; If last status had press or
                JZ      MIH7            ; held...

                Or      BH, 20h         ; Set held

MIH7:

                Mov     MouseStatus, BH

                Cmp     MouseDisplay, 0
                JE      MouseInterruptHandler1

                Mov     SI, MouseEventStart

                Cmp     UpdateScreen, 0
                JE      NoUpdateCursor

                Test    BH, 1           ; Moved?
                JZ      NoUpdateCursor

                PushAD
                Mov     AX, 0B800h
                Mov     ES, AX
                Push    ES
                Call    RemoveMouseCursor
                Call    RestoreMouseGraphics
                Pop     ES
                Call    DrawMouseCursor
                PopAD

NoUpdateCursor:
                Add     CX, MouseXHotSpot
                Add     DX, MouseYHotSpot

MouseInterruptHandler2:                         ; BH = status
                Cmp     SI, MouseEventEnd
                JAE     MouseInterruptHandler1
                Mov     AX, [SI+8]              ; AH = flags, AL = conditions
                                                ; AH: Bit 0-1 = test case
                                                ;            0 = equal
                                                ;            1 = result when and
                                                ;    Bit 2: NOT of test case
                                                ;    Bit 3: Inside/outside area
                                                ;    Bit 4: Ignore area
                Test    AH, 10h
                JNZ     MouseCheckCondition

                Cmp     CX, [SI]
                JB      MouseAreaOutside1
                Cmp     CX, [SI+4]
                JA      MouseAreaOutside1
                Cmp     DX, [SI+2]
                JB      MouseAreaOutside1
                Cmp     DX, [SI+6]
                JA      MouseAreaOutside1

                Test    AH, 8
                JZ      MouseCheckCondition
                Jmp     MouseInterruptHandler3

MouseAreaOutside1:
                Test    AH, 8
                JZ      MouseInterruptHandler3

MouseCheckCondition:
                And     AH, 7
                Cmp     AH, 1
                JB      MouseCheckCondition0
                JE      MouseCheckCondition1

                Cmp     AH, 5
                JB      MouseCheckCondition4
                JE      MouseCheckCondition5
                Jmp     MouseInterruptHandler3

MouseCheckCondition0:
                Cmp     AL, BH
                JE      MouseEventOK
                Jmp     MouseInterruptHandler3

MouseCheckCondition1:
                Test    AL, BH
                JNZ     MouseEventOK
                Jmp     MouseInterruptHandler3

MouseCheckCondition4:
                Cmp     AL, BH
                JNE     MouseEventOK
                Jmp     MouseInterruptHandler3

MouseCheckCondition5:
                Test    AL, BH
                JNZ     MouseInterruptHandler3
;                JZ      MouseEventOK
;                Jmp     MouseInterruptHandler3

MouseEventOK:           ; Call function!
                Mov     AX, [SI+10]
                Call    DWord Ptr [SI+12]
                And     AX, AX
                JZ      MouseInterruptHandler1

MouseInterruptHandler3:
                Add     SI, 16
                Jmp     MouseInterruptHandler2

MouseInterruptHandler1:
                Pop     ES
                Pop     DS
                PopAD
                PopF

                Ret

EndP            MouseInterruptHandler
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitMouse Far

                Cmp     CS:MouseEnabled, 0
                JE      InitMouse2

                Trace   " - Determining mouse availability"

                Xor     AX, AX
                Mov     ES, AX

                Mov     Byte Ptr [ES:449h], 6           ; 'Setting' display mode

                Int     33h

                Cmp     AX, -1
                JE      InitMouse1

                Mov     MouseDisplay, 0

InitMouse2:
                Ret

InitMouse1:
                Trace   " - Setting Mouse extents"

                Mov     MouseAvailable, 1

                Xor     CX, CX          ; X Limits
                Mov     DX, MAXXPIXEL
                Mov     AX, 7
                Int     33h

                Xor     CX, CX          ; Y Limits
                Mov     DX, MAXYPIXEL
                Mov     AX, 8
                Int     33h

                Mov     CX, MouseX
                Mov     DX, MouseY
                Call    MouseSetXY

                Trace   " - Installing mouse handler"

                Push    CS
                Pop     ES
                Mov     CX, 1Fh         ; Call on mouse move
                                        ; left button press, release.
                                        ; right button press, release.
                                        ; Ignores central button (if any)
                Mov     DX, Offset MouseInterruptHandler
                Mov     AX, 0Ch
                Int     33h

                Ret

EndP            InitMouse

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            UnInitMouse Far

                Xor     AX, AX
                Int     33h

                Ret

EndP            UnInitMouse

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseSecondSetEnable Far

                Mov     CS:OverwriteSecondSet, 0
                Ret

EndP            MouseSecondSetEnable

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseSecondSetDisable Far

                Mov     CS:OverwriteSecondSet, 1
                Ret

EndP            MouseSecondSetDisable

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseToggle Far

                Push    CS
                Pop     DS
                        Assume DS:Mouse

                Cmp     MouseAvailable, 0
                JE      MouseToggle1

                Xor     MouseDisplay, 1
                JNZ     MouseToggle1

                Mov     AX, 0B800h
                Mov     ES, AX
                Call    RemoveMouseCursor
                Mov     MouseDisplay, 1
                Or      RestoreGraphicsRequired, 4
                Call    RestoreMouseGraphics
                Mov     MouseDisplay, 0

MouseToggle1:
                Mov     AX, 1
                Ret

EndP            MouseToggle
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseSetXY Far

                PushF

                Mov     NewMouseX, CX
                Mov     NewMouseY, DX

                Cmp     CS:MouseAvailable, 0
                JE      MouseSetXY1

                ClI

                Mov     AX, 4
                Int     33h

                Sub     CX, MouseXHotSpot
                JNS     MouseSetXY2

                Xor     CX, CX

MouseSetXY2:
                Sub     DX, MouseYHotSpot
                JNS     MouseSetXY3

                Xor     DX, DX

MouseSetXY3:
                Cmp     CX, MAXXPIXEL
                JB      MouseSetXY4

                Mov     CX, MAXXPIXEL

MouseSetXY4:
                Cmp     DX, MAXYPIXEL
                JB      MouseSetXY5

                Mov     DX, MAXYPIXEL

MouseSetXY5:
                Mov     MouseX, CX
                Mov     MouseY, DX

                Or      CS:RestoreGraphicsRequired, 4

MouseSetXY1:
                PopF

                Ret

EndP            MouseSetXY

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseSaveEvents Far

                PushF
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Mouse

                Cmp     MouseAvailable, 0
                JE      MouseSaveEvents1

                ClI

                Mov     AX, MouseEventStart
                Mov     SI, MouseEventStackPointer
                Mov     [MouseEventStack+SI], AX
                Add     MouseEventStackPointer, 2

                Mov     AX, MouseEventEnd
                Mov     MouseEventStart, AX

MouseSaveEvents1:
                Pop     DS
                PopF

                Ret

EndP            MouseSaveEvents
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseRestoreEvents Far

                PushF
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Mouse

                Cmp     MouseAvailable, 0
                JE      MouseRestoreEvents1

                ClI

                Mov     AX, MouseEventStart
                Mov     MouseEventEnd, AX

                Sub     MouseEventStackPointer, 2
                Mov     SI, MouseEventStackPointer
                Mov     AX, [MouseEventStack+SI]
                Mov     MouseEventStart, AX

MouseRestoreEvents1:
                Pop     DS
                PopF

                Ret

EndP            MouseRestoreEvents
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetKeyboardLock Far             ; AL = lock state

                Mov     CS:LockKeyBoard, AL
                Ret

EndP            SetKeyboardLock

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetKeyboardLock Far

                Mov     AL, CS:LockKeyBoard
                Ret

EndP            GetKeyboardLock

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            AddMouseQueue Far               ; AX, CX, DX

                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Mouse

                Mov     BH, QUEUEELEMENTSIZE
                Mov     BL, MouseQueueEnd
                Add     BH, BL
                Cmp     BH, MouseQueueStart
                JE      AddMouseQueue1          ; No space left on queue.

                Mov     MouseQueueEnd, BH
                And     BX, 0FFh
                Mov     [MouseQueue+BX], AX
                Mov     [MouseQueue+BX+2], CX
                Mov     [MouseQueue+BX+4], DX
                Mov     [MouseQueue+BX+6], DI

AddMouseQueue1:
                Pop     DS
                Ret

EndP            AddMouseQueue
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseInput Far

                PushF

                Push    CS
                Pop     DS
                        Assume DS:Mouse

                ClI

                Cmp     MouseDisplay, 0
                JE      MouseInput1

                Mov     CL, MouseQueueEnd
                Mov     BL, MouseQueueStart
                Sub     CL, BL
                JNZ     MouseInput2

                Cmp     LockKeyBoard, 0
                JE      MouseInput1

                Mov     AX, 2
                PopF
                Ret

MouseInput1:
                Mov     AX, 0
                PopF
                Ret

MouseInput2:
                And     BX, 0FFh
                Mov     SI, BX

                Add     MouseQueueStart, QUEUEELEMENTSIZE

MouseInput3:
                Mov     BX, [MouseQueue+SI]
                Mov     CX, [MouseQueue+SI+2]
                Mov     DX, [MouseQueue+SI+4]
                Mov     DI, [MouseQueue+SI+6]

                Mov     AX, 1
                PopF
                Ret

EndP            MouseInput
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseAddEvent Far       ; Given DS:SI to event

                PushF

                Cmp     CS:MouseAvailable, 0
                JE      MouseAddEvent1

                Push    SI
                Push    ES
                Push    DI

                ClI
                CLD

                Push    CS
                Pop     ES
                Mov     DI, CS:MouseEventEnd

                Mov     CX, 8
                Rep     MovsW

                Mov     CS:MouseEventEnd, DI

                Pop     DI
                Pop     ES
                Pop     SI

MouseAddEvent1:
                PopF
                Ret

EndP            MouseAddEvent

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseClearEvents Far

                Mov     AX, CS:MouseEventStart
                Mov     CS:MouseEventEnd, AX
                Ret

EndP            MouseClearEvents

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseRemoveEvents Far           ; AX = number to remove

                ShL     AX, 4
                Sub     CS:MouseEventEnd, AX
                Ret

EndP            MouseRemoveEvents

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseGetStatus Far

                Mov     AL, CS:MouseStatus
                Ret

EndP            MouseGetStatus

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            NewCharacterSet Far

                Or      CS:RestoreGraphicsRequired, 2
                Ret

EndP            NewCharacterSet

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseUpdateEnable Far

                Mov     CS:UpdateScreen, 1
                Ret

EndP            MouseUpdateEnable

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MouseUpdateDisable Far

                Mov     CS:UpdateScreen, 0
                Ret

EndP            MouseUpdateDisable

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetMouseCursorType Far

                PushF
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Mouse
                ClI

                Mov     MouseCursorType, BX
                Mov     AX, [MouseCursorHotSpot+BX]
                Mov     CX, MouseX
                Mov     DX, MouseY

                Add     CX, MouseXHotSpot
                Add     DX, MouseYHotSpot

                Mov     Byte Ptr MouseXHotSpot, AL
                Mov     Byte Ptr MouseYHotSpot, AH

                Sub     CX, MouseXHotSpot
                JNS     SetMouseCursorType1

                Xor     CX, CX

SetMouseCursorType1:
                Sub     DX, MouseYHotSpot
                JNS     SetMouseCursorType2

                Xor     DX, DX

SetMouseCursorType2:
                Cmp     CX, MAXXPIXEL
                JB      SetMouseCursorType3

                Mov     CX, MAXXPIXEL

SetMouseCursorType3:
                Cmp     DX, MAXYPIXEL
                JB      SetMouseCursorType4

                Mov     DX, MAXYPIXEL

SetMouseCursorType4:
;                Mov     NewMouseX, CX
;                Mov     NewMouseY, DX

                Call    MouseSetXY

                Pop     DS
                PopF
                Ret

EndP            SetMouseCursorType

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CmdLineDisableMouse Far

                Mov     Word Ptr CS:MouseDisplay, 0
                Ret

EndP            CmdLineDisableMouse

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ForceMouseRestore Far

                Call    MouseUpdateDisable
                ClI
                Call    RestoreMouse
                Or      RestoreGraphicsRequired, 4
                Call    RestoreMouseGraphics
                StI
                Jmp     MouseUpdateEnable

EndP            ForceMouseRestore

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

EndS

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

End
