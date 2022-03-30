/**
 * @name Use of a potentially broken or risky cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id java/potentially-weak-cryptographic-algorithm
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 */

import java
import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.TaintTracking
import DataFlow
import semmle.code.java.dispatch.VirtualDispatch
import PathGraph

private class ShortStringLiteral extends StringLiteral {
  ShortStringLiteral() { this.getValue().length() < 100 }
}

class InsecureAlgoLiteral extends ShortStringLiteral {
  InsecureAlgoLiteral() {
    // Algorithm identifiers should be at least two characters.
    this.getValue().length() > 1 and
    exists(string s | s = this.getValue() |
      not s.regexpMatch(getSecureAlgorithmRegex()) and
      // Exclude results covered by another query.
      not s.regexpMatch(getInsecureAlgorithmRegex())
    )
  }
}

predicate objectToString(MethodAccess ma) {
  exists(ToStringMethod m |
    m = ma.getMethod() and
    m.getDeclaringType() instanceof TypeObject and
    variableTrack(ma.getQualifier()).getType().getErasure() instanceof TypeObject
  )
}

class StringContainer extends RefType {
  StringContainer() {
    this instanceof TypeString or
    this instanceof StringBuildingType or
    this.hasQualifiedName("java.util", "StringTokenizer") or
    this.(Array).getComponentType() instanceof StringContainer
  }
}

class InsecureCryptoConfiguration extends TaintTracking::Configuration {
  InsecureCryptoConfiguration() { this = "InsecureCryptoConfiguration" }

  override predicate isSource(Node n) { n.asExpr() instanceof InsecureAlgoLiteral }

  override predicate isSink(Node n) { exists(CryptoAlgoSpec c | n.asExpr() = c.getAlgoSpec()) }

  override predicate isSanitizer(Node n) {
    objectToString(n.asExpr()) or
    not n.getType().getErasure() instanceof StringContainer
  }
}

from
  PathNode source, PathNode sink, CryptoAlgoSpec c, InsecureAlgoLiteral s,
  InsecureCryptoConfiguration conf
where
  sink.getNode().asExpr() = c.getAlgoSpec() and
  source.getNode().asExpr() = s and
  conf.hasFlowPath(source, sink)
select c, source, sink,
  "Cryptographic algorithm $@ may not be secure, consider using a different algorithm.", s,
  s.getValue()
