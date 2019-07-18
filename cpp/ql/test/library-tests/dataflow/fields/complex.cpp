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

int user_input()
{
  return 42;
}

void sink(int x)
{
}

void bar(Bar &b)
{
  sink(b.f.a());
  sink(b.f.b());
}

void foo()
{
  Bar b1;
  Bar b2;
  Bar b3;
  Bar b4;

  b1.f.setA(user_input());
  b2.f.setB(user_input());
  b3.f.setA(user_input());
  b3.f.setB(user_input());

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