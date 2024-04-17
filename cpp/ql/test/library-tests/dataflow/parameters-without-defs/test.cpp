void sink(int); // $ MISSING: ir
void indirect_sink(int*); // $ MISSING: ir
int source();

void test() {
  int x = source();
  sink(x);

  int* p = &x;
  indirect_sink(p);
}