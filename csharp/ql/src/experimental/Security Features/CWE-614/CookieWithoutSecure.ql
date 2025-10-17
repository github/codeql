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
 *       experimental
 *       external/cwe/cwe-319
 *       external/cwe/cwe-614
 */

import csharp
import semmle.code.asp.WebConfig
import semmle.code.csharp.frameworks.system.Web
import semmle.code.csharp.frameworks.microsoft.AspNetCore
import experimental.dataflow.flowsources.AuthCookie

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

predicate secureFalseOrNotSet(ObjectCreation oc) {
  exists(Assignment a |
    getAValueForProp(oc, a, "Secure") = a.getRValue() and
    a.getRValue().getValue() = "false"
  )
  or
  not isPropertySet(oc, "Secure")
}

predicate insecureCookieOptionsCreation(ObjectCreation oc) {
  // `Secure` property in `CookieOptions` passed to IResponseCookies.Append(...) wasn't set
  oc.getType() instanceof MicrosoftAspNetCoreHttpCookieOptions and
  secureFalseOrNotSet(oc) and
  exists(DataFlow::Node creation |
    CookieOptionsTracking::flow(creation, _) and
    creation.asExpr() = oc
  )
}

predicate insecureCookieAppend(Expr sink) {
  // IResponseCookies.Append(String, String) was called, `Secure` is set to `false` by default
  exists(MethodCall mc, MicrosoftAspNetCoreHttpResponseCookies iResponse |
    mc = sink and
    iResponse.getAppendMethod() = mc.getTarget() and
    mc.getNumberOfArguments() < 3
  )
}

predicate insecureCookieCreationFromConfig(Expr sink) {
  // `Secure` property in `System.Web.HttpCookie` wasn't set, so a default value from config is used
  exists(ObjectCreation oc |
    oc = sink and
    oc.getType() instanceof SystemWebHttpCookie and
    not isPropertySet(oc, "Secure") and
    // the default in config is not set to `true`
    // the `exists` below covers the `cs/web/requiressl-not-set`
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
  insecureCookieCreationFromConfig(c)
}

// predicate insecureCookieCreationAssignment(Assignment a, Expr val) {
//   exists(ObjectCreation oc |
//     getAValueForProp(oc, a, "Secure") = val and
//     val.getValue() = "false" and
//     (
//       oc.getType() instanceof SystemWebHttpCookie
//       or
//       oc.getType() instanceof MicrosoftAspNetCoreHttpCookieOptions and
//       // there is no callback `OnAppendCookie` that sets `Secure` to true
//       not OnAppendCookieSecureTracking::flowTo(_) and
//       // the cookie option is passed to `Append`
//       exists(DataFlow::Node creation |
//         CookieOptionsTracking::flow(creation, _) and
//         creation.asExpr() = oc
//       )
//     )
//   )
// }
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
