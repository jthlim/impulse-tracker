;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Screen Module                                                               ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

include switch.inc

                        Jumps
                        .386

Segment         Mouse BYTE Public 'Code'
                Extrn   MouseCharacterGenerationOffset:Word
EndS

                Extrn   E_UnInitEMS:Far
                Extrn   DrawMouse:Far, RestoreMouse:Far, ForceMouseRestore:Far
                Extrn   RestoreMouseGraphics:Far, NewCharacterSet:Far
                Extrn   MouseSecondSetEnable:Far, MouseSecondSetDisable:Far
                Extrn   MouseUpdateEnable:Far, MouseUpdateDisable:Far

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Globals                                                                     ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                Global  S_InitScreen:Far
                Global  S_SetPalette:Far
                Global  S_UnInitScreen:Far
                Global  S_DrawBox:Far
                Global  S_UpdateScreen:Far
                Global  S_OverrideVGADetection:Far
                Global  S_SetDirectMode:Far
                Global  S_DrawString:Far
                Global  S_DirectDrawString:Far
                Global  S_HiLight:Far
                Global  S_ClearScreen:Far
                Global  S_GetDestination:Far
                Global  S_GetGenerationTableOffset:Far
                Global  S_GenerateCharacters:Far
                Global  S_SaveScreen:Far
                Global  S_RestoreScreen:Far
                Global  S_DefineSmallNumbers:Far
                Global  S_DefineHiASCII:Far
                Global  S_DrawSmallBox:Far
                Global  S_GetPaletteOffset:Far
                Global  S_SetPalette2:Far
                Global  S_UsePresetPalette:Far
                Global  S_InvertCursor:Far

                Global  S_SetSequencer:Far, S_ResetSequencer:Far

                Global  CharacterGenerationOffset:Word

                Public  PaletteDefs
                Public  S_RedefineCharacters
                Public  VGAFlags

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment                 Screen BYTE Public 'Code' USE16
                        Assume  CS:Screen, DS:Screen

CREATENEWLOGFILE        EQU     0
include debug.inc

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Variables                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

STORESCREENADDRESS      EQU     0BA00h

NoVGAMsg                DB      "Sorry, this program requires VGA", 13, 10
                        DB      "$"

ScreenDataArea          DW      ScreenData

PaletteDefs             Label   Byte
                        ; Default to camouflage
                        DB      0, 0, 0, 31, 22, 17, 45, 37, 30, 58, 58, 50
                        DB      44, 0, 21, 63, 63, 21, 17, 38, 18, 19, 3, 6
                        DB      8, 21, 0, 6, 29, 11, 14, 39, 29, 55, 58, 56
                        DB      40, 40, 40, 35, 5, 21, 22, 16, 15, 13, 12, 11

PresetPalettes          Label   Byte
                        ; Light Blue palette
                        DB      0, 0, 0, 10, 25, 45, 30, 40, 55, 51, 58, 63
                        DB      63, 21, 21, 21, 63, 21, 44, 44, 44, 22, 22, 22
                        DB      0, 0, 32, 0, 0, 42, 30, 40, 55, 51, 58, 63
                        DB      44, 44, 44, 21, 63, 21, 18, 16, 15, 12, 11, 10      ; Greyish brown

                        ; Gold
                        DB      0, 0, 0, 20, 17, 10, 41, 36, 21, 63, 55, 33
                        DB      63, 21, 21, 18, 53, 18, 38, 37, 36, 22, 22, 22
                        DB      0, 0, 32, 0, 0, 42, 41, 36, 21, 48, 49, 46
                        DB      44, 44, 44, 21, 50, 21, 18, 16, 15, 12, 11, 10

                        ; Camouflage / Jari Karppinen
                        DB      0, 0, 0, 31, 22, 17, 45, 37, 30, 58, 58, 50
                        DB      44, 0, 21, 63, 63, 21, 17, 38, 18, 19, 3, 6
                        DB      8, 21, 0, 6, 29, 11, 14, 39, 29, 55, 58, 56
                        DB      40, 40, 40, 35, 5, 21, 22, 16, 15, 13, 12, 11

                        ; Midnight Tracking palette
                        DB      0, 0, 0, 0, 8, 16, 0, 19, 32, 16, 28, 48
                        DB      63, 21, 21, 0, 48, 36, 32, 32, 32, 22, 22, 22
                        DB      0, 0, 24, 0, 0, 32, 0, 18, 32, 40, 40, 40
                        DB      32, 32, 32, 28, 0, 24, 4, 13, 20, 6, 7, 11

                        Comment ~
                        ; Cool Hot Colours - Zoner / EPI / XLM
                        DB      11, 0, 18, 0, 0, 22, 42, 35, 33, 53, 45, 41
                        DB      51, 0, 0, 34, 22, 35, 34, 33, 52, 22, 22, 22
                        DB      26, 26, 32, 32, 32, 42, 41, 36, 21, 48, 49, 46
                        DB      44, 44, 44, 21, 40, 21, 27, 16, 24, 21, 11, 19
                        ~

                        ; Pine colours - Jari Karppinen
                        DB      0, 0, 0, 2, 16, 13, 21, 32, 29, 51, 58, 63
                        DB      63, 34, 0, 52, 51, 33, 42, 41, 33, 31, 22, 22
                        DB      12, 10, 16, 18, 0, 24, 30, 40, 55, 58, 58, 33
                        DB      44, 44, 44, 49, 39, 21, 13, 15, 14, 14, 11, 14

                        ; Soundtracker - Chris Jarvis
                        DB      0, 0, 0, 18, 24, 28, 35, 42, 47, 51, 56, 60
                        DB      63, 21, 21, 21, 63, 22, 0, 35, 63, 22, 22, 22
                        DB      32, 13, 38, 37, 16, 62, 27, 40, 55, 51, 58, 63
                        DB      44, 44, 44, 21, 63, 21, 18, 16, 17, 13, 14, 13

                        ; Volcanic
                        DB      0, 0, 0, 25, 9, 0, 40, 14, 0, 51, 23, 0
                        DB      63, 8, 16, 0, 39, 5, 32, 32, 32, 0, 20, 20
                        DB      21, 0, 0, 28, 0, 0, 32, 32, 32, 62, 31, 0
                        DB      40, 40, 40, 0, 28, 38, 10, 16, 27, 8, 11, 19

                        Comment ~
                        ; Atlantic - Delta X / NOiSE
                        DB      0, 0, 0, 2, 0, 30, 8, 18, 43, 21, 43, 63
                        DB      63, 8, 16, 27, 32, 63, 0, 54, 63, 10, 15, 35
                        DB      0, 0, 30, 0, 0, 36, 0, 18, 32, 40, 40, 40
                        DB      18, 52, 63, 21, 50, 21, 10, 16, 27, 8, 11, 19
                        ~
                        ; Original Palette
