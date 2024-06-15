;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Fast Fourier Transform Module                                               ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                        Jumps
                        .386P
                        .387

include switch.inc

IF SPECTRUMANALYSER

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Externals                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Segment         Object1 BYTE Public 'Data'
EndS
Segment         DiskData PARA Public 'Data'
EndS

        Extrn   O1_FourierDisplay:Far

        Extrn   M_Object1List:Far

        Extrn   Music_GetWaveForm:Far

        Extrn   S_InitScreen:Far
        Extrn   S_SetDirectMode:Far

        Global  MouseUpdateEnable:Far, MouseUpdateDisable:Far
        Extrn   VESA_Detect:Far
        Extrn   VESA_SetMode:Far
        Extrn   VESA_SetBlock:Far
        Extrn   InitMouse:Far, UnInitMouse:Far
        Extrn   S_DefineSmallNumbers:Far

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ


Segment                 Infopage BYTE Public 'Code' USE16
                        Assume  CS:Infopage, DS:Nothing, ES:Nothing

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Variables                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Functions                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc    Fourier_CreateTable Far         ; Fills in ES:16384
Public  Fourier_CreateTable

        Mov     DI, 20480
        Xor     CX, CX

Fourier_CreateTable1:
        Mov     DX, 11

        Xor     AX, AX
        Mov     BX, CX

Fourier_CreateTable2:
        ShR     BX, 1
        AdC     AX, AX

        Dec     DX
        JNZ     Fourier_CreateTable2

        ShL     AX, 3
        StosW

        Inc     CX
        Cmp     CX, 2048
        JB      Fourier_CreateTable1

        Ret

EndP    Fourier_CreateTable

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Const1_2048     DD      3C000000h
ConstHalf       DD      3F000000h
Steps           DW      0
CurrentOffset   DW      0

Proc    Fourier_Transform Far
Public  Fourier_Transform
  ; Given DS:16384->DS:20480 = 2048 16-bit signed int samples
  ; Given DS:20480->24576 = relocation table
  ; Given DS:0->DS:16384 = working area

  ; Returns: DS:24576 -> 16-bit table of frequencies. (first 1024)

        Push    DiskData
        Pop     DS

        Push    DS
        Pop     ES

        Mov     CX, 2048        ; Prepare 2048 samples
        Mov     SI, 16384
        Xor     EDX, EDX

Fourier_TransformRelocate1:
        FILd    Word Ptr [SI]
        Mov     DI, [SI+4096]
        LodsW           ; Add SI, 2
        Mov     [DI+4], EDX
        FStP    DWord Ptr [DI]
        Dec     CX
        JNZ     Fourier_TransformRelocate1

; Samples relocated - now for transform
        Mov     CX, 1

Fourier_Transform1:
        Mov     [DS:24576], CX  ; Store count

        FLdZ
        FLd1    ; CurrentPhase.r, CurrentPhase.i

        FLdPi
        FChs
        FIDiv   Word Ptr [DS:24576]     ; -Pi/Step
        FSinCos                         ; deltaphase.r, deltaphase.i, currentphase.r, currentphase.i

        Xor     DX, DX

Fourier_Transform2:
        Mov     SI, DX  ; SI = k
        Mov     DI, CX  ; DI = k+i
        Mov     BX, CX  ; BX = i*2
        Add     DI, DX
        ShL     SI, 3   ; SI = k*8
        ShL     DI, 3   ; DI = (k+i)*8
        ShL     BX, 4   ; BX = i*8*2

