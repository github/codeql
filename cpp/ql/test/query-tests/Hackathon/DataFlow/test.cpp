int source();
void sink(int);

void test_false_positive(int a, int b) {
  int x;
  if(a != b) {
    x = source();
  }

  int y;
  if(a == b) {
    y = x;
  }

  sink(y);
}

void test_true_positive(int a, int b, int c) {
  int x;
  if(a == b) {
    x = source();
  }

  int y;
  if(a == b) {
    y = x;
  }

  sink(y);
}