void sink(char);
void sink(char*);
void sink(char**);

char* GetCommandLineA();
char** CommandLineToArgvA(char*, int*);
char* GetEnvironmentStringsA();
int GetEnvironmentVariableA(const char*, char*, int);

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

using HANDLE = void*;
using DWORD = unsigned long;
using LPVOID = void*;
using LPDWORD = unsigned long*;
using PVOID = void*;
using ULONG_PTR = unsigned long*;
using SIZE_T = decltype(sizeof(0));
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
  sink(*buffer); // $ MISSING: ir
}

void FileIOCompletionRoutine3(
  DWORD dwErrorCode,
  DWORD dwNumberOfBytesTransfered,
  LPOVERLAPPED lpOverlapped
) {
  char c = reinterpret_cast<char>(lpOverlapped->hEvent);
  sink(c); // $ MISSING: ir
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
