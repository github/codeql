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
typedef const wchar_t* LPCWSTR;
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
struct __POSITION { int unused; };
typedef __POSITION* POSITION;
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
    CAtlList<int*> list(10);
    sink(list.GetHead());
    list.AddHead(p);
    sink(list.GetHead()); // $ ir

    CAtlList<int*> list2(10);
    list2.AddHeadList(&list);
    sink(list2.GetHead()); // $ ir

    CAtlList<int*> list3(10);
    list3.AddTail(p);
    sink(list3.GetHead()); // $ ir

    CAtlList<int*> list4(10);
    list4.AddTailList(&list3);
    sink(list4.GetHead()); // $ ir

    {
      CAtlList<int*> list5(10);
      auto pos = list5.Find(p, list5.GetHeadPosition());
      sink(list5.GetAt(pos)); // $ MISSING: ir
    }

    {
      CAtlList<int*> list6(10);
      list6.AddHead(p);
      auto pos = list6.FindIndex(0);
      sink(list6.GetAt(pos)); // $ ir
    }

    {
      CAtlList<int*> list7(10);
      auto pos = list7.GetTailPosition();
      list7.InsertAfter(pos, p);
      sink(list7.GetHead()); // $ ir
    }

    {
      CAtlList<int*> list8(10);
      auto pos = list8.GetTailPosition();
      list8.InsertBefore(pos, p);
      sink(list8.GetHead()); // $ ir
    }
    {
      CAtlList<int*> list9(10);
      list9.SetAt(list9.GetHeadPosition(), p);
      sink(list9.GetHead()); // $ ir
    }
  }
}

struct IUnknown { };

struct ISequentialStream : public IUnknown { };

struct IStream : public ISequentialStream { };

struct CComBSTR {
  CComBSTR() throw();
  CComBSTR(const CComBSTR& src);
  CComBSTR(int nSize);
  CComBSTR(int nSize, LPCOLESTR sz);
  CComBSTR(int nSize, LPCSTR sz);
  CComBSTR(LPCOLESTR pSrc);
  CComBSTR(LPCSTR pSrc);
  CComBSTR(CComBSTR&& src) throw();
  ~CComBSTR();
  
  HRESULT Append(const CComBSTR& bstrSrc) throw();
  HRESULT Append(wchar_t ch) throw();
  HRESULT Append(char ch) throw();
  HRESULT Append(LPCOLESTR lpsz) throw();
  HRESULT Append(LPCSTR lpsz) throw();
  HRESULT Append(LPCOLESTR lpsz, int nLen) throw();
  HRESULT AppendBSTR(BSTR p) throw();
  HRESULT AppendBytes(const char* lpsz, int nLen) throw();
  HRESULT ArrayToBSTR(const SAFEARRAY* pSrc) throw();
  HRESULT AssignBSTR(const BSTR bstrSrc) throw();
  void Attach(BSTR src) throw();
  HRESULT BSTRToArray(LPSAFEARRAY* ppArray) throw();
  unsigned int ByteLength() const throw();
  BSTR Copy() const throw();
  HRESULT CopyTo(BSTR* pbstr) throw();

  HRESULT CopyTo(VARIANT* pvarDest) throw();
  BSTR Detach() throw();
  void Empty() throw();
  unsigned int Length() const throw();
  bool LoadString(HINSTANCE hInst, UINT nID) throw();
  bool LoadString(UINT nID) throw();
  HRESULT ReadFromStream(IStream* pStream) throw();
  HRESULT ToUpper() throw();
  HRESULT WriteToStream(IStream* pStream) throw();

  operator BSTR() const throw();
  BSTR* operator&() throw();

  CComBSTR& operator+= (const CComBSTR& bstrSrc);
  CComBSTR& operator+= (const LPCOLESTR pszSrc);

  BSTR m_str;
};

LPSAFEARRAY getSafeArray() {
  SAFEARRAY* safe = new SAFEARRAY;
  safe->pvData = indirect_source<char>();
  return safe;
}

