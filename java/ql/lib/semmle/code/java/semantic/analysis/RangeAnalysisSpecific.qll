private import java
private import semmle.code.java.dataflow.SSA
private import semmle.code.java.Reflection
private import semmle.code.java.Collections
private import semmle.code.java.Maps
private import semmle.code.java.dataflow.internal.rangeanalysis.SsaReadPositionCommon
private import semmle.code.java.security.RandomDataSource
private import semmle.code.java.semantic.SemanticExprSpecific
private import semmle.code.java.semantic.SemanticExpr
private import semmle.code.java.semantic.SemanticSSA
private import semmle.code.java.semantic.SemanticType
private import ArrayLengthFlow

/**
 * Holds if the specified expression should be excluded from the result of `ssaRead()`.
 *
 * This predicate is to keep the results identical to the original Java implementation. It should be
 * removed once we hae the new implementation matching the old results exactly.
 */
predicate ignoreSsaReadCopy(SemExpr e) {
  getJavaExpr(e) instanceof LocalVariableDeclExpr
  or
  getJavaExpr(e) instanceof PlusExpr
  or
  getJavaExpr(e) instanceof PostIncExpr
  or
  getJavaExpr(e) instanceof PostDecExpr
}

/**
 * Ignore the bound on this expression.
 *
 * This predicate is to keep the results identical to the original Java implementation. It should be
 * removed once we hae the new implementation matching the old results exactly.
 */
predicate ignoreExprBound(SemExpr e) { getJavaExpr(e) instanceof LocalVariableDeclExpr }

/**
 * Ignore any inferred zero lower bound on this expression.
 *
 * This predicate is to keep the results identical to the original Java implementation. It should be
 * removed once we hae the new implementation matching the old results exactly.
 */
predicate ignoreZeroLowerBound(SemExpr e) { getJavaExpr(e) instanceof AssignAndExpr }

/**
 * Holds if the specified expression should be excluded from the result of `ssaRead()`.
 *
 * This predicate is to keep the results identical to the original Java implementation. It should be
 * removed once we hae the new implementation matching the old results exactly.
 */
predicate ignoreSsaReadArithmeticExpr(SemExpr e) { getJavaExpr(e) instanceof AssignOp }

/**
 * Holds if the specified variable should be excluded from the result of `ssaRead()`.
 *
 * This predicate is to keep the results identical to the original Java implementation. It should be
 * removed once we hae the new implementation matching the old results exactly.
 */
predicate ignoreSsaReadAssignment(SemSsaVariable v) {
  getJavaSsaVariable(v).(SsaExplicitUpdate).getDefiningExpr() instanceof LocalVariableDeclExpr
}

/**
 * Adds additional results to `ssaRead()` that are specific to Java.
 *
 * This predicate handles propagation of offsets for post-increment and post-decrement expressions
 * in exactly the same way as the old Java implementation. Once the new implementation matches the
 * old one, we should remove this predicate and propagate deltas for all similar patterns, whether
 * or not they come from a post-increment/decrement expression.
 */
SemExpr specificSsaRead(SemSsaVariable v, int delta) {
  exists(SsaExplicitUpdate ssaVar | ssaVar = getJavaSsaVariable(v) |
    result = getSemanticExpr(ssaVar.getDefiningExpr().(PostIncExpr)) and delta = 1
    or
    result = getSemanticExpr(ssaVar.getDefiningExpr().(PostDecExpr)) and delta = -1
  )
}

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
 * Gets the type that range analysis should use to track the result of the specified expression,
 * if a type other than the original type of the expression is to be used.
 *
 * This predicate is commonly used in languages that support immutable "boxed" types that are
 * actually references but whose values can be tracked as the type contained in the box.
 */
SemType getAlternateType(SemExpr e) {
  result = getSemanticType(getJavaExpr(e).getType().(BoxedType).getPrimitiveType())
}

/**
 * Gets the type that range analysis should use to track the result of the specified source
 * variable, if a type other than the original type of the expression is to be used.
 *
 * This predicate is commonly used in languages that support immutable "boxed" types that are
 * actually references but whose values can be tracked as the type contained in the box.
 */
SemType getAlternateTypeForSsaVariable(SemSsaVariable var) {
  result =
    getSemanticType(getJavaSsaVariable(var)
          .getSourceVariable()
          .getType()
          .(BoxedType)
          .getPrimitiveType())
}
