/**
 * @name Pointless forwarding method
 * @description A method forwards calls to another method of the same name that is not called independently.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/useless-forwarding-method
 * @tags maintainability
 *       useless-code
 */

import csharp

predicate methodInClass(ValueOrRefType t, Method m, string name) {
  m.getDeclaringType() = t and
  m.getName() = name
}

predicate callIn(MethodCall mc, Method fromMethod) { fromMethod = mc.getEnclosingCallable() }

predicate callTo(MethodCall mc, Method toMethod) {
  toMethod = mc.getTarget().getSourceDeclaration()
}

predicate candidates(Method forwarder, Method forwardee) {
  exists(ValueOrRefType t, string name |
    methodInClass(t, forwarder, name) and methodInClass(t, forwardee, name)
  |
    not ignored(forwarder) and not ignored(forwardee) and forwarder != forwardee
  )
}

predicate ignored(Method m) {
  m.isAbstract() or
  m.implements() or
  m.isOverride() or
  m.isVirtual() or
  m.getName() = "Dispose" or
  not m.fromSource()
}

from Method forwarder, Method forwardee
where
  not extractionIsStandalone() and
  candidates(forwarder, forwardee) and
  forex(MethodCall c | callTo(c, forwardee) | callIn(c, forwarder)) and
  forex(MethodCall c | callIn(c, forwarder) | callTo(c, forwardee))
select forwarder.getSourceDeclaration(),
  "This method is a forwarder for $@, which is not called independently - the methods can be merged.",
  forwardee.getSourceDeclaration(), forwardee.getName()
