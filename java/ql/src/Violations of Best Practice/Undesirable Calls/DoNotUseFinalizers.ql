/**
 * @id java/do-not-use-finalizers
 * @name J-D-004: Calling garbage collection methods in application code may cause inconsistent program state
 * @description Calling garbage collection or finalizer methods in application code may cause
 *              inconsistent program state or unpredicatable behavior.
 * @kind problem
 * @precision high
 * @problem.severity error
 * @tags correctness
 *       external/cwe/cwe-586
 */

import java

from MethodCall c, Method m
where
  c.getMethod() = m and
  (
    m.hasQualifiedName("java.lang", "System", ["gc", "runFinalizersOnExit"])
    or
    m.hasQualifiedName("java.lang", "Runtime", "gc")
    or
    m.hasQualifiedName(_, _, "finalize")
  )
select c, "Call to prohibited method that may modify the JVM's garbage collection process."
