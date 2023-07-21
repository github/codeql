namespace {
class C {
	public:
		void g();
};
}

static void f() {
	C *c;
	c->g();
	;
}
