
typedef unsigned long size_t;
typedef signed long ssize_t;
void *malloc(size_t size);
#define NULL (0)

int printf(const char *format, ...);
size_t strlen(const char *s);

int get_fd();
int write(int handle, const void *buffer, size_t length);

long sysconf(int name);
#define _SC_CHILD_MAX (2)

size_t confstr(int name, char *buffer, size_t length);
#define _CS_PATH (1)

void test_sc_1()
{
	int value = sysconf(_SC_CHILD_MAX);

	printf("_SC_CHILD_MAX = %i\n", _SC_CHILD_MAX); // GOOD
	printf("_SC_CHILD_MAX = %i\n", value); // BAD [NOT DETECTED]
}

void test_sc_2()
{
	char *pathbuf;
	size_t n;

	n = confstr(_CS_PATH, NULL, (size_t)0);
	pathbuf = (char *)malloc(n);
	if (pathbuf != NULL)
	{
		confstr(_CS_PATH, pathbuf, n);

		printf("path: %s", pathbuf); // BAD [NOT DETECTED]
		write(get_fd(), pathbuf, strlen(pathbuf)); // BAD
	}
}
