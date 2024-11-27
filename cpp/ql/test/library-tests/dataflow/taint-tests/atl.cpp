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
    sink(static_cast<LPSTR>(a)); // $ ir
    sink(a.m_psz); // $ ir
    sink(a.m_szBuffer); // $ ir
  }

  {
    LPSTR x = indirect_source<char>();
    CA2AEX<128> a(x, 0);
    sink(static_cast<LPSTR>(a)); // $ ir
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
    sink(static_cast<LPCSTR>(a)); // $ ir
    sink(a.m_psz); // $ ir
    sink(a.m_psz); // $ ir
  }
  {
    CA2CAEX<128> a(x, 0);
    sink(static_cast<LPCSTR>(a)); // $ ir
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
    sink(static_cast<LPWSTR>(a)); // $ ir
    sink(a.m_psz); // $ ir
    sink(a.m_psz); // $ ir
  }
  {
    CA2WEX<128> a(x, 0);
    sink(static_cast<LPWSTR>(a)); // $ ir
    sink(a.m_psz); // $ ir
    sink(a.m_psz); // $ ir
  }
}

template<typename T>
struct CElementTraitsBase {
  typedef const T& INARGTYPE;
  typedef T& OUTARGTYPE;

  static void CopyElements(T* pDest, const T* pSrc, size_t nElements);
  static void RelocateElements(T* pDest, T* pSrc, size_t nElements);
};

template <typename T>
struct CDefaultElementTraits : public CElementTraitsBase<T> {};

template<typename T>
struct CElementTraits : public CDefaultElementTraits<T> {};

template<typename E, class ETraits = CElementTraits<E>>
struct CAtlArray {
  using INARGTYPE = typename ETraits::INARGTYPE;
  using OUTARGTYPE = typename ETraits::OUTARGTYPE;

  CAtlArray() throw();
  ~CAtlArray() throw();

  size_t Add(INARGTYPE element);
  size_t Add();
  size_t Append(const CAtlArray<E, ETraits>& aSrc);
  void Copy(const CAtlArray<E, ETraits>& aSrc);
  const E& GetAt(size_t iElement) const throw();
  E& GetAt(size_t iElement) throw();
  size_t GetCount() const throw();
  E* GetData() throw();
  const E* GetData() const throw();
  void InsertArrayAt(size_t iStart, const CAtlArray<E, ETraits>* paNew);
  void InsertAt(size_t iElement, INARGTYPE element, size_t nCount);
  bool IsEmpty() const throw();
  void RemoveAll() throw();
  void RemoveAt(size_t iElement, size_t nCount);
  void SetAt(size_t iElement, INARGTYPE element);
  void SetAtGrow(size_t iElement, INARGTYPE element);
  bool SetCount(size_t nNewSize, int nGrowBy);
  E& operator[](size_t ielement) throw();
  const E& operator[](size_t ielement) const throw();
};

void test_CAtlArray() {
  int x = source<int>();

  {
    CAtlArray<int> a;
    a.Add(x);
    sink(a[0]); // $ ir
    a.Add(0);
    sink(a[0]); // $ ir

    CAtlArray<int> a2;
    sink(a2[0]);
    a2.Append(a);
    sink(a2[0]); // $ ir

    CAtlArray<int> a3;
    sink(a3[0]);
    a3.Copy(a2);
    sink(a3[0]); // $ ir

    sink(a3.GetAt(0)); // $ ir
    sink(*a3.GetData()); // $ ir

    CAtlArray<int> a4;
    sink(a4.GetAt(0));
    a4.InsertArrayAt(0, &a3);
    sink(a4.GetAt(0)); // $ ir
  }
  {
    CAtlArray<int> a5;
    a5.InsertAt(0, source<int>(), 1);
    sink(a5[0]); // $ ir

    CAtlArray<int> a6;
    a6.SetAtGrow(0, source<int>());
    sink(a6[0]); // $ ir
  }
}

