

ERROR           EQU     CX
DELTAERROR      EQU     BP
DELTAOFFSET     EQU     DX
OLDPOSITION             EQU     [SI+2Ch]
CURRENTPOSITION         EQU     [SI+4Ch]
CURRENTPOSITIONERROR    EQU     Word Ptr [SI+48h]
LOOPSTART               EQU     [SI+40h]
LOOPEND                 EQU     [SI+44h]
STEPVALUE               EQU     [SI+02h]
; STEPVALUEHIGH           EQU     Word Ptr [SI+04h]
DIRECTIONFLAG           EQU     Byte Ptr [SI+0Bh]

EXTRAOFFSET     =       MixResolution/8-2

IF MIXRESOLUTION GT 16
        RESOLUTIONSHIFT =       2
ELSE
        RESOLUTIONSHIFT =       1
ENDIF

IF STEREOENABLED
        RESOLUTIONSHIFT =       RESOLUTIONSHIFT+1
ENDIF

MixBufferOffset         DW      0

MixBlockSize            DW      0       ; Number of bytes to mix
                        DW      0       ; High order 0

PreMixFunction          DW      0
MixFunctionSeparate     DW      0       ; Function to separate blocks into 64k
                                        ; chunks.
MixFunctionSeparateBackwards DW 0       ; function to separate blocks into 64k
                                        ; in backwards steps.
MixFunction             DW      0       ; Function to mix samples

LastPage                DW      0       

MemoryType              DB      0
NumPages                DB      0
SampleLocation          DW      0       ; Either EMS Handle or Conventional
                                        ;  base segment
EMSPageFrame            DW      0

LoopCounter             DW      0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            MixNoLoop

                Call    [PreMixFunction]
                Call    PrepareSampleSegment

                Mov     EAX, STEPVALUE                  ; 16.16 value
                Mul     DWord Ptr [MixBlockSize]        ; 16.0 value
                                                        ; EDX:EAX = 32.16 value
                ShLD    EDX, EAX, 16                    ; EDX.AX = 32.16 value.
                                             ; EDX.AX = BytesToMix*StepValue

                Xor     CX, CX
                Mov     EBX, LOOPEND
                Sub     CX, CURRENTPOSITIONERROR
                SBB     EBX, CURRENTPOSITION ; EBX.CX = (End-CurrentPosition)
                JC      MixNoLoop3

                Cmp     EDX, EBX
                JL      MixNoLoop1
                JG      MixNoLoop2
                Cmp     AX, CX
                JB      MixNoLoop1

MixNoLoop2:
                                                ; Turn off
                Mov     EDX, EBX
                Mov     AX, CX

                Mov     Word Ptr [SI], 200h
                Test    Byte Ptr [SI+3Ah], 80h
                JNZ     MixNoLoop1

                Mov     BX, [SI+38h]
                And     Byte Ptr [BX], Not 4    ; Signify channel off

MixNoLoop1:
                Jmp     [MixFunctionSeparate]

MixNoLoop3:
                Mov     Word Ptr [SI], 200h
                Test    Byte Ptr [SI+3Ah], 80h
                JNZ     MixNoLoop4

                Mov     BX, [SI+38h]
                And     Byte Ptr [BX], Not 4    ; Signify channel off

MixNoLoop4:
                Ret

EndP            MixNoLoop

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            MixForwardsLoop

                Call    [PreMixFunction]
                Call    PrepareSampleSegment

MixForwardsLoopAgain:
                Mov     EAX, STEPVALUE                  ; 16.16 value
                Mul     DWord Ptr [MixBlockSize]        ; 16.0 value
                                                        ; EDX:EAX = 32.16 value
                ShLD    EDX, EAX, 16                    ; EDX.AX = 32.16 value.
                                             ; EDX.AX = BytesToMix*StepValue

                Xor     CX, CX
                Mov     EBX, LOOPEND
                Sub     CX, CURRENTPOSITIONERROR
                SBB     EBX, CURRENTPOSITION ; EBX.CX = (End-CurrentPosition)
                JC      UpdateMixForwardsLoop

                Cmp     EDX, EBX
                JL      MixForwardsLoop1
                JG      MixForwardsLoop2
                Cmp     AX, CX
                JB      MixForwardsLoop1

