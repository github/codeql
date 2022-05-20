// semmle-extractor-options: --edg --clang

int x = 0;

int* f(void) {
  int* x_addr = __builtin_addressof(x);
  return x_addr;
}
