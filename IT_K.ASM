;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Keyboard Module                                                             ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                        Jumps
                        .386

include switch.inc

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Externals                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                Extrn   D_GotoStartingDirectory:Far

                Extrn   E_UnInitEMS:Far
                Extrn   S_GetDestination:Far
                Extrn   Music_Stop:Far
                Extrn   Music_KBPlaySong:Far
                Extrn   Music_IncreaseVolume:Far
                Extrn   Music_DecreaseVolume:Far
                Extrn   S_DrawString:Far
                Extrn   CrashRecovery:Far

                Extrn   IsStartupKeyList:Far
                Extrn   GetStartupKeyList:Far

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Globals                                                                     ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                Global  K_DrawTables:Far
                Global  K_InitKeyBoard:Far
                Global  K_UnInitKeyBoard:Far
                Global  K_IsKeyWaiting:Far
                Global  K_GetKey:Far
                Global  K_IsAnyKeyDown:Far
                Global  K_IsKeyDown:Far
                Global  K_ClearKeyBoardQueue:Far
                Global  K_ResetKeyboardTables:Far
                Global  K_SelectKBButton:Far
                Global  K_SetKeyboardType:Far
                Global  K_InstallDOSHandler:Far
                Global  K_UnInstallDOSHandler:Far
                Global  K_SwapKeyBoard:Far
                Global  K_InstallKeyboardType:Far
                Global  K_RemoveKeyboardType:Far
                Global  K_SetScrollLock:Far

                Global  CountryTable:Byte

                Public  MIDIBufferEmpty, MIDISend, K_ShowMIDIInput

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment                 KeyBoard BYTE Public 'Code' USE16
                        Assume CS:KeyBoard, DS:KeyBoard

CREATENEWLOGFILE        EQU     0
include debug.inc

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Variables                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

KeyBoardTable           DB      256 Dup (?)     ; Table of current keypresses
KeyBoardBuffer          DB      256 Dup (?)     ; Queue of keys.
LastKey                 DW      0               ; For Caps/Numlock processing
                                                ;  only on FIRST press
KBStart                 DW      0               ; Buffer start ptr
KBEnd                   DW      0               ; Buffer end ptr

OldKBHandler            Label   DWord
OldKBHandlerOffset      DW      ?               ; Old Interrupt handler offset
OldKBHandlerSegment     DW      ?               ; Old interrupt handler segment

HighSet                 DB      0

Caps                    DB      0               ; Internal flag
NumLock                 DB      0               ; Internal flag
ScrollLock              DB      0

KeyboardFile            DB      "KEYBOARD.CFG", 0
KeyboardFileLength      DW      0

KeypadValueFlag         DB      0
KeypadValue             DB      0

MIDIStatusByte          DB      0
MIDIDataByte1           DB      0
MIDIDataByte2           DB      0
MIDIDataInput           DB      0

MIDIMessage             DB      "MIDI Input: ", 0FDh, "X ", 0FDh, "X ", 0FDh, "X   ", 0

TranslationTable        Label   DWord
TranslationTableOffset  DW      Offset  USKeyboardTable
TranslationTableSegment DW      Keyboard

