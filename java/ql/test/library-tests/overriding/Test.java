class Sup {
	public int m() { return 42; }
	public int m(int x) { return x+19; }
}

class Mid extends Sup implements I {
	public int m() { return super.m(); }
}

class Sub extends Mid {
	public int m() { return m(23); }
}

interface I {
	default int m() { return 1; }
	default int m(int x) { return x+1; }
	default void f() { g(); }
	static void g() { }
	static int x = 7;
}

interface Func {
	void run();
}

class F {
	Func lambda = () -> { r(); };
	Func ref = this::r;
	private void r() { }
}
