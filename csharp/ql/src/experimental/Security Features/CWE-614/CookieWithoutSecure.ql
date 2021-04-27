/**
 * @name 'Secure' attribute is not set to true
 * @description Omitting the 'Secure' attribute allows data to be transmitted insecurely
 *              using HTTP. Always set 'Secure' to 'true' to ensure that HTTPS
 *              is used at all times.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/web/cookie-secure-not-set
 * @tags security
 *       external/cwe/cwe-319
 *       external/cwe/cwe-614
 */

import csharp
import semmle.code.asp.WebConfig
import semmle.code.csharp.frameworks.system.Web
import semmle.code.csharp.frameworks.microsoft.AspNetCore
import experimental.dataflow.flowsources.AuthCookie

from Expr secureSink
where
  exists(Call c |
    secureSink = c and
    (
      // default is not configured or is not set to `Always` or `SameAsRequest`
      not (
        getAValueForCookiePolicyProp("Secure").getValue() = "0" or
        getAValueForCookiePolicyProp("Secure").getValue() = "1"
      ) and
      // there is no callback `OnAppendCookie` that sets `Secure` to true
      not exists(
        OnAppendCookieSecureTrackingConfig config, DataFlow::Node source, DataFlow::Node sink
      |
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
      or
      exists(ObjectCreation oc |
        oc = c and
        oc.getType() instanceof SystemWebHttpCookie and
        // the property wasn't explicitly set, so a default value from config is used
        not isPropertySet(oc, "Secure") and
        // the default in config is not set to `true`
        // the `exists` below covers the `cs/web/requiressl-not-set`
        not exists(XMLElement element |
          element instanceof FormsElement and
          element.(FormsElement).isRequireSSL()
          or
          element instanceof HttpCookiesElement and
          element.(HttpCookiesElement).isRequireSSL()
        )
      )
    )
  )
  or
  exists(Assignment a, Expr val |
    secureSink = a.getRValue() and
    (
      exists(ObjectCreation oc |
        getAValueForProp(oc, a, "Secure") = val and
        val.getValue() = "false" and
        (
          oc.getType() instanceof SystemWebHttpCookie
          or
          oc.getType() instanceof MicrosoftAspNetCoreHttpCookieOptions and
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
    )
  )
select secureSink, "Cookie attribute 'Secure' is not set to true."
