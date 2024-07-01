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

from MutableRefCheckoutStep checkout, ControlCheck check
where
  // the checkout occurs in a privileged context
  (
    inPrivilegedCompositeAction(checkout)
    or
    inPrivilegedExternallyTriggerableJob(checkout)
  ) and
  // there are no evidences that the checked-out gets executed
  not checkout.getAFollowingStep() instanceof PoisonableStep and
  // the mutable checkout step is protected by an access check
  check.dominates(checkout) and
  (
    // environment gates do not depend on the triggering event
    check instanceof EnvironmentCheck
    or
    // label gates do not depend on the triggering event
    check instanceof LabelCheck
    or
    // actor or association gates are only bypassable for IssueOps
    // since an attacker can wait for a privileged user to comment on an issue
    // and then mutate the checked-out code.
    // however, when used for pull_request_target, the check is not bypassable since
    // the actor checked is the author of the PR
    (
      check instanceof AssociationCheck or
      check instanceof ActorCheck or
      check instanceof PermissionCheck
    ) and
    check.getEnclosingJob().getATriggerEvent().getName().matches("%_comment")
  )
select checkout,
  "Insufficient protection against execution of untrusted code on a privileged workflow on step $@.",
  check, check.toString()
