#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include <dsound.h>
#include <process.h>

/*
Registry keys:
 BufferSize         : in kb. maximum of 64
 BufferThreshold    : in kb. maximum of 32
 BufferType         : 0->2 for DualBuffer,QuadBuffer,OctBuffer
 MixSpeed           : in Hz, maximum of 48000.
*/

// Registry values.
static int BufferSize = 24;
static int BufferThreshold = 21;
static int BufferType = 2;
static int MixSpeed = 44100;

// Registry Key stuff.
const char *RegistryKey = "Software\\Jeffrey Lim\\Impulse Tracker VSound Server";
const char *RegistryKeyBufferSize = "BufferSize";
const char *RegistryKeyBufferThreshold = "BufferThreshold";
const char *RegistryKeyBufferType = "BufferType";
const char *RegistryKeyMixSpeed = "MixSpeed";

// Other stuff.
const static LPCTSTR lpszAppName = "VSound Server";
const static LPCTSTR lpszTitleBar = "Impulse Tracker VSound Server";
static HRESULT hr;

static void *BufferUpdateThreadHandle;
static int BufferUpdateThreadID;

static int Quitting = 0;

static HANDLE	NotifyEventHandle;
static LPDIRECTSOUND lpDS;
static LPDIRECTSOUNDBUFFER lpPDSB, lpSDSB;
static PCMWAVEFORMAT pcmwf =
{
    {
        WAVE_FORMAT_PCM,
        2,
        44100,
        4*44100,
        4
    },
    16
};

HINSTANCE g_hInst;
HWND g_hWnd;

char TextBuffer[80];

static short int ServerPort    = 0x401;
static short int DataPort      = 0x402;

static int SoundBufferSize;
static int SoundBufferBlockSize;
static int SoundBufferBlockMask;

char *BufferTypes[] =
{
    "DualBuffer",
    "QuadBuffer",
    "OctBuffer"
};

const char *ServerID = "ITSERVER";
const char *NoServer =
 "Unable to find VSound.VxD\n" \
 "\n" \
 "Please read the documentation on how to setup VSound.VxD";

const char *ServerActive =
 "VSound server is active.\n" \
 "\n"
 "Please shut down Impulse Tracker first";

void __cdecl trace(char *Message, ...)
{
    va_list argptr;

    va_start(argptr, Message);
    vsprintf(TextBuffer, Message, argptr);

    PostMessage(g_hWnd, WM_PAINT, 0, 0);
}

static void VSound_Reset()
{
    _outp(ServerPort, 0);
}

static void VSound_Identify()
{
    int i, j;
    char ServerString[60];
    short int TempValues[2];
    char *BufferInfo = (char*) (&TempValues);

    sprintf(ServerString, "DirectSound VSoundServer 1.0, %dkb %s", BufferSize, BufferTypes[BufferType]);

    j = strlen(ServerString);
    for(i = 0; i < 8; i++) _outp(ServerPort, ServerID[i]);
    for(i = 0; i < j; i++) _outp(ServerPort, ServerString[i]);
    for(     ; i < 60; i++) _outp(ServerPort, ' ');

    TempValues[0] = BufferThreshold * 1024;
    TempValues[1] = MixSpeed;
    for(i = 0; i < 4; i++) _outp(ServerPort, BufferInfo[i] ^ 0xFF);
}

static int VSound_Detect()
{
    int i;
    char Buffer[8];

    for(i = 0; i < 8; i++) Buffer[i] = _inp(ServerPort);
    return memcmp(ServerID, Buffer, sizeof(Buffer)) == 0;
}

static int VSound_Connected()
{
    if(!Quitting) return _inp(ServerPort);
    else return 0;
}

static void Error(char *Message)
{
    VSound_Reset();
    MessageBox(g_hWnd, Message, "VSound Server Error!", MB_OK);
    exit(1);
}

static void CheckHResult(char *Message)
{
    if(hr) Error(Message);
}

