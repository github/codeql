

namespace direct_friend {
  class C {
    friend class D;
  private:
    C(C &) {}
  };

  class D {
    C x;
    void f() {}
  };
}

namespace field_and_base {
  class B {
    // An access expression `x.m`, where `m` as a member of `x` is protected
    // and not static, may only occur in a member or friend of a (reflexive,
    // transitive) base class of `x`'s class (N4140 11.4).
    // To keep the implementation simple and fast, we apply this restriction to
    // static members as well even though it's wrong. If that should ever be
    // fixed, the expected results of this test should be updated to show that
    // `P::f` can indeed access `P::m_static`.
  protected:
    int m;
    static int m_static;
  };
  class P: public B {
    B fieldB;
    int f() {
      // In the fully general syntax `x.B::m`, the _naming class_ `B` may be
      // different from the static type of `x`. Our encoding of access rules
      // currently pretends that they are always the same.
      return this->m + this->B::m + this->m_static + B::m_static;
    }
  };
}

namespace protected_derived {
  class B {
  public:
    int m;
  };
  class BN : protected B { };
  class BPNprot;
  class BPNpub;
  class BP : protected B {
    int f(BN*, BPNprot*, BPNpub*);
  };
  class BPNprot : protected BP { };
  class BPNpub : public BP { };
  int BP::f(BN* bn, BPNprot* bpnProt, BPNpub* bpnPub) {
    return bpnPub->m;
  }
}

namespace protected_virtual {
  class B {
  protected:
    int m;
  };

  class Npub;
  class Nprot;
  class P : virtual private B {
    int f(Npub*, Nprot*);
  };

  // f can access Npub::m since because it can convert an Npub* to a B* and
  // then access B::m.
  class Npub : virtual public B, private P { };

  class Nprot : virtual protected B, private P { };

  int P::f(Npub* pub, Nprot* prot) {
    return pub->m;
  }
}

namespace simple {
  class Base {};
  class Derived : private Base {
    public: Base *castme() { return this; }
  };

  Base *top(Derived *p) {
    return (Base*)p; // C-style cast needed
  }
}

namespace mixed {
  class A {
  private:
    int x;
    static int y;
  };

  class B : private A {
  private:
    void fun() {};
  };

  class C : protected B {
  private:
    void fun() {};
  };

  class D : public C {
  private:
    void fun() {};
  };
}

namespace friend_class {
  class B {
    friend class D1;
    friend class D2;

  private:
    int a;
    static int b;

    void fun() {};
  };

  class C : private B {
  private:
    int x;
    static int y;

    void fun() {};
  };

  class D1 : private C {
  private:
    void fun() {};
  };

  class D2 : private B {
  protected:
    void fun() {};
  };
}

namespace friend_fun {
  class A {
  };

  class B : private A {
  private:
    int x;
    static int y;

    friend void fun2();
  };

  void fun1() {};
  void fun2() {};
}
