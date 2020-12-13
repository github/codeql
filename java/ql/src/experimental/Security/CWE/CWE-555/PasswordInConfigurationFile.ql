/**
 * @name Password in configuration file
 * @description Finds passwords in configuration files.
 * @kind problem
 * @id java/password-in-configuration
 * @tags security
 *       external/cwe/cwe-555
 *       external/cwe/cwe-256
 *       external/cwe/cwe-260
 */

import java

predicate isNotPassword(XMLAttribute a) {
  a.getValue() = "" // Empty string
  or
  a.getValue().regexpMatch("\\$\\{.*\\}") // Variable placeholder ${password}
  or
  a.getValue().charAt(a.getValue().length() - 1) = "=" // A basic check of encrypted passwords ending with padding characters, which could be improved to be more accurate.
}

from XMLAttribute a
where
  a.getName().toLowerCase() in ["password", "pwd"] and not isNotPassword(a) // Attribute name "password" or "pwd"
  or
  exists(
    XMLAttribute b // name/value pair like <property name="password" value="mysecret"/>
  |
    b.getElement() = a.getElement() and
    a.getName().toLowerCase() = "name" and
    a.getValue().toLowerCase() in ["password", "pwd"] and
    b.getName().toLowerCase() = "value" and
    not isNotPassword(b)
  )
  or
  a.getValue().regexpMatch("(?is).*(pwd|password)\\s*=(?!\\s*;).*") // Attribute value matches password pattern
select a, "Plaintext passwords in configuration files."
