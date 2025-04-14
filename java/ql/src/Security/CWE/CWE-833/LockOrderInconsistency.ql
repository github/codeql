/**
 * @name Lock order inconsistency
 * @description Acquiring multiple locks in a different order may cause deadlock.
 * @kind problem
 * @problem.severity recommendation
 * @security-severity 5.0
 * @precision medium
 * @id java/lock-order-inconsistency
 * @tags security
 *       external/cwe/cwe-833
 */

import java

/** A variable of type `ReentrantLock`. */
class LockVariable extends Variable {
  LockVariable() {
    this.getType().(RefType).hasQualifiedName("java.util.concurrent.locks", "ReentrantLock")
  }

  /** An access to method `lock` on this variable. */
  MethodCall getLockAction() {
    exists(MethodCall ma | ma.getQualifier() = this.getAnAccess() |
      ma.getMethod().hasName("lock") and
      result = ma
    )
  }
}

/** A synchronized method or statement, or an expression statement containing an access to a synchronized method. */
class Synched extends Top {
  Synched() {
    this instanceof SynchronizedStmt
    or
    exists(Method m | m.isSynchronized() and not m.isStatic() |
      m = this
      or
      exists(MethodCall ma, VarAccess qual | ma = this and qual = ma.getQualifier() |
        ma.getMethod() = m
      )
    )
  }

  /** A synchronizing statement nested within this element. */
  Synched getInnerSynch() {
    result = this.(Method).getBody().getAChild*()
    or
    result = this.(SynchronizedStmt).getAChild+()
    or
    exists(MethodCall ma | ma = result |
      ma.getEnclosingStmt().getEnclosingStmt*() = this or ma.getEnclosingCallable() = this
    )
  }

  /** The variable on which synchronization is performed, provided this element is a `SynchronizedStmt`. */
  Variable getLockVar() {
    exists(VarAccess va | va = this.(SynchronizedStmt).getExpr() and not exists(va.getQualifier()) |
      result = va.getVariable()
    )
  }

  /**
   * The type of the instance on which synchronization is performed, provided this element is a
   * synchronized method or method access.
   */
  RefType getLockType() {
    result = this.(Method).getDeclaringType().getSourceDeclaration() or
    result = this.(MethodCall).getMethod().getDeclaringType().getSourceDeclaration()
  }
}

/**
 * In one situation, a `ReentrantLock` is obtained on one variable in `first`
 * and then on another variable in `second`, but elsewhere, the lock order is reversed
 * by first obtaining a lock on the latter variable in `otherFirst`.
 */
predicate badReentrantLockOrder(MethodCall first, MethodCall second, MethodCall otherFirst) {
  exists(LockVariable v1, LockVariable v2, MethodCall otherSecond |
    first = v1.getLockAction() and
    otherSecond = v1.getLockAction() and
    second = v2.getLockAction() and
    otherFirst = v2.getLockAction() and
    first.getControlFlowNode().getASuccessor+() = second.getControlFlowNode() and
    otherFirst.getControlFlowNode().getASuccessor+() = otherSecond.getControlFlowNode()
  |
    v1 != v2
  )
}

/**
 * In one situation, two synchronized statements `outer` and `inner` obtain locks
 * on different variables in one order, and elsewhere, the lock order is reversed,
 * starting with `otherOuter`.
 */
predicate badSynchronizedStmtLockOrder(Expr outerExpr, Expr innerExpr, Expr otherOuterExpr) {
  exists(Synched outer, Synched inner, Synched otherOuter |
    outer.(SynchronizedStmt).getExpr() = outerExpr and
    inner.(SynchronizedStmt).getExpr() = innerExpr and
    otherOuter.(SynchronizedStmt).getExpr() = otherOuterExpr and
    inner = outer.getInnerSynch() and
    exists(Variable v1, Variable v2 |
      v1 = outer.getLockVar() and v2 = inner.getLockVar() and v1 != v2
    |
      exists(Synched otherInner | otherInner = otherOuter.getInnerSynch() |
        v2 = otherOuter.getLockVar() and
        v1 = otherInner.getLockVar()
      )
    )
  )
}

/**
 * The method access `ma` to method `m` is qualified by an access to variable `vQual`
 * and has an access to variable `vArg` as the argument at index `i`.
 */
predicate qualifiedMethodCall(MethodCall ma, Method m, Variable vQual, int i, Variable vArg) {
  ma.getMethod() = m and
  ma.getQualifier().(VarAccess).getVariable() = vQual and
  ma.getArgument(i).(VarAccess).getVariable() = vArg
}

/**
 * Holds if the specified method accesses occur on different branches of the same conditional statement
 * inside an unsynchronized method.
 */
predicate inDifferentBranches(MethodCall ma1, MethodCall ma2) {
  exists(IfStmt cond |
    ma1.getEnclosingStmt() = cond.getThen().getAChild*() and
    ma2.getEnclosingStmt() = cond.getElse().getAChild*() and
    not cond.getEnclosingCallable().isSynchronized()
  )
}

/** The method access `ma` occurs in method `runnable`, which is an implementation of `Runnable.run()`. */
predicate inRunnable(MethodCall ma, Method runnable) {
  runnable.getName() = "run" and
  runnable.getDeclaringType().getAStrictAncestor().hasQualifiedName("java.lang", "Runnable") and
  ma.getEnclosingCallable() = runnable
}

/**
 * Holds if the specified method accesses occur in different `Runnable.run()` methods,
 * indicating that they may be invoked by different threads.
 */
predicate inDifferentRunnables(MethodCall ma1, MethodCall ma2) {
  exists(Method runnable1, Method runnable2 |
    inRunnable(ma1, runnable1) and
    inRunnable(ma2, runnable2) and
    runnable1 != runnable2
  )
}

/**
 * A synchronized method `outer` accessed at `outerAccess` makes a synchronized method access
 * in statement `inner` that is qualified by one of the parameters of `outer`, and there is
 * another access to `outer` that may cause locking to be performed in a different order.
 */
predicate badMethodCallLockOrder(MethodCall outerAccess, MethodCall innerAccess, MethodCall other) {
  exists(Synched outer, Synched inner |
    inner = innerAccess and
    inner = outer.getInnerSynch() and
    inner.getLockType() = outer.getLockType() and
    exists(Parameter p, int i | outer.(Method).getAParameter() = p and p.getPosition() = i |
      inner.(MethodCall).getQualifier().(VarAccess).getVariable() = p and
      exists(MethodCall ma1, MethodCall ma2, Variable v1, Variable v2 |
        qualifiedMethodCall(ma1, outer, v1, i, v2) and
        qualifiedMethodCall(ma2, outer, v2, i, v1) and
        v1 != v2 and
        (
          inDifferentBranches(ma1, ma2) or
          inDifferentRunnables(ma1, ma2)
        ) and
        ma1 = outerAccess and
        ma2 = other
      )
    )
  )
}

from Expr first, Expr second, Expr other
where
  badReentrantLockOrder(first, second, other) or
  badSynchronizedStmtLockOrder(first, second, other) or
  badMethodCallLockOrder(first, second, other)
select first,
  "Synchronization here and $@ may be performed in reverse order starting $@ and result in deadlock.",
  second, "here", other, "here"
