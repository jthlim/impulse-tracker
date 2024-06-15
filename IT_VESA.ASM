;зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
;Ё Vesa Module                                                                 Ё
;цддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
;Ё Functions provided:                                                         Ё
;Ё   DetectVESA                                                                Ё
;Ё   SetVESAMode                                                               Ё
;Ё                                                                             Ё
;цддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
;Ё DetectVESA                                                                  Ё
;Ё  - No parameters required                                                   Ё
;Ё  - Detects the presence of a VESA driver                                    Ё
;Ё  - Returns carry SET if no VESA driver found                                Ё
;Ё  - Returns carry CLEAR if VESA driver found                                 Ё
;Ё  - All registers preserved                                                  Ё
;цддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
;Ё SetVESAMode                                                                 Ё
;Ё  - Requires AX = VESA Mode                                                  Ё
;Ё  - Returns carry SET if VESA Mode isn't supported                           Ё
;Ё  - Returns carry CLEAR if VESA mode change OK                               Ё
;Ё  - All registers preserved                                                  Ё
;цддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
;Ё VESAGetInfo                                                                 Ё
;Ё  - Requires AX = VESA Mode to get information on                            Ё
;Ё  - Returns carry SET if VESA Mode isn't supported                           Ё
;Ё  - Returns carry clear if information is OK                                 Ё
;Ё  - Returns ES:DI to Table, all other registers preserved                    Ё
;Ё                                                                             Ё
;юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

                        Jumps
                        .386P

include switch.inc

IF SPECTRUMANALYSER

;зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
;Ё Externals                                                                   Ё
;юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды


;зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
;Ё Globals                                                                     Ё
;юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды


;ммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм

Segment                 Vesa BYTE Public 'Code' USE16
                        Assume CS:Vesa, DS:Nothing

;зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
;Ё Variables                                                                   Ё
;юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

VESAInformationTable    Label
VESASignature           DB      4 Dup (0)
VESAVersion             DW      0
VESAOEMStringPrt        DD      0
VESACapabilities        DD      0
VESAVideoModePtr        DD      0
VESATotalMemory         DW      0
                        DB      256-($-VESAInformationTable) Dup(0)

VESAModeInformationTable Label
                        DB      256-($-VESAModeInformationTable) Dup (0)

ModeInformationStructure        Struc
        ModeAtributes           DW      ?
        WindowAAtributes        DB      ?
        WindowBAttributes       DB      ?
        WindowGranularity       DW      ?
        WindowSize              DW      ?
        WindowASegment          DW      ?
        WindowBSegment          DW      ?
        WindowFunction          DD      ?
        BytesPerScanLine        DW      ?

        XResolution             DW      ?
        YResolution             DW      ?
        XCharacterSize          DB      ?
        YCharacterSize          DB      ?
        NumberOfPlanes          DB      ?
        BitsPerPixel            DB      ?
        NumberOfBanks           DB      ?
        MemoryModel             DB      ?
        BankSize                DB      ?
        NumberOfImagePages      DB      ?
        Reserved                DB      ?

        RedMaskSize             DB      ?
        RedFieldPosition        DB      ?
        GreenMaskSize           DB      ?
        GreenFieldPosition      DB      ?
        BlueMaskSize            DB      ?
        BlueFieldPosition       DB      ?
        RSVDMaskSize            DB      ?
        DirectColourModeInfo    DB      ?

ModeInformationStructure        EndS

;зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
;Ё Functions                                                                   Ё
;юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

Proc            VESA_Detect Far
Public          VESA_Detect

                PushA
                Push    ES

                Mov     AX, 4F00h
                Push    CS
                Pop     ES
                Mov     DI, Offset VESAInformationTable
                Int     10h

                Cmp     AX, 4Fh
                JNE     DetectVESA1
                Cmp     [DWord Ptr ES:DI], "ASEV"       ; 'VESA' identification
                JNE     DetectVESA1

                DB      85h

DetectVESA1:
                StC

                Pop     ES
                PopA
                Ret

EndP            VESA_Detect

;ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

Proc            VESA_SetMode Far
Public          VESA_SetMode

                PushA
                Push    DS
                Push    ES

                Call    VESA_GetInfo
                JC      VESA_SetMode3

                Mov     BX, AX
                Mov     AX, 4F02h       ; Set Mode
                Int     10h
                Cmp     AX, 4Fh
                JE      VESA_SetMode3

                StC

VESA_SetMode3:
                Pop     ES
                Pop     DS
                PopA

                Mov     CX, [VESAModeInformationTable.XResolution]
                Mov     DX, [VESAModeInformationTable.YResolution]

                Ret

EndP            VESA_SetMode

;ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

Proc            VESA_GetInfo
Public          VESA_GetInfo

                Push    AX
                Push    CX

                Mov     CX, AX

                Push    CS
                Pop     ES
                Mov     DI, Offset VESAModeInformationTable
                Mov     AX, 4F01h
                Int     10h

                Cmp     AX, 4Fh
                JE      VESA_GetInfo1

                StC

VESA_GetInfo1:
                Pop     CX
                Pop     AX

                Ret

EndP            VESA_GetInfo

;ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд

Proc            VESA_SetBlock Far       ; Gives access to a 64kb block
Public          VESA_SetBlock           ; Given AX = block number.

                PushA
                Push    AX

                Mov     AX, 64
                Xor     DX, DX
                Div     Word Ptr [VESAModeInformationTable.WindowGranularity]
                Mov     DX, AX
                Pop     AX
                Mul     DX
                Mov     DX, AX
                Xor     BX, BX
                Call    DWord Ptr [VESAModeInformationTable.WindowFunction]

                PopA
                Ret

EndP            VESA_SetBlock

;ммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм

EndS

;ммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм

ENDIF

End
