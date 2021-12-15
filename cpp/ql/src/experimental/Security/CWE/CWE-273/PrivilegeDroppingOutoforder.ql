/**
 * @name LinuxPrivilegeDroppingOutoforder
 * @description A syscall commonly associated with privilege dropping is being called out of order.
 *                Normally a process drops group ID and sets supplimental groups for the target user
 *                before setting the target user ID. This can have security impact if the return code
 *                from these methods is not checked.
 * @kind problem
 * @problem.severity recommendation
 * @id cpp/drop-linux-privileges-outoforder
 * @tags security
 *       external/cwe/cwe-273
 * @precision medium
 */

import cpp

predicate argumentMayBeRoot(Expr e) {
  e.getValue() = "0" or
  e.(VariableAccess).getTarget().getName().toLowerCase().matches("%root%")
}

class SetuidLikeFunctionCall extends FunctionCall {
  SetuidLikeFunctionCall() {
    (this.getTarget().hasGlobalName("setuid") or this.getTarget().hasGlobalName("setresuid")) and
    // setuid/setresuid with the root user are false positives.
    not argumentMayBeRoot(this.getArgument(0))
  }
}

class SetuidLikeWrapperCall extends FunctionCall {
  SetuidLikeFunctionCall baseCall;

  SetuidLikeWrapperCall() {
    this = baseCall
    or
    exists(SetuidLikeWrapperCall fc |
      this.getTarget() = fc.getEnclosingFunction() and
      baseCall = fc.getBaseCall()
    )
  }

  SetuidLikeFunctionCall getBaseCall() { result = baseCall }
}

class CallBeforeSetuidFunctionCall extends FunctionCall {
  CallBeforeSetuidFunctionCall() {
    this.getTarget()
        .hasGlobalName([
            "setgid", "setresgid",
            // Compatibility may require skipping initgroups and setgroups return checks.
            // A stricter best practice is to check the result and errnor for EPERM.
            "initgroups", "setgroups"
          ]) and
    // setgid/setresgid/etc with the root group are false positives.
    not argumentMayBeRoot(this.getArgument(0))
  }
}

class CallBeforeSetuidWrapperCall extends FunctionCall {
  CallBeforeSetuidFunctionCall baseCall;

  CallBeforeSetuidWrapperCall() {
    this = baseCall
    or
    exists(CallBeforeSetuidWrapperCall fc |
      this.getTarget() = fc.getEnclosingFunction() and
      baseCall = fc.getBaseCall()
    )
  }

  CallBeforeSetuidFunctionCall getBaseCall() { result = baseCall }
}

predicate setuidBeforeSetgid(
  SetuidLikeWrapperCall setuidWrapper, CallBeforeSetuidWrapperCall setgidWrapper
) {
  setgidWrapper.getAPredecessor+() = setuidWrapper
}

predicate isAccessed(FunctionCall fc) {
  exists(Variable v | v.getAnAssignedValue() = fc)
  or
  exists(Operation c | fc = c.getAChild() | c.isCondition())
  or
  // ignore pattern where result is intentionally ignored by a cast to void.
  fc.hasExplicitConversion()
}

from Function func, CallBeforeSetuidFunctionCall fc, SetuidLikeFunctionCall setuid
where
  setuidBeforeSetgid(setuid, fc) and
  // Require the call return code to be used in a condition or assigned.
  // This introduces false negatives where the return is checked but then
  // errno == EPERM allows execution to continue.
  not isAccessed(fc) and
  func = fc.getEnclosingFunction()
select fc,
  "This function is called within " + func + ", and potentially after " +
    "$@, and may not succeed. Be sure to check the return code and errno, otherwise permissions " +
    "may not be dropped.", setuid, setuid.getTarget().getName()
