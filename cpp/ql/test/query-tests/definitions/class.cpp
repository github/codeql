
class myClass
{
public:
	myClass() {};
	~myClass() {};
};

class myIntContainer
{
public:
	myIntContainer() : val(0) {};
	myIntContainer(int _val) : val(_val) {};
	~myIntContainer() {};

	void myMethod(myClass &mc) {};

private:
	int val;
};

template <class T>
class myTContainer
{
public:
	myTContainer(T _val) : val(_val) {};
	~myTContainer() {};

	void myMethod(myClass &mc) {};

private:
	T val;
};

myIntContainer mic(10);
myTContainer<char> mtc_c('a');

class myContainerContainer : myClass
{
public:
	myContainerContainer() {};
	~myContainerContainer() {};

private:
	myClass mc;
};

class implicitDestructorClass
{
public:
	myClass mc;

	implicitDestructorClass() {};
};

class implicitDestructorClass2
{
public:
	implicitDestructorClass idc;

	implicitDestructorClass2() {};
};

void myNewFunction()
{
	myClass *mc;

	mc = new myClass();

	delete mc;
}

class Number {
public:
  Number(int _num) : num(_num) {};

  Number operator/(const Number &other) {
    Number result(num / other.num);

    return result;
  }

private:
  int num;
};

Number Calc(int num)
{
  Number result(0);

  return result / (Number)num;
}

typedef wchar_t *string_type;
#define STR(x) L##x

class StringContainer
{
public:
	StringContainer(const string_type &str) {
		// ...
	}
};

StringContainer getAString() {
	return StringContainer(STR("Hello, world!"));
}

class myClassWithConstructorParams
{
public:
	myClassWithConstructorParams(int x, int y);
};

void testConstructors(int a, int b)
{
	myClassWithConstructorParams mcwcp(a, b);
	myClassWithConstructorParams *ptr;
	ptr = new myClassWithConstructorParams(a, b);
}