;                        DB      0, 0, 0, 10, 25, 45, 30, 40, 55, 51, 58, 63
;                        DB      63, 21, 21, 21, 63, 21, 44, 44, 44, 22, 22, 22
;                        DB      0, 0, 32, 0, 0, 42, 30, 40, 55, 51, 58, 63
;                        DB      44, 44, 44, 21, 63, 21, 18, 16, 15, 12, 11, 10      ; Greyish brown

CharacterDefinitions    Label   Byte
                        DB      255, 128, 128, 128, 128, 128, 128, 128  ; 128
                        DB      255, 0, 0, 0, 0, 0, 0, 0                ; 129
                        DB      255, 1, 1, 1, 1, 1, 1, 1                ; 130
                        DB      128, 128, 128, 128, 128, 128, 128, 128  ; 131
                        DB      1, 1, 1, 1, 1, 1, 1, 1                  ; 132
                        DB      128, 128, 128, 128, 128, 128, 128, 255  ; 133
                        DB      0, 0, 0, 0, 0, 0, 0, 255                ; 134
                        DB      1, 1, 1, 1, 1, 1, 1, 255                ; 135
                        DB      128, 0, 0, 0, 0, 0, 0, 0                ; 136
                        DB      1, 0, 0, 0, 0, 0, 0, 0                  ; 137
                        DB      0, 0, 0, 0, 0, 0, 0, 128                ; 138
                        DB      0, 0, 0, 0, 0, 0, 0, 1                  ; 139
                        DB      128, 192, 224, 240, 248, 252, 254,255   ; 140
                        DB      255, 127, 63, 31, 15, 7, 3, 1           ; 141
                        DB      255, 255, 192, 192, 192, 192, 192, 192  ; 142
                        DB      255, 255, 0, 0, 0, 0, 0, 0              ; 143
                        DB      255, 255, 3, 3, 3, 3, 3, 3              ; 144
                        DB      192, 192, 192, 192, 192, 192, 192, 192  ; 145
                        DB      3, 3, 3, 3, 3, 3, 3, 3                  ; 146
                        DB      192, 192, 192, 192, 192, 192, 255, 255  ; 147
                        DB      0, 0, 0, 0, 0, 0, 255, 255              ; 148
                        DB      3, 3, 3, 3, 3, 3, 255, 255              ; 149
                        DB      192, 192, 0, 0, 0, 0, 0, 0              ; 150
                        DB      3, 3, 0, 0, 0, 0, 0, 0                  ; 151
                        DB      0, 0, 0, 0, 0, 0, 192, 192              ; 152
                        DB      0, 0, 0, 0, 0, 0, 3, 3                  ; 153
                        DB      0, 0, 0, 85, 0, 0, 0, 0                 ; 154
