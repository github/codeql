/**
 * Provides classes and predicates for detecting conflicting accesses in the sense of the Java Memory Model.
 */
overlay[local?]
module;

import java
import Concurrency

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
    exists(SummarizedCallable sc, string output | sc.getACall() = c |
      sc.propagatesFlow(_, output, _, _) and
      output.matches("Argument[this]%")
    )
  }
}

/** Holds if the type `t` is thread-safe. */
predicate isThreadSafeType(Type t) {
  t.(RefType).getSourceDeclaration().getName().matches(["Atomic%", "Concurrent%"])
  or
  t.(RefType).getSourceDeclaration().getName() = "ThreadLocal"
  or
  // Anything in `java.util.concurrent` is thread safe.
  // See https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/package-summary.html#MemoryVisibility
  t.(RefType).getPackage().getName() = "java.util.concurrent"
  or
  t instanceof ClassAnnotatedAsThreadSafe
}

/** Holds if the expression `e` is a thread-safe initializer. */
private predicate isThreadSafeInitializer(Expr e) {
  exists(string name |
    e.(Call).getCallee().getSourceDeclaration().hasQualifiedName("java.util", "Collections", name)
  |
    name.matches("synchronized%")
  )
}

/**
 * A field that is exposed to potential data races.
 * We require the field to be in a class that is annotated as `@ThreadSafe`.
 */
class ExposedField extends Field {
  ExposedField() {
    this.getDeclaringType() instanceof ClassAnnotatedAsThreadSafe and
    not this.isVolatile() and
    // field is not a lock
    not this.getType() instanceof LockType and
    // field is not thread-safe
    not isThreadSafeType(this.getType()) and
    not isThreadSafeType(this.getInitializer().getType()) and
    // the initializer guarantees thread safety
    not isThreadSafeInitializer(this.getInitializer())
  }
}

/**
 * A field access that is exposed to potential data races.
 * We require the field to be in a class that is annotated as `@ThreadSafe`.
 */
class ExposedFieldAccess extends FieldAccess {
  ExposedFieldAccess() {
    // access is to an exposed field
    this.getField() instanceof ExposedField and
    // access is not the initializer of the field
    not this.(VarWrite).getASource() = this.getField().getInitializer() and
    // access not in a constructor
    not this.getEnclosingCallable() = this.getField().getDeclaringType().getAConstructor() and
    // not a field on a local variable
    not this.getQualifier+().(VarAccess).getVariable() instanceof LocalVariableDecl and
    // not the variable mentioned in a synchronized statement
    not this = any(SynchronizedStmt sync).getExpr()
  }
}

/**
 * A class annotated as `@ThreadSafe`.
 * Provides predicates to check for concurrency issues.
 */
class ClassAnnotatedAsThreadSafe extends Class {
  ClassAnnotatedAsThreadSafe() { this.getAnAnnotation().getType().getName() = "ThreadSafe" }

  // We wish to find conflicting accesses that are reachable from public methods
  // and to know which monitors protect them.
  //
  // It is very easy and natural to write a predicate for conflicting accesses,
  // but that would be binary, and hence not suited for reachability analysis.
  //
  // It is also easy to state that all accesses to a field are protected by a single monitor,
  // but that would require a forall, which is not suited for recursion.
  // (The recursion occurs for example as you traverse the access path and keep requiring that all tails are protected.)
  //
  // We therefore use a dual solution:
  // - We write a unary recursive predicate for accesses that are not protected by any monitor.
  //   Any such write access, reachable from a public method, is conflicting with itself.
  //   And any such read will be conflicting with any publicly reachable write access (locked or not).
  //
  // - We project the above predicate down to fields, so we can find fields with unprotected accesses.
  // - From this we can derive a unary recursive predicate for fields whose accesses are protected by exactly one monitor.
  //   The predicate tracks the monitor.
  //   If such a field has two accesses protected by different monitors, we have a concurrency issue.
  //   This can be determined by simple counting at the end of the recursion.
  //   Technically, we only have a concurrency issue if there is a write access,
  //   but if you are locking your reads with different locks, you likely made a typo.
  //
  // - From the above, we can derive a unary recursive predicate for fields whose accesses are protected by at least one monitor.
  //   This predicate tracks all the monitors that protect accesses to the field.
  //   This is combined with a predicate that checks if any access escapes a given monitor.
  //   If all the monitors that protect accesses to a field are escaped by at least one access,
  //   we have a concurrency issue.
  //   This can be determined by a single forall at the end of the recursion.
  //
  // With this formulation we avoid binary predicates and foralls in recursion.
  //
  // Cases where a field access is not protected by any monitor
  /**
   * Holds if the field access `a` to the field `f` is not protected by any monitor, and it can be reached via the expression `e` in the method `m`.
   * We maintain the invariant that `m = e.getEnclosingCallable()`.
   */
  private predicate unlockedAccess(
    ExposedField f, Expr e, Method m, ExposedFieldAccess a, boolean write
  ) {
    m.getDeclaringType() = this and
    (
      // base case
      f.getDeclaringType() = this and
      m = e.getEnclosingCallable() and
      a.getField() = f and
      a = e and
      (if Modification::isModifying(a) then write = true else write = false)
      or
      // recursive case
      exists(MethodCall c, Expr e0, Method m0 | this.unlockedAccess(f, e0, m0, a, write) |
        m = c.getEnclosingCallable() and
        not m0.isPublic() and
        c.getCallee().getSourceDeclaration() = m0 and
        c = e and
        not Monitors::locallyMonitors(e0, _)
      )
    )
  }