MixForwardsLoop2:
                Mov     EDX, EBX
                Mov     AX, CX

                Call    [MixFunctionSeparate]

UpdateMixForwardsLoop:
                Mov     EAX, CURRENTPOSITION
                Xor     EDX, EDX

                Mov     EBX, LOOPEND
                SUB     EAX, EBX
                SUB     EBX, LOOPSTART
                JBE     MixForwardsLoop3

                Div     EBX
                Add     EDX, LOOPSTART
                Mov     CURRENTPOSITION, EDX

;                 Cmp     EBX, 10000h
;                 JAE     MixForwardsLoop4

;                 Mov     AX, STEPVALUEHIGH
;                 Cmp     AX, BX
;                 JAE     MixForwardsLoop5

; MixForwardsLoop4:
                Cmp     MixBlockSize, 0
                JG      MixForwardsLoopAgain

MixForwardsLoop3:
                Ret

; MixForwardsLoop5:
;                 Xor     DX, DX
;                 Div     BX
;                 Mov     STEPVALUEHIGH, DX

;                 Cmp     MixBlockSize, 0
;                 JG      MixForwardsLoopAgain

;                 Ret

MixForwardsLoop1:
                Jmp     [MixFunctionSeparate]

EndP            MixForwardsLoop

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            MixPingPongLoop

                Call    [PreMixFunction]
                Call    PrepareSampleSegment

MixPingPongLoopAgain:
                Mov     EAX, STEPVALUE                  ; 16.16 value
                Mul     DWord Ptr [MixBlockSize]        ; 16.0 value
                                                        ; EDX:EAX = 32.16 value
                ShLD    EDX, EAX, 16                    ; EDX.AX = 32.16 value.
                                             ; EDX.AX = BytesToMix*StepValue

                Cmp     DIRECTIONFLAG, 0
                JNE     MixPingPongLoopBackwards1

MixPingPongLoopForwards1:
                Xor     CX, CX
                Mov     EBX, LOOPEND
                Sub     CX, CURRENTPOSITIONERROR
                SBB     EBX, CURRENTPOSITION ; EBX.CX = (End-CurrentPosition)
                JC      UpdateMixPingPongLoopForwards1

                Cmp     EDX, EBX
                JG      MixPingPongLoopForwards3
                JL      MixPingPongLoopForwards2

                Cmp     AX, CX
                JAE     MixPingPongLoopForwards3

MixPingPongLoopForwards2:
                Jmp     [MixFunctionSeparate]

MixPingPongLoopForwards3:
                Mov     EDX, EBX
                Mov     AX, CX
                Call    [MixFunctionSeparate]

UpdateMixPingPongLoopForwards1:
                Mov     EAX, CURRENTPOSITION
                Mov     EBX, LOOPEND
                Xor     EDX, EDX
                Sub     EAX, EBX
                Sub     EBX, LOOPSTART
                JBE     MixPingPongError

                Add     EBX, EBX
                Div     EBX

                ShR     EBX, 1

                Cmp     EDX, EBX
                JAE     MixPingPongLoopForwards4

                Mov     DIRECTIONFLAG, 1
                Mov     EAX, LOOPEND
                Sub     EAX, EDX
                Dec     EAX
                Mov     CURRENTPOSITION, EAX
                Neg     Word Ptr CURRENTPOSITIONERROR
                Jmp     MixPingPongLoopNext

MixPingPongLoopForwards4:
                Sub     EDX, EBX
                Add     EDX, LOOPSTART
                Mov     CURRENTPOSITION, EDX
                Jmp     MixPingPongLoopNext

