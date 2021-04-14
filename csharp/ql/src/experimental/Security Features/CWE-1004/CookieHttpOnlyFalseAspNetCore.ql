/**
 * @name 'HttpOnly' attribute is set to false
 * @description Setting 'HttpOnly' attribute to false for security sensitive data allows
 *              malicious JavaScript to steal it in case of XSS vulnerability. Always set
 *              'HttpOnly' to 'true' to authentication related cookie to make it
 *              not accessible by JavaScript.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/web/cookie-httponly-false-aspnetcore
 * @tags security
 *       external/cwe/cwe-1004
 */

import csharp
import semmle.code.csharp.frameworks.microsoft.AspNetCore
import semmle.code.csharp.dataflow.flowsources.AuthCookie

from Expr val, Assignment a
where
  exists(ObjectCreation oc, MethodCall mc, MicrosoftAspNetCoreHttpResponseCookies iResponse |
    iResponse.getAppendMethod() = mc.getTarget() and
    oc.getType() instanceof MicrosoftAspNetCoreHttpCookieOptions and
    getAValueForProp(oc, a, "HttpOnly") = val and
    val.getValue() = "false" and
    // there is no callback `OnAppendCookie` that sets `HttpOnly` to true
    not exists(
      OnAppendCookieHttpOnlyTrackingConfig config, DataFlow::Node source, DataFlow::Node sink
    |
      config.hasFlow(source, sink)
    ) and
    isCookieWithSensitiveName(mc.getArgument(0)) and
    // Passed as third argument to `IResponseCookies.Append`
    exists(
      CookieOptionsTrackingConfiguration cookieTracking, DataFlow::Node creation,
      DataFlow::Node append
    |
      cookieTracking.hasFlow(creation, append) and
      creation.asExpr() = oc and
      append.asExpr() = mc.getArgument(2)
    )
  )
  or
  exists(PropertyWrite pw |
    (
      pw.getProperty().getDeclaringType() instanceof MicrosoftAspNetCoreHttpCookieBuilder or
      pw.getProperty().getDeclaringType() instanceof
        MicrosoftAspNetCoreAuthenticationCookiesCookieAuthenticationOptions
    ) and
    pw.getProperty().getName() = "HttpOnly" and
    a.getLValue() = pw and
    DataFlow::localExprFlow(val, a.getRValue()) and
    val.getValue() = "false"
  )
select a.getRValue(), "Cookie attribute 'HttpOnly' is set to false."
