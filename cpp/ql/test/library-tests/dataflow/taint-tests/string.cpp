
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
void sink(std::string_view);

void test_string()
{
	char *a = source();
	std::string b("123");
	std::string c(source());

	sink(a); // $ ast,ir
	sink(b);
	sink(c); // $ ast,ir
	sink(b.c_str());
	sink(c.c_str()); // $ ast,ir
}

void test_strings2()
{
	string path1 = user_input();
	sink(path1.c_str(), "r"); // $ ast,ir

	string path2;
	path2 = user_input();
	sink(path2.c_str(), "r"); // $ ast,ir

	string path3(user_input());
	sink(path3.c_str(), "r"); // $ ast,ir
}

void test_string3()
{
	const char *cs = source();

	// convert char * -> std::string
	std::string ss(cs);

	sink(cs); // $ ast,ir
	sink(ss); // $ ast,ir
}

void test_string4()
{
	const char *cs = source();

	// convert char * -> std::string
	std::string ss(cs);

	// convert back std::string -> char *
	cs = ss.c_str();

	sink(cs); // $ ast,ir
	sink(ss); // $ ast,ir
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

		sink(s1); // $ ast,ir
		sink(s2); // $ ast,ir
		sink(s3); // $ ast,ir
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

		sink(s1); // $ ast,ir
		sink(s2); // $ ast,ir
	}
}

void test_range_based_for_loop_string() {
	std::string s(source());
	for(char c : s) {
		sink(c); // $ ast,ir
	}

	for(std::string::iterator it = s.begin(); it != s.end(); ++it) {
		sink(*it); // $ ast,ir
	}

	for(char& c : s) {
		sink(c); // $ ast,ir
	}

	const std::string const_s(source());
	for(const char& c : const_s) {
		sink(c); // $ ast,ir
	}
}

