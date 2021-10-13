/**
 * @name Race condition in double-checked locking object initialization
 * @description Performing additional initialization on an object after
 *              assignment to a shared variable guarded by double-checked
 *              locking is not thread-safe, and could result in unexpected
 *              behavior.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id java/unsafe-double-checked-locking-init-order
 * @tags reliability
 *       correctness
 *       concurrency
 *       external/cwe/cwe-609
 */

import java
import DoubleCheckedLocking

predicate whitelistedMethod(Method m) {
  m.getDeclaringType().hasQualifiedName("java.io", _) and
  m.hasName("println")
}

class SideEffect extends Expr {
  SideEffect() {
    this instanceof MethodAccess and
    not whitelistedMethod(this.(MethodAccess).getMethod())
    or
    this.(Assignment).getDest() instanceof FieldAccess
  }
}

from IfStmt if1, IfStmt if2, SynchronizedStmt sync, Field f, AssignExpr a, SideEffect se
where
  doubleCheckedLocking(if1, if2, sync, f) and
  a.getEnclosingStmt().getEnclosingStmt*() = if2.getThen() and
  se.getEnclosingStmt().getEnclosingStmt*() = sync.getBlock() and
  a.(ControlFlowNode).getASuccessor+() = se and
  a.getDest().(FieldAccess).getField() = f
select a,
  "Potential race condition. This assignment to $@ is visible to other threads before the subsequent statements are executed.",
  f, f.toString()
