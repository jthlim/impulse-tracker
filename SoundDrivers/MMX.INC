
; Stuff from Intel's MMX Macro set.

; This stuff has been written for real mode use - change the EQU below to EAX
;  for protected mode use.

opc_rdTSC     = 031h
opc_Rdpmc     = 033H
opc_Emms      = 077H
opc_Movd_ld   = 06EH
opc_Movd_st   = 07EH
opc_Movq_ld   = 06FH
opc_Movq_st   = 07FH
opc_Packssdw  = 06BH
opc_Packsswb  = 063H
opc_Packuswb  = 067H
opc_Paddb     = 0FCH
opc_Paddd     = 0FEH
opc_Paddsb    = 0ECH
opc_Paddsw    = 0EDH
opc_Paddusb   = 0DCH
opc_Paddusw   = 0DDH
opc_Paddw     = 0FDH
opc_Pand      = 0DBH
opc_Pandn     = 0DFH
opc_Pcmpeqb   = 074H
opc_Pcmpeqd   = 076H
opc_Pcmpeqw   = 075H
opc_Pcmpgtb   = 064H
opc_Pcmpgtd   = 066H
opc_Pcmpgtw   = 065H
opc_Pmaddwd   = 0F5H
opc_Pmulhw    = 0E5H
opc_Pmullw    = 0D5H
opc_Por       = 0EBH
opc_PSHimd    = 072H
opc_PSHimq    = 073H
opc_PSHimw    = 071H
opc_Pslld     = 0F2H
opc_Psllq     = 0F3H
opc_Psllw     = 0F1H
opc_Psrad     = 0E2H
opc_Psraw     = 0E1H
opc_Psrld     = 0D2H
opc_Psrlq     = 0D3H
opc_Psrlw     = 0D1H
opc_Psubb     = 0F8H
opc_Psubd     = 0FAH
opc_Psubsb    = 0E8H
opc_Psubsw    = 0E9H
opc_Psubusb   = 0D8H
opc_Psubusw   = 0D9H
opc_Psubw     = 0F9H
opc_Punpcklbw = 060H
opc_Punpckldq = 062H
opc_Punpcklwd = 061H
opc_Punpckhbw = 068H
opc_Punpckhdq = 06AH
opc_Punpckhwd = 069H
opc_Pxor      = 0EFH

.486P

MM0 EQU AX
MM1 EQU CX
MM2 EQU DX
MM3 EQU BX
MM4 EQU SP
MM5 EQU BP
MM6 EQU SI
MM7 EQU DI

MMXMacro  Macro Dst, Src, Opcode
        Local   X, Y
  X:    CmpXChg Src, Dst
  Y:    Org     X+1
        DB      Opcode
        Org     Y
        EndM

MMXIMacro Macro Dst, Src, Opcode
        Local   X, Y
  X:    BT      Dst, Src
  Y:    Org     X+1
        DB      Opcode
        Org     Y
        EndM

MMXSRMacro Macro Dst, Src, Opcode
        Local   X, Y
  X:    CmpXChg Dst, MM2
        DB      Src
  Y:    Org     X+1
        DB      Opcode
        Org     Y
        EndM

MMXSLMacro Macro Dst, Src, Opcode
        Local   X, Y
  X:    BTR     Dst, Src
  Y:    Org     X+1
        DB      Opcode
        Org     Y
        EndM


EMMS    Macro
        DB      0Fh, opc_Emms
        EndM


MovQ    Macro   Dst, Src
        MMXMacro Dst, Src, opc_MovQ_LD
        EndM

MovQM   Macro   Dst, Src
        MMXMacro Src, Dst, opc_MovQ_ST
        EndM

MovD    Macro   Dst, Src
        MMXMacro Dst, Src, opc_MovD_LD
        EndM

MovDM   Macro   Dst, Src
        MMXMacro Src, Dst, opc_MovD_ST
        EndM

MovDR   Macro   Dst, Src
        MMXMacro Src, Dst, opc_MovD_ST
        EndM


PackSSDW Macro  Dst, Src
        MMXMacro Dst, Src, opc_PackSSDW
        EndM

PackSSWB Macro  Dst, Src
        MMXMacro Dst, Src, opc_PackSSWB
        EndM


PAnd    Macro   Dst, Src
        MMXMacro Dst, Src, opc_PAnd
        EndM