;                        DB      251, 155, 138, 138, 138, 138, 155, 251  ; 155
;                        DB      239, 40, 41, 41, 41, 41, 40, 239        ; 156
;                        DB      255, 0, 157, 85, 85, 157, 0, 255        ; 157
;                        DB      255, 0, 29, 29, 20, 220, 0, 255         ; 158
;                        DB      255, 0, 65, 67, 129, 131, 0, 255        ; 159
;                        DB      255, 0, 171, 42, 171, 58, 0, 255        ; 160
;                        DB      255, 0, 51, 170, 50, 171, 0, 255        ; 161
;                        DB      255, 0, 170, 171, 171, 170, 0, 255      ; 162
;                        DB      255, 1, 177, 169, 169, 177, 1, 255      ; 163

                        DB      0, 252, 252, 252, 252, 252, 252, 0      ; 155
                        DB      0, 126, 126, 126, 126, 126, 126, 0      ; 156
                        DB      0, 63, 63, 63, 63, 63, 63, 0            ; 157
                        DB      0, 31, 31, 31, 31, 31, 31, 0            ; 158
                        DB      0, 15, 15, 15, 15, 15, 15, 0            ; 159
                        DB      0, 7, 7, 7, 7, 7, 7, 0                  ; 160
                        DB      0, 3, 3, 3, 3, 3, 3, 0                  ; 161
                        DB      0, 1, 1, 1, 1, 1, 1, 0                  ; 162
                        DB      0, 128, 128, 128, 128, 128, 128, 0      ; 163
                        DB      0, 192, 192, 192, 192, 192, 192, 0      ; 164
                        DB      0, 224, 224, 224, 224, 224, 224, 0      ; 165
                        DB      0, 240, 240, 240, 240, 240, 240, 0      ; 166
                        DB      0, 248, 248, 248, 248, 248, 248, 0      ; 167
                        DB      126, 126, 126, 126, 126, 126, 126, 126  ; 168
                        DB      255, 255, 0, 24, 60, 126, 255, 0        ; 169
                        DB      255, 255, 0, 0, 0, 0, 24, 24            ; 170
                        DB      255, 255, 0, 24, 60, 126, 255, 24       ; 171
                        DB      255, 255, 0, 66, 102, 90, 66, 66        ; 172
                        DB      0, 0, 0, 24, 24, 0, 0, 0                ; 173
                        DB      0, 192, 192, 192, 192, 192, 192, 192    ; 174
                        DB      0, 216, 216, 216, 216, 216, 216, 216    ; 175
                        DB      0, 219, 219, 219, 219, 219, 219, 219    ; 176
                        DB      0, 96, 96, 96, 96, 96, 96, 96           ; 177
                        DB      0, 108, 108, 108, 108, 108, 108, 108    ; 178
                        DB      0, 109, 109, 109, 109, 109, 109, 109    ; 179
                        DB      0, 128, 128, 128, 128, 128, 128, 128    ; 180
                        DB      0, 176, 176, 176, 176, 176, 176, 176    ; 181
                        DB      0, 182, 182, 182, 182, 182, 182, 182    ; 182
                        DB      0, 0, 24, 60, 60, 24, 0, 0              ; 183
                        DB      0, 0, 0, 66h, 0, 0, 0, 0                ; 184
                        DB      0, 1Eh, 21h, 40h, 0, 0, 0, 0            ; 185Sine
                        DB      0, 0, 0, 82h, 44h, 38h, 0, 0            ; 186
                        DB      0, 3Eh, 22h, 22h, 22h, 22h, 63h, 0      ; 187Square
                        DB      0, 3Eh, 22h, 22h, 22h, 22h, 0E3h, 0     ; 188
                        DB      0, 30h, 2Ch, 23h, 20h, 20h, 20h, 0      ; 189RampDown
                        DB      0, 4, 4, 4, 0C4h, 34h, 0Ch, 0           ; 190
                        DB      0, 6, 4, 4, 4, 4, 6, 0                  ; 191, Left bracket
                        DB      0, 0C0h, 40h, 40h, 40h, 40h, 0C0h, 0    ; 192, Right bracket
                        DB      0, 0, 0, 18h, 18h, 0, 0, 0              ; 193, Notedots
                        DB      0, 0, 18h, 3Ch, 3Ch, 18h, 0, 0          ; 194
                        DB      0, 0, 18h, 3Ch, 3Ch, 18h, 0, 0          ; 195
                        DB      0, 0, 3Ch, 3Ch, 3Ch, 3Ch, 0, 0          ; 196
                        DB      0, 0, 3Ch, 3Ch, 3Ch, 3Ch, 0, 0          ; 197
                        DB      0, 18h, 3Ch, 7Eh, 7Eh, 3Ch, 18h, 0      ; 198
                        DB      0, 18h, 3Ch, 7Eh, 7Eh, 3Ch, 18h, 0      ; 199
                        DB      0, 3Ch, 7Eh, 7Eh, 7Eh, 7Eh, 3Ch, 0      ; 200
                        DB      0, 3Ch, 7Eh, 7Eh, 7Eh, 7Eh, 3Ch, 0      ; 201, end note dots

        Comment &
                                        ; Volume bars
        DB      0, 0, 0, 0, 0, 0, 0, 254
        DB      0, 0, 0, 0, 0, 254, 0, 254
        DB      0, 0, 0, 254, 0, 254, 0, 254
        DB      0, 254, 0, 254, 0, 254, 0, 254

        Comment &

EndCharacterDefinitions Label   Byte

HexNumeralDefinitions   Label   Byte
                        DB      4, 10, 10, 10, 10, 10, 4        ; '0'
                        DB      0, 4, 12, 4, 4, 4, 4, 14        ; '1'
                        DB      0, 4, 10, 2, 4, 4, 8, 14        ; '2'
                        DB      0, 12, 2, 2, 4, 2, 2, 12        ; '3'
                        DB      0, 10, 10, 10, 14, 2, 2, 2      ; '4'
                        DB      0, 14, 8, 8, 12, 2, 2, 12       ; '5'
                        DB      0, 4, 10, 8, 12, 10, 10, 4      ; '6'
                        DB      0, 14, 2, 2, 2, 2, 2, 2         ; '7'
                        DB      0, 4, 10, 10, 4, 10, 10, 4      ; '8'
                        DB      0, 14, 10, 10, 14, 2, 2, 2      ; '9'
                        DB      0, 4, 10, 10, 14, 10, 10, 10    ; 'A'
                        DB      0, 12, 10, 10, 12, 10, 10, 12   ; 'B'
                        DB      0, 6, 8, 8, 8, 8, 8, 6          ; 'C'
                        DB      0, 12, 10, 10, 10, 10, 10, 12   ; 'D'
                        DB      0, 14, 8, 8, 12, 8, 8, 14       ; 'E'
                        DB      0, 14, 8, 8, 12, 8, 8, 8        ; 'F'
                        DB      0, 6, 8, 8, 10, 10, 10, 6       ; 'G'
                        DB      0, 10, 10, 10, 14, 10, 10, 10   ; 'H'


