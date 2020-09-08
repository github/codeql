#include "stl.h"

int source();
void sink(int);
void sink(int*);

template<typename T> void sink(std::shared_ptr<T>&);
template<typename T> void sink(std::unique_ptr<T>&);

void test_make_shared() {
    std::shared_ptr<int> p = std::make_shared<int>(source());
    sink(*p); // tainted
    sink(p); // tainted
}

void test_make_shared_array() {
    std::shared_ptr<int[]> p = std::make_shared<int[]>(source());
    sink(*p); // not tainted
    sink(p); // not tainted
}

void test_make_unique() {
    std::unique_ptr<int> p = std::make_unique<int>(source());
    sink(*p); // tainted
    sink(p); // tainted
}

void test_make_unique_array() {
    std::unique_ptr<int[]> p = std::make_unique<int[]>(source());
    sink(*p); // not tainted
    sink(p); // not tainted
}

void test_reverse_taint_shared() {
    std::shared_ptr<int> p = std::make_shared<int>();

    *p = source();
    sink(p); // tainted [NOT DETECTED]
    sink(*p); // tainted [NOT DETECTED]
}

void test_reverse_taint_unique() {
    std::unique_ptr<int> p = std::unique_ptr<int>();

    *p = source();
    sink(p); // tainted [NOT DETECTED]
    sink(*p); // tainted [NOT DETECTED]
}