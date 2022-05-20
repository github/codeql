
namespace std
{
  class type_info
  {
  public:
    const char *name() const;
  };
}

class Base {
  public:
    virtual void v() { }
};
class Derived : public Base {
};

void TypeId(Base *bp) {
  const char *name = typeid(bp).name();
}