USKeyboardTable    Label Byte

        DB      2       ; 1
         DB      0
         DW      '1'
         DB      3       ; !
         DW      '!'
         DB      0FFh

        DB      3       ; 2
         DB      0
         DW      '2'
         DB      3       ; @
         DW      '@'
         DB      0FFh

        DB      4       ; 3
         DB      0
         DW      '3'
         DB      3       ; #
         DW      '#'
         DB      0FFh

        DB      5       ; 4
         DB      0
         DW      '4'
         DB      3       ; $
         DW      '$'
         DB      0FFh

        DB      6       ; 5
         DB      0
         DW      '5'
         DB      3       ; %
         DW      '%'
         DB      0FFh

        DB      7       ; 6
         DB      0
         DW      '6'
         DB      3       ; ^
         DW      '^'
         DB      0FFh

        DB      8       ; 7
         DB      0
         DW      '7'
         DB      3       ; &
         DW      '&'
         DB      0FFh

        DB      9       ; 8
         DB      0
         DW      '8'
         DB      3       ; *
         DW      '*'
         DB      0FFh

        DB      10      ; 9
         DB      0
         DW      '9'
         DB      3       ; (
         DW      '('
         DB      0FFh

        DB      11      ; 0
         DB      0
         DW      '0'
         DB      3       ; )
         DW      ')'
         DB      0FFh

        DB      12      ; -
         DB      0
         DW      '-'
         DB      3       ; _
         DW      '_'
         DB      0FFh

        DB      13      ; =
         DB      0
         DW      '='
         DB      3       ; +
         DW      '+'
         DB      0FFh

        DB      14      ; Backspace
         DB      4       ; Ctrl-Backspace
         DW      127
         DB      0FFh

        DB      15      ; Tab
         DB      3       ; ShiftTab
         DW      0F00h
         DB      0FFh

        DB      16      ; Q
         DB      1
         DW      'Q'
         DB      2       ; q
         DW      'q'
         DB      4       ; Ctrl-Q
         DW      11h
         DB      5       ; Alt-Q
         DW      1000h
         DB      0FFh

        DB      17      ; W
         DB      1
         DW      'W'
         DB      2       ; w
         DW      'w'
         DB      4       ; Ctrl-W
         DW      17h
         DB      5       ; Alt-W
         DW      1100h
         DB      0FFh

        DB      18      ; E
         DB      1
         DW      'E'
         DB      2       ;e
         DW      'e'
         DB      4       ; Ctrl-E
         DW      5
         DB      5       ; Alt-E
         DW      1200h
         DB      0FFh

        DB      19      ; R
         DB      1
         DW      'R'
         DB      2       ; r
         DW      'r'
         DB      4       ; Ctrl-R
         DW      12h
         DB      5       ; Alt-R
         DW      1300h
         DB      0FFh

        DB      20      ; T
         DB      1
         DW      'T'
         DB      2       ; t
         DW      't'
         DB      4       ; Ctrl-T
         DW      14h
         DB      5       ; Alt-T
         DW      1400h
         DB      0FFh

        DB      21      ; Y
         DB      1
         DW      'Y'
         DB      2       ; y
         DW      'y'
         DB      4       ; Ctrl-Y
         DW      19h
         DB      5       ; Alt-Y
         DW      1500h
         DB      0FFh

        DB      22      ; U
         DB      1
         DW      'U'
         DB      2       ; u
         DW      'u'
         DB      4       ; Ctrl-U
         DW      15h
         DB      5       ; Alt-U
         DW      1600h
         DB      0FFh

        DB      23      ; I
         DB      1
         DW      'I'
         DB      2       ; i
         DW      'i'
         DB      4       ; Ctrl-I
         DW      9
         DB      5       ; Alt-I
         DW      1700h
         DB      0FFh

        DB      24      ; O
         DB      1
         DW      'O'
         DB      2       ; o
         DW      'o'
         DB      4       ; Ctrl-O
         DW      0Fh
         DB      5       ; Alt-O
         DW      1800h
         DB      0FFh

        DB      25      ; P
         DB      1
         DW      'P'
         DB      2       ; p
         DW      'p'
         DB      4       ; Ctrl-P
         DW      10h
         DB      5       ; Alt-P
         DW      1900h
         DB      0FFh

        DB      26      ; [
         DB      0
         DW      '['
         DB      3       ; {
         DW      '{'
         DB      0FFh

        DB      27      ; ]
         DB      0
         DW      ']'
         DB      3       ; }
         DW      '}'
         DB      0FFh

        DB      30      ; A
         DB      1
         DW      'A'
         DB      2       ; a
         DW      'a'
         DB      4       ; Ctrl-A
         DW      1
         DB      5       ; Alt-A
         DW      1E00h
         DB      0FFh

        DB      31      ; S
         DB      1
         DW      'S'
         DB      2       ; s
         DW      's'
         DB      4       ; Ctrl-S
         DW      13h
         DB      5       ; Alt-S
         DW      1F00h
         DB      0FFh

        DB      32      ; D
         DB      1
         DW      'D'
         DB      2       ; d
         DW      'd'
         DB      4       ; Ctrl-D
         DW      4
         DB      5       ; Alt-D
         DW      2000h
         DB      0FFh

        DB      33      ; F
         DB      1
         DW      'F'
         DB      2       ; f
         DW      'f'
         DB      4       ; Ctrl-F
         DW      6
         DB      5       ; Alt-F
         DW      2100h
         DB      0FFh

        DB      34      ; G
         DB      1
         DW      'G'
         DB      2       ; g
         DW      'g'
         DB      4       ; Ctrl-G
         DW      7
         DB      5       ; Alt-G
         DW      2200h
         DB      0FFh

        DB      35      ; H
         DB      1
         DW      'H'
         DB      2       ; h
         DW      'h'
         DB      4       ; Ctrl-H
         DW      8
         DB      5       ; Alt-H
         DW      2300h
         DB      0FFh

        DB      36      ; J
         DB      1
         DW      'J'
         DB      2       ; j
         DW      'j'
         DB      4       ; Ctrl-J
         DW      0Ah
         DB      5       ; Alt-J
         DW      2400h
         DB      0FFh

        DB      37      ; K
         DB      1
         DW      'K'
         DB      2       ; k
         DW      'k'
         DB      4       ; Ctrl-K
         DW      0Bh
         DB      5       ; Alt-K
         DW      2500h
         DB      0FFh

        DB      38      ; L
         DB      1
         DW      'L'
         DB      2       ; l
         DW      'l'
         DB      4       ; Ctrl-L
         DW      0Ch
         DB      5       ; Alt-L
         DW      2600h
         DB      0FFh

        DB      39      ; ;
         DB      0
         DW      ';'
         DB      3       ; :
         DW      ':'
         DB      0FFh

        DB      40      ; '
         DB      0
         DW      "'"
         DB      3       ; "
         DW      '"'
         DB      0FFh

        DB      41      ; `
         DB      0
         DW      '`'
         DB      3       ; ~
         DW      '~'
         DB      0FFh

        DB      43      ; \
         DB      0
         DW      '\'
         DB      3       ; |
         DW      '|'
         DB      0FFh

        DB      44      ; z
         DB      1
         DW      'Z'
         DB      2       ; z
         DW      'z'
         DB      4       ; Ctrl-Z
         DW      1Ah
         DB      5       ; Alt-Z
         DW      2C00h
         DB      0FFh

        DB      45      ; X
         DB      1
         DW      'X'
         DB      2       ; x
         DW      'x'
         DB      4       ; Ctrl-X
         DW      1Ah
         DB      5       ; Alt-X
         DW      2D00h
         DB      0FFh

        DB      46      ; C
         DB      1
         DW      'C'
         DB      2       ; c
         DW      'c'
         DB      4       ; Ctrl-C
         DW      3
         DB      5       ; Alt-C
         DW      2E00h
         DB      0FFh

        DB      47      ; V
         DB      1
         DW      'V'
         DB      2       ; v
         DW      'v'
         DB      4       ; Ctrl-V
         DW      16h
         DB      5       ; Alt-V
         DW      2F00h
         DB      0FFh

        DB      48      ; B
         DB      1
         DW      'B'
         DB      2       ; b
         DW      'b'
         DB      4       ; Ctrl-B
         DW      2
         DB      5       ; Alt-B
         DW      3000h
         DB      0FFh

        DB      49      ; N
         DB      1
         DW      'N'
         DB      2       ; n
         DW      'n'
         DB      4       ; Ctrl-N
         DW      0Eh
         DB      5       ; Alt-N
         DW      3100h
         DB      0FFh

        DB      50      ; M
         DB      1
         DW      'M'
         DB      2
         DW      'm'
         DB      4       ; Ctrl-M
         DW      0Dh
         DB      5       ; Alt-M
         DW      3200h
         DB      0FFh

        DB      51      ; ,
         DB      0
         DW      ','
         DB      3
         DW      '<'
         DB      0FFh

        DB      52      ; .
         DB      0
         DW      '.'
         DB      3
         DW      '>'
         DB      0FFh

        DB      53      ; /
         DB      0
         DW      '/'
         DB      3
         DW      '?'
         DB      0FFh

        DB      55      ; XT/AT printscreen, Enhanced keyboard *
         DB      0
         DW      '*'
         DB      0FFh

        DB      57      ; Spacebar
         DB      0
         DW      ' '
         DB      3
         DW      ' '
         DB     0FFh

        DB      71      ; Keypad 7
         DB      8
         DW      '7'
         DB      10
         DW      7
         DB      0FFh

        DB      72      ; Keypad 8
         DB      8
         DW      '8'
         DB      10
         DW      8
         DB      0FFh

        DB      73      ; Keypad 9
         DB      8
         DW      '9'
         DB      10
         DW      9
         DB      0FFh

        DB      74      ; Grey -
         DB      0
         DW      '-'
         DB      0FFh

        DB      75      ; Keypad 4
         DB      8
         DW      '4'
         DB      10
         DW      4
         DB      0FFh

        DB      76      ; Keypad 5
         DB      8
         DW      '5'
         DB      10
         DW      5
         DB      0FFh

        DB      77      ; Keypad 6
         DB      8
         DW      '6'
         DB      10
         DW      6
         DB      0FFh

        DB      78      ; Grey +
         DB      0
         DW      '+'
         DB      0FFh

        DB      79      ; Keypad 1
         DB      8
         DW      '1'
         DB      10
         DW      1
         DB      0FFh

        DB      80      ; Keypad 2
         DB      8
         DW      '2'
         DB      10
         DW      2
         DB      0FFh

        DB      81      ; Keypad 3
         DB      8
         DW      '3'
         DB      10
         DW      3
         DB      0FFh

        DB      82      ; Keypad 0
         DB      8
         DW      '0'
         DB      10
         DW      0
         DB      0FFh

        DB      83
         DB     8
         DW     '.'
         DB     0FFh

        DB      128+35h ; Grey /
         DB      0
         DW      '/'
         DB      0FFh

        DB      0FFh

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Functions                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Alt             DB      0
Ctrl            DB      0

