class C { };
class D { };

void g() {
	throw 1;
}

void f() {
	try {
		try {
			g();
			throw 2;
l:
		} catch (int) {
			4;
		}
	} catch (C) {
		5;
	} catch (D) {
		6;
	}
}
