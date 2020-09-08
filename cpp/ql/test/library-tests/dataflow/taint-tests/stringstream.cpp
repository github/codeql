
#include "stl.h"

using namespace std;

char *source();

namespace ns_char
{
	char source();
}

void sink(int i) {};

void sink(const std::string &s) {};

template<class charT>
void sink(const std::basic_ostream<charT> &s) {};

template<class charT>
void sink(const std::basic_istream<charT> &s) {};

template<class charT>
void sink(const std::basic_iostream<charT> &s) {};

void test_stringstream_string(int amount)
{
	std::stringstream ss1, ss2, ss3, ss4, ss5, ss6, ss7, ss8, ss9, ss10, ss11, ss12, ss13;
	std::string t(source());

	sink(ss1 << "1234");
	sink(ss2 << source()); // tainted
	sink(ss3 << "123" << source()); // tainted
	sink(ss4 << source() << "456"); // tainted
	sink(ss5 << t); // tainted

	sink(ss1);
	sink(ss2); // tainted
	sink(ss3); // tainted
	sink(ss4); // tainted
	sink(ss5); // tainted
	sink(ss1.str());
	sink(ss2.str()); // tainted [NOT DETECTED]
	sink(ss3.str()); // tainted [NOT DETECTED]
	sink(ss4.str()); // tainted [NOT DETECTED]
	sink(ss5.str()); // tainted [NOT DETECTED]

	ss6.str("abc");
	ss6.str(source()); // (overwrites)
	ss7.str(source());
	ss7.str("abc"); // (overwrites)
	sink(ss6); // tainted [NOT DETECTED]
	sink(ss7);

	sink(ss8.put('a'));
	sink(ss9.put(ns_char::source())); // tainted [NOT DETECTED]
	sink(ss10.put('a').put(ns_char::source()).put('z')); // tainted [NOT DETECTED]
	sink(ss8);
	sink(ss9); // tainted [NOT DETECTED]
	sink(ss10); // tainted [NOT DETECTED]

	sink(ss11.write("begin", 5));
	sink(ss12.write(source(), 5)); // tainted [NOT DETECTED]
	sink(ss13.write("begin", 5).write(source(), amount).write("end", 3)); // tainted [NOT DETECTED]
	sink(ss11);
	sink(ss12); // tainted [NOT DETECTED]
	sink(ss13); // tainted [NOT DETECTED]
}

void test_stringstream_int(int source)
{
	std::stringstream ss1, ss2;
	int v1 = 0, v2 = 0;

	sink(ss1 << 1234);
	sink(ss2 << source); // tainted
	sink(ss1 >> v1);
	sink(ss2 >> v2); // tainted [NOT DETECTED]

	sink(ss1);
	sink(ss2); // tainted
	sink(ss1.str());
	sink(ss2.str()); // tainted [NOT DETECTED]
	sink(v1);
	sink(v2); // tainted [NOT DETECTED]
}

void test_stringstream_constructors()
{
	std::string s1 = "abc";
	std::string s2 = source();
	std::stringstream ss1(s1);
	std::stringstream ss2(s2);
	std::stringstream ss3 = std::stringstream("abc");
	std::stringstream ss4 = std::stringstream(source());
	std::stringstream ss5;
	std::stringstream ss6;

	sink(ss5 = std::stringstream("abc"));
	sink(ss6 = std::stringstream(source())); // tainted [NOT DETECTED]

	sink(ss1);
	sink(ss2); // tainted [NOT DETECTED]
	sink(ss3);
	sink(ss4); // tainted [NOT DETECTED]
	sink(ss5);
	sink(ss6); // tainted [NOT DETECTED]
}

void test_stringstream_swap()
{
	std::stringstream ss1("abc");
	std::stringstream ss2(source());
	std::stringstream ss3("abc");
	std::stringstream ss4(source());

	ss1.swap(ss2);
	ss4.swap(ss3);

	sink(ss1); // tainted [NOT DETECTED]
	sink(ss2);
	sink(ss3); // tainted [NOT DETECTED]
	sink(ss4);
}

void test_stringstream_in()
{
	std::stringstream ss1, ss2;
	std::string s1, s2, s3, s4;
	char b1[100] = {0};
	char b2[100] = {0};
	char b3[100] = {0};
	char b4[100] = {0};
	char b5[100] = {0};
	char b6[100] = {0};
	char b7[100] = {0};
	char b8[100] = {0};
	char b9[100] = {0};
	char b10[100] = {0};
	char c1 = 0, c2 = 0, c3 = 0, c4 = 0, c5 = 0, c6 = 0;

	sink(ss1 << "abc");
	sink(ss2 << source()); // tainted

	sink(ss1 >> s1);
	sink(ss2 >> s2); // tainted [NOT DETECTED]
	sink(ss2 >> s3 >> s4); // tainted [NOT DETECTED]
	sink(s1);
	sink(s2); // tainted [NOT DETECTED]
	sink(s3); // tainted [NOT DETECTED]
	sink(s4); // tainted [NOT DETECTED]

	sink(ss1 >> b1);
	sink(ss2 >> b2);
	sink(ss2 >> b3 >> b4);
	sink(b1);
	sink(b2); // tainted [NOT DETECTED]
	sink(b3); // tainted [NOT DETECTED]
	sink(b4); // tainted [NOT DETECTED]

	sink(ss1.read(b5, 100));
	sink(ss2.read(b6, 100)); // tainted [NOT DETECTED]
	sink(ss1.readsome(b7, 100));
	sink(ss2.readsome(b8, 100)); // (returns a length, not significantly tainted)
	sink(ss1.get(b9, 100));
	sink(ss2.get(b10, 100));
	sink(b5);
	sink(b6); // tainted [NOT DETECTED]
	sink(b7);
	sink(b8); // tainted [NOT DETECTED]
	sink(b9);
	sink(b10); // tainted [NOT DETECTED]

	sink(c1 = ss1.get());
	sink(c2 = ss2.get()); // tainted [NOT DETECTED]
	sink(c3 = ss1.peek());
	sink(c4 = ss2.peek()); // tainted [NOT DETECTED]
	sink(ss1.get(c5));
	sink(ss2.get(c6)); // tainted [NOT DETECTED]
	sink(c1);
	sink(c2); // tainted [NOT DETECTED]
	sink(c3);
	sink(c4); // tainted [NOT DETECTED]
	sink(c5);
	sink(c6); // tainted [NOT DETECTED]
}

void test_stringstream_putback()
{
	std::stringstream ss;

	sink(ss.put('a'));
	sink(ss.get());
	sink(ss.putback('b'));
	sink(ss.get());
	sink(ss.putback(ns_char::source())); // tainted [NOT DETECTED]
	sink(ss.get()); // tainted [NOT DETECTED]
}
