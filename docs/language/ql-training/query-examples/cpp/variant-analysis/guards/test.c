    int val[16];
    void f(int x) {
      if (x > 0) { // `x > 0` is a guard condition
        val[x]; // guarded by `x > 0`, true case
      } else {
        val[x]; // guarded by `x > 0`, false case
      }
      val[x]; // not guarded
    }