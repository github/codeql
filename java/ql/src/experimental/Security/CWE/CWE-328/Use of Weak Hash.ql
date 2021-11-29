/**
 * @name Use of a broken or risky cryptographic hash
 * @description Using weak hash algorithm can allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity ??
 * @precision ??
 * @id java/weak-hash-algorithm
 * @tags security
 *       external/cwe/cwe-328
 */

import java
import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.TaintTracking
import DataFlow
import PathGraph

class BrokenHashLiteral extends StringLiteral {
  BrokenHashLiteral() {
    getValue().length() <  10 and 
    getValue().regexpMatch(getInsecureHashRegex())
  }
}

class InsecureHashConfiguration extends TaintTracking::Configuration {
  InsecureHashConfiguration() { this = "BrokenCryptoAlgortihm::InsecureHashConfiguration" }

  override predicate isSource(Node n) { n.asExpr() instanceof BrokenHashLiteral }

  override predicate isSink(Node n) { exists(CryptoAlgoSpec c | n.asExpr() = c.getAlgoSpec()) }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }
}

from
  PathNode source, PathNode sink, CryptoAlgoSpec c, BrokenHashLiteral s,
  InsecureHashConfiguration conf
where
  sink.getNode().asExpr() = c.getAlgoSpec() and
  source.getNode().asExpr() = s and
  conf.hasFlowPath(source, sink)
select c, source, sink, "Hash algorithm $@ is weak and should not be used.", s,
  s.getValue()

  bindingset[hashString]
  private string hashRegex(string hashString) {
    // Algorithms usually appear in names surrounded by characters that are not
    // alphabetical characters in the same case. This handles the upper and lower
    // case cases.
    result =
      "((^|.*[^A-Z])(" + hashString + ")([^A-Z].*|$))" +
        // or...
        "|" +
        // For lowercase, we want to be careful to avoid being confused by camelCase
        // hence we require two preceding uppercase letters to be sure of a case switch,
        // or a preceding non-alphabetic character
        "((^|.*[A-Z]{2}|.*[^a-zA-Z])(" + hashString.toLowerCase() + ")([^a-z].*|$))"
  }
  string getInsecureHashRegex() {
    result = hashRegex(getAnInsecureHashAlgorithmName())
}

