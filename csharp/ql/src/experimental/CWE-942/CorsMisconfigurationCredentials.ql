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
private import DataFlow
import semmle.code.csharp.frameworks.system.Web

/**
 * Holds if credentials are allowed
 */
private predicate allowsCredentials(MethodCall credentials) {
  credentials
      .getTarget()
      .hasFullyQualifiedName("Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder",
        "AllowCredentials")
}

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
 * Holds if UseCors is called with the revlevant cors policy
 */
private predicate configIsUsed(MethodCall add_policy) {
  exists(MethodCall uc |
    uc.getTarget()
        .hasFullyQualifiedName("Microsoft.AspNetCore.Builder.CorsMiddlewareExtensions", "UseCors") and
    (
      uc.getArgument(1).getValue() = add_policy.getArgument(0).getValue() or
      uc.getArgument(1).(VariableAccess).getTarget() =
        add_policy.getArgument(0).(VariableAccess).getTarget() or
      localFlow(DataFlow::exprNode(add_policy.getArgument(0)), DataFlow::exprNode(uc.getArgument(1)))
    )
  )
}

from MethodCall add_policy, MethodCall m, MethodCall allowsCredentials
where
  (
    add_policy
        .getTarget()
        .hasFullyQualifiedName("Microsoft.AspNetCore.Cors.Infrastructure.CorsOptions", "AddPolicy") and
    add_policy.getArgument(1) = m.getParent*() and
    configIsUsed(add_policy) and
    add_policy.getArgument(1) = allowsCredentials.getParent*()
    or
    add_policy
        .getTarget()
        .hasFullyQualifiedName("Microsoft.AspNetCore.Cors.Infrastructure.CorsOptions",
          "AddDefaultPolicy") and
    add_policy.getArgument(0) = m.getParent*() and
    add_policy.getArgument(0) = allowsCredentials.getParent*()
  ) and
  (allowsCredentials(allowsCredentials) and functionAlwaysReturnsTrue(m))
select add_policy,
  "The following CORS policy may allow credentialed requests from 3rd party websites"
