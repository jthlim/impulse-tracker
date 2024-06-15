;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ EMS Module                                                                  ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

include switch.inc

; Memory structure for patterns:
;  Memory Block Header
;  Memory data
;
; Block Header
; Offset 0:     DWord - Number of bytes in block (not including header)
; Offset 4:     Word - Segment of last block, 0 if first
; Offset 6:     Word - Segment of next block, 0 if last
; Offset 8:     Byte - 0 = Unused, 1 = Used
; Offset 9-0Fh: Not used
; Offset 10h    Data

                        Jumps
                        .386

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Externals                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Segment         Object1 BYTE Public 'Data'
                Extrn   EMSErrorValue:Word
                Extrn   EMSErrorValue2:Word
                Extrn   EMSErrorValue3:Word
                Extrn   EMSErrorValue4:Word
                Extrn   EMSErrorValue5:Word
                Extrn   EMSErrorValue6:Word
                Extrn   EMSErrorValue7:Word
                Extrn   EMSErrorValue8:Word
EndS

                Extrn   M_Object1List:Far

                Extrn   O1_EMSWarningMessage

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Globals                                                                     ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                Global  E_AllocateEMS:Far
                Global  E_InitEMS:Far
                Global  E_UnInitEMS:Far
                Global  E_GetFreeEMS:Far
                Global  E_ReleaseEMS:Far
                Global  E_MapEMSMemory:Far, E_MapAvailableEMSMemory:Far
                Global  E_GetEMSPageFrame:Far
                Global  E_EMSAvailable:Far
                Global  E_SaveEMSPageFrame:Far
                Global  E_RestoreEMSPageFrame:Far
                Global  E_AllocateBlockEMS:Far, E_ReleaseBlockEMS:Far
                Global  E_MapAlignedBlockEMS:Far
                Global  E_GetEMSVersion:Far
                Global  E_GetInternalEMSHandle:Far

IF EMSDEBUG

                Global  E_DumpEMSMemory:Far

ENDIF

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment                 EMS WORD Public 'Code' USE16
                        Assume CS:EMS, DS:Nothing

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Variables                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CREATENEWLOGFILE        EQU     0
include debug.inc

EMSDetectString         DB      "EMMXXXX0"      ; Identification string
EMSHandlesRemaining     DW      0
EMSAvailable            DW      0               ; Assume that it's not avail.
EMSPageFrame            DW      0
EMSHandle               DW      0
EMSVersion              DB      0
                        DB      0

IF EMSDEBUG

EMSDumpName             DB      "EMSDump", 0

ENDIF

EMSCorrespondenceList   Label   Word
        Page0   DB      0, 0
                DW      0
        Page1   DB      0, 0
                DW      1
        Page2   DB      0, 0
                DW      2
        Page3   DB      0, 0
                DW      3

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Functions                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Proc            E_InitEMS Far

                Push    DS
                Push    ES

                Trace   " - Determining EMS presence"

                Xor     AX, AX
                Mov     DS, AX

                Mov     AX, [DS:019Eh]  ; Get interrupt vector for Int 67h
                And     AX, AX          ; Is Segment = 0?
                JZ      E_InitEMS1

                Mov     ES, AX
                Mov     DI, 0Ah         ; Offset into driver of identification string

                Push    CS
                Pop     DS
                        Assume DS:EMS

                Mov     SI, Offset EMSDetectString

                Mov     CX, 8/2

                RepE    CmpsW
                JNE     E_InitEMS1
                                        ; EMM driver is present

                Mov     AH, 40h         ; Get manager status
                Int     67h             ; Returns AH=0 -> no error
                And     AH, AH
                JNZ     E_InitEMS1

                Trace   " - Determining EMS Page Frame"

                Mov     AH, 41h         ; Get page frame segment
                Int     67h             ; AH if successful, with BX=segment
                And     AH, AH
                JNZ     E_InitEMS1

                Mov     EMSPageFrame, BX

                Trace   " - Determining EMS Version"

                Mov     AH, 46h         ; Get EMS version
                Int     67h
                Test    AH, AH
                JNZ     E_InitEMS1

                Mov     EMSVersion, AL

                Trace   " - Allocating EMS block"

                Mov     AH, 43h
                Mov     BX, 8
                Int     67h

                Test    AH, AH
                JNZ     E_InitEMS1

                Mov     EMSHandle, DX

                Mov     AX, 4400h
                Xor     BX, BX
                Int     67h             ; Map first page

                Mov     ES, EMSPageFrame
                Xor     DI, DI
                Mov     EAX, 8*16*1024-16
                StosD                   ; Amount of memory free
                Xor     EAX, EAX        ; No previous block, no next block
                StosD
                Xor     AX, AX          ; Unused block
                StosW

                Mov     EMSAvailable, 1

                                        ; OK.. now to get number of EMS
                                        ; handles available..

                Trace   " - Determining number of free EMS handles"

                Cmp     EMSVersion, 40h
                JB      E_InitEMSBelow4

                Mov     AX, 5402h
                Int     67h             ; BX = total number of pages.
                Test    AH, AH
                JNZ     E_InitEMSBelow4

                Mov     DX, BX

                Mov     AH, 4Bh
                Int     67h

                Test    AH, AH
                JNZ     E_InitEMSBelow4

                Sub     DX, BX
                Mov     EMSHandlesRemaining, DX

                Jmp     E_InitEMS1

