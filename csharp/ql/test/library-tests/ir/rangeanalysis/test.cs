class RangeAnalysis {
  static void sink(int val) {
  
  }
  
  static unsafe void sinkp(int* p) {
  
  }
  
  static int source() {
    return 0;
  }
  
  // Guards, inference, critical edges
  static int test1(int x, int y) {
    if (x < y) {
      x = y;
    }
    return x;
  }
  
  // Bounds mergers at phi nodes
  static int test2(int x, int y) {
    if (x < y) {
      x = y;
    } else {
      x = x-2;
    }
    return x;
  }
  
  // for loops
  static void test3(int x) {
    int y = x;
    for(int i = 0; i < x; i++) {
      sink(i);
    }
    for(int i = y; i > 0; i--) {
      sink(i);
    }
    for(int i = 0; i < y + 2; i++) {
      sink(i);
    }
  }
  
  // pointer bounds
  unsafe static void test4(int *begin, int *end) {
    while (begin < end) {
      sinkp(begin);
      begin++;
    }
  }
  
  // bound propagation through conditionals
  static void test5(int x, int y, int z) {
    if (y < z) {
      if (x < y) {
        sink(x);
      }
    }
    if (x < y) {
      if (y < z) {
        sink(x); // x < z is not inferred here
      }
    }
  }

    unsafe static void addone(int[] arr) 
    {
        int length = arr.Length;
        fixed (int* b = arr) 
        {
            int *p = b;
            for(int i = 0; i <= length; i++)
                *p++ += 1;
        }
    }  
}
