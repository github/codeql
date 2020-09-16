int source();
void sink(int); void sink(const int *); void sink(int **);

void intraprocedural_with_local_flow() {
  int t2;
  int t1 = source();
  sink(t1); // tainted
  t2 = t1;
  sink(t1); // tainted
  sink(t2); // tainted
  if (t1) {
    t2 = 0;
    sink(t2); // clean
  }
  sink(t2); // tainted

  t1 = 0;
  while (false) {
    t1 = t2;
  }
  sink(t1); // clean (because loop condition is `false`)

  for (int i = 0; i < t1; i++) {
    t1 = t2;
  }
  sink(t1); // tainted
}

static void callee(int t, int c) {
  sink(t); // tainted (from first call in caller() function)
  sink(c); // tainted (from second call in caller() function)
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


    sink(t); // tainted
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
  sink(x4);
}

void trackUninitialized() {
  int u1;
  sink(u1); // tainted
  u1 = 2;
  sink(u1); // clean

  int i1 = 1;
  sink(i1); // clean

  int u2;
  sink(i1 ? u2 : 1); // tainted
  i1 = u2;
  sink(i1); // tainted
}

void local_references(int &source1, int clean1) {
  sink(source1); // tainted
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
    sink(ref); // clean (FALSE POSITIVE)
  }

  {
    int t = clean1;
    int &ref = t;
    t = source();
    sink(ref); // tainted (FALSE NEGATIVE)
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
  sink(y); // tainted due to above source
}

int returnSourceParameter(int s) {
  sink(s); // tainted
  return s; // considered clean unless the caller passes taint into the parameter source
}

void callReturnSourceParameter() {
  int x = returnSourceParameter(0);
  sink(x); // clean
  int y = returnSourceParameter(source());
  sink(y); // tainted
}

int returnSourceParameter2(int s) {
  int x = s;
  sink(x); // tainted
  return x; // considered clean unless the caller passes taint into the parameter source
}

void callReturnSourceParameter2() {
  int x = returnSourceParameter2(0);
  sink(x); // clean
  int y = returnSourceParameter2(source());
  sink(y); // tainted
}

// Tests for non-parameter sources returned to a function call

int returnSource() {
  int x = source(); // taints the return value
  return x;
}

void callReturnSource() {
  int x = returnSource();
  int y = x;
  sink(y); // tainted
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
      sink(x); // tainted from call to level1() but not from call to safelevel1()
    }
  };
  class FlowThroughFunctionReturn {
    void level0() {
      int x = level1(source());
      sink(x); // tainted
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
        sink(x); // tainted
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
	sink(x); // tainted from f
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
    sink(globalVar); // tainted (FALSE NEGATIVE)
  }

  int calledAfterTaint() {
    sink(globalVar); // tainted (FALSE NEGATIVE)
  }

  int taintAndCall() {
    globalVar = source();
    calledAfterTaint();
    sink(globalVar); // tainted
  }
}

// This is similar to FlowThroughGlobals, only with a non-static data member
// instead of a global.
class FlowThroughFields {
  int field = 0;

  int taintField() {
    field = source();
  }

  int f() {
    sink(field); // tainted or clean? Not sure.
    taintField();
    sink(field); // tainted [NOT DETECTED with IR]
  }

  int calledAfterTaint() {
    sink(field); // tainted
  }

  int taintAndCall() {
    field = source();
    calledAfterTaint();
    sink(field); // tainted
  }
};

typedef unsigned long size_t;
void *memcpy(void *dest, const void *src, size_t count);

void flowThroughMemcpy_ssa_with_local_flow(int source1) {
  int tmp = 0;
  memcpy(&tmp, &source1, sizeof tmp);
  sink(tmp); // tainted
}

void flowThroughMemcpy_blockvar_with_local_flow(int source1, int b) {
  int tmp = 0;
  int *capture = &tmp;
  memcpy(&tmp, &source1, sizeof tmp);
  sink(tmp); // tainted
  if (b) {
    sink(tmp); // tainted
  }
}

void cleanedByMemcpy_ssa(int clean1) { // currently modeled with BlockVar, not SSA
  int tmp;
  memcpy(&tmp, &clean1, sizeof tmp);
  sink(tmp); // clean [FALSE POSITIVE]
}

void cleanedByMemcpy_blockvar(int clean1) {
  int tmp;
  int *capture = &tmp;
  memcpy(&tmp, &clean1, sizeof tmp);
  sink(tmp); // clean [FALSE POSITIVE]
}

void intRefSource(int &ref_source);
void intPointerSource(int *ref_source);
void intArraySource(int ref_source[], size_t len);

void intRefSourceCaller() {
  int local;
  intRefSource(local);
  sink(local); // tainted
}

void intPointerSourceCaller() {
  int local;
  intPointerSource(&local);
  sink(local); // tainted
}

void intPointerSourceCaller2() {
  int local[1];
  intPointerSource(local);
  sink(local); // tainted
  sink(*local); // tainted
}

void intArraySourceCaller() {
  int local;
  intArraySource(&local, 1);
  sink(local); // tainted
}

void intArraySourceCaller2() {
  int local[2];
  intArraySource(local, 2);
  sink(local); // tainted
  sink(*local); // tainted
}

///////////////////////////////////////////////////////////////////////////////

void throughStmtExpr(int source1, int clean1) {
  sink( ({ source1; }) ); // tainted
  sink( ({ clean1; }) ); // clean

  int local = ({
    int tmp;
    if (clean1)
      tmp = source1;
    else
      tmp = clean1;
    tmp;
  });
  sink(local); // tainted
}

void intOutparamSource(int *p) {
  *p = source();
}

void viaOutparam() {
  int x = 0;
  intOutparamSource(&x);
  sink(x); // tainted
}