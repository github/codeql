
#include "stl.h"

using namespace std;

char *source();

void sink(const std::string &s) {};
void sink(const std::stringstream &s) {};

void test_stringstream()
{
	std::stringstream ss1, ss2, ss3, ss4, ss5;
	std::string t(source());

	ss1 << "1234";
	ss2 << source();
	ss3 << "123" << source();
	ss4 << source() << "456";
	ss5 << t;

	sink(ss1);
	sink(ss2); // tainted [NOT DETECTED]
	sink(ss3); // tainted [NOT DETECTED]
	sink(ss4); // tainted [NOT DETECTED]
	sink(ss5); // tainted [NOT DETECTED]
	sink(ss1.str());
	sink(ss2.str()); // tainted [NOT DETECTED]
	sink(ss3.str()); // tainted [NOT DETECTED]
	sink(ss4.str()); // tainted [NOT DETECTED]
	sink(ss5.str()); // tainted [NOT DETECTED]
}

void test_stringstream_int(int source)
{
	std::stringstream ss1, ss2;

	ss1 << 1234;
	ss2 << source;

	sink(ss1);
	sink(ss2); // tainted [NOT DETECTED]
	sink(ss1.str());
	sink(ss2.str()); // tainted [NOT DETECTED]
}
