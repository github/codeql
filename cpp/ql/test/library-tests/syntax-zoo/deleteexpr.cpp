class C {
	public:
		~C();
};

void f() {
	C* c = new C();
	delete c;
}
