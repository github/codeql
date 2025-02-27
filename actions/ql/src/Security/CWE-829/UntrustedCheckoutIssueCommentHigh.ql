/**
 * @name Checkout of untrusted code in trusted context
 * @description Privileged workflows have read/write access to the base repository and access to secrets.
 *              By explicitly checking out and running the build script from a fork the untrusted code is running in an environment
 *              that is able to push to the base repository and to access secrets.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @security-severity 0.0
 * @id actions/untrusted-checkout-issue-comment/high
 * @tags actions
 *       security
 *       external/cwe/cwe-829
 */

import actions
import codeql.actions.security.UntrustedCheckoutQuery
import codeql.actions.security.PoisonableSteps
import codeql.actions.security.ControlChecks

from PRHeadCheckoutStep checkout, Event event
where
  // the checkout is NOT followed by a known poisonable step
  not checkout.getAFollowingStep() instanceof PoisonableStep and
  // the checkout occurs in a privileged context
  inPrivilegedContext(checkout, event) and
  event.getName() = issueCommentTriggers() and
  not exists(ControlCheck check | check.protects(checkout, event, "untrusted-checkout"))
select checkout, "Potential execution of untrusted code on a privileged workflow ($@).", event,
  event.getName()
