
class C
{
  class Elem
  {
  };

private:
  Elem *s1 = new Elem();
  const Elem *s2 = new Elem();
  Elem *s3;

public:
  const static Elem *s4;

  void main(void)
  {
    C *c = new C();
    c->func();
  }

  C() : s1(new Elem())
  {
    this->s3 = new Elem();
  }

  void func()
  {
    sink(s1); // $ast ir
    sink(s2); // $ MISSING: ast,ir
    sink(s3); // $ast ir
    sink(s4); // $ MISSING: ast,ir
  }

  static void sink(const void *o) {}
};
const C::Elem *C::s4 = new Elem();
