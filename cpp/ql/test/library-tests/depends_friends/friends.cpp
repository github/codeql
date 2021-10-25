class Friend1 {
public:
	void f();
protected:
	void g();
private:
	void h();
};

class Friend2 {
public:
	void f();
protected:
	void g();
private:
	void h();
};

void Friend2::f() {
}

void friendFunc() {}

class C {
	friend class Friend1;
	friend void Friend2::f();
	friend void friendFunc();
};
