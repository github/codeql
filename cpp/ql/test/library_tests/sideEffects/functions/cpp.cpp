
int topLevel = 0;

class SimpleFoo {
    public:
    SimpleFoo() {
    }
};

class SimpleBar : SimpleFoo {
    public:
    SimpleBar() {
    }
};

class Foo {
    public:
    int fooInt;
    Foo(int i) : fooInt(8) { }
    Foo(int i, int j) : fooInt(i++) { }
    Foo(int i, int j, int k) : fooInt(topLevel++) { }
};

class Bar : Foo {
    public:
    int barInt;
    Bar(int i) : Foo(7), barInt(9) { }
    Bar(int i, int j) : Foo(7, 8), barInt(9) { }
    Bar(int i, int j, int k) : Foo(7, 8, 9), barInt(9) { }
    Bar(int i, int j, int k, int l) : Foo(7), barInt(i++) { }
    Bar(int i, int j, int k, int l, int m) : Foo(7), barInt(topLevel++) { }
    Bar(int i, int j, int k, int l, int m, int n) : Foo(topLevel++), barInt(9) { }
};

class PurelyDestructible {
    public:
    ~PurelyDestructible() { }
};

class ImpurelyDestructible {
    public:
    ~ImpurelyDestructible() { topLevel++; }
};

class SuperPurelyDestructible : PurelyDestructible {
    public:
    ~SuperPurelyDestructible() { }
};

class SuperImpurelyDestructible : ImpurelyDestructible {
    public:
    ~SuperImpurelyDestructible() { }
};

class someClass {
    public:
    int operator*() const {
        return 5;
    }
};

void startSomeClass(someClass c) {
    int i;

    i = *c;
}

int global = 0;

void functionAccessesGlobal1() {
	global++;
}

int functionAccessesGlobal2() { // not pure but side-effect free [considered pure]
	return global;
}

int functionAccessesGlobal3() { // not pure but side-effect free [considered pure]
	if (global == 5)
	{
		return 5;
	} else {
		return 0;
	}
}

int functionAccessesStatic() {
	static int ctr = 0;
	
	return ctr++;
}

void increment(int &ref) {
	ref++;
}

void doIncrement() { // pure [currently wrong, but hard to detect]
	int i;
	
	increment(i);
}
