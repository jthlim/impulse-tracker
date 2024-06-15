;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Network Module                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                        Jumps
                        .386P

include switch.inc

IF NETWORKENABLED

SHOWQUEUESIZE           EQU     0

NUMREQUIREDVARIABLES  EQU 16    ; Number of bytes required from IT.EXE by Driver
NUMREQUIREDFUNCTIONS  EQU 32    ; Number of functions (DD Offsets) required by
                                ;  Network driver
NUMPROVIDEDVARIABLES  EQU 16    ; Number of bytes provided from driver to IT.EXE
NUMPROVIDEDFUNCTIONS  EQU 16    ; Number of functions (DW Offsets) provided by
                                ;  Network driver

; Has to handle:
;  1. Loading the network driver
;  2. Messages to/from network driver/buffering, etc.

; Interface

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Externals                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

        Extrn   D_ClearFileName:Far

        Extrn   E_AllocateEMS:Far
        Extrn   E_ReleaseEMS:Far
        Extrn   E_MapEMSMemory:Far
        Extrn   E_GetEMSPageFrame:Far
        Extrn   E_GetEMSVersion:Far
;        Extrn   E_SavePageFrame:Far
;        Extrn   E_RestorePageFrame:Far

        Extrn   F_DrawHeader:Far

        Extrn   Glbl_SetCurrentMode:Far
        Extrn   Glbl_GetCurrentMode:Far

        Extrn   I_MapEnvelope:Far

        Extrn   M_FunctionDivider:Far
        Extrn   M_FunctionHandler:Far
        Extrn   M_Object1List:Far

        Extrn   Music_GetPatternLocation:Far    ; Returns AX = handle
                                                ;        EBX = segment:offset
                                                ;         DL = type.
                                                ;         CX = pattern length
        Extrn   Music_GetPatternLocationNoCount:Far    ; Returns AX = handle
                                                ;        EBX = segment:offset
                                                ;         DL = type.
        Extrn   Music_ReleasePattern:Far        ; Requires AX = pattern
        Extrn   Music_AllocatePattern:Far       ; SI = pattern, DX = length
        Extrn   Music_UpdatePatternOffset:Far
        Extrn   Music_ReleaseAllSamples:Far
        Extrn   Music_AllocateSample:Far
        Extrn   Music_Stop:Far
        Extrn   Music_ReleaseSample:Far

        Extrn   IdleUpdateInfoLine:Far
        Extrn   SetInfoLine:Far
        Extrn   SetInfoLine2:Far
        Extrn   GetTimerCounter:Far

        Extrn   O1_LoadNetworkDriver:Far
        Extrn   O1_NetworkErrorList:Far
        Extrn   GlobalKeyList

        Extrn   PE_FillHeader:Far
        Extrn   PE_NewPattern:Far
        Extrn   PEFunction_OutOfMemoryMessage:Far
        Extrn   PEFunction_StoreCurrentPattern:Far
        Extrn   PE_GetLastInstrument:Far

        Extrn   S_GetDestination:Far
        Extrn   S_DrawString:Far
        Extrn   S_SaveScreen:Far
        Extrn   S_RestoreScreen:Far

Segment         Object1 BYTE Public 'Data'
EndS

Segment         SongData PARA Public 'Data'
EndS

Segment         SongData PARA Public 'Data'
EndS

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

        Public  Network_DriverScreen
        Public  Network_DrawDriverScreen
        Public  Network_PreDriverScreen
        Public  Network_PostDriverScreen
        Public  Network_Shutdown
        Public  Network_Poll
        Public  Network_GetSendQueue            ; Returns ES:DI
        Public  Network_FinishedSendQueue       ; Finished with send queue
        Public  Network_AddWordToQueue
        Public  Network_UpdatePattern
        Public  Network_UpdatePatternIfIdle
        Public  Network_EnsureNoNetwork
        Public  Network_SendSampleHeader
        Public  Network_SendInstrumentHeader
        Public  Network_QueueSampleData
        Public  Network_SendSongDataInformation

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
;
; Not used?
;
;Segment                 Network BYTE Public 'Code' USE16
;                        Assume  CS:Network, DS:Nothing, ES:Nothing
;EndS
;
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment         DiskData PARA Public 'Data'
EndS

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment         Pattern BYTE Public 'Code' USE16
        Extrn   PatternDataArea:Word
        Extrn   PatternNumber:Word
        Extrn   Modified:Byte
        Extrn   PatternModified:Byte
        Extrn   MaxRow:Word
EndS

Segment         Music BYTE Public 'Code' USE16
        Extrn   CurrentOrder:Word
        Extrn   CurrentPattern:Word
        Extrn   CurrentRow:Word
EndS

Segment                 Disk DWORD Public 'Code' USE16
                        Assume  CS:Disk, DS:Nothing, ES:Nothing

        Extrn   DiskDataArea:Word
        Extrn   D_GotoStartingDirectory:Far

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

;******************** THESE BLOCKS CANNOT CHANGE ORDER ************************

Label           NetworkRequiredVariables
        DD      DWord Ptr GlobalKeyList
        DD      DWord Ptr IdleUpdateInfoLine
        DW      DiskData
        DB      NUMREQUIREDVARIABLES - ($-Offset NetworkRequiredVariables) Dup (0)

Label           NetworkRequiredFunctions
        DD      DWord Ptr Network_UnloadDriver
        DD      DWord Ptr M_FunctionHandler
        DD      DWord Ptr M_FunctionDivider
        DD      DWord Ptr Network_ReceiveData
        DD      DWord Ptr Network_SendData
        DD      DWord Ptr Network_EstablishConnection
        DD      DWord Ptr D_GotoStartingDirectory
        DD      DWord Ptr GetTimerCounter
        DD      DWord Ptr SetInfoLine2
        DD      DWord Ptr F_DrawHeader
        DD      DWord Ptr PE_FillHeader
        DD      DWord Ptr S_GetDestination
        DD      DWord Ptr S_DrawString
        DD      DWord Ptr S_SaveScreen
        DD      DWord Ptr S_RestoreScreen
        DD      DWord Ptr Glbl_GetCurrentMode
        DD      DWord Ptr Network_NewConnection
        DD      DWord Ptr Network_DecodeUserName
        DD      NUMREQUIREDFUNCTIONS - ($-Offset NetworkrequiredFunctions)/4 Dup (0)

Label           NetworkDriverVariables  Byte
        DB      NUMPROVIDEDVARIABLES - ($-Offset NetworkDriverVariables) Dup (0)

Label           NetworkDriverFunctions DWord
NetworkDriver_Initialise        DD      Network_EmptyFunction
NetworkDriver_Shutdown          DD      Network_EmptyFunction
NetworkDriver_Screen            DD      Network_EmptyFunction
NetworkDriver_Update            DD      Network_EmptyFunction
NetworkDriver_ConnectionStatus  DD      Network_EmptyFunction
        DD      NUMPROVIDEDFUNCTIONS - ($-Offset NetworkDriverFunctions)/4 Dup (0)

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

DriverIdentification    DB      "Impulse Tracker Network Driver"
DriverMask              DB      "IT*.NET", 0
NoDriverMsg             DB      "No Network Drivers Found", 0
NetworkDriverUnloaded   DB      "Network driver unloaded", 0

IF SHOWQUEUESIZE
DebugMessage            DB      "SendQueueSize: ", 0FDh, "D", 0
ENDIF
; NetworkOverflowMessage  DB     "Network Overflow: Driver Unloaded", 0

ALIGN 2
NumDrivers              DW      0
CurrentDriver           DW      0
TopDriver               DW      0

DriverSegment           DW      0

EMS_SENDBUFFERPAGE      EQU     (0*100h + 4)

LastReceiveCX           DW      0
NetworkEMSHandle        DW      0               ; 384kb ->  64kb = receive buffer 1a
                                                ;           64kb = receive buffer 1b
                                                ;           64kb = receive buffer 2a
                                                ;           64kb = receive buffer 2b
                                                ;           64kb = receive buffer 3a
                                                ;           64kb = receive buffer 3b
NetworkSendEMSHandle    DW      0               ; 64kb, separated for Win9x's
                                                ; inattention to the int-flag.

