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

NOBUGBUG	EQU	1










BUGBUG	macro	d, id, note
endm





























IsDebugOnlyLoaded	macro	lab
	local	var, magic
_DBOSTART segment
var	label	byte
_DBOSTART ends
	db	0F7h, 05h
	dd	OFFSET32 magic
magic	dd	OFFSET32 var - (MAXSYSTEMLADDR + 1)
ifnb <lab>
	jz	lab
endif
	endm










DPublic MACRO	arg
if DEBLEVEL GT DEBLEVELRETAIL
	public	arg
endif
        ENDM















Assumes_Fall_Through MACRO L
ifndef MASM6
IF2
 IFDEF profileall
  IF (?prolog_&L - $) GT 3
  %OUT ERROR:  Fall through to &L invalid
  .ERR
  ENDIF
 ELSE
  IF (L - $) GT 3
  %OUT ERROR:  Fall through to &L invalid
  .ERR
  ENDIF
 ENDIF
ENDIF
else
 IFDEF profileall
.errnz ((?prolog_&L - $) GT 3), <ERROR: Fall through to &L invalid>
 ELSE
.errnz ((L - $) GT 3), <ERROR: Fall through to &L invalid>
 ENDIF
endif

     ENDM


ifndef Not_VxD





























??avh_parse_one_arg macro arg
    ifidni <arg>, <USES_FLAGS>
	??_fUsesFlagsPushfd equ <>
	??_fUsesFlagsPopfd equ <>
    elseifnb <arg>
	??_debLevel = arg
    endif
endm

??avh_parse_args macro DL, fUSES_FLAGS
	??_fUsesFlagsPushfd equ <pushfd>
	??_fUsesFlagsPopfd equ <popfd>
	??_debLevel = DEBLEVELNORMAL
	??avh_parse_one_arg <DL>
	??avh_parse_one_arg <fUSES_FLAGS>
endm

Assert_VM_Handle MACRO R, DL, fUSES_FLAGS
	LOCAL l1

IF DEBLEVEL GT DEBLEVELRETAIL

	??avh_parse_args <DL>, <fUSES_FLAGS>

IF DEBLEVEL GE ??_debLevel

IFNDEF WIN31COMPAT
IF DEBLEVEL LT DEBLEVELMAX
	??_fUsesFlagsPushfd
	cmp	[R].CB_Signature, VMCB_ID
	je	SHORT l1
ENDIF
ENDIF

IFDIFI <ebx>,<R>
	push	ebx
	mov	ebx, R
ENDIF
	VMMCall	Debug_Test_Valid_Handle
IFDIFI <ebx>, <R>
	pop	ebx
ENDIF

IFNDEF WIN31COMPAT
IF DEBLEVEL LT DEBLEVELMAX
l1:
	??_fUsesFlagsPopfd
ENDIF
ENDIF

ENDIF

ENDIF
	ENDM




























Assert_Thread_Handle MACRO R, DL, fUSES_FLAGS
	LOCAL l1

IF DEBLEVEL GT DEBLEVELRETAIL

	??avh_parse_args <DL>, <fUSES_FLAGS>

IF DEBLEVEL GE ??_debLevel

IF DEBLEVEL LT DEBLEVELMAX
	??_fUsesFlagsPushfd
	cmp	dword ptr [R.TCB_Signature], SCHED_OBJ_ID_THREAD
	je	SHORT l1
ENDIF

IFDIFI <edi>,<R>
        push    edi
        mov     edi, R
ENDIF
        VMMCall Debug_Test_Valid_Thread_Handle
IFDIFI <edi>,<R>
        pop     edi
ENDIF

IF DEBLEVEL LT DEBLEVELMAX
l1:
	??_fUsesFlagsPopfd
ENDIF

ENDIF

ENDIF
	ENDM

















Assert_Cur_Thread_Handle MACRO R, DL
	LOCAL myDebLevel
	LOCAL	OK

IF DEBLEVEL GT DEBLEVELRETAIL

IFB <DL>
	myDebLevel EQU DEBLEVELNORMAL
ELSE
	myDebLevel EQU <DL>
ENDIF

IF DEBLEVEL GE myDebLevel

IFDIFI <edi>,<R>
        push    edi
        mov     edi, R
ENDIF
        VMMCall Debug_Test_Cur_Thread
IFDIFI <edi>,<R>
        pop     edi
ENDIF

