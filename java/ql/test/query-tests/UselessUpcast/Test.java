import java.util.ArrayList;

class Super { int x; }
class Sub extends Super { int x; }

class TestSuper { void baz(Sub s) {} }

class Test extends TestSuper {
	Test(Super o) {}

	Test(Sub s) {
		// OK
		this((Super)s);
	}

	{
		Sub s = null;
		// OK
		new Test((Super)s);
		// NOT OK
		Super o = (Super)s;
		// OK
		foo((Super)s);
		// NOT OK
		bar((Super)s);
		// OK
		baz((Super)s);
		// OK
		ArrayList a = (ArrayList)new ArrayList<Sub>();
		// OK
		int x = ((Super)new Sub()).x;
	}

	void foo(Super o) {}
	void foo(Sub s) {}

	void bar(Super o) {}

	void baz(Super o) {}
}