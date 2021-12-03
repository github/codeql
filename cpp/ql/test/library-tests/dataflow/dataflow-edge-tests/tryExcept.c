// semmle-extractor-options: --microsoft

void ProbeFunction();
void sink();

void f() {
  int x, y = 0;
  __try {
    ProbeFunction(0);
    x = y;
    ProbeFunction(0);
  }
  __except (0) {
    sink(x);
  }
}
