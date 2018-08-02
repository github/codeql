class C {
public:
  ~C() {
  }  
};

class D {
public:
};

void v(C *c, D *d) {
  delete c;
  delete d;
}