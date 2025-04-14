/**
 * @name Checkout of untrusted code in trusted context
 * @description Privileged workflows have read/write access to the base repository and access to secrets.
 *              By explicitly checking out and running the build script from a fork the untrusted code is running in an environment
 *              that is able to push to the base repository and to access secrets.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @security-severity 7.5
 * @id actions/untrusted-checkout/high
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
  event.getName() = checkoutTriggers() and
  (
    // issue_comment: check for date comparison checks and actor/access control checks
    event.getName() = "issue_comment" and
    not exists(ControlCheck check, CommentVsHeadDateCheck date_check |
      (
        check instanceof ActorCheck or
        check instanceof AssociationCheck or
        check instanceof PermissionCheck
      ) and
      check.dominates(checkout) and
      date_check.dominates(checkout)
    )
    or
    // not issue_comment triggered workflows
    not event.getName() = "issue_comment" and
    not exists(ControlCheck check | check.protects(checkout, event, "untrusted-checkout"))
  )
select checkout, "Potential execution of untrusted code on a privileged workflow ($@)", event,
  event.getName()
