/**
 * @name 'Secure' attribute is set to false
 * @description Omitting the 'Secure' attribute allows data to be transmitted insecurely
 *              using HTTP. Always set 'Secure' to 'true' to ensure that HTTPS
 *              is used at all times.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/web/cookie-secure-false-aspnetcore
 * @tags security
 *       external/cwe/cwe-319
 *       external/cwe/cwe-614
 */

import csharp
import semmle.code.csharp.frameworks.microsoft.AspNetCore
import semmle.code.csharp.dataflow.flowsources.AuthCookie

from Expr val, Assignment a
where
  exists(ObjectCreation oc |
    // Cookie option `Secure` is set to `false`
    oc.getType() instanceof MicrosoftAspNetCoreHttpCookieOptions and
    getAValueForProp(oc, a, "Secure") = val and
    val.getValue() = "false" and
    // there is no callback `OnAppendCookie` that sets `Secure` to true
    not exists(
      OnAppendCookieSecureTrackingConfig config, DataFlow::Node source, DataFlow::Node sink
    |
      config.hasFlow(source, sink)
    ) and
    // the cookie option is passed to `Append`
    exists(
      CookieOptionsTrackingConfiguration cookieTracking, DataFlow::Node creation,
      DataFlow::Node append
    |
      cookieTracking.hasFlow(creation, append) and
      creation.asExpr() = oc
    )
  )
  or
  exists(PropertyWrite pw |
    (
      pw.getProperty().getDeclaringType() instanceof MicrosoftAspNetCoreHttpCookieBuilder or
      pw.getProperty().getDeclaringType() instanceof
        MicrosoftAspNetCoreAuthenticationCookiesCookieAuthenticationOptions
    ) and
    pw.getProperty().getName() = "SecurePolicy" and
    a.getLValue() = pw and
    DataFlow::localExprFlow(val, a.getRValue()) and
    val.getValue() = "2" // None
  )
select a.getRValue(), "Cookie attribute 'Secure' is set to false."
