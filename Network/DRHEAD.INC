
NUMREQUIREDVARIABLES  EQU 16    ; Number of bytes required from IT.EXE by Driver
NUMREQUIREDFUNCTIONS  EQU 32    ; Number of functions (DD Offsets) required by
                                ;  Network driver
NUMPROVIDEDVARIABLES  EQU 16    ; Number of bytes provided from driver to IT.EXE
NUMPROVIDEDFUNCTIONS  EQU 16    ; Number of functions (DW Offsets) provided by
                                ;  Network driver

ID              DB      "Impulse Tracker Network Driver"
                DB      26
                DB      (62 - ($-Offset ID)) Dup (0)
                DB      13, 10

DriverID        DB      DRIVERIDSTRING
                DB      (62 - ($ - Offset DriverID)) Dup (0)

LengthOfDriver  DW      Offset EndDriver - Offset StartDriver


