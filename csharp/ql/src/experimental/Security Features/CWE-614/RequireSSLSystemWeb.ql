/**
 * @name 'Secure' attribute is not set to true
 * @description Omitting the 'Secure' attribute allows data to be transmitted insecurely
 *              using HTTP. Always set 'Secure' to 'true' to ensure that HTTPS
 *              is used at all times.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/web/cookie-secure-not-set-aspnet
 * @tags security
 *       external/cwe/cwe-319
 *       external/cwe/cwe-614
 */

import csharp
import semmle.code.asp.WebConfig
import semmle.code.csharp.frameworks.system.Web
import semmle.code.csharp.dataflow.flowsources.AuthCookie

from ObjectCreation oc
where
  oc.getType() instanceof SystemWebHttpCookie and
  // the property wasn't explicitly set, so a default value from config is used
  not isPropertySet(oc, "Secure") and
  // the default in config is not set to `true`
  not exists(XMLElement element |
    element instanceof FormsElement and
    element.(FormsElement).isRequireSSL()
    or
    element instanceof HttpCookiesElement and
    element.(HttpCookiesElement).isRequireSSL()
  )
select oc, "Cookie attribute 'Secure' is not set to true."
