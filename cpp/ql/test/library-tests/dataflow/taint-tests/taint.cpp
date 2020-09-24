int source();
void sink(...) {};

void arithAssignments(int source1, int clean1) {
  sink(clean1); // clean
  clean1 += source1;
  clean1 += 1;
  sink(clean1); // tainted

  clean1 = source1 = 1;
  sink(clean1); // clean
  source1 = clean1 = source();
  source1++;
  ++source1;
  source1 += 1;
  sink(source1); // tainted
  sink(++source1); // tainted
}

// --- globals ---

int increment(int x) {return x + 1;}
int zero(int x) {return 0;}

int global1 = 0;
int global2 = source();
int global3 = global2 + 1;
int global4 = increment(source());
int global5 = zero(source());
int global6, global7, global8, global9, global10;

void do_source()
{
	global6 = 0;
	global7 = source();
	global8 = global7 + 1;
	global9 = increment(source());
	global10 = zero(source());

	sink(global6);
	sink(global7); // tainted
	sink(global8); // tainted
	sink(global9); // tainted
	sink(global10);
}

void do_sink()
{
	sink(global1);
	sink(global2); // tainted [NOT DETECTED]
	sink(global3); // tainted [NOT DETECTED]
	sink(global4); // tainted [NOT DETECTED]
	sink(global5);
	sink(global6);
	sink(global7); // tainted [NOT DETECTED]
	sink(global8); // tainted [NOT DETECTED]
	sink(global9); // tainted [NOT DETECTED]
	sink(global10);
}

void global_test()
{
	do_source();
	do_sink();
}

// --- class fields ---

class MyClass {
public:
	MyClass() : a(0), b(source()) {
		c = source();
		d = 0;
	}

	void myMethod() {
		d = source();
	}

	int a, b, c, d;
};

void class_field_test() {
	MyClass mc1, mc2;

	mc1.myMethod();

	sink(mc1.a);
	sink(mc1.b); // tainted
	sink(mc1.c); // tainted
	sink(mc1.d); // tainted
	sink(mc2.a);
	sink(mc2.b); // tainted
	sink(mc2.c); // tainted
	sink(mc2.d);
}

// --- arrays ---

void array_test(int i) {
	int arr1[10] = {0};
	int arr2[10] = {0};
	int arr3[10] = {0};

	arr1[5] = source();
	arr2[i] = source();
	arr3[5] = 0;

	sink(arr1[5]); // tainted
	sink(arr1[i]); // tainted
	sink(arr2[5]); // tainted
	sink(arr2[i]); // tainted
	sink(arr3[5]);
	sink(arr3[i]);
}

// --- pointers ---

void pointer_test() {
	int t1 = source();
	int t2 = 1;
	int t3 = 1;
	int *p1 = &t1;
	int *p2 = &t2;
	int *p3 = &t3;

	*p2 = source();

	sink(*p1); // tainted
	sink(*p2); // tainted
	sink(*p3);

	p3 = &t1;
	sink(*p3); // tainted

	*p3 = 0;
	sink(*p3); // [FALSE POSITIVE]
}

// --- return values ---

int select(int i, int a, int b) {
	if (i == 1) {
		return a;
	} else {
		return b;
	}
}

void fn_test(int i) {
	sink(select(i, 1, source())); // tainted
}

// --- strings ---

char *strcpy(char *destination, const char *source);
char *strcat(char *destination, const char *source);

namespace strings
{
	char *source(); // char* source

	void strings_test1() {
		char *tainted = source();
		char buffer[1024] = {0};

		sink(source()); // tainted
		sink(tainted); // tainted

		strcpy(buffer, "Hello, ");
		sink(buffer);
		strcat(buffer, tainted);
		sink(buffer); // tainted
	}
}

// --- pass by reference ---

namespace refs {
	void callee(int *p) {
		sink(*p); // tainted
	}

	void caller() {
		int x = source();
		callee(&x);
	}
}

void *memcpy(void *dest, void *src, int len);

void test_memcpy(int *source) {
	int x;
	memcpy(&x, source, sizeof(int));
	sink(x);
}

// --- std::swap ---

#include "swap.h"



void test_swap() {
	int x, y;

	x = source();
	y = 0;

	sink(x); // tainted
	sink(y); // clean

	std::swap(x, y);

	sink(x); // clean [FALSE POSITIVE]
	sink(y); // tainted
}

// --- lambdas ---

