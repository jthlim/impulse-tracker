;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Startup Module                                                              ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                        Jumps
                        .386P

include switch.inc

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Externals                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Segment         Object1 BYTE Public 'Data'
                Extrn   HelpKeyValue:Word, OrderKeyValue:Word
EndS

Segment         InfoLine BYTE Public 'Code' USE16
                Extrn   ShowUsageTime:Byte
EndS

Segment         Disk BYTE Public 'Code' USE16
                Extrn   DiskOptions:Byte
EndS

Segment         Screen BYTE Public 'Code'
                Extrn   CharacterGenerationOffset:Word
                Extrn   VGAFlags:Byte
EndS

Segment         Mouse BYTE Public 'Code'
                Extrn   MouseCharacterGenerationOffset:Word
EndS

Segment         Main DWORD Public 'Code' USE16
                Extrn   ReleaseTimeSlice:Byte
EndS

                Extrn   D_InitDisk:Far
                Extrn   D_UnInitDisk:Far
                Extrn   D_DisableFileColours:Far

                Extrn   E_InitEMS:Far
                Extrn   E_UnInitEMS:Far

                Extrn   Error_InitHandler:Far
                Extrn   Error_UnInitHandler:Far

                Extrn   K_InitKeyBoard:Far
                Extrn   K_UnInitKeyBoard:Far
                Extrn   K_InstallKeyboardType:Far
                Extrn   K_RemoveKeyboardType:Far

                Extrn   K_InstallDOSHandler:Far
                Extrn   K_UnInstallDOSHandler:Far
                Extrn   K_SwapKeyBoard:Far

                Extrn   O1_AutoDetectList:Far
                Extrn   O1_ConfirmQuit:Far
                Extrn   O1_PatternEditList:Far
                Extrn   O1_CrashRecovery:Far
                Extrn   O1_KeyboardList:Far

                Extrn   M_Object1List:Far

                Extrn   S_InitScreen:Far
                Extrn   S_ClearScreen:Far
                Extrn   S_UnInitScreen:Far
                Extrn   S_SetDirectMode:Far
                Extrn   S_DrawString:Far

                Extrn   Music_InitMusic:Far
                Extrn   Music_UnInitMusic:Far

                Extrn   Music_SetLimit:Far
                Extrn   Music_SetSoundCard:Far
                Extrn   Music_SetDMA:Far
                Extrn   Music_SetIRQ:Far
                Extrn   Music_SetMixSpeed:Far
                Extrn   Music_SetAddress:Far
                Extrn   Music_ReverseChannels:Far
                Extrn   Music_PatternStorage:Far
                Extrn   Music_SetSoundCardDriver:Far
                Extrn   Music_Stop:Far
                Extrn   Music_AutoDetectSoundCard:Far

IF NETWORKENABLED
                Extrn   Network_Shutdown:Far
ENDIF

                Extrn   PE_InitPatternEdit:Far
                Extrn   PE_UnInitPatternEdit:Far
                Extrn   PECheckModified:Far

                Extrn   D_RestorePreShellDirectory:Far
                Extrn   D_GetPreShellDirectory:Far

                Extrn   MMTSR_InstallMMTSR:Far
                Extrn   MMTSR_UninstallMMTSR:Far

                Extrn   InitMouse:Far, UnInitMouse:Far
                Extrn   CmdLineDisableMouse:Far

                Extrn   InitTimerHandler:Far, UnInitTimerHandler:Far

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

                Global  Quit:Far, Refresh:Far
                Global  DOSShell:Far, GetEnvironment:Far
                Global  CrashRecovery:Far

                Public  IsStartupKeyList
                Public  GetStartupKeyList

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment                 StartUp BYTE Public 'Code' USE16
                        Assume  CS:StartUp, DS:Nothing, ES:Nothing

CREATENEWLOGFILE        EQU     1
include debug.inc

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Variables                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

StackSize       =       1000h

No386Msg        DB      "Sorry, Impulse Tracker requires a 386+ processor to run."
                DB      13, 10, "$"
WindowsMsg      DB      "Microsoft Windows detected.", 13, 10, 10
                DB      "Due to instabilities in Windows, it is highly recommended that you run", 13, 10
                DB      "Impulse Tracker in DOS instead.", 13, 10, 10
                DB      "Press any key to continue..."
                DB      "$"

