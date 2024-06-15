;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Help Module                                                                 ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                        .386
                        Jumps

include switch.inc

Segment                 Object1 BYTE Public 'Data'
EndS

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Externals                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                Extrn   M_Object1List:Far
                Extrn   Glbl_SaveMode:Far
                Extrn   Glbl_RestoreMode:Far

                Extrn   S_DrawString:Far

                Extrn   O1_HelpList:Far

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Globals                                                                     ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                 
                Global  H_SetHelpContext:Far
                Global  H_DrawHelp:Far
                Global  H_Help:Far
                Global  H_HelpUp:Far
                Global  H_HelpDown:Far
                Global  H_HelpPgUp:Far
                Global  H_HelpPgDn:Far
                Global  H_HelpESC:Far

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

Segment         Object1 BYTE Public 'Data'
EndS

Segment                 Help BYTE Public USE16 'Code'
                        Assume CS:Help, DS:Nothing

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Variables                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

 ; Help contexts....
 ;  0 = Order list & Panning
 ;  1 = Pattern edit list
 ;  2 = Sample list
 ;  3 = Load module
 ;  4 = Order list & Volume
 ;  5 = Configuration screen
 ;  6 = Load sample list
 ;  7 = Instrument list
 ;  8 = Keyboard list
 ;  9 = Info page
 ; 10 = Palette configuration
 ; 11 = Instrument list
 ; 12 = message editor
 ; 13 = MIDI Input
 ; 14 = MIDI Output

HelpContext             DW      0
TopLine                 DW      0

Positions               DW      15 Dup (0)
              
HelpContextPtrs         Label   Word
                        DW      Offset HelpContext0Ptrs
                        DW      Offset HelpContext1Ptrs
                        DW      Offset HelpContext2Ptrs
                        DW      Offset NoHelpContext
                        DW      Offset HelpContext4Ptrs
                        DW      Offset NoHelpContext
                        DW      Offset NoHelpContext
                        DW      Offset HelpContext7Ptrs
                        DW      Offset NoHelpContext
                        DW      Offset HelpContext9Ptrs
                        DW      Offset NoHelpContext
                        DW      Offset NoHelpContext
                        DW      Offset HelpContext12Ptrs
                        DW      Offset NoHelpContext
                        DW      Offset NoHelpContext

NoHelpContext           DW      Offset NewLine
                        DW      Offset HelpGlobal_0
                        DW      Offset HelpGlobal_1
                        DW      Offset HelpGlobal_37
                        DW      Offset HelpGlobal_3
                        DW      Offset HelpGlobal_4
                        DW      Offset HelpGlobal_20
                        DW      Offset HelpGlobal_9
                        DW      Offset HelpGlobal_10
                        DW      Offset HelpGlobal_19
                        DW      Offset HelpGlobal_11
                        DW      Offset HelpGlobal_12
                        DW      Offset HelpGlobal_33
                        DW      Offset HelpGlobal_13
                        DW      Offset HelpGlobal_5
                        DW      Offset HelpGlobal_6
                        DW      Offset HelpGlobal_2
                        DW      Offset HelpGlobal_7
                        DW      Offset HelpGlobal_8
                        DW      Offset HelpGlobal_32
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_17
                        DW      Offset HelpGlobal_31
                        DW      Offset HelpGlobal_18
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_16
                        DW      Offset HelpGlobal_34
                        DW      Offset HelpGlobal_35
                        DW      Offset HelpGlobal_36
                        DW      Offset HelpGlobal_21
                        DW      Offset HelpGlobal_14
                        DW      Offset HelpGlobal_15
                        DW      0                                
   
HelpContext0Ptrs        DW      Offset HelpContext0_26
                        DW      Offset HelpContext0_0
                        DW      Offset HelpContext0_27
                        DW      Offset NewLine
                        DW      Offset HelpContext0_6
                        DW      Offset HelpContext0_28
                        DW      Offset HelpContext0_8
                        DW      Offset HelpContext0_9
                        DW      Offset HelpContext0_13
                        DW      Offset HelpContext0_14
                        DW      Offset HelpContext0_12
                        DW      Offset HelpContext0_15
                        DW      Offset NewLine
                        DW      Offset HelpContext0_30
                        DW      Offset HelpContext0_29
                        DW      Offset NewLine
                        DW      Offset Divider
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_0
                        DW      Offset HelpGlobal_1
                        DW      Offset HelpGlobal_37
                        DW      Offset HelpGlobal_3
                        DW      Offset HelpGlobal_4
                        DW      Offset HelpGlobal_9
                        DW      Offset HelpGlobal_10
                        DW      Offset HelpGlobal_19
                        DW      Offset HelpGlobal_11
                        DW      Offset HelpGlobal_12
                        DW      Offset HelpGlobal_33
                        DW      Offset HelpGlobal_13
                        DW      Offset HelpGlobal_5
                        DW      Offset HelpGlobal_6
                        DW      Offset HelpGlobal_2
                        DW      Offset HelpGlobal_7
                        DW      Offset HelpGlobal_8
                        DW      Offset HelpGlobal_32
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_17
                        DW      Offset HelpGlobal_31
                        DW      Offset HelpGlobal_18
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_16
                        DW      Offset HelpGlobal_34
                        DW      Offset HelpGlobal_35
                        DW      Offset HelpGlobal_36
                        DW      Offset HelpGlobal_21
                        DW      Offset HelpGlobal_14
                        DW      Offset HelpGlobal_15
                        DW      Offset NewLine
                        DW      Offset Divider
                        DW      0                                

HelpContext4Ptrs        DW      Offset HelpContext4_0
                        DW      Offset HelpContext4_1
                        DW      Offset HelpContext4_2
                        DW      Offset NewLine
                        DW      Offset HelpContext0_6
                        DW      Offset HelpContext0_28
                        DW      Offset HelpContext0_8
                        DW      Offset HelpContext0_9
                        DW      Offset HelpContext0_13
                        DW      Offset HelpContext0_14
                        DW      Offset HelpContext0_12
                        DW      Offset HelpContext0_15
                        DW      Offset NewLine
                        DW      Offset Divider
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_0
                        DW      Offset HelpGlobal_1
                        DW      Offset HelpGlobal_37
                        DW      Offset HelpGlobal_3
                        DW      Offset HelpGlobal_4
                        DW      Offset HelpGlobal_20
                        DW      Offset HelpGlobal_9
                        DW      Offset HelpGlobal_22
                        DW      Offset HelpGlobal_10
                        DW      Offset HelpGlobal_19
                        DW      Offset HelpGlobal_11
                        DW      Offset HelpGlobal_12
                        DW      Offset HelpGlobal_33
                        DW      Offset HelpGlobal_13
                        DW      Offset HelpGlobal_5
                        DW      Offset HelpGlobal_23
                        DW      Offset HelpGlobal_6
                        DW      Offset HelpGlobal_2
                        DW      Offset HelpGlobal_7
                        DW      Offset HelpGlobal_8
                        DW      Offset HelpGlobal_32
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_17
                        DW      Offset HelpGlobal_31
                        DW      Offset HelpGlobal_18
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_16
                        DW      Offset HelpGlobal_34
                        DW      Offset HelpGlobal_35
                        DW      Offset HelpGlobal_36
                        DW      Offset HelpGlobal_21
                        DW      Offset HelpGlobal_14
                        DW      Offset HelpGlobal_15
                        DW      Offset NewLine
                        DW      Offset Divider
                        DW      0                                

NewLine                 DB      0, 0
Divider                 DB      2, 0FFh, 76, 154, 0

HelpContext0_26         DB      27, 0FFh, 1, 139, 0FFh, 26, 134, 0FFh, 1, 138, 0
HelpContext0_0          DB      27, 0FFh, 1, 132, '  ', 0B9h, 0AAh, 0A1h, 0B8h, ' ', 0FFh, 1, 145, 0
HelpContext0_27         DB      27, 0FFh, 1, 137, 0FFh, 26, 143, 0FFh, 1, 150, 0

HelpContext4_0          DB      22, 0FFh, 1, 139, 0FFh, 33, 134, 0FFh, 1, 138, 0
HelpContext4_1          DB      22, 0FFh, 1, 132, '  ', 0B9h, 0AAh, 0A1h, 8Dh, 89h, ' ', 0FFh, 1, 145, 0
HelpContext4_2          DB      22, 0FFh, 1, 137, 0FFh, 33, 143, 0FFh, 1, 150, 0

HelpContext0_6          DB      3, 0B9h, 0ADh, '.', 0
HelpContext0_28         DB      5, 'N', 0FFh, 17,            ' ', 83h, 0B4h, 85h, 0
HelpContext0_8          DB      5, '-', 0FFh, 17,            ' End ', 0BEh, 'song mark', 0
HelpContext0_9          DB      5, '+', 0FFh, 17,            ' Skip ', 0B1h, 0B4h, 0B9h, 'mark', 0
HelpContext0_13         DB      5, 0C1h, 0FFh, 15,          ' ', 83h, 0BFh, 85h, 0
HelpContext0_14         DB      5, 0C2h, 0FFh, 15,          ' ', 84h, 0BFh, 85h, 0
HelpContext0_12         DB      5, 'Tab/', 82h, 'Tab', 0FFh, 5, ' ', 9Ch, 0B1h, 0B4h, 0B6h, 0
HelpContext0_15         DB      5, 81h, 'F7', 0FFh, 11,      ' ', 9Fh, 'this ', 0B9h, 0B4h, 0

HelpContext0_30         DB      3, 0B8h, 0ADh, '.', 0
HelpContext0_29         DB      5, 'L/M/R/S', 0FFh, 11,      ' ', 0A6h, 0B5h, 0B1h, 'Left/Middle/Right/Surround', 0

