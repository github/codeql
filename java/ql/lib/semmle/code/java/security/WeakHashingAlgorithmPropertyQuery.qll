/** Provides classes and predicates to reason about property files and weak hashing algorithms. */

import java
private import semmle.code.configfiles.ConfigFiles
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.Encryption
private import semmle.code.java.frameworks.Properties
private import semmle.code.java.dataflow.RangeUtils

private class GetPropertyMethodCall extends MethodCall {
  GetPropertyMethodCall() { this.getMethod() instanceof PropertiesGetPropertyMethod }

  private ConfigPair getPair() {
    this.getArgument(0).(ConstantStringExpr).getStringValue() = result.getNameElement().getName()
  }

  string getPropertyValue() {
    result = this.getPair().getValueElement().getValue() or
    result = this.getArgument(1).(ConstantStringExpr).getStringValue()
  }
}

/**
 * Get the name of the weak cryptographic algorithm represented by `node`.
 */
string getWeakHashingAlgorithmName(DataFlow::Node node) {
  exists(MethodCall mc, ConfigPair pair |
    node.asExpr() = mc and mc.getMethod() instanceof PropertiesGetPropertyMethod
  |
    mc.getArgument(0).(ConstantStringExpr).getStringValue() = pair.getNameElement().getName() and
    pair.getValueElement().getValue() = result and
    not pair.getValueElement().getValue().regexpMatch(getSecureAlgorithmRegex())
  )
}

/**
 * Dataflow configuration from a configuration pair in a properties file to the use of a cryptographic algorithm.
 */
module InsecureAlgorithmPropertyConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) {
    exists(GetPropertyMethodCall mc, string algo | n.asExpr() = mc |
      algo = mc.getPropertyValue() and
      not algo.regexpMatch(getSecureAlgorithmRegex())
    )
  }

  predicate isSink(DataFlow::Node n) { n.asExpr() = any(CryptoAlgoSpec c).getAlgoSpec() }
}

/**
 * Dataflow from a configuration pair in a properties file to the use of a cryptographic algorithm.
 */
module InsecureAlgorithmPropertyFlow = TaintTracking::Global<InsecureAlgorithmPropertyConfig>;