  /** Holds if the class has an unlocked access to the field `f` via the expression `e` in the method `m`. */
  private predicate hasUnlockedAccess(ExposedField f, Expr e, Method m, boolean write) {
    this.unlockedAccess(f, e, m, _, write)
  }

  /** Holds if the field access `a` to the field `f` is not protected by any monitor, and it can be reached via the expression `e` in the public method `m`. */
  predicate unlockedPublicAccess(
    ExposedField f, Expr e, Method m, ExposedFieldAccess a, boolean write
  ) {
    this.unlockedAccess(f, e, m, a, write) and
    m.isPublic() and
    not Monitors::locallyMonitors(e, _)
  }

  /** Holds if the class has an unlocked access to the field `f` via the expression `e` in the public method `m`. */
  private predicate hasUnlockedPublicAccess(ExposedField f, Expr e, Method m, boolean write) {
    this.unlockedPublicAccess(f, e, m, _, write)
  }

  // Cases where all accesses to a field are protected by exactly one monitor
  //
  /**
   * Holds if the class has an access, locked by exactly one monitor, to the field `f` via the expression `e` in the method `m`.
   */
  private predicate hasOnelockedAccess(
    ExposedField f, Expr e, Method m, boolean write, Monitors::Monitor monitor
  ) {
    //base
    this.hasUnlockedAccess(f, e, m, write) and
    Monitors::locallyMonitors(e, monitor)
    or
    // recursive case
    exists(MethodCall c, Method m0 | this.hasOnelockedAccess(f, _, m0, write, monitor) |
      m = c.getEnclosingCallable() and
      not m0.isPublic() and
      c.getCallee().getSourceDeclaration() = m0 and
      c = e and
      // consider allowing idempotent monitors
      not Monitors::locallyMonitors(e, _) and
      m.getDeclaringType() = this
    )
  }

  /** Holds if the class has an access, locked by exactly one monitor, to the field `f` via the expression `e` in the public method `m`. */
  private predicate hasOnelockedPublicAccess(
    ExposedField f, Expr e, Method m, boolean write, Monitors::Monitor monitor
  ) {
    this.hasOnelockedAccess(f, e, m, write, monitor) and
    m.isPublic() and
    not this.hasUnlockedPublicAccess(f, e, m, write)
  }

  /** Holds if the field `f` has more than one access, all locked by a single monitor, but different monitors are used. */
  predicate singleMonitorMismatch(ExposedField f) {
    2 <= strictcount(Monitors::Monitor monitor | this.hasOnelockedPublicAccess(f, _, _, _, monitor))
  }

  // Cases where all accesses to a field are protected by at least one monitor
  //
  /** Holds if the class has an access, locked by at least one monitor, to the field `f` via the expression `e` in the method `m`. */
  private predicate hasOnepluslockedAccess(
    ExposedField f, Expr e, Method m, boolean write, Monitors::Monitor monitor
  ) {
    //base
    this.hasOnelockedAccess(f, e, m, write, monitor) and
    not this.singleMonitorMismatch(f) and
    not this.hasUnlockedPublicAccess(f, _, _, _)
    or
    // recursive case
    exists(MethodCall c, Method m0, Monitors::Monitor monitor0 |
      this.hasOnepluslockedAccess(f, _, m0, write, monitor0) and
      m = c.getEnclosingCallable() and
      not m0.isPublic() and
      c.getCallee().getSourceDeclaration() = m0 and
      c = e and
      m.getDeclaringType() = this
    |
      monitor = monitor0
      or
      Monitors::locallyMonitors(e, monitor)
    )
  }

  /** Holds if the class has a write access to the field `f` that can be reached via a public method. */
  predicate hasPublicWriteAccess(ExposedField f) {
    this.hasUnlockedPublicAccess(f, _, _, true)
    or
    this.hasOnelockedPublicAccess(f, _, _, true, _)
    or
    exists(Method m | m.getDeclaringType() = this and m.isPublic() |
      this.hasOnepluslockedAccess(f, _, m, true, _)
    )
  }

  /** Holds if the class has an access, not protected by the monitor `m`, to the field `f` via the expression `e` in the method `m`. */
  private predicate escapesMonitor(
    ExposedField f, Expr e, Method m, boolean write, Monitors::Monitor monitor
  ) {
    //base
    this.hasOnepluslockedAccess(f, _, _, _, monitor) and
    this.hasUnlockedAccess(f, e, m, write) and
    not Monitors::locallyMonitors(e, monitor)
    or
    // recursive case
    exists(MethodCall c, Method m0 | this.escapesMonitor(f, _, m0, write, monitor) |
      m = c.getEnclosingCallable() and
      not m0.isPublic() and
      c.getCallee().getSourceDeclaration() = m0 and
      c = e and
      not Monitors::locallyMonitors(e, monitor) and
      m.getDeclaringType() = this
    )
  }

  /** Holds if the class has an access, not protected by the monitor `m`, to the field `f` via the expression `e` in the public method `m`. */
  private predicate escapesMonitorPublic(
    ExposedField f, Expr e, Method m, boolean write, Monitors::Monitor monitor
  ) {
    this.escapesMonitor(f, e, m, write, monitor) and
    m.isPublic()
  }

  /** Holds if no monitor protects all accesses to the field `f`. */
  predicate notFullyMonitored(ExposedField f) {
    forex(Monitors::Monitor monitor | this.hasOnepluslockedAccess(f, _, _, _, monitor) |
      this.escapesMonitorPublic(f, _, _, _, monitor)
    )
  }
}
