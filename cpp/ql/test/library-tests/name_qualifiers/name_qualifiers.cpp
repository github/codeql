int x = 23;
void f() {}

namespace N1
{
  void nf() {}
  int nx = 9;

  namespace N2
  {
    void ng() {}
    int ny = 84;
  }
}

struct Base
{
  static void bf() {}
  static int bx;
};

int Base::bx;

struct Derived : Base {};

int main()
{
  int i = x;
  i = ::x;

  i = N1::nx;
  using N1::nx;
  i = nx;
  i = ::N1::nx;

  i = N1::N2::ny;
  using namespace N1;
  i = N2::ny;
  using namespace N2;
  i = ny;
  i = ::N1::N2::ny;

  Base::bx = 24;
  i = Base::bx;
  i = Derived::bx;
  i = ::Base::bx;
  i = ::Derived::bx;

  f();
  ::f();

  N1::nf();
  using N1::nf;
  nf();
  ::N1::nf();

  N1::N2::ng();
  ::N1::N2::ng();

  Base::bf();
  Derived::bf();
  ::Base::bf();
  ::Derived::bf();

  return 0;
}
