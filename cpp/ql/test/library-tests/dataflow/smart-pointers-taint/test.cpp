#include "memory.h"

int source();
void sink(int);

void test_unique_ptr_int() {
	std::unique_ptr<int> p1(new int(source()));
	std::unique_ptr<int> p2 = std::make_unique<int>(source());
	
	sink(*p1); // $ MISSING: ast,ir
	sink(*p2); // $ ast ir=8:50
}

struct A {
	int x, y;

	A(int x, int y) : x(x), y(y) {}
};

void test_unique_ptr_struct() {
	std::unique_ptr<A> p1(new A{source(), 0});
	std::unique_ptr<A> p2 = std::make_unique<A>(source(), 0);
	
	sink(p1->x); // $ MISSING: ast,ir
	sink(p1->y);
	sink(p2->x); // $ MISSING: ast,ir=22:46
	sink(p2->y);
}

void test_shared_ptr_int() {
	std::shared_ptr<int> p1(new int(source()));
	std::shared_ptr<int> p2 = std::make_shared<int>(source());
	
	sink(*p1); // $ ast MISSING: ir
	sink(*p2); // $ ast ir=32:50 
}

void test_shared_ptr_struct() {
	std::shared_ptr<A> p1(new A{source(), 0});
	std::shared_ptr<A> p2 = std::make_shared<A>(source(), 0);
	
	sink(p1->x); // $ MISSING: ast,ir
	sink(p1->y);
	sink(p2->x); // $ MISSING: ast,ir
	sink(p2->y);
}