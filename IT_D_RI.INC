;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Load Instrument module
;
; Instrument in .ITI format has to be placed at DS:64000
; Sample headers have to be placed at DS:0
;
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            LoadITInstrument

                Mov     DX, 64000
                Mov     CX, 554         ; Length of instrument header
                Mov     AH, 3Fh
                Int     21h

                Cmp     Word Ptr [DS:64000+1Ch], 200h
                JAE     LoadITInstrument1

                Mov     SI, DX
                Call    ConvertOldInstrument

LoadITInstrument1:
                Mov     AX, [DS:64000+1Eh]      ; AX = number of samples
                Mov     DX, 80
                Mul     DX                      ; Clears DX, AX = size in bytes
                Mov     CX, AX

;                Xor     DX, DX
;                Mov     CX, DI
                JCXZ    LoadITInstrument2

                Mov     AH, 3Fh
                Int     21h             ; All sample headers are loaded too.
                                        ; Step 2 done.

LoadITInstrument2:
                Ret

EndP            LoadITInstrument

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

InstrumentNameOffset    DW      0
XISampleOffset          DD      0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            LoadXIInstrument        ; Must preserve DS, BX

                Push    DS
                Pop     ES

                Mov     DX, 63000
                Mov     CX, 298         ; Length of instrument header
                Mov     AH, 3Fh
                Int     21h

                Mov     AX, [DS:63000+296]      ; NoS
                Mov     CS:NumInstrumentSamples, AX
                Mov     CS:InstrumentNameOffset, 63000+21
                Mov     CS:XISampleOffset, 298

                                        ; Now to transfer data across
                                        ; to 64000 in ITI format
LoadXIChain:
                Mov     DI, 64000
                Mov     EAX, 'IPMI'     ; Header
                StosD

                Xor     AX, AX
                Mov     CX, 8
                Rep     StosW           ; Filename, NNA, DCA, DCT

                Mov     AX, [DS:63000+272]
                Add     AX, 15
                ShR     AX, 5
                Cmp     AX, 256
                JB      LoadXIInstrumentFdOut

                Mov     AX, 256

LoadXIInstrumentFdOut:
                StosW                           ; Fadeout

                Mov     AX, 60*256
                StosW                           ; PPC and PPS
                Mov     AX, 128+32*256
                StosW                           ; GBV and DfP
                Xor     AX, AX
                StosW
                StosW
                Mov     AX, CS:NumInstrumentSamples
                StosW
                Xor     AX, AX

                Mov     SI, CS:InstrumentNameOffset
                Mov     CX, 22/2
                Rep     MovsW
                Mov     CX, 5
                Rep     StosW                   ; Clear up end of inst name

                ; Translation table
                Mov     CX, 12                  ; First 12 entries empty
                Xor     AX, AX

LoadXIInstrument1:
                StosW
                Inc     AX
                Loop    LoadXIInstrument1

                Mov     SI, 63000+66
                Mov     CX, 96

LoadXIInstrument2:
                Mov     AH, [SI]
                Inc     AH
                StosW

                Inc     AX
                Inc     SI
                Loop    LoadXIInstrument2

                Mov     CX, 12                  ; Last 12 entries empty
                Xor     AH, AH

LoadXIInstrument3:
                StosW
                Inc     AX
                Loop    LoadXIInstrument3

                                                ; Now for volume envelope
                Mov     AL, [DS:63000+266]      ; Flags
                Mov     CL, AL
                Mov     AH, AL
                And     AX, 402h
                ShR     AH, 1
                ShL     AL, 1
                Or      AL, AH
                And     CL, 1
                Or      AL, CL

                Mov     AH, [DS:63000+258]      ; No of vol env nodes
                Cmp     AH, 12
                JB      NumXIVolNodes1

                Mov     AH, 12

NumXIVolNodes1:
                StosW
                Mov     AX, [DS:63000+261]      ; Vol loop start+end
                StosW
                Mov     AL, [DS:63000+260]      ; Vol Sustain point
                Mov     AH, AL
                StosW

                                ; OK. now process volume env points
                Mov     CX, 12

LoadXIInstrument4:
                Mov     AL, [SI+2]
                Cmp     AL, 64
                JB      LoadXICheckVolBound1

                Mov     AL, 64

LoadXICheckVolBound1:
                StosB
                MovsW
                LodsW
                Loop    LoadXIInstrument4

                Mov     CX, 13*3+1
                Xor     AX, AX
                Rep     StosB

                        ; Now for panning envelope