void test_CComBSTR() {
  char* x = indirect_source<char>();
  {
    CComBSTR b(x);
    sink(b.m_str); // $ ir

    CComBSTR b2(b);
    sink(b2.m_str); // $ ir
  }
  {
    CComBSTR b(10, x);
    sink(b.m_str); // $ ir
  }
  {
    CComBSTR b(x);

    CComBSTR b2;
    sink(b2.m_str);
    b2 += b;
    sink(b2.m_str); // $ ir

    CComBSTR b3;
    b3 += x;
    sink(b3.m_str); // $ ir
    sink(static_cast<BSTR>(b3)); // $ ir
    sink(**&b3); // $ ir

    CComBSTR b4;
    b4.Append(source<char>());
    sink(b4.m_str); // $ ir

    CComBSTR b5;
    b5.AppendBSTR(b4.m_str);
    sink(b5.m_str); // $ ir

    CComBSTR b6;
    b6.AppendBytes(x, 10);
    sink(b6.m_str); // $ ir

    CComBSTR b7;
    b7.ArrayToBSTR(getSafeArray());
    sink(b7.m_str); // $ ir

    CComBSTR b8;
    b8.AssignBSTR(b7.m_str);
    sink(b8.m_str); // $ ir

    CComBSTR b9;
    LPSAFEARRAY safe;
    b9.Append(source<char>());
    b9.BSTRToArray(&safe);
    sink(safe->pvData); // $ ir

    sink(b9.Copy()); // $ ir
  }

  wchar_t* w = indirect_source<wchar_t>();
  {
    CComBSTR b(w);
    sink(b.m_str); // $ ir

    CComBSTR b2;
    b2.Attach(w);
    sink(b2.m_str); // $ ir
  }
  {
    CComBSTR b(10, w);
    sink(b.m_str); // $ ir
  }
}

template <typename T>
struct CComSafeArray {
  CComSafeArray();
  CComSafeArray(const SAFEARRAYBOUND& bound);
  CComSafeArray(ULONG  ulCount, LONG lLBound);
  CComSafeArray(const SAFEARRAYBOUND* pBound, UINT uDims);
  CComSafeArray(const CComSafeArray& saSrc);
  CComSafeArray(const SAFEARRAY& saSrc);
  CComSafeArray(const SAFEARRAY* psaSrc);

  ~CComSafeArray() throw();

  HRESULT Add(const SAFEARRAY* psaSrc);
  HRESULT Add(ULONG ulCount, const T* pT, BOOL bCopy);
  HRESULT Add(const T& t, BOOL bCopy);
  HRESULT Attach(const SAFEARRAY* psaSrc);
  HRESULT CopyFrom(LPSAFEARRAY* ppArray);
  HRESULT CopyTo(LPSAFEARRAY* ppArray);
  HRESULT Create(const SAFEARRAYBOUND* pBound, UINT uDims);
  HRESULT Create(ULONG ulCount, LONG lLBound);
  HRESULT Destroy();
  LPSAFEARRAY Detach();
  T& GetAt(LONG lIndex) const;
  ULONG GetCount(UINT uDim) const;
  UINT GetDimensions() const;
  LONG GetLowerBound(UINT uDim) const;
  LPSAFEARRAY GetSafeArrayPtr() throw();
  LONG GetUpperBound(UINT uDim) const;
  bool IsSizable() const;
  HRESULT MultiDimGetAt(const LONG* alIndex, T& t);
  HRESULT MultiDimSetAt(const LONG* alIndex, const T& t);
  HRESULT Resize(const SAFEARRAYBOUND* pBound);
  HRESULT Resize(ULONG ulCount, LONG lLBound);
  HRESULT SetAt(LONG lIndex, const T& t, BOOL bCopy);
  operator LPSAFEARRAY() const;
  T& operator[](long lindex) const;
  T& operator[](int nindex) const;

  LPSAFEARRAY m_psa;
};

