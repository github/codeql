package structure;

interface I { }

public class A {
	int x;
	int y;
	class MemberClass { }
	void m() {
		class LocalClass { int n; }
		m();
	}
}

class B extends A { 
	int z;
	interface MemberInterface { }
}

class C { 
	int w;
}

class D extends B {
	{ new C() {}; }
}