PSP             DW      ?

LoadMMTSR       DB      1
Pause           DB      0
COMSPECFound    DB      0
COMSPEC         DD      0
Control         DB      0
CommandTail     DB      1, 0, 13

FCB1            DB      0, 11 Dup (32), 52 Dup (0)
FCB2            DB      0, 11 Dup (32), 52 Dup (0)

COMSPECString   DB      "COMSPEC"
DefaultShell    DB      "C:\COMMAND.COM", 0
EXECData        DW      0               ; Inherit same environment block
                DW      Offset CommandTail, Startup
                DW      Offset FCB1, Startup
                DW      Offset FCB2, Startup
ShellMsg        DB      "Type EXIT to return to Impulse Tracker$"

IF SHOWREGISTERNAME
include wavswitc.inc
include username.inc
ENDIF

Label           CmdLineHelp Byte
IF SHOWVERSION
                DB      "Impulse Tracker 2.14, Copyright (C) 1995-2000 Jeffrey Lim", 13, 10
                DB      10
                DB      "  Usage: IT.EXE [Switches]", 13, 10
ELSE
                DB      "Impulse Tracker, Copyright (C) 1995-2000 Jeffrey Lim", 13, 10
IF SHOWREGISTERNAME
                DB      "Registered to: "
                DB      REGISTERNAME
                DB      13, 10
ENDIF
ENDIF
                DB      10
                DB      "Switches:", 13, 10
                DB      "  SFilename.Drv  Select sound card driver", 13, 10
                DB      "  S#", 9, 9, " Quick select sound card", 13, 10
                DB      9, "S0: No sound card", 9, 9, " S9: Pro Audio Spectrum", 13, 10
                DB      9, "S1: PC Speaker", 9, 9, 9, "S10: Pro Audio Spectrum 16", 13, 10
                DB      9, "S2: Sound Blaster 1.xx", 9, 9, "S11: Windows Sound System", 13, 10
                DB      9, "S3: Sound Blaster 2.xx", 9, 9, "S12: ESS ES1868 AudioDrive", 13, 10
                DB      9, "S4: Sound Blaster Pro", 9, 9, "S13: EWS64 XL Codec", 13, 10
                DB      9, "S5: Sound Blaster 16", 9, 9, "S14: Ensoniq SoundscapeVIVO", 13, 10
                DB      9, "S6: Sound Blaster AWE 32", 9, "S19: Generic MPU401", 13, 10
                DB      9, "S7: Gravis UltraSound", 9, 9, "S20: Disk Writer (WAV)", 13, 10
                DB      9, "S8: AMD Interwave", 9, 9, "S21: Disk Writer (MID)", 13, 10
                DB      10
                DB      "  Axxx", 9, "Set Base Address of sound card (hexadecimal)", 13, 10
                DB      "  I###", 9, "Set IRQ of sound card (decimal)", 13, 10
                DB      "  D###", 9, "Set DMA of sound card (decimal)", 13, 10
                DB      10
                DB      "  M###", 9, "Set Mixspeed", 13, 10
                DB      "  L###", 9, "Limit number of channels (4-256)", 13, 10
                DB      "$"

MixErrorMsg     DB      "Error: Mixing speed invalid - setting ignored", 13, 10, "$"
AddressErrorMsg DB      "Error: Base Address invalid - setting ignored", 13, 10, "$"
IRQErrorMsg     DB      "Error: IRQ number invalid - setting ignored", 13, 10, "$"
LimitErrorMsg   DB      "Error: Channel limit number invalid - setting ignored", 13, 10, "$"
ContinueMsg     DB      "Press any key to continue...$"

StartupList             DB      0
StartupMode             DB      0       ; Load? Or Load/Play? or Load/Save
StartupFileOffset       DW      0
StartupFileSegment      DW      0
StartupKeyListFunction  DW      Offset GetStartupKeyList1

                                ; CX,DX
StartupInformation      DW      11Ch, 0         ; Enter
                        DW      1Ch,  0         ; Release Enter
                        DW      10Fh, 0         ; Tab
                        DW      10Fh, 0         ; Tab
                        DW      10Fh, 0         ; Tab
                        DW      90Eh, 127       ; Ctrl-Backspace

