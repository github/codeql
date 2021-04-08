
#include "stl.h"

using namespace std;

void sink(int);

void test_range_based_for_loop_vector(int source1) {
	// Tainting the vector by allocating a tainted length. This doesn't represent
	// how a vector would typically get tainted, but it allows this test to avoid
	// being concerned with std::vector modeling.
	std::vector<int> v(source1);

	for(int x : v) {
		sink(x); // tainted [NOT DETECTED by IR]
	}

	for(std::vector<int>::iterator it = v.begin(); it != v.end(); ++it) {
		sink(*it); // tainted [NOT DETECTED]
	}

	for(int& x : v) {
		sink(x); // tainted [NOT DETECTED by IR]
	}

	const std::vector<int> const_v(source1);
	for(const int& x : const_v) {
		sink(x); // tainted [NOT DETECTED by IR]
	}
}
