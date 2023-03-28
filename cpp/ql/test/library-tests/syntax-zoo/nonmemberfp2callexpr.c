void (*g())();

static void f() {
	g()();
	;
}