Fourier_Transform3:
        FLd     DWord Ptr [DI]
        FMul    ST, ST(3)       ; cr*sr
        FLd     DWord Ptr [DI+4]
        FMul    ST, ST(4)       ; cr*si, cr*sr, dr, di, cr, ci
        FLd     DWord Ptr [DI]
        FMul    ST, ST(6)
        FLd     DWord Ptr [DI+4]
        FMul    ST, ST(7)       ; ci*si, ci*sr, cr*si, cr*sr, dr, di, cr, ci
        FXCh
        FAddP   ST(2), ST
        FSubP   ST(2), ST        ; tempi, tempr, dr, di, cr, ci
        FLd     DWord Ptr [SI+4] ; ri, tempi, tempr, dr, di, cr, ci
        FAdd    ST, ST(1)
        FLd     DWord Ptr [SI]
        FAdd    ST, ST(3)        ; rr, ri, tempi, tempr, dr, di, cr, ci
        FXCh    ST(3)            ; tempr, ri, tempi, rr, dr, di, cr, ci
        FSubR   DWord Ptr [SI]   ; kr, ri, tempi, rr, dr, di, cr, ci
        FXCh    ST(2)
        FSubR   DWord Ptr [SI+4] ; ki, ri, kr, rr, dr, di, cr, ci
        FXCh    ST(3)            ; rr, ri, kr, ki, dr, di, cr, ci
        FStP    DWord Ptr [SI]
        FStP    DWord Ptr [SI+4]
        FStP    DWord Ptr [DI]
        FStP    DWord Ptr [DI+4]

        Add     SI, BX
        Add     DI, BX

        Cmp     SI, 16384
        JB      Fourier_Transform3

; Left with deltaphase.r, deltaphase.i, currentphase.r, currentphase.i
        FLd     ST              ; d.r, d.r, d.i, c.r, c.i
        FMul    ST, ST(3)       ; d.r*c.r, d.r, d.i, c.r, c.i
        FXCh    ST(3)           ; c.r, d.r, d.i, d.r*c.r, c.i
        FMul    ST, ST(2)       ; c.r*d.i, d.r, d.i, d.r*c.r, c.i
        FLd     ST(2)           ; d.i, c.r*d.i, d.r, d.i, d.r*c.r, c.i
        FMul    ST, ST(5)       ; d.i*c.i, c.r*d.i, d.r, d.i, d.r*c.r, c.i
        FSubP   ST(4), ST       ; c.r*d.i, d.r, d.i, newr, c.i
        FXCh    ST(4)           ; c.i, d.r, d.i, newr, c.r*d.i
        FMul    ST, ST(1)       ; c.i*d.r, d.r, d.i, newr, c.r*d.i
        FAddP   ST(4), ST       ; d.r, d.i, newr, newi

        Inc     DX
        Cmp     DX, CX
        JB      Fourier_Transform2

        FComPP
        FComPP

        ShL     CX, 1
        Cmp     CX, 2048
        JB      Fourier_Transform1

; Cleanup code.
        Mov     CX, 1024
        Xor     SI, SI
        Mov     DI, 24576

        FLd     CS:Const1_2048
;        FMul    ST, ST         ; Include if no sqrt
;        FMul    ST, ST

Fourier_CalculateMagnitudes1:           ; Could be interleaved, but speed isn't
                                        ; *really* a problem.
        FLd     DWord Ptr [SI]
        FMul    ST, ST
        FLd     DWord Ptr [SI+4]
        FMul    ST, ST
        FAdd
        FSqrt
        FMul    ST, ST(1)

        FStP    DWord Ptr [DI]

        Add     SI, 8
        Add     DI, 4

        Dec     CX
        JNZ     Fourier_CalculateMagnitudes1

        FStP    ST

        Ret

EndP    Fourier_Transform

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

FourierPalette  DB      0

Proc    Fourier_ChangePalette Far
Public  Fourier_ChangePalette

        Xor     [CS:FourierPalette], 1
        Call    Fourier_SetPalette

        Mov     AX, 1
        Ret

EndP    Fourier_ChangePalette

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc    Fourier_SetPalette

        Mov     DX, 3C8h
        Xor     AL, AL
        Out     DX, AL
        Inc     DX

        Cmp     [CS:FourierPalette], 0
        JE      Fourier_PaletteB

        Mov     CX, 64

