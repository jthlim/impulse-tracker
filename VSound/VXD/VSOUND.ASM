PAGE 58,132

        .386p

;
; Client has:
;  States -> state is set by writing to port
;            data is retrieved by reading from port
;
;  State 0: Get Identification "ITVXDDRV"
;  State 1: Get Server string (64 bytes)
;  State 2: Get buffer used
;  State 3: Reset Client
;  State 4: Get debug value
;  State 5: Get TSC
;
;
; Server interface:
;  Write 0 to reset
;   If read, returns "ITSERVER", else 01h if Server has been validated.
;   Needs to receive "ITSERVER" to validate.
;   If validated, receives server string of max 64 bytes, no 0 permitted.
;


        .XLIST
        INCLUDE VMM.Inc
        INCLUDE Debug.Inc
        INCLUDE Shell.inc
        .LIST

 VSound_Client_Address  EQU     400h
 VSound_Server_Address  EQU     401h
 VSound_Data_Address    EQU     402h

 VSOUND_CLIENTSTATES    EQU     7
 VSOUND_BUFFERSIZE      EQU     (64*1024)

;******************************************************************************
;                V I R T U A L   D E V I C E   D E C L A R A T I O N
;******************************************************************************

Declare_Virtual_Device VSOUND, 1, 0, VSOUND_Control, Undefined_Device_ID ,,,

;******************************************************************************
;                         L O C A L   D A T A
;******************************************************************************


VxD_LOCKED_DATA_SEG

VSound_Data             DB      VSOUND_BUFFERSIZE Dup (0)
VSound_HeadPointer      DD      0
VSound_TailPointer      DD      0

VSound_Client           DD      0
VSound_Server           DD      0
VSound_ClientCallback   DD      0

VSound_ID               DB      "ITVXDDRV"
VSound_State            DD      0
VSound_BufferUsed       DD      0
VSound_StatePos         DD      0

VSound_ServerID         DB      "ITSERVER"
VSound_ServerInPos      DD      0
VSound_ServerOutPos     DD      0
VSound_ServerValid      DD      0

VSound_DebugValue       DD      0
VSound_TimeStamp1       DD      0
VSound_TimeStamp2       DD      0

VSound_InTable          DD      Offset32 VSound_Identification
                        DD      Offset32 VSound_GetServerString
                        DD      Offset32 VSound_GetBufferUsed
                        DD      Offset32 VSound_GetDebugValue
                        DD      Offset32 VSound_Get0
                        DD      Offset32 VSound_GetDebugValue
                        DD      Offset32 VSound_GetTSC

VSound_OutTable         DD      Offset32 VSound_Out_ResetStatePos
                        DD      Offset32 VSound_Out_ResetStatePos
                        DD      Offset32 VSound_Out_GetBufferUsed
                        DD      Offset32 VSound_Out_ResetClient
                        DD      Offset32 VSound_Out_SetCallbackAddress
                        DD      Offset32 VSound_Out_ResetStatePos
                        DD      Offset32 VSound_Out_GetTSC

VSound_ServerString     DB      64 Dup (0)

VxD_LOCKED_DATA_ENDS


;******************************************************************************
;                  I N I T I A L I Z A T I O N   C O D E
;******************************************************************************

VxD_IDATA_SEG

Begin_Vxd_IO_Table      IO_Table
  Vxd_IO                VSound_Client_Address, VSound_Client_Hook
  Vxd_IO                VSound_Server_Address, VSound_Server_Hook
  Vxd_IO                VSound_Data_Address,   VSound_Data_Hook
End_Vxd_IO_Table        IO_Table

VxD_IDATA_ENDS

VxD_ICODE_SEG


;******************************************************************************
;
;   VSOUND_Device_Init
;
;   DESCRIPTION:
;
;       This routine is called during Windows startup. It needs to 
;       install the I/O handler for our device, and set up the system
;       VM as the default owner.
;
;
;==============================================================================

BeginProc VSOUND_Device_Init

        Xor     EAX, EAX
        Mov     VSound_Client, EAX              ; no current owner
        Mov     VSound_Server, EAX              ; no current owner
        Mov     VSound_ClientCallback, EAX      ; No callback

        Mov     EDI, OFFSET32 IO_Table
        VMMCall Install_Mult_IO_Handlers

        Ret

EndProc VSOUND_Device_Init

VxD_ICODE_ENDS


;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

VxD_CODE_SEG

;******************************************************************************
;
;   VSOUND_Destroy_VM
;
;   DESCRIPTION:
;
;       This routine is called when a VM is destroyed. We need to check
;       to see if the VM in question is the current owner of the device.
;
;==============================================================================

