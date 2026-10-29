class C {
	public:
		void (C::*g)();
};

void f() {
	C *c, *d;
	(c->*(d->g))();
	;
}
