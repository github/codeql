namespace {
class C {
	public:
		C* d;
		void g(int x, int y);
};
}

static void f() {
	int i, j, k, l;
	C *c;
	c->d->g(i + j, k - l);
}