BeginProc VSOUND_Destroy_VM

        Xor     EAX, EAX

        Cmp     EBX, VSound_Client              ; Destroying device owner?
        JNE     Short VDM_Client

        Mov     VSound_Client, EAX
         Mov     VSound_ClientCallback, EAX
        
VDM_Client:
        Cmp     EBX, VSound_Server
        JNE     VDM_Server

        Mov     VSound_Server, EAX
        Mov     VSound_ServerValid, EAX

VDM_Server:
        ClC
        Ret

EndProc VSOUND_Destroy_VM

VxD_CODE_ENDS


;******************************************************************************

VxD_LOCKED_CODE_SEG

;******************************************************************************
;
;   VSound_Control
;
;   DESCRIPTION:
;
;       This is a call-back routine to handle the messages that are sent
;       to VxD's to control system operation.
;
;==============================================================================
BeginProc VSound_Control

        Control_Dispatch Device_Init, VSound_Device_Init
        Control_Dispatch Destroy_VM, VSound_Destroy_VM

        ClC
        Ret

EndProc VSound_Control

VxD_LOCKED_CODE_ENDS


VxD_CODE_SEG

;*****************************************************************************
;
;   VSound_Client_Hook
;
;   DESCRIPTION:
;
;       This routine is called for every I/O access to our port. First,
;       it checks to see if the VM issuing the I/O is the current owner.
;       If not, it displays a dialog box so the user can decide what to
;       do.
;
;*****************************************************************************

VSound_Identification:
        Pop     EAX
        Push    ECX
        Mov     ECX, VSound_StatePos

        Mov     AL, [VSound_ID+ECX]
        Inc     ECX
        And     ECX, 7
        Mov     VSound_StatePos, ECX

        Pop     ECX
        Ret

VSound_GetServerString:
        Pop     EAX
        Push    ECX
        Mov     ECX, VSound_StatePos

        Mov     AL, [VSound_ServerString+ECX]
        Inc     ECX
        And     ECX, 63
        Mov     VSound_StatePos, ECX

        Pop     ECX
        Ret

VSound_GetBufferUsed:
        Pop     EAX
        Push    ECX
        Mov     ECX, VSound_StatePos

        Xor     ECX, 1
        Mov     AL, [Byte Ptr VSound_BufferUsed+ECX]
        Mov     VSound_StatePos, ECX

        Pop     ECX
        Ret

VSound_GetTSC:
        Pop     EAX
        Push    ECX
        Mov     ECX, VSound_StatePos

        Mov     AL, [Byte Ptr VSound_TimeStamp1+ECX]
        Inc     ECX
        And     ECX, 7

        Mov     VSound_StatePos, ECX

        Pop     ECX
        Ret

VSound_Get0:
        Xor     AL, AL

        Pop     ECX
        Ret

VSound_GetDebugValue:
        Pop     EAX
        Push    ECX
        Mov     ECX, VSound_StatePos

        Mov     AL, [Byte Ptr VSound_DebugValue+ECX]
        Inc     ECX
        And     ECX, 3

        Mov     VSound_StatePos, ECX

        Pop     ECX
        Ret

BeginProc VSound_Client_Hook

;---------------------------------------------------------------------
;  Resolve Contention 
;---------------------------------------------------------------------

        Push    EAX

        Mov     EAX, VSound_Client

        Cmp     VSound_ServerValid, 0
        JE      NoValidServer

        Cmp     EAX, EBX                        ; Is the request from the
        JE      Process_IO                      ; current owner?

        Test    EAX, EAX                        ; Was there a previous owner?
        JZ      New_Owner

NoValidServer:
        Pop     EAX

        Dispatch_Byte_IO Fall_Through, <SHORT Blocked_IO>

        Mov     AL, 80h

Blocked_IO:
        Ret

New_Owner:
        Mov     VSound_Client, EBX
        Mov     VSound_ClientCallback, 0

Process_IO:
        Pop     EAX

        Dispatch_Byte_IO Fall_Through, <SHORT VSound_Out>

        Push    EAX
        Mov     EAX, VSound_State
        Cmp     EAX, VSOUND_CLIENTSTATES
        JAE     VSound_Unknown

        Jmp     [VSound_InTable+EAX*4]

VSound_Unknown:
        Pop     EAX
        Xor     AL, AL
        Ret