HelpGlobal_0            DB      3, 'G', 0B2h, 0ADh, '.', 0
HelpGlobal_1            DB      5, 'F1', 0FFh, 16,       ' Help (Context sensitive!)', 0
HelpGlobal_37           DB      5, 82h, 'F1', 0FFh, 10, ' MIDI Screen', 0
HelpGlobal_3            DB      5, 'F2', 0FFh, 16,       ' ', 86h, 'Editor / ', 86h, 'Editor Options', 0
HelpGlobal_4            DB      5, 'F3', 0FFh, 16,       ' ', 94h, 0AAh, 0
HelpGlobal_20           DB      5, 81h, 'F3', 0FFh, 11,  ' ', 94h, 0ABh, 0
HelpGlobal_9            DB      5, 'F4', 0FFh, 16,       ' ', 8Eh, 0AAh, 0
HelpGlobal_22           DB      5, 81h, 'F4', 0FFh, 11,  ' ', 8Eh, 0ABh, 0
HelpGlobal_10           DB      5, 'F5', 0FFh, 16,       ' ', 9Fh, 'Information / ', 9Fh, 'song', 0
HelpGlobal_19           DB      5, 81h, 'F5', 0FFh, 11,  ' ', 9Fh, 'Song', 0
HelpGlobal_11           DB      5, 'F6', 0FFh, 16,       ' ', 9Fh, 0A2h, 85h, 0
HelpGlobal_12           DB      5, 82h, 'F6', 0FFh, 10, ' ', 9Fh, 'song ', 0A9h, 0A2h, 0B9h, 0
HelpGlobal_33           DB      5, 'F7', 0FFh, 16,       ' ', 9Fh, 0A9h, 'mark / ', 0A2h, 'row', 0
HelpGlobal_13           DB      5, 'F8', 0FFh, 16,       ' Stop Playback', 0
HelpGlobal_5            DB      5, 'F9', 0FFh, 16,       ' Load Module', 0
HelpGlobal_23           DB      5, 82h, 'F9', 0FFh, 10, ' Message Editor', 0
HelpGlobal_6            DB      5, 'F10', 0FFh, 15,      ' Save Module', 0
HelpGlobal_2            DB      5, 'F11', 0FFh, 15,      ' ', 0B9h, 0AAh, 0A1h, 0B8h, 0
HelpGlobal_7            DB      3, '2*F11', 0FFh, 15,    ' ', 0B9h, 0AAh, 0A1h, 8Dh, 89h, 0
HelpGlobal_8            DB      5, 'F12', 0FFh, 15,      ' Song Variables & Directory Configuration', 0
HelpGlobal_32           DB      5, 81h, 'F12', 0FFh, 10, ' Palette Configuration', 0

HelpGlobal_17           DB      5, '{ }', 0FFh, 15, ' ', 93h, '/', 92h, ' playback ', 0C4h, 0
HelpGlobal_31           DB      5, '[ ]', 0FFh, 15, ' ', 93h, '/', 92h, ' g', 0B2h, 8Ah, 0
HelpGlobal_18           DB      5, 80h, 'F1 -> ', 80h, 'F8  ', 9Dh, 0A3h, 's 1->8', 0

HelpGlobal_16           DB      5, 81h, 'D', 0FFh, 12, ' DOS Shell', 0
HelpGlobal_34           DB      5, 81h, 'E', 0FFh, 12, ' Refresh screen ', 0A1h, 'reset cache identification', 0
HelpGlobal_35           DB      5, 81h, 'I', 0FFh, 12, ' Reinitialise sound driver', 0
HelpGlobal_36           DB      5, 81h, 'M', 0FFh, 12, ' ', 9Dh, 'mouse cursor', 0
HelpGlobal_21           DB      5, 81h, 'N', 0FFh, 12, ' New Song', 0
HelpGlobal_14           DB      5, 81h, 'Q', 0FFh, 12, ' Quit ', 0B1h, 'DOS', 0
HelpGlobal_15           DB      5, 81h, 'S', 0FFh, 12, ' Save ', 0A2h, 'song', 0


HelpContext1Ptrs        Label   Word
                        DW      Offset HelpContext1_0
                        DW      Offset HelpContext1_1
                        DW      Offset HelpContext1_2
                        DW      Offset NewLine
                        DW      Offset HelpContext1_3
                        DW      Offset NewLine
                        DW      Offset HelpContext1_200
                        DW      Offset HelpContext1_201
                        DW      Offset HelpContext1_202
                        DW      Offset HelpContext1_203
                        DW      Offset HelpContext1_204
                        DW      Offset HelpContext1_205
                        DW      Offset HelpContext1_206
                        DW      Offset HelpContext1_207
                        DW      Offset HelpContext1_208
                        DW      Offset NewLine
                        DW      Offset HelpContext1_299
                        DW      Offset HelpContext1_4
                        DW      Offset HelpContext1_5
                        DW      Offset HelpContext1_6
                        DW      Offset HelpContext1_7
                        DW      Offset HelpContext1_8
                        DW      Offset HelpContext1_9
                        DW      Offset HelpContext1_10
                        DW      Offset HelpContext1_11
                        DW      Offset HelpContext1_12
                        DW      Offset HelpContext1_13
                        DW      Offset HelpContext1_14
                        DW      Offset HelpContext1_15
                        DW      Offset HelpContext1_16
                        DW      Offset HelpContext1_17
                        DW      Offset HelpContext1_18
                        DW      Offset HelpContext1_19
                        DW      Offset HelpContext1_20
                        DW      Offset HelpContext1_21
                        DW      Offset HelpContext1_22
                        DW      Offset HelpContext1_23
                        DW      Offset HelpContext1_24
                        DW      Offset HelpContext1_141
                        DW      Offset HelpContext1_142
                        DW      Offset HelpContext1_143
                        DW      Offset HelpContext1_25
                        DW      Offset HelpContext1_26
                        DW      Offset HelpContext1_135
                        DW      Offset HelpContext1_136
                        DW      Offset HelpContext1_137
                        DW      Offset HelpContext1_27
                        DW      Offset HelpContext1_28
                        DW      Offset HelpContext1_29
                        DW      Offset HelpContext1_30
                        DW      Offset HelpContext1_31
                        DW      Offset HelpContext1_32
                        DW      Offset HelpContext1_33
                        DW      Offset HelpContext1_34
                        DW      Offset HelpContext1_35
                        DW      Offset HelpContext1_36
                        DW      Offset HelpContext1_45
                        DW      Offset HelpContext1_46
                        DW      Offset HelpContext1_47
                        DW      Offset HelpContext1_48
                        DW      Offset HelpContext1_49
                        DW      Offset HelpContext1_50
                        DW      Offset HelpContext1_51
                        DW      Offset HelpContext1_62
                        DW      Offset HelpContext1_63
                        DW      Offset HelpContext1_64
                        DW      Offset HelpContext1_65
                        DW      Offset HelpContext1_66
                        DW      Offset HelpContext1_52
                        DW      Offset HelpContext1_53
                        DW      Offset HelpContext1_144
                        DW      Offset HelpContext1_145
                        DW      Offset HelpContext1_153
                        DW      Offset HelpContext1_154
                        DW      Offset HelpContext1_155
                        DW      Offset HelpContext1_156
                        DW      Offset HelpContext1_157
                        DW      Offset HelpContext1_162
                        DW      Offset HelpContext1_168
                        DW      Offset HelpContext1_169
                        DW      Offset HelpContext1_170
                        DW      Offset HelpContext1_171
                        DW      Offset HelpContext1_54
                        DW      Offset HelpContext1_55
                        DW      Offset HelpContext1_56
                        DW      Offset HelpContext1_57
                        DW      Offset HelpContext1_146
                        DW      Offset HelpContext1_58
                        DW      Offset HelpContext1_59
                        DW      Offset HelpContext1_60
                        DW      Offset HelpContext1_61
                        DW      Offset HelpContext1_179
                        DW      Offset HelpContext1_180
                        DW      Offset HelpContext1_67
                        DW      Offset HelpContext1_68
                        DW      Offset HelpContext1_69
                        DW      Offset HelpContext1_70
                        DW      Offset HelpContext1_138
                        DW      Offset HelpContext1_139
                        DW      Offset HelpContext1_140
                        DW      Offset HelpContext1_71
                        DW      Offset HelpContext1_72
                        DW      Offset HelpContext1_73
                        DW      Offset NewLine
                        DW      Offset Divider
                        DW      Offset NewLine
                        DW      Offset HelpContext1_74
                        DW      Offset HelpContext1_114
                        DW      Offset HelpContext1_115
                        DW      Offset HelpContext1_134
                        DW      Offset HelpContext1_75
                        DW      Offset HelpContext1_76
                        DW      Offset HelpContext1_77
                        DW      Offset HelpContext1_78
                        DW      Offset HelpContext1_79
                        DW      Offset HelpContext1_80
                        DW      Offset HelpContext1_81
                        DW      Offset HelpContext1_181
                        DW      Offset NewLine
                        DW      Offset HelpContext1_82
                        DW      Offset HelpContext1_83
                        DW      Offset HelpContext1_163
                        DW      Offset HelpContext1_84
                        DW      Offset HelpContext1_85
                        DW      Offset NewLine
                        DW      Offset HelpContext1_86
                        DW      Offset HelpContext1_127
                        DW      Offset NewLine
                        DW      Offset HelpContext1_87
                        DW      Offset HelpContext1_164
                        DW      Offset HelpContext1_129
                        DW      Offset HelpContext1_88
                        DW      Offset HelpContext1_131
                        DW      Offset HelpContext1_90
                        DW      Offset HelpContext1_89
                        DW      Offset HelpContext1_160
                        DW      Offset HelpContext1_91
                        DW      Offset HelpContext1_92
                        DW      Offset HelpContext1_93
                        DW      Offset NewLine
                        DW      Offset HelpContext1_116
                        DW      Offset HelpContext1_124
                        DW      Offset NewLine
                        DW      Offset HelpContext1_130
                        DW      Offset HelpContext1_117
                        DW      Offset HelpContext1_161
                        DW      Offset NewLine
                        DW      Offset HelpContext1_166
                        DW      Offset HelpContext1_174
                        DW      Offset HelpContext1_300
                        DW      Offset NewLine
                        DW      Offset HelpContext1_176
                        DW      Offset NewLine
                        DW      Offset HelpContext1_118
                        DW      Offset HelpContext1_119
                        DW      Offset HelpContext1_120
                        DW      Offset HelpContext1_121
                        DW      Offset HelpContext1_122
                        DW      Offset HelpContext1_123
                        DW      Offset HelpContext1_128
                        DW      Offset NewLine
                        DW      Offset HelpContext1_167
                        DW      Offset NewLine
                        DW      Offset HelpContext1_159
                        DW      Offset NewLine
                        DW      Offset HelpContext1_94
                        DW      Offset HelpContext1_95
                        DW      Offset HelpContext1_96
                        DW      Offset HelpContext1_97
                        DW      Offset HelpContext1_98
                        DW      Offset HelpContext1_165
                        DW      Offset NewLine
                        DW      Offset HelpContext1_99
                        DW      Offset NewLine
                        DW      Offset HelpContext1_113
                        DW      Offset HelpContext1_100
                        DW      Offset HelpContext1_101
                        DW      Offset HelpContext1_102
                        DW      Offset HelpContext1_103
                        DW      Offset HelpContext1_104
                        DW      Offset HelpContext1_133
                        DW      Offset HelpContext1_105
                        DW      Offset HelpContext1_106
                        DW      Offset HelpContext1_132
                        DW      Offset HelpContext1_107
                        DW      Offset NewLine
                        DW      Offset HelpContext1_108
                        DW      Offset HelpContext1_109
                        DW      Offset HelpContext1_110
                        DW      Offset HelpContext1_111
                        DW      Offset HelpContext1_173
                        DW      Offset NewLine
                        DW      Offset HelpContext1_125
                        DW      Offset HelpContext1_126
                        DW      Offset NewLine
                        DW      Offset HelpContext1_112
                        DW      Offset HelpContext1_175
                        DW      Offset NewLine
                        DW      Offset HelpContext1_147
                        DW      Offset HelpContext1_148
                        DW      Offset HelpContext1_149
                        DW      Offset NewLine
                        DW      Offset HelpContext1_152
                        DW      Offset HelpContext1_158
                        DW      Offset NewLine
                        DW      Offset HelpContext1_150
                        DW      Offset HelpContext1_151
                        DW      Offset NewLine
                        DW      Offset HelpContext1_172
                        DW      Offset HelpContext1_177
                        DW      Offset HelpContext1_178
                        DW      Offset NewLine
                        DW      Offset Divider
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_0
                        DW      Offset HelpGlobal_1
                        DW      Offset HelpGlobal_37
                        DW      Offset HelpGlobal_3
                        DW      Offset HelpGlobal_4
                        DW      Offset HelpGlobal_20
                        DW      Offset HelpGlobal_9
                        DW      Offset HelpGlobal_22
                        DW      Offset HelpGlobal_10
                        DW      Offset HelpGlobal_19
                        DW      Offset HelpGlobal_11
                        DW      Offset HelpGlobal_12
                        DW      Offset HelpGlobal_33
                        DW      Offset HelpGlobal_13
                        DW      Offset HelpGlobal_5
                        DW      Offset HelpGlobal_23
                        DW      Offset HelpGlobal_6
                        DW      Offset HelpGlobal_2
                        DW      Offset HelpGlobal_7
                        DW      Offset HelpGlobal_8
                        DW      Offset HelpGlobal_32
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_17
                        DW      Offset HelpGlobal_31
                        DW      Offset HelpGlobal_18
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_16
                        DW      Offset HelpGlobal_34
                        DW      Offset HelpGlobal_35
                        DW      Offset HelpGlobal_36
                        DW      Offset HelpGlobal_21
                        DW      Offset HelpGlobal_14
                        DW      Offset HelpGlobal_15
                        DW      Offset NewLine
                        DW      Offset Divider

        Comment &

                        DW      Offset NewLine
                        DW      Offset HelpHexTable0
                        DW      Offset HelpHexTable1
                        DW      Offset HelpHexTable2
                        DW      Offset NewLine
                        DW      Offset HelpHexTable3
                        DW      Offset Divider
                        DW      Offset HelpHexTable4
                        DW      Offset HelpHexTable5
                        DW      Offset HelpHexTable6
                        DW      Offset HelpHexTable7
                        DW      Offset HelpHexTable8
                        DW      Offset HelpHexTable9
                        DW      Offset HelpHexTable10
                        DW      Offset HelpHexTable11
                        DW      Offset HelpHexTable12
                        DW      Offset HelpHexTable13
                        DW      Offset HelpHexTable14
                        DW      Offset HelpHexTable15
                        DW      Offset HelpHexTable16
                        DW      Offset HelpHexTable17
                        DW      Offset HelpHexTable18
                        DW      Offset HelpHexTable19
                        DW      Offset HelpHexTable20
                        DW      Offset HelpHexTable21
                        DW      Offset HelpHexTable22
                        DW      Offset HelpHexTable23
                        DW      Offset HelpHexTable24
                        DW      Offset HelpHexTable25
                        DW      Offset HelpHexTable26
                        DW      Offset HelpHexTable27
                        DW      Offset HelpHexTable28
                        DW      Offset HelpHexTable29
                        DW      Offset HelpHexTable30
                        DW      Offset HelpHexTable31
                        DW      Offset HelpHexTable32
                        DW      Offset HelpHexTable33
                        DW      Offset HelpHexTable34
                        DW      Offset HelpHexTable35
                        DW      Offset Divider

        &
                        DW      0

