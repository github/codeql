void sink(char);
void sink(char*);
void sink(char**);

using HANDLE = void*;
using DWORD = unsigned long;
using LPCH = char*;
using LPSTR = char*;
using LPCSTR = const char*;
using LPVOID = void*;
using LPDWORD = unsigned long*;
using PVOID = void*;
using ULONG_PTR = unsigned long*;
using SIZE_T = decltype(sizeof(0));

LPSTR GetCommandLineA();
LPSTR* CommandLineToArgvA(LPSTR, int*);
LPCH GetEnvironmentStringsA();
DWORD GetEnvironmentVariableA(LPCSTR, LPSTR, DWORD);

void getCommandLine() {
  char* cmd = GetCommandLineA();
  sink(cmd);
  sink(*cmd); // $ ir

  int argc;
  char** argv = CommandLineToArgvA(cmd, &argc);
  sink(argv);
  sink(argv[1]);
  sink(*argv[1]); // $ ir
}

void getEnvironment() {
    char* env = GetEnvironmentStringsA();
    sink(env);
    sink(*env); // $ ir

    char buf[1024];
    GetEnvironmentVariableA("FOO", buf, sizeof(buf));
    sink(buf);
    sink(*buf); // $ ir
}

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

using BOOL = int;
#define FILE_MAP_READ 0x0004

using ULONG64 = unsigned long long;
using ULONG = unsigned long;

using DWORD64 = unsigned long long;
#define MEM_EXTENDED_PARAMETER_TYPE_BITS 8

typedef struct MEM_EXTENDED_PARAMETER {
  struct {
    DWORD64 Type : MEM_EXTENDED_PARAMETER_TYPE_BITS;
    DWORD64 Reserved : 64 - MEM_EXTENDED_PARAMETER_TYPE_BITS;
  } DUMMYSTRUCTNAME;
  union {
    DWORD64 ULong64;
    PVOID   Pointer;
    SIZE_T  Size;
    HANDLE  Handle;
    DWORD   ULong;
  } DUMMYUNIONNAME;
} MEM_EXTENDED_PARAMETER, *PMEM_EXTENDED_PARAMETER;

BOOL ReadFile(
  HANDLE       hFile,
  LPVOID       lpBuffer,
  DWORD        nNumberOfBytesToRead,
  LPDWORD      lpNumberOfBytesRead,
  LPOVERLAPPED lpOverlapped
);

using LPOVERLAPPED_COMPLETION_ROUTINE = void (*)(DWORD, DWORD, LPOVERLAPPED);

BOOL ReadFileEx(
  HANDLE                          hFile,
  LPVOID                          lpBuffer,
  DWORD                           nNumberOfBytesToRead,
  LPOVERLAPPED                    lpOverlapped,
  LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
);

using NTSTATUS = long;
using PIO_APC_ROUTINE = void (*)(struct _DEVICE_OBJECT*, struct _IRP*, PVOID);
typedef struct _IO_STATUS_BLOCK {
  union {
    NTSTATUS Status;
    PVOID    Pointer;
  } DUMMYUNIONNAME;
  ULONG_PTR Information;
} IO_STATUS_BLOCK, *PIO_STATUS_BLOCK;
using LONGLONG = long long;
using LONG = long;
typedef struct _LARGE_INTEGER {
  union {
    struct {
      ULONG LowPart;
      LONG  HighPart;
    } DUMMYSTRUCTNAME;
    LONGLONG QuadPart;
  } DUMMYUNIONNAME;
} LARGE_INTEGER, *PLARGE_INTEGER;

using PULONG = unsigned long*;

NTSTATUS NtReadFile(
  HANDLE           FileHandle,
  HANDLE           Event,
  PIO_APC_ROUTINE  ApcRoutine,
  PVOID            ApcContext,
  PIO_STATUS_BLOCK IoStatusBlock,
  PVOID            Buffer,
  ULONG            Length,
  PLARGE_INTEGER   ByteOffset,
  PULONG           Key
);


