// test cases for rule CWE-497

// library functions etc

#include "tests.h"


typedef struct {} FILE;
FILE *stdout;

int puts(const char *s);
int printf(const char *format, ...);
int sprintf(char *s, const char *format, ...);
int snprintf(char *s, size_t n, const char *format, ...);
size_t strlen(const char *s);
char *getenv(const char *name);

extern std::ostream someotherostream;





















#define NULL (0)

// test cases

void test1()
{
	std::ostream cout_copy = std::cout;

	std::cout << getenv("SECRET_TOKEN"); // BAD: outputs SECRET_TOKEN environment variable
	std::cerr << getenv("SECRET_TOKEN"); // BAD: outputs SECRET_TOKEN environment variable
	std::clog << getenv("SECRET_TOKEN"); // BAD: outputs SECRET_TOKEN environment variable
	someotherostream << getenv("SECRET_TOKEN"); // GOOD: not output
	cout_copy << getenv("SECRET_TOKEN"); // BAD: outputs SECRET_TOKEN environment variable [NOT DETECTED]

	std::cout << getenv("USERPROFILE"); // BAD: outputs PATH environment variable [NOT DETECTED]
	std::cout << getenv("PATH"); // BAD: outputs PATH environment variable [NOT DETECTED]

	std::cout.write(getenv("SECRET_TOKEN"), strlen(getenv("SECRET_TOKEN"))); // BAD: outputs SECRET_TOKEN environment variable
	(std::cout << "SECRET_TOKEN = ").write(getenv("SECRET_TOKEN"), strlen(getenv("SECRET_TOKEN"))); // BAD: outputs SECRET_TOKEN environment variable
	std::cout.write("SECRET_TOKEN = ", 7) << getenv("SECRET_TOKEN"); // BAD: outputs SECRET_TOKEN environment variable
}

char *global_token = getenv("SECRET_TOKEN");
char *global_other = "Hello, world!";

void test2(bool cond)
{
	char *maybe;

	maybe = cond ? global_token : global_other;
	
	printf("token = '%s'\n", global_token); // BAD: outputs SECRET_TOKEN environment variable [NOT DETECTED]
	printf("other = '%s'\n", global_other);
	printf("maybe = '%s'\n", maybe); // BAD: may output SECRET_TOKEN environment variable [NOT DETECTED]
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
	myOutputFn(getenv("SECRET_TOKEN")); // BAD: outputs the SECRET_TOKEN environment variable
	myOtherFn(getenv("SECRET_TOKEN")); // GOOD: does not output anything.
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
	myOutputFn2(getenv("SECRET_TOKEN")); // GOOD: myOutputFn2 doesn't actually output the parameter
	myOutputFn3(getenv("SECRET_TOKEN")); // BAD: outputs the SECRET_TOKEN environment variable
	myOutputFn4(getenv("SECRET_TOKEN")); // BAD: outputs the SECRET_TOKEN environment variable
	myOutputFn5(getenv("SECRET_TOKEN")); // BAD: outputs the SECRET_TOKEN environment variable
}