LoadXIInstrument5:
                Mov     AL, [DS:63000+267]      ; Flags
                Mov     CL, AL
                Mov     AH, AL
                And     AX, 402h
                ShR     AH, 1
                ShL     AL, 1
                Or      AL, AH
                And     CL, 1
                Or      AL, CL

                Mov     AH, [DS:63000+259]      ; No of pan env nodes
                Cmp     AH, 12
                JB      NumXIPanNodes1

                Mov     AH, 12

NumXIPanNodes1:
                StosW
                Mov     AX, [DS:63000+264]      ; Pan loop start+end
                StosW
                Mov     AL, [DS:63000+263]      ; Pan Sustain point
                Mov     AH, AL
                StosW

                                ; OK. now process panning env points
                Mov     CX, 12
                Xor     AH, AH

LoadXIInstrument6:
                Mov     AL, [SI+2]
                Cmp     AL, 64
                JB      LoadXICheckPanBound

                Mov     AL, 64

LoadXICheckPanBound:
                Sub     AL, 32
                StosB
                MovsW
                LodsW                   ; Add SI, 2
                Loop    LoadXIInstrument6

                Mov     CX, 13*3+1
                Xor     AX, AX
                Rep     StosB

                ; Now for pitch envelope
                Mov     AX, 2*256       ; 2 node points
                StosW
                Xor     AX, AX
                StosW
                StosW

                        ; First node is 0, 0, second node is 0, 99
                StosW
                StosW
                Mov     AX, 99
                StosW

                Mov     CX, 75-6
                Xor     AX, AX
                Rep     StosB

                Cmp     Byte Ptr [DS:64000+131h], 2
                JAE     LoadXIInstrumentVolEnvelopeCheck1

                Mov     Byte Ptr [DS:64000+131h], 2
                Mov     Word Ptr [DS:64000+136h], 64
                Mov     Word Ptr [DS:64000+138h], 64*256
                Mov     Word Ptr [DS:64000+13Ah], 100

LoadXIInstrumentVolEnvelopeCheck1:

                Cmp     Byte Ptr [DS:64000+183h], 2
                JAE     LoadXIInstrumentPanEnvelopeCheck1

                Mov     Byte Ptr [DS:64000+183h], 2
                Xor     AX, AX
                Mov     [DS:64000+188h], AX
                Mov     [DS:64000+18Ah], AX
                Mov     Word Ptr [DS:64000+18Ch], 100

LoadXIInstrumentPanEnvelopeCheck1:

                                ; OK. instrument done.
                                ; Now have to load samples
                        ; Bytes to load = 40*NoS
                Mov     AX, 40
                Mul     Word Ptr [DS:64000+1Eh]
                Mov     CX, AX

                Mov     DX, 62000
                Mov     AH, 3Fh
                Int     21h

                Mov     EDX, CS:XISampleOffset          ; EDX = offset in file
                Add     DX, CX

                Xor     DI, DI
                Mov     SI, 62000
                Mov     CX, [DS:64000+1Eh]

LoadXISample1:
                Push    CX

                Mov     EAX, 'SPMI'
                StosD
                Xor     AX, AX
                Mov     CX, 6
                Rep     StosW
                Mov     AX, 64*256
                StosW
                                ; Flg
LoadXISample2:
                Mov     AH, [SI+12]     ; Default volume
                Mov     AL, 0
                Cmp     DWord Ptr [SI], 0       ; Length = 0?
                JE      LoadXISample4

                Mov     AL, 1

                Mov     CL, [SI+14]
                Test    CL, 10h
                JZ      LoadXISample3

                Or      AL, 2   ; 16-bit sample

LoadXISample3:
                And     CL, 3
                JZ      LoadXISample4   ; No loop
                                        ; CL = 1 or 2
                Cmp     DWord Ptr [SI+8], 1
                JBE     LoadXISample4

                Or      AL, 10h         ; Loop
                Dec     CX
                ShL     CL, 6
                Or      AL, CL

LoadXISample4:
                StosW

                Push    SI
                                        ; Copy sample name
                Add     SI, 18
                Mov     CX, 22/2
                Rep     MovsW
                Xor     AX, AX
                StosW
                StosW

                Pop     SI
                                        ; Conversion flags, default pan
                Mov     AL, 5
                Mov     AH, [SI+15]     ; Pan
                ShR     AH, 2
                AdC     AH, 80h
                StosW

                Mov     EAX, [SI]
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

                Push    EDX

                Mul     ECX
                ShRD    EAX, EDX, 16
                Pop     EDX
                StosD                   ; C5freq

                Xor     AX, AX
                StosW
                StosW
                StosW
                StosW

                Mov     EAX, EDX
                Add     EDX, [SI]
                StosD
                Xor     AX, AX
                StosW
                StosW

                Pop     CX
                Add     SI, 40
                Loop    LoadXISample1

                Ret

