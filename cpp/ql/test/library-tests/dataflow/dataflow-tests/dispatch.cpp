int source();
void sink(int);

// This class has the opposite behavior of what the member function names suggest.
struct Top {
  virtual int isSource1() { return 0; }
  virtual int isSource2() { return 0; }
  virtual void isSink(int x) { }
  virtual int notSource1() { return source(); }
  virtual int notSource2() { return source(); }
  virtual void notSink(int x) { sink(x); } // $ SPURIOUS: ast,ir=37:19 ast,ir=45:18
};

// This class has the correct behavior for just the functions ending in 2.
struct Middle : Top {
  int isSource2() override { return source(); }
  int notSource2() override { return 0; }
};

// This class has all the behavior suggested by the function names.
struct Bottom : Middle {
  int isSource1() override { return source(); }
  void isSink(int x) override { sink(x); } // $ ir=33:18 ir=41:17 ir=69:15 ir=73:14 ir=81:13 MISSING: ast=33:18 ast=41:17 ast=69:15 ast=73:14 ast=81:13
  int notSource1() override { return 0; }
  void notSink(int x) override { }
};

void VirtualDispatch(Bottom *bottomPtr, Bottom &bottomRef) {
  Top *topPtr = bottomPtr, &topRef = bottomRef;

  sink(topPtr->isSource1()); // $ ir MISSING: ast
  sink(topPtr->isSource2()); // $ ir MISSING: ast
  topPtr->isSink(source()); // causing a MISSING for ast

  sink(topPtr->notSource1()); // $ SPURIOUS: ast,ir
  sink(topPtr->notSource2()); // $ SPURIOUS: ast,ir
  topPtr->notSink(source()); // causing SPURIOUS for ast,ir

  sink(topRef.isSource1()); // $ ir MISSING: ast
  sink(topRef.isSource2()); // $ ir MISSING: ast
  topRef.isSink(source()); // causing a MISSING for ast

  sink(topRef.notSource1()); // $ SPURIOUS: ast,ir
  sink(topRef.notSource2()); // $ SPURIOUS: ast,ir
  topRef.notSink(source()); // causing SPURIOUS for ast,ir
}

Top *globalBottom, *globalMiddle;

Top *readGlobalBottom() {
  return globalBottom;
}

void DispatchThroughGlobal() {
  sink(globalBottom->isSource1()); // $ ir MISSING: ast
  sink(globalMiddle->isSource1()); // no flow

  sink(readGlobalBottom()->isSource1()); // $ ir MISSING: ast

  globalBottom = new Bottom();
  globalMiddle = new Middle();
}

Top *allocateBottom() {
  return new Bottom();
}

void callSinkByPointer(Top *top) {
  top->isSink(source()); // leads to MISSING from ast
}

void callSinkByReference(Top &top) {
  top.isSink(source()); // leads to MISSING from ast
}

void globalVirtualDispatch() {
  callSinkByPointer(allocateBottom());
  callSinkByReference(*allocateBottom());

  Top *x = allocateBottom();
  x->isSink(source()); // $ MISSING: ast,ir
}

Top *identity(Top *top) {
  return top;
}

void callIdentityFunctions(Top *top, Bottom *bottom) {
  identity(bottom)->isSink(source()); // $ MISSING: ast,ir
  identity(top)->isSink(source()); // now flow
}

using SinkFunctionType = void (*)(int);

void callSink(int x) {
  sink(x); // $ ir=107:17 ir=140:8 ir=144:8 MISSING: ast=107:17 ast=140:8 ast=144:8
}

SinkFunctionType returnCallSink() {
  return callSink;
}

void testFunctionPointer(SinkFunctionType maybeCallSink, SinkFunctionType dontCallSink, bool b) {
  if (b) {
    maybeCallSink = returnCallSink();
  }
  maybeCallSink(source());
  dontCallSink(source()); // no flow
}

namespace virtual_inheritance {
  struct Top {
    virtual int isSource() { return 0; }
  };

  struct Middle : virtual Top {
    int isSource() override { return source(); }
  };

  struct Bottom : Middle {
  };

  void VirtualDispatch(Bottom *bottomPtr, Bottom &bottomRef) {
    // Because the inheritance from `Top` is virtual, the following casts go
    // directly from `Bottom` to `Top`, skipping `Middle`. That means we don't
    // get flow from a `Middle` value to the call qualifier.
    Top *topPtr = bottomPtr, &topRef = bottomRef;

    sink(topPtr->isSource()); // $ MISSING: ast,ir
    sink(topRef.isSource()); // $ MISSING: ast,ir
  }
}

union union_with_sink_fun_ptrs {
  SinkFunctionType f;
  SinkFunctionType g;
} u;

void call_sink_through_union_field_f(SinkFunctionType func) {
  func(source());
}

void call_sink_through_union_field_g(SinkFunctionType func) {
  func(source());
}

void set_global_union_field_f() {
  u.f = callSink;
}

void test_call_sink_through_union() {
  set_global_union_field_f();
  call_sink_through_union_field_f(u.f);
  call_sink_through_union_field_g(u.g);
}

union { union_with_sink_fun_ptrs u; } u2;

void call_sink_through_union_field_u_g(SinkFunctionType func) {
  func(source());
}

void call_sink_through_union_field_u_f(SinkFunctionType func) {
  func(source());
}

void set_global_union_field_u_f() {
  u2.u.f = callSink;
}

void test_call_sink_through_union_2() {
  set_global_union_field_u_f();
  call_sink_through_union_field_u_f(u2.u.f); // $ MISSING: ast,ir
  call_sink_through_union_field_u_g(u2.u.g); // $ MISSING: ast,ir
}