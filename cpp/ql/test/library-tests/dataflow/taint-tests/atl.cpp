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
  HRESULT BSTRToArray(LPSAFEARRAY ppArray) throw();
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
    SAFEARRAY safe;
    b9.Append(source<char>());
    b9.BSTRToArray(&safe);
    sink(safe.pvData); // $ ir

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
    sink(p.m_strPath); // $ ir

    CPath p3;
    p3 += x;
    sink(p.m_strPath); // $ ir
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
    sink(a.GetValueAt(pos)); // $ MISSING: ir
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
  sink(url); // $ MISSING: ir
  sink(url.GetExtraInfo()); // $ MISSING: ir
  sink(url.GetHostName()); // $ MISSING: ir
  sink(url.GetPassword()); // $ MISSING: ir
  sink(url.GetSchemeName()); // $ MISSING: ir
  sink(url.GetUrlPath()); // $ MISSING: ir
  sink(url.GetUserName()); // $ MISSING: ir

  {
    CUrl url2;
    DWORD len;
    char buffer[1024];
    url2.CrackUrl(x, 0);
    url2.CreateUrl(buffer, &len, 0);
    sink(buffer); // $ ast MISSING: ir
  }
  {
    CUrl url2;
    url2.SetExtraInfo(x);
    sink(url2); // $ MISSING: ir
  }
  {
    CUrl url2;
    url2.SetHostName(x);
    sink(url2); // $ MISSING: ir
  }
  {
    CUrl url2;
    url2.SetPassword(x);
    sink(url2); // $ MISSING: ir
  }
  {
    CUrl url2;
    url2.SetSchemeName(x);
    sink(url2); // $ MISSING: ir
  }
  {
    CUrl url2;
    url2.SetUrlPath(x);
    sink(url2); // $ MISSING: ir
  }
  {
    CUrl url2;
    url2.SetUserName(x);
    sink(url2); // $ MISSING: ir
  }
}