HelpContext1_0          DB      32, 0FFh, 1, 139, 0FFh, 16, 134, 0FFh, 1, 138, 0
HelpContext1_1          DB      32, 0FFh, 1, 132, '  ', 86h, 'Edit  ', 0FFh, 1, 145, 0
HelpContext1_2          DB      32, 0FFh, 1, 137, 0FFh, 16, 143, 0FFh, 1, 150, 0
HelpContext1_3          DB      3, 'Summary ', 0BEh, 'Effects.', 0

HelpContext1_200        DB      4, 89h, 'Column ', 0BDh, 's.', 0
HelpContext1_201        DB      5, 'Ax', 8Bh, 8Ah, 87h, 0
HelpContext1_202        DB      5, 'Bx', 8Bh, 8Ah, 88h, 0
HelpContext1_203        DB      5, 'Cx ', 89h, 87h, 0
HelpContext1_204        DB      5, 'Dx ', 89h, 88h, 0
HelpContext1_205        DB      5, 'Ex ', 0BAh, 88h, 0
HelpContext1_206        DB      5, 'Fx ', 0BAh, 87h, 0
HelpContext1_207        DB      5, 'Gx ', 0BCh, 0B1h, 0A5h, 0A0h, 0C4h, 'x', 0
HelpContext1_208        DB      5, 'Hx V', 0B3h, 0A0h, 0C6h, 'x', 0

HelpContext1_299        DB      4, 'General ', 0BDh, 's.', 0

