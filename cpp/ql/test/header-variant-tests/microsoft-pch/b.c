#pragma hdrstop
#include "b.h"

int b() {
  return A;
}
// semmle-extractor-options: --microsoft /Yub.h /Fp${testdir}/microsoft-pch.testproj/a.pch
