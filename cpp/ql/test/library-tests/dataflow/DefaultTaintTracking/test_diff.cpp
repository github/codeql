#include "shared.h"


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
    sink(a);
}

extern int i;

class BaseWithPureVirtual {
public:
    virtual void f(const char*) = 0;
};

class DerivedCallsSink : public BaseWithPureVirtual {
public:
    void f(const char* p) override {
        sink(p);
    }
};

class DerivedDoesNotCallSink : public BaseWithPureVirtual {
public:
    void f(const char* p) override {}
};

class DerivedCallsSinkDiamond1 : virtual public BaseWithPureVirtual {
public:
    void f(const char* p) override {
        sink(p);
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
        sink(p);
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
        sink(p);
    }
};

class CRTPDoesNotCallSink : public CRTP<CRTPDoesNotCallSink> {
    public:
    void g(const char* p) {}
};

int main(int argc, char *argv[]) {
    sink(argv[0]);

    sink(reinterpret_cast<int>(argv));

    calls_sink_with_argv(argv[1]);

    char*** p = &argv;

    sink(*p[0]);

    calls_sink_with_argv(*p[i]);

    sink(*(argv + 1));

    BaseWithPureVirtual* b = new DerivedCallsSink;

    b->f(argv[1]);

    b = new DerivedDoesNotCallSink;
    b->f(argv[0]); // no flow [FALSE POSITIVE by AST]

    BaseWithPureVirtual* b2 = new DerivesMultiple;

    b2->f(argv[i]);

    CRTP<CRTPDoesNotCallSink> crtp_not_call_sink;
    crtp_not_call_sink.f(argv[0]);

    CRTP<CRTPCallsSink> crtp_calls_sink;
    crtp_calls_sink.f(argv[0]);

    Derived1* calls_sink = new Derived3;
    calls_sink->f(argv[1]);

    static_cast<Derived2*>(calls_sink)->f(argv[1]);

    dynamic_cast<Derived2*>(calls_sink)->f(argv[1]); // flow [NOT DETECTED by IR]
}