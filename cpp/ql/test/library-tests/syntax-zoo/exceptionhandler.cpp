namespace ehandler {

class C { };
class D { };

static void g() {
	throw 1;
}

static void f() {
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
}
