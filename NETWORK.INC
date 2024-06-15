IF NETWORKENABLED
                Extrn   Network_GetSendQueue:Far
                Extrn   Network_FinishedSendQueue:Far
                Extrn   Network_AddWordToQueue:Far
                Extrn   Network_EnsureNoNetwork:Far
                Extrn   Network_SendSampleHeader:Far
                Extrn   Network_SendInstrumentHeader:Far
                Extrn   Network_QueueSampleData:Far
                Extrn   Network_SendSongDataInformation:Far

NETWORK_PARTIALPATTERNOBJECT    EQU     0
NETWORK_ENTIREPATTERNOBJECT     EQU     1
NETWORK_REQUESTPATTERNOBJECT    EQU     2
NETWORK_SONGDATAOBJECT          EQU     3
NETWORK_INSTRUMENTHEADEROBJECT  EQU     4
NETWORK_SAMPLEHEADEROBJECT      EQU     5
NETWORK_SETPATTERNLENGTH        EQU     6
NETWORK_DELETESAMPLEOBJECT      EQU     7

EnsureNoNetwork           EQU   Call  Network_EnsureNoNetwork
NetworkSendSample         EQU   Call  Network_SendSampleHeader
NetworkSendInstrument     EQU   Call  Network_SendInstrumentHeader

ELSE

EnsureNoNetwork           EQU   ;
NetworkSendSample         EQU   ;
NetworkSendInstrument     EQU   ;

ENDIF