MixPingPongLoopBackwards1:
                Mov     EBX, CURRENTPOSITION
                Mov     CX, CURRENTPOSITIONERROR

                Sub     CX, 0FFFFh
                SBB     EBX, LOOPSTART
                JC      UpdateMixPingPongLoopBackwards1

                Cmp     EDX, EBX
                JG      MixPingPongLoopBackwards3
                JL      MixPingPongLoopBackwards2

                Cmp     AX, CX
                JAE     MixPingPongLoopBackwards3

MixPingPongLoopBackwards2:
                Call    [MixFunctionSeparateBackwards]

MixPingPongError:
                Ret

MixPingPongLoopBackwards3:
                Mov     EDX, EBX
                Mov     AX, CX
                Call    [MixFunctionSeparateBackwards]

UpdateMixPingPongLoopBackwards1:
                Mov     EBX, LOOPEND
                Mov     EAX, LOOPSTART
                Sub     EBX, EAX
                JBE     MixPingPongError

                Sub     EAX, CURRENTPOSITION
                Xor     EDX, EDX
                Add     EBX, EBX
                Div     EBX

                ShR     EBX, 1

                Cmp     EDX, EBX
                JAE     MixPingPongLoopBackwards4

                Mov     DIRECTIONFLAG, 0
                Add     EDX, LOOPSTART
                Mov     CURRENTPOSITION, EDX
                Neg     Word Ptr CURRENTPOSITIONERROR
                Jmp     MixPingPongLoopNext

MixPingPongLoopBackwards4:
                Sub     EBX, EDX
                Add     EBX, LOOPEND
                Dec     EBX
                Mov     CURRENTPOSITION, EBX

MixPingPongLoopNext:
                Cmp     MixBlockSize, 0
                JG      MixPingPongLoopAgain

                Ret

EndP            MixPingPongLoop

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            UpdateNoLoop

                Mov     EAX, STEPVALUE                  ; 16.16 value
                Mul     DWord Ptr [MixBlockSize]        ; 16.0 value
                                                        ; EDX:EAX = 32.16 value
                ShLD    EDX, EAX, 16                    ; EDX.AX = 32.16 value.
                                             ; EDX.AX = BytesToMix*StepValue
                Add     CURRENTPOSITIONERROR, AX
                AdC     EDX, CURRENTPOSITION

                Cmp     EDX, LOOPEND
                JL      UpdateNoLoop1

UpdateNoLoop2:                                  ; Turn off
                Mov     Word Ptr [SI], 200h

                Test    Byte Ptr [SI+3Ah], 80h
                JNZ     UpdateNoLoop1

                Mov     BX, [SI+38h]
                And     Byte Ptr [BX], Not 4    ; Signify channel off
                Ret

UpdateNoLoop1:
                Mov     CURRENTPOSITION, EDX

                Ret

EndP            UpdateNoLoop

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            UpdateForwardsLoop

                Mov     EAX, STEPVALUE                  ; 16.16 value
                Mul     DWord Ptr [MixBlockSize]        ; 16.0 value
                                                        ; EDX:EAX = 32.16 value
                ShLD    EDX, EAX, 16                    ; EDX.AX = 32.16 value.
                                             ; EDX.AX = BytesToMix*StepValue
                Add     CURRENTPOSITIONERROR, AX
                AdC     EDX, CURRENTPOSITION

                Cmp     EDX, LOOPEND
                JL      UpdateForwardsLoop1

UpdateForwardsLoop2:                    ; Reset position...
                Mov     EBX, LOOPEND
                Mov     EAX, EDX
                Xor     EDX, EDX
                Sub     EAX, EBX
                Sub     EBX, LOOPSTART
                JZ      UpdateForwardsLoop1
                Div     EBX

                Add     EDX, LOOPSTART

UpdateForwardsLoop1:
                Mov     CURRENTPOSITION, EDX
                Ret

EndP            UpdateForwardsLoop

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            UpdatePingPongLoop

                Mov     EAX, STEPVALUE                  ; 16.16 value
                Mul     DWord Ptr [MixBlockSize]        ; 16.0 value
                                                        ; EDX:EAX = 32.16 value
                ShLD    EDX, EAX, 16                    ; EDX.AX = 32.16 value.
                                             ; EDX.AX = BytesToMix*StepValue

                Cmp     DIRECTIONFLAG, 0
                JNE     UpdatePingPongLoopBackwards1

