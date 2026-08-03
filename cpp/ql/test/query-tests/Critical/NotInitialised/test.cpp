void test1() {
  int local;
  int x = local; // $ Alert // BAD

  static int static_local;
  int y = static_local; // GOOD

  int initialised = 42;
  int z = initialised; // GOOD
}

int uninitialised_global; // $ Alert // BAD
static int uninitialised_static_global; // GOOD
int initialized_global = 0; // GOOD

void test2() {
  int a = uninitialised_global;
  int b = uninitialised_static_global;
  int c = initialized_global;
}