PAndN   Macro   Dst, Src
        MMXMacro Dst, Src, opc_PAndN
        EndM


PAddD   Macro   Dst, Src
        MMXMacro Dst, Src, opc_PAddD
        EndM

PAddSW  Macro   Dst, Src
        MMXMacro Dst, Src, opc_PAddSW
        EndM

PAddW   Macro   Dst, Src
        MMXMacro Dst, Src, opc_PAddW
        EndM


PMAddWD Macro   Dst, Src
        MMXMacro Dst, Src, opc_PMAddWD
        EndM

PMulHW  Macro   Dst, Src
        MMXMacro Dst, Src, opc_PMulHW
        EndM

PMulLW  Macro   Dst, Src
        MMXMacro Dst, Src, opc_PMulLW
        EndM


POr     Macro   Dst, Src
        MMXMacro Dst, Src, opc_POr
        EndM


PSLLD   Macro   Dst, Src
        MMXMacro Dst, Src, opc_PSLLD
        EndM

PSLLDI  Macro   Dst, Src
        MMXSLMacro Dst, Src, opc_PSHImd
        EndM

PSLLQ   Macro   Dst, Src
        MMXMacro Dst, Src, opc_PSLLQ
        EndM

PSLLQI  Macro   Dst, Src
        MMXSLMacro Dst, Src, opc_PSHImq
        EndM


PSRAD   Macro   Dst, Src
        MMXMacro Dst, Src, opc_PSRAD
        EndM

PSRADI  Macro   Dst, Src
        MMXIMacro Dst, Src, opc_PSHImd
        EndM

PSRLD   Macro   Dst, Src
        MMXMacro Dst, Src, opc_PSRLD
        EndM

PSRLDI  Macro   Dst, Src
        MMXSRMacro Dst, Src, opc_PSHImd
        EndM

PSRLQ   Macro   Dst, Src
        MMXMacro Dst, Src, opc_PSRLQ
        EndM

PSRLQI  Macro   Dst, Src
        MMXSRMacro Dst, Src, opc_PSHImq
        EndM

PSRAW   Macro   Dst, Src
        MMXMacro Dst, Src, opc_PSRAW
        EndM

PSRAWI  Macro   Dst, Src
        MMXIMacro Dst, Src, opc_PSHImw
        EndM

PSRLW   Macro   Dst, Src
        MMXMacro Dst, Src, opc_PSRLW
        EndM

PSRLWI  Macro   Dst, Src
        MMXSRMacro Dst, Src, opc_PSHImw
        EndM


PSubB   Macro   Dst, Src
        MMXMacro Dst, Src, opc_PSubB
        EndM

PSubSB  Macro   Dst, Src
        MMXMacro Dst, Src, opc_PSubSB
        EndM

PSubUSB  Macro  Dst, Src
        MMXMacro Dst, Src, opc_PSubUSB
        EndM

PSubD   Macro   Dst, Src
        MMXMacro Dst, Src, opc_PSubD
        EndM

PSubW   Macro   Dst, Src
        MMXMacro Dst, Src, opc_PSubW
        EndM

PSubSW  Macro   Dst, Src
        MMXMacro Dst, Src, opc_PSubSW
        EndM

PSubUSW  Macro  Dst, Src
        MMXMacro Dst, Src, opc_PSubUSW
        EndM


PUnpckHBW Macro Dst, Src
        MMXMacro Dst, Src, opc_PUnpckHBW
        EndM

PUnpckHDQ Macro Dst, Src
        MMXMacro Dst, Src, opc_PUnpckHDQ
        EndM

PUnpckHWD Macro Dst, Src
        MMXMacro Dst, Src, opc_PUnpckHWD
        EndM

PUnpckLBW Macro Dst, Src
        MMXMacro Dst, Src, opc_PUnpckLBW
        EndM

PUnpckLDQ Macro Dst, Src
        MMXMacro Dst, Src, opc_PUnpckLDQ
        EndM

PUnpckLWD Macro Dst, Src
        MMXMacro Dst, Src, opc_PUnpckLWD
        EndM


PXor    Macro   Dst, Src
        MMXMacro Dst, Src, opc_PXor
        EndM


RdPMC   Macro
        DB    0Fh, opc_Rdpmc
        EndM

RdTSC   Macro
        DB    0Fh, opc_RdTSC
        EndM