ENDSTARTUPINFORMATION   EQU     $

SaveInformation         DW      0, 0            ; Loading screen key-loss
                        DW      1FFh, 13h       ; Ctrl-S
                        DW      0, 0            ; Saving screen key-loss
                        DW      1FFh, 11h       ; Ctrl-Q
                        DW      1FFh, 'Y'       ; 'Y'

ENDSAVEINFORMATION      EQU     $

StartupQueueOffset      DW      Offset StartupInformation
StartupQueueEnd         DW      Offset ENDSTARTUPINFORMATION
StartupQueueNextFunction DW     Offset GetStartupKeyList2

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Functions                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Proc            CapitaliseAL

                Cmp     AL, 'a'
                JB      CapitaliseAL1

                Cmp     AL, 'z'
                JA      CapitaliseAL1

                Add     AL, 'A'-'a'

CapitaliseAL1:
                Ret

EndP            CapitaliseAL

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetDecimalNumber        ; Returns CX

                LodsB
                Cmp     AL, '0'
                JB      GetDecimalNumber1
                Cmp     AL, '9'
                JBE     GetDecimalNumber2

GetDecimalNumber1:
                StC
                Ret

GetDecimalNumber2:
                Xor     CX, CX

GetDecimalNumber3:
                Mov     BL, AL
                Sub     BL, '0'
                Xor     BH, BH
                Mov     AX, 10
                Mul     CX
                Add     AX, BX
                Mov     CX, AX
                LodsB
                And     DX, DX
                JNZ     GetDecimalNumber1

                Cmp     AL, '0'
                JB      GetDecimalNumber4
                Cmp     AL, '9'
                JA      GetDecimalNumber4
                Jmp     GetDecimalNumber3

GetDecimalNumber4:
                ClC
                Ret

EndP            GetDecimalNumber

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Start
                        Assume DS:Nothing

; 386 check.

                Trace   "Impulse Tracker Startup"

                Push    SP
                Pop     AX
                Cmp     AX, SP
                JNE     No386

                PushF
                Pop     CX      ; CX = Flags.
                Mov     AX, CX
                Or      AX, 0F000h
                Push    AX
                PopF
                PushF
                Pop     AX
                And     AX, 0F000h
                JNZ     Found386

No386:
                Push    CS
                Pop     DS

                Mov     AH, 9
                Mov     DX, Offset No386Msg
                Int     21h

                Mov     AX, 4C02h
                Int     21h

Found386:
;                Push    0B800h                          ; DEBUG!!!!!
;                Pop     GS                              ; DEBUG!!!!!

                Push    CX
                PopF

                ClD

                Mov     [CS:PSP], ES

                Mov     AX, ES
                Mov     BX, SS
                Sub     BX, AX
                Add     BX, StackSize / 16       ; Add BX, <Size reqd for Stack in para>
                Mov     AH, 4Ah                 ; Re-allocate memory
                Int     21h

                                                ; Check for 386 here.

                                                ; Do command line stuff.
                Mov     SI, 81h                 ; DS:SI points to cmdtail

CmdLine1:
                Push    ES
                Pop     DS

                LodsB

CmdLine3:
                Cmp     AL, 0Dh
                JE      CmdLineEnd
                And     AL, AL
                JZ      CmdLineEnd

                Call    CapitaliseAL

CmdLine2:
                Cmp     AL, 'K'
                JE      KeyboardSwap
                Cmp     AL, 'F'
                JE      DisableColours
                Cmp     AL, 'C'
                JE      SetControl
                Cmp     AL, 'H'
                JE      ShowCmdLineHelp
                Cmp     AL, '?'
                JE      ShowCmdLineHelp
                Cmp     AL, 'S'
                JE      SetSoundCard1
                Cmp     AL, 'D'
                JE      SetDMA1
                Cmp     AL, 'M'
                JE      SetMixSpeed1
                Cmp     AL, 'I'
                JE      SetIRQ1
                Cmp     AL, 'A'
                JE      SetAddress1
                Cmp     AL, 'V'
                JE      OverrideVGA
                Cmp     AL, 'L'
                JE      Limit1
                Cmp     AL, 'R'
                JE      Reverse1
                Cmp     AL, 'X'
                JE      DisableFeatures
                Cmp     AL, 'P'
                JE      PatternStorage
                Cmp     AL, 'T'
                JE      NoShowUsageTime
                Cmp     AL, 'W'
                JE      ConvertModule

                Jmp     CmdLine1

