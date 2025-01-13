/**
 * Provides classes and predicates for detecting conflicting accesses in the sense of the Java Memory Model.
 */

import java
import Concurrency

/**
 * Holds if `t` is the type of a lock.
 * Currently a crude test of the type name.
 */
pragma[inline]
predicate isLockType(Type t) { t.getName().matches("%Lock%") }

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
    TVariableMonitor(Variable v) { isLockType(v.getType()) or locallySynchronizedOn(_, _, v) } or
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
    string toString() { result = "Monitor" }
  }

  /**
   * A variable used as a monitor.
   * The variable is either a lock or is used in a synchronized block.
   * E.g `synchronized (m) { ... }` or `m.lock();`
   */
  class VariableMonitor extends Monitor, TVariableMonitor {
    Variable v;

    VariableMonitor() { this = TVariableMonitor(v) }

    override Location getLocation() { result = v.getLocation() }

    override string toString() { result = "VariableMonitor(" + v.toString() + ")" }

    /** Gets the variable being used as a monitor. */
    Variable getVariable() { result = v }
  }

  /**
   * An instance reference used as a monitor.
   * Either via `synchronized (this) { ... }` or by marking a non-static method as `synchronized`.
   */
  class InstanceMonitor extends Monitor, TInstanceMonitor {
    RefType thisType;

    InstanceMonitor() { this = TInstanceMonitor(thisType) }

    override Location getLocation() { result = thisType.getLocation() }

    override string toString() { result = "InstanceMonitor(" + thisType.toString() + ")" }

    /** Gets the instance reference being used as a monitor. */
    RefType getThisType() { result = thisType }
  }

  /**
   * A class used as a monitor.
   * This is achieved by marking a static method as `synchronized`.
   */
  class ClassMonitor extends Monitor, TClassMonitor {
    RefType classType;

    ClassMonitor() { this = TClassMonitor(classType) }

    override Location getLocation() { result = classType.getLocation() }

    override string toString() { result = "ClassMonitor(" + classType.toString() + ")" }

    /** Gets the class being used as a monitor. */
    RefType getClassType() { result = classType }
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

  /** Holds if `localLock` refers to `lock`. */
  predicate represents(Field lock, Variable localLock) {
    isLockType(lock.getType()) and
    (
      localLock = lock
      or
      localLock.getInitializer() = lock.getAnAccess()
    )
  }

  /** Holds if `e` is synchronized on the `Lock` `lock` by a locking call. */
  predicate locallyLockedOn(Expr e, Field lock) {
    isLockType(lock.getType()) and
    exists(Variable localLock, MethodCall lockCall, MethodCall unlockCall |
      represents(lock, localLock) and
      lockCall.getQualifier() = localLock.getAnAccess() and
      lockCall.getMethod().getName() in ["lock", "lockInterruptibly", "tryLock"] and
      unlockCall.getQualifier() = localLock.getAnAccess() and
      unlockCall.getMethod().getName() = "unlock"
    |
      dominates(lockCall.getControlFlowNode(), unlockCall.getControlFlowNode()) and
      dominates(lockCall.getControlFlowNode(), e.getControlFlowNode()) and
      postDominates(unlockCall.getControlFlowNode(), e.getControlFlowNode())
    )
  }
}

/** Provides predicates, chiefly `isModifying`, to check if a given expression modifies a shared resource. */
module Modification {
  import semmle.code.java.dataflow.FlowSummary

  /** Holds if the field access `a` modifies a shared resource. */
  predicate isModifying(FieldAccess a) {
    a.isVarWrite()
    or
    exists(Call c | c.(MethodCall).getQualifier() = a | isModifyingCall(c))
    or
    exists(ArrayAccess aa, Assignment asa | aa.getArray() = a | asa.getDest() = aa)
  }

  /** Holds if the call `c` modifies a shared resource. */
  predicate isModifyingCall(Call c) {
    exists(SummarizedCallable sc, string output, string prefix | sc.getACall() = c |
      sc.propagatesFlow(_, output, _, _) and
      prefix = "Argument[this]" and
      output.prefix(prefix.length()) = prefix
    )
  }
}

/** Holds if the class is annotated as `@ThreadSafe`. */
Class annotatedAsThreadSafe() { result.getAnAnnotation().getType().getName() = "ThreadSafe" }

/** Holds if the type `t` is thread-safe. */
predicate isThreadSafeType(Type t) {
  t.getName().matches(["Atomic%", "Concurrent%"])
  or
  t.getName() in [
      "CopyOnWriteArraySet", "BlockingQueue", "ThreadLocal",
      // this is a method that returns a thread-safe version of the collection used as parameter
      "synchronizedMap", "Executor", "ExecutorService", "CopyOnWriteArrayList",
      "LinkedBlockingDeque", "LinkedBlockingQueue", "CompletableFuture"
    ]
  or
  t = annotatedAsThreadSafe()
}

/**
 * A field access that is exposed to potential data races.
 * We require the field to be in a class that is annotated as `@ThreadSafe`.
 */
class ExposedFieldAccess extends FieldAccess {
  ExposedFieldAccess() {
    this.getField() = annotatedAsThreadSafe().getAField() and
    not this.getField().isVolatile() and
    // field is not a lock
    not isLockType(this.getField().getType()) and
    // field is not thread-safe
    not isThreadSafeType(this.getField().getType()) and
    not isThreadSafeType(this.getField().getInitializer().getType()) and
    // access is not the initializer of the field
    not this.(VarWrite).getASource() = this.getField().getInitializer() and
    // access not in a constructor
    not this.getEnclosingCallable() = this.getField().getDeclaringType().getAConstructor() and
    // not a field on a local variable
    not this.getQualifier+().(VarAccess).getVariable() instanceof LocalVariableDecl and
    // not the variable mention in a synchronized statement
    not this = any(SynchronizedStmt sync).getExpr()
  }

