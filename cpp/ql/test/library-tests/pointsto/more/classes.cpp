// pointsto on classes

class myClass
{
public:
	myClass() : ptr1(0), ptr2(0) {};

	void set1(int *ptr)
	{
		ptr1 = ptr;
	}
	
	void set2(int *ptr)
	{
		ptr2 = ptr;
	}

	int *get1()
	{
		return ptr1; // &x, &z
	}
	
	int *get2()
	{
		return ptr2; // &y
	}

private:
	int *ptr1, *ptr2;
};

int *myFunction()
{
	int x, y, z;
	myClass a, b;

	a.set1(&x);
	a.set2(&y);
	b.set1(&z);

	return a.get1(); // [EXPECTED: x]
}

// ---

struct myStruct2
{
	int *ptr;
};

class myClass2
{
public:
	myClass2(myStruct2 _s) : s(_s) {};

	myStruct2 s;
};

int *myFunction2()
{
	int x;
	myStruct2 s2;
	s2.ptr = &x;
	myClass2 mc2(s2);

	return mc2.s.ptr; // &x
}
