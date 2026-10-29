namespace Complex
{
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

class Bar
{
public:
  Foo f;

  Bar() : f(0, 0) {}
};

class Outer
{
public:
  Bar inner;
};

int user_input()
{
  return 42;
}

void sink(int x)
{
}

void bar(Outer &b)
{
  sink(b.inner.f.a()); // $ ast=53:19 ast=55:19 ir=53:19 ir=55:19
  sink(b.inner.f.b()); // $ ast=54:19 ast=56:19 ir=54:19 ir=56:19
}

void foo()
{
  Outer b1;
  Outer b2;
  Outer b3;
  Outer b4;

  b1.inner.f.setA(user_input());
  b2.inner.f.setB(user_input());
  b3.inner.f.setA(user_input());
  b3.inner.f.setB(user_input());

  // Only a() should alert
  bar(b1);

  // Only b() should alert
  bar(b2);

  // Both a() and b() should alert
  bar(b3);

  // Nothing should alert
  bar(b4);
}
}; // namespace Complex
