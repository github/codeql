private import java
private import SSA
private import semmle.code.java.Reflection
private import semmle.code.java.Collections
private import semmle.code.java.Maps
private import semmle.code.java.dataflow.internal.rangeanalysis.SsaReadPositionCommon
private import semmle.code.java.security.RandomDataSource
private import semmle.code.java.semantic.SemanticExpr
private import semmle.code.java.semantic.SemanticType
private import ArrayLengthFlow

/**
 * Holds if `e >= bound` (if `upper = false`) or `e <= bound` (if `upper = true`).
 */
predicate hasConstantBound(SemExpr e, int bound, boolean upper) {
  exists(Expr javaExpr | javaExpr = getJavaExpr(e) |
    bound = 0 and
    upper = false and
    (
      javaExpr.(MethodAccess).getMethod() instanceof StringLengthMethod or
      javaExpr.(MethodAccess).getMethod() instanceof CollectionSizeMethod or
      javaExpr.(MethodAccess).getMethod() instanceof MapSizeMethod or
      javaExpr.(FieldRead).getField() instanceof ArrayLengthField
    )
    or
    exists(Method read |
      javaExpr.(MethodAccess).getMethod().overrides*(read) and
      read.getDeclaringType().hasQualifiedName("java.io", "InputStream") and
      read.hasName("read") and
      read.getNumberOfParameters() = 0
    |
      upper = true and bound = 255
      or
      upper = false and bound = -1
    )
  )
}

/**
 * Holds if `e >= bound + delta` (if `upper = false`) or `e <= bound + delta` (if `upper = true`).
 */
predicate hasBound(SemExpr e, SemExpr bound, int delta, boolean upper) {
  exists(RandomDataSource rds |
    getJavaExpr(e) = rds.getOutput() and
    (
      getJavaExpr(bound) = rds.getUpperBoundExpr() and
      delta = -1 and
      upper = true
      or
      getJavaExpr(bound) = rds.getLowerBoundExpr() and
      delta = 0 and
      upper = false
    )
  )
  or
  exists(MethodAccess ma, Method m |
    getJavaExpr(e) = ma and
    ma.getMethod() = m and
    (
      m.hasName("max") and upper = false
      or
      m.hasName("min") and upper = true
    ) and
    m.getDeclaringType().hasQualifiedName("java.lang", "Math") and
    getJavaExpr(bound) = ma.getAnArgument() and
    delta = 0
  )
}

/**
 * Holds if the value of `dest` is known to be `src + delta`.
 */
predicate additionalValueFlowStep(SemExpr dest, SemExpr src, int delta) {
  exists(ArrayCreationExpr a |
    arrayLengthDef(getJavaExpr(dest), a) and
    a.getDimension(0) = getJavaExpr(src) and
    delta = 0
  )
}

/**
 * Holds if the specified cast expression is known to not overflow or underflow.
 */
predicate isSafeCast(SemCastExpr cast) {
  exists(CastExpr javaCast, Type fromType, Type toType |
    getSemanticExpr(javaCast) = cast and
    fromType = javaCast.getExpr().getType() and
    toType = javaCast.getType()
  |
    conversionCannotOverflow(getSemanticType(fromType.(BoxedType).getPrimitiveType()),
      getSemanticType(toType))
    or
    conversionCannotOverflow(getSemanticType(fromType),
      getSemanticType(toType.(BoxedType).getPrimitiveType()))
  )
}

/**
 * Gets the type that range analysis should use to track the result of the specified expression,
 * if a type other than the original type of the expression is to be used.
 *
 * This predicate is commonly used in languages that support immutable "boxed" types that are
 * actually references but whose values can be tracked as the type contained in the box.
 */
SemType getAlternateType(SemExpr e) {
  result = getSemanticType(getJavaExpr(e).getType().(BoxedType).getPrimitiveType())
}
