#include "stl.h"

int source();
void sink(int);
void sink(int*);

template<typename T> void sink(std::shared_ptr<T>&);
template<typename T> void sink(std::unique_ptr<T>&);

void test_make_shared() {
    std::shared_ptr<int> p = std::make_shared<int>(source());
    sink(*p); // $ ast,ir
    sink(p); // $ ast,ir
}

void test_make_shared_array() {
    std::shared_ptr<int[]> p = std::make_shared<int[]>(source());
    sink(*p); // not tainted
    sink(p); // not tainted
}

void test_make_unique() {
    std::unique_ptr<int> p = std::make_unique<int>(source());
    sink(*p); // $ ast,ir
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
    sink(p); // $ ast,ir
    sink(*p); // $ ast,ir
}

void test_reverse_taint_unique() {
    std::unique_ptr<int> p = std::unique_ptr<int>();

    *p = source();
    sink(p); // $ ast,ir
    sink(*p); // $ ast,ir
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

void getNumber(std::shared_ptr<int> ptr) {
  *ptr = source();
}

int test_from_issue_5190() {
  std::shared_ptr<int> p(new int);
  getNumber(p);
  sink(*p); // $ ast MISSING: ir
}

struct B {
  A a1;
  A a2;
  int z;
};

void test_operator_arrow(std::unique_ptr<A> p, std::unique_ptr<B> q) {
  p->x = source();
  sink(p->x); // $ ast,ir
  sink(p->y);

  q->a1.x = source();
  sink(q->a1.x); // $ ast,ir
  sink(q->a1.y);
  sink(q->a2.x);
}

void taint_x(A* pa) {
    pa->x = source();
}

void reverse_taint_smart_pointer() {
  std::unique_ptr<A> p = std::unique_ptr<A>(new A);
  taint_x(p.get());
  sink(p->x); // $ ast,ir
}

struct C {
	int z;
	std::shared_ptr<A> q;
};

void taint_x_shared(std::shared_ptr<A> ptr) {
	ptr->x = source();
}

void taint_x_shared_cref(const std::shared_ptr<A>& ptr) {
	ptr->x = source();
}

void getNumberCRef(const std::shared_ptr<int>& ptr) {
  *ptr = source();
}

int nested_shared_ptr_taint(std::shared_ptr<C> p1, std::unique_ptr<std::shared_ptr<int>> p2) {
  taint_x_shared(p1->q);
  sink(p1->q->x); // $ ast MISSING: ir

  getNumber(*p2);
  sink(**p2); // $ ast MISSING: ir
}

int nested_shared_ptr_taint_cref(std::shared_ptr<C> p1, std::unique_ptr<std::shared_ptr<int>> p2) {
  taint_x_shared_cref(p1->q);
  sink(p1->q->x); // $ ast,ir

  getNumberCRef(*p2);
  sink(**p2); // $ ast,ir
}