/**
 * @name 'HttpOnly' attribute is set to false
 * @description Setting 'HttpOnly' attribute to false for security sensitive data allows
 *              malicious JavaScript to steal it in case of XSS vulnerability. Always set
 *              'HttpOnly' to 'true' to authentication related cookie to make it
 *              not accessible by JavaScript.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/web/cookie-httponly-false-aspnet
 * @tags security
 *       external/cwe/cwe-1004
 */

import csharp
import semmle.code.csharp.frameworks.system.Web
import semmle.code.csharp.dataflow.flowsources.AuthCookie

from ObjectCreation oc, Expr val, Assignment a
where
  getAValueForProp(oc, a, "HttpOnly") = val and
  val.getValue() = "false" and
  oc.getType() instanceof SystemWebHttpCookie and
  // It is a sensitive cookie name
  exists(AuthCookieNameConfiguration dataflow, DataFlow::Node source, DataFlow::Node sink |
    dataflow.hasFlow(source, sink) and
    sink.asExpr() = oc.getArgument(0)
  )
select a.getRValue(), "Cookie attribute 'HttpOnly' is set to false."
