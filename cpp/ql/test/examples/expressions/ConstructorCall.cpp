class C {
public:
  C(int i) {
  }  
};

class D {
public:
  D() {
  }
};

class E {
public:
};

void ConstructorCall(C *c, D *d, E *e) {
  c = new C(5);
  d = new D();
  e = new E();
}