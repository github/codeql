/**
 * @name Failure to abandon session
 * @description Reusing an existing session as a different user could allow
 *              an attacker to access someone else's account by using
 *              their session.
 * @kind problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id cs/session-reuse
 * @tags security
 *       external/cwe/cwe-384
 */

import csharp
import semmle.code.csharp.frameworks.system.web.Security

predicate loginMethod(Method m, ControlFlow::SuccessorType flowFrom) {
  (
    m = any(SystemWebSecurityMembershipClass c).getValidateUserMethod()
    or
    m = any(SystemWebSecurityFormsAuthenticationClass c).getAuthenticateMethod()
  ) and
  flowFrom.(ControlFlow::BooleanSuccessor).getValue() = true
  or
  m = any(SystemWebSecurityFormsAuthenticationClass c).getSignOutMethod() and
  flowFrom instanceof ControlFlow::DirectSuccessor
}

/** The `System.Web.SessionState.HttpSessionState` class. */
class SystemWebSessionStateHttpSessionStateClass extends Class {
  SystemWebSessionStateHttpSessionStateClass() {
    this.hasFullyQualifiedName("System.Web.SessionState", "HttpSessionState")
  }

  /** Gets the `Abandon` method. */
  Method getAbandonMethod() { result = this.getAMethod("Abandon") }

  /** Gets the `Clear` method. */
  Method getClearMethod() { result = this.getAMethod("Clear") }
}

/** A method that directly or indirectly clears `HttpSessionState`. */
predicate sessionEndMethod(Method m) {
  exists(SystemWebSessionStateHttpSessionStateClass ss |
    m = ss.getAbandonMethod() or m = ss.getClearMethod()
  )
  or
  exists(Method r | m.calls(r) and sessionEndMethod(r))
}

/** A use of `HttpSessionState`, other than to clear it. */
predicate sessionUse(MemberAccess ma) {
  ma.getType() instanceof SystemWebSessionStateHttpSessionStateClass and
  not exists(MethodCall end | end.getQualifier() = ma and sessionEndMethod(end.getTarget()))
}

/** A control flow step that is not sanitised by a call to clear the session. */
predicate controlStep(ControlFlowNode s1, ControlFlowNode s2) {
  s2 = s1.getASuccessor() and
  not sessionEndMethod(s2.asExpr().(MethodCall).getTarget())
}

from
  ControlFlowNode loginCall, Method loginMethod, ControlFlowNode sessionUse,
  ControlFlow::SuccessorType fromLoginFlow
where
  loginMethod = loginCall.asExpr().(MethodCall).getTarget() and
  loginMethod(loginMethod, fromLoginFlow) and
  sessionUse(sessionUse.asExpr()) and
  controlStep+(loginCall.getASuccessor(fromLoginFlow), sessionUse)
select sessionUse, "This session has not been invalidated following the call to $@.", loginCall,
  loginMethod.getName()
