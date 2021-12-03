/**
 * @name Mutually-dependent types
 * @description Mutual dependency between types makes code difficult to understand and test.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id cs/mutually-dependent-types
 * @tags testability
 *       maintainability
 *       modularity
 */

import csharp
import semmle.code.csharp.metrics.Coupling

/** inner is nested (possibly more than one level deep) within outer */
predicate nestedWithin(ValueOrRefType outer, NestedType inner) {
  inner.getDeclaringType() = outer or
  nestedWithin(outer, inner.getDeclaringType())
}

from ValueOrRefType t1, ValueOrRefType t2
where
  t1 != t2 and
  depends(t1, t2) and
  depends(t2, t1) and
  // PREVENT SYMMETRICAL RESULTS
  t1.getName() < t2.getName() and
  // ADDITIONAL CONSTRAINTS
  t1.fromSource() and
  t2.fromSource() and
  // EXCLUSIONS
  not (
    nestedWithin(t1, t2) or
    nestedWithin(t2, t1) or
    t1.getName().toLowerCase().matches("%visitor%") or
    t2.getName().toLowerCase().matches("%visitor%") or
    t1.getAMember().getName().toLowerCase().matches("%visit%") or
    t2.getAMember().getName().toLowerCase().matches("%visit%")
  )
select t1, "This type and type $@ are mutually dependent.", t2, t2.getName()
