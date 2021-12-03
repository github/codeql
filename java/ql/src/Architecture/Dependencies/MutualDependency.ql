/**
 * @name Mutually-dependent types
 * @description Mutual dependency between types makes code difficult to understand and test.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/mutually-dependent-types
 * @tags testability
 *       maintainability
 *       modularity
 */

import java

from RefType t1, RefType t2
where
  depends(t1, t2) and
  depends(t2, t1) and
  // Prevent symmetrical results.
  t1.getName() < t2.getName() and
  t1.fromSource() and
  t2.fromSource() and
  // Exclusions.
  not (
    t1 instanceof AnonymousClass or
    t1 instanceof BoundedType or
    t2 instanceof AnonymousClass or
    t2 instanceof BoundedType or
    t1.getName().toLowerCase().matches("%visitor%") or
    t2.getName().toLowerCase().matches("%visitor%") or
    t1.getAMethod().getName().toLowerCase().matches("%visit%") or
    t2.getAMethod().getName().toLowerCase().matches("%visit%") or
    t1.getPackage() = t2.getPackage()
  )
select t1, "This type and type $@ are mutually dependent.", t2, t2.getName()
