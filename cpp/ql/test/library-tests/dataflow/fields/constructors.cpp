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
    sink(f.a()); // $ ast=34:11 ast=36:11 ir=34:11 ir=36:11
    sink(f.b()); // $ ast=35:14 ast=36:25 ir=35:14 ir=36:25
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
