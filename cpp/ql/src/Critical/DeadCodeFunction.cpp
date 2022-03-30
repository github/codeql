class C {
public:
	void g() {
		...
		//f() was previously used but is now commented-out, orphaning f()
		//f();
		...
	}
private:
	void f() { //is now unused, and can be removed
	}
};
