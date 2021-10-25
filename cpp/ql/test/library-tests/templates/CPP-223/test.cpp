// semmle-extractor-options: --edg --clang --edg --ms_extensions

template <int a> class b {
  template <bool> struct c;
  typedef typename c<!a>::d e;
  template <bool> void f(e, int);
  template <> void f<true>(e, int);
};
