enum Constants
{
    ONE = 1,
    TWO = 2,
    LARGE = 0xff00,
};

#define SOURCE 1

void sink(int x);

void test_constants() {
  sink(SOURCE | ONE); // $ ir
  sink(SOURCE | TWO); // $ ir
  sink(SOURCE | LARGE); // $ ir

  int x1 = SOURCE | TWO;
  sink(x1); // $ ir

  int x2 = TWO | SOURCE;
  sink(x2); // $ ir

  int x3 = TWO | LARGE;
  sink(x3); // clean

  int x4 = ((SOURCE | ONE) | TWO) | LARGE;
  sink(x4); // $ ir
}