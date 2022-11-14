#include "../shared.h"


struct S {
    void(*f)(const char*);

    void apply(char* p) {
        f(p);
    }

    void (*get())(const char*) {
        return f;
    }
};

void calls_sink_with_argv(const char* a) { // $ ir-path=96:26 ir-path=102:26
    sink(a); // $ ast=96:26 ast=98:18 ir-sink
}

extern int i;

class BaseWithPureVirtual {
public:
    virtual void f(const char*) = 0;
};

class DerivedCallsSink : public BaseWithPureVirtual {
public:
    void f(const char* p) override { // $ ir-path
        sink(p); // $ ast=108:10 ir-sink SPURIOUS: ast=111:10
    }
};

class DerivedDoesNotCallSink : public BaseWithPureVirtual {
public:
    void f(const char* p) override {}
};

class DerivedCallsSinkDiamond1 : virtual public BaseWithPureVirtual {
public:
    void f(const char* p) override { // $ ir-path
        sink(p); // $ ast ir-sink
    }
};

class DerivedDoesNotCallSinkDiamond2 : virtual public BaseWithPureVirtual {
public:
    void f(const char* p) override {}
};

class DerivesMultiple : public DerivedCallsSinkDiamond1, public DerivedDoesNotCallSinkDiamond2 {
    void f(const char* p) override { // $ ir-path=53:37 ir-path=115:11
        DerivedCallsSinkDiamond1::f(p); // $ ir-path
    }
};

template<typename T>
class CRTP {
public:
    void f(const char* p) { // $ ir-path
        static_cast<T*>(this)->g(p); // $ ir-path
    }
};

class CRTPCallsSink : public CRTP<CRTPCallsSink> {
    public:
    void g(const char* p) { // $ ir-path
        sink(p); // $ ast ir-sink
    }
};

class Derived1 : public BaseWithPureVirtual {};

class Derived2 : public Derived1 {
    public:
    void f(const char* p) override {}
};

class Derived3 : public Derived2 {
    public:
    void f(const char* p) override { // $ ir-path=124:19 ir-path=126:43 ir-path=128:44
        sink(p); // $ ast=124:19 ast=126:43 ast=128:44 ir-sink
    }
};

class CRTPDoesNotCallSink : public CRTP<CRTPDoesNotCallSink> {
    public:
    void g(const char* p) {}
};

int main(int argc, char *argv[]) {
    sink(argv[0]); // $ ast,ir-path,ir-sink

    sink(reinterpret_cast<int>(argv)); // $ ast,ir-sink

    calls_sink_with_argv(argv[1]); // $ ast,ir-path

    char*** p = &argv; // $ ast,ir-path

    sink(*p[0]); // $ ast ir-sink=96:26 ir-sink=98:18

    calls_sink_with_argv(*p[i]); // $ ir-path=96:26 ir-path=98:18 MISSING:ast

    sink(*(argv + 1)); // $ ast ir-path ir-sink

    BaseWithPureVirtual* b = new DerivedCallsSink;

    b->f(argv[1]); // $ ast,ir-path

    b = new DerivedDoesNotCallSink;
    b->f(argv[0]); // $ SPURIOUS: ast

    BaseWithPureVirtual* b2 = new DerivesMultiple;

    b2->f(argv[i]); // $ ast,ir-path

    CRTP<CRTPDoesNotCallSink> crtp_not_call_sink;
    crtp_not_call_sink.f(argv[0]); // clean

    CRTP<CRTPCallsSink> crtp_calls_sink;
    crtp_calls_sink.f(argv[0]); // $ ast,ir-path

    Derived1* calls_sink = new Derived3;
    calls_sink->f(argv[1]); // $ ast,ir-path

    static_cast<Derived2*>(calls_sink)->f(argv[1]); // $ ast,ir-path

    dynamic_cast<Derived2*>(calls_sink)->f(argv[1]); // $ ast,ir-path
}