// tests1.cpp

typedef unsigned int size_t;

char *strcpy(char *destination, const char *source);
char *strcat(char *destination, const char *source);
size_t strlen(const char *str);

namespace std
{
	void *malloc(size_t size);
	void free(void *ptr);
}

const char *str3global = "123";

void tests3(int case_num)
{
	const char *str3local = "123";
	char *buffer = 0;

	switch (case_num)
	{
		case 1:
			buffer = (char *)std::malloc(strlen(str3global)); // BAD
			strcpy(buffer, str3global);
			break;

		case 2:
			buffer = (char *)std::malloc(strlen(str3local)); // BAD
			strcpy(buffer, str3local);
			break;

		case 3:
			buffer = (char *)std::malloc(strlen(str3global) + 1); // GOOD
			strcpy(buffer, str3global);
			break;

		case 4:
			buffer = (char *)std::malloc(strlen(str3local) + 1); // GOOD
			strcpy(buffer, str3local);
			break;
	}

	if (buffer != 0)
	{
		std::free(buffer);
	}
}

void test3b()
{
	char *buffer = new char[strlen(str3global)]; // BAD

	strcpy(buffer, str3global);

	delete buffer;
}

void test3c()
{
	char *buffer = new char[10]; // BAD [NOT DETECTED]

	strcpy(buffer, "123456");
	strcat(buffer, "123456");

	delete buffer;
}
