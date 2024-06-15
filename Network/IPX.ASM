;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Network Module                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                        Jumps
                        .386P

DRIVERIDSTRING EQU      "IPX Network Driver, Copyright (C) 1999 Jeffrey Lim", 0
FIXEDUSERNAME   EQU     1

Segment                 DriverHeader PARA Public 'Code' Use16
                        Assume CS:DriverHeader, DS:Nothing

;***** Driver Header *******

include drhead.inc

EndS

; DiskDataArea format:
;  Word   ConnectionIDNum
;  16     Username
;  10     Address
;  DWord  Reserved.

; Maintenance blocks
; Acknoweledgement:
;  Offset 0:    DB      0       ; Block type
;  Offset 1:    DB      PacketID                ; 2 bytes

; Intro:
;  Offset 0:    DB      1       ; Block type
;  Offset 1:    DB      Initiate/Response
;  Offset 2:    DB      NumberOfConnections
;  Offset 3:    16 bytes name
;  Offset 19:   12 bytes socket address
;  Offset 31->114: 16 bytes name followed by 12 bytes address (3 sets)
; Max size = 115 bytes.

; Note: If Destination of Intro was FF:FF:FF:FF:FF:FF (ie. broadcast)
;       Then a reply intro must be made

; Remove:
;  Offset 0:    DB      2       ; Block type - size = 1
; Called when a person gains a maximum limit of 3 extra connections
; Or does not wish to be listed in the IPX screen any further.

; Quit:
;  Offset 0:    DB      3       ; Block type - size = 1
; Called when a person unloads the IPX driver for any reason.
; Causes removal from group and removal from listings

; Talk:
;  Offset 0:    DB      4       ; Block type, talk
;  Offset 1:    16 bytes        ; Sender name
;  Offset 17:   60 bytes        ; Message

; Close connection              ; Remove oneself from the group.
;  Offset 0:    DB      5
; Causes removal from group

; Request connection
;  Offset 0:    DB      6
;  Offset 1:    16 bytes        ; Sender name
; Only nodes with no connections can request connections

; Accept/Reject connection
;  Offset 0:    DB      7
;  Offset 1:    DB      Number of connections including this one. 0 = reject
;  Offset 2:            Other user information (name (16), full address(12))
; Reply from requested node.

; Confirm connection
;  Offset 0:    DB      8
;  Offset 1:    DB      Confirm         0 = cancelled
;  Offset 2:            UserName (16), Full Address (12)
; Add this to the connection list
; Send out this information to anyone already connected to this group.

; Request intro
;  Offset 0:    DB      9

; Notes:
;  The IPX driver will automatically open port 'IT' (4945h) to listen
;   for general/maintenance broadcasts (Socket1). Listening packets at
;   socket 2 will (only) receive a maximum of 128 bytes.
;  A dedicated (dynamically allocated) socket will be used for all music data.
;   (Socket2). Socket2 will be able to receive the MAXDATASIZE (1024 bytes)
;  Initiate/Terminate connection requests are handled through Socket1
;  Once established, the IPX driver will use 4 packets for listening.
;  Each send packet will be timestamped in order to have a maximum timeout,
;   after which an error message is generated, giving the user the option to
;   drop the participant.
;  Acknowledgement packets will be sent for everything received at Socket2 to
;   Socket1 of the sender.

; Required functions:
;  GetBuffer(NumberOfBytes) - returns pointer
;  SetBuffer(NumberOfBytes, Data)
;  GetTimer - returns number of ticks since program startup in EAX.
;  Generic Function Handler
;  S_GetDestination
;  S_DrawString
;  SetInfoLine

; Variables required:
;  GlobalKeyList

; Provided functions:
;  DriverScreen
;  Poll (Update procedure)

; Note: IT's network handler will send data to:
;       either 0 -> everyone
;       or individual connections.
;

MAXIMUMUSERS    EQU     4
TIMEOUT         EQU     10
SENDTIMEOUT     EQU     182     ; 10 seconds
RETRYTIMEOUT    EQU     36      ; 2 seconds
MAINTENANCETIMEOUT EQU  18      ; 1 second

TRACEENABLED    EQU     0
SCREENTRACEENABLED EQU  0
CREATENEWLOGFILE EQU    1

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Externals                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ


;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment                 IPX PARA Public 'Code' USE16
                        Assume  CS:IPX, DS:Nothing, ES:Nothing

ORG 0
StartDriver:

include vtable.inc
include reqproc.inc

IPXEntryAddress         Label   DWord
        DW      Offset F_Nothing        ; Done so that it won't crash if there's
Seg14   DW      0                       ; no IPX due to call to Poll

IPXMaximumPacketSize    DW      0
IPXRetryCount           DW      0

IntroBlockInformation   Label   ; ****************************************
                        DB      1               ; Block type
NumberOfConnections     DB      0

IF FIXEDUSERNAME
 include username.inc
ELSE
 CONFIGURATIONOFFSET     EQU     $+128
 CONFIGURATIONSIZE       EQU     16
 UserName                DB      16 Dup (0)
 IPXLocalAddress         Label
 IPXNetworkAddress       DD      0               ; Do not change order
 IPXNodeAddress          DW      0, 0, 0         ;
 IPXSocket               DW      0               ; Dynamic socket
ENDIF

UserName1               DB      16 Dup (0)
UserAddress1            DB      10 Dup (0)
UserSocket1             DW      0
UserName2               DB      16 Dup (0)
UserAddress2            DB      10 Dup (0)
UserSocket2             DW      0
UserName3               DB      16 Dup (0)
UserAddress3            DB      10 Dup (0)      ; size = 26*4+2=106
UserSocket3             DW      0

AcknowledgementBlockInformation Label   ; ************************************
                        DB      0
PacketID                DB      0       ; Size = 2

ByteBlockInformation    Label
ByteBlock               DB      0

OldNumberOfConnections  DB      0

MessageReceived         DB      0
IFE FIXEDUSERNAME
DriverName              DB      "ITIPX.NET", 0
ENDIF

ALIGN 2

OldNumNodes             DW      0
NumNodes                DW      0
TopNode                 DW      0
CurrentNode             DW      0

NoReply                 DB      0
SendingData             DB      0
SendTime                DD      0
RetryTime               DD      0
LastPacketSize          DW      0

; ---- Interface stuff --------------------------------------------------------

RequestConnectionBox    DW      0
                        DB      27, 24, 54, 32
                        DB      3

RequestConnectionText   DW      1
                        DB      29, 27
                        DB      20h
                        DB      "Connection request from:", 13
                        DB      "    "
ConnectionRequestName   DB      16 Dup (0)
ConnectionRequestAddress DB     12 Dup (0)
ConnectionRequest       DB      0       ; Bit 0 = requesting a connection
                                        ; Bit 1 = connection requested, waiting
                                        ;         for reply.
                                        ; Bit 2 = connection accepted, waiting
                                        ;         for verification.
                                        ; Bit 7 = leave connetion request box

IPXHeaderText           DW      1
                        DB      36, 25
                        DB      23h
                        DB      "IPX Driver", 0

AcceptButton            DW      2
                        DW      0FFFFh, 0FFFFh, 4, 4
                        DW      0
                        DW      0, 0
                        DW      0
                        DW      1               ; Returns 1
                        DW      0, 0, 0, 0
                        DB      28, 29, 39, 31
                        DB      8
                        DB      0
                        DB      "  Accept", 0

RejectButton            DW      2
                        DW      0FFFFh, 0FFFFh, 3, 3
                        DW      0
                        DW      0, 0
                        DW      0
                        DW      0               ; Returns 0
                        DW      0, 0, 0, 0
                        DB      41, 29, 52, 31
                        DB      8
                        DB      0
                        DB      "  Reject", 0

ConnectionRequestList   DW      3
                        DW      IdleFunctionList2
                        DW      ESCReturn0List
                        DW      RequestConnectionBox
                        DW      IPXHeaderText
                        DW      RequestConnectionText
                        DW      AcceptButton
                        DW      RejectButton
                        DW      0

WaitforConnectList      DW      2
                        DW      IdleFunctionList2  ; Needs check for connection
                        DW      ESCReturn0List     ; No global keys.
                        DW      NoIPXBox
                        DW      WaitforConnectText
                        DW      CancelButton
                        DW      0

ConnectionRejectedList  DW      2
                        DW      IdleFunctionList
                        DW      ESCReturn0List
                        DW      NoIPXBox
                        DW      ConnectionRejectedText
                        DW      OKButton
                        DW      0

ConnectionCancelledList DW      2
                        DW      IdleFunctionList
                        DW      ESCReturn0List
                        DW      NoIPXBox
                        DW      ConnectionCancelledText
                        DW      OKButton
                        DW      0

WaitforConnectText      DW      1
                        DB      28, 27
                        DB      20h
                        DB      "Requesting Connection...", 0


FullScreenBox           DW      0
                        DB      0, 0, 79, 49
                        DB      4

NoIPXBox                DW      0
                        DB      25, 25, 54, 32
                        DB      3

NoIPXText               DW      1
                        DB      28, 27
                        DB      20h
                        DB      "IPX Network not detected", 0

ConnectionRejectedText  DW      1
                        DB      31, 27
                        DB      20h
                        DB      "Connection refused", 0

ConnectionCancelledText DW      1
                        DB      30, 27
                        DB      20h
                        DB      "Connection cancelled", 0

NoSocketText            DW      1
                        DB      27, 27
                        DB      20h
                        DB      "IPX Socket request failure", 0

IFE FIXEDUSERNAME
UserNameBox             DW      0
                        DB      31, 29, 48, 31
                        DB      27

UserNameText            DW      1
                        DB      29, 27
                        DB      20h
                        DB      "Please enter your name", 0
ENDIF

ESCReturn0List          DB      0
                        DW      101h
                        DW      Offset F_Return0
KeyListSeg1             DW      0
                        DB      0FFh

IFE FIXEDUSERNAME
UserNameInput   DW      16
                DB      32, 30
StringSeg1      DW      0
                DW      Offset UserName
                DW      16
                DW      Offset F_Return1
StringSeg2      DW      0
                DW      0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh
ENDIF

FillHeader              DW      8
FillHeader2             DD      0

DrawHeader              DW      8
DrawHeader2             DD      0

OKButton                DW      2
                        DW      0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      0
                        DW      0               ; Returns 0
                        DW      0, 0, 0, 0
                        DB      35, 29, 44, 31
                        DB      8
                        DB      0
                        DB      "   OK", 0

CancelButton            DW      2
                        DW      0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      0
                        DW      0               ; Returns 0
                        DW      0, 0, 0, 0
                        DB      34, 29, 45, 31
                        DB      8
                        DB      0
                        DB      "  Cancel", 0

SocketErrorList         DW      2
                        DW      Near Ptr IdleFunctionList
                        DW      0
                        DW      Near Ptr NoIPXBox
                        DW      Near Ptr NoSocketText
                        DW      Near Ptr OKButton
                        DW      Near Ptr FillHeader
                        DW      0

