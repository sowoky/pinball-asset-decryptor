#pragma once
// macOS stub: no audio playback; extraction modes never play.
#include <Windows.h>
class SimpleWindowsAudio {
public:
	SimpleWindowsAudio(HWND, int, int, int) {}
	void SetIdleTask(void (*)(void *), void *) {}
	bool InitDirectSound() { return false; }
	const char *GetErrorDesc() { return "audio playback not supported in the macOS build"; }
	void WriteAudioData(const INT16 *, DWORD) {}
	void SetVolume(int) {}
};
