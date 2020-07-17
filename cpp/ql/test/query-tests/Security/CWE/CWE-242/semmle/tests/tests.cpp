// Semmle tests for rule CWE-242.

// library types, functions etc
char *gets(char *s);
typedef unsigned int FILE;

typedef unsigned long size_t;

namespace std
{
	// --- std::string ---

	// std::char_traits
	template<class charT> class char_traits;

	// std::allocator
	template <class T> class allocator {
	public:
		allocator() throw();
	};

	// std::basic_string
	template<class charT, class traits = char_traits<charT>, class Allocator = allocator<charT> >
	class basic_string {
	public:
		explicit basic_string(const Allocator& a = Allocator());
		basic_string(const charT* s, const Allocator& a = Allocator()); 
	};

	// std::string
	typedef basic_string<char> string;

	// --- std::ios_base ---

	typedef size_t streamsize;

	class ios_base {
	public:
		streamsize width(streamsize wide);
	};

	template <class charT, class traits = char_traits<charT> >
	class basic_ios : public ios_base {
	public:
	};

	// --- std::istream ---

	// std::basic_istream
	template <class charT, class traits = char_traits<charT> >
	class basic_istream : virtual public basic_ios<charT,traits> {
	public:
		basic_istream<charT,traits>& operator>>(int& n);
	};

	// operator>> std::basic_istream >> std::basic_string
	template<class charT, class traits, class Allocator> basic_istream<charT,traits>& operator>>(basic_istream<charT,traits>& is, basic_string<charT,traits,Allocator>& str);

	// operator>> std::basic_istream >> char*
	template<class charT, class traits> basic_istream<charT,traits>& operator>>(basic_istream<charT,traits>&, charT*);

	// std::istream, std::wistream
	typedef basic_istream<char> istream;
	typedef basic_istream<wchar_t> wistream;

	// --- std::setw ---

	class smanip {};

	// operator>> std::basic_istream >> smanip
	template<class charT, class traits> basic_istream<charT,traits>& operator>>(basic_istream<charT,traits>&, smanip);

	smanip setw(int n);

	// --- std::basic_ifstream ---

	// std::basic_ifstream
	template <class charT, class traits = char_traits<charT> >
	class basic_ifstream : public basic_istream<charT,traits> {
	public:
		basic_ifstream();
		explicit basic_ifstream(const char* s/*, ios_base::openmode mode = ios_base::in*/);
	};

	// std::ifstream, std::wifstream
	typedef basic_ifstream<char> ifstream;
	typedef basic_ifstream<wchar_t> wifstream;

	// --- std::istringstream ---

	// std::basic_istringstream
	template <class charT, class traits = char_traits<charT>, class Allocator = allocator<charT> >
	class basic_istringstream : public basic_istream<charT,traits> {
	public:
		void str(const basic_string<charT,traits,Allocator>& s);
	};

	// std::istringstream
	typedef basic_istringstream<char> istringstream;

	// --- std::cin ---

	// std::cin, std::wcin
	extern istream cin;
	extern wistream wcin;
}

char *test1()
{
	static char buffer[1024];

	return gets(buffer); // BAD: use of gets
}

typedef char MYCHAR;
#define BUFFERSIZE (16)
MYCHAR buffer2[BUFFERSIZE];

int int_func();