NoIPXMessageList        DW      2
                        DW      Near Ptr IdleFunctionList
                        DW      Near Ptr ESCReturn0List
                        DW      Near Ptr NoIPXBox
                        DW      Near Ptr NoIPXText
                        DW      Near Ptr OKButton
                        DW      Near Ptr FillHeader
                        DW      0

IFE FIXEDUSERNAME
IPXGetName              Label
                        DW      5
                        DW      Near Ptr IdleFunctionList
                        DW      Near Ptr ESCReturn0List

                        DW      Near Ptr DrawHeader
                        DW      Near Ptr FillHeader
                        DW      Near Ptr NoIPXBox
                        DW      Near Ptr UserNameText
                        DW      Near Ptr UserNameBox
                        DW      Near Ptr UserNameInput

                        DW      0
ENDIF

IPXConnectedScreen      Label
                        DW      5
                        DW      Near Ptr IdleFunctionList2
                        DW      Near Ptr GlobalKeyLink

                        DW      Near Ptr FullScreenBox
                        DW      Near Ptr DrawHeader
                        DW      Near Ptr FillHeader
                        DW      Near Ptr IPXHeader

                        DW      Near Ptr ConnectionDetailMsg
                        DW      Near Ptr LeaveSessionButton
                        DW      Near Ptr ShowConnectionDetails

                        DW      Near Ptr MessageBox
                        DW      Near Ptr MessageEnterBox
                        DW      Near Ptr SendMessageText
                        DW      Near Ptr GroupMessageInput

                        DW      Near Ptr ShowConnectMessages
                        DW      Near Ptr PacketsSentMessage
                        DW      Near Ptr PacketsReceivedMessage
                        DW      Near Ptr PacketsFailedMessage
                        DW      Near Ptr PacketsRetryMessage
                        DW      Near Ptr PacketsAckMessage

                        DW      0

PacketsSentMessage      DW      1
                        DB      2, 33
                        DB      20h
                        DB      "Packets sent: ", 0FDh, "D", 0
PacketsSent             DW      0

PacketsReceivedMessage  DW      1
                        DB      2, 34
                        DB      20h
                        DB      "Packets rcvd: ", 0FDh, "D", 0
PacketsReceived         DW      0

PacketsFailedMessage    DW      1
                        DB      2, 35
                        DB      20h
                        DB      "Packets fail: ", 0FDh, "D", 0
PacketsFailed           DW      0

PacketsRetryMessage     DW      1
                        DB      2, 36
                        DB      20h
                        DB      "Packets rtry: ", 0FDh, "D", 0
PacketsRetry            DW      0

PacketsAckMessage       DW      1
                        DB      2, 32
                        DB      20h
                        DB      "Acks Rcvd: ", 0FDh, "D", 0
PacketsAck              DW      0

ConnectionDetailMsg     DW      1
                        DB      2, 13
                        DB      23h
                        DB      "Connection Details", 0

LeaveSessionButton      DW      2
                        DW      10, 10, 0FFFFh, 0FFFFh
                        DW      0
                        DW      0, 0
                        DW      4
                        DW      Offset IPX_LeaveSession
Seg19                   DW      0
                        DW      0, 0, 0
                        DB      61, 12, 78, 14
                        DB      8
                        DB      0
                        DB      "     Leave", 0

ShowConnectionDetails   DW      8
                        DW      Offset IPX_ShowConnectionDetails
Seg20                   DW      0

IPXScreen               Label
                        DW      5
                        DW      Near Ptr IdleFunctionList2
                        DW      Near Ptr GlobalKeyLink

                        DW      Near Ptr FullScreenBox
                        DW      Near Ptr DrawHeader
                        DW      Near Ptr FillHeader
                        DW      Near Ptr IPXHeader

                        DW      Near Ptr NodeBox
                        DW      Near Ptr ConnectNetworkList

                        DW      Near Ptr UnloadDriverButton

                        DW      Near Ptr MessageBox
                        DW      Near Ptr MessageEnterBox
                        DW      Near Ptr SendMessageText
                        DW      Near Ptr ConnectMessageInput

                        DW      Near Ptr ShowConnectMessages

                        DW      0

IPXQueueScreen  DW      0

IPXHeader       DW      10
                DB      "IPX Network Driver", 0

NodeBox         DW      0
                DB      2, 12, 52, 36
                DB      27

MessageBox      DW      0
                DB      2, 37, 78, 46
                DB      27

MessageEnterBox DW      0
                DB      15, 47, 78, 49
                DB      27

SendMessageText DW      1
                DB      3, 48
                DB      20h
                DB      "Send Message", 0

ConnectMessageInput    DW      16      ; String input
                DB      16, 48
Seg16           DW      0
                DW      Offset MessageEntryArea
                DW      56
                DW      Offset IPX_SendMessage
Seg17           DW      0
                DW      5, 5, 5, 6

GroupMessageInput    DW      16      ; String input
                DB      16, 48
Seg21           DW      0
                DW      Offset MessageEntryArea
                DW      56
                DW      Offset IPX_SendGroupMessage
Seg22           DW      0
                DW      5, 5, 5, 6

ShowConnectMessages     DW      8
                        DW      Offset IPX_DisplayMessages
Seg18                   DW      0

UnloadDriverButton      DW      2
                        DW      0FFFFh, 10, 5, 10
                        DW      0
                        DW      0, 0
                        DW      4
                        DW      Offset IPX_Shutdown
Seg15                   DW      0
                        DW      0, 0, 0
                        DB      61, 12, 78, 14
                        DB      8
                        DB      0
                        DB      "   Disconnect", 0

IdleFunctionList        DD      0
                        DD      0

ConnectNetworkList      DW      15
DrawConnectNetworkList  DW      Offset IPX_DrawConnect
Seg11                   DW      0
PreConnectNetworkList   DW      Offset IPX_PreConnect
Seg12                   DW      0
PostConnectNetworkList  DW      Offset IPX_PostConnect
Seg13                   DW      0

IdleFunctionList2       DD      0
                        DW      Offset IdleCheck
IdleSeg                 DW      0
                        DD      0

GlobalKeyLink           DB      7
GlobalKeyLink2          DD      0

Label           ConnectKeys     Byte
                        DB      0
                        DW      1C8h            ; Up arrow
                        DW      IPX_ConnectUp

                        DB      0
                        DW      1D0h            ; Down arrow
                        DW      IPX_ConnectDown

                        DB      0               ; PgUp
                        DW      1C9h
                        DW      IPX_ConnectPgUp

                        DB      0               ; PgDn
                        DW      1D1h
                        DW      IPX_ConnectPgDn

                        DB      0
                        DW      1C7h
                        DW      IPX_ConnectHome

                        DB      0
                        DW      1CFh
                        DW      IPX_ConnectEnd

                        DB      0               ; Tab
                        DW      10Fh
                        DW      IPX_ConnectTab

                        DB      0
                        DW      11Ch
                        DW      IPX_ConnectEnter

                        DB      0FFh

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

MessageBlock            DB      4
MessageSenderName       DB      16 Dup (0)
MessageEntryArea        DB      56 Dup (0)

MessageData             DB      72*8 Dup (0)

InfoListMessage         DB      64 Dup (0)
ConnectionNumberMsg     DB      "Connection Number ", 0FDh, "D", 0Dh
                        DB      " User name: ", 0
ConnectionAddressMsg    DB      " User address: ", 0
UnknownPacketMessage    DB      "IPX Error: Unknown Packet Type Received", 0

; This prompt needs to be reworded.
AutoRejectMessage       DB      "IPX AutoRejectConnection: "
ClosedMessage           DB      "IPX ClosedConnection: "
AutoDropMessage         DB      "IPX DropConnection: "

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Macro_MaintenanceRHeader Macro Index
        MaintenanceRHeader&Index& Label
                DW      0               ; Checksum
                DW      0               ; Length
                DB      0               ; Transport Control
                DB      4               ; Packet type
                DB      12 Dup (0)      ; Destination Address
                DB      12 Dup (0)      ; Source Address
        MaintenanceRData&Index& Label
                DB      128 Dup (0)

EndM

        IndexCounter = 1
        Rept    4
                Macro_MaintenanceRHeader %IndexCounter
                IndexCounter = IndexCounter+1
        EndM

MaintenanceSendHeaderBroadcast Label
        DW      0               ; Checksum
        DW      0               ; Length
        DB      0               ; Transport Control
        DB      4               ; Packet type
        DB      0, 0, 0, 0                          ; Destination net address
        DB      0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh  ; Node address - broadcast
        DW      'IT'                                ; Destination socket
        DB      12 Dup (0)      ; Source Address

MaintenanceSendHeaderDirected Label
        DW      0               ; Checksum
        DW      0               ; Length
        DB      0               ; Transport Control
        DB      4               ; Packet type
MaintenanceDirectedDestination Label
        DB      12 Dup (0)      ; Destination address
        DB      12 Dup (0)      ; Source Address

MaintenanceECB1 Label
        DD      0       ; Link Address          - IPX controlled
        DW      Offset MaintenanceESR
MESeg1  DW      0
        DB      0       ; In use flag           - IPX controlled
        DB      0       ; Completion code       - IPX controlled
        DW      'IT'    ; Socket Number         - Required
        DB      16 Dup (0) ; IPX workspace      - IPX controlled
        DB      6 Dup (0)  ; Immediate address  - IPX controlled
        DW      2       ; Fragment count        - Required
        DW      Offset MaintenanceRHeader1
Seg1    DW      0
        DW      30      ; Fragment size 1
        DW      Offset MaintenanceRData1
Seg2    DW      0
        DW      128     ; Fragment size 2

MaintenanceECB2 Label
        DD      0       ; Link Address          - IPX controlled
        DW      Offset MaintenanceESR
MESeg2  DW      0
        DB      0       ; In use flag           - IPX controlled
        DB      0       ; Completion code       - IPX controlled
        DW      'IT'    ; Socket Number         - Required
        DB      16 Dup (0) ; IPX workspace      - IPX controlled
        DB      6 Dup (0)  ; Immediate address  - IPX controlled
        DW      2       ; Fragment count        - Required
        DW      Offset MaintenanceRHeader2
Seg3    DW      0
        DW      30      ; Fragment size 1
        DW      Offset MaintenanceRData2
Seg4    DW      0
        DW      128     ; Fragment size 2

MaintenanceECB3 Label
        DD      0       ; Link Address          - IPX controlled
        DW      Offset MaintenanceESR
MESeg3  DW      0
        DB      0       ; In use flag           - IPX controlled
        DB      0       ; Completion code       - IPX controlled
        DW      'IT'    ; Socket Number         - Required
        DB      16 Dup (0) ; IPX workspace      - IPX controlled
        DB      6 Dup (0)  ; Immediate address  - IPX controlled
        DW      2       ; Fragment count        - Required
        DW      Offset MaintenanceRHeader3
Seg5    DW      0
        DW      30      ; Fragment size 1
        DW      Offset MaintenanceRData3
Seg6    DW      0
        DW      128     ; Fragment size 2

MaintenanceECB4 Label
        DD      0       ; Link Address          - IPX controlled
        DW      Offset MaintenanceESR
