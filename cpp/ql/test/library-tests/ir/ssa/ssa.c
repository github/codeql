struct Foo { int x[2]; };
void named_designators() {
  struct Foo foo = {.x[0] = 1234, .x[1] = 5678};
}

void repeated_designators() {
  int x[1] = {[0] = 1234, [0] = 5678};
}