E_InitEMSBelow4:

                Mov     CX, 256         ; Allocate 256 MAX

E_InitEMS2:
                Mov     AH, 43h
                Mov     BX, 1
                Int     67h

                Test    AH, AH
                JNZ     E_InitEMS3

                Inc     EMSHandlesRemaining
                Push    DX
                Loop    E_InitEMS2

E_InitEMS3:
                Mov     CX, EMSHandlesRemaining      ; Now to dealloc them

                Test    CX, CX
E_InitEMS4:
                JZ      E_InitEMS1

                Mov     AH, 45h
                Pop     DX
                Int     67h

                Dec     CX
                Jmp     E_InitEMS4

E_InitEMS1:
                Pop     ES
                Pop     DS
                Ret

EndP            E_InitEMS
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            E_GetFreeEMS Far        ; Returns kb free..

                Push    BX
                Push    DX

                Cmp     EMSAvailable, 0
                JE      E_GetFreeEMS2           ; No EMM driver?

                Mov     AH, 42h                 ; Get page counts
                Int     67h

                And     AH, AH                  ; AH=0 -> no error
                JNZ     E_GetFreeEMS2           ; BX = free pages

                Mov     AX, BX
                ShL     AX, 4

                Jmp     E_GetFreeEMS1

E_GetFreeEMS2:
                Xor     AX, AX

E_GetFreeEMS1:
                Pop     DX
                Pop     BX
                Ret

EndP            E_GetFreeEMS

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            E_ReleaseEMS Far                ; AX = handle.

                Push    AX
                Push    DX

                Mov     DX, AX
                Mov     AH, 45h                 ; Deallocate memory.
                Int     67h

                And     AH, AH                  ; AH = 0 -> no error
                JZ      E_ReleaseEMS1

                Call    EMSWarning

E_ReleaseEMS1:
                Inc     CS:EMSHandlesRemaining

                Pop     DX
                Pop     AX

                Ret

EndP            E_ReleaseEMS

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            EMSWarning

                PushAD
                Push    DS
                Push    ES

                Mov     BX, Object1
                Mov     DS, BX
                        Assume DS:Object1

                Mov     Byte Ptr EMSErrorValue, AH
                Mov     EMSErrorValue2, CX
                Mov     EMSErrorValue3, DX

                Mov     AX, Word Ptr CS:EMSVersion
                Mov     EMSErrorValue8, AX

                Mov     AL, CS:Page0
                Mov     Byte Ptr EMSErrorValue4, AL

                Mov     AL, CS:Page1
                Mov     Byte Ptr EMSErrorValue5, AL

                Mov     AL, CS:Page2
                Mov     Byte Ptr EMSErrorValue6, AL

                Mov     AL, CS:Page3
                Mov     Byte Ptr EMSErrorValue7, AL

                Mov     DI, Offset O1_EMSWarningMessage
                Mov     CX, 2
                Call    M_Object1List

                Pop     ES
                Pop     DS
                PopAD

                Ret

EndP            EMSWarning
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            E_MapAvailableEMSMemory Far
                                        ; AX = handle.

                Push    AX BX DX

                Mov     DX, AX

                Xor     AL, AL
                Xor     BX, BX

E_MapAvailableEMSMemory1:
                Mov     AH, 44h
                Int     67h
                Test    AH, AH
                JNZ     E_MapAvailableEMSMemory2

                Inc     AX
                Inc     BX

                Cmp     AL, 3
                JBE     E_MapAvailableEMSMemory1

E_MapAvailableEMSMemory2:
                Pop     DX BX AX

                Ret

EndP            E_MapAvailableEMSMemory

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            E_MapEMSMemory Far      ; CL = total pages in handle
                                        ; CH = starting (base) page.
                                        ; DX = handle

                Push    AX
                Push    BX
                Push    CX

                Sub     CL, CH
                JBE     E_MapEMSMemory002

                Cmp     CL, 4
                JB      E_MapEMSMemory003

                Mov     CL, 4

