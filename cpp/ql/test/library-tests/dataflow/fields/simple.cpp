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
public:
    int a_;
    int b_;

    int a() { return a_; }
    int b() { return b_; }
    void setA(int a) { a_ = a; }
    void setB(int b) { b_ = b; }

    Foo(int a, int b) : a_(a), b_(b){};
};

void bar(Foo &f)
{
    sink(f.a()); //$ast=39:12 $ast=41:12 $f-:ir
    sink(f.b()); //$ast=40:12 $ast=42:12 $f-:ir
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

struct A
{
    int i;
};

void single_field_test()
{
    A a;
    a.i = user_input();
    A a2 = a;
    sink(a2.i); //$ast,ir
}

struct C {
    int f1;
};

struct C2
{
    C f2;

    int getf2f1() {
        return f2.f1;
    }

    void m() {
        f2.f1 = user_input();
        sink(getf2f1()); //$ast,ir
    }
};

void false_positive_flow_through_conflated_chi(Foo **pp1, Foo **pp2)
{
    (*pp1)->a_ = user_input();
    sink((*pp2)->a_); //$f+:ir
}

} // namespace Simple
