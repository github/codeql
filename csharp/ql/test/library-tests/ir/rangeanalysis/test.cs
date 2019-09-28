class RangeAnalysis {
  static void Sink(int val) 
  {
  }
  
  static unsafe void Sinkp(int* p) 
  {
  }
  
  static int Source() 
  {
    return 0;
  }
  
  // Guards, inference, critical edges
  static int Test1(int x, int y) 
  {
    if (x < y) 
    {
      x = y;
    }
    return x;
  }
  
  // Bounds mergers at phi nodes
  static int Test2(int x, int y) 
  {
    if (x < y) 
    {
      x = y;
    } 
    else 
    {
      x = x - 2;
    }
    return x;
  }
  
  // for loops
  static void Test3(int x) 
  {
    int y = x;
    for(int i = 0; i < x; i++) 
    {
      Sink(i);
    }
    for(int i = y; i > 0; i--) 
    {
      Sink(i);
    }
    for(int i = 0; i < y + 2; i++) 
    {
      Sink(i);
    }
  }
  
  // pointer bounds
  unsafe static void Test4(int *begin, int *end) 
  {
    while (begin < end) 
    {
      Sinkp(begin);
      begin++;
    }
  }
  
  // bound propagation through conditionals
  static void Test5(int x, int y, int z) 
  {
    if (y < z) 
    {
      if (x < y) 
      {
        Sink(x);
      }
    }
    if (x < y) 
    {
      if (y < z) 
      {
        Sink(x); // x < z is not inferred here
      }
    }
  }
}
