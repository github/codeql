/**
 * Provides a taint tracking configuration to find encryption using the
 * ECB encrpytion mode.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.ECBEncryptionExtensions

/**
 * An `Expr` that is used to initialize the block mode of a cipher.
 */
abstract class BlockMode extends Expr { }

/**
 * An `Expr` that is used to form an `AES` cipher.
 */
class AES extends BlockMode {
  AES() {
    // `blockMode` arg in `AES.init` is a sink
    exists(CallExpr call |
      call.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("AES", ["init(key:blockMode:)", "init(key:blockMode:padding:)"]) and
      call.getArgument(1).getExpr() = this
    )
  }
}

/**
 * An `Expr` that is used to form a `Blowfish` cipher.
 */
class Blowfish extends BlockMode {
  Blowfish() {
    // `blockMode` arg in `Blowfish.init` is a sink
    exists(CallExpr call |
      call.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("Blowfish", "init(key:blockMode:padding:)") and
      call.getArgument(1).getExpr() = this
    )
  }
}

/**
 * A taint configuration from the constructor of ECB mode to expressions that use
 * it to initialize a cipher.
 */
module EcbEncryptionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    exists(CallExpr call |
      call.getStaticTarget().(MethodDecl).hasQualifiedName("ECB", "init()") and
      node.asExpr() = call
    )
  }

  predicate isSink(DataFlow::Node node) { node.asExpr() instanceof BlockMode }
}

module EcbEncryptionFlow = DataFlow::Global<EcbEncryptionConfig>;
