#include "fwd.h"

class classA {
public:
	~classA() {	}
};

classA *create_an_a() {
	return new classA;
}

void func2()
{
	classA *a = create_an_a();
}
