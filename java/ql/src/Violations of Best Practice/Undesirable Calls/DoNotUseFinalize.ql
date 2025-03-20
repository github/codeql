/**
 * @id java/do-not-use-finalize
 * @name Do not use `finalize`
 * @description Calling `finalize` in application code may cause
 *              inconsistent program state or unpredicatable behavior.
 * @kind problem
 * @precision high
 * @problem.severity error
 * @tags correctness
 *       external/cwe/cwe-586
 */

import java

from MethodCall mc, Method m
where
  mc.getMethod() = m and
  m.hasName("finalize") and
  // The Java documentation for `finalize` states: "If a subclass overrides
  // `finalize` it must invoke the superclass finalizer explicitly". Therefore,
  // we do not alert on `super.finalize` calls that occur within a callable
  // that overrides `finalize`.
  not exists(Callable caller, FinalizeMethod fm | caller = mc.getCaller() |
    caller.(Method).overrides(fm) and
    mc.getQualifier() instanceof SuperAccess
  )
select mc, "Call to 'finalize'."
