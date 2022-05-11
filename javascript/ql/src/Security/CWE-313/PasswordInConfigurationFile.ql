/**
 * @name Password in configuration file
 * @description Storing unencrypted passwords in configuration files is unsafe.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id js/password-in-configuration-file
 * @tags security
 *       external/cwe/cwe-256
 *       external/cwe/cwe-260
 *       external/cwe/cwe-313
 *       external/cwe/cwe-522
 */

import javascript
import semmle.javascript.security.PasswordInConfigurationFileQuery

from string key, string val, Locatable valElement, string pwd
where
  config(key, val, valElement) and
  val != "" and
  (
    key.toLowerCase() = "password" and
    pwd = val and
    // exclude interpolations of environment variables
    not val.regexpMatch("\\$.*|%.*%") and
    not PasswordHeuristics::isDummyPassword(val)
    or
    key.toLowerCase() != "readme" and
    // look for `password=...`, but exclude `password=;`, `password="$(...)"`,
    // `password=%s` and `password==`
    pwd = val.regexpCapture("(?is).*password\\s*=\\s*(?!;|\"?[$`]|%s|=)(\\S+).*", 1)
  )
select valElement.(FirstLineOf), "Hard-coded password '" + pwd + "' in configuration file."
