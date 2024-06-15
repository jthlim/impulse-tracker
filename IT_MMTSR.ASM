;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ MMTSR Module                                                                ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                        .386

include switch.inc

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Externals                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                Extrn   E_AllocateEMS:Far
                Extrn   E_GetEMSPageFrame:Far
                Extrn   E_ReleaseEMS:Far
                Extrn   E_MapEMSMemory:Far
                Extrn   Music_Stop:Far

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Globals                                                                     ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                Global  MMTSR_InstallMMTSR:Far
                Global  MMTSR_UninstallMMTSR:Far

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment                 MMTSR PARA Public USE16 'Code'
                        Assume CS:MMTSR, DS:MMTSR

CREATENEWLOGFILE        EQU     0
include debug.inc

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Variables                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MAX8            equ     0f8H    ; decompression constants
MAX16           equ     0fff0h

BBsize          equ     0       ; stucture of MMCMP BigBlocks header
BBcmpsize       equ     4       ; (relative offset)
BBxorchk        equ     8
BBnblk          equ     12
BBflag          equ     14
BBntab          equ     16
BBsnbit         equ     18
BBheadersize    equ     20

InstalledFromIT DB      0

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Functions                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Proc    MMTSR_InstallMMTSR Far

        Push    CS
        Push    CS
        Pop     DS
        Pop     ES

        Trace   " - Determining if MMTSR is already installed"

        mov     ax,4370h
        int     21h             ; check if already installed

        cmp     eax,4352697ah
        je      @error          ; if installed, don't install it again

@notinstalled:
        Trace   " - Allocating 64kb of EMS memory for MMTSR decoding"

        StC
        Mov     EAX, 65536      ; 64k
        Call    E_AllocateEMS

        Test    AX, AX
        JZ      @error          ; AX = handle, 0 if error.

@emsdriver:
        Mov     _memhandle, AX
        Call    E_GetEMSPageFrame
        Mov     BaseSeg, AX

@fixups:
        Trace   " - Installing new INT21h handler"

        mov     si,offset _inbuf+2
        mov     [si],ax
        mov     dx,Bufsize
        shr     dx,4
        add     ax,dx
        mov     [si+4],ax
        add     ax,20h
        mov     [si+8],ax
        add     ax,110h
        mov     [si+12],ax
        add     ax,dx
        mov     [si+16],ax

        mov     ax,3521h
        int     21h
        mov     word ptr [_old21],bx      ; get old INT 21h handler
        mov     word ptr [_old21+2],es
        mov     dx,offset @new21
        mov     ax,2521h
        int     21h                                      ;  set new INT 21h handler

        mov     byte ptr [_actived],1           ; MMTSR is ACTIVE!

        Mov     InstalledFromIT, 1

@error:
@error0:                                        ; print message at offset DS:DX onto screen
        Ret

EndP            MMTSR_InstallMMTSR

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Proc            MMTSR_UninstallMMTSR Far

                Push    CS
                Pop     DS

                Cmp     InstalledFromIT, 0
                JE      MMTSR_UninstallMMTSR1

                Mov     DX, Word Ptr [_old21]            ; Reset handler.
                Mov     DS, Word Ptr [_old21+2]
                Mov     AX, 2521h
                Int     21h

                Mov     AX, CS:_memhandle
                Call    E_ReleaseEMS

MMTSR_UninstallMMTSR1:
                Ret

EndP            MMTSR_UninstallMMTSR

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ


;****************************************************************************
;   					  NEW INTERRUPT 21 HANDLER
;****************************************************************************

@activate:
	and	al,1
	mov	byte ptr cs:[_actived],al
        IRet

@installcheck:
	mov	eax,4352697ah
	iret
@new21:				; <<<<---------- INT 21 starts here
	cmp	ax,4370h
	je	short @installcheck
	cmp	ax,4371h
	je	short @activate
	cmp	ax,4372h
	je	short @activate
	cmp	byte ptr cs:[_actived],1
        jne     short @noopen          ; originaly intercepts 'open' only...
        cmp     ah,3dh                 ; now stands for 'do old interrupt'
	je	short @intercept
        cmp     ah,3eh                 ; MMTSR intercepts 'open file' calls, and
        jne     short @noopen          ; close file if the handle is the
        cmp     bx,cs:_modulehandle    ; temporary decompressed module handle
	je	short @intercept

