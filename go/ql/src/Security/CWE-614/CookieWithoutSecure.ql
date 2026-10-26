/**
 * @name Cookie 'Secure' attribute is not set to true
 * @description Cookies without the `Secure` flag may be sent in cleartext.
 *              This makes them vulnerable to be intercepted by an attacker.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @security-severity 4.0
 * @id go/cookie-secure-not-set
 * @tags security
 *       external/cwe/cwe-614
 */

import go
import semmle.go.security.CookieWithoutSecure

from Http::CookieWrite cw
where isInsecureCookie(cw)
select cw, "Cookie does not set Secure attribute to true."
