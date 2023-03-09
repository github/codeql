struct ArrayDelete {
  ~ArrayDelete();
};

void f() {
  delete[] (ArrayDelete*)nullptr;
}
