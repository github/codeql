// Semmle test cases for rule CWE-401 (child of CWE-772).

// --- library types, functions etc ---

#define NULL (0)
typedef unsigned long size_t;
void *malloc(size_t size);
void free(void *ptr);
void *realloc(void *ptr, size_t size);

// --- tests ---

void test1()
{
	char *ptr;

	// malloc, always free (GOOD)
	ptr = (char *)malloc(100);
	free(ptr);
}

void test2()
{
	// malloc, always free (GOOD)
	void *ptr = malloc(sizeof(int));
	free(ptr);
}

void test3()
{
	// malloc, always free (GOOD)
	void *ptr;

	ptr = malloc(sizeof(char) * 1024);
	if (ptr == NULL)
	{
		return;
	}
	
	free(ptr);
}

void test4(int cond)
{
	// malloc, always free (GOOD)
	void *ptr;

	ptr = malloc(sizeof(char) * 1024);
	if (cond == 0)
	{
		free(ptr);
	} else {
		free(ptr);
	}
}

void test5(int cond)
{
	// malloc, sometimes free
	void *ptr;

	ptr = malloc(sizeof(char) * 1024); // BAD: not always freed
	if (cond == 0)
	{
		free(ptr);
	}
}

void test6(int cond)
{
	// malloc, sometimes free
	void *ptr;

	ptr = malloc(sizeof(char) * 1024); // BAD: not always freed
	if (cond == 0)
	{
		return;
	}
	
	free(ptr);
}

void test7()
{
	// malloc, reassign, free (GOOD)
	void *a, *b;

	a = malloc(10);
	b = a;
	free(b);
}

void test8()
{
	// malloc, reassign, don't free
	char *a, *b;

	a = (char *)malloc(10); // BAD: a is not freed
	b = a;
}

void test9()
{
	// malloc, overwrite, don't free
	char *a;

	a = (char *)malloc(10); // BAD: not freed
	a = (char *)malloc(20);
	free(a);
}

int *test10_alloc()
{
	void *ptr = malloc(1024 * sizeof(int));

	return (int *)ptr;
}

void test10_free(int *ptr)
{
	free(ptr);
}

void test10(int cond)
{
	int *a, *b, *c;

	// alloc, free via intermediate functions (GOOD)
	a = test10_alloc();

	// ...

	test10_free(a);
	
	// alloc, don't free b
	b = test10_alloc(); // BAD: b is never freed
	
	// alloc, sometimes free c
	c = test10_alloc(); // BAD: c is not always freed
	if (cond == 0)
	{
		return;
	}
	test10_free(c);
}

class myClass11
{
public:
	myClass11() : a(NULL), b(NULL), c(NULL)
	{
		a = (char *)malloc(1); // freed in destructor (GOOD)
		b = (char *)malloc(1); // unreliably freed in destructor (BAD) [NOT REPORTED]
		c = (char *)malloc(1); // never freed in destructor (BAD)
	}
	
	void myAllocMethod(int amount)
	{
		if (d != NULL)
		{
			free(d);
			d = NULL;
		}

		d = (char *)malloc(amount); // not always freed (BAD) [NOT REPORTED]
	}

	~myClass11()
	{
		if (a != NULL)
		{
			free(a);
			a = NULL;
		}
		if (a != NULL) // oops!
		{
			free(b);
			b = NULL;
		}
	}

private:
	char *a, *b, *c, *d;
};

void test11()
{
	myClass11 mc11;
	
	mc11.myAllocMethod(1);
	mc11.myAllocMethod(1);
}

void test13()
{
	void *a = new int;      // new, delete (GOOD)
	void *b = new char[10]; // new, delete (GOOD)
	char *c = new char[20]; // new, delete (GOOD)
	void *d = new int;      // new, don't delete (BAD)
	void *e = new char[10]; // new, don't delete (BAD)
	char *f = new char[20]; // new, don't delete (BAD)

	delete (int *)a;
	delete [] (int *)b;
	delete [] c;
}

