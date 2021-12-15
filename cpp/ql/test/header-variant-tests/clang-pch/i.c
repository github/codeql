#ifdef SEEN_H
static int h() {
  return 30; // [FALSE POSITIVE] (#pragma hdrstop bug, SEEN_H should not be defined in the precompiled header)
}
#endif
#ifdef H1
static int h1() {
  return 31;
}
#endif
#ifdef H2
static int h2() {
  return 32; // [FALSE POSITIVE] (#pragma hdrstop bug, H2 should not be defined in the precompiled header)
}
#endif
// semmle-extractor-options: --clang -include-pch ${testdir}/clang-pch.testproj/h.pch
