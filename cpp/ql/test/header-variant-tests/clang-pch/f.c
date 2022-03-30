#if 1
#pragma hdrstop
extern int x;
#define SEEN_F
#endif
// semmle-extractor-options: --clang -emit-pch -o ${testdir}/clang-pch.testproj/f.pch
