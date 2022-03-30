/**
 * Provides classes corresponding to VxWorks semaphores and locks.
 */

import cpp

class SemaphoreCreation extends FunctionCall {
  SemaphoreCreation() {
    this.getTarget().getName() = ["semBCreate", "semMCreate", "semCCreate", "semRWCreate"]
  }

  Variable getSemaphore() { result.getAnAccess() = this.getParent().(Assignment).getLValue() }
}

abstract class LockOperation extends FunctionCall {
  abstract UnlockOperation getMatchingUnlock();

  abstract Declaration getLocked();

  abstract string say();

  ControlFlowNode getAReachedNode() {
    result = this
    or
    exists(ControlFlowNode mid | mid = this.getAReachedNode() |
      not mid != this.getMatchingUnlock() and
      result = mid.getASuccessor()
    )
  }
}

abstract class UnlockOperation extends FunctionCall {
  abstract LockOperation getMatchingLock();
}

class SemaphoreTake extends LockOperation {
  SemaphoreTake() {
    exists(string name | name = this.getTarget().getName() |
      name = "semTake"
      or
      // '_' is a wildcard, so this matches calls like
      // semBTakeScalable or semMTake_inline.
      name.matches("sem_Take%")
    )
  }

  override Variable getLocked() { result.getAnAccess() = this.getArgument(0) }

  override UnlockOperation getMatchingUnlock() {
    result.(SemaphoreGive).getLocked() = this.getLocked()
  }

  override string say() { result = "semaphore take of " + this.getLocked().getName() }
}

class SemaphoreGive extends UnlockOperation {
  SemaphoreGive() {
    exists(string name | name = this.getTarget().getName() |
      name = "semGive" or
      name.matches("sem%Give%")
    )
  }

  Variable getLocked() { result.getAnAccess() = this.getArgument(0) }

  override LockOperation getMatchingLock() { this = result.getMatchingUnlock() }
}

class LockingPrimitive extends FunctionCall, LockOperation {
  LockingPrimitive() { this.getTarget().getName() = ["taskLock", "intLock", "taskRtpLock"] }

  override Function getLocked() { result = this.getTarget() }

  override UnlockOperation getMatchingUnlock() {
    result.(UnlockingPrimitive).getTarget().getName() =
      this.getTarget().getName().replaceAll("Lock", "Unlock")
  }

  override string say() { result = "call to " + this.getLocked().getName() }
}

class UnlockingPrimitive extends FunctionCall, UnlockOperation {
  UnlockingPrimitive() { this.getTarget().getName() = ["taskUnlock", "intUnlock", "taskRtpUnlock"] }

  Function getLocked() { result = this.getMatchingLock().getLocked() }

  override LockOperation getMatchingLock() { this = result.getMatchingUnlock() }
}