SendQueueSegment        DW      0               ; MUST be adjacent
SendDataQueueTail       DW      0               ; MUST be adjacent
SendDataQueueHead       DW      0               ; MUST be adjacent
Destination             DB      0               ; MUST be adjacent
DriverValidated         DB      0               ; MUST be adjacent
SendBufferRemaining     DW      0               ; MUST be adjacent
SendBufferOffset        DW      0               ; MUST be adjacent

PatternDataUpdated      DW      50 Dup (0)      ; Bit table of pattern numbers

Label           NetworkKeys     Byte
                        DB      0
                        DW      1C8h            ; Up arrow
                        DW      Network_Up

                        DB      0
                        DW      1D0h            ; Down arrow
                        DW      Network_Down

                        DB      0
                        DW      11Ch
                        DW      Network_LoadDriver

                        DB      0FFh

EMSTransferTable        Label
TransferLength          DW      0, 0
SourceType              DB      0
SourceHandle            DW      0
SourceOffset            DD      0
DestinationType         DB      0
DestinationHandle       DW      0
DestinationOffset       DD      0

PatternModifiedTable    DB      200 Dup (0)      ; Bit field for 200 patterns

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_EmptyFunction Far

                Xor     AX, AX
                Ret

EndP            Network_EmptyFunction

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_DriverScreen Far

; If no network driver loaded, show load screen
; If driver loaded, then call driver's screen interface

                Mov     AL, 24
                Call    Glbl_SetCurrentMode

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Cmp     [DriverSegment], 0
                JE      Network_DriverScreen1

                Jmp     [NetworkDriver_Screen]

Network_DriverScreen1:
                Call    D_GotoStartingDirectory
; Clear data area.

                Mov     ES, [DiskDataArea]
                Mov     CX, 32768
                Xor     DI, DI
                Xor     AX, AX
                Rep     StosW           ; Clear diskdata Area...

                Mov     [NumDrivers], AX
                Mov     [CurrentDriver], AX
                Mov     [TopDriver], AX

; Now shift DTA to DS:64000

                Push    DS

                Push    ES
                Pop     DS

                Mov     DX, 64000
                Mov     AH, 1Ah
                Int     21h                     ; Shift DTA address..

                Pop     DS

; Load file names.

                Mov     DX, Offset DriverMask   ; Wanna search for IT*.NET
                Xor     CX, CX                  ; Normal File types
                Mov     AH, 4Eh

Network_DriverScreenLoadFileNames1:
                Int     21h
                JC      Network_DriverScreenLoadFileNamesEnd

                Push    DS

                Push    ES
                Pop     DS              ; DS = Diskdata

; OK.. have the file.
; Open it and read the first 128 bytes in from it.
; Check for identification string. If all OK, then copy details into
;  network list.

                Mov     AX, 3D00h
                Mov     DX, 64000+1Eh   ; Filename
                Int     21h
                JC      Network_DriverScreenLoadFileNext

                Mov     BX, AX          ; File handle.

; Read first 128 bytes of file

                Mov     AH, 3Fh
                Mov     CX, 128
                Mov     DX, 65000
                Mov     DI, DX

                Int     21h     ; Read file.
                JC      Network_DriverScreenLoadFileNextClose

; Check for matching ID

                Mov     SI, Offset DriverIdentification
                Mov     CX, 30

                SegCS   RepE CmpSB
                JNE     Network_DriverScreenLoadFileNextClose

; Have a matching driver!
; Copy filename and Header.

                Mov     DI, [CS:NumDrivers]
                Inc     [CS:NumDrivers]
                ShL     DI, 7           ; Deposit information at 128*DI
                Mov     CX, 13
                Mov     SI, 64000+1Eh
                Rep     MovsB
                Mov     SI, 65000+64
                Mov     CX, 32
                Rep     MovsW

Network_DriverScreenLoadFileNextClose:
                Mov     AH, 3Eh
                Int     21h

Network_DriverScreenLoadFileNext:
                Pop     DS
                Mov     AH, 4Fh
                Jmp     Network_DriverScreenLoadFileNames1

Network_DriverScreenLoadFileNamesEnd:
; OK.. jump to network screen list

                Mov     AX, 5
                Mov     SI, 1
                Mov     CX, Object1

                Mov     DX, Offset O1_LoadNetworkDriver
                Ret

EndP            Network_DriverScreen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_DrawDriverScreen Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Call    S_GetDestination        ; Gets ES

                Cmp     [NumDrivers], 0
                JNE     Network_DrawDriverScreen1

                Mov     DI, (27+29*80)*2                 ; (6, 13)
                Mov     SI, Offset NoDriverMsg

                Mov     AH, 3
                Call    S_DrawString

                Ret

Network_DrawDriverScreen1:
                Mov     AX, 168+200h
                Mov     DI, (13*80+15)*2
                Mov     CX, 36

Network_DrawDriverScreen2:
                StosW
                Add     DI, 158
                Loop    Network_DrawDriverScreen2

                Mov     SI, [TopDriver]
                Mov     DX, [NumDrivers]
                Mov     BX, [CurrentDriver]

; Need to make sure they're within bounds.
                Cmp     BX, SI
                JAE     Network_DrawDriverScreenClip1

                Mov     SI, BX

Network_DrawDriverScreenClip1:
                LEA     DI, [SI+35]
                Cmp     BX, DI
                JBE     Network_DrawDriverScreenClip2

                LEA     SI, [BX-35]

Network_DrawDriverScreenClip2:
                Mov     DI, (13*80+2)*2
                Mov     [TopDriver], SI

                Sub     DX, SI
                JZ      Network_DrawDriverScreenEnd

                ShL     SI, 7
                Mov     DS, [DiskDataArea]
                        Assume DS:Nothing

                Cmp     DX, 36
                JB      Network_DrawDriverScreenClip

                Mov     DX, 36

Network_DrawDriverScreenClip:
                Mov     AH, 3
                Mov     CX, 13

Network_DrawDriverScreenFileNames:
                LodsB
                StosW
                Loop    Network_DrawDriverScreenFileNames

;                Add     DI, 2
                ScasW

                Mov     CX, 62

Network_DrawDriverScreenDriverName:
                LodsB
                StosW
                Loop    Network_DrawDriverScreenDriverName

                Add     SI, 128-62-13
                Add     DI, 8

                Dec     DX
                JNZ     Network_DrawDriverScreenClip

Network_DrawDriverScreenEnd:
                Ret

EndP            Network_DrawDriverScreen
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_PreDriverScreen Far

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Cmp     [NumDrivers], 0
                JE      Network_PreDriverScreenEnd

                Mov     AX, [CurrentDriver]
                Sub     AX, [TopDriver]
                Add     AX, 13
                Mov     BX, 160
                Mul     BX

                Call    S_GetDestination

                LEA     DI, [EAX+4]
                Mov     CX, 76

Network_PreDriverScreen1:
                Mov     AX, [ES:DI]
                Mov     AH, 30h
                Cmp     CX, 76-13
                JNE     Network_PreDriverScreen2

                Mov     AH, 32h

Network_PreDriverScreen2:
                StosW
                Loop    Network_PreDriverScreen1

Network_PreDriverScreenEnd:
                Ret

EndP            Network_PreDriverScreen
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_Up Far
                Assume DS:Disk

                Sub     [CurrentDriver], 1
                AdC     [CurrentDriver], 0

                Mov     AX, 1
                Ret

EndP            Network_Up
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_Down Far

                Mov     AX, [CurrentDriver]
                Inc     AX
                Cmp     AX, [NumDrivers]
                JAE     Network_Down1

                Mov     [CurrentDriver], AX

Network_Down1:
                Mov     AX, 1
                Ret

EndP            Network_Down

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_PostDriverScreen Far

; Has to handle up, down, Enter.

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     SI, Offset NetworkKeys
                Call    M_FunctionDivider
                JC      Network_PostDriverScreen1

                Jmp     [Word Ptr SI]

Network_PostDriverScreen1:
                Xor     AX, AX
                Ret

EndP            Network_PostDriverScreen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_LoadDriver Far
                Assume DS:Disk

