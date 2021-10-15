extern "C" int printf(const char*, ...);

namespace Foo
{
  namespace
  {
    const char* A()
    {
      return __FUNCDNAME__;
    }
  }
  const char* a()
  {
    return A();
  }
}

namespace Bar
{
  namespace
  {
    const char* B()
    {
      return __FUNCTION__;
    }
  }
  const char* b()
  {
    return B();
  }
}

int main()
{
  return printf("%s\n%s\n", Foo::a(), Bar::b());
}
