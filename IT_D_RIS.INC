;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; In-Module sample loaders have to place the information at Sample*96 bytes
; in ITS format into DiskDataArea. Provided with:
;    BX = file handle, File at header section.
;    DS, ES = DiskDataArea
;
; Variables to update:
;     NumSamples (initialised to 1 before the call)
;
; Variables to use:
;     InSampleDateTime (DWord)
;     CS:InSampleFileName (13 bytes)
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            SoftBSWAP     ; EAX, returns EAX

                Push    EDX

                SHLD    EDX, EAX, 16            ; DX:AX contains value.
                XChg    DH, AL
                XChg    DL, AH                  ; DX:AX in proper order now
                ShL     EAX, 16
                SHRD    EAX, EDX, 16

                Pop     EDX
                Ret

EndP            SoftBSWAP

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            TransferFileName

                Mov     EAX, 'SPMI'
                StosD

                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     EAX, InSampleDateTime

                Mov     SI, Offset InSampleFileName
                Mov     CX, 13
                Rep     MovsB

                Pop     DS
                        Assume DS:Nothing

                Mov     [DI+54h-11h], EAX ; Date.

                Ret

EndP            TransferFileName

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            LoadMODSamplesInModule

                Mov     AH, 3Fh
                Mov     CX, 1084
                Mov     DX, 63000
                Int     21h

                Xor     CX, CX
                Mov     SI, 63952
                Mov     AX, 07F00h


LoadMODSamplesInModule1:
                LodsB
                Cmp     CL, AL
                JAE     LoadMODSamplesInModule2

                Mov     CL, AL

LoadMODSamplesInModule2:
                Dec     AH
                JNZ     LoadMODSamplesInModule1

                Inc     CX                      ; CX = number of patterns to
                                                ;      load

                Mov     AL, CS:InSampleChannels
                Mul     CL                      ; AX = Chan * patterns

                And     EAX, 0FFFFh
                ShL     EAX, 8
                Add     EAX, 1084               
                Mov     EBP, EAX                ; EBP = location of first sample

                Mov     SI, 63020               ; First sample
                Mov     CX, 31

LoadMODSamplesInModule3:
                Push    CX
                Push    SI

                Mov     CX, [SI+22]
                XChg    CH, CL
                Cmp     CX, 1
                JBE     LoadMODSamplesInModule4

                                                ; OK.. have a sample
                Mov     AX, 96
                Mul     CS:NumSamples
                Mov     DI, AX

                Inc     CS:NumSamples

                Mov     Byte Ptr [DI+88], 14
                Push    SI
                Call    TransferFileName
                Pop     SI

                Mov     AL, 64
                StosB

                Mov     AH, [SI+25]             ; Default volume
                Mov     AL, 1

                Mov     CX, [DS:SI+28]
                XChg    CH, CL
                Cmp     CX, 1
                JBE     LoadMODSamplesInModule5

                Or      AL, 16

LoadMODSamplesInModule5:
                StosW

                Mov     CX, 22
                Rep     MovsB
                Xor     EAX, EAX
                StosD

                Mov     AX, 32*256+1            ; Convert signed->Unsigned
                StosW                           ; Default pan of 32

                Mov     AX, [SI]
                XChg    AH, AL
                Add     EAX, EAX
                Mov     [DI+20h], EAX         ; File size
                StosD                   ; Sample length

                Push    EAX

                MovZX   EAX, Word Ptr [SI+4]
                XChg    AH, AL
                Add     EAX, EAX
                StosD                   ; Loop begin

                MovZX   ECX, Word Ptr [SI+6]
                XChg    CH, CL
                Add     ECX, ECX
                Add     EAX, ECX
                StosD                   ; Loop end

                Mov     AL, [SI+2]
                And     AX, 15
                Mov     SI, AX
                Add     SI, SI
                Mov     AX, [CS:FineTuneTable+SI]
                StosW
                Xor     AX, AX
                Mov     CX, 5
                Rep     StosW

                Mov     EAX, EBP
                StosD
                Xor     EAX, EAX
                StosD

                Pop     EAX
                Add     EBP, EAX

LoadMODSamplesInModule4:
                Pop     SI
                Pop     CX

                Add     SI, 30
                Loop    LoadMODSamplesInModule3

                Ret

EndP            LoadMODSamplesInModule

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            LoadS3MSamplesInModule

                Mov     AH, 3Fh
                Mov     CX, 2000
                Mov     DX, 63000
                Int     21h

                Xor     BP, BP

LoadS3MSamplesInModule1:
                Cmp     BP, [DS:63000+22h]
                JB      LoadS3MSamplesInModule2

                Ret