HelpContext1_4          DB      5, 'Axx ', 0A6h, 'song ', 0C4h, '(hex)', 0
HelpContext1_5          DB      5, 'Bxx Jump ', 0B1h, 0B9h, '(hex)', 0
HelpContext1_6          DB      5, 'Cxx Break ', 0B1h, 'row xx (hex) ', 0BEh, 0B4h, 85h, 0
HelpContext1_7          DB      5, 'D0x ', 89h, 88h, 0
HelpContext1_8          DB      5, 'Dx0 ', 89h, 87h, 0
HelpContext1_9          DB      5, 'DFx', 8Bh, 8Ah, 88h, 0
HelpContext1_10         DB      5, 'DxF', 8Bh, 8Ah, 87h, 0
HelpContext1_11         DB      5, 'Exx ', 0BAh, 88h, 'x', 0
HelpContext1_12         DB      5, 'EFx', 8Bh, 0BBh, 88h, 0
HelpContext1_13         DB      5, 'EEx Extra fine ', 0BBh, 88h, 0
HelpContext1_14         DB      5, 'Fxx ', 0BAh, 87h, 'x', 0
HelpContext1_15         DB      5, 'FFx', 8Bh, 0BBh, 87h, 0
HelpContext1_16         DB      5, 'FEx Extra fine ', 0BBh, 87h, 0
HelpContext1_17         DB      5, 'Gxx ', 0BCh, 0B1h, 0A5h, 0A0h, 0C4h, 'xx', 0
HelpContext1_18         DB      5, 'Hxy V', 0B3h, 0A0h, 0C5h, 0
HelpContext1_19         DB      5, 'Ixy Tremor ', 0A0h, 'ontime x ', 0A1h, 'offtime y', 0
HelpContext1_20         DB      5, 'Jxy Arpeggio ', 0A0h, 'halftones x ', 0A1h, 'y', 0
HelpContext1_21         DB      5, 'Kxx', 9Bh, 'H00 & Dxx', 0
HelpContext1_22         DB      5, 'Lxx', 9Bh, 'G00 & Dxx', 0
HelpContext1_23         DB      5, 'Mxx ', 0A6h, 0A4h, 8Ah, 0B1h, 'xx (0->40h)', 0
HelpContext1_24         DB      5, 'N0x ', 8Dh, 8Ah, 88h, 0
HelpContext1_141        DB      5, 'Nx0 ', 8Dh, 8Ah, 87h, 0
HelpContext1_142        DB      5, 'NFx', 8Bh, 0A4h, 8Ah, 88h, 0
HelpContext1_143        DB      5, 'NxF', 8Bh, 0A4h, 8Ah, 87h, 0
HelpContext1_25         DB      5, 'Oxx ', 0A6h, 95h, ' offset ', 0B1h, 'yxx00h, y set ', 0A0h, 'SAy', 0
HelpContext1_26         DB      5, 'P0x ', 0B8h, 0A7h, 0B1h, 'right ', 0B0h, 'x', 0
HelpContext1_135        DB      5, 'Px0 ', 0B8h, 0A7h, 0B1h, 'left ', 0B0h, 'x', 0
HelpContext1_136        DB      5, 'PFx', 8Bh, 0B5h, 0A7h, 0B1h, 'right ', 0B0h, 'x', 0
HelpContext1_137        DB      5, 'PxF', 8Bh, 0B5h, 0A7h, 0B1h, 'left ', 0B0h, 'x', 0
HelpContext1_27         DB      5, 'Qxy Retrigger ', 0A5h, 'every y ticks ', 0A0h, 8Ah, 'modifier x', 0
HelpContext1_28         DB      7, 'Values for x:', 0
HelpContext1_29         DB      9, '0: No ', 8Ah, 0C9h, 0FFh, 8, ' 8: Not used', 0
HelpContext1_30         DB      9, '1: -1', 0FFh, 23, ' 9: +1', 0
HelpContext1_31         DB      9, '2: -2', 0FFh, 23, ' A: +2', 0
HelpContext1_32         DB      9, '3: -4', 0FFh, 23, ' B: +4', 0
HelpContext1_33         DB      9, '4: -8', 0FFh, 23, ' C: +8', 0
HelpContext1_34         DB      9, '5: -16', 0FFh, 22, ' D: +16', 0
HelpContext1_35         DB      9, '6: *2/3', 0FFh, 21, ' E: *3/2', 0
HelpContext1_36         DB      9, '7: *1/2', 0FFh, 21, ' F: *2', 0
; HelpContext1_37         DB      9, '8: Not used', 0
; HelpContext1_38         DB      9, '9: +1', 0
; HelpContext1_39         DB      9, 'A: +2', 0
; HelpContext1_40         DB      9, 'B: +4', 0
; HelpContext1_41         DB      9, 'C: +8', 0
; HelpContext1_42         DB      9, 'D: +16', 0
; HelpContext1_43         DB      9, 'E: *3/2', 0
; HelpContext1_44         DB      9, 'F: *2', 0
HelpContext1_45         DB      5, 'Rxy Tremelo ', 0A0h, 0C5h, 0
HelpContext1_46         DB      5, 0FEh, 7, 'S0x ', 0A6h, 'filter', 0
HelpContext1_47         DB      5, 0FEh, 7, 'S1x ', 0A6h, 'glissando control', 0
HelpContext1_48         DB      5, 0FEh, 7, 'S2x ', 0A6h, 'finetune', 0
HelpContext1_49         DB      5, 'S3x ', 0A6h, 'v', 0B3h, 9Ah, 0
HelpContext1_50         DB      5, 'S4x ', 0A6h, 'tremelo ', 9Ah, 0
HelpContext1_51         DB      5, 'S5x ', 0A6h, 'panbrello ', 9Ah, 0
HelpContext1_62         DB      7, 'Waveforms for commands S3x, S4x ', 0A1h, 'S5x:', 0
HelpContext1_63         DB      9, '0: Sine wave', 0
HelpContext1_64         DB      9, '1: Ramp down', 0
HelpContext1_65         DB      9, '2: Square wave', 0
HelpContext1_66         DB      9, '3: Random wave', 0
HelpContext1_52         DB      5, 'S6x ', 86h, 'delay for x ticks', 0
HelpContext1_53         DB      5, 'S70', 0C0h, 0A5h, 'cut', 0
HelpContext1_144        DB      5, 'S71', 0C0h, 0A5h, 'off', 0
HelpContext1_145        DB      5, 'S72', 0C0h, 0A5h, 'fade', 0
HelpContext1_153        DB      5, 'S73', 96h, 0A5h, 'cut', 0
HelpContext1_154        DB      5, 'S74', 96h, 'continue', 0
HelpContext1_155        DB      5, 'S75', 96h, 0A5h, 'off', 0
HelpContext1_156        DB      5, 'S76', 96h, 0A5h, 'fade', 0
HelpContext1_157        DB      5, 'S77 ', 0ACh, 'off ', 8Ah, 8Ch, 0
HelpContext1_162        DB      5, 'S78 ', 0ACh, 'on ', 8Ah, 8Ch, 0
HelpContext1_168        DB      5, 'S79 ', 0ACh, 'off ', 0B5h, 8Ch, 0
HelpContext1_169        DB      5, 'S7A ', 0ACh, 'on ', 0B5h, 8Ch, 0
HelpContext1_170        DB      5, 'S7B ', 0ACh, 'off ', 0BBh, 8Ch, 0
HelpContext1_171        DB      5, 'S7C ', 0ACh, 'on ', 0BBh, 8Ch, 0
HelpContext1_54         DB      5, 'S8x ', 0A6h, 0B5h, 'position', 0
HelpContext1_55         DB      5, 'S91 ', 0A6h, 'surround sound', 0
HelpContext1_56         DB      5, 'SAy ', 0A6h, 'high value ', 0BEh, 95h, ' offset yxx00h', 0
HelpContext1_57         DB      5, 'SB0 ', 0A6h, 'loopback point', 0
HelpContext1_146        DB      5, 'SBx Loop x times ', 0B1h, 'loopback point', 0
HelpContext1_58         DB      5, 'SCx ', 0C3h, 'cut after x ticks', 0
HelpContext1_59         DB      5, 'SDx ', 0C3h, 'delay for x ticks', 0
HelpContext1_60         DB      5, 'SEx ', 86h, 'delay for x rows', 0
HelpContext1_61         DB      5, 'SFx ', 0A6h, 'parameterised MIDI Macro', 0
HelpContext1_179        DB      5, 'T0x ', 97h, 88h, 0
HelpContext1_180        DB      5, 'T1x ', 97h, 87h, 0
HelpContext1_67         DB      5, 'Txx ', 0A6h, 97h, 0B1h, 'xx (20h->0FFh)', 0
HelpContext1_68         DB      5, 'Uxy', 8Bh, 'v', 0B3h, 0A0h, 0C5h, 0
HelpContext1_69         DB      5, 'Vxx ', 0A6h, 'g', 0B2h, 8Ah, 0B1h, 'xx (0->80h)', 0
HelpContext1_70         DB      5, 'W0x G', 0B2h, 8Ah, 88h, 0
HelpContext1_138        DB      5, 'Wx0 G', 0B2h, 8Ah, 87h, 0
HelpContext1_139        DB      5, 'WFx', 8Bh, 'g', 0B2h, 8Ah, 88h, 0
HelpContext1_140        DB      5, 'WxF', 8Bh, 'g', 0B2h, 8Ah, 87h, 0
HelpContext1_71         DB      5, 'Xxx ', 0A6h, 0B5h, 'position (0->0FFh)', 0
HelpContext1_72         DB      5, 'Yxy Panbrello ', 0A0h, 0C5h, 0
HelpContext1_73         DB      5, 'Zxx MIDI Macros', 0

HelpContext1_74         DB      3, 86h, 'Edit ', 0ADh, '.', 0
HelpContext1_114        DB      5, 'Grey +,-', 0FFh, 9,   ' ', 0C7h, 85h, 0CDh, 0
HelpContext1_115        DB      5, 'Shift +,-', 0FFh, 8,  ' ', 0C7h, '4 ', 85h, 0CDh, 0
HelpContext1_134        DB      5, "Ctrl +,-", 0FFh, 9,   " ", 0C7h, "order's ", 85h, 0CDh, 0
HelpContext1_75         DB      5, '0-9', 0FFh, 14,       ' ', 0C8h, 'octave/volume/', 8Fh, 0
HelpContext1_76         DB      5, '0-9, A-F', 0FFh, 9,   ' ', 0C8h, 0BDh, 'value', 0
HelpContext1_77         DB      5, 'A-Z', 0FFh, 14,       ' ', 0C8h, 0BDh, 0
HelpContext1_78         DB      5, '. (Period)', 0FFh, 7, ' Clear field(s)', 0
HelpContext1_79         DB      5, '1', 0FFh, 16,         ' ', 0C3h, 'cut (^^^)', 0
HelpContext1_80         DB      5, '`', 0FFh, 16,         ' ', 0C3h, 'off (', 0FFh, 3, 'Í) / ', 0B8h, 9Dh, 0

HelpContext1_81         DB      5, 'Spacebar', 0FFh, 9,      ' Use last note/', 8Fh, '/volume/', 0BDh, '/', 0BDh, 'value', 0
HelpContext1_181        DB      5, 'Caps Lock+Key', 0FFh, 4, ' Preview ', 0A5h, 0
HelpContext1_82         DB      5, 99h, 0FFh, 11,        ' Get default note/', 8Fh, '/volume/', 0BDh, 0
HelpContext1_83         DB      5, '< or ', 81h, 'Up', 0FFh, 5,  ' ', 93h, ' ', 8Fh, 0
HelpContext1_163        DB      5, '> or ', 81h, 'Down   ', 92h, ' ', 8Fh, 0
HelpContext1_84         DB      5, 'Grey /,*', 0FFh, 9,      ' ', 93h, '/', 92h, ' octave', 0
HelpContext1_85         DB      5, ', (Comma)', 0FFh, 8,     ' ', 9Dh, 'edit mask for ', 0A2h, 'field', 0
HelpContext1_86         DB      5, 0C1h, '/', 0C2h, 0FFh, 10,      ' ', 9Eh, 0BFh, 'row to/', 0A9h, 0A2h, 0A3h, 0
HelpContext1_127        DB      5, 80h, 0C1h, '/', 0C2h, 0FFh, 6,   ' ', 9Eh, 'an entire row to/', 0A9h, 85h, 0CDh, 0
HelpContext1_87         DB      5, 'Up/Down', 0FFh, 10,      ' ', 9Ch, 0B7h, 0B0h, 'the skipvalue (set ', 0A0h, 'Alt 0-9)', 0
HelpContext1_164        DB      5, 81h, 'Home/End', 0FFh, 4, ' ', 9Ch, 0B7h, 0B0h, '1 row', 0
HelpContext1_129        DB      5, 80h, 'Up/Down', 0FFh, 6,   ' ', 0BCh, 85h, 0B7h, 0B0h, '1 row', 0
HelpContext1_88         DB      5, 'Left/Right', 0FFh, 7,    ' ', 9Ch, 'cursor left/right', 0
HelpContext1_131        DB      5, 80h, 'Left/Right   ', 9Ch, 'forwards/backwards one ', 0A3h, 0
HelpContext1_90         DB      5, 'Tab/', 82h, 'Tab', 0FFh, 4, ' ', 9Ch, 'forwards/backwards ', 0B1h, 0A5h, 'column', 0
HelpContext1_89         DB      5, 'PgUp/PgDn', 0FFh, 8,     ' ', 9Ch, 0B7h, 'n lines (n=Row Hilight Major)', 0
HelpContext1_160        DB      5, 81h, 'PgUp/PgDn   ', 9Ch, 0B1h, 'top/bottom ', 0BEh, 85h, 0
HelpContext1_91         DB      5, 'Home', 0FFh, 13,         ' ', 9Ch, 0B1h, 'start ', 0BEh, 'column/start of line/start of ', 85h, 0
HelpContext1_92         DB      5, 'End', 0FFh, 14,          ' ', 9Ch, 0B1h, 'end ', 0BEh, 'column/end ', 0BEh, 'line/end of', 85h, 0
HelpContext1_93         DB      5, 'Backspace', 0FFh, 8,     ' ', 9Ch, 0B1h, 'previous position (accounts for Multi', 0A3h, ')', 0
HelpContext1_116        DB      5, 80h, 'N', 0FFh, 12,       ' ', 9Dh, 'Multichannel mode for ', 0A2h, 0A3h, 0
HelpContext1_124        DB      3, '2*', 80h, 'N', 0FFh, 12, ' Multichannel Selection menu', 0
HelpContext1_130        DB      5, 80h, 99h, 0FFh, 7,     ' Store ', 85h, 90h, 0
HelpContext1_117        DB      5, 80h, 'Backspace', 0FFh, 4, ' Revert ', 85h, 90h, ' ', 0CDh, 0
HelpContext1_161        DB      5, 81h, 'Backspace   Undo - any function ', 0A0h, 0CDh, ' can be undone', 0

