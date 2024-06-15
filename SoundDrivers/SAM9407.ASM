
        .386P

Segment                 DriverHeader PARA Public 'Code' Use16
                        Assume CS:Driver, DS:Nothing

;***** Driver Header *******

include drhead.inc

EndS

Segment                 Driver PARA Public 'Code' Use16
                        Assume CS:Driver, DS:Nothing

ORG 0
StartDriver:

include vtable.inc

;********  Required ProcedureTable *************

include reqproc.inc

;***********************************************

NUMMEMORYBLOCKS EQU     64

PNPSERIALID     EQU     0FFFFFFFFh
PNPVENDORID     EQU     80719304h

MMT_MAXENTRIES  EQU     64
MMT_MAXSIZE     EQU     3*MMT_MAXENTRIES


SAM_RD_MEM      EQU     2h
SAM_GET_MMT     EQU     3h
SAM_GEN_INT     EQU     48h
SAM_GET_VOI     EQU     51h
SAM_VOI_OPEN    EQU     52h
SAM_VOI_CLOSE   EQU     53h
SAM_VOI_START   EQU     54h
SAM_VOI_STOP    EQU     55h
SAM_VOI_VOL     EQU     56h
SAM_VOI_MAIN    EQU     57h
SAM_VOI_PITCH   EQU     58h
SAM_VOI_AUX     EQU     59h
SAM_VOI_FILT    EQU     5Ah
SAM_VOI_MEM     EQU     5Bh
SAM_GET_POS     EQU     5Ch
SAM_ADD_POS     EQU     5Dh

SAM9407Message  DB      "Dream SAM9407 Detected", 13
                DB      "Port ", 0FDh, "Xh, ", 0FDh, "Dk RAM", 0

StatusLine      DB      "FreeSAM ", 0FDh, "Dk", 0

SAMUpdateFlag   DB      0

ALIGN 4
OldIRQHandler           DD      0
SAMUpdateTimer          DW      0
SAMUpdateCount          DW      0

MMTData                 DW      MMT_MAXSIZE Dup (0)

MemoryBlocks            DD      NUMMEMORYBLOCKS*2 Dup (0)
    ; Memory blocks are offset/size pairs.

SampleInformation       DD      100*4 Dup (0)
                ; Sample data is a struct
                ; Offset 0: Starting address
                ; Offset 4: Loop start
                ; Offset 8: Loop end
                ; Offset 0Ch: ??

SlaveChannelOffset      DW      0

; ÄÄ EmptyFunction ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            EmptyFunction Far

                Xor     AX, AX
                StC
                Ret

EndP            EmptyFunction

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SAM9407ReceiveByte      ; Returns AL = data
                                        ;         BL = status

                Push    DX
                Mov     DX, CS:BasePort
                Inc     DX

SAM9407ReceiveByte1:
                In      AL, DX
                Test    AL, AL
                JS      SAM9407ReceiveByte1

                Mov     BL, AL
                Dec     DX
                And     BL, 30h

                In      AL, DX
                Pop     DX

                Ret

EndP            SAM9407ReceiveByte

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SAM9407ReceiveWord     ; Returns AX

                Call    SAM9407ReceiveByte
                Mov     AL, AH
                Call    SAM9407ReceiveByte
                XChg    AL, AH

                Ret

EndP            SAM9407ReceiveWord

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SAM9407ReceiveDWord     ; Returns EAX

                Call    SAM9407ReceiveByte
                RoR     EAX, 8
                Call    SAM9407ReceiveByte
                RoR     EAX, 8
                Call    SAM9407ReceiveByte
                RoR     EAX, 8
                Call    SAM9407ReceiveByte
                RoR     EAX, 8

                Ret

EndP            SAM9407ReceiveDWord

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SAM9407SendControlByte    ; BL = data

                Push    AX
                Push    DX

                Mov     DX, CS:BasePort
                Inc     DX

SAM9407SendControlByte1:
                In      AL, DX
                Test    AL, 40h
                JNZ     SAM9407SendControlByte1

                Mov     AL, BL
                Out     DX, AL

                Pop     DX
                Pop     AX

                Ret

EndP            SAM9407SendControlByte

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SAM9407SendDataByte    ; AL = data

                Push    DX
                Push    AX

                Mov     DX, CS:BasePort
                Inc     DX

