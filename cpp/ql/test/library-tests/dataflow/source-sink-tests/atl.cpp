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

class CAtlTransactionManager;

class CHandle {
  CHandle() throw();
  CHandle(CHandle& h) throw();
  explicit CHandle(HANDLE h) throw();
};

struct CAtlFile : public CHandle {
  CAtlFile() throw();
  CAtlFile(CAtlTransactionManager* pTM) throw();
  CAtlFile(CAtlFile& file) throw();
  explicit CAtlFile(HANDLE hFile) throw();

  HRESULT Create(
    LPCTSTR szFilename,
    DWORD dwDesiredAccess,
    DWORD dwShareMode,
    DWORD dwCreationDisposition,
    DWORD dwFlagsAndAttributes,
    LPSECURITY_ATTRIBUTES lpsa,
    HANDLE hTemplateFile) throw();

    HRESULT Flush() throw();
    HRESULT GetOverlappedResult(
      LPOVERLAPPED pOverlapped,
      DWORD& dwBytesTransferred,
      BOOL bWait
    ) throw();

    HRESULT GetPosition(ULONGLONG& nPos) const throw();
    HRESULT GetSize(ULONGLONG& nLen) const throw();
    HRESULT LockRange(ULONGLONG nPos, ULONGLONG nCount) throw();
    
    HRESULT Read(
    LPVOID pBuffer,
    DWORD nBufSize) throw();

  HRESULT Read(
      LPVOID pBuffer,
      DWORD nBufSize,
      DWORD& nBytesRead) throw();
  HRESULT Read(
      LPVOID pBuffer,
      DWORD nBufSize,
      LPOVERLAPPED pOverlapped) throw();
  HRESULT Read(
      LPVOID pBuffer,
      DWORD nBufSize,
      LPOVERLAPPED pOverlapped,
      LPOVERLAPPED_COMPLETION_ROUTINE pfnCompletionRoutine) throw();

  HRESULT Seek(
    LONGLONG nOffset,
    DWORD dwFrom) throw();

  HRESULT SetSize(ULONGLONG nNewLen) throw();
  HRESULT UnlockRange(ULONGLONG nPos, ULONGLONG nCount) throw();
  HRESULT Write(
      LPCVOID pBuffer,
      DWORD nBufSize,
      LPOVERLAPPED pOverlapped,
      LPOVERLAPPED_COMPLETION_ROUTINE pfnCompletionRoutine) throw();

  HRESULT Write(
      LPCVOID pBuffer,
      DWORD nBufSize,
      DWORD* pnBytesWritten) throw();

  HRESULT Write(
      LPCVOID pBuffer,
      DWORD nBufSize,
      LPOVERLAPPED pOverlapped) throw();
};

void test_CAtlFile() {
  CAtlFile catFile;
  char buffer[1024];
  catFile.Read(buffer, 1024); // $ local_source
}
