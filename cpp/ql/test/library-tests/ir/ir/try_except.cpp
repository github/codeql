// semmle-extractor-options: --microsoft

void ProbeFunction(...);
void sink(...);

void f_cpp() {
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

void g_cpp() {
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

void h_cpp(int b) {
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

void throw_cpp(int b) {
  int x = 0;
    __try {
        if (b) {
            throw 1;
        }
    }
    __except (1) {
        sink(x);
    }
}