void test_string_append() {
	{
		std::string s1("hello");
		std::string s2(source());

		sink(s1 + s1);
		sink(s1 + s2); // $ ast,ir
		sink(s2 + s1); // $ ast,ir
		sink(s2 + s2); // $ ast,ir
	
		sink(s1 + " world");
		sink(s1 + source()); // $ ast,ir
	}

	{
		std::string s3("abc");
		std::string s4(source());
		std::string s5, s6, s7, s8, s9;

		s5 = s3 + s4;
		sink(s5); // $ ast,ir

		s6 = s3;
		sink(s6 += s4); // $ ast,ir
		sink(s6); // $ ast,ir

		s7 = s3;
		sink(s7 += source()); // $ ast,ir
		sink(s7 += " "); // $ ast,ir
		sink(s7); // $ ast,ir

		s8 = s3;
		s8.append(s4);
		sink(s8); // $ ast,ir

		s9 = s3;
		s9.append(source());
		s9.append(" ");
		sink(s9); // $ ast,ir
	}

	{
		std::string s10("abc");
		char c = ns_char::source();

		s10.append(1, c);
		sink(s10); // $ ast,ir
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

	sink(s4.assign(s2)); // $ ast,ir
	sink(s4); // $ ast,ir

	sink(s5.assign(10, c)); // $ ast,ir
	sink(s5); // $ ast,ir

	sink(s6.assign(s1));
	sink(s6); // $ SPURIOUS: ast
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
	sink(s4.insert(0, s1)); // $ ast,ir
	sink(s4); // $ ast,ir

	s5 = s1;
	sink(s5.insert(0, s2)); // $ ast,ir
	sink(s5); // $ ast,ir

	s6 = s1;
	sink(s6.insert(0, 10, c)); // $ ast,ir
	sink(s6); // $ ast,ir
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
	sink(s4.replace(1, 2, s1)); // $ ast,ir
	sink(s4); // $ ast,ir

	s5 = s1;
	sink(s5.replace(1, 2, s2)); // $ ast,ir
	sink(s5); // $ ast,ir

	s6 = s1;
	sink(s6.replace(1, 2, 10, c)); // $ ast,ir
	sink(s6); // $ ast,ir
}

void test_string_copy() {
	char b1[1024] = {0};
	char b2[1024] = {0};
	std::string s1("hello");
	std::string s2(source());

	s1.copy(b1, s1.length(), 0);
	sink(b1);

	s2.copy(b2, s1.length(), 0);
	sink(b2); // $ ast,ir
}

void test_string_swap() {
	std::string s1("hello");
	std::string s2(source());
	std::string s3("world");
	std::string s4(source());

	sink(s1);
	sink(s2); // $ ast,ir
	sink(s3);
	sink(s4); // $ ast,ir

	s1.swap(s2);
	s4.swap(s3);

	sink(s1); // $ ir
	sink(s2); // $ SPURIOUS: ast
	sink(s3); // $ ir
	sink(s4); // $ SPURIOUS: ast
}

void test_string_clear() {
	std::string s1(source());
	std::string s2(source());
	std::string s3(source());

	sink(s1); // $ ast,ir
	sink(s2); // $ ast,ir
	sink(s3); // $ ast,ir

	s1.clear();
	s2 = "";
	s3 = s3;

	sink(s1); // $ SPURIOUS: ast,ir
	sink(s2);
	sink(s3); // $ ast,ir
}

void test_string_data()
{
	std::string a("123");
	std::string b(source());

	sink(a.data());
	sink(b.data()); // $ ast,ir
	sink(a.length());
	sink(b.length());
}

void test_string_substr()
{
	std::string a("123");
	std::string b(source());

	sink(a.substr(0, a.length()));
	sink(b.substr(0, b.length())); // $ ast,ir
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

	sink(a); // $ ast,ir
	sink(b); // $ ast,ir
	sink(c); // $ ast,ir
}

void test_string_data_more()
{
	std::string str("123");

	str.data()[1] = ns_char::source();
	sink(str); // $ ast,ir
	sink(str.data()); // $ ast,ir
}

void test_string_iterators() {
	// string append
	{
		std::string s1("hello");
		std::string s2(source());
		std::string s3("hello");
		std::string s4("world");

		sink(s1);
		sink(s1.append(s2.begin(), s2.end())); // $ ast,ir
		sink(s1); // $ ast,ir

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

		sink(*iter2); // $ ast,ir
		sink(iter2[1]); // $ ast,ir
	}

	// arithmetic operators
	{
		std::string s1("hello");
		std::string s2(source());

		string::iterator i1 = s1.begin();

		string::iterator i2 = s2.begin();
		string::iterator i3, i4, i5, i6, i7, i8, i9, i10, i11;

		sink(*(i2+1)); // $ ast,ir
		sink(*(i2-1)); // $ ast,ir
		i3 = i2;
		sink(*(++i3)); // $ ast,ir
		i4 = i2;
		sink(*(--i4)); // $ ast,ir
		i5 = i2;
		i5++;
		sink(*i5); // $ ast,ir
		i6 = i2;
		i6--;
		sink(*i6); // $ ast,ir
		i7 = i2;
		sink(*(i7+=1)); // $ ast,ir
		i8 = i2;
		sink(*(i8-=1)); // $ ast,ir

		i9 = s2.end();
		--i9;
		sink(*i9); // $ ast,ir

		i10 = i2;
		sink(*(i10++)); // $ ast,ir
		sink(i10); // $ ast,ir
		i11 = i2;
		sink(*(i11--)); // $ ast,ir
		sink(i11); // $ ast,ir
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

	sink(s2.insert(0, cs2)); // $ ast,ir
	sink(s2); // $ ast,ir
}

void test_string_iterator_methods()
{
	{
		std::string a("aa");
		std::string b("bb");

		sink(a.insert(a.begin(), 10, 'x'));
		sink(a);

		sink(b.insert(b.begin(), 10, ns_char::source())); // $ ast,ir
		sink(b); // $ ast,ir
	}

	{
		std::string c("cc");
		std::string d("dd");
		std::string s1("11");
		std::string s2(source());

		sink(c.insert(c.end(), s1.begin(), s1.end()));
		sink(c);

		sink(d.insert(d.end(), s2.begin(), s2.end())); // $ ast,ir
		sink(d); // $ ast,ir

		sink(s2.insert(s2.end(), s1.begin(), s1.end())); // $ ast,ir
		sink(s2); // $ ast,ir
	}

	{
		std::string e("ee");
		std::string f("ff");
		std::string s3("33");
		std::string s4(source());

		sink(e.append(s3.begin(), s3.end()));
		sink(e);

		sink(f.append(s4.begin(), s4.end())); // $ ast,ir
		sink(f); // $ ast,ir

		sink(s4.append(s3.begin(), s3.end())); // $ ast,ir
		sink(s4); // $ ast,ir
	}

	{
		std::string g("gg");
		std::string h("hh");
		std::string s5("55");
		std::string s6(source());

		sink(g.assign(s5.cbegin(), s5.cend()));
		sink(g);

		sink(h.assign(s6.cbegin(), s6.cend())); // $ ast,ir
		sink(h); // $ ast,ir

		sink(s6.assign(s5.cbegin(), s5.cend()));
		sink(s6); // $ SPURIOUS: ast
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
	sink(s2); // $ ast,ir
	sink(s3);
	sink(s4); // $ ast,ir
}

void test_string_front_back() {
	std::string a("aa");

	sink(a.front());
	sink(a.back());
	a.push_back(ns_char::source());
	sink(a.front()); // $ SPURIOUS: ast,ir
	sink(a.back()); // $ ast,ir
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
		sink( c += (d += source()) ); // $ ast,ir
		sink( (e += "ee") += source() ); // $ ast,ir
		sink( (f += source()) += "ff" ); // $ ast,ir
		sink(a);
		sink(b);
		sink(c); // $ ast,ir
		sink(d); // $ ast,ir
		sink(e); // $ ast,ir
		sink(f); // $ ast,ir
	}

	{
		std::string a("aa");
		std::string b("bb");
		std::string c("cc");
		std::string d("dd");
		std::string e("ee");
		std::string f("ff");

		sink( a.assign(b.assign("bb")) );
		sink( c.assign(d.assign(source())) ); // $ ast,ir
		sink( e.assign("ee").assign(source()) ); // $ ast,ir
		sink( f.assign(source()).assign("ff") );
		sink(a);
		sink(b);
		sink(c); // $ ast,ir
		sink(d); // $ ast,ir
		sink(e); // $ ast,ir
		sink(f); // $ SPURIOUS: ast,ir
	}
}

namespace ns_string_view {
	std::string_view source();
}

void test_string_view_like() {
	std::string_view view = ns_string_view::source();
	std::string constructed(view), sliced(view, 0, 1);
	sink(constructed); // $ ir,ast
	sink(sliced); // $ ir,ast

	std::string assigned, appended, inserted, replaced;
	sink(assigned.assign(view)); // $ ir,ast
	sink(appended.append(view, 0, 1)); // $ ir,ast
	sink(inserted.insert(0, view)); // $ ir,ast
	sink(replaced.replace(0, 0, view)); // $ ir,ast

	char tainted = ns_char::source();
	sink(tainted + std::string("clean")); // $ ast MISSING: ir
}

namespace string_view_tests {

namespace iterators {
struct Iterator {};
Iterator source();
}

namespace ranges {
	struct Range {};
	Range source();
}

void constructors() {
	const char* data = source();
	std::string_view terminated(data);
	sink(terminated); // $ ast,ir
	sink(terminated.data()); // $ MISSING: ir,ast

	std::string_view counted(data, 5);
	sink(counted); // $ MISSING: ir,ast
	sink(counted.data()); // $ MISSING: ir,ast

	std::string_view iterators(data, data + 5);
	sink(iterators); // $ MISSING: ir,ast
}

void copy_and_assignment() {
	const auto original = ns_string_view::source();
	std::string_view copied(original);
	sink(copied); // $ ast,ir
	sink(copied.data()); // $ MISSING: ir,ast
	std::string_view moved(static_cast<const std::string_view&&>(original));
	sink(moved); // $ ast,ir

	std::string_view assigned;
	sink(assigned = original); // $ ast,ir
	sink(assigned); // $ ast,ir

	const std::string_view clean;
	std::string_view chained;
	(chained = clean) = original;
	sink(chained); // $ MISSING: ast,ir

	copied = clean;
	sink(copied); // $ SPURIOUS: ast
}

void iterator_and_range_constructors() {
	iterators::Iterator it = iterators::source();
	std::string_view iterators(it, it);
	sink(iterators); // $ MISSING: ir,ast

	ranges::Range range = ranges::source();
	std::string_view from_range(range);
	sink(from_range); // $ MISSING: ir,ast

	std::vector<char> container;
	container.push_back(ns_char::source());
	std::string_view from_container(container);
	sink(from_container); // $ MISSING: ir
	std::string_view from_container_iterators(container.begin(), container.end());
	sink(from_container_iterators); // $ MISSING: ir
}

void accessors() {
	auto view = ns_string_view::source();
	sink(view.data()); // $ MISSING: ir,ast
	sink(view[0]); // $ MISSING: ir,ast
	sink(view.at(0)); // $ MISSING: ir,ast
	sink(view.front()); // $ MISSING: ir,ast
	sink(view.back()); // $ MISSING: ir,ast
	sink(*view.begin()); // $ ast,ir
	sink(*view.cbegin()); // $ ast,ir
}

void trimming() {
	auto prefix = ns_string_view::source();
	prefix.remove_prefix(1);
	sink(prefix); // $ ast,ir
	sink(prefix.data()); // $ MISSING: ir,ast

	auto suffix = ns_string_view::source();
	suffix.remove_suffix(1);
	sink(suffix); // $ ast,ir
	sink(suffix.data()); // $ MISSING: ir,ast
}

void operations() {
	auto view = ns_string_view::source();
	sink(view.substr(1, 2)); // $ MISSING: ast,ir
	sink(view.subview(1, 2)); // $ MISSING: ast,ir

	char buffer[10] = {};
	sink(view.copy(buffer, 2));
	sink(buffer); // $ MISSING: ast,ir

	std::string_view clean;
	view.swap(clean);
	sink(view); // $ SPURIOUS: ast
	sink(clean); // $ ir MISSING: ast
}
}

void test_string_reverse_flow() {
	{
		std::string s("aa");
		(s = "bb") += source();
		sink(s); // $ ast ir
	}

	{
		std::string s("aa");
		s.front() = ns_char::source();
		sink(s); // $ MISSING: ir,ast
	}

	{
		std::string s("aa");
		s.back() = ns_char::source();
		sink(s); // $ MISSING: ir,ast
	}

	{
		std::string s("aa");
		s.data()[0] = ns_char::source();
		sink(s); // $ ast,ir
	}

	{
		std::string s("aa");
		s.insert(0, "bb") = source();
		sink(s); // $ ast,ir
	}

	{
		std::string s("aa");
		s.append("bb") = source();
		sink(s); // $ ast,ir
	}

	{
		std::string s("aa");
		(s += "bb") = source();
		sink(s); // $ ast,ir
	}

	{
		std::string s("aa");
		s.replace(0, 1, "bb") = source();
		sink(s); // $ ast,ir
	}
}
