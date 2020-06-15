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

struct DeepStruct1 {
    int x;
    int y;
};

struct DeepStruct2 {
    DeepStruct1 d1_1;
    DeepStruct1 d1_2;
};

struct DeepStruct3 {
    DeepStruct2 d2_1;
    DeepStruct2 d2_2;
    DeepStruct1 d1_1;
};

void write_to_d1_2_y(DeepStruct2* d2, int val) {
    d2->d1_2.y = val;
}

void read_from_y(DeepStruct2 d2) {
    sink(d2.d1_1.y);
    
    sink(d2.d1_2.y); //$ast,ir
}

void read_from_y_deref(DeepStruct2* d2) {
    sink(d2->d1_1.y);

    sink(d2->d1_2.y); //$ast,ir
}

void test_deep_structs() {
    DeepStruct3 d3;
    d3.d2_1.d1_1.x = user_input();
    DeepStruct2 d2_1 = d3.d2_1;
    sink(d2_1.d1_1.x); //$ast,ir
    sink(d2_1.d1_1.y);

    sink(d2_1.d1_2.x);

    DeepStruct1* pd1 = &d2_1.d1_1;
    sink(pd1->x); //$ast,ir
}

void test_deep_structs_setter() {
    DeepStruct3 d3;

    write_to_d1_2_y(&d3.d2_1, user_input());

    sink(d3.d2_1.d1_1.y);
    sink(d3.d2_1.d1_2.y); //$ast,ir

    read_from_y(d3.d2_1);
    read_from_y(d3.d2_2);
    read_from_y_deref(&d3.d2_1);
    read_from_y_deref(&d3.d2_2);
}

struct Inner
{
    int f;
    int g;
};

struct Outer
{
    Inner inner;
    int h;
};

void read_f(Inner *inner)
{
    sink(inner->f); //$ast,ir
}

void test()
{
    Outer outer;
    outer.inner.f = user_input();
    read_f(&outer.inner);
}

} // namespace Simple
