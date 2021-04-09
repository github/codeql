#include "stl.h"

int source();
void sink(int);
void sink(int*);

template<typename T> void sink(std::shared_ptr<T>&);
template<typename T> void sink(std::unique_ptr<T>&);

void test_make_shared() {
    std::shared_ptr<int> p = std::make_shared<int>(source());
    sink(*p); // $ ast MISSING: ir
    sink(p); // $ ast,ir
}

void test_make_shared_array() {
    std::shared_ptr<int[]> p = std::make_shared<int[]>(source());
    sink(*p); // not tainted
    sink(p); // not tainted
}

void test_make_unique() {
    std::unique_ptr<int> p = std::make_unique<int>(source());
    sink(*p); // $ ast MISSING: ir
    sink(p); // $ ast,ir
}

void test_make_unique_array() {
    std::unique_ptr<int[]> p = std::make_unique<int[]>(source());
    sink(*p); // not tainted
    sink(p); // not tainted
}

void test_reverse_taint_shared() {
    std::shared_ptr<int> p = std::make_shared<int>();

    *p = source();
    sink(p); // $ MISSING: ast,ir
    sink(*p); // $ MISSING: ast,ir
}

void test_reverse_taint_unique() {
    std::unique_ptr<int> p = std::unique_ptr<int>();

    *p = source();
    sink(p); // $ MISSING: ast,ir
    sink(*p); // $ MISSING: ast,ir
}

void test_shared_get() {
    std::shared_ptr<int> p = std::make_shared<int>(source());
    sink(p.get()); // $ ast,ir
}

void test_unique_get() {
    std::unique_ptr<int> p = std::make_unique<int>(source());
    sink(p.get()); // $ ast,ir
}

struct A {
    int x, y;
};

void test_shared_field_member() {
    std::unique_ptr<A> p = std::make_unique<A>(source(), 0);
    sink(p->x); // $ MISSING: ast,ir
    sink(p->y); // not tainted
}

struct B {
  A a1;
  A a2;
  int z;
};

void test_operator_arrow(std::unique_ptr<A> p, std::unique_ptr<B> q) {
  p->x = source();
  sink(p->x); // $ ast MISSING: ir
  sink(p->y);

  q->a1.x = source();
  sink(q->a1.x); // $ ast MISSING: ir
  sink(q->a1.y);
  sink(q->a2.x);
}

void taint_x(A* pa) {
    pa->x = source();
}

void reverse_taint_smart_pointer() {
  std::unique_ptr<A> p = std::unique_ptr<A>(new A);
  taint_x(p.get());
  sink(p->x); // $ ast MISSING: ir
}