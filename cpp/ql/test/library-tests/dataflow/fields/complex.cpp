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
  // The library correctly finds that the four `user_input` sources can make it
  // to the `sink` calls, but it also finds some source/sink combinations that
  // are impossible. Those false positives here are a consequence of how the
  // shared data flow library overapproximates field flow. The library only
  // tracks the final two fields (`f` and `inner`) and the length (3) of the field
  // access path, and then it tracks that both `a_` and `b_` have followed `f.inner`
  // in _some_ access path somewhere in the search. That makes the library conclude
  // that there could be flow to `b.inner.f.a_` even when the flow was actually to
  // `b.inner.f.b_`.
  sink(b.inner.f.a()); // $ast=62:19 $f+:ast=63:19 $ast=64:19 $f+:ast=65:19 $ir=62:19 $f+:ir=63:19 $ir=64:19 $f+:ir=65:19
  sink(b.inner.f.b()); // $f+:ast=62:19 $ast=63:19 $f+:ast=64:19 $ast=65:19 $f+:ir=62:19 $ir=63:19 $f+:ir=64:19 $ir=65:19
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