SAM9407SendDataByte1:
                In      AL, DX
                Test    AL, 40h
                JNZ     SAM9407SendDataByte1

                Pop     AX
                Dec     DX

                Out     DX, AL

                Pop     DX

                Ret

EndP            SAM9407SendDataByte

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SAM9407SendDataWord     ; AX = data

                Call    SAM9407SendDataByte
                Mov     AL, AH
                Call    SAM9407SendDataByte
                Ret

EndP            SAM9407SendDataWord

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SAM9407SendDataDWord    ; EAX = data

                Call    SAM9407SendDataByte
                ShR     EAX, 8
                Call    SAM9407SendDataByte
                ShR     EAX, 8
                Call    SAM9407SendDataByte
                ShR     AX, 8
                Call    SAM9407SendDataByte
                Ret

EndP            SAM9407SendDataDWord

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SAM9407ReceiveString    ; ES:DI points to deposit point.
                                        ; EAX = memory address
                                        ; CX = count

                Mov     BL, SAM_RD_MEM
                Call    SAM9407SendControlByte
                Call    SAM9407SendDataDWord
                Mov     AX, CX
                Call    SAM9407SendDataWord

SAM9407InString1:
                Call    SAM9407ReceiveByte
                Cmp     AL, 0ABh
                JE      SAM9407InStringError
                Cmp     AL, 0ACh
                JNE     SAM9407InString1

SAM9407InString2:
                Mov     DX, CS:BasePort
                Add     DX, 2

                Rep     InsW

                DB      85h

SAM9407InStringError:
                StC
                Ret

EndP            SAM9407ReceiveString

; ÄÄ DetectCard ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
; Returns carry set if error, else carry clear. Has to setup internal vars
; (eg. appropriate IRQ/DMA whatever).
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ResetWaitforSend     ; Given DX = control port

                Xor     CX, CX

ResetWaitforSend1:
                In      AL, DX
                Test    AL, 40h
                LoopNZ  ResetWaitforSend
                Ret

EndP            ResetWaitforSend

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ResetWaitforReceive

                Xor     CX, CX

ResetWaitforReceive1:
                In      AL, DX
                Test    AL, 80h
                JNZ     ResetWaitforReceive2

                Dec     DX
                In      AL, DX
                Inc     DX
                Cmp     AL, 0FEh
                JE      ResetWaitforReceive3

ResetWaitforReceive2:
                Loop    ResetWaitforReceive1

                StC
                Ret

ResetWaitforReceive3:
                ClC
                Ret

EndP            ResetWaitforReceive

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SAMSendChannelNumber

                Mov     AX, SI
                Sub     AX, CS:SlaveChannelOffset
                ShR     AX, 7
                Call    SAM9407SendDataByte

                Ret

EndP            SAMSendChannelNumber

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SAMOpenVoice

                Cmp     Byte Ptr [SI+2], 1
                JE      SAMOpenVoice1           ; Already opened!

                Mov     Byte Ptr [SI+2], 1

                Mov     BL, [SI+36h]    ; Sample number
                Xor     DH, DH
                And     BX, 0FFh
                ShL     BX, 4

                Mov     DL, [Byte Ptr CS:SampleInformation+BX+3]
                Sub     DL, [Byte Ptr CS:SampleInformation+BX+7]
                                ; Carry 0 if inbank
                                ; Carry 1 if crossbank

                SBB     DL, DL  ; DL = 0 inbank
                                ; DL = 0FFh crossbank

                ShL     DL, 7   ; DL = 0 inbank
                                ; DL = 80h crossbank

                Mov     BL, SAM_VOI_OPEN
                Call    SAM9407SendControlByte

                Mov     AX, SI
                Sub     AX, CS:SlaveChannelOffset
                ShR     AX, 7
                Or      AL, DL
                Call    SAM9407SendDataByte

SAMOpenVoice1:
                Ret

EndP            SAMOpenVoice

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SAMStopNote     ; Closes the voice.

                Cmp     Byte Ptr [SI+2], 1
                JNE     SAMStopNote1

                Mov     Byte Ptr [SI+2], 0
                Mov     BL, SAM_VOI_CLOSE
                Call    SAM9407SendControlByte
                Call    SAMSendChannelNumber

SAMStopNote1:
                Ret


