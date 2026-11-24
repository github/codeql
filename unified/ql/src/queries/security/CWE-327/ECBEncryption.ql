/**
 * @name Encryption using ECB
 * @description Using the ECB encryption mode makes code vulnerable to replay attacks.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id swift/ecb-encryption
 * @tags security
 *       external/cwe/cwe-327
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.ExternalFlow
import EcbEncryptionFlow::PathGraph

// Copied from swift/ql/lib/codeql/swift/security/ECBEncryptionQuery.qll.
/**
 * Provides a taint tracking configuration to find encryption using the
 * ECB encryption mode.
 */

/**
 * A data flow configuration from a creation of an ECB mode instance to expressions that use
 * it to initialize a cipher.
 */
module EcbEncryptionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof EcbEncryptionSource }

  predicate isSink(DataFlow::Node node) { node instanceof EcbEncryptionSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof EcbEncryptionBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(EcbEncryptionAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module EcbEncryptionFlow = DataFlow::Global<EcbEncryptionConfig>;

// Copied from swift/ql/lib/codeql/swift/security/ECBEncryptionExtensions.qll.
/**
 * Provides classes and predicates for reasoning about encryption using the
 * ECB encryption mode.
 */

/**
 * A dataflow source for ECB encryption vulnerabilities. That is,
 * a `DataFlow::Node` of something that specifies a block mode
 * cipher.
 */
abstract class EcbEncryptionSource extends DataFlow::Node { }

/**
 * A dataflow sink for ECB encryption vulnerabilities. That is,
 * a `DataFlow::Node` of something that is used as the block mode
 * of a cipher.
 */
abstract class EcbEncryptionSink extends DataFlow::Node { }

/**
 * A barrier for ECB encryption vulnerabilities.
 */
abstract class EcbEncryptionBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class EcbEncryptionAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to ECB encryption vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A block mode for the CryptoSwift library.
 */
private class CryptoSwiftEcb extends EcbEncryptionSource {
  CryptoSwiftEcb() {
    exists(CallExpr call |
      call.getStaticTarget().(Method).hasQualifiedName("ECB", "init()") and
      this.asExpr() = call
    )
  }
}

private class EcbEncryptionSinks extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // CryptoSwift `AES.init` block mode
        ";AES;true;init(key:blockMode:);;;Argument[1];encryption-block-mode",
        ";AES;true;init(key:blockMode:padding:);;;Argument[1];encryption-block-mode",
        // CryptoSwift `Blowfish.init` block mode
        ";Blowfish;true;init(key:blockMode:padding:);;;Argument[1];encryption-block-mode",
      ]
  }
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultEcbEncryptionSink extends EcbEncryptionSink {
  DefaultEcbEncryptionSink() { sinkNode(this, "encryption-block-mode") }
}

from EcbEncryptionFlow::PathNode sourceNode, EcbEncryptionFlow::PathNode sinkNode
where EcbEncryptionFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "The initialization of the cipher '" + sinkNode.getNode().toString() +
    "' uses the insecure ECB block mode from $@.", sourceNode, sourceNode.getNode().toString()
