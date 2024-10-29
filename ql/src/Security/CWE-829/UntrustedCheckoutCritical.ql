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

from PRHeadCheckoutStep checkout, PoisonableStep poisonable, Event event
where
  // the checkout is followed by a known poisonable step
  checkout.getAFollowingStep() = poisonable and
  (
    poisonable instanceof Run and
    (
      // Check if the poisonable step is a local script execution step
      // and the path of the command or script matches the path of the downloaded artifact
      isSubpath(poisonable.(LocalScriptExecutionRunStep).getPath(), checkout.getPath())
      or
      // Checking the path for non local script execution steps is very difficult
      not poisonable instanceof LocalScriptExecutionRunStep
      // Its not easy to extract the path from a non-local script execution step so skipping this check for now
      // and isSubpath(poisonable.(Run).getWorkingDirectory(), checkout.getPath())
    )
    or
    poisonable instanceof UsesStep and
    (
      not poisonable instanceof LocalActionUsesStep and
      checkout.getPath() = "GITHUB_WORKSPACE/"
      or
      isSubpath(poisonable.(LocalActionUsesStep).getPath(), checkout.getPath())
    )
  ) and
  // the checkout occurs in a privileged context
  inPrivilegedContext(poisonable, event) and
  inPrivilegedContext(checkout, event) and
  event.getName() = checkoutTriggers() and
  not exists(ControlCheck check | check.protects(checkout, event, "untrusted-checkout")) and
  not exists(ControlCheck check | check.protects(poisonable, event, "untrusted-checkout"))
select poisonable, checkout, poisonable,
  "Potential execution of untrusted code on a privileged workflow ($@)", event, event.getName()
