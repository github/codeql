namespace Simple
{
int user_input()
{
    return 42;
}

void sink(int x)
{
}

class Foo
{
    int a_;
    int b_;

public:
    int a() { return a_; }
    int b() { return b_; }
    void setA(int a) { a_ = a; }
    void setB(int b) { b_ = b; }

    Foo(int a, int b) : a_(a), b_(b){};
};

void bar(Foo &f)
{
    sink(f.a()); // flow (through `f.setA` and `h.setA`)
    sink(f.b()); // flow (through `g.setB` and `h.setB`)
}

void foo()
{
    Foo f(0, 0);
    Foo g(0, 0);
    Foo h(0, 0);
    Foo i(0, 0);

    f.setA(user_input());
    g.setB(user_input());
    h.setA(user_input());
    h.setB(user_input());

    // Only a() should alert
    bar(f);

    // Only b() should alert
    bar(g);

    // Both a() and b() should alert
    bar(h);

    // Nothing should alert
    bar(i);
}
} // namespace Simple
