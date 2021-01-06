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

void calls_sink_with_argv(const char* a) {
    sink(a); // $ ast,ir=96:26 ast,ir=98:18
}

extern int i;

class BaseWithPureVirtual {
public:
    virtual void f(const char*) = 0;
};

class DerivedCallsSink : public BaseWithPureVirtual {
public:
    void f(const char* p) override {
        sink(p); // $ ir ast=108:10 SPURIOUS: ast=111:10
    }
};

class DerivedDoesNotCallSink : public BaseWithPureVirtual {
public:
    void f(const char* p) override {}
};

class DerivedCallsSinkDiamond1 : virtual public BaseWithPureVirtual {
public:
    void f(const char* p) override {
        sink(p); // $ ast,ir
    }
};

class DerivedDoesNotCallSinkDiamond2 : virtual public BaseWithPureVirtual {
public:
    void f(const char* p) override {}
};

class DerivesMultiple : public DerivedCallsSinkDiamond1, public DerivedDoesNotCallSinkDiamond2 {
    void f(const char* p) override {
        DerivedCallsSinkDiamond1::f(p);
    }
};

template<typename T>
class CRTP {
public:
    void f(const char* p) {
        static_cast<T*>(this)->g(p);
    }
};

class CRTPCallsSink : public CRTP<CRTPCallsSink> {
    public:
    void g(const char* p) {
        sink(p); // $ ast,ir
    }
};

class Derived1 : public BaseWithPureVirtual {};

class Derived2 : public Derived1 {
    public:
    void f(const char* p) override {}
};

class Derived3 : public Derived2 {
    public:
    void f(const char* p) override {
        sink(p); // $ ast,ir=124:19 ast,ir=126:43 ast,ir=128:44
    }
};

class CRTPDoesNotCallSink : public CRTP<CRTPDoesNotCallSink> {
    public:
    void g(const char* p) {}
};

int main(int argc, char *argv[]) {
    sink(argv[0]); // $ ast,ir

    sink(reinterpret_cast<int>(argv)); // $ ast,ir

    calls_sink_with_argv(argv[1]); // $ ast,ir

    char*** p = &argv; // $ ast,ir

    sink(*p[0]); // $ ast,ir

    calls_sink_with_argv(*p[i]); // $ MISSING: ast,ir

    sink(*(argv + 1)); // $ ast,ir

    BaseWithPureVirtual* b = new DerivedCallsSink;

    b->f(argv[1]); // $ ast,ir

    b = new DerivedDoesNotCallSink;
    b->f(argv[0]); // $ SPURIOUS: ast

    BaseWithPureVirtual* b2 = new DerivesMultiple;

    b2->f(argv[i]); // $ ast,ir

    CRTP<CRTPDoesNotCallSink> crtp_not_call_sink;
    crtp_not_call_sink.f(argv[0]); // clean

    CRTP<CRTPCallsSink> crtp_calls_sink;
    crtp_calls_sink.f(argv[0]); // $ ast,ir

    Derived1* calls_sink = new Derived3;
    calls_sink->f(argv[1]); // $ ast,ir

    static_cast<Derived2*>(calls_sink)->f(argv[1]); // $ ast,ir

    dynamic_cast<Derived2*>(calls_sink)->f(argv[1]); // $ ast,ir
}