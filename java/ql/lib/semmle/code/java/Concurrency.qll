overlay[local?]
module;

import java
import semmle.code.java.frameworks.Mockito

/**
 * A Java type representing a lock.
 * We identify a lock type as one that has both `lock` and `unlock` methods.
 */
class LockType extends RefType {
  LockType() {
    this.getAMethod().hasName("lock") and
    this.getAMethod().hasName("unlock")
  }

  /** Gets a method that is locking this lock type. */
  private Method getLockMethod() {
    result.getDeclaringType() = this and
    result.hasName(["lock", "lockInterruptibly", "tryLock"])
  }

  /** Gets a method that is unlocking this lock type. */
  private Method getUnlockMethod() {
    result.getDeclaringType() = this and
    result.hasName("unlock")
  }

  /** Gets an `isHeldByCurrentThread` method of this lock type. */
  private Method getIsHeldByCurrentThreadMethod() {
    result.getDeclaringType() = this and
    result.hasName("isHeldByCurrentThread")
  }

  /** Gets a call to a method that is locking this lock type. */
  MethodCall getLockAccess() {
    result.getMethod() = this.getLockMethod() and
    // Not part of a Mockito verification call
    not result instanceof MockitoVerifiedMethodCall
  }

  /** Gets a call to a method that is unlocking this lock type. */
  MethodCall getUnlockAccess() {
    result.getMethod() = this.getUnlockMethod() and
    // Not part of a Mockito verification call
    not result instanceof MockitoVerifiedMethodCall
  }

  /** Gets a call to a method that checks if the lock is held by the current thread. */
  MethodCall getIsHeldByCurrentThreadAccess() {
    result.getMethod() = this.getIsHeldByCurrentThreadMethod() and
    // Not part of a Mockito verification call
    not result instanceof MockitoVerifiedMethodCall
  }
}

/**
 * Holds if `e` is synchronized by a local synchronized statement `sync` on the variable `v`.
 */
predicate locallySynchronizedOn(Expr e, SynchronizedStmt sync, Variable v) {
  e.getEnclosingStmt().getEnclosingStmt+() = sync and
  sync.getExpr().(VarAccess).getVariable() = v
}

/**
 * Holds if `e` is synchronized by a local synchronized statement on a `this` of type `thisType`, or by a synchronized
 * modifier on the enclosing (non-static) method.
 */
predicate locallySynchronizedOnThis(Expr e, RefType thisType) {
  exists(SynchronizedStmt sync | e.getEnclosingStmt().getEnclosingStmt+() = sync |
    sync.getExpr().(ThisAccess).getType().(RefType).getSourceDeclaration() = thisType
  )
  or
  exists(SynchronizedCallable c | c = e.getEnclosingCallable() |
    not c.isStatic() and thisType = c.getDeclaringType()
  )
}

/**
 * Holds if `e` is synchronized by a `synchronized` modifier on the enclosing (static) method
 * declared in the type `classType`.
 */
predicate locallySynchronizedOnClass(Expr e, RefType classType) {
  exists(SynchronizedCallable c | c = e.getEnclosingCallable() |
    c.isStatic() and classType = c.getDeclaringType()
  )
}

/**
 * A callable that is synchronized on its enclosing instance, either by a `synchronized` modifier, or
 * by having a body which is precisely `synchronized(this) { ... }`.
 */
class SynchronizedCallable extends Callable {
  SynchronizedCallable() {
    this.isSynchronized()
    or
    // The body is just `synchronized(this) { ... }`.
    exists(SynchronizedStmt s | this.getBody().(SingletonBlock).getStmt() = s |
      s.getExpr().(ThisAccess).getType() = this.getDeclaringType()
    )
  }
}

/**
 * This module provides predicates, chiefly `locallyMonitors`, to check if a given expression is synchronized on a specific monitor.
 */
module Monitors {
  /**
   * A monitor is any object that is used to synchronize access to a shared resource.
   * This includes locks as well as variables used in synchronized blocks (including `this`).
   */
  newtype TMonitor =
    /** Either a lock or a variable used in a synchronized block. */
    TVariableMonitor(Variable v) {
      v.getType() instanceof LockType or locallySynchronizedOn(_, _, v)
    } or
    /** An instance reference used as a monitor. */
    TInstanceMonitor(RefType thisType) { locallySynchronizedOnThis(_, thisType) } or
    /** A class used as a monitor. */
    TClassMonitor(RefType classType) { locallySynchronizedOnClass(_, classType) }

