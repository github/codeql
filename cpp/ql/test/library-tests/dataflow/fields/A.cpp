class A
{

  class C
  {
  public:
    virtual void insert(void *) {}
  };
  class C1 : public C
  {
  public:
    A *a;
  };
  class C2 : public C
  {
  };

  class B
  {
  public:
    C *c;
    B() {}
    B(C *c)
    {
      this->c = c;
    }
    void set(C *c) { this->c = c; }
    C *get() { return this->c; }
    static B *make(C *c)
    {
      return new B(c);
    }
  };

public:
  void f0()
  {
    C cc;
    C ct;
    cc.insert(nullptr);
    ct.insert(new C());
    sink(&cc); // no flow
    sink(&ct); // $ast $f-:ir
  }
  void f1()
  {
    C *c = new C();
    B *b = B::make(c);
    sink(b->c); // $ast $f-:ir
  }

  void f2()
  {
    B *b = new B();
    b->set(new C1());
    sink(b->get());                // $ast $ir=55:12
    sink((new B(new C()))->get()); // $ast $ir
  }

  void f3()
  {
    B *b1 = new B();
    B *b2;
    b2 = setOnB(b1, new C2());
    sink(b1->c); // no flow
    sink(b2->c); // $ast $f-:ir
  }

  void f4()
  {
    B *b1 = new B();
    B *b2;
    b2 = setOnBWrap(b1, new C2());
    sink(b1->c); // no flow
    sink(b2->c); // $ast $f-:ir
  }

  B *setOnBWrap(B *b1, C *c)
  {
    B *b2;
    b2 = setOnB(b1, c);
    return r() ? b1 : b2;
  }

  A::B *setOnB(B *b1, C *c)
  {
    if (r())
    {
      B *b2 = new B();
      b2->set(c);
      return b2;
    }
    return b1;
  }

  void f5()
  {
    A *a = new A();
    C1 *c1 = new C1();
    c1->a = a;
    f6(c1);
  }
  void f6(C *c)
  {
    if (C1 *c1 = dynamic_cast<C1 *>(c))
    {
      sink(c1->a); // $ast,ir
    }
    C *cc;
    if (C2 *c2 = dynamic_cast<C2 *>(c))
    {
      cc = c2;
    }
    else
    {
      cc = new C1();
    }
    if (C1 *c1 = dynamic_cast<C1 *>(cc))
    {
      sink(c1->a); //$f+:ast
    }
  }

  void f7(B *b)
  {
    b->set(new C());
  }
  void f8()
  {
    B *b = new B();
    f7(b);
    sink(b->c); // $ast,ir
  }

  class D
  {
  public:
    A::B *b;

    D(A::B *b, bool x)
    {
      b->c = new C();
      this->b = x ? b : new B();
    }
  };

  void
  f9()
  {
    B *b = new B();
    D *d = new D(b, r());
    sink(d->b);    // $ast,ir=143:25 $ast,ir=150:12
    sink(d->b->c); // $ast $f-:ir
    sink(b->c);    // $ast,ir
  }

  void f10()
  {
    B *b = new B();
    MyList *l1 = new MyList(b, new MyList(nullptr, nullptr));
    MyList *l2 = new MyList(nullptr, l1);
    MyList *l3 = new MyList(nullptr, l2);
    sink(l3->head);                   // no flow, b is nested beneath at least one ->next
    sink(l3->next->head);             // no flow
    sink(l3->next->next->head);       // $ast $f-:ir
    sink(l3->next->next->next->head); // no flow
    for (MyList *l = l3; l != nullptr; l = l->next)
    {
      sink(l->head); // $ast $f-:ir
    }
  }

  static void sink(void *o) {}
  bool r() { return reinterpret_cast<long long>(this) % 10 > 5; }

  class MyList
  {
  public:
    B *head;
    MyList *next;
    MyList(B *newHead, MyList *next)
    {
      head = newHead;
      this->next = next;
    }
  };
};
