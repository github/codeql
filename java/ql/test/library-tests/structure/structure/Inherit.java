package structure;

interface I1 {
	default String m1() { return "I1"; }
}

interface I1other {
	default String m1() { return "I1other"; }
}

interface I2 {
	default String m2() { return "I2"; }
	void f();
}

class Parent implements I1other {
	public String m1() { return "Parent"; }
	public int hashCode() { return 1; }
	public void f() { }
}

class Child extends Parent implements I1, I2 {
}

interface ITop {
	default String f1() { return "ITop.f1"; }
	default String f2() { return "ITop.f2"; }
	String f3();
}

interface IA extends ITop {
	default String f1() { return "IA.f1"; }
	String f2();
	default String f3() { return "IA.f3"; }
}

interface IB extends ITop {
}

interface IDiamond extends IA, IB {
}

abstract class Diamond1 implements IA, IB {
}

interface IC extends IA {
	default String f1() { return "IC.f1"; }
	default String f2() { return "IC.f2"; }
}

class Diamond2 extends Diamond1 implements IA, IB, IC {
}