VSound_Out:
        Push    EAX
        Mov     Byte Ptr VSound_State, AL
        And     EAX, 0FFh

        Cmp     EAX, VSOUND_CLIENTSTATES
        JAE     VSound_Out_Nothing

        Jmp     [VSound_OutTable+EAX*4]

VSound_Out_GetTSC:
        DB      0Fh
        DB      31h     ; RdTSC
        Mov     VSound_TimeStamp1, EAX
        Mov     VSound_TimeStamp2, EDX
        Jmp     VSound_Out_ResetStatePos

VSound_Out_GetBufferUsed:
        Mov     EAX, VSound_TailPointer
        Sub     EAX, VSound_HeadPointer
        And     EAX, VSOUND_BUFFERSIZE-1
        Mov     VSound_BufferUsed, EAX

VSound_Out_ResetStatePos:
        Mov     VSound_StatePos, 0

VSound_Out_Nothing:
        Pop     EAX
        Ret

VSound_Out_ResetClient:
        Xor     EAX, EAX
        Mov     VSound_Client, EAX
        Mov     VSound_ClientCallback, EAX

        Pop     EAX

        Ret

VSound_Out_SetCallbackAddress:
        Mov     AX, [EBP+CLIENT_REG_STRUC.CLIENT_CS]
        ShL     EAX, 16
        Mov     AX, [EBP+CLIENT_REG_STRUC.CLIENT_BX]

        Mov     VSound_ClientCallback, EAX

        Pop     EAX
        Ret

EndProc VSound_Client_Hook

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;--------------------------------------------------------------------

BeginProc VSound_Server_Hook

        Push    EAX

        Mov     EAX, VSound_Server

        Cmp     EAX, EBX                        ; Is the request from the
        JE      Process_Server_IO               ; current owner?

        Test    EAX, EAX                        ; Was there a previous owner?
        JZ      New_Server

        Pop     EAX

        Dispatch_Byte_IO Fall_Through, <SHORT Server_Blocked_IO>

        Mov     AL, 80h

Server_Blocked_IO:
        Ret

New_Server:
        Mov     VSound_Server, EBX

Process_Server_IO:
        Pop     EAX

        Dispatch_Byte_IO Fall_Through, <SHORT VSound_Server_Out>

        Cmp     VSound_ServerValid, 1
        JE      VSound_Server_Validated

        Mov     ECX, VSound_ServerInPos
        Mov     AL, [VSound_ServerID+ECX]
        Inc     ECX
        And     ECX, 7
        Mov     VSound_ServerInPos, ECX
        Ret

VSound_Server_Validated:
        Mov     ECX, VSound_Client
        Add     ECX, 0FFFFFFFFh
        SBB     AL, AL          ; Returns 0 if not connected, 0FFh if connected
        Ret

VSound_Server_Out:
        Test    AL, AL          ; Reset?
        JZ      VSound_Server_Reset

        Mov     ECX, VSound_ServerOutPos

        Cmp     VSound_ServerValid, 1
        JE      VSound_ReceiveServerString

        Cmp     [VSound_ServerID+ECX], AL
        JE      VSound_ValidByte

        Mov     VSound_ServerOutPos, 0
        Ret

VSound_ValidByte:
        Inc     ECX
        And     ECX, 7
        Mov     VSound_ServerOutPos, ECX
        JNZ     VSound_ServerNotValidated

        Mov     VSound_ServerValid, 1

VSound_ServerNotValidated:
        Ret

VSound_ReceiveServerString:
        Mov     [VSound_ServerString+ECX], AL
        Inc     ECX
        And     ECX, 63
        Mov     VSound_ServerOutPos, ECX
        Ret

VSound_Server_Reset:
        Xor     ECX, ECX
        Mov     VSound_Server, ECX
        Mov     VSound_ServerValid, ECX
        Mov     VSound_ServerInPos, ECX
        Mov     VSound_ServerOutPos, ECX

        Ret

EndProc VSound_Server_Hook

;---------------------------------------------------------------------

BeginProc VSound_Data_Hook

        Cmp     EBX, VSound_Server
        JE      VSound_Data_Server

        Cmp     EBX, VSound_Client
        JE      VSound_Data_Client

        Ret

