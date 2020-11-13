
#include "stl.h"

using namespace std;
namespace {
char *source();
}
namespace ns_char
{
	char source();
}

char *user_input() {
  return source();
}

void sink(const char *s);
void sink(const std::string &s);
void sink(const char *filename, const char *mode);
void sink(char);
void sink(std::string::iterator);

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
		sink(*it); // tainted [NOT DETECTED by IR]
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
		sink(s6 += s4); // tainted
		sink(s6); // tainted

		s7 = s3;
		sink(s7 += source()); // tainted
		sink(s7 += " "); // tainted
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

void test_string_assign() {
	std::string s1("hello");
	std::string s2(source());
	char c = ns_char::source();
	std::string s3, s4, s5;
	std::string s6(source());

	sink(s3.assign(s1));
	sink(s3);

	sink(s4.assign(s2)); // tainted
	sink(s4); // tainted

	sink(s5.assign(10, c)); // tainted
	sink(s5); // tainted

	sink(s6.assign(s1));
	sink(s6); // [FALSE POSITIVE]
}

void test_string_insert() {
	std::string s1("hello");
	std::string s2(source());
	char c = ns_char::source();
	std::string s3, s4, s5, s6;

	s3 = s1;
	sink(s3.insert(0, s1));
	sink(s3);

	s4 = s2;
	sink(s4.insert(0, s1)); // tainted
	sink(s4); // tainted

	s5 = s1;
	sink(s5.insert(0, s2)); // tainted
	sink(s5); // tainted

	s6 = s1;
	sink(s6.insert(0, 10, c)); // tainted
	sink(s6); // tainted
}

void test_string_replace() {
	std::string s1("hello");
	std::string s2(source());
	char c = ns_char::source();
	std::string s3, s4, s5, s6;

	s3 = s1;
	sink(s3.replace(1, 2, s1));
	sink(s3);

	s4 = s2;
	sink(s4.replace(1, 2, s1)); // tainted
	sink(s4); // tainted

	s5 = s1;
	sink(s5.replace(1, 2, s2)); // tainted
	sink(s5); // tainted

	s6 = s1;
	sink(s6.replace(1, 2, 10, c)); // tainted
	sink(s6); // tainted
}

void test_string_copy() {
	char b1[1024] = {0};
	char b2[1024] = {0};
	std::string s1("hello");
	std::string s2(source());

	s1.copy(b1, s1.length(), 0);
	sink(b1);

	s2.copy(b2, s1.length(), 0);
	sink(b2); // tainted
}

void test_string_swap() {
	std::string s1("hello");
	std::string s2(source());
	std::string s3("world");
	std::string s4(source());

	sink(s1);
	sink(s2); // tainted
	sink(s3);
	sink(s4); // tainted

	s1.swap(s2);
	s4.swap(s3);

	sink(s1); // tainted
	sink(s2); // [FALSE POSITIVE]
	sink(s3); // tainted
	sink(s4); // [FALSE POSITIVE]
}

void test_string_clear() {
	std::string s1(source());
	std::string s2(source());
	std::string s3(source());

	sink(s1); // tainted
	sink(s2); // tainted
	sink(s3); // tainted

	s1.clear();
	s2 = "";
	s3 = s3;

	sink(s1); // [FALSE POSITIVE]
	sink(s2);
	sink(s3); // tainted
}

void test_string_data()
{
	std::string a("123");
	std::string b(source());

	sink(a.data());
	sink(b.data()); // tainted
	sink(a.length());
	sink(b.length());
}

void test_string_substr()
{
	std::string a("123");
	std::string b(source());

	sink(a.substr(0, a.length()));
	sink(b.substr(0, b.length())); // tainted
}

void test_string_at()
{
	std::string a("123");
	std::string b("123");
	std::string c("123");

	sink(a);
	sink(b);
	sink(c);

	a[0] = ns_char::source();
	b.at(0) = ns_char::source();
	c[0] = a[0];

	sink(a); // tainted
	sink(b); // tainted
	sink(c); // tainted
}

void test_string_data_more()
{
	std::string str("123");

	str.data()[1] = ns_char::source();
	sink(str); // tainted
	sink(str.data()); // tainted
}

