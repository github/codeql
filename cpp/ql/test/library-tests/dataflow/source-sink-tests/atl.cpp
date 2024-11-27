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

struct CAtlFileMappingBase {
  CAtlFileMappingBase(CAtlFileMappingBase& orig);
  CAtlFileMappingBase() throw();
  ~CAtlFileMappingBase() throw();

  HRESULT CopyFrom(CAtlFileMappingBase& orig) throw();
  void* GetData() const throw();
  HANDLE GetHandle() throw ();
  SIZE_T GetMappingSize() throw();

  HRESULT MapFile(
      HANDLE hFile,
      SIZE_T nMappingSize,
      ULONGLONG nOffset,
      DWORD dwMappingProtection,
      DWORD dwViewDesiredAccess) throw();

    HRESULT MapSharedMem(
      SIZE_T nMappingSize,
      LPCTSTR szName,
      BOOL* pbAlreadyExisted,
      LPSECURITY_ATTRIBUTES lpsa,
      DWORD dwMappingProtection,
      DWORD dwViewDesiredAccess) throw();

    HRESULT OpenMapping(
      LPCTSTR szName,
      SIZE_T nMappingSize,
      ULONGLONG nOffset,
      DWORD dwViewDesiredAccess) throw();

    HRESULT Unmap() throw();
};

template <typename T>
struct CAtlFileMapping : public CAtlFileMappingBase {
  operator T*() const throw();
};

void test_CAtlFileMapping(CAtlFileMapping<char> mapping) {
  char* data = static_cast<char*>(mapping); // $ local_source
  void* data2 = mapping.GetData(); // $ local_source
}

struct CAtlTemporaryFile {
  CAtlTemporaryFile() throw();
  ~CAtlTemporaryFile() throw();
  HRESULT Close(LPCTSTR szNewName) throw();
  HRESULT Create(LPCTSTR pszDir, DWORD dwDesiredAccess) throw();
  HRESULT Flush() throw();
  HRESULT GetPosition(ULONGLONG& nPos) const throw();
  HRESULT GetSize(ULONGLONG& nLen) const throw();
  HRESULT HandsOff() throw();
  HRESULT HandsOn() throw();
  HRESULT LockRange(ULONGLONG nPos, ULONGLONG nCount) throw();

  HRESULT Read(
      LPVOID pBuffer,
      DWORD nBufSize,
      DWORD& nBytesRead) throw();
      HRESULT Seek(LONGLONG nOffset, DWORD dwFrom) throw();
  
  HRESULT SetSize(ULONGLONG nNewLen) throw();
  LPCTSTR TempFileName() throw();
  HRESULT UnlockRange(ULONGLONG nPos, ULONGLONG nCount) throw();
  
  HRESULT Write(
      LPCVOID pBuffer,
      DWORD nBufSize,
      DWORD* pnBytesWritten) throw();
      operator HANDLE() throw();
};

void test_CAtlTemporaryFile() {
  CAtlTemporaryFile file;
  char buffer[1024];
  DWORD bytesRead;
  file.Read(buffer, 1024, bytesRead); // $ local_source
}

struct CRegKey {
  CRegKey() throw();
  CRegKey(CRegKey& key) throw();
  explicit CRegKey(HKEY hKey) throw();
  CRegKey(CAtlTransactionManager* pTM) throw();

  ~CRegKey() throw();
  void Attach(HKEY hKey) throw();
  LONG Close() throw();

  LONG Create(
    HKEY hKeyParent,
    LPCTSTR lpszKeyName,
    LPTSTR lpszClass,
    DWORD dwOptions,
    REGSAM samDesired,
    LPSECURITY_ATTRIBUTES lpSecAttr,
    LPDWORD lpdwDisposition) throw();

  LONG DeleteSubKey(LPCTSTR lpszSubKey) throw();
  LONG DeleteValue(LPCTSTR lpszValue) throw();
  HKEY Detach() throw();
  
  LONG EnumKey(
    DWORD iIndex,
    LPTSTR pszName,
    LPDWORD pnNameLength,
    FILETIME* pftLastWriteTime) throw();
  
  LONG Flush() throw();

