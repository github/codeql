// Semmle test cases for rule CWE-497

// library functions etc

char *getenv(const char *name);

namespace std
{
	template<class charT> struct char_traits;

	template <class charT, class traits = char_traits<charT> >
	class basic_ostream /*: virtual public basic_ios<charT,traits> - not needed for this test */ {
	public: 
	};

	template<class charT, class traits> basic_ostream<charT,traits>& operator<<(basic_ostream<charT,traits>&, const charT*);

	typedef basic_ostream<char> ostream;

	extern ostream cout;
}

// test cases

void test1()
{
	std::cout << getenv("HOME"); // BAD: outputs HOME environment variable
	std::cout << "PATH = " << getenv("PATH") << "."; // BAD: outputs PATH environment variable
	std::cout << "PATHPATHPATH"; // GOOD: not system data
}
