// semmle-extractor-options: -std=c++11

namespace range_based_for_11 {
  void array() {
    int arr[4];
    for (auto &el : arr) {
      el = 0;
    }
  }

  struct Iterator {
    void *pos_data;
    bool operator!=(const Iterator &other);
    Iterator &operator++();
    int &operator*();
    ~Iterator();
  };

  struct Iterable {
    void *container_data;
    Iterator begin();
    Iterator end();
  };

  Iterable getContainer();

  int getFirst() {
    for (auto& el : getContainer()) {
      return el;
    }
    return 0;
  }
}

const int global_const = 5;
int global_int = 5;

void skip_init() {
  static int x1 = 0;
  static int x2 = 1;
  static int x3 = 0 + 0;
  static int *x4 = 0;
  static int *x5 = &x3;
  static int *x6 = (&x3 + 1) - 1;
  static int x7[] = { 0, 1 };
  static int *x8[] = { &x1, &global_int };
  static struct { int x; } x9[] = { { 1 } };

  static const char *s1 = "Hello";
  static char s2[] = "World";
  // TODO: non-POD types that may have constructors and such
}

void run_init() {
  int nonstatic;
  static int x1 = global_int;

  // It makes no sense to initialize a static variable to the address of a
  // non-static variable, but in principle it can be done:
  static int *x2 = &nonstatic;
}

namespace lambda {
  void simple(int x) {
    auto closure = [=]() -> int { return x; };
  }

  class Val {
    void *m_data;
  public:
    Val(int);
    Val(const Val &);
  };

  template<typename Fn>
  void apply(Val arg, Fn unaryFunction) {
    unaryFunction(arg);
  }

  template <typename Fn>
  void apply2(Fn binaryFunction, Val arg1, Val arg2) {
    apply(arg2, [=](Val x) { binaryFunction(arg1, x); });
  }

  int doSomething(Val arg1, Val arg2);

  void main() {
    apply2(doSomething, Val(1), Val(2));
  }
}

namespace synthetic_dtor_calls {
  struct C {
    ~C();
  };

  void thrw() {
    C c1, c2;
    throw 1;
  }

  void fallthrough() {
    C c1, c2;
  }

  int ret() {
    C c1, c2;
    return 2 + 2;
  }

  void leavescope() {
    {
      C c1, c2;
    }
  }

  static void f(int x) {
    while (x > 0) {
      C c;
      if (x == 1) {
        0;
      } else if (x == 2) {
        1;
      } else if (x == 4) {
        goto end;
      } else if (x == 5) {
        goto end;
      } else if (x == 3) {
        break;
      } else {
        break;
      }
    }
  end:
    ;
  }

  // This function is interesting because its extractor CFG has unreachable
  // calls to `c2.~C()` and `c3.~C()`. It's the calls that would have come from
  // leaving the block of `c2` by falling off the end, but no path does that.
  static int g(int x) {
    do {
      C c1;
      if (x > 0) {
        if (x < 10) {
          C c2;
          if (x == 1) {
            return 0;
          } else {
            return 1;
          }
        } else {
          C c3;
          if (x == 11) {
            break;
          } else {
            break;
          }
        }
      }
    } while (0);
  }

  void localClass(int x) {
    struct L {
      ~L() { }
    } l;
    if (x) {
      throw 1;
    }
  }
}