HelpContext1_166        DB      5, 81h, 'C', 0FFh, 11,       ' ', 9Dh, 'centralise cursor', 0
HelpContext1_174        DB      5, 81h, 'H', 0FFh, 11,       ' ', 9Dh, 0A2h, 'row hilight', 0
HelpContext1_300        DB      5, 81h, 'V', 0FFh, 11,       ' ', 9Dh, 'default ', 8Ah, 'display', 0

HelpContext1_176        DB      5, 81h, 'F2', 0FFh, 10,      ' ', 0A6h, 85h, 'length', 0

HelpContext1_118        DB      4, 'Track View Functions.', 0
HelpContext1_119        DB      5, 80h, "T", 0FFh, 12,       " Cycle ", 0A2h, "track's view", 0
HelpContext1_120        DB      5, 80h, 'R', 0FFh, 12,       ' Clear all ', 0CBh, 'views', 0
HelpContext1_121        DB      5, 80h, 'H', 0FFh, 12,       ' ', 9Dh, 0CBh, 'view divisions', 0
HelpContext1_122        DB      5, 81h, '0', 0FFh, 11,      ' Deselect ', 0A2h, 0CBh, 0
HelpContext1_123        DB      5, 81h, '1 - ', 81h, '5  View ', 0A2h, 0CBh, 'in scheme 1-5', 0
HelpContext1_128        DB      5, 81h, 'Left/Right  ', 9Ch, 'left/right ', 0A8h, 0CBh, 'view columns', 0

HelpContext1_167        DB      5, 'L-Ctrl&Shift 1-4 Quick view scheme setup', 0

HelpContext1_159        DB      5, 81h, 'T', 0FFh, 11,      ' ', 9Dh, 'View-', 8Dh, 'cursor-tracking', 0

HelpContext1_94         DB      4, 'Block Functions.', 0
HelpContext1_95         DB      5, 80h, 'B', 0FFh, 12,       ' ', 0CAh, 'beginning ', 0BEh, 0CCh, 0
HelpContext1_96         DB      5, 80h, 'E', 0FFh, 12,       ' ', 0CAh, 'end ', 0BEh, 0CCh, 0
HelpContext1_97         DB      5, 80h, 'D', 0FFh, 12,       ' Quick mark n/2n/4n/... lines (n=Row Hilight Major)', 0
HelpContext1_98         DB      5, 80h, 'L', 0FFh, 12,       ' ', 0CAh, 'entire column/', 85h, 0
HelpContext1_165        DB      5, 82h, 'Arrows', 0FFh, 5, ' ', 0CAh, 0CCh, 0

HelpContext1_99         DB      5, 80h, 'U', 0FFh, 12,       ' Unmark block/Release ', 98h, 'memory', 0

HelpContext1_113        DB      5, 80h, 'Q', 0FFh, 12,       ' Raise notes ', 0B0h, 0BFh, 0AFh, 0CDh, 0
HelpContext1_100        DB      5, 80h, 'A', 0FFh, 12,       ' Lower notes ', 0B0h, 0BFh, 0AFh, 0CDh, 0
HelpContext1_101        DB      5, 80h, 'S', 0FFh, 12,       ' ', 0A6h, 8Eh, 0CDh, 0
HelpContext1_102        DB      5, 80h, 'V', 0FFh, 12,       ' ', 0A6h, 'volume/', 0B5h, 0CDh, 0
HelpContext1_103        DB      5, 80h, 'W', 0FFh, 12,       ' ', 0CEh, 'vol/pan not associated ', 0A0h, 0BFh, 'note/', 8Fh, ' ', 0CDh, 0
HelpContext1_104        DB      5, 80h, 'K', 0FFh, 12,       ' ', 0BCh, 'volume/', 0B5h, 'column ', 0CDh, 0
HelpContext1_133        DB      3, '2*', 80h, 'K', 0FFh, 12, ' ', 0CEh, 'all volume/', 0B5h, 'controls ', 0CDh, 0
HelpContext1_105        DB      5, 80h, 'J', 0FFh, 12,       ' ', 89h, 'amplifier ', 0CDh, ' / Fast ', 8Ah, 'attenuate ', 0CDh, 0
HelpContext1_106        DB      5, 80h, 'Z', 0FFh, 12,       ' Cut ', 0CCh, 0CDh, 0
HelpContext1_132        DB      5, 80h, 'X', 0FFh, 12,       ' ', 0BCh, 0BDh, ' value ', 0CDh, 0
HelpContext1_107        DB      3, '2*', 80h, 'X', 0FFh, 12, ' ', 0CEh, 'all ', 0BDh, ' ', 90h, ' ', 0CDh, 0

HelpContext1_108        DB      5, 80h, 'C', 0FFh, 12,       ' Copy ', 0CCh, 'into ', 98h, 0
HelpContext1_109        DB      5, 80h, 'P', 0FFh, 12,       ' Paste ', 90h, ' ', 0A9h, 98h, 0CDh, 0
HelpContext1_110        DB      5, 80h, 'O', 0FFh, 12,       ' Overwrite ', 0A0h, 90h, ' ', 0A9h, 98h, ' ', 0CDh, 0
HelpContext1_111        DB      5, 80h, 'M', 0FFh, 12,       ' Mix each row ', 0A9h, 98h, 0A0h, 85h, 90h, ' ', 0CDh, 0
HelpContext1_173        DB      3, '2*', 80h, 'M', 0FFh, 12,     ' Mix each field ', 0A9h, 98h, 0A0h, 85h, 90h, 0

HelpContext1_125        DB      5, 80h, 'F', 0FFh, 12,       ' Double ', 0CCh, 'length ', 0CDh, 0
HelpContext1_126        DB      5, 80h, 'G', 0FFh, 12,       ' Halve ', 0CCh, 'length ', 0CDh, 0

HelpContext1_112        DB      5, 80h, 'I', 0FFh, 12,       ' Select Template mode / Fast ', 8Ah, 'amplify ', 0CDh, 0

HelpContext1_175        DB      5, 81h, 'J', 0FFh, 11,      ' ', 9Dh, 'fast ', 8Ah, 'mode', 0

HelpContext1_147        DB      3, 'Playback Functions.', 0
HelpContext1_148        DB      5, '4', 0FFh, 16,           ' ', 9Fh, 0A5h, 'under cursor', 0
HelpContext1_149        DB      5, '8', 0FFh, 16,           ' ', 9Fh, 'row', 0

HelpContext1_152        DB      5, 81h, 'F6', 0FFh, 10,     ' ', 9Fh, 0A9h, 0A2h, 'row', 0
HelpContext1_158        DB      5, 81h, 'F7', 0FFh, 10,     ' Set/Clear playback mark (for use ', 0A0h, 'F7)', 0

HelpContext1_150        DB      5, 80h, 'F9', 0FFh, 11,      ' ', 9Dh, 0A2h, 0A3h, 0
HelpContext1_151        DB      5, 80h, 'F10', 0FFh, 10,     ' Solo ', 0A2h, 0A3h, 0

HelpContext1_172        DB      5, 'Scroll Lock', 0FFh, 6, ' ', 9Dh, 'playback tracing', 0
HelpContext1_177        DB      5, 81h, 'Z', 0FFh, 11,      ' ', 0C8h, 'MIDI playback trigger', 0
HelpContext1_178        DB      5, 80h, 'Scroll Lock  ', 9Dh, 'MIDI input', 0

HelpContext2Ptrs        Label   Word
                        DW      Offset HelpContext2_0
                        DW      Offset HelpContext2_1
                        DW      Offset HelpContext2_2
                        DW      Offset NewLine
                        DW      Offset HelpContext2_3
                        DW      Offset HelpContext2_10
                        DW      Offset HelpContext2_4
                        DW      Offset HelpContext2_5
                        DW      Offset NewLine
                        DW      Offset HelpContext2_11
                        DW      Offset HelpContext2_23
                        DW      Offset HelpContext2_8
                        DW      Offset HelpContext2_6
                        DW      Offset HelpContext2_17
                        DW      Offset HelpContext2_18
                        DW      Offset HelpContext2_27
                        DW      Offset HelpContext2_30
                        DW      Offset HelpContext2_33
                        DW      Offset HelpContext2_7
                        DW      Offset HelpContext2_29
                        DW      Offset HelpContext2_28
                        DW      Offset HelpContext2_14
                        DW      Offset HelpContext2_19
                        DW      Offset HelpContext2_12
                        DW      Offset HelpContext2_13
                        DW      Offset HelpContext2_16
                        DW      Offset HelpContext2_15
                        DW      Offset HelpContext2_9
                        DW      Offset NewLine
                        DW      Offset HelpContext2_31
                        DW      Offset HelpContext2_32
                        DW      Offset NewLine
                        DW      Offset HelpContext2_26
                        DW      Offset NewLine
                        DW      Offset HelpContext2_21
                        DW      Offset HelpContext2_22
                        DW      Offset HelpContext2_24
                        DW      Offset HelpContext2_25
                        DW      Offset NewLine
                        DW      Offset Divider
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_0
                        DW      Offset HelpGlobal_1
                        DW      Offset HelpGlobal_37
                        DW      Offset HelpGlobal_3
                        DW      Offset HelpGlobal_4
                        DW      Offset HelpGlobal_20
                        DW      Offset HelpGlobal_9
                        DW      Offset HelpGlobal_22
                        DW      Offset HelpGlobal_10
                        DW      Offset HelpGlobal_19
                        DW      Offset HelpGlobal_11
                        DW      Offset HelpGlobal_12
                        DW      Offset HelpGlobal_33
                        DW      Offset HelpGlobal_13
                        DW      Offset HelpGlobal_5
                        DW      Offset HelpGlobal_23
                        DW      Offset HelpGlobal_6
                        DW      Offset HelpGlobal_2
                        DW      Offset HelpGlobal_7
                        DW      Offset HelpGlobal_8
                        DW      Offset HelpGlobal_32
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_17
                        DW      Offset HelpGlobal_31
                        DW      Offset HelpGlobal_18
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_16
                        DW      Offset HelpGlobal_34
                        DW      Offset HelpGlobal_35
                        DW      Offset HelpGlobal_36
                        DW      Offset HelpGlobal_21
                        DW      Offset HelpGlobal_14
                        DW      Offset HelpGlobal_15
                        DW      Offset NewLine
                        DW      Offset Divider
                        DW      0               ; End of list.

HelpContext2_0          DB      31, 0FFh, 1, 139, 0FFh, 17, 134, 0FFh, 1, 138, 0
HelpContext2_1          DB      31, 0FFh, 1, 132, '   ', 94h, 0AAh, '  ', 0FFh, 1, 145, 0
HelpContext2_2          DB      31, 0FFh, 1, 137, 0FFh, 17, 143, 0FFh, 1, 150, 0