MESeg4  DW      0
        DB      0       ; In use flag           - IPX controlled
        DB      0       ; Completion code       - IPX controlled
        DW      'IT'    ; Socket Number         - Required
        DB      16 Dup (0) ; IPX workspace      - IPX controlled
        DB      6 Dup (0)  ; Immediate address  - IPX controlled
        DW      2       ; Fragment count        - Required
        DW      Offset MaintenanceRHeader4
Seg7    DW      0
        DW      30      ; Fragment size 1
        DW      Offset MaintenanceRData4
Seg8    DW      0
        DW      128     ; Fragment size 2

MaintenanceSendECB      Label
        DD      0       ; Link Address          - IPX controlled
        DD      0
SendECBInUse    Label   Byte
        DB      0       ; In use flag           - IPX controlled
        DB      0       ; Completion Code       - IPX controlled
        DW      'IT'    ; Socket Number         - Required
        DB      16 Dup (0) ; IPX workspace      - IPX controlled
MSendDest DB    6 Dup (0FFh); Immediate address - broadcast
        DW      2       ; Fragment count        - Required
MaintenanceSendHeader           DW      0
Seg9                            DW      0
                                DW      30      ; Fragment size 1
MaintenanceSendDataOffset       DW      0
Seg10                           DW      0
MaintenanceSendDataSize         DW      0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

MaintenanceSData        DB      128 Dup (0)

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


;Data packet definitions.

Zero            DB      0
Ten             DB      10

NUMBEROFLISTENINGPACKETS        EQU     4
MAXDATASIZE                     EQU     1024

Macro_DataReceiveBlock  Macro   Index
        DataReceiveHeader&Index& Label
                DW      0               ; Checksum
                DW      0               ; Length
                DB      0               ; Transport Control
                DB      4               ; Packet type
                DB      12 Dup (0)      ; Destination Address
                DB      12 Dup (0)      ; Source Address
        DataReceive&Index& Label
                DB      MAXDATASIZE Dup (0)

        DataReceiveECB&Index& Label
                        DD      0               ; Link Address   -IPX controlled
                        DW      Offset DataESR
        DataSegA&Index& DW      0
                        DB      0               ; In use flag    -IPX controlled
                        DB      0               ; Completion code-IPX controlled
        DSocket&Index&  DW      0               ; Socket Number  -Required
                        DB      16 Dup (0)      ; IPX workspace  -IPX controlled
                        DB      6 Dup (0)       ; Immediate addr -IPX controlled
                        DW      2               ; Fragment count -Required
                        DW      Offset DataReceiveHeader&Index&
        DataSegB&Index& DW      0
                        DW      30              ; Fragment Size 1
                        DW      Offset DataReceive&Index&
        DataSegC&Index& DW      0
                        DW      MAXDATASIZE     ; Fragment size 2

EndM

Macro_SendAckBlock      Macro   Index

        SendAckHeader&Index& Label
                DW      0               ; Checksum
                DW      0               ; Length
                DB      0               ; Transport Control
                DB      4               ; Packet type
                DB      10 Dup (0)      ; Destination Address
                DW      'IT'
                DB      12 Dup (0)      ; Source Address

        SendAckECB&Index& Label
                        DD      0               ; Link Address   -IPX controlled
                        DD      0               ; ESR Address    -None
                        DB      0               ; In use flag    -IPX controlled
                        DB      0               ; Completion code-IPX controlled
                        DW      'IT'            ; Socket Number  -Required
                        DB      16 Dup (0)      ; IPX workspace  -IPX controlled
                        DB      6 Dup (0)       ; Immediate addr -IPX controlled
                        DW      2               ; Fragment count -Required
                        DW      Offset SendAckHeader&Index&
        SendAckA&Index& DW      0
                        DW      30              ; Fragment Size 1
                        DW      Offset Zero     ; Offset 42 = 2Ah
        SendAckB&Index& DW      0
                        DW      1

EndM

        IndexCounter = 1
        Rept    NUMBEROFLISTENINGPACKETS
                Macro_DataReceiveBlock %IndexCounter
                IndexCounter = IndexCounter + 1
        EndM

        IndexCounter = 1
        Rept    (MAXIMUMUSERS-1)
                Macro_SendAckBlock %IndexCounter
                IndexCounter = IndexCounter + 1
        EndM


Macro_DataSendBlock     Macro   Index
        DataSendHeader&Index& Label
                DW      0               ; Checksum
                DW      0               ; Length
                DB      0               ; Transport Control
                DB      4               ; Packet type
                DB      12 Dup (0)      ; Destination Address
                DB      12 Dup (0)      ; Source Address

        DataSendECB&Index&      Label
                        DD      0               ; Link Address   -IPX controlled
                        DW      Offset SendDataESR
        SDataSegA&Index& DW     0
                        DB      0               ; In use flag    -IPX controlled
        SResult&Index&  DB      0               ; Completion code-IPX controlled
        SDSocket&Index& DW      0               ; Socket Number  -Required
                        DB      16 Dup (0)      ; IPX workspace  -IPX controlled
                        DB      6 Dup (0)       ; Immediate addr -IPX controlled
                        DW      2               ; Fragment count -Required
                        DW      Offset DataSendHeader&Index&
        SDataSegB&Index& DW     0
                        DW      30              ; Fragment Size 1
                        DW      Offset DataSend
        SDataSegC&Index& DW     0
                        DW      MAXDATASIZE     ; Fragment size 2
EndM

        DataSend        DB      MAXDATASIZE Dup (0)

        IndexCounter = 1
        Rept    3
                Macro_DataSendBlock %IndexCounter
                IndexCounter = IndexCounter + 1
        EndM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; RELOCATION TABLE
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Macro_DataSegments Macro Index
        DW      Offset DataSegA&Index&
        DW      Offset DataSegB&Index&
        DW      Offset DataSegC&Index&
EndM

Macro_AckSegments Macro Index
        DW      Offset SendAckA&Index&
        DW      Offset SendAckB&Index&
EndM

Macro_SDataSegments Macro Index
        DW      Offset SDataSegA&Index&
        DW      Offset SDataSegB&Index&
        DW      Offset SDataSegC&Index&
EndM

RelocationTable Label   Word
        DW      Offset Seg1, Offset Seg2, Offset Seg3, Offset Seg4
        DW      Offset Seg5, Offset Seg6, Offset Seg7, Offset Seg8
        DW      Offset Seg9, Offset Seg10
IFE FIXEDUSERNAME
        DW      Offset StringSeg1, Offset StringSeg2
ENDIF
        DW      Offset MESeg1, Offset MESeg2, Offset MESeg3, Offset MESeg4
        Dw      Offset KeyListSeg1, Offset IdleSeg, Offset Seg11, Offset Seg12
        DW      Offset Seg13, Offset Seg14, Offset Seg15, Offset Seg16
        DW      Offset Seg17, Offset Seg18, Offset Seg19, Offset Seg20
        DW      Offset Seg21, Offset Seg22

        IndexCounter = 1
        Rept    NUMBEROFLISTENINGPACKETS
                Macro_DataSegments %IndexCounter
                IndexCounter = IndexCounter + 1
        EndM

        IndexCounter = 1
        Rept    (MAXIMUMUSERS-1)
                Macro_AckSegments %IndexCounter
                IndexCounter = IndexCounter + 1
        EndM

        IndexCounter = 1
        Rept    3
                Macro_SDataSegments %IndexCounter
                IndexCounter = IndexCounter + 1
        EndM

        DW      0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

include debug.inc

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_Nothing Far

                Xor     AX, AX
                Ret

EndP            F_Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_Return0 Far

                Xor     DX, DX
                Mov     AX, 4

                Ret

EndP            F_Return0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            F_Return1 Far

                Cmp     Byte Ptr [CS:UserName], 0
                JE      F_Return0

                Mov     DX, 1
                Mov     AX, 4
                Ret

EndP            F_Return1

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IdleCheck Far

                Push    CS
                Pop     DS
                        Assume DS:IPX

                Mov     AL, ConnectionRequest
                And     ConnectionRequest, 0Fh

                Test    AL, 1
                JZ      IdleCheckConnectionRequestBit1

IdleCheckConnectionRequestBit0:         ; OK.. connection around
                Test    AL, AL
                JNS     IdleNoRedraw

                Mov     DX, 1           ; Return 1.
                Jmp     IdleCheckReturnValue

IdleCheckConnectionRequestBit1:         ; If connection is cancelled before
                Test    AL, 2
                JZ      IdleCheckNoConnectionRequest

                Test    AL, AL          ; Acceptance or Rejection.
                JNS     IdleNoRedraw

                Mov     DX, 2

IdleCheckReturnValue:
                Mov     AX, 5
                Mov     DI, 4
                Ret

IdleCheckNoConnectionRequest:
                Mov     AL, NumberOfConnections
                Cmp     OldNumberOfConnections, AL
                Mov     OldNumberOfConnections, AL
                JE      IdleCheck3

;                Mov     AX, 5
;                Mov     DI, 1           ; Redraw
;                Ret
                Jmp     IPX_DriverScreen

IdleCheck3:
                Mov     AX, NumNodes
                Cmp     AX, OldNumNodes
                Mov     OldNumNodes, AX
                JE      IdleCheck1

IdleCheck2:
                Mov     AX, 1
                Ret

IdleCheck1:
                Cmp     MessageReceived, 0
                Mov     MessageReceived, 0
                JNE     IdleCheck2

IdleNoRedraw:
                Xor     AX, AX
                Ret

EndP            IdleCheck
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            TransferDestinationAddress      ; SI = Header

                Push    AX
                Push    CX
                Push    SI
                Push    DI

                Add     SI, 12h
                Mov     DI, Offset MaintenanceDirectedDestination
                Mov     CX, 10/2
                Rep     MovsW
                Mov     AX, 'IT'
                StosW

                Pop     DI
                Pop     SI
                Pop     CX
                Pop     AX
                Ret

EndP            TransferDestinationAddress

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            NodeSearch      ; DS gets set to DiskDataArea
                                ; Given EAX:EDX = Node address
                                ; Returns carry if found and BX = address
                Assume DS:IPX

                Mov     CX, NumNodes
                Mov     DS, DiskDataArea
                        Assume DS:Nothing

;                ClC
;                Ret

                Xor     BX, BX
                JCXZ    NodeSearch2

NodeSearch1:
                Cmp     [BX+20], EAX
                JNE     NodeSearch3
                Cmp     [BX+24], EDX
                JNE     NodeSearch3

                StC
                Ret

NodeSearch3:
                Add     BX, 32
                Loop    NodeSearch1
;                Dec     CX
;                JNZ     NodeSearch1

NodeSearch2:
                Ret

EndP            NodeSearch

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CheckFromSelf

                Push    SI
                Push    DI

                Add     SI, 12h                 ; Source internetwork address
                Mov     DI, Offset IPXLocalAddress
                Mov     CX, 10
                RepE    CmpSB

                Pop     DI
                Pop     SI

                Ret

EndP            CheckFromSelf

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            ConnectionReject

                Mov     DI, Offset MaintenanceSData
                Mov     AX, 7
                StosW
                Call    IPX_MaintenanceSendData
                Ret

