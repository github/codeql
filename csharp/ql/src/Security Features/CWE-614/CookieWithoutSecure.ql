/**
 * @name Cookie 'Secure' attribute is not set to true
 * @description Cookies without the `Secure` flag may be sent in cleartext.
 *              This makes them vulnerable to be intercepted by an attacker.
 * @kind problem
 * @problem.severity error
 * @security-severity 5.0
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
import semmle.code.csharp.security.auth.SecureCookies

predicate cookieAppendSecureByDefault() {
  // default is set to `Always` or `SameAsRequest`
  (
    getAValueForCookiePolicyProp("Secure").getValue() = "0" or
    getAValueForCookiePolicyProp("Secure").getValue() = "1"
  )
  or
  //callback `OnAppendCookie` that sets `Secure` to true
  OnAppendCookieSecureTracking::flowTo(_)
}

predicate secureFalse(ObjectCreation oc) {
  exists(Assignment a |
    getAValueForProp(oc, a, "Secure") = a.getRValue() and
    a.getRValue().getValue() = "false"
  )
}

predicate secureFalseOrNotSet(ObjectCreation oc) {
  secureFalse(oc)
  or
  not isPropertySet(oc, "Secure")
}

predicate insecureCookieOptionsCreation(ObjectCreation oc) {
  // `Secure` property in `CookieOptions` passed to IResponseCookies.Append(...) wasn't set
  oc.getType() instanceof MicrosoftAspNetCoreHttpCookieOptions and
  secureFalseOrNotSet(oc) and
  CookieOptionsTracking::flowFromExpr(oc)
}

predicate insecureCookieAppend(Expr sink) {
  // IResponseCookies.Append(String, String) was called, `Secure` is set to `false` by default
  exists(MethodCall mc, MicrosoftAspNetCoreHttpResponseCookies iResponse |
    mc = sink and
    iResponse.getAppendMethod() = mc.getTarget() and
    mc.getNumberOfArguments() < 3 and
    mc.getTarget().getParameter(0).getType() instanceof StringType
  )
}

predicate insecureSystemWebCookieCreation(ObjectCreation oc) {
  oc.getType() instanceof SystemWebHttpCookie and
  (
    secureFalse(oc)
    or
    // `Secure` property in `System.Web.HttpCookie` wasn't set, so a default value from config is used
    not isPropertySet(oc, "Secure") and
    // the default in config is not set to `true`
    not exists(XmlElement element |
      element instanceof FormsElement and
      element.(FormsElement).isRequireSsl()
      or
      element instanceof HttpCookiesElement and
      element.(HttpCookiesElement).isRequireSsl()
    )
  )
}

predicate insecureCookieCall(Call c) {
  not cookieAppendSecureByDefault() and
  (
    insecureCookieOptionsCreation(c)
    or
    insecureCookieAppend(c)
  )
  or
  insecureSystemWebCookieCreation(c)
}

predicate insecureSecurePolicyAssignment(Assignment a, Expr val) {
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
}

from Expr secureSink
where
  insecureCookieCall(secureSink)
  or
  exists(Assignment a |
    secureSink = a.getRValue() and
    insecureSecurePolicyAssignment(a, _)
  )
select secureSink, "Cookie attribute 'Secure' is not set to true."
