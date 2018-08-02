
// library
typedef unsigned int size_t;
void *malloc(size_t size);
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
