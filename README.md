# Impulse Tracker

Full source code for Impulse Tracker, including sound drivers, network drivers,
and some supporting documentation

This was originally released on BitBucket in 2014 alongside an article series
titled "20 years of Impulse Tracker", but BitBucket sunset mercurial
repositories, and so this is now made available on GitHub.

- [First Article](https://roartindon.blogspot.com/2014/02/20-years-of-impulse-tracker.html)
- [Second Article](https://roartindon.blogspot.com/2014/03/20-years-of-impulse-tracker-part-2.html)
- [Third Article](https://roartindon.blogspot.com/2014/10/20-years-of-impulse-tracker-part-3.html)
- [Fourth Article](https://roartindon.blogspot.com/2014/12/20-years-of-impulse-tracker-part-4.html)

Note that this repository is purely sharing what used to be -- there is no
active development, and changes/fixes will not be merged other than issues
preventing build.

## Pre-Requisite Software

To build Impulse Tracker, you will need:

- Turbo Assembler v4.1

- Turbo Link v3.01

- Borland MAKE v4.0

- A DOS environment

Once you have these, building IT.EXE should be just a single call to `MAKE`

Sound drivers are build individually via M\*.BAT files inside the SoundDrivers
subdirectory

## Quick File Overview

- IT.ASM:
  Startup routines
- IT_DISK.ASM:
  Disk IO Routines. Uses IT_D\_\*.INC files

- IT_DISPL.ASM:
  Display routines for the Playback Screen (F5)

- IT_EMS.ASM:
  EMS memory handling routines

- IT_F.ASM:
  Collection of functions used by the object model

- IT_FOUR.ASM:
  Fast Fourier routines. Used by the graphic equalizer (Alt-F12).
  Not available on all all sound cards

- IT_G.ASM:
  Global key handler functions

- IT_H.ASM:
  Help Module (F1)

- IT_I.ASM:
  Sample list (F3) and Instrument list (F4) module

- IT_K.ASM:
  Keyboard module

- IT_L.ASM:
  Information line code

- IT_M.ASM:
  Main message loop/dispatcher

- IT_MDATA.ASM:
  Global music variable data

- IT_MMTSR.ASM:
  Sample compression/decompression routines

- IT_MOUSE.ASM:
  Mouse handling code

- IT_MSG.ASM:
  Message editor module (Shift-F9)

- IT_MUSIC.ASM:
  Module playback code. Also uses IT_M_EFF.INC

- IT_NET.ASM:
  Network code

- IT_OBJ1.ASM:
  UI object definitions

- IT_PE.ASM:
  Pattern Editor module (F2)

- IT_S.ASM:
  Screen functions, including character generation

- IT_TUTE.ASM:
  Interactive Tutorial module

- IT_VESA.ASM:
  VESA code for graphic equalizer

- SWITCH.INC:
  High level switches for the program

## Frequently Asked Questions

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

## License

BSD 3-clause license can be found in [LICENSE](LICENSE).