UpdatePingPongLoopForwards1:
                Add     CURRENTPOSITIONERROR, AX
                AdC     EDX, CURRENTPOSITION

                Cmp     EDX, LOOPEND
                JA      UpdatePingPongLoopForwards2

                Mov     CURRENTPOSITION, EDX
                Ret

UpdatePingPongLoopForwards2:
                Mov     EAX, EDX
                Mov     EBX, LOOPEND
                Xor     EDX, EDX
                Sub     EAX, EBX
                Sub     EBX, LOOPSTART
                Add     EBX, EBX
                Div     EBX

                ShR     EBX, 1

                Cmp     EDX, EBX
                JAE     UpdatePingPongLoopForwards3

                Mov     DIRECTIONFLAG, 1
                Mov     EAX, LOOPEND
                Sub     EAX, EDX
                Dec     EAX
                NEG     CURRENTPOSITIONERROR
                Mov     CURRENTPOSITION, EAX
                Ret

UpdatePingPongLoopForwards3:
                Sub     EDX, EBX
                Add     EDX, LOOPSTART
                Mov     CURRENTPOSITION, EDX
                Ret

UpdatePingPongLoopBackwards1:
                Sub     CURRENTPOSITIONERROR, AX
                Mov     ECX, CURRENTPOSITION
                SBB     ECX, EDX

                Cmp     ECX, LOOPSTART
                JLE     UpdatePingPongLoopBackwards2

                Mov     CURRENTPOSITION, ECX
                Ret

UpdatePingPongLoopBackwards2:
                Mov     EAX, LOOPSTART
                Mov     EBX, LOOPEND
                Xor     EDX, EDX
                Sub     EBX, EAX
                Sub     EAX, ECX
                Add     EBX, EBX
                Div     EBX

                ShR     EBX, 1

                Cmp     EDX, EBX
                JAE     UpdatePingPongLoopBackwards3

                Mov     DIRECTIONFLAG, 0
                Add     EDX, LOOPSTART
                NEG     CURRENTPOSITIONERROR
                Mov     CURRENTPOSITION, EDX
                Ret

UpdatePingPongLoopBackwards3:
                Sub     EBX, EDX
                Add     EBX, LOOPEND
                Dec     EBX
                Mov     CURRENTPOSITION, EBX

                Ret

EndP            UpdatePingPongLoop

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            PrepareSampleSegment            ; Sets up sample mixing segment

                Mov     ES, SongDataArea

                Mov     BX, [SI+34h]
                Mov     EAX, [ES:BX+48h]

                Mov     DWord Ptr MemoryType, EAX ; Writes numpages & Sample
                                                  ;  location also.
                Mov     LastPage, 0FFFFh

                Ret

EndP            PrepareSampleSegment

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SetSampleSegment        ; Given EDI, Returns ES

                Mov     CX, Word Ptr CS:MemoryType

                Cmp     CL, 2
                JNE     SetSampleSegment1

                Push    EAX
                Push    EDX

                Mov     EBX, EDI
                ShR     EBX, 14
                And     EDI, 16383

                Cmp     BX, LastPage
                JE      SetSampleEMS2

                Mov     LastPage, BX
                Mov     DX, SampleLocation      ; EMS handle
                                                ; BX = starting page required
                Mov     AL, 3
                Add     BX, 3

                Cmp     BL, CH
                JBE     SetSampleEMS1

                Sub     CH, BL
                Add     BL, CH
                Add     AL, CH
                JNC     SetSampleEMS2

SetSampleEMS1:
                Mov     AH, 44h
                Int     67h

                Dec     BX
                Dec     AL
                JNS     SetSampleEMS1

SetSampleEMS2:
                Mov     ES, EMSPageFrame

                Pop     EDX
                Pop     EAX

                Ret