DWORD WINAPI BufferUpdateThread(void *Parameter)
{
	int UpdatePosition = 0;
    int PlayPosition;
	int Len1, Len2;
	void *Buf1, *Buf2;
    int LastBlock;
    int Active = 0;

/*
    hr = SetThreadPriority(BufferUpdateThreadHandle, THREAD_PRIORITY_TIME_CRITICAL);
    if(!hr) 
    {
        trace("Error code: %d", GetLastError());
        Error("SetThreadPriority failed");
        return;
    }

    hr = SetPriorityClass((HANDLE) BufferUpdateThreadID, REALTIME_PRIORITY_CLASS);
    if(!hr) {
        trace("Error code: %d", GetLastError());
        Error("SetPriorityClass failed");
        return;
    }
*/
    
	while(1)
	{
        int CurrentBlock;
        int NumberOfBlocks;

        WaitForMultipleObjects(1,						// count of object handle array
							   &NotifyEventHandle,	// Handle of event created to signal buffer position updates
							   FALSE,					// return if at least one event is signalled
							   INFINITE);

		hr = lpSDSB->lpVtbl->GetCurrentPosition(lpSDSB, &PlayPosition, NULL);
		CheckHResult("GetCurrentPosition failed");

        CurrentBlock = PlayPosition / SoundBufferBlockSize;
        NumberOfBlocks = (CurrentBlock - LastBlock) & SoundBufferBlockMask;
        if(NumberOfBlocks == 0) continue;

        hr = lpSDSB->lpVtbl->Lock(lpSDSB, UpdatePosition, NumberOfBlocks*SoundBufferBlockSize, &Buf1, &Len1, &Buf2, &Len2, 0);
        CheckHResult("Lock failed");

        if(VSound_Connected() != Active)
        {
            Active = ~Active;
            if(Active)
                trace("Server active");
            else
                trace("Server ready");
        }

// Update buffer here.
        __asm
        {
            Push    EDI
            Mov     DX, [DataPort]
            
            Mov     EDI, [Buf1]
            Mov     ECX, [Len1]
            Rep     InsB

            Mov     EDI, [Buf2]
            Mov     ECX, [Len2]
            Rep     InsB

            Pop     EDI
        }

        hr = lpSDSB->lpVtbl->Unlock(lpSDSB, Buf1, Len1, Buf2, Len2);
        CheckHResult("Unlock failed");

        LastBlock = CurrentBlock;
        UpdatePosition = LastBlock*SoundBufferBlockSize;
	}

    return 0;
}

