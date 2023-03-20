namespace {
class C {
	public:
		int x;
};
}

static void f() {
	C *c;
	int i;
	i = c->x;
}