/**
 * @name Credentialed CORS Misconfiguration
 * @description Allowing any origin while allowing credentials may result in security issues as third party website may be able to
 *              access private resources.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id cs/web/cors-misconfiguration
 * @tags security
 *       external/cwe/cwe-942
 */

import csharp
import CorsMisconfigurationLib

/**
 * Holds if the application allows an origin using "*" origin.
 */
private predicate allowAnyOrigin(MethodCall m) {
  m.getTarget()
      .hasFullyQualifiedName("Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder",
        "AllowAnyOrigin")
}

/**
 * Holds if the application uses a vulnerable CORS policy.
 */
private predicate hasDangerousOrigins(MethodCall m) {
  m.getTarget()
      .hasFullyQualifiedName("Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder",
        "WithOrigins") and
  exists(StringLiteral idStr |
    idStr.getValue().toLowerCase().matches(["null", "*"]) and
    TaintTracking::localExprTaint(idStr, m.getAnArgument())
  )
}

from MethodCall add_policy, MethodCall child
where
  (
    usedPolicy(add_policy) and
    // Misconfigured origin affects used policy
    getCallableFromExpr(add_policy.getArgument(1)).calls*(child.getTarget())
    or
    add_policy
        .getTarget()
        .hasFullyQualifiedName("Microsoft.AspNetCore.Cors.Infrastructure.CorsOptions",
          "AddDefaultPolicy") and
    // Misconfigured origin affects added default policy
    getCallableFromExpr(add_policy.getArgument(0)).calls*(child.getTarget())
  ) and
  (hasDangerousOrigins(child) or allowAnyOrigin(child))
select add_policy, "The following CORS policy may allow requests from 3rd party websites"
