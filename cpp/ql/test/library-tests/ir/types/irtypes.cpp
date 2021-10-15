struct A {
  int f_a;
};

struct B {
  double f_a;
  float f_b;
};

enum E {
  Zero,
  One,
  Two,
  Three
};

enum class ScopedE {
  Zero,
  One,
  Two,
  Three
};

void IRTypes() {
  char c;  //$irtype=int1
  signed char sc;  //$irtype=int1
  unsigned char uc;  //$irtype=uint1
  short s;  //$irtype=int2
  signed short ss;  //$irtype=int2
  unsigned short us;  //$irtype=uint2
  int i;  //$irtype=int4
  signed int si;  //$irtype=int4
  unsigned int ui;  //$irtype=uint4
  long l;  //$irtype=int8
  signed long sl;  //$irtype=int8
  unsigned long ul;  //$irtype=uint8
  long long ll;  //$irtype=int8
  signed long long sll;  //$irtype=int8
  unsigned long long ull;  //$irtype=uint8
  bool b;  //$irtype=bool1
  float f;  //$irtype=float4
  double d;  //$irtype=float8
  long double ld;  //$irtype=float16
  __float128 f128;  //$irtype=float16

  wchar_t wc;  //$irtype=uint4
//  char8_t c8;  //$irtype=uint1
  char16_t c16;  //$irtype=uint2
  char32_t c32;  //$irtype=uint4

  int* pi;  //$irtype=addr8
  int& ri = i;  //$irtype=addr8
  void (*pfn)() = nullptr;  //$irtype=func8
  void (&rfn)() = IRTypes;  //$irtype=func8

  A s_a;  //$irtype=opaque4{A}
  B s_b;  //$irtype=opaque16{B}

  E e;  //$irtype=uint4
  ScopedE se;  //$irtype=uint4

  B a_b[10];  //$irtype=opaque160{B[10]}
}

// semmle-extractor-options: -std=c++17 --clang
