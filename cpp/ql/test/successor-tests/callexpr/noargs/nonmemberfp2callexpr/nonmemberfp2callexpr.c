void (*g())();

void f() {
	g()();
	;
}