EndP            SAMStopNote

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SAMSetVolume

                Cmp     Byte Ptr [SI+2], 1
                JNE     SAMSetVolume1

                Mov     BL, SAM_VOI_VOL
                Call    SAM9407SendControlByte
                Call    SAMSendChannelNumber
                Mov     AL, [SI+20h]
                Call    SAM9407SendDataByte

SAMSetVolume1:
                Ret

EndP            SAMSetVolume

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SAMSetPan

                Cmp     Byte Ptr [SI+2], 1
                JNE     SAMSetPan1

Comment ~
                Mov     BL, SAM_VOI_PAN
                Call    SAM9407SendControlByte
                Call    SAMSendChannelNumber
                Mov     AL, [SI+37h]
                Call    SAM9407SendDataByte
~
SAMSetPan1:
                Ret

EndP            SAMSetPan

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SAMSetPitch

; Pitch value sent is 400h for nominal frequency of 37.5khz, linear scale
; -> Value sent = Frequency*400h / 37500
;               = Frequency * 0.02730666
;               = Frequency * 117281240 / 2^32

                Cmp     Byte Ptr [SI+2], 1
                JNE     SAMSetPitch3

                Mov     EAX, 117281240
                Mul     DWord Ptr [SI+10h]

                Cmp     EDX, 0FFFFh
                JA      SAMSetPitch1

                Mov     BL, SAM_VOI_PITCH
                Call    SAM9407SendControlByte
                Call    SAMSendChannelNumber
                Mov     AX, DX
                Call    SAM9407SendDataWord

SAMSetPitch3:
                Ret

SAMSetPitch1:
                Call    SAMStopNote

                Mov     Word Ptr [SI], 200h
                Test    Byte Ptr [SI+3Ah], 80h
                JNZ     SAMSetPitch2

                Mov     BX, [SI+38h]
                And     Byte Ptr [BX], Not 4    ; Signify channel off

SAMSetPitch2:
                Ret

EndP            SAMSetPitch

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SAMSetRegisters

; First get offset of currently playing notes

; Update Registers to play notes

; Flow is as follows:
;  If new note, open voice
;
;  If pitch change, set pitch
;  If volume change, set volume + filters
;
PlayNote:

                Ret

EndP            SAMSetRegisters

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SAMIRQHandler                   ; IRQ Handler has to
                                                ; 1) Update GUS registers
                                                ; 2) Update song position
                Push    AX
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     AX, SAMUpdateTimer
                Add     SAMUpdateCount, AX
                JC      SAMIRQHandler1

                Mov     AL, 20h
                Out     20h, AL
                Jmp     SAMIRQHandler2

SAMIRQHandler1:
                PushF
                Call    [OldIRQHandler]

SAMIRQHandler2:
                Xor     SAMUpdateFlag, 1
                JZ      SAMIRQHandlerEnd

                PushAD
                Push    ES

                ClD

                Call    SaveEMSPageFrame
                Call    Update          ; Returns DS:SI, CX
                        Assume DS:Nothing

                Mov     SlaveChannelOffset, SI

                Call    SAMSetRegisters
                Call    RestoreEMSPageFrame

                Pop     ES
                PopAD

SAMIRQHandlerEnd:
                Pop     DS
                Pop     AX
                IRet

EndP            SAMIRQHandler

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ResetUART              ; Given DX = Port

                Inc     DX

                Mov     AL, 0FFh        ; Reset!
                Out     DX, AL
                Out     DX, AL          ; Two resets required to ensure it'll work

                Call    ResetWaitforReceive
                JNC     ResetUART1

ResetUARTError:
                StC
                Ret

ResetUART1:                    ; Now to shove it into 'intelligent' mode.
                Call    ResetWaitforSend
                JNZ     ResetUARTError

                Mov     AL, 3Fh         ; Intelligent mode!
                Out     DX, AL

                Call    ResetWaitforReceive
                JC      ResetUARTError

                Call    ResetWaitforSend
                JNZ     ResetUARTError

                Mov     AL, SAM_GEN_INT
                Out     DX, AL

                Call    ResetWaitforSend
                JNZ     ResetUARTError

                Dec     DX
                Xor     AL, AL
                Out     DX, AL
                Inc     DX

                Xor     CX, CX

