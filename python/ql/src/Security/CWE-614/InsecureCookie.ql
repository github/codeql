/**
 * @name Failure to use secure cookies
 * @description Insecure cookies may be sent in cleartext, which makes them vulnerable to
 *              interception.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id py/insecure-cookie
 * @tags security
 *       external/cwe/cwe-614
 *       external/cwe/cwe-1004
 *       external/cwe/cwe-1275
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.Concepts

predicate hasProblem(Http::Server::CookieWrite cookie, string alert, int idx) {
  cookie.hasSecureFlag(false) and
  alert = "Secure" and
  idx = 0
  or
  cookie.hasHttpOnlyFlag(false) and
  alert = "HttpOnly" and
  idx = 1
  or
  cookie.hasSameSiteAttribute(any(Http::Server::CookieWrite::SameSiteNone v)) and
  alert = "SameSite" and
  idx = 2
}

predicate hasAlert(Http::Server::CookieWrite cookie, string alert) {
  exists(int numProblems | numProblems = strictcount(string p | hasProblem(cookie, p, _)) |
    numProblems = 1 and
    alert = any(string prob | hasProblem(cookie, prob, _)) + " attribute"
    or
    numProblems = 2 and
    alert =
      strictconcat(string prob, int idx | hasProblem(cookie, prob, idx) | prob, " and " order by idx)
        + " attributes"
    or
    numProblems = 3 and
    alert = "Secure, HttpOnly, and SameSite attributes"
  )
}

from Http::Server::CookieWrite cookie, string alert
where hasAlert(cookie, alert)
select cookie, "Cookie is added without the " + alert + " properly set."
