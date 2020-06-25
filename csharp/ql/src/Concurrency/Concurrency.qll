/** Classes for concurrency queries. */

import csharp

private class WaitCall extends MethodCall {
  WaitCall() {
    getTarget().hasName("Wait") and
    getTarget().getDeclaringType().hasQualifiedName("System.Threading.Monitor")
  }

  Expr getExpr() { result = getArgument(0) }
}

/** An expression statement containing a `Wait` call. */
class WaitStmt extends ExprStmt {
  WaitStmt() { getExpr() instanceof WaitCall }

  /** Gets the expression that this wait call is waiting on. */
  Expr getLock() { result = getExpr().(WaitCall).getExpr() }

  /** Gets the variable that this wait call is waiting on, if any. */
  Variable getWaitVariable() { result.getAnAccess() = getLock() }

  /** Holds if this wait call waits on `this`. */
  predicate isWaitThis() { getLock() instanceof ThisAccess }

  /** Gets the type that this wait call waits on, if any. */
  Type getWaitTypeObject() { result = getLock().(TypeofExpr).getTypeAccess().getTarget() }
}

private class SynchronizedMethodAttribute extends Attribute {
  SynchronizedMethodAttribute() {
    getType().hasQualifiedName("System.Runtime.CompilerServices.MethodImplAttribute") and
    exists(MemberConstantAccess a, MemberConstant mc |
      a = getArgument(0) and
      a.getTarget() = mc and
      mc.hasName("Synchronized") and
      mc.getDeclaringType().hasQualifiedName("System.Runtime.CompilerServices.MethodImplOptions")
    )
  }
}

/** A method with attribute `[MethodImpl(MethodImplOptions.Synchronized)]`. */
private class SynchronizedMethod extends Method {
  SynchronizedMethod() { getAnAttribute() instanceof SynchronizedMethodAttribute }

  /** Holds if this method locks `this`. */
  predicate isLockThis() { not isStatic() }

  /** Gets the type that is locked by this method, if any. */
  Type getLockTypeObject() { isStatic() and result = getDeclaringType() }
}

/** A block that is locked by a `lock` statement. */
abstract class LockedBlock extends BlockStmt {
  /** Holds if the `lock` statement locks `this`. */
  abstract predicate isLockThis();

  /** Gets the lock variable of the `lock` statement, if any. */
  abstract Variable getLockVariable();

  /** Gets the locked type of the `lock` statement, if any. */
  abstract Type getLockTypeObject();

  /** Gets a statement in the scope of this locked block. */
  Stmt getALockedStmt() {
    // Do this instead of getParent+, because we don't want to escape
    // delegates and lambdas
    result.getParent() = this
    or
    exists(Stmt mid | mid = getALockedStmt() and result.getParent() = mid)
  }
}

private class LockStmtBlock extends LockedBlock {
  LockStmtBlock() { exists(LockStmt s | this = s.getBlock()) }

  override predicate isLockThis() { exists(LockStmt s | this = s.getBlock() and s.isLockThis()) }

  override Variable getLockVariable() {
    exists(LockStmt s | this = s.getBlock() and result = s.getLockVariable())
  }

  override Type getLockTypeObject() {
    exists(LockStmt s | this = s.getBlock() and result = s.getLockTypeObject())
  }
}

/** A call that may take a lock using one of the standard library methods. */
class LockingCall extends MethodCall {
  LockingCall() {
    this.getTarget() =
      any(Method m |
        m.getDeclaringType().hasQualifiedName("System.Threading", "Monitor") and
        m.getName().matches("%Enter%")
      ) or
    this.getTarget().hasName("EnterReadLock") or
    this.getTarget().hasName("EnterWriteLock")
  }
}

private class SynchronizedMethodBlock extends LockedBlock {
  SynchronizedMethodBlock() { exists(SynchronizedMethod m | this = m.getStatementBody()) }

  override predicate isLockThis() {
    exists(SynchronizedMethod m | this = m.getStatementBody() and m.isLockThis())
  }

  override Variable getLockVariable() { none() }

  override Type getLockTypeObject() {
    exists(SynchronizedMethod m | this = m.getStatementBody() and result = m.getLockTypeObject())
  }
}
