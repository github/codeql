/**
 * @name 'HttpOnly' attribute is not set to true
 * @description Omitting the 'HttpOnly' attribute for security sensitive data allows
 *              malicious JavaScript to steal it in case of XSS vulnerability. Always set
 *              'HttpOnly' to 'true' to authentication related cookie to make it
 *              not accessible by JavaScript.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/web/httponly-possibly-not-set-aspnetcore
 * @tags security
 *       external/cwe/cwe-1004
 */

import csharp
import semmle.code.csharp.frameworks.microsoft.AspNetCore
import semmle.code.csharp.dataflow.flowsources.AuthCookie

from Call c, MicrosoftAspNetCoreHttpResponseCookies iResponse, MethodCall mc
where
  // default is not configured or is not set to `Always`
  not getAValueForCookiePolicyProp("HttpOnly").getValue() = "1" and
  // there is no callback `OnAppendCookie` that sets `HttpOnly` to true
  not exists(
    OnAppendCookieHttpOnlyTrackingConfig config, DataFlow::Node source, DataFlow::Node sink
  |
    config.hasFlow(source, sink)
  ) and
  iResponse.getAppendMethod() = mc.getTarget() and
  isCookieWithSensitiveName(mc.getArgument(0)) and
  (
    // `HttpOnly` property in `CookieOptions` passed to IResponseCookies.Append(...) wasn't set
    exists(ObjectCreation oc |
      oc = c and
      oc.getType() instanceof MicrosoftAspNetCoreHttpCookieOptions and
      not isPropertySet(oc, "HttpOnly") and
      exists(
        CookieOptionsTrackingConfiguration cookieTracking, DataFlow::Node creation,
        DataFlow::Node append
      |
        cookieTracking.hasFlow(creation, append) and
        creation.asExpr() = oc
      )
    )
    or
    // IResponseCookies.Append(String, String) was called, `HttpOnly` is set to `false` by default
    mc = c and
    mc.getNumberOfArguments() < 3 and
    isCookieWithSensitiveName(mc.getArgument(0))
  )
select c, "Cookie attribute 'HttpOnly' is not set to true."
