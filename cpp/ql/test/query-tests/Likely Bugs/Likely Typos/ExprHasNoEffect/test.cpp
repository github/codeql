




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

		++arg1; // pure, does nothing [NOT DETECTED]
		++arg2; // pure, does nothing [NOT DETECTED]
		++arg3; // not pure in all cases (when _It is int this has a side-effect)

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

namespace std {
  typedef unsigned long size_t;
}

void* operator new  (std::size_t size, void* ptr) noexcept;

struct Base {
  Base() { }

  Base &operator=(const Base &rhs) {
    return *this;
  }

  virtual ~Base() { }
};

struct Derived : Base {
  Derived &operator=(const Derived &rhs) {
    if (&rhs == this) {
      return *this;
    }

    // In case base class has data, now or in the future, copy that first.
    Base::operator=(rhs); // GOOD

    this->m_x = rhs.m_x;
    return *this;
  }

  int m_x;
};

void use_Base() {
  Base base_buffer[1];
  Base *base = new(&base_buffer[0]) Base();

  // In case the destructor does something, now or in the future, call it. It
  // won't get called automatically because the object was allocated with
  // placement new.
  base->~Base(); // GOOD (because the call has void type)
}
