void gf() {}

namespace N
{
  void nf() {}
}

using N::nf;
using namespace N;

struct B
{
  static void bf() {}
};

struct D : B
{
  using B::bf;

  void df() {
    using ::gf;
    gf();
  }
};

template <typename T>
struct TB
{
  static void tbf() {}
};

struct TD : TB<int>, TB<float>
{
  using TB<int>::tbf;
};

namespace nsfoo {
    void foo(void);
}

namespace nsbar {
    using ::nsfoo::foo;
}

int main()
{
  return 0;
}
