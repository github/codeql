int source();
void sink(...) {};

// --- lambdas ---

void test_lambdas()
{
	int t = source();
	int u = 0;
	int v = 0;
	int w = 0;

	auto a = [t, u]() -> int {
		sink(t); // $ ast,ir
		sink(u);
		return t;
	};
	sink(a()); // $ ast,ir

	auto b = [&] {
		sink(t); // $ ast,ir
		sink(u);
		v = source(); // (v is reference captured)
	};
	b();
	sink(v); // $ MISSING: ast,ir

	auto c = [=] {
		sink(t); // $ ast,ir
		sink(u);
	};
	c();

	auto d = [](int a, int b) {
		sink(a); // $ ast,ir
		sink(b);
	};
	d(t, u);

	auto e = [](int &a, int &b, int &c) {
		sink(a); // $ ast,ir
		sink(b);
		c = source();
	};
	e(t, u, w);
	sink(w); // $ ast,ir
}