EndP            ConnectionReject

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            FindConnection          ; Returns carry set if not found,
                                        ;  BX = address, AX = connection number
                                        ;                0 = first connect
                Assume DS:IPX

                Push    CX
                Push    SI
                Push    DI

                Xor     AX, AX
                Add     SI, 18          ; Address of sender
                Mov     DI, Offset UserAddress1

FindConnection1:
                Cmp     AL, NumberOfConnections
                JAE     FindConnection2

                Mov     CX, 10
                Push    SI
                RepE    CmpsB
                Pop     SI
                JE      FindConnection3

                Add     DI, CX
                Inc     AX
                Add     DI, 16+12-10
                Jmp     FindConnection1

FindConnection2:
                StC

FindConnection3:
                LEA     BX, [DI-26]

                Pop     DI
                Pop     SI
                Pop     CX
                Ret

EndP            FindConnection

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            RemoveFromGroup         ; Assumes DS = CS = IPX

                Call    FindConnection
                JC      RemoveFromGroupEnd

                PushA
                Push    ES

                Push    DS
                Pop     ES

                Mov     AH, 6
                Mul     AH
                Mov     BX, AX

                Mov     SI, Offset ClosedMessage
                Mov     DI, Offset InfoListMessage
                Mov     CX, 22/2
                Rep     MovsW
                Mov     SI, [SendPacketInformation+BX]
                Sub     SI, 16
                Mov     CX, 16/2
                Rep     MovsW
                Mov     BX, 100
                Mov     SI, Offset InfoListMessage
                Call    IT_SetInfoLine

                Pop     ES
                PopA

Proc            RemoveFromGroup2
                Assume DS:IPX

                Push    AX

                Mov     AH, NumberOfConnections
                Sub     AH, AL

                Mov     DI, BX
                LEA     SI, [BX+28]

                Dec     NumberOfConnections
                Mov     AL, 28/2
                Mul     AH

                Mov     CX, AX
                Rep     MovsW

; Remove from ack list
                Pop     CX

                Mov     AX, 0FFFEh
                ShL     AL, CL          ; AL = mask for 'upper' bits
                ShL     AH, CL
                Not     AH              ; AH = mask for 'lower' bits
                Mov     CL, SendingData
                And     AL, CL
                And     AH, CL
                ShR     AL, 1
                Or      AL, AH
                Mov     SendingData, AL

RemoveFromGroupEnd:
                Ret

EndP            RemoveFromGroup2
EndP            RemoveFromGroup
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SendDataOK              ; Returns carry if data is still
                                        ; pending to send.
                Assume DS:IPX

                Xor     AX, AX
                Mov     AL, NumberOfConnections

                Test    AL, AL
                JZ      SendDataOK_Fail

                Cmp     SResult1, 0
                JNE     SendDataOK_Fail
                Dec     AX
                JZ      SendDataOK_End

                Cmp     SResult2, 0
                JNE     SendDataOK_Fail
                Dec     AX
                JZ      SendDataOK_End

                Cmp     SResult3, 0
                JE      SendDataOK_End

SendDataOK_Fail:
                StC

SendDataOK_End:
                Ret

EndP            SendDataOK
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Macro_AckOffsets  Macro   Index
        DW      Offset SendAckHeader&Index&+6
        DW      Offset SendAckECB&Index&
EndM

AckOffsets      Label
        IndexCounter = 1
        Rept    (MAXIMUMUSERS-1)
                Macro_AckOffsets %IndexCounter
                IndexCounter = IndexCounter + 1
        EndM

PacketReceived  DB      0

Proc            DataESR Far

                PushF
                PushAD
                Push    DS

                ScreenTraceStart

                Push    ES
                Push    SI

                Push    CS
                Pop     DS
                        Assume DS:IPX   ; Also ES = IPX

                ScreenTrace '0'

                ClD

                Mov     PacketReceived, 1
                Inc     PacketsReceived

                Trace   "R: ESR"
                ScreenTrace '1'

                Cmp     Byte Ptr [SI+9], 0       ; Received packet successfully?
                JNE     DESRBadPacket

                Mov     DI, [SI+2Ah]    ; Offset to fragment 2
                Mov     SI, [SI+24h]    ; Offset to fragment 1 (ie. header)
                Mov     CX, [SI+2]
                XChg    CH, CL
                Sub     CX, 30

                ScreenTrace '2'

                Call    FindConnection
                JC      DESRRelisten

                ScreenTrace '3'

; Send acknowledgement
                PushA
                Push    DS
                Push    ES

                Mov     BX, AX
                Mov     SI, DI
                Call    IT_ReceiveData

                ScreenTrace '4'

                Pop     ES
                Pop     DS
                PopA

                PushF
                Mov     BX, AX
                ShL     BX, 2

                Mov     EAX, [SI+12h]
                Mov     ECX, [SI+16h]
                Mov     DX, [SI+1Ah]

                Mov     DI, [AckOffsets+BX]
                StosD
                Mov     [DI], ECX
                Mov     [DI+4], DX
                Mov     SI, [AckOffsets+BX+2]
                Mov     [SI+28], ECX
                Mov     [SI+32], DX

                Mov     Word Ptr [SI+2Ah], Offset Zero

                PopF
                JNC     DESRNoBadPacket

DESRBadPacket:
                ScreenTrace '5'

                Mov     Word Ptr [SI+2Ah], Offset Ten
                Inc     PacketsFailed

DESRNoBadPacket:
                ScreenTrace '6'

                Mov     BX, 3
                Call    [DWord Ptr IPXEntryAddress]

                ScreenTrace '7'
                Trace   "R: Source recognised"

                Jmp     DESRRelisten

DESRRelisten:
                ScreenTrace '8'
                Pop     SI
                Pop     ES

                Trace   "R: Packet relisten to socket"

                Mov     BX, 4           ; Relisten to the socket.
                Call    [DWord Ptr IPXEntryAddress]

                ScreenTrace '9'

                ScreenTraceEnd

                Pop     DS
                PopAD
                PopF
                Ret

EndP            DataESR
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SendDataGivenBX ; Given BX = Offset to SendPacketInfo stuff

                Mov     SI, [BX]
                Mov     DI, [BX+2]
                Mov     CX, 6
                Rep     MovsW

                Sub     SI, 8
                Mov     DI, [BX+4]
                Add     DI, 28          ; Immediate address

                MovsW
                MovsW
                MovsW

                Inc     PacketsSent

                Push    AX
                Push    BX
                Mov     SI, [BX+4]
                Mov     BX, LastPacketSize
                Mov     AX, IPXSocket
                Mov     [SI+0Ah], AX            ; Socket Number
                Mov     [SI+2Eh], BX
                Mov     BX, 3
                Call    [DWord Ptr IPXEntryAddress]

                Pop     BX
                Pop     AX

                Ret

EndP            SendDataGivenBX

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

SendPacketInformation   DW      Offset UserAddress1, Offset DataSendHeader1+6, Offset DataSendECB1
                        DW      Offset UserAddress2, Offset DataSendHeader2+6, Offset DataSendECB2
                        DW      Offset UserAddress3, Offset DataSendHeader3+6, Offset DataSendECB3

Proc            SendITData Near

                PushAD
                PushF
                Push    DS
                Push    ES

                Push    CS
                Push    CS
                Pop     ES
                Pop     DS
                        Assume DS:IPX

                Cmp     SendingData, 0
                JNE     SendITDataCheckTime

                Mov     AX, MAXDATASIZE
                Mov     DI, Offset DataSend
                Call    IT_SendData
                Test    CX, CX
                JZ      SendITDataEnd           ; No Network Data to send

                Call    IT_GetTime              ; Returns EAX
                Mov     SendTime, EAX
                Mov     RetryTime, EAX

                Mov     LastPacketSize, CX

                Mov     AL, NumberOfConnections
                Mov     BX, Offset SendPacketInformation

                Test    AL, AL
                JZ      SendITDataEnd

                Test    DL, DL
                JNZ     SendITDataSingle

; Have to send to all connections

                Mov     CL, AL
                Mov     CH, 1
                ShL     CH, CL
                Dec     CH
                Mov     SendingData, CH

SendITData1:
                Trace   "Sending broadcast packet"

                Call    SendDataGivenBX

                Add     BX, 6
                Dec     AL

                JNZ     SendITData1

                Jmp     SendITDataEnd

SendITDataSingle:
                Trace   "Sending single packet"

                Cmp     DL, AL
                JA      SendITDataEnd           ; Invalid destination

                Mov     CL, AL
                Mov     CH, 1
                Dec     CX
                ShL     CH, CL
                Mov     SendingData, CH

; Have to send to single destination
                Mov     AL, 6
                Mul     DL                      ; AX = Destination*6

                Add     BX, AX
                Sub     BX, 6
                Call    SendDataGivenBX
                Jmp     SendITDataEnd

SendITDataCheckTime:
                Mov     DL, NumberOfConnections
                Test    DL, DL
                JZ      SendITDataEnd

                Call    IT_GetTime
                Mov     EBX, EAX
                Mov     ECX, EAX
                Sub     EBX, RetryTime
                Sub     ECX, SendTime

                Cmp     EBX, RETRYTIMEOUT
                JB      SendITDataEnd

; Check for true timeout.. drop if so.
                Cmp     ECX, SENDTIMEOUT
                JA      SendITDataTimeout

; Else retry sending packet.
                Mov     RetryTime, EAX

                Mov     AL, SendingData
                Mov     BX, Offset SendPacketInformation

SendITDataRetry:
                ShR     AL, 1
                JNC     SendITDataRetry2

                Call    SendDataGivenBX
                Inc     PacketsRetry

SendITDataRetry2:
                Add     BX, 6
                Dec     DL
                JNZ     SendITDataRetry

                Jmp     SendITDataEnd

SendITDataTimeout:
                Xor     AX, AX          ; AX = connection number
                Mov     DH, SendingData

SendITDataTimeout1:
                ShR     DH, 1
                JNC     SendITDataTimeout2

                Mov     AH, 6
                Mul     AH
                Mov     BX, AX

                Mov     SI, Offset AutoDropMessage
                Mov     DI, Offset InfoListMessage
                Mov     CX, 20/2
                Rep     MovsW
                Mov     SI, [SendPacketInformation+BX]
                Sub     SI, 16
                Mov     CX, 16/2
                Rep     MovsW
                Mov     BX, 100
                Mov     SI, Offset InfoListMessage
                Call    IT_SetInfoLine

                Call    RemoveFromGroup2
                Jmp     SendITDataEnd

SendITDataTimeout2:
                Inc     AX
                Dec     DL
                JNZ     SendITDataTimeout1

SendITDataEnd:
                Pop     ES
                Pop     DS
                PopF
                PopAD

                Ret

EndP            SendITData

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SendDataESR Far

                Push    DS
                PushF

                ScreenTraceStart

                Push    CS
                Pop     DS
                        Assume DS:IPX   ; Also ES = IPX
                ClD

                Trace   "S: ESR"
                ScreenTrace 'A'

                Cmp     Byte Ptr [SI+9], 0       ; Received packet successfully?
                JNE     SDESRResend

                ScreenTrace 'B'
                Call    SendITData

                ScreenTrace 'C'

                ScreenTraceEnd

                PopF
                Pop     DS
                Ret