  LONG GetKeySecurity(
    SECURITY_INFORMATION si,
    PSECURITY_DESCRIPTOR psd,
    LPDWORD pnBytes) throw();
  
  LONG NotifyChangeKeyValue(
    BOOL bWatchSubtree,
    DWORD dwNotifyFilter,
    HANDLE hEvent,
    BOOL bAsync) throw();

  LONG Open(
    HKEY hKeyParent,
    LPCTSTR lpszKeyName,
    REGSAM samDesired) throw();

  LONG QueryBinaryValue(
    LPCTSTR pszValueName,
    void* pValue,
    ULONG* pnBytes) throw();

  LONG QueryDWORDValue(
    LPCTSTR pszValueName,
    DWORD& dwValue) throw();

  LONG QueryGUIDValue(
    LPCTSTR pszValueName,
    GUID& guidValue) throw();

  LONG QueryMultiStringValue(
    LPCTSTR pszValueName,
    LPTSTR pszValue,
    ULONG* pnChars) throw();

  LONG QueryQWORDValue(
    LPCTSTR pszValueName,
    ULONGLONG& qwValue) throw();

  LONG QueryStringValue(
    LPCTSTR pszValueName,
    LPTSTR pszValue,
    ULONG* pnChars) throw();

  LONG QueryValue(
      LPCTSTR pszValueName,
      DWORD* pdwType,
      void* pData,
      ULONG* pnBytes) throw();

  LONG QueryValue(
    DWORD& dwValue,
    LPCTSTR lpszValueName);

  LONG QueryValue(
    LPTSTR szValue,
    LPCTSTR lpszValueName,
    DWORD* pdwCount);

  LONG RecurseDeleteKey(LPCTSTR lpszKey) throw();

  LONG SetBinaryValue(
    LPCTSTR pszValueName,
    const void* pValue,
    ULONG nBytes) throw();

  LONG SetDWORDValue(LPCTSTR pszValueName, DWORD dwValue) throw();

  LONG SetGUIDValue(LPCTSTR pszValueName, REFGUID guidValue) throw();

  LONG SetKeySecurity(SECURITY_INFORMATION si, PSECURITY_DESCRIPTOR psd) throw();

  LONG SetKeyValue(
    LPCTSTR lpszKeyName,
    LPCTSTR lpszValue,
    LPCTSTR lpszValueName) throw();

  LONG SetMultiStringValue(LPCTSTR pszValueName, LPCTSTR pszValue) throw();

  LONG SetQWORDValue(LPCTSTR pszValueName, ULONGLONG qwValue) throw();

  LONG SetStringValue(
    LPCTSTR pszValueName,
    LPCTSTR pszValue,
    DWORD dwType) throw();

  LONG SetValue(
    LPCTSTR pszValueName,
    DWORD dwType,
    const void* pValue,
    ULONG nBytes) throw();

  static LONG SetValue(
    HKEY hKeyParent,
    LPCTSTR lpszKeyName,
    LPCTSTR lpszValue,
    LPCTSTR lpszValueName);

  LONG SetValue(
    DWORD dwValue,
    LPCTSTR lpszValueName);

  LONG SetValue(
    LPCTSTR lpszValue,
    LPCTSTR lpszValueName,
    bool bMulti,
    int nValueLen);

  operator HKEY() const throw();
  CRegKey& operator= (CRegKey& key) throw();

  HKEY m_hKey;
};

void test_CRegKey() {
  CRegKey key;
  char data[1024];
  ULONG bytesRead;
  key.QueryBinaryValue("foo", data, &bytesRead); // $ local_source

  DWORD value;
  key.QueryDWORDValue("foo", value); // $ local_source
  
  GUID guid;
  key.QueryGUIDValue("foo", guid); // $ local_source
  
  key.QueryMultiStringValue("foo", data, &bytesRead); // $ local_source
  
  ULONGLONG qword;
  key.QueryQWORDValue("foo", qword); // $ local_source
  
  key.QueryStringValue("foo", data, &bytesRead); // $ local_source
  
  key.QueryValue(data, "foo", &bytesRead); // $ local_source
  
  DWORD type;
  key.QueryValue("foo", &type, data, &bytesRead); // $ local_source
  
  DWORD value2;
  key.QueryValue(value2, "foo"); // $ local_source
}