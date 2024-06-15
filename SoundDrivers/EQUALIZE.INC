; Do output filtering
; First copy old contents across
; Assumes destination is MixSegment:0
;         data order is lastvalues, coefficients, volumes

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Xor     DI, DI
                Mov     SI, Offset LastFilter

                Mov     EAX, [SI+40h]
                Mov     EBX, [SI+44h]
                Mov     ECX, [SI+48h]
                Mov     EDX, [SI+4Ch]
                Or      EAX, EBX
                Or      ECX, EDX
                Or      EAX, ECX
                JZ      NoEqualize

                Mov     CX, 80/4
                Mov     ES, MixSegment

                Rep     MovsD

; Now do filtering.
                FNInit
                Mov     CX, BytesToMix

                Push    ES
                Pop     DS
                        Assume DS:Nothing

                Mov     SI, DMABUFFERLENGTH*2+80

OutputFilter1:
                FILD    DWord Ptr [SI]          ; Left sample
                FILD    DWord Ptr [SI+4]        ; R, L

                FLd     DWord Ptr [DS:20h]      ; LB, R, L
                FMul    ST, ST(2)               ; L.LB, R, L
                FLd     DWord Ptr [DS:20h]      ; LB, L.LB, R, L
                FMul    ST, ST(2)               ; R.LB, L.LB, R, L
                FLd     DWord Ptr [DS:0]        ; OL, R.LB, L.LB, R, L
                FMul    DWord Ptr [DS:24h]      ; OL.LB, R.LB, L.LB, R, L
                FLd     DWord Ptr [DS:4]        ; OR, OL.LB, R.LB, L.LB, R, L
                FMul    DWord Ptr [DS:24h]      ; OR.LB, OL.LB, R.LB, L.LB, R, L

                FXCh                            ; OL.LB, OR.LB, R.LB, L.LB, R, L
                FAddP   ST(3), ST
                FAdd                            ; RLB, LLB, R, L

                FLd     DWord Ptr [DS:28h]      ; MB, RLB, LLB, R, L
                FMul    ST, ST(4)               ; L.MB, RLB, LLB, R, L
                FLd     DWord Ptr [DS:28h]      ; MB, L.MB, RLB, LLB, R, L
                FMul    ST, ST(4)               ; R.MB, L.MB, RLB, LLB, R, L
                FLd     DWord Ptr [DS:8]        ; OL, R.MB, L.MB, RLB, LLB, R, L
                FMul    DWord Ptr [DS:2Ch]      ; OL.MB, R.MB, L.MB, RLB, LLB, R, L
                FLd     DWord Ptr [DS:0Ch]      ; OR, OL.MB, R.MB, L.MB, RLB, LLB, R, L
                FMul    DWord Ptr [DS:2Ch]      ; OR.MB, OL.MB, R.MB, L.MB, RLB, LLB, R, L

                FXCh                            ; OL.MB, OR.MB, R.MB, L.MB, RLB, LLB, R, L
                FAddP   ST(3), ST
                FAdd                            ; RMB, LMB, RLB, LLB, R, L
                FXCh    ST(3)                   ; LLB, LMB, RLB, RMB, R, L
                FStP    DWord Ptr [DS:0]
                FStP    DWord Ptr [DS:8]
                FStP    DWord Ptr [DS:4]
                FStP    DWord Ptr [DS:0Ch]

                FLd     DWord Ptr [DS:30h]
                FMul    ST, ST(2)
                FLd     DWord Ptr [DS:30h]
                FMul    ST, ST(2)
                FLd     DWord Ptr [DS:10h]
                FMul    DWord Ptr [DS:34h]
                FLd     DWord Ptr [DS:14h]
                FMul    DWord Ptr [DS:34h]

                FXCh
                FAddP   ST(3), ST
                FAdd

                FLd     DWord Ptr [DS:38h]
                FMul    ST, ST(4)
                FLd     DWord Ptr [DS:38h]
                FMul    ST, ST(4)
                FLd     DWord Ptr [DS:18h]
                FMul    DWord Ptr [DS:3Ch]
                FLd     DWord Ptr [DS:1Ch]
                FMul    DWord Ptr [DS:3Ch]

                FXCh
                FAddP   ST(3), ST
                FAdd
                FXCh    ST(3)
                FStP    DWord Ptr [DS:10h]
                FStP    DWord Ptr [DS:18h]
                FStP    DWord Ptr [DS:14h]
                FStP    DWord Ptr [DS:1Ch]      ; R, L