LoadS3MSamplesInModule2:
                Mov     SI, BP
                Add     SI, SI
                Add     SI, [DS:63000+20h]
                Inc     BP

                Mov     DX, [DS:63000+SI+60h]
                Mov     CX, DX
                ShR     CX, 12
                ShL     DX, 4
                Mov     AX, 4200h
                Int     21h
                                ; Move to location
                Mov     DX, 62000
                Mov     AH, 3Fh
                Mov     CX, 80h
                Int     21h

                Cmp     Byte Ptr [DS:62000], 1
                JNE     LoadS3MSamplesInModule1
                Cmp     DWord Ptr [DS:62000+10h], 0
                JE      LoadS3MSamplesInModule1

                Mov     AX, 96
                Mul     CS:NumSamples
                Mov     DI, AX

                Mov     Byte Ptr [DI+88], 3
                Call    TransferFileName

                Mov     AL, 64
                StosB

                Mov     AL, [DS:62000+1Fh]      ; Flag
                Mov     AH, AL
                And     AX, 401h
                ShR     AH, 1
                ShL     AL, 4
                Or      AL, AH
                Or      AL, 1
                Mov     AH, [DS:62000+1Ch]      ; Default volume
                StosW

                Mov     SI, 62000+30h
                Mov     CX, 25
                Rep     MovsB
                Xor     AX, AX
                StosW
                Mov     AL, 32
                StosB

                                ; Length
                Mov     EAX, [DS:62000+10h]
                StosD
                Test    Byte Ptr [DS:62000+1Fh], 4
                JZ      LoadS3MSamplesInModule3

                Add     EAX, EAX

LoadS3MSamplesInModule3:
                Mov     [DI+20h-4], EAX         ; File size

                Mov     EAX, [DS:62000+14h]
                StosD
                Mov     EAX, [DS:62000+18h]
                StosD
                Mov     EAX, [DS:62000+20h]
                StosD
                Xor     AX, AX
                StosW
                StosW
                StosW
                StosW
                                        ; Sample pointer..
                Mov     AL, [DS:62000+0Dh]
                ShL     EAX, 16
                Mov     AX, [DS:62000+0Eh]
                ShL     EAX, 4
                StosD
                Xor     AX, AX
                StosW
                StosW

                Inc     CS:NumSamples
                Jmp     LoadS3MSamplesInModule1

EndP            LoadS3MSamplesInModule

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            LoadFARSamplesInModule

                Mov     AH, 3Fh
                Mov     CX, 98
                Mov     DX, 63000
                Int     21h

                Mov     AX, 4201h
                Xor     CX, CX
                Mov     DX, [DS:63000+96]
                Int     21h                     ; Removes song message

                Mov     AH, 3Fh
                Mov     CX, 869-98
                Mov     DX, 63000+98
                Int     21h

;                Xor     CX, CX
;                Mov     CL, [DS:63000+354]      ; CX = number of patterns

                Mov     CX, 256

Comment ~

                Xor     CX, CX
                Mov     CL, [DS:63000+355]
                Mov     SI, 63000+98
                Xor     AH, AH
                  ; Have to find CX from order list, apparently...

LoadFARSamplesInModule7:
                LodsB
                Cmp     AL, 0FFh
                JE      LoadFARSamplesInModule8
                Cmp     AL, AH
                JB      LoadFARSamplesInModule8

                Mov     AH, AL

LoadFARSamplesInModule8:
                Loop    LoadFARSamplesInModule7

                Mov     CL, AH
                Inc     CX

      ~

                Mov     SI, 63000+357
                Xor     AX, AX
                Xor     DX, DX

LoadFARSamplesInModule1:
                Add     AX, [SI]
                AdC     DX, 0
                Add     SI, 2
                Loop    LoadFARSamplesInModule1

                        ; DX:AX = length of patterns.
                Mov     CX, DX
                Mov     DX, AX
                Mov     AX, 4201h
                Int     21h             ; OK.. skipped past patterns.

                Mov     AH, 3Fh
                Mov     CX, 8
                Mov     DX, 64000
                Int     21h             ; Read sample map.

                                        ; Determine number of samples...
                Xor     SI, SI          ; SI = number of samples

                Mov     EDX, [DS:64004]
                Mov     EAX, [DS:64000]
                Mov     CX, 64

LoadFARSamplesInModule2:
                Test    AL, 1
                JZ      LoadFARSamplesInModule3

                Inc     SI

