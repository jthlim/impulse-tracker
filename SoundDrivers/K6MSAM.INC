;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Align 4
include q.inc
FilterParameters        DB      64 Dup (07Fh), 64 Dup (0)
Const2048               DD      16384.0
FreqMultiplier          DD      3A9F7867h   ; = 1/(2*PI*110.0*2^0.25)
FreqParameterMultiplier DD      0B92AAAAAh  ; = -1/(24*256)

NUMBEROFFILTERBANDS     =       4

IF OUTPUTFILTERENABLED
LastFilter              DD      NUMBEROFFILTERBANDS*2 Dup (0) ; 4 stereo values
FilterCoefficients      DD      NUMBEROFFILTERBANDS*2 Dup (0)
FilterVolumes           DD      NUMBEROFFILTERBANDS   Dup (0)
ENDIF

FilterFreqValue         DW      0
NewControlWord          DW      7Fh

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            MixSamples      ; Given DS:SI = info tables, CX = numchannels
                Assume DS:Nothing

                                ; 1. Clean buffer
                                ;    + update variables
                                ; 2. Update parameters
                                ; 3. Mix func
                                ; 4. Return

                Push    CX

                Mov     CX, BytesToMix
                Mov     ES, CS:MixSegment
                Mov     DI, DMABUFFERLENGTH*2+80
                Xor     EAX, EAX
                Mov     DX, CX
                Add     CX, CX

                Mov     CS:MixTransferOffset, DI

                Cmp     CS:Stereo, 0
                JE      CS:MixSamples1

                Mov     DX, CX

MixSamples1:
                Rep     StosD
                Mov     CS:MixTransferRemaining, DX

                Pop     CX

MixSamples2:
                Test    Byte Ptr [SI], 1
                JZ      MixSamplesEnd2

                Cmp     Byte Ptr [SI+36h], 100
                JE      MixSamplesEnd2

                Push    CX
                Mov     CX, [SI]

                Test    CH, 2
                JZ      MixSamplesNoStop

                And     Byte Ptr [SI], Not 1

                Cmp     MixMode, 2
                JB      MixSamplesEnd

                Mov     DWord Ptr [SI+0Ch], 0
                Jmp     MixModeCommon

MixSamplesNoStop:
                Test    CL, 20h         ; New freq?
                JZ      MixSamples5

                Mov     AX, [SI+10h]
                Mov     DX, [SI+12h]
                Mov     BX, MixSpeed
                Cmp     DX, BX
                JAE     MixSamplesHandleError

                Div     BX
                ShL     EAX, 16
                Xor     AX, AX
                Div     BX
                Mov     STEPVALUE, EAX

MixSamples4:
                Test    CH, 1
                JZ      MixSamples5

                Xor     EAX, EAX
                Mov     [SI+3Ch], AX            ; For filter.
                Mov     [SI+6Eh], AX

                Mov     DWord Ptr [SI+1Ch], EAX         ; Current Volume = 0
                                                        ; for volume sliding.
                Mov     [SI+06h], DX
                Mov     [SI+5Eh], AX
                Mov     [SI+7Eh], AX

MixSamples5:
                Test    CX, 8540h               ; New volume or panning?
                JZ      MixSamplesMix

                Mov     AX, 4*60

                Test    CH, 8                   ; Muted?
                JZ      MixMMXNoMute

                Xor     EDX, EDX
                Mov     [SI+06h], DX
                Mov     [SI+0Ch], EDX
                Mov     [SI+5Eh], DX
                Mov     [SI+1Ch], EDX
                Mov     [SI+6Eh], DX
                Mov     [SI+3Ch], DX
                Mov     [SI+7Eh], DX

                Xor     BX, BX
                Mov     BL, [SI+3Ah]

                Test    BL, BL
                JS      MixModeCommon1

                Mov     DL, [CS:FilterParameters+BX]
                Mov     BL, [CS:FilterParameters+BX+64]

                Mov     [SI+5Bh], DL
                Mov     [SI+3Fh], BL

                Jmp     MixModeCommon1