void FileIOCompletionRoutine(
  DWORD dwErrorCode,
  DWORD dwNumberOfBytesTransfered,
  LPOVERLAPPED lpOverlapped
) {
  char* buffer = reinterpret_cast<char*>(lpOverlapped->hEvent);
  sink(buffer);
  sink(*buffer); // $ MISSING: ir
}

void FileIOCompletionRoutine2(
  DWORD dwErrorCode,
  DWORD dwNumberOfBytesTransfered,
  LPOVERLAPPED lpOverlapped
) {
  char* buffer = reinterpret_cast<char*>(lpOverlapped->hEvent);
  sink(buffer);
  sink(*buffer); // $ ir
}

void FileIOCompletionRoutine3(
  DWORD dwErrorCode,
  DWORD dwNumberOfBytesTransfered,
  LPOVERLAPPED lpOverlapped
) {
  char c = reinterpret_cast<char>(lpOverlapped->hEvent);
  sink(c); // $ ir
}

void readFile(HANDLE hFile) {
  {
    char buffer[1024];
    DWORD bytesRead;
    OVERLAPPED overlapped;
    BOOL result = ReadFile(hFile, buffer, sizeof(buffer), &bytesRead, &overlapped);
    sink(buffer);
    sink(*buffer); // $ ir
  }

  {
    char buffer[1024];
    OVERLAPPED overlapped;
    overlapped.hEvent = reinterpret_cast<HANDLE>(buffer);
    ReadFileEx(hFile, buffer, sizeof(buffer) - 1, &overlapped, FileIOCompletionRoutine);
    sink(buffer);
    sink(*buffer); // $ ir

    char* p = reinterpret_cast<char*>(overlapped.hEvent);
    sink(p);
    sink(*p); // $ MISSING: ir
  }
  
  {
    char buffer[1024];
    OVERLAPPED overlapped;
    ReadFile(hFile, buffer, sizeof(buffer), nullptr, nullptr);
    overlapped.hEvent = reinterpret_cast<HANDLE>(buffer);
    char buffer2[1024];
    ReadFileEx(hFile, buffer2, sizeof(buffer2) - 1, &overlapped, FileIOCompletionRoutine2);
  }

  {
    char buffer[1024];
    OVERLAPPED overlapped;
    ReadFile(hFile, buffer, sizeof(buffer), nullptr, nullptr);
    overlapped.hEvent = reinterpret_cast<HANDLE>(*buffer);
    char buffer2[1024];
    ReadFileEx(hFile, buffer2, sizeof(buffer2) - 1, &overlapped, FileIOCompletionRoutine3);
  }

  {
    char buffer[1024];
    IO_STATUS_BLOCK ioStatusBlock;
    LARGE_INTEGER byteOffset;
    ULONG key;
    NTSTATUS status = NtReadFile(hFile, nullptr, nullptr, nullptr, &ioStatusBlock, buffer, sizeof(buffer), &byteOffset, &key);
    sink(buffer);
    sink(*buffer); // $ ir
  }
}

LPVOID MapViewOfFile(
  HANDLE hFileMappingObject,
  DWORD  dwDesiredAccess,
  DWORD  dwFileOffsetHigh,
  DWORD  dwFileOffsetLow,
  SIZE_T dwNumberOfBytesToMap
);

PVOID MapViewOfFile2(
  HANDLE  FileMappingHandle,
  HANDLE  ProcessHandle,
  ULONG64 Offset,
  PVOID   BaseAddress,
  SIZE_T  ViewSize,
  ULONG   AllocationType,
  ULONG   PageProtection
);

PVOID MapViewOfFile3(
  HANDLE                 FileMapping,
  HANDLE                 Process,
  PVOID                  BaseAddress,
  ULONG64                Offset,
  SIZE_T                 ViewSize,
  ULONG                  AllocationType,
  ULONG                  PageProtection,
  MEM_EXTENDED_PARAMETER *ExtendedParameters,
  ULONG                  ParameterCount
);

