
Proc            GetCurrentTime

                Push    DS
                Push    ES

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Cmp     TimerData, 0
                JE      GetCurrentTimeEnd

                Mov     ES, TimerData
                Mov     DI, NumTimerData
                ShL     DI, 3

                Mov     AH, 2Ah
                Int     21h             ; Get Date
                Mov     AX, CX          ; Now to get date in yyyyyyym mmmddddd
                Sub     AX, 1980
                ShL     AX, 9           ; Year
                Or      AL, DL          ; Day
                Xor     DL, DL
                ShR     DX, 3
                Or      AX, DX          ; Month
                StosW

                Mov     AH, 2Ch
                Int     21h             ; Get time
                Mov     AX, CX          ; Now to get time in hhhhhmmm mmmsssss
                ShL     AL, 2           ; AX = ...hhhhh mmmmmm..
                ShL     AX, 3           ; AX = hhhhhmmm mmm.....
                ShR     DH, 1           ; DH = ...sssss
                Or      AL, DH
                StosW

GetCurrentTimeEnd:
                Pop     ES
                Pop     DS
                Ret

EndP            GetCurrentTime
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CheckTimerData
                Assume DS:Disk

                Cmp     TimerData, 0
                JNE     CheckTimerData1

                Mov     NumTimerData, 0
                Mov     AH, 48h
                Mov     BX, 1
                Int     21h
                JC      CheckTimerData1

                Mov     TimerData, AX
                Call    GetCurrentTime

CheckTimerData1:
                Ret

EndP            CheckTimerData
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ReleaseTimerData

                Mov     AX, CS:TimerData
                Test    AX, AX
                JZ      ReleaseTimerData1

                Mov     ES, AX
                Mov     AH, 49h
                Int     21h
                Xor     AX, AX

ReleaseTimerData1:
                Mov     CS:TimerData, AX
                Mov     CS:NumTimerData, AX

                Ret

EndP            ReleaseTimerData

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