SDESRResend:
                Inc     PacketsFailed

                ScreenTrace 'D'

                Mov     BX, 3
                Call    [DWord Ptr IPXEntryAddress]

                ScreenTrace 'E'

                ScreenTraceEnd

                PopF
                Pop     DS
                Ret

EndP            SendDataESR
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

MAXIMUMBLOCKTYPE        = 10

MESRBlockOffsets        Label   Word
        DW      Offset MESRBlockType0, Offset MESRBlockType1
        DW      Offset MESRBlockType2, Offset MESRBlockType3
        DW      Offset MESRBlockType4, Offset MESRBlockType5
        DW      Offset MESRBlockType6, Offset MESRBlockType7
        DW      Offset MESRBlockType8, Offset MESRBlockType9
        DW      Offset MESRBLockType10

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MaintenanceESR Far      ; Given ES:SI = ECB

        PushF
        PushAD

        ScreenTraceStart

        Push    DS
        Push    SI

        ClD

        Push    CS
        Pop     DS
                Assume DS:IPX   ; Also ES = IPX

        ScreenTrace 'a'

        Cmp     Byte Ptr [SI+9], 0       ; Received packet successfully?
        JNE     MESRRelisten

        ScreenTrace 'b'

        Mov     DI, [SI+2Ah]    ; Offset to fragment 2
        Mov     SI, [SI+24h]    ; Offset to fragment 1 (ie. header)

        Mov     DX, [DI]        ; DL = block type
        Mov     BX, DX
        And     BX, 0FFh
        Cmp     BL, MAXIMUMBLOCKTYPE
        JA      MESRBlockTypeUnknown
        Add     BX, BX
        Jmp     [MESRBlockOffsets+BX]

MESRBlockType0: ; Acknowledgement
        ScreenTrace 'c'

        Call    FindConnection
        JC      MESRBlockType0End

        Inc     PacketsAck
        Mov     CX, AX
        Mov     AL, 0FEh

        RoL     AL, CL
        And     SendingData, AL

        ScreenTrace 'd'

        Call    SendITData

MESRBlockType0End:
        ScreenTrace 'e'

        Jmp     MESRBlockTypeFinished

;******************************************************************************

MESRBlockType1: ; Intro
        ScreenTrace 'f'
;        Cmp     NumberOfConnections, 3  ; Don't respond if 3 connections already!
;        JE      MESRBlockType1End

    ; Ignore packets from self........

        Call    CheckFromSelf
        JE      MESRBlockType1End

        ScreenTrace 'g'

    ; .................................

; Now check whether destination was broadcast...

        Cmp     Byte Ptr [DI+1], 0
        JNE     MESRBlockType1NoReply

        Cmp     Word Ptr [SI+0Ah], 0FFFFh
        JNE     MESRBlockType1NoReply
        Cmp     DWord Ptr [SI+0Ch], 0FFFFFFFFh
        JNE     MESRBlockType1NoReply

        Cmp     NoReply, 0
        JNE     MESRBlockType1End
; Yes it was broadcast.. now reply..

        ScreenTrace 'h'

        Mov     AL, 1
        Call    SendConnectionData

        ScreenTrace 'i'

MESRBlockType1NoReply:
        ScreenTrace 'j'

; Don't log if we don't want to log (ie. only log if current mode = 24)

;        Cmp     NumberOfConnections, 0
;        JNE     MESRBlockType1End
        Call    IT_GetCurrentMode
        Cmp     AL, 24
        JNE     MESRBlockType1End

        ScreenTrace 'k'

; Don't log if already logged..

        Mov     EAX, [SI+20]    ; Sender's ID
        Mov     EDX, [SI+24]

        Call    NodeSearch
        JC      MESRBlockType1End

        ScreenTrace 'l'

; Don't have the node -> log it!

        LEA     SI, [DI+2]
        Push    CS
        Push    DS
        Pop     ES
        Pop     DS

        Mov     DI, NumNodes
        Xor     DX, DX

        Cmp     DI, 2000
        JA      MESRBlockType1End

        LodsB

        ShL     DI, 5
        Mov     DL, AL

        Inc     DX

        Xor     AX, AX
        Add     NumNodes, DX

MESRBlockType1Transfer:
        StosW
        Mov     CX, 26/2
        Rep     MovsW
        Inc     AX
        Add     DI, 4
        Dec     DX
        JNZ     MESRBlockType1Transfer

MESRBlockType1End:
        ScreenTrace 'm'

        Jmp     MESRBlockTypeFinished

;******************************************************************************

MESRBlockType3: ; Quit          ; Have to say farewell to direct connections
                                ; also. Should cascade to MESRBlockType2
        ScreenTrace 'n'
        Call    RemoveFromGroup

;******************************************************************************

MESRBlockType2: ; Remove        ; Only significant on connect driver screen
        ScreenTrace 'o'

        Cmp     NumberOfConnections, 0
        JNE     MESRBlockType2End
        Call    IT_GetCurrentMode
        Cmp     AL, 24
        JNE     MESRBlockType2End

        ScreenTrace 'p'

        Mov     EAX, [SI+20]    ; Sender's ID
        Mov     EDX, [SI+24]

        Call    NodeSearch
        JNC     MESRBlockType2End       ; DS = DiskData

        ScreenTrace 'q'

        Push    DS
        Pop     ES

        Mov     CX, CS:NumNodes
        Mov     DI, BX
        ShL     CX, 5
        LEA     SI, [BX+32]
        Xor     AX, AX

        Sub     CX, DI
        Rep     MovsB

        Mov     CX, 32/2
        Rep     StosW

        Mov     SI, BX

MESRBlockType2a:
        Cmp     [SI], AX
        JE      MESRBlockType2b

        Dec     Word Ptr [SI]
        Add     SI, 32
        Jmp     MESRBlockType2a

MESRBlockType2b:
        ScreenTrace 'r'

        ShR     BX, 5

        Push    CS
        Pop     DS

        Dec     NumNodes
        Cmp     BX, CurrentNode
        JAE     MESRBlockType2End

        Dec     CurrentNode

MESRBlockType2End:
        ScreenTrace 's'

        Jmp     MESRBlockTypeFinished

;******************************************************************************

MESRBlockType4: ; Message
        ScreenTrace 't'

        Call    CheckFromSelf
        JE      MESRBlockType4End

; If NumberOfConnections = 0 && CurrentMode = 24, then check that name is logged
        Cmp     NumberOfConnections, 0
        JNE     MESRBlockType4_6

        Call    IT_GetCurrentMode
        Cmp     AL, 24
        JNE     MESRBlockType4_3

        Push    DS
        Push    ES

        Mov     EAX, [SI+20]    ; Sender's ID
        Mov     EDX, [SI+24]

        Call    NodeSearch
        JC      MESRBlockType4_4

; Couldn't find node.
        Push    DI
        Push    SI

        Push    CS
        Push    DS
        Pop     ES
        Pop     DS

        LEA     SI, [DI+1]
        Mov     DI, NumNodes
        Cmp     DI, 2000
        JA      MESRBlockType4_5

        ShL     DI, 5
        Xor     AX, AX

        StosW
        Mov     CX, 16/2
        Rep     MovsW

        Pop     SI
        Push    SI

        Add     SI, 18
        Mov     CX, 10/2
        Rep     MovsW

        Inc     NumNodes

MESRBlockType4_5:
        Pop     SI
        Pop     DI

MESRBlockType4_4:
        Pop     ES
        Pop     DS

        Jmp     MESRBlockType4_3

MESRBlockType4_6:
        ; Have connections.. only accept messages from group
        Call    FindConnection
        JC      MESRBlockType4End

MESRBlockType4_3:
        Mov     MessageReceived, 1

        Push    DI

        Mov     SI, Offset MessageData+72
        Mov     DI, Offset MessageData
        Mov     CX, (72*7)/2
        Rep     MovsW

        Pop     SI
        LodsB
        Mov     CX, 72/2
        Rep     MovsW

        Call    IT_GetCurrentMode
        Cmp     AL, 24
        JE      MESRBlockType4End

        Sub     SI, 72
        Mov     DI, Offset InfoListMessage

        Mov     CX, 61

        Push    SI

MESRBlockType4_1:
        LodsB
        StosB
        Test    AL, AL
        LoopNZ  MESRBlockType4_1

        Pop     SI
        Mov     Word Ptr [DI-1], ':'+ ' '*100h
        Inc     DI
        Add     SI, 16
        Mov     AX, 0FEh+2300h
        StosW

MESRBlockType4_2:
        LodsB
        StosB
        Test    AL, AL
        LoopNZ  MESRBlockType4_2
        Xor     AL, AL
        StosB

        Mov     BX, 150
        Mov     SI, Offset InfoListMessage
        Call    IT_SetInfoLine

MESRBlockType4End:
        Jmp     MESRBlockTypeFinished

;******************************************************************************

MESRBlockType5:
        Call    RemoveFromGroup
        Jmp     MESRBlockTypeFinished

;******************************************************************************

MESRBlockType6:                 ; Request connection
                                ; auto reject if:
                                ;  This node is requesting a connection
                                ;  Someone else is requesting a connection
                                ;  NumConnections already = 3
        Cmp     NumberOfConnections, 3
        JE      MESRBlockType6AutoReject
        Test    ConnectionRequest, 0Fh
        JNE     MESRBlockType6AutoReject

        Or      ConnectionRequest, 2    ; Mark that someone is requesting a con

; Else prompt user
; Save connection request address

        Push    DI

        Add     SI, 18                  ; Save address of connection requester
        Mov     DI, Offset ConnectionRequestAddress
        Mov     CX, 12/2
        Rep     MovsW

        Pop     DI

        Inc     DI
        Mov     SI, DI
        Xor     AL, AL
        Mov     CX, 16
        Push    CX
        RepNE   ScasB           ; DI = one after 0 found
        Pop     CX
        Sub     DI, SI
        Mov     DX, DI
        Sub     CX, DI
        ShR     CX, 1

        Mov     DI, Offset ConnectionRequestName

        Mov     AL, ' '
        Rep     StosB

        Mov     CX, DX
        Rep     MovsB

        Mov     IPXQueueScreen, 1

        Jmp     MESRBlockTypeFinished

MESRBlockType6AutoReject:
        Call    MaintenanceWaitforSend
        Call    TransferDestinationAddress

        Push    DI
        Mov     SI, Offset AutoRejectMessage
        Mov     DI, Offset InfoListMessage
        Mov     CX, 26/2
        Rep     MovsW
        Pop     SI
        Inc     SI
        Mov     CX, 16/2
        Rep     MovsW
        Mov     BX, 100
        Mov     SI, Offset InfoListMessage
        Call    IT_SetInfoLine
        Call    ConnectionReject

MESRBlockType6End:
        Jmp     MESRBlockTypeFinished

;******************************************************************************

