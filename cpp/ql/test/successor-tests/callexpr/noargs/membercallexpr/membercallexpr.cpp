class C {
	public:
		void g();
};

void f() {
	C *c;
	c->g();
	;
}
