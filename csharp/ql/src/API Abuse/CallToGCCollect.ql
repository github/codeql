/**
 * @name Call to GC.Collect()
 * @description Explicit requests for garbage collection often indicate performance problems and memory leaks.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cs/call-to-gc
 * @tags efficiency
 *       maintainability
 */

import csharp

from MethodCall c, Method gcCollect
where
  c.getTarget() = gcCollect and
  gcCollect.hasName("Collect") and
  gcCollect.hasNoParameters() and
  gcCollect.getDeclaringType().hasFullyQualifiedName("System", "GC")
select c, "Call to 'GC.Collect()'."
