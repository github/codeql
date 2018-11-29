int test1(int i) {
  int intArray[10] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
  int *intPointer = intArray;
  // BAD: the offset is already automatically scaled by sizeof(int),
  // so this code will compute the wrong offset.
  return *(intPointer + (i * sizeof(int)));
}

int test2(int i) {
  int intArray[10] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
  int *intPointer = intArray;
  // BAD: the offset is already automatically scaled by sizeof(int),
  // so this code will compute the wrong offset.
  return *(intPointer - (i * sizeof(int)));
}

int test3(int i) {
  int intArray[10] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
  int *intPointer = intArray;
  // BAD: the offset is already automatically scaled by sizeof(int),
  // so this code will compute the wrong offset.
  return *(intPointer + sizeof(int));
}

int test4(int i) {
  int intArray[10] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
  int *intPointer = intArray;
  // BAD: the offset is already automatically scaled by sizeof(int),
  // so this code will compute the wrong offset.
  return *(intPointer - sizeof(int));
}

int test5(int i, int j) {
  int intArray[10] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
  int *intPointer = intArray;
  // BAD: the offset is already automatically scaled by sizeof(int),
  // so this code will compute the wrong offset.
  return *(intPointer + (i * sizeof(int) * j));
}

void test6(int i) {
  char charArray[10] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
  char *charPointer = charArray;
  void *voidPointer = charArray;
  char v;

  v = *(charPointer + i); // GOOD
  v = *(charPointer + (i * sizeof(char))); // GOOD
  v = *(char *)(voidPointer + i); // GOOD
  v = *(char *)(voidPointer + (i * sizeof(char))); // GOOD
}

void test7(int i) {
  int intArray[10] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
  int *intPointer = intArray;
  char *charPointer = (char *)intArray;
  void *voidPointer = intArray;
  int v;

  v = *(intPointer + i); // GOOD
  v = *(intPointer + (i * sizeof(int))); // BAD: scaled twice by sizeof(int)
  v = *(charPointer + i); // GOOD (actually rather dubious, but this could be correct code)
  v = *(charPointer + (i * sizeof(int))); // GOOD
  v = *(int *)(voidPointer + i); // GOOD (actually rather dubious, but this could be correct code)
  v = *(int *)(voidPointer + (i * sizeof(int))); // GOOD
}
