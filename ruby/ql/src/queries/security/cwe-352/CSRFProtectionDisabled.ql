/**
 * @name CSRF protection weakened or disabled
 * @description Disabling or weakening CSRF protection may make the application
 *              vulnerable to a Cross-Site Request Forgery (CSRF) attack.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.8
 * @precision high
 * @id rb/csrf-protection-disabled
 * @tags security
 *       external/cwe/cwe-352
 */

import ruby
import codeql.ruby.Concepts

from CSRFProtectionSetting s
where s.getVerificationSetting() = false
select s, "Potential CSRF vulnerability due to forgery protection being disabled or weakened."
