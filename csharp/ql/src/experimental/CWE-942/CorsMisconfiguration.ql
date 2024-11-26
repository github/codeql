/**
 * @name CORS misconfiguration
 * @description Keeping an open CORS policy may result in security issues as third party website may be able to
 *              access other websites.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id cs/web/cors-misconfiguration
 * @tags security
 *       external/cwe/cwe-942
 */

import csharp
private import DataFlow
import semmle.code.csharp.frameworks.system.Web

/**
 * Holds if SetIsOriginAllowed always returns true. This sets the Access-Control-Allow-Origin to the requester
 */
private predicate functionAlwaysReturnsTrue(MethodCall mc) {
  mc.getTarget()
      .hasFullyQualifiedName("Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder",
        "SetIsOriginAllowed") and
  alwaysReturnsTrue(mc.getArgument(0))
}

/**
 * Holds if `c` always returns `true`.
 */
private predicate alwaysReturnsTrue(Callable c) {
  forex(ReturnStmt rs | rs.getEnclosingCallable() = c |
    rs.getExpr().(BoolLiteral).getBoolValue() = true
  )
  or
  c.getBody().(BoolLiteral).getBoolValue() = true
}

/**
 * Holds if the application uses a vulnerable CORS policy.
 */
private predicate hasDangerousOrigins(MethodCall m) {
  m.getTarget()
      .hasFullyQualifiedName("Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder",
        "WithOrigins") and
  m.getAnArgument().getValue() = ["null", "*"]
}

/**
 * Holds if the application allows an origin using "*" origin.
 */
private predicate allowAnyOrigin(MethodCall m) {
  m.getTarget()
      .hasFullyQualifiedName("Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder",
        "AllowAnyOrigin")
}

/**
 * Holds if UseCors is called with the revlevant cors policy
 */
private predicate configIsUsed(MethodCall add_policy) {
  exists(MethodCall uc |
    uc.getTarget()
        .hasFullyQualifiedName("Microsoft.AspNetCore.Builder.CorsMiddlewareExtensions", "UseCors") and
    (
      uc.getArgument(1).getValue() = add_policy.getArgument(0).getValue() or
      localFlow(DataFlow::exprNode(add_policy.getArgument(0)), DataFlow::exprNode(uc.getArgument(1)))
    )
  )
}

from MethodCall add_policy, MethodCall m
where
  (
    add_policy
        .getTarget()
        .hasFullyQualifiedName("Microsoft.AspNetCore.Cors.Infrastructure.CorsOptions", "AddPolicy") and
    add_policy.getArgument(1) = m.getParent*() and
    configIsUsed(add_policy)
    or
    add_policy
        .getTarget()
        .hasFullyQualifiedName("Microsoft.AspNetCore.Cors.Infrastructure.CorsOptions",
          "AddDefaultPolicy") and
    add_policy.getArgument(0) = m.getParent*()
  ) and
  (hasDangerousOrigins(m) or allowAnyOrigin(m) or functionAlwaysReturnsTrue(m))
select add_policy, "The following CORS policy may be vulnerable to 3rd party websites"
