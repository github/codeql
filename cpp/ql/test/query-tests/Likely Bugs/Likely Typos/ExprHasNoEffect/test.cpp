




class MyIterator
{
public:
	MyIterator &operator++() // this class has a pure pre-increment operator
	{
		return (*this);
	}
};

template<class _Elem, class _It = MyIterator>
class MyTemplateClass
{
public:
	MyIterator myMethod() const
	{
		MyIterator arg1, arg2;
		_It arg3;

		++arg1; // pure, does nothing
		++arg2; // pure, does nothing
		++arg3; // not pure in all cases (when _It is int this has a side-effect) [FALSE POSITIVE]

		return arg2;
	}
};

void testFunc()
{
	{
		MyTemplateClass<int> myObj;
		MyIterator iter = myObj.myMethod();
	}
	{
		MyTemplateClass<int, int> myObj;
		MyIterator iter = myObj.myMethod();
	}
}

class Assignable
{
public:
	Assignable &operator=(Assignable &rhs)
	{
		// no side-effects

		return *this;
	}
};

class MyAssignable : public Assignable
{
};

void testFunc2()
{
	Assignable u1, u2;
	u2 = u1;

	MyAssignable v1, v2;
	v2 = v1;
}
