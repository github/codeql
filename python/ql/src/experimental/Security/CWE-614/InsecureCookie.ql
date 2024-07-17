/**
 * @name Failure to use secure cookies
 * @description Insecure cookies may be sent in cleartext, which makes them vulnerable to
 *              interception.
 * @kind problem
 * @problem.severity error
 * @security-severity 5.0
 * @precision ???
 * @id py/insecure-cookie
 * @tags security
 *       experimental
 *       external/cwe/cwe-614
 */

// TODO: determine precision above
import python
import semmle.python.dataflow.new.DataFlow
import experimental.semmle.python.Concepts
import semmle.python.Concepts

from Http::Server::CookieWrite cookie, string alert
where
  cookie.hasSecureFlag(false) and
  alert = "secure"
  or
  cookie.hasHttpOnlyFlag(false) and
  alert = "httponly"
  or
  cookie.hasSameSiteAttribute(any(Http::Server::CookieWrite::SameSiteNone v)) and
  alert = "samesite"
select cookie, "Cookie is added without the '" + alert + "' flag properly set."
