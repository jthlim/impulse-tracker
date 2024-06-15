Impulse Tracker
===============

Full source code for Impulse Tracker, including sound drivers, network drivers,
and some supporting documentation

 

Pre-Requisite Software
----------------------

To build Impulse Tracker, you will need:

-   Turbo Assembler v4.1

-   Turbo Link v3.01

-   Borland MAKE v4.0

-   A DOS environment

 

Once you have these, building IT.EXE should be just a single call to `MAKE`


Sound drivers are build individually via M\*.BAT files inside the SoundDrivers
subdirectory

 

Quick File Overview
-------------------

-	IT.ASM:
	Startup routines
	
-	IT\_DISK.ASM:
	Disk IO Routines. Uses IT\_D\_\*.INC files

-	IT\_DISPL.ASM:
	Display routines for the Playback Screen (F5)

-	IT\_EMS.ASM:
	EMS memory handling routines

-	IT\_F.ASM:
	Collection of functions used by the object model

-	IT\_FOUR.ASM:
	Fast Fourier routines. Used by the graphic equalizer (Alt-F12).
	Not available on all all sound cards

-	IT\_G.ASM:
	Global key handler functions

-	IT\_H.ASM:
	Help Module (F1)

-	IT\_I.ASM:
	Sample list (F3) and Instrument list (F4) module 

-	IT\_K.ASM:
	Keyboard module

-	IT\_L.ASM:
	Information line code

-	IT\_M.ASM:
	Main message loop/dispatcher

-	IT\_MDATA.ASM:
	Global music variable data

-	IT\_MMTSR.ASM:
	Sample compression/decompression routines

-	IT\_MOUSE.ASM:
	Mouse handling code

-	IT\_MSG.ASM:
	Message editor module (Shift-F9)

-	IT\_MUSIC.ASM:
	Module playback code. Also uses IT\_M\_EFF.INC

-	IT\_NET.ASM:
	Network code

-	IT\_OBJ1.ASM:
	UI object definitions

-	IT\_PE.ASM:
	Pattern Editor module (F2)

-	IT\_S.ASM:
	Screen functions, including character generation

-	IT\_TUTE.ASM:
	Interactive Tutorial module

-	IT\_VESA.ASM:
	VESA code for graphic equalizer

-	SWITCH.INC:
	High level switches for the program



Frequently Asked Questions
--------------------------

Q: "What are all those funny characters in the source code?"

A: I wrote the original source code using DOS characters, with characters drawing borders/boxes in 
comments in the source code. In the interests of posterity, I have left the code intact as it was.


Q: "Why didn't you use STRUCs or ENUMs" in your ASM source? 

A: Simply because I didn't know about them at the time. I wish I did. There's a InternalDocumentation 
folder that I've included in the repository that details what some of the magic numbers appearing 
through the code might mean.
 

Q: "Flow in some functions seems to jump all over the place. Why?"

A: The original code was compatible all the way back to an 8086 machine. 8086 would allow you to do 
conditional jumps only within +/-128 bytes, so I spent too much time shuffling code around to meet 
this restriction. When I shifted away from this 8086 restriction, I never went back to update the 
code that was mutilated by it.
 


License
-------

License for this source code is pending.