ENDIF

ENDIF
	ENDM













Debug_Printf	macro	fmt, args, dl
	local	fmtlab, myDebLevel

ife ?_DBOCODE
    ??_fDoit = VMM_TRUE
else
    ??_fDoit = FALSE
endif

if DEBLEVEL GT DEBLEVELRETAIL

ifb <dl>
	myDebLevel EQU <DEBLEVELNORMAL>
else
	myDebLevel EQU <dl>
endif

if DEBLEVEL GE myDebLevel
    ??_fDoit = VMM_TRUE
endif

endif

if ??_fDoit

ife ?_DBOCODE

VxD_DEBUG_ONLY_DATA_SEG
fmtlab	db	fmt, 0
VxD_DEBUG_ONLY_DATA_ENDS

else

ifdef VMMSYS

VMM_LOCKED_DATA_SEG
fmtlab	db	fmt, 0
VMM_LOCKED_DATA_ENDS

else

VxD_LOCKED_DATA_SEG
fmtlab	db	fmt, 0
VxD_LOCKED_DATA_ENDS

endif

endif

	ifb <args>
	VMMCall _Debug_Printf_Service, <(OFFSET32 fmtlab), esp>
	else
	VMMCall _Debug_Printf_Service, <(OFFSET32 fmtlab), esp, args>
	endif

endif

	endm







CHECK_EOL MACRO f, x, ln
	ifdifi <x>,<noeol>
	ifdifi <x>,<no_eol>
	ifdifi <x>,<nocrlf>
	ifdifi <x>,</noeol>
		%OUT Line ln: Unknown symbol (x) in f, taken as NOEOL
	endif
	endif
	endif
	endif

ENDM

??_Gen_String macro lbl:req, str:req
	ife ?_ICODE
	    ??_segName textequ <_IDATA>
	elseife ?_PCODE
	    ??_segName textequ <_PDATA>
	elseife ?_SCODE
	    ??_segName textequ <_SDATA>
	elseife ?_DBOCODE
	    ??_segName textequ <_DBODATA>
	else
	    ??_segName textequ <_LDATA>
	endif

	??_segName segment
	    lbl	db	str
	    ife ??_nocrlf
		db	0dh,0ah
	    endif
		db	0
	??_segName ends
endm


??Trace_Debug_Helper macro typ, str, arg1, arg2
	local	string

    ife ?_DBOCODE
	??_fDoit = VMM_TRUE
    else
	??_fDoit = 0
    endif

    if (DEBLEVEL GT DEBLEVELRETAIL) OR ??_fDoit

	??_nocrlf = 0
	??_debLevel = DEBLEVELNORMAL

	irp x, <arg1, arg2>
	    ifnb <x>
		if ((.TYPE x) AND 20h) GT 0
		    ??_debLevel = x
		else
		    Check_EOL <typ>, <x>, %(@Line)
		    ??_nocrlf = 1
		endif
	    endif
	endm

	if DEBLEVEL GE ??_debLevel
	    ??_fDoit = VMM_TRUE
	endif

    endif

    if ??_fDoit

	irpc c, str
	    ifidn <c>, <">
		??_is_string = 1
	    else
	    ifidni <c>, <'>
		??_is_string = 1
	    else
		??_is_string = 0
	    endif
	    endif
	    exitm
	endm

	if ??_is_string
	    ??_Gen_String string, <str>
	    ??_debug_out_str textequ <OFFSET32 string>
	else
	    ??_debug_out_str textequ <str>
	endif

	ifdef WIN31COMPAT
		pushfd
		pushad
		mov	esi, ??_debug_out_str
		VMMCall Out_Debug_String
	    ifidni <typ>, <Debug_Out>
		VMMCall Test_Debug_Installed
		jz	SHORT $+4
		int	1
	    endif
		popad
		popfd
	else
		push	??_debug_out_str
	    ifidni <typ>, <Debug_Out>
		VMMCall _Debug_Out_Service
	    else
		VMMCall _Trace_Out_Service
	    endif
	endif

    endif

	endm
















irp     cond,<S,C,A,AE,B,BE,E,Z,G,GE,L,LE,O>

Trace_Out&cond macro str, arg1, arg2
	?trace_out <str>,jn&cond, <arg1>, <arg2>
	endm

Trace_OutN&cond macro str, arg1, arg2
	?trace_out <str>,j&cond, <arg1>, <arg2>
	endm