ResetUART2:
                In      AL, DX
                Test    AL, 80h
                JNZ     ResetUART3

                Mov     AH, AL
                Dec     DX
                In      AL, DX
                Inc     DX
                And     AH, 30h
                Cmp     AX, 3088h
                JE      ResetUART4

ResetUART3:
                Loop    ResetUART2
                Jmp     ResetUARTError

ResetUART4:
                Call    ResetWaitforReceive
                JC      ResetUARTError

                Dec     DX

                ClC
                Ret

EndP            ResetUART

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DetectCard Far          ; returns carry clear if succesful

                Push    CS
                Pop     DS

; Check whether the MPU can be reset
                Mov     DX, BasePort
                Cmp     DX, 0FFFFh
                JE      DetectCard1

                Call    ResetUART
                JNC     DetectCardFound

DetectCardExit:
                Ret

DetectCard1:
                Mov     DX, 330h
                Call    ResetUART
                JNC     DetectCard2

                Mov     DX, 300h
                Call    ResetUART
                JC      DetectCardExit

DetectCard2:
                Mov     BasePort, DX

DetectCardFound:
; Find memory mapping table,
                Mov     BL, SAM_GET_MMT
                Xor     AL, AL
                Call    SAM9407SendControlByte
                Call    SAM9407SendDataByte
                Call    SAM9407ReceiveDWord

                Push    CS
                Pop     ES
                Mov     CX, MMT_MAXSIZE
                Mov     DI, Offset MMTData
                Call    SAM9407ReceiveString

                Mov     EAX, 'Jeff'
                Ret

EndP            DetectCard
                Assume DS:Nothing

;ÄÄ InitSound ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
; Sets up any memory required for output
; Initiates output
;
; Parameters: AX = Number of Channels
;
; If sucessful, returns:
;   Carry flag clear
;   DS:SI = pointer to text to display
;      AX = parameter 1 in text
;      BX = parameter 2 in text
;      CX = parameter 3 in text
;      DX = parameter 4 in text
;      DI = parameter 5 in text
;
; If unsucessful, returns:
;   Carry flag set
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            InitSound Far

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     AL, 34h         ; Program IRQ 0. LSB&MSB, Rate gen
                Out     43h, AL

                Call    GetTempo
                Call    SetTempo
                Call    ResetMemory

                Xor     AX, AX
                Mov     ES, AX          ; ES = 0

                Mov     AX, CS
                ShL     EAX, 16
                Mov     AX, Offset SAMIRQHandler

                ClI

                XChg    DWord Ptr [ES:20h], EAX         ; Clock tick
                Mov     OldIRQHandler, EAX

                StI

                Mov     SI, Offset SAM9407Message
                Xor     BX, BX

Comment ~
                Mov     BL, SAM_GET_VOI
                Xor     AL, AL
                Call    SAM9407SendControlByte
                Call    SAM9407SendDataByte
                Call    SAM9407ReceiveByte
                Mov     BL, AL
~
                Mov     AX, BasePort
                Mov     EBX, DWord Ptr [MMTData+2]
                ShR     EBX, 9

                ClC
                Ret

EndP            InitSound
                Assume DS:Nothing

;ÄÄ ReInitSound ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
; Reinitialises sound output
; Initiates sound output
;
; Parameters: AX = number of channels.
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ReInitSound Far

                Ret

EndP            ReInitSound

;ÄÄ UnInitSound ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
; Stops sound output, releases any memory used by driver
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            UnInitSound Far

                Mov     BL, 0FFh
                Call    SAM9407SendControlByte

                Mov     AL, 34h
                Out     43h, AL

                Xor     AX, AX
                Out     40h, AL
                Out     40h, AL

                Mov     ES, AX
                Mov     EAX, OldIRQHandler
                Mov     [ES:20h], EAX

                Ret

EndP            UnInitSound

;ÄÄ Poll ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
; This procedure is called as often as possible by IT.EXE
; AX = Playmode (0 for nothing in particular, 1 = pattern, 2 = song)
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Poll Far

                Ret

EndP            Poll

