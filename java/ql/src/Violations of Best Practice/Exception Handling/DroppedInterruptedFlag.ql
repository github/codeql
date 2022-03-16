/**
 * @name Missing reset of the thread interrupt flag
 * @description Catching the `InterruptedException` without resetting the interrupt flag
 *              may cause deadlocks.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/unreset-interrupt-flag
 * @tags reliability
 *       external/cwe/cwe-391
 *       external/cwe/cwe-833
 */

import java
import semmle.code.java.dataflow.DataFlow

/** The class `java.lang.InterruptedException`. */
private class InterruptedException extends RefType {
  InterruptedException() { this.hasQualifiedName("java.lang", "InterruptedException") }
}

/** The class `java.lang.Thread`. */
private class Thread extends RefType {
  Thread() { this.hasQualifiedName("java.lang", "Thread") }
}

/** Holds if `java.lang.InterruptedException` is caught. */
CatchClause catchesIE(TryStmt t) {
  exists(LocalVariableDeclExpr v |
    t.getACatchClause() = result and
    result.getVariable() = v and
    v.getType().(RefType).getADescendant() instanceof InterruptedException
  )
}

predicate throwsIE(Expr e) {
  exists(Callable c |
    c.getAThrownExceptionType().(RefType).getADescendant() instanceof InterruptedException
  |
    e.(ConstructorCall).getConstructor() = c or
    e.(MethodAccess).getMethod() = c
  )
}

MethodAccess threadInterruptMethodAccess() {
  result =
    any(MethodAccess ma |
      ma.getMethod() =
        any(Method m | m.hasName("interrupt") and m.getDeclaringType() instanceof Thread) and
      DataFlow::localExprFlow(any(Method m | m.hasName("currentThread")).getAReference(),
        ma.getQualifier())
    )
}

Stmt stmtContainingInterrupt() {
  result = threadInterruptMethodAccess().getAnEnclosingStmt() or
  result =
    any(Method m | m.getBody() = stmtContainingInterrupt()).getAReference().getAnEnclosingStmt()
}

from Expr e, TryStmt t, CatchClause cc
where
  throwsIE(e) and
  t.getBlock() = e.getEnclosingStmt().getEnclosingStmt*() and
  cc = catchesIE(t) and
  not cc = stmtContainingInterrupt() and
  not exists(Callable c |
    cc.getEnclosingCallable() = c and
    c.getAThrownExceptionType().getADescendant() instanceof InterruptedException
  )
select cc, "Catches InterruptedException, but fails to reset the thread interrupt flag."
