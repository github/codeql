void f(int a, int b) {
	bool c = a==b;
}

void g();

struct A {
	void af() {

	}
	void ag();
};

void g() {
	A a;
	a.ag();
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

class MyClass
{
public:
	MyClass();
	MyClass(int from);
	MyClass(const MyClass &from);
	MyClass(MyClass &&from);
	operator int();
};

void h(int x);
void h(int y);