; Allocate EMS memory buffers first

                Cmp     NetworkEMSHandle, 1
                JAE     Network_LoadDriverMemoryAlreadyAllocated

                Call    E_GetEMSVersion
                Cmp     AL, 40h
                JB      Network_LoadDriverInsufficientMemory

                                        ; Carry flag set -> essential allocation
                StC
                Mov     EAX, 384*1024
                Call    E_AllocateEMS
                Test    AX, AX
                JNZ     Network_LoadDriverMemoryOK

Network_LoadDriverInsufficientMemory:
                Jmp     PEFunction_OutOfMemoryMessage

Network_LoadDriverMemoryOK:
                Mov     NetworkEMSHandle, AX

Network_LoadDriverMemoryAlreadyAllocated:
                Cmp     NetworkSendEMSHandle, 1
                JAE     Network_LoadDriverSendEMSHandleAlreadyAllocated

                Mov     EAX, 64*1024
                Call    E_AllocateEMS
                Test    AX, AX
                JZ      Network_LoadDriverInsufficientMemory

                Mov     NetworkSendEMSHandle, AX

Network_LoadDriverSendEMSHandleAlreadyAllocated:
                Cmp     SendqueueSegment, 0
                JNE     Network_LoadDriverMemoryAlreadyAllocated2

                Mov     AH, 48h
                Mov     BX, 1024
                Int     21h     ; Allocate 16kb of memory for the SendQueue
                JC      Network_LoadDriverInsufficientMemory

                Mov     SendQueueSegment, AX

Network_LoadDriverMemoryAlreadyAllocated2:
                Xor     EAX, EAX
                Mov     DWord Ptr [SendDataQueueTail], EAX
                Mov     DWord Ptr [Destination], EAX

                Mov     AX, [NumDrivers]
                Mov     DX, [CurrentDriver]

                Test    AX, AX
                JNZ     Network_LoadDriver1

                Ret

Network_LoadDriver1:
                ShL     DX, 7
                Mov     DS, [DiskDataArea]
                        Assume DS:Nothing
                Mov     DI, DX

; Try allocating memory first.
                Mov     BX, [DI+13+62]  ; Bytes to read
                Mov     AH, 48h
                Add     BX, 15
                ShR     BX, 4           ; BX = number of parags required.
                Int     21h
                JNC     Network_LoadDriver2

                Jmp     PEFunction_OutOfMemoryMessage

Network_LoadDriver2:
                Mov     ES, AX
                Mov     [CS:DriverSegment], AX

                Mov     AX, 3D00h
                Int     21h             ; Open file
                JC      Network_LoadDriver3

                Mov     BX, AX
                Mov     AX, 4200h
                Xor     CX, CX
                Mov     DX, 128
                Int     21h
                JC      Network_LoadDriver4

                Mov     AH, 3Fh
                Mov     CX, [DI+13+62]
                Mov     DS, [CS:DriverSegment]
                Xor     DX, DX
                Int     21h     ; Read driver
                JC      Network_LoadDriver4

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     AH, 3Fh
                Mov     CX, NUMPROVIDEDVARIABLES
                Mov     DX, Offset NetworkDriverVariables
                Int     21h
                JC      Network_LoadDriver4

                Mov     AH, 3Fh
                Mov     CX, NUMPROVIDEDFUNCTIONS*2
                Mov     DX, Offset NetworkDriverFunctions+NUMPROVIDEDFUNCTIONS*2
                Int     21h
                JC      Network_LoadDriver4

                Mov     AH, 3Eh
                Int     21h             ; Close file.

; Setup tables
                Mov     SI, Offset NetworkRequiredVariables
                Xor     DI, DI
                Mov     CX, NUMREQUIREDVARIABLES+4*NUMREQUIREDFUNCTIONS
                Rep     MovsB

                Mov     AX, ES
                Push    DS
                Pop     ES
                Mov     SI, DX
                Mov     DI, Offset NetworkDriverFunctions
                Mov     CX, NUMPROVIDEDFUNCTIONS
                ShL     EAX, 16

Network_LoadDriver5:
                LodsW
                StosD
                Loop    Network_LoadDriver5

; Initialise Send/Receive buffers.
                Mov     DX, CS:NetworkEMSHandle
                Mov     CL, 512/16
                Mov     CH, 28
                Call    E_GetEMSPageFrame
                Mov     ES, AX

Network_InitialiseBuffers1:
                Call    E_MapEMSMemory
                Mov     DWord Ptr [ES:65532], 0
                Sub     CH, 4
                JNS     Network_InitialiseBuffers1

; Should jump to network initialise function now.

                Jmp     NetworkDriver_Initialise
                        Assume DS:Nothing

Network_LoadDriver4:
                Mov     AH, 3Eh
                Int     21h

Network_LoadDriver3:
                Jmp     Network_UnloadDriver

EndP            Network_LoadDriver
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_UnloadDriver Far

                Push    CS
                Push    CS
                Pop     DS
                Pop     ES
                        Assume DS:Disk

                Mov     SI, Offset NetworkDriverUnloaded
                Call    SetInfoLine

                Mov     AH, 49h
                Mov     ES, [DriverSegment]
                Int     21h

                Mov     [DriverSegment], 0

                Mov     AH, 49h
                Mov     ES, SendQueueSegment
                Int     21h

                Mov     SendQueueSegment, 0

                Push    CS
                Pop     ES

                Mov     AX, CS
                ShL     EAX, 16
                Mov     AX, Offset Network_EmptyFunction
                Mov     DI, Offset NetworkDriverFunctions
                Mov     CX, NUMPROVIDEDFUNCTIONS
                Rep     StosD

                Jmp     Network_DriverScreen

EndP            Network_UnloadDriver
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

; PatternCycle    DW      0

Proc            Network_Poll Far

Comment ~
                Mov     AX, CS:PatternCycle
                Inc     AX
                Cmp     AX, 200
                JB      Network_Poll1

                Xor     AX, AX

Network_Poll1:
                Mov     CS:PatternCycle, AX

                Call    Network_UpdatePatternIfIdle
~
                Jmp     NetworkDriver_Update

EndP            Network_Poll

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_DecodeUserName Far      ; Given DS:SI = name
                                                ; CX = count (including key)

                Test    CX, CX
                JZ      Network_DecodeUserName3

                Mov     BX, CX
                Xor     DX, DX

Network_DecodeUserName1:
                LodsB
                Add     DL, AL
                StosB
                Xor     DH, DL
                Loop    Network_DecodeUserName1

                Add     DX, 0FFFFh
                JC      Network_UnloadDriver

                Sub     SI, BX
                Mov     CX, BX

                Xor     AH, AH
Network_DecodeUserName2:
                LodsB
                Add     AH, AL
                XChg    AL, AH
                Xor     AL, 0AAh
                RoR     AL, 2
                Mov     [SI-1], AL
                Loop    Network_DecodeUserName2

Network_DecodeUserName3:
                Mov     CS:DriverValidated, 1

Network_DecodeUserNameEnd:
                Ret

EndP            Network_DecodeUserName

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_Shutdown Far

                Mov     AX, CS:NetworkEMSHandle
                Test    AX, AX
                JZ      Network_Shutdown1

                Call    E_ReleaseEMS

Network_Shutdown1:
                Mov     AX, CS:NetworkSendEMSHandle
                Test    AX, AX
                JZ      Network_Shutdown2

                Call    E_ReleaseEMS

Network_Shutdown2:
                Jmp     NetworkDriver_Shutdown

