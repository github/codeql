
#include "stl.h"

using namespace std;
namespace {
char *source();
}
namespace ns_char
{
	char source();
}

void sink(int i);

void sink(const std::string &s);

template<class charT>
void sink(const std::basic_ostream<charT> &s);

template<class charT>
void sink(const std::basic_istream<charT> &s);

template<class charT>
void sink(const std::basic_iostream<charT> &s);

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
	sink(ss2.str()); // tainted
	sink(ss3.str()); // tainted
	sink(ss4.str()); // tainted
	sink(ss5.str()); // tainted

	ss6.str("abc");
	ss6.str(source()); // (overwrites)
	ss7.str(source());
	ss7.str("abc"); // (overwrites)
	sink(ss6); // tainted
	sink(ss7); // [FALSE POSITIVE]

	sink(ss8.put('a'));
	sink(ss9.put(ns_char::source())); // tainted
	sink(ss10.put('a').put(ns_char::source()).put('z')); // tainted
	sink(ss8);
	sink(ss9); // tainted
	sink(ss10); // tainted

	sink(ss11.write("begin", 5));
	sink(ss12.write(source(), 5)); // tainted
	sink(ss13.write("begin", 5).write(source(), amount).write("end", 3)); // tainted
	sink(ss11);
	sink(ss12); // tainted
	sink(ss13); // tainted
}

void test_stringstream_int(int source)
{
	std::stringstream ss1, ss2;
	int v1 = 0, v2 = 0;

	sink(ss1 << 1234);
	sink(ss2 << source); // tainted
	sink(ss1 >> v1);
	sink(ss2 >> v2); // tainted

	sink(ss1);
	sink(ss2); // tainted
	sink(ss1.str());
	sink(ss2.str()); // tainted
	sink(v1);
	sink(v2); // tainted
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
	sink(ss6 = std::stringstream(source())); // tainted

	sink(ss1);
	sink(ss2); // tainted
	sink(ss3);
	sink(ss4); // tainted
	sink(ss5);
	sink(ss6); // tainted
}

void test_stringstream_swap()
{
	std::stringstream ss1("abc");
	std::stringstream ss2(source());
	std::stringstream ss3("abc");
	std::stringstream ss4(source());

	ss1.swap(ss2);
	ss4.swap(ss3);

	sink(ss1); // tainted
	sink(ss2); // [FALSE POSITIVE]
	sink(ss3); // tainted
	sink(ss4); // [FALSE POSITIVE]
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
	sink(ss2 >> s2); // tainted
	sink(ss2 >> s3 >> s4); // tainted
	sink(s1);
	sink(s2); // tainted
	sink(s3); // tainted
	sink(s4); // tainted

	sink(ss1 >> b1);
	sink(ss2 >> b2); // tainted
	sink(ss2 >> b3 >> b4); // tainted
	sink(b1);
	sink(b2); // tainted
	sink(b3); // tainted
	sink(b4); // tainted

	sink(ss1.read(b5, 100));
	sink(ss2.read(b6, 100)); // tainted
	sink(ss1.readsome(b7, 100));
	sink(ss2.readsome(b8, 100)); // (returns a length, not significantly tainted)
	sink(ss1.get(b9, 100));
	sink(ss2.get(b10, 100)); // tainted
	sink(b5);
	sink(b6); // tainted
	sink(b7);
	sink(b8); // tainted
	sink(b9);
	sink(b10); // tainted

	sink(c1 = ss1.get());
	sink(c2 = ss2.get()); // tainted
	sink(c3 = ss1.peek());
	sink(c4 = ss2.peek()); // tainted
	sink(ss1.get(c5));
	sink(ss2.get(c6)); // tainted
	sink(c1);
	sink(c2); // tainted
	sink(c3);
	sink(c4); // tainted
	sink(c5);
	sink(c6); // tainted
}

void test_stringstream_putback()
{
	std::stringstream ss;

	sink(ss.put('a'));
	sink(ss.get());
	sink(ss.putback('b'));
	sink(ss.get());
	sink(ss.putback(ns_char::source())); // tainted
	sink(ss.get()); // tainted
}

void test_getline()
{
	std::stringstream ss1("abc");
	std::stringstream ss2(source());
	char b1[1000] = {0};
	char b2[1000] = {0};
	char b3[1000] = {0};
	char b4[1000] = {0};
	char b5[1000] = {0};
	char b6[1000] = {0};
	char b7[1000] = {0};
	char b8[1000] = {0};
	std::string s1, s2, s3, s4, s5, s6, s7, s8;

	sink(ss1.getline(b1, 1000));
	sink(ss2.getline(b2, 1000)); // tainted
	sink(ss2.getline(b3, 1000)); // tainted
	sink(ss1.getline(b3, 1000));
	sink(b1);
	sink(b2); // tainted
	sink(b3); // [FALSE POSITIVE]

	sink(ss1.getline(b4, 1000, ' '));
	sink(ss2.getline(b5, 1000, ' ')); // tainted
	sink(ss2.getline(b6, 1000, ' ')); // tainted
	sink(ss1.getline(b6, 1000, ' '));
	sink(b4);
	sink(b5); // tainted
	sink(b6); // [FALSE POSITIVE]

	sink(ss2.getline(b7, 1000).getline(b8, 1000)); // tainted
	sink(b7); // tainted
	sink(b8); // tainted

	sink(getline(ss1, s1));
	sink(getline(ss2, s2)); // tainted
	sink(getline(ss2, s3)); // tainted
	sink(getline(ss1, s3));
	sink(s1);
	sink(s2); // tainted
	sink(s3); // [FALSE POSITIVE]

	sink(getline(ss1, s4, ' '));
	sink(getline(ss2, s5, ' ')); // tainted
	sink(getline(ss2, s6, ' ')); // tainted
	sink(getline(ss1, s6, ' '));
	sink(s4);
	sink(s5); // tainted
	sink(s6); // [FALSE POSITIVE]

	sink(getline(getline(ss2, s7), s8)); // tainted
	sink(s7); // tainted
	sink(s8); // tainted
}

void test_chaining()
{
	std::stringstream ss1(source());
	std::stringstream ss2;
	char b1[1000] = {0};
	char b2[1000] = {0};

	sink(ss1.get(b1, 100).unget().get(b2, 100)); // tainted
	sink(b1); // tainted
	sink(b2); // tainted

	sink(ss2.write("abc", 3).flush().write(source(), 3).flush().write("xyz", 3)); // tainted
	sink(ss2); // tainted
}