Proc            K_KBHandler

                Push    AX
                Push    BX
                Push    DS

                Push    CS
                Pop     DS

                In      AL, 60h                 ; Get input from port

                Cmp     AL, 0FAh
                JE      K_KBHandler3            ; Is it a LED response?, 2 prev.

                Mov     BX, KBEnd               ; No... add a key to the queue
                Inc     BX
                And     BX, 0FFh
                Cmp     BX, KBStart
                JE      K_KBHandler1

                Mov     [KeyBoardBuffer+BX], AL
                Mov     KBEnd, BX

K_KBHandler1:
                Cmp     AL, 1Dh         ; Left Ctrl, Right Ctrl
                JE      K_KBHandlerCtrlPressed
                Cmp     AL, 9Dh
                JE      K_KBHandlerCtrlReleased

                Cmp     AL, 38h         ; Left Alt, Right Alt
                JE      K_KBHandlerAltPressed
                Cmp     AL, 0B8h
                JE      K_KBHandlerAltReleased

                Cmp     AL, 42h         ; F8
                JNE     K_KBHandlerDel

                Cmp     Word Ptr [Alt], 0
                JNE     K_KBHandler3

                Call    Music_Stop
                Jmp     K_KBHandler3

K_KBHandlerCtrlPressed:
                Mov     Ctrl, 1
                Jmp     K_KBHandler3