PVOID MapViewOfFile3FromApp(
  HANDLE                 FileMapping,
  HANDLE                 Process,
  PVOID                  BaseAddress,
  ULONG64                Offset,
  SIZE_T                 ViewSize,
  ULONG                  AllocationType,
  ULONG                  PageProtection,
  MEM_EXTENDED_PARAMETER *ExtendedParameters,
  ULONG                  ParameterCount
);

LPVOID MapViewOfFileEx(
  HANDLE hFileMappingObject,
  DWORD  dwDesiredAccess,
  DWORD  dwFileOffsetHigh,
  DWORD  dwFileOffsetLow,
  SIZE_T dwNumberOfBytesToMap,
  LPVOID lpBaseAddress
);

PVOID MapViewOfFileFromApp(
  HANDLE  hFileMappingObject,
  ULONG   DesiredAccess,
  ULONG64 FileOffset,
  SIZE_T  NumberOfBytesToMap
);

PVOID MapViewOfFileNuma2(
  HANDLE  FileMappingHandle,
  HANDLE  ProcessHandle,
  ULONG64 Offset,
  PVOID   BaseAddress,
  SIZE_T  ViewSize,
  ULONG   AllocationType,
  ULONG   PageProtection,
  ULONG   PreferredNode
);

void mapViewOfFile(HANDLE hMapFile) {
  {
    LPVOID pMapView = MapViewOfFile(hMapFile, FILE_MAP_READ, 0, 0, 0);
    char* buffer = reinterpret_cast<char*>(pMapView);
    sink(buffer);
    sink(*buffer); // $ ir
  }

  {
    LPVOID pMapView = MapViewOfFile2(hMapFile, nullptr, 0, nullptr, 0, 0, 0);
    char* buffer = reinterpret_cast<char*>(pMapView);
    sink(buffer);
    sink(*buffer); // $ ir
  }

  {
    MEM_EXTENDED_PARAMETER extendedParams;

    LPVOID pMapView = MapViewOfFile3(hMapFile, nullptr, 0, 0, 0, 0, 0, &extendedParams, 1);
    char* buffer = reinterpret_cast<char*>(pMapView);
    sink(buffer);
    sink(*buffer); // $ ir
  }

  {
    MEM_EXTENDED_PARAMETER extendedParams;

    LPVOID pMapView = MapViewOfFile3FromApp(hMapFile, nullptr, 0, 0, 0, 0, 0, &extendedParams, 1);
    char* buffer = reinterpret_cast<char*>(pMapView);
    sink(buffer);
    sink(*buffer); // $ ir
  }

  {
    LPVOID pMapView = MapViewOfFileEx(hMapFile, FILE_MAP_READ, 0, 0, 0, nullptr);
    char* buffer = reinterpret_cast<char*>(pMapView);
    sink(buffer);
    sink(*buffer); // $ ir
  }

  {
    LPVOID pMapView = MapViewOfFileFromApp(hMapFile, FILE_MAP_READ, 0, 0);
    char* buffer = reinterpret_cast<char*>(pMapView);
    sink(buffer);
    sink(*buffer); // $ ir
  }

  {
    LPVOID pMapView = MapViewOfFileNuma2(hMapFile, nullptr, 0, nullptr, 0, 0, 0, 0);
    char* buffer = reinterpret_cast<char*>(pMapView);
    sink(buffer);
    sink(*buffer); // $ ir
  }
}

typedef struct _SECURITY_ATTRIBUTES
{
  DWORD nLength;
  LPVOID lpSecurityDescriptor;
  BOOL bInheritHandle;
} SECURITY_ATTRIBUTES, *PSECURITY_ATTRIBUTES, *LPSECURITY_ATTRIBUTES;

typedef DWORD (*LPTHREAD_START_ROUTINE)(
    LPVOID lpThreadParameter);

HANDLE CreateThread(
    LPSECURITY_ATTRIBUTES lpThreadAttributes,
    SIZE_T dwStackSize,
    LPTHREAD_START_ROUTINE lpStartAddress,
    LPVOID lpParameter,
    DWORD dwCreationFlags,
    LPDWORD lpThreadId);

