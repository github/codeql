    int val[16];
    void f(int x) {
      if (x < -1 || x > 15) {
        return;
      }
      val[x]; // What possible range of values can x hold here?
    }