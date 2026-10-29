struct Foo
{
  Foo(int x, int y) : m_x(x), m_y(y) {}
  ~Foo() {m_x = m_y = 0;}

  // NB: In Microsoft mode, size_t is predeclared.
  static void* operator new(size_t sz, int z, int w) { return nullptr; }
  static void operator delete(void* self) {}

  int m_x;
  int m_y;
};

int main()
{
  auto foo = new(11, 22) Foo(33, 44);
  delete foo;
}