LoadFARSamplesInModule3:
                ShR     EDX, 1
                RCR     EAX, 1
                Loop    LoadFARSamplesInModule2
                                        ; OK.. SI = number of samples..
                Mov     [DS:65000], SI

                Mov     AX, 48
                Mul     SI
                Mov     SI, AX          ; SI = number of bytes for sample header

                Mov     AX, 4201h
                Xor     CX, CX
                Xor     DX, DX
                Int     21h
                        ; DX:AX = position in file.
                Add     AX, SI
                AdC     DX, 0           ; DX:AX = position in file of first sam

                Xor     BP, BP

LoadFARSamplesInModule4:
                Cmp     BP, [DS:65000]
                JB      LoadFARSamplesInModule5

                Ret

LoadFARSamplesInModule5:
                Inc     BP

                Mov     DX, 62000
                Mov     AH, 3Fh
                Mov     CX, 48
                Int     21h

                Cmp     DWord Ptr [DS:62000+32], 0
                JE      LoadFARSamplesInModule4

                Mov     AX, 96
                Mul     CS:NumSamples
                Mov     DI, AX

                Mov     Byte Ptr [DI+88], 12    ; FAR sample
                Call    TransferFileName

                Mov     AL, 64
                StosB                           ; Global volume

                Mov     AX, [DS:62000+46]       ; 8/16 bit in bit 0
                                                ; loop in bit 3 of AH
                And     AX, 801h
                ShL     AX, 1
                Or      AL, AH
                Or      AL, 1
                Mov     DL, AL
                Mov     AH, 64
                StosW

                Mov     SI, 62000
                Mov     CX, 25

LoadFARSamplesInModule6:
                LodsB
                StosB
                Test    AL, AL
                LoopNZ  LoadFarSamplesInModule6

                Xor     AL, AL
                Inc     CX
                Rep     StosB
                Mov     AX, 1+32*256
                StosW

                Mov     EAX, [DS:62000+32]
                Mov     [DI+20h], EAX         ; File size
                Call    LoadPTMSamplesInModule4
                Mov     EAX, [DS:62000+38]      ; Begin
                Call    LoadPTMSamplesInModule4
                Mov     EAX, [DS:62000+42]      ; End
                Call    LoadPTMSamplesInModule4

                Mov     AX, 8363
                StosW
                Xor     AX, AX
                Mov     CX, 5
                Rep     StosW

                ; Get current position in file
                Mov     AX, 4201h
                Xor     CX, CX
                Xor     DX, DX
                Int     21h
                StosW
                Mov     AX, DX
                StosW

                Xor     AX, AX
                StosW
                StosW

                Mov     AX, 4201h
                Mov     CX, [DS:62000+34]
                Mov     DX, [DS:62000+32]
                Int     21h

                Cmp     DWord Ptr [DS:62000+32], 1
                JBE     LoadFARSamplesInModule4

                Inc     CS:NumSamples
                Jmp     LoadFARSamplesInModule4

EndP            LoadFARSamplesInModule

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            LoadMTMSamplesInModule

                Mov     AH, 3Fh
                Mov     CX, 66          ; Read header
                Mov     DX, 63000
                Int     21h

                                ; Sample pos = LastsamplePos+Length
                                ; So.. setup first sample with no length
                Mov     AH, 64
                Mov     AL, [DS:63000+26]
                Inc     AX
                Mul     AH
                Mov     CX, AX          ; CX = 64*(LastPatternSaved+1)

                Mov     AL, 37
                Mul     Byte Ptr [DS:63000+30]  ; NOS
                Add     CX, AX          ; CX = NOS*37+64*(LastPatternSaved+1)
                Add     CX, [DS:63000+28]
                Add     CX, 194         ; CX = 194+NOS*37+Lngth of comment+...

                Mov     AX, 192
                Mul     Word Ptr [DS:63000+24]  ; Tracks saved

                Add     AX, CX
                AdC     DX, 0

                Mov     [DS:48h], AX
                Mov     [DS:4Ah], DX

                Mov     DWord Ptr [DS:30h], 0

                Mov     Byte Ptr [DS:63000+31], 0
                Xor     BP, BP

LoadMTMSamplesInModule1:
                Cmp     BP, [DS:63000+30]
                JB      LoadMTMSamplesInModule2

                Ret

LoadMTMSamplesInModule2:
                Inc     BP

                Mov     DX, 62000
                Mov     AH, 3Fh
                Mov     CX, 37
                Int     21h

                Cmp     DWord Ptr [DS:62000+22], 0
                JE      LoadMTMSamplesInModule1

                Mov     AX, 96
                Mul     CS:NumSamples
                Mov     DI, AX

                Mov     Byte Ptr [DI+88], 10    ; MTM sample
                Call    TransferFileName

                Mov     AL, 64
                StosB                           ; Global volume

                Mov     AL, 1

                Mov     ECX, [DS:62000+30]
                Sub     ECX, [DS:62000+26]

                Cmp     ECX, 2
                JLE     LoadMTMSamplesInModule3

                Mov     AL, 11h                 ; Loop + sample.

