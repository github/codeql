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
		sink(t); // flow from source()
		sink(u);
		return t;
	};
	sink(a()); // flow from source()

	auto b = [&] {
		sink(t); // flow from source()
		sink(u);
		v = source(); // (v is reference captured)
	};
	b();
	sink(v); // flow from source() [NOT DETECTED]

	auto c = [=] {
		sink(t); // flow from source()
		sink(u);
	};
	c();

	auto d = [](int a, int b) {
		sink(a); // flow from source()
		sink(b);
	};
	d(t, u);

	auto e = [](int &a, int &b, int &c) {
		sink(a); // flow from source()
		sink(b);
		c = source();
	};
	e(t, u, w);
	sink(w); // flow from source()
}
