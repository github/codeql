// test cases for rule CWE-497

// library functions etc

typedef unsigned long size_t;
typedef struct {} FILE;
FILE *stdout;

int puts(const char *s);
int printf(const char *format, ...);
int sprintf(char *s, const char *format, ...);
int snprintf(char *s, size_t n, const char *format, ...);
size_t strlen(const char *s);
char *getenv(const char *name);

namespace std
{
	typedef size_t streamsize;

	template<class charT> struct char_traits;

	template <class charT, class traits = char_traits<charT> >
	class basic_ostream /*: virtual public basic_ios<charT,traits> - not needed for this test */ {
	public:
		typedef charT char_type;
		basic_ostream<charT,traits>& write(const char_type* s, streamsize n);

		basic_ostream<charT, traits>& operator<<(int n);
	};
	template<class charT, class traits> basic_ostream<charT,traits>& operator<<(basic_ostream<charT,traits>&, const charT*);

	typedef basic_ostream<char> ostream;

	extern ostream cout;
	extern ostream cerr;
	extern ostream clog;
}
extern std::ostream someotherostream;

#define NULL (0)

// test cases

void test1()
{
	std::ostream cout_copy = std::cout;

	std::cout << getenv("USERPROFILE"); // BAD: outputs USERPROFILE environment variable [NOT DETECTED]
	std::cerr << getenv("USERPROFILE"); // BAD: outputs USERPROFILE environment variable [NOT DETECTED]
	std::clog << getenv("USERPROFILE"); // BAD: outputs USERPROFILE environment variable [NOT DETECTED]
	someotherostream << getenv("USERPROFILE"); // GOOD: not output
	cout_copy << getenv("USERPROFILE"); // BAD: outputs USERPROFILE environment variable [NOT DETECTED]

	std::cout << getenv("PATH"); // BAD: outputs PATH environment variable [NOT DETECTED]
	std::cout.write(getenv("PATH"), strlen(getenv("PATH"))); // BAD: outputs PATH environment variable [NOT DETECTED]
	(std::cout << "PATH = ").write(getenv("PATH"), strlen(getenv("PATH"))); // BAD: outputs PATH environment variable [NOT DETECTED]
	std::cout.write("PATH = ", 7) << getenv("PATH"); // BAD: outputs PATH environment variable [NOT DETECTED]
}

char *global_path = getenv("PATH");
char *global_other = "Hello, world!";

void test2(bool cond)
{
	char *maybe;

	maybe = cond ? global_path : global_other;
	
	printf("path = '%s'\n", global_path); // BAD: outputs PATH environment variable [NOT DETECTED]
	printf("other = '%s'\n", global_other);
	printf("maybe = '%s'\n", maybe); // BAD: may output PATH environment variable [NOT DETECTED]
}

void test3()
{
	char *path_string = getenv("PATH");
	char buf[4096];

	// ...
	snprintf(buf, 4096, "invalid path '%s'\n", path_string);
	puts(buf); // BAD: outputs PATH environment variable [NOT DETECTED]
}

void myOutputFn(const char *msg)
{
	printf("%s", msg);
}

void myOtherFn(const char *msg)
{
}

void test4()
{
	myOutputFn(getenv("PATH")); // BAD: outputs the PATH environment variable [NOT DETECTED]
	myOtherFn(getenv("PATH")); // GOOD: does not output anything.
}

void myOutputFn2(const char *msg)
{
	msg = "";
	printf("%s", msg);
}

void myOutputFn3(const char *msg)
{
	const char *tmp = msg;

	printf("%s", tmp);
}

void myOutputFn4(const char *msg)
{
	char buffer[4096];

	sprintf(buffer, "log: %s\n", msg);
	puts(buffer);
}

void myOutputFn5(const char *msg)
{
	printf("%s", msg);
	msg = "";
}

void test5()
{
	myOutputFn2(getenv("PATH")); // GOOD: myOutputFn2 doesn't actually output the parameter
	myOutputFn3(getenv("PATH")); // BAD: outputs the PATH environment variable [NOT DETECTED]
	myOutputFn4(getenv("PATH")); // BAD: outputs the PATH environment variable [NOT DETECTED]
	myOutputFn5(getenv("PATH")); // BAD: outputs the PATH environment variable [NOT DETECTED]
}
