#include "d.h"
#include "c.h"

int c() {
  return A;
}
// semmle-extractor-options: --microsoft /Yuc.h /Fp${testdir}/microsoft-pch.testproj/a.pch