typedef void *alloc_func(size_t size);
typedef void free_func(void *);

void *test14_alloc(size_t size)
{
	return malloc(size); // this is a wrapped function (GOOD)
}

void test14_free(void *ptr)
{
	free(ptr);
}

void test14()
{
	alloc_func *af = NULL;
	free_func *ff = NULL;
	void *a, *b;
	
	af = &test14_alloc;
	ff = &test14_free;

	// alloc, free via function pointers (GOOD)
	a = af(1000);
	ff(a);

	// alloc, don't free via function pointer (BAD)
	b = af(2000);
}

void test15()
{
	void *ptr1, *ptr2, *ptr3;

	ptr1 = realloc(NULL, 10); // alloc 10 bytes (BAD - not freed if the next realloc fails)
	ptr1 = realloc(ptr1, 20); // realloc 20 bytes (GOOD)
	ptr1 = realloc(ptr1, 0); // free (GOOD)
	
	ptr2 = realloc(NULL, 10); // alloc 10 bytes (BAD - only freed if the call below succeeds)
	ptr2 = realloc(ptr2, 20); // realloc 20 bytes, never free (BAD)
	
	ptr3 = realloc(NULL, 10); // alloc 10 bytes, never free (BAD)
}

void test16(int cond)
{
	void *ptr = malloc(1024); // not always freed (BAD)
	if (ptr)
	{
		if (cond)
		{
			// ...
			
			free(ptr);
			return;
		} else {
			// ...

			return;
		}
	}
}

void test17(int cond)
{
	// malloc, sometimes free (BAD: ptr is not always freed)
	void *ptr = malloc(1024);

	if (cond == 0)
	{
		free(ptr);
	}

	return;
}

void test18(int cond)
{
	// malloc, sometimes free (BAD: ptr is not always freed)
	void *ptr = malloc(1024);

	if (cond == 0)
	{
		free(ptr);
		return;
	}
}

void test19()
{
	// malloc, retry, free (GOOD)
	void *ptr = malloc(1024 * 10);

	if (ptr == NULL)
	{
		ptr = malloc(1024);
	}

	free(ptr);
}

void test20()
{
	// malloc, free (GOOD)
	int x, y, z;
	
	{
		void *a;

		a = malloc(10);
		free(a);
	}
}

void test21()
{
	// malloc, reassign via initialization, free (GOOD)
	void *a;

	a = malloc(10);
	{
		void *b = a;

		free(b);
	}
}

class Vector3
{
public:
	Vector3(float _x, float _y, float _z) : x(_x), y(_y), z(_z) {};

private:
	float x, y, z;
};

void test22(int cond)
{
	{
		// new, delete (GOOD)
		Vector3 *myVector1 = new Vector3(1.0f, 2.0f, 3.0f);

		delete myVector1;
	}

	{
		// new, don't delete (BAD)
		Vector3 *myVector2 = new Vector3(1.0f, 2.0f, 3.0f);
	}

	{
		// new, sometimes delete (BAD)
		Vector3 *myVector3 = new Vector3(1.0f, 2.0f, 3.0f);

		if (cond) {
			delete myVector3;
		}
	}
}

struct thing
{
	int value;
};

struct container
{
	thing *thingPtr;
};

void test23()
{
	{
		// malloc, free incorrectly (BAD)
		char *buffer = (char *)malloc(100);

		free(buffer + 10);
	}

	{
		// new, delete incorrectly
		container *c = new container;
		c->thingPtr = new thing; // BAD: not deleted [NOT REPORTED]

		delete c;
	}

	{
		// new, delete incorrectly
		container *c = new container; // BAD: not deleted
		c->thingPtr = new thing;

		delete c->thingPtr;
	}
}

struct test24_struct
{
	int x, y, z;
};

test24_struct *test24_global;

void test24_set(test24_struct *s)
{
	test24_global = s;
}

