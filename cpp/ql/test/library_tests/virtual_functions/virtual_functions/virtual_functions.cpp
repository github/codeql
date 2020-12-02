class A
{
public:
	virtual void withunusedpara(int * para1, int unusedpara) = 0;
	virtual void withunusedpara(int * para1, int & para2) = 0;
};

class B1: public A
{
public:
	virtual void withunusedpara(int * para1, int unusedpara)
	{
		*para1 = 1U;
	}
	virtual void withunusedpara(int * para1, int & para2)
	{
		*para1 = 1U;
	}
};

class B2: public A
{
public:
	virtual void withunusedpara(int * para1, int unusedpara)
	{
		*para1 = 1U;
	}
	virtual void withunusedpara(int * para1, int & para2)
	{
		para2 = 0;
	}
};

struct X1 { virtual void f() {} };
struct X2 : X1 {};
struct X3 : X2 { void f() {} };
struct X4 : X2 { void f() {} };
struct X5 : X3, X4 { void f() {} };
struct X6 : X5 {};
struct X7 : X6 { void f() {} };

struct Y1 { virtual void f() {} };
struct Y2 : Y1 {};
struct Y3 : virtual Y2 { void f() {} };
struct Y4 : virtual Y2 { void f() {} };
struct Y5 : Y3, Y4 { void f() {} };
struct Y6 : Y5 {};
struct Y7 : Y6 { void f() {} };
