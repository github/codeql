int source();
void sink(int);

// This class has the opposite behavior of what the member function names suggest.
struct Top {
  virtual int isSource1() { return 0; }
  virtual int isSource2() { return 0; }
  virtual void isSink(int x) { }
  virtual int notSource1() { return source(); }
  virtual int notSource2() { return source(); }
  virtual void notSink(int x) { sink(x); }
};

// This class has the correct behavior for just the functions ending in 2.
struct Middle : Top {
  int isSource2() override { return source(); }
  int notSource2() override { return 0; }
};

// This class has all the behavior suggested by the function names.
struct Bottom : Middle {
  int isSource1() override { return source(); }
  void isSink(int x) override { sink(x); }
  int notSource1() override { return 0; }
  void notSink(int x) override { }
};

void VirtualDispatch(Bottom *bottomPtr, Bottom &bottomRef) {
  Top *topPtr = bottomPtr, &topRef = bottomRef;

  sink(topPtr->isSource1()); // flow [NOT DETECTED by AST]
  sink(topPtr->isSource2()); // flow [NOT DETECTED by AST]
  topPtr->isSink(source()); // flow [NOT DETECTED by AST]

  sink(topPtr->notSource1()); // no flow [FALSE POSITIVE]
  sink(topPtr->notSource2()); // no flow [FALSE POSITIVE]
  topPtr->notSink(source()); // no flow [FALSE POSITIVE]

  sink(topRef.isSource1()); // flow [NOT DETECTED by AST]
  sink(topRef.isSource2()); // flow [NOT DETECTED by AST]
  topRef.isSink(source()); // flow [NOT DETECTED by AST]

  sink(topRef.notSource1()); // no flow [FALSE POSITIVE]
  sink(topRef.notSource2()); // no flow [FALSE POSITIVE]
  topRef.notSink(source()); // no flow [FALSE POSITIVE]
}

Top *globalBottom, *globalMiddle;

Top *readGlobalBottom() {
  return globalBottom;
}

void DispatchThroughGlobal() {
  sink(globalBottom->isSource1()); // flow [NOT DETECTED by AST]
  sink(globalMiddle->isSource1()); // no flow

  sink(readGlobalBottom()->isSource1()); // flow [NOT DETECTED by AST]

  globalBottom = new Bottom();
  globalMiddle = new Middle();
}

Top *allocateBottom() {
  return new Bottom();
}

void callSinkByPointer(Top *top) {
  top->isSink(source()); // flow [NOT DETECTED by AST]
}

void callSinkByReference(Top &top) {
  top.isSink(source()); // flow [NOT DETECTED by AST]
}

void globalVirtualDispatch() {
  callSinkByPointer(allocateBottom());
  callSinkByReference(*allocateBottom());

  Top *x = allocateBottom();
  x->isSink(source()); // flow [NOT DETECTED by AST]
}

Top *identity(Top *top) {
  return top;
}

void callIdentityFunctions(Top *top, Bottom *bottom) {
  identity(bottom)->isSink(source()); // flow [NOT DETECTED]
  identity(top)->isSink(source()); // now flow
}

using SinkFunctionType = void (*)(int);

void callSink(int x) {
  sink(x);
}

SinkFunctionType returnCallSink() {
  return callSink;
}

void testFunctionPointer(SinkFunctionType maybeCallSink, SinkFunctionType dontCallSink, bool b) {
  if (b) {
    maybeCallSink = returnCallSink();
  }
  maybeCallSink(source()); // flow [NOT DETECTED by AST]
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

    sink(topPtr->isSource()); // flow [NOT DETECTED]
    sink(topRef.isSource()); // flow [NOT DETECTED]
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
  call_sink_through_union_field_u_f(u2.u.f); // flow [NOT DETECTED]
  call_sink_through_union_field_u_g(u2.u.g); // flow [NOT DETECTED]
}