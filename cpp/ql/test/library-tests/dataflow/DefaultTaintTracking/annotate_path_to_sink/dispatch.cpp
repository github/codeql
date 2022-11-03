#include "../shared.h"

using SinkFunction = void (*)(int);

void notSink(int notSinkParam);

void callsSink(int sinkParam) {
  sink(sinkParam); // $ ast,ir=31:28 ast,ir=32:31 ast,ir=34:22 MISSING: ast,ir=28
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
  globalStruct.sinkPtr(atoi(getenv("TAINTED"))); // $ MISSING: ast,ir
  globalStruct.notSinkPtr(atoi(getenv("TAINTED"))); // clean

  globalUnion.sinkPtr(atoi(getenv("TAINTED"))); // $ ast,ir
  globalUnion.notSinkPtr(atoi(getenv("TAINTED"))); // $ ast,ir

  globalSinkPtr(atoi(getenv("TAINTED"))); // $ ast,ir
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
    void f(const char* p) override {
        sink(p); // $ ast,ir=58:10 ast,ir=60:17 ast,ir=61:28 ast,ir=62:29 ast,ir=63:33 SPURIOUS: ast,ir=73:30
    }
};

void test_dynamic_cast() {
    B* b = new D3();
    b->f(getenv("VAR")); // $ ast,ir

    ((D2*)b)->f(getenv("VAR")); // $ ast,ir
    static_cast<D2*>(b)->f(getenv("VAR")); // $ ast,ir
    dynamic_cast<D2*>(b)->f(getenv("VAR")); // $ ast,ir
    reinterpret_cast<D2*>(b)->f(getenv("VAR")); // $ ast,ir

    B* b2 = new D2();
    b2->f(getenv("VAR"));

    ((D2*)b2)->f(getenv("VAR"));
    static_cast<D2*>(b2)->f(getenv("VAR"));
    dynamic_cast<D2*>(b2)->f(getenv("VAR"));
    reinterpret_cast<D2*>(b2)->f(getenv("VAR"));

    dynamic_cast<D3*>(b2)->f(getenv("VAR")); // $ SPURIOUS: ast,ir
}
