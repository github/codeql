#if 1
#pragma hdrstop
extern int x;
#define SEEN_F
#endif
// codeql-extractor-compiler: clang-cc1
// codeql-extractor-compiler-options: -emit-pch -o ${testdir}/clang-pch.testproj/f.pch
