/**
 * @name Sensitive cookie missing `HttpOnly` attribute.
 * @description Cookies without the `HttpOnly` attribute set can be accessed by JS scripts, making them more vulnerable to XSS attacks.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id py/client-exposed-cookie
 * @tags security
 *       external/cwe/cwe-1004
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.Concepts

from Http::Server::CookieWrite cookie
where
  cookie.hasHttpOnlyFlag(false) and
  cookie.isSensitive()
select cookie, "Sensitive server cookie is set without HttpOnly flag."
