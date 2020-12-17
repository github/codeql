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

/* Holds if the attribute value is not a cleartext password */
predicate isNotPassword(XMLAttribute attr) {
  exists(string value | value = attr.getValue().trim() |
    value = "" // Empty string
    or
    value.regexpMatch("\\$\\{.*\\}") // Variable placeholder ${password}
    or
    value.matches("%=") // A basic check of encrypted passwords ending with padding characters, which could be improved to be more accurate.
  )
}

/* Holds if the attribute value has an embedded password */
predicate hasEmbeddedPassword(XMLAttribute attr) {
  exists(string password |
    password = attr.getValue().regexpCapture("(?is).*(pwd|password)\\s*=([^;:,]*).*", 2).trim() and
    not (
      password = "" or
      password.regexpMatch("\\$\\{.*\\}") or
      password.matches("%=")
    )
  )
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
  hasEmbeddedPassword(nameAttr) // Attribute value matches password pattern
select nameAttr, "Plaintext password in configuration file."
