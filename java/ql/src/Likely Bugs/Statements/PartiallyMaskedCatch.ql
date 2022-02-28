/**
 * @name Unreachable catch clause
 * @description An unreachable 'catch' clause may indicate a mistake in exception handling or may
 *              be unnecessary.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id java/unreachable-catch-clause
 * @tags reliability
 *       correctness
 *       exceptions
 *       external/cwe/cwe-561
 */

import java

/**
 * Exceptions of type `rt` thrown from within statement `s` are caught by an inner try block
 * and are therefore not propagated to the outer try block `t`.
 */
private predicate caughtInside(TryStmt t, Stmt s, RefType rt) {
  exists(TryStmt innerTry | innerTry.getEnclosingStmt+() = t.getBlock() |
    s.getEnclosingStmt+() = innerTry.getBlock() and
    caughtType(innerTry, _).hasSubtype*(rt)
  )
}

/**
 * Returns an exception type thrown from within the try block of `t`
 * that is relevant to the catch clauses of `t` (i.e. not already
 * caught by an inner try-catch).
 */
private RefType getAThrownExceptionType(TryStmt t) {
  exists(Method m, Exception e |
    (
      m = t.getAResourceDecl().getAVariable().getType().(RefType).getAMethod() or
      m = t.getAResourceExpr().getType().(RefType).getAMethod()
    ) and
    m.hasName("close") and
    m.hasNoParameters() and
    m.getAnException() = e and
    result = e.getType()
  )
  or
  exists(Call call, Exception e |
    t.getBlock() = call.getEnclosingStmt().getEnclosingStmt*() or
    t.getAResourceDecl() = call.getEnclosingStmt()
  |
    (
      call.getCallee().getAnException() = e or
      call.(GenericCall).getATypeArgument(call.getCallee().getAnException().getType()) = e.getType()
    ) and
    not caughtInside(t, call.getEnclosingStmt(), e.getType()) and
    result = e.getType()
  )
  or
  exists(ThrowStmt ts |
    t.getBlock() = ts.getEnclosingStmt*() and
    not caughtInside(t, ts, ts.getExpr().getType()) and
    result = ts.getExpr().getType()
  )
}

private RefType caughtType(TryStmt try, int index) {
  exists(CatchClause cc | cc = try.getCatchClause(index) |
    if cc.isMultiCatch()
    then result = cc.getVariable().getTypeAccess().(UnionTypeAccess).getAnAlternative().getType()
    else result = cc.getVariable().getType()
  )
}

private predicate maybeUnchecked(RefType t) {
  t.getAnAncestor().hasQualifiedName("java.lang", "RuntimeException") or
  t.getAnAncestor().hasQualifiedName("java.lang", "Error") or
  t.hasQualifiedName("java.lang", "Exception") or
  t.hasQualifiedName("java.lang", "Throwable")
}

predicate overlappingExceptions(RefType e1, RefType e2) {
  exists(RefType throwable | throwable.hasQualifiedName("java.lang", "Throwable") |
    throwable.hasSubtype*(e1) and
    throwable.hasSubtype*(e2) and
    e1.getADescendant() = e2.getADescendant()
  )
}

from TryStmt try, int first, int second, RefType masking, RefType masked, string multiCatchMsg
where
  masking = caughtType(try, first) and
  masking.getAStrictAncestor() = masked and
  masked = caughtType(try, second) and
  forall(RefType thrownType |
    thrownType = getAThrownExceptionType(try) and
    // If there's any overlap in the types, this catch block may be relevant.
    overlappingExceptions(thrownType, masked)
  |
    exists(RefType priorCaughtType, int priorIdx |
      priorIdx < second and
      priorCaughtType = caughtType(try, priorIdx) and
      thrownType.hasSupertype*(priorCaughtType)
    )
  ) and
  not maybeUnchecked(masked) and
  if try.getCatchClause(second).isMultiCatch()
  then multiCatchMsg = " for type " + masked.getName()
  else multiCatchMsg = ""
select try.getCatchClause(second),
  "This catch-clause is unreachable" + multiCatchMsg + "; it is masked $@.",
  try.getCatchClause(first), "here for exceptions of type '" + masking.getName() + "'"