void test_CComSafeArray() {
  LPSAFEARRAY safe = getSafeArray();
  sink(safe->pvData); // $ ir
  {
  CComSafeArray<int> c(safe);
  sink(c[0]); // $ ir
  sink(c.GetAt(0)); // $ ir
  sink(c.GetSafeArrayPtr()->pvData); // $ ir
  sink(c.m_psa->pvData); // $ ir
  }
  {
    CComSafeArray<int> c;
    sink(c[0]);
    sink(c.GetAt(0));
    sink(c.GetSafeArrayPtr()->pvData);
    c.Add(safe);
    sink(c[0]); // $ ir
    sink(c.GetAt(0)); // $ ir
    sink(c.GetSafeArrayPtr()->pvData); // $ ir
    sink(static_cast<LPSAFEARRAY>(c)->pvData); // $ ir
  }
  {
    CComSafeArray<int> c;
    c.Add(source<int>(), true);
    sink(c[0]); // $ ir
    sink(c.GetAt(0)); // $ ir
    sink(c.GetSafeArrayPtr()->pvData); // $ ir
  }
  {
    CComSafeArray<int> c;
    c.SetAt(0, source<int>(), true);
    sink(c[0]); // $ ir
    sink(c[0L]); // $ ir
  }
}

template <typename StringType>
struct CPathT {
  typedef StringType PCXSTR; // simplified
  CPathT(PCXSTR pszPath);
  CPathT(const CPathT<StringType>& path);
  CPathT() throw();

  void AddBackslash();
  BOOL AddExtension(PCXSTR pszExtension);
  BOOL Append(PCXSTR pszMore);
  void BuildRoot(int iDrive);
  void Canonicalize();
  void Combine(PCXSTR pszDir, PCXSTR pszFile);
  CPathT<StringType> CommonPrefix(PCXSTR pszOther);
  BOOL CompactPathEx(UINT nMaxChars, DWORD dwFlags);
  BOOL FileExists() const;
  int FindExtension() const;
  int FindFileName() const;
  int GetDriveNumber() const;
  StringType GetExtension() const;
  BOOL IsDirectory() const;
  BOOL IsFileSpec() const;
  BOOL IsPrefix(PCXSTR pszPrefix) const;
  BOOL IsRelative() const;
  BOOL IsRoot() const;
  BOOL IsSameRoot(PCXSTR pszOther) const;
  BOOL IsUNC() const;
  BOOL IsUNCServer() const;
  BOOL IsUNCServerShare() const;
  BOOL MakePretty();
  BOOL MatchSpec(PCXSTR pszSpec) const;
  void QuoteSpaces();
  BOOL RelativePathTo(
      PCXSTR pszFrom,
      DWORD dwAttrFrom,
      PCXSTR pszTo,
      DWORD dwAttrTo);
  void RemoveArgs();
  void RemoveBackslash();
  void RemoveBlanks();
  void RemoveExtension();
  BOOL RemoveFileSpec();
  BOOL RenameExtension(PCXSTR pszExtension);
  int SkipRoot() const;
  void StripPath();
  BOOL StripToRoot();
  void UnquoteSpaces();
  operator const StringType&() const throw();
  operator PCXSTR() const throw();
  operator StringType&() throw();
  CPathT<StringType>& operator+=(PCXSTR pszMore);
  
  StringType m_strPath;
};

using CPath = CPathT<char*>;

void test_CPathT() {
  char* x = indirect_source<char>();
  CPath p(x);
  sink(static_cast<char*>(p)); // $ MISSING: ir
  sink(p.m_strPath); // $ ir

  CPath p2(p);
  sink(p2.m_strPath); // $ ir

  {
    CPath p;
    p.AddExtension(x);
    sink(p.m_strPath); // $ ir
  }
  {
    CPath p;
    p.Append(x);
    sink(p.m_strPath); // $ ir

    CPath p2;
    p2 += p;
    sink(p2.m_strPath); // $ MISSING: ir // this requires flow through `operator StringType&()` which we can't yet model in MaD

    CPath p3;
    p3 += x;
    sink(p3.m_strPath); // $ ir
  }

  {
    CPath p;
    p.Combine(x, nullptr);
    sink(p.m_strPath); // $ ir
  }
  {
    CPath p;
    p.Combine(nullptr, x);
    sink(p.m_strPath); // $ ir
  }

  {
    CPath p;
    auto p2 = p.CommonPrefix(x);
    sink(p2.m_strPath); // $ ir
    sink(p2.GetExtension()); // $ ir
  }
}