BoxDefinitions          Label   Byte
  DB      128,21h,129,21h,130,21h,131,21h,32,23h,132,21h,133,21h,134,21h,135,21h
  DB      128,23h,129,23h,130,23h,131,23h,32,23h,132,23h,133,23h,134,23h,135,23h
  DB      142,21h,143,21h,144,21h,145,21h,32,23h,146,21h,147,21h,148,21h,149,21h
  DB      142,23h,143,23h,144,23h,145,23h,32,23h,146,23h,147,23h,148,23h,149,23h
  DB      128,23h,129,23h,129,23h,131,23h,32,23h, 32,23h,131,23h, 32,23h, 32,23h
  DB      128,21h,129,21h,129,21h,131,21h,32,23h, 32,21h,131,21h, 32,21h, 32,21h
  DB      142,23h,143,23h,143,23h,145,23h,32,23h, 32,23h,145,23h, 32,23h, 32,23h
  DB      142,21h,143,21h,143,21h,145,21h,32,23h, 32,21h,145,21h, 32,21h, 32,21h
  DB      139,23h,134,23h,138,21h,132,23h,32,23h,131,21h,137,21h,129,21h,136,21h
  DB      139,21h,134,21h,138,23h,132,21h,32,23h,131,23h,137,23h,129,23h,136,23h
  DB      153,23h,148,23h,152,21h,146,23h,32,23h,145,21h,151,21h,143,21h,150,21h
  DB      153,21h,148,21h,152,23h,146,21h,32,23h,145,23h,151,23h,143,23h,150,23h ; 11
  DB      139,21h,134,21h,138,21h,132,21h,32, 3h,131,21h,137,21h,129,21h,136,21h
  DB      139,23h,134,23h,138,23h,132,23h,32, 3h,131,23h,137,23h,129,23h,136,23h
  DB      153,21h,148,21h,152,21h,146,21h,32, 3h,145,21h,151,21h,143,21h,150,21h
  DB      153,23h,148,23h,152,23h,146,23h,32, 3h,145,23h,151,23h,143,23h,150,23h
  DB      128,21h,129,21h,130,21h,131,21h,32, 3h,132,21h,133,21h,134,21h,135,21h
  DB      128,23h,129,23h,130,23h,131,23h,32, 3h,132,23h,133,23h,134,23h,135,23h
  DB      142,21h,143,21h,144,21h,145,21h,32, 3h,146,21h,147,21h,148,21h,149,21h
  DB      142,23h,143,23h,144,23h,145,23h,32, 3h,146,23h,147,23h,148,23h,149,23h
  DB      128,23h,129,23h,129,23h,131,23h,32, 3h, 32,23h,131,23h, 32,23h, 32,23h
  DB      128,21h,129,21h,129,21h,131,21h,32, 3h, 32,21h,131,21h, 32,21h, 32,21h
  DB      142,23h,143,23h,143,23h,145,23h,32, 3h, 32,23h,145,23h, 32,23h, 32,23h
  DB      142,21h,143,21h,143,21h,145,21h,32, 3h, 32,21h,145,21h, 32,21h, 32,21h
  DB      139,23h,134,23h,138,21h,132,23h,32, 3h,131,21h,137,21h,129,21h,136,21h
  DB      139,21h,134,21h,138,23h,132,21h,32, 3h,131,23h,137,23h,129,23h,136,23h
  DB      153,23h,148,23h,152,21h,146,23h,32, 3h,145,21h,151,21h,143,21h,150,21h
  DB      153,21h,148,21h,152,21h,146,21h,32, 3h,145,23h,151,21h,143,23h,150,23h ; 27
  DB      128,23h,129,23h,141,21h,131,23h,32,23h,132,21h,140,21h,134,21h,135,21h
  DB      128,21h,129,21h,141,21h,131,21h,32,23h,132,23h,140,21h,134,23h,135,23h
IF TUTORIAL
  DB      128,13h,129,13h,130,13h,131,13h,32,13h,132,13h,133,13h,134,13h,135,13h
ENDIF

CharacterGenerationOffset       DW      512*32
VGAFlags                DB      0       ; Bit 0 = override VGA detection
                                        ; Bit 1 = PreserveRetrace
                                        ; Bit 2 = Wait for VRetrace
DirectVideo             DB      0
TestBytes               DB      '®CHARACTERúTEST¯'

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Functions                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

; InitScreen - Sets up buffer area for screen functions & character generation
;            - Sets up 50 line mode
;            - Sets up palette
;            - Defines basic characters (128->163)
;            - AX returns non-zero if error occurs

Proc            S_InitScreen Far

                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Screen

                Mov     DirectVideo, 0

                Test    VGAFlags, 1
                JNZ     S_InitScreen4

                Trace   " - VGA Detection"

; Check for VGA
                Mov     AX, 1A00h
                Int     10h

                Cmp     BL, 8
                JGE     S_InitScreen5

                Mov     DX, Offset NoVGAMsg
                Mov     AH, 9
                Int     21h

                Call    E_UnInitEMS

                Mov     AX, 4C01h               ; Return to DOS with errorlevel
                Int     21h

S_InitScreen5:
                Trace   " - Matrox-error detection"

                Mov     AX, 3
                Int     10h

                Mov     AX, 1100h
                Mov     BX, 1001h
                Mov     CX, 1
                Xor     DX, DX
                Push    CS
                Pop     ES
                Mov     BP, Offset TestBytes
                Int     10h

                Call    S_SetSequencer

                Push    0A000h
                Pop     ES

                Mov     DI, 4000h
                Mov     SI, Offset TestBytes

                Mov     CX, 4
                RepE    CmpSD
                JE      S_InitScreen8

                Mov     CharacterGenerationOffset, 2000h

                Push    Mouse
                Pop     FS
                        Assume FS:Mouse

                Mov     FS:MouseCharacterGenerationOffset, 2000h
                        Assume FS:Nothing

S_InitScreen8:
                Call    S_ResetSequencer

S_InitScreen4:
                Trace   " - Screen Mode Setup"

                Call    S_Set80x50Mode

                Trace   " - Screen Palette Setup"

                Call    S_SetPalette

                                ; OK.. save all characters above 128

                Trace   " - Character Generation Setup"

                Call    S_SetSequencer

                Mov     AX, 0A000h
                Mov     DS, AX
                Mov     ES, AX

                Mov     AX, 16
                Xor     SI, SI
                Mov     DX, 256
                Mov     DI, AX

S_InitScreen6:
                Mov     CX, 4
                Rep     MovsD

                Add     SI, AX
                Add     DI, AX

                Dec     DX
                JNZ     S_InitScreen6

                Call    S_ResetSequencer

                Push    CS
                Pop     DS

                Mov     SI, Offset CharacterDefinitions
                Mov     BX, (EndCharacterDefinitions-CharacterDefinitions+7) / 8
                Mov     AX, 128
                Call    S_RedefineCharacters

                Call    S_UpdateScreen

                Pop     DS
                Ret

