public class ExprDeref {
  Integer getBoxed() {
    return 0;
  }

  int unboxBad(boolean b) {
    return (b ? null : getBoxed()); // NPE
  }
}