  // LHS of assignments are excluded from the control flow graph,
  // so we use the control flow node for the assignment itself instead.
  override ControlFlowNode getControlFlowNode() {
    // this is the LHS of an assignment, use the control flow node for the assignment
    exists(Assignment asgn | asgn.getDest() = this | result = asgn.getControlFlowNode())
    or
    // this is not the LHS of an assignment, use the default control flow node
    not exists(Assignment asgn | asgn.getDest() = this) and
    result = super.getControlFlowNode()
  }
}

/** Holds if the location of `a` is strictly before the location of `b`. */
pragma[inline]
predicate orderedLocations(Location a, Location b) {
  a.getStartLine() < b.getStartLine()
  or
  a.getStartLine() = b.getStartLine() and
  a.getStartColumn() < b.getStartColumn()
}

/**
 * A class annotated as `@ThreadSafe`.
 * Provides predicates to check for concurrency issues.
 */
class ClassAnnotatedAsThreadSafe extends Class {
  ClassAnnotatedAsThreadSafe() { this = annotatedAsThreadSafe() }

  /** Holds if `a` and `b` are conflicting accesses to the same field and not monitored by the same monitor. */
  predicate unsynchronised(ExposedFieldAccess a, ExposedFieldAccess b) {
    this.conflicting(a, b) and
    this.publicAccess(_, a) and
    this.publicAccess(_, b) and
    not exists(Monitors::Monitor m |
      this.monitors(a, m) and
      this.monitors(b, m)
    )
  }

  /** Holds if `a` is the earliest write to its field that is unsynchronized with `b`. */
  predicate unsynchronised_normalized(ExposedFieldAccess a, ExposedFieldAccess b) {
    this.unsynchronised(a, b) and
    // Eliminate double reporting by making `a` the earliest write to this field
    // that is unsynchronized with `b`.
    not exists(ExposedFieldAccess earlier_a |
      earlier_a.getField() = a.getField() and
      orderedLocations(earlier_a.getLocation(), a.getLocation())
    |
      this.unsynchronised(earlier_a, b)
    )
  }

  /**
   * Holds if `a` and `b` are unsynchronized and both publicly accessible
   * as witnessed by `witness_a` and `witness_b`.
   */
  predicate witness(ExposedFieldAccess a, Expr witness_a, ExposedFieldAccess b, Expr witness_b) {
    this.unsynchronised_normalized(a, b) and
    this.publicAccess(witness_a, a) and
    this.publicAccess(witness_b, b) and
    // avoid double reporting
    not exists(Expr better_witness_a | this.publicAccess(better_witness_a, a) |
      orderedLocations(better_witness_a.getLocation(), witness_a.getLocation())
    ) and
    not exists(Expr better_witness_b | this.publicAccess(better_witness_b, b) |
      orderedLocations(better_witness_b.getLocation(), witness_b.getLocation())
    )
  }

  /**
   * Actions `a` and `b` are conflicting iff
   * they are field access operations on the same field and
   * at least one of them is a write.
   */
  predicate conflicting(ExposedFieldAccess a, ExposedFieldAccess b) {
    // We allow a = b, since they could be executed on different threads
    // We are looking for two operations:
    // - on the same non-volatile field
    a.getField() = b.getField() and
    // - on this class
    a.getField() = this.getAField() and
    // - where at least one is a write
    //   wlog we assume that is `a`
    //   We use a slightly more inclusive definition than simply `a.isVarWrite()`
    Modification::isModifying(a) and
    // Avoid reporting both `(a, b)` and `(b, a)` by choosing the tuple
    // where `a` appears before `b` in the source code.
    (
      (
        Modification::isModifying(b) and
        a != b
      )
      implies
      orderedLocations(a.getLocation(), b.getLocation())
    )
  }

  /** Holds if `a` can be reached by a path from a public method, and all such paths are monitored by `monitor`. */
  predicate monitors(ExposedFieldAccess a, Monitors::Monitor monitor) {
    forex(Method m | this.providesAccess(m, _, a) and m.isPublic() |
      this.monitorsVia(m, a, monitor)
    )
  }

  /** Holds if `a` can be reached by a path from a public method and `e` is the expression in that method that stsarts the path. */
  predicate publicAccess(Expr e, ExposedFieldAccess a) {
    exists(Method m | m.isPublic() | this.providesAccess(m, e, a))
  }

  /**
   * Holds if a call to method `m` can cause an access of `a` and `e` is the expression inside `m` that leads to that access.
   * `e` will either be `a` itself or a method call that leads to `a`.
   */
  predicate providesAccess(Method m, Expr e, ExposedFieldAccess a) {
    m = this.getAMethod() and
    (
      a.getEnclosingCallable() = m and
      e = a
      or
      exists(MethodCall c | c.getEnclosingCallable() = m |
        this.providesAccess(c.getCallee(), _, a) and
        e = c
      )
    )
  }

  /** Holds if all paths from `m` to `a` are monitored by `monitor`. */
  predicate monitorsVia(Method m, ExposedFieldAccess a, Monitors::Monitor monitor) {
    m = this.getAMethod() and
    this.providesAccess(m, _, a) and
    (a.getEnclosingCallable() = m implies Monitors::locallyMonitors(a, monitor)) and
    forall(MethodCall c |
      c.getEnclosingCallable() = m and
      this.providesAccess(c.getCallee(), _, a)
    |
      Monitors::locallyMonitors(c, monitor)
      or
      this.monitorsVia(c.getCallee(), a, monitor)
    )
  }
}
