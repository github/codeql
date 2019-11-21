#pragma hdrstop
#include "b.h"

int b() {
  return A;
}
// codeql-extractor-compiler: cl
// codeql-extractor-compiler-options: /Yub.h /Fp${testdir}/microsoft-pch.testproj/a.pch
