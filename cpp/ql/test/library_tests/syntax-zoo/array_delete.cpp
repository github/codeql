struct Foo {
  ~Foo();
};

void f() {
  delete[] (Foo*)nullptr;
}
