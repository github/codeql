/**
 * @name Incorrect lazy initialization of a static field
 * @description Initializing a static field without synchronization can be problematic
 *              in a multi-threaded context.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/lazy-initialization
 * @tags reliability
 *       correctness
 *       concurrency
 *       external/cwe/cwe-543
 *       external/cwe/cwe-609
 */

import java

/** A comparison (using `==`) with `null`. */
class NullEQExpr extends ValueOrReferenceEqualsExpr {
  NullEQExpr() { exists(NullLiteral l | l.getParent() = this) }
}

/** An assignment to a static field. */
class StaticFieldInit extends AssignExpr {
  StaticFieldInit() { exists(Field f | f.isStatic() | f.getAnAccess() = this.getDest()) }

  Field getField() { result.getAnAccess() = this.getDest() }

  IfStmt getAnEnclosingNullCheck() {
    result.getThen().getAChild*() = this.getEnclosingStmt() and
    result.getCondition().(NullEQExpr).getAChildExpr() = this.getField().getAnAccess()
  }

  IfStmt getNearestNullCheck() {
    result = this.getAnEnclosingNullCheck() and
    not result.getAChild+() = this.getAnEnclosingNullCheck()
  }
}

/** A field that is a candidate for a "lock object". */
class LockObjectField extends Field {
  LockObjectField() {
    this.isStatic() and
    forex(Callable init | init = this.getAnAssignedValue().getEnclosingCallable() |
      init instanceof StaticInitializer
    )
  }
}

/** A synchronized statement on a class literal. */
class ValidSynchStmt extends Stmt {
  ValidSynchStmt() {
    // It's OK to lock the enclosing class.
    this.(SynchronizedStmt).getExpr().(TypeLiteral).getReferencedType() =
      this.getEnclosingCallable().getDeclaringType()
    or
    // It's OK to lock on a "lock object field".
    this.(SynchronizedStmt).getExpr().(FieldRead).getField() instanceof LockObjectField
    or
    // Locking via `ReentrantLock` lock object instead of synchronized statement.
    exists(TryStmt try, LockObjectField lockField |
      this = try.getBlock() and
      lockField.getType().(RefType).hasQualifiedName("java.util.concurrent.locks", "ReentrantLock") and
      exists(MethodCall lockAction |
        lockAction.getQualifier() = lockField.getAnAccess() and
        lockAction.getMethod().getName() = "lock" and
        dominates(lockAction.getControlFlowNode(), this.getControlFlowNode())
      ) and
      exists(MethodCall unlockAction |
        unlockAction.getQualifier() = lockField.getAnAccess() and
        unlockAction.getMethod().getName() = "unlock" and
        postDominates(unlockAction.getControlFlowNode(), this.getControlFlowNode())
      )
    )
  }
}

/** A static method. */
class StaticMethod extends Method {
  StaticMethod() { this.isStatic() }

  predicate bodyIsSynchronized() {
    this.isSynchronized() or
    this.getBody().getAChild() instanceof ValidSynchStmt
  }
}

from StaticMethod method, IfStmt i, StaticFieldInit init, string message
where
  i = init.getNearestNullCheck() and
  method = i.getEnclosingCallable() and
  not method.bodyIsSynchronized() and
  not method instanceof StaticInitializer and
  // There must be an unsynchronized read.
  exists(IfStmt unsyncNullCheck | unsyncNullCheck = init.getAnEnclosingNullCheck() |
    not unsyncNullCheck.getEnclosingStmt+() instanceof ValidSynchStmt
  ) and
  if i.getEnclosingStmt+() instanceof ValidSynchStmt
  then (
    not init.getField().isVolatile() and
    message = "The field must be volatile."
  ) else (
    if i.getEnclosingStmt+() instanceof SynchronizedStmt
    then message = "Bad synchronization."
    else message = "Missing synchronization."
  )
select init, "Incorrect lazy initialization of static field $@: " + message, init.getField() as f,
  f.getName()