EndP            Network_Shutdown

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
;
; Internal structures
; -------------------
;
; SendBuffer is the raw data to transmit:
;  Offset       Size    Contents           Notes
;  0            DWord   Block Header ID    'JLNP' - "J.L. Network Protocol"
;  4            Word    Block Size         Byte count, includes headers
;                                          and CRC check.
;  6            Byte    Block Type
;  7            <...>   Data               Maximum of 65000 bytes
;  <Data+7>     Word    CRC                Calculated
;
; Block types.
;
; SendQueue contains a queue of objects to transmit.
; Structure:
;  Offset       Size    Contents           Notes
;  0            Byte    Destination        0=all, 1-3=specific, others=ignore
;  1            Byte    Object Type
;  2            <>      Data
;
; Object types:
;  0: Partial pattern data
;       Extra data: Pattern Number (1), Bounding Box (4), Data
;  1: Entire pattern
;       Extra data: Pattern Number (1), Data (Compressed)
;  2: Request pattern
;       Extra data: Pattern Number (1)
;  3: SongData information (includes order list + song parameters)
;       Extra data: Length (2), Offset (2)
;  4: Instrument information
;       Extra data: Instrument Number (1)
;  5: Sample information
;       Extra data: Sample Number (1)
;  6: Pattern Length
;       Extra data: Pattern Number (1), New MaxRow (1)
;  7: Delete sample
;       Extra data: Sample Number (1)
;  8: New sample - sends length also
;       Extra data: Sample Number (1)
;  9: Sample Data
;       Extra data: Sample Number (1), Offset (4)


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_CalculateCRC
                ; Calculates CRC and appends 6 byte header

                ; Given ES = EMSSegment
                ; Given DI = end of data written

                Push    DS

                Push    ES
                Pop     DS

                Mov     CX, DI
                Xor     SI, SI
                LEA     BX, [DI+2]
                Xor     DX, DX
                Mov     Word Ptr [SI+4], BX
                Xor     AX, AX
                Mov     DWord Ptr [SI], 'JLNP'

Network_CalculateCRC1:
                LodsB
                Add     DH, AL
                Xor     DL, DH
                Loop    Network_CalculateCRC1

; Have DH = sum, DL = xor of running sum.
; Want to have DX = 0 after next two bytes
; second last byte = DL-DH
; last byte        = -DL

                Sub     AH, DL          ; AH = -DL
                Sub     DL, DH          ; DL = DL-DH
                Mov     AL, DL          ; AL = DL-DH

                StosW
                Mov     CS:SendBufferOffset, 0
                Mov     CS:SendBufferRemaining, BX

                Pop     DS

                Ret

EndP            Network_CalculateCRC

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_GetSendBufferPage Near
                ; Returns AX = EMSPageFrame

                Push    CX
                Push    DX

                Mov     CX, EMS_SENDBUFFERPAGE
                Mov     DX, CS:NetworkSendEMSHandle
                Call    E_MapEMSMemory
                Call    E_GetEMSPageFrame

                Pop     DX
                Pop     CX

                Ret

EndP            Network_GetSendBufferPage

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

; Send Procedure Jump Table
;  Each procedure is given DS:SI = Send queue data
;                          ES:DI = Send buffer
;  Each procedure only need write to ES:DI.
;  Count of bytes is taken from return value of DI, CRC+Header will be appended
;  Can use AX, BX, CX, DX, DS, SI
;  Must update CS:SendDataQueueHead

NUMBEROFBLOCKTYPES      EQU     10

ConvertQueueObjectTypes DW      Offset SendNetworkBlock0
                        DW      Offset SendNetworkBlock1
                        DW      Offset SendNetworkBlock2
                        DW      Offset SendNetworkBlock3
                        DW      Offset SendNetworkBlock4
                        DW      Offset SendNetworkBlock5
                        DW      Offset SendNetworkBlock6
                        DW      Offset SendNetworkBlock7
                        DW      Offset SendNetworkBlock8
                        DW      Offset SendNetworkBlock9

; Receive Procedure Jump Table
;  Given DS = Receive buffer
;  Can use any register

InterpretObjectTypes    DW      Offset ReceiveNetworkBlock0
                        DW      Offset ReceiveNetworkBlock1
                        DW      Offset ReceiveNetworkBlock2
                        DW      Offset ReceiveNetworkBlock3
                        DW      Offset ReceiveNetworkBlock4
                        DW      Offset ReceiveNetworkBlock5
                        DW      Offset ReceiveNetworkBlock6
                        DW      Offset ReceiveNetworkBlock7
                        DW      Offset ReceiveNetworkBlock8
                        DW      Offset ReceiveNetworkBlock9

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
; Block Type 0 notes
;
;  If first byte is between 80 and EF, then Val & 7F rows down are empty
;  If first byte is between F0 and F7, then
;   note field is empty, other fields are:
;    Val & 1, ins present
;    Val & 2, vol present
;    Val & 4, eff present
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SendNetworkBlock0 Near

; Block type 0
; Offset 0: Pattern Number
;        1: Channel
;        2: Row
;        3: Width
;        4: Height

                LodsB
                StosB
                Mov     DX, AX          ; DL = Pattern Number
                LodsW
                StosW
                Mov     CX, AX          ; CL = Channel, CH = Row
                LodsW
                Mov     BX, AX          ; BL = Width, BH = Height

                Mov     CS:SendDataQueueHead, SI

                Push    Pattern
                Pop     DS
                        Assume DS:Pattern

                Cmp     DL, Byte Ptr PatternNumber ; Still editing the pattern?
                JE      SendNetworkBlock0_0

                Xor     AX, AX
                StosW

                Ret

SendNetworkBlock0_0:
                StosW
                Mov     DS, PatternDataArea
                        Assume DS:Nothing

                Mov     AL, 64
                Mul     CH
                Add     AL, CL
                LEA     ESI, [EAX*4+EAX]

SendNetworkBlock0_1:
                Push    BX
                Push    SI

                Xor     DX, DX          ; DL = num empty rows

SendNetworkBlock0_2:
                Push    SI

                Cmp     Byte Ptr [SI], 0FDh
                JNE     SendNetworkBlock0_3
                Cmp     DWord Ptr [SI+1], 0000FF00h
                JNE     SendNetworkBlock0_3

                Inc     DX
                Cmp     DL, 6Fh
                JB      SendNetworkBlock0_NextCell

                Mov     AL, 80h
                Add     AL, DL
                StosB
                Xor     DX, DX
                Jmp     SendNetworkBlock0_NextCell

SendNetworkBlock0_3:
                Test    DX, DX
                JZ      SendNetworkBlock0_4

                Mov     AL, 80h
                Add     AL, DL
                StosB
                Xor     DX, DX

SendNetworkBlock0_4:
                LodsB
                Cmp     AL, 0FDh        ; Empty note?
                JE      SendNetworkBlock0_5

                StosB
                MovsD
                Jmp     SendNetworkBlock0_NextCell

SendNetworkBlock0_5:
                Push    BX

                Mov     BX, DI
                StosB                   ; Increment.. needs to be filled later

                Mov     CL, 0F0h
                LodsB
                Test    AL, AL          ; instrument
                JZ      SendNetworkBlock0_6

                StosB
                Or      CL, 1

SendNetworkBlock0_6:                    ; Volume
                LodsB
                Cmp     AL, 0FFh
                JE      SendNetworkBlock0_7

                StosB
                Or      CL, 2

SendNetworkBlock0_7:                    ; Effect
                LodsW
                Test    AX, AX
                JZ      SendNetworkBlock0_8

                StosW
                Or      CL, 4

SendNetworkBlock0_8:
                Mov     [ES:BX], CL

                Pop     BX

SendNetworkBlock0_NextCell:
                Pop     SI
                Add     SI, 320

                Dec     BH
                JNZ     SendNetworkBlock0_2

                Test    DX, DX
                JZ      SendNetworkBlock0_9

                Mov     AL, 80h
                Or      AL, DL
                StosB

SendNetworkBlock0_9:
                Pop     SI
                Pop     BX

                Add     SI, 5           ; Next column

                Dec     BL
                JNZ     SendNetworkBlock0_1

                Ret

EndP            SendNetworkBlock0
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ReceiveNetworkBlock0 Near

                Push    Pattern
                Pop     ES
                        Assume ES:Pattern

                Mov     [Word Ptr ES:Modified], 101h

                Mov     AL, [DS:07h]    ;  AL = Pattern Number

                Cmp     AL, [Byte Ptr ES:PatternNumber]
                JNE     ReceiveNetworkBlock0_1

                Mov     ES, [ES:PatternDataArea]
                        Assume ES:Nothing

                Mov     CX, [DS:08h]    ; CL = Channel, CH = Row
                Mov     BX, [DS:0Ah]    ; BL = Width, BH = Height

                Test    BX, BX
                JZ      ReceiveNetworkBlock0_1

                Mov     AL, 64
                Mul     CH
                Add     AL, CL
                LEA     EDI, [EAX*4+EAX]
                Mov     AL, 5

                Mul     BL
                Mov     SI, 0Ch

ReceiveNetworkBlock0_0:
                Push    BX
                Push    DI

