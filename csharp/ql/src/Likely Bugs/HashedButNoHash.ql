/**
 * @name Hashed value without GetHashCode definition
 * @description Finds uses of hashing on types that define 'Equals(...)' but not 'GetHashCode()'.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/gethashcode-is-not-defined
 * @tags reliability
 *       maintainability
 */

import csharp
import semmle.code.csharp.frameworks.System

predicate dictionary(ConstructedType constructed) {
  exists(UnboundGenericType dict |
    dict.hasQualifiedName("System.Collections.Generic", "Dictionary<,>") and
    constructed = dict.getAConstructedGeneric()
  )
}

predicate hashtable(Class c) { c.hasQualifiedName("System.Collections", "Hashtable") }

predicate hashstructure(Type t) { hashtable(t) or dictionary(t) }

predicate hashAdd(Expr e) {
  exists(MethodCall mc, string name |
    (name = "Add" or name = "ContainsKey") and
    mc.getArgument(0) = e and
    mc.getTarget().hasName(name) and
    hashstructure(mc.getTarget().getDeclaringType())
  )
}

predicate eqWithoutHash(RefType t) {
  t.getAMethod() instanceof EqualsMethod and
  not t.getAMethod() instanceof GetHashCodeMethod
}

predicate hashCall(Expr e) {
  exists(MethodCall mc |
    mc.getQualifier() = e and
    mc.getTarget() instanceof GetHashCodeMethod
  )
}

from Expr e, Type t
where
  (hashAdd(e) or hashCall(e)) and
  e.getType() = t and
  eqWithoutHash(t)
select e,
  "This expression is hashed, but type '" + t.getName() +
    "' only defines Equals(...) not GetHashCode()."
