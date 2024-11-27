typedef void* HANDLE;
typedef long LONG;
typedef LONG HRESULT;
typedef const char* LPCTSTR;
typedef unsigned long DWORD;
typedef unsigned long ULONG;
typedef void* PVOID;
typedef void* LPVOID;
typedef bool BOOL;
typedef const void* LPCVOID;
typedef unsigned long long ULONGLONG;
typedef long long LONGLONG;
typedef unsigned long* ULONG_PTR;
typedef char *LPTSTR;
typedef DWORD* LPDWORD;
typedef ULONG REGSAM;
typedef DWORD SECURITY_INFORMATION, *PSECURITY_INFORMATION;
typedef PVOID PSECURITY_DESCRIPTOR;
typedef struct _GUID {
  unsigned long  Data1;
  unsigned short Data2;
  unsigned short Data3;
  unsigned char  Data4[8];
} GUID;
typedef GUID* REFGUID;

typedef struct _SECURITY_ATTRIBUTES {
  DWORD  nLength;
  LPVOID lpSecurityDescriptor;
  BOOL   bInheritHandle;
} SECURITY_ATTRIBUTES, *PSECURITY_ATTRIBUTES, *LPSECURITY_ATTRIBUTES;

typedef struct _FILETIME {
  DWORD dwLowDateTime;
  DWORD dwHighDateTime;
} FILETIME, *PFILETIME, *LPFILETIME;

using size_t = decltype(sizeof(int));
using SIZE_T = size_t;

typedef struct _OVERLAPPED {
  ULONG_PTR Internal;
  ULONG_PTR InternalHigh;
  union {
    struct {
      DWORD Offset;
      DWORD OffsetHigh;
    } DUMMYSTRUCTNAME;
    PVOID Pointer;
  } DUMMYUNIONNAME;
  HANDLE    hEvent;
} OVERLAPPED, *LPOVERLAPPED;

using LPOVERLAPPED_COMPLETION_ROUTINE = void(DWORD, DWORD, LPOVERLAPPED);

using HKEY = void*;
