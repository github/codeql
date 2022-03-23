/**
 * @name CSRF protection weakened or disabled
 * @description Disabling or weakening CSRF protection may make the application
 *              vulnerable to a Cross-Site Request Forgery (CSRF) attack.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.8
 * @precision high
 * @id py/csrf-protection-disabled
 * @tags security
 *       external/cwe/cwe-352
 */

import python
import semmle.python.Concepts

from CsrfProtectionSetting s
where
  s.getVerificationSetting() = false and
  not exists(CsrfLocalProtection p) and
  // rule out test code as this is a common place to turn off CSRF protection
  not s.getLocation().getFile().getAbsolutePath().matches("%test%")
select s, "Potential CSRF vulnerability due to forgery protection being disabled or weakened."