HelpContext2_3          DB      3, 94h, 0AAh, 0ADh, '.', 0
HelpContext2_10         DB      5, 99h, 0FFh, 7, ' Load new ', 95h, 0
HelpContext2_4          DB      5, 'Tab', 0FFh, 10,  ' ', 9Ch, 0A8h, 'options', 0
HelpContext2_5          DB      5, 'PgUp/PgDn', 0FFh, 4, ' ', 9Ch, 0B7h, '(when not on list)', 0

HelpContext2_11         DB      5, 80h, 'A', 0FFh, 8, ' Convert Signed to/', 0A9h, 'Unsigned ', 95h, 's', 0
HelpContext2_23         DB      5, 80h, 'B', 0FFh, 8, ' Pre-Loop cut ', 95h, 0
HelpContext2_8          DB      5, 80h, 'C', 0FFh, 8, ' Clear ', 94h, 'Name & Filename (Used in ', 94h, 'Name ', 0B6h, ')', 0
HelpContext2_6          DB      5, 80h, 'D', 0FFh, 8, ' ', 084h, 94h, 0
HelpContext2_17         DB      5, 80h, 'E', 0FFh, 8, ' Resize ', 94h, '(', 0A0h, 'interpolation)', 0
HelpContext2_18         DB      5, 80h, 'F', 0FFh, 8, ' Resize ', 94h, '(without interpolation)', 0
HelpContext2_27         DB      5, 80h, 'G', 0FFh, 8, ' Reverse ', 94h, 0
HelpContext2_30         DB      5, 80h, 'H', 0FFh, 8, ' Centralise ', 94h, 0
HelpContext2_33         DB      5, 80h, 'I', 0FFh, 8, ' Invert ', 94h, 0
HelpContext2_7          DB      5, 80h, 'L', 0FFh, 8, ' Post-Loop cut ', 95h, 0
HelpContext2_29         DB      5, 80h, 'M', 0FFh, 8, ' ', 94h, 'amplifier', 0
HelpContext2_28         DB      5, 80h, 'N', 0FFh, 8, ' ', 9Dh, 'Multi', 0A4h, 'playback', 0
HelpContext2_14         DB      5, 80h, 'O', 0FFh, 8, ' Save ', 0A2h, 95h, ' ', 0B1h, 'disk (IT Format)', 0
HelpContext2_19         DB      5, 80h, 'Q', 0FFh, 8, ' ', 9Dh, 95h, ' quality', 0
HelpContext2_12         DB      5, 80h, 'R', 0FFh, 8, ' Replace ', 0A2h, 95h, ' in song', 0
HelpContext2_13         DB      5, 80h, 'S', 0FFh, 8, ' Swap ', 95h, ' (in song also)', 0
HelpContext2_16         DB      5, 80h, 'T', 0FFh, 8, ' Save ', 0A2h, 95h, ' ', 0B1h, 'disk (ST3 Format)', 0

IF SAVESAMPLEWAV
HelpContext2_15         DB      5, 80h, 'W', 0FFh, 8, ' Save ', 0A2h, 95h, ' ', 0B1h, 'disk (WAV Format)', 0
ELSE
HelpContext2_15         DB      5, 80h, 'W', 0FFh, 8, ' Save ', 0A2h, 95h, ' ', 0B1h, 'disk (RAW Format)', 0
ENDIF

HelpContext2_9          DB      5, 80h, 'X', 0FFh, 8, ' Ex', 0C9h, 95h, ' (only in ', 94h, 'List)', 0

HelpContext2_31         DB      5, 80h, 0C1h, 0FFh, 6, ' ', 83h, 95h, ' ', 91h, 0
HelpContext2_32         DB      5, 80h, 0C2h, 0FFh, 6, ' Remove ', 95h, ' ', 91h, 0

HelpContext2_26         DB      5, '< >', 0FFh, 10,    ' ', 93h, '/', 92h, ' playback ', 0A3h, 0

HelpContext2_21         DB      5, 80h, 'Grey +   ', 92h, 0AEh, 'octave', 0
HelpContext2_22         DB      5, 80h, 'Grey -   ', 93h, 0AEh, 'octave', 0
HelpContext2_24         DB      5, 81h, 'Grey +  ', 92h, 0AEh, 0AFh, 0
HelpContext2_25         DB      5, 81h, 'Grey -  ', 93h, 0AEh, 0AFh, 0

HelpContext7Ptrs        Label   Word
                        DW      Offset HelpContext7_0
                        DW      Offset HelpContext7_1
                        DW      Offset HelpContext7_2
                        DW      Offset NewLine
                        DW      Offset HelpContext7_8
                        DW      Offset HelpContext7_26
                        DW      Offset HelpContext7_9
                        DW      Offset HelpContext7_10
                        DW      Offset HelpContext7_36
                        DW      Offset HelpContext7_22
                        DW      Offset NewLine
                        DW      Offset HelpContext7_25
                        DW      Offset HelpContext7_24
                        DW      Offset HelpContext7_23
                        DW      Offset HelpContext7_28
                        DW      Offset HelpContext7_11
                        DW      Offset HelpContext7_12
                        DW      Offset HelpContext7_13
                        DW      Offset HelpContext7_14
                        DW      Offset NewLine
                        DW      Offset HelpContext7_34
                        DW      Offset HelpContext7_35
                        DW      Offset NewLine
                        DW      Offset HelpContext7_33
                        DW      Offset NewLine
                        DW      Offset HelpContext7_3
                        DW      Offset HelpContext7_4
                        DW      Offset HelpContext7_5
                        DW      Offset NewLine
                        DW      Offset HelpContext7_6
                        DW      Offset HelpContext7_7
                        DW      Offset HelpContext7_27
                        DW      Offset HelpContext7_29
                        DW      Offset HelpContext7_30
                        DW      Offset NewLine
                        DW      Offset HelpContext7_15
                        DW      Offset HelpContext7_16
                        DW      Offset HelpContext7_17
                        DW      Offset HelpContext7_18
                        DW      Offset HelpContext7_19
                        DW      Offset NewLine
                        DW      Offset HelpContext7_20
                        DW      Offset HelpContext7_21
                        DW      Offset NewLine
                        DW      Offset Divider
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_0
                        DW      Offset HelpGlobal_1
                        DW      Offset HelpGlobal_37
                        DW      Offset HelpGlobal_3
                        DW      Offset HelpGlobal_4
                        DW      Offset HelpGlobal_20
                        DW      Offset HelpGlobal_9
                        DW      Offset HelpGlobal_22
                        DW      Offset HelpGlobal_10
                        DW      Offset HelpGlobal_19
                        DW      Offset HelpGlobal_11
                        DW      Offset HelpGlobal_12
                        DW      Offset HelpGlobal_33
                        DW      Offset HelpGlobal_13
                        DW      Offset HelpGlobal_5
                        DW      Offset HelpGlobal_23
                        DW      Offset HelpGlobal_6
                        DW      Offset HelpGlobal_2
                        DW      Offset HelpGlobal_7
                        DW      Offset HelpGlobal_8
                        DW      Offset HelpGlobal_32
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_17
                        DW      Offset HelpGlobal_31
                        DW      Offset HelpGlobal_18
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_16
                        DW      Offset HelpGlobal_34
                        DW      Offset HelpGlobal_35
                        DW      Offset HelpGlobal_36
                        DW      Offset HelpGlobal_21
                        DW      Offset HelpGlobal_14
                        DW      Offset HelpGlobal_15
                        DW      Offset NewLine
                        DW      Offset Divider

                        DW      0               ; End of list

HelpContext7_0          DB      29, 0FFh, 1, 139, 0FFh, 21, 134, 0FFh, 1, 138, 0
HelpContext7_1          DB      29, 0FFh, 1, 132, '   ', 8Eh, 0AAh, '  ', 0FFh, 1, 145, 0
HelpContext7_2          DB      29, 0FFh, 1, 137, 0FFh, 21, 143, 0FFh, 1, 150, 0

HelpContext7_8          DB      3, 8Eh, 0AAh, 0ADh, ".", 0
HelpContext7_26         DB      5, 99h, 0FFh, 10, " Load new ", 8Fh, 0
HelpContext7_9          DB      5, 81h, "PgUp/PgDn  ", 9Ch, 8Fh, " ", 0B7h, "(when not on list)", 0
HelpContext7_10         DB      5, 80h, "C", 0FFh, 11, " Clear ", 8Fh, " name & filename", 0
HelpContext7_36         DB      5, 80h, "W", 0FFh, 11, ' ', 0CEh, 8Fh, " ", 90h, 0
HelpContext7_22         DB      5, "Spacebar", 0FFh, 8, " Edit ", 8Fh, " name (ESC ", 0B1h, "exit)", 0

HelpContext7_25         DB      5, 80h, 'D', 0FFh, 11, ' ', 084h, 8Fh, ' & all related ', 95h, 's', 0
HelpContext7_24         DB      5, 80h, 'N', 0FFh, 11, ' ', 9Dh, 'Multi', 0A4h, 'playback', 0
HelpContext7_23         DB      5, 80h, 'O', 0FFh, 11, ' Save ', 0A2h, 8Fh, ' ', 0B1h, 'disk', 0
HelpContext7_28         DB      5, 80h, 'P', 0FFh, 11, ' Copy ', 8Fh, 0
HelpContext7_11         DB      5, 80h, 'R', 0FFh, 11, ' Replace ', 0A2h, 8Fh, ' in song', 0
HelpContext7_12         DB      5, 80h, 'S', 0FFh, 11, ' Swap ', 08Fh, 's (in song also)', 0
HelpContext7_13         DB      5, 80h, 'U', 0FFh, 11, ' Update ', 85h, 90h, 0
HelpContext7_14         DB      5, 80h, 'X', 0FFh, 11, ' Ex', 0C9h, 08Fh, 's (only in ', 08Eh, 'List)', 0

HelpContext7_34         DB      5, 80h, 0C1h, 0FFh, 9, ' ', 83h, 8Fh, ' ', 91h, 0
HelpContext7_35         DB      5, 80h, 0C2h, 0FFh, 9, ' Remove ', 8Fh, ' ', 91h, 0

HelpContext7_33         DB      5, '< >', 0FFh, 13, ' ', 93h, '/', 92h, ' playback ', 0A3h, 0

