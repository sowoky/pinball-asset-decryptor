#pragma once
// macOS shim for DCSExplorer: the Win32 types and CRT functions it uses.
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <strings.h>
#include <stdarg.h>
#include <time.h>
#include <limits.h>
#include <errno.h>
typedef uint8_t BYTE; typedef uint16_t WORD; typedef uint32_t DWORD; typedef int32_t LONG;
typedef uint8_t UINT8; typedef uint16_t UINT16; typedef uint32_t UINT32; typedef uint64_t UINT64;
typedef int16_t INT16; typedef int32_t INT32; typedef int64_t INT64; typedef unsigned int UINT;
typedef void *HWND; typedef int BOOL;
#ifndef MAX_PATH
#define MAX_PATH 1024
#endif
#define _stricmp strcasecmp
#define _strnicmp strncasecmp
#define _strdup strdup
template<size_t N> inline int sprintf_s(char (&b)[N], const char *f, ...) { va_list a; va_start(a, f); int r = vsnprintf(b, N, f, a); va_end(a); return r; }
inline int sprintf_s(char *b, size_t n, const char *f, ...) { va_list a; va_start(a, f); int r = vsnprintf(b, n, f, a); va_end(a); return r; }
template<size_t N> inline int strcat_s(char (&d)[N], const char *s) { strlcat(d, s, N); return 0; }
inline int strcat_s(char *d, size_t n, const char *s) { strlcat(d, s, n); return 0; }
template<size_t N> inline int strcpy_s(char (&d)[N], const char *s) { strlcpy(d, s, N); return 0; }
inline int strcpy_s(char *d, size_t n, const char *s) { strlcpy(d, s, n); return 0; }
inline int fopen_s(FILE **fp, const char *n, const char *m) { *fp = fopen(n, m); return *fp ? 0 : errno; }
inline int localtime_s(struct tm *t, const time_t *s) { return localtime_r(s, t) ? 0 : 1; }
template<size_t N> inline int asctime_s(char (&b)[N], const struct tm *t) { asctime_r(t, b); return 0; }
inline void Sleep(DWORD) {}
#ifndef _countof
#define _countof(a) (sizeof(a)/sizeof((a)[0]))
#endif
