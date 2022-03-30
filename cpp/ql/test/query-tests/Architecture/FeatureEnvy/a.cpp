
#include "b.h"

void local1(void) { }
void local2(void) { }
void local3(void) { }
void local4(void) { }
void local5(void) { }

void f1(void) {
    g();
    h();
    i();
    j();
    k();
}

void f2(void) {
    local1();
    g();
    h();
    i();
    j();
    k();
}

void f3(void) {
    local1();
    g();
    local2();
    h();
    local3();
    i();
    local4();
    j();
    local5();
    k();
}

void f4(void) {
    local1();
    g();
    h();
    i();
    j();
}

void f5(void) {
    MyClass m;

    m.mg();
    m.mh();
    m.mi();
    m.mj();
    m.mk();
}

