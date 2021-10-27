/**
 * @name Failure to use secure cookies
 * @description Insecure cookies may be sent in cleartext, which makes them vulnerable to
 *              interception.
 * @kind problem
 * @problem.severity error
 * @id py/insecure-cookie
 * @tags security
 *       external/cwe/cwe-614
 */

// determine precision above
import python
import semmle.python.dataflow.new.DataFlow
import experimental.semmle.python.Concepts

from Cookie cookie, string alert
where
  cookie.isSecure() and
  alert = "secure"
  or
  not cookie.isHttpOnly() and
  alert = "httponly"
  or
  cookie.isSameSite() and
  alert = "samesite"
select cookie, "Cookie is added without the ", alert, " flag properly set."
