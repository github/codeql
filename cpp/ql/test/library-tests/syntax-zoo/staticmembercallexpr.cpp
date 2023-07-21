namespace {
class C {
	public:
		static void g();
};
}

static void f() {
	C c;
	c.g();
	;
}
