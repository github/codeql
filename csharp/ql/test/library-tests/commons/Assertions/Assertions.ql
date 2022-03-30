import csharp
import semmle.code.csharp.commons.Assertions

query predicate assertTrue(Assertion a, Expr e) {
  exists(int i |
    a.getExpr(i) = e and
    i = a.getTarget().(BooleanAssertMethod).getAnAssertionIndex(true)
  )
}

query predicate assertFalse(Assertion a, Expr e) {
  exists(int i |
    a.getExpr(i) = e and
    i = a.getTarget().(BooleanAssertMethod).getAnAssertionIndex(false)
  )
}

query predicate assertNull(Assertion a, Expr e) {
  exists(int i |
    a.getExpr(i) = e and
    i = a.getTarget().(NullnessAssertMethod).getAnAssertionIndex(true)
  )
}

query predicate assertNonNull(Assertion a, Expr e) {
  exists(int i |
    a.getExpr(i) = e and
    i = a.getTarget().(NullnessAssertMethod).getAnAssertionIndex(false)
  )
}
