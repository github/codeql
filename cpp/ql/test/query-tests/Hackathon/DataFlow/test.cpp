int source();
void sink(int);

void test(bool b) {
  int x;
  if(b) {
    x = source();
  }

  int y = 0;
  if(!b) {
    y = x;
  }

  sink(y);
}