HANDLE CreateRemoteThread(
  HANDLE                 hProcess,
  LPSECURITY_ATTRIBUTES  lpThreadAttributes,
  SIZE_T                 dwStackSize,
  LPTHREAD_START_ROUTINE lpStartAddress,
  LPVOID                 lpParameter,
  DWORD                  dwCreationFlags,
  LPDWORD                lpThreadId
);

typedef ULONG_PTR DWORD_PTR;

typedef struct _PROC_THREAD_ATTRIBUTE_ENTRY
{
    DWORD_PTR   Attribute;
    SIZE_T      cbSize;
    PVOID       lpValue;
} PROC_THREAD_ATTRIBUTE_ENTRY, *LPPROC_THREAD_ATTRIBUTE_ENTRY;
 
// This structure contains a list of attributes that have been added using UpdateProcThreadAttribute
typedef struct _PROC_THREAD_ATTRIBUTE_LIST
{
    DWORD                          dwFlags;
    ULONG                          Size;
    ULONG                          Count;
    ULONG                          Reserved;  
    PULONG                         Unknown;
    PROC_THREAD_ATTRIBUTE_ENTRY    Entries[1];
} PROC_THREAD_ATTRIBUTE_LIST, *LPPROC_THREAD_ATTRIBUTE_LIST;

HANDLE CreateRemoteThreadEx(
  HANDLE                       hProcess,
  LPSECURITY_ATTRIBUTES        lpThreadAttributes,
  SIZE_T                       dwStackSize,
  LPTHREAD_START_ROUTINE       lpStartAddress,
  LPVOID                       lpParameter,
  DWORD                        dwCreationFlags,
  LPPROC_THREAD_ATTRIBUTE_LIST lpAttributeList,
  LPDWORD                      lpThreadId
);

struct S
{
  int x;
};

DWORD ThreadProc1(LPVOID lpParameter)
{
  S *s = (S *)lpParameter;
  sink(s->x); // $ ir
  return 0;
}

DWORD ThreadProc2(LPVOID lpParameter)
{
  S *s = (S *)lpParameter;
  sink(s->x); // $ ir
  return 0;
}

DWORD ThreadProc3(LPVOID lpParameter)
{
  S *s = (S *)lpParameter;
  sink(s->x); // $ ir
  return 0;
}

int source();

void test_create_thread()
{
  SECURITY_ATTRIBUTES sa;

  S s;
  s.x = source();

  {
  DWORD threadId;
  HANDLE threadHandle = CreateThread(
      &sa,
      0,
      ThreadProc1,
      &s,
      0,
      &threadId);
  }

  {
  DWORD threadId;
  HANDLE threadHandle = CreateRemoteThread(
      nullptr,
      &sa,
      0,
      ThreadProc2,
      &s,
      0,
      &threadId);
  }

  {
  DWORD threadId;
  PROC_THREAD_ATTRIBUTE_LIST attrList;
  HANDLE threadHandle = CreateRemoteThreadEx(
      nullptr,
      &sa,
      0,
      ThreadProc3,
      &s,
      0,
      &attrList,
      &threadId);
  }
}

using size_t = decltype(sizeof(0));

volatile void * RtlCopyVolatileMemory(
  volatile void       *Destination,
  volatile const void *Source,
  size_t              Length
);

volatile void * RtlCopyDeviceMemory(
  volatile void       *Destination,
  volatile const void *Source,
  size_t              Length
);

void RtlCopyMemory(
   void*       Destination,
   const void* Source,
   size_t      Length
);

using VOID = void;

VOID RtlCopyMemoryNonTemporal(
  VOID       *Destination,
  const VOID *Source,
  SIZE_T     Length
);

using USHORT = unsigned short;
using PWSTR = wchar_t*;
using PCWSTR = const wchar_t*;
using PCUNICODE_STRING = const struct _UNICODE_STRING*;

typedef struct _UNICODE_STRING {
  USHORT Length;
  USHORT MaximumLength;
  PWSTR  Buffer;
} UNICODE_STRING, *PUNICODE_STRING;

