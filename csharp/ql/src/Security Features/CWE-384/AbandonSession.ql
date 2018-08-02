/**
 * @name Failure to abandon session
 * @description Reusing an existing session as a different user could allow
 *              an attacker to access someone else's account by using
 *              their session.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/session-reuse
 * @tags security
 *       external/cwe/cwe-384
 */

import csharp
import ControlFlowGraph
import semmle.code.csharp.frameworks.system.web.Security

predicate loginMethod(Method m, ControlFlowEdgeType flowFrom)
{
    (
      m = any(SystemWebSecurityMembershipClass c).getValidateUserMethod()
      or
      m = any(SystemWebSecurityFormsAuthenticationClass c).getAuthenticateMethod()
    )
    and
    flowFrom.(ControlFlowEdgeBoolean).getValue()=true
  or
    m = any(SystemWebSecurityFormsAuthenticationClass c).getSignOutMethod()
    and
    flowFrom instanceof ControlFlowEdgeSuccessor
}

/** The `System.Web.SessionState.HttpSessionState` class. */
class SystemWebSessionStateHttpSessionStateClass extends Class {
  SystemWebSessionStateHttpSessionStateClass() {
    this.hasQualifiedName("System.Web.SessionState.HttpSessionState")
  }

  /** Gets the `Abandon` method. */
  Method getAbandonMethod() { result = getAMethod("Abandon") }

  /** Gets the `Clear` method. */
  Method getClearMethod() { result = getAMethod("Clear") }
}

/** A method that directly or indirectly clears `HttpSessionState`. */
predicate sessionEndMethod(Method m)
{
  exists(SystemWebSessionStateHttpSessionStateClass ss |
    m=ss.getAbandonMethod() or m = ss.getClearMethod())
  or
  exists(Method r | m.calls(r) and sessionEndMethod(r))

}

/** A use of `HttpSessionState`, other than to clear it. */
predicate sessionUse(MemberAccess ma)
{
  ma.getType() instanceof SystemWebSessionStateHttpSessionStateClass
  and
  not exists(MethodCall end | end.getQualifier() = ma and sessionEndMethod(end.getTarget()))
}

/** A control flow step that is not sanitised by a call to clear the session. */
predicate controlStep(ControlFlowNode s1, ControlFlowNode s2)
{
  s2 = s1.getASuccessor()
  and
  not sessionEndMethod(s2.getElement().(MethodCall).getTarget())
}

from ControlFlowNode loginCall, Method loginMethod, ControlFlowNode sessionUse, ControlFlowEdgeType fromLoginFlow
where loginMethod = loginCall.getElement().(MethodCall).getTarget()
  and loginMethod(loginMethod, fromLoginFlow)
  and sessionUse(sessionUse.getElement())
  and controlStep+(loginCall.getASuccessorByType(fromLoginFlow), sessionUse)
select sessionUse, "This session has not been invalidated following the call to '$@'.", loginCall, loginMethod.getName()
