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

predicate relevantSetting(HTTP::Server::CsrfProtectionSetting s) {
  // rule out test code as this is a common place to turn off CSRF protection.
  // We don't use normal `TestScope` to find test files, since we also want to match
  // a settings file such as `.../integration-tests/settings.py`
  not s.getLocation().getFile().getAbsolutePath().matches("%test%")
}

predicate vulnerableSetting(HTTP::Server::CsrfProtectionSetting s) {
  s.getVerificationSetting() = false and
  not exists(HTTP::Server::CsrfLocalProtectionSetting p | p.csrfEnabled()) and
  relevantSetting(s)
}

from HTTP::Server::CsrfProtectionSetting setting
where
  vulnerableSetting(setting) and
  // We have seen examples of dummy projects with vulnerable settings alongside a main
  // project with a protecting settings file. We want to rule out this scenario, so we
  // require all non-test settings to be vulnerable.
  forall(HTTP::Server::CsrfProtectionSetting s | relevantSetting(s) | vulnerableSetting(s))
select setting, "Potential CSRF vulnerability due to forgery protection being disabled or weakened."