EndP            S_InitScreen
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_SaveScreen Far

                PushF
                PushAD
                Push    DS
                Push    ES

                ClD
                Push    0B800h
                Push    STORESCREENADDRESS
                Pop     ES
                Pop     DS
                Xor     SI, SI
                Xor     DI, DI

IF USE32BITSCREENCOPY
                Mov     CX, 2000
                Rep     MovsD
ELSE
                Mov     CX, 4000
                Rep     MovsW
ENDIF

                Call    ForceMouseRestore

                Pop     ES
                Pop     DS
                PopAD
                PopF

                Ret

EndP            S_SaveScreen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_RestoreScreen Far

                PushF
                PushAD
                Push    DS
                Push    ES

                ClD

                Call    S_GetDestination

                Push    STORESCREENADDRESS
                Pop     DS
                Xor     SI, SI
                Xor     DI, DI
IF USE32BITSCREENCOPY
                Mov     CX, 2000
                Rep     MovsD
ELSE
                Mov     CX, 4000
                Rep     MovsW
ENDIF

                Call    ForceMouseRestore

                Pop     ES
                Pop     DS
                PopAD
                PopF

                Call    S_UpdateScreen

                Ret

EndP            S_RestoreScreen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_Set80x50Mode Far

                Push    AX
                Push    DX

                Mov     AX, 3
                Int     10h

                Mov     AX, 1112h
                Xor     BX, BX
                Int     10h

                Mov     AH, 1
                Mov     CH, 20h
                Int     10h

                Mov     AX, 1003h
                Xor     BX, BX
                Int     10h

                Mov     DX, 03C4h               ; Character Map
                Mov     AX, 0403h
                Out     DX, AX

                Test    CS:VGAFlags, 2
                JNZ     S_Set80x50Mode1

                Mov     AX, 0101h
                Out     DX, AX

                Mov     DX, 03C2h
                Mov     AL, 63h
                Out     DX, AL

                Mov     DX, 03DAh
                In      AL, DX

                Mov     DX, 03C0h
                Mov     AL, 13h
                Out     DX, AL
                Xor     AL, AL
                Out     DX, AL
                Mov     AL, 32h
                Out     DX, AL

S_Set80x50Mode1:
                Pop     DX
                Pop     AX

                Ret

EndP            S_Set80x50Mode

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_SetPalette2 Far

                PushA
                Push    DS

                Jmp     SP3

EndP            S_SetPalette2

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_SetPalette Far

                PushA
                Push    DS

                Mov     CX, 16

SP1:
                Mov     AX, 1000h
                Mov     BL, CL
                Dec     BX
                Mov     BH, BL
;                And     BH, 7
                Int     10h

                Loop    SP1

SP3:
                Mov     DX, 3C8h
                Xor     AL, AL
                Out     DX, AL

                Inc     DX

                Mov     CX, 16*3

                Push    CS
                Pop     DS

                        Assume  DS:Screen
                Mov     SI, Offset PaletteDefs

SP2:
                LodsB
                Out     DX, AL
                Loop    SP2

                Pop     DS

                        Assume  DS:Nothing
                PopA

                Ret

EndP            S_SetPalette

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

SequencerSemaphore      DB      0FFh

Proc            S_SetSequencer Far

                Inc     [CS:SequencerSemaphore]
                JNZ     S_SetSequencer1

                Push    AX
                Push    DX

                Mov     DX, 3C4h        ; Sequencer
                Mov     AX, 704h
                Out     DX, AX

                Mov     AX, 402h
                Out     DX, AX

                Mov     DX, 3CEh        ; Controller
                Mov     AX, 204h
                Out     DX, AX
                Mov     AX, 5
                Out     DX, AX
                Mov     AX, 406h
                Out     DX, AX

                Pop     DX
                Pop     AX

S_SetSequencer1:
                Ret

EndP            S_SetSequencer

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_ResetSequencer Far

                Dec     [CS:SequencerSemaphore]
                JNS     S_ResetSequencer1

                Push    AX
                Push    DX

                Mov     DX, 3C4h        ; Sequencer
                Mov     AX, 302h
                Out     DX, AX
                Mov     AX, 304h
                Out     DX, AX

                Mov     DX, 3CEh        ; Controller
                Mov     AX, 4
                Out     DX, AX
                Mov     AX, 1005h
                Out     DX, AX
                Mov     AX, 0E06h
                Out     DX, AX

                Pop     DX
                Pop     AX

S_ResetSequencer1:
                Ret

EndP            S_ResetSequencer

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_RedefineCharacters Far
                                        ; DS:SI = Offset to characterdefs
                                        ; BX = Number of characters
                                        ; AX = First character
                Push    CX
                Push    DS
                Push    SI
                Push    ES
                Push    DI

                Call    MouseUpdateDisable
                Call    NewCharacterSet

                Mov     DI, 0A000h
                Mov     ES, DI

                Mov     DI, AX
                Mov     CL, 5
                ShL     DI, CL

                Cmp     AX, 256
                JB      RedefineCharacters2

                Sub     DI, 256*32
                Add     DI, CS:CharacterGenerationOffset

RedefineCharacters2:
                Call    S_SetSequencer

RedefineCharacters1:
                Mov     CX, 8
                Rep     MovsB

                Add     DI, (32-8)
                Dec     BX
                JNZ     RedefineCharacters1

                Call    S_ResetSequencer
                Call    MouseUpdateEnable

                Pop     DI
                Pop     ES
                Pop     SI
                Pop     DS
                Pop     CX

                Ret

EndP            S_RedefineCharacters

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_DefineSmallNumbers Far

                Push    DS
                Push    SI
                Push    ES
                Push    DI

                Call    MouseUpdateDisable

                Push    CS
                Pop     DS
                Mov     DI, 0A000h
                Mov     ES, DI

                Call    S_SetSequencer

                Xor     DX, DX
                Mov     DI, CharacterGenerationOffset

