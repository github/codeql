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

void g() {
  int x, y = 0;
  __try {
    ProbeFunction(0);
    x = y;
    ProbeFunction(0);
  }
  __finally {
    sink(x);
  }
}

void AfxThrowMemoryException();

void h(int b) {
  int x = 0;
  __try {
    if (b) {
      AfxThrowMemoryException();
    }
  }
  __except (1) {
    sink(x);
  }
}

int i();

void j(int b) {
  int x = 0;
  __try {
    int y = i();
  }
  __except (1) {
    sink(x);
  }
}
