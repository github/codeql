
#include "stl.h"

using namespace std;

char *source();

namespace ns_char
{
	char source();
}

char *user_input() {
  return source();
}

void sink(const char *s) {};
void sink(const std::string &s) {};
void sink(const std::stringstream &s) {};
void sink(const char *filename, const char *mode);
void sink(char) {}

void test_string()
{
	char *a = source();
	std::string b("123");
	std::string c(source());

	sink(a); // tainted
	sink(b);
	sink(c); // tainted
	sink(b.c_str());
	sink(c.c_str()); // tainted
}

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

void test_strings2()
{
	string path1 = user_input();
	sink(path1.c_str(), "r"); // tainted

	string path2;
	path2 = user_input();
	sink(path2.c_str(), "r"); // tainted

	string path3(user_input());
	sink(path3.c_str(), "r"); // tainted
}

void test_string3()
{
	const char *cs = source();

	// convert char * -> std::string
	std::string ss(cs);

	sink(cs); // tainted
	sink(ss); // tainted
}

void test_string4()
{
	const char *cs = source();

	// convert char * -> std::string
	std::string ss(cs);

	// convert back std::string -> char *
	cs = ss.c_str();

	sink(cs); // tainted
	sink(ss); // tainted
}

void test_string_constructors_assignments()
{
	{
		std::string s1("hello");
		std::string s2 = "hello";
		std::string s3;
		s3 = "hello";

		sink(s1);
		sink(s2);
		sink(s3);
	}

	{
		std::string s1(source());
		std::string s2 = source();
		std::string s3;
		s3 = source();

		sink(s1); // tainted
		sink(s2); // tainted
		sink(s3); // tainted
	}

	{
		std::string s1;
		std::string s2 = s1;
		std::string s3;
		s3 = s1;

		sink(s1);
		sink(s2);
		sink(s3);
	}

	{
		std::string s1 = std::string(source());
		std::string s2;
		s2 = std::string(source());

		sink(s1); // tainted
		sink(s2); // tainted
	}
}

void test_range_based_for_loop_string() {
	std::string s(source());
	for(char c : s) {
		sink(c); // tainted [NOT DETECTED by IR]
	}

	for(std::string::iterator it = s.begin(); it != s.end(); ++it) {
		sink(*it); // tainted [NOT DETECTED]
	}

	for(char& c : s) {
		sink(c); // tainted [NOT DETECTED by IR]
	}

	const std::string const_s(source());
	for(const char& c : const_s) {
		sink(c); // tainted [NOT DETECTED by IR]
	}
}

void test_string_append() {
	{
		std::string s1("hello");
		std::string s2(source());

		sink(s1 + s1);
		sink(s1 + s2); // tainted
		sink(s2 + s1); // tainted
		sink(s2 + s2); // tainted
	
		sink(s1 + " world");
		sink(s1 + source()); // tainted
	}

	{
		std::string s3("abc");
		std::string s4(source());
		std::string s5, s6, s7, s8, s9;

		s5 = s3 + s4;
		sink(s5); // tainted

		s6 = s3;
		s6 += s4;
		sink(s6); // tainted

		s7 = s3;
		s7 += source();
		s7 += " ";
		sink(s7); // tainted

		s8 = s3;
		s8.append(s4);
		sink(s8); // tainted

		s9 = s3;
		s9.append(source());
		s9.append(" ");
		sink(s9); // tainted
	}

	{
		std::string s10("abc");
		char c = ns_char::source();

		s10.append(1, c);
		sink(s10); // tainted
	}
}
