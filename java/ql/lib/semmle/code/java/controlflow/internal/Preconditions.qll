/**
 * Provides predicates for identifying precondition checks like
 * `com.google.common.base.Preconditions` and
 * `org.apache.commons.lang3.Validate`.
 */

import java

/**
 * DEPRECATED: Use `conditionCheckMethodArgument` instead.
 * Holds if `m` is a non-overridable method that checks that its first argument
 * is equal to `checkTrue` and throws otherwise.
 */
deprecated predicate conditionCheckMethod(Method m, boolean checkTrue) {
  conditionCheckMethodArgument(m, 0, checkTrue)
}

/**
 * Holds if `m` is a non-overridable method that checks that its zero-indexed `argument`
 * is equal to `checkTrue` and throws otherwise.
 */
predicate conditionCheckMethodArgument(Method m, int argument, boolean checkTrue) {
  condtionCheckMethodGooglePreconditions(m, checkTrue) and argument = 0
  or
  conditionCheckMethodApacheCommonsLang3Validate(m, checkTrue) and argument = 0
  or
  condtionCheckMethodTestingFramework(m, argument, checkTrue)
  or
  exists(Parameter p, MethodAccess ma, int argIndex, boolean ct, Expr arg |
    p = m.getParameter(argument) and
    not m.isOverridable() and
    m.getBody().getStmt(0).(ExprStmt).getExpr() = ma and
    conditionCheckArgument(ma, argIndex, ct) and
    ma.getArgument(argIndex) = arg and
    (
      arg.(LogNotExpr).getExpr().(VarAccess).getVariable() = p and
      checkTrue = ct.booleanNot()
      or
      arg.(VarAccess).getVariable() = p and checkTrue = ct
    )
  )
  or
  exists(Parameter p, IfStmt ifstmt, Expr cond |
    p = m.getParameter(argument) and
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

private predicate condtionCheckMethodGooglePreconditions(Method m, boolean checkTrue) {
  m.getDeclaringType().hasQualifiedName("com.google.common.base", "Preconditions") and
  checkTrue = true and
  (m.hasName("checkArgument") or m.hasName("checkState"))
}

private predicate conditionCheckMethodApacheCommonsLang3Validate(Method m, boolean checkTrue) {
  m.getDeclaringType().hasQualifiedName("org.apache.commons.lang3", "Validate") and
  checkTrue = true and
  (m.hasName("isTrue") or m.hasName("validState"))
}

/**
 * Holds if `m` is a non-overridable testing framework method that checks that its first argument
 * is equal to `checkTrue` and throws otherwise.
 */
private predicate condtionCheckMethodTestingFramework(Method m, int argument, boolean checkTrue) {
  argument = 0 and
  (
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
  )
  or
  m.getDeclaringType().hasQualifiedName(["org.junit", "org.testng"], "Assert") and
  m.getParameter(argument).getType() instanceof BooleanType and
  (
    checkTrue = true and m.hasName("assertTrue")
    or
    checkTrue = false and m.hasName("assertFalse")
  )
}

/**
 * DEPRECATED: Use `conditionCheckArgument` instead.
 * Holds if `ma` is an access to a non-overridable method that checks that its
 * first argument is equal to `checkTrue` and throws otherwise.
 */
deprecated predicate conditionCheck(MethodAccess ma, boolean checkTrue) {
  conditionCheckArgument(ma, 0, checkTrue)
}

/**
 * Holds if `ma` is an access to a non-overridable method that checks that its
 * zero-indexed `argument` is equal to `checkTrue` and throws otherwise.
 */
predicate conditionCheckArgument(MethodAccess ma, int argument, boolean checkTrue) {
  conditionCheckMethodArgument(ma.getMethod().getSourceDeclaration(), argument, checkTrue)
}
