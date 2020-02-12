import csharp
import semmle.code.csharp.commons.Assertions

query predicate assertTrue(Assertion a, Expr e) {
  a.getExpr() = e and
  a.getTarget() instanceof AssertTrueMethod
}

query predicate assertFalse(Assertion a, Expr e) {
  a.getExpr() = e and
  a.getTarget() instanceof AssertFalseMethod
}

query predicate assertNull(Assertion a, Expr e) {
  a.getExpr() = e and
  a.getTarget() instanceof AssertNullMethod
}

query predicate assertNonNull(Assertion a, Expr e) {
  a.getExpr() = e and
  a.getTarget() instanceof AssertNonNullMethod
}