@noopen:
        jmp     dword ptr cs:[_old21]  ; Chain to old interrupt

@intercept:
        mov     byte ptr cs:[_actived],0      ; desactivate MMTSR while running
	mov	byte ptr cs:[_function],ah
        mov     word ptr cs:[_oldstack],sp    ; une hook's stack
        mov     word ptr cs:[_oldstack+2],ss

        pushf

        Call    DWord Ptr [CS:_old21]

        push    es bx ax
	les	bx,cs:[_oldstack]	;
	pushf				;
        pushf                           ; preserve "returned from interrupt" flags
        pop     ax                      ;   and set IF!! ;)
        or      ah,2                    ;
        mov     word ptr es:[bx+4],ax   ;
        popf                            ; "or" modifies flags...
	pop	ax bx es          	;
        jc      @eoi                    ; I/O error
	cmp	cs:[_function],3dh
	je	short @open

	; close temporary file and delete it
@close:
	cmp	byte ptr cs:_openedfile,1
	jne	@eoi
	pusha
	push	ds
	mov	ax,cs
	mov	ds,ax
	mov	dx,offset _tempfile
	mov	ah,41h
	int	21h
	pop	ds
	popa
	mov	word ptr cs:[_modulehandle],0
	mov	byte ptr cs:[_openedfile],0
	jmp	@eoi

	; open file, create the temporary one, decompress, etc....
@open:
	mov	word ptr cs:[_cmphandle],ax
	pushad
	push	ds
	push	es
	push	fs
	push	gs

;----------------------------------------------------------------------------
;					all registers are preserved
;----------------------------------------------------------------------------
	mov	ax,cs
	mov	ds,ax
	mov	bp,sp

        mov     bx,[_cmphandle]
	mov	ax,4400h
	int	21h
	test	dx,0080h
        jne     @nochg          ; handle is a DEVICE handle, not a file!
	mov	bx,[_cmphandle]
	mov	cx,8
	mov	dx,OFFSET _signaturecheck
        mov     ah,03fh         ; read first 8 bytes of the opened file
        int     21h
	push	ax
	mov	bx,[_cmphandle]
        xor     edx,edx         ; reset file pointer to its beginning
	call	@lseek
	pop	ax
	cmp	ax,8
	jne	@nochg
        cmp     dword ptr _signaturecheck,4352697ah     ;
	jne	@nochg                  		; check for ziRCONia
	cmp	dword ptr [_signaturecheck+4],61694e4fh ;
	jne	@nochg					;

        Call    Music_Stop

@emsswap:
        mov     dx,_memhandle
        Mov     AH, 47h
        Int     67h

        Mov     CX, 4
        Call    E_MapEMSMemory

;------------------ we now have free mem to work ---------------------------
@afterswap:
        mov     ah,3ch                   ;
	mov	cx,20h                   ; create temporary file
	mov	dx,offset _tempfile      ;
	int	21h
	jc	@swapback
	mov	word ptr [_modulehandle],ax
	mov	byte ptr [_openedfile],1
	mov	bx,[_cmphandle]
	mov	edx,8
	call	@lseek
	push	16
	push	ds
	push	offset _filehead   	; read file header, 16 bytes minimum
	call	@read			; (as for now, 16 bytes max too....)
	add	sp,6
	mov	bx,[_cmphandle]
	mov	edx,_blockptr
	call	@lseek
	mov	ax,_blktoprocess
        shl     ax,2                     ; load the BigBlock offset table into
	push	ax                       ; memory
	push	dword ptr _blkoffset
	call @read
	add	sp,6
	mov	word ptr _curblock,0

