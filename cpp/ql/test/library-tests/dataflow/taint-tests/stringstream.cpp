
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
	sink(ss2 << source()); // $ ast,ir
	sink(ss3 << "123" << source()); // $ ast,ir
	sink(ss4 << source() << "456"); // $ ast,ir
	sink(ss5 << t); // $ ast,ir

	sink(ss1);
	sink(ss2); // $ ast,ir
	sink(ss3); // $ ast,ir
	sink(ss4); // $ ast,ir
	sink(ss5); // $ ast,ir
	sink(ss1.str());
	sink(ss2.str()); // $ ast,ir
	sink(ss3.str()); // $ ast,ir
	sink(ss4.str()); // $ ast,ir
	sink(ss5.str()); // $ ast,ir

	ss6.str("abc");
	ss6.str(source()); // (overwrites)
	ss7.str(source());
	ss7.str("abc"); // (overwrites)
	sink(ss6); // $ ast,ir
	sink(ss7); // $ SPURIOUS: ast

	sink(ss8.put('a'));
	sink(ss9.put(ns_char::source())); // $ ast,ir
	sink(ss10.put('a').put(ns_char::source()).put('z')); // $ ast,ir
	sink(ss8);
	sink(ss9); // $ ast,ir
	sink(ss10); // $ ast,ir

	sink(ss11.write("begin", 5));
	sink(ss12.write(source(), 5)); // $ ast,ir
	sink(ss13.write("begin", 5).write(source(), amount).write("end", 3)); // $ ast,ir
	sink(ss11);
	sink(ss12); // $ ast,ir
	sink(ss13); // $ ast,ir
}

void test_stringstream_int(int source)
{
	std::stringstream ss1, ss2;
	int v1 = 0, v2 = 0;

	sink(ss1 << 1234);
	sink(ss2 << source); // $ ast,ir
	sink(ss1 >> v1);
	sink(ss2 >> v2); // $ ast,ir

	sink(ss1);
	sink(ss2); // $ ast,ir
	sink(ss1.str());
	sink(ss2.str()); // $ ast,ir
	sink(v1);
	sink(v2); // $ ast,ir
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
	sink(ss6 = std::stringstream(source())); // $ ast,ir

	sink(ss1);
	sink(ss2); // $ ast,ir
	sink(ss3);
	sink(ss4); // $ ast,ir
	sink(ss5);
	sink(ss6); // $ ast,ir
}

void test_stringstream_swap()
{
	std::stringstream ss1("abc");
	std::stringstream ss2(source());
	std::stringstream ss3("abc");
	std::stringstream ss4(source());

	ss1.swap(ss2);
	ss4.swap(ss3);

	sink(ss1); // $ ir
	sink(ss2); // $ SPURIOUS: ast
	sink(ss3); // $ ir
	sink(ss4); // $ SPURIOUS: ast
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
	sink(ss2 << source()); // $ ast,ir

	sink(ss1 >> s1);
	sink(ss2 >> s2); // $ ast,ir
	sink(ss2 >> s3 >> s4); // $ ast,ir
	sink(s1);
	sink(s2); // $ ast,ir
	sink(s3); // $ ast,ir
	sink(s4); // $ ast,ir

	sink(ss1 >> b1);
	sink(ss2 >> b2); // $ ast,ir
	sink(ss2 >> b3 >> b4); // $ ast,ir
	sink(b1);
	sink(b2); // $ ast,ir
	sink(b3); // $ ast,ir
	sink(b4); // $ ast,ir

	sink(ss1.read(b5, 100));
	sink(ss2.read(b6, 100)); // $ ast,ir
	sink(ss1.readsome(b7, 100));
	sink(ss2.readsome(b8, 100)); // (returns a length, not significantly tainted)
	sink(ss1.get(b9, 100));
	sink(ss2.get(b10, 100)); // $ ast,ir
	sink(b5);
	sink(b6); // $ ast,ir
	sink(b7);
	sink(b8); // $ ast,ir
	sink(b9);
	sink(b10); // $ ast,ir

	sink(c1 = ss1.get());
	sink(c2 = ss2.get()); // $ ast,ir
	sink(c3 = ss1.peek());
	sink(c4 = ss2.peek()); // $ ast,ir
	sink(ss1.get(c5));
	sink(ss2.get(c6)); // $ ast,ir
	sink(c1);
	sink(c2); // $ ast,ir
	sink(c3);
	sink(c4); // $ ast,ir
	sink(c5);
	sink(c6); // $ ast,ir
}

void test_stringstream_putback()
{
	std::stringstream ss;

	sink(ss.put('a'));
	sink(ss.get());
	sink(ss.putback('b'));
	sink(ss.get());
	sink(ss.putback(ns_char::source())); // $ ast,ir
	sink(ss.get()); // $ ast,ir
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
	sink(ss2.getline(b2, 1000)); // $ ast,ir
	sink(ss2.getline(b3, 1000)); // $ ast,ir
	sink(ss1.getline(b3, 1000));
	sink(b1);
	sink(b2); // $ ast,ir
	sink(b3); // $ SPURIOUS: ast

	sink(ss1.getline(b4, 1000, ' '));
	sink(ss2.getline(b5, 1000, ' ')); // $ ast,ir
	sink(ss2.getline(b6, 1000, ' ')); // $ ast,ir
	sink(ss1.getline(b6, 1000, ' '));
	sink(b4);
	sink(b5); // $ ast,ir
	sink(b6); // $ SPURIOUS: ast

	sink(ss2.getline(b7, 1000).getline(b8, 1000)); // $ ast,ir
	sink(b7); // $ ast,ir
	sink(b8); // $ ast,ir

	sink(getline(ss1, s1));
	sink(getline(ss2, s2)); // $ ast,ir
	sink(getline(ss2, s3)); // $ ast,ir
	sink(getline(ss1, s3));
	sink(s1);
	sink(s2); // $ ast,ir
	sink(s3); // $ SPURIOUS: ast

	sink(getline(ss1, s4, ' '));
	sink(getline(ss2, s5, ' ')); // $ ast,ir
	sink(getline(ss2, s6, ' ')); // $ ast,ir
	sink(getline(ss1, s6, ' '));
	sink(s4);
	sink(s5); // $ ast,ir
	sink(s6); // $ SPURIOUS: ast

	sink(getline(getline(ss2, s7), s8)); // $ ast,ir
	sink(s7); // $ ast,ir
	sink(s8); // $ ast,ir
}

void test_chaining()
{
	std::stringstream ss1(source());
	std::stringstream ss2;
	char b1[1000] = {0};
	char b2[1000] = {0};

	sink(ss1.get(b1, 100).unget().get(b2, 100)); // $ ast,ir
	sink(b1); // $ ast,ir
	sink(b2); // $ ast,ir

	sink(ss2.write("abc", 3).flush().write(source(), 3).flush().write("xyz", 3)); // $ ast,ir
	sink(ss2); // $ ast,ir
}
