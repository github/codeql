// bad: gratuitous default constructor
class Bad
{
private:
	int key;
	int value;
public:
	Bad();
	Bad(int);
	Bad(int, int);
	int cmp(const Bad& that);
};

Bad::Bad() : key(-1)				// non-compliant
{
}

Bad::Bad(int k) : key(k)			// compliant
{
}

Bad::Bad(int k, int v)				// compliant
{
	key = k;
	value = v;
}

int Bad::cmp(const Bad& that)
{
	if(this->key == -1)
		return 1;
	if(that.key == -1)
		return -1;
	return this->key - that.key;
}

// good: default constructor is necessary because we allocate an array of Good
class Good
{
private:
	char *cp;
public:
	Good();
	Good(char *const cpp);
	char getChar();
};

Good::Good() : cp(0)						// compliant
{
}

Good::Good(char *const cpp) : cp(cpp)
{
}

char Good::getChar()
{
	if(cp == 0)
		return '\0';
	return *cp;
}

Good *gd = new Good[16];

// good: default constructor is necessary because we instantiate a template with AlsoGood
class AlsoGood
{
private:
	char *cp;
public:
	AlsoGood();
	AlsoGood(char *const cpp);
	char getChar();
};

AlsoGood::AlsoGood()								// compliant [FALSE POSITIVE]
{
	cp = 0;
}

AlsoGood::AlsoGood(char *const cpp) : cp(cpp)
{
}

char AlsoGood::getChar()
{
	if(cp == 0)
		return '\0';
	return *cp;
}

template<class T> class Container {
private:
	T *data;
public:
	Container();
};

template<class T> Container<T>::Container()
{
	data = new T();
}

Container<AlsoGood> *foo;

// good: default constructor is convenient since StillGood is a virtual base class
class StillGood
{
private:
	char *cp;
public:
	StillGood();
	StillGood(char *const cpp);
	char getChar();
};

StillGood::StillGood() : cp(0)						// compliant
{
}

StillGood::StillGood(char *const cpp) : cp(cpp)
{
}

char StillGood::getChar()
{
	if(cp == 0)
		return '\0';
	return *cp;
}

class Child : public virtual StillGood
{
};

double sqrt(double d);

// good: members have sensible default values
class Coord
{
private:
	double x, y;
public:
	Coord();
	Coord(double, double);
	double dist();
};

Coord::Coord() : x(0), y(0)								// compliant
{
}

Coord::Coord(double x, double y) : x(x), y(y)
{
}

double Coord::dist()
{
	return sqrt(x*x+y*y);
}
