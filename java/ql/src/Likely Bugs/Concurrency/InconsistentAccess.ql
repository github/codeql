/**
 * @name Inconsistent synchronization for field
 * @description If a field is mostly accessed in a synchronized context, but occasionally accessed
 *              in a non-synchronized way, the non-synchronized accesses may lead to race
 *              conditions.
 * @kind problem
 * @problem.severity error
 * @precision low
 * @id java/inconsistent-field-synchronization
 * @tags reliability
 *       correctness
 *       concurrency
 *       language-features
 *       external/cwe/cwe-662
 *       statistical
 *       non-attributable
 */

import java

predicate withinInitializer(Expr e) {
  e.getEnclosingCallable().hasName("<clinit>") or
  e.getEnclosingCallable() instanceof Constructor
}

predicate locallySynchronized(MethodCall ma) {
  ma.getEnclosingStmt().getEnclosingStmt+() instanceof SynchronizedStmt
}

predicate hasUnsynchronizedCall(Method m) {
  m.isPublic() and not m.isSynchronized()
  or
  exists(MethodCall ma, Method caller | ma.getMethod() = m and caller = ma.getEnclosingCallable() |
    hasUnsynchronizedCall(caller) and
    not caller.isSynchronized() and
    not locallySynchronized(ma)
  )
}

predicate withinLocalSynchronization(Expr e) {
  e.getEnclosingCallable().isSynchronized() or
  e.getEnclosingStmt().getEnclosingStmt+() instanceof SynchronizedStmt
}

class MyField extends Field {
  MyField() {
    this.fromSource() and
    not this.isFinal() and
    not this.isVolatile() and
    not this.getDeclaringType() instanceof EnumType
  }

  int getNumSynchedAccesses() {
    result =
      count(Expr synched | synched = this.getAnAccess() and withinLocalSynchronization(synched))
  }

  int getNumAccesses() { result = count(this.getAnAccess()) }

  float getPercentSynchedAccesses() {
    result = this.getNumSynchedAccesses().(float) / this.getNumAccesses()
  }
}

from MyField f, Expr e, int percent
where
  e = f.getAnAccess() and
  not withinInitializer(e) and
  not withinLocalSynchronization(e) and
  hasUnsynchronizedCall(e.getEnclosingCallable()) and
  f.getNumSynchedAccesses() > 0 and
  percent = (f.getPercentSynchedAccesses() * 100).floor() and
  percent > 80
select e,
  "Unsynchronized access to $@, but " + percent.toString() +
    "% of accesses to this field are synchronized.", f,
  f.getDeclaringType().getName() + "." + f.getName()
