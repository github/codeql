class B
{

  void f1()
  {
    Elem *e = new Elem();
    Box1 *b1 = new Box1(e, nullptr);
    Box2 *b2 = new Box2(b1);
    sink(b2->box1->elem1); // $ ast,ir
    sink(b2->box1->elem2); // no flow
  }

  void f2()
  {
    Elem *e = new B::Elem();
    Box1 *b1 = new B::Box1(nullptr, e);
    Box2 *b2 = new Box2(b1);
    sink(b2->box1->elem1); // no flow
    sink(b2->box1->elem2); // $ ast,ir
  }

  static void sink(void *o) {}

  class Elem
  {
  };

  class Box1
  {
  public:
    Elem *elem1;
    Elem *elem2;
    Box1(Elem *e1, Elem *e2)
    {
      this->elem1 = e1;
      this->elem2 = e2;
    }
  };

  class Box2
  {
  public:
    Box1 *box1;
    Box2(Box1 *b1)
    {
      this->box1 = b1;
    }
  };
};
