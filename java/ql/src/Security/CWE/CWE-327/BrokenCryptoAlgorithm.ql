/**
 * @name Use of a broken or risky cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id java/weak-cryptographic-algorithm
 * @tags security
 *       external/cwe/cwe-327
 */

import java
import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.TaintTracking
import DataFlow
import PathGraph

private class ShortStringLiteral extends StringLiteral {
  ShortStringLiteral() { getLiteral().length() < 100 }
}

class BrokenAlgoLiteral extends ShortStringLiteral {
  BrokenAlgoLiteral() {
    getValue().regexpMatch(getInsecureAlgorithmRegex()) and
    // Exclude German and French sentences.
    not getValue().regexpMatch(".*\\p{IsLowercase} des \\p{IsLetter}.*")
  }
}

class InsecureCryptoConfiguration extends TaintTracking::Configuration {
  InsecureCryptoConfiguration() { this = "BrokenCryptoAlgortihm::InsecureCryptoConfiguration" }

  override predicate isSource(Node n) { n.asExpr() instanceof BrokenAlgoLiteral }

  override predicate isSink(Node n) { exists(CryptoAlgoSpec c | n.asExpr() = c.getAlgoSpec()) }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }
}

from
  PathNode source, PathNode sink, CryptoAlgoSpec c, BrokenAlgoLiteral s,
  InsecureCryptoConfiguration conf
where
  sink.getNode().asExpr() = c.getAlgoSpec() and
  source.getNode().asExpr() = s and
  conf.hasFlowPath(source, sink)
select c, source, sink, "Cryptographic algorithm $@ is weak and should not be used.", s,
  s.getLiteral()
