namespace {
class C {
	public:
		C(int x, int y);
};
}

static void f() {
	int i, j, k, l;
	C c(i + j, k - l);
}