K_KBHandlerCtrlReleased:
                Mov     Ctrl, 0
                Jmp     K_KBHandler3

K_KBHandlerAltPressed:
                Mov     Alt, 1
                Jmp     K_KBHandler3

K_KBHandlerAltReleased:
                Mov     Alt, 0
                Jmp     K_KBHandler3

K_KBHandlerDel:
CRASHRECOVERYKEY        EQU     $+1
                Cmp     AL, 53h         ; Delete, 52h = insert
                JNE     K_KBHandler3

                Cmp     Word Ptr [Alt], 101h
                JNE     K_KBHandler3

                                ; Crash recovery
                Push    BP
                Mov     BP, SP
                DB      66h, 0C7h, 46h, 08h     ; Mov DWord Ptr [BP+8], CrashRecovery
                DD      DWord Ptr CrashRecovery ;
                Pop     BP

K_KBHandler3:
                In      AL, 61h                 ; KB Acknowledgement.
                Mov     AH, AL                  ; (Only for old 8042 chips.)
                Or      AL, 80h
                Out     61h, AL
                Mov     AL, AH
                Out     61h, AL

K_KBHandler2:
                Mov     AL, 20h                 ; IRQ Acknowledgement.
                Out     20h, AL

                Pop     DS
                Pop     BX
                Pop     AX
                IRet

EndP            K_KBHandler

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            K_DOSKBHandler Far

                Push    AX

                In      AL, 60h

                Cmp     AL, 4Eh                 ; Grey plus
                JE      K_DOSKBHandler5

                Cmp     AL, 4Ah                 ; Grey Minus
                JE      K_DOSKBHandler6

                Cmp     AL, 0E0h
                JNE     K_DOSKBHandler3

                Mov     CS:HighSet, 1
                Jmp     K_DOSKBHandler4

K_DOSKBHandler3:
                Cmp     CS:HighSet, 0
                JE      K_DOSKBHandler4

                Mov     CS:HighSet, 0

                Cmp     AL, 1Dh                 ; Right Ctrl.
                JNE     K_DOSKBHandler1

                PushF
                Call    DWord Ptr [CS:OldKBHandler]
                Call    Music_KBPlaySong
                Pop     AX
                IRet

K_DOSKBHandler1:
                Cmp     AL, 38h                 ; Right Alt.
                JNE     K_DOSKBHandler4

                PushF
                Call    DWord Ptr [CS:OldKBHandler]
                Call    Music_Stop
                Pop     AX
                IRet

K_DOSKBHandler4:
                Pop     AX
                Jmp     DWord Ptr [CS:OldKBHandler]

K_DOSKBHandler5:                                ; Grey Plus
                Mov     AL, 20h
                Out     20h, AL

                Call    Music_IncreaseVolume

                Pop     AX
                IRet

K_DOSKBHandler6:
                Mov     AL, 20h
                Out     20h, AL

                Call    Music_DecreaseVolume    ; Grey minus

                Pop     AX
                IRet

EndP            K_DOSKBHandler

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            K_SetKeyBoardLights             ; Reqs: DS:KeyBoard
                                                ; Sets keyboard lights (duh!)
                Push    AX
                Mov     AL, 0EDh
                Out     60h, AL

                Xor     AL, AL

                Cmp     Caps, 0
                JE      K_SetKeyBoardLights1

                Mov     AL, 4

K_SetKeyBoardLights1:
                Cmp     NumLock, 0
                JE      K_SetKeyBoardLights2

                Or      AL, 2

K_SetKeyBoardLights2:
                Cmp     ScrollLock, 0
                JE      K_SetKeyboardLights3

                Or      AL, 1

K_SetKeyBoardLights3:
                Out     60h, AL
                Pop     AX

                Ret

EndP            K_SetKeyBoardLights

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            K_InitKeyBoard Far            ; Raises key repeat rate
                                              ; to 30 char/s,
                                              ; delay before second char=0.25s
                                              ; Gets old IRQ handler
                                              ;  and CAPS/NumLock states
                                              ; Checks for Keyboard chip
                                              ; Installs new IRQ handler

                Push    AX
                Push    DS
                Push    ES

                Push    CS
                Pop     DS

                Trace   " - Detecting Windows presence"

                Mov     AX, 1600h               ; Windows detection.
                Int     2Fh
                Test    AL, 7Fh
                JZ      NoWindows

                Mov     Byte Ptr [CRASHRECOVERYKEY], 52h

NoWindows:
                Trace   " - Setting keyboard repeat rate"

                Mov     AX, 305h                ; Set repeat rate
                Xor     BX, BX
                Int     16h

                Trace   " - Installing keyboard handler"

                ClI

                In      AL, 21h
                Or      AL, 00000010b           ; Disable keyboard IRQ
                Out     21h, AL

                Xor     AX, AX
                Mov     ES, AX

                Mov     EAX, [ES:36]
                Mov     OldKBHandler, EAX

