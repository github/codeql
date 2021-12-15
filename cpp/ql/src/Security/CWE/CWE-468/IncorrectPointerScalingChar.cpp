char example1(int i) {
  int intArray[5] = { 1, 2, 3, 4, 5 };
  char *charPointer = (char *)intArray;
  // BAD: the pointer arithmetic uses type char*, so the offset
  // is not scaled by sizeof(int).
  return *(charPointer + i);
}

int example2(int i) {
  int intArray[10] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
  int *intPointer = intArray;
  // GOOD: the offset is automatically scaled by sizeof(int).
  return *(intPointer + i);
}
