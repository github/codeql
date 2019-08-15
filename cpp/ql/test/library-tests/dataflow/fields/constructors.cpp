namespace Constructors
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
    sink(f.a()); // flow (through `f` and `h`) [NOT DETECTED]
    sink(f.b()); // flow (through `g` and `h`) [NOT DETECTED]
}

void foo()
{
    Foo f(user_input(), 0);
    Foo g(0, user_input());
    Foo h(user_input(), user_input());
    Foo i(0, 0);

    // Only a() should alert
    bar(f);

    // Only b() should alert
    bar(g);

    // Both a() and b() should alert
    bar(h);

    // Nothing should alert
    bar(i);
}
}; // namespace Constructors
