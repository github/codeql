/** Provides classes to be used in queries related to JWT signature vulnerabilities. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.security.JWT

/**
 * An expr that is a (sub-type of) `JwtParser` for which a signing key has been set.
 */
class JwtParserWithSigningKeyExpr extends Expr {
  MethodAccess signingMa;

  JwtParserWithSigningKeyExpr() { isSigningKeySetter(this, signingMa) }

  /** Gets the method access that sets the signing key for this parser. */
  MethodAccess getSigningMethodAccess() { result = signingMa }
}

/**
 * Holds if `signingMa` directly or indirectly sets a signing key for `expr`, which is a `JwtParser`.
 * The `setSigningKey` and `setSigningKeyResolver` methods set a signing key for a `JwtParser`.
 *
 * Directly means code like this (the signing key is set directly on a `JwtParser`):
 * ```java
 * Jwts.parser().setSigningKey(key).parse(token);
 * ```
 *
 * Indirectly means code like this (the signing key is set on a `JwtParserBuilder` indirectly setting the key of `JwtParser` that is created by the call to `build`):
 * ```java
 * Jwts.parserBuilder().setSigningKey(key).build().parse(token);
 * ```
 */
private predicate isSigningKeySetter(Expr expr, MethodAccess signingMa) {
  any(SigningToInsecureMethodAccessDataFlow s)
      .hasFlow(DataFlow::exprNode(signingMa), DataFlow::exprNode(expr))
}

/**
 * Models flow from signing keys assignements to qualifiers of JWT insecure parsers.
 * This is used to determine whether a `JwtParser` has a signing key set.
 */
private class SigningToInsecureMethodAccessDataFlow extends DataFlow::Configuration {
  SigningToInsecureMethodAccessDataFlow() { this = "SigningToExprDataFlow" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof JwtParserWithInsecureParseSource
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JwtParserWithInsecureParseSink }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(JwtParserWithInsecureParseAdditionalFlowStep c).step(node1, node2)
  }
}