template<typename E, class ETraits = CElementTraits<E>>
struct CAtlList {
  using INARGTYPE = typename ETraits::INARGTYPE;
  CAtlList(UINT nBlockSize) throw();
  ~CAtlList() throw();
  POSITION AddHead();
  POSITION AddHead(INARGTYPE element);
  void AddHeadList(const CAtlList<E, ETraits>* plNew);
  POSITION AddTail();
  POSITION AddTail(INARGTYPE element);
  void AddTailList(const CAtlList<E, ETraits>* plNew);
  POSITION Find(INARGTYPE element, POSITION posStartAfter) const throw();
  POSITION FindIndex(size_t iElement) const throw();
  E& GetAt(POSITION pos) throw();
  const E& GetAt(POSITION pos) const throw();
  size_t GetCount() const throw();
  E& GetHead() throw();
  const E& GetHead() const throw();
  POSITION GetHeadPosition() const throw();
  E& GetNext(POSITION& pos) throw();
  const E& GetNext(POSITION& pos) const throw();
  E& GetPrev(POSITION& pos) throw();
  const E& GetPrev(POSITION& pos) const throw();
  E& GetTail() throw();
  const E& GetTail() const throw();
  POSITION GetTailPosition() const throw();
  POSITION InsertAfter(POSITION pos, INARGTYPE element);
  POSITION InsertBefore(POSITION pos, INARGTYPE element);
  bool IsEmpty() const throw();
  void MoveToHead(POSITION pos) throw();
  void MoveToTail(POSITION pos) throw();
  void RemoveAll() throw();
  void RemoveAt(POSITION pos) throw();
  E RemoveHead();
  void RemoveHeadNoReturn() throw();
  E RemoveTail();
  void RemoveTailNoReturn() throw();
  void SetAt(POSITION pos, INARGTYPE element);
  void SwapElements(POSITION pos1, POSITION pos2) throw();
};

void test_CAtlList() {
  int x = source<int>();
  {
    CAtlList<int> list(10);
    sink(list.GetHead());
    list.AddHead(x);
    sink(list.GetHead()); // $ ir

    CAtlList<int> list2(10);
    list2.AddHeadList(&list);
    sink(list2.GetHead()); // $ ir

    CAtlList<int> list3(10);
    list3.AddTail(x);
    sink(list3.GetHead()); // $ ir

    CAtlList<int> list4(10);
    list4.AddTailList(&list3);
    sink(list4.GetHead()); // $ ir

    {
      CAtlList<int> list5(10);
      auto pos = list5.Find(x, list5.GetHeadPosition());
      sink(list5.GetAt(pos)); // $ MISSING: ir
    }

    {
      CAtlList<int> list6(10);
      list6.AddHead(x);
      auto pos = list6.FindIndex(0);
      sink(list6.GetAt(pos)); // $ ir
    }

    {
      CAtlList<int> list7(10);
      auto pos = list7.GetTailPosition();
      list7.InsertAfter(pos, x);
      sink(list7.GetHead()); // $ ir
    }

    {
      CAtlList<int> list8(10);
      auto pos = list8.GetTailPosition();
      list8.InsertBefore(pos, x);
      sink(list8.GetHead()); // $ ir
    }
    {
      CAtlList<int> list9(10);
      list9.SetAt(list9.GetHeadPosition(), x);
      sink(list9.GetHead()); // $ ir
    }
  }

  int* p = indirect_source<int>();
  {
    CAtlList<int> list(10);
    sink(list.GetHead());
    list.AddHead(x);
    sink(list.GetHead()); // $ ir

    CAtlList<int> list2(10);
    list2.AddHeadList(&list);
    sink(list2.GetHead()); // $ ir

    CAtlList<int> list3(10);
    list3.AddTail(x);
    sink(list3.GetHead()); // $ ir

    CAtlList<int> list4(10);
    list4.AddTailList(&list3);
    sink(list4.GetHead()); // $ ir

    {
      CAtlList<int> list5(10);
      auto pos = list5.Find(x, list5.GetHeadPosition());
      sink(list5.GetAt(pos)); // $ MISSING: ir
    }

    {
      CAtlList<int> list6(10);
      list6.AddHead(x);
      auto pos = list6.FindIndex(0);
      sink(list6.GetAt(pos)); // $ ir
    }

    {
      CAtlList<int> list7(10);
      auto pos = list7.GetTailPosition();
      list7.InsertAfter(pos, x);
      sink(list7.GetHead()); // $ ir
    }

    {
      CAtlList<int> list8(10);
      auto pos = list8.GetTailPosition();
      list8.InsertBefore(pos, x);
      sink(list8.GetHead()); // $ ir
    }
    {
      CAtlList<int> list9(10);
      list9.SetAt(list9.GetHeadPosition(), x);
      sink(list9.GetHead()); // $ ir
    }
  }
}
