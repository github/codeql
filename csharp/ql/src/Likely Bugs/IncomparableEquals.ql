/**
 * @name Equals on incomparable types
 * @description Finds calls of the form 'x.Equals(y)' with incomparable types for x and y.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/equals-on-unrelated-types
 * @tags reliability
 *       correctness
 */

import csharp
import semmle.code.csharp.frameworks.System

/**
 * A whitelist of method accesses which would be allowed to perform
 * the incomparable-equals call
 */
predicate whitelist(MethodCall mc) {
  // Allow tests to verify that equals methods return false
  mc.getParent*().(MethodCall).getTarget().hasName("IsFalse")
}

from EqualsMethod equals, MethodCall ma, Type i, Type j
where
  ma.getTarget() = equals and
  not whitelist(ma) and
  // find the source types
  ma.getArgument(0).getType() = i and
  ma.getQualifier().getType() = j and
  // If one of the types is object, then we know they overlap, so
  // no point checking.
  not i instanceof ObjectType and
  not j instanceof ObjectType and
  // In standalone extraction mode, we have to test the
  // weaker condition that they are unrelated classes,
  // and we have enough type information to relate the two classes,
  // which would normally be 'object' without extraction errors.
  (extractionIsStandalone() implies i.(Class).getBaseClass*() = j.(Class).getBaseClass*()) and
  // check they are not related
  not exists(ValueOrRefType k |
    k.getABaseType*() = j and
    k.getABaseType*() = i
  ) and
  // exclude wildcards since the check is not applicable to them
  not (i instanceof TypeParameter or j instanceof TypeParameter) and
  // exclude calls of the form x.Equals(null), since they're highlighted by a different query
  not i instanceof NullType
select ma, "Call to 'Equals()' comparing incomparable types $@ and $@.", j, j.getName(), i,
  i.getName()
