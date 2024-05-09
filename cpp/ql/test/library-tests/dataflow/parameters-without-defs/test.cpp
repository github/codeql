void sink(int); // $ ir
void indirect_sink(int*); // $ ir
int source();

void test() {
  int x = source();
  sink(x);

  int* p = &x;
  indirect_sink(p);
}