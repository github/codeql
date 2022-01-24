/**
 * @name Empty password in configuration file
 * @description Failing to set a password reduces the security of your code.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id js/empty-password-in-configuration-file
 * @tags security
 *       external/cwe/cwe-258
 *       external/cwe/cwe-862
 */

import javascript
import semmle.javascript.security.PasswordInConfigurationFileQuery

from string key, string val, Locatable valElement
where
  config(key, val, valElement) and
  (
    val = "" and key.toLowerCase() = "password"
    or
    key.toLowerCase() != "readme" and
    // look for `password=;`, `password=`, `password=  `, `password==`.
    val.regexpMatch("(?is).*password\\s*(==?|:)\\s*(\\\"\\\"|''|``|;|:)?\\s*($|;|&|]|\\n).*")
  )
select valElement.(FirstLineOf), "Empty password in configuration file."