void test24_new_and_set()
{
	test24_struct *s;

	// new, call function to assign to global (GOOD)
	s = new test24_struct;
	s->x = 1;
	s->y = 2;
	s->z = 3;

	test24_set(s);
}

void test24()
{
	// new, delete
	test24_new_and_set();

	delete test24_global;
}

void test25()
{
	void *ptr1 = NULL, *ptr2 = NULL, *ptr3 = NULL, *ptr4 = NULL;
	void *ptr5, *ptr6, *ptr7;

	ptr1 = realloc(NULL, 10); // alloc 10 bytes (GOOD)
	ptr2 = realloc(ptr1, 20); // realloc 20 bytes (GOOD)
	if (ptr2 == NULL)
	{
		// clean up still allocated ptr1
		free(ptr1);
	}
	realloc(ptr2, 0); // equivalent to free(ptr2) (GOOD)
	
	ptr3 = realloc(NULL, 10); // alloc 10 bytes (BAD - not freed if next realloc fails)
	ptr4 = realloc(ptr3, 20); // realloc 20 bytes (GOOD)
	if (ptr4 != NULL) // (this checks for success instead of failure!)
	{
		// clean up still allocated ptr3
		free(ptr3);
	}
	realloc(ptr4, 0); // equivalent to free(ptr4) (GOOD)	

	ptr5 = realloc(NULL, 10); // alloc 10 bytes (BAD - not freed if the next realloc fails)
	ptr6 = realloc(ptr5, 20); // realloc 20 bytes (GOOD)
	ptr7 = realloc(ptr6, 0); // free (GOOD)
}

class myList26
{
public:
	myList26() : next(NULL) {}

	myList26 *next;
};

class myList26 *allNodes[1024]; // all dynamically allocated myList26 nodes (rather basic implementation)
int numNodes = 0;

myList26 *extendList(myList26 *pList)
{
	myList26 *pNewList = new myList26();
	allNodes[numNodes++] = pNewList;

	pNewList->next = pList;

	return pNewList;
}

void processList(myList26 *pList)
{
	// ...
}

void myFunction26(myList26 *pList)
{
	myList26 *pExtendedList = extendList(pList);

	processList(pExtendedList);
}

void test26()
{
	// GOOD: all list nodes are freed
	myList26 list;
	int i;

	myFunction26(&list);

	// delete all list nodes
	for (i = 0; i < numNodes; i++)
	{
		delete allNodes[i];
	}
}

void dostuff()
{
	// ...
}

void test27()
{
	void *ptr = NULL;

	ptr = realloc(ptr, 10); // BAD (not freed if the second realloc fails)
	if (ptr != NULL)
	{
		ptr = realloc(ptr, 20); // BAD (not freed)
		if (ptr != NULL)
		{
			dostuff();
		}
	}

	dostuff();
}

void test28()
{
	void *ptr = NULL, *ptr_old = NULL;

	ptr = realloc(ptr, 10); // GOOD
	if (ptr != NULL)
	{
		ptr_old = ptr;

		ptr = realloc(ptr, 20); // GOOD
		if (ptr != NULL)
		{
			dostuff();

			free(ptr);
		}

		free(ptr_old);
	}

	dostuff();
}

// placement new
void* operator new(size_t, void* p);

class MyClass29
{
};

void test29()
{
	void *buf = malloc(sizeof(MyClass29)); // GOOD (freed)
	MyClass29 *p1 = new (buf) MyClass29(); // GOOD (not really an allocation)
	free(buf);
}

// run tests
int main(int argc, char *argv[])
{
	test1();
	test2();
	test3();
	test4(argc);
	test5(argc);
	test6(argc);
	test7();
	test8();
	test9();
	test10(argc);
	test11();
	test13();
	test14();
	test15();
	test16(argc);
	test17(argc);
	test18(argc);
	test19();
	test20();
	test21();
	test22(argc);
	test23();
	test24();
	test25();
	test26();
	test27();
	test28();
	test29();
}
