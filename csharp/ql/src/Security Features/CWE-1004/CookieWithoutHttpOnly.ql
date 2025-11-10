/**
 * @name Cookie 'HttpOnly' attribute is not set to true
 * @description Sensitive cookies without the `HttpOnly` property set are accessible by client-side scripts such as JavaScript.
 *              This makes them more vulnerable to being stolen by an XSS attack.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id cs/web/cookie-httponly-not-set
 * @tags security
 *       external/cwe/cwe-1004
 */

import csharp
import semmle.code.asp.WebConfig
import semmle.code.csharp.frameworks.system.Web
import semmle.code.csharp.frameworks.microsoft.AspNetCore
import semmle.code.csharp.security.auth.SecureCookies

predicate cookieAppendHttpOnlyByDefault() {
  // default is set to `Always`
  getAValueForCookiePolicyProp("HttpOnly").getValue() = "1"
  or
  // there is an `OnAppendCookie` callback that sets `HttpOnly` to true
  OnAppendCookieHttpOnlyTracking::flowTo(_)
}

predicate httpOnlyFalse(ObjectCreation oc) {
  exists(Assignment a |
    getAValueForProp(oc, a, "HttpOnly") = a.getRValue() and
    a.getRValue().getValue() = "false"
  )
}

predicate httpOnlyFalseOrNotSet(ObjectCreation oc) {
  httpOnlyFalse(oc)
  or
  not isPropertySet(oc, "HttpOnly")
}

predicate nonHttpOnlyCookieOptionsCreation(ObjectCreation oc, MethodCall append) {
  // `HttpOnly` property in `CookieOptions` passed to IResponseCookies.Append(...) wasn't set
  oc.getType() instanceof MicrosoftAspNetCoreHttpCookieOptions and
  httpOnlyFalseOrNotSet(oc) and
  exists(DataFlow::Node creation, DataFlow::Node sink |
    CookieOptionsTracking::flow(creation, sink) and
    creation.asExpr() = oc and
    sink.asExpr() = append.getArgument(2)
  )
}

predicate nonHttpOnlySystemWebSensitiveCookieCreation(ObjectCreation oc) {
  oc.getType() instanceof SystemWebHttpCookie and
  isCookieWithSensitiveName(oc.getArgument(0)) and
  (
    httpOnlyFalse(oc)
    or
    // the property wasn't explicitly set, so a default value from config is used
    not isPropertySet(oc, "HttpOnly") and
    // the default in config is not set to `true`
    not exists(XmlElement element |
      element instanceof HttpCookiesElement and
      element.(HttpCookiesElement).isHttpOnlyCookies()
    )
  )
}

predicate sensitiveCookieAppend(MethodCall mc) {
  exists(MicrosoftAspNetCoreHttpResponseCookies iResponse |
    iResponse.getAppendMethod() = mc.getTarget() and
    isCookieWithSensitiveName(mc.getArgument(0))
  )
}

predicate nonHttpOnlyCookieCall(Call c) {
  (
    not cookieAppendHttpOnlyByDefault() and
    exists(MethodCall mc |
      sensitiveCookieAppend(mc) and
      (
        nonHttpOnlyCookieOptionsCreation(c, mc)
        or
        // IResponseCookies.Append(String, String) was called, `HttpOnly` is set to `false` by default
        mc = c and
        mc.getNumberOfArguments() < 3 and
        mc.getTarget().getParameter(0).getType() instanceof StringType
      )
    )
    or
    nonHttpOnlySystemWebSensitiveCookieCreation(c)
  )
}

predicate nonHttpOnlyCookieBuilderAssignment(Assignment a, Expr val) {
  val.getValue() = "false" and
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
}

from Expr httpOnlySink
where
  (
    nonHttpOnlyCookieCall(httpOnlySink)
    or
    exists(Assignment a |
      httpOnlySink = a.getRValue() and
      nonHttpOnlyCookieBuilderAssignment(a, _)
    )
  )
select httpOnlySink, "Cookie attribute 'HttpOnly' is not set to true."
