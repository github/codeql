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
  m.getDeclaringType().hasQualifiedName("com.google.common.base", "Preconditions") and
  checkTrue = true and
  (m.hasName("checkArgument") or m.hasName("checkState"))
  or
  m.getDeclaringType().hasQualifiedName("org.apache.commons.lang3", "Validate") and
  checkTrue = true and
  (m.hasName("isTrue") or m.hasName("validState"))
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
  or
  exists(Parameter p, MethodAccess ma, boolean ct, Expr arg |
    p = m.getParameter(0) and
    not m.isOverridable() and
    m.getBody().getStmt(0).(ExprStmt).getExpr() = ma and
    conditionCheck(ma, ct) and
    ma.getArgument(0) = arg and
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
