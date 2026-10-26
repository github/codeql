struct ArrayDelete {
  ~ArrayDelete();
};

static void f() {
  delete[] (ArrayDelete*)nullptr;
}
