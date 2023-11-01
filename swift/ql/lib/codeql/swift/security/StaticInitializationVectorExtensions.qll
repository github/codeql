/**
 * Provides classes and predicates for reasoning about use of static
 * initialization vectors for encryption.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow

/**
 * A dataflow sink for static initialization vector vulnerabilities. That is,
 * a `DataFlow::Node` that is something used as an initialization vector.
 */
abstract class StaticInitializationVectorSink extends DataFlow::Node { }

/**
 * A barrier for static initialization vector vulnerabilities.
 */
abstract class StaticInitializationVectorBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class StaticInitializationVectorAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to static initialization vector vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * An initialization vector sink for various CryptoSwift encryption classes.
 */
private class CryptoSwiftInitializationVectorSink extends StaticInitializationVectorSink {
  CryptoSwiftInitializationVectorSink() {
    // `iv` arg in `init` is a sink
    exists(InitializerCallExpr call |
      call.getStaticTarget()
          .hasQualifiedName([
              "AES", "ChaCha20", "Blowfish", "Rabbit", "CBC", "CFB", "GCM", "OCB", "OFB", "PCBC",
              "CCM", "CTR"
            ], _) and
      call.getArgumentWithLabel("iv").getExpr() = this.asExpr()
    )
  }
}

/**
 * An initialization vector sink for the `RNCryptor` library.
 */
private class RnCryptorInitializationVectorSink extends StaticInitializationVectorSink {
  RnCryptorInitializationVectorSink() {
    exists(NominalTypeDecl c, Method f, CallExpr call |
      c.getFullName() =
        [
          "RNCryptor", "RNEncryptor", "RNDecryptor", "RNCryptor.EncryptorV3",
          "RNCryptor.DecryptorV3"
        ] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel(["iv", "IV"]).getExpr() = this.asExpr()
    )
  }
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultInitializationVectorSink extends StaticInitializationVectorSink {
  DefaultInitializationVectorSink() { sinkNode(this, "encryption-iv") }
}