LoadMTMSamplesInModule3:
                Mov     AH, [DS:62000+35]
                StosW
                                        ; Sample name now..
                Mov     SI, 62000
                Mov     CX, 22

LoadMTMSamplesInModule4:
                LodsB
                StosB
                Test    AL, AL
                LoopNZ  LoadMTMSamplesInModule4

                Xor     AX, AX
                Add     CX, 4
                Rep     StosB

                Mov     AH, 32
                StosW

                Mov     EAX, [DS:62000+22]
                Mov     [DI+20h], EAX
                StosD
                Mov     EAX, [DS:62000+26]
                StosD
                Mov     EAX, [DS:62000+30]
                StosD

                Mov     AL, [DS:62000+34]
                And     AX, 0Fh
                Mov     SI, AX
                Add     SI, SI
                Mov     AX, [CS:FineTuneTable+SI]
                StosW
                Xor     AX, AX
                Mov     CX, 5
                Rep     StosW

                                ; Sample pointer...
                Mov     EAX, [DI-96]    ; Last sample pointer
                Add     EAX, [DI-96-18h]        ; Last sample length
                StosD

                Xor     AX, AX
                StosW
                StosW

                Inc     CS:NumSamples
                Jmp     LoadMTMSamplesInModule1

EndP            LoadMTMSamplesInModule

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Comment ~

Proc            LoadULTSamplesInModule

                Mov     AH, 3Fh
                Mov     CX, 48         ; Read 48 bytes.
                Mov     DX, 63000
                Int     21h

                Xor     DH, DH
                Mov     DL, [DS:63000+47]
                ShL     DX, 5           ; CX = CX * 32
                Xor     CX, CX
                Mov     AX, 4201h
                Int     21h             ; Seek..

                Mov     AH, 3Fh
                Mov     CX, 1
                Mov     DX, 63000+48
                Int     21h             ; Read 1 byte..
                Mov     Byte Ptr [DS:63000+49], 0

                Ret

EndP            LoadULTSamplesInModule

        ~

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            Load669SamplesInModule

                Mov     AH, 3Fh
                Mov     CX, 1F1h
                Mov     DX, 63000
                Int     21h

                Mov     AL, 19h
                Mul     Byte Ptr [DS:63000+6Eh]
                Mov     CX, AX
                Add     CX, 1F1h

                Mov     AL, [DS:63000+6Fh]
                Xor     AH, AH
                Mov     DX, 600h
                Mul     DX

                Add     AX, CX
                AdC     DX, 0

                Mov     [DS:48h], AX
                Mov     [DS:4Ah], DX

                Mov     DWord Ptr [DS:30h], 0

                Mov     Byte Ptr [DS:63000+6Fh], 0
                Xor     BP, BP

Load669SamplesInModule1:
                Cmp     BP, [DS:63000+6Eh]
                JB      Load669SamplesInModule2

                Ret

Load669SamplesInModule2:
                Inc     BP

                Mov     AH, 3Fh
                Mov     CX, 19h
                Mov     DX, 62000
                Int     21h

                Cmp     DWord Ptr [DS:62000+13], 0
                JE      Load669SamplesInModule1

                Mov     AX, 96
                Mul     CS:NumSamples
                Mov     DI, AX

                Mov     Byte Ptr [DI+88], 11    ; 669 sample
                Call    TransferFileName

                Mov     AL, 64
                StosB                           ; Global volume

                Mov     AL, 1

                Mov     ECX, [DS:62000+21]
                Cmp     ECX, [DS:62000+13]
                JA      Load669SamplesInModule3

                Mov     AL, 11h                 ; Loop + sample.

Load669SamplesInModule3:
                Mov     DL, AL
                Mov     AH, 64
                StosW

                                ; Sample name
                Mov     SI, 62000
                Mov     CX, 13
                Rep     MovsB

                Xor     AX, AX
                Mov     CX, 13
                Rep     StosB

                Mov     AH, 32
                StosW

                Mov     SI, 62000+13
                LodsD
                Mov     [DI+20h], EAX
                StosD
                MovsD
                Test    DL, 10h
                JZ      Load669SamplesInModule4

                MovsD
                Jmp     Load669SamplesInModule5

Load669SamplesInModule4:
                Xor     AX, AX
                StosW
                StosW

Load669SamplesInModule5:
                Mov     AX, 8363
                StosW
                Xor     AX, AX
                Mov     CX, 5
                Rep     StosW

                                ; Sample pointer...
                Mov     EAX, [DI-96]            ; Last sample pointer
                Add     EAX, [DI-96-18h]        ; Last sample length
                StosD

                Xor     AX, AX
                StosW
                StosW

                Inc     CS:NumSamples
                Jmp     Load669SamplesInModule1

