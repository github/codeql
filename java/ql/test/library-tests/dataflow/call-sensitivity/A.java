public class A {

	public static void sink(Object o) {
	}

	public Object flowThrough(Object o, boolean cond) {
		if (cond) {
			return o;
		} else {
			return null;
		}
	}

	public void callSinkIfTrue(Object o, boolean cond) {
		if (cond) {
			sink(o);
		}
	}

	public void callSinkIfFalse(Object o, boolean cond) {
		if (!cond) {
			sink(o);
		}
	}

	public void callSinkFromLoop(Object o, boolean cond) {
		while (cond) {
			sink(o);
		}
	}

	public void localCallSensitivity(Object o, boolean c) {
		Object o1 = o;
		Object o2 = null;
		if (c) {
			Object tmp = o1;
			o2 = 1 == 1 ? (tmp) : (tmp);
		}
		Object o3 = o2;
		sink(o3);
	}

	public void localCallSensitivity2(Object o, boolean b, boolean c) {
		Object o1 = o;
		Object o2 = null;
		if (b || c) {
			Object tmp = o1;
			o2 = 1 == 1 ? (tmp) : (tmp);
		}
		Object o3 = o2;
		sink(o3);
	}

	public void f1() {
		// should not exhibit flow
		callSinkIfTrue(new Integer(1), false);
		callSinkIfFalse(new Integer(2), true);
		callSinkFromLoop(new Integer(3), false);
		localCallSensitivity(new Integer(4), false);
		sink(flowThrough(new Integer(4), false));
		// should exhibit flow
		callSinkIfTrue(new Integer(1), true);
		callSinkIfFalse(new Integer(2), false);
		callSinkFromLoop(new Integer(3), true);
		localCallSensitivity(new Integer(4), true);
		localCallSensitivity2(new Integer(4), true, true);
		localCallSensitivity2(new Integer(4), false, true);
		localCallSensitivity2(new Integer(4), true, false);
		sink(flowThrough(new Integer(4), true));
		// expected false positive
		localCallSensitivity2(new Integer(4), false, false);
	}

	public void f2() {
		boolean t = true;
		boolean f = false;
		// should not exhibit flow
		callSinkIfTrue(new Integer(4), f);
		callSinkIfFalse(new Integer(5), t);
		callSinkFromLoop(new Integer(6), f);
		localCallSensitivity(new Integer(4), f);
		sink(flowThrough(new Integer(4), f));
		// should exhibit flow
		callSinkIfTrue(new Integer(4), t);
		callSinkIfFalse(new Integer(5), f);
		callSinkFromLoop(new Integer(6), t);
		localCallSensitivity(new Integer(4), t);
		sink(flowThrough(new Integer(4), t));
	}

	public void f3(InterfaceA b) {
		boolean t = true;
		boolean f = false;
		// should not exhibit flow
		b.callSinkIfTrue(new Integer(4), f);
		b.callSinkIfFalse(new Integer(5), t);
		b.localCallSensitivity(new Integer(4), f);
		// should exhibit flow
		b.callSinkIfTrue(new Integer(4), t);
		b.callSinkIfFalse(new Integer(5), f);
		b.localCallSensitivity(new Integer(4), t);
	}

	class B implements InterfaceA {
		@Override
		public void callSinkIfTrue(Object o, boolean cond) {
			if (cond) {
				sink(o);
			}
		}

		@Override
		public void callSinkIfFalse(Object o, boolean cond) {
			if (!cond) {
				sink(o);
			}
		}

		@Override
		public void localCallSensitivity(Object o, boolean c) {
			Object o1 = o;
			Object o2 = null;
			if (c) {
				Object tmp = o1;
				o2 = 1 == 1 ? (tmp) : (tmp);
			}
			Object o3 = o2;
			sink(o3);
		}

	}
}
