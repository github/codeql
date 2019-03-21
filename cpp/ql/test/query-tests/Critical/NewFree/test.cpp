// semmle-extractor-options: --microsoft  --edg --target --edg linux_x86_64
typedef unsigned __int64 size_t;
void *malloc(size_t size);
void free(void *ptr);

// placement new
void* operator new(size_t _Size, void *_Where)
{
	// ...
}

// ---

class myClass
{
public:
	int x, y;
};

myClass *global_p1, *global_p2;

void f1()
{
	myClass *p1, *p2;
	
	p1 = new myClass;
	p2 = (myClass *)malloc(sizeof(myClass));

	global_p1 = p1;
	global_p2 = p2;
}

void f2()
{
	delete global_p1; // GOOD
	delete global_p2; // BAD: malloc -> delete
}

void f3()
{
	free(global_p1); // BAD: new -> delete
	free(global_p2); // GOOD
}

void *my_malloc(size_t size)
{
	return malloc(size);
}

template<class T> void my_delete(T *t)
{
	if (t != 0)
	{
		delete t;
	}
}

int main()
{
	// straightforward cases
	{
		myClass *p1 = new myClass;
		myClass *p2 = new myClass[10];
		myClass *p3 = (myClass *)malloc(sizeof(myClass));

		delete p1; // GOOD
		delete [] p2; // GOOD
		delete p3; // BAD: malloc -> delete
	}
	{
		myClass *p1 = new myClass;
		myClass *p2 = new myClass[10];
		myClass *p3 = (myClass *)malloc(sizeof(myClass));

		free(p1); // BAD: new -> free
		free(p2); // BAD: new[] -> free
		free(p3); // GOOD
	}

	// more complex flow
	f1();
	f2();
	f1();
	f3();

	// wrapped malloc / delete
	{
		myClass *p1 = (myClass *)my_malloc(sizeof(myClass));
		myClass *p2 = (myClass *)my_malloc(sizeof(myClass));

		delete p1; // BAD: malloc -> delete
		free(p2); // GOOD
	}
	{
		myClass *p1 = new myClass;
		myClass *p2 = (myClass *)malloc(sizeof(myClass));

		my_delete(p1); // GOOD
		my_delete(p2); // BAD: malloc -> delete
	}

	// overwritten
	{
		myClass *p1 = new myClass;
		
		delete p1; // GOOD
		p1 = (myClass *)malloc(sizeof(myClass));

		free(p1); // GOOD
	}

	// placement new
	{
		void *v1 = malloc(sizeof(myClass));
		// ... check alignment of v1 ...
		myClass *p1 = new (v1) myClass();

		p1->~myClass();
		free(p1); // GOOD
	}

	return 0;
}

void *my_malloc_2(size_t size)
{
	void *alloc = malloc(size);

	return alloc;
}

void test2()
{
	void *a = my_malloc_2(10);
	void *b = my_malloc_2(10);
	
	free(a); // GOOD
	delete b; // BAD: malloc -> delete
}

void *my_malloc_3(size_t size)
{
	void *alloc = malloc(size);
	void *mid = alloc;

	return mid;
}

void test3()
{
	void *a = my_malloc_3(10);
	void *b = my_malloc_3(10);
	
	free(a); // GOOD
	delete b; // BAD: malloc -> delete
}

void test4(bool do_array_delete)
{
	myClass *mc = new myClass;
	myClass *mc_array = new myClass[1024];

	if (do_array_delete)
	{
		delete [] mc; // BAD
		delete [] mc_array; // GOOD
	} else {
		delete mc; // GOOD
		delete mc_array; // BAD
	}
}

void test5(bool do_array_delete)
{
	char *c_array = new char[32];
	char *c_array_ptr_2 = c_array;

	if (do_array_delete)
	{
		delete [] c_array_ptr_2; // GOOD
	} else {
		delete c_array_ptr_2; // BAD
	}
}

