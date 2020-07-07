/**
 * @name Empty password in xml file
 * @description Finds empty passwords in xml files.
 * @kind problem
 * @problem.severity warning
 * @id py/empty-password-in-xml-file
 * @tags security
 *       external/cwe/cwe-13
 *       external/cwe/cwe-256
 *       external/cwe/cwe-313
 */

import python

from XMLAttribute a
where
  a.getName().toLowerCase() = "password" and a.getValue() = ""
  or
  a.getName().toLowerCase() = "pwd" and a.getValue() = ""
  or
  a.getValue().regexpMatch("(?is).*(pwd|password)\\s*=\\s*;.*")
select a, "Do not use empty passwords."
