/**
 * Provides predicates for identifying precondition checks like
 * `com.google.common.base.Preconditions` and
 * `org.apache.commons.lang3.Validate`.
 */

import java

/**
 * Holds if `m` is a non-overridable method that checks that its first argument
 * is equal to `checkTrue` and throws otherwise.
 */
predicate conditionCheckMethod(Method m, boolean checkTrue) {
  conditionCheckMethod(m, 0, checkTrue)
  or
  m.getDeclaringType().hasQualifiedName("com.google.common.base", "Preconditions") and
  checkTrue = true and
  (m.hasName("checkArgument") or m.hasName("checkState"))
  or
  m.getDeclaringType().hasQualifiedName("org.apache.commons.lang3", "Validate") and
  checkTrue = true and
  (m.hasName("isTrue") or m.hasName("validState"))
  or
  m.getDeclaringType().hasQualifiedName("org.junit", "Assume") and
  checkTrue = true and
  m.hasName("assumeTrue")
  or
  m.getDeclaringType().hasQualifiedName("org.junit.jupiter.api", "Assertions") and
  (
    checkTrue = true and m.hasName("assertTrue")
    or
    checkTrue = false and m.hasName("assertFalse")
  )
  or
  m.getDeclaringType().hasQualifiedName("org.junit.jupiter.api", "Assumptions") and
  (
    checkTrue = true and m.hasName("assumeTrue")
    or
    checkTrue = false and m.hasName("assumeFalse")
  )
  or
  exists(Parameter p, IfStmt ifstmt, Expr cond |
    p = m.getParameter(0) and
    not m.isOverridable() and
    p.getType() instanceof BooleanType and
    m.getBody().getStmt(0) = ifstmt and
    ifstmt.getCondition() = cond and
    (
      cond.(LogNotExpr).getExpr().(VarAccess).getVariable() = p and checkTrue = true
      or
      cond.(VarAccess).getVariable() = p and checkTrue = false
    ) and
    (
      ifstmt.getThen() instanceof ThrowStmt or
      ifstmt.getThen().(SingletonBlock).getStmt() instanceof ThrowStmt
    )
  )
}

/**
 * Holds if `m` is a non-overridable method that checks that its zero-indexed `argument`
 * is equal to `checkTrue` and throws otherwise.
 */
predicate conditionCheckMethod(Method m, int argument, boolean checkTrue) {
  conditionCheckMethod(m, checkTrue) and argument = 0
  or
  m.getDeclaringType().hasQualifiedName(["org.junit", "org.testng"], "Assert") and
  m.getParameter(argument).getType() instanceof BooleanType and
  (
    checkTrue = true and m.hasName("assertTrue")
    or
    checkTrue = false and m.hasName("assertFalse")
  )
  or
  exists(Parameter p, MethodAccess ma, int argIndex, boolean ct, Expr arg |
    p = m.getParameter(argument) and
    not m.isOverridable() and
    m.getBody().getStmt(0).(ExprStmt).getExpr() = ma and
    conditionCheck(ma, argIndex, ct) and
    ma.getArgument(argIndex) = arg and
    (
      arg.(LogNotExpr).getExpr().(VarAccess).getVariable() = p and
      checkTrue = ct.booleanNot()
      or
      arg.(VarAccess).getVariable() = p and checkTrue = ct
    )
  )
}

/**
 * Holds if `ma` is an access to a non-overridable method that checks that its
 * first argument is equal to `checkTrue` and throws otherwise.
 */
predicate conditionCheck(MethodAccess ma, boolean checkTrue) {
  conditionCheckMethod(ma.getMethod().getSourceDeclaration(), checkTrue)
}

/**
 * Holds if `ma` is an access to a non-overridable method that checks that its
 * zero-indexed `argument` is equal to `checkTrue` and throws otherwise.
 */
predicate conditionCheck(MethodAccess ma, int argument, boolean checkTrue) {
  conditionCheckMethod(ma.getMethod().getSourceDeclaration(), argument, checkTrue)
}
