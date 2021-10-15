public class TestConfusingOverloading {
	class Super<T> {
		void test2(T t) {}
		void test(Super<T> other) {}
	}
	class Sub extends Super<Runnable> {
		void test(Sub other) {}
	}

	class Sub2 extends Super<Runnable> {
		@Override void test2(Runnable r) {}
		@Override void test(Super<Runnable> other) {}
	}
}

class TestDelegates {
	class A {}
	class B1 extends A {}
	class B2 extends A {}
	class C extends B1 {}

	void test(A a) {} // OK (all overloaded methods are either delegates or deprecated)
	void test(B1 b1) { test((A)b1); } // OK (delegate)
	void test(B2 b2) { test((A)b2); } // OK (delegate)
	void test(C c) { test((B1)c); } // OK (delegate)
	@Deprecated void test(Object obj) {} // OK (deprecated)
}
