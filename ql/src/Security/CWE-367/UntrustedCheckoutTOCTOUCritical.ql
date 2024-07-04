/**
 * @name Untrusted Checkout TOCTOU
 * @description Untrusted Checkout is protected by a security check but the checked-out branch can be changed after the check.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @security-severity 9.3
 * @id actions/untrusted-checkout-toctou/critical
 * @tags actions
 *       security
 *       external/cwe/cwe-367
 */

import actions
import codeql.actions.security.UntrustedCheckoutQuery
import codeql.actions.security.PoisonableSteps
import codeql.actions.security.ControlChecks

query predicate edges(Step a, Step b) { a.getAFollowingStep() = b }

from LocalJob j, MutableRefCheckoutStep checkout, PoisonableStep s, ControlCheck check
where
  j = checkout.getEnclosingJob() and
  j.getAStep() = checkout and
  // the checked-out code may lead to arbitrary code execution
  checkout.getAFollowingStep() = s and
  // the checkout occurs in a privileged context
  j.isPrivilegedExternallyTriggerable() and
  // the mutable checkout step is protected by an Insufficient access check
  check.dominates(checkout) and
  check.protects(checkout, j.getATriggerEvent()) and
  check.protectsAgainstRefMutationAttacks() = false
select s, checkout, s,
  "Insufficient protection against execution of untrusted code on a privileged workflow on check $@.",
  check, check.toString()
