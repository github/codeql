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
  // The library correctly finds that the four `user_input` sources can make it
  // to the `sink` calls, but it also finds some source/sink combinations that
  // are impossible. Those false positives here are a consequence of how the
  // shared data flow library overapproximates field flow. The library only
  // tracks the head (`f`) and the length (2) of the field access path, and
  // then it tracks that both `a_` and `b_` have followed `f` in _some_ access
  // path somewhere in the search. That makes the library conclude that there
  // could be flow to `b.f.a_` even when the flow was actually to `b.f.b_`.
  sink(b.f.a()); // flow [FALSE POSITIVE through `b2.f.setB` and `b3.f.setB`]
  sink(b.f.b()); // flow [FALSE POSITIVE through `b1.f.setA` and `b3.f.setA`]
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
