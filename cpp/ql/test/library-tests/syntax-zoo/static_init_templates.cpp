
void write_ref(int &ref) {
	ref = 1;
}

class MyClass {
public:
	MyClass();
	~MyClass();

private:
	int val;
};

MyClass :: MyClass()
{
	int a, b, c, d, e; // BAD: 'e' is unused
	int &f = d;
	
	write_ref(a);
	val = b + f;
	throw c;
}

MyClass :: ~MyClass()
{
}

void test()
{
	MyClass mc; // GOOD: constructor and destructor may have side-effects
	MyClass *mc_ptr; // BAD: 'mc_ptr' is unused
	MyClass &mc_ref = mc; // BAD: 'mc_ref' is unused
}

// ---

template<class T> class container {
public:
	T t;
};

// static int variable in non-instantiated template function
template<typename T> void *templateFunction()
{
    static int my_static; // GOOD
    static void* my_ptr = &my_static;
    return my_ptr;
}


// static template parameter variable in non-instantiated template function
template<typename T> void *templateFunction2()
{
    static T my_static; // GOOD
    static void* my_ptr = &my_static;
    return my_ptr;
}

// static template derived variable in non-instantiated template function
template<typename T> void *templateFunction3()
{
    static container<T *> *my_static; // GOOD
    static void* my_ptr = &my_static;
    return my_ptr;
}

// static unused int variable in non-instantiated template function
template<typename T> void *templateFunction4()
{
    static int my_static; // BAD
    static void* my_ptr = 0;
    return my_ptr;
}

// static int variable in twice instantiated template function
template<typename T> void *instantiatedTemplateFunction()
{
    static int my_static; // GOOD
    static void* my_ptr = &my_static;
    return my_ptr;
}


// static template parameter variable in twice instantiated template function
template<typename T> void *instantiatedTemplateFunction2()
{
    static T my_static; // GOOD
    static void* my_ptr = &my_static;
    return my_ptr;
}

// static template derived variable in twice instantiated template function
template<typename T> void *instantiatedTemplateFunction3()
{
    static container<T *> *my_static; // GOOD
    static void* my_ptr = &my_static;
    return my_ptr;
}

// static unused int variable in twice instantiated template function
template<typename T> void *instantiatedTemplateFunction4()
{
    static int my_static; // BAD
    static void* my_ptr = 0;
    return my_ptr;
}

void caller()
{
	instantiatedTemplateFunction<int>();
	instantiatedTemplateFunction<float>();
	instantiatedTemplateFunction2<int>();
	instantiatedTemplateFunction2<float>();
	instantiatedTemplateFunction3<int>();
	instantiatedTemplateFunction3<float>();
	instantiatedTemplateFunction4<int>();
	instantiatedTemplateFunction4<float>();
}

// This is a non-template version of the above.
void *nonTemplateFunction()
{
    static int *my_static; // GOOD
    static void* my_ptr = &my_static;
    return my_ptr;
}

// This is a non-template version of the above.
void *nonTemplateFunction2()
{
    static int *my_static; // BAD
    static void* my_ptr = 0;
    return my_ptr;
}

// non-static int variable in non-instantiated template function
template<typename T> void *templateFunction5()
{
    int my_local; // GOOD
    void* my_ptr = &my_local;
    return my_ptr;
}

// non-static template parameter variable in non-instantiated template function
template<typename T> void *templateFunction6()
{
    T my_local; // GOOD
    void* my_ptr = &my_local;
    return my_ptr;
}

// non-static template derived variable in non-instantiated template function
template<typename T> void *templateFunction7()
{
    container<T *> *my_local; // GOOD
    void* my_ptr = &my_local;
    return my_ptr;
}

// non-static unused int variable in non-instantiated template function
template<typename T> void *templateFunction8()
{
    int my_local; // BAD
    void* my_ptr = 0;
    return my_ptr;
}

template<typename T> class templateClass
{
public:
	// static int variable in class template method
	void *templateClassMethod()
	{
		static int my_static; // GOOD
		void* my_ptr = &my_static;
		return my_ptr;
	}

	// static template parameter variable in class template method
	void *templateClassMethod2()
	{
		static T my_static; // GOOD
		void* my_ptr = &my_static;
		return my_ptr;
	}

	// static template derived variable in class template method
	void *templateClassMethod3()
	{
		static container<T *> *my_static; // GOOD
		void* my_ptr = &my_static;
		return my_ptr;
	}

	// static unused int variable in class template method
	void *templateClassMethod4()
	{
		static int my_static; // BAD
		void* my_ptr = 0;
		return my_ptr;
	}
};

templateClass<int> tc_i;

template<typename T> class MyTemplateClass2
{
public:
	void method()
	{
		static T *a; // BAD
		static T b; // GOOD - T could have a constructor / destructor
		static container<T> *c; // BAD
		static container<T *> d; // BAD [NOT DETECTED - due to type container<T *> depending on type container<T>, which *could* have a constructor, though as used here it can't]
		static container<T> e; // GOOD - T could have a constructor / destructor
	}
};

// ---

int myGlobal;

class MyMethodClass
{
public:
	void MyMethod() {myGlobal++;} // side-effect
};

class MyConstructorClass
{
public:
	MyConstructorClass() {myGlobal++;} // side-effect
};

class MyDerivedClass : public MyConstructorClass
{
};

class MyContainingClass
{
private:
	MyConstructorClass mcc;
};

void testFunction()
{
	MyMethodClass mmc; // BAD: unused
	MyConstructorClass mcc; // GOOD
	MyDerivedClass mdc; // GOOD
	MyContainingClass mcc2; // GOOD
}