template <class T>
struct CSimpleArray {
  CSimpleArray(const CSimpleArray<T>& src);
  CSimpleArray();
  ~CSimpleArray();

  BOOL Add(const T& t);
  int Find(const T& t) const;
  T* GetData() const;
  int GetSize() const;
  BOOL Remove(const T& t);
  void RemoveAll();
  BOOL RemoveAt(int nIndex);
  
  BOOL SetAtIndex(
    int nIndex,
    const T& t);
  
  T& operator[](int nindex);
  CSimpleArray<T> & operator=(const CSimpleArray<T>& src);
};

void test_CSimpleArray() {
  int x = source<int>();
  {
    CSimpleArray<int> a;
    a.Add(x);
    sink(a[0]); // $ ir
    a.Add(0);
    sink(a[0]); // $ ir

    CSimpleArray<int> a2;
    sink(a2[0]);
    a2 = a;
    sink(a2[0]); // $ ir
  }
  {
    CSimpleArray<int> a;
    a.Add(x);
    sink(a.GetData()); // $ ir

    CSimpleArray<int> a2;
    int pos = a2.Find(x);
    sink(a2[pos]); // $ MISSING: ir
  }
}

template <class TKey, class TVal>
struct CSimpleMap {
  CSimpleMap();
  ~CSimpleMap();

  BOOL Add(const TKey& key, const TVal& val);
  int FindKey(const TKey& key) const;
  int FindVal(const TVal& val) const;
  TKey& GetKeyAt(int nIndex) const;
  int GetSize() const;
  TVal& GetValueAt(int nIndex) const;
  TVal Lookup(const TKey& key) const;
  BOOL Remove(const TKey& key);
  void RemoveAll();
  BOOL RemoveAt(int nIndex);
  TKey ReverseLookup(const TVal& val) const;
  BOOL SetAt(const TKey& key, const TVal& val);
  BOOL SetAtIndex(int nIndex, const TKey& key, const TVal& val);
};

void test_CSimpleMap() {
  wchar_t* x = source<wchar_t*>();
  {
    CSimpleMap<char*, wchar_t*> a;
    a.Add("hello", x);
    sink(a.Lookup("hello")); // $ ir
  }
  {
    CSimpleMap<char*, wchar_t*> a;
    auto pos = a.FindKey("hello");
    sink(a.GetValueAt(pos)); // clean
  }
  {
    CSimpleMap<char*, wchar_t*> a;
    auto pos = a.FindVal(x);
    sink(a.GetValueAt(pos)); // $ MISSING: ir
  }
  {
    CSimpleMap<char*, wchar_t*> a;
    auto key = a.ReverseLookup(x);
    sink(key);
    sink(a.Lookup(key)); // $ MISSING: ir
  }
  {
    CSimpleMap<char*, wchar_t*> a;
    a.SetAt("hello", x);
    sink(a.Lookup("hello")); // $ ir
  }
  {
    CSimpleMap<char*, wchar_t*> a;
    a.SetAtIndex(0, "hello", x);
    sink(a.Lookup("hello")); // $ ir
  }
}

struct CUrl {
  CUrl& operator= (const CUrl& urlThat) throw();
  CUrl() throw();
  CUrl(const CUrl& urlThat) throw();
  ~CUrl() throw();

  inline BOOL Canonicalize(DWORD dwFlags) throw();
  inline void Clear() throw();

  BOOL CrackUrl(LPCTSTR lpszUrl, DWORD dwFlags) throw();
  inline BOOL CreateUrl(LPTSTR lpszUrl, DWORD* pdwMaxLength, DWORD dwFlags) const throw();

