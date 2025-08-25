/**
 * @name Virtual call in constructor or destructor
 * @description Finds virtual calls or accesses in a constructor or destructor
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/virtual-call-in-constructor
 * @alternate-ids cs/virtual-call-in-constructor-or-destructor
 * @tags reliability
 *       maintainability
 *       modularity
 */

import csharp

predicate virtualCallToSelfInConstructor(Expr e) {
  exists(RefType t, Virtualizable d, Callable c |
    c = e.getEnclosingCallable() and
    (c instanceof Constructor or c instanceof Destructor) and
    t = c.getDeclaringType() and
    virtualAccessWithThisQualifier(e, d) and
    t.getABaseType*() = d.getDeclaringType() and
    not t.isSealed() and
    not overriddenSealed(t.getABaseType*(), d)
  )
}

predicate overriddenSealed(RefType t, Virtualizable d) {
  exists(Virtualizable od |
    od.getDeclaringType() = t and
    (od.getOverridee() = d or od.getImplementee() = d) and
    not od.isOverridableOrImplementable()
  )
}

predicate virtualAccessWithThisQualifier(Expr e, Member d) {
  exists(VirtualMethodCall c |
    c = e and c.getTarget() = d and c.hasThisQualifier() and not c.isImplicit()
  )
  or
  exists(VirtualMethodAccess c | c = e and c.getTarget() = d and c.hasThisQualifier())
  or
  exists(VirtualPropertyAccess c | c = e and c.getTarget() = d and c.hasThisQualifier())
  or
  exists(VirtualIndexerAccess c | c = e and c.getTarget() = d and c.hasThisQualifier())
  or
  exists(VirtualEventAccess c | c = e and c.getTarget() = d and c.hasThisQualifier())
}

from Expr e
where virtualCallToSelfInConstructor(e)
select e, "Avoid virtual calls in a constructor or destructor."
