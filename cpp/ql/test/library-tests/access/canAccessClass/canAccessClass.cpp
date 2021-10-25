
namespace simple {
  class Base {};
  class Derived : private Base {
    public: Base *castme() { return this; }
  };

  Base *top(Derived *p) {
    return (Base*)p; // C-style cast needed
  }
}

namespace side_tree {
  class B {};
  class S: protected B {};
  class N: public S {};
  class P: private S {
    static B* f(N* n) {
      // Allowed by C++14 11.2/4 since N can be converted to S by (4.1) and S
      // can be converted to B by (4.3).
      return n;
    }
  };
}

namespace gcc44 {
  struct B { };
  struct D1: protected B { };
  struct D2: B {
    B* f(D1* d) {
      return nullptr;
      // This conversion was allowed by GCC < 4.4, and the frontend defaults to
      // emulating GCC 4.3, so it will actually accept the following illegal
      // conversion.
      //return d;
    }
  };
}

namespace mixed {
  class A {
  };

  class B : private A {
  public:
    void fun() {}; // can convert B -> A; D -> C (public)
  };

  class C : protected B {
  public:
    void fun() {}; // can convert C -> B; D -> B, C (public)
  };

  class D : public C {
  public:
    void fun() {}; // can convert C-> B; D -> C, B (public)
  };

  void fun() {}; // can convert D -> C (public)
}

namespace friend_class {
  class A {
  };

  class B : private A {
    friend class D1;
    friend class D2;

  public:
    void fun() {}; // can convert B -> A
  };

  class C : private B {
  public:
    void fun() {}; // can convert C -> B
  };

  class D1 : private C {
  public:
    void fun() {}; // can convert D1 -> B, C -> A (due to friend decl)
  };

  class D2 : private B {
  protected:
    void fun() {}; // can convert D2 -> A, B, B -> A (due to friend decl)
  };
}

namespace friend_fun {
  class A {
  };

  class B : private A {
    friend void fun2();
  };

  void fun1() {};
  void fun2() {}; // can convert B -> A (due to friend decl)
}
