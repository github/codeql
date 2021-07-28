
typedef unsigned int size_t;
typedef signed int ssize_t;

size_t strlen(const char *s);
char *strcpy(char *s1, const char *s2);
char *strdup(const char *s1);

void *malloc(size_t size);

void *memset(void *s, int c, size_t n);
void *memcpy(void *s1, const void *s2, size_t n);

ssize_t readlink(const char *path, char *buffer, size_t buffer_size);
ssize_t readlinkat(int fd, const char *path, char *buffer, size_t buffer_size);

bool cond();

void test_unassigned()
{
	{
		char buffer1[1024];
		char buffer2[1024];

		strdup(buffer1); // BAD
		strdup(buffer2); // BAD

		memcpy(buffer2, buffer1, sizeof(buffer2));
		strdup(buffer1); // BAD [NOT DETECTED]
		strdup(buffer2); // BAD [NOT DETECTED]
	}

	{
		char buffer1[1024];
		char buffer2[1024];

		strcpy(buffer1, "content");
		strdup(buffer1); // GOOD
		strdup(buffer2); // BAD

		memcpy(buffer2, buffer1, sizeof(buffer2));
		strdup(buffer1); // GOOD
		strdup(buffer2); // GOOD
	}

	{
		char buffer1[1024] = {0};
		char buffer2[1024];

		memset(buffer2, 0, sizeof(buffer2));
		strdup(buffer1); // GOOD
		strdup(buffer2); // GOOD
	}

	{
		char *ptr1;
		char *ptr2 = "content";

		strdup(ptr1); // BAD
		strdup(ptr2); // GOOD
	}

	{
		char buffer1[1024];
		char buffer2[1024];
		char *ptr;

		ptr = buffer1;
		strdup(buffer1); // BAD
		strdup(ptr); // BAD

		strcpy(buffer1, "content");
		strdup(buffer1); // GOOD
		strdup(ptr); // GOOD

		ptr = buffer1;
		strdup(buffer1); // GOOD
		strdup(ptr); // GOOD

		ptr = buffer2;
		strdup(buffer2); // BAD
		strdup(ptr); // BAD
	}

	{
		char buffer[1024];

		if (cond())
		{
			strcpy(buffer, "content");
			strdup(buffer); // GOOD
		}
		strdup(buffer); // BAD
	}

	{
		char buffer[1024];

		if (cond())
		{
			strcpy(buffer, "content");
		} else {
			strcpy(buffer, "alternative");
		}
		strdup(buffer); // GOOD
	}

	{
		char buffer[1024];

		while (cond())
		{
			strcpy(buffer, "content");
			strdup(buffer); // GOOD
		}
		strdup(buffer); // BAD
	}
}

void test_callee(char *p1, char *p2)
{
	strdup(p1);
}

void test_caller()
{
	char buffer[1024];

	test_callee("content", buffer); // GOOD
	test_callee(buffer, "content"); // BAD
}

void test_readlink(int fd, const char *path, size_t sz)
{
	{
		char buffer[1024];

		readlink(path, buffer, sizeof(buffer));
		strdup(buffer); // BAD
	}

	{
		char buffer[1024];
		int v;

		readlinkat(fd, path, buffer, sizeof(buffer));
		v = strlen(buffer); // BAD
	}

	{
		char buffer[1024] = {0};

		readlink(path, buffer, sizeof(buffer) - 1);
		strdup(buffer); // GOOD [FALSE POSITIVE]
	}

	{
		char buffer[1024];

		memset(buffer, 0, sizeof(buffer));
		readlink(path, buffer, sizeof(buffer) - 1);
		strdup(buffer); // GOOD [FALSE POSITIVE]
	}

	{
		char buffer[1024];

		memset(buffer, 0, sizeof(buffer));
		readlink(path, buffer, sizeof(buffer));
		strdup(buffer); // BAD
	}

	{
		char buffer[1024];

		memset(buffer, 0, sizeof(buffer));
		readlink(path, buffer, sizeof(buffer));
		buffer[sizeof(buffer) - 1] = 0;
		strdup(buffer); // GOOD
	}

	{
		char *buffer = (char *)malloc(1024);

		readlink(path, buffer, 1024);
		strdup(buffer); // BAD
	}

	{
		char *buffer = (char *)malloc(1024);

		buffer[1023] = 0;
		readlink(path, buffer, 1023);
		strdup(buffer); // GOOD [FALSE POSITIVE]
	}

	{
		char *buffer = (char *)malloc(sz);

		readlink(path, buffer, sz);
		strdup(buffer); // BAD
	}

	{
		char *buffer = (char *)malloc(sz);

		memset(buffer, 0, sz);
		readlink(path, buffer, sz - 1);
		strdup(buffer); // GOOD [FALSE POSITIVE]
	}
}
