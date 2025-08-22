#include "../../../include/iterator.h"
int source();

template<typename T>
void sink(T);

template<> struct std::iterator_traits<unsigned long>
{   // get traits from integer type
    typedef std::input_iterator_tag iterator_category;
    typedef unsigned long value_type;
    typedef unsigned long difference_type;
    typedef unsigned long distance_type;
    typedef unsigned long * pointer;
    typedef unsigned long& reference;
};


int iterator_test() {
    unsigned long x = source();
    sink(x); // $ ast ir
}