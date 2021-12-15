/**
 * @name Equals on collections
 * @description Comparing collections using the Equals method only checks reference equality. A deep compare is more likely what is needed.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/equals-on-arrays
 * @tags reliability
 *       correctness
 */

import csharp
import semmle.code.csharp.frameworks.System
import semmle.code.csharp.frameworks.system.Collections

// Does method m have an override in t or one of its derived classes?
pragma[nomagic]
predicate methodOverriddenBelow(Method m, Class t) {
  m.getAnOverrider*().getDeclaringType() = t.getASubType*()
}

predicate isIEnumerable(ValueOrRefType t) {
  t instanceof ArrayType or // Extractor doesn't extract interfaces of ArrayType yet.
  t.getABaseInterface*() instanceof SystemCollectionsIEnumerableInterface
}

from MethodCall m
where
  m.getTarget() instanceof EqualsMethod and
  isIEnumerable(m.getQualifier().getType()) and
  isIEnumerable(m.getArgument(0).getType()) and
  not methodOverriddenBelow(m.getTarget(), m.getQualifier().getType())
select m, "Using Equals(object) on a collection only checks reference equality."
