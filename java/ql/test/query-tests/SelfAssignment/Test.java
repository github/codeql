class Outer {
	int x;

	Outer(int x) {
		// NOT OK
		x = x;
		// OK
		this.x = x;
	}

	Outer() {}

	class Inner {
		int x;
		// OK
		{ x = Outer.this.x; }
	}

	class Inner2 extends Outer {
		// OK
		{ x = Outer.this.x; }
	}
}