void test_string_iterators() {
	// string append
	{
		std::string s1("hello");
		std::string s2(source());
		std::string s3("hello");
		std::string s4("world");

		sink(s1);
		sink(s1.append(s2.begin(), s2.end())); // tainted
		sink(s1); // tainted

		sink(s3);
		sink(s3.append(s4.begin(), s4.end()));
		sink(s3);
	}

	// dereference
	{
		std::string s1("hello");
		std::string s2(source());

		string::iterator iter1 = s1.begin();

		sink(*iter1);
		sink(iter1[1]);
		string::iterator iter2 = s2.begin();

		sink(*iter2); // tainted
		sink(iter2[1]); // tainted
	}

	// arithmetic operators
	{
		std::string s1("hello");
		std::string s2(source());

		string::iterator i1 = s1.begin();

		string::iterator i2 = s2.begin();
		string::iterator i3, i4, i5, i6, i7, i8, i9, i10, i11;

		sink(*(i2+1)); //tainted
		sink(*(i2-1)); // tainted
		i3 = i2;
		sink(*(++i3)); // tainted
		i4 = i2;
		sink(*(--i4)); // tainted
		i5 = i2;
		i5++;
		sink(*i5); // tainted
		i6 = i2;
		i6--;
		sink(*i6); // tainted
		i7 = i2;
		sink(*(i7+=1)); // tainted
		i8 = i2;
		sink(*(i8-=1)); // tainted

		i9 = s2.end();
		--i9;
		sink(*i9); // tainted

		i10 = i2;
		sink(*(i10++)); // tainted
		sink(i10); // tainted
		i11 = i2;
		sink(*(i11--)); // tainted
		sink(i11); // tainted
	}
}

void test_string_insert_more()
{
	std::string s1("aa");
	std::string s2("bb");
	char *cs1 = "cc";
	char *cs2 = source();

	sink(s1.insert(0, cs1));
	sink(s1);

	sink(s2.insert(0, cs2)); // tainted
	sink(s2); // tainted
}

void test_string_iterator_methods()
{
	{
		std::string a("aa");
		std::string b("bb");

		sink(a.insert(a.begin(), 10, 'x'));
		sink(a);

		sink(b.insert(b.begin(), 10, ns_char::source())); // tainted
		sink(b); // tainted
	}

	{
		std::string c("cc");
		std::string d("dd");
		std::string s1("11");
		std::string s2(source());

		sink(c.insert(c.end(), s1.begin(), s1.end()));
		sink(c);

		sink(d.insert(d.end(), s2.begin(), s2.end())); // tainted
		sink(d); // tainted

		sink(s2.insert(s2.end(), s1.begin(), s1.end())); // tainted
		sink(s2); // tainted
	}

	{
		std::string e("ee");
		std::string f("ff");
		std::string s3("33");
		std::string s4(source());

		sink(e.append(s3.begin(), s3.end()));
		sink(e);

		sink(f.append(s4.begin(), s4.end())); // tainted
		sink(f); // tainted

		sink(s4.append(s3.begin(), s3.end())); // tainted
		sink(s4); // tainted
	}

	{
		std::string g("gg");
		std::string h("hh");
		std::string s5("55");
		std::string s6(source());

		sink(g.assign(s5.cbegin(), s5.cend()));
		sink(g);

		sink(h.assign(s6.cbegin(), s6.cend())); // tainted
		sink(h); // tainted

		sink(s6.assign(s5.cbegin(), s5.cend()));
		sink(s6); // [FALSE POSITIVE]
	}
}

void test_string_constructors_more() {
	char *cs1 = "abc";
	char *cs2 = source();
	std::string s1(cs1);
	std::string s2(cs2);
	std::string s3(s1.begin(), s1.end());
	std::string s4(s2.begin(), s2.end());

	sink(s1);
	sink(s2); // tainted
	sink(s3);
	sink(s4); // tainted
}

void test_string_front_back() {
	std::string a("aa");

	sink(a.front());
	sink(a.back());
	a.push_back(ns_char::source());
	sink(a.front()); // [FALSE POSITIVE]
	sink(a.back()); // tainted
}

void test_string_return_assign() {
	{
		std::string a("aa");
		std::string b("bb");
		std::string c("cc");
		std::string d("dd");
		std::string e("ee");
		std::string f("ff");

		sink( a += (b += "bb") );
		sink( c += (d += source()) ); // tainted
		sink( (e += "ee") += source() ); // tainted
		sink( (f += source()) += "ff" ); // tainted
		sink(a);
		sink(b);
		sink(c); // tainted
		sink(d); // tainted
		sink(e); // tainted
		sink(f); // tainted
	}

	{
		std::string a("aa");
		std::string b("bb");
		std::string c("cc");
		std::string d("dd");
		std::string e("ee");
		std::string f("ff");

		sink( a.assign(b.assign("bb")) );
		sink( c.assign(d.assign(source())) ); // tainted
		sink( e.assign("ee").assign(source()) ); // tainted
		sink( f.assign(source()).assign("ff") );
		sink(a);
		sink(b);
		sink(c); // tainted
		sink(d); // tainted
		sink(e); // tainted
		sink(f); // [FALSE POSITIVE]
	}
}