MESRBlockType7:                 ; Accept/Reject connection
; First verify that sender is the same as ConnectionRequestAddress and that
; connectionRequest Bit 0 is set. if not, then send negative confirmation

        Test    [ConnectionRequest], 1
        JZ      MESRBlockType7Reject

        Push    SI
        Push    DI

        Mov     CX, 10/2
        Add     SI, 18          ; Sender's address
        Mov     DI, Offset ConnectionRequestAddress
        RepE    CmpsW

        Pop     DI
        Pop     SI

        JNE     MESRBlockType7Reject

; OK.. 
; Connection rejected if DH = 0

        Or      ConnectionRequest, 80h  ; Leave wait for connection request
                                        ; screen
        ShR     DX, 8
        JZ      MESRBlockTypeFinished

        Call    MaintenanceWaitforSend
        Call    TransferDestinationAddress

; Connection accepted if DH != 0
;   Then copy DH*28 lots of bytes starting at UserName1
;   And set NumberOfConnections to DH
;   Then call IT_EstablishConnection

        Mov     NumberOfConnections, DL
        LEA     SI, [DI+2]
        Mov     DI, Offset UserName1

MESRBlockType7Accepted:
        Mov     CX, 28/2
        Rep     MovsW
        Dec     DX
        JNZ     MESRBlockType7Accepted

; Send positive ack

        Mov     SI, Offset UserName
        Mov     DI, Offset MaintenanceSData
        Mov     AX, 108h
        Mov     CX, 28/2
        StosW
        Rep     MovsW
        Call    IPX_MaintenanceSendData

        Call    IT_NewConnection

        Jmp     MESRBlockTypeFinished

MESRBlockType7Reject:
        Test    DH, DH                  ; If connection rejected, dont' send
                                        ; Further response.
        JZ      MESRBlockType7End

        Mov     DI, Offset MaintenanceSData
        Mov     AX, 8
        StosW
        Call    IPX_MaintenanceSendData

MESRBlockType7End:
        Jmp     MESRBlockTypeFinished

;******************************************************************************

MESRBlockType8:                 ; Confirm connection

        ; Check whether connection was requested and whether this cancellation
        ; is from that sender.

; If Confirm connection is from ConnectionRequestAddress and ConnectRequest & 2
;  *OR* Confirm connection is from someone in the current group
; Then add user to user list, increment NumberOfConnections

        Cmp     NumberOfConnections, 3
        JE      MESRBlockType8End

        Call    FindConnection          ; Was it from the group?
        JNC     MESRBlockType8AddUser   ; Yes -> Add user

        Push    SI
        Push    DI

        Add     SI, 12h
        Mov     DI, Offset ConnectionRequestAddress
        Mov     CX, 12/2
        RepE    CmpsW

        Pop     DI
        Pop     SI
        JNE     MESRBlockType8End

        Test    DH, DH          ; Cancelled?
        JZ      MESRBlockType8ScreenRefresh

; If received from group, then don't send
; If not received from group, then send to rest of group.
                                ; Establish connection
                                ; If NumConnections != 0
                                ;  then send connection establishment to all
                                ;  other connected users.
; Send to the rest of the group!
        Mov     AL, NumberOfConnections

        Push    AX
        Inc     AL
        Call    IT_EstablishConnection
        Pop     AX

        Test    AL, AL
        JZ      MESRBlockType8AddUser

        Call    MaintenanceWaitforSend

        Push    DI

        Mov     SI, DI
        Mov     DI, Offset MaintenanceSData
        Mov     CX, 30/2
        Rep     MovsW

        Mov     SI, Offset UserAddress1
        Mov     [MaintenanceSendHeader], Offset MaintenanceSendHeaderDirected
        Mov     [MaintenanceSendDataOffset], Offset MaintenanceSData
        Mov     [MaintenanceSendDataSize], 30

MESRBlockType8Group1:

        Push    AX
        Push    SI

        Mov     DI, Offset MaintenanceDirectedDestination
        Mov     CX, 10/2
        Rep     MovsW
        Mov     AX, 'IT'
        StosW

        Call    SendMaintenancePacket

        Pop     SI
        Pop     AX

        Dec     AL
        JZ      MESRBlockType8GroupEnd

        Add     SI, 28
        Call    MaintenanceWaitforSend
        Jmp     MESRBlockType8Group1

MESRBlockType8GroupEnd:
        Pop     DI

MESRBlockType8AddUser:
        LEA     SI, [DI+2]
        Mov     AL, 28
        Mul     NumberOfConnections

        Mov     DI, AX
        Add     DI, Offset UserName1
        Mov     CX, 28/2
        Rep     MovsW

        Inc     NumberOfConnections

MESRBlockType8ScreenRefresh:
        Or      ConnectionRequest, 80h

MESRBlockType8End:
        Jmp     MESRBlockTypeFinished

;******************************************************************************

MESRBlockType9:         ; Request intro
;        Mov     [MaintenanceSendHeader], Offset MaintenanceSendHeaderDirected
        Mov     AL, 1
        Call    SendConnectionData

        Jmp     MESRBlockTypeFinished

;******************************************************************************

MESRBlockType10:        ; Resend data
        Call    FindConnection
        JC      MESRBlockType10End

        Inc     PacketsRetry

        Mov     AH, 6
        Mul     AH
        Mov     BX, AX
        Add     BX, Offset SendPacketInformation
        Call    SendDataGivenBX

MESRBlockType10End:
        Jmp     MESRBlockTypeFinished

MESRBlockTypeUnknown:
        Mov     BX, 72
        Mov     SI, Offset UnknownPacketMessage
        Call    IT_SetInfoLine

MESRBlockTypeFinished:
; Should process the info, respond if necessary and set the packet back
; for listening.

MESRRelisten:
        Push    CS
        Push    CS
        Pop     ES
        Pop     DS

        Pop     SI

        ScreenTrace 'z'

        Mov     BX, 4           ; Relisten to the socket.
        Call    [DWord Ptr IPXEntryAddress]

        ScreenTrace 'Z'

        Pop     DS
        ScreenTraceEnd

        PopAD
        PopF
        Ret

EndP            MaintenanceESR
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            MaintenanceWaitForSend

                PushF
                PushAD
                Push    DS

                ScreenTraceStart

                Push    CS
                Pop     DS
                        Assume DS:IPX

                Call    IT_GetTime              ; Returns EAX
                Mov     EDX, EAX

SendMaintenancePacket1:
                Cmp     [SendECBInUse], 0
                JE      SendMaintenancePacket2

                StI

                Mov     BX, 0Ah                         ; IPX processing.
                Call    [DWord Ptr IPXEntryAddress]

                Mov     EBX, EDX
                Call    IT_GetTime
                Sub     EBX, EAX
                Cmp     EBX, MAINTENANCETIMEOUT
                JB      SendMaintenancePacket1

; Error message!

SendMaintenancePacket2:
                ScreenTraceEnd

                Pop     DS
                PopAD
                PopF
                Ret

EndP            MaintenanceWaitForSend
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            SendMaintenancePacket

                PushAD
                Push    DS
                Push    ES

                Push    CS
                Push    CS
                Pop     ES
                Pop     DS
                        Assume DS:IPX

                Call    MaintenanceWaitForSend

                Mov     SI, [MaintenanceSendHeader]
                Mov     DI, Offset MSendDest
                Add     SI, 10
                MovsW
                MovsW
                MovSW

                Mov     BX, 3
                Mov     SI, Offset MaintenanceSendECB
                Call    [DWord Ptr IPXEntryAddress]

                Pop     ES
                Pop     DS
                PopAD
                Ret

EndP            SendMaintenancePacket
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DetectIPXNetwork Far       ; IPX detection.

                Push    CS
                Pop     DS
                        Assume DS:IPX

IF FIXEDUSERNAME
                Mov     CX, 18
                Mov     SI, Offset UserName
ELSE
                Xor     CX, CX
ENDIF
                Call    IT_DecodeUserName

                Mov     AX, 7A00h
                Int     2Fh

                Sub     AL, 0FFh
                JC      DetectIPXNetwork1

                Mov     [Word Ptr IPXEntryAddress], DI
                Mov     [Word Ptr IPXEntryAddress+2], ES

                Mov     BX, 1Ah
                Call    [DWord Ptr IPXEntryAddress]

                Mov     [IPXMaximumPacketSize], AX
                Mov     [IPXRetryCount], CX

                Push    CS
                Pop     ES

                Mov     BX, 9
                Mov     SI, Offset IPXLocalAddress
                Call    [DWord Ptr IPXEntryAddress]

                ClC

DetectIPXNetwork1:
                Ret

EndP            DetectIPXNetwork
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Macro_SetupListenDataPackets Macro Index
                Mov     DSocket&Index&, DX
EndM

Macro_ListenDataPackets Macro Index
                Mov     SI, Offset DataReceiveECB&Index&
                Call    [DWord Ptr IPXEntryAddress]
EndM

Proc            IPX_Initialise Far

                Push    CS
                Pop     DS
                        Assume DS:IPX

                Trace   "IPX: Initialise"

                Mov     SI, Offset RelocationTable

IPX_RelocationFixup:
                LodsW
                Test    AX, AX
                JZ      IPX_RelocationEnd
                Mov     BX, AX
                Mov     [BX], DS

                Jmp     IPX_RelocationFixup

IPX_RelocationEnd:
                Mov     EAX, IT_DrawHeader
                Mov     EBX, IT_FillHeader
                Mov     ECX, IdleUpdateInfoLine
                Mov     EDX, GlobalKeyList

                Mov     DrawHeader2, EAX
                Mov     FillHeader2, EBX
                Mov     IdleFunctionList, ECX
                Mov     IdleFunctionList2, ECX
                Mov     GlobalKeyLink2, EDX

                Call    DetectIPXNetwork
                JNC     IPX_Initialise1

                Push    DS
                Push    Offset NoIPXMessageList
                Jmp     IPX_InitialiseReturn

IPX_Initialise1:
                Xor     AL, AL
                Xor     BX, BX  ; Open socket
                Mov     DX, 'IT'
                Call    [DWord Ptr IPXEntryAddress]
                Test    AL, AL
                JNZ     IPX_InitialiseError1

                Xor     AL, AL
                Xor     BX, BX
                Xor     DX, DX
                Call    [DWord Ptr IPXEntryAddress]
                Test    AL, AL
                JNZ     IPX_InitialiseError2

                Mov     IPXSocket, DX

                IndexCounter = 1
                Rept    NUMBEROFLISTENINGPACKETS
                        Macro_SetupListenDataPackets %IndexCounter
                        IndexCounter = IndexCounter + 1
                EndM

IPX_Initialise2:

IFE FIXEDUSERNAME
; OK.. ask for user name.
                Push    DS
                Push    Offset IPXGetName
                Call    IT_FunctionHandler

                Push    CS
                Pop     DS

                Test    DX, DX
                JNZ     IPX_Initialise3
                Jmp     IPX_Shutdown1

IPX_Initialise3:
ENDIF