K_InitKeyBoard3:                                ; Chained to from K_UnInstallDOSHandler
                Mov     AL, [ES:417h]           ; Keyboard status byte.
                Mov     AH, AL
                And     AL, 40h
                Mov     Caps, AL
                And     AH, 20h
                Mov     NumLock, AH

                                                ; New keyboard IRQ handler
                Mov     AX, CS
                ShL     EAX, 16
                Mov     AX, Offset K_KBHandler

                Mov     Word Ptr [ES:5], 0      ; Screw Int1
                Mov     [ES:36], EAX

                In      AL, 21h
                And     AL, 11111101b
                Out     21h, AL

                StI

                Trace   " - Initialising keyboard tables"

                Call    K_ResetKeyboardTables   ; Initialise keyboard tables.

                Trace   " - Initialising keyboard lights"

                Call    K_SetKeyboardLights

                Pop     ES
                Pop     DS
                Pop     AX

                Ret

EndP            K_InitKeyBoard

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            K_UnInitKeyBoard Far

                Push    AX
                Push    DS
                Push    ES

                Push    CS
                Pop     DS

                ClI

                In      AL, 21h
                Or      AL, 00000010b
                Out     21h, AL

                Xor     AX, AX
                Mov     ES, AX

                Mov     EAX, OldKBHandler
                Mov     [ES:36], EAX

K_UnInitKeyBoard3:                              ; Chain to from InstallDOSHandler
                In      AL, 21h
                And     AL, 11111101b
                Out     21h, AL

                StI

                Mov     AL, [ES:417h]
                And     AL, 10010000b
                Cmp     CS:Caps, 0
                JE      K_UnInitKeyBoard2

                Or      AL, 40h                 ; Set caps lock flag

K_UnInitKeyBoard2:
                Cmp     CS:NumLock, 0
                JZ      K_UnInitKeyBoard1

                Or      AL, 20h

K_UnInitKeyBoard1:
                Mov     [ES:417h], AL

                Pop     ES
                Pop     DS
                Pop     AX

                Ret

EndP            K_UnInitKeyBoard

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            K_InstallDOSHandler Far

                Push    AX
                Push    DS
                Push    ES

                Push    CS
                Pop     DS

                ClI

                In      AL, 21h
                Or      AL, 00000010b
                Out     21h, AL

                Xor     AX, AX
                Mov     ES, AX

                Mov     AX, CS
                ShL     EAX, 16
                Mov     AX, Offset K_DOSKBHandler

                Mov     [ES:36], EAX

                Jmp     K_UnInitKeyBoard3

EndP            K_InstallDOSHandler

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            K_UnInstallDOSHandler Far

                Push    AX
                Push    DS
                Push    ES

                Push    CS
                Pop     DS

                Mov     AX, 305h                ; Set repeat rate
                Xor     BX, BX
                Int     16h

                ClI

                In      AL, 21h
                Or      AL, 00000010b           ; Disable keyboard IRQ
                Out     21h, AL

                Xor     AX, AX
                Mov     ES, AX

                Jmp     K_InitKeyBoard3

EndP            K_UnInstallDOSHandler

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            K_GetNextKeyByte

                Inc     BX
                And     BX, 0FFh
                Mov     AL, [KeyBoardBuffer+BX]

                Ret

EndP            K_GetNextKeyByte

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            K_IsKeyWaiting Far      ; Returns 1 in AX if key is ready
                                        ;         0 in AX if no key is ready

                Push    DS
                Push    BX
                Push    CX

                Call    IsStartupKeyList
                And     AX, 0FFh

                JNZ     K_IsKeyWaiting1

                Push    CS
                Pop     DS

                Mov     AX, KBEnd
                Sub     AX, KBStart
                And     AX, 0FFh
                JZ      K_IsKeyWaiting1

                Mov     CX, AX

                Mov     BX, KBStart
                Call    K_GetNextKeyByte
                Cmp     AL, 0E0h
                JNE     K_IsKeyWaiting2

                Mov     AX, CX
                Dec     AX
                Jmp     K_IsKeyWaiting1

K_IsKeyWaiting2:
                Mov     AX, 1

K_IsKeyWaiting1:
                Pop     CX
                Pop     BX
                Pop     DS
                Ret

EndP            K_IsKeyWaiting

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            K_GetKey Far                    ; CX/DX = input/translated

                Push    AX
                Push    BX
                Push    DS
                Push    SI

                Push    CS
                Pop     DS

                Call    IsStartupKeyList
                Test    AL, AL
                JZ      K_GetKeyNoStartupKeyList

                Call    GetStartupKeyList
                Jmp     K_GetKey20

K_GetKeyNoStartupKeyList:
                                                ; Check MIDI first
                Cmp     [MIDIDataInput], 2
                JB      K_GetKey1

                                        ; OK.. have MIDI message

                Mov     CH, [MIDIStatusByte]
                Xor     CL, CL
                Mov     DX, Word Ptr [MIDIDataByte1]
                Mov     [MIDIDataInput], 0
                Jmp     K_GetKey20

K_GetKey1:
                Call    K_IsKeyWaiting
                And     AX, AX
                JZ      K_GetKey1

                Xor     SI, SI

                Mov     BX, KBStart
                Call    K_GetNextKeyByte
                Cmp     AL, 0E0h
                JB      K_GetKey2
                Cmp     AL, 0E1h
                JA      K_GetKey2

                Mov     CX, AX
                And     CX, 1
                Inc     CX