;ÄÄ SetTempo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
; Parameters: BX = tempo
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetTempo Far    ; BX = tempo...

                Push    AX
                Push    BX
                Push    DX

                                        ; Frames per second = 2 * (0.4*Tempo)
                Mov     AX, 0C214h
                Mov     DX, 16h         ; Ticks = (1193181/(2*0.4))/Tempo
                Div     BX

                                        ; AX contains counter.
                Mov     CS:SAMUpdateTimer, AX

                Out     40h, AL         ; Timer IRQ.
                Mov     AL, AH
                Out     40h, AL

                Pop     DX
                Pop     BX
                Pop     AX
                Ret

EndP            SetTempo

;ÄÄ SetMixVolume ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
; Parameters: AX = MixVolume
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetMixVolume Far

                Ret

EndP            SetMixVolume

;ÄÄ SetStereo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
; Parameters: AL = Stereo on/off, 0 = off.
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetStereo Far

                Ret

EndP            SetStereo

;ÄÄ LoadSample ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
; Parameters: AX = sample to load (0 based)
;             DS:SI points to sample header
;             ES:0 points to first sample
;
; Returns: **Carry set if NO error**
;          **Carry clear if error**
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            LoadSample Far

                StC
                Ret

EndP            LoadSample

;ÄÄ ReleaseSample ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
; Parameters: AX = sample to release (1 based)
;             DS:SI points to sample header
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ReleaseSample Far

                Ret

EndP            ReleaseSample

;ÄÄ ResetMemory ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
;  Frees all on-board memory
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ResetMemory Far

                PushA
                Push    DS
                Push    ES

                Push    CS
                Pop     DS
                Push    CS
                Pop     ES

                Mov     SI, Offset MMTData+6
                Mov     DI, Offset MemoryBlocks

ResetMemory1:
                Mov     AX, [SI]
                Add     SI, 6

                Cmp     AX, -1
                JE      ResetMemory2

                Cmp     AX, 1
                JNE     ResetMemory1

                Mov     EAX, [SI-4]
                StosD
                Neg     EAX
                Add     EAX, [SI+2]
                StosD
                Jmp     ResetMemory1

ResetMemory2:
                Mov     CX, Offset MemoryBlocks+NUMMEMORYBLOCKS*2*4
                Sub     CX, DI
                Xor     AX, AX
                ShR     CX, 1
                Rep     StosW

                Pop     ES
                Pop     DS
                PopA
                Ret

EndP            ResetMemory

;ÄÄ GetStatus ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
;  Returns text to show on status line, AX = display parameter
;  Carry set if not to show anything.
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetStatus Far

                Push    CS
                Pop     DS
                        Assume DS:Driver

                Mov     SI, Offset MemoryBlocks+4
                Mov     CX, NUMMEMORYBLOCKS
                Xor     EAX, EAX

GetStatus1:
                Add     EAX, [SI]
                Add     SI, 8
                Loop    GetStatus1

                Mov     SI, Offset StatusLine
                ShR     EAX, 9

                ClC
                Ret

EndP            GetStatus
                Assume DS:Nothing

;ÄÄ SoundCardScreen ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
;  Function to have driver interactive part of program
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SoundCardScreen Far

                Xor     AX, AX
                StC
                Ret

EndP            SoundCardScreen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetVariable Far

                Ret

EndP            GetVariable

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SetVariable Far

                Ret

EndP            SetVariable

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

EndDriver:

;********  Provided Variable Table *************

MaxNumberOfChannels     DW      64      ; Maximum number of channels the
                                        ; driver can handle.
StopAfterPlay           DW      0
DefaultChannels         DW      64

                        DW      5 Dup (0)

;********  Provided Procedure Table *************

ProvidedTableStart:

        DW      Offset DetectCard

        DW      Offset InitSound        ; Playing related
        DW      Offset ReinitSound
        DW      Offset UninitSound

        DW      Offset Poll

        DW      Offset SetTempo         ; Sound variable related
        DW      Offset SetMixVolume
        DW      Offset SetStereo

        DW      Offset LoadSample       ; Sample related
        DW      Offset ReleaseSample
        DW      Offset ResetMemory
        DW      Offset GetStatus        ; Returns string to show on status line

        DW      Offset SoundCardScreen  ; Sound card 'screen'

        DW      Offset GetVariable      ; For interface
        DW      Offset SetVariable

ProvidedTableEnd:
        DW      32-(ProvidedTableEnd-ProvidedTableStart)/2 Dup (0)

EndS

End
