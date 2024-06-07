/**
 * @name Pointless forwarding method
 * @description A method forwards calls to another method of the same name that is not called independently.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/useless-forwarding-method
 * @tags maintainability
 */

import java

predicate ignored(Method m) {
  m.isAbstract() or
  m.overrides(_)
}

Method forwarderCandidate(Method forwardee) {
  result != forwardee and
  result.getName() = forwardee.getName() and
  result.getDeclaringType() = forwardee.getDeclaringType() and
  forex(MethodCall c | c.getMethod() = forwardee | c.getCaller() = result) and
  forall(MethodCall c | c.getCaller() = result | c.getMethod() = forwardee)
}

from Method forwarder, Method forwardee
where
  forwarder = forwarderCandidate(forwardee) and
  // Exclusions
  not ignored(forwarder) and
  not ignored(forwardee) and
  not exists(VirtualMethodCall c |
    c.getMethod() = forwardee and
    c.getCaller() = forwarder and
    c.(MethodCall).hasQualifier()
  )
select forwarder.getSourceDeclaration(),
  "This method is a forwarder for $@, which is not called independently - the methods can be merged.",
  forwardee.getSourceDeclaration(), forwardee.getName()
