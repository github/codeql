namespace {
  template<typename T> T source();
  template<typename T> T* indirect_source();
  void sink(...);
}

typedef unsigned int UINT;
typedef long LONG;
typedef void* LPVOID;
typedef void* PVOID;
typedef bool BOOL;
typedef char* PSTR, *LPSTR;
typedef const char* LPCTSTR;
typedef unsigned short WORD;
typedef unsigned long DWORD;
typedef void* HANDLE;
typedef LONG HRESULT;
typedef unsigned long ULONG;
typedef const char* LPCSTR;
typedef wchar_t OLECHAR;
typedef OLECHAR* LPOLESTR;
typedef const LPOLESTR LPCOLESTR;
typedef OLECHAR* BSTR;
typedef wchar_t* LPWSTR, *PWSTR;
typedef BSTR* LPBSTR;
typedef unsigned short USHORT;
typedef char *LPTSTR;
struct __POSITION { int unused; };typedef __POSITION* POSITION;
typedef WORD ATL_URL_PORT;

enum ATL_URL_SCHEME{
   ATL_URL_SCHEME_UNKNOWN = -1,
   ATL_URL_SCHEME_FTP     = 0,
   ATL_URL_SCHEME_GOPHER  = 1,
   ATL_URL_SCHEME_HTTP    = 2,
   ATL_URL_SCHEME_HTTPS   = 3,
   ATL_URL_SCHEME_FILE    = 4,
   ATL_URL_SCHEME_NEWS    = 5,
   ATL_URL_SCHEME_MAILTO  = 6,
   ATL_URL_SCHEME_SOCKS   = 7
};

using HINSTANCE = void*;
using size_t = decltype(sizeof(int));
using SIZE_T = size_t;

#define NULL nullptr

typedef struct tagSAFEARRAYBOUND {
  ULONG cElements;
  LONG  lLbound;
} SAFEARRAYBOUND, *LPSAFEARRAYBOUND;

typedef struct tagVARIANT {
  /* ... */
} VARIANT;

typedef struct tagSAFEARRAY {
  USHORT         cDims;
  USHORT         fFeatures;
  ULONG          cbElements;
  ULONG          cLocks;
  PVOID          pvData;
  SAFEARRAYBOUND rgsabound[1];
} SAFEARRAY, *LPSAFEARRAY;

struct _U_STRINGorID {
  _U_STRINGorID(UINT nID);
  _U_STRINGorID(LPCTSTR lpString);

  LPCTSTR m_lpstr;
};

void test__U_STRINGorID() {
  {
    UINT x = source<UINT>();
    _U_STRINGorID u(x);
    sink(u.m_lpstr); // $ ir
  }

  {
    LPCTSTR y = indirect_source<const char>();
    _U_STRINGorID u(y);
    sink(u.m_lpstr); // $ ir
  }
}

template <int t_nBufferLength>
struct CA2AEX {
  LPSTR m_psz;
  char m_szBuffer[t_nBufferLength];

  CA2AEX(LPCSTR psz, UINT nCodePage);
  CA2AEX(LPCSTR psz);

  ~CA2AEX();

  operator LPSTR() const throw();
};

void test_CA2AEX() {
  {
    LPSTR x = indirect_source<char>();
    CA2AEX<128> a(x);
    sink(static_cast<LPSTR>(a)); // $ MISSING: ir
    sink(a.m_psz); // $ ir
    sink(a.m_szBuffer); // $ ir
  }

  {
    LPSTR x = indirect_source<char>();
    CA2AEX<128> a(x, 0);
    sink(static_cast<LPSTR>(a)); // $ MISSING: ir
    sink(a.m_psz); // $ ir
    sink(a.m_szBuffer); // $ ir
  }
}

template<int t_nBufferLength>
struct CA2CAEX {
  CA2CAEX(LPCSTR psz, UINT nCodePage) ;
  CA2CAEX(LPCSTR psz) ;
  ~CA2CAEX() throw();
  operator LPCSTR() const throw();
  LPCSTR m_psz;
};

void test_CA2CAEX() {
  LPCSTR x = indirect_source<char>();
  {
    CA2CAEX<128> a(x);
    sink(static_cast<LPCSTR>(a)); // $ MISSING: ir
    sink(a.m_psz); // $ ir
    sink(a.m_psz); // $ ir
  }
  {
    CA2CAEX<128> a(x, 0);
    sink(static_cast<LPCSTR>(a)); // $ MISSING: ir
    sink(a.m_psz); // $ ir
    sink(a.m_psz); // $ ir
  }
}

template <int t_nBufferLength>
struct CA2WEX {
  CA2WEX(LPCSTR psz, UINT nCodePage) ;
  CA2WEX(LPCSTR psz) ;
  ~CA2WEX() throw();
  operator LPWSTR() const throw();
  LPWSTR m_psz;
  wchar_t m_szBuffer[t_nBufferLength];
};

void test_CA2WEX() {
  LPCSTR x = indirect_source<char>();
  {
    CA2WEX<128> a(x);
    sink(static_cast<LPWSTR>(a)); // $ MISSING: ir
    sink(a.m_psz); // $ ir
    sink(a.m_psz); // $ ir
  }
  {
    CA2WEX<128> a(x, 0);
    sink(static_cast<LPWSTR>(a)); // $ MISSING: ir
    sink(a.m_psz); // $ ir
    sink(a.m_psz); // $ ir
  }
}