EndP            Load669SamplesInModule


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            LoadPTMSamplesInModule

                Mov     AH, 3Fh
                Mov     CX, 608         ; Read 608 bytes.
                Mov     DX, 63000
                Int     21h

                Xor     BP, BP

LoadPTMSamplesInModule1:
                Cmp     BP, [DS:63000+34]
                JB      LoadPTMSamplesInModule2

                Ret

LoadPTMSamplesInModule2:
                Inc     BP

                Mov     DX, 62000
                Mov     AH, 3Fh
                Mov     CX, 80
                Int     21h

                Mov     AL, [DS:62000]
                And     AL, 3
                Cmp     AL, 1
                JNE     LoadPTMSamplesInModule1
                Cmp     DWord Ptr [DS:62000+22], 0
                JE      LoadPTMSamplesInModule1

                Mov     AX, 96
                Mul     CS:NumSamples
                Mov     DI, AX

                Mov     Byte Ptr [DI+88], 9     ; PTM sample
                Call    TransferFileName

                Mov     AL, 64
                StosB                           ; Global volume

                Mov     CL, [DS:62000]          ; AL, Bit 0-1 = sample
                                                ;     Bit 2 = loop
                                                ;     Bit 3 = loop dirn
                                                ;     Bit 4 = 8/16 bit
                Mov     AL, CL
                Mov     AH, CL
                And     AX, 1004h
                ShL     AL, 2
                And     CL, 8
                ShR     AH, 3
                ShL     CL, 3
                Or      AL, AH
                Or      AL, CL
                Or      AL, 1
                Mov     DL, AL
                Mov     AH, [DS:62000+13]      ; Default volume
                StosW                           ; Flag + default volume

                Mov     SI, 62000+30h          ; Sample name
                Mov     CX, 25
                Rep     MovsB
                Xor     AX, AX
                StosB

                Mov     AX, 9+32*256           ; Conversion flag + default pan
                StosW

                                ; Length
                Mov     EAX, [DS:62000+22]
                Mov     [DI+20h], EAX         ; File size
                Call    LoadPTMSamplesInModule4
                Mov     EAX, [DS:62000+26]      ; Begin
                Call    LoadPTMSamplesInModule4
                Mov     EAX, [DS:62000+30]      ; End
                Call    LoadPTMSamplesInModule4
                Xor     EAX, EAX
                Mov     AX, [DS:62000+14]       ; C5Freq
                StosD
                Xor     AX, AX
                StosW
                StosW
                StosW
                StosW
                                        ; Sample pointer..
                Mov     EAX, [DS:62000+18]
                StosD
                Xor     AX, AX
                StosW
                StosW

                Inc     CS:NumSamples
                Jmp     LoadPTMSamplesInModule1

LoadPTMSamplesInModule4:
                Test    DL, 2
                JZ      LoadPTMSamplesInModule5

                ShR     EAX, 1

LoadPTMSamplesInModule5:
                StosD
                RetN

EndP            LoadPTMSamplesInModule

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            LoadITSamplesInModule   ; DS, ES = DiskDataArea

                Mov     AH, 3Fh
                Mov     CX, 2000
                Mov     DX, 63000
                Int     21h             ; Loaded module

                Xor     BP, BP          ; DX = number of samples

LoadITSamplesInModule1:
                Cmp     BP, [DS:63000+24h]      ; Num Samples
                JB      LoadITSamplesInModule2

                Ret

LoadITSamplesInModule2:
                Mov     SI, [DS:63000+22h]
                Add     SI, BP
                ShL     SI, 2           ; DX = (NumInstrument+NumSamples)*4
                Add     SI, [DS:63000+20h]
                Inc     BP

                Mov     DX, [DS:63000+SI+0C0h]
                Mov     CX, [DS:63000+SI+0C0h+2]

                Mov     AX, 4200h
                Int     21h
                                ; OK. file pointer moved to sample header.
                        ; Memory region to copy it to is BP*96

                Mov     AX, 96
                Mul     CS:NumSamples

                Mov     DX, AX
                Mov     DI, DX
                Mov     AH, 3Fh
                Mov     CX, 80
                Int     21h

                Mov     CL, [DI+12h]
                Test    CL, 1
                JZ      LoadITSamplesInModule1

                Mov     EAX, [DI+30h]   ; Length
                Test    CL, 2
                JZ      LoadITSamplesInModule3

                Add     EAX, EAX

