int source();
void sink(int); void sink(const int *); void sink(int **); void indirect_sink(...);

void intraprocedural_with_local_flow() {
  int t2;
  int t1 = source();
  sink(t1); // $ ast,ir
  t2 = t1;
  sink(t1); // $ ast,ir
  sink(t2); // $ ast,ir
  if (t1) {
    t2 = 0;
    sink(t2); // clean
  }
  sink(t2); // $ ast,ir

  t1 = 0;
  while (false) {
    t1 = t2;
  }
  sink(t1); // clean (because loop condition is `false`)

  for (int i = 0; i < t1; i++) {
    t1 = t2;
  }
  sink(t1); // $ ast,ir
}

static void callee(int t, int c) {
  sink(t); // $ ast,ir // (from first call in caller() function)
  sink(c); // $ ast,ir // (from second call in caller() function)
}

void caller() {
  callee(source(), 0);
  callee(1, source());
}

void branching(bool b) {
  {
    int t1 = 1, t2 = 2;
    int t = source();
    sink(t ? t1 : t2); // clean

    t = b ? t1 : t2;
    sink(t); // clean
  }

  {
    int t1 = source(), t = 0;
    if (b) {
      t = t1;
    } else {
      t = 1;
    }


    sink(t); // $ ast,ir
  }
}

namespace std {
  template<class T> T&& move(T& t) noexcept; // simplified signature
}

void identityOperations(int* source1) { // $ ast-def=source1 
  const int *x1 = std::move(source1);
  int* x2 = const_cast<int*>(x1);
  int* x3 = (x2);
  const int* x4 = (const int *)x3;
  sink(x4);  // $ ast,ir
}

void trackUninitialized() {
  int u1;
  sink(u1); // $ ast,ir
  u1 = 2;
  sink(u1); // clean

  int i1 = 1;
  sink(i1); // clean

  int u2;
  sink(i1 ? u2 : 1); // $ ast,ir
  i1 = u2;
  sink(i1); // $ ast,ir
}

void local_references(int &source1, int clean1) { // $ ast-def=source1 ir-def=*source1
  sink(source1); // $ ast,ir
  source1 = clean1;
  sink(source1); // clean

  // The next two test cases show that the analysis does not understand the "&"
  // on the type at all. It does not understand that the initialization creates
  // an alias, so it does not understand when two variables change on one
  // assignment. This leads to both overapproximation and underapproximation of
  // flows.
  {
    int t = source();
    int &ref = t;
    t = clean1;
    sink(ref); // $ SPURIOUS: ast,ir
  }

  {
    int t = clean1;
    int &ref = t;
    t = source();
    sink(ref); // $ MISSING: ast,ir
  }
}

int alwaysAssignSource(int *out) { // $ ast-def=out ir-def=*out 
  *out = source();
  return 0;
}

int alwaysAssign0(int *out) { // $ ast-def=out ir-def=*out
  *out = 0;
  return 0;
}

int alwaysAssignInput(int *out, int in) { // $ ast-def=out ir-def=*out
  *out = in;
  return 0;
}
// TODO: call the above

// Tests for flow through functions that return a parameter, or a value obtained from a parameter
// These also test some cases for tracking non-parameter sources returned to a function call

int returnParameter(int p) {
  return p; // considered clean unless the caller passes taint into p, which the analysis will handle separately
}

void callReturnParameter() {
  int x = returnParameter(source());
  int y = x;
  sink(y); // $ ast,ir
}

int returnSourceParameter(int s) {
  sink(s); // $ ast,ir // from line 151
  return s; // considered clean unless the caller passes taint into the parameter source
}

void callReturnSourceParameter() {
  int x = returnSourceParameter(0);
  sink(x); // clean
  int y = returnSourceParameter(source());
  sink(y); // $ ast,ir
}

int returnSourceParameter2(int s) {
  int x = s;
  sink(x); // $ ast,ir // from line 164
  return x; // considered clean unless the caller passes taint into the parameter source
}