VOID RtlCopyUnicodeString(
  PUNICODE_STRING  DestinationString,
  PCUNICODE_STRING SourceString
);

void RtlMoveMemory(
   void*       Destination,
   const void* Source,
   size_t      Length
);

volatile void * RtlMoveVolatileMemory(
  volatile void       *Destination,
  volatile const void *Source,
  size_t              Length
);

void RtlInitUnicodeString(
  PUNICODE_STRING DestinationString,
  PCWSTR          SourceString
);

void test_copy_and_move_memory() {
  int x = source();

  {
    char dest_buffer[1024];
    RtlCopyVolatileMemory(dest_buffer, &x, sizeof(x));
    sink(dest_buffer[0]); // $ ir
  }
  {
    char dest_buffer[1024];
    RtlCopyDeviceMemory(dest_buffer, &x, sizeof(x));
    sink(dest_buffer[0]); // $ ir
  }
  {
    char dest_buffer[1024];
    RtlCopyMemory(dest_buffer, &x, sizeof(x));
    sink(dest_buffer[0]); // $ ir
  }
  {
    char dest_buffer[1024];
    RtlCopyMemoryNonTemporal(dest_buffer, &x, sizeof(x));
    sink(dest_buffer[0]); // $ ir
  }
  {
    UNICODE_STRING dest_string;
    UNICODE_STRING src_string;
    wchar_t buffer[1024];
    buffer[0] = source();
    
    RtlInitUnicodeString(&src_string, buffer);
    sink(src_string.Buffer[0]); // $ ir
    RtlCopyUnicodeString(&dest_string, &src_string);
    sink(dest_string.Buffer[0]); // $ ir
  }
  {
    char dest_buffer[1024];
    RtlMoveMemory(dest_buffer, &x, sizeof(x));
    sink(dest_buffer[0]); // $ ir
  }
  {
    volatile char dest_buffer[1024];
    RtlMoveVolatileMemory(dest_buffer, &x, sizeof(x));
    sink(dest_buffer[0]); // $ ir
  }
}

using HINTERNET = void*;
using ULONGLONG = unsigned long long;
using UINT = unsigned int;
using PDWORD = DWORD*;
using PCSTR = const char*;
typedef union _WINHTTP_HEADER_NAME {
  PCWSTR pwszName;
  PCSTR  pszName;
} WINHTTP_HEADER_NAME, *PWINHTTP_HEADER_NAME;
typedef struct _WINHTTP_EXTENDED_HEADER {
  union {
    PCWSTR pwszName;
    PCSTR  pszName;
  };
  union {
    PCWSTR pwszValue;
    PCSTR  pszValue;
  };
} WINHTTP_EXTENDED_HEADER, *PWINHTTP_EXTENDED_HEADER;

BOOL WinHttpReadData(
  HINTERNET hRequest,
  LPVOID    lpBuffer,
  DWORD     dwNumberOfBytesToRead,
  LPDWORD   lpdwNumberOfBytesRead
);

DWORD WinHttpReadDataEx(
  HINTERNET hRequest,
  LPVOID    lpBuffer,
  DWORD     dwNumberOfBytesToRead,
  LPDWORD   lpdwNumberOfBytesRead,
  ULONGLONG ullFlags,
  DWORD     cbProperty,
  PVOID     pvProperty
);

using LPCWSTR = const wchar_t*;

BOOL WinHttpQueryHeaders(
  HINTERNET hRequest,
  DWORD     dwInfoLevel,
  LPCWSTR   pwszName,
  LPVOID    lpBuffer,
  LPDWORD   lpdwBufferLength,
  LPDWORD   lpdwIndex
);

DWORD WinHttpQueryHeadersEx(
  HINTERNET                hRequest,
  DWORD                    dwInfoLevel,
  ULONGLONG                ullFlags,
  UINT                     uiCodePage,
  PDWORD                   pdwIndex,
  PWINHTTP_HEADER_NAME     pHeaderName,
  PVOID                    pBuffer,
  PDWORD                   pdwBufferLength,
  PWINHTTP_EXTENDED_HEADER *ppHeaders,
  PDWORD                   pdwHeadersCount
);

