/**
 * @name LinuxPrivilegeDroppingOutoforder
 * @description A syscall commonly associated with privilege dropping is being called out of order.
                Normally a process drops group ID and sets supplimental groups for the target user
                before setting the target user ID. This can have security impact if the return code
                from these methods is not checked.
 * @kind problem
 * @problem.severity recommendation
 * @id cpp/drop-linux-privileges-outoforder
 * @tags security
 *       external/cwe/cwe-273
 * @precision medium
 */

import cpp
import semmle.code.cpp.dataflow.TaintTracking

class SetuidLikeFunctionCall extends FunctionCall {
  SetuidLikeFunctionCall() {
    // setuid/setresuid with the root user are false positives.
    getTarget().hasGlobalName("setuid") or
    getTarget().hasGlobalName("setresuid")
  }
}

class SetuidLikeWrapperCall extends FunctionCall {
  SetuidLikeFunctionCall baseCall;

  SetuidLikeWrapperCall() {
    this = baseCall or
    exists(SetuidLikeWrapperCall fc |
      this.getTarget() = fc.getEnclosingFunction() and
      baseCall = fc.getBaseCall()
    )
  }

  SetuidLikeFunctionCall getBaseCall() {
    result = baseCall
  }
}

class CallBeforeSetuidFunctionCall extends FunctionCall {
  CallBeforeSetuidFunctionCall() {
    // setgid/setresgid with the root group are false positives.
    getTarget().hasGlobalName("setgid") or
    getTarget().hasGlobalName("setresgid") or
    // Compatibility may require skipping initgroups and setgroups return checks.
    // A stricter best practice is to check the result and errnor for EPERM.
    getTarget().hasGlobalName("initgroups") or
    getTarget().hasGlobalName("setgroups")
  }
}

class CallBeforeSetuidWrapperCall extends FunctionCall {
  CallBeforeSetuidFunctionCall baseCall;

  CallBeforeSetuidWrapperCall() {
    this = baseCall or
    exists(CallBeforeSetuidWrapperCall fc |
      this.getTarget() = fc.getEnclosingFunction() and
      baseCall = fc.getBaseCall()
    )
  }

  CallBeforeSetuidFunctionCall getBaseCall() {
    result = baseCall
  }
}

predicate setuidBeforeSetgid(
    SetuidLikeWrapperCall setuidWrapper,
    CallBeforeSetuidWrapperCall setgidWrapper) {
  setgidWrapper.getAPredecessor+() = setuidWrapper
}

predicate flowsToCondition(Expr fc) {
  exists(DataFlow::Node source, DataFlow::Node sink |
    TaintTracking::localTaint(source, sink) and
    fc = source.asExpr() and
    (sink.asExpr().getParent*().(ControlFlowNode).isCondition() or sink.asExpr().isCondition())
  )
}

from
  Function func,
  CallBeforeSetuidFunctionCall fc,
  SetuidLikeFunctionCall setuid
where
  setuidBeforeSetgid(setuid, fc) and
  // Require the call return code to be used in a condition.
  // This introduces false negatives where the return is checked but then
  // errno == EPERM allows execution to continue.
  (not flowsToCondition(fc) or not flowsToCondition(setuid)) and
  func = fc.getEnclosingFunction()
select fc, "This function is called within " + func + ", and potentially after " +
  "$@, and may not succeed. Be sure to check the return code and errno.",
  setuid, setuid.getTarget().getName()
