public class Test2 {
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
		{ A a = foo(); /* no a.bar();*/ }  // NOT OK
	}
}