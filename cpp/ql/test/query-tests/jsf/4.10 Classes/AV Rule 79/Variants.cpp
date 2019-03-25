
// library
typedef unsigned int size_t;
void *malloc(size_t size);
void *calloc(size_t nmemb, size_t size);
void *realloc(void *ptr, size_t size);
void free(void* ptr);

int *ID(int *x) 
{
	return x;
}

class MyClass4
{
public:
	MyClass4()
	{
		int *local;

		a = b = new int; // GOOD (a is deleted)
		c = d = new int; // GOOD (d is deleted)
		e = local = new int; // BAD (e is not deleted) [NOT REPORTED]

		f = new int; // GOOD (ID(f) is deleted) [FALSE POSITIVE]
		g = ID(new int); // GOOD (g is deleted)
	}
	
	~MyClass4()
	{
		delete a;
		delete d;
		delete ID(f);
		delete g;
	}

	int *a, *b, *c, *d, *e, *f, *g;
};

class MyClass5
{
public:
	MyClass5()
	{
		a = new int[10]; // GOOD
		b = (int *)calloc(10, sizeof(int)); // GOOD
		c = (int *)realloc(0, 10 * sizeof(int)); // GOOD
	}
	
	~MyClass5()
	{
		delete [] a;
		free(b);
		free(c);
	}

	int *a, *b, *c;
};

class MyClass6
{
public:
	MyClass6()
	{
		a = new int[10]; // BAD
		b = (int *)calloc(10, sizeof(int)); // BAD
		c = (int *)realloc(0, 10 * sizeof(int)); // BAD
	}
	
	~MyClass6()
	{
	}

	int *a, *b, *c;
};

class MyClass7
{
public:
	MyClass7()
	{
	}

	bool open()
	{
		// ...
	}

	void close()
	{
		// ...
	}
};

class myClass7Test
{
public:
	myClass7Test()
	{
		success = mc7.open(); // GOOD
	}

	~myClass7Test()
	{
		mc7.close();
	}

private:
	MyClass7 mc7;
	bool success;
};
