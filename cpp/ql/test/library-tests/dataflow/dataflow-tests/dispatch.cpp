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
