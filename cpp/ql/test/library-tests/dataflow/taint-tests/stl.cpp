
typedef unsigned long size_t;

namespace std
{
	template<class charT> struct char_traits;

	typedef size_t streamsize;

	struct ptrdiff_t;

	template <class iterator_category,
			  class value_type,
			  class difference_type = ptrdiff_t,
			  class pointer_type = value_type*,
			  class reference_type = value_type&>
	struct iterator {
		iterator &operator++();
		iterator operator++(int);
		bool operator==(iterator other) const;
		bool operator!=(iterator other) const;
		reference_type operator*() const;
	};

	struct input_iterator_tag {};
	struct forward_iterator_tag : public input_iterator_tag {};
	struct bidirectional_iterator_tag : public forward_iterator_tag {};
	struct random_access_iterator_tag : public bidirectional_iterator_tag {};

	template <class T> class allocator {
	public:
		allocator() throw();
		typedef size_t size_type;
	};
	
	template<class charT, class traits = char_traits<charT>, class Allocator = allocator<charT> >
	class basic_string {
	public:
		typedef typename Allocator::size_type size_type;

		explicit basic_string(const Allocator& a = Allocator());
		basic_string(const charT* s, const Allocator& a = Allocator());

		const charT* c_str() const;

		typedef std::iterator<random_access_iterator_tag, charT> iterator;
		typedef std::iterator<random_access_iterator_tag, const charT> const_iterator;

		iterator begin();
		iterator end();
		const_iterator begin() const;
		const_iterator end() const;
		const_iterator cbegin() const;
		const_iterator cend() const;

		template<class T> basic_string& operator+=(const T& t);
		basic_string& operator+=(const charT* s);
		basic_string& append(const basic_string& str);
		basic_string& append(const charT* s);
		basic_string& append(size_type n, charT c);
	};

	template<class charT, class traits, class Allocator> basic_string<charT, traits, Allocator> operator+(const basic_string<charT, traits, Allocator>& lhs, const basic_string<charT, traits, Allocator>& rhs);
	template<class charT, class traits, class Allocator> basic_string<charT, traits, Allocator> operator+(const basic_string<charT, traits, Allocator>& lhs, const charT* rhs);

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

char *source();
void sink(const char *s) {};
void sink(const std::string &s) {};
void sink(const std::stringstream &s) {};

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

using namespace std;

char *user_input() {
  return source();
}

void sink(const char *filename, const char *mode);

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

void sink(char) {}

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








namespace std {
	template <class T>
	class vector {
	private:
		void *data_;
	public:
		vector(int size);

		T& operator[](int idx);
		const T& operator[](int idx) const;

		typedef std::iterator<random_access_iterator_tag, T> iterator;
		typedef std::iterator<random_access_iterator_tag, const T> const_iterator;

		iterator begin() noexcept;
		iterator end() noexcept;

		const_iterator begin() const noexcept;
		const_iterator end() const noexcept;
	};
}

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

namespace ns_char
{
	char source();
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
}
