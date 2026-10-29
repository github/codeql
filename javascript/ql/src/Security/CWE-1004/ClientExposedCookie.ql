/**
 * @name Sensitive server cookie exposed to the client
 * @description Sensitive cookies set by a server can be read by the client if the `httpOnly` flag is not set.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id js/client-exposed-cookie
 * @tags security
 *       external/cwe/cwe-1004
 */

import javascript

from CookieWrites::CookieWrite cookie
where
  cookie.isSensitive() and
  cookie.isServerSide() and
  not cookie.isHttpOnly()
select cookie, "Sensitive server cookie is missing 'httpOnly' flag."
