/**
 * Provides a taint tracking configuration to find hard-coded encryption
 * key vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.HardcodedEncryptionKeyExtensions

/**
 * An `Expr` that is used to initialize a key.
 */
abstract class KeySource extends Expr { }

/**
 * A literal byte array is a key source.
 */
class ByteArrayLiteralSource extends KeySource {
  ByteArrayLiteralSource() { this = any(ArrayExpr arr | arr.getType().getName() = "Array<UInt8>") }
}

/**
 * A string literal is a key source.
 */
class StringLiteralSource extends KeySource instanceof StringLiteralExpr { }

/**
 * A class for all ways to set a key.
 */
class EncryptionKeySink extends Expr {
  EncryptionKeySink() {
    // `key` arg in `init` is a sink
    exists(CallExpr call, string fName |
      call.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName([
              "AES", "HMAC", "ChaCha20", "CBCMAC", "CMAC", "Poly1305", "Blowfish", "Rabbit"
            ], fName) and
      fName.matches("init(key:%") and
      call.getArgument(0).getExpr() = this
    )
    or
    // RNCryptor
    exists(ClassOrStructDecl c, MethodDecl f, CallExpr call |
      c.getFullName() = ["RNCryptor", "RNEncryptor", "RNDecryptor"] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel(["encryptionKey", "withEncryptionKey"]).getExpr() = this
    )
  }
}

/**
 * A taint configuration from the key source to expressions that use
 * it to initialize a cipher.
 */
module HardcodedKeyConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof KeySource }

  predicate isSink(DataFlow::Node node) { node.asExpr() instanceof EncryptionKeySink }
}

module HardcodedKeyFlow = TaintTracking::Global<HardcodedKeyConfig>;
