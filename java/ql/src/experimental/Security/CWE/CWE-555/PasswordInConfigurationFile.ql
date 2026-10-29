/**
 * @name Password in configuration file
 * @description Finds passwords in configuration files.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/password-in-configuration
 * @tags security
 *       experimental
 *       external/cwe/cwe-555
 *       external/cwe/cwe-256
 *       external/cwe/cwe-260
 */

import java

/** Holds if the attribute value is not a cleartext password */
bindingset[value]
predicate isNotPassword(string value) {
  value = "" // Empty string
  or
  value.regexpMatch("\\$\\{.*\\}") // Variable placeholder ${password}
  or
  value.matches("%=") // A basic check of encrypted passwords ending with padding characters, which could be improved to be more accurate.
}

/** Holds if the attribute value has an embedded password */
bindingset[value]
predicate hasEmbeddedPassword(string value) {
  exists(string password |
    password = value.regexpCapture("(?is).*(pwd|password)\\s*=([^;:,]*).*", 2).trim() and
    not isNotPassword(password)
  )
}

deprecated query predicate problems(XmlAttribute nameAttr, string message) {
  (
    nameAttr.getName().toLowerCase() in ["password", "pwd"] and
    not isNotPassword(nameAttr.getValue().trim()) // Attribute name "password" or "pwd"
    or
    exists(
      XmlAttribute valueAttr // name/value pair like <property name="password" value="mysecret"/>
    |
      valueAttr.getElement() = nameAttr.getElement() and
      nameAttr.getName().toLowerCase() = "name" and
      nameAttr.getValue().toLowerCase() in ["password", "pwd"] and
      valueAttr.getName().toLowerCase() = "value" and
      not isNotPassword(valueAttr.getValue().trim())
    )
    or
    hasEmbeddedPassword(nameAttr.getValue().trim()) // Attribute value matches password pattern
  ) and
  message = "Avoid plaintext passwords in configuration files."
}