void test_lambdas()
{
	int t = source();
	int u = 0;
	int v = 0;
	int w = 0;

	auto a = [t, u]() -> int {
		sink(t); // tainted
		sink(u); // clean
		return t;
	};
	sink(a()); // tainted

	auto b = [&] {
		sink(t); // tainted
		sink(u); // clean
		v = source(); // (v is reference captured)
	};
	b();
	sink(v); // tainted [NOT DETECTED]

	auto c = [=] {
		sink(t); // tainted
		sink(u); // clean
	};
	c();

	auto d = [](int a, int b) {
		sink(a); // tainted
		sink(b); // clean
	};
	d(t, u);

	auto e = [](int &a, int &b, int &c) {
		sink(a); // tainted
		sink(b); // clean
		c = source();
	};
	e(t, u, w);
	sink(w); // tainted
}

// --- taint through return value ---

int id(int x)
{
	return x;
}

void test_return()
{
	int x, y, z, t;

	t = source();
	x = 0;
	y = 0;
	z = 0;

	sink(t); // tainted
	sink(x);
	sink(y);
	sink(z);

	x = id(t);
	y = id(id(t));
	z = id(z);

	sink(t); // tainted
	sink(x); // tainted
	sink(y); // tainted
	sink(z);
}

// --- taint through parameters ---

void myAssign1(int &a, int &b)
{
	a = b;
}

void myAssign2(int &a, int b)
{
	a = b;
}

void myAssign3(int *a, int b)
{
	*a = b;
}

void myAssign4(int *a, int b)
{
	int c;

	c = b + 1;
	*a = c;
}

void myNotAssign(int &a, int &b)
{
	a = a + 1;
	b = b + 1;
}

void test_outparams()
{
	int t, a, b, c, d, e;

	t = source();
	a = 0;
	b = 0;
	c = 0;
	d = 0;
	e = 0;

	sink(t); // tainted
	sink(a);
	sink(b);
	sink(c);
	sink(d);
	sink(e);

	myAssign1(a, t);
	myAssign2(b, t);
	myAssign3(&c, t);
	myAssign4(&d, t);
	myNotAssign(e, t);

	sink(t); // tainted
	sink(a); // tainted
	sink(b); // tainted
	sink(c); // tainted
	sink(d); // tainted
	sink(e);
}

// --- strdup ---

typedef unsigned long size_t;
char *strdup(const char *s1);
char *strndup(const char *s1, size_t n);
wchar_t* wcsdup(const wchar_t* s1);

void test_strdup(char *source)
{
	char *a, *b, *c;

	a = strdup(source);
	b = strdup("hello, world");
	c = strndup(source, 100);
	sink(a); // tainted
	sink(b);
	sink(c); // tainted
}

void test_strndup(int source)
{
	char *a;

	a = strndup("hello, world", source);
	sink(a); // tainted
}

void test_wcsdup(wchar_t *source)
{
	wchar_t *a, *b;

	a = wcsdup(source);
	b = wcsdup(L"hello, world");
	sink(a); // tainted
	sink(b);
}

// --- qualifiers ---

class MyClass2 {
public:
	MyClass2(int value);
	void setMember(int value);
	int getMember();

	int member;
};

class MyClass3 {
public:
	MyClass3(const char *string);
	void setString(const char *string);
	const char *getString();

	const char *buffer;
};

void test_qualifiers()
{
	MyClass2 a(0), b(0), *c;
	MyClass3 d("");

	sink(a);
	sink(a.getMember());
	a.setMember(source());
	sink(a); // tainted
	sink(a.getMember()); // tainted

	sink(b);
	sink(b.getMember());
	b.member = source();
	sink(b); // tainted
	sink(b.member); // tainted
	sink(b.getMember());

	c = new MyClass2(0);

	sink(c);
	sink(c->getMember());
	c->setMember(source());
	sink(c); // tainted (deref)
	sink(c->getMember()); // tainted

	delete c;

	sink(d);
	sink(d.getString());
	d.setString(strings::source());
	sink(d); // tainted
	sink(d.getString()); // tainted
}

// --- non-standard swap ---

void swop(int &a, int &b)
{
	int c = a;
	a = b;
	b = c;
}

void test_swop() {
	int x, y;

	x = source();
	y = 0;

	sink(x); // tainted
	sink(y); // clean

	swop(x, y);

	sink(x); // clean [FALSE POSITIVE]
	sink(y); // tainted
}

// --- getdelim ---

struct FILE;

int getdelim(char ** lineptr, size_t * n, int delimiter, FILE *stream);

void test_getdelim(FILE* source1) {
	char* line = nullptr;
	size_t n;
	getdelim(&line, &n, '\n', source1);

	sink(line);
}
