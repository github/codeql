
#include "../shared.h"

typedef unsigned long size_t;

namespace std
{
	template<class charT> struct char_traits;

	typedef size_t streamsize;

	template <class T> class allocator {
	public:
		allocator() throw();
	};
	
	template<class charT, class traits = char_traits<charT>, class Allocator = allocator<charT> >
	class basic_string {
	public:
		explicit basic_string(const Allocator& a = Allocator());
		basic_string(const charT* s, const Allocator& a = Allocator());

		const charT* c_str() const;
	};

	typedef basic_string<char> string;

	template <class charT, class traits = char_traits<charT> >
	class basic_istream /*: virtual public basic_ios<charT,traits> - not needed for this test */ {
	public:
		basic_istream<charT,traits>& operator>>(int& n);
	};

	template <class charT, class traits = char_traits<charT> >
	class basic_ostream /*: virtual public basic_ios<charT,traits> - not needed for this test */ {
	public:
		typedef charT char_type;
		basic_ostream<charT,traits>& write(const char_type* s, streamsize n);

		basic_ostream<charT, traits>& operator<<(int n);
	};

	template<class charT, class traits> basic_ostream<charT,traits>& operator<<(basic_ostream<charT,traits>&, const charT*);
	template<class charT, class traits, class Allocator> basic_ostream<charT, traits>& operator<<(basic_ostream<charT, traits>& os, const basic_string<charT, traits, Allocator>& str);

	template<class charT, class traits = char_traits<charT>>
	class basic_iostream : public basic_istream<charT, traits>, public basic_ostream<charT, traits> {
	public:
	};

	template<class charT, class traits = char_traits<charT>, class Allocator = allocator<charT>>
	class basic_stringstream : public basic_iostream<charT, traits> {
	public:
		explicit basic_stringstream(/*ios_base::openmode which = ios_base::out|ios_base::in - not needed for this test*/);

		basic_string<charT, traits, Allocator> str() const;
	};

	using stringstream = basic_stringstream<char>;
}

char *source() { return getenv("USERDATA"); }
void sink(const std::string &s) {};
void sink(const std::stringstream &s) {};

void test_string()
{
	char *a = source();
	std::string b("123");
	std::string c(source());

	sink(a); // $ ast,ir
	sink(b); // clean
	sink(c); // $ ir MISSING: ast
	sink(b.c_str()); // clean
	sink(c.c_str()); // $ ir MISSING: ast
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
	sink(ss2); // $ ir MISSING: ast
	sink(ss3); // $ ir MISSING: ast
	sink(ss4); // $ ir MISSING: ast
	sink(ss5); // $ ir MISSING: ast
	sink(ss1.str());
	sink(ss2.str()); // $ ir MISSING: ast
	sink(ss3.str()); // $ ir MISSING: ast
	sink(ss4.str()); // $ ir MISSING: ast
	sink(ss5.str()); // $ ir MISSING: ast
}

void test_stringstream_int(int source)
{
	std::stringstream ss1, ss2;

	ss1 << 1234;
	ss2 << source;

	sink(ss1); // clean
	sink(ss2); // $ MISSING: ast,ir
	sink(ss1.str()); // clean
	sink(ss2.str()); // $ MISSING: ast,ir
}

using namespace std;

char *user_input() {
  return source();
}

void sink(const char *filename, const char *mode);

void test_strings2()
{
	string path1 = user_input();
	sink(path1.c_str(), "r"); // $ ir MISSING: ast

	string path2;
	path2 = user_input();
	sink(path2.c_str(), "r"); // $ ir MISSING: ast

	string path3(user_input());
	sink(path3.c_str(), "r"); // $ ir MISSING: ast
}

void test_string3()
{
	const char *cs = source();

	// convert char * -> std::string
	std::string ss(cs);

	sink(cs); // $ ast,ir
	sink(ss); // $ ir MISSING: ast
}

void test_string4()
{
	const char *cs = source();

	// convert char * -> std::string
	std::string ss(cs);

	// convert back std::string -> char *
	cs = ss.c_str();

	sink(cs); // $ ast,ir
	sink(ss); // $ ir MISSING: ast
}
