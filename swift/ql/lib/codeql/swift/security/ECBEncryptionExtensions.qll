/**
 * Provides classes and predicates for reasoning about encryption using the
 * ECB encryption mode.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow

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