@blockloop:
	les	di,_blkoffset
	add	di,_curblock
	add	word ptr _curblock,4
	mov	edx,es:[di]              ;
	mov	bx,_cmphandle            ; lseek to next BigBlock
	call	@lseek
	les	di,_BB				; es:0 -> current BB
	mov	di,BBheadersize
	push di
	push	dword ptr [_BB]          ; read the BB
	call	@read                    ;
	add	sp,6
        mov     ax,es:[BBnblk]           ; number of small block within BB
	shl	ax,3
	push	ax
	push	es
	push	di
        call    @read                    ; read all 'small blocks' info
        add     sp,6                     ; (dw offset, dw size) = 8 bytes each
        mov     dword ptr _curblkpos,0   ; offset 0 in the first small blk
	mov	al,es:[BBsnbit]
        mov     _snbit,al                ; snbit: compression info...
	test	word ptr es:[BBflag],1
        je      @notcompressed           ; if not compressed, why bother?

@compressed:
	push	word ptr es:[BBntab]
        push    dword ptr _ttabl      ; read translation table (cmp stuff...)
	call	@read
	add	sp,6
        movzx   eax,ax
        mov     esi,es:[BBcmpsize]    ; esi = toread (copmressed size)
        sub     esi,eax               ;       - trans table size
	xor	eax,eax
        mov     _lasteax,eax          ; _lastXXXX: since blocks may be larger
                                      ; than the buffer, small blocks may have
                                      ; to be decompressed in more than one shot.
                                      ; _lastXXX preserve current state of reg.

        mov     dword ptr _left,eax   ; changes also _lastsmp
	mov	byte ptr _lastch,al
	jmp	@compressloopend
@compressloop:
        movzx   eax,word ptr Bufsize
	sub	ax,_left
        cmp     esi,eax               ; read the most we can...
	jnb	short @readbuf
	mov	eax,esi
@readbuf:
	push	ax
	mov	eax,_inbuf
	add	ax,_left
	push	eax
	call	@read                   ; fill inbuf
	add	sp,6
        movzx   eax,ax
	sub	esi,eax
	add	ax,_left
	mov	_rd,ax				; _rd = number of bytes of data in inbuf
        test    word ptr es:[BBflag],4
	jne	short @16bits
	call	@Uncompbuf8   ; (inbuf, outbuf, &used) in DS
	mov	_towrite,ax
	call	@Translatebuf8	; (outbuf, towrite) in DS
	test	word ptr es:[BBflag],2
	je	short @nodelta8
	call	@Undeltabuf8; (outbuf, towrite, lastbyte) in DS
@nodelta8:
	mov	cl,8
	jmp	short @deltadone
@16bits:
	call @UncompBuf16	; for now, write function is ok even is we have a
	mov	_towrite,ax    ; 16 bits buffer with and odd length.
	call	@UndeltaBuf16	; (outbuf, towrite, lastbyte) in DS
	xor	cl,cl

@deltadone:
	lfs	bx,_outbuf
	add	bx,_towrite
	mov	ax,fs:[bx-2]
	shr	ax,cl
	mov	word ptr _lastsmp,ax	; keep the last sample for future 'undelta'
	mov	cx,_rd
	sub	cx,_used
	jnb	short @leftok
	xor	cx,cx
@leftok:
	mov	_left,cx   		; inbuf might not have been used up, some is left
	je	short @writeblock
	add	cx,3
	shr	cx,2
	push	ds es si di
	les	di,_inbuf
	mov	si,_used               ; copy unused part of inbuf to its bottom
	add	si,di
	mov	ds,word ptr [_inbuf+2]
	rep	movsd
	pop	di si es ds
@writeblock:
	call	@writeblk		; function to write blocks of data (see it...)
@compressloopend:
        movzx   eax,word ptr _left
	or	eax,esi			; is there something left to uncompress?
	jne	@compressloop
	jmp	short @blockloopend

	; this part simply copy the uncompressed buffer from the compressed
	; module to the temp uncompressed module
@notcompressed:
	mov	esi,es:[BBcmpsize]		; esi = toread
@continuenc:
	movzx eax,word ptr Bufsize
	cmp	esi,eax
	jnb	short @readubuf
	mov	ax,si
