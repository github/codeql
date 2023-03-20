namespace {
class C { };
}

static void f() {
	C* c = new C();
	delete c;
}
