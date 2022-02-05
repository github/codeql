private import java
private import semmle.code.java.Reflection
private import semmle.code.java.Collections
private import semmle.code.java.Maps
private import semmle.code.java.security.RandomDataSource

predicate hasZeroLowerBound(Expr e) {
  e.(MethodAccess).getMethod() instanceof StringLengthMethod or
  e.(MethodAccess).getMethod() instanceof CollectionSizeMethod or
  e.(MethodAccess).getMethod() instanceof MapSizeMethod or
  e.(FieldRead).getField() instanceof ArrayLengthField
}

predicate hasBound(Expr e, Expr bound, int delta, boolean upper) {
  exists(RandomDataSource rds |
    e = rds.getOutput() and
    (
      bound = rds.getUpperBoundExpr() and
      delta = -1 and
      upper = true
      or
      bound = rds.getLowerBoundExpr() and
      delta = 0 and
      upper = false
    )
  )
  or
  exists(MethodAccess ma, Method m |
    e = ma and
    ma.getMethod() = m and
    (
      m.hasName("max") and upper = false
      or
      m.hasName("min") and upper = true
    ) and
    m.getDeclaringType().hasQualifiedName("java.lang", "Math") and
    bound = ma.getAnArgument() and
    delta = 0
  )
}
