int source();
void sink(int); void sink(const int *); void sink(int **);

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

void identityOperations(int* source1) {
  const int *x1 = std::move(source1);
  int* x2 = const_cast<int*>(x1);
  int* x3 = (x2);
  const int* x4 = (const int *)x3;
  sink(x4);  // $ ast,ir
}

void trackUninitialized() { // NOTE: uninitialized tracking for IR dataflow is deprecated
  int u1;
  sink(u1); // $ ast
  u1 = 2;
  sink(u1); // clean

  int i1 = 1;
  sink(i1); // clean

  int u2;
  sink(i1 ? u2 : 1); // $ ast
  i1 = u2;
  sink(i1); // $ ast
}

void local_references(int &source1, int clean1) {
  sink(source1); // $ ast,ir
  source1 = clean1;
  sink(source1); // $ SPURIOUS: ir

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

int alwaysAssignSource(int *out) {
  *out = source();
  return 0;
}

int alwaysAssign0(int *out) {
  *out = 0;
  return 0;
}

int alwaysAssignInput(int *out, int in) {
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

  int taintGlobal() {
    globalVar = source();
  }

  int f() {
    sink(globalVar); // tainted or clean? Not sure.
    taintGlobal();
    sink(globalVar); // $ MISSING: ast,ir
  }

  int calledAfterTaint() {
    sink(globalVar); // $ MISSING: ast,ir
  }

  int taintAndCall() {
    globalVar = source();
    calledAfterTaint();
    sink(globalVar); // $ ast,ir
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
  sink(tmp); // $ SPURIOUS: ast
}

void cleanedByMemcpy_blockvar(int clean1) {
  int tmp;
  int *capture = &tmp;
  memcpy(&tmp, &clean1, sizeof tmp);
  sink(tmp); // $ SPURIOUS: ast
}

void intRefSource(int &ref_source);
void intPointerSource(int *ref_source);
void intArraySource(int ref_source[], size_t len);

void intRefSourceCaller() {
  int local;
  intRefSource(local);
  sink(local); // $ ast=416:7 ast=417:16 MISSING: ir
}

void intPointerSourceCaller() {
  int local;
  intPointerSource(&local);
  sink(local); // $ ast=422:7 ast=423:20 MISSING: ir
}

void intPointerSourceCaller2() {
  int local[1];
  intPointerSource(local);
  sink(local); // $ ast=428:7 ast=429:20 MISSING: ir
  sink(*local); // $ ast=428:7 ast=429:20 MISSING: ir
}

void intArraySourceCaller() {
  int local;
  intArraySource(&local, 1);
  sink(local); // $ ast=435:7 ast=436:18 MISSING: ir
}

void intArraySourceCaller2() {
  int local[2];
  intArraySource(local, 2);
  sink(local); // $ ast=441:7 ast=442:18 MISSING: ir
  sink(*local); // $ ast=441:7 ast=442:18 MISSING: ir
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

void intOutparamSource(int *p) {
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

void local_field_flow_def_by_ref_steps_with_local_flow(MyStruct * s) {
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