void callReturnSourceParameter2() {
  int x = returnSourceParameter2(0);
  sink(x); // clean
  int y = returnSourceParameter2(source());
  sink(y); // $ ast,ir
}

// Tests for non-parameter sources returned to a function call

int returnSource() {
  int x = source(); // taints the return value
  return x;
}

void callReturnSource() {
  int x = returnSource();
  int y = x;
  sink(y); // $ ast,ir
}

// TESTS WITH BARRIERS: none of these should have results

void barrier(...);

class BarrierTests {
  // Tests for flow through functions that return a parameter, or a value obtained from a parameter
  // These also test some cases for tracking non-parameter sources returned to a function call

  int returnParameter(int p) {
    return p; // considered clean unless the caller passes taint into p, which the analysis will handle separately
  }

  void callReturnParameter() {
    int x = returnParameter(source());
    int barrier = x;
    int y = barrier;
    sink(y); // no longer tainted
  }

  int returnSourceParameter(int source) {
    int barrier = source;
    sink(barrier); // no longer tainted
    return barrier; // clean
  }

  void callReturnSourceParameter() {
    int x = returnSourceParameter(0);
    sink(x); // clean
    int y = returnSourceParameter(source());
    sink(y); // no longer tainted
  }

  int returnSourceParameter2(int source) {
    int barrier = source;
    int x = barrier;
    sink(x); // no longer tainted
    return x; // clean
  }

  void callReturnSourceParameter2() {
    int x = returnSourceParameter2(0);
    sink(x); // clean
    int y = returnSourceParameter2(source());
    sink(y); // no longer tainted
  }

  // Tests for non-parameter sources returned to a function call

  int returnSource() {
    int x = source();
    int barrier = x;
    return barrier;
  }

  void callReturnSource() {
    int x = returnSource();
    int y = x;
    sink(y); // no longer tainted
  }
};
// Tests for interprocedural flow (as above) involving nested function calls
namespace NestedTests {
  class FlowIntoParameter {
    void level0() {
      level1(source());
      safelevel1(source());
    }

    void level1(int x) {
      int y = x;
      level2(y);
    }

    void safelevel1(int x) {
      int barrier = x;
      level2(barrier);
      }

    void level2(int x) {
      sink(x); // $ ast,ir // tainted from call to level1() but not from call to safelevel1()
    }
  };
  class FlowThroughFunctionReturn {
    void level0() {
      int x = level1(source());
      sink(x); // $ ast,ir
      x = safelevel1(source());
      sink(x); // no longer tainted
    }

    int level1(int x) {
      int y = x;
      return level2(y);
    }

    int safelevel1(int x) {
      int barrier = x;
      return level2(barrier);
    }

    int level2(int x) {
      int y = x;
      return y;
    }
  };
  class FlowOutOfFunction {
      void level0() {
        int x = level1();
        sink(x); // $ ast,ir
        x = safelevel1();
        sink(x); // no longer tainted
      }

      int level1() {
        int y = level2();
        return y;
      }

      int safelevel1() {
        int barrier = level2();
        return barrier;
      }

      int level2() {
        int y = source();
        return y;
      }

      // the next three functions describe a case that should not be picked up
      // by the flow-out-of-function case, but only by the flow-through-function case
      // a poor heuristic to prevent that will lead to the clean sink being flagged

      void f() {
	g(source());
      }
      void g(int p) {
	int x = h(p);
	sink(x); // $ ast,ir  // tainted from f
	int y = h(0);
	sink(y); // clean
	f();
      }
      int h(int p) {
	return p;
      }
    };
}

namespace FlowThroughGlobals {
  int globalVar;

  void taintGlobal() {
    globalVar = source();
  }

  void f() {
    sink(globalVar); // $ ir=333:17 ir=347:17 // tainted or clean? Not sure.
    taintGlobal();
    sink(globalVar); // $ ir=333:17 ir=347:17 MISSING: ast
  }

  void calledAfterTaint() {
    sink(globalVar); // $ ir=333:17 ir=347:17 MISSING: ast
  }