ReceiveNetworkBlock0_3:
                LodsB
                Cmp     AL, 80h
                JB      ReceiveNetworkBlock0_4
                Cmp     AL, 0F8h
                JAE     ReceiveNetworkBlock0_4

                Cmp     AL, 0F0h
                JAE     ReceiveNetworkBlock0_6

; Empty rows here.
                And     AL, 7Fh
                Sub     BH, AL

ReceiveNetworkBlock0_11:
                Mov     Byte Ptr [ES:DI], 0FDh
                Mov     DWord Ptr [ES:DI+1], 0000FF00h
                Add     DI, 320
                Dec     AL
                JNZ     ReceiveNetworkBlock0_11

                Test    BH, BH
                JNZ     ReceiveNetworkBlock0_3
                Jmp     ReceiveNetworkBlock0_5

ReceiveNetworkBlock0_6:         ; Partial row here.
                Mov     AH, AL

                Mov     AL, 0FDh        ; NONOTE
                StosB

                Xor     AL, AL

                Test    AH, 1
                JZ      ReceiveNetworkBlock0_7

                LodsB

ReceiveNetworkBlock0_7:
                StosB

                Mov     AL, 0FFh
                Test    AH, 2
                JZ      ReceiveNetworkBlock0_8

                LodsB

ReceiveNetworkBlock0_8:
                StosB
                Test    AH, 4
                Mov     AX, 0           ; Don't erase flags
                JZ      ReceiveNetworkBlock0_9

                LodsW

ReceiveNetworkBlock0_9:
                StosW
                Jmp     ReceiveNetworkBlock0_10

ReceiveNetworkBlock0_4:
                StosB
                MovsD

ReceiveNetworkBlock0_10:
                Add     DI, 320-5

                Dec     BH
                JNZ     ReceiveNetworkBlock0_3

ReceiveNetworkBlock0_5:

                Pop     DI
                Pop     BX

                Add     DI, 5
                Dec     BL
                JNZ     ReceiveNetworkBlock0_0

                Ret

ReceiveNetworkBlock0_1:         ; Not the same, or zero width -> mark modified

; DX = connection ID
; AL = Pattern number

        ; Sanity check
                Cmp     AL, 200
                JAE     ReceiveNetworkBlock0_2

                Mov     BX, AX
                Inc     DX
                And     BX, 0FFh
                Mov     [CS:PatternModifiedTable+BX], DL

ReceiveNetworkBlock0_2:
                Ret

EndP            ReceiveNetworkBlock0
                Assume ES:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SendNetworkBlock1

; Block type 1
;  Offset 0: Pattern number

                Push    FS

                Push    Pattern
                Pop     FS
                        Assume FS:Pattern

                LodsB
                Mov     CS:SendDataQueueHead, SI
                StosB

                And     AX, 0FFh

; Check whether request should be sent off to another node instead.
; AL = Pattern number

                Mov     BX, AX

                Mov     DH, [CS:PatternModifiedTable+BX]

                Test    DH, DH
                JZ      SendNetworkBlock1_1

                Mov     CS:Destination, DH
                Mov     Byte Ptr [ES:DI-2], 2      ; NETWORK_REQUESTPATTERNOBJECT

                Jmp     SendNetworkBlock1_2

SendNetworkBlock1_1:
                Cmp     AL, [Byte Ptr FS:PatternNumber]
                JNE     SendNetworkBlock1_0

                Mov     [FS:PatternModified], 0

                PushAD
                Push    DS
                Push    ES

                Call    PEFunction_StoreCurrentPattern

                Pop     ES
                Pop     DS
                PopAD

SendNetworkBlock1_0:
                Call    Music_GetPatternLocation
                        ; Returns AX = handle
                        ;        EBX = offset/segment (or page/segment)
                        ;         CX = length (not including header)
                        ;         DL = 0 for conv, 1 for EMS

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Add     CX, 8
; Setup EMS transfer
                Mov     TransferLength, CX

                Mov     SourceType, DL
                Mov     SourceHandle, AX
                Mov     SourceOffset, EBX

                Mov     AX, NetworkSendEMSHandle
                Mov     DestinationType, 1
                Mov     DestinationHandle, AX
                Mov     [Word Ptr DestinationOffset], DI
                Mov     [Word Ptr DestinationOffset+2], 0

; Data is ready to go!
                Mov     AX, 5700h
                Mov     SI, Offset EMSTransferTable
                Int     67h

                Add     DI, CX

SendNetworkBlock1_2:
                Call    Network_GetSendBufferPage
                Mov     ES, AX

                Pop     FS

                Ret

EndP            SendNetworkBlock1
                Assume DS:Nothing, FS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ReceiveNetworkBlock1

                Push    FS

                Push    Music
                Pop     FS
                        Assume FS:Music

                Mov     EDX, [DS:8]
                Mov     AL, [DS:7]

                And     AX, 0FFh        ; AX = Pattern Number
                                        ; DX = length

; Sanity check
                Cmp     AL, 200
                JAE     ReceiveNetworkBlock1_2

                Call    Music_ReleasePattern

                Cmp     EDX, 400040h
                JE      ReceiveNetworkBlock1_1

                Push    AX

                Add     DX, 8
                Push    DX
                Push    AX

                Mov     SI, AX
                Call    Music_AllocatePattern

                Pop     AX
                Call    Music_GetPatternLocationNoCount

; Setup EMS transfer
                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     DestinationType, 1
                Mov     DestinationHandle, AX
                Mov     DestinationOffset, EBX

                Pop     DX

                Mov     AX, NetworkEMSHandle
                Mov     CX, LastReceiveCX       ; CH = page
                Mov     TransferLength, DX
                ShR     CX, 8
                Mov     SourceType, 1
                Mov     SourceHandle, AX
                Mov     [Word Ptr SourceOffset], 8
                Mov     [Word Ptr SourceOffset+2], CX

; Data is ready to go!
                Mov     AX, 5700h
                Mov     SI, Offset EMSTransferTable
                Int     67h

                Pop     AX

; Mark it off as handled
; AX = Pattern number

ReceiveNetworkBlock1_1:
                Mov     BX, AX
                Mov     [CS:PatternModifiedTable+BX], 0

                Push    Pattern
                Pop     DS
                        Assume DS:Pattern

                Cmp     AL, [Byte Ptr DS:PatternNumber]
                JNE     ReceiveNetworkBlock1_0

                Call    PE_NewPattern

ReceiveNetworkBlock1_0:
                Cmp     AL, [Byte Ptr FS:CurrentPattern]
                JNE     ReceiveNetworkBlock1_2

                Call    Music_UpdatePatternOffset

ReceiveNetworkBlock1_2:
                Pop     FS
                Ret

EndP            ReceiveNetworkBlock1
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SendNetworkBlock2

                MovsB
                Mov     CS:SendDataQueueHead, SI
                Ret

EndP            SendNetworkBlock2

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ReceiveNetworkBlock2

                Mov     AH, [DS:7]      ; AH = pattern
                Mov     AL, 1           ; NETWORK_ENTIREPATTERNOBJECT

        ; Sanity check
                Cmp     AH, 200
                JAE     ReceiveNetworkBlock2_1

                Call    Network_AddWordToQueue

ReceiveNetworkBlock2_1:
                Ret

EndP            ReceiveNetworkBlock2

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SendNetworkBlock3

                LodsW                   ; Length
                StosW
                Mov     CX, AX
                LodsW
                StosW
                Mov     CS:SendDataQueueHead, SI

                Push    SongData
                Pop     DS
                Mov     SI, AX

                Rep     MovsB

                Ret

EndP            SendNetworkBlock3

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ReceiveNetworkBlock3

                Push    SongData
                Pop     ES

                Mov     CX, [DS:7]
                Mov     DI, [DS:9]
                Mov     SI, 11

        ; Sanity check
                Mov     AX, CX
                Add     AX, DI

                Cmp     AX, 512
                JA      ReceiveNetworkBlock3_1

                Rep     MovsB

ReceiveNetworkBlock3_1:
                Ret

EndP            ReceiveNetworkBlock3

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SendNetworkBlock4

                LodsB
                StosB
                And     AX, 0FFh
                Mov     CS:SendDataQueueHead, SI
                Add     AX, AX
                Mov     SI, AX

                Push    SongData
                Pop     DS
                Mov     SI, [64712+SI]

                Mov     CX, 554/2
                Rep     MovsW

