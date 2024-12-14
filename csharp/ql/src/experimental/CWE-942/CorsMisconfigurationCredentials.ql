/**
 * @name Credentialed CORS Misconfiguration
 * @description Allowing any origin while allowing credentials may result in security issues as third party website may be able to
 *              access private resources.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id cs/web/cors-misconfiguration-credentials
 * @tags security
 *       external/cwe/cwe-942
 */

import csharp
import CorsMisconfigurationLib

/** A call to `CorsPolicyBuilder.AllowCredentials`. */
class AllowsCredentials extends MethodCall {
  AllowsCredentials() {
    this.getTarget()
        .hasFullyQualifiedName("Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder",
          "AllowCredentials")
  }
}

from MethodCall add_policy, MethodCall setIsOriginAllowed, AllowsCredentials allowsCredentials
where
  (
    add_policy.getArgument(1) = setIsOriginAllowed.getParent*() and
    usedPolicy(add_policy) and
    add_policy.getArgument(1) = allowsCredentials.getParent*()
    or
    add_policy
        .getTarget()
        .hasFullyQualifiedName("Microsoft.AspNetCore.Cors.Infrastructure.CorsOptions",
          "AddDefaultPolicy") and
    add_policy.getArgument(0) = setIsOriginAllowed.getParent*() and
    add_policy.getArgument(0) = allowsCredentials.getParent*()
  ) and
  setIsOriginAllowedReturnsTrue(setIsOriginAllowed)
select add_policy,
  "The following CORS policy may allow credentialed requests from 3rd party websites"
