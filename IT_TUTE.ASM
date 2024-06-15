
        Jumps
        .386

include switch.inc

IF TUTORIAL

                Extrn   S_DrawBox:Far
                Extrn   S_DrawString:Far
                Extrn   Music_GetSongSegment:Far
                Extrn   Music_GetPlayMode:Far
                Extrn   PE_GetLastInstrument:Far        ; Returns BX = LastInst-1

Segment         Pattern BYTE Public 'Code'
                Extrn   PatternDataArea:Word
                Extrn   LastKeyBoard1:Word
                Extrn   LastKeyBoard2:Word
EndS

Segment         Disk Byte Public 'Code' USE16
                Extrn   SamplesInModule:Byte
                Extrn   InSampleFileName:Byte
EndS

                Public  Glbl_TutorialHandler

Segment                 Glbl BYTE Public 'Code' USE16
                        Assume CS:Glbl, DS:Nothing, GS:Pattern

Extrn   CurrentMode:Byte

TutorialState           DW      0


; TutorialInfo structure:
;  DW Offset function
;  DB x, y (top left)
;  DB x, y (bottom right)
;  DB colour
;  DB Message, 0

TutorialFunctionArray   Label   Word
                        DW      Offset Tute_State0
                        DW      Offset Tute_State1
                        DW      Offset Tute_State2
                        DW      Offset Tute_State3
                        DW      Offset Tute_State4
                        DW      Offset Tute_State5
                        DW      Offset Tute_State6
                        DW      Offset Tute_State7
                        DW      Offset Tute_State8
                        DW      Offset Tute_State9
                        DW      Offset Tute_State10
                        DW      Offset Tute_State1
                        DW      Offset Tute_State12
                        DW      Offset Tute_State2
                        DW      Offset Tute_State14
                        DW      Offset Tute_State5
                        DW      Offset Tute_State16
                        DW      Offset Tute_State9
                        DW      Offset Tute_State18
                        DW      Offset Tute_State19
                        DW      Offset Tute_StateEnd

MAXTUTESTATE    =       ($-Offset TutorialFunctionArray)/2


TutorialInfoArray       Label   Word
                        DW      Offset TutorialDisplayState0
                        DW      Offset TutorialDisplayState1
                        DW      Offset TutorialDisplayState2
                        DW      Offset TutorialDisplayState3
                        DW      Offset TutorialDisplayState4
                        DW      Offset TutorialDisplayState5
                        DW      Offset TutorialDisplayState6
                        DW      Offset TutorialDisplayState7
                        DW      Offset TutorialDisplayState8
                        DW      Offset TutorialDisplayState9
                        DW      Offset TutorialDisplayState10
                        DW      Offset TutorialDisplayState11
                        DW      Offset TutorialDisplayState12
                        DW      Offset TutorialDisplayState13
                        DW      Offset TutorialDisplayState14
                        DW      Offset TutorialDisplayState15
                        DW      Offset TutorialDisplayState16
                        DW      Offset TutorialDisplayState17
                        DW      Offset TutorialDisplayState18
                        DW      Offset TutorialDisplayState19
                        DW      Offset TutorialDisplayState20
                        DW      Offset TutorialDisplayStatexx

TutorialDisplayState0   DB      0, 40, 79, 49
                        DB      0FFh, 20, " Welcome to the Impulse Tracker Tutorial!", 13, 13
                        DB      "This tutorial was designed to provide you with a basic understanding of how", 13
                        DB      "this program works. Everything that you learn here is exactly the same as in", 13
                        DB      "the main program. By the end of this tutorial, you should be able to compose", 13
                        DB      "your own modules!", 13, 13
                        DB      "Good luck! (Press Enter to continue)", 0

TutorialDisplayState1   DB      0, 0, 79, 4
                        DB      "This is the load-module screen that Impulse Tracker will normally begin with.", 13
                        DB      "As we will start a song afresh, switch to the sample list screen by pressing", 13
                        DB      "F3.", 0

