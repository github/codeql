
#define NULL (0)

class MyNumber
{
public:
	MyNumber() : value(0)
	{
	}
	
	MyNumber(int _value) : value(_value)
	{
	}

	int value;
};

class MyClass5
{
public:
	MyClass5()
	{
		n = new MyNumber(); // BAD: not deleted
	}

private:
	MyNumber *n;
};

class MyClass6
{
public:
	MyClass6() : n(100) // GOOD: not an allocated / acquired resource
	{
	}

private:
	MyNumber n;
};

class MyClass7Base
{
public:
	MyClass7Base()
	{
	}
	
	virtual ~MyClass7Base()
	{
		if (n != NULL)
		{
			delete n;
			n = NULL;
		}
	}

protected:
	MyNumber *n;
};

class MyClass7 : public MyClass7Base
{
public:
	MyClass7()
	{
		n = new MyNumber(200); // GOOD: deleted in base class
	}
};

template<class T>
class TemplateWithDestructor
{
public:
	TemplateWithDestructor(int len) {
		ptr = new char[len]; // GOOD
	}

	~TemplateWithDestructor()
	{
		delete [] ptr;
	}

private:
	char *ptr;
};

void test() {
	TemplateWithDestructor<int *> *t_ptr = new TemplateWithDestructor<int *>(10);
	//delete t_ptr; --- destructor never used
}
