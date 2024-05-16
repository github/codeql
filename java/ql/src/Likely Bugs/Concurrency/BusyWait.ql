/**
 * @name Busy wait
 * @description Calling 'Thread.sleep' to control thread interaction is
 *              less effective than waiting for a notification and may also
 *              result in race conditions. Merely synchronizing over shared
 *              variables in a loop to control thread interaction
 *              may waste system resources and cause performance problems.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/busy-wait
 * @tags reliability
 *       correctness
 *       concurrency
 */

import java

class SleepMethod extends Method {
  SleepMethod() {
    this.getName() = "sleep" and
    this.getDeclaringType().hasQualifiedName("java.lang", "Thread")
  }
}

class SleepMethodCall extends MethodCall {
  SleepMethodCall() { this.getMethod() instanceof SleepMethod }
}

class WaitMethod extends Method {
  WaitMethod() {
    this.getName() = "wait" and
    this.getDeclaringType() instanceof TypeObject
  }
}

class ConcurrentMethod extends Method {
  ConcurrentMethod() { this.getDeclaringType().getQualifiedName().matches("java.util.concurrent%") }
}

class CommunicationMethod extends Method {
  CommunicationMethod() {
    this instanceof WaitMethod or
    this instanceof ConcurrentMethod
  }
}

predicate callsCommunicationMethod(Method source) {
  source instanceof CommunicationMethod
  or
  exists(MethodCall a, Method overridingMethod, Method target |
    callsCommunicationMethod(overridingMethod) and
    overridingMethod.overridesOrInstantiates*(target) and
    target = a.getMethod() and
    a.getEnclosingCallable() = source
  )
}

class DangerStmt extends Stmt {
  DangerStmt() { exists(SleepMethodCall sleep | sleep.getEnclosingStmt() = this) }
}

from WhileStmt s, DangerStmt d
where
  d.getEnclosingStmt+() = s and
  not exists(MethodCall call | callsCommunicationMethod(call.getMethod()) |
    call.getEnclosingStmt().getEnclosingStmt*() = s
  )
select d, "Prefer wait/notify or java.util.concurrent to communicate between threads."
