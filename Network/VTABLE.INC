
VariableTableStart      Label

GlobalKeyList           DD      ?
IdleUpdateInfoLine      DD      ?
DiskDataArea            DW      ?       ; Segment

                DB      NUMREQUIREDVARIABLES-($-VariableTableStart) Dup (0)


