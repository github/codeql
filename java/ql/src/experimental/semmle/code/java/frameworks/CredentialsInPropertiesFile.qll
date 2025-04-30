/**
 * Provides classes for analyzing properties files.
 */
deprecated module;

import java
import semmle.code.configfiles.ConfigFiles
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Properties

private string possibleSecretName() {
  result =
    [
      "%password%", "%passwd%", "%account%", "%accnt%", "%credential%", "%token%", "%secret%",
      "%access%key%"
    ]
}

private string possibleEncryptedSecretName() { result = ["%hashed%", "%encrypted%", "%crypt%"] }

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
  // Could be a message property for UI display or fake passwords, e.g. login.password_expired=Your current password has expired.
  value.toLowerCase().matches(possibleSecretName())
}

/** A configuration property that appears to contain a cleartext secret. */
class CredentialsConfig extends ConfigPair {
  CredentialsConfig() {
    this.getNameElement().getName().trim().toLowerCase().matches(possibleSecretName()) and
    not this.getNameElement().getName().trim().toLowerCase().matches(possibleEncryptedSecretName()) and
    not isNotCleartextCredentials(this.getValueElement().getValue().trim())
  }

  /** Gets the whitespace-trimmed name of this property. */
  string getName() { result = this.getNameElement().getName().trim() }

  /** Gets the whitespace-trimmed value of this property. */
  string getValue() { result = this.getValueElement().getValue().trim() }

  /** Returns a description of this vulnerability. */
  string getConfigDesc() {
    result =
      "Plaintext credentials " + this.getName() + " have cleartext value " + this.getValue() +
        " in properties file"
  }
}
