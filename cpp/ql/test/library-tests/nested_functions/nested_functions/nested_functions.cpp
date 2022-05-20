
class myClass
{
public:
	void myMethod() {
		void myNestedFunction() { // nested function
		}
	}
};

/*
Nested functions are a GCC language extension.  The nested function is defined inside the parent,
can't be accessed elsewhere, and has access to the parent's parameters.

However in standard C/C++ you can put a function declaration inside another function.  This is
not a nested function, the only effect it has is to limit the visibility of that single declaration.

These tests examine both cases.
*/

namespace ns
{
	void f_a()
	{
		void f_b(); // not a nested function, but declared inside a function.

		{
			void f_c(); // not a nested function, but declared inside a function.

			void f_d() // nested function
			{
			}
		}
	}

	void f_b()
	{
	}
}
