
TRACEENABLED          EQU   0

TUTORIAL        = 0

  EMSUSE41        = 0

  SHOWVERSION         = 0
  SHOWREGISTERNAME    = 1

  USE32BITSCREENCOPY  = 0

  SORTENABLED         = 1
  DDCOMPRESS          = 1
  ORDERSORT           = 1
  FILTERENVELOPES     = 1
  CHORDENTRY          = 1
  SPECTRUMANALYSER    = 1
  SAVESAMPLEWAV       = 1
  ENABLEPRESETENVELOPES = 1
  ENABLESOLO          = 1

    DEFAULTFORMAT     = 3 ; 0 = IT214, 1 = S3M, 2 = IT2xx, 3 = IT215

    USEFPUCODE        = 1 ; For IT_MUSIC, this will change from LUT to FPU code

    OLDDRIVER         = 0

    MUSICDEBUG        = 0
    EMSDEBUG          = 0
    MEMORYDEBUG       = 0
    ENABLEINT3        = 0 ; For debugging.

    TIMERSCREEN       = 1

    NETWORKENABLED    = 1
    SHOWPATTERNLENGTH = 0

IF TUTORIAL
 SORTENABLED     = 1
 DDCOMPRESS      = 1
ENDIF

TRACKERVERSION  = 217h          ; Still have to change text in IT.ASM, IT_F.ASM
