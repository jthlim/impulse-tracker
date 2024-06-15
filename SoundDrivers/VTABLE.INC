
VariableTableStart      Label

BasePort        DW      0FFFFh
IRQ             DW      0FFFFh
DMA             DW      0FFFFh
CmdLineMixSpeed DW      0
SongDataArea    DW      0
                DB      16-($-VariableTableStart) Dup (0)


