// Associated with CWE-190: Integer Overflow or Wraparound. http://cwe.mitre.org/data/definitions/190.html

typedef unsigned long size_t;
typedef struct {} FILE;

void *malloc(size_t size);
void *realloc(void *ptr, size_t size);
void free(void *ptr);
int atoi(const char *nptr);
long atol(const char *nptr);
struct MyStruct
{
	char data[256];
};

namespace std
{
	template<class charT> struct char_traits;

	template <class charT, class traits = char_traits<charT> >
	class basic_istream /*: virtual public basic_ios<charT,traits> - not needed for this test */ {
	public:
		basic_istream<charT,traits>& operator>>(int& n);
	};

	typedef basic_istream<char> istream;

	extern istream cin;
}

int getTainted() {
	int i;
	
	std::cin >> i;

	return i;
}

int main(int argc, char **argv) {
	int tainted = atoi(argv[1]);

	MyStruct *arr1 = (MyStruct *)malloc(sizeof(MyStruct)); // GOOD
	MyStruct *arr2 = (MyStruct *)malloc(tainted); // DUBIOUS (not multiplied by anything)
	MyStruct *arr3 = (MyStruct *)malloc(tainted * sizeof(MyStruct)); // BAD
	MyStruct *arr4 = (MyStruct *)malloc(getTainted() * sizeof(MyStruct)); // BAD [NOT DETECTED]
	MyStruct *arr5 = (MyStruct *)malloc(sizeof(MyStruct) + tainted); // DUBIOUS (not multiplied by anything)

	int size = tainted * 8;
	char *chars1 = (char *)malloc(size); // BAD
	char *chars2 = new char[size]; // BAD
	char *chars3 = new char[8]; // GOOD

	arr1 = (MyStruct *)realloc(arr1, sizeof(MyStruct) * tainted); // BAD

	size = 8;
	chars3 = new char[size]; // GOOD

	return 0;
}

FILE *fopen(const char *filename, const char *mode);
size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
int fclose(FILE *stream);

void processData1(char *buffer, int size)
{
	char *copy;

	copy = new char[size]; // GOOD

	// ...

	delete [] copy;
}

void processData2(char *start, char *end)
{
	char *copy;

	copy = new char[end - start]; // GOOD

	// ...

	delete [] copy;
}

void processFile()
{
	char buffer[256], *copy;
	size_t amount;
	FILE *f;

	// open file
	f = fopen("myfile.txt", "r");
	if (f != 0)
	{
		// read a bounded amount of data
		amount = fread(buffer, sizeof(char), 256, f);
		if (amount > 0)
		{
			processData1(buffer, amount);
			processData2(buffer, buffer + amount);
		}

		// close file
		fclose(f);
	}
}

char *getenv(const char *name);

#define MAX_SIZE 500

int bounded(int x, int limit) {
  int result = x;
  if (x <= 0)
    result = 1;
  else if (x > limit)
    result = limit;
  return result;
}

void open_file_bounded () {
	int size = atoi(getenv("USER"));
	int bounded_size = bounded(size, MAX_SIZE);
	
	int* a = (int*)malloc(bounded_size * sizeof(int)); // GOOD
	int* b = (int*)malloc(size * sizeof(int)); // BAD
}

void more_bounded_tests() {
	{
		int size = atoi(getenv("USER"));

		malloc(size * sizeof(int)); // BAD
	}

	{
		int size = atoi(getenv("USER"));

		if (size > 0)
		{
			malloc(size * sizeof(int)); // GOOD (overflow not possible)
		}
	}

	{
		long size = atol(getenv("USER"));

		if (size > 0)
		{
			malloc(size * sizeof(int)); // BAD
		}
	}

	{
		int size = atoi(getenv("USER"));

		if (size < 100)
		{
			malloc(size * sizeof(int)); // BAD [NOT DETECTED]
		}
	}

	{
		int size = atoi(getenv("USER"));

		if ((size > 0) && (size < 100))
		{
			malloc(size * sizeof(int)); // GOOD
		}
	}

	{
		int size = atoi(getenv("USER"));

		if ((100 > size) && (0 < size))
		{
			malloc(size * sizeof(int)); // GOOD
		}
	}

	{
		int size = atoi(getenv("USER"));

		malloc(size * sizeof(int)); // BAD [NOT DETECTED]

		if ((size > 0) && (size < 100))
		{
			// ...
		}
	}

	{
		int size = atoi(getenv("USER"));

		if (size > 100)
		{
			malloc(size * sizeof(int)); // BAD [NOT DETECTED]
		}
	}
}

size_t get_untainted_size()
{
	return 10 * sizeof(int);
}

size_t get_tainted_size()
{
	return atoi(getenv("USER")) * sizeof(int);
}

size_t get_bounded_size()
{
	size_t s = atoi(getenv("USER")) * sizeof(int);

	if (s < 0) { s = 0; }
	if (s > 100) { s = 100; }

	return s;
}

void *my_alloc(size_t s) {
	void *ptr = malloc(s); // [UNHELPFUL RESULT]

	return ptr;
}

void my_func(size_t s) {
	void *ptr = malloc(s); // BAD

	free(ptr);
}

void more_cases() {
	int local_size = atoi(getenv("USER")) * sizeof(int);

	malloc(local_size); // BAD
	malloc(get_untainted_size()); // GOOD
	malloc(get_tainted_size()); // BAD
	malloc(get_bounded_size()); // GOOD

	my_alloc(100); // GOOD
	my_alloc(local_size); // BAD [NOT DETECTED IN CORRECT LOCATION]
	my_func(100); // GOOD
	my_func(local_size); // GOOD
}

bool get_size(int &out_size) {
	out_size = atoi(getenv("USER"));
	
	return true;
}

void equality_cases() {
	{
		int size1 = atoi(getenv("USER"));
		int size2 = atoi(getenv("USER"));

		if (size1 == 100)
		{
			malloc(size2 * sizeof(int)); // BAD
		}
		if (size2 == 100)
		{
			malloc(size2 * sizeof(int)); // GOOD
		}
	}
	{
		int size = atoi(getenv("USER"));

		if (size != 100)
			return;

		malloc(size * sizeof(int)); // GOOD
	}
	{
		int size;

		if ((get_size(size)) && (size == 100))
		{
			malloc(size * sizeof(int)); // GOOD
		}
	}
	{
		int size;

		if ((get_size(size)) && (size != 100))
		{
			malloc(size * sizeof(int)); // BAD
		}
	}
	{
		int size;

		if ((!get_size(size)) || (size != 100))
			return;

		malloc(size * sizeof(int)); // GOOD
	}
	{
		int size;

		if ((!get_size(size)) || (size == 100))
			return;

		malloc(size * sizeof(int)); // BAD
	}
	{
		int size = atoi(getenv("USER"));

		if ((size == 50) || (size == 100))
		{
			malloc(size * sizeof(int)); // GOOD
		}
	}
	{
		int size = atoi(getenv("USER"));

		if (size != 50 && size != 100)
			return;

		malloc(size * sizeof(int)); // GOOD
	}
}

char * strstr(char *, const char *);

void ptr_diff_case() {
	char* user = getenv("USER");
	char* admin_begin_pos = strstr(user, "ADMIN");
	int offset = admin_begin_pos ? user - admin_begin_pos : 0; 
	malloc(offset); // GOOD
}