void test6(bool do_array_delete)
{
	char *c_ptr_array[10] = {0};
	c_ptr_array[5] = new char;

	if (do_array_delete)
	{
		delete [] c_ptr_array[5]; // BAD [NOT DETECTED]
	} else {
		delete c_ptr_array[5]; // GOOD
	}
}

myClass *global_mc = 0;

void test7(bool do_array_delete)
{
	// alloc
	if (global_mc == 0)
	{
		global_mc = new myClass;
	}

	// free
	if (global_mc != 0)
	{
		if (do_array_delete)
		{
			delete [] global_mc; // BAD
		} else {
			delete global_mc; // GOOD
		}
	}
}

void test8(bool cond)
{
	void *a = 0, *b = 0, *c = 0;

	if (cond) {
		a = malloc(64);
		b = new int;
		c = new int[10];
	}

	free(a); // GOOD
	delete a; // BAD: malloc -> delete
	delete [] a; // BAD: malloc -> delete[]

	free(b); // BAD: new -> free
	delete b; // GOOD
	delete [] b; // BAD: new -> delete[]

	free(c); // BAD: new[] -> free
	delete c; // BAD: new[] -> delete
	delete [] c; // GOOD
}

void test9()
{
	void *ptr;

	ptr = new int;
	delete ptr; // GOOD

	ptr = new int[10];
	delete [] ptr; // GOOD

	ptr = malloc(sizeof(int));
	free(ptr); // GOOD
}

class ClassWithMembers
{
public:
	ClassWithMembers()
	{
		a = new int;
		b = new int;
		c = new int;
	}
	
	~ClassWithMembers()
	{
		delete a; // GOOD
		delete [] b; // BAD: new -> delete[]
		free(c); // BAD: new -> free
	}

private:
	int *a, *b, *c;
};

// ---

struct map_cell
{
	char ch;
	int col;
};
map_cell *map;

static void map_init()
{
	map = new map_cell[30 * 30];
}

static void map_shutdown()
{
	delete map; // BAD: new[] -> delete
	map = 0;
}

// ---

class Test10
{
public:
	Test10() : data(new char[10])
	{
	}

	~Test10()
	{
		delete data; // BAD: new[] -> delete
	}

	char *data;
};

class Test11
{
public:
	Test11()
	{
		data = new char[10];
	}

	void resize(int size)
	{
		if (size > 0)
		{
			delete [] data; // GOOD
			data = new char[size];
		}
	}

	~Test11()
	{
		delete data; // BAD: new[] -> delete
	}

	char *data;
};

// ---

int *z;

void test12(bool cond)
{
	int *x, *y;

	x = new int();
	delete x; // GOOD
	x = (int *)malloc(sizeof(int));
	free(x); // GOOD

	if (cond)
	{
		y = new int();
		z = new int();
	} else {
		y = (int *)malloc(sizeof(int));
		z = (int *)malloc(sizeof(int));
	}

	// ...

	if (cond)
	{
		delete y; // GOOD
		delete z; // GOOD
	} else {
		free(y); // GOOD
		free(z); // GOOD
	}
}

// ---

class MyBuffer13
{
public:
	MyBuffer13(int size)
	{
		buffer = (char *)malloc(size * sizeof(char));
	}

	~MyBuffer13()
	{
		free(buffer); // GOOD
	}

	char *getBuffer() // note: this should not be considered an allocation function
	{
		return buffer;
	}

private:
	char *buffer;
};

class MyPointer13
{
public:
	MyPointer13(char *_pointer) : pointer(_pointer)
	{
	}

	MyPointer13(MyBuffer13 &buffer) : pointer(buffer.getBuffer())
	{
	}

	char *getPointer() // note: this should not be considered an allocation function
	{
		return pointer;
	}

private:
	char *pointer;
};

void test13()
{
	MyBuffer13 myBuffer(100);
	MyPointer13 myPointer2(myBuffer);
	MyPointer13 myPointer3(new char[100]);

	delete myPointer3.getPointer(); // GOOD
}