SetSampleSegment1:                      ; Conventional memory
                Mov     ECX, EDI
                And     EDI, 15
                ShR     ECX, 4
                Add     CX, SampleLocation
                Mov     ES, CX

                Ret

EndP            SetSampleSegment

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SetBackSampleSegment        ; Given BX = frame, Returns ES

                Mov     CX, Word Ptr CS:MemoryType

                Cmp     CL, 2
                JNE     SetBackSampleSegment1

                Push    EAX
                Push    EDX

                Cmp     BX, LastPage
                JE      SetBackSampleEMS2

                Mov     LastPage, BX
                Mov     DX, SampleLocation      ; EMS handle
                                                ; BX = starting page required
                Mov     AL, 3
                Add     BX, 3

                Cmp     BL, CH
                JBE     SetBackSampleEMS1

                Sub     CH, BL
                Add     BL, CH
                Add     AL, CH
                JNC     SetBackSampleEMS2

SetBackSampleEMS1:
                Mov     AH, 44h
                Int     67h

                Dec     BX
                Dec     AL
                JNS     SetBackSampleEMS1

SetBackSampleEMS2:
                Mov     ES, EMSPageFrame

                Pop     EDX
                Pop     EAX

                Ret

SetBackSampleSegment1:                      ; Conventional memory
                ShL     BX, 10
                Add     BX, SampleLocation
                Mov     ES, BX

                Ret

EndP            SetBackSampleSegment

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            MFS8Bit                         ; EDX:AX = 32.16 bytes offset.
                                                ;          to mix


                Push    AX
                Push    EDX

                Mov     EDI, CURRENTPOSITION
                Call    SetSampleSegment

                Xor     CX, CX  ; EDI = CurrentPosition & (2^14-1)

                Mov     EBX, 0FFFEh

                Sub     CX, CURRENTPOSITIONERROR
                SBB     EBX, EDI
                                ; EBX:CX = 64k-(CurrentPosition & (2^14-1))
                                ; EDX:AX = blocksize
                Cmp     EDX, EBX
                JBE     MFS8Bit1

                Mov     EDX, EBX
                Mov     AX, CX

MFS8Bit1:
                                ; Now to calculate bytes to mix...
                ShL     EAX, 16
                SHRD    EAX, EDX, 16
                ShR     EDX, 16         ; EDX:EAX = (16)32.16 offset

                Mov     EBX, STEPVALUE
                Cmp     EDX, EBX
                JAE     MFS8Bit2

                Div     EBX
                Add     EDX, 0FFFFFFFFh
                AdC     EAX, 0          ; EAX = no of bytes to mix
                JZ      MFS8Bit2

                Push    EAX

                Xor     ECX, ECX
                Mov     DELTAOFFSET, [SI+4]   ; Stepvalue
                Mov     DELTAERROR, [SI+2]    ; Stepvalue
                Mov     CX, CURRENTPOSITIONERROR

                Push    DS
                Push    SI

                Mov     SI, MixBufferOffset
                Mov     DS, MixSegment
                Call    [MixFunction]

                Pop     SI
                Pop     DS
                Pop     ECX
                Jmp     MFS8Bit3

MFS8Bit2:
;                Xor     ECX, ECX
                Pop     EDX
                Pop     AX

                Ret

MFS8Bit3:
                        ; Update pointers...
                Mov     EAX, STEPVALUE
                Mul     ECX

                Sub     MixBlockSize, CX
                ShL     CX, RESOLUTIONSHIFT
                Add     MixBufferOffset, CX

                                        ; EDX:EAX = offset mixed (32.16)
                ShLD    EDX, EAX, 16
                Mov     BX, AX
                Mov     ECX, EDX        ; ECX:BX = offset mixed

                Add     CURRENTPOSITIONERROR, BX
                AdC     CURRENTPOSITION, ECX

                Pop     EDX
                Pop     AX

                Sub     AX, BX
                SBB     EDX, ECX

                JG      MFS8Bit

                Ret

