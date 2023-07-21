namespace {
class C {
	public:
		void (C::*g)();
};
}

static void f() {
	C *c, *d;
	(c->*(d->g))();
	;
}
