
ProcedureTableStart     Label

IT_UnloadDriver         DD      ?
IT_FunctionHandler      DD      ?
IT_FunctionDivider      DD      ?

IT_ReceiveData          DD      ?
IT_SendData             DD      ?
IT_EstablishConnection  DD      ?

IT_GotoHomeDirectory    DD      ?
IT_GetTime              DD      ?
IT_SetInfoLine          DD      ?

IT_DrawHeader           DD      ?
IT_FillHeader           DD      ?

IT_S_GetDestination     DD      ?
IT_S_DrawString         DD      ?
IT_S_SaveScreen         DD      ?
IT_S_RestoreScreen      DD      ?

IT_GetCurrentMode       DD      ?

IT_NewConnection        DD      ?

IT_DecodeUserName       DD      ?

        DD      NUMREQUIREDFUNCTIONS - ($-ProcedureTableStart)/4 Dup (0)


