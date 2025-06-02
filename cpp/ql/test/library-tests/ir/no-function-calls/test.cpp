// Test for edge case, where we have a database without any function calls or
// where none of the function calls have any arguments, but where we do have
// a delete expression.

void foo(int* x) {
  delete x;
}

void bar();

void jazz() {
  bar();
}
