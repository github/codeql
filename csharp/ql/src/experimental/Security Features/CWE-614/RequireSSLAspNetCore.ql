/**
 * @name 'Secure' attribute is not set to true
 * @description Omitting the 'Secure' attribute allows data to be transmitted insecurely
 *              using HTTP. Always set 'Secure' to 'true' to ensure that HTTPS
 *              is used at all times.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cs/web/cookie-secure-not-set-aspnetcore
 * @tags security
 *       external/cwe/cwe-319
 *       external/cwe/cwe-614
 */

import csharp
import semmle.code.csharp.frameworks.microsoft.AspNetCore
import semmle.code.csharp.dataflow.flowsources.AuthCookie

from Call c
where
  // default is not configured or is not set to `Always` or `SameAsRequest`
  not (
    getAValueForCookiePolicyProp("Secure").getValue() = "0" or
    getAValueForCookiePolicyProp("Secure").getValue() = "1"
  ) and
  // there is no callback `OnAppendCookie` that sets `Secure` to true
  not exists(OnAppendCookieSecureTrackingConfig config, DataFlow::Node source, DataFlow::Node sink |
    config.hasFlow(source, sink)
  ) and
  (
    // `Secure` property in `CookieOptions` passed to IResponseCookies.Append(...) wasn't set
    exists(ObjectCreation oc |
      oc = c and
      oc.getType() instanceof MicrosoftAspNetCoreHttpCookieOptions and
      not isPropertySet(oc, "Secure") and
      exists(
        CookieOptionsTrackingConfiguration cookieTracking, DataFlow::Node creation,
        DataFlow::Node append
      |
        cookieTracking.hasFlow(creation, append) and
        creation.asExpr() = oc
      )
    )
    or
    // IResponseCookies.Append(String, String) was called, `Secure` is set to `false` by default
    exists(MethodCall mc, MicrosoftAspNetCoreHttpResponseCookies iResponse |
      mc = c and
      iResponse.getAppendMethod() = mc.getTarget() and
      mc.getNumberOfArguments() < 3
    )
  )
select c, "Cookie attribute 'Secure' is not set to true."
