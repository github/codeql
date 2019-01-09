/**
 * @name Empty password in configuration file
 * @description Finds empty passwords in configuration files.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/empty-password-in-configuration
 * @tags security
 *       external/cwe/cwe-258
 *       external/cwe/cwe-862
 */

import csharp

from XMLAttribute a
where
  a.getName().toLowerCase() = "password" and a.getValue() = ""
  or
  a.getName().toLowerCase() = "pwd" and a.getValue() = ""
  or
  a.getValue().regexpMatch("(?is).*(pwd|password)\\s*=\\s*;.*")
select a, "Do not use empty passwords."
