public class ExprDeref {
  Integer getBoxed() {
    return 0;
  }

  int unboxBad(boolean b) {
    return (b ? null : getBoxed()); // $ Alert[java/dereferenced-expr-may-be-null] // NPE
  }
}