; Setup to listen for packets!

                Push    CS
                Pop     ES
                Mov     BX, 4

                Mov     SI, Offset MaintenanceECB1
                Call    [DWord Ptr IPXEntryAddress]

                Mov     SI, Offset MaintenanceECB2
                Call    [DWord Ptr IPXEntryAddress]

                Mov     SI, Offset MaintenanceECB3
                Call    [DWord Ptr IPXEntryAddress]

                Mov     SI, Offset MaintenanceECB4
                Call    [DWord Ptr IPXEntryAddress]

                IndexCounter = 1
                Rept    NUMBEROFLISTENINGPACKETS
                        Macro_ListenDataPackets %IndexCounter
                        IndexCounter = IndexCounter + 1
                EndM

                Jmp     IPX_DriverScreen

IPX_InitialiseError2:                   ; Close socket.
                Mov     BX, 1
                Mov     DX, 'IT'
                Call    [DWord Ptr IPXEntryAddress]

IPX_InitialiseError1:
                Push    DS
                Push    Offset SocketErrorList

IPX_InitialiseReturn:
                Call    IT_FunctionHandler
                Jmp     IT_UnloadDriver

EndP            IPX_Initialise
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            BroadcastMaintenanceByte        ; Given AL

                Call    MaintenanceWaitforSend
                Mov     [ByteBlock], AL
                Mov     [MaintenanceSendHeader], Offset MaintenanceSendHeaderBroadcast
                Mov     [MaintenanceSendDataOffset], Offset ByteBlockInformation
                Mov     [MaintenanceSendDataSize], 1
                Call    SendMaintenancePacket

                Ret

EndP            BroadcastMaintenanceByte

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_DriverScreen Far

                Push    CS
                Pop     DS
                        Assume DS:IPX

                Mov     ES, DiskDataArea
                Xor     DI, DI
                Mov     CX, 32768
                Xor     AX, AX
                Rep     StosW

                Cmp     NumberOfConnections, 0
                JE      IPX_DriverScreen1

; Alternative screens here for post-connection.

                Mov     AX, 5
                Mov     SI, 1
                Mov     DI, AX
                Mov     DX, Offset IPXConnectedScreen
                Mov     CX, CS

                Ret

IPX_DriverScreen1:
                Mov     OldNumNodes, 0
                Mov     NumNodes, 0
                Mov     CurrentNode, 0

;                Call    MaintenanceWaitforSend
;                Mov     [MaintenanceSendHeader], Offset MaintenanceSendHeaderBroadcast
                Xor     AX, AX
                Call    SendConnectionData

                Mov     AX, 5
                Mov     SI, 1
                Mov     DI, AX
                Mov     DX, Offset IPXScreen
                Mov     CX, CS

                Ret

EndP            IPX_DriverScreen
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_Shutdown Far        ; Shutdown has to:
                                        ;  free all allocated
                                        ;  Transmit logoff message
                                        ;  release any allocated sockets
                                        ;  Unload driver
IFE FIXEDUSERNAME
                Call    IT_GotoHomeDirectory
ENDIF
                Push    CS
                Pop     DS
                        Assume DS:IPX

IFE FIXEDUSERNAME
                                        ; Now to save config into driver file.
                Mov     AX, 3D02h       ; Read write access
                Mov     DX, Offset DriverName
                Int     21h
                JC      SaveConfiguration2

                Mov     BX, AX

                Mov     AX, 4200h
                Xor     CX, CX
                Mov     DX, Offset CONFIGURATIONOFFSET
                Int     21h
                JC      SaveConfiguration1

                Mov     AH, 40h
                Mov     CX, CONFIGURATIONSIZE
                Mov     DX, Offset UserName
                Int     21h

SaveConfiguration1:
                Mov     AH, 3Eh
                Int     21h

SaveConfiguration2:
ENDIF
                Mov     AL, 3           ; Block type 3 = quit
                Call    BroadcastMaintenanceByte

IPX_Shutdown1:
; Free both sockets
                Mov     BX, 1

                Mov     DX, 'IT'        ; Release maintenance socket.
                Call    [DWord Ptr IPXEntryAddress]

                Mov     DX, IPXSocket
                Call    [DWord Ptr IPXEntryAddress]

                Jmp     IT_UnloadDriver

EndP            IPX_Shutdown
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_LeaveSession Far

                Mov     AL, 5                   ; Log off from group.
                Call    BroadcastMaintenanceByte

                Mov     CS:NumberOfConnections, 0

                Jmp     IPX_DriverScreen

EndP            IPX_LeaveSession

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_Update Far

                Push    CS
                Pop     DS
                        Assume DS:IPX

                Xor     AX, AX
                XChg    IPXQueueScreen, AX

                Test    AX, 1
                JZ      IPX_Update2

                Push    AX

        ; For Connection requests..
                And     ConnectionRequest, 0Fh

                Call    IT_S_SaveScreen
                Push    CS
                Push    Offset ConnectionRequestList
                Call    IT_FunctionHandler

                Push    CS
                Push    CS
                Pop     DS
                Pop     ES

                Call    IT_S_RestoreScreen

                        ; Transfer destination address
                Mov     SI, Offset ConnectionRequestAddress
                Mov     DI, Offset MaintenanceDirectedDestination
                Mov     CX, 12/2
                Rep     MovsW

                Cmp     DX, 1
                JB      IPX_UpdateConnectionReject
                JA      IPX_UpdateConnectionCancelled

IPX_UpdateConnectionAccept:
; Have to send complete info about all connnections back
; including socket numbers
                Mov     AH, NumberOfConnections
                Mov     DI, Offset MaintenanceSData
                Mov     AL, 7
                Mov     SI, Offset UserName
                Inc     AH
                Mov     CX, ((16+12)*3)/2
                StosW
                Rep     MovsW
                Call    IPX_MaintenanceSendData

                Jmp     IPX_UpdateConnectionEnd

IPX_UpdateConnectionReject:
                Call    ConnectionReject
                Jmp     IPX_UpdateConnectionEnd

IPX_UpdateConnectionCancelled:
                Push    CS
                Push    Offset ConnectionCancelledList
                Call    IT_FunctionHandler
                Call    IT_S_RestoreScreen

IPX_UpdateConnectionEnd:
                And     ConnectionRequest, Not 2
                Pop     AX

IPX_Update3:
                Mov     BX, 0Ah                         ; Relinquish control
                Call    [DWord Ptr IPXEntryAddress]

                Mov     AX, 1
                Ret                                     ; Redraw required.

IPX_Update2:
                Call    SendITData

                Call    IT_GetCurrentMode
                Cmp     AL, 24
                JE      IPX_Update3

IPX_UpdateEnd:
                Mov     BX, 0Ah                         ; Relinquish control
                Call    [DWord Ptr IPXEntryAddress]

                Xor     AX, AX
                XChg    AL, PacketReceived
                Ret

EndP            IPX_Update
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_DrawHexNumber       ; Given AL = Number

                LodsB
                Mov     DH, AL
                ShR     AL, 4
                Cmp     AL, 10
                SBB     AL, 69h
                DAS
                StosW
                Mov     AL, DH
                And     AL, 0Fh
                Cmp     AL, 10
                SBB     AL, 69h
                DAS
                StosW

                Ret

EndP            IPX_DrawHexNumber

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_DrawAddress

                Mov     CX, 3

IPX_DrawAddress1:
                Call    IPX_DrawHexNumber
                Mov     AL, ':'
                StosW
                Loop    IPX_DrawAddress1
                Call    IPX_DrawHexNumber
                Mov     AL, ' '
                StosW

                Mov     CX, 5

IPX_DrawAddress2:
                Call    IPX_DrawHexNumber
                Mov     AL, ':'
                StosW
                Loop    IPX_DrawAddress2
                Call    IPX_DrawHexNumber

                Ret

EndP            IPX_DrawAddress

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_DrawConnect Far

                Push    CS
                Pop     DS
                        Assume DS:IPX

                Call    IT_S_GetDestination     ; Gets ES

                Mov     AX, 168+200h
                Mov     DI, (13*80+22)*2
                Mov     CX, 23

IPX_DrawConnect2:
                StosW
                Add     DI, 158
                Loop    IPX_DrawConnect2

                Cmp     [NumNodes], 0
                JNE     IPX_DrawConnect1

                Ret

IPX_DrawConnect1:
                Mov     SI, [TopNode]
                Mov     DX, [NumNodes]
                Mov     BX, [CurrentNode]

                Cmp     BX, DX
                JB      IPX_DrawConnectClip3

                Mov     BX, DX
                Dec     BX
                Mov     [CurrentNode], BX

IPX_DrawConnectClip3:

; Need to make sure they're within bounds.
                Cmp     BX, SI
                JAE     IPX_DrawConnectClip1

                Mov     SI, BX

IPX_DrawConnectClip1:
                LEA     DI, [SI+22]
                Cmp     BX, DI
                JBE     IPX_DrawConnectClip2

                LEA     SI, [BX-22]

IPX_DrawConnectClip2:
                Mov     DI, (13*80+3)*2
                Mov     [TopNode], SI

                Sub     DX, SI
                JZ      IPX_DrawConnectEnd

                ShL     SI, 5

                Mov     DS, [DiskDataArea]
                        Assume DS:Nothing

                Cmp     DX, 23
                JB      IPX_DrawConnectClip

                Mov     DX, 23

IPX_DrawConnectClip:
                Push    DI

                LodsW

                Mov     AH, 3
                Mov     CX, 16

                Test    AL, AL
                JZ      IPX_DrawConnectUserName

                Add     DI, 4

IPX_DrawConnectUserName:
                LodsB
                StosW
                Loop    IPX_DrawConnectUserName

                Pop     DI

                Add     DI, 40

                Call    IPX_DrawAddress

                Add     SI, 4
                Add     DI, 62

                Dec     DL
                JNZ     IPX_DrawConnectClip

                Mov     CL, 0E0h
                Jmp     IPX_PreConnectChain

IPX_DrawConnectEnd:
                Ret

EndP            IPX_DrawConnect

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_PreConnect Far

                Mov     CL, 30h

IPX_PreConnectChain:
                Push    CS
                Pop     DS
                        Assume DS:IPX

                Cmp     [NumNodes], 0
                JE      IPX_PreConnectEnd

                Mov     AX, [CurrentNode]
                Sub     AX, [TopNode]
                Add     AX, 13
                Mov     BX, 160
                Mul     BX

                Call    IT_S_GetDestination

                Mov     DL, CL
                Mov     DH, CL
                Or      DH, 2

                LEA     DI, [EAX+6]
                Mov     CX, 49

IPX_PreConnectScreen1:
                Mov     AX, [ES:DI]
                Mov     AH, DL
                Cmp     CX, 49-19
                JNE     IPX_PreConnectScreen2

                Mov     AH, DH

IPX_PreConnectScreen2:
                StosW
                Loop    IPX_PreConnectScreen1

IPX_PreConnectEnd:
                Ret

EndP            IPX_PreConnect
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_PostConnect Far

                Push    CS
                Pop     DS
                        Assume DS:IPX

                Mov     SI, Offset ConnectKeys
                Call    IT_FunctionDivider
                JC      IPX_PostConnect1

                Jmp     [Word Ptr SI]

