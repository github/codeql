/**
 * @name Checkout of untrusted code in trusted context
 * @description Priveleged workflows have read/write access to the base repository and access to secrets.
 *              By explicitly checking out and running the build script from a fork the untrusted code is running in an environment
 *              that is able to push to the base repository and to access secrets.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @security-severity 5.3
 * @id actions/untrusted-checkout/high
 * @tags actions
 *       security
 *       external/cwe/cwe-829
 */

import actions
import codeql.actions.security.UntrustedCheckoutQuery
import codeql.actions.security.PoisonableSteps

from LocalJob j, PRHeadCheckoutStep checkout
where
  j = checkout.getEnclosingJob() and
  j.getAStep() = checkout and
  not checkout.getAFollowingStep() instanceof PoisonableStep and
  not exists(ControlCheck check |
    checkout.getIf() = check or checkout.getEnclosingJob().getIf() = check
  ) and
  (
    inPrivilegedCompositeAction(checkout)
    or
    inPrivilegedExternallyTriggerableJob(checkout)
  )
select checkout, "Potential unsafe checkout of untrusted pull request on privileged workflow."