E_MapEMSMemory003:

IF EMSUSE41
                Cmp     CS:EMSVersion, 40h
                JAE     E_MapEMSMemoryV4_1
ENDIF

                Xor     BX, BX

E_MapEMSMemory001:
                Mov     AL, CL
                Dec     AX
                Mov     BL, AL
                Add     BL, CH
                Mov     AH, 44h
                Int     67h

                And     AH, AH
                JNZ     E_MapEMSMemory004

                Dec     CL
                JNZ     E_MapEMSMemory001
                Jmp     E_MapEMSMemory002

IF EMSUSE41

E_MapEMSMemoryV4_1:
                Push    DS
                Push    SI
                PushF

                CLI

                Push    CS
                Pop     DS
                        Assume DS:EMS

                Mov     Page0, CH
                Inc     CH
                Mov     Page1, CH
                Inc     CH
                Mov     Page2, CH
                Inc     CH
                Mov     Page3, CH

                Mov     AX, 5000h
                Xor     CH, CH
                Mov     SI, Offset EMSCorrespondenceList
                Int     67h

                PopF
                Pop     SI
                Pop     DS
                        Assume DS:Nothing

                Test    AH, AH
                JZ      E_MapEMSMemory002

ENDIF

E_MapEMSMemory004:
;                Call    EMSWarning

E_MapEMSMemory002:
                Pop     CX
                Pop     BX
                Pop     AX

E_MapEMSMemoryExit:
                Ret

EndP            E_MapEMSMemory

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            E_UnInitEMS Far

                Cmp     EMSAvailable, 0
                JE      E_UnInitEMS1

                Mov     AX, EMSHandle
                Call    E_ReleaseEMS

E_UnInitEMS1:
                Ret

EndP            E_UnInitEMS

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            E_GetEMSPageFrame Far

                Mov     AX, CS:EMSPageFrame
                Ret

EndP            E_GetEMSPageFrame

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            E_MapAlignedBlockEMS Far        ; Given AX, Return DS:SI

                Push    CX DX

                Mov     SI, AX
                Mov     CX, AX
                ShL     SI, 4
                Mov     CL, 8
                ShR     CH, 2
                And     SI, 03FFFh

                Mov     DX, CS:EMSHandle
                Call    E_MapEMSMemory

                Mov     DS, CS:EMSPageFrame

                Pop     DX CX

                Ret

EndP            E_MapAlignedBlockEMS

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            E_AllocateBlockEMS Far          ; EAX = number of bytes
                                                ; Destroys EMS page frame
                                                ; Returns AX = segment address
                                                ; Carry set if fail, clear if
                                                ; successful

                ClI
                Push    EBX ECX EDX ESI EDI DS ES

                Cmp     CS:EMSAvailable, 0
                JE      AllocateBlockQuitError

                Mov     ESI, EAX
                Add     ESI, 0Fh
                And     ESI, Not 0Fh

                Mov     DS, CS:EMSPageFrame
                Xor     EDI, EDI        ; EDI = current offset

                Mov     CX, 0008h       ; Starting page = 0, Max page = 8

AllocateBlockEMS2:
                Mov     DX, CS:EMSHandle
                Call    E_MapEMSMemory

AllocateBlockEMS1:
                Cmp     Byte Ptr [DI+8], 0      ; Used?
                JNE     AllocateBlockEMSNext

                Cmp     ESI, [DI]
                JA      AllocateBlockEMSNext

                Mov     AX, DI
                And     AX, 3FFFh
                Add     AX, SI
                JC      AllocateBlockQuitError  ; Can't fit it in!

; OK. this block will do
                Mov     Byte Ptr [DI+8], 1      ; This block used

                Mov     EBX, [DI]               ; Size of block
                Mov     [DI], ESI               ; New size of this block

                Mov     EAX, [DI+4]             ; To get next in HEAX
                Mov     ECX, EDI                ; ECX = Current offset
                ShR     ECX, 4                  ; ECX = Segment reference
                Mov     AX, CX                  ; AX = segment, HEAX = next seg

                Sub     EBX, ESI                ; Bytes in next block
                JZ      AllocateBlockPerfectEnd
                Sub     EBX, 16

                LEA     ESI, [ESI+EDI+16]       ; ESI = position of split block
                Push    ESI
                ShR     ESI, 4                  ; SI = segment of split block
                Mov     [DI+6], SI              ; Store pointer to next block
                Pop     EDI                     ; EDI = position of split block

                Mov     ECX, EDI                ; ECX = position of split block
                ShR     ECX, 6
                And     CH, Not 3
                Mov     CL, 8
                Call    E_MapEMSMemory

                Mov     [DI], EBX               ; bytes in block
                Mov     [DI+4], EAX             ; Last block & Next block
                Mov     Byte Ptr [DI+8], 0      ; Unused block

                Push    AX
                Mov     AX, [DI+6]

                Test    AX, AX
                JZ      NoNextBlockSplit

                Call    E_MapAlignedBlockEMS    ; DS:SI Pointing to next
                ShR     EDI, 4
                Mov     [SI+4], DI

