/**
 * @name Checkout of untrusted code in trusted context
 * @description Privileged workflows have read/write access to the base repository and access to secrets.
 *              By explicitly checking out and running the build script from a fork the untrusted code is running in an environment
 *              that is able to push to the base repository and to access secrets.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @security-severity 5.0
 * @id actions/untrusted-checkout/medium
 * @tags actions
 *       security
 *       external/cwe/cwe-829
 */

import actions
import codeql.actions.security.UntrustedCheckoutQuery

from PRHeadCheckoutStep checkout
where
  // the checkout occurs in a non-privileged context
  inNonPrivilegedContext(checkout)
select checkout, "Potential unsafe checkout of untrusted pull request on privileged workflow."
