// semmle-extractor-options: --expect_errors

int f1() {
  int x;
  initialize(&x); // error expression - initialize() is not defined
  return x;       // GOOD - assume x is initialized
}

void * operator new(unsigned long, bool);
void operator delete(void*, bool);

int f2() {
  int x;
  new(true) int (x);  // BAD, ignore implicit error expression
}