LoadXISample5:
                Cmp     EAX, 4177910
                JB      LoadXISample6

                Mov     EAX, 4177910
LoadXISample6:
                Test    Byte Ptr [SI+14], 10h
                JZ      LoadXISample7

                ShR     EAX, 1

LoadXISample7:
                StosD
                RetN

EndP            LoadXIInstrument

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            LoadInITInstrument

                Mov     AH, 3Fh
                Mov     CX, 2000
                Mov     DX, 62000
                Int     21h             ; Read header into 62000

                Mov     AX, 4200h
                Mov     CX, Word Ptr [CS:LoadInstrumentOffset+2]
                Mov     DX, Word Ptr [CS:LoadInstrumentOffset]
                Int     21h             ; Goto location

                Mov     AH, 3Fh         ; Load instrument data
                Mov     CX, 554
                Mov     DX, 64000
                Int     21h

                Cmp     Word Ptr [DS:62000+2Ah], 200h
                JAE     LoadInITInstrument1

                Mov     SI, 64000
                Call    ConvertOldInstrument

LoadInITInstrument1:                    ; Convert Note table and load
                                        ; Sample headers.
                Mov     SI, 64000+41h
                Xor     CX, CX

LoadInITInstrument2:
                Mov     DI, [SI]
                And     DI, 0FFh                ; DI = sample number
                JZ      LoadInITInstrument3
                Cmp     DI, [DS:62000+24h]      ; Sample exists?
                JA      LoadInITInstrument3
                Cmp     Byte Ptr [CS:InstrumentTable+DI], 0
                JNE     LoadInITInstrument3

                Inc     CX                      ; CL = sample number
                Mov     [CS:InstrumentTable+DI], CL

                Push    SI
                Push    CX

                Add     DI, [DS:62000+22h]
                ShL     DI, 2
                Add     DI, [DS:62000+20h]
                Add     DI, 62000+0C0h-4        ; Samples are 0 based, not 1

                Mov     AX, 4200h               ; Move to offset of sample
                Mov     CX, [DI+2]
                Mov     DX, [DI]
                Int     21h

                Pop     AX
                Push    AX

                Dec     AX
                Mov     CX, 80
                Mul     CX
                Mov     DX, AX

                Mov     AH, 3Fh
                Int     21h                     ; Load sample header.

                Pop     CX
                Pop     SI

LoadInITInstrument3:
                Add     SI, 2
                Cmp     SI, 64000+41h+120*2
                JB      LoadInITInstrument2

                Mov     [DS:64000+1Eh], CX

                                                ; Process translation table
                Mov     SI, 64000+41h

LoadInITInstrument4:
                Mov     DI, [SI]
                And     DI, 0FFh
                Mov     AL, [CS:InstrumentTable+DI]
                Mov     [SI], AL

                Add     SI, 2
                Cmp     SI, 64000+41h+120*2
                JB      LoadInITInstrument4

                Mov     DI, Offset InstrumentTable
                Xor     AX, AX
                Mov     CX, 50
                Rep     StosW

                Ret

EndP            LoadInITInstrument

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            LoadInXMInstrument

                Mov     AX, 4200h
                Mov     CX, Word Ptr [CS:LoadInstrumentOffset+2]
                Mov     DX, Word Ptr [CS:LoadInstrumentOffset]
                Int     21h             ; Goto location

                Mov     AH, 3Fh
                Mov     CX, 4
                Mov     DX, 63000
                Int     21h

                Mov     AH, 3Fh
                Mov     CX, [DS:63000]
                Sub     CX, 4
                Mov     DX, 63033+4
                Int     21h

                Mov     AX, [DS:63033+27]
                Mov     CS:NumInstrumentSamples, AX
                Mov     CS:InstrumentNameOffset, 63033+4

                Mov     AX, 4201h
                Xor     CX, CX
                Xor     DX, DX
                Int     21h                     ; DX:AX = fileoffset

                Mov     Word Ptr [CS:XISampleOffset], AX
                Mov     Word Ptr [CS:XISampleOffset+2], DX

                Push    DS
                Pop     ES

                Jmp     LoadXIChain

EndP            LoadInXMInstrument

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            TransferInstrumentName

                Mov     AX, 48
                Mul     CS:NumInstruments
                Inc     CS:NumInstruments

                Mov     DI, AX

                Push    DS

                Push    CS
                Pop     DS

                Mov     AL, CL
                StosB
                Mov     SI, Offset InInstrumentFileName
                Mov     CX, 14
                Rep     MovsB
                Mov     EAX, LoadInstrumentOffset
                Mov     [ES:DI+44-15], EAX

                Pop     DS

                Ret

