/**
 * @name Explicit garbage collection
 * @description Triggering garbage collection explicitly may either have no effect or may trigger
 *              unnecessary garbage collection.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/garbage-collection
 * @tags reliability
 *       maintainability
 */

import java

from MethodAccess mc, Method m
where
  (
    m.getDeclaringType().hasQualifiedName("java.lang", "Runtime") or
    m.getDeclaringType().hasQualifiedName("java.lang", "System")
  ) and
  m.hasName("gc") and
  mc.getMethod() = m
select mc, "Explicit garbage collection. This should only be used in benchmarking code."
