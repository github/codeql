


// This struct is POD in C++11, but not in C++03.
struct S
{
  int a;
  S(int b) : a(b) {}
  S() = default;
};
