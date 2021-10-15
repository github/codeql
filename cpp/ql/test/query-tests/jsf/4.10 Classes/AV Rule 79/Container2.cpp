
template<class T>
class Container2
{
public:
	Container2() : ptr1(0), ptr2(0)
	{
		ptr1 = new T(); // GOOD
		Alloc();
	}

	~Container2()
	{
		delete ptr1;
		Free();
	}

	void Alloc()
	{
		ptr2 = new T(); // GOOD
		ptr3 = new T(); // BAD: not deleted in destructor
	}

	void Free()
	{
		delete ptr2;
	}

private:
	T *ptr1, *ptr2, *ptr3;
};

void myTestFunction()
{
	Container2<int> *myContainer2_i = new Container2<int>();
	Container2<char> *myContainer2_c = new Container2<char>();

	delete myContainer2_c;
	delete myContainer2_i;
}
