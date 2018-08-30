
class ViableCallable {
	public <T1, T2, T3> void Run(C1<T1, T2> x1, C1<T1[], T2> x2, T1 t1, T1[] t1s) {
		// Viable callables: C2.M(), C3.M(), C4.M(), C5.M(), C6.M(), C7.M(), C8.M(), C9.M()
		x1.M(t1, 8);

		// Viable callables: C4.M(), C6.M(), C7.M()
		x2.M(t1s, false);

		// Viable callables: C2.M(), C6.M(), C8.M()
		C1<String, Integer> x3 = Mock();
		x3.M("abc", 42);

		// Viable callables: C2.M(), C3.M(), C6.M(), C8.M()
		C1<String, Long> x4 = Mock();
		x4.M("abc", 42l);

		// Viable callables: C4.M(), C6.M()
		C1<Integer[], Boolean> x5 = Mock();
		x5.M(new Integer[]{ 42 }, (Object)null);

		// Viable callables: C2.M(), C5.M(), C6.M(), C8.M(), C9.M()
		C1<String, Boolean> x6 = Mock();
		x6.M("", (Object)null);

		// Viable callables: C6.M()
		C1<T1, Boolean> x7 = new C6<T1, Boolean>();
		x7.M(t1, "");

		// Viable callables: C1.f()
		I1<T1> i1 = Mock();
		i1.f("", t1);

		// Viable callables: C1.f()
		I2<Long> i2 = Mock();
		i2.f("", 0l);
	}

	<TMock> TMock Mock() { throw new Exception(); }

	void CreateTypeInstance() {
		Run(new C2<Boolean>(), null, null, null);
		Run(new C2<Integer>(), null, null, null);
		Run(new C2<Long>(), null, null, null);
		Run(new C4<Integer>(), null, null, null);
		Run(null, new C4<Integer>(), null, null);
		Run(new C6<String, Boolean>(), null, null, null);
		Run(new C6<String, Integer>(), null, null, null);
		Run(new C6<String, Long>(), null, null, null);
		Run(new C6<Integer[], Boolean>(), null, null, null);
		Run(null, new C6<Integer[], Boolean>(), null, null);
		Run(new C7<Boolean>(), null, null, null);
		Run(new C8<Long,Long>(), null, null, null);
		Run(new C9<Long>(), null, null, null);
	}
}

abstract class C1<T1_C1, T2_C1> {
	public abstract <T3_C1> T2_C1 M(T1_C1 x, T3_C1 y);

	public void Run(T1_C1 x) {
		// Viable callables: C2.M(), C3.M(), C4.M(), C5.M(), C6.M(), C7.M(), C8.M(), C9.M()
		M(x, 8);
	}

	public void f(T1_C1 x, T2_C1 y) { throw new Exception(); }
}

interface I1<T_I1> {
	void f(String x, T_I1 y);
}

interface I2<T_I2> {
	void f(String x, T_I2 y);
	default void g(T_I2 y) {
		// Viable callables: C1.f()
		f("", y);
	}
}

class C2<T_C2> extends C1<String, T_C2> implements I1<T_C2> {
	@Override
	public <T3_C2> T_C2 M(String x, T3_C2 y) { throw new Exception(); }
}

class C3 extends C1<String, Long> implements I2<Long> {
	@Override
	public <T3_C3> Long M(String x, T3_C3 y) { throw new Exception(); }
}

class C4<T_C4> extends C1<T_C4[], Boolean> {
	@Override
	public <T3_C4> Boolean M(T_C4[] x, T3_C4 y) { throw new Exception(); }
}

class C5 extends C1<String, Boolean> {
	@Override
	public <T3_C5> Boolean M(String x, T3_C5 y) { throw new Exception(); }
}

class C6<T1_C6, T2_C6> extends C1<T1_C6, T2_C6> {
	@Override
	public <T3_C6> T2_C6 M(T1_C6 x, T3_C6 y) { throw new Exception(); }

	public void Run(T1_C6 x) {
		// Viable callables: C6.M(), C7.M()
		M(x, 8);

		// Viable callables: C6.M(), C7.M()
		this.M(x, 8);
	}
}

class C7<T1_C7> extends C6<T1_C7, Byte> {
	@Override
	public <T3_C7> Byte M(T1_C7 x, T3_C7 y) { throw new Exception(); }

	public void Run(T1_C7 x) {
		// Viable callables: C7.M()
		M(x, 8);

		// Viable callables: C7.M()
		this.M(x, 8);

		// Viable callables: C6.M()
		super.M(x, 8);
	}
}

class C8<T_C8, T2_C8> extends C1<String, T2_C8> {
	@Override
	public <T3_C8> T2_C8 M(String x, T3_C8 y) { throw new Exception(); }
}

class C9<T_C9> extends C8<Boolean, Boolean> {
	@Override
	public <T3_C9> Boolean M(String x, T3_C9 y) { throw new Exception(); }
}

