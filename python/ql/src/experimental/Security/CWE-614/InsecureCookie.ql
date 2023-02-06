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
import experimental.semmle.python.CookieHeader

from Cookie cookie, string alert
where
  not cookie.isSecure() and
  alert = "secure"
  or
  not cookie.isHttpOnly() and
  alert = "httponly"
  or
  not cookie.isSameSite() and
  alert = "samesite"
select cookie, "Cookie is added without the '" + alert + "' flag properly set."