  inline LPCTSTR GetExtraInfo() const throw();
  inline DWORD GetExtraInfoLength() const throw();
  inline LPCTSTR GetHostName() const throw();
  inline DWORD GetHostNameLength() const throw();
  inline LPCTSTR GetPassword() const throw();
  inline DWORD GetPasswordLength() const throw();
  inline ATL_URL_PORT GetPortNumber() const throw();
  inline ATL_URL_SCHEME GetScheme() const throw();
  inline LPCTSTR GetSchemeName() const throw();
  inline DWORD GetSchemeNameLength() const throw();
  inline DWORD GetUrlLength() const throw();
  inline LPCTSTR GetUrlPath() const throw();
  inline DWORD GetUrlPathLength() const throw();
  inline LPCTSTR GetUserName() const throw();
  inline DWORD GetUserNameLength() const throw();
  inline BOOL SetExtraInfo(LPCTSTR lpszInfo) throw();
  inline BOOL SetHostName(LPCTSTR lpszHost) throw();
  inline BOOL SetPassword(LPCTSTR lpszPass) throw();
  inline BOOL SetPortNumber(ATL_URL_PORT nPrt) throw();
  inline BOOL SetScheme(ATL_URL_SCHEME nScheme) throw();
  inline BOOL SetSchemeName(LPCTSTR lpszSchm) throw();
  inline BOOL SetUrlPath(LPCTSTR lpszPath) throw();
  inline BOOL SetUserName(LPCTSTR lpszUser) throw();
};

void test_CUrl() {
  char* x = indirect_source<char>();
  CUrl url;
  url.CrackUrl(x, 0);
  sink(url); // $ ir
  sink(url.GetExtraInfo()); // $ ir
  sink(url.GetHostName()); // $ ir
  sink(url.GetPassword()); // $ ir
  sink(url.GetSchemeName()); // $ ir
  sink(url.GetUrlPath()); // $ ir
  sink(url.GetUserName()); // $ ir

  {
    CUrl url2;
    DWORD len;
    char buffer[1024];
    url2.CrackUrl(x, 0);
    url2.CreateUrl(buffer, &len, 0);
    sink(buffer); // $ ast ir
  }
  {
    CUrl url2;
    url2.SetExtraInfo(x);
    sink(url2); // $ ir
  }
  {
    CUrl url2;
    url2.SetHostName(x);
    sink(url2); // $ ir
  }
  {
    CUrl url2;
    url2.SetPassword(x);
    sink(url2); // $ ir
  }
  {
    CUrl url2;
    url2.SetSchemeName(x);
    sink(url2); // $ ir
  }
  {
    CUrl url2;
    url2.SetUrlPath(x);
    sink(url2); // $ ir
  }
  {
    CUrl url2;
    url2.SetUserName(x);
    sink(url2); // $ ir
  }
}

struct IAtlStringMgr {}; // simplified

using XCHAR = char;
using YCHAR = wchar_t;

template <typename BaseType>
struct CSimpleStringT {
  using PCXSTR = const BaseType*; // simplified
  using PXSTR = BaseType*; // simplified

  CSimpleStringT() throw();
  CSimpleStringT(const XCHAR* pchSrc, int nLength, IAtlStringMgr* pStringMgr);
  CSimpleStringT(PCXSTR pszSrc, IAtlStringMgr* pStringMgr);
  CSimpleStringT(const CSimpleStringT& strSrc);

  ~CSimpleStringT() throw();

  void Append(const CSimpleStringT& strSrc);
  void Append(PCXSTR pszSrc, int nLength);
  void Append(PCXSTR pszSrc);

  void AppendChar(XCHAR ch);

  static void CopyChars(XCHAR* pchDest, const XCHAR* pchSrc, int nChars) throw();
  static void CopyChars(XCHAR* pchDest, size_t nDestLen, const XCHAR* pchSrc, int nChars) throw();
  static void CopyCharsOverlapped(XCHAR* pchDest, const XCHAR* pchSrc, int nChars) throw();