K_GetKey18:
                Mov     KBStart, BX
                Call    K_IsKeyWaiting
                And     AX, AX
                JZ      K_GetKey18

                Add     SI, 128
                Call    K_GetNextKeyByte

                Loop    K_GetKey18

                Cmp     SI, 128
                JBE     K_GetKey2

                Mov     SI, 64

K_GetKey2:
                Mov     KBStart, BX
                And     AL, AL
                JS      K_GetKey3

                Inc     BH

K_GetKey3:
                And     AX, 07Fh
                Add     SI, AX
                Mov     CX, SI
                Mov     CH, BH

                                                        ; OK test for
                                                        ; stupid input.
                Cmp     CL, 0AAh
                JE      K_GetKey17
                Cmp     CL, 0B6h
                JE      K_GetKey17

                Mov     [KeyBoardTable+SI], BH

                Cmp     CX, 13Ah
                JNE     K_GetKey14

                Cmp     LastKey, CX
                JE      K_GetKey10

                Xor     Caps, 40h                             ; Toggle Caps Lock
                Call    K_SetKeyBoardLights
                Jmp     K_GetKey10

K_GetKey14:
                Cmp     CX, 145h                                ; Num Lock
                JNE     K_GetKey10

                Cmp     LastKey, CX
                JE      K_GetKey10

                Xor     NumLock, 20h
                Call    K_SetKeyBoardLights

K_GetKey10:
                Mov     LastKey, CX
                Cmp     Byte Ptr [KeyBoardTable+02Ah], 0      ; Left Shift Key
                JE      K_GetKey4

                Or      CH, 2                                 ; Left Shift Key

K_GetKey4:
                Cmp     Byte Ptr [KeyBoardTable+36h], 0       ; Right Shift Key
                JE      K_GetKey5

                Or      CH, 4                                 ; Right Shift Key

K_GetKey5:
                Cmp     Byte Ptr [KeyBoardTable+1Dh], 0       ; Left Ctrl Key
                JE      K_GetKey6

                Or      CH, 8

K_GetKey6:
                Cmp     Byte Ptr [KeyBoardTable+9Dh], 0       ; Right Ctrl Key
                JE      K_GetKey7

                Or      CH, 16                                ; Right Ctrl Key

K_GetKey7:
                Cmp     Byte Ptr [KeyBoardTable+38h], 0       ; Left Alt Key
                JE      K_GetKey8

                Or      CH, 32                                ; Left Alt Key

K_GetKey8:
                Cmp     Byte Ptr [KeyBoardTable+0B8h], 0      ; Right Alt Key
                JE      K_GetKey9

                Or      CH, 64                                ; Right Alt Key

K_GetKey9:
                Test    CH, 1   ; Keypress?     - actually need to check for
                                ;                 Alt-keypad stuff.
                JNZ     K_TranslateKeyPress

                Cmp     CL, 38h
                JE      K_TranslateAltRelease
                Cmp     CL, 0B8h
                JNE     K_TranslateKeyNoKey

K_TranslateAltRelease:
                Xor     DX, DX

                Cmp     KeypadValueFlag, 0
                JE      K_TranslateKeyNoKey

                XChg    Word Ptr KeypadValueFlag, DX    ; Reset flag + value
                ShR     DX, 8
                Cmp     DL, 32
                JB      K_TranslateKeyNoKey
                Jmp     K_TranslateKeyEnd

K_TranslateKeyPress:
                LDS     SI, TranslationTable
                        Assume DS:Nothing

K_TranslateKey1:
                LodsB
                Cmp     AL, CL
                JE      K_TranslateKey3
                Cmp     AL, 0FFh
                JE      K_TranslateKeyNoKey

K_TranslateKey2:
                LodsB
                Cmp     AL, 0FFh
                JE      K_TranslateKey1
                LodsW
                Jmp     K_TranslateKey2

K_TranslateKey3:
                LodsB
                Mov     BL, AL
                LodsW
                Mov     DX, AX
                Cmp     BL, 1
                JB      K_TranslateCondition0
                JE      K_TranslateCondition1

                Cmp     BL, 3
                JB      K_TranslateCondition2
                JE      K_TranslateCondition3

                Cmp     BL, 5
                JB      K_TranslateCondition4
                JE      K_TranslateCondition5

                Cmp     BL, 7
                JB      K_TranslateCondition6
                JE      K_TranslateCondition7

                Cmp     BL, 9
                JB      K_TranslateCondition8
                JE      K_TranslateCondition9

                Cmp     BL, 11
                JB      K_TranslateCondition10

                Jmp     K_TranslateKeyNoKey

K_TranslateCondition0:          ; Keypress
                Test    CH, Not 1
                JNZ     K_TranslateKey3
                Jmp     K_TranslateKeyEnd

K_TranslateCondition1:
                Cmp     Caps, 0
                JE      K_TranslateCondition3   ; Caps off -> check shift

K_TranslateConditionNoShift:
                Test    CH, Not 7
                JNZ     K_TranslateKey3
                Test    CH, 6
                JNZ     K_TranslateKey3
                Jmp     K_TranslateKeyEnd

K_TranslateCondition2:
                Cmp     Caps, 0
                JE      K_TranslateConditionNoShift
                        ; Fall through to shift check

K_TranslateCondition3:          ; Shift
                Test    CH, Not 7
                JNZ     K_TranslateKey3
                Test    CH, 6
                JZ      K_TranslateKey3
                Jmp     K_TranslateKeyEnd