NoNextBlockSplit:
                Pop     AX

                ClC
                Jmp     AllocateBlockQuit

AllocateBlockPerfectEnd:
;                Mov     Word Ptr [DI+6], 0      ; Last block.
                ClC
                Jmp     AllocateBlockQuit

AllocateBlockEMSNext:
                Mov     CX, [DI+6]              ; Next segment
                And     ECX, 0FFFFh
                JZ      AllocateBlockQuitError

; Check EDI and ECX for the same frame.. if the same, then skip updating (E)DI
; and only update DI

                ShLD    EAX, EDI, 16    ; AL = 64k frame
                Mov     EDI, ECX
                ShR     CH, 4
                ShL     EDI, 4

                Cmp     AL, CH
                JE      AllocateBlockEMS1

                ShL     CH, 2
                Mov     CL, 8
                Jmp     AllocateBlockEMS2

AllocateBlockQuitError:
                StC

AllocateBlockQuit:
                Pop     ES DS EDI ESI EDX ECX EBX
                StI
                Ret

EndP            E_AllocateBlockEMS

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            E_ReleaseBlockEMS Far           ; Given AX = 'segment'.

                ClI
                Push    EAX EBX DS SI

                Mov     BX, AX                  ; BX = current segment
                Call    E_MapAlignedBlockEMS
                ; DS:SI points to structure.

                Mov     Byte Ptr [DS:SI+8], 0   ; This block unused.

; Release later block first, if possible

                Mov     AX, [DS:SI+6]
                Test    AX, AX
                JZ      E_ReleaseBlockEMSNoneAfter      ; Nope, this is the
                                                        ; last block.
                Call    E_MapAlignedBlockEMS            ; OK, DS:0 points to next block
                Mov     EAX, [DS:SI+4]                  ; HEAX = next block, AX = last block
                Mov     EBX, [DS:SI]                    ; Free memory
                Cmp     Byte Ptr [DS:SI+8], 0           ; Used?
                JNE     E_ReleaseBlockAfterEnd

                Call    E_MapAlignedBlockEMS
                Add     EBX, 16
                Add     [DS:SI], EBX

                Push    AX
                Mov     AX, [DS:SI+4]
                Mov     [DS:SI+4], EAX
                Pop     AX

                Jmp     E_ReleaseBlockEMSBefore

E_ReleaseBlockAfterEnd:
                Call    E_MapAlignedBlockEMS
                Jmp     E_ReleaseBlockEMSBefore

E_ReleaseBlockEMSNoneAfter:
                Mov     AX, BX

E_ReleaseBlockEMSBefore:
                Test    AX, AX
                JZ      E_ReleaseBlockFinished

                Mov     EAX, [DS:SI+4]
                Mov     EBX, [DS:SI]
                Call    E_MapAlignedBlockEMS

                Cmp     Byte Ptr [DS:SI+8], 0
                JNE     E_ReleaseBlockPreviousFailed

                Push    AX

                Mov     AX, [DS:SI+4]           ; Last field
                Mov     [DS:SI+4], EAX          ; Next field written
                Add     EBX, 16
                Add     [DS:SI], EBX

                Pop     AX
                Jmp     E_ReleaseBlockFinished

E_ReleaseBlockPreviousFailed:
                Mov     AX, [DS:SI+6]

E_ReleaseBlockFinished:
                Mov     BX, AX
                Call    E_MapAlignedBlockEMS    ; DS:SI points to 'base' block
                Mov     AX, [SI+6]              ; Next

                Test    AX, AX
                JZ      E_ReleaseBlockCleanup

                Call    E_MapAlignedblockEMS
                Mov     [SI+4], BX

E_ReleaseBlockCleanup:

                Pop     SI DS EBX EAX
                StI
                Ret

