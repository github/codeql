#ifdef SEEN_F
static int g() {
  return 20;
}
#endif
// codeql-extractor-compiler: clang-cc1
// codeql-extractor-compiler-options: -include-pch ${testdir}/clang-pch.testproj/f.pch --expect_errors
