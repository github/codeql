class C {
public:
  ~C() {
  }  
};

class D {
public:
};

void DestructorCall(C *c, D *d) {
  delete c;
  delete d;
}