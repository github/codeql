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

  int xs[] = {1, 2, 3}; // $ asExpr=1 asExpr=2 asExpr=3 asExpr={...}
  const int ys[] = {[0] = 4, [1] = 5, [0] = 6}; // $ asExpr=4 asExpr=5 asExpr=6 asExpr={...}
}

void test_postfix_crement(int *p, int q) { // $ asParameter=p asParameter=q parameterNode=p parameterNode=q
  p++; // $ asExpr="... ++" asIndirectExpr="... ++" asExpr=p asIndirectExpr=p
  q++; // $ asExpr="... ++" asExpr=q
  (p++); // $ asExpr="... ++" asIndirectExpr="... ++" asExpr="p(... ++)" asIndirectExpr="p(*... ++)"
  (q++); // $ asExpr="... ++" asExpr="q(... ++)"
  (void)(p++); // $ asExpr="p(... ++)" asIndirectExpr="p(*... ++)"
  (void)(q++); // $ asExpr="q(... ++)"
  (void)p++; // $ asExpr="p(... ++)" asIndirectExpr="p(*... ++)"
  (void)q++; // $ asExpr="q(... ++)"
  int *p1 = p++; // $ asExpr="... ++" asIndirectExpr="... ++" asExpr="p(... ++)" asIndirectExpr="p(*... ++)"
  int q1 = q++; // $ asExpr="... ++" asExpr="q(... ++)"
  (int*)(p++); // $ asExpr="... ++" asIndirectExpr="... ++" asExpr="p(... ++)" asIndirectExpr="p(*... ++)"
  (int)(q++); // $ asExpr="... ++" asExpr="q(... ++)"
  int *p2 = (int*)(p++); // $ asExpr="... ++" asIndirectExpr="... ++" asExpr="p(... ++)" asIndirectExpr="p(*... ++)"
  int q2 = (int)(q++); // $ asExpr="... ++" asExpr="q(... ++)"
}

struct Foo {
  void f();
};

struct Derived : Foo {};

void test_qualifiers(
  Foo x, // $ asParameter=x parameterNode=x
  Foo &r, // $ asParameter=r(*r) parameterNode=r(*r)
  Foo *p, // $ asParameter=p parameterNode=p
  Foo *&rp, // $ asParameter=rp(*rp) parameterNode=rp(*rp)
  Derived d, // $ asParameter=d parameterNode=d
  Derived &rd) { // $ asParameter=rd(*rd) parameterNode=rd(*rd)
  x.f(); // $ asExpr=x asIndirectExpr=x
  r.f(); // $ asExpr=r asIndirectExpr=r
  p->f(); // $ asExpr=p asIndirectExpr=p
  (*p).f(); // $ asExpr="* ..." asIndirectExpr="* ..." asExpr="p(* ...)" asIndirectExpr="p(* ...)"
  rp->f(); // $ asExpr=rp asIndirectExpr=rp numberOfIndirectNodes="rp: 2" numberOfNodes="rp: 2"
  (*rp).f(); // $ asExpr="* ..." asIndirectExpr="* ..." asExpr="rp(* ...)" asIndirectExpr="rp(* ...)" asIndirectExpr=rp numberOfIndirectNodes="rp: 2"
  d.f(); // $ asExpr=d asIndirectExpr=d
  rd.f(); // $ asExpr=rd asIndirectExpr=rd
}

void test_inner_glvalue_qualifiers(
  Foo x, // $ asParameter=x parameterNode=x
  Foo &r) { // $ asParameter=r(*r) parameterNode=r(*r)
  Foo arr[2];
  (*&x).f(); // $ asExpr="* ..." asIndirectExpr="* ..." asExpr="& ...(* ...)" asIndirectExpr="& ...(* ...)" asExpr="x(* ...)" asIndirectExpr="x(* ...)"
  (*&r).f(); // $ asExpr="* ..." asIndirectExpr="* ..." asExpr="& ...(* ...)" asIndirectExpr="& ...(* ...)" asExpr="r(* ...)" asIndirectExpr="r(* ...)"
  (*arr).f(); // $ asExpr="* ..." asIndirectExpr="* ..." asExpr="arr(* ...)" asIndirectExpr="arr(* ...)"
}