IPX_PostConnect1:
                Xor     AX, AX
                Ret
                Xor     AX, AX
                Ret

EndP            IPX_PostConnect

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_ConnectUp Far
                Assume DS:IPX

                Mov     AX, 1

                Sub     CurrentNode, AX
                AdC     CurrentNode, 0

                Ret

EndP            IPX_ConnectUp
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_ConnectDown Far
                Assume DS:IPX

                Mov     AX, 1
                Add     CurrentNode, AX
                Ret

EndP            IPX_ConnectDown
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_ConnectPgUp Far
                Assume DS:IPX

                Mov     AX, CurrentNode
                Sub     AX, 24
                JNC     IPX_ConnectPgUp1

                Xor     AX, AX

IPX_ConnectPgUp1:
                Mov     CurrentNode, AX

                Mov     AX, 1
                Ret

EndP            IPX_ConnectPgUp
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_ConnectPgDn Far
                Assume DS:IPX

                Add     CurrentNode, 24

                Mov     AX, 1
                Ret

EndP            IPX_ConnectPgDn
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_ConnectHome Far

                Mov     CurrentNode, 0
                Mov     AX, 1
                Ret

EndP            IPX_ConnectHome

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_ConnectEnd Far

                Mov     CurrentNode, 1000

                Mov     AX, 1
                Ret

EndP            IPX_ConnectEnd

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_ConnectTab Far
                Assume DS:IPX

                Mov     AX, 6
                StosW

                Mov     AX, 1
                Ret

EndP            IPX_ConnectTab
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_GetDestinationAddress

                Push    CS
                Push    CS
                Pop     DS
                Pop     ES
                        Assume DS:IPX

                Cmp     NumNodes, 1
                JB      IPX_GetDestinationAddress1

                Mov     SI, CurrentNode
                Mov     DI, Offset MaintenanceDirectedDestination
                ShL     SI, 5
                Mov     CX, 10/2
                Add     SI, 18  ; SI = offset to node address

                Push    DS
                Mov     DS, DiskDataArea

                Rep     MovsW
                Mov     AX, 'IT'
                StosW           ; Destination socket is maintenance socket.

                Pop     DS
                ClC

IPX_GetDestinationAddress1:
                Ret

EndP            IPX_GetDestinationAddress
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc    IPX_MaintenanceSendData

        Mov     [MaintenanceSendHeader], Offset MaintenanceSendHeaderDirected

Proc    IPX_MaintenanceSendDataNoHeader
        Sub     DI, Offset MaintenanceSData
        Mov     [MaintenanceSendDataOffset], Offset MaintenanceSData
        Mov     [MaintenanceSendDataSize], DI

        Call    SendMaintenancePacket

        Ret

EndP    IPX_MaintenanceSendDataNoHeader
EndP    IPX_MaintenanceSendData

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc    SendConnectionData
        Assume DS:IPX

        PushA
        Push    DS
        Pop     ES

        Call    MaintenanceWaitforSend
        Mov     [MaintenanceSendHeader], Offset MaintenanceSendHeaderBroadcast

        Test    AX, AX
        JZ      SendConnectionData2

        Call    TransferDestinationAddress
        Mov     [MaintenanceSendHeader], Offset MaintenanceSendHeaderDirected

SendConnectionData2:
        Mov     DI, Offset MaintenanceSData
        Mov     SI, Offset IntroBlockInformation
        MovsB
        StosB
        MovSB
        Mov     DL, NumberOfConnections

SendConnectionData1:
        Mov     CX, (16+10)/2
        Rep     MovsW
        LodsW
        Dec     DL
        JNS     SendConnectionData1


        Call    IPX_MaintenanceSendDataNoHeader
        PopA
        Ret

EndP    SendConnectionData
        Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_ConnectEnter Far    ; Have to request a connection

                Call    IPX_GetDestinationAddress
                JC      IPX_ConnectEnter1
                        Assume DS:IPX

                Or      ConnectionRequest, 1

                Push    DS
                Mov     DS, DiskDataArea
                        Assume DS:Nothing

                Sub     SI, 26
                Mov     DI, Offset ConnectionRequestName
                Mov     CX, 26/2
                Rep     MovsW
                Pop     DS
                        Assume DS:IPX

                Mov     SI, Offset UserName
                Mov     DI, Offset MaintenanceSData
                Mov     AL, 6
                StosB
                Mov     CX, 16/2
                Rep     MovsW

                Call    IPX_MaintenanceSendData

                Push    DS
                Push    Offset WaitforConnectList
                Call    IT_FunctionHandler

                Push    CS
                Push    CS
                Pop     DS
                Pop     ES

                And     ConnectionRequest, Not 1

; If DX = 0, then connection was cancelled
; If DX = 1, then either connected or cancelled.

                Test    DX, DX
                JNZ     IPX_ConnectEnter2

; Connection cancelled.
                Mov     SI, Offset ConnectionRequestAddress
                Mov     DI, Offset MaintenanceDirectedDestination
                Mov     CX, 10/2
                Rep     MovsW
                Mov     AX, 'IT'
                StosW

                Mov     DI, Offset MaintenanceSData
                Mov     AX, 8
                StosW
                Call    IPX_MaintenanceSendData
                Jmp     IPX_ConnectEnter1

IPX_ConnectEnter2:
                Cmp     NumberOfConnections, 0
                JNE     IPX_ConnectEnter3

; Connection rejected

                Push    DS
                Push    Offset ConnectionRejectedList
                Call    IT_FunctionHandler
                Jmp     IPX_ConnectEnter1

IPX_ConnectEnter3:
; Connection established

IPX_ConnectEnter1:
                Mov     AX, 1
                Ret

EndP            IPX_ConnectEnter

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_SendGroupMessage Far

        Push    CS
        Pop     DS

        Cmp     MessageEntryArea, 0
        JE      IPX_SendMessageEnd

        Mov     SI, Offset UserName
        Mov     DI, Offset MessageSenderName
        Mov     CX, 16/2
        Rep     MovsW

        Mov     [MaintenanceSendHeader], Offset MaintenanceSendHeaderDirected
        Mov     [MaintenanceSendDataOffset], Offset MessageBlock
        Mov     [MaintenanceSendDataSize], 73

        Mov     SI, Offset UserAddress1
        Mov     DL, NumberOfConnections

IPX_SendGroupMessage1:
        Mov     DI, Offset MaintenanceDirectedDestination
        Mov     CX, 10/2
        Rep     MovsW
        Mov     AX, 'IT'
        StosW

        Call    SendMaintenancePacket
        Add     SI, 18

        Dec     DL
        JNZ     IPX_SendGroupMessage1

        Jmp     IPX_SendMessageChain

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_SendMessage Far

        Push    CS
        Pop     DS

        Cmp     MessageEntryArea, 0
        JE      IPX_SendMessageEnd

        Mov     SI, Offset UserName
        Mov     DI, Offset MessageSenderName
        Mov     CX, 16/2
        Rep     MovsW

        Mov     [MaintenanceSendHeader], Offset MaintenanceSendHeaderBroadcast
        Mov     [MaintenanceSendDataOffset], Offset MessageBlock
        Mov     [MaintenanceSendDataSize], 73
        Call    SendMaintenancePacket

; Wait until sent, then does this..

IPX_SendMessageChain:
        Call    MaintenanceWaitForSend

        Mov     SI, Offset MessageData+72
        Mov     DI, Offset MessageData
        Mov     CX, 72*7/2
        Rep     MovsW
        Mov     SI, Offset MessageSenderName
        Mov     CX, 72/2
        Rep     MovsW

        Xor     AX, AX
        Mov     DI, Offset MessageEntryArea
        Mov     CX, 56/2
        Rep     StosW

IPX_SendMessageEnd:
        Mov     AX, 1
        Ret

EndP            IPX_SendMessage
EndP            IPX_SendGroupMessage


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_ShowConnectionDetails Far

                Push    CS
                Pop     DS
                        Assume DS:IPX

                MOv     DX, 1
                Mov     DI, (4+15*80)*2
                Mov     BX, Offset UserName1
                Call    IT_S_GetDestination

IPX_ShowConnectionDetailsLoop:

; Want to show:
;  Connection %d
;   User name: %s
;   User address: [hex]
; (Bytes transferred)

                Push    DX

                Mov     AH, 20h
                Mov     SI, Offset ConnectionNumberMsg
                Call    IT_S_DrawString

                Mov     SI, BX
                Mov     CX, 16

IPX_ShowConnectionDetails1:
                LodsB
                StosW
                Loop    IPX_ShowConnectionDetails1

                Push    SI

                Add     DI, 104
                Mov     SI, Offset ConnectionAddressMsg
                Call    IT_S_DrawString

                Pop     SI

                Call    IPX_DrawAddress

                Mov     AL, ' '
                StosW

                Call    IPX_DrawHexNumber
                Call    IPX_DrawHexNumber

                Mov     BX, SI
                Add     DI, 62+160

                Pop     DX

                Inc     DX

                Cmp     DL, NumberOfConnections
                JBE     IPX_ShowConnectionDetailsLoop

                Ret

EndP            IPX_ShowConnectionDetails
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_DisplayMessages Far

                Push    CS
                Pop     DS
                        Assume DS:IPX

                Call    IT_S_GetDestination

                Mov     CX, 8
                Mov     DI, (38*80+3)*2
                Mov     SI, Offset MessageData

IPX_DisplayMessages1:
                Cmp     Byte Ptr [SI], 0
                JE      IPX_DisplayMessages4

                Push    SI
                Push    DI

                Push    SI
                Mov     AH, 3

IPX_DisplayMessages2:
                LodSB
                Test    AL, AL
                JZ      IPX_DisplayMessages5
                StosW
                Jmp     IPX_DisplayMessages2

IPX_DisplayMessages5:
                Pop     SI
                Add     SI, 16

                Mov     AL, ':'
                StosW
                Mov     AL, ' '
                StosW

                Mov     AH, 2

IPX_DisplayMessages3:
                LodsB
                StosW
                Test    AL, AL
                JNZ     IPX_DisplayMessages3

                Pop     DI
                Pop     SI

IPX_DisplayMessages4:
                Add     SI, 72
                Add     DI, 160
                Loop    IPX_DisplayMessages1

                Ret

EndP            IPX_DisplayMessages
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IPX_ConnectionStatus Far; Returns 0 if not connected
                                        ; Otherwise returns connection count

                Mov     AL, CS:NumberOfConnections
                Ret

EndP            IPX_ConnectionStatus

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

EndDriver:

ProvidedVariableTableStart:
        DB      NUMPROVIDEDVARIABLES-($-ProvidedVariableTableStart) Dup (0)

ProvidedProcedureTableStart:
        DW      Offset IPX_Initialise
        DW      Offset IPX_Shutdown
        DW      Offset IPX_DriverScreen
        DW      Offset IPX_Update
        DW      Offset IPX_ConnectionStatus

        DW      NUMPROVIDEDFUNCTIONS - ($-ProvidedProcedureTableStart)/4 Dup (0)


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

EndS

End