  XCHAR GetAt(int iChar) const;
  PXSTR GetBuffer(int nMinBufferLength);
  PXSTR GetBuffer();
  PXSTR GetBufferSetLength(int nLength);

  PCXSTR GetString() const throw();
  PXSTR LockBuffer();
  void SetAt(int iChar, XCHAR ch);
  void SetString(PCXSTR pszSrc, int nLength);
  void SetString(PCXSTR pszSrc);
  operator PCXSTR() const throw();
  XCHAR operator[](int iChar) const;

  CSimpleStringT& operator+=(PCXSTR pszSrc);
  CSimpleStringT& operator+=(const CSimpleStringT& strSrc);
  CSimpleStringT& operator+=(char ch);
  CSimpleStringT& operator+=(unsigned char ch);
  CSimpleStringT& operator+=(wchar_t ch);

  CSimpleStringT& operator=(PCXSTR pszSrc);
  CSimpleStringT& operator=(const CSimpleStringT& strSrc);
};

void test_CSimpleStringT() {
  char* x = indirect_source<char>();

  CSimpleStringT<char> s1(x, 10, nullptr);
  sink(s1.GetString()); // $ ir

  CSimpleStringT<char> s2(x, nullptr);
  sink(s2.GetString()); // $ ir

  CSimpleStringT<char> s3(s2);
  sink(s3.GetString()); // $ ir

  CSimpleStringT<char> s4;
  s4.Append(indirect_source<char>());
  sink(s4.GetString()); // $ ir

  CSimpleStringT<char> s5;
  s5.Append(s4);
  sink(s5.GetString()); // $ ir

  CSimpleStringT<char> s6;
  s6.Append(indirect_source<char>(), 42);
  sink(s6.GetString()); // $ ir

  char buffer1[128];
  CSimpleStringT<char>::CopyChars(buffer1, x, 10);
  sink(buffer1); // $ ast ir

  char buffer2[128];
  CSimpleStringT<char>::CopyChars(buffer2, 128, x, 10);
  sink(buffer2); // $ ast ir

  char buffer3[128];
  CSimpleStringT<char>::CopyCharsOverlapped(buffer3, x, 10);
  sink(buffer3); // $ ast ir

  sink(s4.GetAt(0)); // $ ir
  sink(s4.GetBuffer(10)); // $ ir
  sink(s4.GetBuffer()); // $ ir
  sink(s4.GetBufferSetLength(10)); // $ ir

  sink(s4.LockBuffer()); // $ ir

  CSimpleStringT<char> s7;
  s7.SetAt(0, source<char>());
  sink(s7.GetAt(0)); // $ ir

  CSimpleStringT<char> s8;
  s8.SetString(indirect_source<char>());
  sink(s8.GetAt(0)); // $ ir

  CSimpleStringT<char> s9;
  s9.SetString(indirect_source<char>(), 1024);
  sink(s9.GetAt(0)); // $ ir

  sink(static_cast<CSimpleStringT<char>::PCXSTR>(s1)); // $ ir
  
  sink(s1[0]); // $ ir
}

template<typename T>
struct MakeOther {};

template<>
struct MakeOther<char> {
  using other_t = wchar_t;
};

template<>
struct MakeOther<wchar_t> {
  using other_t = char;
};

template<typename BaseType>
struct CStringT : public CSimpleStringT<BaseType> {
  using XCHAR = BaseType; // simplified
  using YCHAR = typename MakeOther<BaseType>::other_t; // simplified
  using PCXSTR = typename CSimpleStringT<BaseType>::PCXSTR;
  using PXSTR = typename CSimpleStringT<BaseType>::PXSTR;
  CStringT() throw();

