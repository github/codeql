
class MyClassBase
{
public:
	virtual void method(int *ptr)
	{
		*ptr = 1;
	}
	
	int a;
};

class MyClass : public MyClassBase
{
	virtual void method(int *ptr)
	{
		*ptr = 2;
	}
};

void myFunction()
{
	MyClassBase *ptr1 = new MyClassBase();
	MyClassBase *ptr2 = new MyClass();
	int i;
	int j;

	ptr1->method(&i);
	ptr2->method(&j);
}
