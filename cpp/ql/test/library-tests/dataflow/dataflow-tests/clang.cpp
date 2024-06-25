// semmle-extractor-options: --clang

int source();
void sink(int); void sink(const int *); void sink(int **); void indirect_sink(...);

struct twoIntFields {
  int m1, m2;
  int getFirst() { return m1; }
};

void following_pointers( // $ ast-def=sourceStruct1_ptr ir-def=*cleanArray1 ir-def=*sourceArray1 ir-def=*sourceStruct1_ptr
    int sourceArray1[],
    int cleanArray1[],
    twoIntFields sourceStruct1,
    twoIntFields *sourceStruct1_ptr,
    int (*sourceFunctionPointer)())
{
  sink(sourceArray1); // $ ast,ir

  sink(sourceArray1[0]); // no flow
  sink(*sourceArray1); // no flow
  sink(&sourceArray1); // $ ast // [should probably be taint only]
  indirect_sink(&sourceArray1); // $ ast,ir

  sink(sourceStruct1.m1); // no flow
  sink(sourceStruct1_ptr->m1); // no flow
  sink(sourceStruct1_ptr->getFirst()); // no flow

  sourceStruct1_ptr->m1 = source();
  sink(sourceStruct1_ptr->m1); // $ ast,ir
  sink(sourceStruct1_ptr->getFirst()); // $ ast,ir
  sink(sourceStruct1_ptr->m2); // no flow
  sink(sourceStruct1.m1); // no flow

  twoIntFields s = { source(), source() };


  sink(s.m2); // $ ast,ir

  twoIntFields sArray[1] = { { source(), source() } };
  // TODO: fix this like above
  sink(sArray[0].m2); // $ ir MISSING: ast

  twoIntFields sSwapped = { .m2 = source(), .m1 = 0 };

  sink(sSwapped.m2); // $ ast,ir

  sink(sourceFunctionPointer()); // no flow

  int stackArray[2] = { source(), source() };
  stackArray[0] = source();
  sink(stackArray); // $ ast,ir
  indirect_sink(stackArray); // $ ast ir=50:25 ir=50:35 ir=51:19
}

void test_bitcast() {
  unsigned long x = source();
  double d = __builtin_bit_cast(double, x);
  sink(d); // $ ir MISSING: ast
}