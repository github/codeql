/**
 * @name Hashed value without hashCode definition
 * @description Classes that define an 'equals' method but no 'hashCode' method, and whose instances
 *              are stored in a hashing data structure, can lead to unexpected results.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/hashing-without-hashcode
 * @tags reliability
 *       correctness
 */

import java
import Equality

/** A class that defines an `equals` method but no `hashCode` method. */
predicate eqNoHash(Class c) {
  exists(Method m | m = c.getAMethod() |
    m instanceof EqualsMethod and
    // If the inherited `equals` is a refining `equals`
    // then the superclass hash code is still valid.
    not m instanceof RefiningEquals
  ) and
  not c.getAMethod() instanceof HashCodeMethod and
  c.fromSource()
}

predicate hashingMethod(Method m) {
  exists(string name, string names |
    names = "add,contains,containsKey,get,put,remove" and
    name = names.splitAt(",") and
    m.getName() = name
  )
}

/** Holds if `e` is an expression in which `t` is used in a hashing data structure. */
predicate usedInHash(RefType t, Expr e) {
  exists(RefType s |
    s.getName().matches("%Hash%") and not s.getSourceDeclaration().getName() = "IdentityHashMap"
  |
    exists(MethodCall ma |
      ma.getQualifier().getType() = s and
      ma.getArgument(0).getType() = t and
      e = ma and
      hashingMethod(ma.getMethod())
    )
    or
    exists(ConstructorCall cc |
      cc.getConstructedType() = s and
      s.(ParameterizedType).getTypeArgument(0) = t and
      cc = e
    )
  )
}

from RefType t, Expr e
where
  usedInHash(t, e) and
  eqNoHash(t.getSourceDeclaration())
select e,
  "Type '" + t.getName() + "' does not define hashCode(), " +
    "but is used in a hashing data-structure."