K_TranslateCondition4:          ; Ctrl
                Test    CH, Not 19h
                JNZ     K_TranslateKey3
                Test    CH, 18h
                JZ      K_TranslateKey3
                Jmp     K_TranslateKeyEnd

K_TranslateCondition5:          ; Alt
                Test    CH, Not 61h
                JNZ     K_TranslateKey3
                Test    CH, 60h
                JZ      K_TranslateKey3
                Jmp     K_TranslateKeyEnd

K_TranslateCondition6:          ; Left alt
                Test    CH, Not 21h
                JNZ     K_TranslateKey3
                Test    CH, 20h
                JZ      K_TranslateKey3
                Jmp     K_TranslateKeyEnd

K_TranslateCondition7:          ; Right alt
                Test    CH, Not 41h
                JNZ     K_TranslateKey3
                Test    CH, 40h
                JZ      K_TranslateKey3
                Jmp     K_TranslateKeyEnd

K_TranslateCondition8:
                Test    CH, Not 1
                JNZ     K_TranslateKey3
                Cmp     NumLock, 0
                JE      K_TranslateKey3
                Jmp     K_TranslateKeyEnd

K_TranslateCondition9:
                Test    CH, Not 1
                JNZ     K_TranslateKey3
                Cmp     NumLock, 0
                JNE     K_TranslateKey3
                Jmp     K_TranslateKeyEnd

K_TranslateCondition10:
                Test    CH, Not 61h
                JNZ     K_TranslateKey3
                Test    CH, 60h
                JZ      K_TranslateKey3

                Mov     CS:KeyPadValueFlag, 1
                Mov     AL, 10
                Mul     CS:KeyPadValue
                Add     AL, DL
                Mov     CS:KeyPadValue, AL

K_TranslateKeyNoKey:
                Xor     DX, DX

K_TranslateKeyEnd:
                Cmp     NumLock, 0
                JNE     K_GetKey15

                Cmp     CL, 47h
                JB      K_GetKey15
                Cmp     CL, 53h
                JA      K_GetKey15
                Cmp     CL, 4Ah
                JE      K_GetKey15
                Cmp     CL, 4Eh
                JE      K_GetKey15

                Add     CL, 80h
                Jmp     K_GetKey20

K_GetKey15:
                Cmp     CL, 9Ch                 ; Grey enter...
                JNE     K_GetKey20

                Mov     CL, 1Ch                 ; Normal enter!
                Jmp     K_GetKey20

K_GetKey17:
                Xor     CX, CX
                Xor     DX, DX

K_GetKey20:
                Pop     SI
                Pop     DS
                Pop     BX
                Pop     AX
                Ret


EndP            K_GetKey

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            K_ClearKeyBoardQueue Far

                Push    AX

K_ClearKeyBoardQueue1:
                Call    K_IsKeyWaiting
                Test    AX, AX
                JZ      K_ClearKeyBoardQueue2
                Call    K_GetKey
                Jmp     K_ClearKeyBoardQueue1

K_ClearKeyBoardQueue2:
                Pop     AX
                Ret

EndP            K_ClearKeyBoardQueue

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            K_IsAnyKeyDown Far              ; Returns AL = 1 if key is down.

                Push    CX
                Push    DS
                Push    SI

                Push    CS
                Pop     DS
                        Assume DS:Keyboard

                Mov     SI, Offset KeyBoardTable
                Mov     CX, 256

K_IsAnyKeyDown1:
                LodsB
                And     AL, AL
                LoopZ   K_IsAnyKeyDown1

                JCXZ    K_IsAnyKeyDown2

                Mov     AL, 1

K_IsAnyKeyDown2:
                Pop     SI
                Pop     DS
                Pop     CX

                Ret

EndP            K_IsAnyKeyDown

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            K_IsKeyDown Far         ; BX = key to test

                Cmp     [CS:KeyboardTable+BX], 0
                Ret

EndP            K_IsKeyDown

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            K_ResetKeyboardTables Far

                Push    CS
                Pop     ES
                Mov     DI, Offset KeyboardTable
                Mov     CX, 518
                Xor     AL, AL
                Rep     StosB

                Mov     AX, 1
                Ret

EndP            K_ResetKeyboardTables

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            K_DrawTables Far

                Call    S_GetDestination
                Mov     DI, (2+15*80)*2

                Push    CS
                Pop     DS
                        Assume DS:KeyBoard
                Mov     SI, Offset KeyboardBuffer

                Mov     CX, 2004h               ; CH = row count, CL = ShR
                Mov     AH, 2h

K_DrawTables1:
                Mov     DL, 08h               ; BL = count
                Push    DI

K_DrawTables3:
                LodsB
                Mov     DH, AL
                ShR     AL, CL
                Cmp     AL, 10
                SBB     AL, 69h
                DAS
                StosW

                Mov     AL, DH
                And     AL, 0Fh
                Cmp     AL, 10
                SBB     AL, 69h
                DAS
                StosW

                Dec     DL
                JZ      K_DrawTables2

                Mov     AL, ' '
                StosW
                Jmp     K_DrawTables3