endm

Trace_Out MACRO str, arg1, arg2
	??Trace_Debug_Helper <Trace_Out>, <str>, <arg1>, <arg2>
endm

Trace_OutECXZ   macro str, arg1, arg2
	local	l1,l2
if (DEBLEVEL GT DEBLEVELRETAIL) or (?_DBOCODE eq 0)
	jecxz	l1
	jmp	short l2
l1:	Trace_Out <str>, <arg1>, <arg2>
l2:
endif
	endm

Trace_OutECXNZ macro str, arg1, arg2
	?trace_out <str>,jecxz, <arg1>, <arg2>
	endm

Trace_OutEAXz macro str, arg1, arg2
	local	l1
if (DEBLEVEL GT DEBLEVELRETAIL) or (?_DBOCODE eq 0)
	or	eax,eax
	jnz	short l1
	Trace_Out <str>, <arg1>, <arg2>
l1:
endif
	endm

Trace_OutEAXnz macro str, arg1, arg2
	local	l1
if (DEBLEVEL GT DEBLEVELRETAIL) or (?_DBOCODE eq 0)
	or	eax,eax
	jz	short l1
	Trace_Out <str>, <arg1>, <arg2>
l1:
endif
	endm

?trace_out macro str, jmpop, arg1, arg2
	Local	nomsg
if (DEBLEVEL GT DEBLEVELRETAIL) or (?_DBOCODE eq 0)
	jmpop	short nomsg
	Trace_Out <str>,<arg1>,<arg2>
nomsg:
endif
	endm


















irp	cond,<S,C,A,AE,B,BE,E,Z,G,GE,L,LE,O>

Debug_Out&cond &macro str, arg1
	?debug_out <str>,jn&cond,<arg1>
	&endm

Debug_OutN&cond &macro str, arg1
	?debug_out <str>,j&cond,<arg1>
	&endm

endm

Debug_Out MACRO str, arg1, arg2
	??Trace_Debug_Helper <Debug_Out>, <str>, <arg1>, <arg2>
endm

Debug_OutECXZ	macro str, arg1
	local	l1,l2
if DEBLEVEL GT DEBLEVELRETAIL
	jecxz	l1
	jmp	short l2
l1:	Debug_Out <str>, <arg1>
l2:
endif
	endm

Debug_OutECXNZ macro str, arg1
	?debug_out <str>,jecxz, <arg1>
	endm

Debug_OutEAXz macro str, arg1
	local	l1
if DEBLEVEL GT DEBLEVELRETAIL
	or	eax,eax
	jnz	short l1
	Debug_Out <str>, <arg1>
l1:
endif
	endm

Debug_OutEAXnz macro str, arg1
	local	l1
if DEBLEVEL GT DEBLEVELRETAIL
	or	eax,eax
	jz	short l1
	Debug_Out <str>, <arg1>
l1:
endif
	endm

?debug_out macro str,jmpop, arg1
	Local	nomsg
if DEBLEVEL GT DEBLEVELRETAIL
	jmpop	short nomsg
	Debug_Out <str>, <arg1>
nomsg:
endif
	endm








Queue_Out MACRO S, V1, V2, DL
	LOCAL	Str_Off
	LOCAL MyDebLevel

IF DEBLEVEL GT DEBLEVELRETAIL

IFB <DL>
	myDebLevel = DEBLEVELNORMAL
ELSE
	myDebLevel = DL
ENDIF

IF DEBLEVEL GE myDebLevel

_LDATA SEGMENT
Str_Off db S, 0dh,0ah, 0
_LDATA ENDS

	push	esi
IFNB <V1>
    IF	TYPE V1 GT 0
	push	dword ptr V1
    ELSE
	push	V1
    ENDIF
ELSE
	push	eax
ENDIF
IFNB <V2>
    IF	TYPE V2 GT 0
	push	dword ptr V2
    ELSE
	push	V2
    ENDIF
ELSE
	push	ebx
ENDIF
	mov	esi, OFFSET32 Str_Off
	VMMCall Queue_Debug_String
	pop	esi
ENDIF

ENDIF
	ENDM








Mono_Out MACRO S, nocrlf
	LOCAL	Str_Off
IF DEBLEVEL GT DEBLEVELRETAIL
_LDATA SEGMENT
Str_Off db	S
IFB <nocrlf>
	db	0dh,0ah