EndP            E_ReleaseBlockEMS

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            E_AllocateEMS Far               ; EAX = number of bytes
                                                ; Returns AX with handle
                                                ;  0 if no handle allocated
                                                ; given carry = essential
                                                ;    no carry = spare EMS

                Push    EBX
                Push    ECX
                Push    EDX

                Mov     DX, CS:EMSHandlesRemaining
                JC      E_AllocateEMS3

                Cmp     DX, 10
                JB      E_AllocateEMS2

E_AllocateEMS3:
                Test    DX, DX
                JZ      E_AllocateEMS1

                Cmp     CS:EMSAvailable, 0
                JE      E_AllocateEMS2

                Mov     EBX, EAX
                Add     EBX, 16*1024-1
                SHR     EBX, 14

                Mov     AH, 43h
                Int     67h
                Test    AH, AH
                JNZ     E_AllocateEMS2

                Dec     CS:EMSHandlesRemaining
                Jmp     E_AllocateEMS1

E_AllocateEMS2:
                Xor     DX, DX

E_AllocateEMS1:
                Mov     AX, DX

                Pop     EDX
                Pop     ECX
                Pop     EBX
                Ret

EndP            E_AllocateEMS

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            E_EMSAvailable Far            ; Returns Zero flag set if no EMS

                Cmp     CS:EMSAvailable, 0
                Ret

EndP            E_EMSAvailable

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Comment ~

Proc            E_SavePageFrame Far             ; Given DX = Handle
Public          E_SavePageFrame

                Push    AX
                Push    DX

                Mov     AH, 47h
                Int     67h
                Test    AH, AH
                JZ      E_SavePageFrame1

                Call    EMSWarning

E_SavePageFrame1:
                Pop     DX
                Pop     AX

                Ret

EndP            E_SavePageFrame

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            E_RestorePageFrame Far          ; Given DX = Handle
Public          E_RestorePageFrame

                Push    AX
                Push    DX

                Mov     AH, 48h
                Int     67h
                Test    AH, AH
                JZ      E_RestorePageFrame1

                Call    EMSWarning

E_RestorePageFrame1:
                Pop     DX
                Pop     AX

                Ret

EndP            E_RestorePageFrame

~

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            E_SaveEMSPageFrame Far

                Cmp     CS:EMSAvailable, 0
                JE      E_SaveEMSPageFrame1

                Push    AX
                Push    DX

                Mov     DX, CS:EMSHandle
                Mov     AH, 47h
                Int     67h

;                Cmp     AH, 1

;                Test    AH, AH
;                JZ      E_SaveEMSPageFrame2

;                Call    EMSWarning

                And     AH, AH
                JZ      E_SaveEMSPageFrame2

                StC

E_SaveEMSPageFrame2:
                Pop     DX
                Pop     AX

E_SaveEMSPageFrame1:
                Ret

EndP            E_SaveEMSPageFrame

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            E_RestoreEMSPageFrame Far

                Cmp     CS:EMSAvailable, 0
                JE      E_RestoreEMSPageFrame1

                Push    AX
                Push    DX

                Mov     DX, EMSHandle
                Mov     AH, 48h
                Int     67h

                Pop     DX
                Pop     AX

E_RestoreEMSPageFrame1:
                Ret

EndP            E_RestoreEMSPageFrame

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            E_GetEMSVersion Far

                Mov     AL, CS:EMSVersion
                Ret

EndP            E_GetEMSVersion

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            E_GetInternalEMSHandle Far

                Mov     AX, CS:EMSHandle
                Ret

EndP            E_GetInternalEMSHandle

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

IF EMSDEBUG

Proc            E_DumpEMSMemory Far

                Push    CS
                Pop     DS
                        Assume DS:EMS

                Mov     AH, 3Ch
                Xor     CX, CX
                Mov     DX, Offset EMSDumpName
                Int     21h

                Mov     BX, AX

                Mov     CX, 8
                Mov     DX, EMSHandle
                Call    E_MapEMSMemory

                Mov     AH, 40h
                Mov     CX, 32768
                Mov     DS, EMSPageFrame
                Xor     DX, DX
                Int     21h

                Mov     AH, 40h
                Mov     DX, 32768
                Mov     CX, DX
                Int     21h

                Mov     CX, 408h
                Mov     DX, CS:EMSHandle
                Call    E_MapEMSMemory

                Mov     AH, 40h
                Mov     CX, 32768
                Xor     DX, DX
                Int     21h

                Mov     AH, 40h
                Mov     DX, 32768
                Mov     CX, DX
                Int     21h

                Mov     AH, 3Eh
                Int     21h

                Xor     AX, AX
                Ret

EndP            E_DumpEMSMemory
                Assume DS:Nothing

ENDIF

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

EndS

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

End
