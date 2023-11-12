namespace {
  struct Foo {
    char string[10];
  };

  void acquire(char*);

  Foo* test_self_argument_flow() {
    Foo *info;
    acquire(info->string); // clean

    return info;
  }
}