void sink(void *o);

class D {
public:
  struct Elem { };

  struct Box1 {
    Elem *elem;
    Box1(Elem *e) { elem = e; }
    Elem* getElem() { return elem; }
    void setElem(Elem *e) { elem = e; }
  };

  struct Box2 {
    Box1* box;
    Box2(Box1* b) { box = b; }
    Box1* getBox1() { return box; }
    void setBox1(Box1* b) { box = b; }
  };

  static void sinkWrap(Box2* b2) {
    sink(b2->getBox1()->getElem()); // $ast,ir=28:15 ast,ir=35:15 ast,ir=42:15 ast,ir=49:15
  }

  Box2* boxfield;

  void f1() {
    Elem* e = new Elem(); // source of flow to sinkWrap
    Box2* b = new Box2(new Box1(nullptr));
    b->box->elem = e;
    sinkWrap(b);
  }

  void f2() {
    Elem* e = new Elem(); // source of flow to sinkWrap
    Box2* b = new Box2(new Box1(nullptr));
    b->box->setElem(e);
    sinkWrap(b);
  }

  void f3() {
    Elem* e = new Elem(); // source of flow to sinkWrap
    Box2* b = new Box2(new Box1(nullptr));
    b->getBox1()->elem = e;
    sinkWrap(b);
  }

  void f4() {
    Elem* e = new Elem(); // source of flow to sinkWrap
    Box2* b = new Box2(new Box1(nullptr));
    b->getBox1()->setElem(e);
    sinkWrap(b);
  }

  void f5a() {
    Elem* e = new Elem(); // source of flow to f5b
    boxfield = new Box2(new Box1(nullptr));
    boxfield->box->elem = e;
    f5b();
  }

private:
  void f5b() {
    sink(boxfield->box->elem); // $ ast,ir
  }
};
