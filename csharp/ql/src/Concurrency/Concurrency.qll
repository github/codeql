// Various utilities for writing concurrency queries.
import csharp

class WaitCall extends MethodCall {
  WaitCall() {
    getTarget().hasName("Wait") and
    getTarget().getDeclaringType().hasQualifiedName("System.Threading.Monitor")
  }

  Expr getExpr() { result = getArgument(0) }
}

class WaitStmt extends ExprStmt {
  WaitStmt() { getExpr() instanceof WaitCall }

  Expr getLock() { result = getExpr().(WaitCall).getExpr() }

  // If we are waiting on a variable
  Variable getWaitVariable() { result.getAnAccess() = getLock() }

  // If we are waiting on 'this'
  predicate isWaitThis() { getLock() instanceof ThisAccess }

  // If we are waiting on a typeof()
  Type getWaitTypeObject() { result = getLock().(TypeofExpr).getTypeAccess().getTarget() }
}

class SynchronizedMethodAttribute extends Attribute {
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

// A method with attribute [MethodImpl(MethodImplOptions.Synchronized)]
class SynchronizedMethod extends Method {
  SynchronizedMethod() { getAnAttribute() instanceof SynchronizedMethodAttribute }

  predicate isLockThis() { not isStatic() }

  Type getLockTypeObject() { isStatic() and result = getDeclaringType() }
}

abstract class LockedBlock extends BlockStmt {
  abstract predicate isLockThis();

  abstract Variable getLockVariable();

  abstract Type getLockTypeObject();

  Stmt getALockedStmt() {
    // Do this instead of getParent+, because we don't want to escape
    // delegates and lambdas
    result.getParent() = this
    or
    exists(Stmt mid | mid = getALockedStmt() and result.getParent() = mid)
  }
}

class LockStmtBlock extends LockedBlock {
  LockStmtBlock() { exists(LockStmt s | this = s.getBlock()) }

  override predicate isLockThis() { exists(LockStmt s | this = s.getBlock() and s.isLockThis()) }

  override Variable getLockVariable() {
    exists(LockStmt s | this = s.getBlock() and result = s.getLockVariable())
  }

  override Type getLockTypeObject() {
    exists(LockStmt s | this = s.getBlock() and result = s.getLockTypeObject())
  }
}

/**
 * A call which may take a lock using one of the standard library classes.
 */
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

class SynchronizedMethodBlock extends LockedBlock {
  SynchronizedMethodBlock() { exists(SynchronizedMethod m | this = m.getStatementBody()) }

  override predicate isLockThis() {
    exists(SynchronizedMethod m | this = m.getStatementBody() and m.isLockThis())
  }

  override Variable getLockVariable() { none() }

  override Type getLockTypeObject() {
    exists(SynchronizedMethod m | this = m.getStatementBody() and result = m.getLockTypeObject())
  }
}