Fourier_PaletteA1:
        Xor     AL, AL
        Out     DX, AL
        Out     DX, AL
        Mov     AL, 64
        Sub     AL, CL
        ShR     AL, 1
        Out     DX, AL
        Loop    Fourier_PaletteA1

        Mov     CX, 64

Fourier_PaletteA2:
        Xor     AL, AL
        Out     DX, AL
        Mov     BL, 64
        Sub     BL, CL
        ShR     BL, 1
        Mov     AL, BL
        Out     DX, AL
        Mov     AL, BL
        Add     AL, 32
        Out     DX, AL
        Loop    Fourier_PaletteA2

        Mov     CX, 128

Fourier_PaletteA3:
        Mov     AL, 128
        Sub     AL, CL
        ShR     AL, 1
        Out     DX, AL
        ShR     AL, 1
        Add     AL, 32
        Out     DX, AL
        Mov     AL, 63
        Out     DX, AL
        Loop    Fourier_PaletteA3

        Ret

Fourier_PaletteB:
        Mov     CX, 32
        Xor     BX, BX

Fourier_PaletteB1:
        Xor     AL, AL
        Out     DX, AL
        Out     DX, AL
        Mov     AL, BL
        Out     DX, AL
        Add     BX, 2
        Loop    Fourier_PaletteB1

        Mov     CX, 32
        Xor     BL, BL

Fourier_PaletteB2:
        Mov     AL, BL
        Out     DX, AL
        Xor     AL, AL
        Out     DX, AL
        Mov     AL, 63
        Out     DX, AL
        Add     BX, 2

        Loop    Fourier_PaletteB2

        Mov     CX, 32

Fourier_PaletteB3:
        Mov     AL, 63
        Out     DX, AL
        Xor     AL, AL
        Out     DX, AL
        Mov     AL, CL
        Add     AL, AL
        Dec     AL
        Out     DX, AL
        Loop    Fourier_PaletteB3

        Mov     CX, 32
        Xor     BX, BX

Fourier_PaletteB4:
        Mov     AL, 63
        Out     DX, AL
        Mov     AL, BL
        Out     DX, AL
        Xor     AL, AL
        Out     DX, AL
        Add     BX, 2
        Loop    Fourier_PaletteB4

        Mov     CX, 128
        Xor     BX, BX

Fourier_PaletteB5:
        Mov     AL, 63
        Out     DX, AL
        Out     DX, AL
        Mov     AL, BL
        ShR     AL, 1
        Out     DX, AL
        Inc     BX
        Loop    Fourier_PaletteB5

        Ret

EndP    Fourier_SetPalette

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ScreenWidth     DW      0
ScreenHeight    DW      0

Proc    Fourier_Start Far
Public  Fourier_Start

        Push    DiskData
        Pop     ES
        Xor     DI, DI
        Mov     CX, 32768
        Xor     AX, AX
        Rep     StosW           ; Clear data area first.

        Call    Fourier_CreateTable

        Mov     AL, 1   ; Prevent S_Update calls.
        Call    S_SetDirectMode

        Call    VESA_Detect
        JC      Fourier_End

        Mov     AX, 107h

Fourier_NextMode:
        Call    VESA_SetMode    ; Returns CX = width, DX = height
        JNC     Fourier_ModeOK

        Sub     AL, 2
        JC      Fourier_End
        Jmp     Fourier_NextMode

Fourier_ModeOK:
        Mov     ScreenWidth, CX
        Mov     ScreenHeight, DX

        Call    Fourier_SetPalette

        Mov     CurrentOffset, 0

        Call    UnInitMouse
        Mov     DI, Offset O1_FourierDisplay
        Xor     CX, CX
        Call    M_Object1List

Fourier_End:
        Call    S_InitScreen
        Call    InitMouse
        Call    S_DefineSmallNumbers

        Ret