EndP            MFS8Bit

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            MFS16Bit

                Push    AX
                Push    EDX

                Mov     EDI, CURRENTPOSITION
                Add     EDI, EDI
                Call    SetSampleSegment

                ShR     EDI, 1          ; EDI = number of samples.

                Xor     CX, CX

                Mov     EBX, 7FFEh

                Sub     CX, CURRENTPOSITIONERROR
                SBB     EBX, EDI

                Cmp     EDX, EBX
                JBE     MFS16Bit1

                Mov     EDX, EBX
                Mov     AX, CX

MFS16Bit1:
                                ; Now to calculate bytes to mix...
                ShL     EAX, 16
                SHRD    EAX, EDX, 16
                ShR     EDX, 16         ; EDX:EAX = (16)32.16 offset

                Mov     EBX, STEPVALUE
                Cmp     EDX, EBX
                JAE     MFS16Bit2

                Div     EBX
                Add     EDX, 0FFFFFFFFh
                AdC     EAX, 0          ; EAX = no of bytes to mix
                JZ      MFS16Bit2

                Push    EAX

                Xor     ECX, ECX
                Mov     DELTAOFFSET, [SI+4]              ; Stepvalue
                Mov     DELTAERROR, [SI+2]              ; Stepvalue
                Mov     CX, CURRENTPOSITIONERROR

                Push    DS
                Push    SI

                Mov     SI, MixBufferOffset
                Mov     DS, MixSegment
                Call    [MixFunction]

                Pop     SI
                Pop     DS
                Pop     ECX
                Jmp     MFS16Bit3

MFS16Bit2:
;                Xor     ECX, ECX
                Pop     EDX
                Pop     AX
                Ret

MFS16Bit3:
                        ; Update pointers...
                Mov     EAX, STEPVALUE
                Mul     ECX

                Sub     MixBlockSize, CX
                ShL     CX, RESOLUTIONSHIFT
                Add     MixBufferOffset, CX

                                        ; EDX:EAX = offset mixed (32.16)
                ShLD    EDX, EAX, 16
                Mov     BX, AX
                Mov     ECX, EDX        ; ECX:BX = offset mixed

                Add     CURRENTPOSITIONERROR, BX
                AdC     CURRENTPOSITION, ECX

                Pop     EDX
                Pop     AX

                Sub     AX, BX
                SBB     EDX, ECX

                JG      MFS16Bit

                Ret

EndP            MFS16Bit

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            MBS8Bit

                Push    AX
                Push    EDX                     ; EDX:AX = 32.16 blocksize

                Mov     EDI, CURRENTPOSITION
                Mov     EBX, EDI
                Add     EBX, 2
                ShR     EBX, 14                 ; BX = frame

                Sub     BX, 3
                JNC     MBS8Bit4

                Xor     BX, BX

MBS8Bit4:
                Mov     ECX, EBX
                ShL     ECX, 14
                Sub     EDI, ECX

                Call    SetBackSampleSegment

                Mov     ECX, CURRENTPOSITION
                Mov     BX, CURRENTPOSITIONERROR
                And     ECX, 16383
                Add     ECX, 0BFFEh
                Cmp     ECX, EDX
                JG      MBS8Bit1
                JL      MBS8Bit5
                Cmp     BX, AX
                JG      MBS8Bit1

MBS8Bit5:
                Mov     EDX, ECX
                Mov     AX, BX

MBS8Bit1:

                                ; Now to calculate bytes to mix...
                ShL     EAX, 16
                SHRD    EAX, EDX, 16
                ShR     EDX, 16         ; EDX:EAX = (16)32.16 offset

                Mov     EBX, STEPVALUE
                Cmp     EDX, EBX
                JAE     MBS8Bit2

                Div     EBX
                Add     EDX, 0FFFFFFFFh
                AdC     EAX, 0          ; EAX = no of bytes to mix
                JZ      MBS8Bit2

                Push    EAX

                Xor     ECX, ECX
                Mov     EBP, [SI+2]              ; Stepvalue
                Neg     EBP
                ShLD    EDX, EBP, 16

                Mov     CX, CURRENTPOSITIONERROR

                Push    DS
                Push    SI

                Mov     SI, MixBufferOffset
                Mov     DS, MixSegment
                Call    [MixFunction]

                Pop     SI
                Pop     DS
                Pop     ECX
                Jmp     MBS8Bit3

