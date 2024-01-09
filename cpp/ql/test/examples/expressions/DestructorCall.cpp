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

void destruction_of_named_entity() {
  C c;
  return;
}

void destruction_on_branches(bool b) {
  C c;
  if(b) {
    return;
  } else {
    return;
  }
}