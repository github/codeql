// semmle-extractor-options: -std=gnu++14

typedef unsigned long size_t;

void *malloc(size_t size);
void free(void *ptr);

void* operator new(size_t _Size, void *_Where);

// ---

template<typename T>
class MyTest2Class
{
public:
	MyTest2Class()
	{
		int *a = new int;
		free(a); // BAD

		int *ptr_b = (int *)malloc(sizeof(int));
		int *b = new(ptr_b) int;
		free(b); // GOOD

		c = new int;
		free(c); // BAD

		int *ptr_d = (int *)malloc(sizeof(int));
		d = new(ptr_d) int;
		free(d); // GOOD
	}

	int *c, *d;
};

MyTest2Class<int> mt2c_i;

// ---

void* operator new(size_t);
void operator delete(void*);

void test_operator_new()
{
	void *ptr_new = new int;
	void *ptr_opnew = ::operator new(sizeof(int));
	void *ptr_malloc = malloc(sizeof(int));

	delete ptr_new; // GOOD
	::operator delete(ptr_new); // GOOD
	free(ptr_new); // BAD

	delete ptr_opnew; // GOOD
	::operator delete(ptr_opnew); // GOOD
	free(ptr_opnew); // BAD

	delete ptr_malloc; // BAD
	::operator delete(ptr_malloc); // BAD
	free(ptr_malloc); // GOOD
}