void test2()
{
	{
		char buffer1[8];
		char buffer3[] = "..........";
		char *buffer4 = buffer1;
		std::istream &input = std::cin;

		std::cin >> buffer1; // BAD: use of operator>> into a statically-allocated character array
		std::cin >> buffer2; // BAD: use of operator>> into a statically-allocated character array
		std::cin >> buffer3; // BAD: use of operator>> into a statically-allocated character array
		std::cin >> buffer4; // BAD: use of operator>> into a statically-allocated character array
		input >> buffer1; // BAD: use of operator>> into a statically-allocated character array (NOT DETECTED)
	}

	{
		std::string str;
		int i;
	
		std::cin >> i; // GOOD: destination is not a character array
		std::cin >> str; // GOOD: destination is not statically sized
	}

	{
		std::istringstream ss;
		char buffer[4096];

		ss.str("Hello, world!");
		ss >> buffer; // GOOD: input has known length
	}
	
	{
		char buffer[100];
		int i, j, k;

		std::cin >> i >> j >> k; // GOOD: destinations are not character arrays
		std::cin >> i >> buffer >> k; // BAD: use of operator>> into a statically-allocated character array
		
	}
	
	{
		static wchar_t wbuf[1024];
		static char buf[1024];
		static int i;

		std::wcin >> wbuf; // BAD: use of operator>> into a statically-allocated character array
		std::wcin >> i; // GOOD: destination is not a character array
	}

	{
		std::ifstream my_ifstream("my_file.txt");
		std::wifstream my_wifstream("my_file.txt");
		wchar_t wbuf[4096];
		char buf[4096];
		int i;

		my_ifstream >> buf; // BAD: use of operator>> into a statically-allocated character array
		my_ifstream >> i; // GOOD: destination is not a character array
		my_wifstream >> wbuf; // BAD: use of operator>> into a statically-allocated character array
		my_wifstream >> i; // GOOD: destination is not a character array
	}
	
	{
		wchar_t wbuf[10];
		char buf1[10], buf2[10];
		int i;

		std::cin.width(10);
		std::cin >> buf1; // GOOD: controlled by width()
		std::cin >> buf2; // BAD: uncontrolled by width()

		std::cin.width(10);
		std::cin >> buf1 >> buf2; // BAD: buf2 is uncontrolled by width()

		std::cin.width(10);
		std::cin >> i; // GOOD: destination is not a character array
		std::cin >> buf1; // GOOD: controlled by width()
		
		std::cin.width(10);
		std::cin >> i >> buf1; // GOOD: controlled by width()

		std::cin.width(20);
		std::cin >> buf1; // BAD: specified width is too large

		std::cin.width(int_func());
		std::cin >> buf1; // GOOD: controlled by width()

		std::wcin.width(10);
		std::cin >> buf2; // BAD: uncontrolled by width()
		std::wcin >> wbuf; // GOOD: controlled by width()

		std::cin >> std::setw(10) >> buf1; // GOOD: controlled by setw
		std::cin >> std::setw(10) >> buf1 >> buf2; // BAD: buf2 is uncontrolled
		std::cin >> std::setw(20) >> buf1; // BAD: specified width is too large
		
		std::cin.width(20);
		std::cin.width(10);
		std::cin >> buf2; // GOOD: controlled by width()
	}
	
	{
		char buf[10];
		int i;

		(std::cin >> i) >> buf; // BAD: use of operator>> into a statically-allocated character array
		
		(std::cin >> i).width(10);
		std::cin >> buf; // GOOD: controlled by width()
		
		((std::cin >> i) >> std::setw(10)) >> buf; // GOOD: controlled by setw()
	}
	
	{
		char buf[10];
		std::string str;

		std::cin >> std::setw(10) >> str >> buf; // BAD: buf is uncontrolled
	}
}

typedef char MyCharArray[10];
int sprintf(char *s, const char *format, ...);

void test3(char c, int val, char *str)
{
	char buffer10[10];
	MyCharArray myBuffer10;

	gets(buffer10); // BAD: use of gets
	gets(myBuffer10); // BAD: use of gets

	sprintf(buffer10, "%c", c); // GOOD
	sprintf(myBuffer10, "%c", c); // GOOD

	sprintf(buffer10, "%s", str); // BAD: potential buffer overflow [NOT DETECTED]
	sprintf(myBuffer10, "%s", str); // BAD: potential buffer overflow [NOT DETECTED]

	sprintf(buffer10, "val: %i", val); // BAD: potential buffer overflow
	sprintf(myBuffer10, "val: %i", val); // BAD: potential buffer overflow
}

void test3_caller()
{
	test3('a', 12345, "1234567890");
}

void test4()
{
	char buffer8[8];
	char *buffer8_ptr = buffer8;

	sprintf(buffer8, "12345678"); // BAD: buffer overflow
	sprintf(buffer8_ptr, "12345678"); // BAD: buffer overflow
}

typedef void *va_list;
int vsprintf(char *s, const char *format, va_list arg);

void test5(va_list args, float f)
{
	char buffer10[10], buffer64[64];
	char *buffer4 = new char[4 * sizeof(char)];

	vsprintf(buffer10, "123456789", args); // GOOD
	vsprintf(buffer10, "1234567890", args); // BAD: buffer overflow [NOT DETECTED]

	sprintf(buffer64, "%f", f); // BAD: potential buffer overflow

	vsprintf(buffer4, "123", args); // GOOD
	vsprintf(buffer4, "1234", args); // BAD: buffer overflow [NOT DETECTED]
}

namespace custom_sprintf_impl {
	int sprintf(char *buf, const char *format, ...)
	{
		__builtin_va_list args;
		int i;

		__builtin_va_start(args, format);
		i = vsprintf(buf, format, args);
		__builtin_va_end(args);
		return i;
	}

	void regression_test1()
	{
		char buffer8[8];
		sprintf(buffer8, "12345678"); // BAD: potential buffer overflow
	}
}