EndP            TransferInstrumentName

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

; 'InstrumentTable' scratchpad

LoadInstrumentOffset    DD      0
NumInstrumentSamples    DW      0

Proc            LoadITInModuleInstrument

                Mov     AH, 3Fh
                Mov     CX, 2000
                Mov     DX, 63000
                Int     21h

                Xor     BP, BP

                Push    ES

                Push    CS                      ; Clear InstrumentTable
                Pop     ES

                Mov     DI, Offset InstrumentTable
                Mov     CX, 100
                Xor     AL, AL
                Rep     StosB

                Pop     ES

LoadITInModuleInstrument1:
                Cmp     BP, [DS:63000+22h]      ; InsNum
                JB      LoadITInmoduleInstrument2

                Ret

LoadITInModuleInstrument2:
                Mov     SI, BP
                ShL     SI, 2

                Inc     BP

                Add     SI, [DS:63000+20h]
                Add     SI, 63000+0C0h

                Mov     AX, 4200h               ; Move file pointer.
                Mov     CX, [SI+2]
                Mov     DX, [SI]

                Mov     Word Ptr [CS:LoadInstrumentOffset], DX
                Mov     Word Ptr [CS:LoadInstrumentOffset+2], CX

                Int     21h

                Mov     AH, 3Fh
                Mov     CX, 554
                Mov     DX, 62000
                Int     21h

                Mov     SI, 62000+41h

LoadITInModuleInstrument3:
                LodsW
                And     AX, 0FFh
                Mov     DI, AX

                Cmp     AL, 100
                JAE     LoadITInModuleInstrument5

                Mov     [CS:InstrumentTable+DI], 1

LoadITInModuleInstrument5:
                Cmp     SI, 62000+41h+120*2
                JB      LoadITInModuleInstrument3

                                                ; Now to count samples
                                                ; and clear table.
                Mov     DI, 99
                Xor     DX, DX                  ; DX = number of samples.

LoadITInModuleInstrument4:
                Cmp     Byte Ptr [CS:InstrumentTable+DI], 1
                JNE     LoadITInModuleInstrument6

                Inc     DX
                Mov     Byte Ptr [CS:InstrumentTable+DI], 0

LoadITInModuleInstrument6:
                Dec     DI
                JNZ     LoadITInModuleInstrument4

                Test    DX, DX
                JZ      LoadITInModuleInstrument1

                Push    DX

                Mov     CL, 5                   ; In-Module .IT Instrument
                Call    TransferInstrumentName

                Mov     SI, 62000+20h
                Mov     CX, 25
                Rep     MovsB

                Pop     AX
                StosW
                Xor     AX, AX
                StosW

                Jmp     LoadITInModuleInstrument1

EndP            LoadITInModuleInstrument

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Proc            LoadXMInModuleInstrument

                Call    LoadXMHeader    ; Reads to first instrument

                Xor     BP, BP

LoadXMInModuleInstrument1:
                Cmp     BP, [DS:64000+72]
                JB      LoadXMInModuleInstrument2

                Ret

LoadXMInModuleInstrument2:
                Inc     BP

                Mov     AX, 4201h
                Xor     CX, CX
                Xor     DX, DX
                Int     21h             ; Get current file location

                Mov     Word Ptr [CS:LoadInstrumentOffset], AX
                Mov     Word Ptr [CS:LoadInstrumentOffset+2], DX

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
                JZ      LoadXMInModuleInstrument1

                Mov     CX, 40
                Mul     CX
                Mov     CX, AX
                Mov     AH, 3Fh
                Mov     DX, 62000
                Int     21h                     ; OK sample headers read
                                                ; into DS:62000

                Mov     CL, 6                   ; In-Module .XM Instrument
                Call    TransferInstrumentName

                Mov     SI, 63004
                Mov     CX, 22
                Rep     MovsB
                Xor     AX, AX
                StosB
                StosW

                Mov     AX, [DS:63000+27]
                Mov     CX, AX
                StosW
                Xor     AX, AX
                StosW

                Xor     EDX, EDX
                Mov     SI, 62000

LoadXMInModuleInstrument3:
                Add     EDX, [SI]
                Add     SI, 40

                Dec     CX
                JNZ     LoadXMInModuleInstrument3

                SHLD    ECX, EDX, 16
                Mov     AX, 4201h
                Int     21h
                                        ; Advance file pointers..
                Jmp     LoadXMInModuleInstrument1

EndP            LoadXMInModuleInstrument

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
