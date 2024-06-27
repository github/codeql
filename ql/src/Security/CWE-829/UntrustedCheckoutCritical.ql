/**
 * @name Checkout of untrusted code in trusted context
 * @description Privileged workflows have read/write access to the base repository and access to secrets.
 *              By explicitly checking out and running the build script from a fork the untrusted code is running in an environment
 *              that is able to push to the base repository and to access secrets.
 * @kind path-problem
 * @problem.severity error
 * @precision very-high
 * @security-severity 9.3
 * @id actions/untrusted-checkout/critical
 * @tags actions
 *       security
 *       external/cwe/cwe-829
 */

import actions
import codeql.actions.security.UntrustedCheckoutQuery
import codeql.actions.security.PoisonableSteps

query predicate edges(Step a, Step b) { a.getAFollowingStep() = b }

from LocalJob j, PRHeadCheckoutStep checkout, PoisonableStep s
where
  j = checkout.getEnclosingJob() and
  j.getAStep() = checkout and
  // the checkout is followed by a known poisonable step
  checkout.getAFollowingStep() = s and
  // the checkout is not controlled by an access check
  not exists(ControlCheck check | check.dominates(checkout)) and
  // the checkout occurs in a privileged context
  (
    inPrivilegedCompositeAction(checkout)
    or
    inPrivilegedExternallyTriggerableJob(checkout)
  )
select s, checkout, s, "Potential unsafe checkout of untrusted code on a privileged workflow."
