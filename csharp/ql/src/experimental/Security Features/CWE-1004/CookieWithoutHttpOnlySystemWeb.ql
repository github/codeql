/**
 * @name 'HttpOnly' attribute is not set to true
 * @description Omitting the 'HttpOnly' attribute for security sensitive data allows
 *              malicious JavaScript to steal it in case of XSS vulnerability. Always set
 *              'HttpOnly' to 'true' to authentication related cookie to make it
 *              not accessible by JavaScript.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/web/httponly-not-set-aspnet
 * @tags security
 *       external/cwe/cwe-1004
 */

import csharp
import semmle.code.asp.WebConfig
import semmle.code.csharp.frameworks.system.Web
import semmle.code.csharp.dataflow.flowsources.AuthCookie

from ObjectCreation oc
where
  oc.getType() instanceof SystemWebHttpCookie and
  // the property wasn't explicitly set, so a default value from config is used
  not isPropertySet(oc, "HttpOnly") and
  // the default in config is not set to `true`
  not exists(XMLElement element |
    element instanceof HttpCookiesElement and
    element.(HttpCookiesElement).isHttpOnlyCookies()
  ) and
  // it is a cookie with a sensitive name
  exists(AuthCookieNameConfiguration dataflow, DataFlow::Node source, DataFlow::Node sink |
    dataflow.hasFlow(source, sink) and
    sink.asExpr() = oc.getArgument(0)
  )
select oc, "Cookie attribute 'HttpOnly' is not set to true."
