namespace {
class C {
	public:
		C(int i, int j);
};
}

static void f() {
	int a, b, c, d;
	new C(a + b, c - d);
}