@readubuf:
	push	ax
	push	dword ptr _outbuf
	call	@read
	add	sp,6
	mov	_towrite,ax
	movzx eax,ax
	sub	esi,eax
	call	@writeblk
	or	esi,esi
	jne	short @continuenc

@blockloopend:
	dec	word ptr _blktoprocess		; BigBlocks loop end
	jne  @blockloop

; ----------------------------- done decompressing! -------------------------
	mov	bx,_modulehandle
	mov	ah,3eh
	int	21h		; close temp file to set file size correctly
	mov	dx,offset _tempfile
	mov	ax,3d00h
	int  21h		; reeopen it in read only for the Player/tracker
	mov	_modulehandle,bx
	mov	[bp+36],bx	; put handle in preserved register
	mov	ah,3eh
	mov	bx,_cmphandle
	int  21h

;------------------ swap back memory ---------------------------

@swapback:
@emsswapback:
	mov	ah,48h
	mov	dx,_memhandle
	int	67h

@swapbackdone:
;       pop     gs                              ; this part must be used to return
;       pop     fs                              ; after somthing has been done when
;       pop     es                              ; debugging.
;       pop     ds
;       popad
;       lss     sp,cs:[_oldstack]
;       mov     cs:byte ptr [_actived],1
;       iret
;----------------------------------------------------------------------------
;                                       restore all registers
;----------------------------------------------------------------------------
@nochg:
	pop	gs
	pop	fs
	pop	es
	pop	ds
	popad
@eoi:
;        lss     sp,cs:[_oldstack]
	mov	cs:byte ptr [_actived],1
	iret

;****************************************************************************
;   					       I/O ROUTINES
;****************************************************************************

	;	writes decompressed blocks of data at their respective offsets
	;	withing the temp module
	;	_towrite = lenght to write
	;    _curblkpos = current position relative to beginning of the current
	;				small block
@writeblk	proc	near
	push ebp
	push	si
	xor	si,si
	mov	ebp,_curblkpos
@writeloop:
	mov	edx,es:[di]
	add	edx,ebp
	mov	bx,_modulehandle
	call	@lseek
	mov	ecx,es:[di+4]
	sub	ecx,ebp
	xor	ebx,ebx
	mov	bx,_towrite
	cmp	ebx,ecx
	jnb	short @100
	mov	cx,bx
@100:push	cx
	mov	bx,_modulehandle
	mov	ah,40h
	push	ds
	lds	dx,_outbuf
	add	dx,si
	int	21h
	pop	ds
	pop	ax
	add	si,ax
	sub	_towrite,ax
	movzx eax,ax
	add	ebp,eax
	cmp	ebp,es:[di+4]
	jne	short @notblockend
	add	di,8
	dec	word ptr es:[BBnblk]
	xor	ebp,ebp
@notblockend:
        or      word ptr _towrite,0
	jz	short @writeend
	or	word ptr es:[BBnblk],0
	jnz	short @writeloop
@writeend:
	mov	_curblkpos,ebp
	pop	si
	pop	ebp
	ret
@writeblk	endp

	; this reads only from the compressed module!
@read	proc	near
	push bp

;        Mov     DX, _memhandle
;        Mov     CX, 4
;        Call    E_MapEMSMemory

        mov     bp,sp
	mov	bx,_cmphandle
	push	ds
	lds	dx,[bp+4]
	mov	cx,[bp+8]
	mov	ah,3fh
	int	21h
	pop	ds bp
	ret
@read	endp

@lseek	proc near
	shld	ecx,edx,16
	mov	ax,4200h
	int	21h
	ret
@lseek	endp

;****************************************************************************
;   					  ROUTINES TO UNCOMPRESS
;****************************************************************************

   ;	unsigned int Uncompress(char far *ib, char far *ob, word far *used)
