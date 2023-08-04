/** Provides to taint-tracking configuration to reason about the use of broken or risky cryptographic algorithms. */

import java
private import semmle.code.java.security.Encryption
private import semmle.code.java.dataflow.TaintTracking

private class ShortStringLiteral extends StringLiteral {
  ShortStringLiteral() { this.getValue().length() < 100 }
}

/**
 * A string literal that may refer to a broken or risky cryptographic algorithm.
 */
class BrokenAlgoLiteral extends ShortStringLiteral {
  BrokenAlgoLiteral() {
    this.getValue().regexpMatch(getInsecureAlgorithmRegex()) and
    // Exclude German and French sentences.
    not this.getValue().regexpMatch(".*\\p{IsLowercase} des \\p{IsLetter}.*")
  }
}

/**
 * A taint-tracking configuration to reason about the use of broken or risky cryptographic algorithms.
 */
module InsecureCryptoConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr() instanceof BrokenAlgoLiteral }

  predicate isSink(DataFlow::Node n) { exists(CryptoAlgoSpec c | n.asExpr() = c.getAlgoSpec()) }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }
}

/**
 * Taint-tracking flow for use of broken or risky cryptographic algorithms.
 */
module InsecureCryptoFlow = TaintTracking::Global<InsecureCryptoConfig>;
