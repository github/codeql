// semmle-extractor-options: --build-mode none

int f();

void test() {
  int i = f();
  unsigned u = i;
  long j = i * i; // BAD (FP)
  unsigned long k = u * u; // BAD (FP)
}
