struct Allocators
{
  Allocators(int x, int y) : m_x(x), m_y(y) {}
  ~Allocators() {m_x = m_y = 0;}

  // NB: In Microsoft mode, size_t is predeclared.
  static void* operator new(size_t sz, int z, int w) { return nullptr; }
  static void operator delete(void* self) {}

  int m_x;
  int m_y;
};

static int f()
{
  auto foo = new(11, 22) Allocators(33, 44);
  delete foo;
}

// semmle-extractor-options: --microsoft