@Uncompbuf8	proc near
	push	bp
	mov	bp,sp
	sub	sp,2
	push	si
	push	di
	push	fs
	push	es
	lfs	si,_inbuf
        les     di,_outbuf

	lea	ax,[di-100h]
	add	ax,Bufsize
	mov	[bp-2],ax

	mov	ch,_lastch   ; bit count in eax
	mov	eax,_lasteax ; eax : data
        mov     cl,_snbit    ; num of bit to use
	inc	cl
	xor	bh,bh
	xor	dx,dx
	jmp	short @017

@012:shrd	dx,ax,cl
	shr	eax,cl
        rol     dx,cl
	sub	ch,cl
	mov	bl,cl
@013:cmp	dl,[bx+_bchg8-1]
	jb 	short @016
	shl	bx,1
	jmp	word ptr [bx+_fct1-2]
@015c:and	dl,7					; 3 bits used
	jmp	short @011
@015b:and	dl,3					; 2 bits used, get highest bit
	shr	eax,1
	rcl	dl,1
	sub	ch,1
	jmp	short @011
@015a:and	dl,1					; 1 bit used, get 2 highest bits
	shl	dl,2
	shrd	dx,ax,2
	shr	eax,2
	rol  dx,2
	sub	ch,2
	jmp	short @011
@015:xor	dl,dl				; no bit used, get 3 bits
	shrd	dx,ax,3
	shr	eax,3
	rol  dx,3
	sub	ch,3
@011:shr	bx,1
	inc	dl
	cmp	cl,dl
	je	short @011a
	mov	cl,dl
	jmp	short @017
@011a:                        ; Special commands (254,255, end);
	mov	dl,al
	shr	eax,3
	sub	ch,3
	and  dl,7
	cmp	dl,7
	je	short @019	; maybe end-of-buf command
@016a:add	dl,MAX8
@016:mov  es:[di],dl		; Store uncompressed data
	inc	di
	cmp	di,[bp-2]
	je	short @019b
	xor	dl,dl
@017:cmp	ch,10H
	jnb	short @012
@018:xchg	cl,ch
	ror	eax,cl
	mov	ax,fs:[si]
	add	si,2
	rol	eax,cl
	add	cl,10H
	xchg	cl,ch
	jmp	@012
@019:dec	ch
	shr	eax,1
	jnc  @016a      ; no only a 255
@019b:
	mov	_lastch,ch
	mov	_lasteax,eax
	dec	cl
	mov	_snbit,cl
	sub	si,word ptr _inbuf
	mov	_used,si
	sub	di,word ptr _outbuf
	mov	ax,di
	pop	es
	pop	fs
	pop	di
	pop	si
	leave
	ret
@Uncompbuf8	endp

;	void UndeltaBuf8(void far *buf, unsigned int len, char lastbyte)
@UndeltaBuf8	proc near
	push ds
	mov	cx,_towrite
	add	cx,3
	and	cl,0fch
	mov	dl,byte ptr _lastsmp
	lds	bx,_outbuf
	add	cx,bx
@091:mov	eax,[bx]
	add	al,dl
	add	ah,al
	mov	dl,ah
	ror 	eax,16
	add	al,dl
	add	ah,al
	mov	dl,ah
	ror  eax,16
	mov	[bx],eax
	add	bx,4
	cmp	bx,cx
	jne  short @091
@092:pop	ds
	ret
@UndeltaBuf8	endp

;	void TranslateBuf8(char far *buf, unsigned int len)
@TranslateBuf8	proc near
	push	es
        push    ds
	push	si
	push	di
	mov	cx,_towrite
	add	cx,3
	shr	cx,2
	les	di,_outbuf
	lds	si,_ttabl
	xor	bh,bh
@110:   mov     eax,es:[di]
	mov	bl,al
	mov	al,[bx+si]
	mov	bl,ah
	mov	ah,[bx+si]
	ror	eax,16
	mov	bl,al
	mov	al,[bx+si]
	mov	bl,ah
	mov	ah,[bx+si]
	ror	eax,16
	stosd
	dec	cx
	jne	short @110
	pop	di
	pop	si
	pop	ds
	pop	es
	ret
@TranslateBuf8	endp

;*******************************************************************
;******************** 16 bits decompression code *******************

   ;	unsigned int Uncompbuf16(char far *ib, char far *ob, CompProcess *CP)
