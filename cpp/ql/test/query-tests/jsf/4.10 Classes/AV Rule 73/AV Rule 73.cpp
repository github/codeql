
class MyClass1 {
public:
	MyClass1() { // BAD
		x = 1;
	}

	void myMethod() {
		if (x == 1) {
			// ...
		}
	}

	int x;
};

class MyClass2 {
public:
	MyClass2() {
		x = 1;
	}

	void myMethod1() {
		if (x == 1) {
			// ...
		}
	}

	void myMethod2() {
		int y = x;

		// ...
	}

	int x;
};

class MyClass3 {
public:
	MyClass3() {
		x = 1;
	}

	void myMethod() {
		if (x == 1) {
			// ...
		}
	}

	int x;
};

MyClass3 *arr3 = new MyClass3[10];

typedef struct
{
	int a;
	int b = 1;
} struct_t;

struct_t st;
