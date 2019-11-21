#define TWO 2
#include "b.h"

int main() {
  return ONE + TWO + THREE + FOUR;
}
// codeql-extractor-compiler: clang-cc1
// codeql-extractor-compiler-options: -include-pch ${testdir}/clang-pch.testproj/a.pch -Iextra_dummy_path
