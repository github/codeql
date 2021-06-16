/**
 * @name Using a non-constant time algorithm for comparing results of a cryptographic operation
 * @description When comparing results of a cryptographic operation, a constant time algorithm should be used.
 *              Otherwise, an attacker may be able to implement a timing attack.
 *              A successful attack may result in leaking secrets or authentication bypass.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/non-constant-time-crypto-comparison
 * @tags security
 *       external/cwe/cwe-385
 *       external/cwe/cwe-208
 */

import java
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

/**
 * A method that returns the result of a cryptographic operation
 * such as encryption, decryption, signing, etc.
 */
private class ReturnCryptoOperationResultMethod extends Method {
  ReturnCryptoOperationResultMethod() {
    getDeclaringType().hasQualifiedName("javax.crypto", ["Mac", "Cipher"]) and
    hasName("doFinal")
    or
    getDeclaringType().hasQualifiedName("java.security", "Signature") and
    hasName("sign")
  }
}

/**
 * A configuration that tracks data flow from cryptographic operations
 * to methods that compare data using a non-constant time algorithm.
 */
private class NonConstantTimeCryptoComparisonConfig extends TaintTracking::Configuration {
  NonConstantTimeCryptoComparisonConfig() { this = "NonConstantTimeCryptoComparisonConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(MethodAccess ma | ma.getMethod() instanceof ReturnCryptoOperationResultMethod |
      ma = source.asExpr()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      m.getDeclaringType() instanceof TypeString and
      m.hasName(["equals", "contentEquals", "equalsIgnoreCase"]) and
      sink.asExpr() = [ma.getQualifier(), ma.getAnArgument()]
      or
      m.getDeclaringType().hasQualifiedName("java.util", "Arrays") and
      m.hasName("equals") and
      ma.getAnArgument() = sink.asExpr()
      or
      m.getDeclaringType().hasQualifiedName("org.apache.commons.lang3", "StringUtils") and
      m.hasName(["equals", "equalsAny", "equalsAnyIgnoreCase", "equalsIgnoreCase"]) and
      ma.getAnArgument() = sink.asExpr()
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, NonConstantTimeCryptoComparisonConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Using a non-constant time algorithm for comparing results of a cryptographic operation."
