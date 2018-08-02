
typedef unsigned int size_t;
void *malloc(size_t size);
void free(void *ptr);

void MyFree1(char *_ptr)
{
	delete [] _ptr;
}

void MyFree2(char *_ptr, const char *debug_message)
{
	delete [] _ptr;
}

class Wrapped
{
public:
	Wrapped(int len) {
		ptr1 = new char[len]; // GOOD
		ptr2 = new char[len]; // GOOD
		ptr3 = new char[len]; // GOOD
	}

	~Wrapped()
	{
		MyFree1(ptr1);
		MyFree2(ptr2, "debug message");
		MyFree3(ptr3);
	}

	void MyFree3(char *_ptr)
	{
		delete [] _ptr;
	}

private:
	char *ptr1, *ptr2, *ptr3;
};
