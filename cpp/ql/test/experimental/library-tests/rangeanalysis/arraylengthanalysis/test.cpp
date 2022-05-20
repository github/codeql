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
  A* aptr = (A *) malloc(sizeof(A) * count);
  sink(aptr); // (count, 0, Zero, 0)
  unsigned int* ptr = &count;
  sink(ptr); // (Zero, 1, Zero, 0) TODO none, as the feature is not implemented
  int* a = (int *) malloc(sizeof(int) * count);
  sink(a); // (count, 0, Zero, 0)
  a = (int *) malloc(sizeof(int) * (count - 1));
  sink(a); // (count, -1, Zero, 0)
  a = (int *) malloc(sizeof(int) * (count + 1));
  sink(a); // (count, 1, Zero, 0)
  a = (int *) malloc(sizeof(int) * (2 * count));
  sink(a); // none, as the size expression is too complicated
  char* c = (char *)malloc(count);
  sink(c); // /count, 0, Zero, 0)
  sink((unsigned char*)c); // (count, 0, Zero, 0)
  void* v = c;
  sink(v); // (count, 0, Zero, 0)
  v = malloc(count);
  sink((char *)v); // none, as we don't track void* allocations
  int stack[100];
  sink(stack); // (Zero, 100, Zero, 0)
  for(unsigned int i = 0; i < count; ++i) {
    int* b = (int*) malloc(sizeof(int) * count);
    sink(b); // (count, 0, Zero, 0)
  }
}

void test2(unsigned int count, bool b) {
  int* a = (int *) malloc(sizeof(int) * count);
  a = a + 2;
  sink(a); // (count, 0, Zero, 2)
  for(unsigned int i = 2; i < count; ++i) {
    sink(a); // none
    a++;
    sink(a); // none
  }
  a = (int*) malloc(sizeof(int) * count);
  if (b) {
    a += 2;
    sink(a); // (count, 0, Zero, 2)
  } else {
    a += 3;
    sink(a); // (count, 0, Zero, 2)
  }
  sink(a); // none
  a -= 2;
  sink(a); // none
  a = (int*) malloc(sizeof(int) * count);
  for(unsigned int i = 0; i < count; i++) {
    sink(&a[i]); // (count, 0, i, 0)
  }
  a = (int*) malloc(sizeof(int) * count);
  sink(a); // (count, 0, Zero, 0)
  a += 3;
  sink(a); // (count, 0, Zero, 3)
  a -= 1;
  sink(a); // (count, 0, Zero, 2)
  a -= 2;
  sink(a); // (count, 0, Zero, 0)
  a -= 10;
  sink(a); // (count, 0, Zero, -10)
  a = (int*) malloc(sizeof(int) * (count + 1));
  sink(a); // (count, 1, Zero, 0)
  a += count;
  sink(a); // (count, 1, count, 0);
  a += 1;
  sink(a); // (count, 1, count, 1);
  a -= count;
  sink(a); // none
  a = (int*) malloc(sizeof(int) * (count + 1));
  a += count + 1;
  sink(a); // TODO, should be (count, 1, count, 1), but is (count, 1, count + 1, 0)
  a += 1;
  sink(a); // TODO, should be (count, 1, count, 2), but is (count, 1, count + 1, 1)
  a = (int*) malloc(sizeof(int) * (1024 - count));
  sink(a); // none, as the size expression is too complicated
}

void test3(unsigned int object) {
  unsigned int* ptr = &object;
  sink(ptr); // TODO, none, but should be (Zero, 1, Zero, 0)
}
