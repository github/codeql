class Base {
  virtual void f() { } 
};
class Derived : public Base  {
  void f() { } 
};

void DynamicCast(Base *bp, Derived *d) {
  d = dynamic_cast<Derived *>(bp);
}

void DynamicCastRef(Base &bp, Derived &d) {
  d = dynamic_cast<Derived &>(bp);
}