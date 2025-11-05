/**
 * @name 'HttpOnly' attribute is not set to true
 * @description Omitting the 'HttpOnly' attribute for security sensitive data allows
 *              malicious JavaScript to steal it in case of XSS vulnerability. Always set
 *              'HttpOnly' to 'true' to authentication related cookie to make it
 *              not accessible by JavaScript.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id go/cookie-httponly-not-set
 * @tags security
 *       external/cwe/cwe-1004
 */

import go
import semmle.go.security.SecureCookies
import semmle.go.concepts.HTTP
import SensitiveCookieNameFlow::PathGraph

from
  Http::CookieWrite cw, Expr sensitiveNameExpr, string name,
  SensitiveCookieNameFlow::PathNode source, SensitiveCookieNameFlow::PathNode sink
where
  isSensitiveCookie(cw, sensitiveNameExpr, name, source, sink) and
  isNonHttpOnlyCookie(cw)
select cw, source, sink, "Sensitive cookie $@ does not set HttpOnly attribute to true.",
  sensitiveNameExpr, name
