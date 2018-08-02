namespace ambiguous {
  class Duplicated {};

  class Intermediate: public Duplicated {};

  class C: protected Duplicated, public Intermediate {};
}

namespace chain {
  class C {
  public: static void pubC();
  protected: static void protC();
  private: static void priC();
  };

  class D: public C {
  private: static void priD();
  };

  class E: protected D {};

  class F: public E {};
}

namespace diamond {
  class Top {
  public: static void pub();
  protected: static void prot();
  };

  class Left: private Top {};

  class Right: public Top {};

  class Bottom: public Left, protected Right {};

  class Alone {
    Alone();
  };
}

namespace friend_class {
  class A {
  };

  class B : private A {
    friend class D1;
    friend class D2;

  public:
    void fun() {};
  };

  class C : private B {
  public:
    void fun() {};
  };

  class D1 : private C {
  public:
    void fun() {};
  };

  class D2 : private B {
  protected:
    void fun() {};
  };
}
