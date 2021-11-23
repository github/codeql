#include "../shared.h"

using SinkFunction = void (*)(int);

void notSink(int notSinkParam);

void callsSink(int sinkParam) { // $ ir-path=31:23 ir-path=32:26 ir-path=34:17
  sink(sinkParam); // $ ast=31:28 ast=32:31 ast=34:22 ir-sink
}

struct {
  SinkFunction sinkPtr, notSinkPtr;
} globalStruct;

union {
  SinkFunction sinkPtr, notSinkPtr;
} globalUnion;

SinkFunction globalSinkPtr;

void assignGlobals() {
  globalStruct.sinkPtr = callsSink;
  globalUnion.sinkPtr = callsSink;
  globalSinkPtr = callsSink;
};

void testStruct() {
  globalStruct.sinkPtr(atoi(getenv("TAINTED"))); // $ MISSING: ir-path,ast
  globalStruct.notSinkPtr(atoi(getenv("TAINTED"))); // clean

  globalUnion.sinkPtr(atoi(getenv("TAINTED"))); // $ ast ir-path
  globalUnion.notSinkPtr(atoi(getenv("TAINTED"))); // $ ast ir-path

  globalSinkPtr(atoi(getenv("TAINTED"))); // $ ast ir-path
}

class B {
    public:
    virtual void f(const char*) = 0;
};

class D1 : public B {};

class D2 : public D1 {
    public:
    void f(const char* p) override {}
};

class D3 : public D2 {
    public:
    void f(const char* p) override { // $ ir-path=58:10 ir-path=60:17 ir-path=61:28 ir-path=62:29 ir-path=63:33 SPURIOUS: ir-path=73:30
        sink(p); // $ ast=58:10 ast=60:17 ast=61:28 ast=62:29 ast=63:33 ir-sink SPURIOUS: ast=73:30
    }
};

void test_dynamic_cast() {
    B* b = new D3();
    b->f(getenv("VAR")); // $ ast ir-path

    ((D2*)b)->f(getenv("VAR")); // $ ast ir-path
    static_cast<D2*>(b)->f(getenv("VAR")); // $ ast ir-path
    dynamic_cast<D2*>(b)->f(getenv("VAR")); // $ ast ir-path
    reinterpret_cast<D2*>(b)->f(getenv("VAR")); // $ ast ir-path

    B* b2 = new D2();
    b2->f(getenv("VAR"));

    ((D2*)b2)->f(getenv("VAR"));
    static_cast<D2*>(b2)->f(getenv("VAR"));
    dynamic_cast<D2*>(b2)->f(getenv("VAR"));
    reinterpret_cast<D2*>(b2)->f(getenv("VAR"));

    dynamic_cast<D3*>(b2)->f(getenv("VAR")); // $ SPURIOUS: ast ir-path
}