LoadITSamplesInModule3:
                Mov     [DI+50h], EAX

                Mov     Byte Ptr [DI+88], 2
                Call    TransferFileName

                Inc     CS:NumSamples
                Jmp     LoadITSamplesInModule1

EndP            LoadITSamplesInModule

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            LoadXMHeader

                Mov     AH, 3Fh
                Mov     CX, 74
                Mov     DX, 64000
                Int     21h             ; Loaded module

                Mov     AX, 4200h       ; Seek to position from start of module
                Mov     DX, [DS:64000+60]
                Mov     CX, [DS:64000+62]
                Add     DX, 60
                Int     21h

                Xor     BP, BP          ; BP = pattern counter
                                        ; At first pattern
LoadXMSamplesInModule1:
                Cmp     BP, [DS:64000+70]       ; Number of patterns
                JAE     LoadXMSamplesInModule2

                                        ; Load 4 bytes.
                Mov     AH, 3Fh
                Mov     CX, 9           ; Read standard header
                Mov     DX, 63000
                Int     21h

                Mov     AX, 4201h
                Xor     CX, CX
                Mov     DX, [DS:63000]
                Add     DX, [DS:63000+7]
                Sub     DX, 9
                Int     21h

                Inc     BP
                Jmp     LoadXMSamplesInModule1

LoadXMSamplesInModule2:                         ; OK.. at first instrument

                Ret

EndP            LoadXMHeader

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            LoadXMSamplesInModule

                Call    LoadXMHeader

                Xor     BP, BP

LoadXMSamplesInModule3:
                Cmp     BP, [DS:64000+72]
                JB      LoadXMSamplesInModule4

                Ret

LoadXMSamplesInModule4:
                Inc     BP

                Mov     AH, 3Fh
                Mov     CX, 4
                Mov     DX, 63000
                Int     21h             ; Read instrument size field

                Mov     AH, 3Fh
                Mov     CX, [DS:63000]
                Sub     CX, 4
                Mov     DX, 63004
                Int     21h

                Mov     AX, [DS:63000+27]       ; Number of samples
                Test    AX, AX
                JZ      LoadXMSamplesInModule3

                                                ; Bytes to read = AX*40
                Mov     CX, 40
                Mul     CX
                Mov     CX, AX
                Mov     AH, 3Fh
                Mov     DX, 62000
                Int     21h                     ; OK sample headers read
                                                ; into DS:62000

                Push    BP
                Xor     BP, BP
                Xor     EDX, EDX                ; EDX = number of bytes to adv

LoadXMSamplesInModule5:
                Cmp     BP, [DS:63000+27]       ; Number of samples
                JB      LoadXMSamplesInModule6

                SHLD    ECX, EDX, 16
                Mov     AX, 4201h
                Int     21h                     ; Advance file pointer

                Pop     BP
                Jmp     LoadXMSamplesInModule3

LoadXMSamplesInModule6:
                Push    EDX

                Mov     AX, 40
                Mul     BP
                Mov     SI, AX
                Add     SI, 62000

                Pop     EDX
                Inc     BP

                Cmp     DWord Ptr [DS:SI], 0    ; Sample length = 0??
                JE      LoadXMSamplesInModule5

                Push    EDX

                Mov     AX, 96
                Mul     CS:NumSamples
                Mov     DI, AX

                Push    SI

                Mov     Byte Ptr [DI+88], 8
                Call    TransferFileName

                Mov     AL, 64
                StosB

                Pop     SI

                Mov     AH, [SI+12]     ; Default volume
                Mov     AL, 1

                Mov     CL, [SI+14]
                Test    CL, 10h
                JZ      LoadXMSamplesInModule7

                Or      AL, 2   ; 16-bit sample

LoadXMSamplesInModule7:
                And     CL, 3
                JZ      LoadXMSamplesInModule8 ; No loop
                                        ; CL = 1 or 2

                Cmp     DWord Ptr [SI+8], 1
                JBE     LoadXMSamplesInModule8

                Or      AL, 10h         ; Loop
                Dec     CX
                ShL     CL, 6
                Or      AL, CL

