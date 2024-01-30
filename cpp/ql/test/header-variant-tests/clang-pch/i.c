#ifdef SEEN_H
static int h() {
  return 30;
}
#endif
#ifdef H1
static int h1() {
  return 31;
}
#endif
#ifdef H2
static int h2() {
  return 32;
}
#endif
// semmle-extractor-options: --clang -include-pch ${testdir}/clang-pch.testproj/h.pch