ENDIF
	db	0
_LDATA ENDS

	pushfd
	pushad
	mov	esi, OFFSET32 Str_Off
	VMMCall Out_Mono_String
	popad
	popfd
ENDIF
	ENDM








Mono_Out_At MACRO Row, Col, S, nocrlf
	LOCAL	Str_Off
IF DEBLEVEL GT DEBLEVELRETAIL
_LDATA SEGMENT
Str_Off db	S
IFB <nocrlf>
	db	0dh,0ah
ENDIF
	db	0
_LDATA ENDS

	pushfd
	pushad
	mov	dx, (Row SHL 8)+Col
	VMMCall Set_Mono_Cur_Pos
	mov	esi, OFFSET32 Str_Off
	VMMCall Out_Mono_String
	popad
	popfd
ENDIF
	ENDM










Assert_Ints_Disabled MACRO DL

IFB <DL>
	??_debLevel = DEBLEVELNORMAL
ELSE
	??_debLevel = DL
ENDIF

IF DEBLEVEL GE ??_debLevel

ifndef ??_aidMessage
	_LDATA segment
	??_aidMessage	db	"ERROR:  Ints enabled at Assert_Ints_Disabled"
			db	0Dh, 0Ah, 0
	_LDATA ends
endif
	pushfd
	test	byte ptr [esp+1], IF_Mask SHR 8
    .if	!ZERO?
	push	OFFSET32 ??_aidMessage
	VMMCall _Debug_Out_Service
    .endif
	popfd
ENDIF
	ENDM








Assert_Ints_Enabled MACRO DL

IFB <DL>
	??_debLevel = DEBLEVELNORMAL
ELSE
	??_debLevel = DL
ENDIF

IF DEBLEVEL GE ??_debLevel

ifndef ??_aieMessage
	_LDATA segment
	??_aieMessage	db	"ERROR:  Ints disabled at Assert_Ints_Enabled"
			db	0Dh, 0Ah, 0
	_LDATA ends
endif
	pushfd
	test	byte ptr [esp+1], IF_Mask SHR 8
    .if	ZERO?
	push	OFFSET32 ??_aieMessage
	VMMCall _Debug_Out_Service
    .endif
	popfd
ENDIF
	ENDM

















Assert_Cur_VM_Handle MACRO R, DL
	LOCAL	OK
	LOCAL myDebLevel

IF DEBLEVEL GT DEBLEVELRETAIL

IFB <DL>
	myDebLevel = DEBLEVELNORMAL
ELSE
	myDebLevel = DL
ENDIF

IF DEBLEVEL GE myDebLevel

IFDIFI <ebx>,<R>
	push	ebx
	mov	ebx, R
ENDIF
	VMMCall Debug_Test_Cur_VM
IFDIFI <ebx>,<R>
	pop	ebx
ENDIF

ENDIF

ENDIF
	ENDM


Assert_Client_Ptr MACRO Reg, DL
	LOCAL myDebLevel
IF DEBLEVEL GT DEBLEVELRETAIL

IFB <DL>
	myDebLevel = DEBLEVELNORMAL
ELSE
	myDebLevel = DL
ENDIF

IF DEBLEVEL GE myDebLevel
IFDIFI <ebp>,<Reg>
	push	ebp
	mov	ebp, Reg
ENDIF
	VMMCall Validate_Client_Ptr
IFDIFI <ebp>,<Reg>
	pop	ebp
ENDIF
ENDIF

ENDIF
	ENDM

endif























irp	cond,<s,c,a,ae,b,be,e,z,g,ge,l,le,o>

TRAP&cond &macro
	?trap	jn&cond
	&endm

TRAPn&cond &macro
	?trap	j&cond
	&endm

TRAPFATAL&cond &macro
	?trap	jn&cond, FATAL
	&endm

TRAPFATALn&cond &macro
	?trap	j&cond, FATAL
	&endm
endm

TRAP	macro
if DEBLEVEL GT DEBLEVELRETAIL
	int	3
endif
	endm

TRAPFATAL	macro
	local	l
if DEBLEVEL GT DEBLEVELRETAIL
l:	int	3
	jmp	short l
endif
	endm

TRAPecxz macro
	local	l1,l2
if DEBLEVEL GT DEBLEVELRETAIL
	jecxz	l1
	jmp	short l2
l1:	int	3
l2:
endif
	endm

