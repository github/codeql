
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
	// BAD [the alert here is unfortunately placed]
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
