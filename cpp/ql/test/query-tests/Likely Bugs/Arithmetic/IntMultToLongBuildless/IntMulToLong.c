// semmle-extractor-options: --build-mode none

int f();

void test() {
  int i = f();
  unsigned u = i;
  long j = i * i; // GOOD: build mode none
  unsigned long k = u * u; // GOOD: build mode none
}
