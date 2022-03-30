typedef unsigned int size_t;
typedef signed int ssize_t;
typedef struct {} FILE;

size_t strlen(const char *s);
char *strcpy(char *s1, const char *s2);
char *strcat(char *s1, const char *s2);
char *strdup(const char *s1);
long int strtol(const char* nptr, char** endptr, int base);
void *malloc(size_t size);
void *memset(void *s, int c, size_t n);
void *memcpy(void *s1, const void *s2, size_t n);
void read(int src, void *out, int num);
size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
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
		strdup(buffer); // GOOD
	}

	{
		char buffer[1024];
		ssize_t len;

		len = readlink(path, buffer, sizeof(buffer));
		if (len >= 0)
		{
			buffer[len - 1] = 0;
			strdup(buffer); // GOOD
		}
	}

	{
		char buffer[1024];

		memset(buffer, 0, sizeof(buffer));
		readlink(path, buffer, sizeof(buffer) - 1);
		strdup(buffer); // GOOD
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
		strdup(buffer); // BAD [NOT DETECTED]
	}

	{
		char *buffer = (char *)malloc(1024);

		buffer[1023] = 0;
		readlink(path, buffer, 1023);
		strdup(buffer); // GOOD
	}

	{
		char *buffer = (char *)malloc(sz);

		readlink(path, buffer, sz);
		strdup(buffer); // BAD [NOT DETECTED]
	}

	{
		char *buffer = (char *)malloc(sz);

		memset(buffer, 0, sz);
		readlink(path, buffer, sz - 1);
		strdup(buffer); // GOOD
	}
}

void doNothing(char *data) { };
void doNothing2(const char *data);
void clearBuffer(char *data, size_t size);
char *id(char *data) { return data; }

void test_strcat()
{
	{
		char buffer[1024];

		strcat(buffer, "content"); // BAD
	}

	{
		char buffer[1024];

		buffer[0] = 0;
		strcat(buffer, "content"); // GOOD
	}

	{
		char buffer[1024];

		buffer[10] = 0;
		strcat(buffer, "content"); // GOOD
	}

	{
		char buffer[1024];

		buffer[0] = '\0';
		strcat(buffer, "content"); // GOOD
	}

	{
		char buffer[1024];

		buffer[0] = 'a';
		strcat(buffer, "content"); // BAD
	}

	{
		char buffer[1024];

		*buffer = 0;
		strcat(buffer, "content"); // GOOD
	}

	{
		char buffer[1024];

		strcpy(buffer, "con");
		strcat(buffer, "tent"); // GOOD
	}

	{
		char buffer[1024];

		doNothing(buffer);
		strcat(buffer, "content"); // BAD
	}

	{
		char buffer[1024];

		doNothing2(buffer);
		strcat(buffer, "content"); // BAD [NOT DETECTED]
	}

	{
		char buffer1[1024];
		char buffer2[1024];
		char *buffer_ptr = buffer1;

		*buffer_ptr = 0;
		strcat(buffer1, "content"); // GOOD
		strcat(buffer2, "content"); // BAD
		strcat(buffer_ptr, "content"); // GOOD

		buffer_ptr = buffer2;
		strcat(buffer_ptr, "content"); // BAD [NOT DETECTED]
	}

	{
		char buffer[1024];
		char *buffer_ptr = buffer;

		*buffer_ptr = 'a';
		strcat(buffer, "content"); // BAD
	}

	{
		char buffer[1024];

		clearBuffer(buffer, 1024);
		strcat(buffer, "content"); // GOOD
	}

	{
		char buffer[1024];

		clearBuffer(id(buffer), 1024);
		strcat(buffer, "content"); // GOOD
	}
}

