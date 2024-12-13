/**
 * @name Cleartext Credentials in Properties File
 * @description Finds cleartext credentials in Java properties files.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id java/credentials-in-properties
 * @tags security
 *       experimental
 *       external/cwe/cwe-555
 *       external/cwe/cwe-256
 *       external/cwe/cwe-260
 */

/*
 * Note this query requires properties files to be indexed before it can produce results.
 * If creating your own database with the CodeQL CLI, you should run
 * `codeql database index-files --language=properties ...`
 * If using lgtm.com, you should add `properties_files: true` to the index block of your
 * lgtm.yml file (see https://lgtm.com/help/lgtm/java-extraction#customizing-index)
 */

import java
deprecated import experimental.semmle.code.java.frameworks.CredentialsInPropertiesFile

/**
 * Holds if the credentials are in a non-production properties file indicated by:
 *    a) in a non-production directory
 *    b) with a non-production file name
 */
deprecated predicate isNonProdCredentials(CredentialsConfig cc) {
  cc.getFile().getAbsolutePath().matches(["%dev%", "%test%", "%sample%"])
}

deprecated query predicate problems(CredentialsConfig cc, string message) {
  not isNonProdCredentials(cc) and
  message = cc.getConfigDesc()
}
