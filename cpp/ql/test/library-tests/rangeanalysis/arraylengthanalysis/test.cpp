//#include <cstddef>
//#include <stdlib.h>

void *malloc(unsigned long);
void sink(...);

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
  sink(ptr);
}

void test2(unsigned int count) {
  int* a = (int*) malloc(sizeof(int) * count);
  for(unsigned int i = 0; i < count; ++i) {
    sink(a);
  }
}

void test3(unsigned int count) {
  int* a = (int*) malloc(sizeof(int) * count);
  sink(a);
  a = a + 2;
  sink(a);
}

void test4(unsigned int count) {
  void* a = malloc(count);
  sink((char *)a);
}

void test5() {
  int a[100];
  sink(a);
}

void test6(unsigned int count) {
  int* a = (int*) malloc(sizeof(int) * count);
  sink(a);
  for(unsigned int i = 0; i < count; ++i) {
    sink(a);
    a++;
    sink(a);
  }
}

void test7(unsigned int count) {
  int* a = (int*) malloc(sizeof(int) * count);
  sink(a);
  a += 3;
  sink(a);
  for(unsigned int i = 0; i < count - 2; ++i) {
    sink(a);
    a++;
    sink(a);
  }
}

void test8(unsigned int count) {
  if (count < 1) {
    return;
  }
  int* a = (int*) malloc(sizeof(int) * count);
  sink(a);
}


void test9(unsigned int count) {
  for(unsigned int i = 0; i < count; ++i) {
    int* a = (int*) malloc(sizeof(int) * count);
    sink(a);
  }
}

void test10(unsigned int count, bool b) {
  if(count < 4) {
    return;
  }
  int* a = (int*) malloc(sizeof(int) * count);
  sink(a);
  if (b) {
    a += 2;
    sink(a);
  } else {
    a += 3;
    sink(a);
  }
  sink(a);
  a -= 2;
  sink(a);
}

void test11(int* array, unsigned int count) {
  sink(array);
  for (unsigned int i = 0; i < count; ++i) {
    array[i] = 0; // in-bounds TODO range analysis
  }
}

void test12(unsigned int c) {
  if(c < 4) {
    return;
  }
  int* a = (int*) malloc(sizeof(int) * c);
  sink(a);
  test11(a, c);
  sink(a);
}

void test13(unsigned int object) {
  unsigned int* ptr = &object;
  sink(ptr);
}

void test14() {
  void (*foo)(unsigned int);
  sink(foo);
  foo = &test13;
  sink(foo);
  foo(4);
  (*foo)(4);
}

void test15(unsigned int count) {
  int* a = (int*) malloc(sizeof(int) * count);
  sink(a);
  a += 3;
  sink(a);
  a -= 1;
  sink(a);
  a -= 2;
  sink(a);
  a -= 10;
  sink(a);
}