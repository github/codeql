namespace NS1
{
  typedef int WIDTH;
}

void f1()
{
  typedef int TYPE;
  class D {};
}

class A
{

protected:
	typedef NS1::WIDTH WIDTH;
	typedef WIDTH WIDTH2;

public:
	typedef WIDTH WIDTH3;

private:
	typedef WIDTH WIDTH4;
};

class B: public A {
	WIDTH i;
	WIDTH2 i2;
	WIDTH3 i3;
	//WIDTH4 i4; --- inaccessible
};
