/**
 * Provides a taint tracking configuration to find use of static
 * initialization vectors for encryption.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.StaticInitializationVectorExtensions

/**
 * A static IV is created through either a byte array or string literals.
 */
class StaticInitializationVectorSource extends Expr {
  StaticInitializationVectorSource() {
    this instanceof ArrayExpr or
    this instanceof StringLiteralExpr or
    this instanceof NumberLiteralExpr
  }
}

/**
 * A class for all ways to set an IV.
 */
class EncryptionInitializationSink extends Expr {
  EncryptionInitializationSink() {
    // `iv` arg in `init` is a sink
    exists(InitializerCallExpr call |
      call.getStaticTarget()
          .hasQualifiedName([
              "AES", "ChaCha20", "Blowfish", "Rabbit", "CBC", "CFB", "GCM", "OCB", "OFB", "PCBC",
              "CCM", "CTR"
            ], _) and
      call.getArgumentWithLabel("iv").getExpr() = this
    )
    or
    // RNCryptor
    exists(ClassOrStructDecl c, MethodDecl f, CallExpr call |
      c.getFullName() = ["RNCryptor", "RNEncryptor", "RNDecryptor"] and
      c.getAMember() = f and
      call.getStaticTarget() = f and
      call.getArgumentWithLabel(["iv", "IV"]).getExpr() = this
    )
  }
}

/**
 * A dataflow configuration from the source of a static IV to expressions that use
 * it to initialize a cipher.
 */
module StaticInitializationVectorConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node.asExpr() instanceof StaticInitializationVectorSource
  }

  predicate isSink(DataFlow::Node node) { node.asExpr() instanceof EncryptionInitializationSink }
}

module StaticInitializationVectorFlow = TaintTracking::Global<StaticInitializationVectorConfig>;
