int test1(int i) {
  int intArray[10] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
  int *intPointer = intArray;
  // GOOD: the offset is automatically scaled by sizeof(int).
  return *(intPointer + i);
}

int test2(int i) {
  int intArray[5] = { 1, 2, 3, 4, 5 };
  char *charPointer = (char *)intArray;
  // BAD [FALSE NEGATIVE of IncorrectPointerScaling.ql]: the pointer arithmetic
  // uses type char*, so the offset is not scaled by sizeof(int).
  return *(int *)(charPointer + i);
}

int test3(int i) {
  int intArray[5] = { 1, 2, 3, 4, 5 };
  char *charPointer = (char *)intArray;
  // GOOD: the offset is manually scaled by sizeof(int).
  return *(int *)(charPointer + (i * sizeof(int)));
}

int test4(int i) {
  int intArray[5] = { 1, 2, 3, 4, 5 };
  char *charPointer = (char *)intArray;
  // GOOD: the offset is manually scaled by sizeof(int).
  return *(int *)(charPointer - (i * sizeof(int)));
}

int test5(int i) {
  int intArray[5] = { 1, 2, 3, 4, 5 };
  char *charPointer = (char *)intArray;
  // GOOD: the offset is manually scaled by sizeof(int).
  return *(int *)(charPointer + sizeof(int));
}

int test6(int i) {
  int intArray[5] = { 1, 2, 3, 4, 5 };
  char *charPointer = (char *)intArray;
  // GOOD: the offset is manually scaled by sizeof(int).
  return *(int *)(charPointer - sizeof(int));
}

char* test7(
  double *x
) {
  int *p = (int*)x;
  // BAD: the type of x is double*, but it has been cast to int*
  // so the pointer add is scaled by sizeof(int).
  return (char *)(p + 1);
}

char* test8(
  void *x
) {
  int *p = (int*)x;
  // GOOD: the type of x is void*, so we give the programmer the benefit
  // of the doubt and assume that it is really an int*.
  return (char *)(p + 1);
}

char* test9(
  char *x
) {
  int *p = (int*)x;
  // GOOD: the type of x is char* (which is often used is a generic
  // pointer type, like void*), so we give the programmer the benefit
  // of the doubt and assume that it is really an int*.
  return (char *)(p + 1);
}

char* test10(int* x) {
  // BAD, but not because of incorrect pointer scaling. The result of reading
  // only part of an integer is architecture-dependent. If the pointer returned
  // from this function is dereferenced, the result will depend on int size and
  // endianness regardless of whether the offset is scaled by sizeof(int).
  return (char*)x + 1;
}

char* test10b(int* x) {
  // BAD, but not because of incorrect pointer scaling. The result of reading
  // only part of an integer is architecture-dependent. If the pointer returned
  // from this function is dereferenced, the result will depend on int size and
  // endianness regardless of whether the offset is scaled by sizeof(int).
  return (char*)x + sizeof(int);
}

short* test10c(int* x) {
  // BAD, but not because of incorrect pointer scaling. The result of reading
  // only part of an integer is architecture-dependent. If the pointer returned
  // from this function is dereferenced, the result will depend on int size and
  // endianness regardless of whether the offset is scaled by (sizeof(int) /
  // sizeof(short)).
  return (short*)x + 1;
}

int test11(int* x, int* y) {
  // GOOD: this code is computing a pointer difference, so we will
  // assume that the programmer knows what they are doing.
  return (char*)x - (char*)y;
}

int test12(int* x, int* y) {
  // GOOD: this code is computing a pointer difference, so we will
  // assume that the programmer knows what they are doing.
  return ((char*)x + 1) - (char*)y;
}

struct mystruct {
  char char_field;
  int int_field;
};

int test13(mystruct *p) {
  // GOOD [FALSE POSITIVE of IncorrectPointerScalingChar.ql]: this code
  // computes the byte offset of a member. Code like this is commonly seen in
  // projects that use C/C++ for their low-level control over memory.
  int offset = (char *)&p->int_field - (char *)p;
  return *(int *)((char*)p + offset);
}

int test14(int arr[12][12]) {
  // GOOD: this code uses int* to index into a multi-dimensional array where
  // int is the underlying type.
  return *((int*) arr + 4);
}

int test15(int arr[12][12]) {
  // BAD: the type of the pointer is int but it has been scaled by sizeof(short)
  return *(int*)((short*) arr + 1);
}

void* test16(int* x) {
  // BAD: void pointer arithmetic is not portable across compilers
  return (void*)x + 1;
}

void* test17(int* x) {
  // BAD: void pointer arithmetic is not portable across compilers
  return (void*)x + sizeof(int);
}

int test18(int i) {
  int intArray[2][2] = { {1, 2}, {3, 4} };
  char *charPointer = (char *)intArray;
  // BAD: the pointer arithmetic uses type char*, so the offset is not scaled by sizeof(int).
  return *(int *)(charPointer + i);
}