S_DefineSmallNumbers1:
                Mov     AL, DL
                Mov     AH, AL
                And     AX, 0FF0h
                ShL     AH, 4
                ShR     AX, 1
                Mov     BL, AH
                Xor     BH, BH
                Mov     SI, AX
                And     SI, 0FFh
                Add     BX, Offset HexNumeralDefinitions
                Add     SI, Offset HexNumeralDefinitions

                Mov     CH, 8

S_DefineSmallNumbers2:
                Mov     AH, [BX]
                Inc     BX
                LodsB
                ShL     AL, 4
                Or      AL, AH
                StosB
                Dec     CH
                JNZ     S_DefineSmallNumbers2

                Inc     DX
                Add     DI, 24
                Cmp     DX, 256
                JB      S_DefineSmallNumbers1

                                ; Have to define G0->G9,H0->H9
                Mov     DH, 2
                Mov     BX, Offset HexNumeralDefinitions+16*8
                Mov     DI, 226*32              ; start at char 226.

S_DefineSmallNumbers3:
                Mov     SI, Offset HexNumeralDefinitions
                Mov     DL, 10

S_DefineSmallNumbers4:
                Push    BX

                Mov     CH, 8

S_DefineSmallNumbers5:
                Mov     AH, [BX]
                ShL     AH, 4
                Inc     BX
                LodsB
                Or      AL, AH
                StosB
                Dec     CH
                JNZ     S_DefineSmallNumbers5

                Pop     BX
                Add     DI, 24

                Dec     DL
                JNZ     S_DefineSmallNumbers4

                Add     BX, 8

                Dec     DH
                JNZ     S_DefineSmallNumbers3

                Call    S_ResetSequencer

                Pop     DI
                Pop     ES
                Pop     SI
                Pop     DS

                Call    NewCharacterSet
                Call    MouseSecondSetDisable
                Call    MouseUpdateEnable

                Ret

EndP            S_DefineSmallNumbers

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_UnInitScreen Far

                Push    ES

                Mov     AH, 49h
                Mov     ES, ScreenDataArea
                Int     21h

                Pop     ES

                Mov     AX, 3
                Int     10h

                Ret

EndP            S_UnInitScreen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_GetDestination Far

                Mov     ES, CS:ScreenDataArea

                Cmp     CS:DirectVideo, 0
                JE      S_GetDestination1

                Push    AX
                Mov     AX, 0B800h
                Mov     ES, AX
                Pop     AX

S_GetDestination1:
                Ret

EndP            S_GetDestination

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_ClearScreen Far

                Push    CX
                Push    ES
                Push    DI

                Call    S_GetDestination
IF USE32BITSCREENCOPY
                Mov     CX, 2000
                Mov     EAX, 03000300h
                Xor     DI, DI
                Rep     StosD
ELSE
                Mov     CX, 4000
                Mov     AX, 300h
                Xor     DI, DI
                Rep     StosW
ENDIF
                Pop     DI
                Pop     ES
                Pop     CX

                Ret

EndP            S_ClearScreen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

; Style - Low byte: Box style number
;       - High byte: Flags - Bit 0: Filled box/empty box; on = don't fill

Proc            S_DrawBox Far
                ARG Style, Bottom, Right, Top, Left

                Push    BP
                Mov     BP, SP

                PushA
                Push    DS
                Push    ES

                Push    CS
                Pop     DS

                Call    S_GetDestination
                Mov     DX, Style               ; SI = Box Style
                Mov     AL, 18
                Mul     DL                      ; AX = Box Style*18
                Mov     SI, AX
                Add     SI, Offset BoxDefinitions

                Mov     AX, 80
                Mul     Top
                Add     AX, Left
                Add     AX, AX

                Mov     DI, AX                  ; ES:DI points to top left
                MovsW

                LodsW
                Mov     CX, Right
                Sub     CX, Left
                Dec     CX
                Mov     DX, CX                  ; DX = width

                Rep     StosW

                MovsW                           ; OK.... top line drawn

                Mov     BX, Bottom
                Sub     BX, Top

DrawBox1:
                Add     DI, 156
                Sub     DI, DX
                Sub     DI, DX

                Dec     BX
                JZ      DrawBox3

                Push    SI

                MovsW

                LodsW

                Test    Style, 100h
                JNZ     DrawBox2

                Mov     CX, DX
                Rep     StosW

                MovsW
                Pop     SI

                Jmp     DrawBox1

DrawBox2:
                Add     DI, DX
                Add     DI, DX

                MovsW

                Pop     SI
                Jmp     DrawBox1

DrawBox3:
                Add     SI, 6

                MovsW

                LodsW
                Mov     CX, DX
                Rep     StosW

                MovsW

                Pop     ES
                Pop     DS
                PopA

                Pop     BP
                Ret

EndP            S_DrawBox

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_UpdateScreen Far

                Cmp     CS:DirectVideo, 0
                JNE     S_UpdateScreen1

                PushAD
                Push    DS
                Push    ES

                Call    MouseUpdateDisable               ; *

                Mov     ES, CS:ScreenDataArea
                Call    RestoreMouse
                Call    RestoreMouseGraphics


                Test    CS:VGAFlags, 4          ; Wait for vertical retrace?
                JZ      S_UpdateScreen2

                Mov     DX, 3DAh

S_UpdateScreen3:
                In      AL, DX
                Test    AL, 8
                JZ      S_UpdateScreen3

S_UpdateScreen2:
                Mov     ES, CS:ScreenDataArea
                Call    DrawMouse

                Xor     SI, SI
                Xor     DI, DI

                Mov     DS, CS:ScreenDataArea
                Mov     CX, 0B800h
                Mov     ES, CX