LoadXMSamplesInModule8:
                StosW

                Push    SI
                                        ; Sample name
                Add     SI, 18
                Mov     CX, 22/2
                Rep     MovsW

                Pop     SI

                Xor     AX, AX          ; Cleanup + conversion flags
                StosW
                StosW
                Mov     AH, [SI+15]     ; Default pan
                ShR     AH, 2
                AdC     AH, 80h
                Mov     AL, 5           ; Delta values, signed
                StosW

                Mov     EAX, [SI]
                Mov     [DI+20h], EAX         ; File size
                Call    LoadXISample5
                Mov     EAX, [SI+4]
                Call    LoadXISample5
                Mov     EAX, [SI+4]
                Add     EAX, [SI+8]
                Call    LoadXISample5

                                        ; C5speed..
                Push    ES
                Push    DI

                Call    Music_GetPitchTable     ; Returns ES:DI
                Mov     AL, [SI+16]     ; Relative note number
                Add     AL, 60          ; AL = note multiplier
                And     AX, 0FFh
                ShL     AX, 2
                Add     DI, AX
                Mov     ECX, [ES:DI]

                Mov     AL, [SI+13]     ; Finetune, -128->+127
                SAR     AL, 4           ; Finetune = -8->+7
                And     AX, 0Fh
                Add     AX, AX
                Mov     DI, AX
                MovZX   EAX, [CS:FineTuneTable+DI]

                Pop     DI
                Pop     ES

                Mul     ECX
                ShRD    EAX, EDX, 16
                StosD                   ; C5freq

                Xor     AX, AX
                StosW
                StosW
                StosW
                StosW
                                        ; Now position
                Mov     AX, 4201h
                Xor     CX, CX
                Xor     DX, DX
                Int     21h             ; Returns file position in DX:AX

                Push    AX
                ShRD    EAX, EDX, 16
                Pop     AX
                Pop     EDX
                Add     EAX, EDX
                StosD
                Xor     AX, AX
                StosW
                StosW

                Add     EDX, [DS:SI]
                Inc     CS:NumSamples
                Jmp     LoadXMSamplesInModule5

EndP            LoadXMSamplesInModule

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

KRZSampleOffset         DD      0
KRZSampleStartingOffset DD      0
KRZFileOffset           DD      0

Proc            LoadKRZSamples

                Mov     AH, 3Fh
                Mov     CX, 32
                Mov     DX, 64000
                Int     21h

                Mov     CS:KRZFileOffset, 32

                Mov     EAX, [DS:64000+4]               ; Sample start offset
                Call    SoftBSWAP

                Mov     CS:KRZSampleOffset, EAX
                Mov     CS:KRZSampleStartingOffset, EAX

LoadKRZSamples1:
                Mov     EDX, CS:KRZFileOffset
                Cmp     EDX, CS:KRZSampleStartingOffset
                JB      LoadKRZSamples2

                Ret

LoadKRZSamples2:
                Mov     AX, 4200h               ; Move to location in file
                SHLD    ECX, EDX, 16
                Int     21h

                Mov     AH, 3Fh
                Mov     CX, 1000
                Mov     DX, 64000
                Int     21h             ; Load .KRZ object

                Mov     AX, [DS:64000+6]                ; Block size
                XChg    AH, AL
                Add     AX, 7
                And     EAX, 0FFFCh
                Add     CS:KRZFileOffset, EAX

                Mov     AX, [DS:64000+4]        ; Sample object?
                Cmp     AL, 98h
                JB      LoadKRZSamples1
                Cmp     AL, 9Bh
                JA      LoadKRZSamples1

                Push    BX

                Mov     AX, 96
                Mul     CS:NumSamples
                Mov     DI, AX

                Mov     Byte Ptr [DI+88], 15    ; KRZ sample.
                Call    TransferFileName

                Mov     AL, 64                  ; Global volume
                StosB

                Mov     BX, [DS:64000+8]
                XChg    BH, BL
                Add     BX, 64000+20

 ; BX points to start of
 ; KRZSampleHdr

                Mov     AX, 4003h               ; Flags + Default volume
        ; sample present, 16-bit
                Mov     DL, [BX+1]

                Test    DL, 2           ; Bidir loop?
                JZ      LoadKRZSamples5

                Or      AL, 0C0h        ; Ping pong

LoadKRZSamples5:
                Test    DL, 80h         ; Loop off?
                JNZ     LoadKRZSamples6

                Mov     ECX, [BX+16]
                Cmp     ECX, [BX+20]
                JE      LoadKRZSamples6

                Or      AL, 10h         ; Loop on.

LoadKRZSamples6:
                StosW           ; Flags + DFV done.

; Sample name.

                Mov     SI, 64000+10
                Mov     CX, 26

LoadKRZSamples3:
                LodsB
                Test    AL, AL
                JZ      LoadKRZSamples4
                StosB
                Loop    LoadKRZSamples3

                Xor     AL, AL

