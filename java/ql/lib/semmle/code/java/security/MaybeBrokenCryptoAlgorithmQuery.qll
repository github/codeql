/**
 * Provides classes and a taint-tracking configuration to reason about the use of potentially insecure cryptographic algorithms.
 */

import java
private import semmle.code.configfiles.ConfigFiles
private import semmle.code.java.security.Encryption
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.dataflow.RangeUtils
private import semmle.code.java.dispatch.VirtualDispatch
private import semmle.code.java.frameworks.Properties

private class ShortStringLiteral extends StringLiteral {
  ShortStringLiteral() { this.getValue().length() < 100 }
}

/**
 * A string literal that may refer to an insecure cryptographic algorithm.
 */
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

private predicate objectToString(MethodCall ma) {
  exists(ToStringMethod m |
    m = ma.getMethod() and
    m.getDeclaringType() instanceof TypeObject and
    DataFlow::exprNode(ma.getQualifier()).getTypeBound().getErasure() instanceof TypeObject
  )
}

/**
 * A taint-tracking configuration to reason about the use of potentially insecure cryptographic algorithms.
 */
module InsecureCryptoConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) {
    n.asExpr() instanceof InsecureAlgoLiteral
    or
    exists(PropertiesGetPropertyMethodCall mc | n.asExpr() = mc |
      // Since properties pairs are not included in the java/weak-crypto-algorithm,
      // The check for values from properties files can be less strict than `InsecureAlgoLiteral`.
      not mc.getPropertyValue().regexpMatch(getSecureAlgorithmRegex())
    )
  }

  predicate isSink(DataFlow::Node n) { exists(CryptoAlgoSpec c | n.asExpr() = c.getAlgoSpec()) }

  predicate isBarrier(DataFlow::Node n) {
    objectToString(n.asExpr()) or
    n.getType().getErasure() instanceof TypeObject
  }
}

/**
 * Taint-tracking flow for use of potentially insecure cryptographic algorithms.
 */
module InsecureCryptoFlow = TaintTracking::Global<InsecureCryptoConfig>;
