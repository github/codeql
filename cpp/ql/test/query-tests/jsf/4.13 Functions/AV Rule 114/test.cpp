// semmle-extractor-options: -std=c++11
class MyValue {
public:
	MyValue(int _val) : val(_val) {};

private:
	int val;
};

MyValue g1()
{
	return MyValue(1); // GOOD
}

MyValue g2()
{
	// BAD
}

MyValue g3()
{
	throw MyValue(3); // GOOD
}

MyValue g4()
{
	throw "fail"; // GOOD
}

MyValue g5(bool c)
{
	if (c) throw "fail";

	return MyValue(5); // GOOD
}

MyValue g6(bool c)
{
	if (c) return MyValue(6);

	throw "fail"; // GOOD
}

#define DONOTHING

MyValue g7(bool c)
{
	if (c) return MyValue(7);
	DONOTHING
	DONOTHING
	// BAD
}

typedef void MYVOID;
MYVOID g8()
{
	// GOOD
}

template<class T, class U>
class TypePair
{
public:
	typedef T first;
	typedef U second;
};

TypePair<void, int>::first g9()
{
	// GOOD (the return type amounts to void)
}

TypePair<void, int>::second g10()
{
	// BAD (the return type amounts to int)
}

template<class T>
typename TypePair<void, T>::first g11()
{
	// GOOD (the return type amounts to void)
}

template<class T>
typename TypePair<void, T>::second g12()
{
	// BAD (the return type amounts to T / int)
}

void instantiate()
{
	g11<int>();
	g12<int>();
}

void myThrow(const char *error)
{
	throw error;
}

int g13()
{
	myThrow("fail"); // GOOD
}

int g14(int x)
{
	if (x < 10)
	{
		myThrow("fail"); // BAD (doesn't always throw)
	}
}

int g15(int x)
{
	if (x < 10)
	{
		return x;
	} else {
		myThrow("fail"); // GOOD
	}
}

void myConditionalThrow(bool condition, const char *error)
{
	if (condition)
	{
		throw error;
	}
}

int g16(int x)
{
	myConditionalThrow(x < 10, "fail"); // BAD (doesn't always throw)
}

int g17(int x)
{
	try
	{
		myConditionalThrow(x < 10, "fail");
	} catch (...) {
		return x; // BAD (doesn't always reach this return)
	}
}

int g18(int x)
{
	try
	{
		myThrow("fail");
	} catch (...) {
		return x; // GOOD [FALSE POSITIVE]
	}
}

int g19(int x)
{
	try
	{
		myThrow("fail");
	} catch (...) {
	}

	return x; // GOOD
}

[[noreturn]] void g20();

int g21() {
    g20(); // GOOD
}