SendNetworkBlock4_1:
                Ret

EndP            SendNetworkBlock4

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ReceiveNetworkBlock4

                Mov     DI, [DS:7]
                And     DI, 0FFh
                Mov     AX, DI          ; AX = instrument

        ; Sanity check
                Cmp     AX, 100
                JAE     ReceiveNetworkBlock4_1

                Add     DI, DI

                Push    SongData
                Pop     ES

                Mov     DI, [ES:64712+DI]
                Mov     SI, 8
                Mov     CX, 554/2
                Rep     MovsW

                Call    PE_GetLastInstrument
                Cmp     AX, BX
                JNE     ReceiveNetworkBlock4_1

                Call    Glbl_GetCurrentMode
                Cmp     AL, 4
                JNE     ReceiveNetworkBlock4_1

                Call    I_MapEnvelope

ReceiveNetworkBlock4_1:

                Ret

EndP            ReceiveNetworkBlock4

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SendNetworkBlock5               ; Does not send length or
                                                ; sample pointer.

                LodsB
                StosB
                And     AX, 0FFh
                Mov     CS:SendDataQueueHead, SI
                Add     AX, AX
                Mov     SI, AX

                Push    SongData
                Pop     DS
                Mov     SI, [64912+SI]

                Add     SI, 4
                Mov     CX, 2Ch/2
                Rep     MovsW
                LodsW                   ; Skip length
                LodsW
                Mov     CX, 14h/2
                Rep     MovsW
                LodsW
                LodsW
                MovsW
                MovsW

                Ret

EndP            SendNetworkBlock5

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ReceiveNetworkBlock5

                Mov     DI, [DS:7]
                And     DI, 0FFh

                Cmp     DI, 100
                JAE     ReceiveNetworkBlock5_1

                Add     DI, DI

                Push    SongData
                Pop     ES

                Mov     DI, [ES:64912+DI]
                Mov     SI, 8
                ScasW
                ScasW
                Mov     CX, 2Ch/2
                Rep     MovsW
                ScasW
                ScasW
                Mov     CX, 14h/2
                Rep     MovsW
                ScasW
                ScasW
                MovsW
                MovsW

ReceiveNetworkBlock5_1:
                Ret

EndP            ReceiveNetworkBlock5

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SendNetworkBlock6

                MovsW
                Mov     CS:SendDataQueueHead, SI

                Ret

EndP            SendNetworkBlock6

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ReceiveNetworkBlock6

                Mov     AX, [DS:7]      ; AL = pattern number, AH = numrows

                Push    Pattern
                Pop     DS
                        Assume DS:Pattern

                Cmp     AL, [Byte Ptr PatternNumber]
                JNE     ReceiveNetworkBlock6_1

                Cmp     AH, 200
                JAE     ReceiveNetworkBlock6_2

                Mov     [Byte Ptr MaxRow], AH

ReceiveNetworkBlock6_2:
                Ret

ReceiveNetworkBlock6_1:
                Jmp     ReceiveNetworkBlock0_1  ; Marks pattern as modified.

EndP            ReceiveNetworkBlock6
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SendNetworkBlock7

                MovsB
                Mov     CS:SendDataQueueHead, SI
                Ret

EndP            SendNetworkBlock7

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ReceiveNetworkBlock7

                Mov     AL, [DS:7]
                Mov     AH, 1

                Cmp     AL, 100
                JAE     ReceiveNetworkBlock7_1

                Call    Music_ReleaseSample

ReceiveNetworkBlock7_1:
                Ret

EndP            ReceiveNetworkBlock7

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SendNetworkBlock8               ; New sample

                MovsB
                MovsD
                Mov     CS:SendDataQueueHead, SI

                Ret

EndP            SendNetworkBlock8

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ReceiveNetworkBlock8            ; New sample

;                Call    Music_Stop

                Mov     AX, [DS:7]
                And     AX, 0FFh                ; AX = Sample number

        ; Sanity check
                Cmp     AX, 100
                JAE     ReceiveNetworkBlock8_2

                Mov     SI, AX
                Add     SI, AX
                Mov     EDX, [DS:8]

                Push    SongData
                Pop     DS

                Mov     SI, [SI+64912]          ; DS:SI = sample
                Mov     ECX, EDX

                Test    Byte Ptr [SI+12h], 2    ; 16 bit?
                JZ      ReceiveNetworkBlock8_1

                Add     EDX, EDX

ReceiveNetworkBlock8_1:
                Call    Music_AllocateSample
                Mov     [SI+30h], ECX

ReceiveNetworkBlock8_2:
                Ret

EndP            ReceiveNetworkBlock8

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetSampleLocation       ; Given BX = EMS transfer structure
                                        ; Given DX = sample number
                                        ; Given ECX = offset
                                        ; Returns carry if problem.

                PushAD
                Push    DS

                Push    SongData
                Pop     DS
                Mov     SI, DX
                Add     SI, DX
                Mov     SI, [64912+SI]  ; DS:SI = sample header

                Mov     EAX, [SI+30h]

                Test    Byte Ptr [SI+12h], 2
                JZ      GetSampleLocation2

                Add     EAX, EAX

GetSampleLocation2:
                Cmp     EAX, ECX
                JB      GetSampleLocation1

                Mov     EDX, EAX
                Sub     EDX, ECX
                Cmp     EDX, 32768
                JB      GetSampleLocation6

                Mov     DX, 32768

GetSampleLocation6:
                Mov     [CS:TransferLength], DX

                Cmp     Byte Ptr [SI+48h], 1
                JB      GetSampleLocation1
                JA      GetSampleLocation4

GetSampleLocation3:     ; Conventional memory
                Mov     Byte Ptr [CS:BX], 0     ; type
                Mov     DWord Ptr [CS:BX+1], 0  ; handle,Offset
                ShR     ECX, 4
                Add     CX, [SI+4Ah]
                Mov     Word Ptr [CS:BX+5], CX  ; segment

                Jmp     GetSampleLocation5

GetSampleLocation4:     ; Expanded memory
                Mov     AX, [SI+4Ah]
                Mov     Byte Ptr [CS:BX], 1
                Mov     Word Ptr [CS:BX+1], AX  ; handle
                Mov     AX, CX
                ShR     ECX, 14
                And     AX, 3FFFh
                Mov     [CS:BX+3], AX           ; Offset
                Mov     [CS:BX+5], CX           ; Page

                Jmp     GetSampleLocation5

GetSampleLocation1:
                StC

GetSampleLocation5:
                Pop     DS
                PopAD

                Ret

EndP            GetSampleLocation

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SendNetworkBlock9

                LodsB
                StosB
                Mov     DX, AX
                LodsD
                StosD
                Mov     ECX, EAX
                And     DX, 0FFh
                Mov     CS:SendDataQueueHead, SI

                Mov     BX, Offset SourceType
                Call    GetSampleLocation
                JC      SendNetworkBlock9_1

                Push    CS
                Pop     DS
                        Assume DS:Disk

                Mov     AX, NetworkSendEMSHandle
                Mov     DestinationType, 1
                Mov     DestinationHandle, AX
                Mov     [Word Ptr DestinationOffset], DI
                Mov     [Word Ptr DestinationOffset+2], 0

                Add     DI, TransferLength

; Data is ready to go!
                Mov     AX, 5700h
                Mov     SI, Offset EMSTransferTable
                Int     67h

                Ret

SendNetworkBlock9_1:
                Sub     DI, 5

                Ret

EndP            SendNetworkBlock9
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ReceiveNetworkBlock9

                Mov     DX, [DS:7]
                Mov     ECX, [DS:8]
                And     DX, 0FFh
                Mov     BX, Offset DestinationType
                Mov     AX, NetworkEMSHandle
                Mov     SI, LastReceiveCX       ; CH = page

        ; Sanity Check
                Cmp     DX, 100
                JAE     ReceiveNetworkBlock9_1

                Call    GetSampleLocation
                JC      ReceiveNetworkBlock9_1

                Push    CS
                Pop     DS
                        Assume DS:Disk

                ShR     SI, 8
                Mov     SourceType, 1
                Mov     SourceHandle, AX
                Mov     [Word Ptr SourceOffset], 12
                Mov     [Word Ptr SourceOffset+2], SI

