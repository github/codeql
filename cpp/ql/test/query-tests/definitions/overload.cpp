
class MyValue
{
public:
	MyValue(int _v) : v(_v) {};
	MyValue(const MyValue &other) : v(other.v) {};

	MyValue &operator=(const MyValue &other)
	{
		v = other.v;

		return *this;
	}

	MyValue operator*() // overload operator* to function as increment
	{
		MyValue temp(*this);
		v++;
		return temp;
	}

	int v;
};

void overload_test1()
{
	MyValue x(1), y = x;
	MyValue z(MyValue(x));

	y = ***x;
}
