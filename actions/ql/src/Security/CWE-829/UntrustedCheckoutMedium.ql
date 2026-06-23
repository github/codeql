/**
 * @name Checkout of untrusted code in a non-privileged context
 * @description Checking out and running the build script from a fork executes untrusted code. Even in a
 *              non-privileged workflow, this can be abused, for example to compromise self-hosted runners
 *              or to poison caches and artifacts that are later consumed by privileged workflows.
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
select checkout, "Potential unsafe checkout of untrusted pull request on non-privileged workflow."
