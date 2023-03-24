#include "memory.h"

int source();
void sink(int);

void test_unique_ptr_int() {
	std::unique_ptr<int> p1(new int(source()));
	std::unique_ptr<int> p2 = std::make_unique<int>(source());
	
	sink(*p1); // $ ir MISSING: ast
	sink(*p2); // $ ast ir
}

struct A {
	int x, y;

	A(int x, int y) : x(x), y(y) {}
};

void test_unique_ptr_struct() {
	std::unique_ptr<A> p1(new A{source(), 0});
	std::unique_ptr<A> p2 = std::make_unique<A>(source(), 0);
	
	sink(p1->x); // $ ir MISSING: ast
	sink(p1->y);
	sink(p2->x); // $ ir MISSING: ast
	sink(p2->y);
}

void test_shared_ptr_int() {
	std::shared_ptr<int> p1(new int(source()));
	std::shared_ptr<int> p2 = std::make_shared<int>(source());
	
	sink(*p1); // $ ast,ir
	sink(*p2); // $ ast ir
}

void test_shared_ptr_struct() {
	std::shared_ptr<A> p1(new A{source(), 0});
	std::shared_ptr<A> p2 = std::make_shared<A>(source(), 0);
	
	sink(p1->x); // $ MISSING: ast,ir
	sink(p1->y);
	sink(p2->x); // $ MISSING: ast,ir
	sink(p2->y);
}