/**
 * Provides classes and predicates for reasoning about hard-coded encryption
 * key vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow

/**
 * A dataflow sink for hard-coded encryption key vulnerabilities. That is,
 * a `DataFlow::Node` of something that is used as a key.
 */
abstract class HardcodedEncryptionKeySink extends DataFlow::Node { }

/**
 * A sanitizer for hard-coded encryption key vulnerabilities.
 */
abstract class HardcodedEncryptionKeySanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 */
class HardcodedEncryptionKeyAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for paths related to hard-coded encryption key vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A sink for the CryptoSwift library.
 */
private class CryptoSwiftEncryptionKeySink extends HardcodedEncryptionKeySink {
  CryptoSwiftEncryptionKeySink() {
    // `key` arg in `init` is a sink
    exists(NominalTypeDecl c, ConstructorDecl f, CallExpr call |
      c.getName() = ["AES", "HMAC", "ChaCha20", "CBCMAC", "CMAC", "Poly1305", "Blowfish", "Rabbit"] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel("key").getExpr() = this.asExpr()
    )
  }
}

/**
 * A sink for the RNCryptor library.
 */
private class RnCryptorEncryptionKeySink extends HardcodedEncryptionKeySink {
  RnCryptorEncryptionKeySink() {
    exists(NominalTypeDecl c, MethodDecl f, CallExpr call |
      c.getFullName() =
        [
          "RNCryptor", "RNEncryptor", "RNDecryptor", "RNCryptor.EncryptorV3",
          "RNCryptor.DecryptorV3"
        ] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel(["encryptionKey", "withEncryptionKey"]).getExpr() = this.asExpr()
    )
  }
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultEncryptionKeySink extends HardcodedEncryptionKeySink {
  DefaultEncryptionKeySink() { sinkNode(this, "encryption-key") }
}
