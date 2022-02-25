void sink(void *o);
void *user_input(void);

void local_array() {
  void *arr[10] = { 0 };
  arr[0] = user_input();
  sink(arr[0]); // $ ast,ir
  sink(arr[1]); // $ SPURIOUS: ast,ir
  sink(*arr); // $ ast,ir
  sink(*&arr[0]); // $ ast,ir
}

void local_array_convoluted_assign() {
  void *arr[10] = { 0 };
  *&arr[0] = user_input();
  sink(arr[0]); // $ ast,ir
  sink(arr[1]); // $ SPURIOUS: ast,ir
}

struct inner {
  void *data;
  int unrelated;
};

struct middle {
  inner arr[10];
  inner *ptr;
};

struct outer {
  middle nested;
  middle *indirect;
};

void nested_array_1(outer o) {
  o.nested.arr[1].data = user_input();
  sink(o.nested.arr[1].data); // $ ast,ir
  sink(o.nested.arr[0].data); // $ SPURIOUS: ast,ir
}

void nested_array_2(outer o) {
  o.indirect->arr[1].data = user_input();
  sink(o.indirect->arr[1].data); // $ ast,ir
  sink(o.indirect->arr[0].data); // $ SPURIOUS: ast,ir
}

void nested_array_3(outer o) {
  o.indirect->ptr[1].data = user_input();
  sink(o.indirect->ptr[1].data); // $ ir MISSING: ast
  sink(o.indirect->ptr[0].data); // $ SPURIOUS: ir
}
