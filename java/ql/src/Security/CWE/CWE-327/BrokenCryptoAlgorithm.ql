/**
 * @name Use of a broken or risky cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id java/weak-cryptographic-algorithm
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 */

import java
import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.TaintTracking
import DataFlow

private class ShortStringLiteral extends StringLiteral {
  ShortStringLiteral() { getValue().length() < 100 }
}

class BrokenAlgoLiteral extends ShortStringLiteral {
  BrokenAlgoLiteral() {
    getValue().regexpMatch(getInsecureAlgorithmRegex()) and
    // Exclude German and French sentences.
    not getValue().regexpMatch(".*\\p{IsLowercase} des \\p{IsLetter}.*")
  }
}

module InsecureCryptoConfig implements ConfigSig {
  predicate isSource(Node n) { n.asExpr() instanceof BrokenAlgoLiteral }

  predicate isSink(Node n) { exists(CryptoAlgoSpec c | n.asExpr() = c.getAlgoSpec()) }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }
}

module InsecureCryptoFlow = TaintTracking::Make<InsecureCryptoConfig>;

import InsecureCryptoFlow::PathGraph

from
  InsecureCryptoFlow::PathNode source, InsecureCryptoFlow::PathNode sink, CryptoAlgoSpec c,
  BrokenAlgoLiteral s
where
  sink.getNode().asExpr() = c.getAlgoSpec() and
  source.getNode().asExpr() = s and
  InsecureCryptoFlow::hasFlowPath(source, sink)
select c, source, sink, "Cryptographic algorithm $@ is weak and should not be used.", s,
  s.getValue()
