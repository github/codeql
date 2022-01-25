/**
 * @name Sensitive cookie without SameSite restrictions
 * @description Sensitive cookies where the SameSite attribute is set to "None" can
 *              in some cases allow for Cross-Site Request Forgery (CSRF) attacks.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision medium
 * @id js/samesite-none-cookie
 * @tags security
 *       external/cwe/cwe-1275
 */

import javascript

from CookieWrites::CookieWrite cookie
where
  cookie.isSensitive() and
  cookie.isSecure() and // `js/clear-text-cookie` will report it if the cookie is not secure.
  cookie.getSameSite().toLowerCase() = "none"
select cookie, "Sensitive cookie with SameSite set to 'None'"
