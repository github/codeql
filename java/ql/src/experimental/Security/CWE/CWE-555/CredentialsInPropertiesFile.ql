/**
 * @name Cleartext Credentials in Properties File
 * @description Finds cleartext credentials in Java properties files.
 * @kind problem
 * @id java/credentials-in-properties
 * @tags security
 *       external/cwe/cwe-555
 *       external/cwe/cwe-256
 *       external/cwe/cwe-260
 */

import java
import semmle.code.configfiles.ConfigFiles

private string suspicious() {
  result = "%password%" or
  result = "%passwd%" or
  result = "%account%" or
  result = "%accnt%" or
  result = "%credential%" or
  result = "%token%" or
  result = "%secret%" or
  result = "%access%key%"
}

private string nonSuspicious() {
  result = "%hashed%" or
  result = "%encrypted%" or
  result = "%crypt%"
}

/** Holds if the value is not cleartext credentials. */
bindingset[value]
predicate isNotCleartextCredentials(string value) {
  value = "" // Empty string
  or
  value.length() < 7 // Typical credentials are no less than 6 characters
  or
  value.matches("% %") // Sentences containing spaces
  or
  value.regexpMatch(".*[^a-zA-Z\\d]{3,}.*") // Contain repeated non-alphanumeric characters such as a fake password pass**** or ????
  or
  value.matches("@%") // Starts with the "@" sign
  or
  value.regexpMatch("\\$\\{.*\\}") // Variable placeholder ${credentials}
  or
  value.matches("%=") // A basic check of encrypted credentials ending with padding characters
  or
  value.matches("ENC(%)") // Encrypted value
  or
  value.toLowerCase().matches(suspicious()) // Could be message properties or fake passwords
}

/**
 * Holds if the credentials are in a non-production properties file indicated by:
 *    a) in a non-production directory
 *    b) with a non-production file name
 */
predicate isNonProdCredentials(CredentialsConfig cc) {
  cc.getFile().getAbsolutePath().matches(["%dev%", "%test%", "%sample%"]) and
  not cc.getFile().getAbsolutePath().matches("%codeql%") // CodeQL test cases
}

/** The properties file with configuration key/value pairs. */
class ConfigProperties extends ConfigPair {
  ConfigProperties() { this.getFile().getBaseName().toLowerCase().matches("%.properties") }
}

/** The credentials configuration property. */
class CredentialsConfig extends ConfigProperties {
  CredentialsConfig() {
    this.getNameElement().getName().trim().toLowerCase().matches(suspicious()) and
    not this.getNameElement().getName().trim().toLowerCase().matches(nonSuspicious())
  }

  string getName() { result = this.getNameElement().getName().trim() }

  string getValue() { result = this.getValueElement().getValue().trim() }
}

from CredentialsConfig cc
where
  not isNotCleartextCredentials(cc.getValue()) and
  not isNonProdCredentials(cc)
select cc,
  "Plaintext credentials " + cc.getName() + " have cleartext value " + cc.getValue() +
    " in properties file."