@Uncompbuf16	proc near
	push	bp
	mov	bp,sp
	sub	sp,2
	push	si
	push	di
	push	fs
	push	es
	lfs	si,_inbuf
	les	di,_outbuf

	lea	ax,[di-100h]
	add	ax,Bufsize
	mov	[bp-2],ax

	mov	ch,_lastch	; bit count in eax
	mov	eax,_lasteax	; eax : data
	mov  cl,_snbit		; num of bit to use

	inc	cl
	xor	dx,dx
	xor	ebx,ebx
	jmp	@217

@212:shrd	dx,ax,cl
	shr	eax,cl
        rol     dx,cl
	sub	ch,cl
	mov	bl,cl
	cmp	ch,10H
	jnb	short @213
	xchg	cl,ch
	ror	eax,cl
	mov	ax,fs:[si]
	add	si,2
	rol	eax,cl
	add	cl,10H
	xchg	cl,ch
@213:   dd      1b943b67H      ;\
        dw      (_bchg16-2)    ; } cmp     dx,[ebx+ebx+_bchg16-2]
	dw	0              ;/
	jb 	@216
	dd	1ba4ff67H      ;\ jmp word ptr [ebx+ebx+_fct3-2] still this
	dw	(_fct3-2)      ; } bug with 16 bits labels...
	dw	0              ;/
@215d:and	dx,15				; 4 bits used
	jmp	short @211
@215c:and       dl,7                            ; 3 bits used, get highest bit
	shr	eax,1
	rcl	dl,1
	dec	ch
	jmp	short @211
@215b:and       dl,3                            ; 2 bit used, get 2 highest bits
	shl	dl,2
	shrd	dx,ax,2
	shr	eax,2
	rol	dx,2
	sub	ch,2
	jmp	short @211
@215a:and       dl,1                            ; 1 bit used, get 3 highest bits
	shl	dl,3
	shrd	dx,ax,3
	shr	eax,3
	rol  dx,3
	sub	ch,3
	jmp	short @211
@215:xor	dl,dl				; no bit used, get 4 bits
	shrd	dx,ax,4
	shr	eax,4
	rol  dx,4
	sub	ch,4
@211:inc	dl
	cmp	cl,dl
	je	short @211a
	mov	cl,dl
	jmp	short @217
@211a:                        ; Special commands;
	cmp	ch,10H
	jnb	short @216b
	xchg	cl,ch
	ror	eax,cl
	mov	ax,fs:[si]
	add	si,2
	rol	eax,cl
	add	cl,10H
	xchg	cl,ch
@216b:mov	dl,al
	shr	eax,4
	sub	ch,4
	and  dx,15
	cmp	dl,15
	je	short @219	; maybe end-of-buf command
@216a:add	dx,MAX16
@216:mov  es:[di],dx		; Store uncompressed data
	add	di,2
	cmp	di,[bp-2]
	je	short @219b
	xor	dx,dx
@217:cmp	ch,10H
	jnb	@212
@218:xchg	cl,ch
	ror	eax,cl
	mov	ax,fs:[si]
	add	si,2
	rol	eax,cl
	add	cl,10H
	xchg	cl,ch
	jmp	@212
@219:cmp	ch,10H
	jnb	short @219a
	xchg	cl,ch
	ror	eax,cl
	mov	ax,fs:[si]
	add	si,2
	rol	eax,cl
	add	cl,10H
	xchg	cl,ch
@219a:dec	ch
	shr	eax,1
	jnc  @216a      ; no only a 65535
@219b:
	mov	_lastch,ch
	mov	_lasteax,eax
	dec	cl
	mov	_snbit,cl
	sub	si,word ptr _inbuf
	mov	_used,si
	sub	di,word ptr _outbuf
	mov	ax,di
	pop	es
	pop	fs
	pop	di
	pop	si
	leave
	ret
@Uncompbuf16	endp

