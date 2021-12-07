/**
 * @name CSRF protection disabled
 * @description Disabling CSRF protection makes the application vulnerable to
 *              a Cross-Site Request Forgery (CSRF) attack.
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
select s, "Potential CSRF vulnerability due to forgery protection being disabled."
