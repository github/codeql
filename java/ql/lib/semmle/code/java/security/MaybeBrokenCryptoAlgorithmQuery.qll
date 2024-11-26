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

/** A reference to an insecure cryptographic algorithm. */
abstract class InsecureAlgorithm extends Expr {
  /** Gets the string representation of this insecure cryptographic algorithm. */
  abstract string getStringValue();
}

private class ShortStringLiteral extends StringLiteral {
  ShortStringLiteral() { this.getValue().length() < 100 }
}

/**
 * A string literal that may refer to an insecure cryptographic algorithm.
 */
class InsecureAlgoLiteral extends InsecureAlgorithm, ShortStringLiteral {
  InsecureAlgoLiteral() {
    exists(string s | s = this.getValue() |
      // Algorithm identifiers should be at least two characters.
      s.length() > 1 and
      not s.regexpMatch(getSecureAlgorithmRegex()) and
      // Exclude results covered by another query.
      not s.regexpMatch(getInsecureAlgorithmRegex()) and
      // Exclude results covered by `InsecureAlgoProperty`.
      // This removes duplicates when a string literal is a default value for the property,
      // such as "MD5" in the following: `props.getProperty("hashAlg2", "MD5")`.
      not exists(InsecureAlgoProperty insecAlgoProp | this = insecAlgoProp.getAnArgument())
    )
  }

  override string getStringValue() { result = this.getValue() }
}

/**
 * A property access that may refer to an insecure cryptographic algorithm.
 */
class InsecureAlgoProperty extends InsecureAlgorithm, PropertiesGetPropertyMethodCall {
  string value;

  InsecureAlgoProperty() {
    value = this.getPropertyValue() and
    // Since properties pairs are not included in the java/weak-cryptographic-algorithm,
    // the check for values from properties files can be less strict than `InsecureAlgoLiteral`.
    not value.regexpMatch(getSecureAlgorithmRegex())
  }

  override string getStringValue() { result = value }
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
  predicate isSource(DataFlow::Node n) { n.asExpr() instanceof InsecureAlgorithm }

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
