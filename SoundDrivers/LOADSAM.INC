Proc            LoadSample Far          ; Fix up end of sample bytes

                PushAD
                Push    DS
                Push    ES
                Push    FS

                Mov     FS, CS:SongDataArea
                Mov     BP, AX
                Add     BP, BP
                Mov     BP, [FS:64910+BP]

                Xor     CX, CX                  ; From the start of the sample..
                Call    GetSampleLocation       ; Returns DS:ESI, ECX = length
                JC      LoadSampleEnd           ; Zero flag ON if 16 bit..

                Xor     EAX, EAX
                Mov     BL, [FS:BP+12h]

                Test    BL, 10h                 ; Loop
                JZ      LoadSample2

                Mov     ESI, [FS:BP+34h]        ; Start of loop
                Test    BL, 40h                 ; Pingpong?
                JZ      LoadSample1

                Mov     ESI, [FS:BP+38h]
                Sub     ESI, 2
                JNC     LoadSample1

                Xor     ESI, ESI

LoadSample1:
                Test    BL, 2
                JZ      LoadSample4

                Add     ESI, ESI

LoadSample4:
                Int     3
                Mov     AL, [SI]
                Inc     ESI
                Int     3
                Mov     AH, [SI]

LoadSample2:
                Mov     ESI, [FS:BP+30h]
                Test    BL, 2
                JZ      LoadSample3

                Add     ESI, ESI

LoadSample3:
                Int     3
                Mov     [SI], AL
                Inc     ESI
                Int     3
                Mov     [SI], AH

LoadSampleEnd:
                Pop     FS
                Pop     ES
                Pop     DS
                PopAD

                StC
                Ret

EndP            LoadSample


