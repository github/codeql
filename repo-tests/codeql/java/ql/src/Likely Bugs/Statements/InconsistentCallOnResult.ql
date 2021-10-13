/**
 * @name Inconsistent operation on return value
 * @description If the same operation is usually performed
 *              on the result of a method call, any cases where it
 *              is not performed may indicate resource leaks or other problems.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/inconsistent-call-on-result
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-252
 *       statistical
 *       non-attributable
 */

import java
import Chaining

predicate exclude(Method m) {
  exists(string name | name = m.getName().toLowerCase() |
    name.matches("get%") or
    name.matches("is%") or
    name.matches("has%") or
    name.matches("add%")
  )
}

/**
 * The method access `otherCall`
 *  - is described by operation,
 *  - operates on `v`,
 *  - is different from `callToCheck`, and
 *  - is not a call to an excluded method.
 */
predicate checkExpr(MethodAccess callToCheck, MethodAccess otherCall, string operation, Variable v) {
  not exclude(otherCall.getMethod()) and
  v.getAnAssignedValue() = callToCheck and
  otherCall != callToCheck and
  otherCall.getMethod().getName() = operation and
  (
    otherCall.getAnArgument() = getChainedAccess(v) or
    otherCall.getQualifier() = getChainedAccess(v)
  )
}

/**
 * Holds if `operation` is implicitly called on `v`, and `v` is assigned the result of `callToCheck`.
 */
predicate implicitCheckExpr(MethodAccess callToCheck, string operation, Variable v) {
  exists(TryStmt try, LocalVariableDeclExpr decl |
    try.getAResourceDecl().getAVariable() = decl and
    decl.getVariable() = v and
    decl.getInit() = callToCheck and
    operation = "close"
  )
}

/**
 * Get all accesses to a variable, either directly or by a chain of method calls.
 */
Expr getChainedAccess(Variable v) {
  result = v.getAnAccess()
  or
  exists(MethodAccess chainedAccess | chainedAccess.getQualifier() = getChainedAccess(v) |
    designedForChaining(chainedAccess.getMethod()) and result = chainedAccess
  )
}

/**
 * The result of `ma` and a call to a method named `operation` are both assigned to the same variable.
 */
predicate checkedFunctionCall(MethodAccess ma, string operation) {
  relevantFunctionCall(ma, _) and
  exists(Variable v | not v instanceof Field |
    v.getAnAssignedValue() = ma and
    (checkExpr(ma, _, operation, v) or implicitCheckExpr(ma, operation, v))
  )
}

/**
 * The method access `ma` is a call to `m` where the result is assigned.
 */
predicate relevantFunctionCall(MethodAccess ma, Method m) {
  ma.getMethod() = m and
  exists(Variable v | v.getAnAssignedValue() = ma) and
  not okToIgnore(ma)
}

predicate okToIgnore(MethodAccess ma) { not ma.getCompilationUnit().fromSource() }

predicate functionStats(Method m, string operation, int used, int total, int percentage) {
  m.getReturnType() instanceof RefType and
  // Calls to `m` where we also perform `operation`.
  used = strictcount(MethodAccess ma | checkedFunctionCall(ma, operation) and m = ma.getMethod()) and
  // Calls to `m`.
  total = strictcount(MethodAccess ma | relevantFunctionCall(ma, m)) and
  percentage = used * 100 / total
}

from MethodAccess unchecked, Method m, string operation, int percent
where
  relevantFunctionCall(unchecked, m) and
  not checkedFunctionCall(unchecked, operation) and
  functionStats(m, operation, _, _, percent) and
  percent >= 90 and
  not m.getName() = operation and
  not unchecked.getEnclosingStmt().(ExprStmt).isFieldDecl()
select unchecked,
  "After " + percent.toString() + "% of calls to " + m.getName() + " there is a call to " +
    operation + " on the return value. The call may be missing in this case."
