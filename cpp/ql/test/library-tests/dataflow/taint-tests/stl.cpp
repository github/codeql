
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

char *source();
void sink(const char *s) {};
void sink(const std::string &s) {};
void sink(const std::stringstream &s) {};

void test_string()
{
	char *a = source(); // * source -> sink causes the issue.
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
	std::stringstream ss1, ss2, ss3, ss4;
	std::string t(source());

	ss1 << "1234";
	ss2 << source();
	ss3 << "123" << source();
	ss4 << t;

	sink(ss1);
	sink(ss2); // tainted
	sink(ss3); // tainted
	sink(ss4); // tainted
	sink(ss1.str());
	sink(ss2.str()); // tainted
	sink(ss3.str()); // tainted
	sink(ss4.str()); // tainted
}
