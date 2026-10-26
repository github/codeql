public class A2 {

	public static void sink(Object o) {
	}

	public void m() {

	}

	public void callsite(InterfaceB intF) {
		B b = new B();
		// in both possible implementations of foo, this callsite is relevant
		// in IntA, it improves virtual dispatch,
		// and in IntB, it improves the dataflow analysis.
		intF.foo(b, new Integer(5), false);
	}

	private class B extends A2 {
		@Override
		public void m() {

		}
	}

	private class IntA implements InterfaceB {
		@Override
		public void foo(A2 obj, Object o, boolean cond) {
			obj.m();
			sink(o);
		}
	}

	private class IntB implements InterfaceB {
		@Override
		public void foo(A2 obj, Object o, boolean cond) {
			if (cond) {
				sink(o);
			}
		}
	}

}
