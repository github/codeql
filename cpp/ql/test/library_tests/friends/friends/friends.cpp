template <typename T>
class SelfFriendlyTemplate
{
  friend class SelfFriendlyTemplate<T>;
};

class OuterC
{
  class InnerC
  {
    friend class Foo;
  };
  friend class Foo;
};

class OuterF
{
  friend void foo();
  class InnerF
  {
    friend void foo();
  };
};

int main()
{
  SelfFriendlyTemplate<int> i;
  SelfFriendlyTemplate<float> f;
}