TutorialDisplayState2   DB      36, 1, 78, 13
                        DB      "There are two basic elements to an", 13
                        DB      "Impulse Tracker module: patterns and", 13
                        DB      "samples. Samples provide all the 'real'", 13
                        DB      "sound information to the program. These", 13
                        DB      "sounds can be instruments, voices, WAV", 13
                        DB      "files - anything you like! IT understands", 13
                        DB      "a wide variety of sound files and even", 13
                        DB      "allows you to take sounds directly from", 13
                        DB      "other modules. Since there are no samples", 13
                        DB      "currently loaded, press Enter to switch", 13
                        DB      "to the load sample screen.", 0

TutorialDisplayState3   DB      0, 0, 79, 5
                        DB      "A file called TUTE.IT was included with this tutorial. You should be able to", 13
                        DB      "see it highlighted in the listing below. IT will hilight any file that it", 13
                        DB      "recognises as a sound file. You can also navigate through your directories", 13
                        DB      "from this menu. Select TUTE.IT and step into it by pressing Enter.", 0

TutorialDisplayState4   DB      2, 28, 45, 39
                        DB      "Here you can see a list of all the samples", 13
                        DB      "that are contained within TUTE.IT. To have", 13
                        DB      "a listen to how they sound, press the down", 13
                        DB      "arrow once to hilight the first sample and", 13
                        DB      "press 'Q'. Try moving to the other samples", 13
                        DB      "and playing them. Try pressing 'W', 'E',", 13
                        DB      "'R'. You will notice that the samples are", 13
                        DB      "played at a different pitch. Once you've", 13
                        DB      "heard all of the samples, select the Bass", 13
                        DB      "Drum and press Enter.", 0

TutorialDisplayState5   DB      36, 14, 78, 20
                        DB      "OK! You have now loaded the Bass Drum", 13
                        DB      "into memory. This means that you can use", 13
                        DB      "it in your songs. Lets do that now!", 13, 13
                        DB      "Press F2 to go to the pattern editor.", 0

TutorialDisplayState6   DB      33, 16, 78, 19
                        DB      "The pattern editor is where you set out the", 13
                        DB      "notes that you want to play. Press 'Q'", 0

TutorialDisplayState7   DB      33, 16, 78, 35
                        DB      "So what does this mean?", 13, 13
                        DB      "C-5 01 ", 173, 173, " .00", 13, 13
                        DB      "C-5 means to play the note C at octave 5.", 13
                        DB      "01  means to use sample number 1.", 13, 13
                        DB      "If this doesn't make sense now, don't worry!", 13
                        DB      "All of this will be explained later in this", 13
                        DB      "tutorial.", 13, 13
                        DB      "For now, try to enter a Bass Drum every four", 13
                        DB      "rows in Channel 1 (ie. on row 4, 8, 12, ...)", 13, 13
                        DB      "Continue to use 'Q' to enter the notes. The", 13
                        DB      "arrow keys may be of assistance. If you make", 13
                        DB      "a mistake, use the '.' key to blank out the", 13
                        DB      "entry.", 0

TutorialDisplayState8   DB      33, 16, 78, 21
                        DB      "OK, that's enough!", 13, 13
                        DB      "Lets take a listen to what you've done.", 13
                        DB      "Press F6 to play what you've entered.", 0

TutorialDisplayState9   DB      33, 16, 78, 23
                        DB      "As the pattern is played to you, you will", 13
                        DB      "notice that a cursor on the left hand side", 13
                        DB      "of the screen indicates the current playback", 13
                        DB      "position. Press F6 to watch that again.", 13, 13
                        DB      "When you're ready, press F8 to stop playback", 0

TutorialDisplayState10  DB      33, 16, 78, 25
                        DB      "To finish off the task of entering the Bass", 13
                        DB      "Drum, move up one row to row 16 and press", 13
                        DB      "Alt-4. This will cause the cursor to step", 13
                        DB      "4 rows after every note that you enter", 13
                        DB      "instead of 1.", 13, 13
                        DB      "Hold down 'Q' until Channel 1 has a Bass", 13
                        DB      "Drum every 4 rows until row 60.", 0

