/**
 * @name Password in xml file
 * @description Finds passwords in xml files.
 * @kind problem
 * @problem.severity warning
 * @id py/password-in-xml-file
 * @tags security
 *       external/cwe/cwe-13
 *       external/cwe/cwe-256
 *       external/cwe/cwe-313
 */

import python

from XMLAttribute a
where
  a.getName().toLowerCase() = "password" and not a.getValue() = ""
  or
  a.getName().toLowerCase() = "pwd" and not a.getValue() = ""
  or
  a.getValue().regexpMatch("(?is).*(pwd|password)\\s*=(?!\\s*;).*")
select a, "Avoid plaintext passwords in xml files."
