/**
 * @name Cookie 'HttpOnly' attribute is not set to true
 * @description Sensitive cookies without the `HttpOnly` property set are accessible by client-side scripts such as JavaScript.
 *              This makes them more vulnerable to being stolen by an XSS attack.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @security-severity 5.0
 * @id go/cookie-httponly-not-set
 * @tags security
 *       external/cwe/cwe-1004
 */

import go
import semmle.go.security.CookieWithoutHttpOnly
import SensitiveCookieNameFlow::PathGraph

from
  Http::CookieWrite cw, string name, SensitiveCookieNameFlow::PathNode source,
  SensitiveCookieNameFlow::PathNode sink
where
  isSensitiveCookie(cw, name, source, sink) and
  isNonHttpOnlyCookie(cw)
select cw, source, sink, "Sensitive cookie $@ does not set HttpOnly attribute to true.", source,
  name
