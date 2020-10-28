#include "stl.h"

using namespace std;

void sink(int);

class int_iterator_by_typedefs {
public:
    typedef input_iterator_tag iterator_category;
    typedef int value_type;
    typedef size_t difference_type;
    typedef int * pointer;
    typedef int & reference;

    int_iterator_by_typedefs &operator++();
    int_iterator_by_typedefs operator++(int);
    int operator*() const;
};

class int_iterator_by_trait {
public:
    int_iterator_by_trait &operator++();
    int_iterator_by_trait operator++(int);
    int operator*() const;
};

template<>
struct std::iterator_traits<int_iterator_by_trait> {
    typedef input_iterator_tag iterator_category;
};

class non_iterator {
public:
    non_iterator &operator++();
    non_iterator operator++(int);
    int operator*() const;
};

void test_typedefs(int_iterator_by_typedefs source1) {
    sink(*source1); // tainted
    sink(*(source1++)); // tainted
    sink(*(++source1)); // tainted
}

void test_trait(int_iterator_by_trait source1) {
    sink(*source1); // tainted
    sink(*(source1++)); // tainted
    sink(*(++source1)); // tainted
}

void test_non_iterator(non_iterator source1) {
    sink(*source1);
    sink(*(source1++));
    sink(*(++source1));
}

int source();

class insert_iterator_by_trait {
public:
    insert_iterator_by_trait &operator++();
    insert_iterator_by_trait operator++(int);
    insert_iterator_by_trait &operator--();
    insert_iterator_by_trait operator--(int);
    insert_iterator_by_trait operator*();
    insert_iterator_by_trait operator=(int x);
};

template<>
struct std::iterator_traits<insert_iterator_by_trait> {
    typedef output_iterator_tag iterator_category;
};

class container {
public:
    container();
    insert_iterator_by_trait begin();
};

void sink(container);

void test_insert_iterator() {
    container c1, c2;

    insert_iterator_by_trait i1 = c1.begin();
    *i1-- = source();
    sink(c1);

    insert_iterator_by_trait i2 = c2.begin();
    *i2-- = 0;
    sink(c2);
}