;	void UndeltaBuf16(char far *buf, unsigned int len, CompProcess *CP)
@UndeltaBuf16	proc near
	push ds
	push	si
	mov	cx,_towrite
	add	cx,3
	shr	cx,2
	mov	bx,_lastsmp
	lds	si,_outbuf
	test	word ptr es:[BBflag],2
	je	short @321
@320:mov	eax,[si]
	shr	ax,1
	rcr	dx,1
	sar	dx,15
	xor	ax,dx
	add	ax,bx
	mov	bx,ax
	ror	eax,16
	shr	ax,1
	rcr	dx,1
	sar	dx,15
	xor	ax,dx
	add	ax,bx
	mov	bx,ax
	ror	eax,16
	mov	[si],eax
	add	si,4
	dec	cx
	jne	short @320
	jmp	short @323
@321:test	word ptr es:[BBflag],200h
	je	short @323
@322:mov	eax,[si]
	shr	ax,1
	rcr	dx,1
	sar	dx,15
	xor	ax,dx
	ror	eax,16
	shr	ax,1
	rcr	dx,1
	sar	dx,15
	xor	ax,dx
	ror	eax,16
	mov	[si],eax
	add	si,4
	dec	cx
	jne	short @322
@323:pop	si
	pop	ds
	mov	word ptr _lastsmp,bx
	ret
@UndeltaBuf16	endp

;*******************************************************************
;******************** 8 bits decompression data ********************
_bchg8	label     byte
	db	01H
	db	03H
	db	07H
	db	0fH
	db	1eH
	db	3cH
	db	78H
	db	0f8H
EVEN
_fct1	label	word
	dw   @015
	dw   @015
	dw   @015
	dw   @015
	dw   @015a
	dw   @015b
	dw   @015c
	dw   @015c
;*******************************************************************
;********************* 16 bits compression data ********************
_bchg16	label     word
	dw	00001H 	;1
	dw	00003H 	;2
	dw	00007H 	;3
	dw	0000fH 	;4
	dw	0001eH 	;5
	dw	0003cH 	;6
	dw	00078H 	;7
	dw	000f0H	;8
	dw	001f0H	;9
	dw	003f0H	;10
	dw	007f0H	;11
	dw	00ff0H	;12
	dw	01ff0H	;13
	dw	03ff0H	;14
	dw	07ff0H	;15
	dw	0fff0H	;16

_fct3	label	word
	dw   @215
	dw   @215
	dw   @215
	dw   @215
	dw   @215a
	dw   @215b
	dw   @215c
	dw   @215d
	dw   @215d
	dw   @215d
	dw   @215d
	dw   @215d
	dw   @215d
	dw   @215d
	dw   @215d
	dw   @215d

@settings:
align 4
BaseSeg         dw      08000h
Bufsize         dw      06E00h  ; 0b000h or anything else for XMS...

_inbuf          dd      0       ; size: Bufsize  ; Basemem
_ttabl          dd      0       ; size: 200h     ; Basemem + Bufsize
_BB             dd      0       ; size: 1100h    ; Basemem + Bufsize + 200h
_outbuf         dd      0       ; size: Bufsize  ; Basemem + Bufsize + 1300h
_blkoffset      dd      0       ; size: 2000h    ; Basemem + 2*Bufsize + 1300h

_tempfile	db	'C:\_~zirc~_.tmp',0,0,0,0,0,0,0,0   ; 23 b + NULL (24 b)

_old21          dd      0
_driver         dd      0
_oldstack	dd	0
_memhandle      dw      0
_actived	db	0
_openedfile	db	0
_function	db	0

_signaturecheck	label	qword
_filehead:
	_headersize	dw	0
        _version        dw      0
	_blktoprocess	dw	0
	_unpacklen	dd	0
        _blockptr       dd      0
	_dummy		dw	0

_cmphandle	dw	0
_modulehandle	dw	0

_lasteax	dd	0
_left           dw      0
_lastsmp	dw	0
_lastch         db      0

_curblock	dw	0
_curblkpos      dd      0
_towrite	dw	0
_rd		dw	0
_used           dw      0
_snbit          db      0

align 2

EndS

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

EndS

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

End
