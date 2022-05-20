
int *id(int *i_ptr)
{
	return i_ptr;
}

void ignore(int *i_ptr)
{
}

namespace ns
{
	// --- my_auto_ptr ---

	template<class T>
	class my_auto_ptr
	{
	public:
		my_auto_ptr(T *_ptr = 0) : ptr(_ptr) {};
		~my_auto_ptr() {delete ptr;}

		my_auto_ptr &operator=(my_auto_ptr &rhs)
		{
			if (ptr != rhs.ptr)
			{
				delete ptr;
				ptr = rhs.ptr;
				rhs.ptr = 0;
			}
            return *this;
        }

		T *operator->() {return ptr;}

	private:
		T *ptr;
	};
}

class AutoContainer
{
public:
	AutoContainer() : v(new float) // GOOD
	{
		ns::my_auto_ptr<double> ap(new double); // GOOD
	}

	ns::my_auto_ptr<float> v;
};

template<class T>
class AutoContainer2
{
public:
	AutoContainer2() : v(new T) // GOOD [FALSE POSITIVE]
	{
		ns::my_auto_ptr<T> ap(new T); // GOOD [FALSE POSITIVE]
	}

	ns::my_auto_ptr<T> v;
};

template<class T>
class AutoCloner
{
public:
	AutoCloner(T _val = 0) : val(_val) {};
	AutoCloner(AutoCloner &from) : val(from.val) {};

	ns::my_auto_ptr<AutoCloner> clone() {
		return ns::my_auto_ptr<AutoCloner>(new AutoCloner(*this)); // GOOD [FALSE POSITIVE]
	}

private:
	T val;
};

int main()
{
	int *i1 = new int; // BAD: never deleted
	int *i2 = id(new int); // BAD: never deleted
	ignore(new int); // BAD: never deleted

	ns::my_auto_ptr<char> a1(new char); // GOOD
	ns::my_auto_ptr<short> a2(new short); // GOOD
	ns::my_auto_ptr<short> a3(new short); // GOOD
	a3 = a2;

	AutoContainer ac1;
	AutoContainer2<long> ac2;

	ns::my_auto_ptr<AutoCloner<long long> > ac3(new AutoCloner<long long>()); // GOOD
	ns::my_auto_ptr<AutoCloner<long long> > ac4 = ac3->clone();

	return 0;
}
