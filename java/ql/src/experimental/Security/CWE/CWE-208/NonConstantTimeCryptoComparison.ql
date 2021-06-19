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
import semmle.code.java.dataflow.TaintTracking2
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

private class UserInputInCryptoOperationConfig extends TaintTracking2::Configuration {
  UserInputInCryptoOperationConfig() { this = "UserInputInCryptoOperationConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      (
        (
          m.hasQualifiedName("javax.crypto", ["Mac", "Cipher"], "doFinal") or
          m.hasQualifiedName("java.security", "Signature", "sign")
        ) and
        ma.getQualifier() = sink.asExpr()
      )
    )
  }

  override predicate isAdditionalTaintStep(DataFlow2::Node fromNode, DataFlow2::Node toNode) {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      (
        (
          m.hasQualifiedName("javax.crypto", ["Mac", "Cipher"], ["doFinal", "update"]) or
          m.hasQualifiedName("java.security", "Signature", ["sign", "update"])
        ) and
        ma.getAnArgument() = fromNode.asExpr() and
        ma.getQualifier() = toNode.asExpr()
      )
    )
  }
}

abstract private class CryptoOperationSource extends DataFlow::Node {
  Expr cryptoOperation;

  predicate includesUserInput() {
    exists(
      DataFlow2::PathNode source, DataFlow2::PathNode sink, UserInputInCryptoOperationConfig config
    |
      config.hasFlowPath(source, sink)
    |
      sink.getNode().asExpr() = cryptoOperation
    )
  }
}

/**
 * A source that produces a MAC.
 */
private class MacSource extends CryptoOperationSource {
  MacSource() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      m.hasQualifiedName("javax.crypto", "Mac", "doFinal") and
      (
        m.getReturnType() instanceof Array and ma = this.asExpr()
        or
        m.getParameterType(0) instanceof Array and ma.getArgument(0) = this.asExpr()
      ) and
      cryptoOperation = ma.getQualifier()
    )
  }
}

/**
 * A source that produces a signature.
 */
private class SignatureSource extends CryptoOperationSource {
  SignatureSource() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      m.hasQualifiedName("java.security", "Signature", "sign") and
      (
        m.getReturnType() instanceof Array and ma = this.asExpr()
        or
        m.getParameterType(0) instanceof Array and ma.getArgument(0) = this.asExpr()
      ) and
      cryptoOperation = ma.getQualifier()
    )
  }
}

/**
 * A source that produces a ciphertext.
 */
private class CiphertextSource extends CryptoOperationSource {
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
      ) and
      cryptoOperation = ma.getQualifier()
    )
  }
}

private class UserInputComparisonConfig extends TaintTracking2::Configuration {
  UserInputComparisonConfig() { this = "UserInputComparisonConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      (
        m.hasQualifiedName("java.lang", "String", ["equals", "contentEquals", "equalsIgnoreCase"]) or
        m.hasQualifiedName("java.nio", "ByteBuffer", ["equals", "compareTo"]) or
        m.hasQualifiedName("java.util", "Arrays", ["equals", "deepEquals"]) or
        m.hasQualifiedName("java.util", "Objects", "deepEquals") or
        m.hasQualifiedName("org.apache.commons.lang3", "StringUtils",
          ["equals", "equalsAny", "equalsAnyIgnoreCase", "equalsIgnoreCase"])
      ) and
      [ma.getAnArgument(), ma.getQualifier()] = sink.asExpr()
    )
  }
}

/**
 * A sink that compares input using a non-constant time algorithm.
 */
private class KnownNonConstantTimeComparisonSink extends DataFlow::Node {
  Expr anotherParameter;

  KnownNonConstantTimeComparisonSink() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      (
        m.hasQualifiedName("java.lang", "String", ["equals", "contentEquals", "equalsIgnoreCase"]) or
        m.hasQualifiedName("java.nio", "ByteBuffer", ["equals", "compareTo"])
      ) and
      (
        this.asExpr() = ma.getQualifier() and
        anotherParameter = ma.getAnArgument() and
        not ma.getAnArgument().isCompileTimeConstant()
        or
        this.asExpr() = ma.getAnArgument() and
        anotherParameter = ma.getQualifier() and
        not ma.getQualifier().isCompileTimeConstant()
      )
    )
    or
    exists(StaticMethodAccess ma, Method m | m = ma.getMethod() |
      (
        m.hasQualifiedName("java.util", "Arrays", ["equals", "deepEquals"]) or
        m.hasQualifiedName("java.util", "Objects", "deepEquals") or
        m.hasQualifiedName("org.apache.commons.lang3", "StringUtils",
          ["equals", "equalsAny", "equalsAnyIgnoreCase", "equalsIgnoreCase"])
      ) and
      ma.getAnArgument() = this.asExpr() and
      (
        this.asExpr() = ma.getArgument(0) and anotherParameter = ma.getArgument(1)
        or
        this.asExpr() = ma.getArgument(1) and anotherParameter = ma.getArgument(0)
      )
    )
  }

  predicate includesUserInput() {
    exists(UserInputComparisonConfig config |
      config.hasFlowTo(DataFlow2::exprNode(anotherParameter))
    )
  }
}

/**
 * A configuration that tracks data flow from cryptographic operations
 * to methods that compare data using a non-constant time algorithm.
 */
private class NonConstantTimeCryptoComparisonConfig extends TaintTracking::Configuration {
  NonConstantTimeCryptoComparisonConfig() { this = "NonConstantTimeCryptoComparisonConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof CryptoOperationSource }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof KnownNonConstantTimeComparisonSink
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, NonConstantTimeCryptoComparisonConfig conf
where
  conf.hasFlowPath(source, sink) and
  (
    source.getNode().(CryptoOperationSource).includesUserInput() or
    sink.getNode().(KnownNonConstantTimeComparisonSink).includesUserInput()
  )
select sink.getNode(), source, sink,
  "Using a non-constant time algorithm for comparing results of a cryptographic operation."