  CStringT(IAtlStringMgr* pStringMgr) throw();
  CStringT(const VARIANT& varSrc);
  CStringT(const VARIANT& varSrc, IAtlStringMgr* pStringMgr);
  CStringT(const CStringT& strSrc);
  CStringT(const CSimpleStringT<BaseType>& strSrc);
  CStringT(const XCHAR* pszSrc);
  CStringT(const YCHAR* pszSrc);
  CStringT(LPCSTR pszSrc, IAtlStringMgr* pStringMgr);
  CStringT(LPCWSTR pszSrc, IAtlStringMgr* pStringMgr);
  CStringT(const unsigned char* pszSrc);
  CStringT(char* pszSrc);
  CStringT(unsigned char* pszSrc);
  CStringT(wchar_t* pszSrc);
  CStringT(const unsigned char* pszSrc, IAtlStringMgr* pStringMgr);
  CStringT(char ch, int nLength = 1);
  CStringT(wchar_t ch, int nLength = 1);
  CStringT(const XCHAR* pch, int nLength);
  CStringT(const YCHAR* pch, int nLength);
  CStringT(const XCHAR* pch, int nLength, IAtlStringMgr* pStringMgr);
  CStringT(const YCHAR* pch, int nLength, IAtlStringMgr* pStringMgr);

  operator CSimpleStringT<BaseType> &();

  ~CStringT() throw();

  BSTR AllocSysString() const;
  void AppendFormat(PCXSTR pszFormat, ...);
  void AppendFormat(UINT nFormatID, ...);
  int Delete(int iIndex, int nCount = 1);
  int Find(PCXSTR pszSub, int iStart=0) const throw();
  int Find(XCHAR ch, int iStart=0) const throw();
  int FindOneOf(PCXSTR pszCharSet) const throw();
  void Format(UINT nFormatID, ...);
  void Format(PCXSTR pszFormat, ...);
  BOOL GetEnvironmentVariable(PCXSTR pszVar);
  int Insert(int iIndex, PCXSTR psz);
  int Insert(int iIndex, XCHAR ch);
  CStringT Left(int nCount) const;
  BOOL LoadString(HINSTANCE hInstance, UINT nID, WORD wLanguageID);
  BOOL LoadString(HINSTANCE hInstance, UINT nID);
  BOOL LoadString(UINT nID);
  CStringT& MakeLower();
  CStringT& MakeReverse();
  CStringT& MakeUpper();
  CStringT Mid(int iFirst, int nCount) const;
  CStringT Mid(int iFirst) const;
  int Replace(PCXSTR pszOld, PCXSTR pszNew);
  int Replace(XCHAR chOld, XCHAR chNew);
  CStringT Right(int nCount) const;
  BSTR SetSysString(BSTR* pbstr) const;
  CStringT SpanExcluding(PCXSTR pszCharSet) const;
  CStringT SpanIncluding(PCXSTR pszCharSet) const;
  CStringT Tokenize(PCXSTR pszTokens, int& iStart) const;
  CStringT& Trim(XCHAR chTarget);
  CStringT& Trim(PCXSTR pszTargets);
  CStringT& Trim();
  CStringT& TrimLeft(XCHAR chTarget);
  CStringT& TrimLeft(PCXSTR pszTargets);
  CStringT& TrimLeft();
  CStringT& TrimRight(XCHAR chTarget);
  CStringT& TrimRight(PCXSTR pszTargets);
  CStringT& TrimRight();
};