NoShowUsageTime:
                LodsB
                Cmp     AL, '1'
                JNE     NoReleaseTimeSlice

                Push    DS

                Push    InfoLine
                Pop     DS
                        Assume DS:InfoLine

                Mov     [ShowUsageTime], 0

                Pop     DS
                Jmp     CmdLine1
                        Assume DS:Nothing

NoReleaseTimeSlice:
                Cmp     AL, '2'
                JNE     CmdLine3

NoReleaseTimeSlice2:
                Push    DS

                Push    Main
                Pop     DS
                        Assume DS:Main

                Mov     [ReleaseTimeSlice], 1

                Pop     DS
                Jmp     CmdLine1

PatternStorage:
                LodsB
                Sub     AL, '0'
                JC      PatternStorageEnd
                Cmp     AL, 2
                JA      PatternStorageEnd
                Call    Music_PatternStorage
                Jmp     CmdLine1

PatternStorageEnd:
                Jmp     CmdLine3

DisableFeatures:
                LodsB
                Cmp     AL, '1'
                JB      CmdLine3
                JE      DisableMMTSR

                Cmp     AL, '3'
                JB      DisableMouse
                JE      DisableDetectDriveMap

                Cmp     AL, '5'
                JB      DisableCacheFiles
                Jmp     CmdLine3

DisableMouse:
                Call    CmdLineDisableMouse
                Jmp     CmdLine1

DisableMMTSR:
                Mov     [LoadMMTSR], 0
                Jmp     CmdLine1

DisableDetectDriveMap:
                Push    Disk
                Pop     DS
                        Assume DS:Disk

                Or      [DiskOptions], 1
                Jmp     CmdLine1
                        Assume DS:Nothing

DisableCacheFiles:
                Push    Disk
                Pop     DS
                        Assume DS:Disk

                Or      [DiskOptions], 2
                Jmp     CmdLine1
                        Assume DS:Nothing

KeyboardSwap:
                Mov     AX, Object1
                Mov     DS, AX
                        Assume DS:Object1

                Mov     [HelpKeyValue], 157h
                Mov     [OrderKeyValue], 13Bh

                Jmp     CmdLine1
                        Assume DS:Nothing

DisableColours:
                Call    D_DisableFileColours
                Jmp     CmdLine1

Reverse1:
                Call    Music_ReverseChannels
                Jmp     CmdLine1

OverrideVGA:
                LodsB

                Mov     CX, Screen
                Mov     DS, CX
                        Assume DS:Screen

                Cmp     AL, '1'
                JE      OverrideVGA1
                Cmp     AL, '2'
                JE      Matrox
                Cmp     AL, '3'
                JE      WaitforRetrace
                Cmp     AL, '4'
                JE      Retrace
                Jmp     CmdLine3

OverrideVGA1:
                Or      [VGAFlags], 1
                Jmp     CmdLine1

WaitforRetrace:
                Or      [VGAFlags], 4
                Jmp     CmdLine1

Retrace:
                Or      [VGAFlags], 2
                Jmp     CmdLine1

Matrox:
                Mov     [CharacterGenerationOffset], 256*32

                Mov     AX, Mouse
                Mov     DS, AX
                        Assume DS:Mouse
                Mov     [MouseCharacterGenerationOffset], 256*32

                Jmp     CmdLine1
                        Assume DS:Nothing

SetControl:
                Mov     [CS:Control], 1
                Jmp     CmdLine1

ShowCmdLineHelp:
                Push    CS
                Pop     DS

                Mov     AH, 9
                Mov     DX, Offset CmdLineHelp
                Int     21h

                Mov     AX, 4C00h
                Int     21h

SetSoundCard1:
                Call    GetDecimalNumber
                JC      SetSoundCardDriver
                Cmp     CX, 21
                JA      SetSoundCard2

                Push    AX
                Mov     AX, CX
                Call    Music_SetSoundCard
                Pop     AX

