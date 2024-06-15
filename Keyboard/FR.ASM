
        .model tiny
        .code

; to create the file:
;  TASM <filename>
;  TLINK /TDC <filename>
;  REN <filename>.COM KEYBOARD.CFG
;
; Structure is:
;  Keycode        (1 byte)
;   Condition     (1 byte)
;    Return value (1 word)
;   Condition     (1 byte)
;    Return value (1 word)
;   Condition     (1 byte)
;    Return value (1 word)
;    .
;    .
;    .
;   0FFh <-- end of condition/return value list
;
; Keycode is the value in the keypress table in IT on Ctrl-F1 (remember the
; values on the keypress table are in HEX..)
;
; Condition is one of the following
;  0 = requires NO Shift/Ctrl/Alt/...,
;  1 = if Shift and key while caps lock OFF *OR* CAPS lock ON, no ctrl/alt
;  2 = if Shift and key while caps lock ON *OR* CAPS lock OFF, no ctrl/alt
;  3 = if Shift
;  4 = if Ctrl
;  5 = if left/right Alt
;  6 = if Left Alt
;  7 = if Right Alt
;  8 = if Numlock on, no ctrl/alt
;  9 = if Numlock off, no ctrl/alt
;  0FFh = end of list.
;
; Return value is the character, or a DOS character value

ORG 100h

FileStart:

FileLength  DW      Offset EndKeyboardTable - Offset StartKeyboardTable

StartKeyboardTable:

        DB      2       ; 1
        DB      0
        DW      '&'
        DB      3       ; !
        DW      '1'
        DB      0FFh

        DB      3       ; 2
        DB      0
        DW      '‚'
        DB      3       ; "
        DW      '2'
        DB      7
        DW      "~"     ; @
        DB      0FFh

        DB      4       ; 3
        DB      0
        DW      '"'
        DB      3       ; #
        DW      '3'
        DB      7
        DW      "#"
        DB      0FFh

        DB      5       ; 4
        DB      0
        DW      "'"
        DB      3       ; $
        DW      '4'
        DB      7
        DW      '{'
        DB      0FFh

        DB      6       ; 5
        DB      0
        DW      '('
        DB      3       ; %
        DW      '5'
        DB      7
        DW      '['
        DB      0FFh

        DB      7       ; 6
        DB      0
        DW      '-'
        DB      3       ; &
        DW      '6'
        DB      7
        DW      '|'
        DB      0FFh

        DB      8       ; 7
        DB      0
        DW      'Š'
        DB      3       ; 
        DW      '7'
        DB      7
        DW      '`'     ; 
        DB      0FFh

        DB      9       ; 8
        DB      0
        DW      '_'
        DB      3       ; 
        DW      '8'
        DB      7
        DW      '\'     ; 
        DB      0FFh

        DB      10      ; 9
        DB      0
        DW      '‡'
        DB      3       ; 
        DW      '9'
        DB      7
        DW      '^'     ; 
        DB      0FFh

        DB      11      ; 0
        DB      0
        DW      '…'
        DB      3       ; =
        DW      '0'
        DB      7
        DW      '@'     ; }
        DB      0FFh

        DB      12      ; +
        DB      0
        DW      ')'
        DB      3       ; ?
        DW      'ø'
        DB      7
        DW      ']'
        DB      0FFh

        DB      13      ; '
        DB      0
        DW      "="
        DB      3       ; `
        DW      "+"
        DB      7
        DW      '}'
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
        DW      'A'
        DB      2       ; q
        DW      'a'
        DB      4       ; Ctrl-Q
        DW      1h
        DB      5       ; Alt-Q
        DW      1E00h
        DB      0FFh

        DB      17      ; W
        DB      1
        DW      'Z'
        DB      2       ; w
        DW      'z'
        DB      4       ; Ctrl-W
        DW      19h
        DB      5       ; Alt-W
        DW      1500h
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
        DB      4       ; Ctrl-Z
        DW      19h
        DB      5       ; Alt-Z
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

        DB      26      ; 
        DB      0
        DW      '^'
        DB      3       ; †
        DW      'ù'
        DB      0FFh

        DB      27      ; .
        DB      0
        DW      '$'
        DB      3       ; ~
        DW      'œ'
        DB      0FFh

        DB      30      ; A
        DB      1
        DW      'Q'
        DB      2       ; a
        DW      'q'
        DB      4       ; Ctrl-A
        DW      11h
        DB      5       ; Alt-A
        DW      1000h
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

        DB      39      ; ™
        DB      1
        DW      'M'
        DB      2       ; ”
        DW      'm'
        DB      4       ; Ctrl-M
        DW      0Dh
        DB      5       ; Alt-M
        DW      3200h
        DB      0FFh

        DB      40      ; Ž
        DB      0
        DW      "—"
        DB      3       ; „
        DW      '%'
        DB      0FFh

        DB      41      ; '
        DB      0
        DW      "*"
        DB      3       ; *
        DW      "æ"
        DB      0FFh

        DB      43      ; <
        DB      0
        DW      '<'
        DB      3       ; >
        DW      '>'
        DB      0FFh

        DB      44      ; Y
        DB      1
        DW      'W'
        DB      2       ; y
        DW      'w'
        DB      4       ; Ctrl-Y
        DW      17h
        DB      5       ; Alt-Y
        DW      1100h
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
        DB      0
        DW      ','
        DB      3
        DW      '?'
        DB      0FFh

        DB      51      ; ,
        DB      0
        DW      ';'
        DB      3
        DW      '.'
        DB      0FFh

        DB      52      ; .
        DB      0
        DW      ':'
        DB      3
        DW      '/'
        DB      0FFh

        DB      53      ; -
        DB      0
        DW      '!'
        DB      3
        DW      '!'
        DB      0FFh

        DB      55      ; XT/AT printscreen, Enhanced keyboard *
        DB      0
        DW      '*'
        DB      0FFh

        DB      57      ; Spacebar
        DB      0
        DW      ' '
        DB      0FFh

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

        DB      128+35h ; Grey /
        DB      0
        DW      '/'
        DB      0FFh

        DB      0FFh

EndKeyboardTable:

End     FileStart
