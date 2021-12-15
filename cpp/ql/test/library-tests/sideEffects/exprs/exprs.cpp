
class MyIterator
	{
public:
	MyIterator &operator++()
		{
		return (*this);
		}
	
	MyIterator &operator--()
		{
		v--;
		return (*this);
		}

private:
	int v;
	};

void f2() {
	MyIterator mi;
	
	++mi;
	--mi;
}

template<class T> void myTemplateFunction() {
	static MyIterator mi;
	static int i;
	static T t;

	++mi; // pure
	++i; // impure
	++t; // varies
}

void f3() {
	myTemplateFunction<MyIterator>();
	myTemplateFunction<int>();
}