SetSoundCard2:
                Jmp     CmdLine3

SetSoundCardDriver:
                Cmp     AL, 32
                JBE     CmdLine3

                Dec     SI
                Call    Music_SetSoundCardDriver

SetSoundCardDriver1:
                LodsB
                Cmp     AL, 32
                JA      SetSoundCardDriver1

                Mov     Byte Ptr [SI-1], 0
                Cmp     AL, 32
                JE      CmdLine1
                Jmp     CmdLineEnd

ConvertModule:
                Mov     [CS:StartupList], 1
                Mov     [CS:StartupFileOffset], SI
                Mov     [CS:StartupFileSegment], DS
                Jmp     SetSoundCardDriver1

SetDMA1:
                LodsB
                Cmp     AL, '0'
                JB      CmdLine3
                Cmp     AL, '7'
                JA      CmdLine3
                Sub     AL, '0'
                Call    Music_SetDMA
                Jmp     CmdLine1

SetMixSpeed1:
                Call    GetDecimalNumber
                JC      SetMixSpeedError
                Push    AX
                Call    Music_SetMixSpeed
                Pop     AX
                Jmp     CmdLine3

SetMixSpeedError:
                Push    CS
                Pop     DS
                        Assume DS:StartUp

                Mov     AH, 9
                Mov     DX, Offset MixErrorMsg
                Int     21h

                Mov     [Pause], 1
                Jmp     CmdLine1
                        Assume DS:Nothing

SetIRQ1:
                Call    GetDecimalNumber
                JC      IRQError
                Cmp     CX, 15
                JA      IRQError

                Push    AX
                Call    Music_SetIRQ
                Pop     AX
                Jmp     CmdLine3

IRQError:
                Push    CS
                Pop     DS
                        Assume DS:StartUp

                Mov     AH, 9
                Mov     DX, Offset IRQErrorMsg
                Int     21h

                Mov     [Pause], 1
                Jmp     CmdLine1
                        Assume DS:Nothing


SetAddress1:
                LodsB

                Xor     DX, DX
                Mov     CL, 4

                Cmp     AL, '0'
                JB      SetAddress2
                Cmp     AL, '9'
                JA      SetAddress2
                Sub     AL, '0'
                Jmp     SetAddress3

SetAddress2:
                Call    CapitaliseAL

                Cmp     AL, 'A'
                JB      CmdLine2
                Cmp     AL, 'F'
                JA      CmdLine2
                Sub     AL, '@'

SetAddress3:
                Test    DX, 0F000h
                JNZ     AddressError

                ShL     DX, CL
                Or      DL, AL

                LodsB
                Cmp     AL, '0'
                JB      SetAddress4
                Cmp     AL, '9'
                JA      SetAddress4
                Sub     AL, '0'
                Jmp     SetAddress3

SetAddress4:
                Call    CapitaliseAL
                Cmp     AL, 'A'
                JB      SetAddress5
                Cmp     AL, 'F'
                JA      SetAddress5

                Sub     AL, '@'
                Jmp     SetAddress3

SetAddress5:
                Call    Music_SetAddress
                Jmp     CmdLine3

AddressError:
                Push    CS
                Pop     DS
                        Assume DS:StartUp

                Mov     AH, 9
                Mov     DX, Offset AddressErrorMsg
                Int     21h

                Mov     [Pause], 1
                Jmp     CmdLine1
                        Assume DS:Nothing

Limit1:
                Call    GetDecimalNumber
                JC      LimitError
                Cmp     CX, 256
                JA      LimitError
                Cmp     CX, 4
                JB      LimitError

                Push    AX
                Call    Music_SetLimit
                Pop     AX
                Jmp     CmdLine3

LimitError:
                Push    CS
                Pop     DS
                        Assume DS:StartUp

                Mov     AH, 9
                Mov     DX, Offset LimitErrorMsg
                Int     21h

                Mov     [Pause], 1
                Jmp     CmdLine1
                        Assume DS:Nothing


