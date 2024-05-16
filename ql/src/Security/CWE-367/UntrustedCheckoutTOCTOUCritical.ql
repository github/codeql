/**
 * @name Untrusted Checkout TOCTOU
 * @description Untrusted Checkout is protected by a security check but the checked-out branch can be changed after the check.
 * @kind problem
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

from ControlCheck check, MutableRefCheckoutStep checkout
where
  // the mutable checkout step is protected by an access check
  check = [checkout.getIf(), checkout.getEnclosingJob().getIf()] and
  // the checked-out code may lead to arbitrary code execution
  checkout.getAFollowingStep() instanceof PoisonableStep and
  (
    // label gates do not depend on the triggering event
    check instanceof LabelControlCheck
    or
    // actor or Association gates apply to IssueOps only
    (check instanceof AssociationControlCheck or check instanceof ActorControlCheck) and
    check.getEnclosingJob().getATriggerEvent().getName().matches("%_comment")
  )
select checkout, "The checked-out code can be changed after the authorization check o step $@.",
  check, check.toString()
