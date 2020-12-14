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
  a.getValue().matches("%=") // A basic check of encrypted passwords ending with padding characters, which could be improved to be more accurate.
}

from XMLAttribute nameAttr
where
  nameAttr.getName().toLowerCase() in ["password", "pwd"] and not isNotPassword(nameAttr) // Attribute name "password" or "pwd"
  or
  exists(
    XMLAttribute valueAttr // name/value pair like <property name="password" value="mysecret"/>
  |
    valueAttr.getElement() = nameAttr.getElement() and
    nameAttr.getName().toLowerCase() = "name" and
    nameAttr.getValue().toLowerCase() in ["password", "pwd"] and
    valueAttr.getName().toLowerCase() = "value" and
    not isNotPassword(valueAttr)
  )
  or
  nameAttr.getValue().regexpMatch("(?is).*(pwd|password)\\s*=(?!\\s*;).*") // Attribute value matches password pattern
select nameAttr, "Plaintext password in configuration file."