CmdLineEnd:
                Trace   "Command Line Parsed"

                Push    CS
                Pop     DS
                        Assume DS:StartUp

                Trace   "Windows Detection"

                Mov     AX, 1600h               ; Windows detection.
                Int     2Fh
                Test    AL, 7Fh
                JZ      Start1
                Cmp     AL, 4                   ; Windows 4.0+ ??
                JAE     Start1

                Mov     AH, 9
                Mov     DX, Offset WindowsMsg
                Int     21h

                Xor     AX, AX
                Int     16h

Start1:
                                                ; Get Comspec
                Cmp     [Pause], 1
                JNE     NoPause

                Mov     DX, Offset ContinueMsg
                Mov     AH, 9
                Int     21h

                Xor     AX, AX
                Int     16h

NoPause:
                Trace   "Retrieving Environment"

                Mov     SI, Offset COMSPECString
                Mov     CX, 7
                Call    GetEnvironment
                JC      Start2

                Mov     [COMSPECFound], 1
                Mov     [Word Ptr COMSPEC], DI
                Mov     [Word Ptr COMSPEC+2], ES

Start2:
                Mov     FS, [CS:PSP]

                Trace   "Initialising Screen Module"

                Call    S_InitScreen

                Trace   "Initialising Disk Module"

                Call    D_InitDisk

                Trace   "Initialising Expanded Memory Module"

                Call    E_InitEMS

                Trace   "Initialising Music Module"

                Call    Music_InitMusic

                Trace   "Initialising Keyboard Module"

                Call    K_InitKeyBoard

                Trace   "Initialising Edit Module"

                Call    PE_InitPatternEdit

                Trace   "Initialising Custom Keyboard Layout"

                Call    K_InstallKeyboardType

                Trace   "Initialising Error Handler Module"

                Call    Error_InitHandler

                Cmp     [CS:LoadMMTSR], 0
                JE      SkipMMTSR

                Trace   "Initialising MMTSR Module"

                Call    MMTSR_InstallMMTSR

SkipMMTSR:
                Trace   "Initialising Mouse Module"

                Call    InitMouse

                Call    S_ClearScreen

                Trace   "Initialising Timer Module"

                Call    InitTimerHandler

                Trace   "Initialising Soundcard"

                Call    Music_AutoDetectSoundCard

                Trace   "Entering Main Message Loop"

                Mov     DI, Offset O1_AutoDetectList
;                Mov     DI, Offset O1_KeyboardList
                Mov     CX, 0FFFFh
                Call    M_Object1List
                Jmp     Quit1

Proc            Quit Far

                Mov     DI, Offset O1_ConfirmQuit
                Mov     CX, 3
                Call    M_Object1List

                And     DX, DX
                JNZ     Quit1

                Mov     AX, 1
                RetF

Quit1:
                Call    PECheckModified
                Call    Music_Stop

IF NETWORKENABLED
                Call    Network_Shutdown
ENDIF

                Call    MMTSR_UninstallMMTSR
                Call    PE_UnInitPatternEdit
                Call    Music_UnInitMusic
                Call    UnInitMouse
                Call    S_UnInitScreen
                Call    E_UnInitEMS
                Call    K_UnInitKeyBoard
                Call    Error_UnInitHandler
                Call    D_UnInitDisk
                Call    K_RemoveKeyboardType
                Call    UnInitTimerHandler

                Mov     AX, 4C00h
                Int     21h

EndP            Quit

EndP            Start

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            IsStartupKeyList Far

                Mov     AL,CS:StartupList

                Ret

EndP            IsStartupKeyList

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetStartupKeyList Far

                Jmp     [CS:StartupKeyListFunction]

GetStartupKeyList1:
                Push    SI
                Mov     SI, [CS:StartupQueueOffset]

                Mov     CX, [CS:SI]
                Mov     DX, [CS:SI+2]

                Add     SI, 4
                Mov     [CS:StartupQueueOffset], SI

                Cmp     SI, [CS:StartupQueueEnd]
                
                Pop     SI
                JB      GetStartupKeyList1End

                Mov     AX, [CS:StartupQueueNextFunction]
                Mov     [CS:StartupKeyListFunction], AX

GetStartupKeyList1End:
                Ret

