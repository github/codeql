/**
 * Provides classes and predicates for reasoning about encryption using the
 * ECB encryption mode.
 */

import swift
import codeql.swift.dataflow.DataFlow

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
 * A sanitizer for ECB encryption vulnerabilities.
 */
abstract class EcbEncryptionSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 */
class EcbEncryptionAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
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
      call.getStaticTarget().(MethodDecl).hasQualifiedName("ECB", "init()") and
      this.asExpr() = call
    )
  }
}

/**
 * A block mode being used to form a CryptoSwift `AES` cipher.
 */
private class AES extends EcbEncryptionSink {
  AES() {
    // `blockMode` arg in `AES.init` is a sink
    exists(CallExpr call |
      call.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("AES", ["init(key:blockMode:)", "init(key:blockMode:padding:)"]) and
      call.getArgument(1).getExpr() = this.asExpr()
    )
  }
}

/**
 * A block mode being used to form a CryptoSwift `Blowfish` cipher.
 */
private class Blowfish extends EcbEncryptionSink {
  Blowfish() {
    // `blockMode` arg in `Blowfish.init` is a sink
    exists(CallExpr call |
      call.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("Blowfish", "init(key:blockMode:padding:)") and
      call.getArgument(1).getExpr() = this.asExpr()
    )
  }
}