IF USE32BITSCREENCOPY
                Mov     CX, 2000
                Rep     MovsD
ELSE
                Mov     CX, 4000
                Rep     MovsW
ENDIF

                Mov     ES, CS:ScreenDataArea
                Call    RestoreMouse

                Call    MouseUpdateEnable               ; *

                Pop     ES
                Pop     DS
                PopAD

S_UpdateScreen1:
                Ret

EndP            S_UpdateScreen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_SetDirectMode Far

                Cmp     CS:DirectVideo, AL
                JE      S_SetDirectMode2

                And     AL, AL
                JZ      S_SetDirectMode1

                Call    S_UpdateScreen
                Jmp     S_SetDirectMode2

S_SetDirectMode1:
                PushAD
                Push    DS
                Push    ES

                Call    MouseUpdateDisable

                Mov     ES, CS:ScreenDataArea
                Mov     CX, 0B800h
                Mov     DS, CX
                Xor     SI, SI
                Xor     DI, DI
IF USE32BITSCREENCOPY
                Mov     CX, 2000
                Rep     MovsD
ELSE
                Mov     CX, 4000
                Rep     MovsW
ENDIF

                Call    RestoreMouse

                Call    MouseUpdateEnable       ; *

                Pop     ES
                Pop     DS
                PopAD

S_SetDirectMode2:
                Mov     CS:DirectVideo, AL
                Ret

EndP            S_SetDirectMode

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_HiLight Far                   ; DI points to offset
                                                ; AL = colour
                                                ; CX = number of characters
                Push    ES
                Push    CX
                Push    DI

                Call    S_GetDestination

HiLight1:
                Inc     DI
                StosB
                Loop    HiLight1

                Pop     DI
                Pop     CX
                Pop     ES

                Ret

EndP            S_HiLight

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_DirectDrawString Far

                Push    BP
                Mov     BP, SP
                Add     BP, 6

                Push    AX
                Push    BX
                Push    CX
                Push    DX
                Push    SI
                Push    ES

                Mov     DX, 0B800h
                Mov     ES, DX
                Mov     DX, DI

                Jmp     DrawString001

EndP            S_DirectDrawString

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_DrawString Far                ; DS:SI points to string
                                                ; DI points to offset
                                                ; AH = colour

        ; 0 = End of string
        ; 13 = Next line
        ; 10 = Toggle character sets
        ; 0FFh, x, n = repeat character n 'x' times
        ; 0FEh, x = set colour to x
        ; 0FDh, 'D' = show decimal number
        ; 0FDh, 'X' = show hex number
        ; 0FDh, 'S' = show signed number
        ; 0FDh, 'L' = show long number


                Push    BP
                Mov     BP, SP
                Add     BP, 6

                Push    AX
                Push    BX
                Push    CX
                Push    DX
                Push    SI
                Push    ES

                Call    S_GetDestination

                Mov     DX, DI

DrawString001:
                LodsB
                And     AL, AL
                JZ      DrawString002

                Cmp     AL, 0FDh
                JE      DrawString007

                Cmp     AL, 13
                JE      DrawString003

                Cmp     AL, 10
                JE      DrawString004

                Cmp     AL, 0FEh
                JAE     DrawString005

                StosW
                Jmp     DrawString001

DrawString002:
                Pop     ES
                Pop     SI
                Pop     DX
                Pop     CX
                Pop     BX
                Pop     AX
                Pop     BP

                Ret

DrawString003:                                  ; Next line
                Add     DX, 160
                Mov     DI, DX
                Jmp     DrawString001

DrawString004:                                  ; Toggle character sets
                Xor     AH, 8h
                Jmp     DrawString001

DrawString005:
                Cmp     AL, 0FEH
                JE      DrawString006

                LodsB                           ; RepeatCharacters
                Mov     CL, AL
                Xor     CH, CH

                LodsB
                Rep     StosW
                Jmp     DrawString001

DrawString006:
                LodsB                           ; New Colour
                Mov     AH, AL
                Jmp     DrawString001

DrawString007:
                LodsB
                Cmp     AL, 'D'
                JE      DrawString008

                Cmp     AL, 'X'
                JE      DrawString012

                Cmp     AL, 'L'
                JE      DrawString015

                Cmp     AL, 'S'
                JE      DrawStringSigned

                Push    AX
                Mov     AL, 0FDh
                StosW
                Pop     AX
                StosW
                Jmp     DrawString001

DrawStringSigned:
                Push    AX
                Push    BX
                Push    CX
                Push    DX

                Mov     CH, AH

                Push    0FFFFh

                Mov     AX, [BP]
                Mov     BX, 10

                And     AX, AX
                JNS     DrawString009

                Neg     AX
                Mov     CL, '-'
                Mov     [ES:DI], CX
                ScasW
;                Add     DI, 2
                Jmp     DrawString009

DrawString008:
                Push    AX
                Push    BX
                Push    CX
                Push    DX

                Mov     CH, AH

                Push    0FFFFh

                Mov     AX, [BP]
                Mov     BX, 10

DrawString009:
                Xor     DX, DX
                Div     BX

                Push    DX
                And     AX, AX
                JNZ     DrawString009

DrawString010:
                Pop     AX
                Cmp     AX, 0FFFFh
                JE      DrawString011

                Mov     AH, CH
                Add     AL, '0'
                StosW
                Jmp     DrawString010

DrawString011:
                Add     BP, 2

                Pop     DX
                Pop     CX
                Pop     BX
                Pop     AX
                Jmp     DrawString001

DrawString012:
                Push    AX
                Push    BX
                Push    DX

                Push    0FFFFh

                Mov     DX, [BP]
                Add     BP, 2

DrawString013:
                Mov     AL, DL
                And     AL, 0Fh
                Cmp     AL, 10
                SBB     AL, 69h
                DAS
                Push    AX

                ShR     DX, 4
                JNZ     DrawString013

                Pop     AX

