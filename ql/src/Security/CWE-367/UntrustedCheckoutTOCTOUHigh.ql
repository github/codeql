/**
 * @name Untrusted Checkout TOCTOU
 * @description Untrusted Checkout is protected by a security check but the checked-out branch can be changed after the check.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @security-severity 7.5
 * @id actions/untrusted-checkout-toctou/high
 * @tags actions
 *       security
 *       external/cwe/cwe-367
 */

import actions
import codeql.actions.security.UntrustedCheckoutQuery
import codeql.actions.security.PoisonableSteps
import codeql.actions.security.ControlChecks

from LocalJob job, MutableRefCheckoutStep checkout, ControlCheck check, Event event
where
  job.getAStep() = checkout and
  // there are no evidences that the checked-out gets executed
  not checkout.getAFollowingStep() instanceof PoisonableStep and
  // the checkout occurs in a privileged context
  inPrivilegedContext(checkout, event) and
  event = job.getATriggerEvent() and
  // the mutable checkout step is protected by an Insufficient access check
  check.protects(checkout, event, "untrusted-checkout") and
  not check.protects(checkout, event, "untrusted-checkout-toctou")
select checkout,
  "Insufficient protection against execution of untrusted code on a privileged workflow on step $@.",
  check, check.toString()
