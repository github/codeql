
#include "functions.h"

int myFunction1(int x) {
	return x;
}

void myCaller() {
	myFunction1();
	myFunction1();
	myFunction1(104);
	myFunction2(105);
	myFunction2();
}