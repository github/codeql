#include "d.h"
#include "c.h"

int c() {
  return A;
}
// codeql-extractor-compiler: cl
// codeql-extractor-compiler-options: /Yuc.h /Fp${testdir}/microsoft-pch.testproj/a.pch
