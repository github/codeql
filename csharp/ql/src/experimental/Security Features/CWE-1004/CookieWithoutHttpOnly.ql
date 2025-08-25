/**
 * @name 'HttpOnly' attribute is not set to true
 * @description Omitting the 'HttpOnly' attribute for security sensitive data allows
 *              malicious JavaScript to steal it in case of XSS vulnerability. Always set
 *              'HttpOnly' to 'true' to authentication related cookie to make it
 *              not accessible by JavaScript.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/web/cookie-httponly-not-set
 * @tags security
 *       experimental
 *       external/cwe/cwe-1004
 */

import csharp
import semmle.code.asp.WebConfig
import semmle.code.csharp.frameworks.system.Web
import semmle.code.csharp.frameworks.microsoft.AspNetCore
deprecated import experimental.dataflow.flowsources.AuthCookie

deprecated query predicate problems(Expr httpOnlySink, string message) {
  (
    exists(Assignment a, Expr val |
      httpOnlySink = a.getRValue() and
      val.getValue() = "false" and
      (
        exists(ObjectCreation oc |
          getAValueForProp(oc, a, "HttpOnly") = val and
          (
            oc.getType() instanceof SystemWebHttpCookie and
            isCookieWithSensitiveName(oc.getArgument(0))
            or
            exists(MethodCall mc, MicrosoftAspNetCoreHttpResponseCookies iResponse |
              oc.getType() instanceof MicrosoftAspNetCoreHttpCookieOptions and
              iResponse.getAppendMethod() = mc.getTarget() and
              isCookieWithSensitiveName(mc.getArgument(0)) and
              // there is no callback `OnAppendCookie` that sets `HttpOnly` to true
              not OnAppendCookieHttpOnlyTracking::flowTo(_) and
              // Passed as third argument to `IResponseCookies.Append`
              exists(DataFlow::Node creation, DataFlow::Node append |
                CookieOptionsTracking::flow(creation, append) and
                creation.asExpr() = oc and
                append.asExpr() = mc.getArgument(2)
              )
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
          pw.getProperty().getName() = "HttpOnly" and
          a.getLValue() = pw and
          DataFlow::localExprFlow(val, a.getRValue())
        )
      )
    )
    or
    exists(Call c |
      httpOnlySink = c and
      (
        exists(MicrosoftAspNetCoreHttpResponseCookies iResponse, MethodCall mc |
          // default is not configured or is not set to `Always`
          not getAValueForCookiePolicyProp("HttpOnly").getValue() = "1" and
          // there is no callback `OnAppendCookie` that sets `HttpOnly` to true
          not OnAppendCookieHttpOnlyTracking::flowTo(_) and
          iResponse.getAppendMethod() = mc.getTarget() and
          isCookieWithSensitiveName(mc.getArgument(0)) and
          (
            // `HttpOnly` property in `CookieOptions` passed to IResponseCookies.Append(...) wasn't set
            exists(ObjectCreation oc |
              oc = c and
              oc.getType() instanceof MicrosoftAspNetCoreHttpCookieOptions and
              not isPropertySet(oc, "HttpOnly") and
              exists(DataFlow::Node creation |
                CookieOptionsTracking::flow(creation, _) and
                creation.asExpr() = oc
              )
            )
            or
            // IResponseCookies.Append(String, String) was called, `HttpOnly` is set to `false` by default
            mc = c and
            mc.getNumberOfArguments() < 3
          )
        )
        or
        exists(ObjectCreation oc |
          oc = c and
          oc.getType() instanceof SystemWebHttpCookie and
          isCookieWithSensitiveName(oc.getArgument(0)) and
          // the property wasn't explicitly set, so a default value from config is used
          not isPropertySet(oc, "HttpOnly") and
          // the default in config is not set to `true`
          not exists(XmlElement element |
            element instanceof HttpCookiesElement and
            element.(HttpCookiesElement).isHttpOnlyCookies()
          )
        )
      )
    )
  ) and
  message = "Cookie attribute 'HttpOnly' is not set to true."
}
