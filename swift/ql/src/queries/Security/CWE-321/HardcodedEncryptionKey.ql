/**
 * @name Hard-coded encryption key
 * @description Using hardcoded keys for encryption is not secure, because potential attackers can easily guess them.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.1
 * @precision high
 * @id swift/hardcoded-key
 * @tags security
 *       external/cwe/cwe-321
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import DataFlow::PathGraph

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
class HardcodedKeyConfig extends TaintTracking::Configuration {
  HardcodedKeyConfig() { this = "HardcodedKeyConfig" }

  override predicate isSource(DataFlow::Node node) { node.asExpr() instanceof KeySource }

  override predicate isSink(DataFlow::Node node) { node.asExpr() instanceof EncryptionKeySink }
}

// The query itself
from HardcodedKeyConfig config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode
where config.hasFlowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "The key '" + sinkNode.getNode().toString() +
    "' has been initialized with hard-coded values from $@.", sourceNode,
  sourceNode.getNode().toString()
