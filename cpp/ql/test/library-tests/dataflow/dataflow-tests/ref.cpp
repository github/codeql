int source();

template<typename T>
void sink(T);

extern int arbitrary;

namespace withoutFields {
  template<typename T>
  void assign(T &lhs, T rhs) {
    lhs = rhs;
  }

  template<typename T>
  void assignWrapper(T &lhs, T rhs) {
    assign(lhs, rhs);
  }

  void notAssign(int &lhs, int rhs) {
    lhs = rhs;
    if (arbitrary) {
      lhs = 1;
    } else {
      lhs = 2;
    }
  }

  void sourceToParam(int &out) {
    out = source();
    if (arbitrary) {
      out = 1;
    }
  }

  void sourceToParamWrapper(int &out) {
    if (arbitrary) {
      sourceToParam(out);
    } else {
      out = 1;
    }
  }

  void notSource(int &out) {
    out = source();
    if (arbitrary) {
      out = 1;
    } else {
      out = 2;
    }
  }

  void testRefs() {
    int x1, x2, x3, x4;

    assignWrapper(x1, source());
    sink(x1); // $ ast=55:23 ir SPURIOUS: ast=53:9

    notAssign(x2, source());
    sink(x2); // $ SPURIOUS: ast,ir

    sourceToParamWrapper(x3);
    sink(x3); // $ ast=29:11 ir SPURIOUS: ast=53:17

    notSource(x4);
    sink(x4); // $ SPURIOUS: ast,ir
  }
}

namespace withFields {
  struct Int {
    int val;
  };

  void assign(Int &lhs, int rhs) {
    lhs.val = rhs;
  }

  void assignWrapper(Int &lhs, int rhs) {
    assign(lhs, rhs);
  }

  void notAssign(Int &lhs, int rhs) {
    lhs.val = rhs;
    // Field flow ignores that the field is subsequently overwritten, leading
    // to false flow here.
    if (arbitrary) {
      lhs.val = 1;
    } else {
      lhs.val = 2;
    }
  }

  void sourceToParam(Int &out) {
    out.val = source();
    if (arbitrary) {
      out.val = 1;
    }
  }

  void sourceToParamWrapper(Int &out) {
    if (arbitrary) {
      sourceToParam(out);
    } else {
      out.val = 1;
    }
  }

  void notSource(Int &out) {
    out.val = source();
    // Field flow ignores that the field is subsequently overwritten, leading
    // to false flow here.
    if (arbitrary) {
      out.val = 1;
    } else {
      out.val = 2;
    }
  }

  void testRefs() {
    Int x1, x2, x3, x4;

    assignWrapper(x1, source());
    sink(x1.val); // $ ast,ir

    notAssign(x2, source());
    sink(x2.val); // $ SPURIOUS: ast,ir

    sourceToParamWrapper(x3);
    sink(x3.val); // $ ast,ir

    notSource(x4);
    sink(x4.val); // $ SPURIOUS: ast,ir
  }
}
