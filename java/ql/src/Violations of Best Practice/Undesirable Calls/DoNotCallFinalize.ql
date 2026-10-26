/**
 * @id java/do-not-call-finalize
 * @previous-id java/do-not-use-finalizers
 * @name Do not call `finalize()`
 * @description Calling `finalize()` in application code may cause
 *              inconsistent program state or unpredictable behavior.
 * @kind problem
 * @precision high
 * @problem.severity error
 * @tags quality
 *       reliability
 *       correctness
 *       performance
 *       external/cwe/cwe-586
 */

import java

from MethodCall mc
where
  mc.getMethod() instanceof FinalizeMethod and
  // The Java documentation for `finalize()` states: "If a subclass overrides
  // `finalize` it must invoke the superclass finalizer explicitly". Therefore,
  // we do not alert on `super.finalize()` calls that occur within a callable
  // that overrides `finalize`.
  not exists(Callable caller, FinalizeMethod fm | caller = mc.getCaller() |
    caller.(Method).overrides(fm) and
    mc.getQualifier() instanceof SuperAccess
  )
select mc, "Call to 'finalize()'."
