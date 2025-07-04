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
import semmle.code.csharp.frameworks.system.Collections
import semmle.code.csharp.frameworks.system.collections.Generic

/**
 * Holds if `t` is a dictionary type.
 */
predicate dictionary(ValueOrRefType t) {
  exists(Type base | base = t.getABaseType*().getUnboundDeclaration() |
    base instanceof SystemCollectionsGenericIDictionaryInterface or
    base instanceof SystemCollectionsGenericIReadOnlyDictionaryInterface or
    base instanceof SystemCollectionsIDictionaryInterface
  )
}

/**
 * Holds if `c` is a hashset type.
 */
predicate hashSet(ValueOrRefType t) {
  t.getABaseType*().getUnboundDeclaration() instanceof SystemCollectionsGenericHashSetClass
}

predicate hashStructure(Type t) { dictionary(t) or hashSet(t) }

/**
 * Holds if the expression `e` relies on `GetHashCode()` implementation.
 * That is, if the call assumes that `e1.Equals(e2)` implies `e1.GetHashCode() == e2.GetHashCode()`.
 */
predicate usesHashing(Expr e) {
  exists(MethodCall mc, string name |
    name = ["Add", "Contains", "ContainsKey", "Remove", "TryAdd", "TryGetValue"] and
    mc.getArgument(0) = e and
    mc.getTarget().hasName(name) and
    hashStructure(mc.getTarget().getDeclaringType())
  )
  or
  exists(IndexerCall ic |
    ic.getArgument(0) = e and
    dictionary(ic.getTarget().getDeclaringType())
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
  (usesHashing(e) or hashCall(e)) and
  e.getType() = t and
  eqWithoutHash(t)
select e,
  "This expression is hashed, but type '" + t.getName() +
    "' only defines Equals(...) not GetHashCode()."
