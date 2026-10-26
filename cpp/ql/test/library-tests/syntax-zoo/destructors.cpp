struct HasDtor {
  int x;
  ~HasDtor();
};

int destructors_main(HasDtor p) {
  HasDtor fscope;
  {
    HasDtor inner;
    if (p.x == 1) {
      return 1;
    }
    ;
  }
  if (p.x == 2) {
    return 2;
  }
  ;
  return 3;
  ;
}


void destructor_after_handler() {
  HasDtor x;

  try {
  } catch (const HasDtor&) {
    return;
  }
}

void destructor_catch() {
  try {
  } catch (HasDtor d) {
    HasDtor d2 = { 0 };
  }
}

namespace cond_destruct {
  struct C {
      C();
      C(const C&) = delete;
      ~C();
      int getInt() const;
      void *data;
  };

  int f(int x) {
      C local;
      const C &ref = x ? (const C&)C() : (const C&)local;
      return ref.getInt();
      // If `x` was true, `ref` refers to a temporary object whose lifetime was
      // extended to coincide with `ref`. Before the function returns, it
      // should destruct `ref` if and only if the first branch was taken in the
      // ?: expression.
  }
}