  void taintAndCall() {
    globalVar = source();
    calledAfterTaint();
    sink(globalVar); // $ ast ir=333:17 ir=347:17
  }
}

// This is similar to FlowThroughGlobals, only with a non-static data member
// instead of a global.
class FlowThroughFields {
  int field = 0;

  void taintField() {
    field = source();
  }

  void f() {
    sink(field); // tainted or clean? Not sure.
    taintField();
    sink(field); // $ ast,ir
  }

  void calledAfterTaint() {
    sink(field); // $ ast,ir
  }

  void taintAndCall() {
    field = source();
    calledAfterTaint();
    sink(field); // $ ast,ir
  }
};

typedef unsigned long size_t;
void *memcpy(void *dest, const void *src, size_t count);

void flowThroughMemcpy_ssa_with_local_flow(int source1) {
  int tmp = 0;
  memcpy(&tmp, &source1, sizeof tmp);
  sink(tmp); // $ ast,ir
}

void flowThroughMemcpy_blockvar_with_local_flow(int source1, int b) {
  int tmp = 0;
  int *capture = &tmp;
  memcpy(&tmp, &source1, sizeof tmp);
  sink(tmp); // $ ast,ir
  if (b) {
    sink(tmp); // $ ast,ir
  }
}

void cleanedByMemcpy_ssa(int clean1) { // currently modeled with BlockVar, not SSA
  int tmp;
  memcpy(&tmp, &clean1, sizeof tmp);
  sink(tmp); // $ SPURIOUS: ast,ir
}

void cleanedByMemcpy_blockvar(int clean1) {
  int tmp;
  int *capture = &tmp;
  memcpy(&tmp, &clean1, sizeof tmp);
  sink(tmp); // $ SPURIOUS: ast,ir
}

void intRefSource(int &ref_source);
void intPointerSource(int *ref_source);
void intArraySource(int ref_source[], size_t len);

void intRefSourceCaller() {
  int local;
  intRefSource(local);
  sink(local); // $ ast,ir=416:7 ast,ir=417:16
}

void intPointerSourceCaller() {
  int local;
  intPointerSource(&local);
  sink(local); // $ ast,ir=422:7 ast,ir=423:20
}






void intPointerSourceCaller2() {
  int local[1];
  intPointerSource(local);
  sink(local); // $ ast=434:20 ir SPURIOUS: ast=433:7
  sink(*local); // $ ast=434:20 ir SPURIOUS: ast=433:7
}

void intArraySourceCaller() {
  int local;
  intArraySource(&local, 1);
  sink(local); // $ ast,ir=440:7 ast,ir=441:18
}

// The IR results for this test _are_ equivalent to the AST ones.
// See the comment on `intPointerSourceCaller2` for an explanation.
void intArraySourceCaller2() {
  int local[2];
  intArraySource(local, 2);
  sink(local); // $ ast=449:18 ir SPURIOUS: ast=448:7
  sink(*local); // $ ast=449:18 ir SPURIOUS: ast=448:7
}

///////////////////////////////////////////////////////////////////////////////

void throughStmtExpr(int source1, int clean1) {
  sink( ({ source1; }) ); // $ ast,ir
  sink( ({ clean1; }) ); // clean

  int local = ({
    int tmp;
    if (clean1)
      tmp = source1;
    else
      tmp = clean1;
    tmp;
  });
  sink(local); // $ ast,ir
}

void intOutparamSource(int *p) { // $ ast-def=p ir-def=*p
  *p = source();
}

void viaOutparam() {
  int x = 0;
  intOutparamSource(&x);
  sink(x); // $ ast,ir
}

void writes_to_content(void*);

struct MyStruct {
  int* content; 
};

void local_field_flow_def_by_ref_steps_with_local_flow(MyStruct * s) { // $ ast-def=s 
  writes_to_content(s->content);
  int* p_content = s->content;
  sink(*p_content);
}

bool unknown();

void regression_with_phi_flow(int clean1) {
  int x = 0;
  while (unknown()) {
    x = clean1;
    if (unknown()) { }
    sink(x); // clean
    x = source();
  }
}

