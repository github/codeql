/**
 * @name Explicit garbage collection
 * @description Triggering garbage collection explicitly may either have no effect or may trigger
 *              unnecessary garbage collection.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/garbage-collection
 * @previous-id java/do-not-use-finalizers
 * @tags quality
 *       reliability
 *       correctness
 */

import java

from MethodCall mc, Method m
where
  (
    m.getDeclaringType().hasQualifiedName("java.lang", "Runtime") or
    m.getDeclaringType().hasQualifiedName("java.lang", "System")
  ) and
  m.hasName("gc") and
  mc.getMethod() = m
select mc, "Explicit garbage collection. This should only be used in benchmarking code."
