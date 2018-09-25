#include "calls1.h"

void g() {
	int x = 2;
	int y = 4;
	swap(&x,&y);
}

void negate(int& c) { c = -c; }

template<class Iter, class Fct> void compute(Iter b, Fct f)
{
	f(b);
}

void f(int aa)
{
	compute(aa, negate);
}

