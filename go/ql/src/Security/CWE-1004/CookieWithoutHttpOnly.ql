/**
 * @name 'HttpOnly' attribute is not set to true
 * @description Omitting the 'HttpOnly' attribute for security sensitive data allows
 *              malicious JavaScript to steal it in case of XSS vulnerability. Always set
 *              'HttpOnly' to 'true' to authentication related cookie to make it
 *              not accessible by JavaScript.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id go/cookie-httponly-not-set
 * @tags security
 *       experimental
 *       external/cwe/cwe-1004
 */

import go
import semmle.go.security.SecureCookies
import semmle.go.concepts.HTTP

from Http::CookieWrite cw, Expr sensitiveNameExpr, string name
where
  isSensitiveCookie(cw, sensitiveNameExpr, name) and
  (
    isNonHttpOnlyDefault(cw)
    or
    isNonHttpOnlyDirect(cw, _)
  )
select cw, "Sensitive cookie $@ does not set HttpOnly to true", sensitiveNameExpr, name