  /**
   * A monitor is any object that is used to synchronize access to a shared resource.
   * This includes locks as well as variables used in synchronized blocks (including `this`).
   */
  class Monitor extends TMonitor {
    /** Gets the location of this monitor. */
    abstract Location getLocation();

    /** Gets a textual representation of this element. */
    abstract string toString();
  }

  /**
   * A variable used as a monitor.
   * The variable is either a lock or is used in a synchronized block.
   * E.g `synchronized (m) { ... }` or `m.lock();`
   */
  class VariableMonitor extends Monitor, TVariableMonitor {
    override Location getLocation() { result = this.getVariable().getLocation() }

    override string toString() { result = "VariableMonitor(" + this.getVariable().toString() + ")" }

    /** Gets the variable being used as a monitor. */
    Variable getVariable() { this = TVariableMonitor(result) }
  }

  /**
   * An instance reference used as a monitor.
   * Either via `synchronized (this) { ... }` or by marking a non-static method as `synchronized`.
   */
  class InstanceMonitor extends Monitor, TInstanceMonitor {
    override Location getLocation() { result = this.getThisType().getLocation() }

    override string toString() { result = "InstanceMonitor(" + this.getThisType().toString() + ")" }

    /** Gets the instance reference being used as a monitor. */
    RefType getThisType() { this = TInstanceMonitor(result) }
  }

  /**
   * A class used as a monitor.
   * This is achieved by marking a static method as `synchronized`.
   */
  class ClassMonitor extends Monitor, TClassMonitor {
    override Location getLocation() { result = this.getClassType().getLocation() }

    override string toString() { result = "ClassMonitor(" + this.getClassType().toString() + ")" }

    /** Gets the class being used as a monitor. */
    RefType getClassType() { this = TClassMonitor(result) }
  }

  /** Holds if the expression `e` is synchronized on the monitor `m`. */
  predicate locallyMonitors(Expr e, Monitor m) {
    exists(Variable v | v = m.(VariableMonitor).getVariable() |
      locallyLockedOn(e, v)
      or
      locallySynchronizedOn(e, _, v)
    )
    or
    locallySynchronizedOnThis(e, m.(InstanceMonitor).getThisType())
    or
    locallySynchronizedOnClass(e, m.(ClassMonitor).getClassType())
  }

  /** Gets the control flow node that must dominate `e` when `e` is synchronized on a lock. */
  ControlFlowNode getNodeToBeDominated(Expr e) {
    // If `e` is the LHS of an assignment, use the control flow node for the assignment
    exists(Assignment asgn | asgn.getDest() = e | result = asgn.getControlFlowNode())
    or
    // if `e` is not the LHS of an assignment, use the default control flow node
    not exists(Assignment asgn | asgn.getDest() = e) and
    result = e.getControlFlowNode()
  }

  /** A field storing a lock. */
  class LockField extends Field {
    LockField() { this.getType() instanceof LockType }

    /** Gets a call to a method locking the lock stored in this field. */
    MethodCall getLockCall() {
      result.getQualifier() = this.getRepresentative().getAnAccess() and
      result = this.getType().(LockType).getLockAccess()
    }

    /** Gets a call to a method unlocking the lock stored in this field. */
    MethodCall getUnlockCall() {
      result.getQualifier() = this.getRepresentative().getAnAccess() and
      result = this.getType().(LockType).getUnlockAccess()
    }

    /**
     * Gets a variable representing this field.
     * It can be the field itself or a local variable initialized to the field.
     */
    private Variable getRepresentative() {
      result = this
      or
      result.getInitializer() = this.getAnAccess()
    }
  }

  /** Holds if `e` is synchronized on the `Lock` `lock` by a locking call. */
  predicate locallyLockedOn(Expr e, LockField lock) {
    exists(MethodCall lockCall, MethodCall unlockCall |
      lockCall = lock.getLockCall() and
      unlockCall = lock.getUnlockCall()
    |
      dominates(lockCall.getControlFlowNode(), unlockCall.getControlFlowNode()) and
      dominates(lockCall.getControlFlowNode(), getNodeToBeDominated(e)) and
      postDominates(unlockCall.getControlFlowNode(), getNodeToBeDominated(e))
    )
  }
}
