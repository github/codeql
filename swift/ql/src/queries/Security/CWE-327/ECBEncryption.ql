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
import DataFlow::PathGraph

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
class EcbEncryptionConfig extends DataFlow::Configuration {
  EcbEncryptionConfig() { this = "EcbEncryptionConfig" }

  override predicate isSource(DataFlow::Node node) {
    exists(CallExpr call |
      call.getStaticTarget().(MethodDecl).hasQualifiedName("ECB", "init()") and
      node.asExpr() = call
    )
  }

  override predicate isSink(DataFlow::Node node) { node.asExpr() instanceof BlockMode }
}

// The query itself
from EcbEncryptionConfig config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode
where config.hasFlowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "The initialization of the cipher '" + sinkNode.getNode().toString() +
    "' uses the insecure ECB block mode from $@.", sourceNode, sourceNode.getNode().toString()
