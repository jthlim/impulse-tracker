
ProcedureTableStart     Label
Update                  DD      0
GetSampleHeader         DD      0
GetSampleLocation       DD      0
                        DD      0
GetEMSPageFrame         DD      0
SaveEMSPageFrame        DD      0
RestoreEMSPageFrame     DD      0
GetTempo                DD      0               ; Gets tempo in BX
M_FunctionHandler       DD      0
SetInfoLine             DD      0
Music_LoadAllSamples    DD      0
GlobalKeyList           DD      0
IdleUpdateInfoLine      DD      0
DrawHeaderFunction      DD      0
FillHeaderFunction      DD      0
GotoHomeDirectory       DD      0
GetFileName             DD      0
SetDirectory            DD      0
StopPlayback            DD      0
GetEnvironment          DD      0
GetChannelTables        DD      0
RecalculateAllVolumes   DD      0
UARTBufferEmpty         DD      0
UARTSend                DD      0
S_GetDestination        DD      0
S_DrawString            DD      0
        DD      32 - ($-ProcedureTableStart)/4 Dup (0)


