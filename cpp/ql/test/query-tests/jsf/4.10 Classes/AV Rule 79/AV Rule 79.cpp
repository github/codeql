
// library
typedef unsigned int size_t;
void *malloc(size_t size);
void *calloc(size_t nmemb, size_t size); 
void *realloc(void *ptr, size_t size);
void free(void* ptr);

struct FILE;
FILE *fopen(const char *filename, const char *mode);
int fclose(FILE *stream);

// simple automatic freeing pointer container
template<class T>
class AutoPtr
{
public:
	AutoPtr() : ptr(0) {}

	AutoPtr<T> &operator=(T *_ptr)
	{
		ptr = _ptr;

		return *this;
	}

	~AutoPtr()
	{
		if (ptr != 0)
		{
			delete ptr;
		}
	}

private:
	T *ptr;
};

// test class
class MyClass
{
public:
	MyClass()
	{
		myPtr1 = new int; // GOOD
		myPtr2 = new int; // BAD: not deleted in destructor
		myPtr3 = (int *)malloc(sizeof(int)); // GOOD
		myPtr4 = (int *)malloc(sizeof(int)); // BAD: not freed in destructor
		myPtr5 = new int; // BAD: deleted in close but not in destructor
		myPtr6 = (int *)malloc(sizeof(int)); // BAD: freed in close but not in destructor

		myAutoPtr = new int; // GOOD

		myFile1 = fopen("file1.txt", "rt"); // GOOD
		myFile2 = fopen("file2.txt", "rt"); // BAD: not closed in destructor

		myArray1 = (int *)calloc(100, sizeof(int)); // BAD: not freed in destructor
		myArray2 = new int[100]; // BAD: not deleted in destructor
		myArray3 = new int[100]; // GOOD: deleted in destructor

		myPtr7 = (int*)realloc(0, sizeof(int)); // GOOD: freed below (assuming the realloc succeeds)
		myPtr8 = (int*)realloc(myPtr7, sizeof(int)); // BAD: not freed in destructor
	}
	
	~MyClass()
	{
		delete myPtr1;
		free(myPtr3);
		fclose(myFile1);
		delete [] myArray3;
	}

	void close()
	{
		delete myPtr5;
		free(myPtr6);
	}

	int *myPtr1;
	int *myPtr2;
	int *myPtr3;
	int *myPtr4;
	int *myPtr5;
	int *myPtr6;
	AutoPtr<int> myAutoPtr;
	FILE *myFile1;
	FILE *myFile2;
	int *myArray1;
	int *myArray2;
	int *myArray3;
	int *myPtr7;
	int *myPtr8;
};

int main()
{
	MyClass mc;

	return 0;
}
