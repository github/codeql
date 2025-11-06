/**
 * @name 'Secure' attribute is not set to true
 * @description todo
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @security-severity 5.0
 * @id go/cookie-secure-not-set
 * @tags security
 *       external/cwe/cwe-1004
 */

import go
import semmle.go.security.SecureCookies

from Http::CookieWrite cw
where isInsecureCookie(cw)
select cw, "Cookie does not set Secure attribute to true."
