/**
 * @name Password in configuration file
 * @description Finds passwords in configuration files.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id cs/password-in-configuration
 * @tags security
 *       external/cwe/cwe-13
 *       external/cwe/cwe-256
 *       external/cwe/cwe-313
 */

import csharp

from XMLAttribute a
where
  a.getName().toLowerCase() = "password" and not a.getValue() = ""
  or
  a.getName().toLowerCase() = "pwd" and not a.getValue() = ""
  or
  a.getValue().regexpMatch("(?is).*(pwd|password)\\s*=(?!\\s*;).*")
select a, "Avoid plaintext passwords in configuration files."
