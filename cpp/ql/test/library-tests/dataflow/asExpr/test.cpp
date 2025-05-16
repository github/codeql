void take_const_ref_int(const int &);

void test_materialize_temp_int()
{
  take_const_ref_int(42); // $ asExpr=42 asIndirectExpr=42
}

struct A {};

A get();
void take_const_ref(const A &);

void test1(){
  take_const_ref(get()); // $ asExpr="call to get" asIndirectExpr="call to get"
}

void take_ref(A &);

A& get_ref();

void test2() {
  take_ref(get_ref()); // $ asExpr="call to get_ref" asIndirectExpr="call to get_ref"
}

struct S {
  int a;
  int b;
};

void test_aggregate_literal() {
  S s1 = {1, 2}; // $ asExpr=1 asExpr=2 asExpr={...}
  const S s2 = {3, 4}; // $ asExpr=3 asExpr=4 asExpr={...}
  S s3 = (S){5, 6}; // $ asExpr=5 asExpr=6 asExpr={...}
  const S s4 = (S){7, 8}; // $ asExpr=7 asExpr=8 asExpr={...}

  S s5 = {.a = 1, .b = 2}; // $ asExpr=1 asExpr=2 asExpr={...}

  int xs[] = {1, 2, 3}; // $ asExpr=1 asExpr=2 asExpr=3 MISSING: asExpr={...}
  const int ys[] = {[0] = 4, [1] = 5, [0] = 6}; // $ asExpr=4 asExpr=5 asExpr=6 MISSING: asExpr={...}
}