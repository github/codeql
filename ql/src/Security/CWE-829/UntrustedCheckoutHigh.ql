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

from PRHeadCheckoutStep checkout
where
  // the checkout is NOT followed by a known poisonable step
  not checkout.getAFollowingStep() instanceof PoisonableStep and
  // the checkout occurs in a privileged context
  inPrivilegedContext(checkout) and
  (
    // issue_comment: check for date comparison checks and actor/access control checks
    exists(Event e |
      e.getName() = "issue_comment" and
      checkout.getEnclosingJob().getATriggerEvent() = e and
      not exists(ControlCheck write_check, CommentVsHeadDateCheck data_check |
        (write_check instanceof ActorCheck or write_check instanceof AssociationCheck) and
        write_check.dominates(checkout) and
        data_check.dominates(checkout)
      )
    )
    or
    // not issue_comment triggered workflows
    exists(Event event |
      not event.getName() = "issue_comment" and
      not exists(ControlCheck check |
        check
            .protects(checkout, checkout.getEnclosingJob().getATriggerEvent(), "untrusted-checkout")
      )
    )
  )
select checkout, "Potential execution of untrusted code on a privileged workflow."
