
int myTarget(int);

int call(int (*target)(int), int val) {
  return target(val);
}

void testFunctionAccess() {
  int (*myFunctionPointer)(int) = &myTarget; // FunctionAccess

  call(myFunctionPointer, 1);
  call(myTarget, 2); // FunctionAccess
  (&myTarget)(3); // FunctionAccess
}
