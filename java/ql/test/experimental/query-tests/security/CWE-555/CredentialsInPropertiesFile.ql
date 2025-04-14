/*
 * Note this is similar to src/experimental/Security/CWE/CWE-555/CredentialsInPropertiesFile.ql
 * except we do not filter out test files.
 */

import java
deprecated import experimental.semmle.code.java.frameworks.CredentialsInPropertiesFile

deprecated query predicate problems(CredentialsConfig cc, string message) {
  message = cc.getConfigDesc()
}
