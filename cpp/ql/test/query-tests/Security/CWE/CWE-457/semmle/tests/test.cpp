// Semmle test cases for rule CWE-457.

void use(...);

void test1() {
	int foo = 1;
	use(foo); // GOOD
}

void test2() {
	int foo;
	use(foo); // BAD
}

void test3(bool b) {
	int foo;
	if (b) {
		foo = 1;
	} else {
		foo = 2;
	}
	use(foo); // GOOD
}

void test4(bool b) {
	int foo;
	if (b) {
		foo = 1;
	}
	use(foo); // BAD [NOT DETECTED]
}

void test5() {
	int foo;
	for (int i = 0; i < 10; i++) {
		foo = i;
	}
	use(foo); // GOOD
}

void test5(int count) {
	int foo;
	for (int i = 0; i < count; i++) {
		foo = i;
	}
	use(foo); // BAD [NOT DETECTED]
}

void test6(bool b) {
	int foo;
	if (b) {
		foo = 42;
	}
	if (b) {
		use(foo); // GOOD
	}
}

void test7(bool b) {
	bool set = false;
	int foo;
	if (b) {
		foo = 42;
		set = true;
	}
	if (set) {
		use(foo); // GOOD
	}
}

void test8() {
	int foo;
	int count = 1;
	while (count > 0) {
		foo = 42;
		count--;
	}
	use(foo); // GOOD
}

void test9(int count) {
	int foo;
	bool set = false;
	while (count > 0) {
		foo = 42;
		set = true;
		count--;
	}
	if (!set) {
		foo = 42;
	}
	use(foo); // GOOD
}

void test10() {
	extern int i;
	use(i); // GOOD
}

void test11() {
	static int i;
	use(i); // GOOD
}

void test12() {
	static int i[10];
	use(i[0]); // GOOD
}

void test13() {
	int foo;
	&foo;
	use(foo); // BAD
}

void init(int* p) { *p = 1; }

void test14() {
	int foo;
	init(&foo);
	use(foo); // GOOD
}

// Example from qhelp
int absWrong(int i) {
	int j;
	if (i > 0) {
		j = i;
	} else if (i < 0) {
		j = -i;
	}
	return j; // wrong: j may not be initialized before use [NOT DETECTED]
}

// Example from qhelp
int absCorrect1(int i) {
	int j = 0;
	if (i > 0) {
		j = i;
	} else if (i < 0) {
		j = -i;
	}
	return j; // correct: j always initialized before use
}

// Example from qhelp
int absCorrect2(int i) {
	int j;
	if (i > 0) {
		j = i;
	} else if (i < 0) {
		j = -i;
	} else {
		j = 0;
	}
	return j; // correct: j always initialized before use
}

typedef __builtin_va_list va_list;
#define va_start(v, l)	__builtin_va_start(v,l)
#define va_end(v)	__builtin_va_end(v)
#define va_arg(v, l)	__builtin_va_arg(v,l)
#define va_copy(d, s)	__builtin_va_copy(d,s)

#define NULL 0

// Variadic initialisation
void init(int val, ...) {
  int* ptr;
  va_list args;
  va_start(args, val);
  while ((ptr = va_arg(args, int*)) != NULL) {
    *ptr = val;
  }
}

void test15() {
  int foo;
  init(42, &foo, NULL);
  use(foo); // GOOD -- initialised by `init`
}

// Variadic non-initialisation
void nonInit(int val, ...) {
  int* ptr;
  va_list args;
  va_start(args, val);
}

void test16() {
  int foo;
  nonInit(42, &foo, NULL);
  use(foo); // BAD (NOT REPORTED)
}

void test_va_copy(va_list va) {
  va_list va2;
  va_copy(va2, va); // GOOD -- this is an initialization
  use(va2);
  va_end(va2);
}

bool test17(bool b) {
  int foo;
  int *p = nullptr;
  if (b) {
    p = &foo;
  }
  return p == &foo; // GOOD -- value of `foo` ignored
}

void test18() {
  int x;
  *&x = 1;
  use(x); // GOOD
}

void test19() {
  int x;
  ((char*)(void*)&x)[0] = 0;
  use(x); // GOOD, conservatively assuming only the first byte is needed
}


void test20() {
  int x;
  x += 0; // BAD
  use(x);
}

class MyValue {
public:
	MyValue() {};
	MyValue(int _val) : val(_val) {};

	MyValue operator>>(int amount)
	{
		return MyValue(val >> amount);
	}

	int val;
};

void test21()
{
	MyValue v1(1);
	MyValue v2;
	MyValue v3;
	int i;

	v3 = v1 >> i; // BAD: i is not initialized
	v3 = v2 >> 1; // BAD: v2 is not initialized [NOT DETECTED]
}

int test22() {
	bool loop = true;
	int val;

	while (loop)
	{
		val = 1;
		loop = false;
	}
	return val; // GOOD
}

