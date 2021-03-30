/**
 * Provides classes for analyzing properties files.
 */

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

/** The credentials configuration property. */
class CredentialsConfig extends ConfigPair {
  CredentialsConfig() {
    this.getNameElement().getName().trim().toLowerCase().matches(possibleSecretName()) and
    not this.getNameElement().getName().trim().toLowerCase().matches(possibleEncryptedSecretName()) and
    not isNotCleartextCredentials(this.getValueElement().getValue().trim())
  }

  string getName() { result = this.getNameElement().getName().trim() }

  string getValue() { result = this.getValueElement().getValue().trim() }

  /** Returns a description of this vulnerability. */
  string getConfigDesc() {
    exists(
      // getProperty(...)
      LoadCredentialsConfiguration cc, DataFlow::Node source, DataFlow::Node sink, MethodAccess ma
    |
      this.getName() = source.asExpr().(CompileTimeConstantExpr).getStringValue() and
      cc.hasFlow(source, sink) and
      ma.getArgument(0) = sink.asExpr() and
      result = "Plaintext credentials " + this.getName() + " are loaded in Java Properties " + ma
    )
    or
    exists(
      // @Value("${mail.password}")
      Annotation a
    |
      a.getType().hasQualifiedName("org.springframework.beans.factory.annotation", "Value") and
      a.getAValue().(CompileTimeConstantExpr).getStringValue() = "${" + this.getName() + "}" and
      result = "Plaintext credentials " + this.getName() + " are loaded in Spring annotation " + a
    )
    or
    not exists(LoadCredentialsConfiguration cc, DataFlow::Node source, DataFlow::Node sink |
      this.getName() = source.asExpr().(CompileTimeConstantExpr).getStringValue() and
      cc.hasFlow(source, sink)
    ) and
    not exists(Annotation a |
      a.getType().hasQualifiedName("org.springframework.beans.factory.annotation", "Value") and
      a.getAValue().(CompileTimeConstantExpr).getStringValue() = "${" + this.getName() + "}"
    ) and
    result =
      "Plaintext credentials " + this.getName() + " have cleartext value " + this.getValue() +
        " in properties file"
  }
}

/**
 * A dataflow configuration tracking flow of cleartext credentials stored in a properties file
 *  to a `Properties.getProperty(...)` method call.
 */
class LoadCredentialsConfiguration extends DataFlow::Configuration {
  LoadCredentialsConfiguration() { this = "LoadCredentialsConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(CredentialsConfig cc |
      source.asExpr().(CompileTimeConstantExpr).getStringValue() = cc.getName()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() =
      any(MethodAccess ma | ma.getMethod() instanceof PropertiesGetPropertyMethod).getArgument(0)
  }
}