EndP    Fourier_Start

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc    Fourier_PreDrawScreen Far
Public  Fourier_PreDrawScreen

        Ret

EndP    Fourier_PreDrawScreen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ControlWord     DW      003Fh

Proc    Fourier_DrawScreen Far
Public  Fourier_DrawScreen

        FLdCW   [CS:ControlWord]

        Push    DiskData
        Pop     ES
        Mov     DI, 16384
        Call    Music_GetWaveForm
        JC      Fourier_DrawScreen1

        Push    ES
        Pop     DS
        Call    Fourier_Transform       ; Have table at DS:0

        Mov     CX, 1024
        Mov     SI, 24576

Fourier_ConvertToInteger:
        FLd     DWord Ptr [SI]
        FIStP   DWord Ptr [SI]
        Mov     EDX, [SI]
        ShR     EDX, 6
        Cmp     EDX, 255
        JB      Fourier_DrawScreen3

        Mov     DL, 255

Fourier_DrawScreen3:
        Mov     [SI], DL
        Add     SI, 4
        Loop    Fourier_ConvertToInteger

        Xor     AX, AX
        Call    VESA_SetBlock

        Push    0A000h
        Pop     ES
        Mov     DI, CurrentOffset
        Mov     CX, ScreenHeight
        Sub     CX, 64
        Mov     BX, ScreenWidth
        LEA     SI, [24576+ECX*4]

Fourier_DrawScreen2:
        Mov     DL, [SI]
        Mov     [ES:DI], DL

        Sub     SI, 4
        Add     DI, BX
        JNC     Fourier_DrawScreen4

        Inc     AX
        Call    VESA_SetBlock

Fourier_DrawScreen4:
        Dec     CX
        JNZ     Fourier_DrawScreen2

        Mov     AX, CurrentOffset
        Inc     AX
        Xor     DX, DX
        Div     BX
        Mov     CurrentOffset, DX

; Now to draw volume bars.

        Mov     CX, 64
        And     EBX, 0FFFFh

        Mov     BP, BX
        Xor     EDI, EDI
        Cmp     BP, 1024
        JB      Fourier_DrawBars2

        Mov     DI, BX
        Mov     BP, 1024
        Sub     DI, BP
        ShR     DI, 1

Fourier_DrawBars2:

Fourier_DrawBars1:
        Push    BX
        Push    CX
        Push    EDI

        Xor     EAX, EAX

        Mov     AX, ScreenHeight
        Sub     AX, CX
        Mul     EBX     ; EAX = offset.
        Add     EAX, EDI

        Mov     DI, AX
        ShR     EAX, 16
        Call    VESA_SetBlock

        Mov     DX, BP
        Mov     BL, CL
        Dec     BL
        ShL     BL, 2   ; BL = 0->256

        Push    AX
        Mov     SI, 24580

Fourier_DrawBars3:
        Cmp     BL, Byte Ptr [SI]
        SBB     AL, AL

        Mov     [ES:DI], AL

        Add     DI, 1
        JNC     Fourier_DrawBars4

        Pop     AX
        Inc     AX
        Call    VESA_SetBlock
        Push    AX

Fourier_DrawBars4:
        Add     SI, 4
        Dec     DX
        JNZ     Fourier_DrawBars3

        Pop     AX

        Pop     EDI
        Pop     CX
        Pop     BX
        Loop    Fourier_DrawBars1

Fourier_DrawScreen1:
        Ret

EndP    Fourier_DrawScreen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc    Fourier_IdleList Far
Public  Fourier_IdleList

        Mov     AX, 1
        Ret

EndP    Fourier_IdleList

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc    Fourier_PostFunction Far
Public  Fourier_PostFunction

        Cmp     CX, 101h
        JE      Fourier_PostFunction2

Fourier_PostFunction1:
        Xor     AX, AX
        Ret

Fourier_PostFunction2:
        Mov     AX, 4
        Ret

EndP    Fourier_PostFunction

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ


EndS

ENDIF

End

