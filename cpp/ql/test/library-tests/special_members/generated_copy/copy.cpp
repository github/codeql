namespace protected_cc {
  class C {
    int i;
  protected:
    C(const C&) = default;
    C& operator=(const C&) = default;
  };

  class Sub1 : private C {
    // should have copy members
  };

  class Sub2: public Sub1 {
    // should have copy members
  };

  class HasMember {
    C c;
    // should NOT have copy members
  };
}

namespace deleted_cc {
  class C {
    C(const C&) = delete;
    C& operator=(const C&) = delete;
  };

  class Sub : public C {
    // should NOT have copy members
  };
}

namespace private_cc {
  class C {
  private:
    C(C&) = default;
    C& operator=(const C&) = default;
  };

  class Sub : private C {
    // should NOT have copy members
  public:
    // In the terminology of clang, this constructor is explicitly defaulted
    // but implicitly deleted
    Sub(Sub&) = default;
  };

  class HasPointer {
    C *c;
    // should have copy members since pointers are copyable
  };

  class HasArray {
    C c[2];
    // should NOT have copy members
  };

  class HasArray2D {
    C c[2][2];
    // should NOT have copy members
  };
}

namespace container {
  template<class T>
  class Wrapper {
    T t;
  };

  class Copyable {};
  class NotCopyable {
    int&& i;
  };

  class CopyableComposition {
    Wrapper<Copyable> w;
  };

  class NotCopyableComposition {
    Wrapper<NotCopyable> w;
  };

  class CopyableInheritance : Wrapper<Copyable> {};

  class NotCopyableInheritance : Wrapper<NotCopyable> {};
}

namespace typedefs {
  class A {
    class B { };
    friend class C;
  };

  class C {
  public:
    typedef A::B D;
  };

  class Derived : C::D {
    // should have copy members
  };
}

namespace moves {
  class MoveCtor {
  public:
    MoveCtor(MoveCtor&& that) {}
  };

  class MoveAssign {
  public:
    MoveAssign& operator=(MoveAssign&& that) {
      return *this;
    }
  };
}

namespace difference {
  class OnlyCtor {
    const int i;
  };

  class Base {
  public:
    Base& operator=(const Base&);
  private:
    Base(const Base&);
  };

  class OnlyAssign : Base {
  };
}