GetStartupKeyList2:
                Push    DS
                Push    SI

                LDS     SI, [DWord Ptr CS:StartupFileOffset]
                LodsB

                Mov     [CS:StartupFileOffset], SI

                Pop     SI
                Pop     DS

                Cmp     AL, 32
                JE      GetStartupKeyList2EndOfString
                And     AX, 0FFh
                JZ      GetStartupKeyList2EndOfString

                Mov     DX, AX
                Mov     CX, 1FFh

                Ret

GetStartupKeyList2EndOfString:
                Mov     [CS:StartupQueueOffset], Offset SaveInformation
                Mov     [CS:StartupQueueEnd], Offset ENDSAVEINFORMATION
                Mov     [CS:StartupQueueNextfunction], Offset GetStartupKeyList3
                Mov     [CS:StartupKeyListFunction], Offset GetStartupKeyList1

                Mov     CX, 11Ch        ; Enter
                Mov     DX, 0

                Ret

GetStartupKeyList3:                     ; Save module then quit
                Xor     CX, CX
                Xor     DX, DX
                Mov     [CS:StartupList], 0
                Ret

EndP            GetStartupKeyList

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            CrashRecovery Far               ; CtrlAltDel location.

                ClD
                StI

                Call    S_ClearScreen
                Call    S_InitScreen
                Call    D_InitDisk
                Call    InitMouse

                Mov     DI, Offset O1_CrashRecovery
                Mov     CX, 0FFFFh
                Call    M_Object1List

                Mov     DI, Offset O1_PatternEditList
                Mov     CX, 0FFFFh
                Jmp     M_Object1List

EndP            CrashRecovery

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            GetEnvironment Far              ; DS:SI points to string.
                                                ; CX = length of string.
                                                ; Returns ES:DI

                Mov     ES, [CS:PSP]
                Mov     ES, [ES:2Ch]            ; DS:00 points to environ.
                Xor     DI, DI

GetEnvironment1:
                Push    DI
                Push    CX
                Push    SI

                RepE    CmpSB

                Pop     SI
                Pop     CX
                Pop     DI

                JE      GetEnvironment3         ; From RepE

                Xor     AL, AL

GetEnvironment2:
                ScasB
                JNE     GetEnvironment2

                Cmp     [Byte Ptr ES:DI], AL
                JNE     GetEnvironment1

                StC
                Ret

GetEnvironment3:
                Add     DI, CX
                Inc     DI              ; Skip past '='
                ClC
                Ret

EndP            GetEnvironment

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Refresh Far

                Call    D_GetPreShellDirectory
                Call    S_InitScreen
                Call    D_InitDisk
                Call    InitMouse
                Call    D_RestorePreShellDirectory

                Mov     AX, 1
                Ret

EndP            Refresh

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            DOSShell Far

                PushAD
                Push    DS
                Push    ES

                PushF

                Call    D_GetPreShellDirectory

                Cmp     [CS:Control], 0
                JNE     DOSShell2

                Call    K_UnInitKeyBoard
                Jmp     DOSShell3

DOSShell2:
                Call    K_InstallDOSHandler
DOSShell3:

                Mov     AX, 3
                Int     10h                     ; Clr screen.

                Call    UnInitMouse

                Push    CS
                Push    CS
                Pop     DS
                Pop     ES
                        Assume DS:StartUp

                Mov     AH, 9
                Mov     DX, Offset ShellMsg
                Int     21h

                Mov     AX, 4B00h
                Mov     BX, Offset ExecData
                Mov     DX, Offset DefaultShell
                Cmp     [COMSPECFound], 0
                JE      DOSShell1

                LDS     DX, [COMSPEC]

DOSShell1:
                ClI
                Int     21h
                        Assume DS:Nothing

                PopF

                Call    S_InitScreen
                Call    D_InitDisk
                Call    InitMouse

                Cmp     [CS:Control], 0
                JNE     DOSShell4

                Call    K_InitKeyBoard
                Jmp     DOSShell5

DOSShell4:
                Call    K_UnInstallDOSHandler

DOSShell5:
                Call    D_RestorePreShellDirectory

                Pop     ES
                Pop     DS
                PopAD

                Mov     AX, 1
                Ret

EndP            DOSShell
                Assume DS:Nothing

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ


EndS

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Stack Segment                                                               ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Segment         StackSeg PARA Stack 'Stack'
StackData       DB      StackSize Dup(?)
EndS

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

End             Start
