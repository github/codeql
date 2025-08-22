// This file tests that data flow cannot survive in a variable past a loop that
// always assigns to this variable.

int source();
void sink(...);
bool random();

void on_entry_test1() {
  int x = source();
  for (int i = 0; i < 10; i++) {
    x = 0;
  }
  sink(x); // $ SPURIOUS: ir
}

void on_entry_test2(int iterations) {
  int x = source();
  for (int i = 0; i < iterations; i++) {
    x = 0;
  }
  sink(x); // $ ast,ir
}

void on_entry_test3() {
  int x = 0;
  for (int i = 0; i < 10; i++) {
    x = source();
  }
  sink(x); // $ ast,ir
}

void on_entry_test4() {
  int x = source();
  for (int i = 0; i < 10; i++) {
    if (random())
      break;
    x = 0;
  }
  sink(x); // $ ast,ir
}

void on_entry_test5() {
  int x = source();
  for (int i = 0; i < 10; i++) {
    if (random())
      continue;
    x = 0;
  }
  sink(x); // $ ast,ir
}

void on_entry_test6() {
  int y;
  int x = source();
  for (int i = 0; i < 10 && (y = 1); i++) {
  }
  sink(x); // $ ast,ir
}

void on_entry_test7() {
  int y;
  int x = source();
  for (int i = 0; i < 10 && (y = 1); i++) {
    x = 0;
  }
  sink(x); // $ SPURIOUS: ir
}

void on_entry_test8() {
  int x = source();
  // It appears to the analysis that the condition can exit after `i < 10`
  // without having assigned to `x`. That is an effect of how the
  // true-upon-entry analysis considers the entire loop condition, while the
  // analysis of where we might jump out of the loop condition considers every
  // jump out of the condition, not just the last one.
  for (int i = 0; i < 10 && (x = 1); i++) {
  }
  sink(x); // $ SPURIOUS: ast,ir
}

void on_entry_test9() {
  int y;
  int x = source();
  for (int i = 0; (y = 1) && i < 10; i++) {
  }
  sink(x); // $ ast,ir
}

void on_entry_test10() {
  int x = source();
  for (int i = 0; (x = 1) && i < 10; i++) {
  }
  sink(x); // no flow
}

void on_entry_test10(int b, int d) {
  int i = 0;
  int x = source();
  if (b)
    goto L;
  for (; i < 10; i += d) {
    x = 0;
    L: ;
  }
  sink(x); // $ ir MISSING: ast
}