TutorialDisplayState11  DB      33, 16, 78, 21
                        DB      "Now we'll add in a snare drum. Before we do", 13
                        DB      "that though, set the cursor step back to", 13
                        DB      "a single row at a time. Press Alt-1, then", 13
                        DB      "F3 to go back to the sample list.", 0

TutorialDisplayState12  DB      36, 14, 78, 18
                        DB      "To load a sample into the second sample", 13
                        DB      "slot, first press the down arrow a single", 13
                        DB      "time so that sample two is hilighted.", 0

TutorialDisplayState13  DB      36, 14, 72, 17
                        DB      "Now press Enter to call up the Load", 13
                        DB      "Sample screen.", 0

TutorialDisplayState14  DB      7, 25, 42, 28
                        DB      "Select the Snare Drum and load it", 13
                        DB      "(by pressing Enter).", 0

TutorialDisplayState15  DB      36, 14, 74, 17
                        DB      "And now return to the Pattern Editor", 13
                        DB      "(F2)", 0

TutorialDisplayState16  DB      36, 16, 78, 24
                        DB      "Press Ctrl-PgUp to move to the top of", 13
                        DB      "the pattern and enter a snare drum in", 13
                        DB      "every 4th row starting at line 2.", 13
                        DB      13
                        DB      "Use C-5 again, and to make it easier, you", 13
                        DB      "can set the skip to 4 once you've moved", 13
                        DB      "to line 2.", 0

TutorialDisplayState17  DB      34, 16, 78, 19
                        DB      "Have a listen to what you've just created!", 13
                        DB      "(Press F6)", 0

TutorialDisplayState18  DB      36, 16, 78, 28
                        DB      "As part of this tutorial, we'll try out", 13
                        DB      "one of the block functions that IT", 13
                        DB      "offers. Our goal is to halve the speed", 13
                        DB      "at which this plays just by modifying", 13
                        DB      "the pattern data. IT has two functions", 13
                        DB      "that will automatically halve or double", 13
                        DB      "the length of a hilighted block.", 13, 13
                        DB      "First, hilight channel 1.", 13
                        DB      "Move to the top of the channel first", 13
                        DB      "by pressing Ctrl-PgUp, then press Alt-L", 0

TutorialDisplayState19  DB      36, 16, 78, 26
                        DB      "Alt-L is a function which will mark the", 13
                        DB      "entire channel that your cursor is", 13
                        DB      "currently on. Pressing it twice will", 13
                        DB      "mark the entire pattern. For now, we", 13
                        DB      "only need the first channel so you do", 13
                        DB      "not need to press it a second time.", 13
                        DB      13
                        DB      "Now that the block is marked, press", 13
                        DB      "Alt-G to actually double the block size!", 0

TutorialDisplayState20  DB      36, 16, 78, 33
                        DB      "Uhhh. Ooops!! That was supposed to be", 13
                        DB      "Alt-F. No matter - the automatic undo", 13
                        DB      "in IT will be able to recover our data.", 13
                        DB      "(Yes, we could just double it twice and", 13
                        DB      "everything would be perfectly fine, but", 13
                        DB      "this is meant to teach you about IT,", 13
                        DB      "right? [smile])", 13
                        DB      13
                        DB      "Whenever you do a block function in IT", 13
                        DB      "the contents of the entire pattern is", 13
                        DB      "saved first. IT will store up to 10 of", 13
                        DB      "these in memory so that you can recover", 13
                        DB      "from any mistakes that you make.", 13
                        DB      13
                        DB      "Press Ctrl-Backspace to pull up the", 13
                        DB      "undo menu.", 0

TutorialDisplayStatexx  DB      33, 16, 78, 21
                        DB      "Incomplete...", 0

TuteFileName            DB      "TUTE.IT"
BassDrumText            DB      "Bass Drum"
SnareDrumText           DB      "Snare Drum"

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Tute_State0

                Cmp     AL, 9
                Ret

EndP            Tute_State0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Tute_State1

                Cmp     AL, 3
                Ret