HelpContext7_3          DB      3, 0C3h, "Translation.", 0
HelpContext7_4          DB      5, 99h, 0FFh, 10, " Pickup ", 95h, " number & default play ", 0A5h, 0
HelpContext7_5          DB      5, "< >", 0FFh, 13,   " ", 93h, "/", 92h, " ", 95h, " number", 0
HelpContext7_6          DB      5, 80h, "A", 0FFh, 11, " ", 0C8h, "all ", 95h, "s", 0
HelpContext7_7          DB      5, 80h, "N", 0FFh, 11, " ", 99h, 0B4h, 0A5h, 0
HelpContext7_27         DB      5, 80h, "P", 0FFh, 11, " ", 99h, "previous ", 0A5h, 0
HelpContext7_29         DB      5, 80h, "Up/Down", 0FFh, 5, " Transpose all notes ", 0BFh, 0AFh, 0B7h, 0
HelpContext7_30         DB      5, 80h, 0C1h, "/", 0C2h, 0FFh, 5, " ", 9Eh, 0BFh, "row ", 0A9h, "the table", 0

HelpContext7_15         DB      3, 'Envelope ', 0ADh, '.', 0
HelpContext7_16         DB      5, 99h, 0FFh, 10,  ' Pick up/Drop ', 0A2h, 'node', 0
HelpContext7_17         DB      5, 83h, 0FFh, 9, ' Add node', 0
HelpContext7_18         DB      5, 84h, 0FFh, 9, ' ', 084h, 'node', 0
HelpContext7_19         DB      5, 80h, 'Arrow ', 0ADh, '  ', 9Ch, 'node (fast)', 0

HelpContext7_20         DB      5, 'Press Spacebar  ', 9Fh, 'default ', 0A5h, 0
HelpContext7_21         DB      5, 'Release Space   ', 0C3h, 'off command', 0

HelpContext9Ptrs        Label   Word
                        DW      Offset HelpContext9_0
                        DW      Offset HelpContext9_1
                        DW      Offset HelpContext9_2
                        DW      Offset NewLine
                        DW      Offset HelpContext9_3
                        DW      Offset HelpContext9_4
                        DW      Offset HelpContext9_11
                        DW      Offset HelpContext9_5
                        DW      Offset HelpContext9_6
                        DW      Offset HelpContext9_7
                        DW      Offset NewLine
                        DW      Offset HelpContext9_15
                        DW      Offset HelpContext9_16
                        DW      Offset NewLine
                        DW      Offset HelpContext9_8
                        DW      Offset HelpContext9_9
                        DW      Offset NewLine
                        DW      Offset HelpContext9_10
                        DW      Offset NewLine
                        DW      Offset HelpContext9_12
                        DW      Offset HelpContext9_14
                        DW      Offset NewLine
                        DW      Offset HelpContext9_13
                        DW      Offset NewLine
                        DW      Offset Divider
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_0
                        DW      Offset HelpGlobal_1
                        DW      Offset HelpGlobal_37
                        DW      Offset HelpGlobal_3
                        DW      Offset HelpGlobal_4
                        DW      Offset HelpGlobal_20
                        DW      Offset HelpGlobal_9
                        DW      Offset HelpGlobal_22
                        DW      Offset HelpGlobal_10
                        DW      Offset HelpGlobal_19
                        DW      Offset HelpGlobal_11
                        DW      Offset HelpGlobal_12
                        DW      Offset HelpGlobal_33
                        DW      Offset HelpGlobal_13
                        DW      Offset HelpGlobal_5
                        DW      Offset HelpGlobal_23
                        DW      Offset HelpGlobal_6
                        DW      Offset HelpGlobal_2
                        DW      Offset HelpGlobal_7
                        DW      Offset HelpGlobal_8
                        DW      Offset HelpGlobal_32
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_17
                        DW      Offset HelpGlobal_31
                        DW      Offset HelpGlobal_18
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_16
                        DW      Offset HelpGlobal_34
                        DW      Offset HelpGlobal_35
                        DW      Offset HelpGlobal_36
                        DW      Offset HelpGlobal_21
                        DW      Offset HelpGlobal_14
                        DW      Offset HelpGlobal_15
                        DW      Offset NewLine
                        DW      Offset Divider
                        DW      0

HelpContext9_0          DB      33, 0FFh, 1, 139, 0FFh, 13, 134, 0FFh, 1, 138, 0
HelpContext9_1          DB      33, 0FFh, 1, 132, '  Info Page  ', 0FFh, 1, 145, 0
HelpContext9_2          DB      33, 0FFh, 1, 137, 0FFh, 13, 143, 0FFh, 1, 150, 0

HelpContext9_3          DB      3, 83h, 0FFh, 11, ' Add ', 0BFh, 'new ', 0B6h, 0
HelpContext9_4          DB      3, 84h, 0FFh, 11, ' ', 084h, 0A2h, 0B6h, 0
HelpContext9_11         DB      3, 'Tab/', 82h, 'Tab', 0FFh, 5, ' ', 9Ch, 0A8h, 0B6h, 's', 0
HelpContext9_5          DB      3, 'Up/Dn/Left/Right  ', 9Ch, 'highlighted ', 0A3h, 0
HelpContext9_6          DB      3, 'PgUp/PgDn', 0FFh, 9, ' ', 0C8h, 0B6h, ' type', 0
HelpContext9_7          DB      3, 80h, 'Up/Down', 0FFh, 7, ' ', 9Ch, 0B6h, ' base ', 0B7h, 0

HelpContext9_15         DB      3, 'V', 0FFh, 17, ' ', 9Dh, 0A8h, 'volume/velocity bars', 0
HelpContext9_16         DB      3, 'I', 0FFh, 17, ' ', 9Dh, 0A8h, 95h, '/', 8Fh, ' names', 0

HelpContext9_8          DB      3, 'Q', 0FFh, 17, ' Mute/Unmute ', 0A2h, 0A3h, 0
HelpContext9_9          DB      3, 'S', 0FFh, 17, ' Solo ', 0A2h, 0A3h, 0

HelpContext9_10         DB      3, 'Grey +, Grey -', 0FFh, 4, ' ', 9Ch, 'forwards/backwards one ', 85h, 'in song', 0

HelpContext9_12         DB      3, 80h, 'S', 0FFh, 13, ' ', 9Dh, 'Stereo playback', 0
HelpContext9_14         DB      3, 80h, 'R', 0FFh, 13, ' Reverse output ', 0A3h, 's', 0

Helpcontext9_13         DB      3, 'G', 0FFh, 17, ' Goto ', 85h, 'currently playing', 0

HelpContext12Ptrs       Label   Word
                        DW      Offset HelpContext12_0
                        DW      Offset HelpContext12_1
                        DW      Offset HelpContext12_2
                        DW      Offset NewLine
                        DW      Offset HelpContext12_3
                        DW      Offset NewLine
                        DW      Offset HelpContext12_4
                        DW      Offset HelpContext12_5
                        DW      Offset HelpContext12_6
                        DW      Offset NewLine
                        DW      Offset Divider
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_0
                        DW      Offset HelpGlobal_1
                        DW      Offset HelpGlobal_37
                        DW      Offset HelpGlobal_3
                        DW      Offset HelpGlobal_4
                        DW      Offset HelpGlobal_20
                        DW      Offset HelpGlobal_9
                        DW      Offset HelpGlobal_22
                        DW      Offset HelpGlobal_10
                        DW      Offset HelpGlobal_19
                        DW      Offset HelpGlobal_11
                        DW      Offset HelpGlobal_12
                        DW      Offset HelpGlobal_33
                        DW      Offset HelpGlobal_13
                        DW      Offset HelpGlobal_5
                        DW      Offset HelpGlobal_23
                        DW      Offset HelpGlobal_6
                        DW      Offset HelpGlobal_2
                        DW      Offset HelpGlobal_7
                        DW      Offset HelpGlobal_8
                        DW      Offset HelpGlobal_32
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_17
                        DW      Offset HelpGlobal_31
                        DW      Offset HelpGlobal_18
                        DW      Offset NewLine
                        DW      Offset HelpGlobal_16
                        DW      Offset HelpGlobal_34
                        DW      Offset HelpGlobal_35
                        DW      Offset HelpGlobal_36
                        DW      Offset HelpGlobal_21
                        DW      Offset HelpGlobal_14
                        DW      Offset HelpGlobal_15
                        DW      Offset NewLine
                        DW      Offset Divider
                        DW      0

HelpContext12_0         DB      31, 0FFh, 1, 139, 0FFh, 18, 134, 0FFh, 1, 138, 0
HelpContext12_1         DB      31, 0FFh, 1, 132, '  Message Editor  ', 0FFh, 1, 145, 0
HelpContext12_2         DB      31, 0FFh, 1, 137, 0FFh, 18, 143, 0FFh, 1, 150, 0

HelpContext12_3         DB      3, 99h, '/ ESC', 0FFh, 5, ' Edit message / finished editing', 0

HelpContext12_4         DB      3, 'Editing ', 0ADh, '.', 0
HelpContext12_5         DB      5, 81h, 'Y', 0FFh, 8, ' ', 084h, 'line', 0
HelpContext12_6         DB      5, 80h, 'C', 0FFh, 9, ' Clear message', 0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

