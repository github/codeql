
void f(void) {
    if (1) {
        int i;

        for(int i = 1; i < 10; i++) { // BAD
            ;
        }
    }
}

namespace foo {
  namespace bar {
    void f2(int i) {
      int k;
      try {
        for (i = 0; i < 3; i++) {
          int k; // BAD
        }
      }
      catch (int e) {
      }
    }
  }
}

void nestedRangeBasedFor() {
  int xs[4], ys[4];
  for (auto x : xs)
    for (auto y : ys) // GOOD
      x = y = 0;
}