void VSound_InitDSound()
{
    int i, NumberOfNotifications;
	DSBUFFERDESC DSBDesc; 
	DSBPOSITIONNOTIFY DSBPositionNotify[8];
	LPDIRECTSOUNDNOTIFY lpDSNotify;
	int Len1, Len2;
	char *Buf1, *Buf2;

    NumberOfNotifications = 2 << BufferType;
    SoundBufferSize = BufferSize*1024;
    SoundBufferBlockSize = SoundBufferSize / NumberOfNotifications;
    SoundBufferBlockMask = NumberOfNotifications - 1;

    trace("CreateEvemt");
	NotifyEventHandle = CreateEvent(NULL,	// Security attributes
									FALSE,	// Manual reset = FALSE
									FALSE,	// Signal initial state = FALSE
									NULL);	// Name
    if(!NotifyEventHandle) Error("CreateEvent failed");

    trace("DirectSoundCreate");
	hr = DirectSoundCreate(NULL, &lpDS, NULL);
    CheckHResult("DirectSoundCreate failed");

    trace("SetCooperativeLevel");
    hr = lpDS->lpVtbl->SetCooperativeLevel(lpDS, GetActiveWindow(), DSSCL_PRIORITY); 
    CheckHResult("SetCooperativeLevel failed");

    trace("CreateSoundBuffer (Primary)");
	memset(&DSBDesc, 0, sizeof(DSBUFFERDESC)); // Zero it out. 
	DSBDesc.dwSize = sizeof(DSBUFFERDESC); 
	DSBDesc.dwFlags = DSBCAPS_PRIMARYBUFFER;
	DSBDesc.dwBufferBytes = 0;
	DSBDesc.lpwfxFormat = NULL;
	hr = lpDS->lpVtbl->CreateSoundBuffer(lpDS, &DSBDesc, &lpPDSB, NULL); 
    CheckHResult("CreateSoundBuffer (Primary) failed");

    trace("SetFormat");
    pcmwf.wf.nSamplesPerSec = MixSpeed;
    pcmwf.wf.nAvgBytesPerSec = MixSpeed * 4;
	hr = lpPDSB->lpVtbl->SetFormat(lpPDSB, (void*) &pcmwf); 
    CheckHResult("SetFormat failed");

	memset(&DSBDesc, 0, sizeof(DSBUFFERDESC)); // Zero it out. 
	DSBDesc.dwSize = sizeof(DSBUFFERDESC); 
	DSBDesc.dwFlags = DSBCAPS_CTRLPOSITIONNOTIFY | 
					  DSBCAPS_GETCURRENTPOSITION2 | 
                      DSBCAPS_STICKYFOCUS |
					  DSBCAPS_LOCSOFTWARE;
	DSBDesc.dwBufferBytes = SoundBufferSize;
	DSBDesc.lpwfxFormat = (void*) &pcmwf; 
    trace("CreateSoundBuffer (Secondary)");
    hr = lpDS->lpVtbl->CreateSoundBuffer(lpDS, &DSBDesc, &lpSDSB, NULL); 
    CheckHResult("CreateSoundBuffer (Secondary) failed");

    trace("QueryInterface");
    hr = lpSDSB->lpVtbl->QueryInterface(lpSDSB, &IID_IDirectSoundNotify, &lpDSNotify); 
    CheckHResult("Error obtaining DirectSoundNotify interface");

    trace("SetNotificationPositions");
    for(i = 0; i < NumberOfNotifications; i++)
    {
	    DSBPositionNotify[i].dwOffset = i*SoundBufferBlockSize;
	    DSBPositionNotify[i].hEventNotify = NotifyEventHandle;
    }
	hr = lpDSNotify->lpVtbl->SetNotificationPositions(lpDSNotify, NumberOfNotifications, DSBPositionNotify);
    CheckHResult("SetNotificationPositions failed");

    trace("Lock (Clear)");
	hr = lpSDSB->lpVtbl->Lock(lpSDSB, 0, 0, &Buf1, &Len1, &Buf2, &Len2, DSBLOCK_ENTIREBUFFER);
    CheckHResult("Lock failed");

    trace("Clearing buffer");
    memset(Buf1, 0, Len1);

    trace("Unlock (Clear)");
	hr = lpSDSB->lpVtbl->Unlock(lpSDSB, Buf1, Len1, Buf2, Len2);
	CheckHResult("Unlocked failed");

    trace("Creating sound thread");
	BufferUpdateThreadHandle = CreateThread(NULL,					// Security atributes
											0,						// Stack size
											BufferUpdateThread,		// Pointer to thread starting function
											0,						// Parameter to new thread
											0,						// Creation flags
											&BufferUpdateThreadID);

    hr = SetThreadPriority(BufferUpdateThreadHandle, THREAD_PRIORITY_TIME_CRITICAL);
    if(!hr) Error("SetThreadPriority failed");

//  Set process to realtime priority.
/*
    hr = SetPriorityClass((DWORD) _getpid(), REALTIME_PRIORITY_CLASS);
    if(!hr) Error("SetPriorityClass failed");
*/
    trace("Play");
    hr = lpSDSB->lpVtbl->Play(lpSDSB, 0, 0, DSBPLAY_LOOPING);
    CheckHResult("Play failed");

    VSound_Identify();
    trace("Server ready");
}

LRESULT CALLBACK WndProc(HWND hWnd, UINT Message, WPARAM wParam, LPARAM lParam)
{
	switch(Message)
	{
    case WM_PAINT:
        {
            HDC hDC;
            PAINTSTRUCT Paint;
            RECT Rectangle;

            GetClientRect(hWnd, &Rectangle);
            InvalidateRect(hWnd, &Rectangle, TRUE);

            hDC = BeginPaint(hWnd, &Paint);
            
            SetBkMode(hDC, TRANSPARENT); 

            Rectangle.left += 5;
            Rectangle.right -= 5;

            DrawText(hDC, TextBuffer, strlen(TextBuffer), &Rectangle, DT_VCENTER | DT_SINGLELINE | DT_LEFT);
            EndPaint(hWnd, &Paint);
            return 0;
        }
        break;

    case WM_DESTROY:
    case WM_CLOSE:
        if(VSound_Connected())
        {
            MessageBox(hWnd, ServerActive, "Error!", MB_OK);
            return 0;
        }
        VSound_Reset();
        Quitting = 1;
        PostQuitMessage(0);
	}

	return DefWindowProc(hWnd, Message, wParam, lParam);
}

