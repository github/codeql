
#ifdef COMPILABLE_TEST
#include <stdio.h>
#endif

int main(void) {
    int i, j = 3;

    int g(int x) {
        return x + j + 1;
    }

    i = g(8);

#ifdef COMPILABLE_TEST
    printf("Got %d\n", i);
#endif

    return 0;
}

void h(void) {
    float f;

    float g(float x) {
      return 3.0;
    }

    f = g(8);
}

void bad(void) {
    int i;
#ifndef COMPILABLE_TEST
    i = g(8);
#endif
}

void f_a()
{
	void f_b(); // not a nested function, but declared inside a function.

	{
		void f_c(); // not a nested function, but declared inside a function.

		/*void f_d() // nested function --- extractor error
		{
		}*/
	}
}

void f_b()
{
}
