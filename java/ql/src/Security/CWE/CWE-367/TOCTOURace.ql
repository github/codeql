/**
 * @name Time-of-check time-of-use race condition
 * @description Using a resource after an unsynchronized state check can lead to a race condition,
 *              if the state may be changed between the check and use.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.7
 * @precision medium
 * @id java/toctou-race-condition
 * @tags security
 *       external/cwe/cwe-367
 */

import java
import semmle.code.java.Concurrency
import semmle.code.java.controlflow.Guards

/**
 * Holds if `e1` and `e2` appear within a `synchronized` block on `monitor`.
 */
predicate commonSynchronization(Expr e1, Expr e2, Variable monitor) {
  exists(SynchronizedStmt s |
    locallySynchronizedOn(e1, s, monitor) and
    locallySynchronizedOn(e2, s, monitor)
  )
}

/**
 * Holds if `m` is a call to a synchronized method on `receiver`.
 */
predicate synchCallOn(MethodCall m, Variable receiver) {
  m.getCallee() instanceof SynchronizedCallable and
  m.getQualifier() = receiver.getAnAccess()
}

/**
 * A callable that might be used concurrently. This is a heuristic to avoid flagging
 * non-concurrent usage of classes that try to be concurrency-safe (e.g. a lot of the Java
 * collections).
 */
class PossiblyConcurrentCallable extends Callable {
  PossiblyConcurrentCallable() {
    this instanceof SynchronizedCallable
    or
    exists(SynchronizedStmt s | s.getEnclosingCallable() = this)
    or
    exists(FieldAccess f | f.getVariable().isVolatile() | f.getEnclosingCallable() = this)
    or
    exists(VarAccess v |
      v.getVariable().getType().(RefType).hasQualifiedName("java.lang", "ThreadLocal")
    |
      v.getEnclosingCallable() = this
    )
  }
}

/**
 * Holds if all accesses to `v` (outside of initializers) are locked in the same way.
 */
predicate alwaysLocked(Field f) {
  exists(Variable lock |
    forex(VarAccess access |
      access = f.getAnAccess() and not access.getEnclosingCallable() instanceof InitializerMethod
    |
      locallySynchronizedOn(access, _, lock)
    )
  )
  or
  exists(RefType thisType |
    forex(VarAccess access |
      access = f.getAnAccess() and not access.getEnclosingCallable() instanceof InitializerMethod
    |
      locallySynchronizedOnThis(access, thisType)
    )
  )
  or
  exists(RefType classType |
    forex(VarAccess access |
      access = f.getAnAccess() and not access.getEnclosingCallable() instanceof InitializerMethod
    |
      locallySynchronizedOnClass(access, classType)
    )
  )
}

/**
 * Holds if the value of `v` probably never escapes the local scope.
 */
predicate probablyNeverEscapes(LocalVariableDecl v) {
  // Not passed into another function.
  not exists(Call c | c.getAnArgument() = v.getAnAccess()) and
  // Not assigned directly to another variable.
  not exists(Assignment a | a.getSource() = v.getAnAccess()) and
  // Not returned.
  not exists(ReturnStmt r | r.getResult() = v.getAnAccess()) and
  // All assignments are to new instances of a class.
  forex(Expr e | e = v.getAnAssignedValue() | e instanceof ClassInstanceExpr)
}

// Loop conditions tend to be uninteresting, so are not included.
from IfStmt check, MethodCall call1, MethodCall call2, Variable r
where
  check.getCondition().getAChildExpr*() = call1 and
  // This can happen if there are loops, etc.
  not call1 = call2 and
  // The use is controlled by one of the branches of the condition, i.e. whether it
  // is reached actually depends on that condition.
  call1.getBasicBlock().(ConditionBlock).controls(call2.getBasicBlock(), _) and
  // Two calls to synchronized methods on the same variable.
  synchCallOn(call1, r) and
  synchCallOn(call2, r) and
  // Not jointly synchronized on that variable.
  // (If the caller synchronizes on `r` then it takes the same monitor as the `synchronized` callees do.)
  not commonSynchronization(call1, call2, r) and
  // Only include cases that look like they may be intended for concurrent usage.
  check.getEnclosingCallable() instanceof PossiblyConcurrentCallable and
  // Ignore fields that look like they're consistently guarded with some other lock.
  not alwaysLocked(r) and
  // Ignore local variables whose value probably never escapes, as they can't be accessed concurrently.
  not probablyNeverEscapes(r) and
  // The synchronized methods on `Throwable` are not interesting.
  not call1.getCallee().getDeclaringType() instanceof TypeThrowable
select call2, "This uses the state of $@ which $@. But these are not jointly synchronized.", r,
  r.getName(), call1, "is checked at a previous call"
