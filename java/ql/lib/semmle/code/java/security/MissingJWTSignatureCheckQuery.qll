/** Provides classes to be used in queries related to JSON Web Token (JWT) signature vulnerabilities. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.JWT

/**
 * Models flow from signing keys assignments to qualifiers of JWT insecure parsers.
 * This is used to determine whether a `JwtParser` performing unsafe parsing has a signing key set.
 */
class MissingJwtSignatureCheckConf extends DataFlow::Configuration {
  MissingJwtSignatureCheckConf() { this = "SigningToExprDataFlow" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof JwtParserWithInsecureParseSource
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JwtParserWithInsecureParseSink }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(JwtParserWithInsecureParseAdditionalFlowStep c).step(node1, node2)
  }
}
