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
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.Concepts

from Http::Server::CookieWrite cookie
where
  cookie.hasSecureFlag(false) and
  cookie.isSensitive()
select cookie, "Cookie is added to response without the 'secure' flag being set."
