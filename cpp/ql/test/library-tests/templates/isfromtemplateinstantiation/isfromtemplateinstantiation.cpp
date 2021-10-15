#define A_MACRO i++
// semmle-extractor-options: -std=c++14
// non-template function
void normal_function()
{
	int i = 0;

	i++;
}

// nested template function
template<class T> void inner_template_function()
{
	T t;

	t++;
}

template<class T> void outer_template_function()
{
	int i = 0;

	A_MACRO;

	inner_template_function<T>();
}

// non-template class
class normal_class
{
	int i;

public:	
	void a_method()
	{
	}
	
	template <class T> void a_template_method()
	{
	}
};

// template class
template <class T> class template_class
{
	T t;

public:
	void b_method()
	{
	}
	
	template <class U> void b_template_method(U u)
	{
	}
};

// main
int main()
{
	normal_function();
	outer_template_function<short>();
	outer_template_function<long>();

	{
		normal_class o1;
		template_class<char> o2;
	
		o1.a_method();
		o1.a_template_method<short>();
		o2.b_method();
		o2.b_template_method<long>('a');
	}
}

// another template class
template <class T> class AnotherTemplateClass
{
public:
	typedef T _t;

	struct MyClassStruct
	{
		_t value;
	};
	MyClassStruct l;

	enum MyClassEnum
	{
		MyClassEnumConst
	};

	void myMethod1(MyClassEnum mce1 = MyClassEnumConst) {}
	void myMethod2(MyClassEnum mce2 = MyClassEnumConst);
};

template <class T> void AnotherTemplateClass<T> :: myMethod2(MyClassEnum mce2)
{
}

AnotherTemplateClass<int> atc_int;

void anotherMain()
{
	atc_int.myMethod1();
	atc_int.myMethod2();
}

template <typename T>
T var_template;

int normal_var;

void function_using_vars()
{
	var_template<int> = 1;
	normal_var = 2;
}

// full specialization: _not_ an uninstantiated template.
template<>
class AnotherTemplateClass<long> {
	int f() { return 0; }
};

// partial specialization: _is_ and uninstantiated template.
template<class T>
class AnotherTemplateClass<T*> {
	int f() { return 1; }
};

template class AnotherTemplateClass<long*>;

template<typename T> struct Outer {
  template<typename U> struct Inner {
    U x;
    T y;
  };
};

template class Outer<int>::Inner<long>;


template<typename T> class incomplete_never_instantiated;

template<typename T> class never_instantiated { T x; };

template<typename T> T decl_never_instantiated(T x);

template<typename T> T def_never_instantiated(T x) { return x; }
