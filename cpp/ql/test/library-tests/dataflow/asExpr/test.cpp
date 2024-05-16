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
