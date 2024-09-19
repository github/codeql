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
import codeql.actions.security.ControlChecks

query predicate edges(Step a, Step b) { a.getNextStep() = b }

from PRHeadCheckoutStep checkout, PoisonableStep step
where
  // the checkout is followed by a known poisonable step
  checkout.getAFollowingStep() = step and
  // the checkout occurs in a privileged context
  inPrivilegedContext(checkout) and
  (
    // issue_comment: check for date comparison checks and actor/access control checks
    exists(Event event |
      event.getName() = "issue_comment" and
      event = checkout.getEnclosingJob().getATriggerEvent() and
      not exists(ControlCheck check, CommentVsHeadDateCheck date_check |
        (
          check instanceof ActorCheck or
          check instanceof AssociationCheck or
          check instanceof PermissionCheck
        ) and
        check.dominates(checkout) and
        date_check.dominates(checkout)
      )
    )
    or
    // not issue_comment triggered workflows
    exists(Event event |
      not event.getName() = "issue_comment" and
      event = checkout.getEnclosingJob().getATriggerEvent() and
      not exists(ControlCheck check | check.protects(checkout, event, "untrusted-checkout"))
    )
  )
select step, checkout, step, "Execution of untrusted code on a privileged workflow."
