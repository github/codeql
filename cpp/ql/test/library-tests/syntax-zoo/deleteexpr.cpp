namespace {
class C {
	public:
		~C();
};
}

static void f() {
	C* c = new C();
	delete c;
}
