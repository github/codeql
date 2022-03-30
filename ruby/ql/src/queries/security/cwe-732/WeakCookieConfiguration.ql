/**
 * @name Weak cookie configuration
 * @description Misconfiguring how cookies are encrypted or sent can expose a user to various attacks.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @id rb/weak-cookie-configuration
 * @tags external/cwe/cwe-732
 *       external/cwe/cwe-1275
 *       security
 * @precision high
 */

import ruby
import codeql.ruby.Concepts
import codeql.ruby.Frameworks

from CookieSecurityConfigurationSetting s
select s, s.getSecurityWarningMessage()