LoadKRZSamples4:
                Rep     StosB

                Mov     AX, 1+2+32*256
                StosW                   ; Signed sample, default pan = 32

        ; Length
                Mov     EAX, [BX+8]
                Call    SoftBSWAP
                Mov     EBP, EAX

                Mov     EAX, [BX+20]
                Call    SoftBSWAP
                Sub     EAX, EBP
                StosD
                Add     EAX, EAX
                Mov     [DI+20h-4], EAX         ; File size

                Mov     EAX, [BX+16]    ; start of loop
                Call    SoftBSWAP
                Sub     EAX, EBP
                StosD
                Mov     EAX, [BX+20]
                Call    SoftBSWAP
                Sub     EAX, EBP
                Cmp     EAX, [ES:DI-4]
                JB      NextKRZ
                StosD

                Mov     EAX, [BX+28]
                Call    SoftBSWAP
                Mov     ECX, EAX

                Mov     EAX, 22000
                Test    ECX, ECX
                JZ      LoadKRZSamples7

                Xor     EDX, EDX
                Mov     EAX, 1000000000

                Div     ECX
                Test    EAX, EAX
                JNZ     LoadKRZSamples7

                Mov     EAX, 44100

LoadKRZSamples7:
                StosD           ; C5Speed

                Xor     EAX, EAX
                StosD
                StosD

                Mov     EAX, CS:KRZSampleOffset
                Add     EAX, EBP
                Add     EAX, EBP
                StosD

                Xor     EAX, EAX
                StoSD

                Inc     CS:NumSamples

NextKRZ:
                Pop     BX
                Jmp     LoadKRZSamples1

EndP            LoadKRZSamples

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            StorePATLength

                Test    DL, 1           ; 16-bit?
                JZ      StorePATLength1

                ShR     EAX, 1

StorePATLength1:
                StosD
                Ret

EndP            StorePATLength

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            LoadPATSamples

                Mov     AH, 3Fh
                Mov     CX, 129+63+47   ; 129 bytes for file header, 63 for
                                        ; instrument header, 47 for layer
                Mov     DX, 65000
                Int     21h

                Mov     BP, [DS:65000+129+63+6]
                And     BP, 0FFh        ; BP = number of waves.

LoadPATSamples1:
                Mov     AH, 3Fh
                Mov     DX, 64000
                Mov     CX, 96
                Int     21h             ; Read data in

                Mov     AX, 96
                Mul     CS:NumSamples
                Mov     DI, AX

                Inc     CS:NumSamples

                Mov     Byte Ptr [DI+88], 16    ; GUS Patch
                Call    TransferFileName

                Mov     AL, 64                  ; Global volume
                StosB

                Mov     AX, 4001h               ; sample present
                Mov     DL, [DS:64000+55]       ; modes

                Test    DL, 1                   ; 8/16 bit
                JZ      LoadPATSamples2

                Or      AL, 2

LoadPATSamples2:
                Test    DL, 4   ; Looping enabled?
                JZ      LoadPATSamples3

                Or      AL, 10h

LoadPATSamples3:
                Test    DL, 8   ; Ping pong loops?
                JZ      LoadPATSamples4

                Or      AL, 40h

LoadPATSamples4:
                StosW                   ; OK.. now for name.

                Mov     SI, 65000+129+2
                Mov     CX, 16

LoadPATSamples5:
                LodsB
                Test    AL, AL
                JZ      LoadPATSamples6
                StosB
                Loop    LoadPATSamples5

LoadPATSamples6:
                Add     CX, 9

                Mov     AL, ':'
                StosB
                Mov     SI, 64000

LoadPATSamples7:
                LodsB
                Test    AL, AL
                JZ      LoadPATSamples8
                StosB
                Loop    LoadPATSamples7

LoadPATSamples8:
                Xor     AL, AL
                Rep     StosB

                ; Convert, default pan

                Mov     AH, 32
                Mov     AL, [DS:64000+55]
                And     AL, 2
                ShR     AL, 1
                Xor     AL, 1
                StosW

                ; Length.

                Mov     DL, [DS:64000+55]

                Mov     EAX, [DS:64000+16]      ; ->Length
                Mov     [DI+20h], EAX           ; File size
                Call    StorePATLength

                Mov     EAX, [DS:64000+12]      ; LoopBeg
                Call    StorePATLength
                Mov     EAX, [DS:64000+16]      ; LoopEnd
                Call    StorePATLength

                Mov     AX, [DS:64000+20]
                And     EAX, 0FFFFh
                StosD                           ; C5Spd

                Xor     EAX, EAX
                StosD
                StosD

                Mov     AX, 4201h
                Xor     CX, CX
                Xor     DX, DX
                Int     21h             ; Current position.

                StosW
                Mov     AX, DX
                StosW

                Xor     AX, AX
                StosW
                StosW

                Mov     AX, 4201h
                Mov     CX, [DS:64000+10]
                Mov     DX, [DS:64000+8]
                Int     21h

                Dec     BP
                JNZ     LoadPATSamples1

                Ret

EndP            LoadPATSamples

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