; Data is ready to go!
                Mov     AX, 5700h
                Mov     SI, Offset EMSTransferTable
                Int     67h

ReceiveNetworkBlock9_1:
                Ret

EndP            ReceiveNetworkBlock9
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_SendData Far
; Called by driver when it is able to send data
;
; Provided: AX    = number of bytes it can send.
;           ES:DI = buffer location
;
; Returns: CX = number of bytes to send, 0 if no data.
;          DX = receiver's connection ID. 0 = all, 1->3 = specific.

                PushF
                CLI
                Push    DS
                Push    ES
                Push    DI

                Push    AX
                Push    DX

                Mov     AH, 47h
                Mov     DX, CS:NetworkSendEMSHandle
                Int     67h

                Test    AH, AH

                Pop     DX
                Pop     AX

                JNZ     Network_SendDataError

                Cmp     CS:DriverValidated, 1
                JNE     Network_SendDataError

                Mov     CX, CS:SendBufferRemaining
                Test    CX, CX
                JNZ     Network_SendData1

; Need to get a new block of data into the buffer.

Network_SendData3:
                Mov     CX, CS:SendDataQueueTail
                Mov     SI, CS:SendDataQueueHead

                Sub     CX, SI
                JZ      Network_SendDataEnd

                Mov     DS, SendQueueSegment
                        Assume DS:Nothing

                Push    AX
                Push    BX
                Push    BP
                Push    ES
                Push    DI
                Push    FS

;                Mov     DX, CS:NetworkEMSHandle
;                Call    E_SavePageFrame

                Call    Network_GetSendBufferPage
                Mov     ES, AX
                Mov     DI, 6

                LodsB
                Mov     CS:Destination, AL
                LodsB
                StosB
                Mov     BL, AL
                And     BX, 0FFh
                Add     BX, BX
                Call    [CS:ConvertQueueObjectTypes+BX]
                Call    Network_CalculateCRC

                Cmp     [CS:SendDataQueueHead], 16384-16
                JB      Network_SendData4

                Mov     [CS:SendDataQueueHead], 0

Network_SendData4:

                Mov     CX, BX          ; CX = SendBufferRemaining

                Pop     FS
                Pop     DI
                Pop     ES
                Pop     BP
                Pop     BX
                Pop     AX

;                Push    DX
;                Mov     DX, CS:NetworkEMSHandle
;                Call    E_RestorePageFrame
;                Pop     DX

                Cmp     CX, 9
                JA      Network_SendData1

                Mov     DWord Ptr [CS:SendBufferRemaining], 0
                Jmp     Network_SendData3

Network_SendData1:                      ; Send buffer has data remaining
                Mov     SI, CS:SendBufferOffset

                Cmp     CX, AX
                JB      Network_SendData2

                Mov     CX, AX

Network_SendData2:
                Add     CS:SendBufferOffset, CX
                Sub     CS:SendBufferRemaining, CX

                Call    Network_GetSendBufferPage
                Mov     DS, AX

                Xor     DX, DX
                Push    CX
                Rep     MovsB
                Pop     CX
                Mov     DL, CS:Destination

Network_SendDataEnd:
                Push    DX

                Mov     AH, 48h
                Mov     DX, CS:NetworkSendEMSHandle
                Int     67h

                Pop     DX

                Pop     DI
                Pop     ES
                Pop     DS
                PopF

                Ret

Network_SendDataError:
                Pop     DI
                Pop     ES
                Pop     DS
                PopF

                Xor     CX, CX
                Xor     DX, DX
                Ret

EndP            Network_SendData


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ReceiveToBlock  DB      0, 8, 16

; EMS layout:
;  EMS:65532: Check word
;  EMS:65534: Buffer Offset

Proc            Network_ReceiveData Far
; Called by driver when data is received
;
; Provided: DS:SI = data block received
;           BX    = sender's connection ID (0->2)
;           CX    = byte count received

                PushF
                CLI
                Push    CX

                Mov     AH, 47h
                Mov     DX, CS:NetworkEMSHandle
                Int     67h

                Test    AH, AH
                JNZ     Network_ReceiveData3
;                Call    E_SavePageFrame

                Cmp     CS:DriverValidated, 1
                JNE     Network_ReceiveData3

                Mov     CL, 512/16
                Mov     CH, [CS:ReceiveToBlock+BX]
                Mov     CS:LastReceiveCX, CX
                Call    E_MapEMSMemory

                Call    E_GetEMSPageFrame

                Pop     CX

                Mov     ES, AX
                Mov     DI, [ES:65534]

; Consistency check -> if at start of block, make sure that the header contains
; 'JLNP'

                Test    DI, DI
                JNZ     Network_ReceiveData1

                Cmp     DWord Ptr [SI], 'JLNP'
                JNE     Network_ReceiveDataEnd

Network_ReceiveData1:
                Mov     DX, [ES:65532]

; Assume OK.. now place data into buffer, updating check word.
Network_ReceiveData2:
                LodsB
                Add     DL, AL
                StosB
                Xor     DH, DL
                Loop    Network_ReceiveData2

                Cmp     DI, [ES:4]
                JAE     Network_ReceiveDataBlockFinished

                Mov     [ES:65532], DX
                Mov     [ES:65534], DI

Network_ReceiveDataEnd:
                Mov     AH, 48h
                Mov     DX, CS:NetworkEMSHandle
                Int     67h
;                Mov     DX, CS:NetworkEMSHandle
;                Call    E_RestorePageFrame

                PopF

                ClC

                Ret

Network_ReceiveDataBlockFinished:
                Xor     Byte Ptr [CS:ReceiveToBlock+BX], 4
                Mov     DWord Ptr [ES:65532], 0
                Test    DX, DX
                JNZ     Network_CRCFail                 ; CRC check failed

; ********************* Need to handle block types here.
                PushAD
                Push    DS

                Push    ES
                Pop     DS

                Mov     SI, [DS:6]
                And     SI, 0FFh

                Cmp     SI, NUMBEROFBLOCKTYPES
                JAE     Network_ReceiveDataBlockError

                Add     SI, SI
                Mov     DX, BX
                Call    [InterpretObjectTypes+SI]

Network_ReceiveDataBlockError:
                Pop     DS
                PopAD
                Jmp     Network_ReceiveDataEnd

Network_CRCFail:
                Mov     AH, 48h
                Mov     DX, CS:NetworkEMSHandle
                Int     67h
                Push    CX

Network_ReceiveData3:
                Pop     CX
                PopF

                StC

                Ret

EndP            Network_ReceiveData

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_GetSendQueue Far

                PushAD
                PushF
                Push    DS
                Push    ES

                Sub     SP, 4
                Push    BP
                Mov     BP, SP
                Mov     EDI, [BP+44]
                Mov     [BP+2], EDI
                Pop     BP

                Push    AX
                Push    DS

                ClI

                Push    CS
                Pop     DS
                        Assume DS:Disk

Comment ~
                This code is incomplete
                Mov     AX, SendDataQueueTail
                Sub     AX, SendDataQueueHead
                Cmp     AX, 16384-16
                JB      Network_GetSendQueue2

                Call    [NetworkDriver_UnloadDriver]

                Xor     AX, AX
                Jmp     Network_GetSendQueue1

Network_GetSendQueue2:
~
                Call    [NetworkDriver_ConnectionStatus]
                Mov     DI, [SendQueueSegment]
                Or      AX, DI
                Mov     ES, DI
                Mov     DI, [SendDataQueueTail]

Network_GetSendQueue1:
                Pop     DS
                Pop     AX

                Ret

EndP            Network_GetSendQueue
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_FinishedSendQueue Far

                Cmp     DI, 16384-16  ; 16 bytes slack area
                JB      Network_FinishedSendQueue1

                Xor     DI, DI

Network_FinishedSendQueue1:
                Mov     [CS:SendDataQueueTail], DI
                Mov     BP, SP
                Pop     EAX
                Mov     [BP+42], EAX

IF SHOWQUEUESIZE
                Push    CS
                Pop     DS
                Mov     AX, SendDataQueueTail
                Sub     AX, SendDataQueueHead
                Mov     SI, Offset DebugMessage
                Call    SetInfoLine
