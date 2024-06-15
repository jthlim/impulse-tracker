
This package contains 6 files

1. IT.EXE - This can be considered IT214 Patch #4. Includes a few bugfixes
            and some minor enhancements. Registered users should use their
            own IT.EXE

2. ITVSOUND.MMX - Virtual Sound Driver for Impulse Tracker. This is a MMX
                  driver and will not work on non MMX computers.

3. ITVSOUND.DRV - Virtual Sound Driver for Impulse Tracker. This is a non-MMX
                  driver and should work on all computers.

4. ITVSOUND.VXD - Driver to connect ITVSOUND.MMX to the server.

5. SERVER.EXE - Windows server to connect to DirectSound

6. README.TXT - This file.

How to use these files
----------------------
You MUST have DirectX installed. It was written with the DirectX6 SDK,
although I'm pretty sure DirectSound 5 is sufficient.

1. Copy ITVSOUND.VXD into your Windows\System directory
   (normally C:\WINDOWS\SYSTEM)

2. In your Windows directory (normally C:\WINDOWS), edit your SYSTEM.INI file
   and include the line:
                              device=itvsound.vxd
   anywhere in the [386Enh] section

3. Reboot your computer

4. Run Server.EXE

5. Run "IT"

Configuring the driver
----------------------
The driver can be configured by modifying Window's Registry by running
"regedit" (which comes with Windows). The variables can be found at:
 "KHEY_LOCAL_MACHINE\Software\Jeffrey Lim\Impulse Tracker VSound Server"

The 4 variables are:
 BufferSize       - The size of the DirectSound buffer in kb.
                    Permitted ranges from 4 to 64, default 24
 BufferThreshold  - The size of the buffer that IT tries to maintain in kb.
                    Permitted ranges from 2 to 32, default 21
 BufferType  - 0 = DualBuffer (BufferSize is logically split into 2 sections)
               1 = QuadBuffer (BufferSize is logically split into 4 sections)
               2 = OctBuffer  (BufferSize is logically split into 8 sections)
                   (recommended, default)
 MixSpeed         - Mixing rate to be used in Hz.
                    Permitted ranges from 11025 to 64000, default 44100

You will need to restart the server before these changes take effect.

Known Problems
--------------
1. This driver only works with Win95 and Win98, NOT WinNT (I'll try a WinNT
   driver sometime).

2. There is an obvious latency due to the size of the buffers and the delay
   that is inherent to DirectSound. Reducing the BufferSize and BufferThreshold
   values can reduce this latency, however, smaller values can also cause the
   sound to break up.

    Try using the values:
     1. BufferSize=16, BufferThreshold=14, BufferType=2, MixSpeed = 44100