; For each one, output value += ((band value) - (previous band value)) * Volume

                FLd     DWord Ptr [DS:18h]
                FSub    DWord Ptr [DS:10h]      ; L4, R, L
                FLd     DWord Ptr [DS:1Ch]
                FSub    DWord Ptr [DS:14h]      ; R4, L4, R, L
                FLd     DWord Ptr [DS:10h]
                FSub    DWord Ptr [DS:8]
                FLd     DWord Ptr [DS:14h]
                FSub    DWord Ptr [DS:0Ch]      ; R3, L3, R4, L4, R, L
                FLd     DWord Ptr [DS:8]
                FSub    DWord Ptr [DS:0]
                FLd     DWord Ptr [DS:0Ch]
                FSub    DWord Ptr [DS:4]        ; R2, L2, R3, L3, R4, L4, R, L
                FXCh    ST(5)                   ; L4, L2, R3, L3, R4, R2, R, L
                FMul    DWord Ptr [DS:4Ch]      ; L4V, L2, R3, L3, R4, R2, R, L
                FXCh    ST(4)                   ; R4, L2, R3, L3, L4V, R2, R, L
                FMul    DWord Ptr [DS:4Ch]      ; R4V, L2, R3, L3, L4V, R2, R, L
                FXCh    ST(3)                   ; L3, L2, R3, R4V, L4V, R2, R, L
                FMul    DWord Ptr [DS:48h]      ; L3V, L2, R3, R4V, L4V, R2, R, L
                FXCh    ST(2)                   ; R3, L2, L3V, R4V, L4V, R2, R, L
                FMul    DWord Ptr [DS:48h]      ; R3V, L2, L3V, R4V, L4V, R2, R, L
                FXCh                            ; L2, R3V, L3V, R4V, L4V, R2, R, L
                FMul    DWord Ptr [DS:44h]      ; L2V, R3V, L3V, R4V, L4V, R2, R, L
                FXCh    ST(5)                   ; R2, R3V, L3V, R4V, L4V, L2V, R, L
                FMul    DWord Ptr [DS:44h]      ; R2V, R3V, L3V, R4V, L4V, L2V, R, L
                FXCh    ST(4)                   ; L4V, R3V, L3V, R4V, R2V, L2V, R, L
                FAddP   ST(7), ST               ; R3V, L3V, R4V, R2V, L2V, R, L
                FAddP   ST(5), ST               ; L3V, R4V, R2V, L2V, R, L
                FAddP   ST(3), ST
                FAdd
                FLd     DWord Ptr [DS:0]
                FMul    DWord Ptr [DS:40h]      ; L1V, RV, LV, R, L
                FLd     DWord Ptr [DS:4]        ;
                FMul    DWord Ptr [DS:40h]      ; R1V, L1V, RV, LV, R, L
                FXCh    ST(2)                   ; RV, L1V, R1V, LV, R, L
                FAddP   ST(4), ST               ; L1V, R1V, LV, R, L
                FAddP   ST(4), ST               ; R1V, LV, R, L
                FAddP   ST(2), ST
                FAddP   ST(2), ST

                FIStP   DWord Ptr [SI+4]
                FIStP   DWord Ptr [SI]

                Add     SI, 8
                Dec     CX
                JNZ     OutputFilter1

; Transfer contents out
                Push    CS
                Pop     ES

                Mov     DI, Offset LastFilter
                Xor     SI, SI
                Mov     CX, 32/4

                Rep     MovsD
; Finished output filtering!
NoEqualize:
