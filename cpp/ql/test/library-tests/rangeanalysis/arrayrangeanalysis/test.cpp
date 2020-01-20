//#include <cstddef>
//#include <stdlib.h>

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
  ptr[0].a = 1000; // in-bounds
  ptr[count - 1].a = 1001; // in-bounds
  ptr[1].a = 1002; // unknown
  ptr[count - 2].a = 1002; // detected as out-of-bounds because not caught by bounds-check, in reality unknown/call-site-dependant
  ptr[count].a = 1003; // out-of-bounds
  ptr[-1].a = 1004; // out-of-bounds
}

void test2(unsigned int count) {
  int* a = (int*) malloc(sizeof(int) * count);
  for(unsigned int i = 0; i < count; ++i) {
    a[i] = 0; // in-bounds
  }
}

void test3(unsigned int count) {
  int* a = (int*) malloc(sizeof(int) * count);
  a = a + 2;
  for(unsigned int i = 0; i < count - 2; ++i) {
    a[i] = 0; // in-bounds
  }
}

void test4(unsigned int count) {
  void* a = malloc(count);
  for(unsigned int i = 0; i < count; ++i) {
    ((char *)a)[i] = 0; // in-bounds
  }
}

void test5() {
  int a[100];
  for(unsigned int i = 0; i < 100; ++i) {
    a[i] = 0; // in-bounds
  }
}

void test6(unsigned int count) {
  int* a = (int*) malloc(sizeof(int) * count);
  for(unsigned int i = 0; i < count; ++i) {
    *a = 1; // in-bounds TODO do we detect this?
    a++;
  }
}

void test7(unsigned int count) {
  int* a = (int*) malloc(sizeof(int) * count);
  a += 2;
  for(unsigned int i = 0; i < count - 2; ++i) {
    *a = 1; // in-bounds, todo do we detect this?
    a++;
  }
}

void test8(unsigned long count) {
  if (count < 1) {
    return;  
  } 
  int* a = (int*) malloc(sizeof(int) * count);
  a = a + 2;
  unsigned int i = 0;
  for(; i < count - 2; ++i) {
    a[i] = 0; // in-bounds
  }
  a[-2] = 0; // in-bounds
  a[-3] = 0; // out-of-bounds
  a[i] = 0; // out-of-bounds
}

void test9(unsigned int count) {
  if (count < 1) {
    return;
  }
  int* a = (int*) malloc(sizeof(int) * count);
  a[0] = 0; // in-bounds
  a[1] = 1; // unknown
  a[-1] = 0; // out-of-bounds
  a[count] = 0; // out-of-bounds
}

void test10(unsigned int count) {
  if (count < 1) {
    return;
  }
  int* a = (int*) malloc(sizeof(int) * count);
  int b = a[0] + 3; // in-bounds
}

void test11(unsigned int count) {
  if (count < 1) {
    return;
  }
  int* a = (int*) malloc(sizeof(int) * count);
  int b = *a + 3; // in-bounds
}

void test12(unsigned int count) {
  for(unsigned int i = 0; i < count; ++i) {
    int* a = (int*) malloc(sizeof(int) * count);
    for (int j = 0; j < count; ++j) {
      a[j] = 0; // in-bounds
    }
  }
}

void test13(unsigned int count, bool b) {
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

void test14(int* array, unsigned int count) {
  for (unsigned int i = 0; i < count; ++i) {
    array[i] = 0; // in-bounds TODO range analysis
  }
}

void test15(unsigned int c) {
  if(c < 4) {
    return;
  }
  int* a = (int*) malloc(sizeof(int) * c);
  a[3] = 0; // in-bounds
  test14(a, c);
}

void test16(unsigned int object) {
  unsigned int* ptr = &object;
  *ptr = 0;
}

void test17() {
  void (*foo)(unsigned int);
  foo = &test16;
  foo(4);
  (*foo)(4);
}

void test19(unsigned long count) {
  int* a = (int*) malloc(sizeof(int) * count);
  a[0] = 1;
}