MBS8Bit2:
;                Xor     ECX, ECX
                Pop     EDX
                Pop     AX
                Ret

MBS8Bit3:
                        ; Update pointers...
                Mov     EAX, STEPVALUE
                Mul     ECX

                Sub     MixBlockSize, CX
                ShL     CX, RESOLUTIONSHIFT
                Add     MixBufferOffset, CX

                                        ; EDX:EAX = offset mixed (32.16)
                ShLD    EDX, EAX, 16
                Mov     BX, AX
                Mov     ECX, EDX        ; ECX:BX = offset mixed

                Sub     CURRENTPOSITIONERROR, BX
                SBB     CURRENTPOSITION, ECX

                Pop     EDX
                Pop     AX

                Sub     AX, BX
                SBB     EDX, ECX

                JG      MBS8Bit

                Ret

EndP            MBS8Bit

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            MBS16Bit

                Push    AX
                Push    EDX                     ; EDX:AX = 32.16 blocksize

                Mov     EDI, CURRENTPOSITION
                Mov     EBX, EDI
                Add     EBX, 4
                ShR     EBX, 13                 ; BX = frame

                Sub     BX, 3
                JNC     MBS16Bit4

                Xor     BX, BX

MBS16Bit4:
                Mov     ECX, EBX
                ShL     ECX, 13
                Sub     EDI, ECX

                Call    SetBackSampleSegment

                Mov     ECX, CURRENTPOSITION
                Mov     BX, CURRENTPOSITIONERROR
                And     ECX, 8191
                Add     ECX, 05FFEh
                Cmp     ECX, EDX
                JG      MBS16Bit1
                JL      MBS16Bit5
                Cmp     BX, AX
                JG      MBS16Bit1

MBS16Bit5:
                Mov     EDX, ECX
                Mov     AX, BX

MBS16Bit1:

                                ; Now to calculate bytes to mix...
                ShL     EAX, 16
                SHRD    EAX, EDX, 16
                ShR     EDX, 16         ; EDX:EAX = (16)32.16 offset

                Mov     EBX, STEPVALUE
                Cmp     EDX, EBX
                JAE     MBS16Bit2

                Div     EBX
                Add     EDX, 0FFFFFFFFh
                AdC     EAX, 0          ; EAX = no of bytes to mix
                JZ      MBS16Bit2

                Push    EAX

                Xor     ECX, ECX
                Mov     EBP, [SI+2]              ; Stepvalue
                Neg     EBP
                ShLD    EDX, EBP, 16

                Mov     CX, CURRENTPOSITIONERROR

                Push    DS
                Push    SI

                Mov     SI, MixBufferOffset
                Mov     DS, MixSegment
                Call    [MixFunction]

                Pop     SI
                Pop     DS
                Pop     ECX
                Jmp     MBS16Bit3

MBS16Bit2:
;                Xor     ECX, ECX
                Pop     EDX
                Pop     AX
                Ret

MBS16Bit3:
                        ; Update pointers...
                Mov     EAX, STEPVALUE
                Mul     ECX

                Sub     MixBlockSize, CX
                ShL     CX, RESOLUTIONSHIFT
                Add     MixBufferOffset, CX

                                        ; EDX:EAX = offset mixed (32.16)
                ShLD    EDX, EAX, 16
                Mov     BX, AX
                Mov     ECX, EDX        ; ECX:BX = offset mixed

                Sub     CURRENTPOSITIONERROR, BX
                SBB     CURRENTPOSITION, ECX

                Pop     EDX
                Pop     AX

                Sub     AX, BX
                SBB     EDX, ECX

                JG      MBS16Bit

                Ret

EndP            MBS16Bit

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            ReportError

                Ret

EndP            ReportError

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

