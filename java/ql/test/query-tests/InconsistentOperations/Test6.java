public class Test6 {
	static class A { void bar() {} }
	static A foo() { return new A(); }

	void test() {
		{ A a = foo(); a.bar(); }
		{ A a = foo(); a.bar(); }
		{ A a = foo(); a.bar(); }
		{ A a = foo(); a.bar(); }
		{ A a = foo(); a.bar(); }
		{ A a = foo(); a.bar(); }
		{ A a = foo(); a.bar(); }
		{ A a = foo(); a.bar(); }
		{ A a = foo(); a.bar(); }
	}

	Object o = new Object() {
		A a = foo(); // OK
	};
}