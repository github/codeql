
void f(int ii) {
    if (1) {
        for(int ii = 1; ii < 10; ii++) {
            ;
        }
    }
}

namespace foo {
  namespace bar {
    void f2(int ii, int kk) {
      try {
        for (ii = 0; ii < 3; ii++) {
          int kk;
        }
      }
      catch (int ee) {
      }
    }
  }
}


