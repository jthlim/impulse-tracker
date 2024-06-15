ml -Fl -DBLD_COFF -DIS_32 -W2 -c -Cx -Zm -DMASM6 vsound.asm
link /VXD /NOD /OUT:VSOUND.VxD /MAP:VSOUND.MAP /DEF:VSOUND.DEF vsound
copy vsound.vxd \windows\system\itvsound.vxd
