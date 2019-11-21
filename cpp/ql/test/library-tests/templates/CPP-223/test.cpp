

template <int a> class b {
  template <bool> struct c;
  typedef typename c<!a>::d e;
  template <bool> void f(e, int);
  template <> void f<true>(e, int);
};

// codeql-extractor-compiler: clang
// codeql-extractor-compiler-options: -fms-extensions
