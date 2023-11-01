/**
 * @name Failure to use secure cookies
 * @description Insecure cookies may be sent in cleartext, which makes them vulnerable to
 *              interception.
 * @kind problem
 * @problem.severity error
 * @security-severity 5.0
 * @precision high
 * @id java/insecure-cookie
 * @tags security
 *       external/cwe/cwe-614
 */

import java
import semmle.code.java.frameworks.Servlets
import semmle.code.java.security.InsecureCookieQuery

from MethodCall add
where
  add.getMethod() instanceof ResponseAddCookieMethod and
  not SecureCookieFlow::flowToExpr(add.getArgument(0))
select add, "Cookie is added to response without the 'secure' flag being set."
