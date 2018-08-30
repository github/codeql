/**
 * @name Use of a broken or risky cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can allow an attacker to compromise security.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/weak-cryptographic-algorithm
 * @tags security
 *       external/cwe/cwe-327
 */
import java
import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.TaintTracking
import DataFlow

private class ShortStringLiteral extends StringLiteral {
  ShortStringLiteral() {
    getLiteral().length() < 100
  }
}

class BrokenAlgoLiteral extends ShortStringLiteral {
  BrokenAlgoLiteral() {
    getValue().regexpMatch(algorithmBlacklistRegex()) and
    // Exclude German and French sentences.
    not getValue().regexpMatch(".*\\p{IsLowercase} des \\p{IsLetter}.*")
  }
}

class InsecureCryptoConfiguration extends TaintTracking::Configuration {
  InsecureCryptoConfiguration() { this = "BrokenCryptoAlgortihm::InsecureCryptoConfiguration" }
  override predicate isSource(Node n) {
    n.asExpr() instanceof BrokenAlgoLiteral
  }
  override predicate isSink(Node n) {
    exists(CryptoAlgoSpec c | n.asExpr() = c.getAlgoSpec())
  }
  override predicate isSanitizer(DataFlow::Node node) { node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType }
}

from CryptoAlgoSpec c, Expr a, BrokenAlgoLiteral s, InsecureCryptoConfiguration conf
where
  a = c.getAlgoSpec() and
  conf.hasFlow(exprNode(s), exprNode(a))
select c, "Cryptographic algorithm $@ is weak and should not be used.",
  s, s.getLiteral()