void sink(PCSTR);

void test_winhttp(HINTERNET hRequest) {
  {
    char buffer[1024];
    DWORD bytesRead;
    BOOL result = WinHttpReadData(hRequest, buffer, sizeof(buffer), &bytesRead);
    sink(buffer);
    sink(*buffer); // $ ir
  }
  {
    char buffer[1024];
    DWORD bytesRead;
    DWORD result = WinHttpReadDataEx(hRequest, buffer, sizeof(buffer), &bytesRead, 0, 0, nullptr);
    sink(buffer);
    sink(*buffer); // $ ir
  }
  {
    char buffer[1024];
    DWORD bufferLength = sizeof(buffer);
    WinHttpQueryHeaders(hRequest, 0, nullptr, buffer, &bufferLength, nullptr);
    sink(buffer);
    sink(*buffer); // $ ir
  }
  {
    char buffer[1024];
    DWORD bufferLength = sizeof(buffer);
    PWINHTTP_EXTENDED_HEADER headers;
    DWORD headersCount;
    PWINHTTP_HEADER_NAME headerName;
    DWORD result = WinHttpQueryHeadersEx(hRequest, 0, 0, 0, nullptr, headerName, buffer, &bufferLength, &headers, &headersCount);
    sink(buffer);
    sink(*buffer); // $ ir
    sink(headerName->pszName);
    sink(*headerName->pszName); // $ ir
    sink(headers->pszValue);
    sink(*headers->pszValue); // $ ir
  }
}

using LPWSTR = wchar_t*;
using INTERNET_SCHEME = enum {
  INTERNET_SCHEME_INVALID = -1,
  INTERNET_SCHEME_UNKNOWN = 0,
  INTERNET_SCHEME_HTTP = 1,
  INTERNET_SCHEME_HTTPS = 2,
  INTERNET_SCHEME_FTP = 3,
  INTERNET_SCHEME_FILE = 4,
  INTERNET_SCHEME_NEWS = 5,
  INTERNET_SCHEME_MAILTO = 6,
  INTERNET_SCHEME_SNEWS = 7,
  INTERNET_SCHEME_SOCKS = 8,
  INTERNET_SCHEME_WAIS = 9,
  INTERNET_SCHEME_LAST = 10
};
using INTERNET_PORT = unsigned short;

typedef struct _WINHTTP_URL_COMPONENTS {
  DWORD           dwStructSize;
  LPWSTR          lpszScheme;
  DWORD           dwSchemeLength;
  INTERNET_SCHEME nScheme;
  LPWSTR          lpszHostName;
  DWORD           dwHostNameLength;
  INTERNET_PORT   nPort;
  LPWSTR          lpszUserName;
  DWORD           dwUserNameLength;
  LPWSTR          lpszPassword;
  DWORD           dwPasswordLength;
  LPWSTR          lpszUrlPath;
  DWORD           dwUrlPathLength;
  LPWSTR          lpszExtraInfo;
  DWORD           dwExtraInfoLength;
} URL_COMPONENTS, *LPURL_COMPONENTS;

BOOL WinHttpCrackUrl(
  LPCWSTR          pwszUrl,
  DWORD            dwUrlLength,
  DWORD            dwFlags,
  LPURL_COMPONENTS lpUrlComponents
);

void sink(LPWSTR);

void test_winhttp_crack_url() {
  {
    URL_COMPONENTS urlComponents;
    urlComponents.dwStructSize = sizeof(URL_COMPONENTS);
    wchar_t x[256];
    x[0] = (wchar_t)source();
    BOOL result = WinHttpCrackUrl(x, 0, 0, &urlComponents);
    sink(urlComponents.lpszHostName);
    sink(*urlComponents.lpszHostName); // $ ir
    sink(urlComponents.lpszUrlPath);
    sink(*urlComponents.lpszUrlPath); // $ ir
    sink(urlComponents.lpszExtraInfo);
    sink(*urlComponents.lpszExtraInfo); // $ ir
  }
}