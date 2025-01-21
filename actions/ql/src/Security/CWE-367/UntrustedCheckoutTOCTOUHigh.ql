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

from MutableRefCheckoutStep checkout, Event event
where
  // there are no evidences that the checked-out gets executed
  not checkout.getAFollowingStep() instanceof PoisonableStep and
  // the checkout occurs in a privileged context
  inPrivilegedContext(checkout, event) and
  // the mutable checkout step is protected by an Insufficient access check
  exists(ControlCheck check1 | check1.protects(checkout, event, "untrusted-checkout")) and
  not exists(ControlCheck check2 | check2.protects(checkout, event, "untrusted-checkout-toctou"))
select checkout,
  "Insufficient protection against execution of untrusted code on a privileged workflow ($@).",
  event, event.getName()