MixMMXNoMute:
                Xor     BX, BX
                Mov     BL, [SI+3Ah]

                Test    BL, BL          ; Disowned? Then use channel filters.
                JNS     MixGetChannelFilters

                Mov     BL, [SI+3Fh]
                Jmp     MixChannelFilters

MixGetChannelFilters:
                                        ; Filter = [FilterParameters+BX]
                                        ;      Q = [FilterParameters+BX+64]

                Mov     AL, [CS:FilterParameters+BX]    ; AX = Filter
                Mov     BL, [CS:FilterParameters+BX+64] ; BX = Q

; If the values are different, then force recalculate volume. (and hence mixmode)

                Cmp     [SI+5Bh], AL
                JE      MixChannelFiltersSame
                Cmp     [SI+3Fh], BL
                JE      MixChannelFiltersSame

                Mov     DWord Ptr [SI+0Ch], 0

MixChannelFiltersSame:
                Mov     [SI+5Bh], AL
                Mov     [SI+3Fh], BL

MixChannelFilters:
                Cmp     MixMode, 3
                JNE     MixMMXNoFilters

                Mov     AL, [SI+3Eh]
                Mul     Byte Ptr [SI+5Bh]

                Mov     CS:FilterFreqValue, AX

                Cmp     AX, 127*255
                JNE     MixChannelFiltersOK
                Test    BL, BL
                JZ      MixMMXNoFilters

MixChannelFiltersOK:
                ShL     BX, 2

                FNInit
                FLdCW   [CS:NewControlWord]

                FILD    [CS:FilterFreqValue]         ; 0->127*256
                FMul    [CS:FreqParameterMultiplier] ; -i/(24*256)
                FLd     ST
                FRndInt
                FSub    ST(1), ST
                FXCh
                F2XM1
                FLd1
                FAdd
                FScale                              ; = 2^(i/24*256)
                FMul    [CS:FreqMultiplier]         ; = r
                FLd     ST                              ; r, r
                FMul    ST(1), ST                       ; r, r^2

                FLd     [CS:QualityFactorTable+BX]      ; 2d, r, r^2
                FMul    ST(1), ST                       ; 2d, 2dr, r^2
                FAdd

                FLd1                                    ; 1, d+1, e
                FXCh                                    ; d+1, 1, e
                FSubR   ST(1), ST
                FAdd    ST, ST(2)                       ; 1+d+e, d, e
                FDivR   Const2048                       ; 1/(1+d+e), d, e
                FISt    Word Ptr [SI+5Eh]               ;
                FLd     ST(2)                           ; e, 1/(1+d+e), d, e
                FAdd    ST, ST
                FAddP   ST(2), ST                       ; 1/(1+d+e), d+2e, e
                FMul    ST(2), ST                       ; 1/(1+d+e), d+2e, e/(1+d+e)
                FMul
                FIStP   Word Ptr [SI+6Eh]
                FChs
                FIStP   Word Ptr [SI+7Eh]
                FStP  ST
                Mov     DWord Ptr [SI+0Ch], 0

MixMMXNoFilters:
                Mov     EBX, [SI+0Ch]

                Cmp     Stereo, 0
                JNE     MixMMXStereo

MixMMXMono:
                Mov     AX, [SI+4Ah]
                Mul     MixVolume
                ShRD    AX, DX, 9
                Mov     [SI+0Ch], AX
                Mov     [SI+0Eh], AX

                Jmp     MixModeVolumeCheck

MixMMXStereo:
                Mov     AL, [SI+37h]            ; Final pan
                Cmp     AL, 100
                JE      MixMMXSurround

                Mul     Byte Ptr MixVolume      ; 0->128
                Mul     Word Ptr [SI+4Ah]       ; 0->32768
                ShRD    AX, DX, 15              ; Maxvol = 8192
                Mov     [SI+0Eh], AX            ; Store into right volume

                Mov     AL, 64                  ; Do left volume
                Sub     AL, [SI+37h]            ; AL = 64-FinalPan
                Mul     Byte Ptr MixVolume
                Mul     Word Ptr [SI+4Ah]
                ShRD    AX, DX, 15
                Mov     [SI+0Ch], AX

                Jmp     MixModeVolumeCheck

