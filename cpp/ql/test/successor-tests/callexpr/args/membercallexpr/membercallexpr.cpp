class C {
	public:
		C* d;
		void g(int x, int y);
};

void f() {
	int i, j, k, l;
	C *c;
	c->d->g(i + j, k - l);
}
