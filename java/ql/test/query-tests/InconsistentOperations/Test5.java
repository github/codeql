public class Test5 {
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

	static A a = foo(); // OK
}