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
 *       external/cwe/cwe-208
 */

import java
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

/**
 * A source that produces a MAC.
 */
private class MacSource extends DataFlow::Node {
  MacSource() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      m.hasQualifiedName("javax.crypto", "Mac", "doFinal") and
      (
        m.getReturnType() instanceof Array and ma = this.asExpr()
        or
        m.getParameterType(0) instanceof Array and ma.getArgument(0) = this.asExpr()
      )
    )
  }
}

/**
 * A source that produces a signature.
 */
private class SignatureSource extends DataFlow::Node {
  SignatureSource() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      m.hasQualifiedName("java.security", "Signature", "sign") and
      (
        m.getReturnType() instanceof Array and ma = this.asExpr()
        or
        m.getParameterType(0) instanceof Array and ma.getArgument(0) = this.asExpr()
      )
    )
  }
}

/**
 * A source that produces a ciphertext.
 */
private class CiphertextSource extends DataFlow::Node {
  CiphertextSource() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      m.hasQualifiedName("javax.crypto", "Cipher", "doFinal") and
      (
        m.getReturnType() instanceof Array and ma = this.asExpr()
        or
        m.getParameterType([0, 3]) instanceof Array and ma.getArgument([0, 3]) = this.asExpr()
        or
        m.getParameterType(1).(RefType).hasQualifiedName("java.nio", "ByteBuffer") and
        ma.getArgument(1) = this.asExpr()
      )
    )
  }
}

/**
 * A sink that compares input using a non-constant time algorithm.
 */
private class KnownNonConstantTimeComparisonSink extends DataFlow::Node {
  KnownNonConstantTimeComparisonSink() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      m.hasQualifiedName("java.lang", "String", ["equals", "contentEquals", "equalsIgnoreCase"]) and
      this.asExpr() = [ma.getQualifier(), ma.getAnArgument()]
      or
      m.hasQualifiedName("java.nio", "ByteBuffer", ["equals", "compareTo"]) and
      this.asExpr() = [ma.getQualifier(), ma.getAnArgument()]
      or
      m.hasQualifiedName("java.util", "Arrays", ["equals", "deepEquals"]) and
      ma.getAnArgument() = this.asExpr()
      or
      m.hasQualifiedName("java.util", "Objects", "deepEquals") and
      ma.getAnArgument() = this.asExpr()
      or
      m.hasQualifiedName("org.apache.commons.lang3", "StringUtils",
        ["equals", "equalsAny", "equalsAnyIgnoreCase", "equalsIgnoreCase"]) and
      ma.getAnArgument() = this.asExpr()
    )
  }
}

/**
 * Holds if `fromNode` to `toNode` is a dataflow step
 * that converts a `ByteBuffer` to a byte array and vice versa.
 */
private predicate convertByteBufferStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    m.hasQualifiedName("java.nio", "ByteBuffer", "array") and
    ma.getQualifier() = fromNode.asExpr() and
    ma = toNode.asExpr()
    or
    m.hasQualifiedName("java.nio", "ByteBuffer", "wrap") and
    ma.getAnArgument() = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
}

/**
 * A configuration that tracks data flow from cryptographic operations
 * to methods that compare data using a non-constant time algorithm.
 */
private class NonConstantTimeCryptoComparisonConfig extends TaintTracking::Configuration {
  NonConstantTimeCryptoComparisonConfig() { this = "NonConstantTimeCryptoComparisonConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof MacSource
    or
    source instanceof SignatureSource
    or
    source instanceof CiphertextSource
  }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof KnownNonConstantTimeComparisonSink
  }

  override predicate isAdditionalTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    convertByteBufferStep(fromNode, toNode)
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, NonConstantTimeCryptoComparisonConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Using a non-constant time algorithm for comparing results of a cryptographic operation."
