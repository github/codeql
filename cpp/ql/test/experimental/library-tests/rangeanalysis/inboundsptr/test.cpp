void *malloc(unsigned long);

typedef struct A {
  int a;
  int b;
  char * c;
} A;

void test1(unsigned int count) {
  if (count < 1) {
    return;
  }
  A* ptr = (A*) malloc(sizeof(A) * count);
  ptr[count - 1].a = 1000; // in-bounds
  ptr[count - 1].b = 1001; // in-bounds
  ptr[1].c = 0; // unknown
  ptr[count - 2].a = 1002; // dependant on call-site
  ptr[count].b = 1003; // out-of-bounds
  ptr[-1].c = 0; // out-of-bounds
}

void test2(unsigned int count) {
  int* a = (int*) malloc(sizeof(int) * count);

  for(unsigned int i = 0; i < count; ++i) {
    a[i] = 0; // in-bounds
    int l = a[i]; // in-bounds
  }

  a = (int*) malloc(sizeof(int) * count);
  a = a + 2;
  for(unsigned int i = 0; i < count - 2; ++i) {
    a[i] = 0; // in-bounds
  }

  for(unsigned int i = 0; i < count; ++i) {
    *a = 1; // in-bounds but not detected, array length tracking is not advanced enough for this
    a++;
  }

  void* v = malloc(count);
  for(unsigned int i = 0; i < count; ++i) {
    ((char *)v)[i] = 0; // in-bounds, but due to void-allocation not detected
  }

  int stack[100];
  for(unsigned int i = 0; i < 100; ++i) {
    stack[i] = 0; // in-bounds
  }

  for(unsigned int i = 0; i < count; ++i) {
    a = (int*) malloc(sizeof(int) * count);
    for (int j = 0; j < count; ++j) {
      a[j] = 0; // in-bounds, but not detected due to RangeAnalysis shortcomings
    }
  }

  for(unsigned int i = 0; i < 10; ++i) {
    a = (int*) malloc(sizeof(int) * i);
    for (unsigned int j = 0; j < i; ++j) {
      a[j] = 0; // in-bounds
    }
  }

}
void test3(int count) {
  for(int i = 0; i < count; ++i) {
    int * a = (int*) malloc(sizeof(int) * i);
    for (int j = 0; j < i; ++j) {
      a[j] = 0; // in-bounds
    }
  }
}


void test4(unsigned long count) {
  if (count < 1) {
    return;  
  } 
  int* a = (int*) malloc(sizeof(int) * count);
  int b = a[0] + 3; // in-bounds
  a = a + 2;
  unsigned int i = 0;
  for(; i < count - 2; ++i) {
    a[i] = 0; // in-bounds
  }
  a[-2] = 0; // in-bounds
  a[-3] = 0; // out-of-bounds
  a[i] = 0; // out-of-bounds
  a[count - 2] = 0; // out-of-bounds
  a[count - 3] = 0; // in-bounds
}

void test5(unsigned int count) {
  int* a = (int*) malloc(sizeof(int) * count);
  a[0] = 0; // unknown, call-site dependant
}


void test6(unsigned int count, bool b) {
  if(count < 4) {
    return;
  }
  int* a = (int*) malloc(sizeof(int) * count);
  if (b) {
    a += 2;
  } else {
    a += 3;
  } // we lose all information about a after the phi-node here
  a[-2] = 0; // unknown
  a[-3] = 0; // unknown
  a[-4] = 0; // unknown
  a[0] = 0; // unknown
}

void test7(unsigned int object) {
  unsigned int* ptr = &object;
  *ptr = 0; // in-bounds, but needs ArrayLengthAnalysis improvements.
}

void test8() {
  void (*foo)(unsigned int);
  foo = &test7;
  foo(4); // in-bounds, but needs ArrayLengthAnalysis improvements.
}

