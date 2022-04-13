// Semmle test cases for rule CWE-497

// library functions etc

#include "tests.h"

char *getenv(const char *name);
char *strcpy(char *s1, const char *s2);















int socket(int p1, int p2, int p3);
void send(int sock, const char *buffer, int p3, int p4);

const char *mysql_get_client_info();
void mysql_real_connect(int p1, int p2, int p3, const char *password, int p5, int p6, int p7, int p8);

struct container
{
	char *ptr;
};

struct passwd
{
	// ...

	char *pw_passwd;

	// ...
};

passwd *getpwuid(int uid);

int val();

// test cases

const char *global1 = mysql_get_client_info();
const char *global2 = "abc";

void test1()
{
	int sock = socket(val(), val(), val());

	// tests for a strict implementation of CWE-497
	std::cout << getenv("HOME"); // BAD: outputs HOME environment variable [NOT DETECTED]
	std::cout << "PATH = " << getenv("PATH") << "."; // BAD: outputs PATH environment variable [NOT DETECTED]
	std::cout << "PATHPATHPATH"; // GOOD: not system data

	// tests for a more pragmatic implementation of CWE-497
	send(sock, getenv("HOME"), val(), val()); // BAD
	send(sock, getenv("PATH"), val(), val()); // BAD
	send(sock, getenv("USERNAME"), val(), val()); // BAD
	send(sock, getenv("APP_PASSWORD"), val(), val()); // BAD
	send(sock, getenv("HARMLESS"), val(), val()); // GOOD: harmless information
	send(sock, "HOME", val(), val()); // GOOD: not system data
	send(sock, "PATH", val(), val()); // GOOD: not system data
	send(sock, "USERNAME", val(), val()); // GOOD: not system data
	send(sock, "APP_PASSWORD", val(), val()); // GOOD: not system data
	send(sock, "HARMLESS", val(), val()); // GOOD: not system data

	// tests for `mysql_get_client_info`, including via a global
	{
		char buffer[256];

		strcpy(buffer, mysql_get_client_info());

		send(sock, mysql_get_client_info(), val(), val()); // BAD
		send(sock, buffer, val(), val()); // BAD
		send(sock, global1, val(), val()); // BAD [NOT DETECTED]
		send(sock, global2, val(), val()); // GOOD: not system data
	}

	// tests for `mysql_real_connect`
	{
		const char *str1 = "123456";
		const char *str2 = "abcdef";

		mysql_real_connect(sock, val(), val(), str1, val(), val(), val(), val());

		send(sock, str1, val(), val()); // BAD
		send(sock, str2, val(), val()); // GOOD: not system data
	}

	// tests for `getpwuid`
	{
		passwd *pw;

		pw = getpwuid(val());
		send(sock, pw->pw_passwd, val(), val()); // BAD
	}

	// tests for containers
	{
		container c1, c2;

		c1.ptr = getenv("MY_SECRET_TOKEN");
		c2.ptr = "";
		send(sock, c1.ptr, val(), val()); // BAD
		send(sock, c2.ptr, val(), val()); // GOOD: not system data
	}
}
