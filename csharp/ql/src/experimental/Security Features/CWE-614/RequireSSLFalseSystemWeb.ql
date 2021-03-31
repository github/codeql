/**
 * @name 'Secure' attribute is set to false
 * @description Omitting the 'Secure' attribute allows data to be transmitted insecurely
 *              using HTTP. Always set 'Secure' to 'true' to ensure that HTTPS
 *              is used at all times.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/web/cookie-secure-false-aspnet
 * @tags security
 *       external/cwe/cwe-319
 *       external/cwe/cwe-614
 */

import csharp
import semmle.code.csharp.frameworks.system.Web
import semmle.code.csharp.dataflow.flowsources.AuthCookie

from ObjectCreation oc, Expr val, Assignment a
where
  oc.getType() instanceof SystemWebHttpCookie and
  getAValueForProp(oc, a, "Secure") = val and
  val.getValue() = "false"
select a.getRValue(), "Cookie attribute 'Secure' is set to false."