EndP            Tute_State1

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Tute_State2

                Cmp     AL, 13
                Ret

EndP            Tute_State2

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Tute_State3

                Push    Disk
                Pop     ES
                        Assume ES:Disk

                Cmp     ES:SamplesInModule, 1
                JNE     Tute_State3a

                Mov     DI, Offset InSampleFileName
                Mov     SI, Offset TuteFileName
                Mov     CX, 7
                RepE    CmpsB

Tute_State3a:
                Ret

EndP            Tute_State3

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Tute_State4

                Call    Music_GetSongSegment
                Mov     ES, AX
                Mov     DI, [ES:64912]
                Mov     SI, Offset BassDrumText
                Add     DI, 14h
                Mov     CX, 9
                RepE    CmpSB
                Ret

EndP            Tute_State4

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Tute_State5

                Cmp     AL, 2
                Ret

EndP            Tute_State5

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Tute_State6

                Cmp     Word Ptr [FS:0], 13Ch
                Ret

EndP            Tute_State6

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Tute_State7

                Cmp     Word Ptr [FS:320*16], 13Ch
                Ret

EndP            Tute_State7

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Tute_State8

                Call    Music_GetPlayMode
                Cmp     AX, 1

                Ret

EndP            Tute_State8

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Tute_State9

                Call    Music_GetPlayMode
                Test    AX, AX
                Ret

EndP            Tute_State9

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Tute_State10

                Cmp     Word Ptr [FS:60*320], 13Ch
                Ret

EndP            Tute_State10

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Tute_State12

                Call    PE_GetLastInstrument
                Cmp     BX, 1
                Ret

EndP            Tute_State12

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Tute_State14

                Call    Music_GetSongSegment
                Mov     ES, AX
                Mov     DI, [ES:64914]
                Mov     SI, Offset SnareDrumText
                Add     DI, 14h
                Mov     CX, 10
                RepE    CmpSB
                Ret

EndP            Tute_State14

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Tute_StateEnd

                Inc     AX      ; Ensure zero flag is not set.
                Ret

EndP            Tute_StateEnd

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Tute_State16

                Cmp     Word Ptr [FS:62*320], 23Ch
                Ret

EndP            Tute_State16

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Tute_State18

                Cmp     [Word Ptr GS:LastKeyboard1+2], 2600h
                Ret

EndP            Tute_State18

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Tute_State19

                Cmp     [Word Ptr GS:LastKeyboard1+2], 2200h
                Ret

EndP            Tute_State19

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            Glbl_TutorialHandler Far

                PushAD
                Push    DS

                Push    CS
                Pop     DS
                        Assume DS:Glbl

                Push    Pattern
                Pop     GS

                Mov     FS, [GS:PatternDataArea]
                        Assume FS:Nothing

                Mov     BX, [TutorialState]
                Mov     AL, CurrentMode
                LEA     SI, [EBX+EBX]

                Push    BX
                Call    [TutorialFunctionArray+SI]
                Pop     BX
                JNE     Glbl_TutorialHandler1

                Inc     BX

Glbl_TutorialHandler1:
                Mov     [TutorialState], BX

                Cmp     BX, MAXTUTESTATE
                JAE     Tute_TuteFinished

                Xor     AX, AX
                LEA     SI, [EBX+EBX]
                Mov     SI, [TutorialInfoArray+SI]
                LodsB
                Push    AX
                LodsB
                Push    AX
                LodsB
                Push    AX
                LodsB
                Push    AX
                Mov     AL, 30
                Push    AX

                Call    S_DrawBox
                Add     SP, 10
                Mov     AL, 80
                Mul     Byte Ptr [SI-3] ; y*80
                Add     AL, Byte Ptr [SI-4]
                AdC     AH, 0
                LEA     DI, [EAX+EAX]
                Add     DI, (80+1)*2
                Mov     AH, 13h
                Call    S_DrawString

Tute_TuteFinished:
                Pop     DS
                PopAD
                Ret

EndP            Glbl_TutorialHandler
                Assume DS:Nothing, FS:Nothing

EndS

ENDIF

End