VSound_Data_Client:
        Cmp     CX, String_IO or Rep_IO or Byte_Output
        JNE     Data_Client_Simulate

        PushAD
        Push    ES
        PushF

        ClI

        Push    DS
        Pop     ES

        ShR     ECX, 16                 ; ECX = segment.
        Mov     EAX, [EBP+CLIENT_REG_STRUC.CLIENT_ECX]

        ShL     ECX, 4
        Mov     ESI, [EBP+CLIENT_REG_STRUC.CLIENT_ESI]

        And     ESI, 0FFFFh
        Mov     EDI, VSound_TailPointer

        Add     ESI, ECX                ; ESI = data source.
        And     EAX, 0FFFFh             ; EAX = byte count

        Test    EAX, 3                  ; Must be multiple of 4 bytes
        JNZ     VSound_DataClientExit

        LEA     EDX, [EDI+EAX]
        Add     EDI, Offset VSound_Data

        Cmp     EDX, VSOUND_BUFFERSIZE
        JB      VSound_DataClient1

        Mov     ECX, VSOUND_BUFFERSIZE
        LEA     EAX, [EDX-VSOUND_BUFFERSIZE]

        Sub     ECX, VSound_TailPointer
        ShR     ECX, 2

        Rep     MovsD

        Mov     EDI, Offset VSound_Data

VSound_DataClient1:
        ShR     EAX, 2
        And     EDX, VSOUND_BUFFERSIZE-1

        Mov     ECX, EAX
        Mov     VSound_TailPointer, EDX

        Rep     MovsD

VSound_DataClientExit:
        PopF
        Pop     ES
        PopAD

Data_Client_Simulate:
        Ret

VSound_Data_Server:

;
; The server will only receive data if:
;  1) A Rep InsB instruction is used. No other instruction will work
;  2) The ECX count is a multiple of 4
;  3) The ECX count must be less than BUFFERSIZE

        Cmp     CX, String_IO or Rep_IO or Addr_32_IO or Byte_Input
        JNE     Data_Server_Simulate

        PushAD
        Push    ES
        PushF

        ClI

        ShR     ECX, 16
        Mov     ES, CX

        Mov     EAX, [EBP+CLIENT_REG_STRUC.CLIENT_ECX]
        Mov     EDI, [EBP+CLIENT_REG_STRUC.CLIENT_EDI]

        Test    EAX, 3
        JNZ     VSound_DataServerExit

        Cmp     EAX, VSOUND_BUFFERSIZE
        JAE     VSound_DataServerExit

; Want minimum of bytes available and bytes requested
        Mov     ESI, VSound_HeadPointer
        Mov     EBX, VSound_TailPointer

        Sub     EBX, ESI
        And     EBX, VSOUND_BUFFERSIZE-1        ; EBX = bytes available
                                                ; EAX = bytes requested
        Cmp     EBX, EAX
        JB      VSound_DataServer1

        Mov     EBX, EAX

VSound_DataServer1:                             ; EBX = bytes to transfer
        Sub     EAX, EBX                        ; EAX = bytes to zero
        LEA     EDX, [ESI+EBX]

        ShR     EBX, 2                          ; EBX = dwords to transfer
        Add     ESI, Offset VSound_Data

        Cmp     EDX, VSOUND_BUFFERSIZE          ; Does it span the buffer boundary?
        JB      VSound_DataServer2

        LEA     EBX, [EDX-VSOUND_BUFFERSIZE]
        Mov     ECX, VSOUND_BUFFERSIZE

        ShR     EBX, 2
        Sub     ECX, VSound_HeadPointer

        ShR     ECX, 2

        Rep     MovsD

        Mov     ESI, Offset VSound_Data

VSound_DataServer2:
        ShR     EAX, 2
        Mov     ECX, EBX
        Rep     MovsD

        Mov     ECX, EAX
        And     EDX, VSOUND_BUFFERSIZE-1

        Xor     EAX, EAX
        Mov     VSound_HeadPointer, EDX

        Rep     StosD

; ECX = 0
        Mov     EBX, VSound_Client
        Cmp     VSound_ClientCallback, ECX
        JE      VSound_DataServerExit
        Test    EBX, EBX
        JZ      VSound_DataServerExit

        Mov     EBP, [EBX+CB_S.CB_Client_Pointer]

        VMMCall Set_Execution_Focus
        JC      VSound_DataServerExit

        Push_Client_State

        VMMCall Begin_Nest_V86_Exec

        MovZX   EDX, Word Ptr [VSound_ClientCallback]
        MovZX   ECX, Word Ptr [VSound_ClientCallback+2]
        VMMCall Simulate_Far_Call
        VMMCall Resume_Exec

        VMMCall End_Nest_Exec

        Pop_Client_State

VSound_DataServerExit:
        PopF
        Pop     ES
        PopAD

Data_Server_Simulate:
        Ret

EndProc   VSound_Data_Hook

;---------------------------------------------------------------------

VxD_CODE_ENDS


        END