int intOutparamSourceMissingReturn(int *p) { // $ ast-def=p ir-def=*p
  *p = source();
  // return deliberately omitted to test IR dataflow behavior
}

void viaOutparamMissingReturn() {
  int x = 0;
  intOutparamSourceMissingReturn(&x);
  sink(x); // $ ast,ir
}

void uncertain_definition() {
  int stackArray[2];
  int clean = 0;
  stackArray[0] = source();
  stackArray[1] = clean;
  sink(stackArray[0]); // $ ast=519:19 ir SPURIOUS: ast=517:7
}

void set_through_const_pointer(int x, const int **e) // $ ast-def=e ir-def=**e ir-def=*e
{
  *e = &x;
}

void test_set_through_const_pointer(int *e) // $ ast-def=e
{
  set_through_const_pointer(source(), &e);
  sink(*e); // $ ir MISSING: ast
}

void sink_then_source_1(int* p) { // $ ast-def=p ir-def=*p
    sink(*p); // $ ir // Flow from the unitialized x to the dereference.
    *p = source();
}

void sink_then_source_2(int* p, int y) { // $ ast-def=p ir-def=*p
    sink(y); // $ SPURIOUS: ast ir
    *p = source();
}

void test_sink_then_source() {
  {
    int x;
    sink_then_source_1(&x);
  }
  {
    int y;
    sink_then_source_2(&y, y);
  }
}

int* indirect_source();

namespace IndirectFlowThroughGlobals {
  int* globalInt;

  void taintGlobal() {
    globalInt = indirect_source();
  }

  void f() {
    sink(*globalInt); // $ ir=562:17 ir=576:17 MISSING: ast=562:17 ast=576:17
    taintGlobal();
    sink(*globalInt); // $ ir=562:17 ir=576:17 MISSING: ast=562:17 ast=576:17
  }

  void calledAfterTaint() {
    sink(*globalInt); // $ ir=562:17 ir=576:17 MISSING: ast=562:17 ast=576:17
  }

  void taintAndCall() {
    globalInt = indirect_source();
    calledAfterTaint();
    sink(*globalInt); // $ ir=562:17 ir=576:17 MISSING: ast=562:17 ast=576:17
  }
}

void write_to_param(int* x) { // $ ast-def=x
  int s = source();
  x = &s;
}

void test_write_to_param() {
  int x = 0;
  write_to_param(&x);
  sink(x); // $ SPURIOUS: ast
}

void test_indirect_flow_to_array() {
  int* p = indirect_source();
  int* xs[2];
  xs[0] = p;
  sink(*xs[0]); // $ ir MISSING: ast // the IR source is the indirection of `indirect_source()`.
}

void test_def_by_ref_followed_by_uncertain_write_array(int* p) { // $ ast-def=p ir-def=*p
  intPointerSource(p);
  p[10] = 0;
  sink(*p); // $ ir MISSING: ast
}

void test_def_by_ref_followed_by_uncertain_write_pointer(int* p) { // $ ast-def=p ir-def=*p
  intPointerSource(p);
  *p = 0;
  sink(*p); // $ ir MISSING: ast
}

void test_flow_through_void_double_pointer(int *p) // $ ast-def=p
{
  intPointerSource(p);
  void* q = (void*)&p;
  sink(**(int**)q); // $ ir MISSING: ast
}

void use(int *);

void test_def_via_phi_read(bool b)
{
  static int buffer[10]; // This is missing an initialisation in IR dataflow
  if (b)
  {
    use(buffer);
  }
  intPointerSource(buffer);
  indirect_sink(buffer); // $ ast,ir
}

void test_static_local_1() {
  static int x = source();
  sink(x); // $ ast,ir
}

void test_static_local_2() {
  static int x = source();
  x = 0;
  sink(x); // clean
}

void test_static_local_3() {
  static int x = 0;
  sink(x); // $ ir MISSING: ast
  x = source();
}

void test_static_local_4() {
  static int x = 0;
  sink(x); // clean
  x = source();
  x = 0;
}

