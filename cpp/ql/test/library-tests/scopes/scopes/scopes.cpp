
class A {

};


class B {

};

class C: A, B {

};

class D: C {

	class E;

};

class D::E {

	class F;

	class G {

	};

};

class D::E::F: D::E::G {
  void doubleNestedFunction() {}
};

void f(int a, int b) {
	bool c = a==b;

	switch (a)
	{
	default:
	}
}

void g();

struct S {
	void af() {

	}
	void ag();
};

void g() {
	S s;
	s.ag();
}

class Name {
	const char* s;
};

class Table {
  Name* p;
  int sz;
public:
  Table(int s=15) { p = new Name[sz=s]; } // constructor
  ~Table() { delete[] p; }
  Name* lookup (const char*);
  bool insert(Name*);
};

extern "C" int strlen(const char*);

namespace One
{
	template <class T>
	class H
	{
		T t;
	};

	H<short> h_short;
	H<long> h_long;

	namespace Two
	{
		enum myEnum
		{
			myOne,
			myTwo,
			myThree
		};
	};

	class I
	{
		enum myEnum2
		{
			Alpha,
			Beta,
			Gamma
		};
	};
};