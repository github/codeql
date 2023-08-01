/** Provides classes and predicates to reason about property files and weak hashing algorithms. */

import java
private import semmle.code.configfiles.ConfigFiles
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.Encryption
private import semmle.code.java.frameworks.Properties
private import semmle.code.java.dataflow.RangeUtils

class GetPropertyMethodAccess extends MethodAccess {
  GetPropertyMethodAccess() { this.getMethod() instanceof PropertiesGetPropertyMethod }

  private ConfigPair getPair() {
    this.getArgument(0).(ConstantStringExpr).getStringValue() = result.getNameElement().getName()
  }

  string getValue() {
    result = this.getPair().getValueElement().getValue() or
    result = this.getArgument(1).(ConstantStringExpr).getStringValue()
  }
}

string getWeakHashingAlgorithm(DataFlow::Node node) {
/**
 * Get the name of the weak cryptographic algorithm represented by `node`.
 */
string getWeakHashingAlgorithmName(DataFlow::Node node) {
  exists(MethodAccess ma, ConfigPair pair |
    node.asExpr() = ma and ma.getMethod() instanceof PropertiesGetPropertyMethod
  |
    ma.getArgument(0).(ConstantStringExpr).getStringValue() = pair.getNameElement().getName() and
    pair.getValueElement().getValue() = result and
    not pair.getValueElement().getValue().regexpMatch(getSecureAlgorithmRegex())
  )
}

/**
 * Dataflow configuration from a configuration pair in a properties file to the use of a cryptographic algorithm.
 */
module InsecureAlgorithmPropertyConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) {
    exists(MethodAccess ma, ConfigPair pair |
      n.asExpr() = ma and ma.getMethod() instanceof PropertiesGetPropertyMethod
    |
      ma.getArgument(0).(ConstantStringExpr).getStringValue() = pair.getNameElement().getName() and
      not pair.getValueElement().getValue().regexpMatch(getSecureAlgorithmRegex())
    )
  }

  predicate isSink(DataFlow::Node n) { n.asExpr() = any(CryptoAlgoSpec c).getAlgoSpec() }
}

/**
 * Dataflow from a configuration pair in a properties file to the use of a cryptographic algorithm.
 */
module InsecureAlgorithmPropertyFlow = TaintTracking::Global<InsecureAlgorithmPropertyConfig>;
