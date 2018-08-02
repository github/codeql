class Base {
  virtual void f() { } 
};
class Derived : public Base  {
  void f() { } 
};

void v(Base *bp, Derived *d) {
  d = dynamic_cast<Derived *>(bp);
}

void v_ref(Base &bp, Derived &d) {
  d = dynamic_cast<Derived &>(bp);
}