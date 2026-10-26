namespace eehandler {

static void f() {
	try {
		try {
			throw 1;
		} catch (int i) {
		} catch (...) {
		}
	} catch (int j) {
	}
}

static void g(bool condition) {
	try {
		if (condition) throw 1;
	} catch (...) {
	}
}
}
