#define TWO 2
#include "b.h"

int main() {
  return ONE + TWO + THREE + FOUR;
}
// semmle-extractor-options: --clang -include-pch ${testdir}/clang-pch.testproj/a.pch -Iextra_dummy_path