DrawString014:
                StosW

                Pop     AX
                Cmp     AX, 0FFFFh
                JNE     DrawString014

                Pop     DX
                Pop     BX
                Pop     AX
                Jmp     DrawString001

DrawString015:
                Push    EAX
                Push    EBX
                Push    ECX
                Push    EDX

                Mov     CH, AH

                Push    0FFFFh

                Mov     EAX, [BP]
                Mov     EBX, 10

DrawString016:
                Xor     EDX, EDX
                Div     EBX

                Push    DX
                And     EAX, EAX
                JNZ     DrawString016

DrawString017:
                Pop     AX
                Cmp     AX, 0FFFFh
                JE      DrawString018

                Mov     AH, CH
                Add     AL, '0'
                StosW
                Jmp     DrawString017

DrawString018:
                Add     BP, 4

                Pop     EDX
                Pop     ECX
                Pop     EBX
                Pop     EAX
                Jmp     DrawString001


EndP            S_DrawString

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_GetGenerationTableOffset Far          ; returns ES:DI

                Mov     ES, CS:ScreenDataArea
                Mov     DI, 8000

                Ret

EndP            S_GetGenerationTableOffset

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_GenerateCharacters Far                ; AX = starting char.
                                                        ; BX = chars per row.
                                                        ; CX = number of rows.
                PushAD
                Push    DS
                Push    ES

                Push    AX
                Push    BX
                Push    CX

                Call    MouseUpdateDisable
                Call    NewCharacterSet

                Pop     CX
                Pop     BX
                Pop     AX

                Call    MouseSecondSetEnable

                Call    S_SetSequencer

                Mov     DL, 32
                Mul     DL                              ; AX = starting offset.
                Mov     DI, AX
                Add     DI, CharacterGenerationOffset

                Push    0A000h
                Pop     ES

                Mov     DS, CS:ScreenDataArea
                Mov     SI, 8000

                Mov     DX, BX

S_GenerateCharacters1:
                Push    CX
                Push    SI

S_GenerateCharacters5:
                Push    DI
                Push    SI
                Mov     CX, 8

S_GenerateCharacters4:
                Xor     AH, AH
                Mov     BP, 8

S_GenerateCharacters2:
                LodsB

                ShR     AL, 1
                RCL     AH, 1
                Dec     BP
                JNZ     S_GenerateCharacters2

                Mov     AL, AH
                StosB

                Mov     AX, DX
                ShL     AX, 3
                Add     SI, AX          ; Add SI, 8*BX
                Sub     SI, 8
                Loop    S_GenerateCharacters4

                Pop     SI
                Add     SI, 8

                Pop     DI
                Add     DI, 32

                Dec     BX
                JNZ     S_GenerateCharacters5

                Pop     SI
                Mov     BX, DX

                Mov     AX, BX
                Mov     CL, 6
                ShL     AX, CL
                Add     SI, AX

                Pop     CX

                Loop    S_GenerateCharacters1           ; Rows..

                Call    S_ResetSequencer

                Call    MouseUpdateEnable

                Pop     ES
                Pop     DS
                PopAD

                Ret

EndP            S_GenerateCharacters

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_DrawSmallBox Far

                Mov     AX, 30
                Push    AX
                Mov     AX, 25
                Push    AX
                Mov     AX, 49
                Push    AX
                Mov     AX, 27
                Push    AX
                Mov     AX, 3
                Push    AX
                Call    S_DrawBox
                Add     SP, 10

                Ret

EndP            S_DrawSmallBox

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_GetPaletteOffset Far

                Push    CS
                Pop     DS
                Mov     DX, Offset PaletteDefs

                Ret

EndP            S_GetPaletteOffset

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_UsePresetPalette Far

                Mov     AL, 48
                Mul     Byte Ptr [DS:SI+22]
                Mov     SI, AX

                Mov     AX, CS
                Mov     DS, AX
                Mov     ES, AX
                        Assume DS:Screen

                Add     SI, Offset PresetPalettes
                Mov     DI, Offset PaletteDefs
                Mov     CX, 48
                Rep     MovsB

                Call    S_SetPalette2

                Mov     AX, 1
                Ret

EndP            S_UsePresetPalette
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_DefineHiASCII Far

                Call    MouseUpdateDisable

                Call    S_SetSequencer


                Push    DS
                Push    ES

                Mov     AX, 0A000h
                Mov     DS, AX
                Mov     ES, AX

                Mov     AX, 16
                Mov     DI, CS:CharacterGenerationOffset
                Mov     SI, AX

                Xor     DX, DX

S_DefineHIASCII1:
                Mov     CX, AX
                Rep     MovsB

                Add     SI, AX
                Add     DI, AX
                Dec     DL
                JNZ     S_DefineHIASCII1

                Pop     ES
                Pop     DS

                Call    S_ResetSequencer

                Call    NewCharacterSet
                Call    MouseSecondSetDisable
                Call    MouseUpdateEnable

                Ret

EndP            S_DefineHiASCII

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            S_InvertCursor Far              ; AL = char, AH = mask.

                PushA
                Push    DS
                Push    ES

                Mov     SI, 0A000h
                Mov     DS, SI
                Mov     ES, SI

                Mov     SI, DX
                And     SI, 0FFh
                ShL     SI, 5
                Test    DH, 8
                JZ      S_InvertCursor2

                Add     SI, CS:CharacterGenerationOffset

S_InvertCursor2:
                ClI
                Call    S_SetSequencer
                Mov     CX, 8
                Mov     DI, (246*32)

S_InvertCursor1:
                LodsB
                Xor     AL, AH
                StosB
                Loop    S_InvertCursor1

                Call    S_ResetSequencer
                StI

                Pop     ES
                Pop     DS
                PopA
                Ret

EndP            S_InvertCursor

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment         ScreenData PARA Public 'Data'
                DB      1542 * 16 Dup (0)
EndS

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

EndS

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

End
