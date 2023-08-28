namespace {
  struct Foo {
    char string[10];
  };

  void acquire(char*);

  Foo* test_self_argument_flow() {
    Foo *info;
    acquire(info->string); // $ SPURIOUS: self-arg-flow

    return info;
  }
}