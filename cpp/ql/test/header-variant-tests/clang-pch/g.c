#ifdef SEEN_F
static int g() {
  return 20;
}
#endif
// semmle-extractor-options: --clang -include-pch ${testdir}/clang-pch.testproj/f.pch --expect_errors
