// semmle-extractor-options: -std=c++20
double a1[]{1,2,3};
double* p1 = new double[]{1,2,3};
double* p2 = new double[0]{};
double* p3 = new double[]{};
char c[]{"Hello"};
char* d = new char[]{"Hello"};
double a2[](1,2,3);
double* p4 = new double[](1,2,3);
double* p5 = new double[4]{1,2};  // Size mismatch
