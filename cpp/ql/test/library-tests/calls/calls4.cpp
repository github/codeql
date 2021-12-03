
class CThisCall {
  struct S {
    bool (CThisCall::*b)();
  };
  const S *s;
  void f() {
    if ((this->*s->b)()) ;
  }
};