MixMMXSurround:
                Mov     AX, [SI+4Ah]
                Mul     MixVolume
                ShRD    AX, DX, 10
                Mov     [SI+0Ch], AX
                Neg     AX
                Mov     [SI+0Eh], AX

MixModeVolumeCheck:
                Test    CH, 3+4
                JNZ     MixModeCommon

                Cmp     EBX, [SI+0Ch]   ; Same as last volume?
                JE      MixSamplesMix

MixModeCommon:                          ; Requires AX = 30 etc. depending
                                        ;               On mixing mode type.
                                        ; This will add 180 for 16-bit,
                                        ; And sort out loop types.
                Mov     AX, MixModeOffset

                Cmp     DWord Ptr [SI+0Ch], 0
                JNE     MixModeActualMix

                Cmp     MixMode, 2
                JB      MixMMXGeneralNoRamp

                Cmp     DWord Ptr [SI+1Ch], 0
                JNE     MixModeActualMix

MixMMXGeneralNoRamp:
                Mov     AX, 4*60
                Jmp     MixModeCommon1

MixModeActualMix:
                Cmp     MixMode, 3
                JNE     MixModeFilter

                Cmp     Word Ptr [SI+6Eh], 0
                JNE     MixModeFilter
                Cmp     Word Ptr [SI+7Eh], 0
                JNE     MixModeFilter

                Sub     AX, 60

MixModeFilter:
                Test    Byte Ptr [SI+18h], 2    ; 16 bit?
                JZ      MixModeCommon1

                Add     AX, 30

MixModeCommon1:
                Cmp     Byte Ptr [SI+0Ah], 8
                JB      MixModeCommon3          ; No loop
                JE      MixModeCommon2          ; Forwards loop

                Add     AX, 10

MixModeCommon2:
                Add     AX, 10

MixModeCommon3:
                Add     AX, Offset MixFunctionTables
                Mov     [SI+8], AX              ; Offset...

MixSamplesMix:
                Mov     BX, [SI+8]              ; BX = offset into
                Mov     EAX, [CS:BX+2]
                Mov     DWord Ptr PreMixFunction, EAX
                Mov     EAX, [CS:BX+6]
                Mov     DWord Ptr MixFunctionSeparateBackwards, EAX

                Mov     AX, BytesToMix
                Mov     MixBlockSize, AX
                Mov     MixBufferOffset, DMABUFFERLENGTH*2+80

                Mov     EAX, CURRENTPOSITION
                Mov     OLDPOSITION, EAX

                Push    Word Ptr [SI+8]
                Call    Word Ptr [CS:BX]
                Pop     BX

                And     Word Ptr [SI], 0111100010001101b

                Cmp     BX, Offset MixFunctionTables+60*2
                JB      MixSamplesEnd
                Cmp     BX, Offset MixFunctionTables+60*4
                JAE     MixSamplesEnd

                MovDR   AX, MM6
                Mov     [SI+0Ch], EAX
                Mov     [SI+1Ch], EAX

                Cmp     BX, Offset MixfunctionTables+60*3
                JB      MixSamplesEnd

                Mov     ES, CS:MixSegment
                Mov     DX, [ES:10h]
                Mov     BX, [ES:14h]
                Mov     [SI+3Ch], DX
                Mov     [SI+6h], BX
                Jmp     MixSamplesEnd

MixSamplesHandleError:
                Mov     Word Ptr [SI], 200h

                Test    Byte Ptr [SI+3Ah], 80h
                JNZ     MixSamplesEnd

                Mov     BX, [SI+38h]
                And     Byte Ptr [BX], Not 4    ; Turn off channel

MixSamplesEnd:
                Pop     CX

MixSamplesEnd2:
                Add     SI, 128
                Dec     CX
                JNZ     MixSamples2

IF OUTPUTFILTERENABLED
  include equalize.inc
ENDIF
                Ret

EndP            MixSamples
                Assume DS:Nothing

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

