
        .386P

Segment                 DriverHeader PARA Public 'Code' Use16
                        Assume CS:Driver, DS:Nothing

;***** Driver Header *******

include drhead.inc

EndS

Segment                 Driver PARA Public 'Code' Use16
                        Assume CS:Driver, DS:Nothing

ORG 0
StartDriver:

include vtable.inc

;********  Required ProcedureTable *************

include reqproc.inc

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

EndDriver:

;********  Provided Variable Table *************

ProvidedVariableStart:
        DB      NUMPROVIDEDVARIABLES-($-ProvidedVariableStart) Dup (0)

;********  Provided Procedure Table *************

ProvidedTableStart:
        DW      Offset Initialise
        DW      Offset Shutdown
        DW      Offset DriverScreen
        DW      Offset Update
        DW      Offset ConnectionStatus
ProvidedTableEnd:
        DW      NUMPROVIDEDFUNCTIONS-(ProvidedTableEnd-ProvidedTableStart)/2 Dup (0)

EndS

End