int GetRegistryInteger(const char *KeyName, int Default)
{
    HKEY hkey;
    int ReturnValue;
    int Size = 4;

    if(RegCreateKeyEx(HKEY_LOCAL_MACHINE, 
                      RegistryKey, 
                      0, 
                      (LPTSTR) lpszAppName, 
                      0, 
                      KEY_ALL_ACCESS, 
                      NULL, 
                      &hkey, 
                      NULL
                     ) == ERROR_SUCCESS)
    {
		if((hr = RegQueryValueEx(hkey, KeyName, 0, 0, (LPBYTE) &ReturnValue, &Size)) == ERROR_SUCCESS)
        {
    		RegCloseKey(hkey);
            return ReturnValue;
        }

        RegSetValueEx(hkey, KeyName, 0, REG_DWORD, (LPBYTE) &Default, sizeof(Default));
  		RegCloseKey(hkey);
        return Default;
    }
    Error("Unable to access Windows registry");
}

void SetRegistryInteger(const char *KeyName, int Value)
{
    HKEY hkey;

    if(RegCreateKeyEx(HKEY_LOCAL_MACHINE, 
                      RegistryKey, 
                      0, 
                      (LPTSTR) lpszAppName, 
                      0, 
                      KEY_ALL_ACCESS, 
                      NULL, 
                      &hkey, 
                      NULL
                     ) == ERROR_SUCCESS)
    {
        RegSetValueEx(hkey, KeyName, 0, REG_DWORD, (LPBYTE) &Value, sizeof(Value));
  		RegCloseKey(hkey);
    }

}

void GetRegistry()
{
    BufferSize = GetRegistryInteger(RegistryKeyBufferSize, 24);
    if(BufferSize < 4 || BufferSize > 64)
    {
        BufferSize = 24;
        SetRegistryInteger(RegistryKeyBufferSize, BufferSize);
    }

    BufferThreshold = GetRegistryInteger(RegistryKeyBufferThreshold, 21);
    if(BufferThreshold < 2 || BufferThreshold > 32)
    {
        BufferThreshold = BufferSize >> 1;
        SetRegistryInteger(RegistryKeyBufferThreshold, BufferThreshold);
    }

    BufferType = GetRegistryInteger(RegistryKeyBufferType, 2);
    if(BufferType < 0 || BufferType > 2)
    {
        BufferType = 2;
        SetRegistryInteger(RegistryKeyBufferType, BufferType);
    }

    MixSpeed = GetRegistryInteger(RegistryKeyMixSpeed, 44100);
    if(MixSpeed < 11025) MixSpeed = 11025;
    if(MixSpeed > 64000) MixSpeed = 64000;
    SetRegistryInteger(RegistryKeyMixSpeed, MixSpeed);
}

int APIENTRY WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	MSG msg;
	WNDCLASSEX wc;

	g_hInst = hInstance;

	// Window Class parameters.
	wc.style		= CS_HREDRAW | CS_VREDRAW;
	wc.lpfnWndProc	= (WNDPROC) WndProc;
	wc.cbClsExtra	= 0;
	wc.cbWndExtra	= 0;
	wc.hInstance	= hInstance;
	wc.hIcon		= NULL;
	wc.hCursor		= LoadCursor(NULL, IDC_ARROW);;
	wc.hbrBackground= (HBRUSH) (COLOR_WINDOW);
	wc.lpszMenuName = lpszAppName;
	wc.lpszClassName= lpszAppName;
	wc.cbSize		= sizeof(WNDCLASSEX);
	wc.hIconSm		= NULL;

	if(RegisterClassEx(&wc))
	{
		// Create window.
		g_hWnd = CreateWindow(
					lpszAppName,
					lpszTitleBar,
                    WS_OVERLAPPED | WS_BORDER | WS_CAPTION | WS_MINIMIZEBOX | WS_SYSMENU | WS_VISIBLE,
					CW_USEDEFAULT,
					CW_USEDEFAULT,
					280,
					50,
					NULL,
					NULL,
					hInstance,
					NULL
				 );
        if(g_hWnd)
        {
            // Lets first see if the VSound server exists.

            if(!VSound_Detect())
            {
                trace("Connect to VSound.VxD failed");
                MessageBox(NULL, NoServer, "Error!", MB_OK);
                exit(1);
            }

            GetRegistry();
            VSound_InitDSound();

		    while( GetMessage(&msg, NULL, 0, 0))
		    {
			    TranslateMessage(&msg);
			    DispatchMessage(&msg);
		    }
		    return (msg.wParam);
        }
	}
	return 1;
}