void test_CStringT() {
  VARIANT v = source<VARIANT>();

  CStringT<char> s1(v);
  sink(s1.GetString()); // $ ir

  CStringT<char> s2(v, nullptr);
  sink(s2.GetString()); // $ ir

  CStringT<char> s3(s2);
  sink(s3.GetString()); // $ ir

  char* x = indirect_source<char>();
  CStringT<char> s4(x);
  sink(s4.GetString()); // $ ir

  wchar_t* y = indirect_source<wchar_t>();
  CStringT<wchar_t> s5(y);
  sink(s5.GetString()); // $ ir

  CStringT<char> s6(x, nullptr);
  sink(s6.GetString()); // $ ir

  CStringT<wchar_t> s7(y, nullptr);
  sink(s7.GetString()); // $ ir

  unsigned char* ucs = indirect_source<unsigned char>();
  CStringT<char> s8(ucs);
  sink(s8.GetString()); // $ ir

  char c = source<char>();
  CStringT<char> s9(c);
  sink(s9.GetString()); // $ ir

  wchar_t wc = source<wchar_t>();
  CStringT<wchar_t> s10(wc);
  sink(s10.GetString()); // $ ir

  sink(static_cast<CSimpleStringT<char>&>(s1)); // $ ast ir

  auto bstr = s1.AllocSysString();
  sink(bstr); // $ ir

  CStringT<char> s11;
  s11.AppendFormat("%d", source<int>());
  sink(s11.GetString()); // $ ir

  CStringT<char> s12;
  s12.AppendFormat(indirect_source<char>());
  sink(s12.GetString()); // $ ir

  CStringT<char> s13;
  s13.AppendFormat(source<UINT>());
  sink(s13.GetString()); // $ ir

  CStringT<char> s14;
  s14.AppendFormat(42, source<char>());
  sink(s14.GetString()); // $ ir

  CStringT<char> s15;
  s15.AppendFormat(42, indirect_source<char>());
  sink(s15.GetString()); // $ ir

  CStringT<char> s16;
  s16.AppendFormat("%s", indirect_source<char>());

  CStringT<char> s17;
  s17.Insert(0, x);
  sink(s17.GetString()); // $ ir

  CStringT<char> s18;
  s18.Insert(0, source<char>());
  sink(s18.GetString()); // $ ir

  sink(s1.Left(42).GetString()); // $ ir

  CStringT<char> s20;
  s20.LoadString(source<UINT>());
  sink(s20.GetString()); // $ ir

  sink(s1.MakeLower().GetString()); // $ ir
  sink(s1.MakeReverse().GetString()); // $ ir
  sink(s1.MakeUpper().GetString()); // $ ir
  sink(s1.Mid(0, 42).GetString()); // $ ir

  CStringT<char> s21;
  s21.Replace("abc", x);
  sink(s21.GetString()); // $ ir

  CStringT<char> s22;
  s22.Replace('\n', source<char>());
  sink(s22.GetString()); // $ ir

  sink(s2.Right(42).GetString()); // $ ir

  BSTR bstr2;
  s1.SetSysString(&bstr2);
  sink(bstr2); // $ ast ir

  sink(s1.SpanExcluding("abc").GetString()); // $ ir
  sink(s1.SpanIncluding("abc").GetString()); // $ ir
  
  int start = 0;
  sink(s1.Tokenize("abc", start).GetString()); // $ ir

  sink(s1.Trim('a').GetString()); // $ ir
  sink(s1.Trim("abc").GetString()); // $ ir
  sink(s1.Trim().GetString()); // $ ir
  sink(s1.TrimLeft('a').GetString()); // $ ir
  sink(s1.TrimLeft("abc").GetString()); // $ ir
  sink(s1.TrimLeft().GetString()); // $ ir
  sink(s1.TrimRight('a').GetString()); // $ ir
  sink(s1.TrimRight("abc").GetString()); // $ ir
  sink(s1.TrimRight().GetString()); // $ ir
}

struct CStringData {
  void* data() throw();
};

void test_CStringData() {
  CStringData d = source<CStringData>();
  sink(d.data()); // $ ir
}

template<typename TCharType>
struct CStrBufT {
  typedef CSimpleStringT<TCharType> StringType;

  using PCXSTR = typename StringType::PCXSTR;
  using PXSTR = typename StringType::PXSTR;

  CStrBufT(StringType& str, int nMinLength, DWORD dwFlags);
  CStrBufT(StringType& str);

  operator PCXSTR() const throw();
  operator PXSTR() throw();
};

void test_CStrBufT() {
  CStringT<char> s = source<CStringT<char>>();
  CStrBufT<char> b(s, 42, 0);
  sink(static_cast<CStrBufT<char>::PCXSTR>(b)); // $ ir
  sink(static_cast<CStrBufT<char>::PXSTR>(b)); // $ ir
}