ENDIF

                Pop     ES
                Pop     DS
                PopF
                PopAD

                Ret

EndP            Network_FinishedSendQueue

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_NewConnection Far       ; Called when this computer
                                                ; joins a group

                PushA
                Push    ES

                Push    CS
                Pop     ES

                Mov     CX, 200/2               ; Mark all patterns as requiring
                                                ; update from host connection
                Mov     DI, Offset PatternModifiedTable
                Mov     AX, 101h
                Rep     StosW

                Call    Music_Stop
                Call    D_ClearFileName

                Pop     ES
                PopA
                Ret


EndP            Network_NewConnection

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ResetDI

                Cmp     DI, 16384-16
                JB      ResetDI1

                Xor     DI, DI

ResetDI1:
                Ret

EndP            ResetDI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_QueueSampleData Far     ; Given CX = Sample number, 0 base
                                                ; DL = ConnectionID

                Push    EAX
                Push    EBX
                Push    ECX
                Push    DX
                Push    SI
                Push    DS

                Push    SongData
                Pop     DS

                Call    Network_GetSendQueue
                JZ      Network_QueueSampleData2

                Mov     SI, CX
                Add     SI, CX
                Mov     SI, [SI+64912]          ; DS:SI = sample

                Test    Byte Ptr [SI+12h], 1
                JZ      Network_QueueSampleData2

                Mov     EBX, [SI+30h]
                Test    EBX, EBX
                JZ      Network_QueueSampleData2

                Mov     AL, DL
                Mov     AH, 8
                StosW
                Mov     AL, CL
                StosB
                Mov     EAX, EBX                ; Length
                StosD
                Call    ResetDI

                Mov     DH, CL

                Xor     ECX, ECX
                Test    Byte Ptr [SI+12h], 2
                JZ      Network_QueueSampleData1

                Add     EBX, EBX

Network_QueueSampleData1:
                Mov     AL, DL
                Mov     AH, 9
                StosW
                Mov     AL, DH
                StosB
                Mov     EAX, ECX
                StosD
                Call    ResetDI

                Add     ECX, 32768
                Cmp     ECX, EBX
                JB      Network_QueueSampleData1

Network_QueueSampleData2:
                Call    Network_FinishedSendQueue

                Pop     DS
                Pop     SI
                Pop     DX
                Pop     ECX
                Pop     EBX
                Pop     EAX

                Ret

EndP            Network_QueueSampleData

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_EstablishConnection Far ; Called when a connection is
                                                ; made to this computer
; Called when a successful connection is made
; Given AL = new connection number

; This basically adds all samples, instruments, patterns,
; and order list to the send queue (or requests to the appropriate nodes)

                PushA
                Push    DS
                Push    ES

                Mov     ES, CS:SendQueueSegment
                Mov     DI, CS:SendDataQueueTail

; Send Patterns
                Xor     CX, CX
                Mov     DX, AX

Network_EstablishConnection1:           ; 3 * 200 bytes
                Mov     AL, DL          ; Destination
                Mov     AH, 1           ; NETWORK_ENTIREPATTERNOBJECT
                StosW
                Mov     AL, CL
                StosB
                Call    ResetDI
                Inc     CX
                Cmp     CX, 200
                JB      Network_EstablishConnection1

; Send Instruments
                Xor     CX, CX

Network_EstablishConnection2:           ; 3 * 100 bytes
                Mov     AL, DL          ; Destination
                Mov     AH, 4
                StosW
                Mov     AL, CL
                StosB
                Call    ResetDI
                Inc     CX
                Cmp     CX, 100
                JB      Network_EstablishConnection2

; Send Sample headers
                Xor     CX, CX

Network_EstablishConnection3:           ; 3 * 100 bytes
                Mov     AL, DL          ; Destination
                Mov     AH, 5
                StosW
                Mov     AL, CL
                StosB
                Call    ResetDI
                Inc     CX
                Cmp     CX, 100
                JB      Network_EstablishConnection3

; Now send order list                   ; 6 bytes
                Mov     AL, DL          ; Destination
                Mov     AH, 3           ; NETWORK_SONGDATAOBJECT
                StosW
                Mov     AX, 512         ; Length
                StosW
                Xor     AX, AX          ; Offset
                StosW
                Call    ResetDI

                Mov     CS:SendDataQueueTail, DI

                Xor     CX, CX

Network_EstablishConnection4:
                Call    Network_QueueSampleData

                Inc     CX

                Cmp     CX, 100
                JB      Network_EstablishConnection4

; Loop through patterns and make sure that no patterns are destined for new
; connection

                Push    CS
                Pop     ES

                Mov     CX, 200
                Mov     DI, Offset PatternModifiedTable

Network_EstablishConnection5:
                Mov     AL, [ES:DI]
                Cmp     AL, DL
                JNE     Network_EstablishConnection6

                Xor     AL, AL

Network_EstablishConnection6:
                StosB
                Loop    Network_EstablishConnection5

                Pop     ES
                Pop     DS
                PopA

                Ret

EndP            Network_EstablishConnection

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_AddWordToQueue Far      ; Given AX, broadcasts to all

                Call    Network_GetSendQueue
                JZ      Network_AddWordToQueue0

                Push    AX
                Xor     AL, AL
                StosB
                Pop     AX
                StosW

Network_AddWordToQueue0:
                Call    Network_FinishedSendQueue
                Ret

EndP            Network_AddWordToQueue

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_UpdatePatternIfIdle Far

                Cmp     CS:SendQueueSegment, 0
                JE      Network_UpdatePatternEnd

                Push    AX
                Mov     AX, CS:SendDataQueueTail
                Cmp     AX, CS:SendDataQueueHead
                Pop     AX
                JNE     Network_UpdatePatternEnd

Proc            Network_UpdatePattern Far

                PushA
                                ; AX = pattern number
; Check whether it is current.
; AL = Pattern number

                Mov     BX, AX
                And     BX, 0FFh
                Xor     AX, AX

                XChg    [CS:PatternModifiedTable+BX], AL
                Test    AL, AL
                JZ      Network_UpdatePattern1

; AL = connection request
                Call    Network_GetSendQueue
                JZ      Network_UpdatePattern2

                StosB
                Mov     AL, 2   ; NETWORK_REQUESTPATTERNOBJECT
                Mov     AH, BL
                StosW

Network_UpdatePattern2:
                Call    Network_FinishedSendQueue

Network_UpdatePattern1:
                PopA

Network_UpdatePatternEnd:
                Ret

EndP            Network_UpdatePattern

EndP            Network_UpdatePatternIfIdle

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_EnsureNoNetwork Far

                Push    AX
                Call    [CS:NetworkDriver_ConnectionStatus]
                Test    AL, AL
                Pop     AX
                JZ      Network_EnsureNoNetwork1

                Mov     DI, Offset O1_NetworkErrorList
                Mov     CX, 2
                Call    M_Object1List

                Mov     AX, 1
                Add     SP, 4

Network_EnsureNoNetwork1:
                Ret

EndP            Network_EnsureNoNetwork

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_SendSampleHeader Far

                Call    Network_GetSendQueue
                JZ      Network_SendSampleHeader1

                Mov     AX, 500h                ; Sample header, broadcast
                StosW
                Call    PE_GetLastInstrument
                Mov     AL, BL
                StosB

Network_SendSampleHeader1:
                Call    Network_FinishedSendQueue
                Ret

EndP            Network_SendSampleHeader

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_SendInstrumentHeader Far

                Call    Network_GetSendQueue
                JZ      Network_SendInstrumentHeader1

                Mov     AX, 400h                ; Instrument header, broadcast
                StosW
                Call    PE_GetLastInstrument
                Mov     AL, BL
                StosB

Network_SendInstrumentHeader1:
                Call    Network_FinishedSendQueue
                Ret

EndP            Network_SendInstrumentHeader

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Network_SendSongDataInformation Far     ; CX = Count, DX = offset

                Call    Network_GetSendQueue
                JZ      Network_SendSongDataInformation1

                Mov     AX, 300h
                StosW
                Mov     AX, CX
                StosW
                Mov     AX, DX
                StosW

Network_SendSongDataInformation1:
                Call    Network_FinishedSendQueue
                Ret

EndP            Network_SendSongDataInformation

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

EndS

ENDIF

End