int test23() {
	bool loop = true, stop = false;
	int val;

	while (loop && true)
	{
		val = 1;
		loop = false;
	}
	return val; // GOOD
}

int test24() {
	bool stop = false;
	int val;

	while (!stop)
	{
		val = 1;
		stop = true;
	}
	return val; // GOOD
}

int test25() {
	bool loop = true, stop = false;
	int val;

	while (true && loop)
	{
		val = 1;
		loop = false;
	}
	return val; // GOOD
}

int test26() {
	bool loop = true, stop = false;
	int val;

	while (loop && loop)
	{
		val = 1;
		loop = false;
	}
	return val; // GOOD
}

int test27() {
	bool loop = true, stop = false;
	int val;

	while (loop || false)
	{
		val = 1;
		loop = false;
	}
	return val; // GOOD
}

int test28() {
	bool a = true, b = true, c = true;
	int val;

	while (a ? b : c)
	{
		val = 1;
		a = false;
		c = false;
	}
	return val; // GOOD
}

int test29() {
	bool a, b = true, c = true;
	int val;

	while ((a && b) || c) // BAD (a is uninitialized)
	{
		val = 1;
		b = false;
		c = false;
	}
	return val; // GOOD
}

int test30() {
	int val;

	do
	{
		val = 1;
	} while (false);
	return val; // GOOD
}

int test31() {
	bool loop = true;
	bool stop = false;
	bool a, b = true, c = true;
	int val;

	while (loop || false)
	{
		loop = false;
	}
	while (!stop)
	{
		stop = true;
	}
	while ((a && b) || c) // BAD (a is uninitialized)
	{
		b = false;
		c = false;
	}
	do
	{
	} while (false);

	return val; // BAD
}

int test32() {
	int val;

	while (true)
	{
	}

	return val; // GOOD (never reached)
}

int test33() {
	int val;

	while (val = 1, true) {
		return val; // GOOD
	}
}

int test34() {
	bool loop = true;
	int val;

	{
		while (loop)
		{
			val = 1;
			loop = false;
		}
	}
	return val; // GOOD
}

int test35() {
	int i, j;

	for (int i = 0; i < 10; i++, j = 1) {
		return j; // BAD
	}
}

int test36() {
	int i, j;

	for (int i = 0; i < 10; i++, j = 1) {
	}

	return j; // GOOD
}

int test38() {
	int i, j;

	for (int i = 0; false; i++, j = 1) {
	}

	return j; // BAD
}

void test39() {
	int x;

	x; // GOOD, in void context
}

void test40() {
	int x;

	(void)x; // GOOD, explicitly cast to void
}

void test41() {
	int x;

	x++; // BAD
}

void test42() {
	int x;

	void(x++); // BAD
}

void test43() {
	int x;
	int y = 1;

	x + y; // BAD
}

void test44() {
	int x;
	int y = 1;

	void(x + y); // BAD
}

enum class State { StateA, StateB, StateC };

int exhaustive_switch(State s) {
	int y;
	switch(s) {
		case State::StateA:
			y = 1;
			break;
		case State::StateB:
			y = 2;
			break;
		case State::StateC:
			y = 3;
			break;
	}
	return y; // GOOD (y is always initialized)
}

int exhaustive_switch_2(State s) {
	int y;
	switch(s) {
		case State::StateA:
			y = 1;
			break;
		default:
			y = 2;
			break;
	}
	return y; // GOOD (y is always initialized)
}

int non_exhaustive_switch(State s) {
	int y;
	switch(s) {
		case State::StateA:
			y = 1;
			break;
		case State::StateB:
			y = 2;
			break;
	}
	return y; // BAD [NOT DETECTED] (y is not initialized when s = StateC)
}

int non_exhaustive_switch_2(State s) {
	int y;
	switch(s) {
		case State::StateA:
			y = 1;
			break;
		case State::StateB:
			y = 2;
			break;
	}
	if(s != State::StateC) {
		return y; // GOOD (y is not initialized when s = StateC, but if s = StateC we won't reach this point)
	}
	return 0;
}

class StaticMethodClass{
    public:
    static int get(){
        return 1;
    }
};

int static_method_false_positive(){
    StaticMethodClass *t;
	int i = t->get(); // GOOD: the `get` method is static and this is equivalent to StaticMethodClass::get()
}

struct LinkedList
{
  LinkedList* next;
};

bool getBool();

void test45() {
  LinkedList *r, *s, **rP = &r;

  while(getBool())
  {
    s = new LinkedList;
    *rP = s;
    rP = &s->next;
  }

  *rP = NULL;
  use(r); // GOOD
}

void test46()
{
  LinkedList *r, **rP = &r;

  while (getBool())
  {
    LinkedList *s = nullptr;
    *rP = s;
    rP = &s->next;
  }

  *rP = nullptr;
  use(r);
}

namespace std {
	float remquo(float, float, int*);
}

void test47() {
	float x = 1.0f;
	float y = 2.0f;
	int quo;
	std::remquo(x, y, &quo);
	use(quo); // GOOD
}