TRAPecxnz macro
	?trap	jecxz
	endm

?trap	macro	jmpop, fatal
	Local	l, n
if DEBLEVEL GT DEBLEVELRETAIL
	jmpop	short n
l:	int	3
ifnb	<fatal>
	jmp	short l
endif
n:
endif
	endm

ifndef Not_VxD




Dump_Struc_Head MACRO
if DEBLEVEL GT DEBLEVELRETAIL
	Trace_Out "  Base    Address   Offs     Value  Field name"
ENDIF
	ENDM

Dump_Struc MACRO Base, X
if DEBLEVEL GT DEBLEVELRETAIL
	pushfd
	pushad
	lea	esi, [Base]
	mov	ecx, X
	lea	edx, [esi+ecx]

IF SIZE X EQ 6
	mov	bx, WORD PTR [edx+4]
	mov	eax, DWORD PTR [edx]
	Trace_Out "#ESI  #EDX  #CX  #BX:#EAX  &X"
ELSE
IF SIZE X EQ 4
	mov	eax, DWORD PTR [edx]
	Trace_Out "#ESI  #EDX  #CX  #EAX  &X"
ELSE
IF SIZE X EQ 2
	mov	ax, WORD PTR [edx]
	Trace_Out "#ESI  #EDX  #CX      #AX  &X"
ELSE
	mov	al, BYTE PTR [edx]
	Trace_Out "#ESI  #EDX  #CX        #AL  &X"
ENDIF
ENDIF
ENDIF

	popad
	popfd
ENDIF
	ENDM

BeginDoc



























EndDoc

Begin_Touch_1st_Meg MACRO DL
	LOCAL myDebLevel
IF DEBLEVEL GT DEBLEVELRETAIL
IFB <DL>
	myDebLevel = DEBLEVELMAX
ELSE
	myDebLevel = DL
ENDIF
IF DEBLEVEL GE myDebLevel
	VMMCall Enable_Touch_1st_Meg
ENDIF
ENDIF
	ENDM



End_Touch_1st_Meg MACRO DL
	LOCAL myDebLevel
IF DEBLEVEL GT DEBLEVELRETAIL
IFB <DL>
	myDebLevel = DEBLEVELMAX
ELSE
	myDebLevel = DL
ENDIF
IF DEBLEVEL GE myDebLevel
	VMMCall Disable_Touch_1st_Meg
ENDIF
ENDIF
	ENDM

endif

IFDEF	DEBUG
TrashThis Macro	l:vararg
    ?TrashThisVal equ <0FFFFFF80h>
    ?TrashThisValSet = 0
    for r, <l>
	or	r, ?TrashThisVal
      ife ?TrashThisValSet
        if (OPATTR r) and 10h
	    ?TrashThisVal equ <r>
	    ?TrashThisValSet = 1
	endif
      endif
    endm
endm
ELSE
TrashThis Macro	l:vararg
endm
ENDIF


ifndef Not_VxD

if DEBLEVEL GT DEBLEVELRETAIL

ENTER_NOBLOCK MACRO
	push	DFS_ENTER_NOBLOCK
	VMMCall _Debug_Flags_Service
	ENDM

EXIT_NOBLOCK MACRO
	push	DFS_EXIT_NOBLOCK
	VMMCall _Debug_Flags_Service
	ENDM

Assert_CLD MACRO
	pushfd
	test	dword ptr [esp], DF_MASK
	Debug_OutNZ "Direction flag is not clear."
	popfd
	ENDM

Assert_Might_Block MACRO
	push	DFS_TEST_BLOCK
	VMMCall _Debug_Flags_Service
	ENDM

Assert_Not_Nest_Exec MACRO
	push	DFS_TEST_NEST_EXEC
	VMMCall _Debug_Flags_Service
	ENDM

ELSE

ENTER_NOBLOCK EQU <>
EXIT_NOBLOCK EQU <>
Assert_CLD EQU <>
Assert_Might_Block EQU <>
Assert_Not_Nest_Exec EQU <>

ENDIF


ifdef Begin_Service_Table
Begin_Service_Table DEBUG
DEBUG_Service	 DEBUG_Get_Version, LOCAL
DEBUG_Service	 DEBUG_Fault, LOCAL
DEBUG_Service	 DEBUG_CheckFault, LOCAL
DEBUG_Service	 _DEBUG_LoadSyms
End_Service_Table DEBUG
endif
endif