void test_static_local_5() {
  static int x = 0;
  sink(x); // $ ir MISSING: ast
  x = 0;
  x = source();
}

void test_static_local_6() {
  static int s = source();
  static int* ptr_to_s = &s;
  sink(*ptr_to_s); // $ ir MISSING: ast
}

void test_static_local_7() {
  static int s = source();
  s = 0;
  static int* ptr_to_s = &s;
  sink(*ptr_to_s); // clean
}

void test_static_local_8() {
  static int s;
  static int* ptr_to_s = &s;
  sink(*ptr_to_s); // $ ir MISSING: ast

  s = source();
}

void test_static_local_9() {
  static int s;
  static int* ptr_to_s = &s;
  sink(*ptr_to_s); // clean

  s = source();
  s = 0;
}

void increment_buf(int** buf) { // $ ast-def=buf ir-def=*buf ir-def=**buf
  *buf += 10;
  sink(buf); // $ SPURIOUS: ast
}

void call_increment_buf(int** buf) { // $ ast-def=buf
  increment_buf(buf);
}

void test_conflation_regression(int* source) { // $ ast-def=source
  int* buf = source;
  call_increment_buf(&buf);
}

void write_to_star_star_p(unsigned char **p) // $ ast-def=p ir-def=**p ir-def=*p
{
  **p = 0;
}

void write_to_star_buf(unsigned char *buf) // $ ast-def=buf
{
  unsigned char *c = buf;
  write_to_star_star_p(&c);
}

void test_write_to_star_buf(unsigned char *source) // $ ast-def=source
{
  write_to_star_buf(source);
  sink(*source); // clean
}

void does_not_write_source_to_dereference(int *p) // $ ast-def=p ir-def=*p
{
  int x = source();
  p = &x;
  *p = 42;
}

void test_does_not_write_source_to_dereference()
{
  int x;
  does_not_write_source_to_dereference(&x);
  sink(x); // $ ast,ir=733:7 SPURIOUS: ast,ir=726:11
}

void sometimes_calls_sink_eq(int x, int n) {
  if(n == 0) {
    sink(x); // $ ast,ir=751:27 ast,ir=755:32 SPURIOUS: ast=749:27 ast,ir=753:32 // IR spurious results because we only have call contexts of depth 1
  }
}

void call_sometimes_calls_sink_eq(int x, int n) {
  sometimes_calls_sink_eq(x, n);
}

void test_sometimes_calls_sink_eq_1() {
  sometimes_calls_sink_eq(source(), 1);
  sometimes_calls_sink_eq(0, 0);
  sometimes_calls_sink_eq(source(), 0);

  call_sometimes_calls_sink_eq(source(), 1);
  call_sometimes_calls_sink_eq(0, 0);
  call_sometimes_calls_sink_eq(source(), 0);
}

void sometimes_calls_sink_lt(int x, int n) {
  if(n < 10) {
    sink(x); // $ ast,ir=771:27 ast,ir=775:32 SPURIOUS: ast=769:27 ast,ir=773:32 // IR spurious results because we only have call contexts of depth 1
  }
}

void call_sometimes_calls_sink_lt(int x, int n) {
  sometimes_calls_sink_lt(x, n);
}

void test_sometimes_calls_sink_lt() {
  sometimes_calls_sink_lt(source(), 10);
  sometimes_calls_sink_lt(0, 0);
  sometimes_calls_sink_lt(source(), 2);

  call_sometimes_calls_sink_lt(source(), 10);
  call_sometimes_calls_sink_lt(0, 0);
  call_sometimes_calls_sink_lt(source(), 2);

}

void sometimes_calls_sink_switch(int x, int n) {
  switch(n) {
    case 0:
      sink(x); // $ ast,ir=790:31 SPURIOUS: ast,ir=788:31 // IR spurious results because IRGuard doesn't understand switch statements.
      break;
  }
}

void test_sometimes_calls_sink_switch() {
  sometimes_calls_sink_switch(source(), 1);
  sometimes_calls_sink_switch(0, 0);
  sometimes_calls_sink_switch(source(), 0);
}