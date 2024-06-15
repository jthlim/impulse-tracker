;
; Debug macro. To write to the file, use "Trace <logmessage>"
;

IF TRACEENABLED

IF CREATENEWLOGFILE
FirstTime       DB      0
ENDIF

LogFileName     DB      "Logfile.Txt", 0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            WriteDebugFile

                PushA
                Push    DS

                Push    CS
                Pop     DS

                Mov     DX, Offset LogFileName

IF CREATENEWLOGFILE

                  Cmp     DS:FirstTime, 0
                  JNE     WriteDebugFile1

                  Mov     AH, 3Ch
                  Xor     CX, CX
                  Int     21h
                  JC      WriteDebugFileEnd

                  Mov     DS:FirstTime, 1
                  XChg    AX, BX
                  Jmp     WriteDebugFile2

  WriteDebugFile1:

ENDIF
                Mov     AX, 3D02h
                Int     21h
                JC      WriteDebugFileEnd

                XChg    AX, BX

                Mov     AX, 4202h
                Xor     CX, CX
                Xor     DX, DX
                Int     21h             ; Move to end of file

WriteDebugFile2:
                Mov     AH, 40h
                Mov     CX, 82
                Mov     DX, SI
                Int     21h

                Mov     AH, 3Eh
                Int     21h

WriteDebugFileEnd:
                Pop     DS
                PopA
                Ret

EndP            WriteDebugFile

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Trace           Macro LogMessage
                Local X, Y

                PushF
                Push    SI
                Jmp     Y
        X:
                DB      LogMessage
                DB      80-($-Offset X) Dup (0)
                DB      0Dh, 0Ah
        Y:
                Mov     SI, Offset X
                Call    WriteDebugFile
                Pop     SI
                PopF

                EndM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ELSE

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Trace           Macro LogMessage
                EndM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ENDIF

IF SCREENTRACEENABLED

ScreenTrace     Macro Value
                Mov  Byte Ptr [FS:0], Value
                EndM

ScreenTraceStart Macro
                 Push FS
                 Push 0B800h
                 Pop  FS
                 EndM

ScreenTraceEnd   Macro
                 Pop FS
                 EndM

ELSE

ScreenTrace     Macro Value
                EndM

ScreenTraceStart Macro
                 EndM

ScreenTraceEnd   Macro
                 EndM

ENDIF

