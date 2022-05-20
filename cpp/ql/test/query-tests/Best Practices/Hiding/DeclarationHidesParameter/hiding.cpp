
void f(int ii) {
    if (1) {
        for(int ii = 1; ii < 10; ii++) { // local variable hides parameter of the same name
            ;
        }
    }
}

namespace foo {
  namespace bar {
    void f2(int ii, int kk) {
      try {
        for (ii = 0; ii < 3; ii++) {
          int kk; // local variable hides parameter of the same name
        }
      }
      catch (int ee) {
      }
    }
  }
}

void myFunction(int a, int b, int c);

void myFunction(int a, int b, int _c) {
	{
		int a = a; // local variable hides parameter of the same name
		int _b = b;
		int c = _c;

		// ...
	}
}

template<class T>
class MyTemplateClass {
public:
	void myMethod(int a, int b, int c);
};

template<class T>
void MyTemplateClass<T> :: myMethod(int a, int b, int _c) {
	{
		int a = a; // local variable hides parameter of the same name
		int _b = b;
		int c = _c;

		// ...
	}
}

MyTemplateClass<int> mtc_i;

void test() {
	mtc_i.myMethod(0, 0, 0);
}

#define MYMACRO for (int i = 0; i < 10; i++) {}

void testMacro(int i) {
	MYMACRO;

	for (int i = 0; i < 10; i++) {}; // local variable hides parameter of the same name
}

#include "hiding.h"

void myClass::myCaller(void) {
  this->myMethod(5, 6);
}

template <typename T>
void myClass::myMethod(int arg1, T arg2) {
	{
		int protoArg1;
		T protoArg2;
		int arg1; // local variable hides parameter of the same name
		T arg2; // local variable hides parameter of the same name
	}
}