void test_strlen(bool cond1, bool cond2)
{
	{
		char buffer[1024];
		int i = strlen(buffer); // BAD
	}

	{
		char buffer[1024] = {0};
		int i = strlen(buffer); // GOOD
	}

	{
		char *ptr = "content";
		int i = strlen(ptr); // GOOD
	}

	{
		char buffer[1024];

		if (cond1)
			buffer[0] = 0;
		if (cond1)
			strlen(buffer); // GOOD
	}

	{
		char buffer[1024];

		if (cond1)
			buffer[0] = 0;
		if (cond2)
			strlen(buffer); // BAD [NOT DETECTED]
	}

	{
		char buffer[1024];

		if (cond1)
		{
			buffer[0] = 0;
		} else {
			buffer[0] = 0;
		}

		strlen(buffer); // GOOD
	}

	{
		char buffer[1024];
		int init = 0;

		if (cond1)
		{
			buffer[0] = 0;
			init = 1;
		}

		if (init != 0)
		{
			strlen(buffer); // GOOD
		}
	}

	{
		char buffer[1024];
		int init = 0;

		if (cond1)
		{
			buffer[0] = 0;
			init = 1;
		}

		if (init == 0)
		{
			// ...
		} else {
			strlen(buffer); // GOOD
		}
	}
}

void test_strcpy()
{
	{
		char buffer1[1024];
		char buffer2[1024];

		strcpy(buffer1, buffer2); // BAD
	}

	{
		char buffer1[1024];
		char buffer2[1024];

		strcpy(buffer2, "content"); // GOOD
		strcpy(buffer1, buffer2); // GOOD
	}
}

void strcatWrapper(char *data, const char *with)
{
	strcat(data, with);
}

void strcatWrapper2(char *data, const char *with)
{
	strcatWrapper(data, with);
}

void test_wrappers()
{
	{
		char buffer[1024];

		strcatWrapper(buffer, "content"); // BAD
	}

	{
		char buffer[1024];

		strcatWrapper2(buffer, "content"); // BAD
	}
}

void test_read_fread(int read_src, FILE *s)
{
	const size_t buffer_size = 80;

	{
		char buffer[buffer_size];

		read(read_src, buffer, buffer_size * sizeof(char));
		strlen(buffer); // BAD
	}

	{
		char buffer[buffer_size];

		read(read_src, buffer, buffer_size * sizeof(char));
		buffer[buffer_size - 1] = 0;
		strlen(buffer); // GOOD
	}

	{
		char buffer[buffer_size];

		fread(buffer, sizeof(char), buffer_size, s);
		strlen(buffer); // BAD
	}

	{
		char buffer[buffer_size];

		fread(buffer, sizeof(char), buffer_size, s);
		buffer[buffer_size - 1] = 0;
		strlen(buffer); // GOOD
	}
}

void test_strtol()
{
	{
		char buffer[100];
		char *after_ptr;
		long int num;

		strcpy(buffer, "123abc");
		num = strtol("123abc", &after_ptr, 10);
		strlen(after_ptr); // GOOD
	}
}

int printf(const char *format, ...);

void test_printf(char *str)
{
	{
		char buffer[1024];

		printf(buffer, ""); // BAD
	}

	{
		char buffer[1024];

		printf("%s", buffer); // BAD
	}

	{
		size_t len = strlen(str);
		char *copied_str = (char *)malloc(len);

		memcpy(copied_str, str, len);
		printf("%s", copied_str); // BAD [NOT DETECTED]
	}

	{
		size_t len = strlen(str);
		char *copied_str = (char *)malloc(len + 1);

		memcpy(copied_str, str, len + 1);
		printf("%s", copied_str); // GOOD
	}
}

void test_reassignment()
{
	{
		char buffer1[1024];
		char buffer2[1024];
		char *buffer_ptr = buffer1;

		buffer_ptr = buffer2;
		strcpy(buffer_ptr, "content"); // null terminates buffer2
		strdup(buffer2); // GOOD
	}

	{
		char buffer1[1024];
		char buffer2[1024];
		char *buffer_ptr = buffer1;

		strcpy(buffer_ptr, "content"); // null terminates buffer1
		buffer_ptr = buffer2;
		strdup(buffer2); // BAD
	}

	{
		char buffer1[1024];
		char buffer2[1024];
		char *buffer_ptr = buffer1;

		while (cond())
		{
			buffer_ptr = buffer2;
			strcpy(buffer_ptr, "content"); // null terminates buffer2
			strdup(buffer2); // GOOD
		}
	}

	{
		char buffer1[1024];
		char buffer2[1024];
		char *buffer_ptr = buffer1;

		while (cond())
		{
			strcpy(buffer_ptr, "content"); // null terminates buffer1 or buffer2
			buffer_ptr = buffer2;
			strdup(buffer2); // BAD [NOT DETECTED]
		}
	}
}
