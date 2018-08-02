
void f(void) {
    if (1) {
        int i;

        for(int i = 1; i < 10; i++) {
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
          int k;
        }
      }
      catch (int e) {
      }
    }
  }
}


