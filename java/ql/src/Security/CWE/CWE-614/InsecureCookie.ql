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

from MethodAccess add
where
  add.getMethod() instanceof ResponseAddCookieMethod and
  not exists(Variable cookie, MethodAccess m |
    add.getArgument(0) = cookie.getAnAccess() and
    m.getMethod().getName() = "setSecure" and
    m.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() = true and
    m.getQualifier() = cookie.getAnAccess()
  )
select add, "Cookie is added to response without the 'secure' flag being set."