K_DrawTables2:
                Pop     DI
                Add     DI, 160

                Dec     CH
                JNZ     K_DrawTables1

                        ; Now for keypress tables.
                Mov     SI, Offset KeyboardTable
                Mov     DI, (29+15*80)*2

                Mov     CX, 2004h               ; CH = row count, CL = ShR
                Xor     DL, DL

K_DrawTable4:
                Mov     DH, 8
                Push    DI

K_DrawTable5:
                Mov     AH, 2
                LodsB

                Cmp     AL, 1
                SBB     AH, -1

                Mov     AL, DL
                ShR     AL, CL
                Cmp     AL, 10
                SBB     AL, 69h
                DAS
                StosW

                Mov     AL, DL
                And     AL, 0Fh
                Cmp     AL, 10
                SBB     AL, 69h
                DAS
                StosW

                Inc     DL
                Dec     DH
                JZ      K_DrawTable7

                Mov     AL, ' '
                StosW
                Jmp     K_DrawTable5

K_DrawTable7:
                Pop     DI
                Add     DI, 160

                Dec     CH
                JNZ     K_DrawTable4

                Xor     AX, AX
                Ret

EndP            K_DrawTables
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            K_ShowMIDIInput Far

                Push    CS
                Pop     DS
                        Assume DS:Keyboard

                                ; Now to shove the MIDI input info.
                Xor     AX, AX
                Mov     AL, [MIDIDataByte2]
                Push    AX
                Mov     AL, [MIDIDataByte1]
                Push    AX
                Mov     AL, [MIDIStatusByte]
                Push    AX

                Mov     DI, (2+13*80)*2
                Mov     SI, Offset MIDIMessage
                Mov     AH, 20h
                Call    S_DrawString

                Add     SP, 6

                Xor     AX, AX
                Ret

EndP            K_ShowMIDIInput
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            K_InstallKeyboardType Far

                Call    D_GotoStartingDirectory

                Push    CS
                Pop     DS
                        Assume DS:Keyboard

                Mov     AX, 3D00h
                Mov     DX, Offset KeyboardFile
                Int     21h
                JC      K_InstallKeyboardType2

                Trace   " - Custom keyboard file found"

                Mov     BX, AX

                Mov     AH, 3Fh
                Mov     CX, 2           ; Read 2 bytes
                Mov     DX, Offset KeyboardFileLength
                Int     21h
                JC      K_InstallKeyboardType1

                Trace   " - Allocating memory"

                Push    BX
                Mov     AH, 48h         ; Allocate memory
                Mov     BX, KeyboardFileLength
                Mov     CX, BX          ; CX = length for next call.
                Add     BX, 15
                ShR     BX, 4
                Int     21h
                Pop     BX
                JC      K_InstallKeyboardType1
                                        ; AX = load destination

                Trace   " - Loading custom keyboard data"

                Mov     DS, AX
                Xor     DX, DX
                Mov     AH, 3Fh         ; Load data
                Int     21h
                JC      K_InstallKeyboardType3

                Trace   " - Installing new keyboard translation table"

                Mov     AX, DS
                ShL     EAX, 16
                Mov     CS:TranslationTable, EAX
                Jmp     K_InstallKeyboardType1

K_InstallKeyboardType3:
                Push    DS
                Pop     ES
                Mov     AH, 49h
                Int     21h

K_InstallKeyboardType1:
                Mov     AH, 3Eh         ; Close file
                Int     21h

K_InstallKeyboardType2:
                Ret

EndP            K_InstallKeyboardType

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            K_RemoveKeyboardType Far

                Push    CS
                Pop     DS
                        Assume DS:Keyboard

                Mov     AX, TranslationTableSegment
                Mov     BX, CS
                Cmp     AX, BX
                JE      K_RemoveKeyboardType1

                Mov     ES, AX
                Mov     AH, 49h
                Int     21h

K_RemoveKeyboardType1:
                Ret

EndP            K_RemoveKeyboardType

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            K_SetScrollLock Far

                Push    CS
                Pop     DS
                Mov     ScrollLock, AL
                Call    K_SetKeyboardLights
                Ret

EndP            K_SetScrollLock

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MIDIBufferEmpty Far     ; Returns carry set if input OK.
                                        ; Returns carry CLEAR if input full.

                Cmp     [CS:MIDIDataInput], 2
                Ret

EndP            MIDIBufferEmpty

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MIDISend Far            ; Given AL = data byte.

                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Keyboard

                Test    AL, AL          ; Status byte?
                JNS     MIDISend1

                Mov     [MIDIStatusByte], AL
                Mov     [MIDIDataInput], 0
                Jmp     MIDISendEnd

MIDISend1:
                Xor     BX, BX
                Mov     SI, Offset MIDIDataByte1
                Add     BL, [MIDIDataInput]
                Mov     [SI+BX], AL
                Mov     AL, [MIDIStatusByte]
                Inc     BX
                Cmp     AL, 0C0h
                JB      MIDISend2
                Cmp     AL, 0E0h
                JAE     MIDISend2

                Inc     BX
                Mov     [MIDIDataByte2], 0

MIDISend2:
                Mov     [MIDIDataInput], BL

MIDISendEnd:
                Pop     DS
                Ret

EndP            MIDISend
                Assume DS:Nothing

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

EndS

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

End
