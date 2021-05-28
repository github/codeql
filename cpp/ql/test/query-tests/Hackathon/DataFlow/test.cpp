int source();
void sink(int);

void test(int a, int b) {
  int x;
  if(a < b || b > a) {
    x = source();
  }

  int y;
  if(a == b) {
    y = x;
  }

  sink(y);
}