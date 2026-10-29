struct Foo { int x[2]; };
void named_designators() {
  struct Foo foo = {.x[0] = 1234, .x[1] = 5678};
}

void repeated_designators() {
  int x[1] = {[0] = 1234, [0] = 5678};
}

struct Foo2 { int x; int y; };
void named_designators_2() {
  struct Foo2 foo = {.x = 1234, .y = 5678};

  struct Foo2 foo_swapped = {.y = 5678, .x = 1234};
}

void non_repeated_designators() {
  int x[2] = {[0] = 1234, [1] = 5678};

  int y[2] = {[1] = 1234, [0] = 5678};
}

struct Foo_array_and_int {
 int x[2];
 int y;
};

void test_foo_array_and_int() {
  struct Foo_array_and_int f = { .x = {0, 1}, .x[0] = 42, .y = 42 };
}