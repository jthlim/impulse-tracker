;****************************************************************************
;                                                                           *
; THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY     *
; KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE       *
; IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR     *
; PURPOSE.                                                                  *
;                                                                           *
; Copyright (C) 1993-95  Microsoft Corporation.  All Rights Reserved.       *
;                                                                           *
;****************************************************************************

ifndef _SHELL_H
_SHELL_H	EQU	1
ifndef Not_VxD
Begin_Service_Table SHELL
SHELL_Service    SHELL_Get_Version, LOCAL
SHELL_Service    SHELL_Resolve_Contention, LOCAL
SHELL_Service    SHELL_Event, LOCAL
SHELL_Service    SHELL_SYSMODAL_Message, LOCAL
SHELL_Service    SHELL_Message, LOCAL
ifndef WIN30COMPAT
SHELL_Service    SHELL_GetVMInfo, LOCAL
endif
ifndef WIN31COMPAT
SHELL_Service    _SHELL_PostMessage, LOCAL
SHELL_Service    _SHELL_ShellExecute
SHELL_Service    _SHELL_PostShellMessage
SHELL_Service    SHELL_DispatchRing0AppyEvents, LOCAL
SHELL_Service    SHELL_Hook_Properties, LOCAL
SHELL_Service    SHELL_Unhook_Properties, LOCAL
SHELL_Service    SHELL_Update_User_Activity, LOCAL
SHELL_Service    _SHELL_QueryAppyTimeAvailable, LOCAL
SHELL_Service    _SHELL_CallAtAppyTime, LOCAL
SHELL_Service    _SHELL_CancelAppyTimeEvent
SHELL_Service    _SHELL_BroadcastSystemMessage, LOCAL
SHELL_Service    _SHELL_HookSystemBroadcast, LOCAL
SHELL_Service    _SHELL_UnhookSystemBroadcast, LOCAL
SHELL_Service    _SHELL_LocalAllocEx, LOCAL
SHELL_Service    _SHELL_LocalFree, LOCAL
SHELL_Service    _SHELL_LoadLibrary, LOCAL
SHELL_Service    _SHELL_FreeLibrary, LOCAL
SHELL_Service    _SHELL_GetProcAddress, LOCAL
SHELL_Service    _SHELL_CallDll, LOCAL
SHELL_Service	 _SHELL_SuggestSingleMSDOSMode
SHELL_Service	 SHELL_CheckHotkeyAllowed
SHELL_Service	 _SHELL_GetDOSAppInfo
endif
End_Service_Table SHELL
ifndef WIN31COMPAT
SBH_CALL_ORDER_DEFAULT	EQU	0
SBH_CALL_ORDER_REGISTRY	EQU	30000000H
SBH_CALL_ORDER_CONFIGMG	EQU	40000000H
endif
MB_OK	EQU	00H
MB_OKCANCEL	EQU	01H
MB_ABORTRETRYIGNORE	EQU	02H
MB_YESNOCANCEL	EQU	03H
MB_YESNO	EQU	04H
MB_RETRYCANCEL	EQU	05H
MB_ICONHAND	EQU	10H
MB_ICONEXCLAMATION	EQU	30H
MB_ICONASTERISK	EQU	40H
MB_DEFBUTTON1	EQU	00H
MB_DEFBUTTON2	EQU	100H
MB_DEFBUTTON3	EQU	200H
MB_APPLMODAL	EQU	00H
MB_SYSTEMMODAL	EQU	1000H
MB_NOFOCUS	EQU	8000H
MB_ASAP	EQU	80000000H
MB_NOWINDOW	EQU	40000000H
MB_HANGSYS	EQU	20000000H
ifndef WIN31COMPAT
MB_APPYTIME	EQU	10000000H
endif
IDOK	EQU	1
IDCANCEL	EQU	2
IDABORT	EQU	3
IDRETRY	EQU	4
IDIGNORE	EQU	5
IDYES	EQU	6
IDNO	EQU	7
SE_WP_PrtScBoost	EQU	00100000H
SE_WP_PrtScBoostBit	EQU	20
SE_WP_DispUpdBoost	EQU	00200000H
SE_WP_DispUpdBoostBit	EQU	21
ifndef WIN31COMPAT
SPM_UM_DoNotWaitForCrit	EQU	00020000H
SPM_UM_DoNotWaitForCritBit	EQU	17
SPM_UM_AlwaysSchedule	EQU	00080000H
SPM_UM_AlwaysScheduleBit	EQU	19
endif
SGVMI_Windowed	EQU	00000004H
SGVMI_ALTTABdis	EQU	00000020H
SGVMI_ALTESCdis	EQU	00000040H
SGVMI_ALTSPACEdis	EQU	00000080H
SGVMI_ALTENTERdis	EQU	00000100H
SGVMI_ALTPRTSCdis	EQU	00000200H
SGVMI_PRTSCdis	EQU	00000400H
SGVMI_CTRLESCdis	EQU	00000800H
SGVMI_HasHotKey	EQU	00004000H
SGVMI_Polling	EQU	00001000H
SGVMI_FastPaste	EQU	00020000H
SGVMI_NoHMA	EQU	00002000H
SGVMI_XMS_Lock	EQU	00010000H
SGVMI_EMS_Lock	EQU	00008000H
SGVMI_V86_Lock	EQU	00040000H
SGVMI_ClsExit	EQU	40000000H
endif
ifndef WIN31COMPAT
ifndef Not_VxD
LMEM_FIXED	EQU	0000H
LMEM_ZEROINIT	EQU	0040H
LPTR	EQU	(LMEM_FIXED OR LMEM_ZEROINIT)
LMEM_STRING	EQU	00010000H
LMEM_OEM2ANSI	EQU	00020000H
QAAFL_APPYAVAIL	EQU	00000001H
QAAFL_APPYNOW	EQU	00000002H
CAAFL_RING0	EQU	00000001H
CAAFL_TIMEOUT	EQU	00000002H
endif

SHEXPACKET	STRUC
shex_dwTotalSize	DD	?
shex_dwSize	DD	?
shex_ibOp	DD	?
shex_ibFile	DD	?
shex_ibParams	DD	?
shex_ibDir	DD	?
shex_dwReserved	DD	?
shex_nCmdShow	DD	?
SHEXPACKET	ENDS
SGDAIF_COMPARENAME	EQU	0
SGDAIF_TESTAPPBIT	EQU	1
SGDAIF_LASTVALID	EQU	1
SGDAIR_SUCCESS	EQU	0
SGDAIR_NOMATCH	EQU	1
SGDAIR_BADFUNCTION	EQU	2
endif
endif
