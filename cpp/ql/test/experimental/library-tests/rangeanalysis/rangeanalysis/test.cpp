
void sink(...);
int source();

// Guards, inference, critical edges
int test1(int x, int y) {
  if (x < y) {
    x = y;
  }
  return x;
}

// Bounds mergers at phi nodes
int test2(int x, int y) {
  if (x < y) {
    x = y;
  } else {
    x = x-2;
  }
  return x;
}

// for loops
int test3(int x) {
  int i;
  for(i = 0; i < x; i++) {
    sink(i);
  }
  for(i = x; i > 0; i--) {
    sink(i);
  }
  for(i = 0; i < x + 2; i++) {
    sink(i);
  }
}

// pointer bounds
int test4(int *begin, int *end) {
  while (begin < end) {
    sink(begin);
    begin++;
  }
}

// bound propagation through conditionals
int test5(int x, int y, int z) {
  if (y < z) {
    if (x < y) {
      sink(x);
    }
  }
  if (x < y) {
    if (y < z) {
      sink(x); // x < z is inferred here
    }
  }
}

// pointer arithmetic and sizes
void test6(int *p) {
  for (char *iter = (char *)p; iter < (char *)(p+1); iter++) {
    sink(iter);
  }

  char *end = (char *)(p+1);
  for (char *iter = (char *)p; iter < end; iter++) {
    sink(iter);
  }
}

// inference from equality
int test8(int x, int y) {
  int *p = new int[x];

  if (x == y) {
    for(int i = 0; i < y; ++i) {
      sink(i);
    }
  }
}

// >, >=, <=
void test9(int x) {
  if (x > 1) {
    sink(x);
  } else {
    sink(x);
  }
  if (x >= 1) {
    sink(x);
  } else {
    sink(x);
  }
  if (x < 1) {
    sink(x);
  } else {
    sink(x);
  }
  if (x <= 1) {
    sink(x);
  } else {
    sink(x);
  }
}

// Phi nodes as bounds
void test10(int y, int z, bool use_y) {
  int x;
  if(use_y) {
    x = y;
  } else {
    x = z;
  }
  sink();
  int i = source();
  if (i < x)
    sink(i);
}

// Irreducible CFGs
int test11(int y, int x) {
  int i = 0;
  if (x < y) {
    x = y;
  } else {
    goto inLoop;
  }
  for(i = 0; i < x; i++) {
    inLoop:
    sink(i);
  }
}

// do-while
int test12(int x) {
  int i = 0;
  do {
    i++;
  } while(i < x);
  return i;
}

// do while false
int test13(int x) {
  int i = 0;
  do {
    i++;
  } while(false);
  return i;
}

// unequal bound narrowing
int test14(int x, int y) {
  if(x < y) {
    if (x == y-1) {
      sink(x);
    } else {
      sink(x);
    }
    if (x != y-1) {
      sink(x);
    } else {
      sink(x);
    }
  } else {
    if (y == x-1) {
      sink(x);
    } else {
      sink(x);
    }
  }
}

// more interesting bounds with irreducible CFG
int test15(int i, int x) {
  if (x < i) {
    sink(i); // i >= x + 1
  } else {
    sink(i); // i <= x
    goto inLoop;
  }
  for(; i < x; i++) {
    sink(i); // i <= x - 1
    inLoop:
    sink(i); // i <= x
  }
  return i;
}

// safe integer type conversion
int test16(int i) {
  long l;
  l = i;
  sink(l);
}

// implicit integer casts
void test17(int i, long l) {
  if (i < l) {
    sink(i);
  }
  if (i < l - 2) {
    sink (i);
  }
}

void test18(int x, int y) {
  if (x < y - 2) {
    sink(x);
  }
}
