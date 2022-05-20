class ComplexCondition {
  public boolean bad(boolean a, boolean b, boolean c) {
    if (a && (b || !c)
    ||  b && (a || !c)
    ||  c && (a || !b)) {
      return true;
    } else {
      return (a && !b) || (b && !c) || (a && !c) || (a && b || c);
    }
  }

  public boolean ok(boolean a, boolean b, boolean c) {
    if (a && b && c && !a && !b && !c) {
      return true;
    } else {
      return (a && !b) || (b && !c) || (a && !c) || (a && b && c);
    }
  }

  public boolean lengthy(boolean a, boolean b, boolean c) {
    return ok(
      new ComplexCondition() {
        // Imagine there was stuff here...
      }.ok(a || b, b || c, c || a),
      new ComplexCondition() {
        // ... and here ...
      }.ok(a || b, b || c, c || a),
      new ComplexCondition() {
        // ... and here.
      }.ok(a || b, b || c, c || a)
    );
  }
};