/**
 * @name Sensitive cookie with `SameSite` attribute set to `None`.
 * @description Cookies with `SameSite` set to `None` can allow for Cross-Site Request Forgery (CSRF) attacks.
 * @kind problem
 * @problem.severity warning
 * @security-severity 4.0
 * @precision high
 * @id py/samesite-none-cookie
 * @tags security
 *       external/cwe/cwe-1275
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.Concepts

from Http::Server::CookieWrite cookie
where
  cookie.hasSameSiteAttribute(any(Http::Server::CookieWrite::SameSiteNone v)) and
  cookie.isSensitive()
select cookie, "Sensitive cookie with SameSite set to 'None'."