DecodeWord80h           DB      "Alt-", 0
DecodeWord81h           DB      "Ctrl-", 0
DecodeWord82h           DB      "Shift-", 0
DecodeWord83h           DB      0C1h, "ert ", 0
DecodeWord84h           DB      0C2h, "ete ", 0
DecodeWord85h           DB      "pattern ", 0
DecodeWord86h           DB      "Pattern ", 0
DecodeWord87h           DB      0A7h, "up ", 0B0h, "x", 0
DecodeWord88h           DB      0A7h, "down ", 0B0h, "x", 0
DecodeWord89h           DB      "Volume ", 0
DecodeWord8Ah           DB      "volume ", 0
DecodeWord8Bh           DB      " Fine ", 0
DecodeWord8Ch           DB      "envelope", 0
DecodeWord8Dh           DB      "Channel ", 0
DecodeWord8Eh           DB      0C1h, "trument ", 0
DecodeWord8Fh           DB      "instrument", 0
DecodeWord90h           DB      "data", 0
DecodeWord91h           DB      "slot (updates ", 85h, 90h, ")", 0
DecodeWord92h           DB      "Increase", 0
DecodeWord93h           DB      "Decrease", 0
DecodeWord94h           DB      "Sample ", 0
DecodeWord95h           DB      "sample", 0
DecodeWord96h           DB      " ", 0A6h, "NNA ", 0B1h, 0
DecodeWord97h           DB      "Tempo ", 0
DecodeWord98h           DB      "clipboard ", 0
DecodeWord99h           DB      "Enter ", 0
DecodeWord9Ah           DB      "waveform ", 0B1h, "type x", 0
DecodeWord9Bh           DB      " Dual Command: ", 0
DecodeWord9Ch           DB      "Move ", 0
DecodeWord9Dh           DB      "Toggle ", 0
DecodeWord9Eh           DB      0C1h, "ert/", 0C2h, "ete ", 0
DecodeWord9Fh           DB      "Play ", 0
DecodeWordA0h           DB      "with ", 0
DecodeWordA1h           DB      "and ", 0
DecodeWordA2h           DB      "current ", 0
DecodeWordA3h           DB      "channel", 0
DecodeWordA4h           DB      0A3h, ' ', 0
DecodeWordA5h           DB      "note ", 0
DecodeWordA6h           DB      "Set ", 0
DecodeWordA7h           DB      "slide ", 0
DecodeWordA8h           DB      "between ", 0
DecodeWordA9h           DB      "from ", 0
DecodeWordAAh           DB      "List ", 0
DecodeWordABh           DB      "Library ", 0
DecodeWordACh           DB      "Turn ", 0
DecodeWordADh           DB      "Keys", 0
DecodeWordAEh           DB      ' C-5 Frequency by 1 ', 0
DecodeWordAFh           DB      'semitone ', 0
DecodeWordB0h           DB      "by ", 0
DecodeWordB1h           DB      "to ", 0
DecodeWordB2h           DB      "lobal ", 0
DecodeWordB3h           DB      "ibra", 0B1h, 0
DecodeWordB4h           DB      "next ", 0
DecodeWordB5h           DB      "panning ", 0
DecodeWordB6h           DB      "window", 0
DecodeWordB7h           DB      "up/down ", 0
DecodeWordB8h           DB      "Panning ", 0
DecodeWordB9h           DB      "Order ", 0
DecodeWordBAh           DB      "Pitch ", 0
DecodeWordBBh           DB      "pitch ", 0
DecodeWordBCh           DB      "Slide ", 0
DecodeWordBDh           DB      "effect", 0
DecodeWordBEh           DB      "of ", 0
DecodeWordBFh           DB      "a ", 0
DecodeWordC0h           DB      " Past ", 0
DecodeWordC1h           DB      "Ins", 0
DecodeWordC2h           DB      "Del", 0
DecodeWordC3h           DB      "Note ", 0
DecodeWordC4h           DB      "speed ", 0
DecodeWordC5h           DB      0C4h, "x, ", 0C6h, "y", 0
DecodeWordC6h           DB      "depth ", 0
DecodeWordC7h           DB      "Next/Previous ", 0
DecodeWordC8h           DB      "Change ", 0
DecodeWordC9h           DB      "change ", 0
DecodeWordCAh           DB      "Mark ", 0
DecodeWordCBh           DB      "track ", 0
DecodeWordCCh           DB      "block ", 0
DecodeWordCDh           DB      " (*)", 0
DecodeWordCEh           DB      "Wipe ", 0

; channel, pitch, column, effect, note, current, list, library
; speed/width, turn, on, off, down, instrument
; semitone, octave, block, edit, save, (g)lobal, (v)ibrato, (p)anbrello
; cursor, window

DecodeBuffer            DB      80 Dup (0)
DecodeWords             DW      Offset DecodeWord80h, Offset DecodeWord81h
                        DW      Offset DecodeWord82h, Offset DecodeWord83h
                        DW      Offset DecodeWord84h, Offset DecodeWord85h
                        DW      Offset DecodeWord86h, Offset DecodeWord87h
                        DW      Offset DecodeWord88h, Offset DecodeWord89h
                        DW      Offset DecodeWord8Ah, Offset DecodeWord8Bh
                        DW      Offset DecodeWord8Ch, Offset DecodeWord8Dh
                        DW      Offset DecodeWord8Eh, Offset DecodeWord8Fh
                        DW      Offset DecodeWord90h, Offset DecodeWord91h
                        DW      Offset DecodeWord92h, Offset DecodeWord93h
                        DW      Offset DecodeWord94h, Offset DecodeWord95h
                        DW      Offset DecodeWord96h, Offset DecodeWord97h
                        DW      Offset DecodeWord98h, Offset DecodeWord99h
                        DW      Offset DecodeWord9Ah, Offset DecodeWord9Bh
                        DW      Offset DecodeWord9Ch, Offset DecodeWord9Dh
                        DW      Offset DecodeWord9Eh, Offset DecodeWord9Fh
                        DW      Offset DecodeWordA0h, Offset DecodeWordA1h
                        DW      Offset DecodeWordA2h, Offset DecodeWordA3h
                        DW      Offset DecodeWordA4h, Offset DecodeWordA5h
                        DW      Offset DecodeWordA6h, Offset DecodeWordA7h
                        DW      Offset DecodeWordA8h, Offset DecodeWordA9h
                        DW      Offset DecodeWordAAh, Offset DecodeWordABh
                        DW      Offset DecodeWordACh, Offset DecodeWordADh
                        DW      Offset DecodeWordAEh, Offset DecodeWordAFh
                        DW      Offset DecodeWordB0h, Offset DecodeWordB1h
                        DW      Offset DecodeWordB2h, Offset DecodeWordB3h
                        DW      Offset DecodeWordB4h, Offset DecodeWordB5h
                        DW      Offset DecodeWordB6h, Offset DecodeWordB7h
                        DW      Offset DecodeWordB8h, Offset DecodeWordB9h
                        DW      Offset DecodeWordBAh, Offset DecodeWordBBh
                        DW      Offset DecodeWordBCh, Offset DecodeWordBDh
                        DW      Offset DecodeWordBEh, Offset DecodeWordBFh
                        DW      Offset DecodeWordC0h, Offset DecodeWordC1h
                        DW      Offset DecodeWordC2h, Offset DecodeWordC3h
                        DW      Offset DecodeWordC4h, Offset DecodeWordC5h
                        DW      Offset DecodeWordC6h, Offset DecodeWordC7h
                        DW      Offset DecodeWordC8h, Offset DecodeWordC9h
                        DW      Offset DecodeWordCAh, Offset DecodeWordCBh
                        DW      Offset DecodeWordCCh, Offset DecodeWordCDh
                        DW      Offset DecodeWordCEh

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ Functions                                                                   ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Proc            H_DrawHelp Far

                Push    CS
                Pop     DS

                Push    CS
                Pop     ES

                        Assume DS:Help

                Mov     CX, 32
                Mov     SI, HelpContext
                Add     SI, SI
                Mov     SI, [HelpContextPtrs+SI]
                Mov     DI, 13*160

                Mov     AX, TopLine
                Add     AX, AX
                Add     SI, AX

H_DrawHelp1:
                Push    SI
                Push    DI

                Mov     SI, [SI]
                LodsB
                Xor     AH, AH
                Add     AX, AX
                Add     DI, AX

; DS:SI points to string. Deposit into buffer

                Push    DI
                Mov     DI, Offset DecodeBuffer

                Mov     DX, 1

H_DecodeBuffer1:
                LodsB
                Test    AL, AL
                JZ      H_DecodeBuffer4
                JS      H_DecodeBuffer2

                StosB
                Jmp     H_DecodeBuffer1

H_DecodeBuffer2:
                Cmp     AL, -2
                JGE     H_DecodeBuffer3

                ; Insert word
                Push    SI
                LEA     SI, [EAX*2 + Offset DecodeWords - 100h]
                Inc     DX
                Mov     SI, [SI]
                Jmp     H_DecodeBuffer1

H_DecodeBuffer3:
                StosB
                JE      H_DecodeBuffer1
                MovsB
                MovsB
                Jmp     H_DecodeBuffer1

H_DecodeBuffer4:
                Dec     DX
                JZ      H_DecodeBufferEnd

                Pop     SI
                Jmp     H_DecodeBuffer1

H_DecodeBufferEnd:
                Xor     AL, AL
                StosB
                Pop     DI

                Mov     SI, Offset DecodeBuffer
                Mov     AH, 6
                Call    S_DrawString

                Pop     DI
                Pop     SI
                LodsW                           ; Add     SI, 2
                Add     DI, 160
                Cmp     Word Ptr [SI], 0
                LoopNZ  H_DrawHelp1

                Ret

EndP            H_DrawHelp
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            H_Help Far

                Call    Glbl_SaveMode

                Mov     BX, CS:HelpContext
                Add     BX, BX
                Mov     AX, [CS:Positions+BX]

                Mov     CS:TopLine, AX

                Mov     AX, 5
                Mov     CX, Object1
                Mov     DX, Offset O1_HelpList
                Mov     SI, 1

                Ret

EndP            H_Help

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            H_HelpUp Far

                Sub     CS:TopLine, 1
                AdC     CS:Topline, 0

                Mov     AX, 1
                Ret

EndP            H_HelpUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            H_HelpDown Far

                Push    CX

                Push    CS
                Pop     DS
                        Assume DS:Help

                Mov     SI, HelpContext
                Add     SI, SI
                Mov     SI, [HelpContextPtrs+SI]
                Mov     BX, TopLine
                Add     BX, BX
                Add     SI, BX
                Mov     CX, 32

H_HelpDown2:
                Add     SI, 2
                Cmp     Word Ptr [SI], 0
                LoopNZ  H_HelpDown2
                JZ      H_HelpDown1

                Inc     TopLine

H_HelpDown1:
                Pop     CX

                Mov     AX, 1
                Ret

EndP            H_HelpDown
                Assume DS:Nothing

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            H_HelpPgUp Far

                Mov     AX, CS:TopLine
                Sub     AX, 32
                JNS     H_HelpPgUp1

                Xor     AX, AX
H_HelpPgUp1:
                Mov     CS:TopLine, AX

                Mov     AX, 1
                Ret

EndP            H_HelpPgUp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            H_HelpPgDn Far

                Mov     CX, 32

H_HelpPgDn1:
                Call    H_HelpDown
                Loop    H_HelpPgDn1

                Ret                     ; AX = 1, set by H_HelpDown

EndP            H_HelpPgDn

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            H_HelpESC Far

                Mov     AX, CS:TopLine
                Mov     BX, CS:HelpContext
                Add     BX, BX

                Mov     [CS:Positions+BX], AX

                Jmp     Glbl_RestoreMode

EndP            H_HelpESC

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Proc            H_SetHelpContext Far

                Mov     AX, [SI+2]
                Mov     CS:HelpContext, AX
             
                Ret

EndP            H_SetHelpContext

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

EndS

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

End
